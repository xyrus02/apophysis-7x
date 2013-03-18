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

unit varPostCrop;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationPostCrop = class(TBaseVariation)
  const
    n_x0 : string = 'post_crop_left';
    n_y0 : string = 'post_crop_top';
    n_x1 : string = 'post_crop_right';
    n_y1 : string = 'post_crop_bottom';
    n_s : string = 'post_crop_scatter_area';
    n_z : string = 'post_crop_zero';
    n : string = 'post_crop';

  private
    x0, y0, x1, y1, s, w, h: double;
    _x0, _y0, _x1, _y1: double;
    z: integer;

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
procedure TVariationPostCrop.Prepare;
begin
  if (x0 < x1) then begin
    _x0 := x0;
    _x1 := x1;
  end else begin
    _x0 := x1;
    _x1 := x0;
  end;

  if (y0 < y1) then begin
    _y0 := y0;
    _y1 := y1;
  end else begin
    _y0 := y1;
    _y1 := y0;
  end;

  w := (_x1 - _x0) * 0.5 * s;
  h := (_y1 - _y0) * 0.5 * s;
end;

procedure TVariationPostCrop.CalcFunction;
var x, y: double;
begin
  x := FPx^;
  y := FPy^;

  if ((x < _x0) or (x > _x1) or (y < _y0) or (y > _y1)) and (z <> 0) then begin
    x := 0; y := 0;
  end else begin
    if x < _x0 then x := _x0 + random * w
    else if x > _x1 then x := _x1 - random * w;
    if y < _y0 then y := _y0 + random * h
    else if y > _y1 then y := _y1 - random * h;
  end;

  FPx^ := VVAR * x;
  FPy^ := VVAR * y;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationPostCrop.Create;
begin
  x0 := -1; x1 := 1;
  y0 := -1; y1 := 1;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationPostCrop.GetInstance: TBaseVariation;
begin
  Result := TVariationPostCrop.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationPostCrop.GetName: string;
begin
  Result := n;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPostCrop.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := n_x0;
  1: Result := n_y0;
  2: Result := n_x1;
  3: Result := n_y1;
  4: Result := n_s;
  5: Result := n_z;
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPostCrop.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = n_x0 then begin
    x0 := Value;
    Result := True;
  end else if Name = n_y0 then begin
    y0 := Value;
    Result := True;
  end else if Name = n_x1 then begin
    x1 := Value;
    Result := True;
  end else if Name = n_y1 then begin
    y1 := Value;
    Result := True;
  end else if Name = n_s then begin
    if (Value < -1) then Value := -1;
    if (Value > 1) then Value := 1;
    s := Value;
    Result := True;
  end else if Name = n_z then begin
    if (Value > 1) then Value := 1;
    if (Value < 0) then Value := 0;
    z := Round(Value);
    Result := True;
  end
end;
function TVariationPostCrop.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = n_x0 then begin
    x0 := -1;
    Result := True;
  end else if Name = n_y0 then begin
    y0 := -1;
    Result := True;
  end else if Name = n_x1 then begin
    x1 := 1;
    Result := True;
  end else if Name = n_y1 then begin
    y1 := 1;
    Result := True;
  end else if Name = n_s then begin
    s := 0;
    Result := True;
  end else if Name = n_z then begin
    z := 0;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPostCrop.GetNrVariables: integer;
begin
  Result := 6
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPostCrop.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = n_x0 then begin
    Value := x0;
    Result := True;
  end else if Name = n_y0 then begin
    Value := y0;
    Result := True;
  end else if Name = n_x1 then begin
    Value := x1;
    Result := True;
  end else if Name = n_y1 then begin
    Value := y1;
    Result := True;
  end else if Name = n_s then begin
    Value := s;
    Result := True;
  end else if Name = n_z then begin
    Value := z;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationPostCrop), true, false);
end.