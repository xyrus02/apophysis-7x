{
     Flame screensaver Copyright (C) 2002 Ronald Hordijk
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Borys, Peter Sdobnov

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
unit Render32f;

{$define _ASM_}

interface

uses
  Windows, Classes, Forms, Graphics, ImageMaker,
  RenderST, RenderTypes, Xform, ControlPoint;

type
  TRenderer32f = class(TBaseSTRenderer)

  protected
    Buckets: TBucket32fArray;
    ColorMap: array[0..255] of TFloatColor;

//    FImageMaker: TImageMaker;

    function GetBits: integer; override;
    function GetBucketsPtr: pointer; override;
    procedure AllocateBuckets; override;

//    procedure InitBuffers; override;
    procedure ClearBuckets; override;
    procedure CreateColorMap; override;

  protected
//    procedure SetPixels; override;

    procedure IterateBatch; override;
    procedure IterateBatchAngle; override;
    procedure IterateBatchFX; override;
    procedure IterateBatchAngleFX; override;

  public
//    procedure Render; override;

end;

// ----------------------------------------------------------------------------

type
  TRenderer32fMM = class(TRenderer32f)

  protected
    procedure CalcBufferSize; override;

  public
    procedure Render; override;

end;


implementation

uses
  Math, Sysutils;

///////////////////////////////////////////////////////////////////////////////
//
//{ TRenderer32f }
//
///////////////////////////////////////////////////////////////////////////////
procedure TRenderer32f.ClearBuckets;
var
  i, j: integer;
begin
  for j := 0 to BucketHeight - 1 do
    for i := 0 to BucketWidth - 1 do
      with buckets[j][i] do begin
        Red   := 0;
        Green := 0;
        Blue  := 0;
        Count := 0;
      end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer32f.CreateColorMap;
var
  i: integer;
begin
  for i := 0 to 255 do
    with ColorMap[i] do begin
      Red   := (fcp.CMap[i][0] * fcp.white_level) / 256;
      Green := (fcp.CMap[i][1] * fcp.white_level) / 256;
      Blue  := (fcp.CMap[i][2] * fcp.white_level) / 256;
    end;
end;

///////////////////////////////////////////////////////////////////////////////
function TRenderer32f.GetBits: integer;
begin
  Result := BITS_32f;
end;

function TRenderer32f.GetBucketsPtr: pointer;
begin
  Result := Buckets;
end;

procedure TRenderer32f.AllocateBuckets;
begin
  SetLength(buckets, BucketHeight, BucketWidth);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer32f.IterateBatch;
var
  i: integer;
  px, py: double;
  pBucket: PBucket32f;
  MapColor: ^TFloatColor;

  p, q: TCPPoint;
  xf: TXForm;
begin
{$ifndef _ASM_}
  p.x := 2 * random - 1;
  p.y := 2 * random - 1;
  p.c := random;
{$else}
asm
    fld1
    call    System.@RandExt
    fadd    st, st
    fsub    st, st(1)
    fstp    qword ptr [p.x]
    call    System.@RandExt
    fadd    st, st
    fsubrp  st(1), st
    fstp    qword ptr [p.y]
    call    System.@RandExt
    fstp    qword ptr [p.c]
end;
{$endif}

  try
	xf := fcp.xform[0];
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);
    end;

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);

      if xf.noPlot then continue;

      q := p;
      fcp.ProjectionFunc(@q); // 3d hack

      px := q.x - camX0;
      if (px < 0) or (px > camW) then continue;
      py := q.y - camY0;
      if (py < 0) or (py > camH) then continue;

      pBucket := @buckets[Round(bhs * py)][Round(bws * px)];
      MapColor := @ColorMap[Round(p.c * 255)];

      with pBucket^ do begin
        Red   := Red   + MapColor.Red;
        Green := Green + MapColor.Green;
        Blue  := Blue  + MapColor.Blue;
        Count := Count + 1;
      end;
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;

procedure TRenderer32f.IterateBatchAngle;
var
  i: integer;
  px, py: double;
  pBucket: PBucket32f;
  MapColor: ^TFloatColor;

  p, q: TCPPoint;
  xf: TXform;
