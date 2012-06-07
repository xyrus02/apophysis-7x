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

unit varFan2;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationFan2 = class(TBaseVariation)
  private
    FX, FY: double;
    dy, dx, dx2: double;
  public
    constructor Create;

    class function GetName: string; override;
    class function GetInstance: TBaseVariation; override;

    function GetNrVariables: integer; override;
    function GetVariableNameAt(const Index: integer): string; override;

    function SetVariable(const Name: string; var value: double): boolean; override;
    function GetVariable(const Name: string; var value: double): boolean; override;

    procedure Prepare; override;
    procedure CalcFunction; override;
  end;

implementation

uses
  Math;

{ TVariationFan2 }

///////////////////////////////////////////////////////////////////////////////
procedure TVariationFan2.Prepare;
const
  EPS = 1E-10;
begin
  dy := FY;
  dx := pi * (sqr(FX) + EPS);
  dx2 := dx/2;
end;

procedure TVariationFan2.CalcFunction;
var
  r, a : double;
  sinr, cosr: double;
  Angle: double;
begin
{
  r := sqrt(FTx^ * FTx^ + FTy^ * FTy^);
  if (FTx^ < -EPS) or (FTx^ > EPS) or (FTy^ < -EPS) or (FTy^ > EPS) then
     Angle := arctan2(FTx^, FTy^)
  else
    Angle := 0.0;

  dy := FY;
  dx := PI * (sqr(FX) + EPS);
  dx2 := dx/2;

  t := Angle+dy - System.Int((Angle + dy)/dx) * dx;
  if (t > dx2) then
    a := Angle - dx2
  else
    a := Angle + dx2;

  FPx^ := FPx^ + vvar * r * sin(a);
  FPy^ := FPy^ + vvar * r * cos(a);
}
  Angle := arctan2(FTx^, FTy^);
  if System.Frac((Angle + dy)/dx) > 0.5 then
    a := Angle - dx2
  else
    a := Angle + dx2;
  SinCos(a, sinr, cosr);
  r := vvar * sqrt(sqr(FTx^) + sqr(FTy^));
  FPx^ := FPx^ + r * cosr;
  FPy^ := FPy^ + r * sinr;
  FPz^ := FPz^  + vvar * FTz^;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationFan2.Create;
begin
  FX := 2 * Random - 1;
  FY := 2 * Random - 1;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationFan2.GetInstance: TBaseVariation;
begin
  Result := TVariationFan2.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationFan2.GetName: string;
begin
  Result := 'fan2';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationFan2.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'fan2_x';
  1: Result := 'fan2_y';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationFan2.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'fan2_x' then begin
    FX := Value;
    Result := True;
  end else if Name = 'fan2_y' then begin
    FY := Value;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationFan2.GetNrVariables: integer;
begin
  Result := 2
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationFan2.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'fan2_x' then begin
    Value := FX;
    Result := True;
  end else if Name = 'fan2_y' then begin
    Value := FY;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationFan2), true, false);
end.
