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
unit Render;

interface

uses
  Windows, Graphics,
  Controlpoint;

type
  TOnProgress = procedure(prog: double) of object;

type
  TColorMapColor = Record
    Red  : Int64;
    Green: Int64;
    Blue : Int64;
//    Count: Int64;
  end;
  PColorMapColor = ^TColorMapColor;
  TColorMapArray = array[0..255] of TColorMapColor;

  TBucket = Record
    Red  : Int64;
    Green: Int64;
    Blue : Int64;
    Count: Int64;
  end;
  PBucket = ^TBucket;
  TBucketArray = array of TBucket;


type
  TBaseRenderer = class
  private
    procedure SetOnProgress(const Value: TOnProgress);
  protected
    FMaxMem: integer;
    FCompatibility: integer;
    FStop: boolean;
    FOnProgress: TOnProgress;
    FCP: TControlPoint;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure SetCP(CP: TControlPoint);
    function  GetImage: TBitmap; virtual; abstract;
    procedure Render; virtual; abstract;
    procedure Stop;

    property OnProgress: TOnProgress
        read FOnProgress
       write SetOnProgress;

    property compatibility : integer
        read Fcompatibility
       write Fcompatibility;

    property MaxMem : integer
        read FMaxMem
       write FMaxMem;

  end;

type
  TRenderer = class
  private
    Fcp: TControlPoint;
    bm: TBitmap;

    oversample: int64;
    filter_width: int64;
    filter: array of array of extended;

    image_Width: int64;
    image_Height: int64;
    BucketWidth: int64;
    BucketHeight: int64;
    BucketSize: int64;
    gutter_width: int64;

//    sample_density: double;
    sample_density: extended;           // mt

    Buckets: TBucketArray;
    ColorMap: TColorMapArray;
    accumulate: array of array of int64;

    bg: array[0..2] of extended;
    vib_gam_n: int64;
    vibrancy: double;
    gamma: double;

    bounds: array[0..3] of extended;
    size: array[0..1] of extended;
    ppux, ppuy: extended;

    bUseAcculationBuffer: boolean;
    bStop: boolean;

    FOnProgress: TOnProgress;

    procedure SetOnProgress(const Value: TOnProgress);

    procedure CreateFilter;
    procedure NormalizeFilter;

    procedure InitValues;
    procedure InitBuffers;
    procedure InitBitmap(w: int64 = 0; h: int64 = 0);
    procedure ClearBuffers;
    procedure ClearBuckets;
    procedure CreateColorMap;
    procedure CreateCamera;

    procedure FillAccumulation(Filter: double = 1);

    procedure AddPointsToBuckets(const points: TPointsArray); overload;
    procedure AddPointsToBucketsAngle(const points: TPointsArray); overload;

  public
    MaxMem: int64;
    nrSlices: int64;
    Slice: int64;
    compatibility : integer;
    constructor Create;
    destructor Destroy; override;

    procedure SetCP(CP: TControlPoint);
    function GetImage: TBitmap;
    procedure SetPixels;
    procedure CreateBM;
    procedure CreateBMFromBuckets(YOffset: int64 = 0);
    procedure CreateBMPrecise;

    procedure RenderMaxMem(MaxMemory: int64 = 64);
    procedure Render; overload;
    procedure Render(Time: double); overload;
    procedure Stop;

    procedure Test(var fracBlack, fracWhite, avgColor: Double);

    property OnProgress: TOnProgress
      read FOnProgress
      write SetOnProgress;
  end;

implementation

uses
  Math, Sysutils;

{ TRenderer }


procedure TRenderer.ClearBuckets;
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

procedure TRenderer.ClearBuffers;
var
  i: integer;
begin
  if bUseAcculationBuffer then
    for i := 0 to BucketSize - 1 do begin
      buckets[i].Red   := 0;
      buckets[i].Green := 0;
      buckets[i].Blue  := 0;
      buckets[i].Count := 0;

      accumulate[i][0] := 0;
      accumulate[i][1] := 0;
      accumulate[i][2] := 0;
      accumulate[i][3] := 0;
    end
  else
    ClearBuckets;
