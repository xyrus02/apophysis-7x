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

unit XFormMan;

interface

uses
  BaseVariation, SysUtils, Forms, Windows;

const
  NRLOCVAR = 29;
var
  NumBuiltinVars: integer;

type
  TFNToVN = record
    FileName: string;
    VarName: string;
  end;

function NrVar: integer;
function Varnames(const index: integer): String;
procedure RegisterVariation(Variation: TVariationLoader; supports3D, supportsDC : boolean);
function GetNrRegisteredVariations: integer;
function GetRegisteredVariation(const Index: integer): TVariationLoader;
function GetNrVariableNames: integer;
function GetVariableNameAt(const Index: integer): string;
function GetVariationIndex(const str: string): integer;
function GetVariationIndexFromVariableNameIndex(const Index: integer): integer;
procedure VarSupports(index : integer; var supports3D : boolean; var supportsDC : boolean);
procedure InitializeXFormMan;
procedure DestroyXFormMan;
procedure RegisterVariationFile(filename, name: string);
function GetFileNameOfVariation(name: string): string;

implementation

uses
  Classes;

var
  VariationList: TList;
  VariableNames: TStringlist;
  loaderNum : integer;
  Variable2VariationIndex : array of integer;
  FNToVNList : array of TFNToVN;
  FNToVNCount: integer;

procedure InitializeXFormMan;
begin
  VariationList := TList.Create;
  VariableNames := TStringlist.create;
  SetLength(Variable2VariationIndex,0);
  SetLength(FNToVNList, 0);
  FNToVNCount := 0;
end;

procedure VarSupports(index : integer; var supports3D : boolean; var supportsDC : boolean);
const
  supports3D_arr: array[0..NRLOCVAR-1] of boolean = (
    true, //'linear',
    true, //'flatten',
    true, //'sinusoidal',
    true, //'spherical',
    true, //'swirl',
    true, //'horseshoe',
    true, //'polar',
    true, //'disc',
    true, //'spiral',
    true, //'hyperbolic',
    true, //'diamond',
    true, //'eyefish',
    true, //'bubble',
    true, //'cylinder',
    true, //'noise',
    true, //'blur',
    true, //'gaussian_blur',
    true, //'zblur',
    true, //'blur3D',
    true, //'pre_blur',
    true, //'pre_zscale',
    true, //'pre_ztranslate',
    true, //'pre_rotate_x',
    true, //'pre_rotate_y',
    true, //'zscale',
    true, //'ztranslate',
    true, //'zcone',
    true, //'post_rotate_x',
    true //'post_rotate_y',
    );
 supportsDC_arr: array[0..NRLOCVAR-1] of boolean = (
    false, //'linear3D',
    false, //'linear',
    false, //'sinusoidal',
    false, //'spherical',
    false, //'swirl',
    false, //'horseshoe',
    false, //'polar',
//  false, //  'handkerchief',
//  false, //  'heart',
    false, //'disc',
    false, //'spiral',
    false, //'hyperbolic',
    false, //'diamond',
//  false, //  'ex',
//  false, //  'julia',
//  false, //  'bent',
//  false, //  'waves',
//  false, //  'fisheye',
//  false, //  'popcorn',
//  false, //  'exponential',
//  false, //  'power',
//  false, //  'cosine',
//  false, //  'rings',
//  false, //  'fan',
    false, //'eyefish',
    false, //'bubble',
    false, //'cylinder',
    false, //'noise',
    false, //'blur',
    false, //'gaussian_blur',
    false, //'zblur',
    false, //'blur3D',

    false, //'pre_blur',
    false, //'pre_zscale',
    false, //'pre_ztranslate',
    false, //'pre_rotate_x',
    false, //'pre_rotate_y',

    false, //'zscale',
    false, //'ztranslate',
    false, //'zcone',

    false, //'post_rotate_x',
    false //'post_rotate_y'
    );
var
  varl : TVariationLoader;
begin

  if (index >= NRLOCVAR) then begin
    supports3D := TVariationLoader(VariationList.Items[index - NRLOCVAR]).supports3D;
    supportsDC := TVariationLoader(VariationList.Items[index - NRLOCVAR]).supportsDC;
  end else begin
    supports3D := supports3D_arr[index];
    supportsDC := supportsDC_arr[index];
  end;
