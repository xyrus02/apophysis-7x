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

unit GradientHlpr;

interface

uses
  windows, Graphics, Cmap;

const
  PixelCountMax = 32768;

type
  pRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = array[0..PixelCountMax - 1] of TRGBTriple;

type
  TGradientHelper = class
  private
    procedure RGBBlend(a, b: integer; var Palette: TColorMap);
  public
    function GetGradientBitmap(Index: integer; const hue_rotation: double): TBitmap;
    function RandomGradient: TColorMap;
  end;

var
  GradientHelper: TGradientHelper;

implementation

uses
  Global;

{ TGradientHelper }

function TGradientHelper.GetGradientBitmap(Index: integer; const hue_rotation: double): TBitmap;
var
  BitMap: TBitMap;
  i, j: integer;
  Row: pRGBTripleArray;
  pal: TColorMap;
begin
  GetCMap(index, hue_rotation, pal);

  BitMap := TBitMap.create;
  Bitmap.PixelFormat := pf24bit;
  BitMap.Width := 256;
  BitMap.Height := 2;

  for j := 0 to Bitmap.Height - 1 do begin
    Row := Bitmap.Scanline[j];
    for i := 0 to Bitmap.Width - 1 do begin
      Row[i].rgbtRed := Pal[i][0];
      Row[i].rgbtGreen := Pal[i][1];
      Row[i].rgbtBlue := Pal[i][2];
    end
  end;

  Result := BitMap;
end;

///////////////////////////////////////////////////////////////////////////////
function TGradientHelper.RandomGradient: TColorMap;
var
  a, b, n, nodes: integer;
  rgb: array[0..2] of double;
  hsv: array[0..2] of double;
  pal: TColorMap;
begin
  rgb[0] := 0;
  rgb[1] := 0;
  rgb[2] := 0;

  inc(MainSeed);
  RandSeed := Mainseed;
  nodes := random((MaxNodes - 1) - (MinNodes - 2)) + (MinNodes - 1);
  n := 256 div nodes;
  b := 0;
  hsv[0] := 0.01 * (random(MaxHue - (MinHue - 1)) + MinHue);
  hsv[1] := 0.01 * (random(MaxSat - (MinSat - 1)) + MinSat);
  hsv[2] := 0.01 * (random(MaxLum - (MinLum - 1)) + MinLum);
  hsv2rgb(hsv, rgb);
  Pal[0][0] := Round(rgb[0] * 255);
  Pal[0][1] := Round(rgb[1] * 255);
  Pal[0][2] := Round(rgb[2] * 255);
  repeat
    a := b;
    b := b + n;
    hsv[0] := 0.01 * (random(MaxHue - (MinHue - 1)) + MinHue);
    hsv[1] := 0.01 * (random(MaxSat - (MinSat - 1)) + MinSat);
    hsv[2] := 0.01 * (random(MaxLum - (MinLum - 1)) + MinLum);
    hsv2rgb(hsv, rgb);
    if b > 255 then b := 255;
    Pal[b][0] := Round(rgb[0] * 255);
    Pal[b][1] := Round(rgb[1] * 255);
    Pal[b][2] := Round(rgb[2] * 255);
    RGBBlend(a, b, pal);
  until b = 255;
  Result := Pal;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TGradientHelper.RGBBlend(a, b: integer; var Palette: TColorMap);
{ Linear blend between to indices of a palette }
var
  c, v: real;
  vrange, range: real;
  i: integer;
begin
  if a = b then
  begin
    Exit;
  end;
  range := b - a;
  vrange := Palette[b mod 256][0] - Palette[a mod 256][0];
  c := Palette[a mod 256][0];
  v := vrange / range;
  for i := (a + 1) to (b - 1) do
  begin
    c := c + v;
    Palette[i mod 256][0] := Round(c);
  end;
  vrange := Palette[b mod 256][1] - Palette[a mod 256][1];
  c := Palette[a mod 256][1];
  v := vrange / range;
  for i := a + 1 to b - 1 do
  begin
    c := c + v;
    Palette[i mod 256][1] := Round(c);
  end;
  vrange := Palette[b mod 256][2] - Palette[a mod 256][2];
  c := Palette[a mod 256][2];
  v := vrange / range;
  for i := a + 1 to b - 1 do
  begin
    c := c + v;
    Palette[i mod 256][2] := Round(c);
  end;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  GradientHelper := TGradientHelper.create;
finalization
  GradientHelper.Free;
end.
