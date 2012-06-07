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
unit RenderingImplementation;

{$ifdef Apo7X64}
{$else}
  {$define _ASM_}
{$endif}

interface

uses
{$ifdef Apo7X64}
{$else}
AsmRandom,
{$endif}
  Windows, Classes, Forms, Graphics, Global,
  RenderingInterface, Xform, Math, Translation,
  Binary, RenderingCommon, ControlPoint, Sysutils,
  BucketFillerThread;

type
  TBatchProc = procedure of object;
  TRenderWorkerST = class(TBaseRenderer)

  protected
    PropTable: array[0..PROP_TABLE_SIZE] of TXform;
    finalXform: TXform;
    UseFinalXform: boolean;

    procedure Prepare; override;
    procedure SetPixels; override;

  protected
    procedure IterateBatch;
    procedure IterateBatchAngle;
    procedure IterateBatchFX;
    procedure IterateBatchAngleFX;
end;

type
  TRenderWorkerMT = class(TBaseRenderer)

  protected
    batchcounter: Integer;
    WorkingThreads: array of TBucketFillerThread;
    CriticalSection: TRTLCriticalSection;

    function NewThread: TBucketFillerThread;
    procedure Prepare; override;
    procedure SetPixels; override;
    
  protected
    procedure AddPointsToBuckets(const points: TPointsArray);
    procedure AddPointsToBucketsAngle(const points: TPointsArray);
    
  public
    procedure Stop; override;
    procedure BreakRender; override;

    procedure Pause; override;
    procedure UnPause; override;
end;

type
  TRenderWorkerST_MM = class(TRenderWorkerST)
  protected
    procedure CalcBufferSize; override;
  public
    procedure Render; override;

end;

type
  TRenderWorkerMT_MM = class(TRenderWorkerMT)
  protected
    procedure CalcBufferSize; override;
  public
    procedure Render; override;
end;

// ----------------------------------------------------------------------------

implementation

////////////////////////////////////////////////////////////////////////////////
// PREPARE
////////////////////////////////////////////////////////////////////////////////
procedure TRenderWorkerST.Prepare;
var
  i, n: Integer;
  propsum: double;
  LoopValue: double;
  j: integer;
  TotValue: double;
begin
  totValue := 0;
  n := fcp.NumXforms;
  assert(n > 0);

  finalXform := fcp.xform[n];
  finalXform.Prepare;
  useFinalXform := fcp.FinalXformEnabled and fcp.HasFinalXform;

  fcp.Prepare;
end;
procedure TRenderWorkerMT.Prepare;
begin
  fcp.Prepare;
end;

////////////////////////////////////////////////////////////////////////////////
// SETPIXELS
////////////////////////////////////////////////////////////////////////////////
procedure TRenderWorkerST.SetPixels;
var
  i: integer;
  nsamples: int64;
  IterateBatchProc: procedure of object;
begin
  if FNumSlices > 1 then
    TimeTrace(Format(TextByKey('common-trace-rendering-multipleslices'), [FSlice + 1, FNumSlices]))
  else
    TimeTrace(TextByKey('common-trace-rendering-oneslice'));

  Randomize;

  if FCP.FAngle = 0 then begin
    if UseFinalXform then
      IterateBatchProc := IterateBatchFX
    else
      IterateBatchProc := IterateBatch;
  end
  else begin
    if UseFinalXform then
      IterateBatchProc := IterateBatchAngleFX
    else
      IterateBatchProc := IterateBatchAngle;
  end;

  NSamples := Round(sample_density * NrSlices * bucketSize / (oversample * oversample));
  FNumBatches := Round(nsamples / (fcp.nbatches * SUB_BATCH_SIZE));
  if FNumBatches = 0 then FNumBatches := 1;

  FMinBatches := Round(FNumBatches * FMinDensity / fcp.sample_density);
  if FMinBatches = 0 then FMinBatches := 1;

  for i := 0 to FNumBatches-1 do begin
    if FStop <> 0 then begin
      fcp.actual_density := fcp.actual_density + fcp.sample_density * i / FNumBatches;
      FNumBatches := i;
      exit;
    end;

    if ((i and $1F) = 0) then Progress(i / FNumBatches);

    IterateBatchProc;
    Inc(FBatch);
  end;

  fcp.actual_density := fcp.actual_density + fcp.sample_density;

  Progress(1);
