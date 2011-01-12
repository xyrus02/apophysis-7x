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
unit RndFlame;

interface

uses
  ControlPoint, Xform;

function RandomFlame(SourceCP: TControlPoint= nil; algorithm: integer = 0): TControlPoint;

implementation

uses
  SysUtils, Global, cmap, GradientHlpr, XFormMan, Classes;

///////////////////////////////////////////////////////////////////////////////
procedure RGBBlend(a, b: integer; var Palette: TColorMap);
{ Linear blend between to indices of a palette }
var
  c, v: real;
  vrange, range: real;
  i: integer;
begin
  if a = b then
  begin
    Exit;
  end;
  range := b - a;
  vrange := Palette[b mod 256][0] - Palette[a mod 256][0];
  c := Palette[a mod 256][0];
  v := vrange / range;
  for i := (a + 1) to (b - 1) do
  begin
    c := c + v;
    Palette[i mod 256][0] := Round(c);
  end;
  vrange := Palette[b mod 256][1] - Palette[a mod 256][1];
  c := Palette[a mod 256][1];
  v := vrange / range;
  for i := a + 1 to b - 1 do
  begin
    c := c + v;
    Palette[i mod 256][1] := Round(c);
  end;
  vrange := Palette[b mod 256][2] - Palette[a mod 256][2];
  c := Palette[a mod 256][2];
  v := vrange / range;
  for i := a + 1 to b - 1 do
  begin
    c := c + v;
    Palette[i mod 256][2] := Round(c);
  end;
end;

function CreatePalette(strng: string): TColorMap;
{ Loads a palette from a gradient string }
var
  Strings: TStringList;
  index, i: integer;
  Tokens: TStringList;
  Indices, Colors: TStringList;
  a, b: integer;
begin
  Strings := TStringList.Create;
  Tokens := TStringList.Create;
  Indices := TStringList.Create;
  Colors := TStringList.Create;
  try
    try
      Strings.Text := strng;
      if Pos('}', Strings.Text) = 0 then raise EFormatInvalid.Create('No closing brace');
      if Pos('{', Strings[0]) = 0 then raise EFormatInvalid.Create('No opening brace.');
      GetTokens(ReplaceTabs(strings.text), tokens);
      Tokens.Text := Trim(Tokens.text);
      i := 0;
      while (Pos('}', Tokens[i]) = 0) and (Pos('opacity:', Lowercase(Tokens[i])) = 0) do
      begin
        if Pos('index=', LowerCase(Tokens[i])) <> 0 then
          Indices.Add(GetVal(Tokens[i]))
        else if Pos('color=', LowerCase(Tokens[i])) <> 0 then
          Colors.Add(GetVal(Tokens[i]));
        inc(i)
      end;
      for i := 0 to 255 do
      begin
        Result[i][0] := 0;
        Result[i][1] := 0;
        Result[i][2] := 0;
      end;
      if Indices.Count = 0 then raise EFormatInvalid.Create('No color info');
      for i := 0 to Indices.Count - 1 do
      begin
       try
        index := StrToInt(Indices[i]);
        while index < 0 do inc(index, 400);
        index := Round(Index * (255 / 399));
        indices[i] := IntToStr(index);
        assert(index>=0);
        assert(index<256);
        Result[index][0] := StrToInt(Colors[i]) mod 256;
        Result[index][1] := trunc(StrToInt(Colors[i]) / 256) mod 256;
        Result[index][2] := trunc(StrToInt(Colors[i]) / 65536);
       except
       end;
      end;
      i := 1;
      repeat
        a := StrToInt(Trim(Indices[i - 1]));
        b := StrToInt(Trim(Indices[i]));
        RGBBlend(a, b, Result);
        inc(i);
      until i = Indices.Count;
      if (Indices[0] <> '0') or (Indices[Indices.Count - 1] <> '255') then
      begin
        a := StrToInt(Trim(Indices[Indices.Count - 1]));
        b := StrToInt(Trim(Indices[0])) + 256;
        RGBBlend(a, b, Result);
      end;
    except on EFormatInvalid do
      begin
//        Result := False;
      end;
    end;
  finally
    Tokens.Free;
    Strings.Free;
    Indices.Free;
    Colors.Free;
  end;
end;

procedure GetGradientFileGradientsNames(const filename: string; var NamesList: TStringList);
var
  i, p: integer;
  Title: string;
  FStrings: TStringList;
