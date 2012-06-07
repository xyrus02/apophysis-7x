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
unit RenderingInterface;

interface

uses
  Windows, Graphics, Classes, RenderingCommon,
  Controlpoint, ImageMaker, PngImage, Translation;

///////////////////////////////////////////////////////////////////////////////
//
//  { TBaseRenderer }
//
///////////////////////////////////////////////////////////////////////////////

const
  opRendering: integer = 0;
  opSampling: integer = 1;
  opHibernating: integer = 2;

type
  TOnOutput = procedure(s: string) of object;
  TOnOperation = procedure(op: integer) of object;
  TCopyBufferCallback = procedure(tgr: Pointer; x, y: integer) of object;

type
  TColorMapColor = Record
    Red,
    Green,
    Blue:

    {$ifdef Apo7X64}
    double
    {$else}
    single
    {$endif};
  end;
  PColorMapColor = ^TColorMapColor;
  TColorMapArray = array[0..255] of TColorMapColor;

  TPoint3D = Record
    X,
    Y,
    Z,
    W: Double;
  end;
  TPoint3DArray = array of TPoint3D;

const
  MAX_FILTER_WIDTH = 25;

//const
  //SizeOfBucket: array[0..3] of byte = (32, 32, 32, 32);

function TimeToString(t: TDateTime): string;

type
  TBaseRenderer = class
  private
    FOnProgress: TOnProgress;
    FOnOperation: TOnOperation;
    FCopyBuffer: TCopyBufferCallback;
    strOutput: TStrings;

  protected
    Buckets: TBucketArray;
    ZBuffer: TZBuffer;

    procedure AllocateBuckets;
    procedure ClearBuckets;
    procedure SetBucketsPtr(ptr: pointer);
    function GetBucketsPtr: pointer;

  protected
    camX0, camX1, camY0, camY1, // camera bounds
    camW, camH,                 // camera sizes
    bws, bhs, cosa, sina, rcX, rcY: double;
    ppux, ppuy: extended;

    BucketWidth, BucketHeight: int64;
    BucketSize: int64;

    sample_density: extended;
    oversample: integer;
    gutter_width: Integer;
    max_gutter_width: Integer;

    FCP: TControlPoint;
    FStop: integer;//boolean;
    FHibernated: boolean;

    FImageMaker: TImageMaker;

    ColorMap: TColorMapArray;

    FMaxMem: integer;
    FSlice, FNumSlices: integer;
    image_Width, image_Height: Int64;
    image_Center_X, image_Center_Y: double;

    FCompatibility: integer;
    FNumThreads: integer;
    FNumBatches: integer;//int64;
    FBatch: integer;
    FThreadPriority: TThreadPriority;

    FMinDensity: double;
    FMinBatches: integer;
    FRenderOver: boolean;

    FBufferPath: string;
    FDoExportBuffer: boolean;

    StartTime, RenderTime, PauseTime: TDateTime;

    procedure Progress(value: double);
    procedure Operation(op: integer);

    procedure SetMinDensity(const q: double);

    procedure CreateColorMap; virtual;
    procedure CreateCamera;
    procedure CreateCameraMM;
    procedure Prepare; virtual; abstract;
    procedure SetPixels; virtual; abstract;

    procedure CalcBufferSize; virtual;
    procedure CalcBufferSizeMM;
    
    procedure InitBuffers;
    procedure RenderMM;

    procedure Trace(const str: string);
    procedure TimeTrace(const str: string);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Hibernate(filePath: string);
    procedure Resume(filePath: string);

    procedure SetCP(CP: TControlPoint);
    procedure Render; virtual;
    procedure ProcessBuffer(density: double);
    
    function  GetImage: TBitmap; virtual;
    procedure GetImageAndDelete(target:tBitmap); virtual;
    function  GetTransparentImage: TPngObject;
    procedure UpdateImage(CP: TControlPoint);
    procedure SaveImage(const FileName: String);

    procedure Stop; virtual;
    procedure BreakRender; virtual;
    procedure Pause; virtual;
    procedure UnPause; virtual;
    procedure SetThreadPriority(p: TThreadPriority); virtual;

    function Failed: boolean;
    function Hibernated: boolean;

    procedure ShowBigStats;
    procedure ShowSmallStats;

    property CopyBufferCallback: TCopyBufferCallback
       write FCopyBuffer;
    property OnProgress: TOnProgress