end;
procedure TRenderWorkerMT.SetPixels;
var
  i: integer;
  nSamples: Int64;
  bc : integer;
begin
  if FNumSlices > 1 then
    TimeTrace(Format(TextByKey('common-trace-rendering-multipleslices'), [FSlice + 1, FNumSlices]))
  else
    TimeTrace(TextByKey('common-trace-rendering-oneslice'));

  nSamples := Round(sample_density * NrSlices * BucketSize / (oversample * oversample));
  FNumBatches := Round(nSamples / (fcp.nbatches * SUB_BATCH_SIZE));
  if FNumBatches = 0 then FNumBatches := 1;
  FMinBatches := Round(FNumBatches * FMinDensity / fcp.sample_density);

  batchcounter := 1;
  Randomize;

  InitializeCriticalSection(CriticalSection);

  SetLength(WorkingThreads, NumThreads);
  for i := 0 to NumThreads - 1 do
    WorkingThreads[i] := NewThread;

  for i := 0 to NumThreads - 1 do
    WorkingThreads[i].Resume;

  bc := 1;
  while (FStop = 0) and (bc <= FNumBatches) do begin
    sleep(250);
    try
      EnterCriticalSection(CriticalSection);

      Progress(batchcounter / FNumBatches);
      bc := batchcounter;
    finally
      LeaveCriticalSection(CriticalSection);
    end;
  end;

  for i := 0 to High(WorkingThreads) do begin
    WorkingThreads[i].Terminate;
    WorkingThreads[i].WaitFor;
    WorkingThreads[i].Free;
  end;
  SetLength(WorkingThreads, 0);

  fcp.actual_density := fcp.actual_density +
                        fcp.sample_density * BatchCounter / FNumBatches; // actual quality of incomplete render
  FNumBatches := BatchCounter;

  DeleteCriticalSection(CriticalSection);
  Progress(1);
end;

////////////////////////////////////////////////////////////////////////////////
// MM OVERRIDES
////////////////////////////////////////////////////////////////////////////////
procedure TRenderWorkerST_MM.CalcBufferSize;
begin
  CalcBufferSizeMM;
end;
procedure TRenderWorkerST_MM.Render;
begin
  RenderMM;
end;
procedure TRenderWorkerMT_MM.CalcBufferSize;
begin
  CalcBufferSizeMM;
end;
procedure TRenderWorkerMT_MM.Render;
begin
  RenderMM;
end;

