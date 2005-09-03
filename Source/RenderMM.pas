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
unit RenderMM;

interface

uses
  Windows, Graphics,
   Render, Controlpoint, ImageMaker;

type
  TRendererMM64 = class(TBaseRenderer)
  private
    oversample: Integer;
    filter_width: Integer;
    filter: array of array of extended;

    image_Width: Int64;
    image_Height: Int64;
    BucketWidth: Integer;
    BucketHeight: Integer;
    BucketSize: Integer;
    gutter_width: Integer;

    sample_density: extended;

    Buckets: TBucketArray;
    ColorMap: TColorMapArray;

    bounds: array[0..3] of extended;
    size: array[0..1] of extended;
    FRotationCenter: array[0..1] of extended;
    ppux, ppuy: extended;
    nrSlices: int64;
    Slice: int64;
    FImageMaker: TImageMaker;

    procedure InitValues;
    procedure InitBuffers;
    procedure ClearBuffers;
    procedure ClearBuckets;
    procedure CreateColorMap;
    procedure CreateCamera;

    procedure AddPointsToBuckets(const points: TPointsArray); overload;
    procedure AddPointsToBucketsAngle(const points: TPointsArray); overload;

    procedure SetPixels;
  protected
    function GetSlice: integer; override;
    function GetNrSlices: integer; override;

  public
    constructor Create; override;
    destructor Destroy; override;

    function  GetImage: TBitmap; override;
    procedure SaveImage(const FileName: String); override;

    procedure Render; override;

  end;

implementation

uses
  Math, Sysutils;

{ TRendererMM64 }

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64.ClearBuckets;
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
procedure TRendererMM64.ClearBuffers;
begin
  ClearBuckets;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64.CreateCamera;
var
  scale: double;
  t0, t1: double;
  corner0, corner1: double;
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
  corner0 := fcp.center[0] - image_width / ppux / 2.0;
  corner1 := fcp.center[1] - image_height / ppuy / 2.0;
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
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64.CreateColorMap;
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
destructor TRendererMM64.Destroy;
begin
  FImageMaker.Free;

  inherited;
end;

///////////////////////////////////////////////////////////////////////////////
function TRendererMM64.GetImage: TBitmap;
begin
  Result := FImageMaker.GetImage;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64.InitBuffers;
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
procedure TRendererMM64.InitValues;
begin
  image_height := fcp.Height;
  image_Width := fcp.Width;

  CreateCamera;

  InitBuffers;

  CreateColorMap;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64.AddPointsToBuckets(const points: TPointsArray);
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
    if FStop then
      Exit;

    px := points[i].x - bx;
    py := points[i].y - by;

    if ((px < 0) or (px > wx) or
        (py < 0) or (py > wy)) then
      continue;

    MapColor := @ColorMap[Round(points[i].c * 255)];
    Bucket := @buckets[Round(bws * px) + Round(bhs * py) * BucketWidth];

    Inc(Bucket.Red,   MapColor.Red);
    Inc(Bucket.Green, MapColor.Green);
    Inc(Bucket.Blue,  MapColor.Blue);
    Inc(Bucket.Count);
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64.AddPointsToBucketsAngle(const points: TPointsArray);
var
  i: integer;
  px, py: double;
  ca,sa: double;
  nx, ny: double;
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

  ca := cos(FCP.FAngle);
  sa := sin(FCP.FAngle);

  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
    if FStop then
      Exit;

    px := points[i].x - FRotationCenter[0];
    py := points[i].y - FRotationCenter[1];

    nx := px * ca + py * sa;
    ny := -px * sa + py * ca;

    px := nx + FRotationCenter[0] - bx;
    py := ny + FRotationCenter[1] - by;

    if ((px < 0) or (px > wx) or
        (py < 0) or (py > wy)) then
      continue;

    MapColor := @ColorMap[Round(points[i].c * 255)];
    Bucket := @buckets[Round(bws * px) + Round(bhs * py) * BucketWidth];

    Inc(Bucket.Red,   MapColor.Red);
    Inc(Bucket.Green, MapColor.Green);
    Inc(Bucket.Blue,  MapColor.Blue);
    Inc(Bucket.Count);
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64.SetPixels;
var
  i: integer;
  nsamples: Int64;
  nrbatches: Integer;
  points: TPointsArray;
begin
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
    case Compatibility of
      0: fcp.iterate_Old(SUB_BATCH_SIZE, points);
      1: fcp.iterateXYC(SUB_BATCH_SIZE, points);
    end;

    if FCP.FAngle = 0 then
      AddPointsToBuckets(points)
    else
      AddPointsToBucketsAngle(points);
  end;

  Progress(1);
end;


///////////////////////////////////////////////////////////////////////////////
constructor TRendererMM64.Create;
begin
  inherited Create;

  FImageMaker  := TImageMaker.Create;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64.Render;
const
  Dividers: array[0..15] of integer = (1, 2, 3, 4, 5, 6, 7, 8, 10, 16, 20, 32, 64, 128, 256, 512);
var
  ApproxMemory, MaxMemory: int64;
  i: integer;
  zoom_scale, center_base, center_y: double;
begin
  FStop := False;

  FRotationCenter[0] := fcp.center[0];
  FRotationCenter[1] := fcp.center[1];

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
    SetPixels;

    if not FStop then begin
      FImageMaker.OnProgress := OnProgress;
      FImageMaker.CreateImage(Slice * fcp.height);
    end;
  end;

  fcp.sample_density := fcp.sample_density / nrslices;
  fcp.height := fcp.height * nrslices;
end;

///////////////////////////////////////////////////////////////////////////////
function TRendererMM64.GetSlice: integer;
begin
  Result := Slice;
end;

///////////////////////////////////////////////////////////////////////////////
function TRendererMM64.GetNrSlices: integer;
begin
  Result := NrSlices;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64.SaveImage(const FileName: String);
begin
  FImageMaker.SaveImage(FileName);
end;

///////////////////////////////////////////////////////////////////////////////
end.

