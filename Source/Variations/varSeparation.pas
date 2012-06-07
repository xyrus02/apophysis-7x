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

unit varSeparation;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationSeparation = class(TBaseVariation)
  private
    separation_x, separation_y: double;
    separation_xinside, separation_yinside: double;
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
procedure TVariationSeparation.Prepare;
begin
end;

procedure TVariationSeparation.CalcFunction;
begin
  if(FTx^ > 0.0) then
		FPx^ := FPx^ + VVAR * (sqrt(sqr(FTx^) + sqr(separation_x))- FTx^ * (separation_xinside))
	else
		FPx^ := FPx^ - VVAR * (sqrt(sqr(FTx^) + sqr(separation_x))+ FTx^ * (separation_xinside)) ;
	if(FTy^ > 0.0) then
		FPy^ := FPy^ + VVAR * (sqrt(sqr(FTy^) + sqr(separation_y))- FTy^ * (separation_yinside))
	else
		FPy^ := FPy^ - VVAR * (sqrt(sqr(FTy^) + sqr(separation_y))+ FTy^ * (separation_yinside)) ;

  FPz^ := FPz^ + vvar * FTz^;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationSeparation.Create;
begin
  separation_x := 1;
  separation_y := 1;
  separation_xinside := 0;
  separation_yinside := 0;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationSeparation.GetInstance: TBaseVariation;
begin
  Result := TVariationSeparation.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationSeparation.GetName: string;
begin
  Result := 'separation';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationSeparation.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'separation_x';
  1: Result := 'separation_y';
  2: Result := 'separation_xinside';
  3: Result := 'separation_yinside';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationSeparation.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'separation_x' then begin
    separation_x := Value;
    Result := True;
  end else if Name = 'separation_y' then begin
    separation_y := Value;
    Result := True;
  end else if Name = 'separation_xinside' then begin
    separation_xinside := Value;
    Result := True;
  end else if Name = 'separation_yinside' then begin
    separation_yinside := Value;
    Result := True;
  end 
end;
function TVariationSeparation.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = 'separation_x' then begin
    separation_x := 1;
    Result := True;
  end else if Name = 'separation_y' then begin
    separation_y := 1;
    Result := True;
  end else if Name = 'separation_xinside' then begin
    separation_xinside := 0;
    Result := True;
  end else if Name = 'separation_yinside' then begin
    separation_yinside := 0;
    Result := True;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationSeparation.GetNrVariables: integer;
begin
  Result := 4
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationSeparation.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'separation_x' then begin
    Value := separation_x;
    Result := True;
  end else if Name = 'separation_y' then begin
    Value := separation_y;
    Result := True;
  end else if Name = 'separation_xinside' then begin
    Value := separation_xinside;
    Result := True;
  end else if Name = 'separation_yinside' then begin
    Value := separation_yinside;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationSeparation), true, false);
end.