////////////////////////////////////////////////////////////////////////////////
// BATCH ITERATION
////////////////////////////////////////////////////////////////////////////////
procedure TRenderWorkerST.IterateBatch;
var
  i: integer;
  px, py: double;
  Bucket: PBucket;
  ZBufPos: PDouble;
  MapColor: PColorMapColor;

  ix, iy: integer;
  BmpColor: TColor;

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
    xf := fcp.xform[0];
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
      {$ifdef ENABLEZBUF}
      ZBufPos := @zbuffer[Round(bhs * py)][Round(bws * px)];
      if (q.z < ZBufPos^) then
      begin
        ZBufPos^ := q.z;
        Bucket.Red := Bucket.Red + MapColor.Red;
        Bucket.Green := Bucket.Green + MapColor.Green;
        Bucket.Blue := Bucket.Blue + MapColor.Blue;
        Bucket.Count := Bucket.Count + 1;
      end;
      {$else}
        Bucket.Red := Bucket.Red + MapColor.Red;
        Bucket.Green := Bucket.Green + MapColor.Green;
        Bucket.Blue := Bucket.Blue + MapColor.Blue;
        Bucket.Count := Bucket.Count + 1;
      {$endif}
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;
procedure TRenderWorkerST.IterateBatchAngle;
var
  i: integer;
  px, py: double;
  Bucket: PBucket;
  MapColor: PColorMapColor;
  ZBufPos: PDouble;
  ix, iy: integer;
  BmpColor: TColor;

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
    xf := fcp.xform[0];
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);
    end;

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);

      if random >= xf.transOpacity then continue;

      q := p;
      fcp.ProjectionFunc(@q);

      px := q.x * cosa + q.y * sina + rcX;
      if (px < 0) or (px > camW) then continue;
      py := q.y * cosa - q.x * sina + rcY;
      if (py < 0) or (py > camH) then continue;

      Bucket := @buckets[Round(bhs * py)][Round(bws * px)];
      MapColor := @ColorMap[Round(p.c * 255)];

      {$ifdef ENABLEZBUF}
      ZBufPos := @zbuffer[Round(bhs * py)][Round(bws * px)];
      if (q.z < ZBufPos^) then
      begin
        ZBufPos^ := q.z;
        Bucket.Red := Bucket.Red + MapColor.Red;
        Bucket.Green := Bucket.Green + MapColor.Green;
        Bucket.Blue := Bucket.Blue + MapColor.Blue;
        Bucket.Count := Bucket.Count + 1;
      end;
      {$else}
        Bucket.Red := Bucket.Red + MapColor.Red;
        Bucket.Green := Bucket.Green + MapColor.Green;
        Bucket.Blue := Bucket.Blue + MapColor.Blue;
        Bucket.Count := Bucket.Count + 1;
      {$endif}
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;
procedure TRenderWorkerST.IterateBatchFX;
var
  i: integer;
  px, py: double;
  Bucket: PBucket;
  MapColor: PColorMapColor;
  ZbufPos: PDouble;
  ix, iy: integer;
  BmpColor: TColor;

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
    xf := fcp.xform[0];
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);
    end;

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);

      if random >= xf.transOpacity then continue;

      finalXform.NextPointTo(p, q);
      fcp.ProjectionFunc(@q);

      px := q.x - camX0;
      if (px < 0) or (px > camW) then continue;
      py := q.y - camY0;
      if (py < 0) or (py > camH) then continue;

      Bucket := @buckets[Round(bhs * py)][Round(bws * px)];
      MapColor := @ColorMap[Round(q.c * 255)];

      {$ifdef ENABLEZBUF}
      ZBufPos := @zbuffer[Round(bhs * py)][Round(bws * px)];
      if (q.z < ZBufPos^) then
      begin
        ZBufPos^ := q.z;
        Bucket.Red := Bucket.Red + MapColor.Red;
        Bucket.Green := Bucket.Green + MapColor.Green;
        Bucket.Blue := Bucket.Blue + MapColor.Blue;
        Bucket.Count := Bucket.Count + 1;
      end;
      {$else}
        Bucket.Red := Bucket.Red + MapColor.Red;
        Bucket.Green := Bucket.Green + MapColor.Green;
        Bucket.Blue := Bucket.Blue + MapColor.Blue;
        Bucket.Count := Bucket.Count + 1;
      {$endif}
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;
procedure TRenderWorkerST.IterateBatchAngleFX;
var
  i: integer;
  px, py: double;
  Bucket: PBucket;
  MapColor: PColorMapColor;
  ZBufPos: PDouble;
  ix, iy: integer;
  BmpColor: TColor;

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
    xf := fcp.xform[0];
    for i := 0 to FUSE do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);
    end;

    for i := 0 to SUB_BATCH_SIZE-1 do begin
      xf := xf.PropTable[Random(PROP_TABLE_SIZE)];
      xf.NextPoint(p);

      if random >= xf.transOpacity then continue;

      finalXform.NextPointTo(p, q);
      fcp.ProjectionFunc(@q);

      px := q.x * cosa + q.y * sina + rcX;
      if (px < 0) or (px > camW) then continue;
      py := q.y * cosa - q.x * sina + rcY;
      if (py < 0) or (py > camH) then continue;

      Bucket := @buckets[Round(bhs * py)][Round(bws * px)];
      MapColor := @ColorMap[Round(q.c * 255)];

      {$ifdef ENABLEZBUF}
      ZBufPos := @zbuffer[Round(bhs * py)][Round(bws * px)];
      if (q.z < ZBufPos^) then
      begin
        ZBufPos^ := q.z;
        Bucket.Red := Bucket.Red + MapColor.Red;
        Bucket.Green := Bucket.Green + MapColor.Green;
        Bucket.Blue := Bucket.Blue + MapColor.Blue;
        Bucket.Count := Bucket.Count + 1;
      end;
      {$else}
        Bucket.Red := Bucket.Red + MapColor.Red;
        Bucket.Green := Bucket.Green + MapColor.Green;
        Bucket.Blue := Bucket.Blue + MapColor.Blue;
        Bucket.Count := Bucket.Count + 1;
      {$endif}
    end;

  except
    on EMathError do begin
      exit;
    end;
  end;
