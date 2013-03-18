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

unit varPreFalloff2;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationPreFalloff2 = class(TBaseVariation)
  const
    n_scatter : string = 'pre_falloff2_scatter';
    n_mindist : string = 'pre_falloff2_mindist';
    n_mul_x : string = 'pre_falloff2_mul_x';
    n_mul_y : string = 'pre_falloff2_mul_y';
    n_mul_z : string = 'pre_falloff2_mul_z';
    n_mul_c : string = 'pre_falloff2_mul_c';
    n_x0 : string = 'pre_falloff2_x0';
    n_y0 : string = 'pre_falloff2_y0';
    n_z0 : string = 'pre_falloff2_z0';
    n_invert : string = 'pre_falloff2_invert';
    n_blurtype : string = 'pre_falloff2_type';

  private
    rmax: double;
    x0, y0, z0: double;
    scatter, mindist: double;
    invert, blurtype: integer;
    mul_x, mul_y, mul_z, mul_c: double;

  public
    constructor Create;

    class function GetName: string; override;
    class function GetInstance: TBaseVariation; override;

    function GetNrVariables: integer; override;
    function GetVariableNameAt(const Index: integer): string; override;

    function SetVariable(const Name: string; var value: double): boolean; override;
    function GetVariable(const Name: string; var value: double): boolean; override;
    function ResetVariable(const Name: string): boolean; override;

	  procedure Prepare; override;
    procedure CalcFunction; override;
    procedure CalcFunctionRadial;
    procedure CalcFunctionGaussian;
    procedure GetCalcFunction(var f: TCalcFunction); override;
  end;

implementation

uses
  Math;

///////////////////////////////////////////////////////////////////////////////
procedure TVariationPreFalloff2.Prepare;
begin
  rmax := 0.04 * scatter;
end;

procedure TVariationPreFalloff2.GetCalcFunction(var f: TCalcFunction);
begin
  if blurtype = 1 then f := CalcFunctionRadial
  else if blurtype = 2 then f := CalcFunctionGaussian
  else f := CalcFunction;
end;
procedure TVariationPreFalloff2.CalcFunction;
var
  in_x, in_y, in_z, d: double;
begin
  in_x := FTx^;
  in_y := FTy^;
  in_z := FTz^;

  d := sqrt(sqr(in_x - x0) + sqr(in_y - y0) + sqr(in_z - z0));
  if (invert <> 0) then d := 1 - d; if (d < 0) then d := 0;
  d := (d - mindist) * rmax; if (d < 0) then d := 0;

  FTx^ := VVAR * (in_x + mul_x * random * d);
  FTy^ := VVAR * (in_y + mul_y * random * d);
  FTz^ := VVAR * (in_z + mul_z * random * d);
  color^ := Abs(Frac(color^ + mul_c * random * d));
end;
procedure TVariationPreFalloff2.CalcFunctionRadial;
var
  in_x, in_y, in_z, d, r_in: double;
  sigma, phi, r, sins, coss, sinp, cosp: double;
begin
  in_x := FTx^;
  in_y := FTy^;
  in_z := FTz^;

  r_in := sqrt(sqr(in_x) + sqr(in_y) + sqr(in_z)) + 1e-6;
  d := sqrt(sqr(in_x - x0) + sqr(in_y - y0) + sqr(in_z - z0));
  if (invert <> 0) then d := 1 - d; if (d < 0) then d := 0;
  d := (d - mindist) * rmax; if (d < 0) then d := 0;

  sigma := ArcSin(in_z / r_in) + mul_z * random * d;
  phi := ArcTan2(in_y, in_x) + mul_y * random * d;
  r := r_in + mul_x * random * d;

  SinCos(sigma, sins, coss);
  SinCos(phi, sinp, cosp);

  FTx^ := VVAR * (r * coss * cosp);
  FTy^ := VVAR * (r * coss * sinp);
  FTz^ := VVAR * (sins);
  color^ := Abs(Frac(color^ + mul_c * random * d));
end;
procedure TVariationPreFalloff2.CalcFunctionGaussian;
var
  in_x, in_y, in_z, d: double;
  sigma, phi, r, sins, coss, sinp, cosp: double;