end;

procedure TRenderer.CreateBM;
var
  i, j: integer;

  alpha: double;
//  r,g,b: double;
  ai, ri, gi, bi: int64;
  bgtot: int64;
  ls: double;

  ii, jj: integer;
  fp: array[0..3] of double;

  Row: PLongintArray;

  vib, notvib: int64;
  bgi: array[0..2] of int64;
  bucketpos: int64;
  filterValue: double;
  filterpos: int64;
begin
  vibrancy := vibrancy / vib_gam_n;
  gamma := vib_gam_n / gamma;

  vib := round(vibrancy * 256.0);
  notvib := 256 - vib;

  bgi[0] := round((256 * bg[0]) / vib_gam_n);
  bgi[1] := round((256 * bg[1]) / vib_gam_n);
  bgi[2] := round((256 * bg[2]) / vib_gam_n);
  bgtot := RGB(bgi[2], bgi[1], bgi[0]);

  bucketpos := 0;
  ai := 0;
  ls := 0;

  for i := 0 to Image_Height - 1 do begin
    if bStop then
      Break;

    if assigned(FOnProgress) then
      FOnProgress(i / Image_Height);

    Row := PLongintArray(bm.scanline[i]);
    for j := 0 to Image_Width - 1 do begin
      // todo filter

      if filter_width > 1 then begin
        fp[0] := 0;
        fp[1] := 0;
        fp[2] := 0;
        fp[3] := 0;

        for ii := 0 to filter_width - 1 do begin
          for jj := 0 to filter_width - 1 do begin
            filterValue := filter[ii, jj];
//            filterpos := (i * oversample + ii) * BucketWidth + j * oversample  + jj;
            filterpos := bucketpos + ii * BucketWidth + jj;
            fp[0] := fp[0] + filterValue * accumulate[filterpos][0];
            fp[1] := fp[1] + filterValue * accumulate[filterpos][1];
            fp[2] := fp[2] + filterValue * accumulate[filterpos][2];
            fp[3] := fp[3] + filterValue * accumulate[filterpos][3];
          end;
        end;
      end else begin
        fp[0] := accumulate[bucketpos][0];
        fp[1] := accumulate[bucketpos][1];
        fp[2] := accumulate[bucketpos][2];
        fp[3] := accumulate[bucketpos][3];
      end;
      Inc(bucketpos, oversample);

      fp[0] := fp[0] / PREFILTER_WHITE;
      fp[1] := fp[1] / PREFILTER_WHITE;
      fp[2] := fp[2] / PREFILTER_WHITE;
      fp[3] := fp[3] / PREFILTER_WHITE;
      if (fp[3] > 0.0) then begin
        alpha := power(fp[3], gamma);
        ls := vib * alpha / fp[3];
        ai := round(alpha * 256);
        if (ai < 0) then
          ai := 0
        else if (ai > 256) then
          ai := 256;
        ai := 256 - ai;
      end else begin
        // no intesity so simply set the BG;
        Row[j] := bgtot;
        continue;
      end;

      if (notvib > 0) then
        ri := Round(ls * fp[0] + notvib * power(fp[0], gamma))
      else
        ri := Round(ls * fp[0]);
      ri := ri + (ai * bgi[0]) shr 8;
      if (ri < 0) then
        ri := 0
      else if (ri > 255) then
        ri := 255;

      if (notvib > 0) then
        gi := Round(ls * fp[1] + notvib * power(fp[1], gamma))
      else
        gi := Round(ls * fp[1]);
      gi := gi + (ai * bgi[1]) shr 8;
      if (gi < 0) then
        gi := 0
      else if (gi > 255) then
        gi := 255;

      if (notvib > 0) then
        bi := Round(ls * fp[2] + notvib * power(fp[2], gamma))
      else
        bi := Round(ls * fp[2]);
      bi := bi + (ai * bgi[2]) shr 8;
      if (bi < 0) then
        bi := 0
      else if (bi > 255) then
        bi := 255;

      Row[j] := RGB(bi, gi, ri);
    end;

    Inc(bucketpos, 2 * gutter_width);
    Inc(bucketpos, (oversample - 1) * BucketWidth);
  end;
  bm.PixelFormat := pf24bit;