end;
procedure TRenderWorkerMT.AddPointsToBuckets(const points: TPointsArray);
var
  i: integer;
  px, py: double;
  Bucket: PBucket;
  ZBufPos: PDouble;
  MapColor: PColorMapColor;
begin
  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
    px := points[i].x - camX0;
    if (px < 0) or (px > camW) then continue;
    py := points[i].y - camY0;
    if (py < 0) or (py > camH) then continue;

    Bucket := @buckets[Round(bhs * py)][Round(bws * px)];
    MapColor := @ColorMap[Round(points[i].c * 255)];

    if random >= points[i].o then continue;

    {$ifdef ENABLEZBUF}
    ZBufPos := @zbuffer[Round(bhs * py)][Round(bws * px)];
    if (points[i].z < ZBufPos^) then
    begin
      ZBufPos^ := points[i].z;
      Bucket.Red := Bucket.Red + MapColor.Red;
      Bucket.Green := Bucket.Green + MapColor.Green;
      Bucket.Blue := Bucket.Blue + MapColor.Blue;
      Bucket.Count := Bucket.Count + 1;
    end;
    {$else}
      Bucket.Red := Bucket.Red + MapColor.Red;
      Bucket.Green := Bucket.Green + MapColor.Green;
      Bucket.Blue := Bucket.Blue + MapColor.Blue;
      Bucket.Count := Bucket.Count + 1;
    {$endif}
  end;
end;
procedure TRenderWorkerMT.AddPointsToBucketsAngle(const points: TPointsArray);
var
  i: integer;
  px, py: double;
  Bucket: PBucket;
  MapColor: PColorMapColor;
  ZBufPos: PDouble;
begin
  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
    px := points[i].x * cosa + points[i].y * sina + rcX;
    if (px < 0) or (px > camW) then continue;
    py := points[i].y * cosa - points[i].x * sina + rcY;
    if (py < 0) or (py > camH) then continue;

    Bucket := @buckets[Round(bhs * py)][Round(bws * px)];
    MapColor := @ColorMap[Round(points[i].c * 255)];

    if random >= points[i].o then continue;

    {$ifdef ENABLEZBUF}
    ZBufPos := @zbuffer[Round(bhs * py)][Round(bws * px)];
    if (points[i].z < ZBufPos^) then
    begin
      ZBufPos^ := points[i].z;
      Bucket.Red := Bucket.Red + MapColor.Red;
      Bucket.Green := Bucket.Green + MapColor.Green;
      Bucket.Blue := Bucket.Blue + MapColor.Blue;
      Bucket.Count := Bucket.Count + 1;
    end;
    {$else}
      Bucket.Red := Bucket.Red + MapColor.Red;
      Bucket.Green := Bucket.Green + MapColor.Green;
      Bucket.Blue := Bucket.Blue + MapColor.Blue;
      Bucket.Count := Bucket.Count + 1;
    {$endif}
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// THREADING
////////////////////////////////////////////////////////////////////////////////
procedure TRenderWorkerMT.Stop;
var
  i: integer;
begin
  for i := 0 to High(WorkingThreads) do
    WorkingThreads[i].Terminate;

  inherited;
end;
procedure TRenderWorkerMT.BreakRender;
var
  i: integer;
begin
  inherited;

  for i := 0 to High(WorkingThreads) do
    WorkingThreads[i].Terminate;
end;
procedure TRenderWorkerMT.Pause;
var
  i: integer;
begin
  inherited;

  for i := 0 to High(WorkingThreads) do
    WorkingThreads[i].Suspend;
end;
procedure TRenderWorkerMT.UnPause;
var
  i: integer;
begin
  inherited;

  for i := 0 to High(WorkingThreads) do
    WorkingThreads[i].Resume;
end;
function TRenderWorkerMT.NewThread: TBucketFillerThread;
begin
  Result := TBucketFillerThread.Create(fcp);
  assert(Result<>nil);

  if FCP.FAngle = 0 then
    Result.AddPointsProc := self.AddPointsToBuckets
  else
    Result.AddPointsProc := self.AddPointsToBucketsAngle;

  Result.CriticalSection := CriticalSection;
  Result.Nrbatches := FNumBatches;
  Result.batchcounter := @batchcounter;
end;

end.

