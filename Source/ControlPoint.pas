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
unit ControlPoint;

interface

uses
  Classes, Windows, Cmap, Xform;

const
  EPS = 1E-10;
  NXFORMS = 12;
  SUB_BATCH_SIZE = 10000;
  PREFILTER_WHITE = (1 shl 26);
  FILTER_CUTOFF = 1.8;
  BRIGHT_ADJUST = 2.3;

type
  PLongintArray = ^TLongintArray;
  TLongintArray = array[0..8192] of Longint;
  TVariation = (vLinear, vSinusoidal, vSpherical, vSwirl, vHorseshoe, vPolar,
    vHandkerchief, vHeart, vDisc, vSpiral, vHyperbolic, vSquare, vEx, vJulia,
    vBent, vWaves, vFisheye, vPopcorn, vExponential, vPower, vCosine,
    vRings, vFan, vRandom);

type
  TPointsArray = array of TCPpoint;
  TPointsXYArray = array of TXYpoint;

  T2Cpoint = record
    x, y, c1, c2: double;
  end;
  P2Cpoint = ^T2Cpoint;
  T2CPointsArray = array of T2Cpoint;

  TControlPoint = class
  public
    xform: array[0..NXFORMS - 1] of TXForm;
    variation: TVariation;
    cmap: TColorMap;
    cmapindex: integer;
    time: double;
    brightness: double; // 1.0 = normal
    contrast: double; // 1.0 = normal
    gamma: double;
    Width: integer;
    Height: integer;
    spatial_oversample: integer;
      name, nick, url: string;
    center: array[0..1] of double; // camera center
    vibrancy: double; // blend between color algs (0=old,1=new)
    hue_rotation: double; // applies to cmap, 0-1
    background: array[0..3] of Integer; // Changed to integers so no conversion needed - mt
    zoom: double; // effects ppu and sample density
    pixels_per_unit: double; // and scale
    spatial_filter_radius: double; // variance of gaussian
    sample_density: extended; // samples per pixel (not bucket)
    (* in order to motion blur more accurately we compute the logs of the
      sample density many times and average the results.  we interplate
      only this many times. *)
    nbatches: integer; // this much color resolution.  but making it too high induces clipping
    white_level: integer;
    cmap_inter: integer; // if this is true, then color map interpolates one entry
                      // at a time with a bright edge
    symmetry: integer;
    pulse: array[0..1, 0..1] of double; // [i][0]=magnitute [i][1]=frequency */
    wiggle: array[0..1, 0..1] of double; // frequency is /minute, assuming 30 frames/s */

    PropTable: array of Integer;
    FAngle: Double;
    FTwoColorDimensions: Boolean;
  private
    procedure PreparePropTable;

  public
    procedure SaveToStringlist(sl: TStringlist);
    procedure SaveToFile(Filename: string);

    procedure ParseString(aString: string);
    procedure ParseStringList(sl: TStringlist);
    procedure RandomCP(min: integer = 2; max: integer = NXFORMS; calc: boolean = true);
    procedure RandomCP1;
    procedure CalcBoundbox;
    function BlowsUp(NrPoints: integer): boolean;

    procedure SetVariation(vari: TVariation);
    procedure Clear;

    class function interpolate(cp1, cp2: TControlPoint; Time: double): TControlPoint; /// just for now
    procedure InterpolateX(cp1, cp2: TControlPoint; Tm: double);
    procedure Iterate_Old(NrPoints: integer; var Points: TPointsArray);
    procedure IterateXY(NrPoints: integer; var Points: TPointsXYArray);
    procedure IterateXYC(NrPoints: integer; var Points: TPointsArray);
    procedure IterateXYCC(NrPoints: integer; var Points: T2CPointsArray);

    procedure Testiterate(NrPoints: integer; var Points: TPointsArray);

    function Clone: TControlPoint;
    procedure Copy(cp1: TControlPoint);

    function HasNewVariants: boolean;

    constructor Create;
    destructor Destroy; override;

    procedure ZoomtoRect(R: TRect);
    procedure ZoomOuttoRect(R: TRect);
    procedure ZoomIn(Factor: double);
    procedure MoveRect(R: TRect);
    procedure Rotate(Angle: double);
  end;

function add_symmetry_to_control_point(var cp: TControlPoint; sym: integer): integer;
function CalcUPRMagn(const cp: TControlPoint): double;

implementation


uses
  SysUtils, math, global;

var
  var_distrib: array[0..NRVISVAR + 18] of integer;
  mixed_var_distrib: array[0..NRVISVAR + 8] of integer;

{ TControlPoint }

function sign(n: double): double;
begin
  if n < 0 then Result := -1
  else if n > 0 then Result := 1
  else Result := 0;
end;

constructor TControlPoint.Create;
var
  i: Integer;
begin
  for i := 0 to NXFORMS - 1 do begin
    xform[i] := TXForm.Create;
  end;

  pulse[0][0] := 0;
  pulse[0][1] := 60;
  pulse[1][0] := 0;
  pulse[1][1] := 60;

  wiggle[0][0] := 0;
  wiggle[0][1] := 60;
  wiggle[1][0] := 0;
  wiggle[1][1] := 60;

  background[0] := 0;
  background[1] := 0;
  background[2] := 0;

  center[0] := 0;
  center[1] := 0;

  pixels_per_unit := 50;

  width := 100;
  Height := 100;

  spatial_oversample := 1;
  spatial_filter_radius := 0.5;

  FAngle := 0;
  gamma := 1;
  vibrancy := 1;
  contrast := 1;
  brightness := 1;

  sample_density := 50;
  zoom := 0;
  nbatches := 1;

  white_level := 200;

  FTwoColorDimensions := False;
end;

destructor TControlPoint.Destroy;
var
  i: Integer;
begin
  for i := 0 to NXFORMS - 1 do
    xform[i].Free;

  inherited;
end;

procedure TControlPoint.PreparePropTable;
var
  i: Integer;
  propsum: double;
  LoopValue: double;
  j: integer;
  TotValue: double;
begin
  SetLength(PropTable, 1024);

  totValue := 0;
  for i := 0 to NXFORMS - 1 do begin
    totValue := totValue + xform[i].density;
  end;

  LoopValue := 0;
  for i := 0 to 1023 do begin
    propsum := 0;
    j := -1;
    repeat
      inc(j);
      propsum := propsum + xform[j].density;
    until (propsum > LoopValue) or (j = NXFORMS - 1);
    PropTable[i] := j;
    LoopValue := LoopValue + TotValue / 1024;
  end;
end;

procedure TControlPoint.Iterate_Old(NrPoints: integer; var Points: TPointsArray);
var
  i: Integer;
  px, py, pc: double;
  dx, dy, tx, ty: double;
  nx, ny: double;
  r: double;
  s, v, a: double;
  n0, n1, m0, m1: double;