begin
  in_x := FTx^;
  in_y := FTy^;
  in_z := FTz^;

  d := sqrt(sqr(in_x - x0) + sqr(in_y - y0) + sqr(in_z - z0));
  if (invert <> 0) then d := 1 - d; if (d < 0) then d := 0;
  d := (d - mindist) * rmax; if (d < 0) then d := 0;

  sigma := d * random * 2 * PI;
  phi := d * random * PI;
  r := d * random;

  SinCos(sigma, sins, coss);
  SinCos(phi, sinp, cosp);

  FTx^ := VVAR * (in_x + mul_x * r * coss * cosp);
  FTy^ := VVAR * (in_y + mul_y * r * coss * sinp);
  FTz^ := VVAR * (in_z + mul_z * r * sins);
  color^ := Abs(Frac(color^ + mul_c * random * d));
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationPreFalloff2.Create;
begin
  scatter := 1;
  mindist := 0.5;
  mul_x := 1;
  mul_y := 1;
  mul_z := 0;
  mul_c := 0;
  x0 := 0;
  y0 := 0;
  z0 := 0;
  invert := 0;
  blurtype := 0;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationPreFalloff2.GetInstance: TBaseVariation;
begin
  Result := TVariationPreFalloff2.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationPreFalloff2.GetName: string;
begin
  Result := 'pre_falloff2';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPreFalloff2.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := n_scatter;
  1: Result := n_mindist;
  2: Result := n_mul_x;
  3: Result := n_mul_y;
  4: Result := n_mul_z;
  5: Result := n_mul_c;
  6: Result := n_x0;
  7: Result := n_y0;
  8: Result := n_z0;
  9: Result := n_invert;
  10: Result := n_blurtype;
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPreFalloff2.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = n_scatter then begin
    if Value < 1e-6 then Value := 1e-6;
    scatter := Value;
    Result := True;
  end else if Name = n_mindist then begin
    if Value < 0 then Value := 0;
    mindist := Value;
    Result := True;
  end else if Name = n_mul_x then begin
    if Value < 0 then Value := 0
    else if Value > 1 then Value := 1;
    mul_x := Value;
    Result := True;
  end else if Name = n_mul_y then begin
    if Value < 0 then Value := 0
    else if Value > 1 then Value := 1;
    mul_y := Value;
    Result := True;
  end else if Name = n_mul_z then begin
    if Value < 0 then Value := 0
    else if Value > 1 then Value := 1;
    mul_z := Value;
    Result := True;
  end else if Name = n_mul_c then begin
    if Value < 0 then Value := 0
    else if Value > 1 then Value := 1;
    mul_c := Value;
    Result := True;
  end else if Name = n_x0 then begin
    x0 := Value;
    Result := True;
  end else if Name = n_y0 then begin
    y0 := Value;
    Result := True;
  end else if Name = n_z0 then begin
    z0 := Value;
    Result := True;
  end else if Name = n_invert then begin
    if (Value > 1) then Value := 1;
    if (Value < 0) then Value := 0;
    invert := Round(Value);
    Result := True;
  end else if Name = n_blurtype then begin
    if (Value > 2) then Value := 2;
    if (Value < 0) then Value := 0;
    blurtype := Round(Value);
    Result := True;
  end
end;
function TVariationPreFalloff2.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = n_scatter then begin
    scatter := 1;
    Result := True;
  end else if Name = n_mindist then begin
    mindist := 0.5;
    Result := True;
  end else if Name = n_mul_x then begin
    mul_x := 1;
    Result := True;
  end else if Name = n_mul_y then begin
    mul_y := 1;
    Result := True;
  end else if Name = n_mul_z then begin
    mul_z := 0;
    Result := True;
  end else if Name = n_mul_c then begin
    mul_c := 0;
    Result := True;
  end else if Name = n_x0 then begin
    x0 := 0;
    Result := True;
  end else if Name = n_y0 then begin
    y0 := 0;
    Result := True;
  end else if Name = n_z0 then begin
    z0 := 0;
    Result := True;
  end else if Name = n_invert then begin
    invert := 0;
    Result := True;
  end else if Name = n_blurtype then begin
    blurtype := 0;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPreFalloff2.GetNrVariables: integer;
begin
  Result := 11
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPreFalloff2.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = n_scatter then begin
    Value := scatter;
    Result := True;
  end else if Name = n_mindist then begin
    Value := mindist;
    Result := True;
  end else if Name = n_mul_x then begin
    Value := mul_x;
    Result := True;
  end else if Name = n_mul_y then begin
    Value := mul_y;
    Result := True;
  end else if Name = n_mul_z then begin
    Value := mul_z;
    Result := True;
  end else if Name = n_mul_c then begin
    Value := mul_c;
    Result := True;
  end else if Name = n_x0 then begin
    Value := x0;
    Result := True;
  end else if Name = n_y0 then begin
    Value := y0;
    Result := True;
  end else if Name = n_z0 then begin
    Value := z0;
    Result := True;
  end else if Name = n_invert then begin
    Value := invert;
    Result := True;
  end else if Name = n_blurtype then begin
    Value := blurtype;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationPreFalloff2), true, false);
end.