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

unit varPostBwraps;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationPostBwraps = class(TBaseVariation)
  private
    post_bwraps_cellsize, post_bwraps_space, post_bwraps_gain,
    post_bwraps_inner_twist, post_bwraps_outer_twist,
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
procedure TVariationPostBwraps.Prepare;
var
  max_bubble, radius: double;
begin
  radius := 0.5 * (post_bwraps_cellsize / (1.0 + sqr(post_bwraps_space)));
  g2 := sqr(post_bwraps_gain) / (radius + 1e-6) + 1e-6;
  max_bubble := g2 * radius;

  if (max_bubble > 2.0) then max_bubble := 1.0
  else max_bubble := max_bubble * (1.0 / (sqr(max_bubble)/4.0 + 1.0));

  r2 := sqr(radius);
  rfactor := radius / max_bubble;
end;

procedure TVariationPostBwraps.CalcFunction;
var
  Vx, Vy,
  Cx, Cy,
  Lx, Ly,
  r, theta, s, c : double;
begin
  Vx := FPx^;
  Vy := FPy^;

	if (post_bwraps_cellsize <> 0.0) then
  begin
    Cx := (floor(Vx / post_bwraps_cellsize) + 0.5) * post_bwraps_cellsize;
    Cy := (floor(Vy / post_bwraps_cellsize) + 0.5) * post_bwraps_cellsize;

	  Lx := Vx - Cx;
	  Ly := Vy - Cy;

    if ((sqr(Lx) + sqr(Ly)) <= r2) then
    begin
      Lx := Lx * g2;
      Ly := Ly * g2;

      r := rfactor / ((sqr(Lx) + sqr(Ly)) / 4.0 + 1);
      
      Lx := Lx * r;
      Ly := Ly * r;

      r := (sqr(Lx) + sqr(Ly)) / r2;
      theta := post_bwraps_inner_twist * (1.0 - r) + post_bwraps_outer_twist * r;
      SinCos(theta, s, c);

      Vx := Cx + c * Lx + s * Ly;
      Vy := Cy - s * Lx + c * Ly;

      FPx^ := VVAR * Vx;
      FPy^ := VVAR * Vy;
      FPz^ := VVAR * FPz^;
    end;
  end;

end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationPostBwraps.Create;
begin
  post_bwraps_cellsize := 1;
  post_bwraps_space := 0;
  post_bwraps_gain := 1;
  post_bwraps_inner_twist := 0;
  post_bwraps_outer_twist := 0;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationPostBwraps.GetInstance: TBaseVariation;
begin
  Result := TVariationPostBwraps.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationPostBwraps.GetName: string;
begin
  Result := 'post_bwraps';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPostBwraps.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'post_bwraps_cellsize';
  1: Result := 'post_bwraps_space';
  2: Result := 'post_bwraps_gain';
  3: Result := 'post_bwraps_inner_twist';
  4: Result := 'post_bwraps_outer_twist';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPostBwraps.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'post_bwraps_cellsize' then begin
    if Value = 0 then Value := 1e-6;
    post_bwraps_cellsize := Value;
    Result := True;
  end else if Name = 'post_bwraps_space' then begin
    post_bwraps_space := Value;
    Result := True;
  end else if Name = 'post_bwraps_gain' then begin
    post_bwraps_gain := Value;
    Result := True;
  end else if Name = 'post_bwraps_inner_twist' then begin
    post_bwraps_inner_twist := Value;
    Result := True;
  end else if Name = 'post_bwraps_outer_twist' then begin
    post_bwraps_outer_twist := Value;
    Result := True;
  end 
end;
function TVariationPostBwraps.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = 'post_bwraps_cellsize' then begin
    post_bwraps_cellsize := 1;
    Result := True;
  end else if Name = 'post_bwraps_space' then begin
    post_bwraps_space := 0;
    Result := True;
  end else if Name = 'post_bwraps_gain' then begin
    post_bwraps_gain := 1;
    Result := True;
  end else if Name = 'post_bwraps_inner_twist' then begin
    post_bwraps_inner_twist := 0;
    Result := True;
  end else if Name = 'post_bwraps_outer_twist' then begin
    post_bwraps_outer_twist := 0;
    Result := True;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPostBwraps.GetNrVariables: integer;
begin
  Result := 5
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPostBwraps.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'post_bwraps_cellsize' then begin
    Value := post_bwraps_cellsize;
    Result := True;
  end else if Name = 'post_bwraps_space' then begin
    Value := post_bwraps_space;
    Result := True;
  end else if Name = 'post_bwraps_gain' then begin
    Value := post_bwraps_gain;
    Result := True;
  end else if Name = 'post_bwraps_inner_twist' then begin
    Value := post_bwraps_inner_twist;
    Result := True;
  end else if Name = 'post_bwraps_outer_twist' then begin
    Value := post_bwraps_outer_twist;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationPostBwraps), true, false);
end.