begin
  FStrings := TStringList.Create;
  FStrings.LoadFromFile(filename);
  try
    if (Pos('{', FStrings.Text) <> 0) then
    begin
      for i := 0 to FStrings.Count - 1 do
      begin
        p := Pos('{', FStrings[i]);
        if (p <> 0) and (Pos('(3D)', FStrings[i]) = 0) then
        begin
          Title := Trim(Copy(FStrings[i], 1, p - 1));
          if Title <> '' then
            NamesList.Add(Trim(Copy(FStrings[i], 1, p - 1)));
        end;
      end;
    end;
  finally
    FStrings.Free;
  end;
end;

procedure RandomGradient(SourceCP, DestCP: TControlPoint);
var
  tmpGrad: string;
  tmpGrdList: TStringList;
begin
  case randGradient of
    0:
      begin
        cmap_index := Random(NRCMAPS);
        GetCMap(cmap_index, 1, DestCP.cmap);
//        cmap_index := DestCP.cmapindex;
        DestCP.cmapIndex := cmap_index;
      end;
    1:
      begin
        DestCP.cmap := DefaultPalette;
        DestCP.cmapIndex := cmap_index;
      end;
    2:
      if assigned(SourceCP) then begin
        DestCP.cmap := SourceCP.cmap;
        DestCP.cmapIndex := SourceCP.cmapIndex;
      end else begin
        cmap_index := Random(NRCMAPS);
        GetCMap(cmap_index, 1, DestCP.cmap);
        DestCP.cmapIndex := cmap_index;
      end;
    3:
      DestCP.cmap := GradientHelper.RandomGradient;
    4:
      if FileExists(randGradientFile) then
      begin
        tmpGrdList := TStringList.Create;
        GetGradientFileGradientsNames(randGradientFile, tmpGrdList);
        tmpGrad := GetGradient(randGradientFile, tmpGrdList.Strings[random(tmpGrdList.Count)]);
        DestCP.cmap := CreatePalette(tmpGrad);
        tmpGrdList.Free;
      end else
      begin
        cmap_index := Random(NRCMAPS);
        GetCMap(cmap_index, 1, DestCP.cmap);
        DestCP.cmapIndex := cmap_index;
      end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure RandomVariation(cp: TControlPoint);
{ Randomise variation parameters }
var
  a, b, i, j: integer;
  VarPossible: boolean;
begin
  inc(MainSeed);
  RandSeed := MainSeed;

  VarPossible := false;
  for j := 0 to NRVAR - 1 do begin
    VarPossible := VarPossible or Variations[j];
  end;

  for i := 0 to cp.NumXForms - 1 do begin
    for j := 0 to NRVAR - 1 do
      cp.xform[i].SetVariation(j, 0);

    if VarPossible then begin
      repeat
        a := random(NRVAR);
      until Variations[a];

      repeat
        b := random(NRVAR);
      until Variations[b];
    end else begin
      a := 0;
      b := 0;
    end;

    if (a = b) then begin
      cp.xform[i].SetVariation(a, 1);
    end else begin
      cp.xform[i].SetVariation(a, random);
      cp.xform[i].SetVariation(b, 1 - cp.xform[i].GetVariation(a));
    end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure SetVariation(cp: TControlPoint);
{ Set the current Variation }
var
  i, j: integer;
begin
  if Variation = vRandom then begin
    RandomVariation(cp);
  end else
    for i := 0 to cp.NumXForms - 1 do  begin
      for j := 0 to NRVAR - 1 do
        cp.xform[i].SetVariation(j, 0);
      cp.xform[i].SetVariation(integer(Variation), 1);
    end;
end;

