unit CustomDrawControl;

interface

uses
  Classes, Controls, Messages, Windows, Graphics;

type
  TCustomDrawControl = class(TCustomControl)
  private
    FOnPaint: TNotifyEvent;

    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
//    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
//    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
  protected

  public
    procedure Paint; override;

    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property Canvas;

    property OnDblClick;
    property OnKeyDown;
//    property OnKeyPress;
//    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
//    property OnMouseWheelDown;
//    property OnMouseWheelUp;
    property OnEnter;
    property OnExit;
  end;

implementation

procedure TCustomDrawControl.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

{
procedure TCustomDrawControl.WMSetFocus(var Message: TWMSetFocus);
begin
  Invalidate;
end;

procedure TCustomDrawControl.WMKillFocus(var Message: TWMKillFocus);
begin
  Invalidate;
end;
}

procedure TCustomDrawControl.Paint;
begin
  if Assigned(FOnPaint) then FOnPaint(Self);
end;

end.