//      read FOnProgress
       write FOnProgress;
    property OnOperation: TOnOperation
       write FOnOperation;
    property MaxMem : integer
        read FMaxMem
       write FMaxMem;
    property NrSlices: integer
        read FNumSlices;
    property Slice: integer
        read FSlice;
    property NumThreads: integer
        read FNumThreads
       write FNumThreads;
    property Output: TStrings
       write strOutput;
    property MinDensity: double
       write SetMinDensity;
    property RenderMore: boolean
       write FRenderOver;
    property Batch: integer
        read FBatch;
    property NrBatches: integer
        read FNumBatches;
    property BufferPath: string
        read FBufferPath
       write FBufferPath;
    property ExportBuffer: boolean
        read FDoExportBuffer
       write FDoExportBuffer;
  end;

///////////////////////////////////////////////////////////////////////////////

  { TRenderer }

///////////////////////////////////////////////////////////////////////////////

type
  TRenderer = class
  private
    FRenderer: TBaseRenderer;

    FOnProgress: TOnProgress;
    FOnOperation: TOnOperation;
    FCopyBuffer: TCopyBufferCallback;
    FCP: TControlPoint;
    FMaxMem: int64;
    FBufferPath: string;
    FNrThreads: integer;

    function GetSlice: integer;
    function GetNrSlices: integer;
    function GetBatch: integer;
    function GetNrBatches: integer;
    function GetNrThreads: integer;

    procedure SetNrThreads(v: integer);

  public
    destructor Destroy; override;

    procedure SetCP(CP: TControlPoint);
    procedure Render;
    procedure ProcessBuffer(density: double);

    function GetImage: TBitmap;
    procedure GetImageAndDelete(target: TBitmap);
    function  GetTransparentImage: TPngObject;
    procedure Stop;

    procedure IntermediateSample(imgmkr: TImageMaker);

    property CopyBufferCallback: TCopyBufferCallback
      read FCopyBuffer
      write FCopyBuffer;
    property OnProgress: TOnProgress
      read FOnProgress
      write FOnProgress;
    property OnOperation: TOnOperation
      read FOnOperation
      write FOnOperation;

    property Slice: integer
      read GetSlice;
    property NrSlices: integer
      read GetNrSlices;

    property Batch: integer
      read GetBatch;
    property NrBatches: integer
      read GetNrBatches;
    property NrThreads: integer
      read FNrThreads
     write FNrThreads;
    property BufferPath: string
      read FBufferPath
      write FBufferPath;

    procedure Hibernate(fileName: string);
  end;

implementation

uses
  Math, SysUtils, Forms,
  RenderingImplementation,
  Binary, Global;

///////////////////////////////////////////////////////////////////////////////
//
//  { TBaseRenderer }
//
///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.Hibernate(filePath: string);
begin
  // todo
end;
procedure TBaseRenderer.Resume(filePath: string);
begin
  // todo
end;
procedure TBaseRenderer.CalcBufferSizeMM;
begin
  oversample := fcp.spatial_oversample;
  gutter_width := (FImageMaker.GetFilterSize - oversample) div 2;
  BucketHeight := oversample * image_height + 2 * gutter_width;
  Bucketwidth := oversample * image_width + 2 * gutter_width;
  BucketSize := BucketWidth * BucketHeight;
end;
procedure TBaseRenderer.RenderMM;
const
  Dividers: array[0..15] of integer = (1, 2, 3, 4, 5, 6, 7, 8, 10, 16, 20, 32, 64, 128, 256, 512);
var
  ApproxMemory, MaxMemory: int64;
  i: integer;
  zoom_scale, center_base, center_y: double;
  t: TDateTime;
