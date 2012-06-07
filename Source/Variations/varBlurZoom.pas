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

unit varBlurZoom;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationBlurZoom = class(TBaseVariation)
  private
    blur_zoom_length, blur_zoom_x, blur_zoom_y: double; 
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
procedure TVariationBlurZoom.Prepare;
begin
end;

procedure TVariationBlurZoom.CalcFunction;
var z: double;
begin

  z := 1.0 + blur_zoom_length * random;
  FPx^ := FPx^ + vvar * ((FTx^ - blur_zoom_x) * z + blur_zoom_x);
  FPy^ := FPy^ + vvar * ((FTy^ - blur_zoom_y) * z - blur_zoom_y);
  FPz^ := FPz^ + vvar * FTz^;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationBlurZoom.Create;
begin
  blur_zoom_length := 0;
  blur_zoom_x := 0;
  blur_zoom_y := 0;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationBlurZoom.GetInstance: TBaseVariation;
begin
  Result := TVariationBlurZoom.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationBlurZoom.GetName: string;
begin
  Result := 'blur_zoom';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationBlurZoom.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'blur_zoom_length';
  1: Result := 'blur_zoom_x';
  2: Result := 'blur_zoom_y';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationBlurZoom.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'blur_zoom_length' then begin
    blur_zoom_length := Value;
    Result := True;
  end else if Name = 'blur_zoom_x' then begin
    blur_zoom_y := Value;
    Result := True;
  end else if Name = 'blur_zoom_y' then begin
    blur_zoom_y := Value;
    Result := True;
  end 
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationBlurZoom.GetNrVariables: integer;
begin
  Result := 3
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationBlurZoom.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'blur_zoom_length' then begin
    Value := blur_zoom_length;
    Result := True;
  end else if Name = 'blur_zoom_x' then begin
    Value := blur_zoom_x;
    Result := True;
  end else if Name = 'blur_zoom_y' then begin
    Value := blur_zoom_y;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationBlurZoom), true, false);
end.