///////////////////////////////////////////////////////////////////////////////
(* --Z-- hmm, exactly the same function exists in module Main

function TrianglesFromCP(const cp1: TControlPoint; var Triangles: TTriangles): integer;
{ Sets up the triangles from the IFS code }
var
  xforms: integer;
  i, j: integer;
  temp_x, temp_y, xset, yset: double;
  left, top, bottom, right: double;
  a, b, c, d, e, f: double;
begin
  top := 0; bottom := 0; right := 0; left := 0;
  xforms := NumXForms(cp1);
  Result := xforms;
  if not FixedReference then
  begin
    for i := 0 to xforms - 1 do
    begin
      a := cp1.xform[i].c[0][0];
      b := cp1.xform[i].c[0][1];
      c := cp1.xform[i].c[1][0];
      d := cp1.xform[i].c[1][1];
      e := cp1.xform[i].c[2][0];
      f := cp1.xform[i].c[2][1];
      xset := 1.0;
      yset := 1.0;
      for j := 0 to 5 do
      begin
        temp_x := xset * a + yset * c + e;
        temp_y := xset * b + yset * d + f;
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
        if (yset < top) then top := yset;
        if (yset > bottom) then bottom := yset;
      end;
    end;
    Triangles[-1].x[0] := left;
    Triangles[-1].x[1] := right;
    Triangles[-1].x[2] := right;
    Triangles[-1].y[0] := bottom;
    Triangles[-1].y[1] := bottom;
    Triangles[-1].y[2] := top;
  end
  else
  begin
    Triangles[-1].x[0] := 0; Triangles[-1].y[0] := 0;
    Triangles[-1].x[1] := 1; Triangles[-1].y[1] := 0;
    Triangles[-1].x[2] := 1; Triangles[-1].y[2] := 1.5;
  end;

  for j := 0 to xforms - 1 do
  begin
    a := cp1.xform[j].c[0][0];
    b := cp1.xform[j].c[0][1];
    c := cp1.xform[j].c[1][0];
    d := cp1.xform[j].c[1][1];
    e := cp1.xform[j].c[2][0];
    f := cp1.xform[j].c[2][1];
    for i := 0 to 2 do
    begin
      triangles[j].x[i] := Triangles[-1].x[i] * a + Triangles[-1].y[i] *
        c + e;
      triangles[j].y[i] := Triangles[-1].x[i] * b + Triangles[-1].y[i] *
        d + f;
    end;
  end;
  for i := -1 to xforms - 1 do
    for j := 0 to 2 do
      triangles[i].y[j] := -triangles[i].y[j];
end;
*)

///////////////////////////////////////////////////////////////////////////////
procedure EqualizeWeights(var cp: TControlPoint);
var
  t, i: integer;
begin
  t := cp.NumXForms;
  for i := 0 to t - 1 do
    cp.xform[i].density := 1.0 / t;
end;

///////////////////////////////////////////////////////////////////////////////
procedure NormalizeWeights(var cp: TControlPoint);
var
  i: integer;
  td: double;
begin
  td := 0.0;
  for i := 0 to cp.NumXForms - 1 do
    td := td + cp.xform[i].Density;
  if (td < 0.001) then
    EqualizeWeights(cp)
  else
    for i := 0 to cp.NumXForms - 1 do
      cp.xform[i].Density := cp.xform[i].Density / td;
end;

///////////////////////////////////////////////////////////////////////////////
procedure ComputeWeights(var cp1: TControlPoint; Triangles: TTriangles; t: integer);
{ Caclulates transform weight from triangles }
var
  i: integer;
  total_area: double;
begin
  total_area := 0.0;
  for i := 0 to t - 1 do
  begin
    cp1.xform[i].Density := triangle_area(Triangles[i]);
    total_area := total_area + cp1.xform[i].Density;
  end;
  for i := 0 to t - 1 do
  begin
    cp1.xform[i].Density := cp1.xform[i].Density / total_area;
  end;
  NormalizeWeights(cp1);
end;

///////////////////////////////////////////////////////////////////////////////
procedure RandomWeights(var cp1: TControlPoint);
{ Randomizes xform weights }
var
  i: integer;
begin
  for i := 0 to Transforms - 1 do
    cp1.xform[i].Density := random;
  NormalizeWeights(cp1);
end;

///////////////////////////////////////////////////////////////////////////////
function RandomFlame(SourceCP: TControlPoint; algorithm: integer): TControlPoint;
var
  Min, Max, i, j, rnd: integer;
  Triangles: TTriangles;
  r, s, theta, phi: double;
  skip: boolean;
