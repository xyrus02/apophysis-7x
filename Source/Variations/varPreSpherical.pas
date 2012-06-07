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

unit varPreSpherical;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationPreSpherical = class(TBaseVariation)
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

{ TVariationPreSpherical }

///////////////////////////////////////////////////////////////////////////////
procedure TVariationPreSpherical.CalcFunction;
var r: double;
begin
  r := vvar / (sqr(FTx^) + sqr(FTy^) + 10e-6);
  FTx^ := FTx^ * r;
  FTy^ := FTy^ * r;
  FTz^ := VVAR * FTz^;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationPreSpherical.Create;
begin
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationPreSpherical.GetInstance: TBaseVariation;
begin
  Result := TVariationPreSpherical.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationPreSpherical.GetName: string;
begin
  Result := 'pre_spherical';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPreSpherical.GetVariableNameAt(const Index: integer): string;
begin
  Result := '';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPreSpherical.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPreSpherical.GetNrVariables: integer;
begin
  Result := 0
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPreSpherical.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationPreSpherical), true, false);
end.