begin
  FStop := 0; //False;

  image_Center_X := fcp.center[0];
  image_Center_Y := fcp.center[1];

  image_Height := fcp.Height;
  image_Width := fcp.Width;
  oversample := fcp.spatial_oversample;

  // entered memory - imagesize
  MaxMemory := FMaxMem * 1024 * 1024 - 4 * image_Height * int64(image_Width);

  if (SingleBuffer) then
    ApproxMemory := 16 * sqr(oversample) * image_Height * int64(image_Width)
  else
    ApproxMemory := 32 * sqr(oversample) * image_Height * int64(image_Width);

  assert(MaxMemory > 0);
  if MaxMemory <= 0 then exit;

  FNumSlices := 1 + ApproxMemory div MaxMemory;

  if FNumSlices > Dividers[High(Dividers)] then begin
    for i := High(Dividers) downto 0 do begin
      if image_height <> (image_height div dividers[i]) * dividers[i] then begin
        FNumSlices := dividers[i];
        break;
      end;
    end;
  end else begin
    for i := 0 to High(Dividers) do begin
      if image_height <> (image_height div dividers[i]) * dividers[i] then
        continue;
      if FNumSlices <= dividers[i] then begin
        FNumSlices := dividers[i];
        break;
      end;
    end;
  end;

  FImageMaker.SetCP(FCP);
  FImageMaker.Init;

  fcp.height := fcp.height div FNumSlices;
  center_y := fcp.center[1];
  zoom_scale := power(2.0, fcp.zoom);
  center_base := center_y - ((FNumSlices - 1) * fcp.height) /  (2 * fcp.pixels_per_unit * zoom_scale);

  image_height := fcp.Height;
  image_Width := fcp.Width;

  InitBuffers;
  CreateColorMap;
  Prepare;

  RenderTime := 0;
  for i := 0 to FNumSlices - 1 do begin
    if FStop <> 0 then Exit;

    FSlice := i;
    fcp.center[1] := center_base + fcp.height * slice / (fcp.pixels_per_unit * zoom_scale);
    CreateCameraMM;
    ClearBuckets;
    fcp.actual_density := 0;

    t := Now;
    SetPixels;
    RenderTime := RenderTime + (Now - t);

    if FStop = 0 then begin
      TimeTrace(TextByKey('common-trace-creating-simple'));
      FImageMaker.OnProgress := FOnProgress;
      FImageMaker.CreateImage(Slice * fcp.height);
    end;
  end;

  fcp.height := fcp.height * FNumSlices;
end;
procedure TBaseRenderer.AllocateBuckets;
var
  i, j: integer;
begin
  SetLength(buckets, BucketHeight, BucketWidth);
  SetLength(zbuffer, BucketHeight, BucketWidth);

  for i := 0 to BucketHeight - 1 do
  for j := 0 to BucketWidth - 1 do
  begin
    zbuffer[i, j] := 10e10;
  end;
end;
procedure TBaseRenderer.ClearBuckets;
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
procedure TBaseRenderer.SetBucketsPtr(ptr: pointer);
begin
  Buckets := TBucketArray(ptr);
end;
function TBaseRenderer.GetBucketsPtr: pointer;
begin
  Result := Buckets;
end;

constructor TBaseRenderer.Create;
begin
  inherited Create;

  FNumSlices := 1;
  FSlice := 0;
  FStop := 0; // False;
  FThreadPriority := tpNormal;

  FImageMaker := TImageMaker.Create;
end;

///////////////////////////////////////////////////////////////////////////////
destructor TBaseRenderer.Destroy;
begin
  FImageMaker.Free;

  SetLength(buckets, 1, 1);
  SetLength(zbuffer, 1, 1);

  if assigned(FCP) then
    FCP.Free;

  TrimWorkingSet;

  inherited;
end;

procedure TBaseRenderer.Operation(op: integer);
begin
 if assigned(FOnOperation) then
    FOnOperation(op);
end;
function TRenderer.GetSlice: integer;
begin
  Result := FRenderer.Slice;
end;
function TRenderer.GetNrSlices: integer;
begin
  Result := FRenderer.NrSlices;
end;

function TRenderer.GetBatch: integer;
begin
  Result := FRenderer.Batch;
