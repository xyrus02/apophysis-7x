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

unit varBipolar;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationBipolar = class(TBaseVariation)
  private
    bipolar_shift, v_4, v, s: double;
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
  end;

implementation

uses
  Math;

///////////////////////////////////////////////////////////////////////////////
procedure TVariationBipolar.Prepare;
begin
  v_4 := VVAR * 0.15915494309189533576888376337251;
  v := VVAR * 0.636619772367581343075535053490061;
  s := -1.57079632679489661923 * (bipolar_shift);
end;

procedure TVariationBipolar.CalcFunction;
var x2y2, y, t, x2, f, g : double;
begin
  x2y2 := sqr(FTx^) + sqr(FTy^);
  y := 0.5 * ArcTan2(2.0 * FTy^, x2y2 - 1.0) + (s);

    if (y > 1.57079632679489661923) then
        y := -1.57079632679489661923 + fmod(y + 1.57079632679489661923, PI)
    else if (y < -1.57079632679489661923) then
        y := 1.57079632679489661923 - fmod(1.57079632679489661923 - y, PI);

    t := x2y2 + 1.0;
    x2 := 2.0 * FTx^;

    f := t + x2;
    g := t - x2;

    if (g = 0) or (f/g <= 0) then
      Exit;
    
    FPx^ := FPx^ + (v_4) * Ln((t+x2) / (t-x2));
    FPy^ := FPy^ + (v) * y;

  FPz^ := FPz^ + vvar * FTz^;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationBipolar.Create;
begin
  bipolar_shift := 0;
  v_4 := 0;
  v := 0;
  s := 0;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationBipolar.GetInstance: TBaseVariation;
begin
  Result := TVariationBipolar.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationBipolar.GetName: string;
begin
  Result := 'bipolar';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationBipolar.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'bipolar_shift';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationBipolar.SetVariable(const Name: string; var value: double): boolean;
var temp: double;
begin
  Result := False;
  if Name = 'bipolar_shift' then begin
    temp := frac(0.5 * (value + 1.0));
    value := 2.0 * temp - 1.0;
    bipolar_shift := Value;
    Result := True;
  end 
end;
function TVariationBipolar.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = 'bipolar_shift' then begin
    bipolar_shift := 0;
    Result := True;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationBipolar.GetNrVariables: integer;
begin
  Result := 1
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationBipolar.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'bipolar_shift' then begin
    Value := bipolar_shift;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationBipolar), true, false);
end.