begin
{$ifndef _ASM_}
  p.x := 2 * random - 1;
  p.y := 2 * random - 1;
  p.c := random;
{$else}
asm
    fld1
    call    System.@RandExt
    fadd    st, st
    fsub    st, st(1)
    fstp    qword ptr [p.x]
    call    System.@RandExt
    fadd    st, st
    fsubrp  st(1), st
    fstp    qword ptr [p.y]
    call    System.@RandExt
    fstp    qword ptr [p.c]
end;
{$endif}

  try
    xf := fcp.xform[0];
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);
    end;

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);

      if xf.noPlot then continue;

      q := p;
      fcp.ProjectionFunc(@q); // 3d hack

      px := q.x * cosa + q.y * sina + rcX;
      if (px < 0) or (px > camW) then continue;
      py := q.y * cosa - q.x * sina + rcY;
      if (py < 0) or (py > camH) then continue;

      pBucket := @buckets[Round(bhs * py)][Round(bws * px)];
      MapColor := @ColorMap[Round(p.c * 255)];

      with pBucket^ do begin
        Red   := Red   + MapColor.Red;
        Green := Green + MapColor.Green;
        Blue  := Blue  + MapColor.Blue;
        Count := Count + 1;
      end;
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;


procedure TRenderer32f.IterateBatchFX;
var
  i: integer;
  px, py: double;
  pBucket: PBucket32f;
  MapColor: ^TFloatColor;

  p, q: TCPPoint;
  xf: TXForm;
begin
{$ifndef _ASM_}
  p.x := 2 * random - 1;
  p.y := 2 * random - 1;
  p.c := random;
{$else}
asm
    fld1
    call    System.@RandExt
    fadd    st, st
    fsub    st, st(1)
    fstp    qword ptr [p.x]
    call    System.@RandExt
    fadd    st, st
    fsubrp  st(1), st
    fstp    qword ptr [p.y]
    call    System.@RandExt
    fstp    qword ptr [p.c]
end;
{$endif}

  try
    xf := fcp.xform[0];
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);
    end;

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);

      if xf.noPlot then continue;

      finalXform.NextPointTo(p, q);

      fcp.ProjectionFunc(@q); // 3d hack

      px := q.x - camX0;
      if (px < 0) or (px > camW) then continue;
      py := q.y - camY0;
      if (py < 0) or (py > camH) then continue;

      pBucket := @buckets[Round(bhs * py)][Round(bws * px)];
      MapColor := @ColorMap[Round(q.c * 255)];

      with pBucket^ do begin
        Red   := Red   + MapColor.Red;
        Green := Green + MapColor.Green;
        Blue  := Blue  + MapColor.Blue;
        Count := Count + 1;
      end;
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;

procedure TRenderer32f.IterateBatchAngleFX;
var
  i: integer;
  px, py: double;
  pBucket: PBucket32f;
  MapColor: ^TFloatColor;

  p, q: TCPPoint;
  xf: TXForm;
begin
{$ifndef _ASM_}
  p.x := 2 * random - 1;
  p.y := 2 * random - 1;
  p.c := random;
{$else}
asm
    fld1
    call    System.@RandExt
    fadd    st, st
    fsub    st, st(1)
    fstp    qword ptr [p.x]
    call    System.@RandExt
    fadd    st, st
    fsubrp  st(1), st
    fstp    qword ptr [p.y]
    call    System.@RandExt
    fstp    qword ptr [p.c]
end;
{$endif}

  try
    xf := fcp.xform[0];
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);
    end;

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);

      if xf.noPlot then continue;

      finalXform.NextPointTo(p, q);

      fcp.ProjectionFunc(@q); // 3d hack

      px := q.x * cosa + q.y * sina + rcX;
      if (px < 0) or (px > camW) then continue;
      py := q.y * cosa - q.x * sina + rcY;
      if (py < 0) or (py > camH) then continue;

      pBucket := @buckets[Round(bhs * py)][Round(bws * px)];
      MapColor := @ColorMap[Round(q.c * 255)];

      with pBucket^ do begin
        Red   := Red   + MapColor.Red;
        Green := Green + MapColor.Green;
        Blue  := Blue  + MapColor.Blue;
        Count := Count + 1;
      end;
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;

// -- { TRenderer32fMM } ------------------------------------------------------

procedure TRenderer32fMM.CalcBufferSize;
begin
  CalcBufferSizeMM;
end;

procedure TRenderer32fMM.Render;
begin
  RenderMM;
end;

end.


