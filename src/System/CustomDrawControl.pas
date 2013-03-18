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

unit CustomDrawControl;

interface

uses
  Classes, Controls, Messages, Windows, Graphics;

type
  TCustomDrawControl = class(TCustomControl)
  private
    FOnPaint: TNotifyEvent;
    FOnLeave: TNotifyEvent;

    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Message: TMessage); message WM_GETDLGCODE;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected

  public
    procedure Paint; override;

    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property Canvas;

    property OnDblClick;
    property OnKeyDown;
//    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
//    property OnMouseWheelDown;
//    property OnMouseWheelUp;
    property OnEnter;
    property OnExit;
    property OnMouseLeave: TNotifyEvent read FOnLeave write FOnLeave;
  end;

implementation

procedure TCustomDrawControl.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TCustomDrawControl.WMSetFocus(var Message: TWMSetFocus);
begin
  Invalidate;
end;

procedure TCustomDrawControl.WMKillFocus(var Message: TWMKillFocus);
begin
  if assigned(OnExit) then OnExit(self);
  Invalidate;
end;

procedure TCustomDrawControl.WMGetDlgCode(var Message: TMessage);
begin
  inherited;
  Message.Result :=  Message.Result or DLGC_WANTARROWS;
end;

procedure TCustomDrawControl.CMMouseLeave(var Message: TMessage); 
begin
  if Assigned(FOnLeave) then FOnLeave(Self);
end;

procedure TCustomDrawControl.Paint;
begin
  if Assigned(FOnPaint) then FOnPaint(Self);
end;

end.