end;
function TRenderer.GetNrBatches: integer;
begin
  Result := FRenderer.NrBatches;
end;

function TRenderer.GetNrThreads: integer;
begin
  Result := FRenderer.NumThreads;
end;
procedure TRenderer.SetNrThreads(v: integer);
begin
  FRenderer.NumThreads := v;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.SetCP(CP: TControlPoint);
begin
  if assigned(FCP) then
    FCP.Free;

  FCP := Cp.Clone;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.Trace(const str: string);
begin
  if assigned(strOutput) then
    strOutput.Add(str);
end;

procedure TBaseRenderer.TimeTrace(const str: string);
begin
  if assigned(strOutput) then
    strOutput.Add(TimeToStr(Now) + ' : ' + str);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.Pause;
begin
  PauseTime := Now;

  TimeTrace(TextByKey('common-trace-pausing'));
end;

procedure TBaseRenderer.UnPause;
var
  tNow: TDateTime;
begin
  tNow := Now;
  RenderTime := RenderTime + (tNow - PauseTime);

  TimeTrace(TextByKey('common-trace-resuming'));
end;

procedure TBaseRenderer.SetThreadPriority(p: TThreadPriority);
begin
  FThreadPriority := p;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.Stop;
begin
  TimeTrace(TextByKey('common-trace-terminating'));

  FStop := 1; //True;
end;

procedure TBaseRenderer.BreakRender;
begin
  TimeTrace(TextByKey('common-trace-stopping'));

  FStop := -1;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.Progress(value: double);
begin
  if assigned(FOnprogress) then
    FOnprogress(Value);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.SetMinDensity(const q: double);
begin
  if q < fcp.sample_density then FMinDensity := q
  else FMinDensity := fcp.sample_density;
end;

///////////////////////////////////////////////////////////////////////////////
function TBaseRenderer.Failed: boolean;
begin
  Result := (FStop > 0);
end;

function TBaseRenderer.Hibernated: boolean;
begin
  Result := FHibernated;
end;

///////////////////////////////////////////////////////////////////////////////
function TBaseRenderer.GetImage: TBitmap;
begin
  if FStop > 0 then begin
    assert(false);
    FImageMaker.OnProgress := FOnProgress;
    FImageMaker.CreateImage;
  end;
  Result := FImageMaker.GetImage;
end;

procedure TBaseRenderer.GetImageAndDelete(target:tBitmap);
begin
  if FStop > 0 then begin
    assert(false);
    FImageMaker.OnProgress := FOnProgress;
    FImageMaker.CreateImage;
  end;
  FImageMaker.GetImageAndDelete(target);
end;

procedure TRenderer.GetImageAndDelete(target:tBitmap);
begin
  FRenderer.GetImageAndDelete(target);
end;

///////////////////////////////////////////////////////////////////////////////
function TBaseRenderer.GetTransparentImage: TPngObject;
begin
  if FStop > 0 then begin
    // shouldn't happen. and if it does...WTF?
    Result := nil;
  end
  else
    Result := FImageMaker.GetTransparentImage;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.UpdateImage(CP: TControlPoint);
begin
  FCP.background := cp.background;
  FCP.spatial_filter_radius := cp.spatial_filter_radius;
  FCP.gamma := cp.Gamma;
  FCP.vibrancy := cp.vibrancy;
  FCP.contrast := cp.contrast;
  FCP.brightness := cp.brightness;

  FImageMaker.SetCP(FCP);
  FImageMaker.Init;

  FImageMaker.OnProgress := FOnProgress;
  FImageMaker.CreateImage;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.SaveImage(const FileName: String);
begin
  if FStop > 0 then begin
    TimeTrace(Format(TextByKey('common-trace-creating-detailed'), [fcp.actual_density]));
    FImageMaker.OnProgress := FOnProgress;
    FImageMaker.CreateImage;
  end;
  TimeTrace(TextByKey('common-trace-saving'));
  FImageMaker.SaveImage(FileName);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.CreateColorMap;
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
procedure TBaseRenderer.CreateCamera;
var
  scale: double;
  t0, t1: double;
  t2, t3: double;
  corner_x, corner_y, Xsize, Ysize: double;
  shift: Integer;