begin
  px := 2 * random - 1;
  py := 2 * random - 1;
  pc := random;

  PreparePropTable;

  for i := -100 to NrPoints - 1 do begin
    with xform[PropTable[Random(1024)]] do begin

      // first compute the color coord
      s := symmetry;
      pc := (pc + color) * 0.5 * (1 - s) + s * pc;

      try
        // then apply the affine part of the function
        tx := c[0][0] * px + c[1][0] * py + c[2][0];
        ty := c[0][1] * px + c[1][1] * py + c[2][1];

        px := 0;
        py := 0;

        // then add in proportional amounts of each of the variations
        if vars[0] > 0 then begin // linear
          px := px + vars[0] * tx;
          py := py + vars[0] * ty;
        end;

        if vars[1] > 0 then begin // sinusoidal
          px := px + vars[1] * sin(tx);
          py := py + vars[1] * sin(ty);
        end;

        if vars[2] > 0 then begin // complex
          r := tx * tx + ty * ty + 1E-6;
          px := px + vars[2] * tx / r;
          py := py + vars[2] * ty / r;
        end;

        if vars[3] > 0 then begin // swirl
          r := tx * tx + ty * ty;
          px := px + vars[3] * (sin(r) * tx - cos(r) * ty);
          py := py + vars[3] * (cos(r) * tx + sin(r) * ty);
        end;

        if vars[4] > 0 then begin // swirl
          if (tx < -EPS) or (tx > EPS) or (ty < -EPS) or (ty > EPS) then
            a := arctan2(tx, ty)
          else
            a := 0;
          px := px + vars[4] * (sin(a) * tx - cos(a) * ty);
          py := py + vars[4] * (cos(a) * tx + sin(a) * ty);
        end;

        if vars[5] > 0 then begin // polar
          if (tx < -EPS) or (tx > EPS) or (ty < -EPS) or (ty > EPS) then
            a := arctan2(tx, ty) / PI
          else
            a := 0;
          r := sqrt(tx * tx + ty * ty) - 1;
          px := px + vars[5] * a;
          py := py + vars[5] * r;
        end;

        if vars[6] > 0 then begin // bent
        {Draves' latest code 1.7 seems to have dropped "Bent" in
        favour of "Folded Handkerchief" but I'll keep it for
        "classic" flames and compatibility with old parameters }
          nx := tx;
          ny := ty;
          if (nx < 0) and (nx > -1E100) then nx := nx * 2;
          if ny < 0 then ny := ny / 2;
          px := px + vars[6] * nx;
          py := py + vars[6] * ny;
        end;

        if vars[7] > 0 then begin // Hart shaped box
        // Heart
          if (tx < -EPS) or (tx > EPS) or (ty < -EPS) or (ty > EPS) then
            a := arctan2(tx, ty)
          else
            a := 0;
          r := sqrt(tx * tx + ty * ty);

          px := px + vars[7] * (sin(a * r) * r);
          py := py - vars[7] * (cos(a * r) * r);
        end;

        if vars[8] > 0 then begin // The world in a sphere
        // Disc
          if (tx < -EPS) or (tx > EPS) or (ty < -EPS) or (ty > EPS) then
            a := arctan2(tx, ty)
          else
            a := 0;
          r := sqrt(tx * tx + ty * ty);
          px := px + vars[8] * (sin(r) * (a));
          py := py + vars[8] * (cos(r) * (a));
        end;

        if vars[9] > 0 then begin // Test
        // Spiral
          if (tx < -EPS) or (tx > EPS) or (ty < -EPS) or (ty > EPS) then
            a := arctan2(tx, ty)
          else
            a := 0;
          r := power(tx * tx + ty * ty, 0.5) + 1E-6;

          px := px + vars[9] * ((cos(a) + sin(r)) / r);
          py := py + vars[9] * ((sin(a) - cos(r)) / r);
        end;

        if vars[10] > 0 then begin // Test
       //* hyperbolic */
          if (tx < -EPS) or (tx > EPS) or (ty < -EPS) or (ty > EPS) then
            a := arctan2(tx, ty)
          else
            a := 0;
          r := power(tx * tx + ty * ty, 0.25) + 1E-6;
          px := px + vars[10] * (sin(a) / r);
          py := py - vars[10] * (cos(a) * r);
        end;

        v := vars[11];
        if (v > 0.0) then
        begin
         //* square */ Draves' version
          if (tx < -EPS) or (tx > EPS) or (ty < -EPS) or (ty > EPS) then
            a := arctan2(tx, ty)
          else
            a := 0.0;
          r := sqrt(tx * tx + ty * ty);
          px := px + v * sin(a) * cos(r);
          py := py + v * cos(a) * sin(r);
        end;

        v := vars[12];
        if (v > 0.0) then
        begin
         //* ex */
          if (tx < -EPS) or (tx > EPS) or (ty < -EPS) or (ty > EPS) then
            a := arctan2(tx, ty)
          else
            a := 0.0;
          r := sqrt(tx * tx + ty * ty);
          n0 := sin(a + r);
          n1 := cos(a - r);
          m0 := n0 * n0 * n0 * r;
          m1 := n1 * n1 * n1 * r;
          px := px + v * (m0 + m1);
          py := py + v * (m0 - m1);
        end;

        if vars[13] > 0 then begin // Folded hankercief
          if (tx < -EPS) or (tx > EPS) or (ty < -EPS) or (ty > EPS) then
            a := arctan2(tx, ty)
          else
            a := 0;
          r := sqrt(tx * tx + ty * ty);
          px := px + vars[13] * (sin(a + r) * r);
          py := py - vars[13] * (cos(a - r) * r);
        end;

        if vars[14] > 0 then begin // bent
        { repeat bent, just so there's something here }
          nx := tx;
          ny := ty;
          if (nx < 0) and (nx > -1E100) then nx := nx * 2;
          if ny < 0 then ny := ny / 2;
          px := px + vars[14] * nx;
          py := py + vars[14] * ny;
        end;

        if vars[15] <> 0 then
        begin
        { Waves }
          dx := c[2][0];
          dy := c[2][1];
          nx := tx + c[1][0] * sin(ty / ((dx * dx) + EPS));
          ny := ty + c[1][1] * sin(tx / ((dy * dy) + EPS));
          px := px + vars[15] * nx;
          py := py + vars[15] * ny;
        end;

        if vars[16] <> 0 then
        begin
          { fisheye }
          r := sqrt(tx * tx + ty * ty);
          a := arctan2(tx, ty);
          r := 2 * r / (r + 1);
          nx := r * cos(a);
          ny := r * sin(a);
          px := px + vars[16] * nx;
          py := py + vars[16] * ny;
        end;

        if vars[17] <> 0 then
        begin
        { Popcorn - mine from Apophysis 2.0 beta 17}
          nx := tx + c[1][0] * sin(ty + tan(3 * ty) + EPS);
          ny := ty + c[1][1] * sin(tx + tan(3 * tx) + EPS);
          px := px + vars[17] * nx;
          py := py + vars[17] * ny;
        end;


      except
        on EMathError do begin
//          raise Exception.Create('Iteration blows up');
          exit;
        end;
      end;
    end;

    // store points
    if i >= 0 then begin
      Points[i].x := px;
      Points[i].y := py;
      Points[i].c := pc;
    end
  end;
end;

procedure TControlPoint.IterateXY(NrPoints: integer; var Points: TPointsXYArray);
var
  i: Integer;
  px, py: double;
  CurrentPoint: PXYPoint;
begin
  px := 2 * random - 1;
  py := 2 * random - 1;

  PreparePropTable;

  for i := 0 to NXFORMS - 1 do
    xform[i].prepare;

  for i := -100 to NrPoints - 1 do begin
    try
      xform[PropTable[Random(1024)]].NextPointXY(px,py);
    except
      on EMathError do begin
        exit;
      end;
    end;
    // store points
    if i >= 0 then begin
      CurrentPoint := @Points[i];
      CurrentPoint.X := px;
      CurrentPoint.Y := py;
    end
  end;
end;

procedure TControlPoint.IterateXYC(NrPoints: integer; var Points: TPointsArray);
{ Variations for Draves conpatibility }
var
  i: Integer;
  px, py, pc: double;
  CurrentPoint: PCPPoint;
begin
  px := 2 * random - 1;
  py := 2 * random - 1;
  pc := random;

  PreparePropTable;

  for i := 0 to NXFORMS - 1 do
    xform[i].prepare;

  for i := -100 to NrPoints - 1 do begin
    try
      xform[PropTable[Random(1024)]].NextPoint(px,py,pc);
    except
      on EMathError do begin
        exit;
      end;
    end;
    // store points
    if i >= 0 then begin
      CurrentPoint := @Points[i];
      CurrentPoint.X := px;
      CurrentPoint.Y := py;
      CurrentPoint.C := pc;
    end
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TControlPoint.Testiterate(NrPoints: integer; var Points: TPointsArray);
var
  i: Integer;
  px, py, pc, pt: double;
  CurrentPoint: PCPPoint;
begin

  PreparePropTable;

  for i := 0 to NXFORMS - 1 do
    xform[i].prepare;

  for i := 0 to NrPoints - 1 do begin
    px := 4 * (-1 + 2 * random);
    py := 4 * (-1 + 2 * random);

    pc := 0.1 + 0.5 * sqrt(sqr(px/4)+ sqr(py/4)) ;
    if abs(px)< 0.02 then
      pc := 1 ;
    if abs(py)< 0.02 then
      pc := 1 ;
    if abs(frac(px))< 0.01 then
      pc := 1 ;
    if abs(frac(py))< 0.01 then
      pc := 1 ;
    if abs(sqrt(sqr(px/4)+ sqr(py/4)) - 0.9) < 0.02 then
      pc := 0;
    try

      xform[PropTable[Random(1024)]].NextPoint(px,py,pt);
    except
      on EMathError do begin
        exit;
      end;
    end;
    // store points
    if i >= 0 then begin
      CurrentPoint := @Points[i];
      CurrentPoint.X := px;
      CurrentPoint.Y := py;
      CurrentPoint.C := pc;
    end
  end;
end;


procedure TControlPoint.IterateXYCC(NrPoints: integer; var Points: T2CPointsArray);
var
  i: Integer;
  px, py, pc1, pc2: double;
  CurrentPoint: P2Cpoint;
begin
  px := 2 * random - 1;
  py := 2 * random - 1;
  pc1 := random;
  pc2 := random;

  PreparePropTable;

  for i := 0 to NXFORMS - 1 do
    xform[i].prepare;

  for i := -100 to NrPoints - 1 do begin
    try
      xform[PropTable[Random(1024)]].NextPoint2C(px, py, pc1, pc2);
    except
      on EMathError do begin
        exit;
      end;
    end;
    // store points
    if i >= 0 then begin
      CurrentPoint := @Points[i];
      CurrentPoint.X  := px;
      CurrentPoint.Y  := py;
      CurrentPoint.C1 := pc1;
      CurrentPoint.C2 := pc2;
    end
  end;
end;


function TControlPoint.BlowsUp(NrPoints: integer): boolean;
var
  i: Integer;
  px, py: double;
  minx, maxx, miny, maxy: double;
  Points: TPointsXYArray;
  CurrentPoint: PXYPoint;
begin
  Result := false;

  SetLength(Points, SUB_BATCH_SIZE);

  px := 2 * random - 1;
  py := 2 * random - 1;

  PreparePropTable;

  for i := 0 to NXFORMS - 1 do
    xform[i].prepare;

  for i := -100 to NrPoints - 1 do begin
    try
      xform[PropTable[Random(1024)]].NextPointXY(px,py);
      if i >= 0 then begin
        CurrentPoint := @Points[i];
        CurrentPoint.X := px;
        CurrentPoint.Y := py;
      end
    except
      on EMathError do begin
        Result := True;
        Exit;
      end;
    end;
  end;

  // It is possible that the transformation will grow very large but remain below the overflow line
  minx := 1E10;
  maxx := -1E10;
  miny := 1E10;
  maxy := -1E10;
  for i := 0 to SUB_BATCH_SIZE - 1 do begin
    minx := min(minx, Points[i].x);
    maxx := max(maxx, Points[i].x);
    miny := min(miny, Points[i].y);
    maxy := max(maxy, Points[i].y);
  end;

  if ((Maxx - MinX) > 1000) or ((Maxy - Miny) > 1000) then
    Result := True;
end;


procedure TControlPoint.ParseString(aString: string);
var
  ParseValues: TStringList;
  ParsePos: integer;
  CurrentToken: string;
  CurrentXForm: integer;
  i: integer;
  OldDecimalSperator: Char;
begin
  ParseValues := TStringList.Create;
  ParseValues.CommaText := AString;

  OldDecimalSperator := DecimalSeparator;
  DecimalSeparator := '.';

  CurrentXForm := 0;

  ParsePos := 0;
  while (ParsePos < ParseValues.Count) do begin
    CurrentToken := ParseValues[ParsePos];
    if AnsiCompareText(CurrentToken, 'xform') = 0 then begin
      Inc(ParsePos);
      CurrentXForm := StrToInt(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'time') = 0 then begin
      Inc(ParsePos);
      time := StrToFloat(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'brightness') = 0 then begin
      Inc(ParsePos);
      brightness := StrToFloat(ParseValues[ParsePos]) / BRIGHT_ADJUST;
    end else if AnsiCompareText(CurrentToken, 'zoom') = 0 then begin // mt
      Inc(ParsePos); // mt
      zoom := StrToFloat(ParseValues[ParsePos]); // mt
    end else if AnsiCompareText(CurrentToken, 'angle') = 0 then begin
      Inc(ParsePos);
      FAngle := StrToFloat(ParseValues[ParsePos]); 
    end else if AnsiCompareText(CurrentToken, 'contrast') = 0 then begin
      Inc(ParsePos);
      contrast := StrToFloat(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'gamma') = 0 then begin
      Inc(ParsePos);
      gamma := StrToFloat(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'vibrancy') = 0 then begin
      Inc(ParsePos);
      vibrancy := StrToFloat(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'hue_rotation') = 0 then begin
      Inc(ParsePos);
      hue_rotation := StrToFloat(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'zoom') = 0 then begin
      Inc(ParsePos);
      zoom := StrToFloat(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'imagesize') = 0 then begin
      Inc(ParsePos);
      Width := StrToInt(ParseValues[ParsePos]);
      Inc(ParsePos);
      Height := StrToInt(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'image_size') = 0 then begin
      Inc(ParsePos);
      Width := StrToInt(ParseValues[ParsePos]);
      Inc(ParsePos);
      Height := StrToInt(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'center') = 0 then begin
      Inc(ParsePos);
      center[0] := StrToFloat(ParseValues[ParsePos]);
      Inc(ParsePos);
      center[1] := StrToFloat(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'background') = 0 then begin
      Inc(ParsePos);
      // Trap conversion errors for older parameters
      try
        background[0] := StrToInt(ParseValues[ParsePos]);
      except on EConvertError do
          background[0] := 0;
      end;
      Inc(ParsePos);
      try
        background[1] := StrToInt(ParseValues[ParsePos]);
      except on EConvertError do
          background[1] := 0;
      end;
      Inc(ParsePos);
      try
        background[2] := StrToInt(ParseValues[ParsePos]);
      except on EConvertError do
          background[2] := 0;
      end;
    end else if AnsiCompareText(CurrentToken, 'pulse') = 0 then begin
      Inc(ParsePos);
      pulse[0, 0] := StrToFloat(ParseValues[ParsePos]);
      Inc(ParsePos);
      pulse[0, 1] := StrToFloat(ParseValues[ParsePos]);
      Inc(ParsePos);
      pulse[1, 0] := StrToFloat(ParseValues[ParsePos]);
      Inc(ParsePos);
      pulse[1, 1] := StrToFloat(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'wiggle') = 0 then begin
      Inc(ParsePos);
      wiggle[0, 0] := StrToFloat(ParseValues[ParsePos]);
      Inc(ParsePos);
      wiggle[0, 1] := StrToFloat(ParseValues[ParsePos]);
      Inc(ParsePos);
      wiggle[1, 0] := StrToFloat(ParseValues[ParsePos]);
      Inc(ParsePos);
      wiggle[1, 1] := StrToFloat(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'pixels_per_unit') = 0 then begin
      Inc(ParsePos);
      pixels_per_unit := StrToFloat(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'spatial_filter_radius') = 0 then begin
      Inc(ParsePos);
      spatial_filter_radius := StrToFloat(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'spatial_oversample') = 0 then begin
      Inc(ParsePos);
      spatial_oversample := StrToInt(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'sample_density') = 0 then begin
      Inc(ParsePos);
      sample_density := StrToFloat(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'nbatches') = 0 then begin
      Inc(ParsePos);
      nbatches := StrToInt(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'white_level') = 0 then begin
      Inc(ParsePos);
      white_level := StrToInt(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'cmap') = 0 then begin
      Inc(ParsePos);
      cmapindex := StrToInt(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'cmap_inter') = 0 then begin
      Inc(ParsePos);
      cmap_inter := StrToInt(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'palette') = 0 then begin
//      Inc(ParsePos);
//      cmapindex := StrToInt(ParseValues[ParsePos]);
      OutputDebugString(Pchar('NYI import Palette'));
    end else if AnsiCompareText(CurrentToken, 'density') = 0 then begin
      Inc(ParsePos);
      xform[CurrentXForm].Density := StrToFloat(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'color') = 0 then begin
      Inc(ParsePos);
      xform[CurrentXForm].color := StrToFloat(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'symmetry') = 0 then begin
      Inc(ParsePos);
      xform[CurrentXForm].symmetry := StrToFloat(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'coefs') = 0 then begin
      Inc(ParsePos);
      xform[CurrentXForm].c[0, 0] := StrToFloat(ParseValues[ParsePos]);
      Inc(ParsePos);
      xform[CurrentXForm].c[0, 1] := StrToFloat(ParseValues[ParsePos]);
      Inc(ParsePos);
      xform[CurrentXForm].c[1, 0] := StrToFloat(ParseValues[ParsePos]);
      Inc(ParsePos);
      xform[CurrentXForm].c[1, 1] := StrToFloat(ParseValues[ParsePos]);
      Inc(ParsePos);
      xform[CurrentXForm].c[2, 0] := StrToFloat(ParseValues[ParsePos]);
      Inc(ParsePos);
      xform[CurrentXForm].c[2, 1] := StrToFloat(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'var') = 0 then begin
      for i := 0 to NRVAR - 1 do begin
        xform[CurrentXForm].vars[i] := 0;
      end;

      i := 0;
      while true do begin
        if (ParsePos + 1) >= ParseValues.Count then
          break;
        if ParseValues[ParsePos + 1][1] in ['a'..'z', 'A'..'Z'] then
          break;

        Inc(ParsePos);
        xform[CurrentXForm].vars[i] := StrToFloat(ParseValues[ParsePos]);
        Inc(i);
      end;

    end else begin
      OutputDebugString(Pchar('Unknown Token: ' + CurrentToken));
    end;

    Inc(ParsePos);
  end;
  GetCmap(cmapindex, hue_rotation, Cmap);

  ParseValues.Free;

  DecimalSeparator := OldDecimalSperator;
end;


procedure TControlPoint.SetVariation(vari: TVariation);
var
  i, j, v: integer;
  rv: integer;
  VarPossible: boolean;
begin
  VarPossible := false;
  for j := 0 to NRVISVAR - 1 do begin
    VarPossible := VarPossible or Variations[j];
  end;

  if VarPossible then begin
    repeat
      rv := var_distrib[random(Length(var_distrib))];
    until Variations[rv];
  end else begin
    rv := 0;
  end;

  for i := 0 to NXFORMS - 1 do begin
    for j := 0 to NRVAR - 1 do begin
      xform[i].vars[j] := 0;
    end;

    if vari = vRandom then
    begin
      if rv < 0 then
      begin
        if VarPossible then begin
          repeat
            v := Mixed_var_distrib[random(Length(mixed_var_distrib))];
          until Variations[v]; // Use only Variations set in options
        end else begin
          v := 0;
        end;
        xform[i].vars[v] := 1
      end
      else
        xform[i].vars[rv] := 1;
    end
    else
      xform[i].vars[integer(vari)] := 1;
  end;
end;

procedure TControlPoint.RandomCP(min: integer = 2; max: integer = NXFORMS; calc: boolean = true);
var
  nrXforms: integer;
  i, j: integer;
  v, rv: integer;
  VarPossible: boolean;
begin
//hue_rotation := random;
  hue_rotation := 1;
  cmapindex := RANDOMCMAP;
  GetCmap(cmapindex, hue_rotation, cmap);
  time := 0.0;

//nrXforms := xform_distrib[random(13)];
  nrXforms := random(Max - (Min - 1)) + Min;

  VarPossible := false;
  for j := 0 to NRVISVAR - 1 do begin
    VarPossible := VarPossible or Variations[j];
  end;

  if VarPossible then begin
    repeat
      rv := var_distrib[random(Length(var_distrib))];
    until Variations[rv];
  end else begin
    rv := 0;
  end;

  for i := 0 to NXFORMS - 1 do begin
    xform[i].density := 0;
  end;

  for i := 0 to nrXforms - 1 do begin
    xform[i].density := 1.0 / nrXforms;
    xform[i].color := i / (nrXforms - 1);

    xform[i].c[0][0] := 2 * random - 1;
    xform[i].c[0][1] := 2 * random - 1;
    xform[i].c[1][0] := 2 * random - 1;
    xform[i].c[1][1] := 2 * random - 1;
    xform[i].c[2][0] := 4 * random - 2;
    xform[i].c[2][1] := 4 * random - 2;

    for j := 0 to NRVAR - 1 do begin
      xform[i].vars[j] := 0;
    end;

    for j := 0 to NRVAR - 1 do begin
      xform[i].vars[j] := 0;
    end;

    if rv < 0 then begin
      if VarPossible then begin
        repeat
          v := Mixed_var_distrib[random(Length(mixed_var_distrib))];
        until Variations[v]; // use only variations set in options
      end else begin
        v := 0;
      end;

      xform[i].vars[v] := 1
    end else
      xform[i].vars[rv] := 1;

  end;
  if calc then
    CalcBoundbox;
end;

procedure TControlPoint.RandomCP1;
var
  i, j: Integer;
begin
  RandomCP;
  for i := 0 to NXFORMS - 1 do begin
    for j := 0 to NRVAR - 1 do begin
      xform[i].vars[j] := 0;
    end;
    xform[i].vars[0] := 1;
  end;

  CalcBoundbox;
end;

procedure TControlPoint.CalcBoundbox;
var
  Points: TPointsArray;
  i, j: integer;
  deltax, minx, maxx: double;
  cntminx, cntmaxx: integer;
  deltay, miny, maxy: double;
  cntminy, cntmaxy: integer;
  LimitOutSidePoints: integer;
begin
{$IFDEF TESTVARIANT}
  center[0] := 0;
  center[1] := 0;
  pixels_per_unit := 0.7 * Min(width / (6), Height / (6));
  Exit;
{$ENDIF}

//  RandSeed := 1234567;
  try
    SetLength(Points, SUB_BATCH_SIZE);
    case compatibility of
      0: iterate_Old(SUB_BATCH_SIZE, points);
      1: iterateXYC(SUB_BATCH_SIZE, points);
    end;

    LimitOutSidePoints := Round(0.05 * SUB_BATCH_SIZE);

    minx := 1E99;
    maxx := -1E99;
    miny := 1E99;
    maxy := -1E99;
    for i := 0 to SUB_BATCH_SIZE - 1 do begin
      minx := min(minx, Points[i].x);
      maxx := max(maxx, Points[i].x);
      miny := min(miny, Points[i].y);
      maxy := max(maxy, Points[i].y);
    end;

    deltax := (maxx - minx) * 0.25;
    maxx := (maxx + minx) / 2;
    minx := maxx;

    deltay := (maxy - miny) * 0.25;
    maxy := (maxy + miny) / 2;
    miny := maxy;

    for j := 0 to 10 do begin
      cntminx := 0;
      cntmaxx := 0;
      cntminy := 0;
      cntmaxy := 0;
      for i := 0 to SUB_BATCH_SIZE - 1 do begin
        if (Points[i].x < minx) then Inc(cntminx);
        if (Points[i].x > maxx) then Inc(cntmaxx);
        if (Points[i].y < miny) then Inc(cntminy);
        if (Points[i].y > maxy) then Inc(cntmaxy);
      end;

      if (cntMinx < LimitOutSidePoints) then begin
        minx := minx + deltax;
      end else begin
        minx := minx - deltax;
      end;

      if (cntMaxx < LimitOutSidePoints) then begin
        maxx := maxx - deltax;
      end else begin
        maxx := maxx + deltax;
      end;

      deltax := deltax / 2;

      if (cntMiny < LimitOutSidePoints) then begin
        miny := miny + deltay;
      end else begin
        miny := miny - deltay;
      end;

      if (cntMaxy < LimitOutSidePoints) then begin
        maxy := maxy - deltay;
      end else begin
        maxy := maxy + deltay;
      end;

      deltay := deltay / 2;
    end;

    if ((maxx - minx) > 1000) or
       ((maxy - miny) > 1000) then
      raise EMathError.Create('Flame area too large');

    center[0] := (minx + maxx) / 2;
    center[1] := (miny + maxy) / 2;
    if ((maxx - minx) > 0.001) and ((maxy - miny) > 0.001) then
      pixels_per_unit := 0.65 * Min(width / (maxx - minx), Height / (maxy - miny))
    else
      pixels_per_unit := 10;
  except on E: EMathError do
    begin// default
      center[0] := 0;
      center[1] := 0;
      pixels_per_unit := 10;
    end;
  end;
end;

function CalcUPRMagn(const cp: TControlPoint): double;
var
  Points: TPointsXYArray;
  i, j: integer;
  deltax, minx, maxx: double;
  cntminx, cntmaxx: integer;
  deltay, miny, maxy: double;
  cntminy, cntmaxy: integer;
  LimitOutSidePoints: integer;
  xLength, yLength: double;
begin
  try
    SetLength(Points, SUB_BATCH_SIZE);
    cp.iterateXY(SUB_BATCH_SIZE, Points);

    LimitOutSidePoints := Round(0.05 * SUB_BATCH_SIZE);

    minx := 1E99;
    maxx := -1E99;
    miny := 1E99;
    maxy := -1E99;
    for i := 0 to SUB_BATCH_SIZE - 1 do begin
      minx := min(minx, Points[i].x);
      maxx := max(maxx, Points[i].x);
      miny := min(miny, Points[i].y);
      maxy := max(maxy, Points[i].y);
    end;

    deltax := (maxx - minx) * 0.25;
    maxx := (maxx + minx) / 2;
    minx := maxx;

    deltay := (maxy - miny) * 0.25;
    maxy := (maxy + miny) / 2;
    miny := maxy;

    for j := 0 to 10 do begin
      cntminx := 0;
      cntmaxx := 0;
      cntminy := 0;
      cntmaxy := 0;
      for i := 0 to SUB_BATCH_SIZE - 1 do begin
        if (Points[i].x < minx) then Inc(cntminx);
        if (Points[i].x > maxx) then Inc(cntmaxx);
        if (Points[i].y < miny) then Inc(cntminy);
        if (Points[i].y > maxy) then Inc(cntmaxy);
      end;

      if (cntMinx < LimitOutSidePoints) then begin
        minx := minx + deltax;
      end else begin
        minx := minx - deltax;
      end;

      if (cntMaxx < LimitOutSidePoints) then begin
        maxx := maxx - deltax;
      end else begin
        maxx := maxx + deltax;
      end;

      deltax := deltax / 2;

      if (cntMiny < LimitOutSidePoints) then begin
        miny := miny + deltay;
      end else begin
        miny := miny - deltay;
      end;

      if (cntMaxy < LimitOutSidePoints) then begin
        maxy := maxy - deltay;
      end else begin
        maxy := maxy + deltay;
      end;

      deltay := deltay / 2;
    end;

    if ((maxx - minx) > 1000) or
       ((maxy - miny) > 1000) then
      raise EMathError.Create('Flame area too large');

    cp.center[0] := (minx + maxx) / 2;
    cp.center[1] := (miny + maxy) / 2;
    if ((maxx - minx) > 0.001) and ((maxy - miny) > 0.001) then
      cp.pixels_per_unit := 0.7 * Min(cp.width / (maxx - minx), cp.height / (maxy - miny))
    else
      cp.pixels_per_unit := 10;

 // Calculate magn for UPRs
    xLength := maxx - minx;
    yLength := maxy - miny;
    if xLength >= yLength then
    begin
      result := 1 / xLength * 2;
    end
    else
    begin
      result := 1 / yLength * 2;
    end;

  except on E: EMathError do
    begin// default
      cp.center[0] := 0;
      cp.center[1] := 0;
      cp.pixels_per_unit := 10;
      raise Exception.Create('CalcUPRMagn: ' +e.Message);
    end;
  end;
end;


class function TControlPoint.interpolate(cp1, cp2: TControlPoint; Time: double): TControlPoint;
var
  c0, c1: double;
  i, j: integer;
  r, s, t: array[0..2] of double;
//  totvar: double;
  {z,rhtime: double;}
begin
  if (cp2.time - cp1.time) > 1E-6 then begin
    c0 := (cp2.time - time) / (cp2.time - cp1.time);
    c1 := 1 - c0;
  end else begin
    c0 := 1;
    c1 := 0;
  end;

  Result := TControlPoint.Create;
  Result.time := Time;

  if cp1.cmap_inter = 0 then
    for i := 0 to 255 do begin
      r[0] := cp1.cmap[i][0] / 255;
      r[1] := cp1.cmap[i][1] / 255;
      r[2] := cp1.cmap[i][2] / 255;
      rgb2hsv(r, s);
      r[0] := cp2.cmap[i][0] / 255;
      r[1] := cp2.cmap[i][1] / 255;
      r[2] := cp2.cmap[i][2] / 255;
      rgb2hsv(r, t);
      t[0] := c0 * s[0] + c1 * t[0];
      t[1] := c0 * s[1] + c1 * t[1];
      t[2] := c0 * s[2] + c1 * t[2];
      hsv2rgb(t, r);
      Result.cmap[i][0] := Round(255 * r[0]);
      Result.cmap[i][1] := Round(255 * r[1]);
      Result.cmap[i][2] := Round(255 * r[2]);
    end;

  Result.cmapindex := -1;

  Result.brightness := c0 * cp1.brightness + c1 * cp2.brightness;
  Result.contrast := c0 * cp1.contrast + c1 * cp2.contrast;
  Result.gamma := c0 * cp1.gamma + c1 * cp2.gamma;
  Result.vibrancy := c0 * cp1.vibrancy + c1 * cp2.vibrancy;
  Result.width := cp1.width;
  Result.height := cp1.height;
  Result.spatial_oversample := Round(c0 * cp1.spatial_oversample + c1 * cp2.spatial_oversample);
  Result.center[0] := c0 * cp1.center[0] + c1 * cp2.center[0];
  Result.center[1] := c0 * cp1.center[1] + c1 * cp2.center[1];
  Result.pixels_per_unit := c0 * cp1.pixels_per_unit + c1 * cp2.pixels_per_unit;
{ Apophysis doesn't interpolate background color - mt }
//  Result.background[0] := c0 * cp1.background[0] + c1 * cp2.background[0];
//  Result.background[1] := c0 * cp1.background[1] + c1 * cp2.background[1];
//  Result.background[2] := c0 * cp1.background[2] + c1 * cp2.background[2];
  Result.spatial_filter_radius := c0 * cp1.spatial_filter_radius + c1 * cp2.spatial_filter_radius;
  Result.sample_density := c0 * cp1.sample_density + c1 * cp2.sample_density;
  Result.zoom := c0 * cp1.zoom + c1 * cp2.zoom;
  Result.nbatches := Round(c0 * cp1.nbatches + c1 * cp2.nbatches);
  Result.white_level := Round(c0 * cp1.white_level + c1 * cp2.white_level);

  for i := 0 to 3 do begin
    Result.pulse[i div 2][i mod 2] := c0 * cp1.pulse[i div 2][i mod 2] + c1 * cp2.pulse[i div 2][i mod 2];
    Result.wiggle[i div 2][i mod 2] := c0 * cp1.wiggle[i div 2][i mod 2] + c1 * cp2.wiggle[i div 2][i mod 2];
  end;

  for i := 0 to NXFORMS - 1 do begin
    Result.xform[i].density := c0 * cp1.xform[i].density + c1 * cp2.xform[i].density;
    Result.xform[i].color := c0 * cp1.xform[i].color + c1 * cp2.xform[i].color;
    for j := 0 to NRVAR - 1 do begin
      Result.xform[i].vars[j] := c0 * cp1.xform[i].vars[j] + c1 * cp2.xform[i].vars[j];
    end;

(*
    totvar := 0;
    for j := 0 to NVARS - 1 do begin
      totvar := totvar + Result.xform[i].vars[j];
    end;
    for j := 0 to NVARS - 1 do begin
      if totVar <> 0 then Result.xform[i].vars[j] := Result.xform[i].vars[j] / totvar;
    end;
   *)

    // interpol matrix
    for j := 0 to 2 do begin
      Result.xform[i].c[j, 0] := c0 * cp1.xform[i].c[j, 0] + c1 * cp2.xform[i].c[j, 0];
      Result.xform[i].c[j, 1] := c0 * cp1.xform[i].c[j, 1] + c1 * cp2.xform[i].c[j, 1];
    end;

{ Remainder commented out;
    rhtime := time * 2 * PI / (60.0 * 30.0);
    // pulse
    z := 1;
    for j := 0 to 1 do begin
      z := z + Result.pulse[j, 0] * sin(Result.pulse[j, 1] * rhtime)
    end;

    for j := 0 to 2 do begin
      Result.xform[i].c[j][0] := Result.xform[i].c[j][0] * z;
      Result.xform[i].c[j][1] := Result.xform[i].c[j][1] * z;
    end;

    // wiggle
    for j := 0 to 1 do begin
      z := Result.wiggle[j,1] * rhtime;

      Result.xform[i].c[0][0] := Result.xform[i].c[0][0] + Result.wiggle[j,0] * cos(z);
      Result.xform[i].c[1][0] := Result.xform[i].c[1][0] + Result.wiggle[j,0] * -sin(z);
      Result.xform[i].c[0][1] := Result.xform[i].c[0][1] + Result.wiggle[j,0] * sin(z);
      Result.xform[i].c[1][1] := Result.xform[i].c[1][1] + Result.wiggle[j,0] * cos(z);
    end;
}
  end;
end;

procedure TControlPoint.InterpolateX(cp1, cp2: TControlPoint; Tm: double);
var
  result: TControlPoint;
  c0, c1: double;
  i, j: integer;
  r, s, t: array[0..2] of double;
//  totvar: double;
  {z,rhtime: double;}
begin
  if (cp2.time - cp1.time) > 1E-6 then begin
    c0 := (cp2.time - tm) / (cp2.time - cp1.time);
    c1 := 1 - c0;
  end else begin
    c0 := 1;
    c1 := 0;
  end;

  Result := TControlPoint.Create;
  Result.time := Tm;

  if cp1.cmap_inter = 0 then
    for i := 0 to 255 do begin
      r[0] := cp1.cmap[i][0] / 255;
      r[1] := cp1.cmap[i][1] / 255;
      r[2] := cp1.cmap[i][2] / 255;
      rgb2hsv(r, s);
      r[0] := cp2.cmap[i][0] / 255;
      r[1] := cp2.cmap[i][1] / 255;
      r[2] := cp2.cmap[i][2] / 255;
      rgb2hsv(r, t);
      t[0] := c0 * s[0] + c1 * t[0];
      t[1] := c0 * s[1] + c1 * t[1];
      t[2] := c0 * s[2] + c1 * t[2];
      hsv2rgb(t, r);
      Result.cmap[i][0] := Round(255 * r[0]);
      Result.cmap[i][1] := Round(255 * r[1]);
      Result.cmap[i][2] := Round(255 * r[2]);
    end;

  Result.cmapindex := -1;

  Result.brightness := c0 * cp1.brightness + c1 * cp2.brightness;
  Result.contrast := c0 * cp1.contrast + c1 * cp2.contrast;
  Result.gamma := c0 * cp1.gamma + c1 * cp2.gamma;
  Result.vibrancy := c0 * cp1.vibrancy + c1 * cp2.vibrancy;
  Result.width := cp1.width;
  Result.height := cp1.height;
  Result.spatial_oversample := Round(c0 * cp1.spatial_oversample + c1 * cp2.spatial_oversample);
  Result.center[0] := c0 * cp1.center[0] + c1 * cp2.center[0];
  Result.center[1] := c0 * cp1.center[1] + c1 * cp2.center[1];
  Result.pixels_per_unit := c0 * cp1.pixels_per_unit + c1 * cp2.pixels_per_unit;
//  Result.background[0] := c0 * cp1.background[0] + c1 * cp2.background[0];
//  Result.background[1] := c0 * cp1.background[1] + c1 * cp2.background[1];
//  Result.background[2] := c0 * cp1.background[2] + c1 * cp2.background[2];
  Result.spatial_filter_radius := c0 * cp1.spatial_filter_radius + c1 * cp2.spatial_filter_radius;
  Result.sample_density := c0 * cp1.sample_density + c1 * cp2.sample_density;
  Result.zoom := c0 * cp1.zoom + c1 * cp2.zoom;
  Result.nbatches := Round(c0 * cp1.nbatches + c1 * cp2.nbatches);
  Result.white_level := Round(c0 * cp1.white_level + c1 * cp2.white_level);

  for i := 0 to 3 do begin
    Result.pulse[i div 2][i mod 2] := c0 * cp1.pulse[i div 2][i mod 2] + c1 * cp2.pulse[i div 2][i mod 2];
    Result.wiggle[i div 2][i mod 2] := c0 * cp1.wiggle[i div 2][i mod 2] + c1 * cp2.wiggle[i div 2][i mod 2];
  end;

  for i := 0 to NXFORMS - 1 do begin
    Result.xform[i].density := c0 * cp1.xform[i].density + c1 * cp2.xform[i].density;
    Result.xform[i].color := c0 * cp1.xform[i].color + c1 * cp2.xform[i].color;
    Result.xform[i].symmetry := c0 * cp1.xform[i].symmetry + c1 * cp2.xform[i].symmetry;
    for j := 0 to NRVAR - 1 do begin
      Result.xform[i].vars[j] := c0 * cp1.xform[i].vars[j] + c1 * cp2.xform[i].vars[j];
    end;
(*
    totvar := 0;
    for j := 0 to NVARS - 1 do begin
      totvar := totvar + Result.xform[i].vars[j];
    end;
    for j := 0 to NVARS - 1 do begin
      if totVar <> 0 then Result.xform[i].vars[j] := Result.xform[i].vars[j] / totvar;
    end;
   *)

    // interpol matrix
    for j := 0 to 2 do begin
      Result.xform[i].c[j, 0] := c0 * cp1.xform[i].c[j, 0] + c1 * cp2.xform[i].c[j, 0];
      Result.xform[i].c[j, 1] := c0 * cp1.xform[i].c[j, 1] + c1 * cp2.xform[i].c[j, 1];
    end;
  end;
  Copy(Result);
  cmap := Result.cmap;
  result.free;
end;

procedure TControlPoint.SaveToFile(Filename: string);
var
  sl: TStringlist;
begin
  sl := TStringlist.Create;

  SaveToStringlist(sl);

  sl.SaveToFile(filename);
  sl.Free;
end;

procedure TControlPoint.SaveToStringlist(sl: TStringlist);
var
  i, j: Integer;
  s: string;
  OldDecimalSperator: Char;
begin
  OldDecimalSperator := DecimalSeparator;
  DecimalSeparator := '.';

  sl.add(format('time %f', [time]));
  if cmapindex >= 0 then
    sl.add(format('cmap %d', [cmapindex]));
  sl.add(format('zoom %f', [zoom])); // mt
  sl.add(format('angle %f', [FAngle]));
  sl.add(format('image_size %d %d center %f %f pixels_per_unit %f',
    [Width, Height, center[0], center[1], pixels_per_unit]));
  sl.add(format('spatial_oversample %d spatial_filter_radius %f',
    [spatial_oversample, spatial_filter_radius]));
  sl.add(format('sample_density %f', [sample_density]));
//  sl.add(format('nbatches %d white_level %d background %f %f %f', - changed to integers - mt
  sl.add(format('nbatches %d white_level %d background %d %d %d',
    [nbatches, white_level, background[0], background[1], background[2]]));
  sl.add(format('brightness %f gamma %f vibrancy %f hue_rotation %f cmap_inter %d',
    [brightness * BRIGHT_ADJUST, gamma, vibrancy, hue_rotation, cmap_inter]));

  for i := 0 to NXFORMS - 1 do begin
    if xform[i].density = 0 then
      Continue;

    sl.add(format('xform %d density %.3f color %f symmetry %f', [i, xform[i].density, xform[i].color, xform[i].symmetry]));
    s := 'var';
    for j := 0 to NRVAR - 1 do begin
      s := format('%s %f', [s, xform[i].vars[j]]);
    end;
    sl.add(s);
//    sl.Add(format('coefs %f %f %f %f %f %f',
    sl.Add(format('coefs %.6f %.6f %.6f %.6f %.6f %.6f',
      [xform[i].c[0][0], xform[i].c[0][1],
      xform[i].c[1][0], xform[i].c[1][1],
        xform[i].c[2][0], xform[i].c[2][1]]));
  end;

  DecimalSeparator := OldDecimalSperator;
end;


function TControlPoint.Clone: TControlPoint;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  SaveToStringlist(sl);
  Result := TControlPoint.Create;
  Result.ParseStringlist(sl);
  Result.Fangle := FAngle;
  Result.cmap := cmap;
  Result.name := name;
  Result.nick := nick;
  Result.url := url;
  sl.Free;
end;

procedure TControlPoint.Copy(cp1: TControlPoint);
var
  sl: TStringList;
begin
  Clear;
  sl := TStringList.Create;
  cp1.SaveToStringlist(sl);
  ParseStringlist(sl);
  Fangle := cp1.FAngle;
  cmap := cp1.cmap;
  name := cp1.name;
  nick := cp1.nick;
  url := cp1.url;
  sl.Free;
end;

procedure TControlPoint.ParseStringList(sl: TStringlist);
var
  s: string;
  i: integer;
begin
  for i := 0 to sl.Count - 1 do begin
    s := s + sl[i] + ' ';
  end;
  ParseString(s);
end;

procedure TControlPoint.Clear;
var
  i, j: Integer;
begin
  symmetry := 0;
  for i := 0 to NXFORMS - 1 do begin
    xform[i].density := 0;
    xform[i].symmetry := 0;
    xform[i].color := 0;
    xform[i].vars[0] := 1;
    for j := 1 to NRVAR - 1 do begin
      xform[i].vars[j] := 0;
    end;
  end;
  zoom := 0;
end;

function add_symmetry_to_control_point(var cp: TControlPoint; sym: integer): integer;
const
  sym_distrib: array[0..14] of integer = (
    -4, -3,
    -2, -2, -2,
    -1, -1, -1,
    2, 2, 2,
    3, 3,
    4, 4
    );
var
  i, j, k: integer;
  a: double;
begin
  result := 0;
  if (0 = sym) then
    if (random(1) <> 0) then
      sym := sym_distrib[random(14)]
    else if (random(32) <> 0) then // not correct
      sym := random(13) - 6
    else
      sym := random(51) - 25;

  if (1 = sym) or (0 = sym) then
  begin
    result := 0;
    exit;
  end;

  for i := 0 to NXFORMS - 1 do
    if (cp.xform[i].density = 0.0) then break;

  if (i = NXFORMS) then
  begin
    result := 0;
    exit;
  end;
  cp.symmetry := sym;

  if (sym < 0) then
  begin
    cp.xform[i].density := 1.0;
    cp.xform[i].symmetry := 1;
    cp.xform[i].vars[0] := 1.0;
    for j := 1 to NRVAR - 1 do
      cp.xform[i].vars[j] := 0;
    cp.xform[i].color := 1.0;
    cp.xform[i].c[0][0] := -1.0;
    cp.xform[i].c[0][1] := 0.0;
    cp.xform[i].c[1][0] := 0.0;
    cp.xform[i].c[1][1] := 1.0;
    cp.xform[i].c[2][0] := 0.0;
    cp.xform[i].c[2][1] := 0.0;

    inc(i);
    inc(result);
    sym := -sym;
  end;

  a := 2 * PI / sym;

//  for (k = 1; (k < sym)&&(i < NXFORMS); k + + ) {
  k := 1;
  while (k < sym) and (i < NXFORMS) do
  begin
    cp.xform[i].density := 1.0;
    cp.xform[i].vars[0] := 1.0;
    cp.xform[i].symmetry := 1;
    for j := 1 to NRVAR - 1 do
      cp.xform[i].vars[j] := 0;
    if sym < 3 then
      cp.xform[i].color := 0
    else
      cp.xform[i].color := (k - 1) / (sym - 2);

    if cp.xform[i].color > 1 then
    begin
//      ShowMessage('Color value larger than 1');
      repeat
        cp.xform[i].color := cp.xform[i].color - 1
      until cp.xform[i].color <= 1;
    end;

    cp.xform[i].c[0][0] := cos(k * a);
    cp.xform[i].c[0][1] := sin(k * a);
    cp.xform[i].c[1][0] := -cp.xform[i].c[0][1];
    cp.xform[i].c[1][1] := cp.xform[i].c[0][0];
    cp.xform[i].c[2][0] := 0.0;
    cp.xform[i].c[2][1] := 0.0;

    inc(i);
    inc(result);
    inc(k);
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TControlPoint.HasNewVariants: boolean;
var
  i: integer;
begin
  Result := false;

  for i:= 0 to NXFORMS -1 do begin
    if (xform[i].vars[18] > 0) or
       (xform[i].vars[19] > 0) or
       (xform[i].vars[20] > 0) or
       (xform[i].vars[21] > 0) then begin
      Result := True;
      Exit;
    end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TControlPoint.ZoomtoRect(R: TRect);
var
  scale: double;
  ppux, ppuy: double;
  dx,dy: double;
begin
  scale := power(2, zoom);
  ppux := pixels_per_unit * scale;
  ppuy := pixels_per_unit * scale;

  dx := ((r.Left + r.Right)/2 - Width/2)/ppux ;
  dy := ((r.Top + r.Bottom)/2 - Height/2)/ppuy;

  center[0] := center[0] + cos(FAngle) * dx - sin(FAngle) * dy;
  center[1] := center[1] + sin(FAngle) * dx + cos(FAngle) * dy ;

  Scale := Scale * Min( Width/(abs(r.Right - r.Left) + 1), Height/(abs(r.Bottom - r.Top) + 1)) ;
  Zoom := Log2(Scale);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TControlPoint.ZoomOuttoRect(R: TRect);
var
  scale: double;
  ppux, ppuy: double;
  dx,dy: double;
begin
  scale := power(2, zoom);
  ppux := pixels_per_unit * scale;
  ppuy := pixels_per_unit * scale;

  dx := ((r.Left + r.Right)/2 - Width/2)/ppux ;
  dy := ((r.Top + r.Bottom)/2 - Height/2)/ppuy;

  center[0] := center[0] + cos(FAngle) * dx - sin(FAngle) * dy;
  center[1] := center[1] + sin(FAngle) * dx + cos(FAngle) * dy ;

  Scale := Scale / Min( Width/(abs(r.Right - r.Left) + 1), Height/(abs(r.Bottom - r.Top) + 1)) ;
  Zoom := Log2(Scale);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TControlPoint.ZoomIn(Factor: double);
var
  scale: double;
begin
  scale := power(2, zoom);

  Scale := Scale / Factor;
  Zoom := Log2(Scale);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TControlPoint.MoveRect(R: TRect);
var
  scale: double;
  ppux, ppuy: double;
  dx,dy: double;
begin
  scale := power(2, zoom);
  ppux := pixels_per_unit * scale;
  ppuy := pixels_per_unit * scale;

  dx := (r.Left - r.Right)/ppux;
  dy := (r.Top - r.Bottom)/ppuy;

  center[0] := center[0] + cos(FAngle) * dx - sin(FAngle) * dy;
  center[1] := center[1] + sin(FAngle) * dx + cos(FAngle) * dy ;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TControlPoint.Rotate(Angle: double);
begin
  FAngle := FAngle + Angle;
end;

///////////////////////////////////////////////////////////////////////////////
procedure FillVarDisturb;
const
  startvar_distrib: array[0..26] of integer = (-1, -1, -1, -1, -1, -1, -1, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7);
  startmixed_var_distrib: array[0..16] of integer = (0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 4, 4, 5, 6, 6, 7);
var
  i: integer;
begin
  for i := 0 to High(startvar_distrib) do
    var_distrib[i] := startvar_distrib[i];

  for i := High(startvar_distrib) + 1 to high(var_distrib) do
    var_distrib[i] := 8 + i - High(startvar_distrib) - 1;

  for i := 0 to High(startmixed_var_distrib) do
    mixed_var_distrib[i] := startmixed_var_distrib[i];

  for i := High(startmixed_var_distrib) + 1 to high(mixed_var_distrib) do
    mixed_var_distrib[i] := 8 + i - High(startmixed_var_distrib) - 1;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  FillVarDisturb
end.

