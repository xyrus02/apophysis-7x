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
unit Render48MT;

interface

uses
  Windows, Forms, Classes, Graphics,
  Render, RenderMT, ImageMaker, ControlPoint, RenderTypes;

type
  TRenderer48MT = class(TBaseMTRenderer)

  protected
    Buckets: TBucket48Array;
//    ColorMap: TColorMapArray;

    function GetBits: integer; override;
    function GetBucketsPtr: pointer; override;
    procedure AllocateBuckets; override;

    procedure ClearBuckets; override;
//    procedure CreateColorMap; override;

  public
    procedure AddPointsToBuckets(const points: TPointsArray); override;
    procedure AddPointsToBucketsAngle(const points: TPointsArray); override;

end;

// ----------------------------------------------------------------------------

type
  TRenderer48MT_MM = class(TRenderer48MT)

  protected
    procedure CalcBufferSize; override;

  public
    procedure Render; override;

end;

implementation

uses
  Math, Sysutils;

{ TRenderer48MT }

///////////////////////////////////////////////////////////////////////////////
function TRenderer48MT.GetBits: integer;
begin
  Result := BITS_48;
end;

function TRenderer48MT.GetBucketsPtr: pointer;
begin
  Result := Buckets;
end;

procedure TRenderer48MT.AllocateBuckets;
begin
  SetLength(buckets, BucketHeight, BucketWidth);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer48MT.ClearBuckets;
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
procedure TRenderer48MT.AddPointsToBuckets(const points: TPointsArray);
var
  i: integer;
  px, py: double;
//  R: double;
//  V1, v2, v3: integer;
  pBucket: PBucket48;
  MapColor: PColorMapColor;
begin
  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
//    if FStop then Exit;

    px := points[i].x - camX0;
    if (px < 0) or (px > camW) then continue;
    py := points[i].y - camY0;
    if (py < 0) or (py > camH) then continue;

    pBucket := @Buckets[Round(bhs * py)][Round(bws * px)];
    MapColor := @ColorMap[Round(points[i].c * 255)];

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

  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer48MT.AddPointsToBucketsAngle(const points: TPointsArray);
var
  i: integer;
  px, py: double;
  pBucket: PBucket48;
  MapColor: PColorMapColor;
begin
  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
//    if FStop then Exit;

    px := points[i].x * cosa + points[i].y * sina + rcX;
    if (px < 0) or (px > camW) then continue;
    py := points[i].y * cosa - points[i].x * sina + rcY;
    if (py < 0) or (py > camH) then continue;

    pBucket := @Buckets[Round(bhs * py)][Round(bws * px)];
    MapColor := @ColorMap[Round(points[i].c * 255)];

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

  end;
end;

///////////////////////////////////////////////////////////////////////////////
//
//  { TRenderer48MT_MM }
//
///////////////////////////////////////////////////////////////////////////////

procedure TRenderer48MT_MM.CalcBufferSize;
begin
  CalcBufferSizeMM;
end;

procedure TRenderer48MT_MM.Render;
begin
  RenderMM;
end;

end.