begin
  if Assigned(SourceCP) then
    Result := SourceCP.clone
  else
    Result := TControlPoint.Create;

  Min := randMinTransforms;
  Max := randMaxTransforms;

  inc(MainSeed);
  RandSeed := MainSeed;
  transforms := random(Max - (Min - 1)) + Min;
  repeat
    try
      inc(MainSeed);
      RandSeed := MainSeed;
      Result.clear;
      Result.RandomCP(transforms, transforms, false);
      Result.SetVariation(Variation);
      inc(MainSeed);
      RandSeed := MainSeed;

      case algorithm of
        1: rnd := 0;
        2: rnd := 7;
        3: rnd := 9;
      else
        if (Variation = vLinear) or (Variation = vRandom) then
          rnd := random(10)
        else
          rnd := 9;
      end;
      case rnd of
        0..6:
          begin
            for i := 0 to Transforms - 1 do
            begin
              if Random(10) < 9 then
                Result.xform[i].c[0, 0] := 1
              else
                Result.xform[i].c[0, 0] := -1;
              Result.xform[i].c[0, 1] := 0;
              Result.xform[i].c[1, 0] := 0;
              Result.xform[i].c[1, 1] := 1;
              Result.xform[i].c[2, 0] := 0;
              Result.xform[i].c[2, 1] := 0;
              Result.xform[i].color := 0;
              Result.xform[i].symmetry := 0;
              Result.xform[i].SetVariation(0, 1);
              for j := 1 to NRVAR - 1 do
                Result.xform[i].SetVariation(j, 0);
              Result.xform[i].Translate(random * 2 - 1, random * 2 - 1);
              Result.xform[i].Rotate(random * 360);
              if i > 0 then
                Result.xform[i].Scale(random * 0.8 + 0.2)
              else
                Result.xform[i].Scale(random * 0.4 + 0.6);
              if Random(2) = 0 then
                Result.xform[i].Multiply(1, random - 0.5, random - 0.5, 1);
            end;
            SetVariation(Result);
          end;
        7, 8:
          begin
          { From the source to Chaos: The Software }
            for i := 0 to Transforms - 1 do begin
              r := random * 2 - 1;
              if ((0 <= r) and (r < 0.2)) then
                r := r + 0.2;
              if ((r > -0.2) and (r <= 0)) then
                r := r - 0.2;
              s := random * 2 - 1;
              if ((0 <= s) and (s < 0.2)) then
                s := s + 0.2;
              if ((s > -0.2) and (s <= 0)) then
                s := s - -0.2;
              theta := PI * random;
              phi := (2 + random) * PI / 4;
              Result.xform[i].c[0][0] := r * cos(theta);
              Result.xform[i].c[1][0] := s * (cos(theta) * cos(phi) - sin(theta));
              Result.xform[i].c[0][1] := r * sin(theta);
              Result.xform[i].c[1][1] := s * (sin(theta) * cos(phi) + cos(theta));
            { the next bit didn't translate so well, so I fudge it}
              Result.xform[i].c[2][0] := random * 2 - 1;
              Result.xform[i].c[2][1] := random * 2 - 1;
            end;
            for i := 0 to NXFORMS-1 do //NXFORMS - 1 do
              Result.xform[i].density := 0;
            for i := 0 to Transforms - 1 do
              Result.xform[i].density := 1 / Transforms;
            SetVariation(Result);
          end;
        9: begin
            for i := 0 to NXFORMS-1 do //NXFORMS - 1 do
              Result.xform[i].density := 0;
            for i := 0 to Transforms - 1 do
              Result.xform[i].density := 1 / Transforms;
          end;
      end; // case
      Result.TrianglesFromCp(Triangles);
      if Random(2) > 0 then
        ComputeWeights(Result, Triangles, transforms)
      else
        EqualizeWeights(Result);
    except on E: EmathError do
      begin
        Continue;
      end;
    end;
    for i := 0 to Transforms - 1 do
      Result.xform[i].color := i / (transforms - 1);
    if Result.xform[0].density = 1 then
      Continue;
    case SymmetryType of
      { Bilateral }
      1: add_symmetry_to_control_point(Result, -1);
      { Rotational }
      2: add_symmetry_to_control_point(Result, SymmetryOrder);
      { Rotational and Reflective }
      3: add_symmetry_to_control_point(Result, -SymmetryOrder);
    end;
    { elimate flames with transforms that aren't affine }
    skip := false;
    for i := 0 to Transforms - 1 do begin
      if not transform_affine(Triangles[i], Triangles) then
        skip := True;
    end;
    if skip then
      continue;
  until not Result.BlowsUP(5000) and (Result.xform[0].density <> 0);

  RandomGradient(SourceCP, Result);

  Result.brightness := defBrightness;
  Result.gamma := defGamma;
  Result.gamma_threshold := defGammaThreshold;
  Result.vibrancy := defVibrancy;
  Result.sample_density := defSampleDensity;
  Result.spatial_oversample := defOversample;
  Result.spatial_filter_radius := defFilterRadius;
  if KeepBackground and assigned(SourceCP) then begin
    Result.background[0] := SourceCP.background[0];
    Result.background[1] := SourceCP.background[1];
    Result.background[2] := SourceCP.background[2];
  end else begin
    Result.background[0] := 0;
    Result.background[1] := 0;
    Result.background[2] := 0;
  end;
  Result.zoom := 0;
  Result.Nick := SheepNick;
  Result.URl := SheepURL;

  Result.xform[Result.NumXForms].Clear;
  Result.xform[Result.NumXForms].symmetry := 1;
end;

end.
