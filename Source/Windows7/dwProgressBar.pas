unit dwProgressBar;

interface

{$INCLUDE 'DelphiVersions.inc'}

uses
  SysUtils, Classes, Controls, ComCtrls, Messages, Graphics,
  dwTaskbarComponents;

const
  ICC_PROGRESS_CLASS = $00000020;

const
  PBS_SMOOTH = $01;
  PBS_VERTICAL = $04;
  PBS_MARQUEE = $08;
  PBS_SMOOTHREVERSE = $10;

const
  PBM_SETMARQUEE = WM_USER + 10;
  PBM_SETSTATE = WM_USER + 16;
  PBM_GETSTATE = WM_USER + 17;

const
  PBST_NORMAL = $0001;
  PBST_ERROR = $0002;
  PBST_PAUSED = $0003;

type
  TdwProgressBarState = (pbstMarquee = 0, pbstNormal = 1, pbstError = 2, pbstPaused = 3);

  TdwProgressBar = class(TdwTaskbarWinControl)
  private // CodeGear :: ProgressBar
    FMin: Integer;
    FMax: Integer;
    FPosition: Integer;
    FStep: Integer;
    FOrientation: TProgressBarOrientation;
    FSmooth: Boolean;
    FSmoothReverse: Boolean;
    FBarColor: TColor;
    FBackgroundColor: TColor;

    function GetMin: Integer;
    function GetMax: Integer;
    function GetPosition: Integer;
    procedure SetParams(AMin, AMax: Integer);
    procedure SetMin(Value: Integer);
    procedure SetMax(Value: Integer);
    procedure SetPosition(Value: Integer);
    procedure SetStep(Value: Integer);
    procedure SetOrientation(Value: TProgressBarOrientation);
    procedure SetSmooth(Value: Boolean);
    procedure SetSmoothReverse(Value: Boolean);
    procedure SetBarColor(Value: TColor);
    procedure SetBackgroundColor(Value: TColor);
    procedure WMEraseBkGnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;

  private
    {$IFDEF Delphi2006_UP}
      const LIMIT_16 = 65535;
    {$ENDIF}
    class procedure ProgressLimitError;

  private
    FMsgUpdateTaskbar: Cardinal;
    FProgressBarState: TdwProgressBarState;
    FMarqueeEnabled: Boolean;
    FMarqueeInterval: Integer;
    FShowInTaskbar: Boolean;

    procedure SetProgressBarState(const Value: TdwProgressBarState);
    procedure SetMarqueeInterval(const Value: Integer);
    procedure SetShowInTaskbar(const Value: Boolean);
    procedure SetMarqueeEnabled(const Value: Boolean);

  protected // CodeGear :: ProgressBar
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;

  protected
    class function GetComCtrlClass: Integer; override;
    class function GetComCtrlClassName: PChar; override;

    procedure WndProc(var Msg: TMessage); override;

  public // CodeGear ProgressBar
    constructor Create(AOwner: TComponent); override;
    procedure StepIt;
    procedure StepBy(Delta: Integer);

  published // CodeGear ProgressBar
    property Align;
    property Anchors;
    property BorderWidth;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Hint;
    property Constraints;
    property Min: Integer read GetMin write SetMin default 0;
    property Max: Integer read GetMax write SetMax default 100;
    property Orientation: TProgressBarOrientation read FOrientation write SetOrientation default pbHorizontal;
    property ParentShowHint;
    property PopupMenu;
    property Position: Integer read GetPosition write SetPosition default 0;
    property Smooth: Boolean read FSmooth write SetSmooth default False;
    property SmoothReverse: Boolean read FSmoothReverse write SetSmoothReverse default False;
    property Step: Integer read FStep write SetStep default 10;
    property BarColor: TColor read FBarColor write SetBarColor default clDefault;
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor default clDefault;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    {$IFDEF Delphi2006_UP}
      property OnMouseActivate;
      property OnMouseEnter;
      property OnMouseLeave;
    {$ENDIF}
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property DoubleBuffered;
    {$IFDEF Delphi2009_Up}
      property ParentDoubleBuffered;
    {$ENDIF}

  published
    property ProgressBarState: TdwProgressBarState read FProgressBarState write SetProgressBarState default pbstNormal;
    property MarqueeEnabled: Boolean read FMarqueeEnabled write SetMarqueeEnabled default False;
    property MarqueeInterval: Integer read FMarqueeInterval write SetMarqueeInterval default 75;
    property ShowInTaskbar: Boolean read FShowInTaskbar write SetShowInTaskbar default False;
  end;

