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
unit Render64MT;

interface

uses
  Windows, Classes, Graphics,
   Render, Controlpoint, ImageMaker;

type
  TPixelRenderThread = class(TThread)
  private
    fcp: TControlPoint;
    points: TPointsArray;
  public
    nrbatches: integer;
    batchcounter: Pinteger;

    BucketWidth: Int64;
    BucketHeight: Int64;
    bounds: array[0..3] of extended;
    size: array[0..1] of extended;
    Buckets: PBucketArray;
    ColorMap: TColorMapArray;
    CriticalSection: TRTLCriticalSection;

    constructor Create(cp: TControlPoint);

    procedure Execute; override;

    procedure AddPointsToBuckets(const points: TPointsArray); overload;
    procedure AddPointsToBucketsAngle(const points: TPointsArray); overload;
  end;

type
  TRenderer64MT = class(TBaseRenderer)
  private
    oversample: Int64;
    batchcounter: Integer;
    FNrBatches: Integer;

    BucketWidth: Int64;
    BucketHeight: Int64;
    BucketSize: Int64;
    gutter_width: Integer;
    max_gutter_width: Integer;

    sample_density: extended;

    Buckets: TBucketArray;
    ColorMap: TColorMapArray;

    bounds: array[0..3] of extended;
    size: array[0..1] of extended;
    ppux, ppuy: extended;
    FNrOfTreads: integer;
    WorkingThreads: array of TPixelRenderThread;
    CriticalSection: TRTLCriticalSection;

    FImageMaker: TImageMaker;

    procedure InitValues;
    procedure InitBuffers;

    procedure ClearBuffers;
    procedure ClearBuckets;
    procedure CreateColorMap;
    procedure CreateCamera;

    procedure SetPixelsMT;
    procedure SetNrOfTreads(const Value: integer);

    function NewThread: TPixelRenderThread;
  public
    constructor Create; override;
    destructor Destroy; override;

    function  GetImage: TBitmap; override;

    procedure Stop; override;

    procedure Render; override;

    procedure UpdateImage(CP: TControlPoint); override;
    procedure SaveImage(const FileName: String); override;

    property NrOfTreads: integer
        read FNrOfTreads
       write SetNrOfTreads;
  end;

implementation

uses
  Math, Sysutils;

{ TRenderer64MT }

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64MT.ClearBuckets;
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
procedure TRenderer64MT.ClearBuffers;
begin
  ClearBuckets;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64MT.CreateCamera;
var
  scale: double;
  t0, t1: double;
  t2, t3: double;
  corner0, corner1: double;
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
  corner0 := fcp.center[0] - fcp.Width / ppux / 2.0;
  corner1 := fcp.center[1] - fcp.Height / ppuy / 2.0;
  bounds[0] := corner0 - t0;
  bounds[1] := corner1 - t1 + shift;
  bounds[2] := corner0 + fcp.Width / ppux + t2;
  bounds[3] := corner1 + fcp.Height / ppuy + t3; //+ shift;
  if abs(bounds[2] - bounds[0]) > 0.01 then
    size[0] := 1.0 / (bounds[2] - bounds[0])
  else
    size[0] := 1;
  if abs(bounds[3] - bounds[1]) > 0.01 then
    size[1] := 1.0 / (bounds[3] - bounds[1])
  else
    size[1] := 1;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64MT.CreateColorMap;
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
destructor TRenderer64MT.Destroy;
begin
  FImageMaker.Free;

  inherited;
end;

///////////////////////////////////////////////////////////////////////////////
function TRenderer64MT.GetImage: TBitmap;
begin
  Result := FImageMaker.GetImage;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64MT.InitBuffers;
const
  MaxFilterWidth = 25;
begin
  oversample := fcp.spatial_oversample;
  max_gutter_width := (MaxFilterWidth - oversample) div 2;
  gutter_width := (FImageMaker.GetFilterSize - oversample) div 2;
  BucketHeight := oversample * fcp.Height + 2 * max_gutter_width;
  Bucketwidth := oversample * fcp.width + 2 * max_gutter_width;
  BucketSize := BucketWidth * BucketHeight;

  if high(buckets) <> (BucketSize - 1) then begin
    SetLength(buckets, BucketSize);
  end;

  // share the buffer with imagemaker
  FImageMaker.SetBucketData(Buckets, BucketWidth);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64MT.InitValues;
begin
  InitBuffers;
  CreateCamera;

  CreateColorMap;
end;


///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64MT.SetPixelsMT;
var
  i: integer;
  nsamples: Int64;
begin
  nsamples := Round(sample_density * bucketSize / (oversample * oversample));
  FNrBatches := Round(nsamples / (fcp.nbatches * SUB_BATCH_SIZE));
  batchcounter :=  0;
  Randomize;

  InitializeCriticalSection(CriticalSection);

  SetLength(WorkingThreads, NrOfTreads);
  for i := 0 to NrOfTreads - 1 do
    WorkingThreads[i] := NewThread;

  while (Not FStop) and (batchcounter < FNrBatches) do begin
    if batchcounter > 0 then
      Progress(batchcounter / FNrBatches)
    else
      Progress(0);

    sleep(200)
  end;

  DeleteCriticalSection(CriticalSection);
  Progress(1);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64MT.Stop;
