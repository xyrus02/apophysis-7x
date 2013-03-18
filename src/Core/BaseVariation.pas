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

unit BaseVariation;

interface

type
  TCalcFunction = procedure of object;

type
  TBaseVariation = class

  protected
    procedure CalcFunction; virtual; abstract;

  public
    vvar:  double;
    FTx, FTy: ^double;
    FPx, FPy: ^double;
    FTz, FPz: ^double;

    // more params :)
    color : ^double;
    a, b, c, d, e, f : double;

    class function GetName: string; virtual; abstract;
    class function GetInstance: TBaseVariation; virtual; abstract;

    function GetNrVariables: integer; virtual;
    function GetVariableNameAt(const Index: integer): string; virtual;

    function GetVariable(const Name: string; var Value: double): boolean; virtual;
    function SetVariable(const Name: string; var Value: double): boolean; virtual;
    function ResetVariable(const Name: string): boolean; virtual;

    function GetVariableStr(const Name: string): string; virtual;
    function SetVariableStr(const Name: string; var strValue: string): boolean; virtual;

    procedure Prepare; virtual;

    procedure GetCalcFunction(var Delphi_Suxx: TCalcFunction); virtual;
  end;

  TBaseVariationClass = class of TBaseVariation;

type
  TVariationLoader = class
  public
    Supports3D, SupportsDC : boolean;

    function GetName: string; virtual; abstract;
    function GetInstance: TBaseVariation; virtual; abstract;
    function GetNrVariables: integer; virtual; abstract;
    function GetVariableNameAt(const Index: integer): string; virtual; abstract;
  end;

type
  TVariationClassLoader = class (TVariationLoader)
  public
    constructor Create(varClass : TBaseVariationClass);
    function GetName: string; override;
    function GetInstance: TBaseVariation; override;
    function GetNrVariables: integer; override;
    function GetVariableNameAt(const Index: integer): string; override;

  private
    VariationClass : TBaseVariationClass;
  end;

function fmod(x, y: double) : double;

implementation

uses SysUtils;

function fmod(x, y: double) : double;
begin
  Result := frac(x / y) * y;
end;

{ TBaseVariation }

///////////////////////////////////////////////////////////////////////////////
function TBaseVariation.GetNrVariables: integer;
begin
  Result := 0;
end;

///////////////////////////////////////////////////////////////////////////////
function TBaseVariation.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
end;

function TBaseVariation.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
end;

function TBaseVariation.ResetVariable(const Name: string): boolean;
var
  zero: double;
begin
  zero := 0;
  Result := SetVariable(Name, zero);
end;

///////////////////////////////////////////////////////////////////////////////
function TBaseVariation.GetVariableStr(const Name: string): string;
var
  value: double;
begin
  if GetVariable(Name, value) then
    Result := Format('%.6g', [value])
  else
    Result := '';
end;

function TBaseVariation.SetVariableStr(const Name: string; var strValue: string): boolean;
var
  v, oldv: double;
begin
  if GetVariable(Name, oldv) then begin
    try
      v := StrToFloat(strValue);
      SetVariable(Name, v);
    except
      v := oldv;
    end;
    strValue := Format('%.6g', [v]);
    Result := true;
  end
  else Result := false;
end;

///////////////////////////////////////////////////////////////////////////////
function TBaseVariation.GetVariableNameAt(const Index: integer): string;
begin
  Result := ''
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseVariation.Prepare;
begin
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseVariation.GetCalcFunction(var Delphi_Suxx: TCalcFunction);
begin
  Delphi_Suxx := CalcFunction;   // -X- lol
end;

///////////////////////////////////////////////////////////////////////////////
{ TVariationClassLoader }

constructor TVariationClassLoader.Create(varClass : TBaseVariationClass);
begin
  VariationClass := varClass;
end;

function TVariationClassLoader.GetName: string;
begin
  Result := VariationClass.GetName();
end;

function TVariationClassLoader.GetInstance: TBaseVariation;
begin
  Result := VariationClass.GetInstance();
end;

function TVariationClassLoader.GetNrVariables: integer;
var
  hack : TBaseVariation;
begin
  hack := GetInstance();
  Result := hack.GetNrVariables();
  hack.Free();
end;

function TVariationClassLoader.GetVariableNameAt(const Index: integer): string;
var
  hack : TBaseVariation;
begin
  hack := GetInstance();
  Result := hack.GetVariableNameAt(Index);
  hack.Free();
end;

end.
