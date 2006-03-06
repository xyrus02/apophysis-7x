unit ImageMaker;

interface

uses
  Windows, Graphics, ControlPoint, Render;

type
  TImageMaker = class
  private
    FOversample: Integer;
    FFilterSize: Integer;
    FFilter: array of array of double;

    FBitmap: TBitmap;
    FAlphaBitmap: TBitmap;
    FTransparentImage: TBitmap;
    Fcp: Tcontrolpoint;

    FBucketWidth: integer;
    FBuckets: TBucketArray;
    FOnProgress: TOnProgress;

    procedure CreateFilter;
    procedure NormalizeFilter;
    procedure SetOnProgress(const Value: TOnProgress);

    procedure Progress(value: double);

    function GetTransparentImage: TBitmap;

    procedure CreateImage_MB(YOffset: integer = 0);
    procedure CreateImage_Flame3(YOffset: integer = 0);

  public
    destructor Destroy; override;

    function GetImage: TBitmap;

    procedure SetCP(CP: TControlPoint);
    procedure Init;
    procedure SetBucketData(const Buckets: TBucketArray; const BucketWidth: integer);

    function GetFilterSize: Integer;

    procedure CreateImage(YOffset: integer = 0);
    procedure SaveImage(const FileName: String);

    property OnProgress: TOnProgress
        read FOnProgress
       write SetOnProgress;
  end;

implementation

uses
  Math, SysUtils, PngImage, JPEG, Global, Types;

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
  for i := 0 to FFilterSize - 1 do begin
    for j := 0 to FFilterSize - 1 do begin
      ii := ((2.0 * i + 1.0)/ FFilterSize - 1.0) * adjust;
      jj := ((2.0 * j + 1.0)/ FFilterSize - 1.0) * adjust;

      FFilter[i, j] :=  exp(-2.0 * (ii * ii + jj * jj));
    end;
  end;

  Normalizefilter;
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
  if ShowTransparency then
    Result := GetTransparentImage
  else
    Result := FBitmap;
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
procedure TImageMaker.SetBucketData(const Buckets: TBucketArray; const BucketWidth: integer);
begin
  FBuckets := Buckets;
  FBucketWidth := BucketWidth;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TImageMaker.SetCP(CP: TControlPoint);
begin
  Fcp := CP;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TImageMaker.SetOnProgress(const Value: TOnProgress);
begin
  FOnProgress := Value;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TImageMaker.CreateImage(YOffset: integer);
begin
  Case PNGTransparency of
  0,1:
    CreateImage_Flame3(YOffset);
  2:
    CreateImage_MB(YOffset);
  else
    Exception.CreateFmt('Unexpected value of PNGTransparency [%d]', [PNGTransparency]);
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TImageMaker.CreateImage_Flame3(YOffset: integer);
var
  gamma: double;
  i, j: integer;
  alpha: double;
  ai, ri, gi, bi: Integer;
  bgtot: TRGB;
  ls: double;
  ii, jj: integer;
  fp: array[0..3] of double;
  Row: PRGBArray;
  AlphaRow: PbyteArray;
  vib, notvib: Integer;
  bgi: array[0..2] of Integer;
  bucketpos: Integer;
  filterValue: double;
  filterpos: Integer;
  lsa: array[0..1024] of double;
  sample_density: double;
  gutter_width: integer;
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
  bgtot.red := bgi[0];
  bgtot.green := bgi[1];
  bgtot.blue := bgi[2];

  gutter_width := FBucketwidth - FOversample * fcp.Width;
//  gutter_width := 2 * ((25 - Foversample) div 2);

  FBitmap.PixelFormat := pf24bit;

  sample_density := fcp.sample_density * power(2, fcp.zoom) * power(2, fcp.zoom);
  k1 := (fcp.Contrast * BRIGHT_ADJUST * fcp.brightness * 268 * PREFILTER_WHITE) / 256.0;
  area := FBitmap.Width * FBitmap.Height / (fcp.ppux * fcp.ppuy);
  k2 := (FOversample * FOversample) / (fcp.Contrast * area * fcp.White_level * sample_density);

  lsa[0] := 0;
  for i := 1 to 1024 do begin
    lsa[i] := (k1 * log10(1 + fcp.White_level * i * k2)) / (fcp.White_level * i);
  end;

  ls := 0;
  ai := 0;
  bucketpos := 0;
  for i := 0 to fcp.Height - 1 do begin
