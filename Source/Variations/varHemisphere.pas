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

unit varHemisphere;

interface

uses
  BaseVariation, XFormMan;

const
  var_name = 'hemisphere';

{$define _ASM_}

type
  TVariationHemisphere = class(TBaseVariation)
  private

  public
    constructor Create;

    class function GetName: string; override;
    class function GetInstance: TBaseVariation; override;

    function GetNrVariables: integer; override;

    procedure CalcFunction; override;
  end;

implementation

uses
  Math;

{ TVariationSpherize }

///////////////////////////////////////////////////////////////////////////////
procedure TVariationHemisphere.CalcFunction;
var
  t: double;
begin
  t := vvar / sqrt(sqr(FTx^) + sqr(FTy^) + 1);

  FPx^ := FPx^ + FTx^ * t;
  FPy^ := FPy^ + FTy^ * t;
  FPz^ := FPz^ + t;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationHemisphere.Create;
begin

end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationHemisphere.GetInstance: TBaseVariation;
begin
  Result := TVariationHemisphere.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationHemisphere.GetName: string;
begin
  Result := var_name;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationHemisphere.GetNrVariables: integer;
begin
  Result := 0;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationHemisphere), true, false);
end.
