unit FastMMUsageTracker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, Buttons, FastMM4;

type
  TfFastMMUsageTracker = class(TForm)
    gbMemoryMap: TGroupBox;
    gbBlockStats: TGroupBox;
    tTimer: TTimer;
    sgBlockStatistics: TStringGrid;
    dgMemoryMap: TDrawGrid;
    bClose: TBitBtn;
    Label1: TLabel;
    eAddress: TEdit;
    Label2: TLabel;
    eState: TEdit;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    eTotalAddressSpaceInUse: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
    procedure dgMemoryMapDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure dgMemoryMapSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    {The current state}
    FMemoryManagerState: TMemoryManagerState;
    FMemoryMap: TMemoryMap;
  public
    {Refreshes the display}
    procedure RefreshSnapShot;
  end;

function ShowFastMMUsageTracker: TfFastMMUsageTracker;

{Gets the number of bytes of virtual memory either reserved or committed by this
 process}
function GetAddressSpaceUsed: Cardinal;

implementation

{$R *.dfm}

function ShowFastMMUsageTracker: TfFastMMUsageTracker;
begin
  Application.CreateForm(TfFastMMUsageTracker, Result);
  Result.RefreshSnapShot;
  Result.Show;
end;

function GetAddressSpaceUsed: Cardinal;
var
  LMemoryStatus: TMemoryStatus;
begin
  {Set the structure size}
  LMemoryStatus.dwLength := SizeOf(LMemoryStatus);
  {Get the memory status}
  GlobalMemoryStatus(LMemoryStatus);
  {The result is the total address space less the free address space}
  Result := (LMemoryStatus.dwTotalVirtual - LMemoryStatus.dwAvailVirtual) shr 10;
end;

{ TfUsageTracker }

procedure TfFastMMUsageTracker.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfFastMMUsageTracker.RefreshSnapShot;
var
  LInd: integer;
  LAllocatedSize, LTotalBlocks, LTotalAllocated, LTotalReserved: Cardinal;
begin
  {Get the state}
  GetMemoryManagerState(FMemoryManagerState);
  GetMemoryMap(FMemoryMap);
  dgMemoryMap.Invalidate;
  {Set the texts inside the results string grid}
  LTotalBlocks := 0;
  LTotalAllocated := 0;
  LTotalReserved := 0;
  for LInd := 0 to high(FMemoryManagerState.SmallBlockTypeStates) do
  begin
    with FMemoryManagerState.SmallBlockTypeStates[LInd] do
    begin
      sgBlockStatistics.Cells[1, LInd + 1] := IntToStr(AllocatedBlockCount);
      Inc(LTotalBlocks, AllocatedBlockCount);
      LAllocatedSize := AllocatedBlockCount * UseableBlockSize;
      sgBlockStatistics.Cells[2, LInd + 1] := IntToStr(LAllocatedSize);
      Inc(LTotalAllocated, LAllocatedSize);
      sgBlockStatistics.Cells[3, LInd + 1] := IntToStr(ReservedAddressSpace);
      Inc(LTotalReserved, ReservedAddressSpace);
      if ReservedAddressSpace > 0 then
        sgBlockStatistics.Cells[4, LInd + 1] := FormatFloat('0.##%', LAllocatedSize/ReservedAddressSpace * 100)
      else
        sgBlockStatistics.Cells[4, LInd + 1] := 'N/A';
    end;
  end;
  {Medium blocks}
  LInd := length(FMemoryManagerState.SmallBlockTypeStates) + 1;
  sgBlockStatistics.Cells[1, LInd] := IntToStr(FMemoryManagerState.AllocatedMediumBlockCount);
  Inc(LTotalBlocks, FMemoryManagerState.AllocatedMediumBlockCount);
  sgBlockStatistics.Cells[2, LInd] := IntToStr(FMemoryManagerState.TotalAllocatedMediumBlockSize);
  Inc(LTotalAllocated, FMemoryManagerState.TotalAllocatedMediumBlockSize);
  sgBlockStatistics.Cells[3, LInd] := IntToStr(FMemoryManagerState.ReservedMediumBlockAddressSpace);
  Inc(LTotalReserved, FMemoryManagerState.ReservedMediumBlockAddressSpace);
  if FMemoryManagerState.ReservedMediumBlockAddressSpace > 0 then
    sgBlockStatistics.Cells[4, LInd] := FormatFloat('0.##%', FMemoryManagerState.TotalAllocatedMediumBlockSize/FMemoryManagerState.ReservedMediumBlockAddressSpace * 100)
  else
    sgBlockStatistics.Cells[4, LInd] := 'N/A';
  {Large blocks}
  LInd := length(FMemoryManagerState.SmallBlockTypeStates) + 2;
  sgBlockStatistics.Cells[1, LInd] := IntToStr(FMemoryManagerState.AllocatedLargeBlockCount);
  Inc(LTotalBlocks, FMemoryManagerState.AllocatedLargeBlockCount);
  sgBlockStatistics.Cells[2, LInd] := IntToStr(FMemoryManagerState.TotalAllocatedLargeBlockSize);
  Inc(LTotalAllocated, FMemoryManagerState.TotalAllocatedLargeBlockSize);
  sgBlockStatistics.Cells[3, LInd] := IntToStr(FMemoryManagerState.ReservedLargeBlockAddressSpace);
  Inc(LTotalReserved, FMemoryManagerState.ReservedLargeBlockAddressSpace);
  if FMemoryManagerState.ReservedLargeBlockAddressSpace > 0 then
    sgBlockStatistics.Cells[4, LInd] := FormatFloat('0.##%', FMemoryManagerState.TotalAllocatedLargeBlockSize/FMemoryManagerState.ReservedLargeBlockAddressSpace * 100)
  else
    sgBlockStatistics.Cells[4, LInd] := 'N/A';
  {Overall}
  LInd := length(FMemoryManagerState.SmallBlockTypeStates) + 3;
  sgBlockStatistics.Cells[1, LInd] := IntToStr(LTotalBlocks);
  sgBlockStatistics.Cells[2, LInd] := IntToStr(LTotalAllocated);
  sgBlockStatistics.Cells[3, LInd] := IntToStr(LTotalReserved);
  if LTotalReserved > 0 then
    sgBlockStatistics.Cells[4, LInd] := FormatFloat('0.##%', LTotalAllocated/LTotalReserved * 100)
  else
    sgBlockStatistics.Cells[4, LInd] := 'N/A';
  {Address space usage}
  eTotalAddressSpaceInUse.Text := FormatFloat('0.###', GetAddressSpaceUsed / 1024);
