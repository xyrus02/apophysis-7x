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

unit varFoci;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationFoci = class(TBaseVariation)
  public
    constructor Create;

    class function GetName: string; override;
    class function GetInstance: TBaseVariation; override;

    function GetNrVariables: integer; override;
    function GetVariableNameAt(const Index: integer): string; override;

    function SetVariable(const Name: string; var value: double): boolean; override;
    function GetVariable(const Name: string; var value: double): boolean; override;


    procedure CalcFunction; override;
  end;

implementation

uses
  Math;


///////////////////////////////////////////////////////////////////////////////
procedure TVariationFoci.CalcFunction;
var
  expx, expnx, siny, cosy, tmp: double;
begin
  expx := exp(FTx^) * 0.5;
  expnx := 0.25 / expx;
  sincos(FTy^, siny, cosy);

  tmp := ( expx + expnx - cosy );
  if (tmp = 0) then tmp := 1e-6;
  tmp := VVAR / tmp;

  FPx^ := FPx^ + (expx - expnx) * tmp;
  FPy^ := FPy^ + siny * tmp;

  FPz^ := FPz^ + vvar * FTz^;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationFoci.Create;
begin
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationFoci.GetInstance: TBaseVariation;
begin
  Result := TVariationFoci.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationFoci.GetName: string;
begin
  Result := 'foci';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationFoci.GetVariableNameAt(const Index: integer): string;
begin
  Result := '';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationFoci.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationFoci.GetNrVariables: integer;
begin
  Result := 0
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationFoci.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationFoci), true, false);
end.
