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
unit RenderMM_MT;

interface

uses
  Windows, Graphics,
   Render, Controlpoint, ImageMaker, BucketFillerThread, XForm;

type
  TRendererMM64_MT = class(TBaseRenderer)
  private
    oversample: Integer;

    image_Width, image_Height: integer; // we're not going to render images
    BucketWidth, BucketHeight: integer; // more then 2^32 pixels wide, are we? :)
    BucketSize: Integer;
    gutter_width: Integer;

    sample_density: extended;

    Buckets: TBucketArray;
    ColorMap: TColorMapArray;

    FinalXform: ^TXform;
    UseFinalXform: boolean;

    camX0, camX1, camY0, camY1, // camera bounds
    camW, camH,                 // camera sizes
    bws, bhs, cosa, sina, rcX, rcY: double;
//    bounds: array[0..3] of extended;
//    size: array[0..1] of extended;
//    FRotationCenter: array[0..1] of extended;

    ppux, ppuy: extended;
    nrSlices: int64;
    Slice: int64;
    FImageMaker: TImageMaker;
    FNrBatches: int64;
    batchcounter: Integer;

    FNrOfTreads: integer;
    WorkingThreads: array of TBucketFillerThread;
    CriticalSection: TRTLCriticalSection;

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
    procedure SetPixelsMT;
    procedure SetNrOfTreads(const Value: integer);

    function NewThread: TBucketFillerThread;
  protected
    function GetSlice: integer; override;
    function GetNrSlices: integer; override;

  public
    constructor Create; override;
    destructor Destroy; override;

    function  GetImage: TBitmap; override;
    procedure SaveImage(const FileName: String); override;

    procedure Render; override;

    property NrOfTreads: integer
        read FNrOfTreads
       write SetNrOfTreads;
  end;

implementation

uses
  Math, Sysutils;

{ TRendererMM64_MT }

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64_MT.ClearBuckets;
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
procedure TRendererMM64_MT.ClearBuffers;
begin
  ClearBuckets;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64_MT.CreateCamera;
var
  scale: double;
  t0, t1: double;
  corner_x, corner_y, Xsize, Ysize: double;
  shift: Integer;
begin
  scale := power(2, fcp.zoom);
  sample_density := fcp.sample_density * scale * scale;
  ppux := fcp.pixels_per_unit * scale;
  ppuy := fcp.pixels_per_unit * scale;
  // todo field stuff
  shift := 0;
  t0 := gutter_width / (oversample * ppux);
  t1 := gutter_width / (oversample * ppuy);
  corner_x := fcp.center[0] - image_width / ppux / 2.0;
  corner_y := fcp.center[1] - image_height / ppuy / 2.0;
{
  bounds[0] := corner0 - t0;
  bounds[1] := corner1 - t1 + shift;
  bounds[2] := corner0 + image_width / ppux + t0;
  bounds[3] := corner1 + image_height / ppuy + t1; //+ shift;
  if abs(bounds[2] - bounds[0]) > 0.01 then
    size[0] := 1.0 / (bounds[2] - bounds[0])
  else
    size[0] := 1;
  if abs(bounds[3] - bounds[1]) > 0.01 then
    size[1] := 1.0 / (bounds[3] - bounds[1])
  else
    size[1] := 1;
}
  camX0 := corner_x - t0;
  camY0 := corner_y - t1 + shift;
  camX1 := corner_x + image_width / ppux + t0;
  camY1 := corner_y + image_height / ppuy + t1; //+ shift;
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
procedure TRendererMM64_MT.CreateColorMap;
var
  i: integer;
begin
  for i := 0 to 255 do begin
    ColorMap[i].Red   := (fcp.CMap[i][0] * fcp.white_level) div 256;
    ColorMap[i].Green := (fcp.CMap[i][1] * fcp.white_level) div 256;
    ColorMap[i].Blue  := (fcp.CMap[i][2] * fcp.white_level) div 256;