end;


procedure DestroyXFormMan;
var i: integer;
begin
  VariableNames.Free;

  // The registered variation loaders are owned here, so we must free them.
  for i := 0 to VariationList.Count-1 do
    TVariationLoader(VariationList[i]).Free;
  VariationList.Free;

  Finalize(Variable2VariationIndex);
  Finalize(FNToVNList);
end;

///////////////////////////////////////////////////////////////////////////////
function NrVar: integer;
begin
  Result := NRLOCVAR + VariationList.Count;
end;

///////////////////////////////////////////////////////////////////////////////

function GetVariationIndexFromVariableNameIndex(const Index: integer): integer;
begin
  if (Index<0) or (Index > High(Variable2VariationIndex)) then
    Result := -1
  else
    Result := Variable2VariationIndex[Index];
end;

function Varnames(const index: integer): String;
const
  cvarnames: array[0..NRLOCVAR-1] of string = (
    'linear',
    'flatten',
    'sinusoidal',
    'spherical',
    'swirl',
    'horseshoe',
    'polar',
//    'handkerchief',
//    'heart',
    'disc',
    'spiral',
    'hyperbolic',
    'diamond',
//    'ex',
//    'julia',
//    'bent',
//    'waves',
//    'fisheye',
//    'popcorn',
//    'exponential',
//    'power',
//    'cosine',
//    'rings',
//    'fan',
    'eyefish',
    'bubble',
    'cylinder',
    'noise',
    'blur',
    'gaussian_blur',
    'zblur',
    'blur3D',

    'pre_blur',
    'pre_zscale',
    'pre_ztranslate',
    'pre_rotate_x',
    'pre_rotate_y',

    'zscale',
    'ztranslate',
    'zcone',

    'post_rotate_x',
    'post_rotate_y'
    );
begin
  if Index < NRLOCVAR then
    Result := cvarnames[Index]
  else
    Result := TVariationLoader(VariationList[Index - NRLOCVAR]).GetName;
end;

///////////////////////////////////////////////////////////////////////////////
function GetVariationIndex(const str: string): integer;
var
  i: integer;
begin
  i := NRVAR-1;
  while (i >= 0) and (Varnames(i) <> str) do Dec(i);
  Result := i;
end;

///////////////////////////////////////////////////////////////////////////////

procedure RegisterVariationFile(filename, name: string);
begin
  FNToVNCount := FNToVNCount + 1;
  SetLength(FNToVNList, FNToVNCount);
  FNToVNList[FNToVNCount - 1].FileName := filename;
  FNToVNList[FNToVNCount - 1].VarName := name;
end;
function GetFileNameOfVariation(name: string): string;
var i: integer;
begin
  for i := 0 to FNToVNCount - 1 do begin
    if FNToVNList[i].VarName = name then begin
      Result := FNToVNList[i].FileName;
      Exit;
    end;
  end;
  Result := '';
end;

procedure RegisterVariation(Variation: TVariationLoader; supports3D, supportsDC : boolean);
var
  i: integer;
  prevNumVariables:integer;
begin
  OutputDebugString(PChar(Variation.GetName));

  VariationList.Add(Variation);
  Variation.Supports3D := supports3D;
  Variation.SupportsDC := supportsDC;

  prevNumVariables := GetNrVariableNames;
  setLength(Variable2VariationIndex, prevNumVariables + Variation.GetNrVariables);
  for i := 0 to Variation.GetNrVariables - 1 do begin
    VariableNames.Add(Variation.GetVariableNameAt(i));
    Variable2VariationIndex[prevNumVariables + i] := NrVar-1;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function GetNrRegisteredVariations: integer;
begin
  Result := VariationList.count;
end;

///////////////////////////////////////////////////////////////////////////////
function GetRegisteredVariation(const Index: integer): TVariationLoader;
begin
  Result := TVariationLoader(VariationList[Index]);
end;

///////////////////////////////////////////////////////////////////////////////
function GetNrVariableNames: integer;
begin
  Result := VariableNames.Count;
end;

///////////////////////////////////////////////////////////////////////////////
function GetVariableNameAt(const Index: integer): string;
begin
  Result := VariableNames[Index];
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  InitializeXFormMan;
  
finalization
  DestroyXFormMan;

end.
