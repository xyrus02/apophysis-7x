{
     Flame screensaver Copyright (C) 2002 Ronald Hordijk
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Borys, Peter Sdobnov     

     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation; either version 2 of the License, or
     (at your option) any later version.

     This program is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.

     You should have received a copy of the GNU General Public License
     along with this program; if not, write to the Free Software
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}
unit Render64;

interface

uses
  Windows, Forms, Graphics, ImageMaker,
  Render, xform, Controlpoint;

type
  TRenderer64 = class(TBaseRenderer)

  protected
    camX0, camX1, camY0, camY1, // camera bounds
    camW, camH,                 // camera sizes
    bws, bhs, cosa, sina, rcX, rcY: double;
    ppux, ppuy: extended;

    BucketWidth, BucketHeight: int64;
    BucketSize: int64;

    sample_density: extended;
    oversample: integer;
    gutter_width: Integer;
    max_gutter_width: Integer;

    Buckets: TBucketArray;
    ColorMap: TColorMapArray;

    FImageMaker: TImageMaker;

    procedure InitValues;
    procedure InitBuffers;

    procedure ClearBuffers;
    procedure ClearBuckets;
    procedure CreateColorMap;
    procedure CreateCamera;

    procedure SetPixels;

  protected
    PropTable: array[0..SUB_BATCH_SIZE] of TXform;
    finalXform: TXform;
    UseFinalXform: boolean;

    procedure Prepare;
    procedure IterateBatch;
    procedure IterateBatchAngle;
    procedure IterateBatchFX;
    procedure IterateBatchAngleFX;

  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Render; override;

    function  GetImage: TBitmap; override;
    procedure UpdateImage(CP: TControlPoint); override;
    procedure SaveImage(const FileName: String); override;
  end;

implementation

{$define _ASM_}

uses
  Math, Sysutils;

{ TRenderer64 }

///////////////////////////////////////////////////////////////////////////////
constructor TRenderer64.Create;
begin
  inherited Create;

  FImageMaker  := TImageMaker.Create;
end;

///////////////////////////////////////////////////////////////////////////////
destructor TRenderer64.Destroy;
begin
  FImageMaker.Free;

  inherited;
end;


///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64.ClearBuckets;
var
  i: integer;
begin
  for i := 0 to BucketSize - 1 do begin
    buckets[i].Red   := 0;
    buckets[i].Green := 0;
    buckets[i].Blue  := 0;
    buckets[i].Count := 0;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64.ClearBuffers;
begin
  ClearBuckets;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64.CreateCamera;
var
  scale: double;
  t0, t1: double;
  t2, t3: double;
  corner_x, corner_y, Xsize, Ysize: double;
  shift: Integer;
begin
  scale := power(2, fcp.zoom);
  sample_density := fcp.sample_density * scale * scale;
  ppux := fcp.pixels_per_unit * scale;
  ppuy := fcp.pixels_per_unit * scale;
  // todo field stuff
  shift := 0;

  t0 := (gutter_width) / (oversample * ppux);
  t1 := (gutter_width) / (oversample * ppuy);
  t2 := (2 * max_gutter_width - gutter_width) / (oversample * ppux);
  t3 := (2 * max_gutter_width - gutter_width) / (oversample * ppuy);
  corner_x := fcp.center[0] - fcp.Width / ppux / 2.0;
  corner_y := fcp.center[1] - fcp.Height / ppuy / 2.0;
  camX0 := corner_x - t0;
  camY0 := corner_y - t1 + shift;
  camX1 := corner_x + fcp.Width / ppux + t2;
  camY1 := corner_y + fcp.Height / ppuy + t3; //+ shift;
  camW := camX1 - camX0;
  if abs(camW) > 0.01 then
    Xsize := 1.0 / camW
  else
    Xsize := 1;
  camH := camY1 - camY0;
  if abs(camH) > 0.01 then
    Ysize := 1.0 / camH
  else
    Ysize := 1;
  bws := (BucketWidth - 0.5)  * Xsize;
  bhs := (BucketHeight - 0.5) * Ysize;

  if FCP.FAngle <> 0 then
  begin
    cosa := cos(FCP.FAngle);
    sina := sin(FCP.FAngle);
    rcX := FCP.Center[0]*(1 - cosa) - FCP.Center[1]*sina - camX0;
    rcY := FCP.Center[1]*(1 - cosa) + FCP.Center[0]*sina - camY0;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64.CreateColorMap;
var
  i: integer;
begin
{$IFDEF TESTVARIANT}
  for i := 0 to 255 do begin
    ColorMap[i].Red   := i;
    ColorMap[i].Green := i;
    ColorMap[i].Blue  := i;
//    cmap[i][3] := fcp.white_level;
  end;
{$ELSE}
  for i := 0 to 255 do begin
    ColorMap[i].Red   := (fcp.CMap[i][0] * fcp.white_level) div 256;
    ColorMap[i].Green := (fcp.CMap[i][1] * fcp.white_level) div 256;
    ColorMap[i].Blue  := (fcp.CMap[i][2] * fcp.white_level) div 256;