//    if FStop then
//      Break;

    Progress(i / fcp.Height);
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
            filterpos := bucketpos + ii * FBucketWidth + jj;

            ls := lsa[Min(1023, FBuckets[filterpos].Count)];

            fp[0] := fp[0] + filterValue * ls * FBuckets[filterpos].Red;
            fp[1] := fp[1] + filterValue * ls * FBuckets[filterpos].Green;
            fp[2] := fp[2] + filterValue * ls * FBuckets[filterpos].Blue;
            fp[3] := fp[3] + filterValue * ls * FBuckets[filterpos].Count;
          end;
        end;

        fp[0] := fp[0] / PREFILTER_WHITE;
        fp[1] := fp[1] / PREFILTER_WHITE;
        fp[2] := fp[2] / PREFILTER_WHITE;
        fp[3] := fcp.white_level * fp[3] / PREFILTER_WHITE;
      end else begin
        ls := lsa[Min(1023, FBuckets[bucketpos].count)] / PREFILTER_WHITE;

        fp[0] := ls * FBuckets[bucketpos].Red;
        fp[1] := ls * FBuckets[bucketpos].Green;
        fp[2] := ls * FBuckets[bucketpos].Blue;
        fp[3] := ls * FBuckets[bucketpos].Count * fcp.white_level;
      end;

      Inc(bucketpos, FOversample);

      if (fp[3] > 0.0) then begin
        alpha := power(fp[3], gamma);
        ls := vib * alpha / fp[3];
        ai := round(alpha * 256);
        if (ai < 0) then
          ai := 0
        else if (ai > 255) then
          ai := 255;
        ai := 255 - ai;
      end else begin
        // no intensity so simply set the BG;
        Row[j] := bgtot;
        AlphaRow[j] := 0;
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

      Row[j].red := ri;
      Row[j].green := gi;
      Row[j].blue := bi;

      AlphaRow[j] := 255 - ai;
    end;

    Inc(bucketpos, gutter_width);
    Inc(bucketpos, (FOversample - 1) * FBucketWidth);
  end;

  FBitmap.PixelFormat := pf24bit;

  Progress(1);
end;

// global variable for reuse in follong slices
var
  MaxA: int64;

///////////////////////////////////////////////////////////////////////////////
// michael baranov transparancy code from flamesong
procedure TImageMaker.CreateImage_MB(YOffset: integer);
var
  gamma: double;
  i, j: integer;
  alpha: double;
  ai, ri, gi, bi: Integer;
  bgtot: TRGB;
  ls: double;
  ii, jj: integer;
  fp: array[0..3] of double;
  Row: PRGBArray;
  AlphaRow: PbyteArray;
  vib, notvib: Integer;
  bgi: array[0..2] of Integer;
  bucketpos: Integer;
  filterValue: double;
  filterpos: Integer;
  lsa: array[0..1024] of double;
  sample_density: double;
  gutter_width: integer;
  k1, k2: double;
  area: double;
  ACount: double;
  RCount: double;
  GCount: double;
  BCount: double;
  offsetLow: double;
  offsetHigh: double;
  densLow: double;
  densHigh: double;
  divisor: double;
