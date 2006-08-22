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
unit Render32fMT;

interface

uses
  Windows, Forms, Classes, Graphics,
  Render, RenderMT, Controlpoint, ImageMaker, BucketFillerthread, RenderTypes;

type
  TRenderer32fMT = class(TBaseMTRenderer)

  protected
    Buckets: TBucket32fArray;
    FloatColorMap: array[0..255] of TFloatColor;

    function GetBits: integer; override;
    function GetBucketsPtr: pointer; override;
    procedure AllocateBuckets; override;

    procedure ClearBuckets; override;
    procedure CreateColorMap; override;

  public
    procedure AddPointsToBuckets(const points: TPointsArray); override;
    procedure AddPointsToBucketsAngle(const points: TPointsArray); override;

end;

// ----------------------------------------------------------------------------

type
  TRenderer32fMT_MM = class(TRenderer32fMT)

  protected
    procedure CalcBufferSize; override;

  public
    procedure Render; override;

end;

implementation

uses
  Math, Sysutils;

{ TRenderer32fMT }

///////////////////////////////////////////////////////////////////////////////
function TRenderer32fMT.GetBits: integer;
begin
  Result := BITS_32f;
end;

function TRenderer32fMT.GetBucketsPtr: pointer;
begin
  Result := Buckets;
end;

procedure TRenderer32fMT.AllocateBuckets;
begin
  SetLength(buckets, BucketHeight, BucketWidth);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer32fMT.ClearBuckets;
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
procedure TRenderer32fMT.CreateColorMap;
var
  i: integer;
begin
  for i := 0 to 255 do
    with FloatColorMap[i] do begin
      Red   := (fcp.CMap[i][0] * fcp.white_level) / 256;
      Green := (fcp.CMap[i][1] * fcp.white_level) / 256;
      Blue  := (fcp.CMap[i][2] * fcp.white_level) / 256;
    end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer32fMT.AddPointsToBuckets(const points: TPointsArray);
var
  i: integer;
  px, py: double;
//  R: double;
//  V1, v2, v3: integer;
  pBucket: PBucket32f;
  MapColor: ^TFloatColor;
begin
  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
//    if FStop then Exit;

    px := points[i].x - camX0;
    if (px < 0) or (px > camW) then continue;
    py := points[i].y - camY0;
    if (py < 0) or (py > camH) then continue;

    pBucket := @Buckets[Round(bhs * py)][Round(bws * px)];
    MapColor := @FloatColorMap[Round(points[i].c * 255)];

    with pBucket^ do begin
      Red   := Red   + MapColor.Red;
      Green := Green + MapColor.Green;
      Blue  := Blue  + MapColor.Blue;
      Count := Count + 1;
    end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer32fMT.AddPointsToBucketsAngle(const points: TPointsArray);
var
  i: integer;
  px, py: double;
  pBucket: PBucket32f;
  MapColor: ^TFloatColor;
begin
  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
//    if FStop then Exit;

    px := points[i].x * cosa + points[i].y * sina + rcX;
    if (px < 0) or (px > camW) then continue;
    py := points[i].y * cosa - points[i].x * sina + rcY;
    if (py < 0) or (py > camH) then continue;

    pBucket := @Buckets[Round(bhs * py)][Round(bws * px)];
    MapColor := @FloatColorMap[Round(points[i].c * 255)];

    with pBucket^ do begin
      Red   := Red   + MapColor.Red;
      Green := Green + MapColor.Green;
      Blue  := Blue  + MapColor.Blue;
      Count := Count + 1;
    end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
//
//  { TRenderer32fMT_MM }
//
///////////////////////////////////////////////////////////////////////////////

procedure TRenderer32fMT_MM.CalcBufferSize;
begin
  CalcBufferSizeMM;
end;

procedure TRenderer32fMT_MM.Render;
begin
  RenderMM;
end;

end.

