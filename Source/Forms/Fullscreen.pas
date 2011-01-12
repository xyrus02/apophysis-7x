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
unit Fullscreen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, ControlPoint, RenderThread, Translation;

type
  TFullscreenForm = class(TForm)
    Image: TImage;
    Timelimiter: TTimer;
    FullscreenPopup: TPopupMenu;
    RenderStop: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    RenderMore: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ImageDblClick(Sender: TObject);
    procedure TimelimiterOnTimer(Sender: TObject);
    procedure RenderStopClick(Sender: TObject);
    procedure RenderMoreClick(Sender: TObject);

  private
    Remainder, StartTime, t: double;
    imgLeft, imgTop,
    imgWidth, imgHeight: integer;
    Closing: boolean;

    Renderer: TRenderThread;

    procedure showTaskbar;
    procedure hideTaskbar;
    procedure DrawFlame;
    procedure OnProgress(prog: double);
    procedure HandleThreadCompletion(var Message: TMessage);
      message WM_THREAD_COMPLETE;
    procedure HandleThreadTermination(var Message: TMessage);
      message WM_THREAD_TERMINATE;

  public
    Calculate : boolean;
    cp: TControlPoint;
    Zoom: double;
    center: array[0..1] of double;

    ActiveForm: TForm;
  end;

var
  FullscreenForm: TFullscreenForm;

implementation

uses
  Main, Math, Global,
  Tracer;

{$R *.DFM}

procedure Trace1(const str: string);
begin
  if TraceLevel >= 1 then
    TraceForm.FullscreenTrace.Lines.Add('. ' + str);
end;

procedure Trace2(const str: string);
begin
  if TraceLevel >= 2 then
    TraceForm.FullscreenTrace.Lines.Add('. . ' + str);
end;

procedure TFullscreenForm.DrawFlame;
var
  r: double;
begin
  if (cp.width / cp.height) > (ClientWidth / ClientHeight) then
  begin
    imgWidth := ClientWidth;
    r := cp.width / imgWidth;
    imgHeight := round(cp.height / r);
    imgLeft := 1;
    imgTop := (ClientHeight - imgHeight) div 2;
  end
  else begin
    imgHeight := ClientHeight;
    r := cp.height / imgHeight;
    imgWidth := round(cp.Width / r);
    imgTop := 1;
    imgLeft := (ClientWidth - ImgWidth) div 2;
  end;
  cp.AdjustScale(imgWidth, imgHeight);

//  cp.Zoom := MainForm.Zoom;
//  cp.center[0] := MainForm.center[0];
//  cp.center[1] := MainForm.center[1];
  cp.sample_density := defSampleDensity;
  StartTime := Now;
  t := now;
  Remainder := 1;

  if Assigned(Renderer) then begin // hmm...
    Trace2('Killing previous RenderThread #' + inttostr(Renderer.ThreadID));
    Renderer.Terminate;
    Renderer.WaitFor;

    while Renderer <> nil do
      Application.ProcessMessages; // HandleThreadTermination kinda should be called here...(?)
  end;

  assert(not assigned(renderer), 'Render thread is still running!?');

  Renderer := TRenderThread.Create; // Hmm... Why do we use RenderThread here, anyway? :-\
  Renderer.TargetHandle := Handle;
  Renderer.OnProgress := OnProgress;
  Renderer.NrThreads := NrTreads;
  if TraceLevel > 0 then Renderer.Output := TraceForm.FullscreenTrace.Lines;
  Renderer.SetCP(cp);

  Renderer.WaitForMore := true;
  RenderStop.Enabled := true;
  RenderMore.Enabled := false;

  Renderer.Resume;
end;

procedure TFullscreenForm.HandleThreadCompletion(var Message: TMessage);
var
  bm: TBitmap;
begin
  Trace2(MsgComplete + IntToStr(message.LParam));
  if not Assigned(Renderer) then begin
    Trace2(MsgNotAssigned);
    exit;
  end;
  if Renderer.ThreadID <> message.LParam then begin
    Trace2(MsgAnotherRunning);
    exit;
  end;

  if Assigned(Renderer) then
  begin
    bm := TBitmap.Create;
    bm.assign(Renderer.GetImage);
    Image.SetBounds(imgLeft, imgTop, imgWidth, imgHeight);
    Image.Picture.Graphic := bm;
    bm.Free;
  end;

  RenderStop.Enabled := false;
  RenderMore.Enabled := true;

  TimeLimiter.Enabled := false;
end;

procedure TFullscreenForm.HandleThreadTermination(var Message: TMessage);
var
  bm: TBitmap;