end;

procedure TRenderer.CreateBMPrecise;
var
  i, j: integer;

  alpha: double;
  r, g, b: double;
  ls: double;

  ii, jj: integer;
  fp: array[0..3] of double;

  Row: PLongintArray;
begin
  vibrancy := vibrancy / vib_gam_n;
  gamma := vib_gam_n / gamma;

  bg[0] := 256 * bg[0] / vib_gam_n;
  bg[1] := 256 * bg[1] / vib_gam_n;
  bg[2] := 256 * bg[2] / vib_gam_n;

  for i := 0 to Image_Height - 1 do begin
    if assigned(FOnProgress) then
      FOnProgress(i / Image_Height);

    Row := PLongintArray(bm.scanline[i]);

    for j := 0 to Image_Width - 1 do begin
      // todo filter

      fp[0] := 0;
      fp[1] := 0;
      fp[2] := 0;
      fp[3] := 0;
      for ii := 0 to filter_width - 1 do begin
        for jj := 0 to filter_width - 1 do begin
          fp[0] := fp[0] + filter[ii, jj] * accumulate[(i * oversample + ii) * BucketWidth + j * oversample + jj][0];
          fp[1] := fp[1] + filter[ii, jj] * accumulate[(i * oversample + ii) * BucketWidth + j * oversample + jj][1];
          fp[2] := fp[2] + filter[ii, jj] * accumulate[(i * oversample + ii) * BucketWidth + j * oversample + jj][2];
          fp[3] := fp[3] + filter[ii, jj] * accumulate[(i * oversample + ii) * BucketWidth + j * oversample + jj][3];
        end;
      end;

      alpha := fp[3];
      if (alpha > 0.0) then begin
        ls := vibrancy * 256.0 * power(alpha / PREFILTER_WHITE, gamma) / (alpha / PREFILTER_WHITE);
        alpha := power(alpha / PREFILTER_WHITE, gamma);
        if (alpha < 0.0) then
          alpha := 0.0
        else if (alpha > 1.0) then
          alpha := 1.0;
      end else begin
        ls := 0;
      end;

      r := ls * fp[0] / PREFILTER_WHITE;
      if (vibrancy < 1.0) then
        r := r + (1.0 - vibrancy) * 256.0 * power(fp[0] / PREFILTER_WHITE, gamma);
      r := r + ((1.0 - alpha) * bg[0]);
      if (r < 0) then
        r := 0
      else if (r > 255) then
        r := 255;

      g := ls * fp[1] / PREFILTER_WHITE;
      if (vibrancy < 1.0) then
        g := g + (1.0 - vibrancy) * 256.0 * power(fp[1] / PREFILTER_WHITE, gamma);
      g := g + ((1.0 - alpha) * bg[1]);
      if (g < 0) then
        g := 0
      else if (g > 255) then
        g := 255;

      b := ls * fp[2] / PREFILTER_WHITE;
      if (vibrancy < 1.0) then
        b := b + (1.0 - vibrancy) * 256.0 * power(fp[2] / PREFILTER_WHITE, gamma);
      b := b + ((1.0 - alpha) * bg[2]);
      if (b < 0) then
        b := 0
      else if (b > 255) then
        b := 255;

      Row[j] := RGB(round(b), round(g), round(r));
    end;
  end;
  bm.PixelFormat := pf24bit;
end;

procedure TRenderer.CreateCamera;
var
  scale: double;
  t0, t1: double;
  corner0, corner1: double;
  shift: int64;
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

procedure TRenderer.CreateColorMap;
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

procedure TRenderer.CreateFilter;
var
  i, j: integer;
