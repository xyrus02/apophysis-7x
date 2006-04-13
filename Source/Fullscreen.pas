{
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
unit Fullscreen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ControlPoint, RenderThread, ExtCtrls;

type
  TFullscreenForm = class(TForm)
    Image: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ImageDblClick(Sender: TObject);
  private
    Remainder, StartTime, t: double;
    imgLeft, imgTop,
    imgWidth, imgHeight: integer;

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
  end;

var
  FullscreenForm: TFullscreenForm;

implementation

uses Main, Math, Global;

{$R *.DFM}


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

  if Assigned(Renderer) then begin
    // Hmm... but how can it be assigned & running here, anyway? :-\
    Renderer.Terminate;
    Renderer.WaitFor;

    Application.ProcessMessages; // HandleThreadTermination kinda should be called here...(?)

    Renderer.Free;
    Renderer := nil;
  end;

  assert(not assigned(renderer), 'Render thread is still running!?');

  Renderer := TRenderThread.Create;
  Renderer.TargetHandle := Handle;
  Renderer.OnProgress := OnProgress;
  Renderer.Compatibility := Compatibility;
  Renderer.SetCP(cp);
  Renderer.Resume;
end;

procedure TFullscreenForm.HandleThreadCompletion(var Message: TMessage);
var
  bm: TBitmap;
begin
  if Assigned(Renderer) then
  begin
    bm := TBitmap.Create;
    bm.assign(Renderer.GetImage);
    Image.SetBounds(imgLeft, imgTop, imgWidth, imgHeight);
    Image.Picture.Graphic := bm;

//    Canvas.StretchDraw(Rect(0, 0, ClientWidth, ClientHeight), bm);
    Renderer.Free;
    Renderer := nil;
    bm.Free;
  end;
end;

procedure TFullscreenForm.HandleThreadTermination(var Message: TMessage);
//var
//  bm: TBitmap;
begin
  if Assigned(Renderer) then
  begin
//    bm := TBitmap.Create;
//    bm.assign(Renderer.GetImage);
//    Image.Picture.Graphic := bm;

    Renderer.Free;
    Renderer := nil;
//    bm.Free;
  end;
end;

procedure TFullscreenForm.OnProgress(prog: double);
begin
  prog := (Renderer.Slice + Prog) / Renderer.NrSlices;
  if prog = 1 then
  begin
    Canvas.Brush.Color := clBlack;
    Canvas.FillRect(Rect(5, ClientHeight - 15, ClientWidth - 5, ClientHeight - 5));
  end
  else begin
    Canvas.Brush.Color := clTeal;
    Canvas.FrameRect(Rect(5, ClientHeight - 15, ClientWidth - 5, ClientHeight - 5));
    Canvas.Brush.Color := clTeal;
    Canvas.Fillrect(Rect(7, ClientHeight - 13, 7 + Round(prog * (ClientWidth - 14)), ClientHeight - 7));
    Canvas.Brush.Color := clBlack;
    Canvas.Fillrect(Rect(7 + Round(prog * (ClientWidth - 14)), ClientHeight - 13, ClientWidth - 7, ClientHeight - 7));
  end;
  Application.ProcessMessages;
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
  if Image.Width < ClientWidth then
    Image.Left := (ClientWidth - Image.Width) div 2;
  if Image.Height < ClientHeight then
    Image.Top := (ClientHeight - Image.Height) div 2;

  MainForm.mnuFullScreen.enabled := true;
  HideTaskbar;
  if calculate then
    DrawFlame;
end;

procedure TFullscreenForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(Renderer) then Renderer.Terminate;
  ShowTaskbar;
end;

procedure TFullscreenForm.FormCreate(Sender: TObject);
begin
  cp := TControlPoint.Create;
end;

procedure TFullscreenForm.FormDestroy(Sender: TObject);
begin
  if assigned(Renderer) then Renderer.Terminate;
  if assigned(Renderer) then Renderer.WaitFor;
  if assigned(Renderer) then Renderer.Free;
  cp.Free;
end;

procedure TFullscreenForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  close;
end;

procedure TFullscreenForm.ImageDblClick(Sender: TObject);
begin
  close;
end;

end.