begin
  Trace2(MsgTerminated + IntToStr(message.LParam));
  if not Assigned(Renderer) then begin
    Trace2(MsgNotAssigned);
    exit;
  end;
  if Renderer.ThreadID <> message.LParam then begin
    Trace2(MsgAnotherRunning);
    exit;
  end;

  RenderStop.Enabled := false;
  RenderMore.Enabled := false;

  TimeLimiter.Enabled := false;
end;

procedure TFullscreenForm.OnProgress(prog: double);
begin
  prog := (Renderer.Slice + Prog) / Renderer.NrSlices;
  Canvas.Lock;
 try
  if prog >= 1 then
  begin
    Canvas.Brush.Color := clBlack;
    Canvas.FillRect(Rect(5, ClientHeight - 15, ClientWidth - 5, ClientHeight - 5));
  end
  else if prog >= 0 then begin
    Canvas.Brush.Color := clTeal;
    Canvas.FrameRect(Rect(5, ClientHeight - 15, ClientWidth - 5, ClientHeight - 5));
    Canvas.Brush.Color := clTeal;
    Canvas.Fillrect(Rect(7, ClientHeight - 13, 7 + Round(prog * (ClientWidth - 14)), ClientHeight - 7));
    Canvas.Brush.Color := clBlack;
    Canvas.Fillrect(Rect(7 + Round(prog * (ClientWidth - 14)), ClientHeight - 13, ClientWidth - 7, ClientHeight - 7));
  end;
 finally
  Canvas.Unlock;
 end;
  //Application.ProcessMessages;
end;

procedure TFullscreenForm.hideTaskbar;
var wndHandle: THandle;
  wndClass: array[0..50] of Char;
begin
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle := FindWindow(@wndClass[0], nil);
  ShowWindow(wndHandle, SW_HIDE);
end;

procedure TFullscreenForm.showTaskbar;
var wndHandle: THandle;
  wndClass: array[0..50] of Char;
begin
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle := FindWindow(@wndClass[0], nil);
  ShowWindow(wndHandle, SW_RESTORE);
end;

procedure TFullscreenForm.FormShow(Sender: TObject);
begin
  Trace1('--- Opening Fullscreen View ---');

  if Image.Width < ClientWidth then
    Image.Left := (ClientWidth - Image.Width) div 2;
  if Image.Height < ClientHeight then
    Image.Top := (ClientHeight - Image.Height) div 2;

  Closing := false;
  TimeLimiter.Enabled := false;

  RenderStop.Enabled := false;
  RenderMore.Enabled := false;

  MainForm.mnuFullScreen.enabled := true;
  HideTaskbar;

  if calculate then
    DrawFlame;
end;

procedure TFullscreenForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Closing := true;
  if Assigned(Renderer) then begin
    if Renderer.Suspended then begin
      Renderer.WaitForMore := false;
      Renderer.Resume;
    end;
    Trace2('Form closing: killing RenderThread #' + inttostr(Renderer.ThreadID));
    Renderer.Terminate;
    Renderer.WaitFor;

    Trace2('Destroying RenderThread #' + IntToStr(Renderer.ThreadID));
    Renderer.Free;
    Renderer := nil;
  end;
  Trace1('--- Closing Fullscreen View ---');
  Trace1('');
  ShowTaskbar;

  ActiveForm.SetFocus;
end;

procedure TFullscreenForm.FormCreate(Sender: TObject);
begin
  Exit1.Caption := TextByKey('common-close');
	RenderMore.Caption := TextByKey('fullscreen-popup-rendermore');
	RenderStop.Caption := TextByKey('fullscreen-popup-stoprender');
  cp := TControlPoint.Create;
end;

procedure TFullscreenForm.FormDestroy(Sender: TObject);
begin
  if assigned(Renderer) then begin
    Renderer.Terminate;
    Renderer.WaitFor;
    Renderer.Free;
  end;
  cp.Free;
end;

procedure TFullscreenForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = ' ' then begin
    if RenderStop.Enabled then RenderStop.Click
    else if RenderMore.Enabled then RenderMore.Click;
  end
  else Close;
end;

procedure TFullscreenForm.ImageDblClick(Sender: TObject);
begin
  Close;
end;

procedure TFullscreenForm.TimelimiterOnTimer(Sender: TObject);
begin
  //if assigned(Renderer) then Renderer.Break;
  TimeLimiter.Enabled := false;
end;

procedure TFullscreenForm.RenderStopClick(Sender: TObject);
begin
  if assigned(Renderer) then Renderer.BreakRender;
end;

procedure TFullscreenForm.RenderMoreClick(Sender: TObject);
begin
  if assigned(Renderer) and Renderer.Suspended then begin
    Renderer.Resume;
    RenderStop.Enabled := true;
    RenderMore.Enabled := false;
  end;
end;

end.

