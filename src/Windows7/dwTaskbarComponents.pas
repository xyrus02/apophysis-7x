unit dwTaskbarComponents;

interface

{$INCLUDE 'DelphiVersions.inc'}

uses
  Classes, Controls, Messages, dwTaskbarList;

procedure InitCommonControls; stdcall;

type
  TdwTaskbarWinControl = class(TWinControl)
  private
    FIn32BitMode: Boolean;
    FTaskbarList: ITaskbarList;
    FTaskbarList2: ITaskbarList2;
    FTaskbarList3: ITaskbarList3;
    FTaskBarEntryHandle: THandle;
    function GetTaskBarEntryHandle: THandle;

  protected
    procedure CreateParams(var Params: TCreateParams); override;
    property In32BitMode: Boolean read FIn32BitMode;
    property TaskbarList: ITaskbarList read FTaskbarList;
    property TaskbarList2: ITaskbarList2 read FTaskbarList2;
    property TaskbarList3: ITaskbarList3 read FTaskbarList3;

  protected
    class function GetComCtrlClass: Integer; virtual; abstract;
    class function GetComCtrlClassName: PChar; virtual; abstract;

  public
    constructor Create(AOwner: TComponent); override;

    property TaskBarEntryHandle: THandle read GetTaskBarEntryHandle write FTaskBarEntryHandle;
  end;

  TdwTaskbarComponent = class(TComponent)
  private
    FHandle: Cardinal;
    FMsgAutoInitialize: Cardinal;
    FMsgUpdate: Cardinal;
    FAutoInitialize: Boolean;
    FIsInitialized: Boolean;

    FTaskbarList: ITaskbarList;
    FTaskbarList2: ITaskbarList2;
    FTaskbarList3: ITaskbarList3;
    FTaskBarEntryHandle: THandle;
    function GetTaskBarEntryHandle: THandle;
  protected
    procedure CheckInitalization;
    procedure SendUpdateMessage;
    function DoInitialize: Boolean; virtual; 
    procedure DoUpdate; virtual;

    property AutoInitialize: Boolean read FAutoInitialize write FAutoInitialize default True;
    property TaskbarList: ITaskbarList read FTaskbarList;
    property TaskbarList2: ITaskbarList2 read FTaskbarList2;
    property TaskbarList3: ITaskbarList3 read FTaskbarList3;

    property Handle: Cardinal read FHandle;
    function HandleAllocated: Boolean;
    procedure WndProc(var Message: TMessage); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property TaskBarEntryHandle: THandle read GetTaskBarEntryHandle write FTaskBarEntryHandle;
    property IsInitialized: Boolean read FIsInitialized;
  end;

implementation

uses
  Forms, ComCtrls, Windows, ComObj, SysUtils;

procedure InitCommonControls; stdcall; external comctl32;

{ TdwCommon }

constructor TdwTaskbarWinControl.Create(AOwner: TComponent);
var
  Obj: IInterface;
begin
  inherited;

  FIn32BitMode := InitCommonControl(GetComCtrlClass);

  Obj := CreateComObject(CLSID_TaskbarList);
  if Obj = nil then
  begin
    FTaskbarList := nil;
  end
  else
  begin
    FTaskbarList := ITaskbarList(Obj);
    FTaskbarList.HrInit;

    FTaskbarList.QueryInterface(CLSID_TaskbarList2, FTaskbarList2);
    FTaskbarList.QueryInterface(CLSID_TaskbarList3, FTaskbarList3);
  end;

end;

procedure TdwTaskbarWinControl.CreateParams(var Params: TCreateParams);
begin
  if not In32BitMode then
    InitCommonControls;

  inherited;

  CreateSubClass(Params, GetComCtrlClassName);
end;

function TdwTaskbarWinControl.GetTaskBarEntryHandle: THandle;
begin
  if FTaskBarEntryHandle <> 0 then
  begin
    Result := FTaskBarEntryHandle;
  end
  else
  begin
    {$IFNDEF Delphi2007_Up}
      Result := Application.Handle;
    {$ELSE}
      if not Application.MainFormOnTaskBar then
      begin
        Result := Application.Handle;
      end
      else
      begin
        Result := Application.MainForm.Handle;
      end;
    {$ENDIF}
  end;
end;

{ TdwCommonComponent }

procedure TdwTaskbarComponent.CheckInitalization;
begin
  if FIsInitialized then
    raise Exception.Create('Thumbnails are initialized already.');
end;

constructor TdwTaskbarComponent.Create(AOwner: TComponent);
var
  Obj: IInterface;
begin
  inherited;

  Obj := CreateComObject(CLSID_TaskbarList);
  if Obj = nil then
  begin
    FTaskbarList := nil;
  end
  else
  begin
    FTaskbarList := ITaskbarList(Obj);
    FTaskbarList.HrInit;

    FTaskbarList.QueryInterface(CLSID_TaskbarList2, FTaskbarList2);
    FTaskbarList.QueryInterface(CLSID_TaskbarList3, FTaskbarList3);
  end;

  if not (csDesigning in ComponentState) then
  begin
    FHandle := Classes.AllocateHWnd(WndProc);
  end
  else
  begin
    FHandle := 0;
  end;

  FAutoInitialize := True;
  FIsInitialized := False;
  FMsgAutoInitialize := RegisterWindowMessage('dw.Component.Taskbar.Thumbnails.Auto.Initialize');
  FMsgUpdate := RegisterWindowMessage('dw.Component.Taskbar.Thumbnails.Update');

  if HandleAllocated then
    PostMessage(Handle, FMsgAutoInitialize, 0, 0);
end;

destructor TdwTaskbarComponent.Destroy;
begin
  if HandleAllocated then
  begin
    Classes.DeallocateHWnd(FHandle);
    FHandle := 0;
  end;
  inherited;
end;

function TdwTaskbarComponent.DoInitialize: Boolean;
begin
  Result := True;
end;

procedure TdwTaskbarComponent.DoUpdate;
begin

end;

function TdwTaskbarComponent.GetTaskBarEntryHandle: THandle;
begin
  if FTaskBarEntryHandle <> 0 then
  begin
    Result := FTaskBarEntryHandle;
  end
  else
  begin
    {$IFNDEF Delphi2007_Up}
      Result := Application.Handle;
    {$ELSE}
      if not Application.MainFormOnTaskBar then
      begin
        Result := Application.Handle;
      end
      else
      begin
        Result := Application.MainForm.Handle;
      end;
    {$ENDIF}
  end;
end;

function TdwTaskbarComponent.HandleAllocated: Boolean;
begin
  Result := FHandle <> 0;
end;

procedure TdwTaskbarComponent.SendUpdateMessage;
begin
  if HandleAllocated then
    if FIsInitialized then
      PostMessage(Handle, FMsgUpdate, 0, 0);
end;

procedure TdwTaskbarComponent.WndProc(var Message: TMessage);
begin
  if Message.Msg = FMsgAutoInitialize then
  begin
    if FAutoInitialize then
    begin
      FIsInitialized := DoInitialize;
    end;
  end
  else
  if Message.Msg = FMsgUpdate then
  begin
    if FIsInitialized then
      DoUpdate;
  end;

end;

end.
