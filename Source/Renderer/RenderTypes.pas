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

unit RenderTypes;

interface

uses SysUtils, Windows, Translation, Classes;

type
  TOnProgress = procedure(prog: double) of object;
  TOnOutput = procedure(s: string) of object;


type
  TColorMapColor = Record
    Red,
    Green,
    Blue: integer;
  end;
  PColorMapColor = ^TColorMapColor;
  TColorMapArray = array[0..255] of TColorMapColor;

  TBucket32 = Record
    Red,
    Green,
    Blue,
    Count: Longword;
  end;
  PBucket32 = ^TBucket32;
  TBucket32Array = array of array of TBucket32;

const
  MAX_FILTER_WIDTH = 25;

const
  SizeOfBucket: array[0..3] of byte = (16, 16, 24, 32);

type
  TBucketStats = record
    MaxR, MaxG, MaxB, MaxA,
    TotalA: int64;
  end;

function TimeToString(t: TDateTime): string;

implementation

function TimeToString(t: TDateTime): string;
var
  n: integer;
begin
  n := Trunc(t);
  Result := '';
  if n > 0 then begin
    Result := Result + Format(' %d ' + TextByKey('common-days'), [n]);
    //if n <> 1 then Result := Result + 's';
  end;
  t := t * 24;
  n := Trunc(t) mod 24;
  if n > 0 then begin
    Result := Result + Format(' %d ' + TextByKey('common-hours'), [n]);
    //if n <> 1 then Result := Result + 's';
  end;
  t := t * 60;
  n := Trunc(t) mod 60;
  if n > 0 then begin
    Result := Result + Format(' %d ' + TextByKey('common-minutes'), [n]);
    //if n <> 1 then Result := Result + 's';
  end;
  t := t * 60;
  t := t - (Trunc(t) div 60) * 60;
  Result := Result + Format(' %.2f ' + TextByKey('common-seconds'), [t]);
end;

end.