//    cmap[i][3] := fcp.white_level;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
destructor TRendererMM64_MT.Destroy;
begin
  FImageMaker.Free;

  inherited;
end;

///////////////////////////////////////////////////////////////////////////////
function TRendererMM64_MT.GetImage: TBitmap;
begin
  Result := FImageMaker.GetImage;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64_MT.InitBuffers;
begin
  oversample := fcp.spatial_oversample;
  gutter_width := (FImageMaker.GetFilterSize - oversample) div 2;
  BucketHeight := oversample * image_height + 2 * gutter_width;
  Bucketwidth := oversample * image_width + 2 * gutter_width;
  BucketSize := BucketWidth * BucketHeight;

  if high(buckets) <> (BucketSize - 1) then begin
    SetLength(buckets, BucketSize);
  end;

  // share the buffer with imagemaker
  FImageMaker.SetBucketData(Buckets, BucketWidth);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64_MT.InitValues;
begin
  image_height := fcp.Height;
  image_Width := fcp.Width;

  CreateCamera;

  InitBuffers;

  CreateColorMap;

  FinalXForm := @fcp.xform[fcp.NumXForms];
  UseFinalXForm := fcp.finalXformEnabled and fcp.HasFinalXform;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64_MT.AddPointsToBuckets(const points: TPointsArray);
var
  i: integer;
  px, py: double;
//  R: double;
//  V1, v2, v3: integer;
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

procedure TRendererMM64_MT.AddPointsWithFX(const points: TPointsArray);
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
 except
 end
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64_MT.AddPointsToBucketsAngle(const points: TPointsArray);
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

procedure TRendererMM64_MT.AddPointsWithAngleFX(const points: TPointsArray);
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
procedure TRendererMM64_MT.SetPixels;
var
  i: integer;
  nsamples: Int64;
  nrbatches: Integer;
  points: TPointsArray;
  AddPointsProc: procedure (const points: TPointsArray) of object;
begin
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

    if (i and $F = 0) then
      if nrbatches > 0 then
        Progress(i / nrbatches)
      else
        Progress(0);

    // generate points
{    case Compatibility of
      0: fcp.iterate_Old(SUB_BATCH_SIZE, points);
      1: fcp.iterateXYC(SUB_BATCH_SIZE, points);
    end;
}
    fcp.IterateXYC(SUB_BATCH_SIZE, points);

    AddPointsProc(points)
  end;

  Progress(1);
end;

///////////////////////////////////////////////////////////////////////////////
constructor TRendererMM64_MT.Create;
begin
  inherited Create;

  FImageMaker  := TImageMaker.Create;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64_MT.Render;
const
  Dividers: array[0..15] of integer = (1, 2, 3, 4, 5, 6, 7, 8, 10, 16, 20, 32, 64, 128, 256, 512);
var
  ApproxMemory, MaxMemory: int64;
  i: integer;
  zoom_scale, center_base, center_y: double;
begin
  FStop := False;