begin
  oversample := fcp.spatial_oversample;
  filter_width := Round(2.0 * FILTER_CUTOFF * oversample * fcp.spatial_filter_radius);
  // make sure it has same parity as oversample
  if odd(filter_width + oversample) then
    inc(filter_width);

  setLength(filter, filter_width, filter_width);
  for i := 0 to filter_width - 1 do begin
    for j := 0 to filter_width - 1 do begin
      filter[i, j] := exp(-2.0 * power(((2.0 * i + 1.0) / filter_width - 1.0) * FILTER_CUTOFF, 2) *
        power(((2.0 * j + 1.0) / filter_width - 1.0) * FILTER_CUTOFF, 2));
    end;
  end;
  Normalizefilter;
end;

destructor TRenderer.Destroy;
begin
  if assigned(bm) then
    bm.Free;

  inherited;
end;

procedure TRenderer.FillAccumulation(Filter: double);
var
  k1, k2: double;
  area: double;
  ls: double;
  i: integer;
begin
  vibrancy := vibrancy + fcp.vibrancy;
  gamma := gamma + fcp.gamma;
  Inc(vib_gam_n);

  bg[0] := bg[0] + fcp.background[0] / 256;
  bg[1] := bg[1] + fcp.background[1] / 256;
  bg[2] := bg[2] + fcp.background[2] / 256;

  k1 := (Filter * fcp.Contrast * BRIGHT_ADJUST * fcp.brightness * 268 * PREFILTER_WHITE) / 256;
  area := image_width * image_height / (ppux * ppuy);
  k2 := (oversample * oversample * fcp.nbatches) / (fcp.Contrast * area * fcp.White_level * sample_density);

  for i := 0 to BucketWidth * BucketHeight - 1 do begin
    if Buckets[i].count = 0 then
      Continue;
    ls := (k1 * log10(1 + Buckets[i].Count * k2)) / Buckets[i].Count;
    accumulate[i, 0] := accumulate[i, 0] + Round(Buckets[i].Red * ls);
    accumulate[i, 1] := accumulate[i, 1] + Round(Buckets[i].Green * ls);
    accumulate[i, 2] := accumulate[i, 2] + Round(Buckets[i].Blue * ls);
    accumulate[i, 3] := accumulate[i, 3] + Round(Buckets[i].Count * ls);
  end;
end;

function TRenderer.GetImage: TBitmap;
begin
  Result := bm;
end;

procedure TRenderer.InitBuffers;
begin
  gutter_width := (filter_width - oversample) div 2;
  BucketHeight := oversample * image_height + 2 * gutter_width;
  Bucketwidth := oversample * image_width + 2 * gutter_width;
  BucketSize := BucketWidth * BucketHeight;

  if high(buckets) <> (BucketSize - 1) then begin
    SetLength(buckets, BucketSize);
    if bUseAcculationBuffer then
      SetLength(accumulate, BucketSize, 4);
  end;
end;

procedure TRenderer.InitValues;
begin
  image_height := fcp.Height;
  image_Width := fcp.Width;

  bUseAcculationBuffer := fcp.nbatches > 1;
//  bUseAcculationBuffer := True;

  CreateFilter;
  CreateCamera;

  InitBuffers;

  CreateColorMap;

  vibrancy := 0;
  gamma := 0;
  vib_gam_n := 0;
  bg[0] := 0;
  bg[1] := 0;
  bg[2] := 0;
end;

procedure TRenderer.NormalizeFilter;
var
  i, j: integer;
  t: double;
begin
  t := 0;
  for i := 0 to filter_width - 1 do
    for j := 0 to filter_width - 1 do
      t := t + filter[i, j];

  for i := 0 to filter_width - 1 do
    for j := 0 to filter_width - 1 do
      filter[i, j] := filter[i, j] / t;
end;

procedure TRenderer.RenderMaxMem(MaxMemory: int64);
const
  Dividers: array[0..12] of integer = (1, 2, 3, 4, 5, 6, 7, 8, 10, 16, 20, 32, 64);
var
  ApproxMemory: int64;
  i: integer;
//  height: double;
  zoom_scale, center_base, center_y: double;
