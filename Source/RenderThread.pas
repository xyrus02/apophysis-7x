{
     Flame screensaver Copyright (C) 2002 Ronald Hordijk
     Apophysis Copyright (C) 2001-2004 Mark Townsend

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
  Classes, windows, Messages, Graphics,
   controlPoint, Render, Render32;

const
  WM_THREAD_COMPLETE = WM_APP + 5437;
  WM_THREAD_TERMINATE = WM_APP + 5438;

type
  TRenderThread = class(TThread)
  private
    FRenderer: TRenderer32;

    FOnProgress: TOnProgress;
    FCP: TControlPoint;
  public
    MaxMem: int64;
    TargetHandle: HWND;
    nrSlices: int64;
    Slice: int64;
    compatibility: integer;
    procedure Execute; override;
    constructor Create;
    destructor Destroy; override;

    procedure SetCP(CP: TControlPoint);
    function GetImage: TBitmap;

    procedure RenderMaxMem(MaxMemory: int64 = 64);
    procedure Render; overload;
    procedure Render(Time: double); overload;
    procedure Terminate;

    property OnProgress: TOnProgress
      read FOnProgress
      write FOnProgress;
  end;

implementation

uses
  Math, Sysutils;

{ TRenderThread }


destructor TRenderThread.Destroy;
begin
  if assigned(FRenderer) then
    FRenderer.Free;

  inherited;
end;

function TRenderThread.GetImage: TBitmap;
begin
  Result := nil;
  if assigned(FRenderer) then
    Result := FRenderer.GetImage;
end;


procedure TRenderThread.RenderMaxMem(MaxMemory: int64);
begin
  if assigned(FRenderer) then
    FRenderer.Free;

  FRenderer := TRenderer32.Create;
  FRenderer.SetCP(FCP);
  FRenderer.compatibility := compatibility;
  FRenderer.OnProgress := FOnProgress;
  FRenderer.RenderMaxMem(MaxMemory);
end;


procedure TRenderThread.Render(Time: double);
begin
  if assigned(FRenderer) then
    FRenderer.Free;

  FRenderer := TRenderer32.Create;
  FRenderer.SetCP(FCP);
  FRenderer.compatibility := compatibility;
  FRenderer.OnProgress := FOnProgress;
  FRenderer.Render(Time);
end;

procedure TRenderThread.SetCP(CP: TControlPoint);
begin
  FCP := CP;
end;

constructor TRenderThread.Create;
begin
  MaxMem := 0;                          // mt
  Slice := 0;
  NrSlices := 1;
  FreeOnTerminate := False;
  inherited Create(True);               // Create Suspended;
end;


procedure TRenderThread.Render;
begin
  if assigned(FRenderer) then
    FRenderer.Free;

  FRenderer := TRenderer32.Create;
  FRenderer.SetCP(FCP);
  FRenderer.compatibility := compatibility;
  FRenderer.OnProgress := FOnProgress;
  Frenderer.Render;
end;

procedure TRenderThread.Execute;
begin
  if MaxMem = 0 then
    Render
  else
    RenderMaxMem(MaxMem);

  if Terminated then
    PostMessage(TargetHandle, WM_THREAD_TERMINATE, 0, 0)
  else
    PostMessage(TargetHandle, WM_THREAD_COMPLETE, 0, 0);
end;

procedure TRenderThread.Terminate;
begin
  inherited Terminate;

  if assigned(FRenderer) then
    FRenderer.Stop; 
end;

end.

