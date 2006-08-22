unit BucketFillerThread;

interface

uses
  Classes, Windows,
  ControlPoint, Render, XForm, RenderTypes;

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

///////////////////////////////////////////////////////////////////////////////
constructor TBucketFillerThread.Create(cp: TControlPoint);
begin
  inherited Create(True);
  Self.FreeOnTerminate := True;

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
end;

///////////////////////////////////////////////////////////////////////////////

{ -- RENDER THREAD MUST *NOT* KNOW ANYTHING ABOUT BUCKETS!!! -- }

end.