begin
  bUseAcculationBuffer := fcp.nbatches > 1;
  image_height := fcp.Height;
  image_Width := fcp.Width;
  oversample := fcp.spatial_oversample;

  MaxMemory := MaxMemory * 1000000 - 4 * image_height * image_width;

  if bUseAcculationBuffer then
    ApproxMemory := 32 * oversample * oversample * image_height * image_width
  else
    ApproxMemory := 16 * oversample * oversample * image_height * image_width;

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

  fcp.sample_density := fcp.sample_density * nrslices;
  fcp.height := fcp.height div nrslices;
//  height := Fcp.Height / Fcp.pixels_per_unit;
// Slice location changed to code from Drave's flame 1.6 - mt
  center_y := fcp.center[1];
  zoom_scale := power(2.0, fcp.zoom);
  center_base := center_y - ((nrslices - 1) * fcp.height) /
    (2 * fcp.pixels_per_unit * zoom_scale);

  InitValues;
  InitBitmap(fcp.Width, NrSlices * fcp.Height);

  for i := 0 to NrSlices - 1 do begin
    Slice := i;
//    fcp.center[1] := center_base + Height * slice;
    fcp.center[1] := center_base + fcp.height * slice / (fcp.pixels_per_unit * zoom_scale);
    CreateCamera;
    ClearBuffers;
    SetPixels;
    if bUseAcculationBuffer then begin
      FillAccumulation;
      CreateBM;
    end else begin
      CreateBMFromBuckets(Slice * fcp.height);
    end;
  end;
  fcp.sample_density := fcp.sample_density / nrslices;
  fcp.height := fcp.height * nrslices;
end;


procedure TRenderer.Render(Time: double);
//var
//  i: integer;
begin
{
  if not Assigned(FCPS) or (FCPS.NrControlPoints = 0) then begin
    if Assigned(FCP) then
      Render(0);
    exit;
  end;

  FCP := FCPS.Cps[0];
  FCP.spatial_filter_radius := 0.4;
  InitValues;
  InitBitmap;
  InitTemporalData;
  ClearBuffers;

  for i := 0 to FCP.nbatches - 1 do begin
    FCP := FCPS.GetCp(time + temporal_deltas[i]);
    ClearBuckets;
    CreateCamera;
    CreateCMap;
    SetPixelsi;

    if bUseAcculationBuffer then begin
      FillAccumulation(temporal_filter[i]);
    end else begin
      CreateBMFromBuckets;
    end;

    FCP.Free;
  end;
  if bUseAcculationBuffer then begin
    CreateBM;
  end;

  FCP := nil;
  }
end;

procedure TRenderer.SetCP(CP: TControlPoint);
begin
  FCP := CP;
//  FCPS := nil;
end;

{
procedure TRenderer.SetCPS(CPS: TControlPoints);
begin
  FCPS := CPS;
  FCP := nil;
end;
}

procedure TRenderer.SetOnProgress(const Value: TOnProgress);
begin
  FOnProgress := Value;
end;


procedure TRenderer.AddPointsToBuckets(const points: TPointsArray);
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
    if bStop then
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

procedure TRenderer.AddPointsToBucketsAngle(const points: TPointsArray);
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
    if BStop then
      Exit;

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
    Bucket := @buckets[Round(bws * px) + Round(bhs * py) * BucketWidth];

    Inc(Bucket.Red,   MapColor.Red);
    Inc(Bucket.Green, MapColor.Green);
    Inc(Bucket.Blue,  MapColor.Blue);
    Inc(Bucket.Count);
  end;
end;

procedure TRenderer.SetPixels;
var
  i: integer;
  nsamples: int64;
  nrbatches: int64;
  points: TPointsArray;
begin
  SetLength(Points, SUB_BATCH_SIZE);

  nsamples := Round(sample_density * bucketSize / (oversample * oversample));
  nrbatches := Round(nsamples / (fcp.nbatches * SUB_BATCH_SIZE));
  Randomize;

  for i := 0 to nrbatches do begin
    if bStop then
      Exit;

    if (i and $F = 0) and assigned(FOnProgress) then
      FOnProgress(i / nrbatches);

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

  if assigned(FOnProgress) then
    FOnProgress(1);
end;

procedure TRenderer.Stop;
begin
  bStop := True;
end;

