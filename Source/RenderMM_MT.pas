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
unit RenderMM_MT;

interface

uses
  Windows, Forms, Graphics,
  Render64MT, Controlpoint, ImageMaker, BucketFillerThread, XForm;

type
  TRendererMM64_MT = class(TRenderer64MT)

  private
    image_Width, image_Height: int64;
    image_Center_X, image_Center_Y: double;

    Slice, nrSlices: integer;

    procedure InitBuffers;
    procedure CreateCamera;

  protected
    function GetSlice: integer; override;
    function GetNrSlices: integer; override;

  public
    function  GetImage: TBitmap; override;

    procedure Render; override;
    procedure Stop; override;

    procedure Pause(paused: boolean); override;
  end;

implementation

uses
  Math, Sysutils;

{ TRendererMM64_MT }

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64_MT.CreateCamera;
var
  scale: double;
  t0, t1: double;
  corner_x, corner_y, Xsize, Ysize: double;
  shift: Integer;
begin
  scale := power(2, fcp.zoom);
  sample_density := fcp.sample_density * scale * scale;
  ppux := fcp.pixels_per_unit * scale;
  ppuy := fcp.pixels_per_unit * scale;
  // todo field stuff
  shift := 0;
  t0 := gutter_width / (oversample * ppux);
  t1 := gutter_width / (oversample * ppuy);
  corner_x := fcp.center[0] - image_width / ppux / 2.0;
  corner_y := fcp.center[1] - image_height / ppuy / 2.0;

  camX0 := corner_x - t0;
  camY0 := corner_y - t1 + shift;
  camX1 := corner_x + image_width / ppux + t0;
  camY1 := corner_y + image_height / ppuy + t1; //+ shift;
  camW := camX1 - camX0;
  if abs(camW) > 0.01 then
    Xsize := 1.0 / camW
  else
    Xsize := 1;
  camH := camY1 - camY0;
  if abs(camH) > 0.01 then
    Ysize := 1.0 / camH
  else
    Ysize := 1;
  bws := (BucketWidth - 0.5)  * Xsize;
  bhs := (BucketHeight - 0.5) * Ysize;

  if FCP.FAngle <> 0 then
  begin
    cosa := cos(FCP.FAngle);
    sina := sin(FCP.FAngle);
    rcX := image_Center_X*(1 - cosa) - image_Center_X*sina - camX0;
    rcY := image_Center_Y*(1 - cosa) + image_Center_Y*sina - camY0;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TRendererMM64_MT.GetImage: TBitmap;
begin
  Result := FImageMaker.GetImage;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64_MT.InitBuffers;
begin
  oversample := fcp.spatial_oversample;
  gutter_width := (FImageMaker.GetFilterSize - oversample) div 2;
  BucketHeight := oversample * image_height + 2 * gutter_width;
  Bucketwidth := oversample * image_width + 2 * gutter_width;
  BucketSize := BucketWidth * BucketHeight;

  if high(buckets) <> (BucketSize - 1) then
  try
    SetLength(buckets, BucketSize);
  except
    on EOutOfMemory do begin
      Application.MessageBox('Error: not enough memory for this render!', 'Apophysis', 48);
      FStop := true;
      exit;
    end;
  end;

  // share the buffer with imagemaker
  FImageMaker.SetBucketData(Buckets, BucketWidth);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64_MT.Stop;
var
  i: integer;
begin
  for i := 0 to NrOfTreads - 1 do
    WorkingThreads[i].Terminate;

  inherited;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64_MT.Pause(paused: boolean);
var
  i: integer;
begin
  if paused then begin
    for i := 0 to NrOfTreads - 1 do
      WorkingThreads[i].Suspend;
  end
  else begin
    for i := 0 to NrOfTreads - 1 do
      WorkingThreads[i].Resume;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRendererMM64_MT.Render;
const
  Dividers: array[0..15] of integer = (1, 2, 3, 4, 5, 6, 7, 8, 10, 16, 20, 32, 64, 128, 256, 512);
var
  ApproxMemory, MaxMemory: int64;
  i: integer;
  zoom_scale, center_base, center_y: double;
begin
  FStop := False;

  image_Center_X := fcp.center[0];
  image_Center_Y := fcp.center[1];

  image_height := fcp.Height;
  image_Width := fcp.Width;
  oversample := fcp.spatial_oversample;

  // entered memory - imagesize
  MaxMemory := FMaxMem * 1024 * 1024 - 4 * image_height * int64(image_width);

  ApproxMemory := 32 * oversample * oversample * image_height * int64(image_width);

  if (MaxMemory < 0) then
    Exit;

  nrSlices := 1 + ApproxMemory div MaxMemory;

  if nrSlices > Dividers[High(Dividers)] then begin
    for i := High(Dividers) downto 0 do begin
      if image_height <> (image_height div dividers[i]) * dividers[i] then begin
        nrSlices := dividers[i];
        break;
      end;
    end;
  end else begin
    for i := 0 to High(Dividers) do begin
      if image_height <> (image_height div dividers[i]) * dividers[i] then
        continue;
      if nrslices <= dividers[i] then begin
        nrSlices := dividers[i];
        break;
      end;
    end;
  end;

  FImageMaker.SetCP(FCP);
  FImageMaker.Init;

  fcp.sample_density := fcp.sample_density * nrslices;
  fcp.height := fcp.height div nrslices;
  center_y := fcp.center[1];
  zoom_scale := power(2.0, fcp.zoom);
  center_base := center_y - ((nrslices - 1) * fcp.height) /  (2 * fcp.pixels_per_unit * zoom_scale);

  image_height := fcp.Height;
  image_Width := fcp.Width;

  InitBuffers;
  CreateColorMap;
  fcp.Prepare;

  for i := 0 to NrSlices - 1 do begin
    if FStop then
      Exit;

    Slice := i;
    fcp.center[1] := center_base + fcp.height * slice / (fcp.pixels_per_unit * zoom_scale);
    CreateCamera;
    ClearBuffers;
    SetPixelsMT;

    if not FStop then begin
      FImageMaker.OnProgress := OnProgress;
      FImageMaker.CreateImage(Slice * fcp.height);
    end;
  end;

  fcp.sample_density := fcp.sample_density / nrslices;
  fcp.height := fcp.height * nrslices;
end;

///////////////////////////////////////////////////////////////////////////////
function TRendererMM64_MT.GetSlice: integer;
begin
  Result := Slice;
end;

///////////////////////////////////////////////////////////////////////////////
function TRendererMM64_MT.GetNrSlices: integer;
begin
  Result := NrSlices;
end;

///////////////////////////////////////////////////////////////////////////////
end.