procedure Register;

implementation

uses
  Consts,
  Themes, CommCtrl, Windows,
  dwTaskbarList;

{$IFNDEF Delphi2006_UP}
  const LIMIT_16 = 65535;
{$ENDIF}

procedure Register;
begin
  RegisterComponents('Windows 6+', [TdwProgressBar]);
end;

{ TdwProgressBar }

constructor TdwProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Width := 150;
  Height := GetSystemMetrics(SM_CYVSCROLL);
  FMin := 0;
  FMax := 100;
  FStep := 10;
  FOrientation := pbHorizontal;
  FBarColor := clDefault;
  FBackgroundColor := clDefault;
  FMarqueeInterval := 10;
  FSmooth := False;
  FSmoothReverse := False;
  FMarqueeInterval := 50;
  FProgressBarState := pbstNormal;
  FShowInTaskbar := False;

  FMsgUpdateTaskbar := RegisterWindowMessage('dw.Control.Update.Taskbar');
end;

procedure TdwProgressBar.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
  begin
    if FOrientation = pbVertical then
      Style := Style or PBS_VERTICAL;
    if FSmooth then
      Style := Style or PBS_SMOOTH;
    if (FProgressBarState = pbstMarquee) and ThemeServices.ThemesEnabled and CheckWin32Version(5, 1) then
      Style := Style or PBS_MARQUEE;
    if FSmoothReverse and ThemeServices.ThemesEnabled and CheckWin32Version(6, 0) then
      Style := Style or PBS_SMOOTHREVERSE;
  end;
end;

procedure TdwProgressBar.CreateWnd;
begin
  inherited CreateWnd;

  if In32BitMode then
  begin
    SendMessage(Handle, PBM_SETRANGE32, FMin, FMax);
  end
  else
  begin
    SendMessage(Handle, PBM_SETRANGE, 0, MakeLong(FMin, FMax));
  end;

  SendMessage(Handle, PBM_SETSTEP, FStep, 0);
  Position := FPosition;
  BarColor := FBarColor;
  BackgroundColor := FBackgroundColor;
  ProgressBarState := FProgressBarState;

  if ThemeServices.ThemesEnabled and CheckWin32Version(5, 1) then
  begin
    if FProgressBarState = pbstMarquee then
      SendMessage(Handle, PBM_SETMARQUEE, Integer(BOOL(FMarqueeEnabled)), FMarqueeInterval);
  end;
end;

procedure TdwProgressBar.DestroyWnd;
begin
  FPosition := Position;
  inherited;
end;

class function TdwProgressBar.GetComCtrlClass: Integer;
begin
  Result := ICC_PROGRESS_CLASS;
end;

class function TdwProgressBar.GetComCtrlClassName: PChar;
begin
  Result := PROGRESS_CLASS;
end;

function TdwProgressBar.GetMax: Integer;
begin
  if HandleAllocated and In32BitMode then
    Result := SendMessage(Handle, PBM_GETRANGE, 0, 0)
  else
    Result := FMax;
end;

function TdwProgressBar.GetMin: Integer;
begin
  if HandleAllocated and In32BitMode then
    Result := SendMessage(Handle, PBM_GETRANGE, 1, 0)
  else
    Result := FMin;
end;

function TdwProgressBar.GetPosition: Integer;
begin
  if HandleAllocated then
  begin
    if In32BitMode then
      Result := SendMessage(Handle, PBM_GETPOS, 0, 0)
    else
      Result := SendMessage(Handle, PBM_DELTAPOS, 0, 0);
  end
  else
  begin
    Result := FPosition;
  end;
