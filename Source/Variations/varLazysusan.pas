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
     You should have received a copy of the GNU General Public License
     GNU General Public License for more details.

     along with this program; if not, write to the Free Software
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}

unit varLazysusan;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationLazysusan = class(TBaseVariation)
  private
    lazysusan_spin, lazysusan_space, lazysusan_twist : double;
    lazysusan_x, lazysusan_y : double;
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
procedure TVariationLazysusan.Prepare;
begin
end;
procedure TVariationLazysusan.CalcFunction;
var
  a, r, sina, cosa, x, y: double;
begin
	x := FTx^ - lazysusan_x;
	y := FTy^ + lazysusan_y;
	r := sqrt(x*x + y*y);

	if (r < VVAR) then
  begin
    a := ArcTan2(y, x) + lazysusan_spin + lazysusan_twist*(VVAR-r);
    sincos(a, sina, cosa);
    FPx^ := FPx^ + VVAR * (r*cosa + lazysusan_x);
    FPy^ := FPy^ + VVAR * (r*sina - lazysusan_y);
  end else begin
    r := 1.0 + lazysusan_space / (r + 1E-6);
    FPx^ := FPx^ + VVAR * (r*x + lazysusan_x);
    FPy^ := FPy^ + VVAR * (r*y - lazysusan_y);
  end;

  FPz^ := FPz^ + VVAR * FTz^;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationLazysusan.Create;
begin
  lazysusan_spin := PI;
  lazysusan_space := 0;
  lazysusan_twist := 0;
  lazysusan_x := 0;
  lazysusan_y := 0;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationLazysusan.GetInstance: TBaseVariation;
begin
  Result := TVariationLazysusan.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationLazysusan.GetName: string;
begin
  Result := 'lazysusan';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationLazysusan.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'lazysusan_spin';
  1: Result := 'lazysusan_space';
  2: Result := 'lazysusan_twist';
  3: Result := 'lazysusan_x';
  4: Result := 'lazysusan_y';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationLazysusan.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'lazysusan_spin' then begin
    Value := frac(value / (2 * PI)) * (2 * PI);
    lazysusan_spin := value;
    Result := True;
  end else if Name = 'lazysusan_space' then begin
    lazysusan_space := Value;
    Result := True;
  end else if Name = 'lazysusan_twist' then begin
    lazysusan_twist := Value;
    Result := True;
  end else if Name = 'lazysusan_x' then begin
    lazysusan_x := Value;
    Result := True;
  end else if Name = 'lazysusan_y' then begin
    lazysusan_y := Value;
    Result := True;
  end;
end;
function TVariationLazysusan.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = 'lazysusan_spin' then begin
    lazysusan_spin := PI;
    Result := True;
  end else if Name = 'lazysusan_space' then begin
    lazysusan_space := 0;
    Result := True;
  end else if Name = 'lazysusan_twist' then begin
    lazysusan_twist := 0;
    Result := True;
  end else if Name = 'lazysusan_x' then begin
    lazysusan_x := 0;
    Result := True;
  end else if Name = 'lazysusan_y' then begin
    lazysusan_x := 0;
    Result := True;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationLazysusan.GetNrVariables: integer;
begin
  Result := 5
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationLazysusan.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'lazysusan_spin' then begin
    Value := lazysusan_spin;
    Result := True;
  end else if Name = 'lazysusan_space' then begin
    Value := lazysusan_space;
    Result := True;
  end else if Name = 'lazysusan_twist' then begin
    Value := lazysusan_twist;
    Result := True;
  end else if Name = 'lazysusan_x' then begin
    Value := lazysusan_x;
    Result := True;
  end else if Name = 'lazysusan_y' then begin
    Value := lazysusan_y;
    Result := True;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationLazysusan), true, false);
end.
