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
unit Render48;

{$define _ASM_}

interface

uses
  Windows, Classes, Forms, Graphics, ImageMaker,
  RenderST, RenderTypes, Xform, ControlPoint;

type
  pInt64 = ^int64;

type
  TRenderer48 = class(TBaseSTRenderer)

  protected
    Buckets: TBucket48Array;
    ColorMap: TColorMapArray;

    function GetBits: integer; override;
    function GetBucketsPtr: pointer; override;
    procedure AllocateBuckets; override;

//    procedure InitBuffers; override;
    procedure ClearBuckets; override;
    procedure CreateColorMap; override;

  protected
    procedure IterateBatch; override;
    procedure IterateBatchAngle; override;
    procedure IterateBatchFX; override;
    procedure IterateBatchAngleFX; override;

end;

// ----------------------------------------------------------------------------

type
  TRenderer48MM = class(TRenderer48)

  protected
    procedure CalcBufferSize; override;

  public
    procedure Render; override;

end;

implementation

uses
  Math, Sysutils;

{ TRenderer48 }

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer48.ClearBuckets;
var
  i, j: integer;
begin
  for j := 0 to BucketHeight - 1 do
    for i := 0 to BucketWidth - 1 do
      with buckets[j][i] do begin
        rl := 0; rh := 0;
        gl := 0; gh := 0;
        bl := 0; bh := 0;
        cl := 0; ch := 0;
      end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer48.CreateColorMap;
var
  i: integer;
begin
  for i := 0 to 255 do
    with ColorMap[i] do begin
      Red   := (fcp.CMap[i][0] * fcp.white_level) div 256;
      Green := (fcp.CMap[i][1] * fcp.white_level) div 256;
      Blue  := (fcp.CMap[i][2] * fcp.white_level) div 256;
    end;
end;

///////////////////////////////////////////////////////////////////////////////
function TRenderer48.GetBits: integer;
begin
  Result := BITS_48;
end;

function TRenderer48.GetBucketsPtr: pointer;
begin
  Result := Buckets;
end;

procedure TRenderer48.AllocateBuckets;
begin
  SetLength(buckets, BucketHeight, BucketWidth);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer48.IterateBatch;
var
  i: integer;
  px, py: double;
  pBucket: PBucket48;
  MapColor: PColorMapColor;

  p: TCPPoint;
  xf: TXForm;
  t: int64;
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
    xf := fcp.xform[0];//random(fcp.NumXForms)];
    xf.NextPoint(p);
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);
    end;

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);

      if xf.noPlot then continue;

      px := p.x - camX0;
      if (px < 0) or (px > camW) then continue;
      py := p.y - camY0;
      if (py < 0) or (py > camH) then continue;

      pBucket := @buckets[Round(bhs * py)][Round(bws * px)];
      MapColor := @ColorMap[Round(p.c * 255)];

{$ifndef _ASM_}
      // HACK warning!!!
      // this WILL corrupt data in case of 48-bit overflow!
      Inc((pInt64(@pBucket^.rl))^,   MapColor.Red);
      Inc((pInt64(@pBucket^.gl))^,   MapColor.Green);
      Inc((pInt64(@pBucket^.bl))^,   MapColor.Blue);
      Inc((pInt64(@pBucket^.cl))^);
{$else}
asm
    mov     edx, [MapColor]
    mov     ecx, [pBucket]
    mov     eax, [edx]
    add     [ecx], eax
    jnc     @skip_r
    inc     word ptr [ecx + 4]
@skip_r:
    mov     eax, [edx + 4]
    add     [ecx + 6], eax
    jnc     @skip_g
    inc     word ptr [ecx + 10]
@skip_g:
    mov     eax, [edx + 8]
    add     [ecx + 12], eax
    jnc     @skip_b
    inc     word ptr [ecx + 16]
@skip_b:
    inc     [ecx + 18]
    jnc     @skip_c
    inc     word ptr [ecx + 22]
@skip_c:
end;
{$endif}
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;

procedure TRenderer48.IterateBatchAngle;
var
  i: integer;
  px, py: double;
  pBucket: PBucket48;
  MapColor: PColorMapColor;

  p: TCPPoint;
  xf: TXForm;
  t: int64;
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
    xf := fcp.xform[0];//random(fcp.NumXForms)];
    xf.NextPoint(p);
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);
    end;

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);

      if xf.noPlot then continue;

      px := p.x * cosa + p.y * sina + rcX;
      if (px < 0) or (px > camW) then continue;
      py := p.y * cosa - p.x * sina + rcY;
      if (py < 0) or (py > camH) then continue;

      pBucket := @buckets[Round(bhs * py)][Round(bws * px)];
      MapColor := @ColorMap[Round(p.c * 255)];

