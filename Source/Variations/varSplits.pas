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

unit varSplits;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationSplits = class(TBaseVariation)
  private
    splits_x, splits_y: double; 
  public
    constructor Create;

    class function GetName: string; override;
    class function GetInstance: TBaseVariation; override;

    function GetNrVariables: integer; override;
    function GetVariableNameAt(const Index: integer): string; override;

    function SetVariable(const Name: string; var value: double): boolean; override;
    function GetVariable(const Name: string; var value: double): boolean; override;

	  procedure Prepare; override;
    procedure CalcFunction; override;
  end;

implementation

uses
  Math;

///////////////////////////////////////////////////////////////////////////////
procedure TVariationSplits.Prepare;
begin
end;

procedure TVariationSplits.CalcFunction;
begin
  if(FTx^ >= 0.0) then
		FPx^ := FPx^ + VVAR * (FTx^ + splits_x)
	else
		FPx^ := FPx^ + VVAR * (FTx^ - splits_x);

  if(FTy^ >= 0.0) then
		FPy^ := FPy^ + VVAR * (FTy^ + splits_y)
	else
		FPy^ := FPy^ + VVAR * (FTy^ - splits_y);

  FPz^ := FPz^ + vvar * FTz^;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationSplits.Create;
begin
  splits_x := 0;
  splits_y := 0;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationSplits.GetInstance: TBaseVariation;
begin
  Result := TVariationSplits.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationSplits.GetName: string;
begin
  Result := 'splits';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationSplits.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'splits_x';
  1: Result := 'splits_y';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationSplits.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'splits_x' then begin
    splits_x := Value;
    Result := True;
  end else if Name = 'splits_y' then begin
    splits_y := Value;
    Result := True;
  end 
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationSplits.GetNrVariables: integer;
begin
  Result := 2
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationSplits.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'splits_x' then begin
    Value := splits_x;
    Result := True;
  end else if Name = 'splits_y' then begin
    Value := splits_y;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationSplits), true, false);
end.