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

unit varBwraps;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationBwraps = class(TBaseVariation)
  private
    bwraps_cellsize, bwraps_space, bwraps_gain,
    bwraps_inner_twist, bwraps_outer_twist,
    g2, r2, rfactor: double;
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
procedure TVariationBwraps.Prepare;
var
  max_bubble, radius: double;
begin
  radius := 0.5 * (bwraps_cellsize / (1.0 + sqr(bwraps_space)));
  g2 := sqr(bwraps_gain) / (radius + 1e-6) + 1e-6;
  max_bubble := g2 * radius;

  if (max_bubble > 2.0) then max_bubble := 1.0
  else max_bubble := max_bubble * (1.0 / (sqr(max_bubble)/4.0 + 1.0));

  r2 := sqr(radius);
  rfactor := radius / max_bubble;
end;

procedure TVariationBwraps.CalcFunction;
var
  Vx, Vy,
  Cx, Cy,
  Lx, Ly,
  r, theta, s, c : double;
begin
  Vx := FTx^;
  Vy := FTy^;

	if (bwraps_cellsize = 0.0) then
  begin
    FPx^ := FPx^ + VVAR * FTx^;
    FPy^ := FPy^ + VVAR * FTy^;
    FPz^ := FPz^ + VVAR * FTz^;
  end else
  begin
    Cx := (floor(Vx / bwraps_cellsize) + 0.5) * bwraps_cellsize;
    Cy := (floor(Vy / bwraps_cellsize) + 0.5) * bwraps_cellsize;

	  Lx := Vx - Cx;
	  Ly := Vy - Cy;

    if ((sqr(Lx) + sqr(Ly)) > r2) then
    begin
      FPx^ := FPx^ + VVAR * FTx^;
      FPy^ := FPy^ + VVAR * FTy^;
      FPz^ := FPz^ + VVAR * FTz^;
    end else
    begin
      Lx := Lx * g2;
      Ly := Ly * g2;

      r := rfactor / ((sqr(Lx) + sqr(Ly)) / 4.0 + 1);
      
      Lx := Lx * r;
      Ly := Ly * r;

      r := (sqr(Lx) + sqr(Ly)) / r2;
      theta := bwraps_inner_twist * (1.0 - r) + bwraps_outer_twist * r;
      SinCos(theta, s, c);

      Vx := Cx + c * Lx + s * Ly;
      Vy := Cy - s * Lx + c * Ly;

      FPx^ := FPx^ + VVAR * Vx;
      FPy^ := FPy^ + VVAR * Vy;
      FPz^ := FPz^ + VVAR * FTz^;
    end;
  end;

end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationBwraps.Create;
begin
  bwraps_cellsize := 1;
  bwraps_space := 0;
  bwraps_gain := 1;
  bwraps_inner_twist := 0;
  bwraps_outer_twist := 0;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationBwraps.GetInstance: TBaseVariation;
begin
  Result := TVariationBwraps.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationBwraps.GetName: string;
begin
  Result := 'bwraps';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationBwraps.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'bwraps_cellsize';
  1: Result := 'bwraps_space';
  2: Result := 'bwraps_gain';
  3: Result := 'bwraps_inner_twist';
  4: Result := 'bwraps_outer_twist';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationBwraps.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'bwraps_cellsize' then begin
    bwraps_cellsize := Value;
    Result := True;
  end else if Name = 'bwraps_space' then begin
    bwraps_space := Value;
    Result := True;
  end else if Name = 'bwraps_gain' then begin
    bwraps_gain := Value;
    Result := True;
  end else if Name = 'bwraps_inner_twist' then begin
    bwraps_inner_twist := Value;
    Result := True;
  end else if Name = 'bwraps_outer_twist' then begin
    bwraps_outer_twist := Value;
    Result := True;
  end 
end;
function TVariationBwraps.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = 'bwraps_cellsize' then begin
    bwraps_cellsize := 1;
    Result := True;
  end else if Name = 'bwraps_space' then begin
    bwraps_space := 0;
    Result := True;
  end else if Name = 'bwraps_gain' then begin
    bwraps_gain := 1;
    Result := True;
  end else if Name = 'bwraps_inner_twist' then begin
    bwraps_inner_twist := 0;
    Result := True;
  end else if Name = 'bwraps_outer_twist' then begin
    bwraps_outer_twist := 0;
    Result := True;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationBwraps.GetNrVariables: integer;
begin
  Result := 5
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationBwraps.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'bwraps_cellsize' then begin
    if Value = 0 then Value := 1e-6;
    Value := bwraps_cellsize;
    Result := True;
  end else if Name = 'bwraps_space' then begin
    Value := bwraps_space;
    Result := True;
  end else if Name = 'bwraps_gain' then begin
    Value := bwraps_gain;
    Result := True;
  end else if Name = 'bwraps_inner_twist' then begin
    Value := bwraps_inner_twist;
    Result := True;
  end else if Name = 'bwraps_outer_twist' then begin
    Value := bwraps_outer_twist;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationBwraps), true, false);
end.