begin
  scale := power(2, fcp.zoom);
  sample_density := fcp.sample_density * scale * scale;
  ppux := fcp.pixels_per_unit * scale;
  ppuy := fcp.pixels_per_unit * scale;
  shift := 0;

  corner_x := fcp.center[0] - fcp.Width / ppux / 2.0;
  corner_y := fcp.center[1] - fcp.Height / ppuy / 2.0;
  t0 := gutter_width / (oversample * ppux);
  t1 := gutter_width / (oversample * ppuy);
  t2 := (2 * max_gutter_width - gutter_width) / (oversample * ppux);
  t3 := (2 * max_gutter_width - gutter_width) / (oversample * ppuy);

  camX0 := corner_x - t0;
  camY0 := corner_y - t1 + shift;
  camX1 := corner_x + fcp.Width / ppux + t2;
  camY1 := corner_y + fcp.Height / ppuy + t3; //+ shift;

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
    rcX := FCP.Center[0]*(1 - cosa) - FCP.Center[1]*sina - camX0;
    rcY := FCP.Center[1]*(1 - cosa) + FCP.Center[0]*sina - camY0;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.CreateCameraMM;
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
    rcX := image_Center_X*(1 - cosa) - image_Center_Y*sina - camX0;
    rcY := image_Center_Y*(1 - cosa) + image_Center_X*sina - camY0;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.CalcBufferSize;
begin
  oversample := fcp.spatial_oversample;
  max_gutter_width := (MAX_FILTER_WIDTH - oversample) div 2;
  gutter_width := (FImageMaker.GetFilterSize - oversample) div 2;
  BucketWidth := oversample * fcp.Width + 2 * max_gutter_width;
  BucketHeight := oversample * fcp.Height + 2 * max_gutter_width;
  BucketSize := BucketWidth * BucketHeight;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.InitBuffers;
var
  error_string : string;
begin
  error_string := TextByKey('common-trace-notenoughmemory');

  CalcBufferSize;

  try
    FStop := 0;
    TrimWorkingSet;
    if SingleBuffer then
      TimeTrace(Format(TextByKey('common-trace-allocating'), [BucketSize * 16 / 1048576]))
    else
      TimeTrace(Format(TextByKey('common-trace-allocating'), [BucketSize * 32 / 1048576]));

    AllocateBuckets;

  except
    on EOutOfMemory do begin
      if Assigned(strOutput) then
        strOutput.Add(error_string);
      FStop := 1;
      TrimWorkingSet;
      exit;
    end;
  end;

  // share the buffer with imagemaker
  FImageMaker.SetBucketData(GetBucketsPtr, BucketWidth, BucketHeight, 64);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer.IntermediateSample(imgmkr: TImageMaker);
begin
  FCP.actual_density := FCP.sample_density * FRenderer.FBatch / FRenderer.FNumBatches;
  imgmkr.SetCP(FCP);
  imgmkr.Init;
  imgmkr.SetBucketData(FRenderer.GetBucketsPtr, FRenderer.BucketWidth, FRenderer.BucketHeight, 64);
  imgmkr.CreateImage;
end;

procedure TBaseRenderer.Render;
begin
  if fcp.NumXForms <= 0 then
  begin
    exit;
  end;
  FStop := 0; //False;

  FImageMaker.SetCP(FCP);
  FImageMaker.Init;

  InitBuffers;
  if FStop <> 0 then exit; // memory allocation error?

  CreateColorMap;
  Prepare;

  CreateCamera;
  if not FRenderOver then ClearBuckets;

  Operation(opRendering);

  StartTime := Now;
  RenderTime := Now;
  SetPixels;
  RenderTime := Now - RenderTime;

  if FStop <= 0 then begin
    if fcp.sample_density = fcp.actual_density then
      TimeTrace(TextByKey('common-trace-creating-simple'))
    else
      TimeTrace(Format(TextByKey('common-trace-creating-detailed'), [fcp.actual_density]));

    if (FBufferPath <> '') then begin
      Operation(opHibernating);
      Hibernate(FBufferPath);
    end;

    Operation(opSampling);
    FImageMaker.OnProgress := FOnProgress;
    FImageMaker.CreateImage;
  end;