//    cmap[i][3] := fcp.white_level;
  end;
{$ENDIF}
end;

///////////////////////////////////////////////////////////////////////////////
function TRenderer64.GetImage: TBitmap;
begin
  Result := FImageMaker.GetImage;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64.InitBuffers;
const
  MaxFilterWidth = 25;
begin
  oversample := fcp.spatial_oversample;
  max_gutter_width := (MaxFilterWidth - oversample) div 2;
  gutter_width := (FImageMaker.GetFilterSize - oversample) div 2;
  BucketHeight := oversample * fcp.Height + 2 * max_gutter_width;
  Bucketwidth := oversample * fcp.Width + 2 * max_gutter_width;
  BucketSize := BucketWidth * BucketHeight;

  if high(buckets) <> (BucketSize - 1) then
  try
    SetLength(buckets, BucketSize);
  except
    on EOutOfMemory do begin
      Application.MessageBox('Error: not enough memory for this render!', 'Apophysis', 48);
      FStop := true;
    end;
  end;

  // share the buffer with imagemaker
  FImageMaker.SetBucketData(Buckets, BucketWidth);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64.InitValues;
begin
  InitBuffers;
  CreateCamera;

  CreateColorMap;

  fcp.Prepare;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64.SetPixels;
var
  i: integer;
  nsamples: Int64;
  nrbatches: Integer;
  IterateBatchProc: procedure of object;
begin
  Prepare;
  Randomize;

  if FCP.FAngle = 0 then begin
    if UseFinalXform then
      IterateBatchProc := IterateBatchFX
    else
      IterateBatchProc := IterateBatch;
  end
  else begin
    if UseFinalXform then
      IterateBatchProc := IterateBatchAngleFX
    else
      IterateBatchProc := IterateBatchAngle;
  end;

  nsamples := Round(sample_density * bucketSize / (oversample * oversample));
  nrbatches := Round(nsamples / (fcp.nbatches * SUB_BATCH_SIZE));

  for i := 0 to nrbatches do begin
    if FStop then
      Exit;

    if ((i and $1F) = 0) then
      if nrbatches > 0 then
        Progress(i / nrbatches)
      else
        Progress(0);

    IterateBatchProc;
  end;

  Progress(1);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64.Render;
begin
  if fcp.NumXForms <= 0 then exit;

  FStop := False;

  FImageMaker.SetCP(FCP);
  FImageMaker.Init;

  InitValues;

  ClearBuffers;
  SetPixels;

  if not FStop then begin
    FImageMaker.OnProgress := OnProgress;
    FImageMaker.CreateImage;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64.UpdateImage(CP: TControlPoint);
begin
  FCP.background := cp.background;
  FCP.spatial_filter_radius := cp.spatial_filter_radius;
  FCP.gamma := cp.Gamma;
  FCP.vibrancy := cp.vibrancy;
  FCP.contrast := cp.contrast;
  FCP.brightness := cp.brightness;

  FImageMaker.SetCP(FCP);
  FImageMaker.Init;

  FImageMaker.OnProgress := OnProgress;
  FImageMaker.CreateImage;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64.SaveImage(const FileName: String);
begin
  FImageMaker.SaveImage(FileName);
end;

//******************************************************************************

procedure TRenderer64.Prepare;
var
  i, n: Integer;
  propsum: double;
  LoopValue: double;
  j: integer;
  TotValue: double;
begin
  totValue := 0;
  n := fcp.NumXforms;
  assert(n > 0);

  finalXform := fcp.xform[n];
  finalXform.Prepare;
  useFinalXform := fcp.FinalXformEnabled and fcp.HasFinalXform;

  for i := 0 to n - 1 do begin
    fcp.xform[i].Prepare;
    totValue := totValue + fcp.xform[i].density;
  end;

  LoopValue := 0;
  for i := 0 to PROP_TABLE_SIZE-1 do begin
    propsum := 0;
    j := -1;
    repeat
      inc(j);
      propsum := propsum + fcp.xform[j].density;
    until (propsum > LoopValue) or (j = n - 1);
    PropTable[i] := fcp.xform[j];
    LoopValue := LoopValue + TotValue / PROP_TABLE_SIZE;
  end;
end;

procedure TRenderer64.IterateBatch;
var
  i: integer;
  px, py: double;
  Bucket: PBucket;
  MapColor: PColorMapColor;

  p: TCPPoint;
begin
{$ifndef _ASM_}
  p.x := 2 * random - 1;
  p.y := 2 * random - 1;
  p.c := random;
{$else}
asm
    fld1
    call    System.@RandExt
    fadd    st, st
    fsub    st, st(1)
    fstp    qword ptr [p.x]
    call    System.@RandExt
    fadd    st, st
    fsubrp  st(1), st
    fstp    qword ptr [p.y]
    call    System.@RandExt
    fstp    qword ptr [p.c]
