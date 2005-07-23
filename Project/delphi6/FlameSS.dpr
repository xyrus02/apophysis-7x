program FlameSS;

uses
  Forms,
  Dialogs,
  SysUtils,
  Render,
  controlpoint,
  windows,
  graphics,
  messages,
  ScrConfig in '..\..\ScreenSaver\ScrConfig.pas' {frmConfig},
  ScrMain in '..\..\ScreenSaver\ScrMain.pas' {frmMain},
  FlameIO in '..\..\ScreenSaver\FlameIO.pas';

{$E SCR}

{$R *.res}

type  TSSMode = (ssSetPwd,ssPreview,ssConfig,ssRun);

var
  MySem: THandle;

function GetScreenSaverMode: TSSMode;
var
  ParamChar: Char;
begin
  Result := ssRun;
  if ParamCount = 0 then
    Exit;

  if Length(ParamStr(1)) = 1 then
    ParamChar := ParamStr(1)[1]
  else
    ParamChar := ParamStr(1)[2];

  Case ParamChar of
  'A', 'a':
    Result := ssSetPwd;
  'P', 'p':
    Result := ssPreview;
  'C', 'c':
    Result := ssConfig;
  else
    Result := ssRun;
  end;
end;

procedure SetPassWord;
var
  SysDir: string;
  NewLen: integer;
  MyMod: THandle;
  PwdFunc:     function (a : PChar; ParentHandle : THandle; b, c : Integer) :
                     Integer; stdcall;
begin
  SetLength(SysDir,MAX_PATH);
  NewLen := GetSystemDirectory(PChar(SysDir),MAX_PATH);
  SetLength(SysDir,NewLen);

  MyMod := LoadLibrary(PChar(IncludeTrailingPathDelimiter(SysDir) + 'MPR.DLL'));
  if MyMod <> 0 then begin
    PwdFunc := GetProcAddress(MyMod,'PwdChangePasswordA');
    if Assigned(PwdFunc) then
      PwdFunc('SCRSAVE',StrToInt(paramstr(2)),0,0);
    FreeLibrary(MyMod);
  end;
end;

function WindowProc(Wnd: HWnd; Msg: Integer; wParam: Word; lParam: Integer): Integer; far; stdcall;
begin

  { Window procedure for the saver preview. Only used for terminating the preview
    version of the saver. }
  if (Msg = WM_DESTROY) or (Msg = WM_CLOSE) then PostMessage(Wnd, WM_QUIT, 0, 0);
  Result := DefWindowProc(Wnd, Msg, wParam, lParam);

end;

procedure Preview;
var
  PreviewCanvas: TCanvas;
  PreviewRect: TRect;
  WndClass: TWndClass;
  DC: hDC;
  MyWnd: hWnd;
  Msg: TMsg;
  ParentHandle: THandle;
  cp : TControlPoint;
  Render: TRenderer;
  bm: TBitmap;
begin
  { To run the preview, you need to create a window class corresponding with the
    little display in the screensaver control panel. This doesn't look very
    elegant in a Delphi project, but I don't think you can use VCL functionality
    to do this... }
  with WndClass do
  begin
    style := CS_PARENTDC;
    lpfnWndProc := @WindowProc;
    cbClsExtra := 0;
    cbWndExtra := 0;
    hIcon := 0;
    hCursor := 0;
    hbrBackground := 0;
    lpszMenuName := nil;
    lpszClassName := 'DeskSpin';
  end;
  WndClass.hInstance := hInstance;
  Windows.RegisterClass(WndClass);

  ParentHandle := StrToInt(ParamStr(2));

  // Initialize a Rect that matches the preview area:
  GetWindowRect(Parenthandle, PreviewRect);
  PreviewRect.Right := PreviewRect.Right - PreviewRect.Left;
  PreviewRect.Bottom := PreviewRect.Bottom - PreviewRect.Top;
  PreviewRect.Left := 0;
  PreviewRect.Top := 0;

  // Instantiate the window class so we can draw to the preview area:
  MyWnd := CreateWindow('DeskSpin', 'DeskSpin',
                        WS_CHILD or WS_DISABLED or WS_VISIBLE, 0, 0,
                        PreviewRect.Right, PreviewRect.Bottom, ParentHandle,
                        0, hInstance, nil);

  // We need a DC before we can draw:
  DC := GetDC(MyWnd);
  { We can create a TCanvas matching the DC, so we can draw the preview with
    familiar functions: }
  PreviewCanvas := TCanvas.Create;
  PreviewCanvas.Handle := DC;

  randomize;
  cp := TControlPoint.Create;
  Render := TRenderer.Create;

  cp.ParseString('pixels_per_unit 277.456647 center -1.0982659 0 gamma 2 spatial_filter_radius' +
                 ' 0.5 contrast 1 brightness 1.5 zoom 0 spatial_oversample 1 sample_density 1 nbatches' +
                 ' 1 white_level 200 cmap_inter 0 time 0 cmap 33 xform 0 density 1 color 0 var 0 0 0 1 0' +
                 ' 0 0 coefs 0.466381997 -0.0618700013 0.0792416036 0.610638022 -0.475656986 -0.28115499'+
                 ' xform 1 density 1 color 1 var 0 0 0 0 1 0 0 coefs -0.513867021 0.271649003 -0.254521996' +
                 ' -0.550984025 -0.674094975 -0.600323975');

  cp.sample_density := 1;
  cp.Width := PreviewRect.Right - PreviewRect.Left;
  cp.Height := PreviewRect.Bottom - PreviewRect.Top;
  cp.spatial_oversample := 2;
  cp.spatial_filter_radius := 0.1;
  cp.Gamma := 4;
  cp.brightness := 4;
  cp.CalcBoundbox;
  Render.SetCP(cp);
  Render.Render;
  BM := Render.GetImage;
  PreviewCanvas.Draw(0,0,bm);


  { Enter a message loop to keep the preview going. I've kept the preview simple
    (plain text output), but if you wanted, you could initialize OpenGL for the
    DC you already have, and actually let your saver render to that. }
  while GetMessage(Msg, 0, 0, 0) do
  begin
    PreviewCanvas.Draw(0,0,bm);

//    PreviewCanvas.FillRect(PreviewRect);
//    PreviewCanvas.TextOut(5, 5, 'Your preview here.');
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
  PreviewCanvas.Free;

  // Close and destroy the preview window:
  CloseWindow(MyWnd);
  DestroyWindow(MyWnd);

  Render.Free;
  cp.Free;
end;

begin
  Case GetScreenSaverMode of
  ssSetPwd:
    begin
      Application.Initialize;
      SetPassWord;
    end;
  ssConfig:
    begin
      Application.Initialize;
      Application.Title := 'Flame Screensaver';
  Application.CreateForm(TfrmConfig, frmConfig);
  Application.Run;
    end;
  ssPreview:
    Preview;
  else // ssrun
    // Test if screen save was already started
    MySem := CreateSemaphore(nil,0,1,'ESDSaverSemaphore');
    if (MySem <> 0) and (GetLastError = ERROR_ALREADY_EXISTS) then begin
      CloseHandle(MySem);
      Exit;
    end;

    Application.Initialize;
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;

    if (MySem <> 0) then
      CloseHandle(MySem);
  end; // Case GetScreenSaverMode of

end.
