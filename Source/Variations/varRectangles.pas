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
{
     This variation was started by Michael Faber
}

unit varRectangles;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationRectangles = class(TBaseVariation)
  private
    FRectanglesX, FRectanglesY: double;
  public
    constructor Create;

    class function GetName: string; override;
    class function GetInstance: TBaseVariation; override;

    function GetNrVariables: integer; override;
    function GetVariableNameAt(const Index: integer): string; override;

    function SetVariable(const Name: string; var value: double): boolean; override;
    function GetVariable(const Name: string; var value: double): boolean; override;

    procedure GetCalcFunction(var f: TCalcFunction); override;
    procedure CalcFunction; override;
    procedure CalcZeroX;
    procedure CalcZeroY;
    procedure CalcZeroXY;

  end;

implementation

uses
  Math;

{ TVariationRectangles }

///////////////////////////////////////////////////////////////////////////////

procedure TVariationRectangles.GetCalcFunction(var f: TCalcFunction);
begin
  if IsZero(FRectanglesX) then begin
    if IsZero(FRectanglesY) then
      f := CalcZeroXY
    else
      f := CalcZeroX;
  end
  else if IsZero(FRectanglesY) then
    f := CalcZeroY
  else f := CalcFunction;
end;

procedure TVariationRectangles.CalcFunction;
begin
  FPx^ := FPx^ + vvar * ((2*floor(FTx^/FRectanglesX) + 1)*FRectanglesX - FTx^);
  FPy^ := FPy^ + vvar * ((2*floor(FTy^/FRectanglesY) + 1)*FRectanglesY - FTy^);
  FPz^ := FPz^ + vvar * FTz^;
end;

procedure TVariationRectangles.CalcZeroX;
begin
  FPx^ := FPx^ + vvar * FTx^;
  FPy^ := FPy^ + vvar * ((2*floor(FTy^/FRectanglesY) + 1)*FRectanglesY - FTy^);
  FPz^ := FPz^ + vvar * FTz^;
end;

procedure TVariationRectangles.CalcZeroY;
begin
  FPx^ := FPx^ + vvar * ((2*floor(FTx^/FRectanglesX) + 1)*FRectanglesX - FTx^);
  FPy^ := FPy^ + vvar * FTy^;
  FPz^ := FPz^ + vvar * FTz^;
end;

procedure TVariationRectangles.CalcZeroXY;
begin
  FPx^ := FPx^ + vvar * FTx^;
  FPy^ := FPy^ + vvar * FTy^;
  FPz^ := FPz^ + vvar * FTz^;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationRectangles.GetName: string;
begin
  Result := 'rectangles';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationRectangles.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'rectangles_x';
  1: Result := 'rectangles_y';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationRectangles.GetNrVariables: integer;
begin
  Result := 2;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationRectangles.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'rectangles_x' then begin
    FRectanglesX := Value;
    Result := True;
  end else if Name = 'rectangles_y' then begin
    FRectanglesY := Value;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationRectangles.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'rectangles_x' then begin
    Value := FRectanglesX;
    Result := True;
  end else if Name = 'rectangles_y' then begin
    Value := FRectanglesY;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationRectangles.Create;
begin
  inherited Create;

  FRectanglesX  := 1.0;
  FRectanglesY := 1.0;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationRectangles.GetInstance: TBaseVariation;
begin
  Result := TVariationRectangles.Create;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationRectangles), true, false);
end.