end;
{$endif}

  try
    for i := 0 to FUSE do
      PropTable[Random(PROP_TABLE_SIZE)].NextPoint(p);

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      PropTable[Random(PROP_TABLE_SIZE)].NextPoint(p);

      px := p.x - camX0;
      if (px < 0) or (px > camW) then continue;
      py := p.y - camY0;
      if (py < 0) or (py > camH) then continue;

      Bucket := @buckets[Round(bws * px) + Round(bhs * py) * BucketWidth];
      MapColor := @ColorMap[Round(p.c * 255)];

      Inc(Bucket.Red,   MapColor.Red);
      Inc(Bucket.Green, MapColor.Green);
      Inc(Bucket.Blue,  MapColor.Blue);
      Inc(Bucket.Count);
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;

procedure TRenderer64.IterateBatchAngle;
var
  i: integer;
  px, py: double;
  Bucket: PBucket;
  MapColor: PColorMapColor;

  p: TCPPoint;
begin
{$ifndef _ASM_}
  p.x := 2 * random - 1;
  p.y := 2 * random - 1;
  p.c := random;
{$else}
asm
    fld1
    call    System.@RandExt
    fadd    st, st
    fsub    st, st(1)
    fstp    qword ptr [p.x]
    call    System.@RandExt
    fadd    st, st
    fsubrp  st(1), st
    fstp    qword ptr [p.y]
    call    System.@RandExt
    fstp    qword ptr [p.c]
end;
{$endif}

  try
    for i := 0 to FUSE do
      PropTable[Random(PROP_TABLE_SIZE)].NextPoint(p);

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      PropTable[Random(PROP_TABLE_SIZE)].NextPoint(p);

      px := p.x * cosa + p.y * sina + rcX;
      if (px < 0) or (px > camW) then continue;
      py := p.y * cosa - p.x * sina + rcY;
      if (py < 0) or (py > camH) then continue;

      Bucket := @buckets[Round(bws * px) + Round(bhs * py) * BucketWidth];
      MapColor := @ColorMap[Round(p.c * 255)];

      Inc(Bucket.Red,   MapColor.Red);
      Inc(Bucket.Green, MapColor.Green);
      Inc(Bucket.Blue,  MapColor.Blue);
      Inc(Bucket.Count);
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;


procedure TRenderer64.IterateBatchFX;
var
  i: integer;
  px, py: double;
  Bucket: PBucket;
  MapColor: PColorMapColor;

  p, q: TCPPoint;
begin
{$ifndef _ASM_}
  p.x := 2 * random - 1;
  p.y := 2 * random - 1;
  p.c := random;
{$else}
asm
    fld1
    call    System.@RandExt
    fadd    st, st
    fsub    st, st(1)
    fstp    qword ptr [p.x]
    call    System.@RandExt
    fadd    st, st
    fsubrp  st(1), st
    fstp    qword ptr [p.y]
    call    System.@RandExt
    fstp    qword ptr [p.c]
end;
{$endif}

  try
    for i := 0 to FUSE do
      PropTable[Random(PROP_TABLE_SIZE)].NextPoint(p);

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      PropTable[Random(PROP_TABLE_SIZE)].NextPoint(p);
      finalXform.NextPointTo(p, q);

      px := q.x - camX0;
      if (px < 0) or (px > camW) then continue;
      py := q.y - camY0;
      if (py < 0) or (py > camH) then continue;

      Bucket := @buckets[Round(bws * px) + Round(bhs * py) * BucketWidth];
      MapColor := @ColorMap[Round(q.c * 255)];

      Inc(Bucket.Red,   MapColor.Red);
      Inc(Bucket.Green, MapColor.Green);
      Inc(Bucket.Blue,  MapColor.Blue);
      Inc(Bucket.Count);
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;

procedure TRenderer64.IterateBatchAngleFX;
var
  i: integer;
  px, py: double;
  Bucket: PBucket;
  MapColor: PColorMapColor;

  p, q: TCPPoint;
begin
{$ifndef _ASM_}
  p.x := 2 * random - 1;
  p.y := 2 * random - 1;
  p.c := random;
{$else}
asm
    fld1
    call    System.@RandExt
    fadd    st, st
    fsub    st, st(1)
    fstp    qword ptr [p.x]
    call    System.@RandExt
    fadd    st, st
    fsubrp  st(1), st
    fstp    qword ptr [p.y]
    call    System.@RandExt
    fstp    qword ptr [p.c]
end;
{$endif}

  try
    for i := 0 to FUSE do
      PropTable[Random(PROP_TABLE_SIZE)].NextPoint(p);

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      PropTable[Random(PROP_TABLE_SIZE)].NextPoint(p);
      finalXform.NextPointTo(p, q);

      px := q.x * cosa + q.y * sina + rcX;
      if (px < 0) or (px > camW) then continue;
      py := q.y * cosa - q.x * sina + rcY;
      if (py < 0) or (py > camH) then continue;

      Bucket := @buckets[Round(bws * px) + Round(bhs * py) * BucketWidth];
      MapColor := @ColorMap[Round(q.c * 255)];

      Inc(Bucket.Red,   MapColor.Red);
      Inc(Bucket.Green, MapColor.Green);
      Inc(Bucket.Blue,  MapColor.Blue);
      Inc(Bucket.Count);
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;

end.

