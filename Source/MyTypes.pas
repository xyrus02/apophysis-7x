{
     Apophysis Copyright (C) 2001-2004 Mark Townsend

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
unit MyTypes;


interface
uses ControlPoint;

type
  TTriangle = record
    x: array[0..2] of double;
    y: array[0..2] of double;
  end;
  TTriangles = array[-1..NXFORMS] of TTriangle;
  TSPoint = record
    x: double;
    y: double;
  end;
  TMapPalette = record
    Red: array[0..255] of byte;
    Green: array[0..255] of byte;
    Blue: array[0..255] of byte;
  end;
  TColorMaps = record
    Identifier: string;
    UGRFile: string;
  end;
  pPixArray = ^TPixArray;
  TPixArray = array[0..1279, 0..1023, 0..3] of integer;
  pPreviewPixArray = ^TPreviewPixArray;
  TPreviewPixArray = array[0..159, 0..119, 0..3] of integer;
  TFileType = (ftIfs, ftFla, ftXML);

implementation

end.