//  FRotationCenter[0] := fcp.center[0];
//  FRotationCenter[1] := fcp.center[1];

  image_height := fcp.Height;
  image_Width := fcp.Width;
  oversample := fcp.spatial_oversample;

  // entered memory - imagesize
  MaxMemory := FMaxMem * 1024 * 1024 - 4 * image_height * image_width;

  ApproxMemory := 32 * oversample * oversample * image_height * image_width;

  if (MaxMemory < 0) then
    Exit;

  nrSlices := 1 + ApproxMemory div MaxMemory;

  if nrSlices > Dividers[High(Dividers)] then begin
    for i := High(Dividers) downto 0 do begin
      if image_height <> (image_height div dividers[i]) * dividers[i] then begin
        nrSlices := dividers[i];
        break;
      end;
    end;
  end else begin
    for i := 0 to High(Dividers) do begin
      if image_height <> (image_height div dividers[i]) * dividers[i] then
        continue;
      if nrslices <= dividers[i] then begin
        nrSlices := dividers[i];
        break;
      end;
    end;
  end;

  FImageMaker.SetCP(FCP);
  FImageMaker.Init;

  fcp.sample_density := fcp.sample_density * nrslices;
  fcp.height := fcp.height div nrslices;
  center_y := fcp.center[1];
  zoom_scale := power(2.0, fcp.zoom);
  center_base := center_y - ((nrslices - 1) * fcp.height) /  (2 * fcp.pixels_per_unit * zoom_scale);

  InitValues;

  for i := 0 to NrSlices - 1 do begin
    if FStop then
      Exit;

    Slice := i;
    fcp.center[1] := center_base + fcp.height * slice / (fcp.pixels_per_unit * zoom_scale);
    CreateCamera;
    ClearBuffers;
    SetPixelsMT;

    if not FStop then begin
      FImageMaker.OnProgress := OnProgress;
      FImageMaker.CreateImage(Slice * fcp.height);
    end;
  end;

  fcp.sample_density := fcp.sample_density / nrslices;
  fcp.height := fcp.height * nrslices;
end;

///////////////////////////////////////////////////////////////////////////////
function TRendererMM64_MT.GetSlice: integer;
begin
  Result := Slice;
end;

///////////////////////////////////////////////////////////////////////////////
function TRendererMM64_MT.GetNrSlices: integer;
begin
  Result := NrSlices;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64_MT.SaveImage(const FileName: String);
begin
  FImageMaker.SaveImage(FileName);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64_MT.SetNrOfTreads(const Value: integer);
begin
  FNrOfTreads := Value;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64_MT.SetPixelsMT;
var
  i: integer;
  nsamples: Int64;
  bc : integer;
begin
  nsamples := Round(sample_density * bucketSize / (oversample * oversample));
  FNrBatches := Round(nsamples / (fcp.nbatches * SUB_BATCH_SIZE));
  batchcounter := 0;
  Randomize;

  InitializeCriticalSection(CriticalSection);

  SetLength(WorkingThreads, NrOfTreads);
  for i := 0 to NrOfTreads - 1 do
    WorkingThreads[i] := NewThread;

  for i := 0 to NrOfTreads - 1 do
    WorkingThreads[i].Resume;

  bc := 0;
  while (Not FStop) and (bc < FNrBatches) do begin
    sleep(200);
    try
      EnterCriticalSection(CriticalSection);
      if batchcounter > 0 then
        Progress(batchcounter / FNrBatches)
      else
        Progress(0);

       bc := batchcounter;
     finally
       LeaveCriticalSection(CriticalSection);
     end;
  end;

  DeleteCriticalSection(CriticalSection);
  Progress(1);
end;

///////////////////////////////////////////////////////////////////////////////
function TRendererMM64_MT.NewThread: TBucketFillerThread;
begin
  Result := TBucketFillerThread.Create(fcp);
  Result.BucketWidth := BucketWidth;
  Result.BucketHeight := BucketHeight;
  Result.Buckets := @Buckets;
{
  Result.size[0] := size[0];
  Result.size[1] := size[1];
  Result.bounds[0] := Bounds[0];
  Result.bounds[1] := Bounds[1];
  Result.bounds[2] := Bounds[2];
  Result.bounds[3] := Bounds[3];
  Result.RotationCenter[0] := FRotationCenter[0];
  Result.RotationCenter[1] := FRotationCenter[1];
}
  Result.camX0 := camX0;
  Result.camY0 := camY0;
  Result.camW := camW;
  Result.camH := camH;
  Result.bws := bws;
  Result.bhs := bhs;
  Result.cosa := cosa;
  Result.sina := sina;
  Result.rcX := rcX;
  Result.rcY := rcY;

  Result.ColorMap := colorMap;
  Result.CriticalSection := CriticalSection;
  Result.Nrbatches := FNrBatches;
  Result.batchcounter := @batchcounter;
end;

///////////////////////////////////////////////////////////////////////////////
end.

