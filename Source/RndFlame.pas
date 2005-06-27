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
unit RndFlame;

interface

uses
  ControlPoint;

function RandomFlame(SourceCP: TControlPoint= nil; algorithm: integer = 0): TControlPoint;

implementation

uses
  SysUtils, Global, cmap, MyTypes, GradientHlpr, XForm;

///////////////////////////////////////////////////////////////////////////////
procedure RandomGradient(SourceCP, DestCP: TControlPoint);
begin
  case randGradient of
    0:
      begin
        cmap_index := Random(NRCMAPS);
        GetCMap(cmap_index, 1, DestCP.cmap);
        cmap_index := DestCP.cmapindex;
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
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function NumXForms(const cp: TControlPoint): integer;
var
  i: integer;
begin
  Result := NXFORMS;
  for i := 0 to NXFORMS - 1 do begin
    if cp.xform[i].density = 0 then
    begin
      Result := i;
      Break;
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
  for j := 0 to NRVISVAR - 1 do begin
    VarPossible := VarPossible or Variations[j];
  end;

  for i := 0 to NumXForms(cp) - 1 do begin
    for j := 0 to NRVAR - 1 do
      cp.xform[i].vars[j] := 0;

    if VarPossible then begin
      repeat
        a := random(NRVISVAR);
      until Variations[a];

      repeat
        b := random(NRVISVAR);
      until Variations[b];
    end else begin
      a := 0;
      b := 0;
    end;

    if (a = b) then begin
      cp.xform[i].vars[a] := 1;
    end else begin
      cp.xform[i].vars[a] := random;
      cp.xform[i].vars[b] := 1 - cp.xform[i].vars[a];
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
    for i := 0 to NumXForms(cp) - 1 do  begin
      for j := 0 to NRVAR - 1 do
        cp.xform[i].vars[j] := 0;
      cp.xform[i].vars[integer(Variation)] := 1;
    end;
end;

///////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////
procedure EqualizeWeights(var cp: TControlPoint);
var
  t, i: integer;
begin
  t := NumXForms(cp);
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
  for i := 0 to NumXForms(cp) - 1 do
    td := td + cp.xform[i].Density;
  if (td < 0.001) then
    EqualizeWeights(cp)
  else
    for i := 0 to NumXForms(cp) - 1 do
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
              Result.xform[i].vars[0] := 1;
              for j := 1 to NRVAR - 1 do
                Result.xform[i].vars[j] := 0;
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
            for i := 0 to NXFORMS - 1 do
              Result.xform[i].density := 0;
            for i := 0 to Transforms - 1 do
              Result.xform[i].density := 1 / Transforms;
            SetVariation(Result);
          end;
        9: begin
            for i := 0 to NXFORMS - 1 do
              Result.xform[i].density := 0;
            for i := 0 to Transforms - 1 do
              Result.xform[i].density := 1 / Transforms;
          end;
      end; // case
      TrianglesFromCp(Result, Triangles);
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
end;

end.
