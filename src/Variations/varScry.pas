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

unit varScry;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationScry = class(TBaseVariation)
  private
    v: double;
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
procedure TVariationScry.Prepare;
begin
  if (VVAR = 0) then
    v := 1.0 / 1e-6
  else v := 1.0 / vvar;
end;

procedure TVariationScry.CalcFunction;
var t, r : double;
begin
  t := sqr(FTx^) + sqr(FTy^);
	r := 1.0 / (sqrt(t) * (t + v));

	FPx^ := FPx^ + FTx^ * r;
	FPy^ := FPy^ + FTy^ * r;

  FPz^ := FPz^ + vvar * FTz^;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationScry.Create;
begin
  v := 0;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationScry.GetInstance: TBaseVariation;
begin
  Result := TVariationScry.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationScry.GetName: string;
begin
  Result := 'scry';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationScry.GetVariableNameAt(const Index: integer): string;
begin
  Result := '';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationScry.SetVariable(const Name: string; var value: double): boolean;
var temp: double;
begin
  Result := False;
end;
function TVariationScry.ResetVariable(const Name: string): boolean;
begin
  Result := False;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationScry.GetNrVariables: integer;
begin
  Result := 0
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationScry.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationScry), true, false);
end.