end;

class procedure TdwProgressBar.ProgressLimitError;
begin
  raise Exception.CreateFmt(SOutOfRange, [0, LIMIT_16]);
end;

procedure TdwProgressBar.SetBackgroundColor(Value: TColor);
var
  ColorRef: TColorRef;
begin
  if FBackgroundColor <> Value then
  begin
    FBackgroundColor := Value;
    if Value = clDefault then
      ColorRef := TColorRef($FF000000)
    else
      ColorRef := TColorRef(ColorToRGB(Color));

    if HandleAllocated then
      SendMessage(Handle, PBM_SETBKCOLOR, 0, ColorRef);
  end;
end;

procedure TdwProgressBar.SetBarColor(Value: TColor);
var
  ColorRef: TColorRef;
begin
  if FBarColor <> Value then
  begin
    FBarColor := Value;
    if Value = clDefault then
      ColorRef := TColorRef($FF000000)
    else
      ColorRef := TColorRef(ColorToRGB(Color));

    if HandleAllocated then
      SendMessage(Handle, PBM_SETBARCOLOR, 0, ColorRef);
  end;
end;

procedure TdwProgressBar.SetMarqueeEnabled(const Value: Boolean);
begin
  if FMarqueeEnabled <> Value then
  begin
    FMarqueeEnabled := Value;
    if (FProgressBarState = pbstMarquee) and ThemeServices.ThemesEnabled and CheckWin32Version(5, 1) and HandleAllocated then
    begin
      SendMessage(Handle, PBM_SETMARQUEE, Integer(BOOL(FMarqueeEnabled)), FMarqueeInterval);
      PostMessage(Handle, FMsgUpdateTaskbar, 0, 0);
    end;
  end;
end;

procedure TdwProgressBar.SetMarqueeInterval(const Value: Integer);
begin
  if FMarqueeInterval <> Value then
  begin
    FMarqueeInterval := Value;
    if (FProgressBarState = pbstMarquee) and ThemeServices.ThemesEnabled and CheckWin32Version(5, 1) and HandleAllocated then
    begin
      SendMessage(Handle, PBM_SETMARQUEE, Integer(BOOL(FMarqueeEnabled)), FMarqueeInterval);
    end;
  end;
end;

procedure TdwProgressBar.SetMax(Value: Integer);
begin
  if FMax <> Value then
  begin
    SetParams(FMin, Value);
  end;
end;

procedure TdwProgressBar.SetMin(Value: Integer);
begin
  if FMin <> Value then
  begin
    SetParams(Value, FMax);
  end;
end;

procedure TdwProgressBar.SetOrientation(Value: TProgressBarOrientation);
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    RecreateWnd;
  end;
end;

procedure TdwProgressBar.SetParams(AMin, AMax: Integer);
begin
  if AMax < AMin then
    raise EInvalidOperation.CreateFmt(SPropertyOutOfRange, [Self.ClassName]);

  if not In32BitMode and ((AMin < 0) or (AMax > LIMIT_16)) then
    ProgressLimitError;

  if (FMin <> AMin) or (FMax <> AMax) then
  begin
    if HandleAllocated then
    begin
      if In32BitMode then
        SendMessage(Handle, PBM_SETRANGE32, AMin, AMax)
      else
        SendMessage(Handle, PBM_SETRANGE, 0, MakeLong(AMin, AMax));

      if FMin > FMax then
        SendMessage(Handle, PBM_SETPOS, AMin, 0);
      PostMessage(Handle, FMsgUpdateTaskbar, 0, 0);
    end;
    FMin := AMin;
    FMax := AMax;
  end;
end;

procedure TdwProgressBar.SetPosition(Value: Integer);
begin
  if not In32BitMode and ((Value < 0) or (Value > LIMIT_16)) then
    ProgressLimitError;

  if HandleAllocated then
  begin
    SendMessage(Handle, PBM_SETPOS, Value, 0);
    PostMessage(Handle, FMsgUpdateTaskbar, 0, 0);
  end
  else
  begin
    FPosition := Value;
  end;
