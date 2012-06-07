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

unit varMobius;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationMobius = class(TBaseVariation)
  private
    Re_A, Im_A, Re_B, Im_B, Re_C, Im_C, Re_D, Im_D: double;
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
procedure TVariationMobius.Prepare;
begin
end;

procedure TVariationMobius.CalcFunction;
var
  uRe, uIm, vRe, vIm, vDenom : double;
begin
  uRe := (Re_A) * FTX^ - (Im_A) * FTY^ + (Re_B);
  uIm := (Re_A) * FTY^ + (Im_A) * FTX^ + (Im_B);
  vRe := (Re_C) * FTX^ - (Im_C) * FTY^ + (Re_D);
  vIm := (Re_C) * FTY^ + (Im_C) * FTX^ + (Im_D);

  vDenom := vRe * vRe + vIm * vIm;

  FPx^ := FPx^ + VVAR * (uRe*vRe + uIm*vIm) / vDenom;
  FPy^ := FPy^ + VVAR * (uIm*vRe - uRe*vIm) / vDenom;
  FPz^ := FPz^ + VVAR * FTz^;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationMobius.Create;
begin
  Re_A := 1; Im_A := 0;
  Re_B := 0; Im_B := 0;
  Re_C := 0; Im_C := 0;
  Re_D := 1; Im_D := 0;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationMobius.GetInstance: TBaseVariation;
begin
  Result := TVariationMobius.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationMobius.GetName: string;
begin
  Result := 'mobius';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationMobius.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'Re_A';
  1: Result := 'Im_A';
  2: Result := 'Re_B';
  3: Result := 'Im_B';
  4: Result := 'Re_C';
  5: Result := 'Im_C';
  6: Result := 'Re_D';
  7: Result := 'Im_D';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationMobius.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'Re_A' then begin
    Re_A := Value;
    Result := True;
  end else if Name = 'Im_A' then begin
    Im_A := Value;
    Result := True;
  end else if Name = 'Re_B' then begin
    Re_B := Value;
    Result := True;
  end else if Name = 'Im_B' then begin
    Im_B := Value;
    Result := True;
  end else if Name = 'Re_C' then begin
    Re_C := Value;
    Result := True;
  end else if Name = 'Im_C' then begin
    Im_C := Value;
    Result := True;
  end else if Name = 'Re_D' then begin
    Re_D := Value;
    Result := True;
  end else if Name = 'Im_D' then begin
    Im_D := Value;
    Result := True;
  end
end;
function TVariationMobius.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = 'Re_A' then begin
    Re_A := 1;
    Result := True;
  end else if Name = 'Im_A' then begin
    Im_A := 0;
    Result := True;
  end else if Name = 'Re_B' then begin
    Re_B := 0;
    Result := True;
  end else if Name = 'Im_B' then begin
    Im_B := 0;
    Result := True;
  end else if Name = 'Re_C' then begin
    Re_C := 0;
    Result := True;
  end else if Name = 'Im_C' then begin
    Im_C := 0;
    Result := True;
  end else if Name = 'Re_D' then begin
    Re_D := 1;
    Result := True;
  end else if Name = 'Im_D' then begin
    Im_D := 0;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationMobius.GetNrVariables: integer;
begin
  Result := 8
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationMobius.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'Re_A' then begin
    Value := Re_A;
    Result := True;
  end else if Name = 'Im_A' then begin
    Value := Im_A;
    Result := True;
  end else if Name = 'Re_B' then begin
    Value := Re_B;
    Result := True;
  end else if Name = 'Im_B' then begin
    Value := Im_B;
    Result := True;
  end else if Name = 'Re_C' then begin
    Value := Re_C;
    Result := True;
  end else if Name = 'Im_C' then begin
    Value := Im_C;
    Result := True;
  end else if Name = 'Re_D' then begin
    Value := Re_D;
    Result := True;
  end else if Name = 'Im_D' then begin
    Value := Im_D;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationMobius), true, false);
end.