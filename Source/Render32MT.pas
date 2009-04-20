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
unit Render32MT;

interface

uses
  Windows, Forms, Classes, Graphics,
  Render, RenderMT, ControlPoint, ImageMaker, RenderTypes;

type
  TRenderer32MT = class(TBaseMTRenderer)

  protected
    Buckets: TBucket32Array;

    function GetBits: integer; override;
    function GetBucketsPtr: pointer; override;
    procedure AllocateBuckets; override;

    procedure ClearBuckets; override;

  public
    procedure AddPointsToBuckets(const points: TPointsArray); override;
    procedure AddPointsToBucketsAngle(const points: TPointsArray); override;

end;

// ----------------------------------------------------------------------------

type
  TRenderer32MT_MM = class(TRenderer32MT)

  protected
    procedure CalcBufferSize; override;

  public
    procedure Render; override;

end;

implementation

uses
  Math, Sysutils;

{ TRenderer32MT }

///////////////////////////////////////////////////////////////////////////////
function TRenderer32MT.GetBits: integer;
begin
  Result := BITS_32;
end;

function TRenderer32MT.GetBucketsPtr: pointer;
begin
  Result := Buckets;
end;

procedure TRenderer32MT.AllocateBuckets;
begin
  SetLength(buckets, BucketHeight, BucketWidth);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer32MT.ClearBuckets;
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
procedure TRenderer32MT.AddPointsToBuckets(const points: TPointsArray);
var
  i: integer;
  px, py: double;
  Bucket: PBucket32;
  MapColor: PColorMapColor;
begin
  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
    px := points[i].x - camX0;
    if (px < 0) or (px > camW) then continue;
    py := points[i].y - camY0;
    if (py < 0) or (py > camH) then continue;

    Bucket := @buckets[Round(bhs * py)][Round(bws * px)];
    MapColor := @ColorMap[Round(points[i].c * 255)];

    Inc(Bucket.Red,   MapColor.Red);
    Inc(Bucket.Green, MapColor.Green);
    Inc(Bucket.Blue,  MapColor.Blue);
    Inc(Bucket.Count);
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer32MT.AddPointsToBucketsAngle(const points: TPointsArray);
var
  i: integer;
  px, py: double;
  Bucket: PBucket32;
  MapColor: PColorMapColor;
begin
  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
    px := points[i].x * cosa + points[i].y * sina + rcX;
    if (px < 0) or (px > camW) then continue;
    py := points[i].y * cosa - points[i].x * sina + rcY;
    if (py < 0) or (py > camH) then continue;

    Bucket := @buckets[Round(bhs * py)][Round(bws * px)];
    MapColor := @ColorMap[Round(points[i].c * 255)];

    Inc(Bucket.Red,   MapColor.Red);
    Inc(Bucket.Green, MapColor.Green);
    Inc(Bucket.Blue,  MapColor.Blue);
    Inc(Bucket.Count);
  end;
end;

// -- { TRenderer32MT_MM } ----------------------------------------------------

procedure TRenderer32MT_MM.CalcBufferSize;
begin
  CalcBufferSizeMM;
end;

procedure TRenderer32MT_MM.Render;
begin
  RenderMM;
end;

end.

