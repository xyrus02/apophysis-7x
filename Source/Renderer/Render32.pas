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
unit Render32;

{$define _ASM_}

interface

uses
  Windows, Classes, Forms, Graphics, Global,
  RenderST, RenderTypes, Xform, ControlPoint,
  AsmRandom, Hibernation;

type
  TRenderer32 = class(TBaseSTRenderer)

  protected
    Buckets: TBucket32Array;
    CurrentlySavingHibernationFile: Boolean;

    function GetBits: integer; override;
    function GetBucketsPtr: pointer; override;
    procedure AllocateBuckets; override;

    procedure ClearBuckets; override;

  protected
    procedure IterateBatch; override;
    procedure IterateBatchAngle; override;
    procedure IterateBatchFX; override;
    procedure IterateBatchAngleFX; override;

    // StD functionality
    procedure Hibernate(filePath: string); override;
    procedure Resume(filePath: string); override;
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
procedure TRenderer32.Hibernate(filePath: string);
var
  header: THibHeader;
  data: TBucket32Array;
  flame: TControlPoint;
  handle: File;
begin
  PauseTime := Now;
  flame := FCP; //TControlPoint.create;
  //FCP.Copy(flame);
  header := GetHibernationHeader;
  data := Buckets;

  HibAllocate(handle, filePath);
  HibWriteIntro(handle);
  HibWriteGlobals(handle, EFF_NONE, EPL_XYZW, EBP_32);
  HibWriteHeader(handle, header);
  HibWriteData(handle, header, flame, data, colormap, Progress);
  HibWriteOutro(handle);
  HibFree(handle);

  //flame.Destroy;
end;
procedure TRenderer32.Resume(filePath: string);
var
  header: THibHeader;
  flame: TStringList;
  flags: EHibFileFlags;
  layout: EHibPixelLayout;
  bpp: EHibBitsPerPixel;
  rel: SmallInt;
  valid: Boolean;
  handle: File;
begin
  HibOpen(handle, filePath);
  HibReadIntro(handle, valid);
  assert(valid, 'The file had an invalid opening cookie. It may be a wrong format or corrupted.');
  if not valid then exit;

  HibReadGlobals(handle, rel, flags, layout, bpp);
  assert(rel = 0, 'The file was created by another version of the renderer.');
  assert(layout = EPL_XYZW, 'Pixel layout is different than XYZW - alternate layouts are not supported by this version.');
  assert(bpp = EBP_32, 'Only 32-bit buffers are supported by this version.');
  if bpp <> EBP_32 then exit;

  HibReadHeader(handle, header);
  HibReadData(handle, header, flame, buckets, colormap, Progress);

  FCP := TControlPoint.Create;
  FCP.ParseStringList(flame);
  SetHibernationHeader(header);

  HibReadOutro(handle, valid);
  HibFree(handle);

  assert(valid, 'The file had an invalid closing cookie. It may be a wrong format or corrupted.');
end;

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
function TRenderer32.GetBits: integer;      // obsolete
begin
  Result := 0;
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
    call    AsmRandExt
    fadd    st, st
    fsub    st, st(1)
    fstp    qword ptr [p.x]
    call    AsmRandExt
    fadd    st, st
    fsubrp  st(1), st
    fstp    qword ptr [p.y]
    call    AsmRandExt
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

      if random >= xf.transOpacity then continue;

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

procedure TRenderer32.IterateBatchAngle;
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
    call    AsmRandExt
    fadd    st, st
    fsub    st, st(1)
    fstp    qword ptr [p.x]
    call    AsmRandExt
    fadd    st, st
    fsubrp  st(1), st
    fstp    qword ptr [p.y]
    call    AsmRandExt
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

      if random >= xf.transOpacity then continue;

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
    call    AsmRandExt
    fadd    st, st
    fsub    st, st(1)
    fstp    qword ptr [p.x]
    call    AsmRandExt
    fadd    st, st
    fsubrp  st(1), st
    fstp    qword ptr [p.y]
    call    AsmRandExt
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

      if random >= xf.transOpacity then continue;

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
    call    AsmRandExt
    fadd    st, st
    fsub    st, st(1)
    fstp    qword ptr [p.x]
    call    AsmRandExt
    fadd    st, st
    fsubrp  st(1), st
    fstp    qword ptr [p.y]
    call    AsmRandExt
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

      if random >= xf.transOpacity then continue;

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

procedure TRenderer32MM.CalcBufferSize;
begin
  CalcBufferSizeMM;
end;

procedure TRenderer32MM.Render;
begin
  RenderMM;
end;

end.

