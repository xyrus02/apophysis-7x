{
     Flame screensaver Copyright (C) 2002 Ronald Hordijk
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Borys, Peter Sdobnov
     Apophysis Copyright (C) 2007-2008 Piotr Borys, Peter Sdobnov

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

//{$define VAR_STR}

uses
  Classes, Windows, Cmap, XForm, XFormMan;

const
  SUB_BATCH_SIZE = 10000;
  PROP_TABLE_SIZE = 1024;
  PREFILTER_WHITE = (1 shl 26);
  FILTER_CUTOFF = 1.8;
  BRIGHT_ADJUST = 2.3;
  FUSE = 15;

type
  TCoefsArray= array[0..2, 0..1] of double;
  pCoefsArray= ^TCoefsArray;
  TTriangle = record
    x: array[0..2] of double;
    y: array[0..2] of double;
  end;
  TTriangles = array[-1..NXFORMS] of TTriangle;
  TSPoint = record
    x: double;
    y: double;
  end;
  TSRect = record
    Left, Top, Right, Bottom: double;
  end;
  TMapPalette = record
    Red:   array[0..255] of byte;
    Green: array[0..255] of byte;
    Blue:  array[0..255] of byte;
  end;
  TColorMaps = record
    Identifier: string;
    UGRFile: string;
  end;
  pPixArray = ^TPixArray;
  TPixArray = array[0..1279, 0..1023, 0..3] of integer;
  pPreviewPixArray = ^TPreviewPixArray;
  TPreviewPixArray = array[0..159, 0..119, 0..3] of integer;
  TFileType = (ftIfs, ftFla, ftXML);

type //?
  PLongintArray = ^TLongintArray;
  TLongintArray = array[0..8192] of Longint;

type
  TVariation = (vLinear, vSinusoidal, vSpherical, vSwirl, vHorseshoe, vPolar,
    vHandkerchief, vHeart, vDisc, vSpiral, vHyperbolic, vSquare, vEx, vJulia,
    vBent, vWaves, vFisheye, vPopcorn, vExponential, vPower, vCosine,
    vRings, vFan, vRandom);

type
  TPointsArray = array of TCPpoint;
  //TPointsXYArray = array of TXYpoint;

  P2Cpoint = ^T2Cpoint;
  T2CPointsArray = array of T2Cpoint;

  TControlPoint = class
  public
    finalXform: TXForm;
    finalXformEnabled: boolean;
    useFinalXform: boolean;
    soloXform: integer;

    Transparency: boolean;

    xform: array[0..NXFORMS] of TXForm;

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
    actual_density: extended; // for incomplete renders
    nbatches: integer; // this much color resolution.  but making it too high induces clipping
    white_level: integer;
    cmap_inter: integer; // if this is true, then color map interpolates one entry
                      // at a time with a bright edge
    symmetry: integer;
    pulse: array[0..1, 0..1] of double; // [i][0]=magnitute [i][1]=frequency */
    wiggle: array[0..1, 0..1] of double; // frequency is /minute, assuming 30 frames/s */

    estimator, estimator_min, estimator_curve: double; // density estimator.
    jitters: integer;
    gamma_treshold: double;

//    PropTable: array of TXForm;
    FAngle: Double;
    FTwoColorDimensions: Boolean;

  private
    invalidXform: TXForm;
    
    function getppux: double;
    function getppuy: double;

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

//    class function interpolate(cp1, cp2: TControlPoint; Time: double): TControlPoint; /// just for now
    procedure InterpolateX(cp1, cp2: TControlPoint; Tm: double);
//    procedure IterateXY(NrPoints: integer; var Points: TPointsXYArray);
    procedure IterateXYC(NrPoints: integer; var Points: TPointsArray);
//    procedure IterateXYCC(NrPoints: integer; var Points: T2CPointsArray);

    procedure Prepare;
//    procedure Testiterate(NrPoints: integer; var Points: TPointsArray);

    function Clone: TControlPoint;
    procedure Copy(cp1: TControlPoint; KeepSizes: boolean = false);

//    function HasNewVariants: boolean;
    function HasFinalXForm: boolean;

    // CP-specific functions moved from unit Main
    function NumXForms: integer;
    function TrianglesFromCP(var Triangles: TTriangles): integer;
    procedure GetFromTriangles(const Triangles: TTriangles; const t: integer);

    procedure GetTriangle(var Triangle: TTriangle; const n: integer);
    procedure GetPostTriangle(var Triangle: TTriangle; const n: integer);

    procedure EqualizeWeights;
    procedure NormalizeWeights;
    procedure RandomizeWeights;
    procedure ComputeWeights(Triangles: TTriangles; t: integer);
    procedure AdjustScale(w, h: integer);

    constructor Create;
    destructor Destroy; override;

    procedure ZoomtoRect(R: TSRect);
    procedure ZoomOuttoRect(R: TSRect);
    procedure MoveRect(R: TSRect);
    procedure ZoomIn(Factor: double);
    procedure Rotate(Angle: double);

    property ppux: double read getppux;
    property ppuy: double read getppuy;
  end;

function add_symmetry_to_control_point(var cp: TControlPoint; sym: integer): integer;
function CalcUPRMagn(const cp: TControlPoint): double;
procedure FillVarDisturb;

implementation


uses
  SysUtils, math, global;

var
  var_distrib: array of integer;
  mixed_var_distrib: array of integer;

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
  for i := 0 to NXFORMS do begin
    xform[i] := TXForm.Create;
  end;
  invalidXform := TXForm.Create;
  soloXform := -1;

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

  estimator := 9.0;
  estimator_min := 0.0;
  estimator_curve := 0.4;
  jitters := 1;
  gamma_treshold := 0.01;

  FTwoColorDimensions := False;

  finalXformEnabled := false;
  Transparency := false;
end;

destructor TControlPoint.Destroy;
var
  i: Integer;
begin
  for i := 0 to NXFORMS do
    xform[i].Free;
  invalidXform.Free;

  inherited;
end;

procedure TControlPoint.Prepare;
var
  i, n: Integer;
  propsum: double;
  LoopValue: double;
  j: integer;
  TotValue: double;

  k: integer;
  tp: array[0..NXFORMS] of double;
begin
//  SetLength(PropTable, PROP_TABLE_SIZE);

  //totValue := 0;
  n := NumXforms;
  assert(n > 0);

  finalXform := xform[n];
  finalXform.Prepare;
  useFinalXform := FinalXformEnabled and HasFinalXform;
  for i := 0 to n - 1 do begin
    xform[i].Prepare;
    //totValue := totValue + xform[i].density;
  end;
  invalidXform.PrepareInvalidXForm;

  if soloXform >= 0 then begin
    for i := 0 to n - 1 do xform[i].noPlot := true;
    xform[soloXform].noPlot := false;
  end;

  for k := 0 to n - 1 do begin
    totValue := 0;
    SetLength(xform[k].PropTable, PROP_TABLE_SIZE);

    for i := 0 to n - 1 do begin
      tp[i] := xform[i].density * xform[k].modWeights[i];
      totValue := totValue + tp[i];
    end;

    if totValue > 0 then begin
     LoopValue := 0;
      for i := 0 to PROP_TABLE_SIZE-1 do begin
        propsum := 0;
        j := -1;
        repeat
          inc(j);
          propsum := propsum + tp[j];//xform[j].density;
        until (propsum > LoopValue) or (j = n - 1);

      //assert(tp[j]<>0);

        xform[k].PropTable[i] := xform[j];
        LoopValue := LoopValue + TotValue / PROP_TABLE_SIZE;
      end;
    end
    else begin
      for i := 0 to PROP_TABLE_SIZE-1 do
        xform[k].PropTable[i] := invalidXform;
    end;
  end;
end;

(*
procedure TControlPoint.IterateXY(NrPoints: integer; var Points: TPointsXYArray);
var
  i: Integer;
  px, py: double;
  pPoint: PXYPoint;

  xf: TXform;
begin
  px := 2 * random - 1;
  py := 2 * random - 1;

  try
    xf := xform[0];//random(NumXForms)];
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPointXY(px,py);
    end;

    pPoint := @Points[0];

    if UseFinalXform then
      for i := 0 to NrPoints - 1 do begin
        xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
        xf.NextPointXY(px,py);
        if xf.noPlot then
          pPoint^.x := MaxDouble // hack
        else begin
          pPoint^.X := px;
          pPoint^.Y := py;
        end;
        finalXform.NextPointXY(pPoint^.X, pPoint^.y);
        Inc(pPoint);
      end
    else
      for i := 0 to NrPoints - 1 do begin
        xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
        xf.NextPointXY(px,py);
        if xf.noPlot then
          pPoint^.x := MaxDouble // hack
        else begin
          pPoint.X := px;
          pPoint.Y := py;
        end;
        Inc(pPoint);
      end;
  except
    on EMathError do begin
      exit;
    end;
  end;
end;
*)

procedure TControlPoint.IterateXYC(NrPoints: integer; var Points: TPointsArray);
var
  i: Integer;
  p: TCPPoint;
  pPoint: PCPPoint;

  xf: TXform;
begin
{$if false}
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
{$ifend}

  try
    xf := xform[0];//random(NumXForms)];
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      if xf.RetraceXform then continue;
      xf.NextPoint(p);
    end;

    pPoint := @Points[0];

    if UseFinalXform then
      for i := 0 to NrPoints - 1 do begin
        xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
        if xf.RetraceXform then begin
          if xf.noPlot then
            pPoint^.x := MaxDouble // hack
          else begin
            xf.NextPointTo(p, pPoint^);
            finalXform.NextPoint(pPoint^);
          end;
        end
        else begin
          xf.NextPoint(p);
          if xf.noPlot then
            pPoint^.x := MaxDouble // hack
          else
            finalXform.NextPointTo(p, pPoint^);
        end;
        Inc(pPoint);
      end
    else
      for i := 0 to NrPoints - 1 do begin
        xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
        if xf.RetraceXform then begin
          if xf.noPlot then
            pPoint^.x := MaxDouble // hack
          else
            xf.NextPointTo(p, pPoint^);
        end
        else begin
          xf.NextPoint(p);
          if xf.noPlot then
            pPoint^.x := MaxDouble // hack
          else begin
            //pPoint^.x := p.x; pPoint^.y := p.y; pPoint^.c := p.c;
            pPoint^ := p;
          end;
        end;
        Inc(pPoint);
      end;
  except
    on EMathError do begin
      exit;
    end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
{
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

      PropTable[Random(PROP_TABLE_SIZE)].NextPoint(px,py,pt);
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
}

{
procedure TControlPoint.IterateXYCC(NrPoints: integer; var Points: T2CPointsArray);
var
  i: Integer;
  //px, py, pc1, pc2: double;
  p: T2CPoint;
  CurrentPoint: P2Cpoint;

  xf: TXform;
begin
  p.x := 2 * random - 1;
  p.y := 2 * random - 1;
  p.c1 := random;
  p.c2 := random;

  try
    xf := xform[random(NumXForms)];
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint2C(p);//px, py, pc1, pc2);
    end;

    CurrentPoint := @Points[0];
if UseFinalXform then
    for i := 0 to NrPoints - 1 do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint2C(p);//px, py, pc1, pc2);
      CurrentPoint.X := p.x;
      CurrentPoint.Y := p.y;
      CurrentPoint.C1 := p.c1;
      CurrentPoint.C2 := p.c2;
      finalXform.NextPoint2C(CurrentPoint^);
      Inc(CurrentPoint);
    end
else
    for i := 0 to NrPoints - 1 do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint2C(p);
      CurrentPoint.X := p.x;
      CurrentPoint.Y := p.y;
      CurrentPoint.C1 := p.c1;
      CurrentPoint.C2 := p.c2;
      Inc(CurrentPoint);
    end
  except
    on EMathError do begin
      exit;
    end;
  end;
end;
}

function TControlPoint.BlowsUp(NrPoints: integer): boolean;
var
  i, n: Integer;
  px, py: double;
  minx, maxx, miny, maxy: double;
  Points: TPointsArray; //TPointsXYArray;
  CurrentPoint: PXYPoint;

  xf: TXForm;
begin
  Result := false;

  n := min(SUB_BATCH_SIZE, NrPoints);
  SetLength(Points, n);

  px := 2 * random - 1;
  py := 2 * random - 1;

  Prepare;

  try
    xf := xform[random(NumXForms)];
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPointXY(px,py);
    end;

    CurrentPoint := @Points[0];
    for i := 0 to n-1 do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPointXY(px,py);
      CurrentPoint.X := px;
      CurrentPoint.Y := py;
      Inc(CurrentPoint);
      // random CPs don't use finalXform...
    end;
  except
    on EMathError do begin
      Result := True;
      Exit;
    end;
  end;

  // It is possible that the transformation will grow very large but remain below the overflow line
  minx := 1E10;
  maxx := -1E10;
  miny := 1E10;
  maxy := -1E10;
  for i := 0 to n-1 do begin
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
  v: double;
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
    end else if AnsiCompareText(CurrentToken, 'finalxformenabled') = 0 then begin
      Inc(ParsePos);
      finalxformenabled := StrToInt(ParseValues[ParsePos]) <> 0;
    end else if AnsiCompareText(CurrentToken, 'soloxform') = 0 then begin
      Inc(ParsePos);
      soloxform := StrToInt(ParseValues[ParsePos]);
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
    end else if AnsiCompareText(CurrentToken, 'post') = 0 then begin
      Inc(ParsePos);
      xform[CurrentXForm].p[0, 0] := StrToFloat(ParseValues[ParsePos]);
      Inc(ParsePos);
      xform[CurrentXForm].p[0, 1] := StrToFloat(ParseValues[ParsePos]);
      Inc(ParsePos);
      xform[CurrentXForm].p[1, 0] := StrToFloat(ParseValues[ParsePos]);
      Inc(ParsePos);
      xform[CurrentXForm].p[1, 1] := StrToFloat(ParseValues[ParsePos]);
      Inc(ParsePos);
      xform[CurrentXForm].p[2, 0] := StrToFloat(ParseValues[ParsePos]);
      Inc(ParsePos);
      xform[CurrentXForm].p[2, 1] := StrToFloat(ParseValues[ParsePos]);
    end else if AnsiCompareText(CurrentToken, 'postxswap') = 0 then begin
      Inc(ParsePos);
      xform[CurrentXForm].postXswap := (ParseValues[ParsePos] = '1');
    end else if AnsiCompareText(CurrentToken, 'vars') = 0 then begin
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
    end else if AnsiCompareText(CurrentToken, 'variables') = 0 then begin
{
      v := 0;
      for i:= 0 to GetNrVariableNames-1 do begin
        xform[CurrentXForm].SetVariable(GetVariableNameAt(i), v);
      end;
}
      for i:= 0 to GetNrVariableNames-1 do begin
        xform[CurrentXForm].ResetVariable(GetVariableNameAt(i));
      end;

      i := 0;
      while true do begin
        if (ParsePos + 1) >= ParseValues.Count then
          break;
        if ParseValues[ParsePos + 1][1] in ['a'..'z', 'A'..'Z'] then
          break;

        Inc(ParsePos);
        v := StrToFloat(ParseValues[ParsePos]);
        xform[CurrentXForm].SetVariable(GetVariableNameAt(i), v);
        Inc(i);
      end;

    end else if AnsiCompareText(CurrentToken, 'chaos') = 0 then begin
      i := 0;
      while true do begin
        if (ParsePos + 1) >= ParseValues.Count then
          break;
        if ParseValues[ParsePos + 1][1] in ['a'..'z', 'A'..'Z'] then
          break;

        Inc(ParsePos);
        v := StrToFloat(ParseValues[ParsePos]);
        xform[CurrentXForm].modWeights[i] := v;
        Inc(i);
      end;

    end else if AnsiCompareText(CurrentToken, 'plotmode') = 0 then begin
      Inc(ParsePos);
      xform[CurrentXForm].noPlot := (ParseValues[ParsePos] = '1');
    end else if AnsiCompareText(CurrentToken, 'retrace') = 0 then begin
      Inc(ParsePos);
      xform[CurrentXForm].RetraceXform := (ParseValues[ParsePos] = '1');
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
  FillVarDisturb;
  VarPossible := false;
  for j := 0 to NRVAR - 1 do begin
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

  FillVarDisturb;
  VarPossible := false;
  for j := 0 to NRVAR - 1 do begin
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
  Points: TPointsArray; //TPointsXYArray;
  i, j: integer;
  deltax, minx, maxx: double;
  cntminx, cntmaxx: integer;
  deltay, miny, maxy: double;
  cntminy, cntmaxy: integer;
  LimitOutSidePoints: integer;
  px, py, sina, cosa: double;
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
{    case compatibility of
      0: iterate_Old(SUB_BATCH_SIZE, points);
      1: iterateXYC(SUB_BATCH_SIZE, points);
    end;
}
    cosa := cos(FAngle);
    sina := sin(FAngle);

    Prepare;

    IterateXYC(SUB_BATCH_SIZE, points);

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
        px := points[i].x * cosa + points[i].y * sina;
        py := points[i].y * cosa - points[i].x * sina;
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
  Points: TPointsArray; //TPointsXYArray;
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
    cp.iterateXYC(SUB_BATCH_SIZE, Points);

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
      raise Exception.Create('CalcUPRMagn: ' + e.Message);
    end;
  end;
end;

(*
class function TControlPoint.Interpolate(cp1, cp2: TControlPoint; Time: double): TControlPoint;
var
  c0, c1: double;
  i, j: integer;
  r, s, t: array[0..2] of double;
//  totvar: double;
  {z,rhtime: double;}
  v1, v2: double;
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
//    for j := 0 to NRVAR - 1 do
//      Result.xform[i].vars[j] := c0 * cp1.xform[i].vars[j] + c1 * cp2.xform[i].vars[j];
    for j := 0 to NrVar-1 do
    begin
      Result.xform[i].vars[j] := c0 * cp1.xform[i].vars[j] + c1 * cp2.xform[i].vars[j];
    end;
    for j:= 0 to GetNrVariableNames-1 do begin
      cp1.xform[i].GetVariable(GetVariableNameAt(j), v1);
      cp2.xform[i].GetVariable(GetVariableNameAt(j), v2);
      v1 := c0 * v1 + c1 * v2;
      Result.xform[i].SetVariable(GetVariableNameAt(j), v1);
    end;

{
    totvar := 0;
    for j := 0 to NVARS - 1 do begin
      totvar := totvar + Result.xform[i].vars[j];
    end;
    for j := 0 to NVARS - 1 do begin
      if totVar <> 0 then Result.xform[i].vars[j] := Result.xform[i].vars[j] / totvar;
    end;
}

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
*)

procedure TControlPoint.InterpolateX(cp1, cp2: TControlPoint; Tm: double);
var
  result: TControlPoint;
  c0, c1: double;
  i, j: integer;
  r, s, t: array[0..2] of double;
  v1, v2: double;
//  totvar: double;
  {z,rhtime: double;}

  nXforms1, nXforms2: integer;
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

  // save finalxform from mut(il)ation ;)
  nXforms1 := cp1.NumXForms;
  if cp1.HasFinalXForm then
  begin
    if nXforms1 < NXFORMS then
    begin
      cp1.xform[NXFORMS].Assign(cp1.xform[nXforms1]);
      cp1.xform[nXforms1].Clear;
    end;
  end
  else begin
    cp1.xform[NXFORMS].Clear;
    cp1.xform[NXFORMS].symmetry := 1;
  end;

  nXforms2 := cp2.NumXForms;
  if cp2.HasFinalXForm then
  begin
    if nXforms2 < NXFORMS then
    begin
      cp2.xform[NXFORMS].Assign(cp2.xform[nXforms2]);
      cp2.xform[nXforms2].Clear;
    end;
  end
  else begin
    cp2.xform[NXFORMS].Clear;
    cp2.xform[NXFORMS].symmetry := 1;
  end;

  for i := 0 to NXFORMS do begin
    Result.xform[i].density := c0 * cp1.xform[i].density + c1 * cp2.xform[i].density;
    Result.xform[i].color := c0 * cp1.xform[i].color + c1 * cp2.xform[i].color;
    Result.xform[i].symmetry := c0 * cp1.xform[i].symmetry + c1 * cp2.xform[i].symmetry;
//    for j := 0 to NrVar - 1 do
//      Result.xform[i].vars[j] := c0 * cp1.xform[i].vars[j] + c1 * cp2.xform[i].vars[j];
    for j := 0 to NrVar-1 do
      Result.xform[i].vars[j] := c0 * cp1.xform[i].vars[j] + c1 * cp2.xform[i].vars[j];
    for j:= 0 to GetNrVariableNames-1 do begin
      cp1.xform[i].GetVariable(GetVariableNameAt(j), v1);
      cp2.xform[i].GetVariable(GetVariableNameAt(j), v2);
      v1 := c0 * v1 + c1 * v2;
      Result.xform[i].SetVariable(GetVariableNameAt(j), v1);
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

  // finalxform was supposed to be mutate-able too, but somehow it's always
  // getting confused by random-generated mutatns :-\
  if Result.NumXForms < NXFORMS then
  begin
    Result.xform[Result.NumXForms].Assign(cp1.xform[NXFORMS]); //result.xform[NXFORMS]);
    Result.xform[NXFORMS].Clear;
  end;
  Result.finalXformEnabled := cp1.finalXformEnabled;

  // restore finalxforms in source CPs
  if nXforms1 < NXFORMS then
  begin
    cp1.xform[nXforms1].Assign(cp1.xform[NXFORMS]);
    cp1.xform[NXFORMS].Clear;
  end;
  if nXforms2 < NXFORMS then
  begin
    cp2.xform[nXforms2].Assign(cp2.xform[NXFORMS]);
    cp2.xform[NXFORMS].Clear;
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
  i, j, k: Integer;
  s: string;
  OldDecimalSperator: Char;
  v: double;
begin
  OldDecimalSperator := DecimalSeparator;
  DecimalSeparator := '.';

  sl.add(format('time %f', [time]));
  if cmapindex >= 0 then
    sl.add(format('cmap %d', [cmapindex]));
  sl.add(format('zoom %g', [zoom])); // mt
  sl.add(format('angle %g', [FAngle]));
  sl.add(format('image_size %d %d center %g %g pixels_per_unit %f',
    [Width, Height, center[0], center[1], pixels_per_unit]));
  sl.add(format('spatial_oversample %d spatial_filter_radius %f',
    [spatial_oversample, spatial_filter_radius]));
  sl.add(format('sample_density %g', [sample_density]));
//  sl.add(format('nbatches %d white_level %d background %f %f %f', - changed to integers - mt
  sl.add(format('nbatches %d white_level %d background %d %d %d',
    [nbatches, white_level, background[0], background[1], background[2]]));
  sl.add(format('brightness %f gamma %f vibrancy %f hue_rotation %f cmap_inter %d',
    [brightness * BRIGHT_ADJUST, gamma, vibrancy, hue_rotation, cmap_inter]));
  sl.add(format('finalxformenabled %d', [ifthen(finalxformenabled, 1, 0)]));
  sl.add(format('soloxform %d', [soloXform]));

  for i := 0 to NumXForms+1 do //NXFORMS do
    with xform[i] do begin
      //if density = 0 then continue; - FinalXform has weight=0

      sl.add(format('xform %d density %g color %g symmetry %g', [i, density, color, symmetry]));
      s := 'vars';
      for j := 0 to NRVAR - 1 do begin
        s := format('%s %g', [s, vars[j]]);
      end;
      sl.add(s);
      s := 'variables';
      for j:= 0 to GetNrVariableNames-1 do begin
{$ifndef VAR_STR}
        GetVariable(GetVariableNameAt(j), v);
        s := format('%s %g', [s, v]);
{$else}
        s := s + ' ' + GetVariableStr(GetVariableNameAt(j));
{$endif}
      end;
      sl.add(s);
      sl.Add(format('coefs %.6f %.6f %.6f %.6f %.6f %.6f',
        [c[0][0], c[0][1], c[1][0], c[1][1], c[2][0], c[2][1]]));
      sl.Add(format('post %.6f %.6f %.6f %.6f %.6f %.6f',
        [p[0][0], p[0][1], p[1][0], p[1][1], p[2][0], p[2][1]]));
      if postXswap then
        sl.Add('postxswap 1')
      else
        sl.Add('postxswap 0');

      s := 'chaos';
      for j := 0 to NumXForms+1 do begin
        s := s + format(' %g', [modWeights[j]]);
      end;
      sl.Add(s);

      sl.Add(Format('plotmode %d', [Ifthen(noPlot, 1, 0)]));
      sl.Add(Format('retrace %d', [Ifthen(RetraceXform, 1, 0)]));

    end;
  DecimalSeparator := OldDecimalSperator;
end;


function TControlPoint.Clone: TControlPoint;
var
  i: integer;
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
  Result.Transparency := Transparency;

  for i := 0 to NXFORMS - 1 do
    Result.xform[i].assign(xform[i]);

  sl.Free;
end;

procedure TControlPoint.Copy(cp1: TControlPoint; KeepSizes: boolean = false);
var
  i: integer;
  sl: TStringList;
  w, h: integer;
begin
  w := Width;
  h := Height;

  Clear;
  sl := TStringList.Create;

  // --Z-- this is quite a weird and unoptimal way to copy things:
  cp1.SaveToStringlist(sl);
  ParseStringlist(sl);

  Fangle := cp1.FAngle;
  center[0]:= cp1.center[0];
  center[1]:= cp1.center[1];
  pixels_per_unit := cp1.pixels_per_unit;
  cmap := cp1.cmap;
  name := cp1.name;
  nick := cp1.nick;
  url := cp1.url;

  if KeepSizes then
    AdjustScale(w, h);

  for i := 0 to NXFORMS do // was: NXFORMS-1
    xform[i].assign(cp1.xform[i]);
  finalXformEnabled := cp1.finalXformEnabled;

  sl.Free;
end;

procedure TControlPoint.ParseStringList(sl: TStringlist);
var
  s: string;
  i: integer;
begin
  finalXformEnabled := false;
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
  cmapindex := -1;
  zoom := 0;
  for i := 0 to NXFORMS do xform[i].Clear;
  FinalXformEnabled := false;
end;

function TControlPoint.HasFinalXForm: boolean;
var
  i: integer;
begin
  with xform[NumXForms] do
  begin
    Result := (c[0,0]<>1) or (c[0,1]<>0) or (c[1,0]<>0) or (c[1,1]<>1) or (c[2,0]<>0) or (c[2,1]<>0) or
              (p[0,0]<>1) or (p[0,1]<>0) or (p[1,0]<>0) or (p[1,1]<>1) or (p[2,0]<>0) or (p[2,1]<>0) or
              (symmetry <> 1) or (vars[0] <> 1);
    if Result = false then
      for i := 1 to NRVAR-1 do Result := Result or (vars[i] <> 0);
  end;
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
//  while (k < sym) and (i < NXFORMS) do
  while (k < sym) and (i < SymmetryNVars) do
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

(*
///////////////////////////////////////////////////////////////////////////////
function TControlPoint.HasNewVariants: boolean;
var
  i,v: integer;
begin
  Result := false; // flam3 will be updated anyway :-)
{
  for i:= 0 to NXFORMS - 1 do begin
    if xform[i].density = 0 then
      break;

    for v := NRLOCVAR to NrVar - 1 do
      result := Result or (xform[i].vars[v] > 0);

    if result then
      break;
  end;
}
end;
*)

///////////////////////////////////////////////////////////////////////////////
procedure TControlPoint.ZoomtoRect(R: TSRect);
var
  scale, ppu: double;
  dx,dy: double;
begin
  scale := power(2, zoom);
  ppu := pixels_per_unit * scale;

  dx := ((r.Left + r.Right)/2 - Width/2) / ppu;
  dy := ((r.Top + r.Bottom)/2 - Height/2) / ppu;

  center[0] := center[0] + cos(FAngle) * dx - sin(FAngle) * dy;
  center[1] := center[1] + sin(FAngle) * dx + cos(FAngle) * dy;

  if PreserveQuality then
    zoom := Log2(scale * ( Width/(abs(r.Right - r.Left) + 1)))
  else
    pixels_per_unit := pixels_per_unit * Width / abs(r.Right - r.Left);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TControlPoint.ZoomOuttoRect(R: TSRect);
var
  ppu: double;
  dx, dy: double;
begin

  if PreserveQuality then
    zoom := Log2(power(2, zoom) / ( Width/(abs(r.Right - r.Left) + 1)))
  else
    pixels_per_unit := pixels_per_unit / Width * abs(r.Right - r.Left);
  ppu := pixels_per_unit * power(2, zoom);

  dx := ((r.Left + r.Right)/2 - Width/2) / ppu;
  dy := ((r.Top + r.Bottom)/2 - Height/2) / ppu;

  center[0] := center[0] - cos(FAngle) * dx + sin(FAngle) * dy;
  center[1] := center[1] - sin(FAngle) * dx - cos(FAngle) * dy;
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
procedure TControlPoint.MoveRect(R: TSRect);
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
function TControlPoint.getppux: double;
begin
  result := pixels_per_unit * power(2, zoom)
end;

///////////////////////////////////////////////////////////////////////////////
function TControlPoint.getppuy: double;
begin
  result := pixels_per_unit * power(2, zoom)
end;

///////////////////////////////////////////////////////////////////////////////
var
  vdfilled: boolean = False;

procedure FillVarDisturb;
const
  startvar_distrib: array[0..26] of integer = (-1, -1, -1, -1, -1, -1, -1, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7);
  startmixed_var_distrib: array[0..16] of integer = (0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 4, 4, 5, 6, 6, 7);
var
  i: integer;
begin
  if vdfilled then
    Exit;

  setlength(var_distrib, NRVAR + 19);
  setlength(mixed_var_distrib, NRVAR + 9);

  for i := 0 to High(startvar_distrib) do
    var_distrib[i] := startvar_distrib[i];

  for i := High(startvar_distrib) + 1 to high(var_distrib) do
    var_distrib[i] := 8 + i - High(startvar_distrib) - 1;

  for i := 0 to High(startmixed_var_distrib) do
    mixed_var_distrib[i] := startmixed_var_distrib[i];

  for i := High(startmixed_var_distrib) + 1 to high(mixed_var_distrib) do
    mixed_var_distrib[i] := 8 + i - High(startmixed_var_distrib) - 1;

  vdfilled := true;
end;

///////////////////////////////////////////////////////////////////////////////
//
// --Z-- cp-specific functions moved here from MainForm
//

function TControlPoint.NumXForms: integer;
var
  i: integer;
begin
//...
  Result := NXFORMS;
  for i := 0 to NXFORMS - 1 do
  begin
    if xform[i].density = 0 then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TControlPoint.TrianglesFromCP(var Triangles: TTriangles): integer;
{ Sets up the triangles from the IFS code }
var
  i, j: integer;
  temp_x, temp_y, xset, yset: double;
  left, top, bottom, right: double;
begin
  top := 0; bottom := 0; right := 0; left := 0;
  Result := NumXForms;
  if ReferenceMode > 0 then
  begin
    for i := 0 to Result-1 do
    begin
      xset := 1.0;
      yset := 1.0;
      for j := 0 to 5 do
      with xform[i] do begin
        temp_x := xset * c[0][0] + yset * c[1][0] + c[2][0];
        temp_y := xset * c[0][1] + yset * c[1][1] + c[2][1];
        xset := temp_x;
        yset := temp_y;
      end;
      if (i = 0) then
      begin
        left := xset;
        right := xset;
        top := yset;
        bottom := yset;
      end
      else
      begin
        if (xset < left) then left := xset;
        if (xset > right) then right := xset;
        if (yset > top) then top := yset;
        if (yset < bottom) then bottom := yset;
      end;
    end;

    if ReferenceMode = 1 then
    begin
      Triangles[-1].x[0] := right-left;
      Triangles[-1].y[0] := 0;
      Triangles[-1].x[1] := 0;
      Triangles[-1].y[1] := 0;
      Triangles[-1].x[2] := 0;
      Triangles[-1].y[2] := -(top-bottom);
    end
    else begin
      Triangles[-1].x[0] := right;
      Triangles[-1].y[0] := -bottom;
      Triangles[-1].x[1] := left;
      Triangles[-1].y[1] := -bottom;
      Triangles[-1].x[2] := left;
      Triangles[-1].y[2] := -top;
    end;
  end
  else
  begin
    Triangles[-1].x[0] := 1; Triangles[-1].y[0] := 0; // "x"
    Triangles[-1].x[1] := 0; Triangles[-1].y[1] := 0; // "0"
    Triangles[-1].x[2] := 0; Triangles[-1].y[2] := -1; // "y"
  end;

  for j := 0 to Result do
  begin
    for i := 0 to 2 do
    with xform[j] do begin
      if postXswap then begin
        Triangles[j].x[i] := Triangles[-1].x[i] * p[0][0] + Triangles[-1].y[i] * p[1][0] + p[2][0];
        Triangles[j].y[i] := Triangles[-1].x[i] * p[0][1] + Triangles[-1].y[i] * p[1][1] + p[2][1];
      end
      else begin
        Triangles[j].x[i] := Triangles[-1].x[i] * c[0][0] + Triangles[-1].y[i] * c[1][0] + c[2][0];
        Triangles[j].y[i] := Triangles[-1].x[i] * c[0][1] + Triangles[-1].y[i] * c[1][1] + c[2][1];
      end;
    end;
  end;
  EnableFinalXform := FinalXformEnabled;

  // I don't like this... :-/
  for j := -1 to Result do // was: Result-1
    for i := 0 to 2 do
      Triangles[j].y[i] := -Triangles[j].y[i];
end;

procedure TControlPoint.EqualizeWeights;
var
  t, i: integer;
begin
  t := NumXForms;
  for i := 0 to t - 1 do
    xform[i].density := 0.5;
end;

procedure TControlPoint.NormalizeWeights;
var
  i: integer;
  td: double;
begin
  td := 0.0;
  for i := 0 to NumXForms - 1 do
    td := td + xform[i].Density;
  if (td < 0.001) then
    EqualizeWeights
  else
    for i := 0 to NumXForms - 1 do
      xform[i].Density := xform[i].Density / td;
end;

procedure TControlPoint.RandomizeWeights;
var
  i: integer;
begin
  for i := 0 to Transforms - 1 do
    xform[i].Density := Random;
end;

procedure TControlPoint.ComputeWeights(Triangles: TTriangles; t: integer);
// Caclulate transform weight from triangle areas
var
  i: integer;
  total_area: double;
begin
  total_area := 0;
  for i := 0 to t - 1 do
  begin
    xform[i].Density := triangle_area(Triangles[i]);
    total_area := total_area + xform[i].Density;
  end;
  for i := 0 to t - 1 do
  begin
    xform[i].Density := xform[i].Density / total_area;
  end;
  //? cp1.NormalizeWeights;
end;

procedure TControlPoint.GetFromTriangles(const Triangles: TTriangles; const t: integer);
var
  i: integer;
begin
  for i := 0 to t do
   if xform[i].postXswap then
   begin
    solve3(Triangles[-1].x[0], -Triangles[-1].y[0], Triangles[i].x[0],
           Triangles[-1].x[1], -Triangles[-1].y[1], Triangles[i].x[1],
           Triangles[-1].x[2], -Triangles[-1].y[2], Triangles[i].x[2],
           xform[i].p[0][0],    xform[i].p[1][0],   xform[i].p[2][0]);

    solve3(Triangles[-1].x[0], -Triangles[-1].y[0], -Triangles[i].y[0],
           Triangles[-1].x[1], -Triangles[-1].y[1], -Triangles[i].y[1],
           Triangles[-1].x[2], -Triangles[-1].y[2], -Triangles[i].y[2],
           xform[i].p[0][1],    xform[i].p[1][1],    xform[i].p[2][1]);
   end
   else begin
    solve3(Triangles[-1].x[0], -Triangles[-1].y[0], Triangles[i].x[0],
           Triangles[-1].x[1], -Triangles[-1].y[1], Triangles[i].x[1],
           Triangles[-1].x[2], -Triangles[-1].y[2], Triangles[i].x[2],
           xform[i].c[0][0],    xform[i].c[1][0],   xform[i].c[2][0]);

    solve3(Triangles[-1].x[0], -Triangles[-1].y[0], -Triangles[i].y[0],
           Triangles[-1].x[1], -Triangles[-1].y[1], -Triangles[i].y[1],
           Triangles[-1].x[2], -Triangles[-1].y[2], -Triangles[i].y[2],
           xform[i].c[0][1],    xform[i].c[1][1],    xform[i].c[2][1]);
   end;
  FinalXformEnabled := EnableFinalXform;
end;

procedure TControlPoint.GetTriangle(var Triangle: TTriangle; const n: integer);
var
  i, j: integer;
begin
  for i := 0 to 2 do
  with xform[n] do begin
    Triangle.x[i] :=  MainTriangles[-1].x[i] * c[0][0] - MainTriangles[-1].y[i] * c[1][0] + c[2][0];
    Triangle.y[i] := -MainTriangles[-1].x[i] * c[0][1] + MainTriangles[-1].y[i] * c[1][1] - c[2][1];
  end;
end;

procedure TControlPoint.GetPostTriangle(var Triangle: TTriangle; const n: integer);
var
  i, j: integer;
begin
  for i := 0 to 2 do
  with xform[n] do begin
    Triangle.x[i] :=  MainTriangles[-1].x[i] * p[0][0] - MainTriangles[-1].y[i] * p[1][0] + p[2][0];
    Triangle.y[i] := -MainTriangles[-1].x[i] * p[0][1] + MainTriangles[-1].y[i] * p[1][1] - p[2][1];
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TControlPoint.AdjustScale(w, h: integer);
begin
//  if width >= height then
  pixels_per_unit := pixels_per_unit * w/width;
//  else
//    pixels_per_unit := pixels_per_unit * h/height;
  width := w;
  height := h;
end;

end.

