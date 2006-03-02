{
     Flame screensaver Copyright (C) 2002 Ronald Hordijk
     Apophysis Copyright (C) 2001-2004 Mark Townsend

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
  Windows, Graphics, ImageMaker,
   Render, xform, Controlpoint;

type
  TRenderer64 = class(TBaseRenderer)
  private
    oversample: integer;

    BucketWidth, BucketHeight: integer;
    BucketSize: integer;

    gutter_width: Integer;
    max_gutter_width: Integer;

    sample_density: extended;

    Buckets: TBucketArray;
    ColorMap: TColorMapArray;

    FinalXform: ^TXform;
    UseFinalXform: boolean;

    camX0, camX1, camY0, camY1, // camera bounds
    camW, camH,                 // camera sizes
    bws, bhs, cosa, sina, rcX, rcY: double;
    ppux, ppuy: extended;
    FImageMaker: TImageMaker;

    procedure InitValues;
    procedure InitBuffers;

    procedure ClearBuffers;
    procedure ClearBuckets;
    procedure CreateColorMap;
    procedure CreateCamera;

    procedure AddPointsToBuckets(const points: TPointsArray);
    procedure AddPointsToBucketsAngle(const points: TPointsArray);
    procedure AddPointsWithFX(const points: TPointsArray);
    procedure AddPointsWithAngleFX(const points: TPointsArray);

    procedure SetPixels;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Render; override;

    function  GetImage: TBitmap; override;
    procedure UpdateImage(CP: TControlPoint); override;
    procedure SaveImage(const FileName: String); override;
  end;

implementation

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

  if high(buckets) <> (BucketSize - 1) then begin
    SetLength(buckets, BucketSize);
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

  FinalXForm := @fcp.xform[fcp.NumXForms];
  UseFinalXForm := fcp.finalXformEnabled and fcp.HasFinalXform;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64.AddPointsToBuckets(const points: TPointsArray);
var
  i: integer;
  px, py: double;
  Bucket: PBucket;
  MapColor: PColorMapColor;
begin
  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
//    if FStop then Exit;

    px := points[i].x - camX0;
    if (px < 0) or (px > camW) then continue;
    py := points[i].y - camY0;
    if (py < 0) or (py > camH) then continue;

    Bucket := @buckets[Round(bws * px) + Round(bhs * py) * BucketWidth];
    MapColor := @ColorMap[Round(points[i].c * 255)];

    Inc(Bucket.Red,   MapColor.Red);
    Inc(Bucket.Green, MapColor.Green);
    Inc(Bucket.Blue,  MapColor.Blue);
    Inc(Bucket.Count);
  end;
end;

procedure TRenderer64.AddPointsWithFX(const points: TPointsArray);
const
  const255: single = 255;
var
  i: integer;
  px, py: double;
  Bucket: PBucket;
  MapColor: PColorMapColor;
begin
 try
  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
//    if FStop then Exit;

    FinalXform.NextPoint(points[i]);

{$if true}
    px := points[i].x - camX0;
    if (px < 0) or (px > camW) then continue;
    py := points[i].y - camY0;
    if (py < 0) or (py > camH) then continue;

    Bucket := @buckets[Round(bws * px) + Round(bhs * py) * BucketWidth];
    MapColor := @ColorMap[Round(points[i].c * 255)];

    Inc(Bucket.Red,   MapColor.Red);
    Inc(Bucket.Green, MapColor.Green);
    Inc(Bucket.Blue,  MapColor.Blue);
    Inc(Bucket.Count);
{$else}
asm
    mov     eax, [points]
    lea     edx, [eax + edi*8]  // assert: "i" in edi
//    fld     qword ptr [edx + edi*8] // assert: "i" in edi
    fld     qword ptr [edx]
    fsub    qword ptr [bx]
    fldz
    fcomp   st(1), st
    fnstsw  ax
    sahf
    jb      @skip1
    fld     qword ptr [wx]
    fcomp
    fnstsw  ax
    sahf
    jnbe    @skip1

    fld     qword ptr [edx + 8]
    fsub    qword ptr [by]
    fldz
    fcomp
    fnstsw  ax
    sahf
    jb      @skip2
    fld   qword ptr [wy]
    fcomp
    fnstsw  ax
    sahf
    jnbe    @skip2

    fmul    qword ptr [bhs]
    fimul   [BucketWidth]

    fld     qword ptr [edx + 16]
    fmul    dword ptr [const255]
    sub     esp, 4
    fistp   dword ptr [esp]
    pop     eax

@skip2:
    fstp    st
@skip1:
    fstp    st
@continue:
end;
{$ifend}
  end
 except
 end
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64.AddPointsToBucketsAngle(const points: TPointsArray);
var
  i: integer;
  px, py: double;
  Bucket: PBucket;
  MapColor: PColorMapColor;
begin
  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
//    if FStop then Exit;

    px := points[i].x * cosa + points[i].y * sina + rcX;
    if (px < 0) or (px > camW) then continue;
    py := points[i].y * cosa - points[i].x * sina + rcY;
    if (py < 0) or (py > camH) then continue;

    Bucket := @buckets[Round(bws * px) + Round(bhs * py) * BucketWidth];
    MapColor := @ColorMap[Round(points[i].c * 255)];

    Inc(Bucket.Red,   MapColor.Red);
    Inc(Bucket.Green, MapColor.Green);
    Inc(Bucket.Blue,  MapColor.Blue);
    Inc(Bucket.Count);
  end;
end;

procedure TRenderer64.AddPointsWithAngleFX(const points: TPointsArray);
var
  i: integer;
  px, py: double;
  Bucket: PBucket;
  MapColor: PColorMapColor;
begin
 try
  for i := SUB_BATCH_SIZE - 1 downto 0 do
  begin
//    if FStop then Exit;
    FinalXform.NextPoint(points[i]);

    px := points[i].x * cosa + points[i].y * sina + rcX;
    if (px < 0) or (px > camW) then continue;
    py := points[i].y * cosa - points[i].x * sina + rcY;
    if (py < 0) or (py > camH) then continue;

    Bucket := @buckets[Round(bws * px) + Round(bhs * py) * BucketWidth];
    MapColor := @ColorMap[Round(points[i].c * 255)];

    Inc(Bucket.Red,   MapColor.Red);
    Inc(Bucket.Green, MapColor.Green);
    Inc(Bucket.Blue,  MapColor.Blue);
    Inc(Bucket.Count);
  end;
 except
 end
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64.SetPixels;
var
  i: integer;
  nsamples: Int64;
  nrbatches: Integer;
  points: TPointsArray;
  AddPointsProc: procedure (const points: TPointsArray) of object;
begin
//  if FileExists('c:\temp\flame.txt') then
//    Deletefile('c:\temp\flame.txt');

//  AssignFile(F, 'c:\temp\flame.txt');
//  Rewrite(F);
  if FCP.FAngle = 0 then begin
    if UseFinalXForm then
      AddPointsProc := AddPointsWithFX
    else
      AddPointsProc := AddPointsToBuckets;
  end
  else begin
    if UseFinalXForm then
      AddPointsProc := AddPointsWithAngleFX
    else
      AddPointsProc := AddPointsToBucketsAngle;
  end;

  SetLength(Points, SUB_BATCH_SIZE);

  nsamples := Round(sample_density * bucketSize / (oversample * oversample));
  nrbatches := Round(nsamples / (fcp.nbatches * SUB_BATCH_SIZE));
  Randomize;

  for i := 0 to nrbatches do begin
    if FStop then
      Exit;

    if ((i and $F) = 0) then
      if nrbatches > 0 then
        Progress(i / nrbatches)
      else
        Progress(0);

    // generate points
{$IFDEF TESTVARIANT}
//    if i > 10 then
//      break;
    fcp.Testiterate(SUB_BATCH_SIZE, points);
{$ELSE}
{
    case Compatibility of
      0: fcp.iterate_Old(SUB_BATCH_SIZE, points);
      1: fcp.iterateXYC(SUB_BATCH_SIZE, points);
    end;
}
    fcp.IterateXYC(SUB_BATCH_SIZE, points);
{$ENDIF}

//    for j := SUB_BATCH_SIZE - 1 downto 0 do
//      Writeln(f,  FloatTostr(points[j].x) + #9 + FloatTostr(points[j].y) + #9 + FloatTostr(points[j].c));

    AddPointsProc(points);
  end;

//  closefile(f);

  Progress(1);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64.Render;
begin
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

///////////////////////////////////////////////////////////////////////////////
end.

