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

unit varLoonie;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationLoonie = class(TBaseVariation)
  private
    sqrvar: double;
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
procedure TVariationLoonie.Prepare;
begin
  sqrvar := VVAR * VVAR;
end;

procedure TVariationLoonie.CalcFunction;
var r, r2 : double;
begin
  r2 := sqr(FTx^) + sqr(FTy^);

	if (r2 < (sqrvar)) and (r2 <> 0) then
	begin
		r := VVAR * sqrt((sqrvar) / r2 - 1.0);
		FPx^ := FPx^ + r * FTx^;
		FPy^ := FPy^ + r * FTy^;
	end else begin
		FPx^ := FPx^ + VVAR * FTx^;
		FPy^ := FPy^ + VVAR * FTy^;
	end;

  FPz^ := FPz^ + vvar * FTz^;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationLoonie.Create;
begin
  sqrvar := 0;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationLoonie.GetInstance: TBaseVariation;
begin
  Result := TVariationLoonie.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationLoonie.GetName: string;
begin
  Result := 'loonie';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationLoonie.GetVariableNameAt(const Index: integer): string;
begin
  Result := '';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationLoonie.SetVariable(const Name: string; var value: double): boolean;
var temp: double;
begin
  Result := False;
end;
function TVariationLoonie.ResetVariable(const Name: string): boolean;
begin
  Result := False;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationLoonie.GetNrVariables: integer;
begin
  Result := 0
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationLoonie.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationLoonie), true, false);
end.