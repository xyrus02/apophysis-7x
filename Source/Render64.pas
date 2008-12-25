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
unit Render64;

interface

uses
  Windows, Classes, Forms, Graphics, ImageMaker,
  RenderST, RenderTypes, Xform, ControlPoint;

type
  TRenderer64 = class(TBaseSTRenderer)

  protected
    Buckets: TBucket64Array;
    ColorMap: TColorMapArray;

    function GetBits: integer; override;
    function GetBucketsPtr: pointer; override;
    procedure AllocateBuckets; override;

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
  TRenderer64MM = class(TRenderer64)

  protected
    procedure CalcBufferSize; override;

  public
    procedure Render; override;

end;

implementation

{$define _ASM_}

uses
  Math, Sysutils;

{ TRenderer64 }

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64.ClearBuckets;
var
  i, j: integer;
begin
  for j := 0 to BucketHeight - 1 do
    for i := 0 to BucketWidth - 1 do
    with Buckets[j][i] do begin
      Red   := 0;
      Green := 0;
      Blue  := 0;
      Count := 0;
    end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64.CreateColorMap;
var
  i: integer;
begin
{$IFDEF TESTVARIANT}
  for i := 0 to 255 do begin
    ColorMap[i].Red   := i;
    ColorMap[i].Green := i;
    ColorMap[i].Blue  := i;
//    cmap[i][3] := fcp.white_level;
  end;
{$ELSE}
  for i := 0 to 255 do begin
    ColorMap[i].Red   := (fcp.CMap[i][0] * fcp.white_level) div 256;
    ColorMap[i].Green := (fcp.CMap[i][1] * fcp.white_level) div 256;
    ColorMap[i].Blue  := (fcp.CMap[i][2] * fcp.white_level) div 256;
//    cmap[i][3] := fcp.white_level;
  end;
{$ENDIF}
end;

///////////////////////////////////////////////////////////////////////////////
function TRenderer64.GetBits: integer;
begin
  Result := BITS_64;
end;

function TRenderer64.GetBucketsPtr: pointer;
begin
  Result := Buckets;
end;

procedure TRenderer64.AllocateBuckets;
begin
  SetLength(buckets, BucketHeight, BucketWidth);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer64.IterateBatch;
var
  i: integer;
  px, py: double;
  Bucket: PBucket64;
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
    xf := fcp.xform[0];//random(fcp.NumXForms)];
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

procedure TRenderer64.IterateBatchAngle;
var
  i: integer;
  px, py: double;
  Bucket: PBucket64;
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
    xf := fcp.xform[0];//random(fcp.NumXForms)];
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


procedure TRenderer64.IterateBatchFX;
var
  i: integer;
  px, py: double;
  Bucket: PBucket64;
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
    xf := fcp.xform[0];//random(fcp.NumXForms)];
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

procedure TRenderer64.IterateBatchAngleFX;
var
  i: integer;
  px, py: double;
  Bucket: PBucket64;
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
    xf := fcp.xform[0];//random(fcp.NumXForms)];
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

procedure TRenderer64MM.CalcBufferSize;
begin
  CalcBufferSizeMM;
end;

procedure TRenderer64MM.Render;
begin
  RenderMM;
end;

end.

