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
unit RenderMT;

interface

uses
  Windows, Forms, Classes, Graphics,
  Render, Controlpoint, ImageMaker, BucketFillerthread, RenderTypes;

type
  TBaseMTRenderer = class(TBaseRenderer)

  private
    batchcounter: Integer;

    WorkingThreads: array of TBucketFillerThread;
    CriticalSection: TRTLCriticalSection;

    function NewThread: TBucketFillerThread;

  protected
    procedure Prepare; override;
    procedure SetPixels; override;

    procedure AddPointsToBuckets(const points: TPointsArray); virtual; abstract;
    procedure AddPointsToBucketsAngle(const points: TPointsArray); virtual; abstract;

  public
    procedure Stop; override;
    procedure BreakRender; override;

    procedure Pause; override;
    procedure UnPause; override;
    procedure SetThreadPriority(p: TThreadPriority); override;

  end;

implementation

uses
  Math, Sysutils;

{ TBaseMTRenderer }

///////////////////////////////////////////////////////////////////////////////
procedure TBaseMTRenderer.SetPixels;
var
  i: integer;
  nSamples: Int64;
  bc : integer;
begin
  if FNumSlices > 1 then
    TimeTrace(Format('Rendering slice #%d of %d...', [FSlice + 1, FNumSlices]))
  else
    TimeTrace('Rendering...');

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
  end;
  SetLength(WorkingThreads, 0);

  fcp.actual_density := fcp.actual_density +
                        fcp.sample_density * BatchCounter / FNumBatches; // actual quality of incomplete render
  FNumBatches := BatchCounter;

  DeleteCriticalSection(CriticalSection);
  Progress(1);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseMTRenderer.Prepare;
begin
  fcp.Prepare;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseMTRenderer.Stop;
var
  i: integer;
begin
  for i := 0 to High(WorkingThreads) do
    WorkingThreads[i].Terminate;
  SetLength(WorkingThreads, 0); //?

  inherited; //  FStop := 1;
end;

procedure TBaseMTRenderer.BreakRender;
var
  i: integer;
begin
  inherited; // FStop := -1;

  {if BatchCounter < FMinBatches then exit;}

  for i := 0 to High(WorkingThreads) do
    WorkingThreads[i].Terminate;
  SetLength(WorkingThreads, 0); //?
end;

procedure TBaseMTRenderer.Pause;
var
  i: integer;
begin
  inherited;

  for i := 0 to High(WorkingThreads) do
    WorkingThreads[i].Suspend;
end;

procedure TBaseMTRenderer.UnPause;
var
  i: integer;
begin
  inherited;

  for i := 0 to High(WorkingThreads) do
    WorkingThreads[i].Resume;
end;

procedure TBaseMTRenderer.SetThreadPriority(p: TThreadPriority);
var
  i: integer;
begin
  inherited;
  
  //for i := 0 to High(WorkingThreads) do
  //  WorkingThreads[i].Priority := p;
end;

///////////////////////////////////////////////////////////////////////////////
function TBaseMTRenderer.NewThread: TBucketFillerThread;
begin
  Result := TBucketFillerThread.Create(fcp);
  assert(Result<>nil);
  //Result.Priority := FThreadPriority;

  if FCP.FAngle = 0 then
    Result.AddPointsProc := self.AddPointsToBuckets
  else
    Result.AddPointsProc := self.AddPointsToBucketsAngle;

  Result.CriticalSection := CriticalSection;
  Result.Nrbatches := FNumBatches;
  Result.batchcounter := @batchcounter;
end;

end.