begin
  if fcp.gamma = 0 then
    gamma := fcp.gamma
  else
    gamma := 1 / (2* fcp.gamma);
  vib := round(fcp.vibrancy * 256.0);
  notvib := 256 - vib;

  bgi[0] := round(fcp.background[0]);
  bgi[1] := round(fcp.background[1]);
  bgi[2] := round(fcp.background[2]);
  bgtot.red := bgi[0];
  bgtot.green := bgi[1];
  bgtot.blue := bgi[2];

  gutter_width := FBucketwidth - FOversample * fcp.Width;

  sample_density := fcp.sample_density * power(2, fcp.zoom) * power(2, fcp.zoom);
  k1 := (fcp.Contrast * BRIGHT_ADJUST * fcp.brightness * 268 * PREFILTER_WHITE) / 256.0;
  area := FBitmap.Width * FBitmap.Height / (fcp.ppux * fcp.ppuy);
  k2 := (FOversample * FOversample) / (fcp.Contrast * area * fcp.White_level * sample_density);

  lsa[0] := 0;
  for i := 1 to 1024 do begin
    lsa[i] := (k1 * log10(1 + fcp.White_level * i * k2)) / (fcp.White_level * i);
  end;

  // only do this for the first slice
  // TODO: should be nicer always using a image wide value 
  if YOffset = 0 then begin
    MaxA := 0;
    bucketpos := 0;
    for i := 0 to fcp.Height - 1 do begin
      for j := 0 to fcp.Width - 1 do begin
        MaxA := Max(MaxA, FBuckets[bucketpos].Count);
        Inc(bucketpos, FOversample);
      end;
      Inc(bucketpos, gutter_width);
      Inc(bucketpos, (FOversample - 1) * FBucketWidth);
    end;
  end;

  offsetLow := 0;
  offsetHigh := 0.02;
  densLow := MaxA * offsetLow;
  densHigh := MaxA * offsetHigh;
  divisor := power(MaxA * (1 - offsethigh), Gamma);

  ls := 0;
  ai := 0;
  bucketpos := 0;
  for i := 0 to fcp.Height - 1 do begin
//    if FStop then
//      Break;

    Progress(i / fcp.Height);
    AlphaRow := PByteArray(FAlphaBitmap.scanline[YOffset + i]);
    Row := PRGBArray(FBitmap.scanline[YOffset + i]);
    for j := 0 to fcp.Width - 1 do begin
      if FFilterSize > 1 then begin
        fp[0] := 0;
        fp[1] := 0;
        fp[2] := 0;
        fp[3] := 0;
        ACount := 0;

        for ii := 0 to FFilterSize - 1 do begin
          for jj := 0 to FFilterSize - 1 do begin
            filterValue := FFilter[ii, jj];
            filterpos := bucketpos + ii * FBucketWidth + jj;

            ls := lsa[Min(1023, FBuckets[filterpos].Count)];

            fp[0] := fp[0] + filterValue * ls * FBuckets[filterpos].Red;
            fp[1] := fp[1] + filterValue * ls * FBuckets[filterpos].Green;
            fp[2] := fp[2] + filterValue * ls * FBuckets[filterpos].Blue;
            fp[3] := fp[3] + filterValue * ls * FBuckets[filterpos].Count;
            ACount := ACount + filterValue * FBuckets[filterpos].Count;
//            RCount := RCount + filterValue * FBuckets[bucketpos].Red;
//            GCount := GCount + filterValue * FBuckets[bucketpos].Green;
//            BCount := BCount + filterValue * FBuckets[bucketpos].Blue;
          end;
        end;

        fp[0] := fp[0] / PREFILTER_WHITE;
        fp[1] := fp[1] / PREFILTER_WHITE;
        fp[2] := fp[2] / PREFILTER_WHITE;
        fp[3] := fcp.white_level * fp[3] / PREFILTER_WHITE;
      end else begin
        ls := lsa[Min(1023, FBuckets[bucketpos].count)] / PREFILTER_WHITE;

        fp[0] := ls * FBuckets[bucketpos].Red;
        fp[1] := ls * FBuckets[bucketpos].Green;
        fp[2] := ls * FBuckets[bucketpos].Blue;
        fp[3] := ls * FBuckets[bucketpos].Count * fcp.white_level;
        ACount := FBuckets[bucketpos].Count;
        RCount := FBuckets[bucketpos].Red;
        GCount := FBuckets[bucketpos].Green;
        BCount := FBuckets[bucketpos].Blue;
      end;

      Inc(bucketpos, FOversample);

      if (fp[3] > 0.0) then begin
        if(divisor > 1E-12) then
          alpha := power(ACount - densLow, Gamma) / divisor
        else
          alpha := 1;

