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

unit varPDJ;

interface

uses
  BaseVariation, XFormMan;

{$define _ASM_}

type
  TVariationPDJ = class(TBaseVariation)
  private
    FA,FB,FC,FD: double;
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

{ TVariationPDJ }

///////////////////////////////////////////////////////////////////////////////
procedure TVariationPDJ.CalcFunction;
begin
  FPx^ := FPx^ + vvar * (sin(FA * FTy^) - cos(FB * FTx^));
  FPy^ := FPy^ + vvar * (sin(FC * FTx^) - cos(FD * FTy^));
  FPz^ := FPz^ + vvar * FTz^;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationPDJ.Create;
begin
  FA := 6 * Random - 3;
  FB := 6 * Random - 3;
  FC := 6 * Random - 3;
  FD := 6 * Random - 3;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationPDJ.GetInstance: TBaseVariation;
begin
  Result := TVariationPDJ.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationPDJ.GetName: string;
begin
  Result := 'pdj';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPDJ.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'pdj_a';
  1: Result := 'pdj_b';
  2: Result := 'pdj_c';
  3: Result := 'pdj_d';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPDJ.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'pdj_a' then begin
    FA := Value;
    Result := True;
  end else if Name = 'pdj_b' then begin
    FB := Value;
    Result := True;
  end else if Name = 'pdj_c' then begin
    FC := Value;
    Result := True;
  end else if Name = 'pdj_d' then begin
    FD := Value;
    Result := True;
  end 
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPDJ.GetNrVariables: integer;
begin
  Result := 4
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPDJ.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'pdj_a' then begin
    Value := FA;
    Result := True;
  end else if Name = 'pdj_b' then begin
    Value := FB;
    Result := True;
  end else if Name = 'pdj_c' then begin
    Value := FC;
    Result := True;
  end else if Name = 'pdj_d' then begin
    Value := FD;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationPDJ), true, false);
end.
