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

unit varLog;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationLog = class(TBaseVariation)
  private
    base, denom: double;
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

{ TVariationPreSpherical }


///////////////////////////////////////////////////////////////////////////////
procedure TVariationLog.Prepare;
begin
  denom := 0.5 / Ln(base);
end;
procedure TVariationLog.CalcFunction;
begin
  FPx^ := FPx^ + vvar * Ln(sqr(FTx^) + sqr(FTy^)) * denom;
  FPy^ := FPy^ + vvar * ArcTan2(FTy^, FTx^);
  FPz^ := FPz^ + vvar * FTz^;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationLog.Create;
begin
  base := 2.71828182845905;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationLog.GetInstance: TBaseVariation;
begin
  Result := TVariationLog.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationLog.GetName: string;
begin
  Result := 'log';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationLog.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'log_base';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationLog.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'log_base' then begin
    base := Value;
    if (base < 1E-6) then
      base := 1E-6;
    Result := True;
  end;
end;
function TVariationLog.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = 'log_base' then begin
    base := 2.71828182845905;
    Result := True;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationLog.GetNrVariables: integer;
begin
  Result := 1
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationLog.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'log_base' then begin
    Value := base;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationLog), true, false);
end.
