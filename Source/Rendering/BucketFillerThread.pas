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

unit BucketFillerThread;

interface

uses
  Classes, Windows, ControlPoint, RenderingInterface, XForm;

type
  TBucketFillerThread = class(TThread)

  private
    fcp: TControlPoint;
    points: TPointsArray;

  public
    nrbatches: integer;
    batchcounter: Pinteger;

    ColorMap: TColorMapArray;
    CriticalSection: TRTLCriticalSection;

    AddPointsProc: procedure (const points: TPointsArray) of object;

    constructor Create(cp: TControlPoint);
    destructor Destroy; override;

    procedure Execute; override;

  end;

implementation

//uses SysUtils, FormRender;

///////////////////////////////////////////////////////////////////////////////
constructor TBucketFillerThread.Create(cp: TControlPoint);
begin
  inherited Create(True);
  //Self.FreeOnTerminate := True;

  Fcp := cp.Clone;

  SetLength(Points, SUB_BATCH_SIZE);

  fcp.Prepare;
end;

///////////////////////////////////////////////////////////////////////////////
destructor TBucketFillerThread.Destroy;
begin
  FCP.Free;

  inherited;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBucketFillerThread.Execute;
var
  bc: integer;
begin
  inherited;
  //RenderForm.Output.Lines.Add(' . . . > Filler thread #' + IntToStr(ThreadID) + ' Started');

  bc := 0;
  while (not Terminated) and (bc < Nrbatches) do begin
    fcp.iterateXYC(SUB_BATCH_SIZE, points);

    try
      EnterCriticalSection(CriticalSection);

      AddPointsProc(Points);

      Inc(batchcounter^);
      bc := batchcounter^
    finally
      LeaveCriticalSection(CriticalSection);
    end;
  end;
  //RenderForm.Output.Lines.Add(' . . . > Filler thread #' + IntToStr(ThreadID) + ' Finished');
end;

///////////////////////////////////////////////////////////////////////////////

{ -- RENDER THREAD MUST *NOT* KNOW ANYTHING ABOUT BUCKETS!!! -- }

end.
