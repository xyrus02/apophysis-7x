{
     Flame screensaver Copyright (C) 2002 Ronald Hordijk
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Boris, Peter Sdobnov

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
unit RenderThread;

interface

uses
  Classes, Windows, Messages, Graphics,
  ControlPoint, Render,
  Global, RenderTypes, PngImage,
  Render64, Render64MT,
  Render48, Render48MT,
  Render32, Render32MT,
  Render32f, Render32fMT;

const
  WM_THREAD_COMPLETE = WM_APP + 5437;
  WM_THREAD_TERMINATE = WM_APP + 5438;

type
  TRenderThread = class(TThread)
  private
    FRenderer: TBaseRenderer;

    FOnProgress: TOnProgress;
    FCP: TControlPoint;
    FMaxMem: int64;
    FNrThreads: Integer;
    FBitsPerSample: integer;
    FMinDensity: double;
    FOutput: TStrings;

    procedure CreateRenderer;
    function GetNrSlices: integer;
    function GetSlice: integer;
    procedure SetBitsPerSample(const bits: Integer);

    procedure Trace(const str: string);

  public
    TargetHandle: HWND;
    WaitForMore, More: boolean;

    constructor Create;
    destructor Destroy; override;

    procedure SetCP(CP: TControlPoint);
    function  GetImage: TBitmap;
    function  GetTransparentImage: TPngObject;
    procedure SaveImage(const FileName: String);

    procedure Execute; override;
    function  GetRenderer: TBaseRenderer;

    procedure Terminate;
    procedure Suspend;
    procedure Resume;
    procedure BreakRender;
    procedure SetPriority(p: TThreadPriority);

//    procedure GetBucketStats(var Stats: TBucketStats);
    procedure ShowBigStats;
    procedure ShowSmallStats;

    property OnProgress: TOnProgress
        read FOnProgress
       write FOnProgress;

    property Slice: integer
        read GetSlice;
    property NrSlices: integer
        read GetNrSlices;
    property MaxMem: int64
        read FMaxMem
       write FMaxMem;
//    property compatibility: Integer read Fcompatibility write Fcompatibility;
    property NrThreads: Integer
        read FNrThreads
       write FNrThreads;
    property BitsPerSample: Integer
        read FBitsPerSample
       write SetBitsPerSample;
    property Output: TStrings
       write FOutput;
    property MinDensity: double
       write FMinDensity;
  end;

implementation

uses
  Math, SysUtils,
  Tracer;

{ TRenderThread }

///////////////////////////////////////////////////////////////////////////////
destructor TRenderThread.Destroy;
begin
  if assigned(FRenderer) then
    FRenderer.Free;
  FRenderer := nil;

  if assigned(FCP) then FCP.Free;

  inherited;
end;

///////////////////////////////////////////////////////////////////////////////
function TRenderThread.GetImage: TBitmap;
begin
  Result := nil;
  if assigned(FRenderer) then
    Result := FRenderer.GetImage;
end;

///////////////////////////////////////////////////////////////////////////////
function TRenderThread.GetTransparentImage: TPngObject;
begin
  Result := nil;
  if assigned(FRenderer) then
    Result := FRenderer.GetTransparentImage;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderThread.SetCP(CP: TControlPoint);
begin
  FCP := CP.Clone;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TRenderThread.Create;
begin
  MaxMem := 0;
  BitsPerSample := InternalBitsPerSample;
  FreeOnTerminate := false;
  WaitForMore := false;

  inherited Create(True);               // Create Suspended;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderThread.CreateRenderer;
begin
  if assigned(FRenderer) then begin
    Trace('Destroying previous renderer (?)');
    FRenderer.Free;
  end;
  Trace('Creating renderer');

  if NrThreads <= 1 then begin
    if MaxMem = 0 then begin
      case FBitsPerSample of
        0: FRenderer := TRenderer32.Create;
        1: FRenderer := TRenderer32f.Create;
        2: FRenderer := TRenderer48.Create;
        3: FRenderer := TRenderer64.Create;
      end;
    end else begin
      case FBitsPerSample of
        0: FRenderer := TRenderer32MM.Create;
        1: FRenderer := TRenderer32fMM.Create;
        2: FRenderer := TRenderer48MM.Create;
        3: FRenderer := TRenderer64MM.Create;
      end;
      FRenderer.MaxMem := MaxMem;
    end;
  end
  else begin
    if MaxMem = 0 then begin
      case FBitsPerSample of
        0: FRenderer := TRenderer32MT.Create;
        1: FRenderer := TRenderer32fMT.Create;
        2: FRenderer := TRenderer48MT.Create;
        3: FRenderer := TRenderer64MT.Create;
      end;
    end else begin
      case FBitsPerSample of
        0: FRenderer := TRenderer32MT_MM.Create;
        1: FRenderer := TRenderer32fMT_MM.Create;
        2: FRenderer := TRenderer48MT_MM.Create;
        3: FRenderer := TRenderer64MT_MM.Create;
      end;
      FRenderer.MaxMem := MaxMem;
    end;
    FRenderer.NumThreads := NrThreads;
  end;

  FRenderer.SetCP(FCP);
//  FRenderer.SetThreadPriority(self.Priority);
//  FRenderer.compatibility := compatibility;
  FRenderer.MinDensity := FMinDensity;
  FRenderer.OnProgress := FOnProgress;
  FRenderer.Output := FOutput;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderThread.Execute;
label RenderMore;
begin
  CreateRenderer;

RenderMore:
  assert(assigned(FRenderer));

  Trace('Rendering');
  FRenderer.Render;

  if Terminated or FRenderer.Failed then begin
    Trace('Sending WM_THREAD_TERMINATE');
    PostMessage(TargetHandle, WM_THREAD_TERMINATE, 0, ThreadID);
    Trace('Terminated');
    exit;
  end
  else begin
    Trace('Sending WM_THREAD_COMPLETE');
    PostMessage(TargetHandle, WM_THREAD_COMPLETE, 0, ThreadID);
  end;

  if WaitForMore and (FRenderer <> nil) then begin
    FRenderer.RenderMore := true;

    Trace('Waiting for more');
    inherited Suspend;

    if WaitForMore then goto RenderMore;
  end;

  Trace('Finished');
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderThread.Terminate;
begin
  if assigned(FRenderer) then
    FRenderer.Stop;

  WaitForMore := false;

  inherited Terminate;
end;

procedure TRenderThread.Suspend;
begin
  if assigned(FRenderer) then FRenderer.Pause;

  inherited;
end;

procedure TRenderThread.Resume;
begin
  if assigned(FRenderer) then FRenderer.UnPause;

  inherited;
end;

procedure TRenderThread.BreakRender;
begin
  if assigned(FRenderer) then
    FRenderer.BreakRender;
end;

procedure TRenderThread.SetPriority(p: TThreadPriority);
begin
  Priority := p;

  if assigned(FRenderer) then
    FRenderer.SetThreadPriority(p);
end;

///////////////////////////////////////////////////////////////////////////////
function TRenderThread.GetNrSlices: integer;
begin
  if assigned(FRenderer) then
    Result := FRenderer.NrSlices
  else
    Result := 1;
end;

///////////////////////////////////////////////////////////////////////////////
function TRenderThread.GetSlice: integer;
begin
  if assigned(FRenderer) then
    Result := FRenderer.Slice
  else
    Result := 1;
end;

//////////////////////////////////////////////////////////////////////////////
function TRenderThread.GetRenderer: TBaseRenderer;
begin
  Result := FRenderer;
  FRenderer := nil;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderThread.SetBitsPerSample(const bits: Integer);
begin
  if FRenderer = nil then FBitsPerSample := bits
  else assert(false);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderThread.SaveImage(const FileName: String);
begin
  if assigned(FRenderer) then
    FRenderer.SaveImage(FileName);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderThread.Trace(const str: string);
begin
  if assigned(FOutput) and (TraceLevel >= 2) then
    FOutput.Add('. . > RenderThread #' + IntToStr(ThreadID) + ': ' + str);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderThread.ShowBigStats;
begin
  if assigned(FRenderer) then
    FRenderer.ShowBigStats;
end;

procedure TRenderThread.ShowSmallStats;
begin
  if assigned(FRenderer) then
    FRenderer.ShowSmallStats;
end;
///////////////////////////////////////////////////////////////////////////////

end.
