unit dwTaskbarList;

interface

{$INCLUDE 'DelphiVersions.inc'}

uses
  Windows;

{$IFNDEF Delphi2007_Up}
type
  ULONGLONG = UInt64;
{$ENDIF}

const
  CLSID_TaskbarList: TGUID = '{56FDF344-FD6D-11D0-958A-006097C9A090}';
  CLSID_TaskbarList2: TGUID = '{602D4995-B13A-429B-A66E-1935E44F4317}';
  CLSID_TaskbarList3: TGUID = '{EA1AFB91-9E28-4B86-90E9-9E9F8A5EEFAF}';

const
  THBF_ENABLED = $0000;  
  THBF_DISABLED = $0001;
  THBF_DISMISSONCLICK = $0002;
  THBF_NOBACKGROUND = $0004;
  THBF_HIDDEN = $0008;

const
  THB_BITMAP = $0001;
  THB_ICON = $0002;
  THB_TOOLTIP = $0004;
  THB_FLAGS = $0008;

const
  THBN_CLICKED = $1800;

const
  TBPF_NOPROGRESS	= $00;
	TBPF_INDETERMINATE = $01;
	TBPF_NORMAL	= $02;
	TBPF_ERROR= $04;
	TBPF_PAUSED	= $08;

const
  TBATF_USEMDITHUMBNAIL: DWORD = $00000001;
  TBATF_USEMDILIVEPREVIEW: DWORD = $00000002;
  
const
  WM_DWMSENDICONICTHUMBNAIL = $0323;
  WM_DWMSENDICONICLIVEPREVIEWBITMAP = $0326;

type
  TTipString = array[0..259] of WideChar;
  PTipString = ^TTipString;
  tagTHUMBBUTTON = packed record
    dwMask: DWORD;
    iId: UINT;
    iBitmap: UINT;
    hIcon: HICON;
    szTip: TTipString;
    dwFlags: DWORD;
  end;
  THUMBBUTTON = tagTHUMBBUTTON;
  THUMBBUTTONLIST = ^THUMBBUTTON;
  TThumbButton = THUMBBUTTON;
  TThumbButtonList = array of TThumbButton;

type
  ITaskbarList = interface
    ['{56FDF342-FD6D-11D0-958A-006097C9A090}']
    procedure HrInit; safecall;
    procedure AddTab(hwnd: Cardinal); safecall;
    procedure DeleteTab(hwnd: Cardinal); safecall;
    procedure ActivateTab(hwnd: Cardinal); safecall;
    procedure SetActiveAlt(hwnd: Cardinal); safecall;
  end;

  ITaskbarList2 = interface(ITaskbarList)
    ['{602D4995-B13A-429B-A66E-1935E44F4317}']
    procedure MarkFullscreenWindow(hwnd: Cardinal; fFullscreen: Bool); safecall;
  end;

  ITaskbarList3 = interface(ITaskbarList2)
    ['{EA1AFB91-9E28-4B86-90E9-9E9F8A5EEFAF}']
    procedure SetProgressValue(hwnd: Cardinal; ullCompleted, ullTotal: ULONGLONG); safecall;
    procedure SetProgressState(hwnd: Cardinal; tbpFlags: DWORD); safecall;
    procedure RegisterTab(hwndTab: Cardinal; hwndMDI: Cardinal); safecall;
    procedure UnregisterTab(hwndTab: Cardinal); safecall;
    procedure SetTabOrder(hwndTab: Cardinal; hwndInsertBefore: Cardinal); safecall;
    procedure SetTabActive(hwndTab: Cardinal; hwndMDI: Cardinal; tbatFlags: DWORD); safecall;
    procedure ThumbBarAddButtons(hwnd: Cardinal; cButtons: UINT; Button: THUMBBUTTONLIST); safecall;
    procedure ThumbBarUpdateButtons(hwnd: Cardinal; cButtons: UINT; pButton: THUMBBUTTONLIST); safecall;
    procedure ThumbBarSetImageList(hwnd: Cardinal; himl: Cardinal); safecall;
    procedure SetOverlayIcon(hwnd: Cardinal; hIcon: HICON; pszDescription: LPCWSTR); safecall;
    procedure SetThumbnailTooltip(hwnd: Cardinal; pszTip: LPCWSTR); safecall;
    function SetThumbnailClip(hwnd: Cardinal; prcClip: PRect):Cardinal; safecall;
  end;

implementation

end.
