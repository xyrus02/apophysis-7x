unit RenderST;

interface

uses
  Windows, Classes, Forms, Graphics, ImageMaker,
  Render, RenderTypes, Xform, ControlPoint;

type
  TBatchProc = procedure of object;

type
  TBaseSTRenderer = class(TBaseRenderer)

  protected
    PropTable: array[0..SUB_BATCH_SIZE] of TXform;
    finalXform: TXform;
    UseFinalXform: boolean;

    procedure Prepare; override;
    procedure SetPixels; override;

    procedure IterateBatch; virtual; abstract;
    procedure IterateBatchAngle; virtual; abstract;
    procedure IterateBatchFX; virtual; abstract;
    procedure IterateBatchAngleFX; virtual; abstract;
  end;

implementation

uses
  Math, Sysutils;

{ TBaseSTRenderer }

///////////////////////////////////////////////////////////////////////////////
procedure TBaseSTRenderer.Prepare;
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

  for i := 0 to n - 1 do begin
    fcp.xform[i].Prepare;
    totValue := totValue + fcp.xform[i].density;
  end;

  LoopValue := 0;
  for i := 0 to PROP_TABLE_SIZE-1 do begin
    propsum := 0;
    j := -1;
    repeat
      inc(j);
      propsum := propsum + fcp.xform[j].density;
    until (propsum > LoopValue) or (j = n - 1);
    PropTable[i] := fcp.xform[j];
    LoopValue := LoopValue + TotValue / PROP_TABLE_SIZE;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseSTRenderer.SetPixels;
var
  i: integer;
  nsamples: int64;
  IterateBatchProc: procedure of object;
begin
  if Assigned(strOutput) then begin
    if FNumSlices > 1 then
      strOutput.Add(TimeToStr(Now) + Format(' : Rendering slice #%d...', [FSlice + 1]))
    else
      strOutput.Add(TimeToStr(Now) + ' : Rendering...');
  end;

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
//      if (FStop < 0) or (i >= FMinBatches) then begin //?
      fcp.actual_density := fcp.actual_density +
                            fcp.sample_density * i / FNumBatches; // actual quality of incomplete render
      FNumBatches := i;
      exit;
    end;

    if ((i and $1F) = 0) then Progress(i / FNumBatches);

    IterateBatchProc;
  end;

  fcp.actual_density := fcp.actual_density + fcp.sample_density;

  Progress(1);
end;

end.