procedure TRenderer.CreateBMFromBuckets(YOffset: int64);
var
  i, j: integer;

  alpha: double;
//  r,g,b: double;
  ai, ri, gi, bi: int64;
  bgtot: int64;
  ls: double;
  ii, jj: integer;
  fp: array[0..3] of double;
  Row: PLongintArray;
  vib, notvib: int64;
  bgi: array[0..2] of int64;
  bucketpos: int64;
  filterValue: double;
  filterpos: int64;
  lsa: array[0..1024] of double;
var
  k1, k2: double;
  area: double;
begin
  if fcp.gamma = 0 then
    gamma := fcp.gamma
  else
    gamma := 1 / fcp.gamma;
  vib := round(fcp.vibrancy * 256.0);
  notvib := 256 - vib;

  bgi[0] := round(fcp.background[0]);
  bgi[1] := round(fcp.background[1]);
  bgi[2] := round(fcp.background[2]);
  bgtot := RGB(bgi[2], bgi[1], bgi[0]);

  k1 := (fcp.Contrast * BRIGHT_ADJUST * fcp.brightness * 268 * PREFILTER_WHITE) / 256.0;
  area := image_width * image_height / (ppux * ppuy);
  k2 := (oversample * oversample) / (fcp.Contrast * area * fcp.White_level * sample_density);

  lsa[0] := 0;
  for i := 1 to 1024 do begin
    lsa[i] := (k1 * log10(1 + fcp.White_level * i * k2)) / (fcp.White_level * i);
  end;

  if filter_width > 1 then begin
    for i := 0 to BucketWidth * BucketHeight - 1 do begin
      if Buckets[i].count = 0 then
        Continue;

      ls := lsa[Min(1023, Buckets[i].Count)];

      Buckets[i].Red   := Round(Buckets[i].Red * ls);
      Buckets[i].Green := Round(Buckets[i].Green * ls);
      Buckets[i].Blue  := Round(Buckets[i].Blue * ls);
      Buckets[i].Count := Round(Buckets[i].Count * ls);
    end;
  end;

  ls := 0;
  ai := 0;
  bucketpos := 0;
  for i := 0 to Image_Height - 1 do begin
    if bStop then
      Break;

    if assigned(FOnProgress) then
      FOnProgress(i / Image_Height);

    Row := PLongintArray(bm.scanline[YOffset + i]);
    for j := 0 to Image_Width - 1 do begin
      if filter_width > 1 then begin
        fp[0] := 0;
        fp[1] := 0;
        fp[2] := 0;
        fp[3] := 0;

        for ii := 0 to filter_width - 1 do begin
          for jj := 0 to filter_width - 1 do begin
            filterValue := filter[ii, jj];
            filterpos := bucketpos + ii * BucketWidth + jj;

            fp[0] := fp[0] + filterValue * Buckets[filterpos].Red;
            fp[1] := fp[1] + filterValue * Buckets[filterpos].Green;
            fp[2] := fp[2] + filterValue * Buckets[filterpos].Blue;
            fp[3] := fp[3] + filterValue * Buckets[filterpos].Count;
          end;
        end;

        fp[0] := fp[0] / PREFILTER_WHITE;
        fp[1] := fp[1] / PREFILTER_WHITE;
        fp[2] := fp[2] / PREFILTER_WHITE;
        fp[3] := fcp.white_level * fp[3] / PREFILTER_WHITE;
      end else begin
        ls := lsa[Min(1023, Buckets[bucketpos].count)] / PREFILTER_WHITE;

        fp[0] := ls * Buckets[bucketpos].Red;
        fp[1] := ls * Buckets[bucketpos].Green;
        fp[2] := ls * Buckets[bucketpos].Blue;
        fp[3] := ls * Buckets[bucketpos].Count * fcp.white_level;
      end;

      Inc(bucketpos, oversample);

      if (fp[3] > 0.0) then begin
        alpha := power(fp[3], gamma);
        ls := vib * alpha / fp[3];
        ai := round(alpha * 256);
        if (ai < 0) then
          ai := 0
        else if (ai > 256) then
          ai := 256;
        ai := 256 - ai;
      end else begin
        // no intensity so simply set the BG;
        Row[j] := bgtot;
        continue;
      end;

      if (notvib > 0) then
        ri := Round(ls * fp[0] + notvib * power(fp[0], gamma))
      else
        ri := Round(ls * fp[0]);
      ri := ri + (ai * bgi[0]) shr 8;
      if (ri < 0) then
        ri := 0
      else if (ri > 255) then
        ri := 255;

      if (notvib > 0) then
        gi := Round(ls * fp[1] + notvib * power(fp[1], gamma))
      else
        gi := Round(ls * fp[1]);
      gi := gi + (ai * bgi[1]) shr 8;
      if (gi < 0) then
        gi := 0
      else if (gi > 255) then
        gi := 255;

      if (notvib > 0) then
        bi := Round(ls * fp[2] + notvib * power(fp[2], gamma))
      else
        bi := Round(ls * fp[2]);
      bi := bi + (ai * bgi[2]) shr 8;
      if (bi < 0) then
        bi := 0
      else if (bi > 255) then
        bi := 255;

      Row[j] := RGB(bi, gi, ri);
    end;

    Inc(bucketpos, 2 * gutter_width);
    Inc(bucketpos, (oversample - 1) * BucketWidth);
  end;
  bm.PixelFormat := pf24bit;

  if assigned(FOnProgress) then
    FOnProgress(1);