end;

procedure TfFastMMUsageTracker.tTimerTimer(Sender: TObject);
begin
  tTimer.Enabled := False;
  try
    RefreshSnapShot;
  finally
    tTimer.Enabled := True;
  end;
end;

procedure TfFastMMUsageTracker.FormCreate(Sender: TObject);
var
  LInd: integer;
begin
  {Set up the row count}
  sgBlockStatistics.RowCount := length(FMemoryManagerState.SmallBlockTypeStates) + 4;
  {Get the initial snapshot}
  RefreshSnapShot;
  {Set up the StringGrid columns}
  sgBlockStatistics.Cells[0, 0] := 'Block Size';
  sgBlockStatistics.Cells[1, 0] := '# Live Pointers';
  sgBlockStatistics.Cells[2, 0] := 'Live Size';
  sgBlockStatistics.Cells[3, 0] := 'Used Space';
  sgBlockStatistics.Cells[4, 0] := 'Efficiency';
  for LInd := 0 to high(FMemoryManagerState.SmallBlockTypeStates) do
  begin
    sgBlockStatistics.Cells[0, LInd + 1] :=
      IntToStr(FMemoryManagerState.SmallBlockTypeStates[LInd].InternalBlockSize)
      + '(' + IntToStr(FMemoryManagerState.SmallBlockTypeStates[LInd].UseableBlockSize) + ')';
  end;
  sgBlockStatistics.Cells[0, length(FMemoryManagerState.SmallBlockTypeStates) + 1] := 'Medium Blocks';
  sgBlockStatistics.Cells[0, length(FMemoryManagerState.SmallBlockTypeStates) + 2] := 'Large Blocks';
  sgBlockStatistics.Cells[0, length(FMemoryManagerState.SmallBlockTypeStates) + 3] := 'Overall';
end;

procedure TfFastMMUsageTracker.bCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfFastMMUsageTracker.dgMemoryMapDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  LChunkIndex: integer;
  LChunkColour: TColor;
begin
  {Get the chunk index}
  LChunkIndex := ARow * dgMemoryMap.ColCount + ACol;
  {Get the correct colour}
  case FMemoryMap[LChunkIndex] of
    csAllocated:
    begin
      LChunkColour := $9090ff;
    end;
    csReserved:
    begin
      LChunkColour := $90f090;
    end;
    csSysAllocated:
    begin
      LChunkColour := $707070;
    end;
    csSysReserved:
    begin
      LChunkColour := $c0c0c0;
    end
  else
    begin
      {Unallocated}
      LChunkColour := $ffffff;
    end;
  end;
  {Draw the chunk background}
  dgMemoryMap.Canvas.Brush.Color := LChunkColour;
  if State = [] then
  begin
    dgMemoryMap.Canvas.FillRect(Rect);
  end
  else
  begin
    dgMemoryMap.Canvas.Rectangle(Rect);
  end;
end;

procedure TfFastMMUsageTracker.dgMemoryMapSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  LChunkIndex: Cardinal;
begin
  LChunkIndex := ARow * dgMemoryMap.ColCount + ACol;
  eAddress.Text := Format('$%0.8x', [LChunkIndex shl 16]);
  case FMemoryMap[LChunkIndex] of
    csAllocated:
    begin
      eState.Text := 'FastMM Allocated';
    end;
    csReserved:
    begin
      eState.Text := 'FastMM Reserved';
    end;
    csSysAllocated:
    begin
      eState.Text := 'System Allocated';
    end;
    csSysReserved:
    begin
      eState.Text := 'System Reserved';
    end
  else
    begin
      {Unallocated}
      eState.Text := 'Unallocated';
    end;
  end;
end;

end.