end;

procedure TdwProgressBar.SetProgressBarState(const Value: TdwProgressBarState);
var
  DoRecreate: Boolean;
begin
  DoRecreate := (FProgressBarState <> Value);
  FProgressBarState := Value;
  if DoRecreate then
  begin
    RecreateWnd;
  end
  else
  begin
    if CheckWin32Version(6, 0) and HandleAllocated then
      SendMessage(Handle, PBM_SETSTATE, Integer(Value), 0);
    PostMessage(Handle, FMsgUpdateTaskbar, 0, 0);
  end;
end;

procedure TdwProgressBar.SetShowInTaskbar(const Value: Boolean);
begin
  if FShowInTaskbar <> Value then
  begin
    FShowInTaskbar := Value;
    PostMessage(Handle, FMsgUpdateTaskbar, 0, 0);
  end;
end;

procedure TdwProgressBar.SetSmooth(Value: Boolean);
begin
  if FSmooth <> Value then
  begin
    FSmooth := Value;
    RecreateWnd;
  end;
end;

procedure TdwProgressBar.SetSmoothReverse(Value: Boolean);
begin
  if FSmoothReverse <> Value then
  begin
    FSmoothReverse := Value;
    RecreateWnd;
  end;
end;

procedure TdwProgressBar.SetStep(Value: Integer);
begin
  if FStep <> Value then
  begin
    FStep := Value;
    if HandleAllocated then
    begin
      SendMessage(Handle, PBM_SETSTEP, FStep, 0);
      PostMessage(Handle, FMsgUpdateTaskbar, 0, 0);
    end;
  end;
end;

procedure TdwProgressBar.StepBy(Delta: Integer);
begin
  if HandleAllocated then
  begin
    SendMessage(Handle, PBM_DELTAPOS, Delta, 0);
    PostMessage(Handle, FMsgUpdateTaskbar, 0, 0);
  end;
end;

procedure TdwProgressBar.StepIt;
begin
  if HandleAllocated then
  begin
    SendMessage(Handle, PBM_STEPIT, 0, 0);
    PostMessage(Handle, FMsgUpdateTaskbar, 0, 0);
  end;
end;

procedure TdwProgressBar.WMEraseBkGnd(var Message: TWMEraseBkgnd);
begin
  DefaultHandler(Message);
end;

procedure TdwProgressBar.WndProc(var Msg: TMessage);
var
  FormHandle: THandle;
begin
  if Msg.Msg = FMsgUpdateTaskbar then
  begin
    if CheckWin32Version(6, 1) and (TaskbarList3 <> nil) then
    begin
      FormHandle := TaskBarEntryHandle;
      if FormHandle <> INVALID_HANDLE_VALUE then
      begin
        if ShowInTaskbar then
        begin
          case FProgressBarState of
            pbstMarquee:
            begin
              TaskbarList3.SetProgressState(FormHandle, TBPF_NORMAL);
              if FMarqueeEnabled then
                TaskbarList3.SetProgressState(FormHandle, TBPF_INDETERMINATE)
              else
                TaskbarList3.SetProgressState(FormHandle, TBPF_NOPROGRESS);
            end;
            pbstNormal: TaskbarList3.SetProgressState(FormHandle, TBPF_NORMAL);
            pbstError: TaskbarList3.SetProgressState(FormHandle, TBPF_ERROR);
            pbstPaused: TaskbarList3.SetProgressState(FormHandle, TBPF_PAUSED);
          end;
          if FProgressBarState in [pbstNormal, pbstError, pbstPaused] then
          begin
            TaskbarList3.SetProgressValue(FormHandle, Position - Min, Max - Min);
          end;
        end
        else
        begin
          TaskbarList3.SetProgressState(FormHandle, TBPF_NOPROGRESS);
        end;
      end;
    end;
  end;

  inherited;
end;

end.