{$ifndef _ASM_}
      // HACK warning!!!
      // this WILL corrupt data in case of 48-bit overflow!
      Inc((pInt64(@pBucket^.rl))^,   MapColor.Red);
      Inc((pInt64(@pBucket^.gl))^,   MapColor.Green);
      Inc((pInt64(@pBucket^.bl))^,   MapColor.Blue);
      Inc((pInt64(@pBucket^.cl))^);
{$else}
asm
    mov     edx, [MapColor]
    mov     ecx, [pBucket]
    mov     eax, [edx]
    add     [ecx], eax
    jnc     @skip_r
    inc     word ptr [ecx + 4]
@skip_r:
    mov     eax, [edx + 4]
    add     [ecx + 6], eax
    jnc     @skip_g
    inc     word ptr [ecx + 10]
@skip_g:
    mov     eax, [edx + 8]
    add     [ecx + 12], eax
    jnc     @skip_b
    inc     word ptr [ecx + 16]
@skip_b:
    inc     [ecx + 18]
    jnc     @skip_c
    inc     word ptr [ecx + 22]
@skip_c:
end;
{$endif}
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;


procedure TRenderer48.IterateBatchFX;
var
  i: integer;
  px, py: double;
  pBucket: PBucket48;
  MapColor: PColorMapColor;

  p, q: TCPPoint;
  xf: TXForm;
  t: int64;
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
    xf := fcp.xform[0];//random(fcp.NumXForms)];
    xf.NextPoint(p);
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);
    end;

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);

      if xf.noPlot then continue;

      finalXform.NextPointTo(p, q);

      px := q.x - camX0;
      if (px < 0) or (px > camW) then continue;
      py := q.y - camY0;
      if (py < 0) or (py > camH) then continue;

      pBucket := @buckets[Round(bhs * py)][Round(bws * px)];
      MapColor := @ColorMap[Round(q.c * 255)];

{$ifndef _ASM_}
      // HACK warning!!!
      // this WILL corrupt color-data in case of 48-bit overflow!
      Inc((pInt64(@pBucket^.rl))^,   MapColor.Red);
      Inc((pInt64(@pBucket^.gl))^,   MapColor.Green);
      Inc((pInt64(@pBucket^.bl))^,   MapColor.Blue);
      Inc((pInt64(@pBucket^.cl))^);
{$else}
asm
    mov     edx, [MapColor]
    mov     ecx, [pBucket]
    mov     eax, [edx]
    add     [ecx], eax
    jnc     @skip_r
    inc     word ptr [ecx + 4]
@skip_r:
    mov     eax, [edx + 4]
    add     [ecx + 6], eax
    jnc     @skip_g
    inc     word ptr [ecx + 10]
@skip_g:
    mov     eax, [edx + 8]
    add     [ecx + 12], eax
    jnc     @skip_b
    inc     word ptr [ecx + 16]
@skip_b:
    inc     [ecx + 18]
    jnc     @skip_c
    inc     word ptr [ecx + 22]
@skip_c:
end;
{$endif}
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;

procedure TRenderer48.IterateBatchAngleFX;
var
  i: integer;
  px, py: double;
  pBucket: PBucket48;
  MapColor: PColorMapColor;

  p, q: TCPPoint;
  xf: TXForm;
  t: int64;
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
    xf := fcp.xform[0];//random(fcp.NumXForms)];
    xf.NextPoint(p);
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);
    end;

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);

      if xf.noPlot then continue;

      finalXform.NextPointTo(p, q);

      px := q.x * cosa + q.y * sina + rcX;
      if (px < 0) or (px > camW) then continue;
      py := q.y * cosa - q.x * sina + rcY;
      if (py < 0) or (py > camH) then continue;

      pBucket := @buckets[Round(bhs * py)][Round(bws * px)];
      MapColor := @ColorMap[Round(q.c * 255)];

{$ifndef _ASM_}
      // HACK warning!!!
      // this WILL corrupt color-data in case of 48-bit overflow!
      Inc((pInt64(@pBucket^.rl))^,   MapColor.Red);
      Inc((pInt64(@pBucket^.gl))^,   MapColor.Green);
      Inc((pInt64(@pBucket^.bl))^,   MapColor.Blue);
      Inc((pInt64(@pBucket^.cl))^);
{$else}
asm
    mov     edx, [MapColor]
    mov     ecx, [pBucket]
    mov     eax, [edx]
    add     [ecx], eax
    jnc     @skip_r
    inc     word ptr [ecx + 4]
@skip_r:
    mov     eax, [edx + 4]
    add     [ecx + 6], eax
    jnc     @skip_g
    inc     word ptr [ecx + 10]
@skip_g:
    mov     eax, [edx + 8]
    add     [ecx + 12], eax
    jnc     @skip_b
    inc     word ptr [ecx + 16]
@skip_b:
    inc     [ecx + 18]
    jnc     @skip_c
    inc     word ptr [ecx + 22]
@skip_c:
end;
{$endif}
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;

// -- { TRenderer48MM } -------------------------------------------------------

procedure TRenderer48MM.CalcBufferSize;
begin
  CalcBufferSizeMM;
end;

procedure TRenderer48MM.Render;
begin
  RenderMM;
end;

end.

