{
     Flame screensaver Copyright (C) 2002 Ronald Hordijk
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Borys, Peter Sdobnov
     Apophysis Copyright (C) 2007-2008 Piotr Borys, Peter Sdobnov

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
unit Render32;

{$define _ASM_}

interface

uses
  Windows, Classes, Forms, Graphics,
  RenderST, RenderTypes, Xform, ControlPoint;

type
  TRenderer32 = class(TBaseSTRenderer)

  protected
    Buckets: TBucket32Array;

    function GetBits: integer; override;
    function GetBucketsPtr: pointer; override;
    procedure AllocateBuckets; override;

    procedure ClearBuckets; override;

  protected
    procedure IterateBatch; override;
    procedure IterateBatchAngle; override;
    procedure IterateBatchFX; override;
    procedure IterateBatchAngleFX; override;
end;

// ----------------------------------------------------------------------------

type
  TRenderer32MM = class(TRenderer32)

  protected
    procedure CalcBufferSize; override;

  public
    procedure Render; override;

end;

implementation

uses
  Math, Sysutils;

{ TRenderer32 }

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer32.ClearBuckets;
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
function TRenderer32.GetBits: integer;
begin
  Result := BITS_32;
end;

function TRenderer32.GetBucketsPtr: pointer;
begin
  Result := Buckets;
end;

procedure TRenderer32.AllocateBuckets;
begin
  SetLength(buckets, BucketHeight, BucketWidth);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer32.IterateBatch;
var
  i: integer;
  px, py: double;
  Bucket: PBucket32;
  MapColor: PColorMapColor;

  p: TCPPoint;
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
    xf.NextPoint(p);
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);
    end;

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);

      if (xf.plotMode < 0) then continue
      else if (xf.plotMode = 0) and (random > xf.opacity) then continue;

      px := p.x - camX0;
      if (px < 0) or (px > camW) then continue;
      py := p.y - camY0;
      if (py < 0) or (py > camH) then continue;

      Bucket := @buckets[Round(bhs * py)][Round(bws * px)];
      MapColor := @ColorMap[Round(p.c * 255)];

      Inc(Bucket.Red,   MapColor.Red);
      Inc(Bucket.Green, MapColor.Green);
      Inc(Bucket.Blue,  MapColor.Blue);
      Inc(Bucket.Count);
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;

procedure TRenderer32.IterateBatchAngle;
var
  i: integer;
  px, py: double;
  Bucket: PBucket32;
  MapColor: PColorMapColor;

  p: TCPPoint;
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
    xf.NextPoint(p);
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);
    end;

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);

      if (xf.plotMode < 0) then continue
      else if (xf.plotMode = 0) and (random > xf.opacity) then continue;

      px := p.x * cosa + p.y * sina + rcX;
      if (px < 0) or (px > camW) then continue;
      py := p.y * cosa - p.x * sina + rcY;
      if (py < 0) or (py > camH) then continue;

      Bucket := @buckets[Round(bhs * py)][Round(bws * px)];
      MapColor := @ColorMap[Round(p.c * 255)];

      Inc(Bucket.Red,   MapColor.Red);
      Inc(Bucket.Green, MapColor.Green);
      Inc(Bucket.Blue,  MapColor.Blue);
      Inc(Bucket.Count);
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;


procedure TRenderer32.IterateBatchFX;
var
  i: integer;
  px, py: double;
  Bucket: PBucket32;
  MapColor: PColorMapColor;

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
    xf.NextPoint(p);
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);
    end;

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);

      if (xf.plotMode < 0) then continue
      else if (xf.plotMode = 0) and (random > xf.opacity) then continue;

      finalXform.NextPointTo(p, q);

      px := q.x - camX0;
      if (px < 0) or (px > camW) then continue;
      py := q.y - camY0;
      if (py < 0) or (py > camH) then continue;

      Bucket := @buckets[Round(bhs * py)][Round(bws * px)];
      MapColor := @ColorMap[Round(q.c * 255)];

      Inc(Bucket.Red,   MapColor.Red);
      Inc(Bucket.Green, MapColor.Green);
      Inc(Bucket.Blue,  MapColor.Blue);
      Inc(Bucket.Count);
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;

procedure TRenderer32.IterateBatchAngleFX;
var
  i: integer;
  px, py: double;
  Bucket: PBucket32;
  MapColor: PColorMapColor;

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
    xf.NextPoint(p);
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);
    end;

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);

      if (xf.plotMode < 0) then continue
      else if (xf.plotMode = 0) and (random > xf.opacity) then continue;

      finalXform.NextPointTo(p, q);

      px := q.x * cosa + q.y * sina + rcX;
      if (px < 0) or (px > camW) then continue;
      py := q.y * cosa - q.x * sina + rcY;
      if (py < 0) or (py > camH) then continue;

      Bucket := @buckets[Round(bhs * py)][Round(bws * px)];
      MapColor := @ColorMap[Round(q.c * 255)];

      Inc(Bucket.Red,   MapColor.Red);
      Inc(Bucket.Green, MapColor.Green);
      Inc(Bucket.Blue,  MapColor.Blue);
      Inc(Bucket.Count);
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;

// -- { TRenderer32MM } -------------------------------------------------------

procedure TRenderer32MM.CalcBufferSize;
begin
  CalcBufferSizeMM;
end;

procedure TRenderer32MM.Render;
begin
  RenderMM;
end;

end.

