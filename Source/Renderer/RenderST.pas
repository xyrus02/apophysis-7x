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

unit RenderST;

interface

uses
  Windows, Classes, Forms, Graphics, ImageMaker,
  Render, RenderTypes, Xform, ControlPoint, Translation;

type
  TBatchProc = procedure of object;

type
  TBaseSTRenderer = class(TBaseRenderer)

  protected
    PropTable: array[0..PROP_TABLE_SIZE] of TXform;
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

  fcp.Prepare;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseSTRenderer.SetPixels;
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
//      if (FStop <> 0) or (i >= FMinBatches) then begin //?
      fcp.actual_density := fcp.actual_density +
                            fcp.sample_density * i / FNumBatches; // actual quality of incomplete render
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

end.
