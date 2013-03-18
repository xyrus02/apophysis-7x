{
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Borys, Peter Sdobnov
     Apophysis Copyright (C) 2007-2008 Piotr Borys, Peter Sdobnov
     
     Apophysis "3D hack" Copyright (C) 2007-2008 Peter Sdobnov
     Apophysis "7X" Copyright (C) 2009-2010 Georg Kiehne

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

unit ImageMaker;

interface

uses
  Windows, Graphics, ControlPoint, RenderingCommon, PngImage, Bezier;

type TPalette = record
    logpal : TLogPalette;
    colors: array[0..255] of TPaletteEntry;
  end;

type
  TImageMaker = class
  private
    FOversample: Integer;
    FFilterSize: Integer;
    FFilter: array of array of double;
    FParameters : String;

    FBitmap: TBitmap;
    FAlphaBitmap: TBitmap;
    AlphaPalette: TPalette;
    FTransparentImage: TBitmap;

    comp_max_radius, comp_min_radius : double;
    num_de_filters_d, num_de_filters : double;
    de_max_ind, de_count_limit : double;
    de_cutoff_val : double;
    de_row_size, de_half_size, de_kernel_index : double;
    de_filter_coefs, de_filter_widths : array of double;

    FCP: TControlPoint;

    FBucketHeight: integer;
    FBucketWidth: integer;
    FBuckets: TBucketArray;
    FOnProgress: TOnProgress;
    FGetBucket: function(x, y: integer): TBucket of object;
    function GetBucket(x, y: integer): TBucket;
    function SafeGetBucket(x, y: integer): TBucket;

    procedure CreateFilter;
    procedure InitDE;
    procedure NormalizeFilter;

  public
    constructor Create;
    destructor Destroy; override;

    function GetImage: TBitmap;
    procedure GetImageAndDelete(target:tBitmap);
    function GetTransparentImage: TPNGObject;

    procedure SetCP(CP: TControlPoint);
    procedure Init;
    procedure SetBucketData(const Buckets: pointer; BucketWidth, BucketHeight: integer; bits: integer);

    function GetFilterSize: Integer;

    procedure CreateImage(YOffset: integer = 0);
    procedure SaveImage(FileName: String);

    procedure GetBucketStats(var Stats: TBucketStats);

    property OnProgress: TOnProgress
//      read FOnProgress
       write FOnProgress;
  end;

implementation

uses
  Math, SysUtils, JPEG, Global, Types;

{ TImageMaker }

type
  TRGB = packed Record
    blue: byte;
    green: byte;
    red: byte;
  end;

  PByteArray = ^TByteArray;
  TByteArray = array[0..0] of byte;
//  PLongintArray = ^TLongintArray;
//  TLongintArray = array[0..0] of Longint;
  PRGBArray = ^TRGBArray;
  TRGBArray = array[0..0] of TRGB;

///////////////////////////////////////////////////////////////////////////////
constructor TImageMaker.Create;
var
  i: integer;
begin
  AlphaPalette.logpal.palVersion := $300;
  AlphaPalette.logpal.palNumEntries := 256;
  for i := 0 to 255 do
    with AlphaPalette.logpal.palPalEntry[i] do begin
      peRed := i;
      peGreen := i;
      peBlue := i;
    end;
end;

///////////////////////////////////////////////////////////////////////////////
destructor TImageMaker.Destroy;
begin
  if assigned(FBitmap) then
    FBitmap.Free;

  if assigned(FAlphaBitmap) then
    FAlphaBitmap.Free;

  if assigned(FTransparentImage) then
    FTransparentImage.Free;

  inherited;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TImageMaker.CreateFilter;
var
  i, j: integer;
  fw: integer;
  adjust: double;
  ii, jj: double;
begin

  FOversample := fcp.spatial_oversample;
  fw := Trunc(2.0 * FILTER_CUTOFF * FOversample * fcp.spatial_filter_radius);
  FFilterSize := fw + 1;

  // make sure it has same parity as oversample
  if odd(FFilterSize + FOversample) then
    inc(FFilterSize);

  if (fw > 0.0) then
  	adjust := (1.0 * FILTER_CUTOFF * FFilterSize) / fw
  else
  	adjust := 1.0;

  setLength(FFilter, FFilterSize, FFilterSize);
  if fcp.enable_de and false then InitDE;

  for i := 0 to FFilterSize - 1 do begin
    for j := 0 to FFilterSize - 1 do begin
      ii := ((2.0 * i + 1.0)/ FFilterSize - 1.0) * adjust;
      jj := ((2.0 * j + 1.0)/ FFilterSize - 1.0) * adjust;

      FFilter[i, j] :=  exp(-2.0 * (ii * ii + jj * jj));
    end;
  end;

  Normalizefilter;
end;

procedure TImageMaker.InitDE;
var
  e, em, ec : double;
  filtloop : integer;

  de_filt_sum, de_filt_d, de_filt_h : double;
  adjloop, sfx : double;
  dej,dek, filter_coef_idx : integer;
  sl : integer;
begin
  de_filt_sum := 0;

  if (fcp.estimator < 0.0) then
    e := 0
  else
    e := fcp.estimator;

  if (fcp.estimator_min < 0.0) then
    em := 0
  else
    em := fcp.estimator_min;

  if (fcp.estimator_curve < 0.0) then
    ec := 0
  else
    ec := fcp.estimator_curve;

  if (e <= 0) then exit;

  comp_max_radius := e*Foversample + 1;
  comp_min_radius := em*Foversample + 1;

  num_de_filters_d := power(comp_max_radius/comp_min_radius, (1.0/ec));
  num_de_filters := ceil(num_de_filters_d);

  if (num_de_filters>100) then begin
    de_max_ind := ceil(100 + power(num_de_filters - 100, ec)) + 1;
    de_count_limit := power(de_max_ind - 100, 1.0/ec) + 100;
  end else begin
    de_max_ind := num_de_filters;
    de_count_limit := de_max_ind;
  end;

  de_row_size := 2*ceil(comp_max_radius)-1;
  de_half_size := (de_row_size-1)/2;
  de_kernel_index := (de_half_size+1)*(2+de_half_size)/2;

  sl := Trunc(de_max_ind * de_kernel_index);
  //assert(sl >= 0);
  if (sl < 0) then sl := 0;
  setLength(de_filter_coefs, sl);

  sl := Trunc(de_max_ind);
  //assert(sl >= 0);
  if (sl < 0) then sl := 0;
  setLength(de_filter_widths, sl);

  de_cutoff_val := 0;
  for filtloop := 0 to trunc(de_max_ind)-1 do begin
    if (filtloop < 100) then
      de_filt_h := (comp_max_radius / power(filtloop+1, ec))
    else begin
      adjloop := power(filtloop - 100, (1/ec))+100;
      de_filt_h := (comp_max_radius / power(adjloop+1, ec))
    end;

    if (de_filt_h <= comp_min_radius) then begin
      de_filt_h := comp_min_radius;
      de_cutoff_val := filtloop;
    end;

    de_filter_widths[filtloop] := de_filt_h;

    for dej := -trunc(de_half_size) to trunc(de_half_size) do
      for dek := -trunc(de_half_size) to trunc(de_half_size) do begin
        de_filt_d := sqrt(dej * dej + dek * dek) / de_filt_h;
        if (de_filt_d <= 1.0) then begin
          sfx := 1.8 * de_filt_d;
          de_filt_sum := de_filt_sum + (exp(-2.0*sfx*sfx)*0.7978845608);
        end;                                      // -X- ^^^ sqrt(2/PI)
      end;

    filter_coef_idx := filtloop * trunc(de_kernel_index);

    for dej := 0 to trunc(de_half_size) do
      for dek := 0 to dej-1 do begin
        de_filt_d := sqrt(dej * dej + dek * dek) / de_filt_h;
        if (de_filt_d>1.0) then begin
          // -X- TODO fix...
          if (filter_coef_idx >= 0) and (filter_coef_idx < Trunc(de_max_ind * de_kernel_index)) then
            de_filter_coefs[filter_coef_idx] := 0
        end else begin
          sfx := 1.8 * de_filt_d;
          if (filter_coef_idx >= 0) and (filter_coef_idx < Trunc(de_max_ind * de_kernel_index)) then
            de_filter_coefs[filter_coef_idx] := (exp(-2.0*sfx*sfx)*0.7978845608) / de_filt_sum;
        end;
        Inc(filter_coef_idx);
      end;

    if (de_cutoff_val > 0) then break;
  end;

  if (de_cutoff_val=0) then
    de_cutoff_val := num_de_filters-1;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TImageMaker.NormalizeFilter;
var
  i, j: integer;
  t: double;
begin
  t := 0;
  for i := 0 to FFilterSize - 1 do
    for j := 0 to FFilterSize - 1 do
      t := t + FFilter[i, j];

  for i := 0 to FFilterSize - 1 do
    for j := 0 to FFilterSize - 1 do
      FFilter[i, j] := FFilter[i, j] / t;
end;

///////////////////////////////////////////////////////////////////////////////
function TImageMaker.GetFilterSize: Integer;
begin
  Result := FFiltersize;
end;

///////////////////////////////////////////////////////////////////////////////
function TImageMaker.GetImage: TBitmap;
begin
//  if ShowTransparency then
//    Result := GetTransparentImage
//  else
    Result := FBitmap;
end;

procedure TImageMaker.GetImageAndDelete(target:tBitmap);
begin
    assert(false);
    //target.Assign(FBitmap);
    //FBitmap.Free;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TImageMaker.Init;
begin
  if not Assigned(FBitmap) then
    FBitmap := TBitmap.Create;

  FBitmap.PixelFormat := pf24bit;

  FBitmap.Width := Fcp.Width;
  FBitmap.Height := Fcp.Height;

  if not Assigned(FAlphaBitmap) then
    FAlphaBitmap := TBitmap.Create;

  FAlphaBitmap.PixelFormat := pf8bit;
  FAlphaBitmap.Width := Fcp.Width;
  FAlphaBitmap.Height := Fcp.Height;

  CreateFilter;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TImageMaker.SetBucketData(const Buckets: pointer; BucketWidth, BucketHeight: integer; bits: integer);
begin
  FBuckets := TBucketArray(Buckets);

  FBucketWidth := BucketWidth;
  FBucketHeight := BucketHeight;

  FGetBucket := GetBucket;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TImageMaker.SetCP(CP: TControlPoint);
begin
  Fcp := CP;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TImageMaker.CreateImage(YOffset: integer);
var
  gamma: double;
  i, j: integer;
  alpha: double;
  ri, gi, bi: Integer;
  ai, ia: integer;
  bgtot, zero_BG: TRGB;
  ls: double;
  ii, jj: integer;
  fp: array[0..3] of double;
  Row: PRGBArray;
  AlphaRow: PbyteArray;
  vib, notvib: Integer;
  bgi: array[0..2] of Integer;
//  bucketpos: Integer;
  filterValue: double;
//  filterpos: Integer;
  lsa: array[0..1024] of double;
  csa: array[0..3] of array[0..256] of double;
  sample_density: extended;
  gutter_width: integer;
  k1, k2: double;
  area: double;
  frac, funcval: double;
  f_select : double;
  f_select_int, f_coef_idx : integer;
  arr_filt_width : integer;
  c : array of double;
  ss : integer;
  scf:boolean;
  scfact : double;
  acc : integer;
  avg, fac: double;
  curvesSet: boolean;

  GetBucket: function(x, y: integer): TBucket of object;
  bucket: TBucket;
  bx, by: integer;
  label zero_alpha;
begin
  SetLength(c, 4);

  if fcp.gamma = 0 then
    gamma := fcp.gamma
  else
    gamma := 1 / fcp.gamma;
  vib := round(fcp.vibrancy * 256.0);
  notvib := 256 - vib;

  if fcp.gamma_threshold <> 0 then
    funcval := power(fcp.gamma_threshold, gamma - 1) { / fcp.gamma_threshold; }
  else funcval := 0;

  bgi[0] := round(fcp.background[0]);
  bgi[1] := round(fcp.background[1]);
  bgi[2] := round(fcp.background[2]);
  bgtot.red := bgi[0];
  bgtot.green := bgi[1];
  bgtot.blue := bgi[2];
  zero_BG.red := 0;
  zero_BG.green := 0;
  zero_BG.blue := 0;

  curvesSet := true;
  for i := 0 to 3 do
    curvesSet := curvesSet and (
      ((fcp.curvePoints[i][0].x = 0) and (fcp.curvePoints[i][0].y = 0)) and
      ((fcp.curvePoints[i][1].x = 0) and (fcp.curvePoints[i][1].y = 0)) and
      ((fcp.curvePoints[i][2].x = 1) and (fcp.curvePoints[i][2].y = 1)) and
      ((fcp.curvePoints[i][3].x = 1) and (fcp.curvePoints[i][3].y = 1))
    );
  curvesSet := not curvesSet;

  gutter_width := FBucketwidth - FOversample * fcp.Width;
//  gutter_width := 2 * ((25 - Foversample) div 2);
  if(FFilterSize <= gutter_width div 2) then // filter too big when 'post-processing' ?
    GetBucket := FGetBucket
  else
    GetBucket := SafeGetBucket;

  FBitmap.PixelFormat := pf24bit;

  sample_density := fcp.actual_density * sqr( power(2, fcp.zoom) );
  if sample_density = 0 then sample_density := 0.001;
  k1 := (fcp.Contrast * BRIGHT_ADJUST * fcp.brightness * 268 * PREFILTER_WHITE) / 256.0;
  area := FBitmap.Width * FBitmap.Height / (fcp.ppux * fcp.ppuy);
  k2 := (FOversample * FOversample) / (fcp.Contrast * area * fcp.White_level * sample_density);

  csa[0][0] := 0; csa[1][0] := 0; csa[2][0] := 0; csa[3][0] := 0;
  for i := 0 to 1024 do begin
    if i = 0 then lsa[0] := 0
    else lsa[i] := (k1 * log10(1 + fcp.White_level * i * k2)) / (fcp.White_level * i);

    if i <= 256 then begin
      csa[0][i] := BezierFunc(i / 256.0, fcp.curvePoints[0], fcp.curveWeights[0]) * 256;
      csa[1][i] := BezierFunc(i / 256.0, fcp.curvePoints[1], fcp.curveWeights[1]) * 256;
      csa[2][i] := BezierFunc(i / 256.0, fcp.curvePoints[2], fcp.curveWeights[2]) * 256;
      csa[3][i] := BezierFunc(i / 256.0, fcp.curvePoints[3], fcp.curveWeights[3]) * 256;
    end;
  end;

  ls := 0;
  ai := 0;

  ss := Trunc(floor(FOversample / 2));
  scf := (trunc(FOversample) mod 2 = 0);
  scfact := power(FOversample/(FOversample+1), 2);

  //bucketpos := 0;
  by := 0;
  for i := 0 to fcp.Height - 1 do begin
    bx := 0;

    if (i and $3f = 0) and assigned(FOnProgress) then FOnProgress(i / fcp.Height);

    AlphaRow := PByteArray(FAlphaBitmap.scanline[YOffset + i]);
    Row := PRGBArray(FBitmap.scanline[YOffset + i]);
    for j := 0 to fcp.Width - 1 do begin
      if FFilterSize > 1 then begin
        fp[0] := 0;
        fp[1] := 0;
        fp[2] := 0;
        fp[3] := 0;

        for ii := 0 to FFilterSize - 1 do begin
          for jj := 0 to FFilterSize - 1 do begin
            filterValue := FFilter[ii, jj];

            bucket := GetBucket(bx + jj, by + ii);
            if bucket.count < 1024 then
              ls := lsa[Round(bucket.Count)]
            else
              ls := (k1 * log10(1 + fcp.White_level * bucket.count * k2)) / (fcp.White_level * bucket.count);

            fp[0] := fp[0] + filterValue * ls * bucket.Red;
            fp[1] := fp[1] + filterValue * ls * bucket.Green;
            fp[2] := fp[2] + filterValue * ls * bucket.Blue;
            fp[3] := fp[3] + filterValue * ls * bucket.Count;
          end;
        end;

        fp[0] := fp[0] / PREFILTER_WHITE;
        fp[1] := fp[1] / PREFILTER_WHITE;
        fp[2] := fp[2] / PREFILTER_WHITE;
        fp[3] := fcp.white_level * fp[3] / PREFILTER_WHITE;
      end else begin
        bucket := GetBucket(bx, by);
        if bucket.count < 1024 then
          ls := lsa[Round(bucket.count)] / PREFILTER_WHITE
        else
          ls := (k1 * log10(1 + fcp.White_level * bucket.count * k2)) / (fcp.White_level * bucket.count) / PREFILTER_WHITE;

        fp[0] := ls * bucket.Red;
        fp[1] := ls * bucket.Green;
        fp[2] := ls * bucket.Blue;
        fp[3] := ls * bucket.Count * fcp.white_level;
      end;

      if (num_de_filters > 0) and (fp[3] > 0) then begin
        f_select := 0;
        for ii := -ss to trunc(ss) + 1 do
          for jj := -ss to trunc(ss) + 1 do begin
            bucket := SafeGetBucket(bx + jj, by + ii);
            f_select := f_select + (bucket.Count / 255.0);
          end;
        if (scf) then f_select := f_select * scfact;

        if (f_select > de_count_limit) then
          f_select_int := trunc(de_cutoff_val)
        else if (f_select <= 100) then
          f_select_int := trunc(ceil(f_select)) - 1
        else
          f_select_int := 100 + trunc(floor(power(f_select - 100, fcp.estimator_curve)));

        if (f_select_int >= de_cutoff_val) then
          f_select_int := trunc(de_cutoff_val);

        f_coef_idx := trunc(f_select_int*de_kernel_index);
        if (f_select_int >= 0) and (f_select_int < length(de_filter_widths)) then
          arr_filt_width := trunc(floor(de_filter_widths[length(de_filter_widths) - 1 - f_select_int]))
        else
          arr_filt_width := 1;

        fp[0] := 0;
        fp[1] := 0;
        fp[2] := 0;
        fp[3] := 0;
        acc := 1;
        
        for jj := 0 to arr_filt_width do
          for ii := 0 to arr_filt_width do begin
            bucket := SafeGetBucket(bx+ii, by+jj);

            if (f_coef_idx < 0) or (f_coef_idx >= length(de_filter_coefs)) then continue;
            if (de_filter_coefs[f_coef_idx]= 0) then begin
              Inc(f_coef_idx);
              continue;
            end;

            if bucket.count < 1024 then
              ls := lsa[Round(bucket.Count)]
            else if bucket.count = 0 then
              ls := 0
            else
              ls := (k1 * log10(1 + fcp.White_level * bucket.count * k2)) / (fcp.White_level * bucket.count);

            fp[0] := fp[0] + bucket.Red * ls * de_filter_coefs[f_coef_idx];
            fp[1] := fp[1] + bucket.Green * ls * de_filter_coefs[f_coef_idx];
            fp[2] := fp[2] + bucket.Blue * ls * de_filter_coefs[f_coef_idx];
            fp[3] := fp[3] + bucket.Count * ls * de_filter_coefs[f_coef_idx];

            Inc(acc);
            Inc(f_coef_idx);
          end;
          
        fp[0] := fp[0] * acc  / PREFILTER_WHITE;
        fp[1] := fp[1] * acc  / PREFILTER_WHITE;
        fp[2] := fp[2] * acc  / PREFILTER_WHITE;
        fp[3] := fcp.white_level * acc * fp[3] / PREFILTER_WHITE;
      end;

      Inc(bx, FOversample);

      if fcp.Transparency then begin // -------------------------- Transparency
        // gamma linearization
        if (fp[3] > 0.0) then begin
          if fp[3] <= fcp.gamma_threshold then begin
            frac := fp[3] / fcp.gamma_threshold;
            alpha := (1 - frac) * fp[3] * funcval + frac * power(fp[3], gamma);
          end
          else
            alpha := power(fp[3], gamma);

          ls := vib * alpha / fp[3];
          ai := round(alpha * 256);
          if (ai <= 0) then goto zero_alpha // ignore all if alpha = 0
          else if (ai > 255) then ai := 255;
          //ia := 255 - ai;
        end
        else begin
zero_alpha:
          Row[j] := zero_BG;
          AlphaRow[j] := 0;
          continue;
        end;

        if (notvib > 0) then begin
          ri := Round(ls * fp[0] + notvib * power(fp[0], gamma));
          gi := Round(ls * fp[1] + notvib * power(fp[1], gamma));
          bi := Round(ls * fp[2] + notvib * power(fp[2], gamma));
        end
        else begin
          ri := Round(ls * fp[0]);
          gi := Round(ls * fp[1]);
          bi := Round(ls * fp[2]);
        end;

        // ignoring BG color in transparent renders..
        if (ri >= 0) and (ri <= 256) and (curvesSet) then ri := Round(csa[1][Round(csa[0][ri])]);
        if (gi >= 0) and (gi <= 256) and (curvesSet) then gi := Round(csa[2][Round(csa[0][gi])]);
        if (bi >= 0) and (bi <= 256) and (curvesSet) then bi := Round(csa[3][Round(csa[0][bi])]);

        ri := (ri * 255) div ai; // ai > 0 !
        if (ri < 0) then ri := 0
        else if (ri > 255) then ri := 255;

        gi := (gi * 255) div ai;
        if (gi < 0) then gi := 0
        else if (gi > 255) then gi := 255;

        bi := (bi * 255) div ai;
        if (bi < 0) then bi := 0
        else if (bi > 255) then bi := 255;

        Row[j].red := ri;
        Row[j].green := gi;
        Row[j].blue := bi;
        AlphaRow[j] := ai;
      end
      else begin // ------------------------------------------- No transparency
        if (fp[3] > 0.0) then begin
          // gamma linearization
          if fp[3] <= fcp.gamma_threshold then begin
            frac := fp[3] / fcp.gamma_threshold;
            alpha := (1 - frac) * fp[3] * funcval + frac * power(fp[3], gamma);
          end
          else
            alpha := power(fp[3], gamma);

          ls := vib * alpha / fp[3];
          ai := round(alpha * 256);
          if (ai < 0) then ai := 0
          else if (ai > 255) then ai := 255;
          ia := 255 - ai;
        end
        else begin
          // no intensity so simply set the BG;
          Row[j] := bgtot;
          continue;
        end;

        if (notvib > 0) then begin
          ri := Round(ls * fp[0] + notvib * power(fp[0], gamma));
          gi := Round(ls * fp[1] + notvib * power(fp[1], gamma));
          bi := Round(ls * fp[2] + notvib * power(fp[2], gamma));
        end
        else begin
          ri := Round(ls * fp[0]);
          gi := Round(ls * fp[1]);
          bi := Round(ls * fp[2]);
        end;

        if (ri >= 0) and (ri <= 256) and (curvesSet) then ri := Round(csa[1][Round(csa[0][ri])]);
        if (gi >= 0) and (gi <= 256) and (curvesSet) then gi := Round(csa[2][Round(csa[0][gi])]);
        if (bi >= 0) and (bi <= 256) and (curvesSet) then bi := Round(csa[3][Round(csa[0][bi])]);

        ri := ri + (ia * bgi[0]) shr 8;
        if (ri < 0) then ri := 0
        else if (ri > 255) then ri := 255;

        gi := gi + (ia * bgi[1]) shr 8;
        if (gi < 0) then gi := 0
        else if (gi > 255) then gi := 255;

        bi := bi + (ia * bgi[2]) shr 8;
        if (bi < 0) then bi := 0
        else if (bi > 255) then bi := 255;

        Row[j].red := ri;
        Row[j].green := gi;
        Row[j].blue := bi;
        AlphaRow[j] := ai;//?
      end
    end;

    //Inc(bucketpos, gutter_width);
    //Inc(bucketpos, (FOversample - 1) * FBucketWidth);
    Inc(by, FOversample);
  end;

  FBitmap.PixelFormat := pf24bit;

  if assigned(FOnProgress) then FOnProgress(1);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TImageMaker.SaveImage(FileName: String);
var
  i,row: integer;
  PngObject: TPngObject;
  rowbm, rowpng: PByteArray;
  JPEGImage: TJPEGImage;
  PNGerror: boolean;
  label BMPhack;
begin
  if UpperCase(ExtractFileExt(FileName)) = '.PNG' then begin
    pngError := false;

    PngObject := TPngObject.Create;
    try
      PngObject.Assign(FBitmap);
      if fcp.Transparency then // PNGTransparency <> 0
      begin
        PngObject.CreateAlpha;
        for i:= 0 to FAlphaBitmap.Height - 1 do begin
          rowbm := PByteArray(FAlphaBitmap.scanline[i]);
          rowpng := PByteArray(PngObject.AlphaScanline[i]);
          for row := 0 to FAlphaBitmap.Width -1 do begin
            rowpng[row] := rowbm[row];
          end;
        end;
      end;
      //else Exception.CreateFmt('Unexpected value of PNGTransparency [%d]', [PNGTransparency]);

      {if (FParameters <> '') then
        PngObject.AddtEXt('Parameters', FParameters); }
      PngObject.SaveToFile(FileName);
    except
      pngError := true;
    end;
    PngObject.Free;

    if pngError then begin
      FileName := ChangeFileExt(FileName, '.bmp');
      goto BMPHack;
    end;

  end else if UpperCase(ExtractFileExt(FileName)) = '.JPG' then begin
    JPEGImage := TJPEGImage.Create;
    JPEGImage.Assign(FBitmap);
    JPEGImage.CompressionQuality := JPEGQuality;
    JPEGImage.SaveToFile(FileName);
    JPEGImage.Free;

//    with TLinearBitmap.Create do
//    try
//      Assign(Renderer.GetImage);
//      JPEGLoader.Default.Quality := JPEGQuality;
//      SaveToFile(RenderForm.FileName);
//    finally
//      Free;
//    end;
  end else begin // bitmap
BMPHack:
    FBitmap.SaveToFile(FileName);
    if fcp.Transparency then begin
      FAlphaBitmap.Palette := CreatePalette(AlphaPalette.logpal);
      FileName := ChangeFileExt(FileName, '_alpha.bmp');
      FAlphaBitmap.SaveToFile(FileName);
    end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TImageMaker.GetTransparentImage: TPngObject;
var
  x, y: integer;
  i, row: integer;
  rowbm, rowpng: PByteArray;
begin
  Result := TPngObject.Create;
  Result.Assign(FBitmap);

  if ((fcp <> nil) and fcp.Transparency) then begin
    Result.CreateAlpha;
    for i:= 0 to FAlphaBitmap.Height - 1 do begin
      rowbm := PByteArray(FAlphaBitmap.scanline[i]);
      rowpng := PByteArray(Result.AlphaScanline[i]);
      for row := 0 to FAlphaBitmap.Width - 1 do begin
        rowpng[row] := rowbm[row];
      end;
    end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////

function TImageMaker.GetBucket(x, y: integer): TBucket;
begin
  with FBuckets[y][x] do begin
    Result.Red   := Red;
    Result.Green := Green;
    Result.Blue  := Blue;
    Result.Count := Count;
  end;
end;

function TImageMaker.SafeGetBucket(x, y: integer): TBucket;
begin
  if x < 0 then x := 0
  else if x >= FBucketWidth then x := FBucketWidth-1;
  if y < 0 then y := 0
  else if y >= FBucketHeight then y := FBucketHeight-1;
  Result := FGetBucket(x, y);
end;

///////////////////////////////////////////////////////////////////////////////

procedure TImageMaker.GetBucketStats(var Stats: TBucketStats);
var
  bucketpos: integer;
  x, y: integer;
  b: TBucket;
begin
  with Stats do begin
    MaxR := 0;
    MaxG := 0;
    MaxB := 0;
    MaxA := 0;
    TotalA := 0;

    for y := 0 to FBucketHeight - 1 do
      for x := 0 to FBucketWidth - 1 do begin
        b := FGetBucket(x, y);
        MaxR := max(MaxR, b.Red);
        MaxG := max(MaxG, b.Green);
        MaxB := max(MaxB, b.Blue);
        MaxA := max(MaxA, b.Count);
        TotalA := TotalA + b.Count
      end;
  end;
end;

end.