end;

procedure TRenderer.InitBitmap(w, h: int64);
begin
  if not Assigned(bm) then
    bm := TBitmap.Create;

  bm.PixelFormat := pf32bit;

  if (w <> 0) and (h <> 0) then begin
    bm.Width := w;
    bm.Height := h;
  end else begin
    bm.Width := image_Width;
    bm.Height := image_Height;
  end;
end;

constructor TRenderer.Create;
begin
  MaxMem := 0;                          // mt
  Slice := 0;
  NrSlices := 1;
end;

procedure TRenderer.Test(var fracBlack, fracWhite, avgColor: Double);
// Might have to take this out of class...only needs to see the bitmap;
var
  x, y: integer;
  Row: PLongintArray;
  nrPixels: int64;
  nrWhite: int64;
  nrBlack: int64;
  SumColor: int64;
  c: int64;
begin
  Render;

  nrPixels := fcp.Width * fcp.Height;
  nrWhite := 0;
  nrBlack := 0;
  SumColor := 0;
  for y := 0 to bm.Height - 1 do begin
    Row := bm.ScanLine[y];
    for x := 0 to bm.Height - 1 do begin
      c := (((Row[x] shr 16) and $FF) + ((Row[x] shr 8) and $FF) + (Row[x] and $FF)) div 3;
      Inc(SumColor, c);
      if c = 0 then Inc(nrBlack);
      if c = 255 then Inc(nrWhite);
    end;
  end;

  fracBlack := nrBlack / nrPixels;
  fracWhite := nrWhite / nrPixels;
  avgColor := SumColor / nrPixels;
end;

procedure TRenderer.Render;
begin
{  if not Assigned(FCP) then begin
    if Assigned(FCPS) then
      Render(0);
    exit;
  end;
}

  bStop := False;

  InitValues;
  InitBitmap;
  ClearBuffers;
  SetPixels;
  if bUseAcculationBuffer then begin
    FillAccumulation;
    CreateBM;
  end else begin
    CreateBMFromBuckets;
  end;
end;


{ TBaseRenderer }

procedure TBaseRenderer.SetOnProgress(const Value: TOnProgress);
begin
  FOnProgress := Value;
end;

constructor TBaseRenderer.Create;
begin
  inherited Create;
  FCompatibility := 1;
  FStop := False;
end;

procedure TBaseRenderer.SetCP(CP: TControlPoint);
begin
  if assigned(FCP) then
    FCP.Free;

  FCP := Cp.Clone;
end;

procedure TBaseRenderer.Stop;
begin
  FStop := True;
end;


destructor TBaseRenderer.Destroy;
begin
  if assigned(FCP) then
    FCP.Free;

  inherited;
end;

end.

