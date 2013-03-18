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

unit varPostCurl;

interface

uses
  BaseVariation, XFormMan;

const
  variation_name = 'post_curl';
  num_vars = 2;

type
  TVariationPostCurl = class(TBaseVariation)
  private
    c1, c2, c22: double;
  public
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

// TVariationCurl3D

procedure TVariationPostCurl.Prepare;
begin
  c1 := c1 * VVAR;
  c2 := c2 * VVAR;
  c22 := 2 * c2;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TVariationPostCurl.CalcFunction;
var
  x, y, r, re, im: double;
begin
  x := FPx^;
  y := FPy^;

  re := 1 + c1 * x + c2 * (sqr(x) - sqr(y));
  im := c1 * y + c22 * x * y;

  r := sqr(re) + sqr(im);
  FPx^ := (x * re + y * im) / r;
  FPy^ := (y * re - x * im) / r;
end;
///////////////////////////////////////////////////////////////////////////////
class function TVariationPostCurl.GetInstance: TBaseVariation;
begin
  Result := TVariationPostCurl.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationPostCurl.GetName: string;
begin
  Result := variation_name;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPostCurl.GetVariableNameAt(const Index: integer): string;
begin
  case Index of
    0: Result := 'post_curl_c1';
    1: Result := 'post_curl_c2';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPostCurl.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'post_curl_c1' then begin
    c1 := value;
    Result := True;
  end
  else if Name = 'post_curl_c2' then begin
    c2 := value;
    Result := True;
  end;
end;

function TVariationPostCurl.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = 'post_curl_c1' then begin
    c1 := 0;
    Result := True;
  end
  else if Name = 'post_curl_c2' then begin
    c2 := 0;
    Result := True;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPostCurl.GetNrVariables: integer;
begin
  Result := num_vars;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPostCurl.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'post_curl_c1' then begin
    value := c1;
    Result := True;
  end
  else if Name = 'post_curl_c2' then begin
    value := c2;
    Result := True;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationPostCurl), true, false);
end.
