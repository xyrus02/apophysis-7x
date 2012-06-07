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

unit varJuliaScope;

interface

uses
  BaseVariation, XFormMan;

const
  variation_name='juliascope';
  var_n_name='juliascope_power';
  var_c_name='juliascope_dist';

{$ifdef Apo7X64}
{$else}
  {$define _ASM_}
{$endif}

type
  TVariationJuliaScope = class(TBaseVariation)
  private
    N: integer;
    c: double;

    rN: integer;
    cn: double;

    procedure CalcPower1;
    procedure CalcPowerMinus1;
    procedure CalcPower2;
    procedure CalcPowerMinus2;

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
    procedure GetCalcFunction(var f: TCalcFunction); override;
  end;

implementation

uses
  math;

// TVariationJuliaScope

///////////////////////////////////////////////////////////////////////////////
constructor TVariationJuliaScope.Create;
begin
  N := random(5) + 2;
  c := 1.0;
end;

procedure TVariationJuliaScope.Prepare;
begin
  rN := abs(N);
  cn := c / N / 2;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TVariationJuliaScope.GetCalcFunction(var f: TCalcFunction);
begin
  if c = 1 then begin
    if N = 2 then f := CalcPower2
    else if N = -2 then f := CalcPowerMinus2
    else if N = 1 then f := CalcPower1
    else if N = -1 then f := CalcPowerMinus1
    else f := CalcFunction;
  end
  else f := CalcFunction;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TVariationJuliaScope.CalcFunction;
var
  rnd: integer;
  r: double;
  sina, cosa: extended;
begin
  rnd := random(rN);
  if (rnd and 1) = 0 then
    sincos( (2*pi*rnd + arctan2(FTy^, FTx^)) / N, sina, cosa)
  else
    sincos( (2*pi*rnd - arctan2(FTy^, FTx^)) / N, sina, cosa);
  r := vvar * Math.Power(sqr(FTx^) + sqr(FTy^), cn);
  FPx^ := FPx^ + r * cosa;
  FPy^ := FPy^ + r * sina;
  FPz^ := FPz^ + vvar * FTz^;
end;

procedure TVariationJuliaScope.CalcPower2;
var
  r: double;
  sina, cosa: extended;
begin
  if random(2) = 0 then
    sincos(arctan2(FTy^, FTx^)/2, sina, cosa)
  else
    sincos(pi - arctan2(FTy^, FTx^)/2, sina, cosa);

  r := vvar * sqrt(sqrt(sqr(FTx^) + sqr(FTy^)));

  FPx^ := FPx^ + r * cosa;
  FPy^ := FPy^ + r * sina;
  FPz^ := FPz^ + vvar * FTz^;
end;

procedure TVariationJuliaScope.CalcPowerMinus2;
var
  r: double;
  sina, cosa: extended;
begin
  if random(2) = 0 then
    sincos(arctan2(FTy^, FTx^)/2, sina, cosa)
  else
    sincos(pi - arctan2(FTy^, FTx^)/2, sina, cosa);
  r := vvar / sqrt(sqrt(sqr(FTx^) + sqr(FTy^)));

  FPx^ := FPx^ + r * cosa;
  FPy^ := FPy^ - r * sina;
  FPz^ := FPz^ + vvar * FTz^;
end;

procedure TVariationJuliaScope.CalcPower1;
begin
  FPx^ := FPx^ + vvar * FTx^;
  FPy^ := FPy^ + vvar * FTy^;
  FPz^ := FPz^ + vvar * FTz^;
end;

procedure TVariationJuliaScope.CalcPowerMinus1;
var
  r: double;
begin
  r := vvar / (sqr(FTx^) + sqr(FTy^));

  FPx^ := FPx^ + r * FTx^;
  FPy^ := FPy^ - r * FTy^;
  FPz^ := FPz^ + vvar * FTz^;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationJuliaScope.GetInstance: TBaseVariation;
begin
  Result := TVariationJuliaScope.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationJuliaScope.GetName: string;
begin
  Result := variation_name;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationJuliaScope.GetVariableNameAt(const Index: integer): string;
begin
  case Index of
  0: Result := var_n_name;
  1: Result := var_c_name;
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationJuliaScope.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = var_n_name then begin
    N := Round(Value);
    if N = 0 then N := 1;
    Value := N;
    Result := True;
  end
  else if Name = var_c_name then begin
    c := value;
    Result := True;
  end;
end;

function TVariationJuliaScope.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = var_n_name then begin
    if N = 2 then N := -2
    else N := 2;
    Result := True;
  end
  else if Name = var_c_name then begin
    c := 1;
    Result := True;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationJuliaScope.GetNrVariables: integer;
begin
  Result := 2;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationJuliaScope.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = var_n_name then begin
    Value := N;
    Result := true;
  end
  else if Name = var_c_name then begin
    Value := c;
    Result := true;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationJuliaScope), true, false);
end.