//        ls := vib * alpha;
        ls := vib * power(fp[3], gamma) / fp[3];
        ai := round(alpha * 256);
        if (ai < 0) then
          ai := 0
        else if (ai > 255) then
          ai := 255;
        ai := 255 - ai;
      end else begin
        // no intensity so simply set the BG;
        Row[j] := bgtot;
        AlphaRow[j] := 0;
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
(*

      ri := Round(RCount/ACount) + (ai * bgi[0]) shr 8;
      if (ri < 0) then
        ri := 0
      else if (ri > 255) then
        ri := 255;

      gi := Round(GCount/ACount) + (ai * bgi[1]) shr 8;
      if (gi < 0) then
        gi := 0
      else if (gi > 255) then
        gi := 255;

      bi := Round(BCount/ACount) + (ai * bgi[2]) shr 8;
      if (bi < 0) then
        bi := 0
      else if (bi > 255) then
        bi := 255;
*)
      Row[j].red := ri;
      Row[j].green := gi;
      Row[j].blue := bi;

      AlphaRow[j] := 255 - ai;
    end;

    Inc(bucketpos, gutter_width);
    Inc(bucketpos, (FOversample - 1) * FBucketWidth);
  end;

  Progress(1);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TImageMaker.SaveImage(const FileName: String);
var
  i,row: integer;
  PngObject: TPngObject;
  rowbm, rowpng: PByteArray;
  JPEGImage: TJPEGImage;
begin
  if UpperCase(ExtractFileExt(FileName)) = '.PNG' then begin
    PngObject := TPngObject.Create;
    PngObject.Assign(FBitmap);
    Case PNGTransparency of
    0:
      ; // do nothing
    1,2:
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
    else
      Exception.CreateFmt('Unexpected value of PNGTransparency [%d]', [PNGTransparency]);
    end;

    PngObject.SaveToFile(FileName);
    PngObject.Free;
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
    FBitmap.SaveToFile(FileName);
  end;

end;

///////////////////////////////////////////////////////////////////////////////
procedure TImageMaker.Progress(value: double);
begin
  if assigned(FOnprogress) then
    FOnprogress(Value);
end;

///////////////////////////////////////////////////////////////////////////////
function TImageMaker.GetTransparentImage: TBitmap;
var
  x,y: integer;
  i,row: integer;
  PngObject: TPngObject;
  rowbm, rowpng: PByteArray;
begin
  if assigned(FTransparentImage) then
    FTransparentImage.Free;

  FTransparentImage := TBitmap.Create;

  FTransparentImage.Width := Fcp.Width;
  FTransparentImage.Height := Fcp.Height;

  FTransparentImage.Canvas.Brush.Color := ClSilver;
  FTransparentImage.Canvas.FillRect(Rect(0,0,Fcp.Width, Fcp.Height));

  FTransparentImage.Canvas.Brush.Color := ClWhite;
  for x := 0 to ((Fcp.Width - 1) div 20) do begin
    for y := 0 to ((Fcp.Height - 1) div 20) do begin
      if odd(x + y) then
        FTransparentImage.Canvas.FillRect(Rect(x * 20, y * 20, x * 20 + 20, y * 20 + 20));
    end;
  end;

  PngObject := TPngObject.Create;
  PngObject.Assign(FBitmap);
  PngObject.CreateAlpha;
  for i:= 0 to FAlphaBitmap.Height - 1 do begin
    rowbm := PByteArray(FAlphaBitmap.scanline[i]);
    rowpng := PByteArray(PngObject.AlphaScanline[i]);
    for row := 0 to FAlphaBitmap.Width -1 do begin
      rowpng[row] := rowbm[row];
    end;
  end;

  PngObject.Draw(FTransparentImage.Canvas, Rect(0,0,Fcp.Width, Fcp.Height));
  PngObject.Free;

  Result := FTransparentImage;
end;

///////////////////////////////////////////////////////////////////////////////
end.