var
  i: integer;
begin
  inherited;

  for i := 0 to NrOfTreads - 1 do
    WorkingThreads[i].Terminate;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TRenderer64MT.Create;
begin
  inherited Create;

  FImageMaker := TImageMaker.Create;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64MT.Render;
begin
  FStop := False;

  FImageMaker.SetCP(FCP);
  FImageMaker.Init;
  InitValues;

  ClearBuffers;
  SetPixelsMT;

  if not FStop then begin
    FImageMaker.OnProgress := OnProgress;
    FImageMaker.CreateImage;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64MT.UpdateImage(CP: TControlPoint);
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
procedure TRenderer64MT.SetNrOfTreads(const Value: integer);
begin
  FNrOfTreads := Value;
end;

///////////////////////////////////////////////////////////////////////////////
function TRenderer64MT.NewThread: TPixelRenderThread;
begin
  Result := TPixelRenderThread.Create(fcp);
//  Result.OnTerminate := OnThreadTerminated;
  Result.BucketWidth := BucketWidth;
  Result.BucketHeight := BucketHeight;
  Result.size[0] := size[0];
  Result.size[1] := size[1];
  Result.bounds[0] := Bounds[0];
  Result.bounds[1] := Bounds[1];
  Result.bounds[2] := Bounds[2];
  Result.bounds[3] := Bounds[3];
  Result.ColorMap := colorMap;
  Result.Buckets := @Buckets;
  Result.CriticalSection := CriticalSection;
  Result.Nrbatches := FNrBatches;
  Result.batchcounter := @batchcounter;
  Result.Resume;
end;

{ PixelRenderThread }

///////////////////////////////////////////////////////////////////////////////
procedure TPixelRenderThread.AddPointsToBuckets(const points: TPointsArray);
var
  i: integer;
  px, py: double;
  bws, bhs: double;
  bx, by: double;
  wx, wy: double;
//  R: double;
//  V1, v2, v3: integer;
  Bucket: PBucket;
  MapColor: PColorMapColor;
begin
  bws := (BucketWidth - 0.5)  * size[0];
  bhs := (BucketHeight - 0.5) * size[1];
  bx := bounds[0];
  by := bounds[1];
  wx := bounds[2] - bounds[0];
  wy := bounds[3] - bounds[1];

  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
    px := points[i].x - bx;
    py := points[i].y - by;

    if ((px < 0) or (px > wx) or
        (py < 0) or (py > wy)) then
      continue;

    MapColor := @ColorMap[Round(points[i].c * 255)];
    Bucket := @TbucketArray(buckets^)[Round(bws * px) + Round(bhs * py) * BucketWidth];

    Inc(Bucket.Red,   MapColor.Red);
    Inc(Bucket.Green, MapColor.Green);
    Inc(Bucket.Blue,  MapColor.Blue);
    Inc(Bucket.Count);
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TPixelRenderThread.AddPointsToBucketsAngle(const points: TPointsArray);
var
  i: integer;
  px, py: double;
  ca,sa: double;
  nx, ny: double;
  bws, bhs: double;
  bx, by: double;
  wx, wy: double;
  Bucket: PBucket;
  MapColor: PColorMapColor;
begin

  bws := (BucketWidth - 0.5)  * size[0];
  bhs := (BucketHeight - 0.5) * size[1];
  bx := bounds[0];
  by := bounds[1];
  wx := bounds[2] - bounds[0];
  wy := bounds[3] - bounds[1];

  ca := cos(FCP.FAngle);
  sa := sin(FCP.FAngle);

  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
    px := points[i].x - FCP.Center[0];
    py := points[i].y - FCP.Center[1];

    nx := px * ca + py * sa;
    ny := -px * sa + py * ca;

    px := nx + FCP.Center[0] - bx;
    py := ny + FCP.Center[1] - by;

    if ((px < 0) or (px > wx) or
        (py < 0) or (py > wy)) then
      continue;

    MapColor := @ColorMap[Round(points[i].c * 255)];
    Bucket := @TbucketArray(buckets^)[Round(bws * px) + Round(bhs * py) * BucketWidth];

    Inc(Bucket.Red,   MapColor.Red);
    Inc(Bucket.Green, MapColor.Green);
    Inc(Bucket.Blue,  MapColor.Blue);
    Inc(Bucket.Count);
  end;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TPixelRenderThread.Create(cp: TControlPoint);
begin
  inherited Create(True);
  Self.FreeOnTerminate := True;

  fcp := cp;

  SetLength(Points, SUB_BATCH_SIZE);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TPixelRenderThread.Execute;
begin
  inherited;

//  while true do begin
  while (not Terminated) and (batchcounter^ < Nrbatches) do begin
    fcp.iterateXYC(SUB_BATCH_SIZE, points);
    try
      EnterCriticalSection(CriticalSection);

      if FCP.FAngle = 0 then
        AddPointsToBuckets(Points)
      else
        AddPointsToBucketsAngle(Points);

      Inc(batchcounter^);
    finally
      LeaveCriticalSection(CriticalSection);
    end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64MT.SaveImage(const FileName: String);
begin
  FImageMaker.SaveImage(FileName);
end;

end.