end;

procedure TBaseRenderer.ProcessBuffer(density: double);
var
  nsamples: int64;
  x, y: integer;
  bucket : TBucket;
  ptr: TBucketArray;
begin
  if fcp.NumXForms <= 0 then exit;
  FStop := 0; //False;

  FImageMaker.SetCP(FCP);
  FImageMaker.Init;

  InitBuffers;
  if FStop <> 0 then exit; // memory allocation error?

  CreateColorMap;
  Prepare;

  CreateCamera;
  if not FRenderOver then ClearBuckets;

  Operation(opSampling);

  StartTime := Now;
  RenderTime := Now;
  //////////////// <SetPixels>
  Randomize;

  NSamples := Round(sample_density * NrSlices * bucketSize / (oversample * oversample));
  FNumBatches := Round(nsamples / (fcp.nbatches * SUB_BATCH_SIZE));
  if FNumBatches = 0 then FNumBatches := 1;
  FMinBatches := Round(FNumBatches * FMinDensity / fcp.sample_density);
  if FMinBatches = 0 then FMinBatches := 1;

  ptr := TBucketArray(GetBucketsPtr);
  if (assigned(FCopyBuffer)) then begin
    for y := 0 to BucketHeight - 1 do
    for x := 0 to BucketWidth - 1 do
    begin
      FCopyBuffer(@bucket, x, y);
      ptr[y, x].red := bucket.red;
      ptr[y, x].green := bucket.green;
      ptr[y, x].blue := bucket.blue;
      ptr[y, x].count := bucket.count;
    end;

  end;
  FBatch := FNumBatches;

  fcp.actual_density := density;

  Progress(0);
  //////////////// </SetPixels>
  RenderTime := Now - RenderTime;

  if FStop <= 0 then begin
    if fcp.sample_density = fcp.actual_density then
      TimeTrace(TextByKey('common-trace-creating-simple'))
    else
      TimeTrace(Format(TextByKey('common-trace-creating-detailed'), [fcp.actual_density]));

    //Operation(opSampling);
    FImageMaker.OnProgress := FOnProgress;
    FImageMaker.CreateImage;
  end;

end;

///////////////////////////////////////////////////////////////////////////////
//
//  { TRenderer }
//
///////////////////////////////////////////////////////////////////////////////

destructor TRenderer.Destroy;
begin
  if assigned(FRenderer) then
    FRenderer.Free;

  inherited;
end;

///////////////////////////////////////////////////////////////////////////////
function TRenderer.GetImage: TBitmap;
begin
  Result := nil;
  if assigned(FRenderer) then
    Result := FRenderer.GetImage;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer.SetCP(CP: TControlPoint);
begin
  FCP := CP;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer.ProcessBuffer(density: double);
begin
  if assigned(FRenderer) then
    FRenderer.Free;

  assert(Fmaxmem=0);
   if FNrThreads <= 1 then
    FRenderer := TRenderWorkerST.Create
   else begin
    FRenderer := TRenderWorkerMT.Create;
    FRenderer.NumThreads := FNrThreads;
   end;

  FRenderer.SetCP(FCP);
  FRenderer.OnProgress := FOnProgress;
  FRenderer.OnOperation := FOnOperation;
  FRenderer.CopyBufferCallback := FCopyBuffer;
  FRenderer.BufferPath := '';
  FRenderer.ProcessBuffer(density);
end;
procedure TRenderer.Render;
begin
  if assigned(FRenderer) then
    FRenderer.Free;

  assert(Fmaxmem=0);
    if FNrThreads <= 1 then
      FRenderer := TRenderWorkerST.Create

    else begin
      FRenderer := TRenderWorkerMT.Create;
      FRenderer.NumThreads := FNrThreads;
    end;

  FRenderer.SetCP(FCP);
  FRenderer.OnProgress := FOnProgress;
  FRenderer.OnOperation := FOnOperation;
  FRenderer.BufferPath := FBufferPath;
  FRenderer.Render;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer.Stop;
