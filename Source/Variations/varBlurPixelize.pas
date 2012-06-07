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

unit varBlurPixelize;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationBlurPixelize = class(TBaseVariation)
  private
    blur_pixelize_size, blur_pixelize_scale: double;
    inv_size, v: double;
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
procedure TVariationBlurPixelize.Prepare;
begin
  inv_size := 1.0 / blur_pixelize_size;
  v := vvar * blur_pixelize_size;
end;

procedure TVariationBlurPixelize.CalcFunction;
var x, y: double;
begin
  x := floor(FTx^*(inv_size));
	y := floor(FTy^*(inv_size));

  FPx^ := FPx^ + (v) * (x + (blur_pixelize_scale) * (random - 0.5) + 0.5);
  FPy^ := FPy^ + (v) * (y + (blur_pixelize_scale) * (random - 0.5) + 0.5);
  FPz^ := FPz^ + vvar * FTz^;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationBlurPixelize.Create;
begin
  blur_pixelize_size := 0.1;
  blur_pixelize_scale := 1;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationBlurPixelize.GetInstance: TBaseVariation;
begin
  Result := TVariationBlurPixelize.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationBlurPixelize.GetName: string;
begin
  Result := 'blur_pixelize';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationBlurPixelize.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'blur_pixelize_size';
  1: Result := 'blur_pixelize_scale';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationBlurPixelize.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'blur_pixelize_size' then begin
    if (value < 1e-6) then value := 1e-6;
    blur_pixelize_size := Value;
    Result := True;
  end else if Name = 'blur_pixelize_scale' then begin
    blur_pixelize_scale := Value;
    Result := True;
  end 
end;
function TVariationBlurPixelize.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = 'blur_pixelize_size' then begin
    blur_pixelize_size := 0.1;
    Result := True;
  end else if Name = 'blur_pixelize_scale' then begin
    blur_pixelize_size := 1;
    Result := True;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationBlurPixelize.GetNrVariables: integer;
begin
  Result := 2
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationBlurPixelize.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'blur_pixelize_size' then begin
    Value := blur_pixelize_size;
    Result := True;
  end else if Name = 'blur_pixelize_scale' then begin
    Value := blur_pixelize_scale;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationBlurPixelize), true, false);
end.