begin
  if assigned(FRenderer) then
    FRenderer.Stop;
end;

procedure TRenderer.Hibernate(fileName: string);
begin
  FRenderer.Hibernate(fileName);
end;

function TRenderer.GetTransparentImage: TPngObject;
begin
  Result := FRenderer.GetTransparentImage;
end;

function TimeToString(t: TDateTime): string;
var
  n: integer;
begin
  n := Trunc(t);
  Result := '';
  if n > 0 then begin
    Result := Result + Format(' %d ' + TextByKey('common-days'), [n]);
    //if n <> 1 then Result := Result + 's';
  end;
  t := t * 24;
  n := Trunc(t) mod 24;
  if n > 0 then begin
    Result := Result + Format(' %d ' + TextByKey('common-hours'), [n]);
    //if n <> 1 then Result := Result + 's';
  end;
  t := t * 60;
  n := Trunc(t) mod 60;
  if n > 0 then begin
    Result := Result + Format(' %d ' + TextByKey('common-minutes'), [n]);
    //if n <> 1 then Result := Result + 's';
  end;
  t := t * 60;
  t := t - (Trunc(t) div 60) * 60;
  Result := Result + Format(' %.2f ' + TextByKey('common-seconds'), [t]);
end;
procedure TBaseRenderer.ShowBigStats;
var
  Stats: TBucketStats;
  TotalSamples: int64;

  Rbits, Gbits, Bbits, Abits: double;
begin
  if not assigned(strOutput) then exit;

  strOutput.Add('');
  if NrSlices = 1 then
    strOutput.Add(TextByKey('common-statistics-title-oneslice'))
  else
    strOutput.Add(TextByKey('common-statistics-title-multipleslices')); // not really useful :-\

  TotalSamples := int64(FNumBatches) * SUB_BATCH_SIZE; // * fcp.nbatches ?
  if TotalSamples <= 0 then begin
    //strOutput.Add('  Nothing to talk about!'); // normally shouldn't happen
    exit;
  end;
  strOutput.Add(Format('  ' + TextByKey('common-statistics-maxpossiblebits'), [8 + log2(TotalSamples)]));
  FImageMaker.GetBucketStats(Stats);
  with Stats do begin
    if MaxR > 0 then Rbits := log2(MaxR) else Rbits := 0;
    if MaxG > 0 then Gbits := log2(MaxG) else Gbits := 0;
    if MaxB > 0 then Bbits := log2(MaxB) else Bbits := 0;
    if MaxA > 0 then Abits := log2(MaxA) else Abits := 0;
    strOutput.Add(Format('  ' + TextByKey('common-statistics-maxred'), [Rbits]));
    strOutput.Add(Format('  ' + TextByKey('common-statistics-maxgreen'), [Gbits]));
    strOutput.Add(Format('  ' + TextByKey('common-statistics-maxblue'), [Bbits]));
    strOutput.Add(Format('  ' + TextByKey('common-statistics-maxcounter'), [Abits]));
    strOutput.Add(Format('  ' + TextByKey('common-statistics-pointhitratio'), [100.0*(TotalA/TotalSamples)]));
    if RenderTime > 0 then // hmm
      strOutput.Add(Format('  ' + TextByKey('common-statistics-averagespeed'), [TotalSamples / (RenderTime * 24 * 60 * 60)]));
    strOutput.Add('  ' + TextByKey('common-statistics-purerenderingtime') + TimeToString(RenderTime));
  end;
end;

procedure TBaseRenderer.ShowSmallStats;
var
  TotalSamples: int64;
begin
  if not assigned(strOutput) then exit;

  TotalSamples := int64(FNumBatches) * SUB_BATCH_SIZE; // * fcp.nbatches ?
  if RenderTime > 0 then // hmm
      strOutput.Add(Format('  ' + TextByKey('common-statistics-averagespeed'), [TotalSamples / (RenderTime * 24 * 60 * 60)]));
    strOutput.Add('  ' + TextByKey('common-statistics-purerenderingtime') + TimeToString(RenderTime));
end;


end.

