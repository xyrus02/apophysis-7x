{
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Borys, Peter Sdobnov
     Apophysis Copyright (C) 2007-2008 Piotr Borys, Peter Sdobnov

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

//{$D-,L-,O+,Q-,R-,Y-,S-}

unit Main;

//{$define VAR_STR}

interface

uses
  Windows, Forms, Dialogs, Menus, Controls, ComCtrls,
  ToolWin, StdCtrls, Classes, Messages, ExtCtrls, ImgList,
  Jpeg, SyncObjs, SysUtils, ClipBrd, Graphics, Math,
  ExtDlgs, AppEvnts, ShellAPI, Registry,
  Global, Xform, XFormMan, ControlPoint, CMap,
  RenderThread, RenderTypes,
  LibXmlParser, LibXmlComps, PngImage;

const
  PixelCountMax = 32768;
  RS_A1 = 0;
  RS_DR = 1;
  RS_XO = 2;
  RS_VO = 3;

  AppVersionString = 'Apophysis 2.08 beta 2 pre6+';

type
  TMouseMoveState = (msUsual, msZoomWindow, msZoomOutWindow, msZoomWindowMove,
                     msZoomOutWindowMove, msDrag, msDragMove, msRotate, msRotateMove);

type
  TWin32Version = (wvUnknown, wvWin95, wvWin98, wvWinNT, wvWin2000, wvWinXP);

type
  pRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = array[0..PixelCountMax - 1] of TRGBTriple;
  TMatrix = array[0..1, 0..1] of double;

  TMainForm = class(TForm)
    Buttons: TImageList;
    SmallImages: TImageList;
    MainMenu: TMainMenu;
    MainFile: TMenuItem;
    mnuSaveUPR: TMenuItem;
    N1: TMenuItem;
    mnuRandomBatch: TMenuItem;
    FileExitSep: TMenuItem;
    mnuExit: TMenuItem;
    MainEdit: TMenuItem;
    mnuCopyUPR: TMenuItem;
    mnuEditor: TMenuItem;
    mnuRandom: TMenuItem;
    mnuNormalWeights: TMenuItem;
    mnuEqualize: TMenuItem;
    mnuRWeights: TMenuItem;
    mnuOptions: TMenuItem;
    MainHelp: TMenuItem;
    mnuHelpTopics: TMenuItem;
    OpenDialog: TOpenDialog;
    ListPopUp: TPopupMenu;
    mnuItemDelete: TMenuItem;
    mnuListRename: TMenuItem;
    DisplayPopup: TPopupMenu;
    mnuPopFullscreen: TMenuItem;
    RedrawTimer: TTimer;
    mnuVar: TMenuItem;
    mnuVRandom: TMenuItem;
    N3: TMenuItem;
    mnuOpen: TMenuItem;
    mnuSaveAs: TMenuItem;
    N8: TMenuItem;
    mnuGrad: TMenuItem;
    mnuSmoothGradient: TMenuItem;
    ToolBar: TToolBar;
    btnOpen: TToolButton;
    btnSave: TToolButton;
    btnEditor: TToolButton;
    btnGradient: TToolButton;
    ToolButton9: TToolButton;
    ToolButton3: TToolButton;
    mnuView: TMenuItem;
    mnuToolbar: TMenuItem;
    mnuStatusBar: TMenuItem;
    ListView: TListView;
    Splitter: TSplitter;
    BackPanel: TPanel;
    Image: TImage;
    StatusBar: TStatusBar;
    mnuFileContents: TMenuItem;
    mnuUndo: TMenuItem;
    mnuRedo: TMenuItem;
    N5: TMenuItem;
    SaveDialog: TSaveDialog;
    F1: TMenuItem;
    N11: TMenuItem;
    mnuAbout: TMenuItem;
    mnuFullScreen: TMenuItem;
    mnuRender: TMenuItem;
    mnuMutate: TMenuItem;
    btnMutate: TToolButton;
    btnUndo: TToolButton;
    btnRedo: TToolButton;
    mnuAdjust: TMenuItem;
    btnAdjust: TToolButton;
    mnuOpenGradient: TMenuItem;
    mnuResetLocation: TMenuItem;
    N4: TMenuItem;
    N14: TMenuItem;
    mnuSaveUndo: TMenuItem;
    N2: TMenuItem;
    ToolButton1: TToolButton;
    btnOptions: TToolButton;
    btnRender: TToolButton;
    mnuPopResetLocation: TMenuItem;
    N6: TMenuItem;
    mnuPopUndo: TMenuItem;
    N16: TMenuItem;
    mnuPopRedo: TMenuItem;
    btnReset: TToolButton;
    mnuCalculateColors: TMenuItem;
    mnuRandomizeColorValues: TMenuItem;
    N7: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    btnDefine: TToolButton;
    mnuScript: TMenuItem;
    mnuRun: TMenuItem;
    mnuEditScript: TMenuItem;
    N15: TMenuItem;
    btnRun: TToolButton;
    mnuStop: TMenuItem;
    btnStop: TToolButton;
    mnuOpenScript: TMenuItem;
    mnuImportGimp: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    mnuManageFavorites: TMenuItem;
    mnuImageSize: TMenuItem;
    N13: TMenuItem;
    ApplicationEvents: TApplicationEvents;
    mnuPaste: TMenuItem;
    mnuCopy: TMenuItem;
    N20: TMenuItem;
    mnuExportFLame: TMenuItem;
    mnuPostSheep: TMenuItem;
    ListXmlScanner: TEasyXmlScanner;
    N21: TMenuItem;
    XmlScanner: TXmlScanner;
    mnuFlamepdf: TMenuItem;
    ToolButton4: TToolButton;
    tbzoomwindow: TToolButton;
    tbDrag: TToolButton;
    tbRotate: TToolButton;
    mnuimage: TMenuItem;
    tbzoomoutwindow: TToolButton;
    mnuSaveAllAs: TMenuItem;
    ToolButton5: TToolButton;
    btnSize: TToolButton;
    btnFullScreen: TToolButton;
    ToolButton6: TToolButton;
    tbQualityBox: TComboBox;
    View1: TMenuItem;
    tbShowAlpha: TToolButton;
    tbShowTrace: TToolButton;
    tbTraceSeparator: TToolButton;
    mnuRenderAll: TMenuItem;
    mnuBuiltinVars: TMenuItem;
    mnuPluginVars: TMenuItem;
    procedure tbzoomoutwindowClick(Sender: TObject);
    procedure mnuimageClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuSaveUPRClick(Sender: TObject);
    procedure ListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormCreate(Sender: TObject);
    procedure mnuRandomClick(Sender: TObject);
    procedure mnuEqualizeClick(Sender: TObject);
    procedure mnuEditorClick(Sender: TObject);
    procedure mnuRWeightsClick(Sender: TObject);
    procedure mnuRandomBatchClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyUpDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mnuOptionsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuHelpTopicsClick(Sender: TObject);
    procedure mnuRefreshClick(Sender: TObject);
    procedure mnuNormalWeightsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuCopyUPRClick(Sender: TObject);
    procedure mnuItemDeleteClick(Sender: TObject);
    procedure ListViewEdited(Sender: TObject; Item: TListItem;
      var S: string);
    procedure mnuListRenameClick(Sender: TObject);
    procedure BackPanelResize(Sender: TObject);
    procedure mnuNextClick(Sender: TObject);
    procedure mnuPreviousClick(Sender: TObject);
    procedure RedrawTimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MainFileClick(Sender: TObject);
    procedure MainViewClick(Sender: TObject);
    procedure MainToolsClick(Sender: TObject);
    procedure MainHelpClick(Sender: TObject);
    procedure mnuVRandomClick(Sender: TObject);
    procedure mnuSaveAsClick(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure mnuGradClick(Sender: TObject);
    procedure mnuSmoothGradientClick(Sender: TObject);
    procedure mnuToolbarClick(Sender: TObject);
    procedure mnuStatusBarClick(Sender: TObject);
    procedure mnuFileContentsClick(Sender: TObject);
    procedure mnuUndoClick(Sender: TObject);
    procedure mnuRedoClick(Sender: TObject);
    procedure Undo;
    procedure Redo;
    procedure mnuExportBitmapClick(Sender: TObject);
    procedure mnuFullScreenClick(Sender: TObject);
    procedure mnuRenderClick(Sender: TObject);
    procedure mnuMutateClick(Sender: TObject);
    procedure mnuAdjustClick(Sender: TObject);
    procedure mnuResetLocationClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure mnuOpenGradientClick(Sender: TObject);
    procedure mnuSaveUndoClick(Sender: TObject);
    procedure mnuExportBatchClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure mnuCalculateColorsClick(Sender: TObject);
    procedure mnuRandomizeColorValuesClick(Sender: TObject);
    procedure mnuEditScriptClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure mnuRunClick(Sender: TObject);
    procedure mnuOpenScriptClick(Sender: TObject);
    procedure mnuStopClick(Sender: TObject);
    procedure mnuImportGimpClick(Sender: TObject);
    procedure mnuManageFavoritesClick(Sender: TObject);
    procedure mnuShowFullClick(Sender: TObject);
    procedure mnuImageSizeClick(Sender: TObject);
    procedure ApplicationEventsActivate(Sender: TObject);
    procedure mnuPasteClick(Sender: TObject);
    procedure mnuCopyClick(Sender: TObject);
    procedure mnuExportFlameClick(Sender: TObject);

    procedure ListXmlScannerStartTag(Sender: TObject; TagName: string;
      Attributes: TAttrList);
    procedure XMLScannerStartTag(Sender: TObject; TagName: string;
      Attributes: TAttrList);
    procedure XMLScannerEmptyTag(Sender: TObject; TagName: string;
      Attributes: TAttrList);
    procedure mnuFlamepdfClick(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbzoomwindowClick(Sender: TObject);
    procedure tbDragClick(Sender: TObject);
    procedure tbRotateClick(Sender: TObject);
    procedure mnuSaveAllAsClick(Sender: TObject);
    procedure tbQualityBoxKeyPress(Sender: TObject; var Key: Char);
    procedure tbQualityBoxSet(Sender: TObject);
    procedure ImageDblClick(Sender: TObject);
    procedure tbShowAlphaClick(Sender: TObject);
    procedure tbShowTraceClick(Sender: TObject);
    procedure XmlScannerContent(Sender: TObject; Content: String);
    procedure mnuRenderAllClick(Sender: TObject);
    procedure ListViewChanging(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure ListViewInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);

  private
    Renderer: TRenderThread;

    FMouseMoveState: TMouseMoveState;
    FSelectRect, FClickRect: TRect;
    DrawSelection: boolean;
    FRotateAngle: double;
    FClickAngle: double;
    FViewImage: TPngObject;
    FViewPos, FViewOldPos: TSPoint;
    FViewScale: double;
    FShiftState: TShiftState;

    // For parsing:
    FinalXformLoaded: boolean;
    ActiveXformSet: integer;
    XMLPaletteFormat: string;
    XMLPaletteCount: integer;

    procedure DrawImageView;
    procedure DrawZoomWindow;
    procedure DrawRotatelines(Angle: double);

    procedure FillVariantMenu;
    procedure VariantMenuClick(Sender: TObject);

    procedure FavoriteClick(Sender: TObject);
    procedure HandleThreadCompletion(var Message: TMessage);
      message WM_THREAD_COMPLETE;
    procedure HandleThreadTermination(var Message: TMessage);
      message WM_THREAD_TERMINATE;

  public
    { Public declarations }
    UndoIndex, UndoMax: integer;
    Center: array[0..1] of double;
    MainZoom: double;
    StartTime: TDateTime;
    AnimPal: TColorMap;

    VarMenus: array of TMenuItem;

    procedure LoadXMLFlame(filename, name: string); overload;
    procedure LoadXMLFlame(filename: string; index: integer); overload;
    procedure DisableFavorites;
    procedure EnableFavorites;
    procedure ParseXML(var cp1: TControlPoint; const params: PCHAR);
    function SaveFlame(cp1: TControlPoint; title, filename: string): boolean;
    function SaveXMLFlame(const cp1: TControlPoint; title, filename: string): boolean;
    procedure DisplayHint(Sender: TObject);
    procedure OnProgress(prog: double);
    procedure ResizeImage;
    procedure DrawFlame;
    procedure UpdateUndo;
    procedure LoadUndoFlame(index: integer; filename: string);
    procedure SmoothPalette;
    procedure RandomizeCP(var cp1: TControlPoint; alg: integer = 0);
    function UPRString(cp1: TControlPoint; Entry: string): string;
    function SaveGradient(Gradient, Title, FileName: string): boolean;
    function GradientFromPalette(const pal: TColorMap; const title: string): string;
    procedure StopThread;
    procedure UpdateWindows;
    procedure ResetLocation;
    procedure RandomBatch;
    procedure GetScripts;
    function ApplicationOnHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;

{$IFDEF DEBUG}
    procedure AppException(Sender: TObject; E: Exception);
{$ENDIF}
  end;

procedure ListXML(FileName: string; sel: integer);
function EntryExists(En, Fl: string): boolean;
function XMLEntryExists(title, filename: string): boolean;
//procedure ComputeWeights(var cp1: TControlPoint; Triangles: TTriangles; t: integer);
function DeleteEntry(Entry, FileName: string): boolean;
function CleanIdentifier(ident: string): string;
function CleanUPRTitle(ident: string): string;
function GradientString(c: TColorMap): string;
//function PackVariations: int64;
//procedure UnpackVariations(v: int64);
//procedure NormalizeWeights(var cp: TControlPoint);
//procedure EqualizeWeights(var cp: TControlPoint);
procedure MultMatrix(var s: TMatrix; const m: TMatrix);
procedure ListFlames(FileName: string; sel: integer);
procedure ListIFS(FileName: string; sel: integer);
procedure NormalizeVariations(var cp1: TControlPoint);
function GetWinVersion: TWin32Version;

var
  MainForm: TMainForm;
  pname, ptime: string;
  nxform: integer;

  MainCp: TControlPoint;
  ParseCp: TControlPoint;
  mainCPindex: integer;

implementation

uses
{$IFDEF DEBUG}
  JclDebug, ExceptForm,
{$ENDIF}
  Editor, Options, Regstry,  Render,
  FullScreen, FormRender, Mutate, Adjust, Browser, Save, About, CmapData,
  HtmlHlp, ScriptForm, FormFavorites, FormExport, msMultiPartFormData,
  ImageColoring, RndFlame,
  Tracer, Types;

{$R *.DFM}

procedure NormalizeVariations(var cp1: TControlPoint);
var
  totvar: double;
  i, j: integer;
begin
  for i := 0 to NXFORMS - 1 do
  begin
    totvar := 0;
    for j := 0 to NRVAR - 1 do
    begin
      if cp1.xform[i].vars[j] < 0 then cp1.xform[i].vars[j] := cp1.xform[i].vars[j] * -1;
      totvar := totvar + cp1.xform[i].vars[j];
    end;
    if totVar = 0 then
    begin
      cp1.xform[i].vars[0] := 1;
    end
    else
      for j := 0 to NRVAR - 1 do begin
        if totVar <> 0 then
          cp1.xform[i].vars[j] := cp1.xform[i].vars[j] / totvar;
      end;
  end;
end;

function FlameInClipboard: boolean;
var
  flamestr: string;
  isstart, isend: integer;
begin
  { returns true if a flame in clipboard - can be tricked }
  result := false;
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    flamestr := Clipboard.AsText;
    isstart := Pos('<flame', flamestr);
    isend := Pos('</flame>', flamestr);
    if (isstart > 0) and (isend > 0) and (isstart < isend) then Result := true;
  end
end;

procedure MultMatrix(var s: TMatrix; const m: TMatrix);
var
  a, b, c, d, e, f, g, h: double;
begin
  a := s[0, 0];
  b := s[0, 1];
  c := s[1, 0];
  d := s[1, 1];
  e := m[0, 0];
  f := m[0, 1];
  g := m[1, 0];
  h := m[1, 1];
{
    [a, b][e ,f]   [a*e+b*g, a*f+b*h]
    [    ][    ] = [                ]
    [c, d][g, h]   [c*e+d*g, c*f+d*h]
}
  s[0, 0] := a * e + b * g;
  s[0, 1] := a * f + b * h;
  s[1, 0] := c * e + d * g;
  s[1, 1] := c * f + d * h;

end;

(*
function PackVariations: int64;
{ Packs the variation options into an integer with Linear as lowest bit }
var
  i: integer;
begin
  result := 0;
  for i := NRVAR-1 downto 0 do
  begin
    result := (result shl 1) or integer(Variations[i]);
  end;
end;

procedure UnpackVariations(v: int64);
{ Unpacks the variation options form an integer }
var
  i: integer;
begin
  for i := 0 to NRVAR - 1 do
    Variations[i] := boolean(v shr i and 1);
end;
*)

function GetWinVersion: TWin32Version;
{ Returns current version of a host Win32 platform }
begin
  Result := wvUnknown;
  if Win32Platform = VER_PLATFORM_WIN32_WINDOWS then
    if (Win32MajorVersion > 4) or
       ((Win32MajorVersion = 4) and
       (Win32MinorVersion > 0)) then
      Result := wvWin98
    else
      Result := wvWin95
  else
    if Win32MajorVersion <= 4 then
      Result := wvWinNT
    else
      if Win32MajorVersion = 5 then
        Result := wvWin2000
end;

{ ************************************* Help ********************************* }

procedure ShowHelp(Pt: TPoint; ContextId: Integer);
var
  Popup: THHPopup;
begin
  FillChar(Popup, SizeOf(Popup), 0);
  Popup.cbStruct := SizeOf(Popup);
  Popup.hinst := 0;
  Popup.idString := ContextId;
  Popup.pszText := nil;
  GetCursorPos(Pt);
  Popup.pt := Pt;
  Popup.clrForeGround := TColorRef(-1);
  Popup.clrBackground := TColorRef(-1);
  Popup.rcMargins := Rect(-1, -1, -1, -1);
  Popup.pszFont := '';
  HtmlHelp(0, PChar(AppPath + 'Apophysis 2.0.chm::/Popups.txt'), HH_DISPLAY_TEXT_POPUP, DWORD(@Popup));
end;


function TMainForm.ApplicationOnHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
var
  Pos: TPoint;
begin
  Pos.x := 0;
  Pos.y := 0;

  CallHelp := False;
  Result := True;
  case Command of
    HELP_SETPOPUP_POS: Pos := SmallPointToPoint(TSmallPoint(Data));
    HELP_CONTEXTPOPUP: ShowHelp(Pos, Data);
  else Result := False;
  end;
end;

procedure TMainForm.mnuHelpTopicsClick(Sender: TObject);
var
  URL, HelpTopic: string;
begin
  if EditForm.Active then HelpTopic := 'Transform editor.htm'
//  else if GradientForm.Active then HelpTopic := 'Gradient window.htm'
  else if AdjustForm.Active then HelpTopic := 'Adjust window.htm'
  else if MutateForm.Active then HelpTopic := 'Mutation window.htm'
  else if RenderForm.Active then HelpTopic := 'Render window.htm';
  HtmlHelp(0, nil, HH_CLOSE_ALL, 0);
  URL := AppPath + 'Apophysis 2.0.chm';
  if HelpTopic <> '' then URL := URL + '::\' + HelpTopic;
  HtmlHelp(0, PChar(URL), HH_DISPLAY_TOC, 0);
end;

{ **************************************************************************** }

procedure TMainForm.StopThread;
begin
  RedrawTimer.Enabled := False;
  if Assigned(Renderer) then begin
    assert(Renderer.Suspended = false);
    Renderer.Terminate;
    Renderer.WaitFor;
  end;
end;

procedure EqualizeVars(const x: integer);
var
  i: integer;
begin
  for i := 0 to Transforms - 1 do
    MainCp.xform[x].vars[i] := 1.0 / NRVAR;
end;

procedure NormalVars(const x: integer);
var
  i: integer;
  td: double;
begin
  td := 0.0;
  for i := 0 to 6 do
    td := td + Maincp.xform[x].vars[i];
  if (td < 0.001) then
    EqualizeVars(x)
  else
    for i := 0 to 6 do
      MainCp.xform[x].vars[i] := MainCp.xform[x].vars[i] / td;
end;

procedure RandomVariation(cp: TControlPoint);
{ Randomise variation parameters }
var
  a, b, i, j: integer;
begin
  inc(MainSeed);
  RandSeed := MainSeed;
  for i := 0 to cp.NumXForms - 1 do
  begin
    for j := 0 to NRVAR - 1 do
      cp.xform[i].vars[j] := 0;
    repeat
      a := random(NRVAR);
    until Variations[a];
    repeat
      b := random(NRVAR);
    until Variations[b];
    if (a = b) then
    begin
      cp.xform[i].vars[a] := 1;
    end
    else
    begin
      cp.xform[i].vars[a] := random;
      cp.xform[i].vars[b] := 1 - cp.xform[i].vars[a];
    end;
  end;
end;

procedure SetVariation(cp: TControlPoint);
{ Set the current Variation }
var
  i, j: integer;
begin
  if Variation = vRandom then
  begin
    RandomVariation(cp);
  end
  else
    for i := 0 to cp.NumXForms - 1 do
    begin
      for j := 0 to NRVAR - 1 do
        cp.xform[i].vars[j] := 0;
      cp.xform[i].vars[integer(Variation)] := 1;
    end;
end;

procedure TMainForm.RandomizeCP(var cp1: TControlPoint; alg: integer = 0);
(*
var
  vrnd, Min, Max, i, j, rnd: integer;
  Triangles: TTriangles;
  cmap: TColorMap;
  r, s, theta, phi: double;
  skip: boolean;
*)
var
  sourceCP: TControlPoint;
begin
  if assigned(MainCP) then
    sourceCP := MainCP.Clone
  else
    SourceCP := nil;

  if assigned(cp1) then begin
    cp1.Free;
    cp1 := nil;
  end;
  cp1 := RandomFlame(sourceCP, alg);

  if assigned(sourceCP) then
    sourceCP.Free;

(*
  Min := randMinTransforms;
  Max := randMaxTransforms;
  case randGradient of
    0:
      begin
        cp1.CmapIndex := Random(NRCMAPS);
        GetCMap(cmap_index, 1, cp1.cmap);
        cmap_index := cp1.cmapindex;
      end;
    1: cmap := DefaultPalette;
    2: cmap := MainCp.cmap;
    3: cmap := GradientForm.RandomGradient;
  end;
  inc(MainSeed);
  RandSeed := MainSeed;
  transforms := random(Max - (Min - 1)) + Min;
  repeat
    try
      inc(MainSeed);
      RandSeed := MainSeed;
      cp1.clear;
      cp1.RandomCP(transforms, transforms, false);
      cp1.SetVariation(Variation);
      inc(MainSeed);
      RandSeed := MainSeed;

      case alg of
        1: rnd := 0;
        2: rnd := 7;
        3: rnd := 9;
      else
        if (Variation = vLinear) or (Variation = vRandom) then
          rnd := random(10)
        else
          rnd := 9;
      end;
      case rnd of
        0..6:
          begin
            for i := 0 to Transforms - 1 do
            begin
              if Random(10) < 9 then
                cp1.xform[i].c[0, 0] := 1
              else
                cp1.xform[i].c[0, 0] := -1;
              cp1.xform[i].c[0, 1] := 0;
              cp1.xform[i].c[1, 0] := 0;
              cp1.xform[i].c[1, 1] := 1;
              cp1.xform[i].c[2, 0] := 0;
              cp1.xform[i].c[2, 1] := 0;
              cp1.xform[i].color := 0;
              cp1.xform[i].symmetry := 0;
              cp1.xform[i].vars[0] := 1;
              for j := 1 to NVARS - 1 do
                cp1.xform[i].vars[j] := 0;
              Translate(cp1.xform[i], random * 2 - 1, random * 2 - 1);
              Rotate(cp1.xform[i], random * 360);
              if i > 0 then Scale(cp1.xform[i], random * 0.8 + 0.2)
              else Scale(cp1.xform[i], random * 0.4 + 0.6);
              if Random(2) = 0 then
                Multiply(cp1.xform[i], 1, random - 0.5, random - 0.5, 1);
            end;
            SetVariation(cp1);
          end;
        7, 8:
          begin
          { From the source to Chaos: The Software }
            for i := 0 to Transforms - 1 do
            begin
              r := random * 2 - 1;
              if ((0 <= r) and (r < 0.2)) then
                r := r + 0.2;
              if ((r > -0.2) and (r <= 0)) then
                r := r - 0.2;
              s := random * 2 - 1;
              if ((0 <= s) and (s < 0.2)) then
                s := s + 0.2;
              if ((s > -0.2) and (s <= 0)) then
                s := s - -0.2;
              theta := PI * random;
              phi := (2 + random) * PI / 4;
              cp1.xform[i].c[0][0] := r * cos(theta);
              cp1.xform[i].c[1][0] := s * (cos(theta) * cos(phi) - sin(theta));
              cp1.xform[i].c[0][1] := r * sin(theta);
              cp1.xform[i].c[1][1] := s * (sin(theta) * cos(phi) + cos(theta));
            { the next bit didn't translate so well, so I fudge it}
              cp1.xform[i].c[2][0] := random * 2 - 1;
              cp1.xform[i].c[2][1] := random * 2 - 1;
            end;
            for i := 0 to NXFORMS - 1 do
              cp1.xform[i].density := 0;
            for i := 0 to Transforms - 1 do
              cp1.xform[i].density := 1 / Transforms;
            SetVariation(cp1);
          end;
        9: begin
            for i := 0 to NXFORMS - 1 do
              cp1.xform[i].density := 0;
            for i := 0 to Transforms - 1 do
              cp1.xform[i].density := 1 / Transforms;
          end;
      end; // case
      MainForm.TrianglesFromCp(cp1, Triangles);
      vrnd := Random(2);
      if vrnd > 0 then
        ComputeWeights(cp1, Triangles, transforms)
      else
        EqualizeWeights(cp1);
    except on E: EmathError do
      begin
        Continue;
      end;
    end;
    for i := 0 to Transforms - 1 do
      cp1.xform[i].color := i / (transforms - 1);
    if cp1.xform[0].density = 1 then Continue;
    case SymmetryType of
      { Bilateral }
      1: add_symmetry_to_control_point(cp1, -1);
      { Rotational }
      2: add_symmetry_to_control_point(cp1, SymmetryOrder);
      { Rotational and Reflective }
      3: add_symmetry_to_control_point(cp1, -SymmetryOrder);
    end;
    { elimate flames with transforms that aren't affine }
    skip := false;
    for i := 0 to Transforms - 1 do
      if not transform_affine(Triangles[i], Triangles) then
        skip := True;
    if skip then continue;
  until not cp1.BlowsUP(5000) and (cp1.xform[0].density <> 0);
  cp1.brightness := defBrightness;
  cp1.gamma := defGamma;
  cp1.vibrancy := defVibrancy;
  cp1.sample_density := defSampleDensity;
  cp1.spatial_oversample := defOversample;
  cp1.spatial_filter_radius := defFilterRadius;
  cp1.cmapIndex := MainCp.cmapindex;
  if not KeepBackground then begin
    cp1.background[0] := 0;
    cp1.background[1] := 0;
    cp1.background[2] := 0;
  end;
  if randGradient = 0 then
  else cp1.cmap := cmap;
  cp1.zoom := 0;
  cp1.Nick := SheepNick;
  cp1.URl := SheepURL;
*)
end;

function TMainForm.GradientFromPalette(const pal: TColorMap; const title: string): string;
var
  c, i, j: integer;
  strings: TStringList;
begin
  strings := TStringList.Create;
  try
    strings.add('gradient:');
    strings.add(' title="' + CleanUPRTitle(title) + '" smooth=no');
    for i := 0 to 255 do
    begin
      j := round(i * (399 / 255));
      c := pal[i][2] shl 16 + pal[i][1] shl 8 + pal[i][0];
      strings.Add(' index=' + IntToStr(j) + ' color=' + intToStr(c));
    end;
    result := strings.text;
  finally
    strings.free;
  end;
end;

function CleanIdentifier(ident: string): string;
{ Strips unwanted characters from an identifier}
var
  i: integer;
begin
  for i := 0 to Length(ident) do
  begin
    if ident[i] = #32 then
      ident[i] := '_'
    else if ident[i] = '}' then
      ident[i] := '_'
    else if ident[i] = '{' then
      ident[i] := '_';
  end;
  Result := ident;
end;

procedure TMainForm.OnProgress(prog: double);
var
  Elapsed, Remaining: TDateTime;
begin
  Elapsed := Now - StartTime;
  StatusBar.Panels[0].Text := Format('Elapsed %2.2d:%2.2d:%2.2d.%2.2d',
    [Trunc(Elapsed * 24),
    Trunc((Elapsed * 24 - Trunc(Elapsed * 24)) * 60),
      Trunc((Elapsed * 24 * 60 - Trunc(Elapsed * 24 * 60)) * 60),
      Trunc((Elapsed * 24 * 60 * 60 - Trunc(Elapsed * 24 * 60 * 60)) * 100)]);
  if prog > 0 then
    Remaining := Elapsed/prog - Elapsed
  else
    Remaining := 0;

  StatusBar.Panels[1].Text := Format('Remaining %2.2d:%2.2d:%2.2d.%2.2d',
    [Trunc(Remaining * 24),
    Trunc((Remaining * 24 - Trunc(Remaining * 24)) * 60),
      Trunc((Remaining * 24 * 60 - Trunc(Remaining * 24 * 60)) * 60),
      Trunc((Remaining * 24 * 60 * 60 - Trunc(Remaining * 24 * 60 * 60)) * 100)]);
  StatusBar.Panels[2].Text := MainCp.name;
  //Application.ProcessMessages;
end;

procedure TMainForm.UpdateUndo;
begin
  SaveFlame(MainCp, Format('%.4d-', [UndoIndex]) + MainCp.name, AppPath + 'apophysis.undo');
  Inc(UndoIndex);
  UndoMax := UndoIndex; //Inc(UndoMax);
  mnuSaveUndo.Enabled := true;
  mnuUndo.Enabled := True;
  mnuPopUndo.Enabled := True;
  mnuRedo.Enabled := false;
  mnuPopRedo.Enabled := false;
  btnUndo.enabled := true;
  btnRedo.Enabled := false;
  EditForm.mnuUndo.Enabled := True;
  EditForm.mnuRedo.Enabled := false;
  EditForm.tbUndo.enabled := true;
  EditForm.tbRedo.enabled := false;
  AdjustForm.btnUndo.enabled := true;
  AdjustForm.btnRedo.enabled := false;
end;

function GradientEntries(gFilename: string): string;
var
  i, p: integer;
  Title: string;
  FileStrings: TStringList;
  NewStrings: TStringList;
begin
  FileStrings := TStringList.Create;
  NewStrings := TStringList.Create;
  NewStrings.Text := '';
  FileStrings.LoadFromFile(gFilename);
  try
    if (Pos('{', FileStrings.Text) <> 0) then
    begin
      for i := 0 to FileStrings.Count - 1 do
      begin
        p := Pos('{', FileStrings[i]);
        if (p <> 0) then
        begin
          Title := Trim(Copy(FileStrings[i], 1, p - 1));
          if (Title <> '') and (LowerCase(Title) <> 'comment') then
          begin { Otherwise bad format }
            NewStrings.Add(Title);
          end;
        end;
      end;
      GradientEntries := NewStrings.Text;
    end;
  finally
    FileStrings.Free;
    NewStrings.Free;
  end;
end;

{ ********************************* File ************************************* }

function EntryExists(En, Fl: string): boolean;
{ Searches for existing identifier in parameter files }
var
  FStrings: TStringList;
  i: integer;
begin
  Result := False;
  if FileExists(Fl) then
  begin
    FStrings := TStringList.Create;
    try
      FStrings.LoadFromFile(Fl);
      for i := 0 to FStrings.Count - 1 do
        if Pos(LowerCase(En) + ' {', Lowercase(FStrings[i])) <> 0 then
          Result := True;
    finally
      FStrings.Free;
    end
  end
  else
    Result := False;
end;

function CleanEntry(ident: string): string;
{ Strips unwanted characters from an identifier}
var
  i: integer;
begin
  for i := 1 to Length(ident) do
  begin
    if ident[i] = #32 then
      ident[i] := '_'
    else if ident[i] = '}' then
      ident[i] := '_'
    else if ident[i] = '{' then
      ident[i] := '_';
  end;
  Result := ident;
end;

function CleanXMLName(ident: string): string;
var
  i: integer;
begin
  for i := 1 to Length(ident) do
  begin
    if ident[i] = '*' then
      ident[i] := '_'
    else if ident[i] = '"' then
      ident[i] := #39;
  end;
  Result := ident;
end;


function CleanUPRTitle(ident: string): string;
{ Strips braces but leave spaces }
var
  i: integer;
begin
  for i := 1 to Length(ident) do
  begin
    if ident[i] = '}' then
      ident[i] := '_'
    else if ident[i] = '{' then
      ident[i] := '_';
  end;
  Result := ident;
end;

function DeleteEntry(Entry, FileName: string): boolean;
{ Deletes an entry from a multi-entry file }
var
  Strings: TStringList;
  p, i: integer;
begin
  Result := True;
  Strings := TStringList.Create;
  try
    i := 0;
    Strings.LoadFromFile(FileName);
    while Pos(Entry + ' ', Trim(Strings[i])) <> 1 do
    begin
      inc(i);
    end;
    repeat
      p := Pos('}', Strings[i]);
      Strings.Delete(i);
    until p <> 0;
    if (i < Strings.Count) and (Trim(Strings[i]) = '') then Strings.Delete(i);
    Strings.SaveToFile(FileName);
  finally
    Strings.Free;
  end;
end;

function SaveUPR(Entry, FileName: string): boolean;
{ Saves UF parameter to end of file }
var
  UPRFile: TextFile;
begin
  Result := True;
  try
    AssignFile(UPRFile, FileName);
    if FileExists(FileName) then
    begin
      if EntryExists(Entry, FileName) then DeleteEntry(Entry, FileName);
      Append(UPRFile);
    end
    else
      ReWrite(UPRFile);
    WriteLn(UPRFile, MainForm.UPRString(MainCp, Entry));
    CloseFile(UPRFile);
  except on E: EInOutError do
    begin
      Application.MessageBox('Cannot save file', 'Apophysis', 16);
      Result := False;
    end;
  end;
end;

function IFSToString(cp: TControlPoint; Title: string): string;
{ Creates a string containing a formated IFS parameter set }
var
  i: integer;
  a, b, c, d, e, f, p: double;
  Strings: TStringList;
begin
  Strings := TStringList.Create;
  try
    Strings.Add(CleanEntry(Title) + ' {');
    for i := 0 to Transforms - 1 do
    begin
      a := cp.xform[i].c[0][0];
      b := cp.xform[i].c[0][1];
      c := cp.xform[i].c[1][0];
      d := cp.xform[i].c[1][1];
      e := cp.xform[i].c[2][0];
      f := cp.xform[i].c[2][1];
      p := cp.xform[i].density;
      Strings.Add(Format('%.6g %.6g %.6g %.6g %.6g %.6g %.6g',
        [a, b, c, d, e, f, p]));
    end;
    Strings.Add('}');
    IFSToString := Strings.Text;
  finally
    Strings.Free;
  end;
end;

function GetTitle(str: string): string;
var
  p: integer;
begin
  str := Trim(str);
  p := Pos(' ', str);
  GetTitle := Trim(Copy(str, 1, p));
end;

function GetComment(str: string): string;
{ Extracts comment form line of IFS file }
var
  p: integer;
begin
  str := Trim(str);
  p := Pos(';', str);
  if p <> 0 then
    GetComment := Trim(Copy(str, p + 1, Length(str) - p))
  else
    GetComment := '';
end;

function GetParameters(str: string; var a, b, c, d, e, f, p: double): boolean;
var
  Tokens: TStringList;
begin
  GetParameters := False;
  Tokens := TStringList.Create;
  try
    try
      GetTokens(str, tokens);
      if Tokens.Count >= 7 then {enough tokens}
      begin
        a := StrToFloat(Tokens[0]);
        b := StrToFloat(Tokens[1]);
        c := StrToFloat(Tokens[2]);
        d := StrToFloat(Tokens[3]);
        e := StrToFloat(Tokens[4]);
        f := StrToFloat(Tokens[5]);
        p := StrToFloat(Tokens[6]);
        Result := True;
      end;
    except on E: EConvertError do
      begin
        Result := False
      end;
    end;
  finally
    Tokens.Free;
  end;
end;

function StringToIFS(strng: string): boolean;
{ Loads an IFS parameter set from string}
var
  Strings: TStringList;
  Comments: TStringList;
  i, sTransforms: integer;
  cmnt, sTitle: string;
  a, b, c, d: double;
  e, f, p: double;
begin
  MainCp.clear;
  StringToIFS := True;
  sTransforms := 0;
  Strings := TStringList.Create;
  Comments := TStringList.Create;
  try
    try
      Strings.Text := strng;
      if Pos('}', Strings.Text) = 0 then
        raise EFormatInvalid.Create('No closing brace');
      if Pos('{', Strings[0]) = 0 then
        raise EFormatInvalid.Create('No opening brace.');
      {To Do ... !!!!}
      sTitle := GetTitle(Strings[0]);
      if sTitle = '' then raise EFormatInvalid.Create('No identifier.');
      cmnt := GetComment(Strings[0]);
      if cmnt <> '' then Comments.Add(cmnt);
      i := 1;
      try
        repeat
          cmnt := GetComment(Strings[i]);
          if cmnt <> '' then Comments.Add(cmnt);
          if (Pos(';', Trim(Strings[i])) <> 1) and (Trim(Strings[i]) <> '') then
            if GetParameters(Strings[i], a, b, c, d, e, f, p) then
            begin
              MainCp.xform[sTransforms].c[0][0] := a;
              MainCp.xform[sTransforms].c[0][1] := c;
              MainCp.xform[sTransforms].c[1][0] := b;
              MainCp.xform[sTransforms].c[1][1] := d;
              MainCp.xform[sTransforms].c[2][0] := e;
              MainCp.xform[sTransforms].c[2][1] := f;
              MainCp.xform[sTransforms].density := p;
              inc(sTransforms);
            end
            else
              EFormatInvalid.Create('Insufficient parameters.');
          inc(i);
        until (Pos('}', Strings[i]) <> 0) or (sTransforms = NXFORMS);
      except on E: EMathError do
      end;
      if sTransforms < 2 then
        raise EFormatInvalid.Create('Insufficient parameters.');
      MainCp.name := sTitle;
      Transforms := sTransforms;
      for i := 1 to Transforms - 1 do
        MainCp.xform[i].color := 0;
      MainCp.xform[0].color := 1;

    except on E: EFormatInvalid do
      begin
        Application.MessageBox('Invalid Format.', PChar(APP_NAME), 16);
      end;
    end;
  finally
    Strings.Free;
    Comments.Free;
  end;
end;


function SaveIFS(cp: TControlPoint; Title, FileName: string): boolean;
{ Saves IFS parameters to end of file }
var
  a, b, c: double;
  d, e, f, p: double;
  m: integer;
  IFile: TextFile;
begin
  Result := True;
  try
    AssignFile(IFile, FileName);
    if FileExists(FileName) then
    begin
      if EntryExists(Title, FileName) then DeleteEntry(Title, FileName);
      Append(IFile);
    end
    else
      ReWrite(IFile);
    WriteLn(IFile, Title + ' {');
    for m := 0 to Transforms - 1 do
    begin
      a := cp.xform[m].c[0][0];
      c := cp.xform[m].c[0][1];
      b := cp.xform[m].c[1][0];
      d := cp.xform[m].c[1][1];
      e := cp.xform[m].c[2][0];
      f := cp.xform[m].c[2][1];
      p := cp.xform[m].density;
      Write(IFile, Format('%.6g %.6g %.6g %.6g %.6g %.6g %.6g',
        [a, b, c, d, e, f, p]));
      WriteLn(IFile, '');
    end;
    WriteLn(IFile, '}');
    WriteLn(IFile, ' ');
    CloseFile(IFile);
  except on E: EInOutError do
    begin
      Application.MessageBox('Cannot save file', 'Apophysis', 16);
      Result := False;
    end;
  end;
end;

function TMainForm.SaveFlame(cp1: TControlPoint; title, filename: string): boolean;
{ Saves Flame parameters to end of file }
var
  IFile: TextFile;
  sl: TStringList;
  i: integer;
begin
  Result := True;
  try
    AssignFile(IFile, filename);
    if FileExists(filename) then
    begin
      if EntryExists(title, filename) then DeleteEntry(title, fileName);
      Append(IFile);
    end
    else ReWrite(IFile);

    sl := TStringList.Create;
    try
      cp1.SaveToStringList(sl);
      WriteLn(IFile, title + ' {');
      write(IFile, sl.Text);
      WriteLn(IFile, 'palette:');
      for i := 0 to 255 do
      begin
        WriteLn(IFile, IntToStr(cp1.cmap[i][0]) + ' ' +
                       IntToStr(cp1.cmap[i][1]) + ' ' +
                       IntToStr(cp1.cmap[i][2]))
      end;
      WriteLn(IFile, ' }');
    finally
      sl.free
    end;
    WriteLn(IFile, ' ');
    CloseFile(IFile);

  except on EInOutError do
    begin
      Application.MessageBox('Cannot save file', 'Apophysis', 16);
      Result := False;
    end;
  end;
end;

function ColorToXmlCompact(cp1: TControlPoint): string;
var
  i: integer;
begin
  Result := '   <palette count="256" format="RGB">';
  for i := 0 to 255 do  begin
    if ((i and 7) = 0) then Result := Result + #13#10 + '      ';
    Result := Result + IntToHex(cp1.cmap[i, 0],2)
                     + IntToHex(cp1.cmap[i, 1],2)
                     + IntToHex(cp1.cmap[i, 2],2);
  end;
  Result := Result + #13#10 + '   </palette>';
end;


function ColorToXml(cp1: TControlPoint): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to 255 do  begin
    Result := Result + '   <color index="' + IntToStr(i) +
      '" rgb="' + IntToStr(cp1.cmap[i, 0]) + ' ' +
                  IntToStr(cp1.cmap[i, 1]) + ' ' +
                  IntToStr(cp1.cmap[i, 2]) + '"/>' + #13#10;
  end;
end;


function FlameToXML(const cp1: TControlPoint; exporting: boolean): string;
var
  t, i{, j}: integer;
  FileList: TStringList;
  x, y: double;
  parameters: string;
begin
  FileList := TStringList.create;
  x := cp1.center[0];
  y := cp1.center[1];

//  if cp1.cmapindex >= 0 then pal := pal + 'gradient="' + IntToStr(cp1.cmapindex) + '" ';

  try
    parameters := 'version="' + AppVersionString + '" ';
    if cp1.time <> 0 then
      parameters := parameters + format('time="%g" ', [cp1.time]);

    parameters := parameters +
      'size="' + IntToStr(cp1.width) + ' ' + IntToStr(cp1.height) +
      format('" center="%g %g" ', [x, y]) +
      format('scale="%g" ', [cp1.pixels_per_unit]);

    if cp1.FAngle <> 0 then
      parameters := parameters + format('angle="%g" ', [cp1.FAngle]) +
                                 format('rotate="%g" ', [-180 * cp1.FAngle/Pi]);
    if cp1.zoom <> 0 then
      parameters := parameters + format('zoom="%g" ', [cp1.zoom]);

    parameters := parameters + format(
             'oversample="%d" filter="%g" quality="%g" ',
             [cp1.spatial_oversample,
              cp1.spatial_filter_radius,
              cp1.sample_density]
             );
    if cp1.nbatches <> 1 then parameters := parameters + 'batches="' + IntToStr(cp1.nbatches) + '" ';

    parameters := parameters +
      format('background="%g %g %g" ', [cp1.background[0] / 255, cp1.background[1] / 255, cp1.background[2] / 255]) +
      format('brightness="%g" ', [cp1.brightness]) +
      format('gamma="%g" ', [cp1.gamma]);

    if cp1.vibrancy <> 1 then
      parameters := parameters + format('vibrancy="%g" ', [cp1.vibrancy]);

    if cp1.gamma_threshold <> 0 then
      parameters := parameters + format('gamma_threshold="%g" ', [cp1.gamma_threshold]);

    if cp1.soloXform >= 0 then
      parameters := parameters + format('soloxform="%d" ', [cp1.soloXform]);

    if exporting then parameters := parameters +
      format('estimator_radius="%g" ', [cp1.estimator]) +
      format('estimator_minimum="%g" ', [cp1.estimator_min]) +
      format('estimator_curve="%g" ', [cp1.estimator_curve]) +
      format('temporal_samples="%d" ', [cp1.jitters]);

    FileList.Add('<flame name="' + CleanXMLName(cp1.name) + '" ' + parameters + '>');
   { Write transform parameters }
    t := cp1.NumXForms;
    for i := 0 to t - 1 do
      FileList.Add(cp1.xform[i].ToXMLString);
    if cp1.HasFinalXForm then
    begin
      // 'enabled' flag disabled in this release
      FileList.Add(cp1.xform[t].FinalToXMLString(cp1.finalXformEnabled));
    end;

    { Write palette data }
    if exporting or OldPaletteFormat then
      FileList.Add(ColorToXml(cp1))
    else
      FileList.Add(ColorToXmlCompact(cp1));

    FileList.Add('</flame>');
    result := FileList.text;
  finally
    FileList.free
  end;
end;

function RemoveExt(filename: string): string;
var
  ext: string;
  p: integer;
begin
  filename := ExtractFileName(filename);
  ext := ExtractFileExt(filename);
  p := Pos(ext, filename);
  Result := Copy(filename, 0, p - 1);
end;

function XMLEntryExists(title, filename: string): boolean;
var
  FileList: TStringList;
begin

  Result := false;
  if FileExists(filename) then
  begin
    FileList := TStringList.Create;
    try
      FileList.LoadFromFile(filename);
      if pos('<flame name="' + title + '"', FileList.Text) <> 0 then Result := true;
    finally
      FileList.Free;
    end
  end else
    result := false;
end;

procedure DeleteXMLEntry(title, filename: string);
var
  Strings: TStringList;
  p, i: integer;
begin
  Strings := TStringList.Create;
  try
    i := 0;
    Strings.LoadFromFile(FileName);
    while Pos('name="' + title + '"', Trim(Strings[i])) = 0 do
      inc(i);

    p := 0;
    while p = 0 do
    begin
      p := Pos('</flame>', Strings[i]);
      Strings.Delete(i);
    end;
    Strings.SaveToFile(FileName);
  finally
    Strings.Free;
  end;
end;


function TMainForm.SaveXMLFlame(const cp1: TControlPoint; title, filename: string): boolean;
{ Saves Flame parameters to end of file }
var
  Tag: string;
  IFile: TextFile;
  FileList: TStringList;
  i, p: integer;
  bakname: string;
begin
  Tag := RemoveExt(filename);
  Result := True;
  try
    if FileExists(filename) then
    begin
      bakname := ChangeFileExt(filename, '.bak');
      if FileExists(bakname) then DeleteFile(bakname);
      RenameFile(filename, bakname);

      FileList := TStringList.create;
      try
        FileList.LoadFromFile(bakname);

        if Pos('<flame name="' + title + '"', FileList.Text) <> 0 then
        begin
          i := 0;
          while Pos('<flame name="' + title + '"', Trim(FileList[i])) = 0 do
            inc(i);

          p := 0;
          while p = 0 do
          begin
            p := Pos('</flame>', FileList[i]);
            FileList.Delete(i);
          end;
        end;

//      FileList := TStringList.create;
//      try
//        FileList.LoadFromFile(filename);

        // fix first line
        if (FileList.Count > 0) then begin
          FileList[0] := '<Flames name="' + Tag + '">';
        end;

        if FileList.Count > 2 then
        begin
          if pos('<flame ', FileList.text) <> 0 then
            repeat
              FileList.Delete(FileList.Count - 1);
            until (Pos('</flame>', FileList[FileList.count - 1]) <> 0)
          else
            repeat
              FileList.Delete(FileList.Count - 1);
            until (Pos('<' + Tag + '>', FileList[FileList.count - 1]) <> 0) or
                  (Pos('</Flames>', FileList[FileList.count - 1]) <> 0);
        end else
        begin
          FileList.Delete(FileList.Count - 1);
        end;

        FileList.Add(Trim(FlameToXML(cp1, false)));
        FileList.Add('</Flames>');
        FileList.SaveToFile(filename);

      finally
        if FileExists(bakname) and not FileExists(filename) then
          RenameFile(bakname, filename);

        FileList.Free;
      end;
    end
    else
    begin
    // New file ... easy
      AssignFile(IFile, filename);
      ReWrite(IFile);
      Writeln(IFile, '<Flames name="' + Tag + '">');
      Write(IFile, FlameToXML(cp1, false));
      Writeln(IFile, '</Flames>');
      CloseFile(IFile);
    end;
  except on E: EInOutError do
    begin
      Application.MessageBox('Cannot save file', 'Apophysis', 16);
      Result := False;
    end;
  end;
end;

function TMainForm.SaveGradient(Gradient, Title, FileName: string): boolean;
{ Saves gradient parameters to end of file }
var
  IFile: TextFile;
begin
  Result := True;
  try
    AssignFile(IFile, FileName);
    if FileExists(FileName) then
    begin
      if EntryExists(Title, FileName) then DeleteEntry(Title, FileName);
      Append(IFile);
    end
    else
      ReWrite(IFile);
    Write(IFile, Gradient);
    WriteLn(IFile, ' ');
    CloseFile(IFile);
  except on EInOutError do
    begin
      Application.MessageBox('Cannot save file', 'Apophysis', 16);
      Result := False;
    end;
  end;
end;

function RenameIFS(OldIdent: string; var NewIdent: string): boolean;
{ Renames an IFS parameter set in a file }
var
  Strings: TStringList;
  p, i: integer;
  s: string;
begin
  Result := True;
  NewIdent := CleanEntry(NewIdent);
  Strings := TStringList.Create;
  try
    try
      i := 0;
      Strings.LoadFromFile(OpenFile);
      if Pos(OldIdent + ' ', Trim(Strings.Text)) <> 0 then
      begin
        while Pos(OldIdent + ' ', Trim(Strings[i])) <> 1 do
        begin
          inc(i);
        end;
        p := Pos('{', Strings[i]);
        s := Copy(Strings[i], p, Length(Strings[i]) - p + 1);
        Strings[i] := NewIdent + ' ' + s;
        Strings.SaveToFile(OpenFile);
      end
      else
        Result := False;
    except on Exception do Result := False;
    end;
  finally
    Strings.Free;
  end;
end;

function RenameXML(OldIdent: string; var NewIdent: string): boolean;
{ Renames an XML parameter set in a file }
var
  Strings: TStringList;
  i: integer;
  bakname: string;
begin
  Result := True;
  Strings := TStringList.Create;
  try
    try
      i := 0;
      Strings.LoadFromFile(OpenFile);
      if Pos('name="' + OldIdent + '"', Strings.Text) <> 0 then
      begin
        while Pos('name="' + OldIdent + '"', Strings[i]) = 0 do
        begin
          inc(i);
        end;
        Strings[i] := StringReplace(Strings[i], OldIdent, NewIdent, []);

        bakname := ChangeFileExt(OpenFile, '.bak');
        if FileExists(bakname) then DeleteFile(bakname);
        RenameFile(OpenFile, bakname);

        Strings.SaveToFile(OpenFile);
      end
      else
        Result := False;
    except on Exception do Result := False;
    end;
  finally
    Strings.Free;
  end;
end;


procedure ListIFS(FileName: string; sel: integer);
{ List identifiers in file }
var
  i, p: integer;
  Title: string;
  ListItem: TListItem;
  FStrings: TStringList;
begin
  FStrings := TStringList.Create;
  FStrings.LoadFromFile(FileName);
  try
    MainForm.ListView.Items.BeginUpdate;
    MainForm.ListView.Items.Clear;
    if (Pos('{', FStrings.Text) <> 0) then
    begin
      for i := 0 to FStrings.Count - 1 do
      begin
        p := Pos('{', FStrings[i]);
        if (p <> 0) and (Pos('(3D)', FStrings[i]) = 0) then
        begin
          Title := Trim(Copy(FStrings[i], 1, p - 1));
          if Title <> '' then
          begin { Otherwise bad format }
            ListItem := MainForm.ListView.Items.Add;
            Listitem.Caption := Trim(Copy(FStrings[i], 1, p - 1));
          end;
        end;
      end;
    end;
    MainForm.ListView.Items.EndUpdate;
    case sel of
      0: MainForm.ListView.Selected := MainForm.ListView.Items[MainForm.ListView.Items.Count - 1];
      1: MainForm.ListView.Selected := MainForm.ListView.Items[0];
    end;
  finally
    FStrings.Free;
  end;
end;

procedure ListFlames(FileName: string; sel: integer);
{ List identifiers in file }
var
  i, p: integer;
  Title: string;
  ListItem: TListItem;
  FStrings: TStringList;
begin
  FStrings := TStringList.Create;
  FStrings.LoadFromFile(FileName);
  try
    MainForm.ListView.Items.BeginUpdate;
    MainForm.ListView.Items.Clear;
    if (Pos('{', FStrings.Text) <> 0) then
    begin
      for i := 0 to FStrings.Count - 1 do
      begin
        p := Pos('{', FStrings[i]);
        if (p <> 0) then
        begin
          Title := Trim(Copy(FStrings[i], 1, p - 1));
          if Title <> '' then
          begin { Otherwise bad format }
            ListItem := MainForm.ListView.Items.Add;
            Listitem.Caption := Trim(Copy(FStrings[i], 1, p - 1));
          end;
        end;
      end;
    end;
    MainForm.ListView.Items.EndUpdate;
    if sel = 1 then MainForm.ListView.Selected := MainForm.ListView.Items[0];
  finally
    FStrings.Free;
  end;
end;

{ ****************************** Display ************************************ }

procedure Trace1(const str: string);
begin
  if TraceLevel >= 1 then
    TraceForm.MainTrace.Lines.Add('. ' + str);
end;

procedure Trace2(const str: string);
begin
  if TraceLevel >= 2 then
    TraceForm.MainTrace.Lines.Add('. . ' + str);
end;

procedure TMainForm.HandleThreadCompletion(var Message: TMessage);
var
  oldscale: double;
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
  Image.Cursor := crDefault;

  if assigned(FViewImage) then begin
    oldscale := FViewImage.Width / Image.Width;
    FViewImage.Free;
  end
  else oldscale := FViewScale;

  FViewImage := Renderer.GetTransparentImage;

  if FViewImage <> nil then begin
    FViewScale := FViewImage.Width / Image.Width;

    FViewPos.X := FViewScale/oldscale * (FViewPos.X - FViewOldPos.X);
    FViewPos.Y := FViewScale/oldscale * (FViewPos.Y - FViewOldPos.Y);

    DrawImageView;
{
    case FMouseMoveState of
      msZoomWindowMove: FMouseMoveState := msZoomWindow;
      msZoomOutWindowMove: FMouseMoveState := msZoomOutWindow;
//    msDragMove: FMouseMoveState := msDrag;
      msRotateMove: FMouseMoveState := msRotate;
    end;
}
    if FMouseMoveState in [msZoomWindowMove, msZoomOutWindowMove, msRotateMove] then
      DrawSelection := false;

    Trace1(TimeToStr(Now) + ' : Render complete');
    Renderer.ShowSmallStats;
  end
  else Trace2('WARNING: No image rendered!');

  Renderer.WaitFor;
  Trace2('Destroying RenderThread #' + IntToStr(Renderer.ThreadID));
  Renderer.Free;
  Renderer := nil;
  Trace1('');
end;

procedure TMainForm.HandleThreadTermination(var Message: TMessage);
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
  Image.Cursor := crDefault;
  Trace2('  Render aborted');

  Trace2('Destroying RenderThread #' + IntToStr(Renderer.ThreadID));
  Renderer.Free;
  Renderer := nil;
  Trace1('');
end;

procedure TMainForm.DrawFlame;
var
  GlobalMemoryInfo: TMemoryStatus; // holds the global memory status information
  RenderCP: TControlPoint;
  Mem, ApproxMem: cardinal;
begin
  RedrawTimer.Enabled := False;
  if Assigned(Renderer) then begin
    assert(Renderer.Suspended = false);

    Trace2('Killing previous RenderThread #' + inttostr(Renderer.ThreadID));
    Renderer.Terminate;
    Renderer.WaitFor;
    Trace2('Destroying RenderThread #' + IntToStr(Renderer.ThreadID));

    Renderer.Free;
    Renderer := nil;
  end;

  if not Assigned(Renderer) then
  begin
    if EditForm.Visible and ((MainCP.Width / MainCP.Height) <> (EditForm.cp.Width / EditForm.cp.Height))
      then EditForm.UpdateDisplay(true); // preview only?
    if AdjustForm.Visible then AdjustForm.UpdateDisplay(true); // preview only!

    RenderCP := MainCP.Clone;
    RenderCp.AdjustScale(Image.width, Image.height);

    // following needed ?
//    cp.Zoom := Zoom;
//    cp.center[0] := center[0];
//    cp.center[1] := center[1];

    RenderCP.sample_density := defSampleDensity;
    // oversample and filter are just slowing us down here...
    RenderCP.spatial_oversample := 1; // defOversample;
    RenderCP.spatial_filter_radius := 0.001; {?} //defFilterRadius;
    RenderCP.Transparency := true; // always generate transparency here

    GlobalMemoryInfo.dwLength := SizeOf(GlobalMemoryInfo);
    GlobalMemoryStatus(GlobalMemoryInfo);
    Mem := GlobalMemoryInfo.dwAvailPhys;

//    if Output.Lines.Count >= 1000 then Output.Lines.Clear;
    Trace1('--- Previewing "' + RenderCP.name + '" ---');
    Trace1(Format('  Available memory: %f Mb', [Mem / (1024*1024)]));
    ApproxMem := int64(RenderCp.Width) * int64(RenderCp.Height) {* sqr(Oversample)}
                 * (SizeOfBucket[InternalBitsPerSample] + 4 + 4); // +4 for temp image(s)...?
    assert(MainPreviewScale <> 0);
    if ApproxMem * sqr(MainPreviewScale) < Mem then begin
      if ExtendMainPreview then begin
        RenderCP.sample_density := RenderCP.sample_density / sqr(MainPreviewScale);
        RenderCP.Width := round(RenderCp.Width * MainPreviewScale);
        RenderCP.Height := round(RenderCp.Height * MainPreviewScale);
      end;
    end
    else Trace1('WARNING: Not enough memory for extended preview!');
    if ApproxMem > Mem then
      Trace1('OUTRAGEOUS: Not enough memory even for normal preview! :-(');
    Trace1(Format('  Size: %dx%d, Quality: %f',
                  [RenderCP.Width, RenderCP.Height, RenderCP.sample_density]));
    FViewOldPos.x := FViewPos.x;
    FViewOldPos.y := FViewPos.y;
    StartTime := Now;
    try
      Renderer := TRenderThread.Create;
      Renderer.TargetHandle := MainForm.Handle;
      if TraceLevel > 0 then Renderer.Output := TraceForm.MainTrace.Lines;
      Renderer.OnProgress := OnProgress;
      Renderer.SetCP(RenderCP);

      Trace2('Starting RenderThread #' + inttostr(Renderer.ThreadID));
      Renderer.Resume;

      Image.Cursor := crAppStart;
    except
      Trace1('ERROR: Cannot start renderer!');
    end;
    RenderCP.Free;
  end;
end;

{ ************************** IFS and triangle stuff ************************* }

function FlameToString(Title: string): string;
{ Creates a string containing the formated flame parameter set }
var
  I: integer;
  sl, Strings: TStringList;
begin
  Strings := TStringList.Create;
  sl := TStringList.Create;
  try
    Strings.Add(CleanEntry(Title) + ' {');
    MainCp.SaveToStringList(sl);
    Strings.Add(sl.text);
    Strings.Add('palette:');
    for i := 0 to 255 do
    begin
      Strings.Add(IntToStr(MainCp.cmap[i][0]) + ' ' +
        IntToStr(MainCp.cmap[i][1]) + ' ' +
        IntToStr(MainCp.cmap[i][2]))
    end;
    Strings.Add('}');
    Result := Strings.Text;
  finally
    sl.Free;
    Strings.Free;
  end;
end;

procedure TMainForm.RandomBatch;
{ Write a series of random ifs to a file }
var
  i: integer;
  F: TextFile;
  b, RandFile: string;
begin
  b := IntToStr(BatchSize);
  inc(MainSeed);
  RandSeed := MainSeed;
  try
    AssignFile(F, AppPath + 'apophysis.rand');
    OpenFile := AppPath + 'apophysis.rand';
    ReWrite(F);
    WriteLn(F, '<random_batch>');
    for i := 0 to BatchSize - 1 do
    begin
      inc(RandomIndex);
      Statusbar.SimpleText := 'Generating ' + IntToStr(i + 1) + ' of ' + b;
      RandSeed := MainSeed;
      if randGradient = 0 then cmap_index := random(NRCMAPS);
      inc(MainSeed);
      RandSeed := MainSeed;
      RandomizeCP(MainCp);
      MainCp.CalcBoundbox;

(*     Title := RandomPrefix + RandomDate + '-' +
        IntToStr(RandomIndex);
  *)
      MainCp.name := RandomPrefix + RandomDate + '-' +
        IntToStr(RandomIndex);
      Write(F, FlameToXML(MainCp, False));
//      Write(F, FlameToString(Title));
//      WriteLn(F, ' ');
    end;
    Write(F, '</random_batch>');
    CloseFile(F);
  except
    on EInOutError do Application.MessageBox('Error creating batch', PChar(APP_NAME), 16);
  end;
  RandFile := AppPath + 'apophysis.rand';
  MainCp.name := '';
end;

{ ******************************** Menu ************************************ }

procedure ListXML(FileName: string; sel: integer);
{ List .flame file }
var
  i, p: integer;
  Title: string;
  ListItem: TListItem;
  FStrings: TStringList;
begin
  FStrings := TStringList.Create;
  FStrings.LoadFromFile(FileName);
  try
    MainForm.ListView.Items.BeginUpdate;
    MainForm.ListView.Items.Clear;
    if (Pos('<flame ', Lowercase(FStrings.Text)) <> 0) then
    begin
      for i := 0 to FStrings.Count - 1 do
      begin
        p := Pos('<flame ', LowerCase(FStrings[i]));
        if (p <> 0) then
        begin
          MainForm.ListXMLScanner.LoadFromBuffer(PCHAR(FSTrings[i]));
          MainForm.ListXMLScanner.Execute;

          if Trim(pname) = '' then
            Title := '*untitled ' + ptime
          else
            Title := Trim(pname);
          if Title <> '' then
          begin { Otherwise bad format }
            ListItem := MainForm.ListView.Items.Add;
            Listitem.Caption := Title;
          end;
        end;
      end;
    end;
    MainForm.ListView.Items.EndUpdate;
    case sel of
      0: MainForm.ListView.Selected := MainForm.ListView.Items[MainForm.ListView.Items.Count - 1];
      1: MainForm.ListView.Selected := MainForm.ListView.Items[0];
    end;
  finally
    FStrings.Free;
  end;
end;

procedure TMainForm.mnuOpenClick(Sender: TObject);
begin
  ScriptEditor.Stopped := True;
  OpenDialog.Filter := 'Flame files (*.flame;*.flam3)|*.flame;*.flam3|Apophysis 1.0 parameters (*.fla;*.apo)|*.fla;*.apo|Fractint IFS Files (*.ifs)|*.ifs';
  OpenDialog.InitialDir := ParamFolder;
  OpenDialog.FileName := '';
  if OpenDialog.Execute then
  begin
    Maincp.name := '';
    ParamFolder := ExtractFilePath(OpenDialog.FileName);
    ListView.ReadOnly := False;
    mnuListRename.Enabled := True;
    mnuItemDelete.Enabled := True;
    OpenFile := OpenDialog.FileName;
    MainForm.Caption := AppVersionString + ' - ' + OpenFile; // --Z--
    OpenFileType := ftXML;
    if UpperCase(ExtractFileExt(OpenDialog.FileName)) = '.IFS' then
    begin
      OpenFileType := ftIfs;
      Variation := vLinear;
      VarMenus[0].Checked := True;
    end;
    if (UpperCase(ExtractFileExt(OpenDialog.FileName)) = '.FLA') or
      (UpperCase(ExtractFileExt(OpenDialog.FileName)) = '.APO') then
      OpenFileType := ftFla;
    if OpenFileType = ftXML then
      ListXML(OpenDialog.FileName, 1)
    else
      ListIFS(OpenDialog.FileName, 1)
  end;
end;

procedure TMainForm.mnuNextClick(Sender: TObject);
begin
  with ListView do
    if Items.Count <> 0 then
      Selected := Items[(Selected.Index + 1) mod Items.Count];
end;

procedure TMainForm.mnuPreviousClick(Sender: TObject);
var
  i: integer;
begin
  with ListView do
    if Items.Count <> 0 then
    begin
      i := Selected.Index - 1;
      if i < 0 then i := Items.Count - 1;
      Selected := Items[i];
    end;
end;

procedure TMainForm.mnuListRenameClick(Sender: TObject);
begin
  if ListView.SelCount <> 0 then
    ListView.Items[ListView.Selected.Index].EditCaption;
end;

procedure TMainForm.mnuCopyUPRClick(Sender: TObject);
begin
  Clipboard.SetTextBuf(PChar(UPRString(MainCp, Maincp.name)));
end;

procedure TMainForm.mnuItemDeleteClick(Sender: TObject);
var
  c: boolean;
begin
  if ListView.SelCount <> 0 then
  begin
    if ConfirmDelete then
      c := Application.MessageBox(
        PChar('Are you sure you want to permanently delete' + ' "'
        + ListView.Selected.Caption + '"'), 'Apophysis', 36) = IDYES
    else
      c := True;
    if c then
      if ListView.Focused and (ListView.SelCount <> 0) then
      begin
        Application.ProcessMessages;
        if OpenFileType = ftXML then
          DeleteXMLEntry(ListView.Selected.Caption, OpenFile)
        else
          DeleteEntry(ListView.Selected.Caption, OpenFile);
        ListView.Items.Delete(ListView.Selected.Index);
        Application.ProcessMessages;
        ListView.Selected := ListView.ItemFocused;
      end;
  end;
//end;
end;

procedure TMainForm.mnuOptionsClick(Sender: TObject);
begin
  OptionsForm.ShowModal;
  // --Z--
  StopThread;
  RedrawTimer.Enabled := True;
  tbQualityBox.Text := FloatToStr(defSampleDensity);
  tbShowAlpha.Down := ShowTransparency;
  DrawImageView;
  UpdateWindows;
end;

procedure TMainForm.mnuRefreshClick(Sender: TObject);
begin
  RedrawTimer.enabled := true;
end;

procedure TMainForm.mnuNormalWeightsClick(Sender: TObject);
begin
  StopThread;
  UpdateUndo;
// TODO: ...something
//  ComputeWeights(MainCp, MainTriangles, transforms);
  RedrawTimer.Enabled := True;
  UpdateWindows;
end;

procedure TMainForm.mnuRWeightsClick(Sender: TObject);
begin
  StopThread;
  UpdateUndo;
  inc(MainSeed);
  RandSeed := MainSeed;
  MainCp.RandomizeWeights;
  RedrawTimer.Enabled := True;
  UpdateWindows;
end;

procedure TMainForm.mnuRandomBatchClick(Sender: TObject);
begin
  ScriptEditor.Stopped := True;
  inc(MainSeed);
  RandSeed := MainSeed;
  RandomBatch;
  OpenFile := AppPath + 'apophysis.rand';
  OpenFileType := ftXML;
  MainForm.Caption := AppVersionString + ' - Random Batch';
  ListXML(OpenFile, 1);
  ListView.SetFocus;
  if batchsize = 1 then DrawFlame;
end;

function GradientString(c: TColorMap): string;
var
  strings: TStringList;
  i, j, cl: integer;
begin
  strings := TStringList.Create;
  for i := 0 to 255 do
  begin
    j := round(i * (399 / 255));
    cl := (c[i][2] shl 16) + (c[i][1] shl 8) + (c[i][0]);
    strings.Add(' index=' + IntToStr(j) + ' color=' + intToStr(cl));
  end;
  Result := Strings.Text;
  strings.Free;
end;

function TMainForm.UPRString(cp1: TControlPoint; Entry: string): string;
{ Returns a string containing an Ultra Fractal parameter set for copying
  or saving to file }
var
  IterDensity, m, i, j: integer;
  scale, a, b, c, d, e, f, p, v: double;
  GradStrings, Strings: TStringList;
  rept, cby, smap, sol: string;
  uprcenter: array[0..1] of double; // camera center
  Backcolor: longint;
  xf_str: string;
begin
  cp1.Prepare;
  uprcenter[0] := cp1.Center[0];
  uprcenter[1] := cp1.Center[1];
  cp1.Width := UPRWidth;
  cp1.Height := UPRHeight;
  scale := power(2, cp1.zoom) * CalcUPRMagn(cp1);
  cp1.center[0] := uprCenter[0];
  cp1.center[1] := uprCenter[1];
  smap := 'no';
  sol := 'no';
  rept := '';
  cby := 'Hit Frequency';
  Strings := TStringList.Create;
  GradStrings := TStringList.Create;
  try
    Strings.Add(CleanEntry(Entry) + ' {');
    Strings.Add('fractal:');
    Strings.Add('  title="' + CleanUPRTitle(Entry) +
      '" width=' + IntToStr(UPRWidth) + ' height=' + IntToStr(UPRHeight) + ' layers=1');
    Strings.Add('layer:');
    Strings.Add('  method=linear caption="Background" opacity=100 mergemode=normal');
    Strings.Add('mapping:');
    Strings.Add('  center=' + floatToStr(cp1.center[0]) + '/' + floatToStr(-cp1.center[1]) +
      ' magn=' + FloatToStr(scale));
    Strings.Add('formula:');
    Strings.Add('  maxiter=1 filename="' + UPRFormulaFile + '" entry="' + UPRFormulaIdent + '"');
    Strings.Add('inside:');
    Strings.Add('  transfer=none');
    Strings.Add('outside:');
    Strings.Add('  transfer=linear repeat=no ' + 'filename="' + UPRColoringFile + '" entry="'
      + UPRColoringIdent + '"');
    if (UPRAdjustDensity) and (scale > 1) then
      IterDensity := Trunc(UPRSampleDensity * scale * scale)
    else
      IterDensity := UPRSampleDensity;
    Strings.Add('  p_iter_density=' + IntToStr(IterDensity) + ' p_spat_filt_rad=' +
      Format('%.3g', [UPRFilterRadius]) + ' p_oversample=' + IntToStr(UPROversample));
    backcolor := 255 shl 24 + cp1.background[0] shl 16 + cp1.background[1] shl 8 + cp1.background[2];
    Strings.Add('  p_bk_color=' + IntToStr(Backcolor) + ' p_contrast=1' +
      ' p_brightness=' + FloatToStr(cp1.Brightness) + ' p_gamma=' + FloatToStr(cp1.Gamma));
    Strings.Add('  p_white_level=200 p_xforms=' + inttostr(Transforms));
    for m := 0 to Transforms do
    begin
      a := cp1.xform[m].c[0][0];
      c := cp1.xform[m].c[0][1];
      b := cp1.xform[m].c[1][0];
      d := cp1.xform[m].c[1][1];
      e := cp1.xform[m].c[2][0];
      f := cp1.xform[m].c[2][1];
      p := cp1.xform[m].Density;
      if m < Transforms then xf_str := 'p_xf' + inttostr(m)
      else begin
        if cp1.HasFinalXForm = false then break;
        xf_str := 'p_finalxf';
      end;
      Strings.Add('  ' + xf_str + '_p=' + Format('%.6g ', [p]));
      Strings.Add('  ' + xf_str + '_c=' + floatTostr(cp1.xform[m].color));
      Strings.Add('  ' + xf_str + '_sym=' + floatTostr(cp1.xform[m].symmetry));
      Strings.Add('  ' + xf_str + '_cfa=' + Format('%.6g ', [a]) +
        xf_str + '_cfb=' + Format('%.6g ', [b]) +
        xf_str + '_cfc=' + Format('%.6g ', [c]) +
        xf_str + '_cfd=' + Format('%.6g ', [d]));
      Strings.Add('  ' + xf_str + '_cfe=' + Format('%.6g ', [e]) +
        ' ' + xf_str + '_cff=' + Format('%.6g ', [f]));
      for i := 0 to NRVAR-1 do
        if cp1.xform[m].vars[i] <> 0 then begin
          Strings.Add('  ' + xf_str + '_var_' + VarNames(i) + '=' +
            floatToStr(cp1.xform[m].vars[i]));
        for j:= 0 to GetNrVariableNames - 1 do begin
{$ifndef VAR_STR}
          cp1.xform[m].GetVariable(GetVariableNameAt(j), v);
          Strings.Add('  ' + xf_str + '_par_' + GetVariableNameAt(j) + '=' + floatToStr(v));
{$else}
          Strings.Add('  ' + xf_str + '_par_' +
                      GetVariableNameAt(j) + '=' + cp1.xform[m].GetVariableStr(GetVariableNameAt(j)));
{$endif}
        end;
      end;
    end;
    Strings.Add('gradient:');
    Strings.Add(GradientString(cp1.cmap));
    Strings.Add('}');
    UPRString := Strings.Text;
  finally
    GradStrings.Free;
    Strings.Free;
  end;
end;

procedure TMainForm.mnuRandomClick(Sender: TObject);
begin
  StopThread;
  UpdateUndo;
  inc(MainSeed);
  RandomizeCP(MainCp);
  inc(RandomIndex);
  MainCp.name := RandomPrefix + RandomDate + '-' +
    IntToStr(RandomIndex);
  Transforms := MainCp.TrianglesFromCP(MainTriangles);

  if AdjustForm.visible then AdjustForm.UpdateDisplay;

  StatusBar.Panels[2].text := maincp.name;
  ResetLocation;
  RedrawTimer.Enabled := true;
  UpdateWindows;
end;

procedure TMainForm.mnuEqualizeClick(Sender: TObject);
begin
  StopThread;
  UpdateUndo;
  MainCP.EqualizeWeights;
  RedrawTimer.Enabled := True;
  UpdateWindows;
end;

procedure TMainForm.mnuEditorClick(Sender: TObject);
begin
  EditForm.Show;
end;

procedure TMainForm.mnuExitClick(Sender: TObject);
begin
  ScriptEditor.Stopped := True;
  Close;
end;

procedure TMainForm.mnuSaveUPRClick(Sender: TObject);
{ Write a UPR to a file }
begin
  SaveForm.Caption := 'Export UPR';
  SaveForm.Filename := UPRPath;
  SaveForm.Title := maincp.name;
  if SaveForm.ShowModal = mrOK then
  begin
    UPRPath := SaveForm.FileName;
    SaveUPR(SaveForm.Title, SaveForm.Filename);
  end;
end;

procedure TMainForm.mnuSaveAsClick(Sender: TObject);
{ Save parameters to a file }
begin
  SaveForm.Caption := 'Save Parameters';
  SaveForm.Filename := SavePath;
  SaveForm.Title := maincp.name;
  SaveForm.txtTitle.Enabled := True;
  if SaveForm.ShowModal = mrOK then
  begin
    maincp.name := SaveForm.Title;
    SavePath := SaveForm.Filename;
    if ExtractFileExt(SavePath) = '' then SavePath := SavePath + '.flame';
    if Lowercase(ExtractFileExt(SaveForm.Filename)) = '.ifs' then
      SaveIFS(maincp, maincp.name, SavePath)
    else if (LowerCase(ExtractFileExt(SaveForm.Filename)) = '.fla') or
      (LowerCase(ExtractFileExt(SaveForm.Filename)) = '.apo') then
      SaveFlame(maincp, maincp.name, SavePath)
    else
      SaveXMLFlame(maincp, maincp.name, SavePath);
    StatusBar.Panels[2].Text := maincp.name;
    if (SavePath = OpenFile) then
    begin
      if OpenFileType = ftXML then
        ListXML(OpenDialog.FileName, 0)
      else
        ListIFS(OpenDialog.FileName, 0)
    end;


  end;
end;

procedure TMainForm.mnuSaveAllAsClick(Sender: TObject);
{ Save all parameters to a file }
var
  i, current: integer;
begin
  SaveForm.Caption := 'Save All Parameters';
  SaveForm.Filename := SavePath;
  SaveForm.Title := '';
  SaveForm.txtTitle.Enabled := false;
  if SaveForm.ShowModal = mrOK then
  begin
    SavePath := SaveForm.Filename;
    if ExtractFileExt(SavePath) = '' then SavePath := SavePath + '.flame';
    if ExtractFileExt(SavePath) <> '.flame' then
    begin
      Application.MessageBox('Bad filename extension.', 'Warning',
                             MB_OK or MB_ICONEXCLAMATION);
      exit;
    end;
    current := ListView.ItemIndex;
    for i := 0 to ListView.Items.Count-1 do
    begin
      LoadXMLFlame(OpenFile, ListView.Items.Item[i].Caption);
      SaveXMLFlame(maincp, maincp.name, SavePath);
    end;
    ListView.ItemIndex := current;
    LoadXMLFlame(OpenFile, ListView.Selected.caption);
  end;
end;

function GradTitle(str: string): string;
var
  p: integer;
begin
  p := pos('{', str);
  GradTitle := Trim(copy(str, 1, p - 1));
end;

procedure TMainForm.DisplayHint(Sender: TObject);
var
  T: TComponent;
begin
  T := MainForm.FindComponent('StatusBar');
  if T <> nil then
    if Application.Hint = '' then
    begin
      TStatusBar(T).SimpleText := '';
      TStatusBar(T).SimplePanel := False;
      TStatusBar(T).Refresh;
    end
    else
      TStatusBar(T).SimpleText := Application.Hint;
end;

procedure TMainForm.MainFileClick(Sender: TObject);
begin
  ScriptEditor.Stopped := True;
end;

procedure TMainForm.MainViewClick(Sender: TObject);
begin
  ScriptEditor.Stopped := True;
end;

procedure TMainForm.MainToolsClick(Sender: TObject);
begin
  ScriptEditor.Stopped := True;
end;

procedure TMainForm.MainHelpClick(Sender: TObject);
begin
end;

{ ********************************* Form ************************************ }


procedure TMainForm.FavoriteClick(Sender: TObject);
var
  i: integer;
  s: string;
begin
  i := TMenuItem(Sender).Tag;
  Script := favorites[i];
  ScriptEditor.Editor.Lines.LoadFromFile(Script);
  s := ExtractFileName(Script);
  s := Copy(s, 0, length(s) - 4);
  mnuRun.Caption := 'Run "' + s + '"';
  btnRun.Hint := 'Run Script (F8)|Runs the ' + s + ' script.';
  ScriptEditor.Caption := s;
  ScriptEditor.RunScript;
end;

procedure TMainForm.GetScripts;
var
  NewItem: TMenuItem;
  i: integer;
  s: string;
begin
  if not FileExists(AppPath + 'favorites') then exit;
  Favorites.LoadFromFile(AppPath + 'favorites');
  if Trim(Favorites.Text) = '' then exit;
  if Favorites.count <> 0 then
  begin
    NewItem := TMenuItem.Create(self);
    NewItem.Caption := '-';
    mnuScript.Add(NewItem);
    for i := 0 to Favorites.Count - 1 do
    begin
      if FileExists(Favorites[i]) then
      begin
        NewItem := TMenuItem.Create(Self);
        if i < 12 then
          NewItem.ShortCut := TextToShortCut('Ctrl+F' + IntToStr(i + 1));
        NewItem.Tag := i;
        s := ExtractFileName(Favorites[i]);
        s := Copy(s, 0, length(s) - 4);
        NewItem.Caption := s;
        NewItem.Hint := 'Loads and runs the ' + s + ' script.';
        NewItem.OnClick := FavoriteClick;
        OnClick := FavoriteClick;
        mnuScript.Add(NewItem);
      end;
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  dte: string;
begin
  Screen.Cursors[crEditArrow]  := LoadCursor(HInstance, 'ARROW_WHITE');
  Screen.Cursors[crEditMove]   := LoadCursor(HInstance, 'MOVE_WB');
  Screen.Cursors[crEditRotate] := LoadCursor(HInstance, 'ROTATE_WB');
  Screen.Cursors[crEditScale]  := LoadCursor(HInstance, 'SCALE_WB');

(*
{$IFDEF DEBUG}
  // Enable raw mode (default mode uses stack frames which aren't always generated by the compiler)
  Include(JclStackTrackingOptions, stRawMode);
  // Disable stack tracking in dynamically loaded modules (it makes stack tracking code a bit faster)
  Include(JclStackTrackingOptions, stStaticModuleList);

  // Initialize Exception tracking
  JclStartExceptionTracking;
  Application.OnException := AppException;
{$ENDIF}
*)

  FMouseMoveState := msDrag;
  LimitVibrancy := True;
  Favorites := TStringList.Create;
  GetScripts;
  Randomize;
  MainSeed := Random(1234567890);
  maincp := TControlPoint.Create;
  ParseCp := TControlPoint.create;
  mainCPindex := -1;
  OpenFileType := ftXML;
  Application.OnHint := DisplayHint;
  Application.OnHelp := ApplicationOnHelp;
  AppPath := ExtractFilePath(Application.ExeName);
  CanDrawOnResize := False;

  ReadSettings;

  Dte := FormatDateTime('yymmdd', Now);
  if Dte <> RandomDate then
    RandomIndex := 0;
  RandomDate := Dte;
  mnuExit.ShortCut := TextToShortCut('Alt+F4');

  //if VariationOptions = 0 then VariationOptions := 16383; // it shouldn't hapen but just in case;
  //UnpackVariations(VariationOptions);

  FillVariantMenu;

  tbQualityBox.Text := FloatToStr(defSampleDensity);
  tbShowAlpha.Down := ShowTransparency;
  DrawSelection := true;
  FViewScale := 1; // prevent divide by zero (?)
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  Registry: TRegistry;
  i: integer;
begin
  { Read position from registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('\Software\' + APP_NAME + '\Forms\Main', False) then
    begin
      if Registry.ValueExists('Left') then
        MainForm.Left := Registry.ReadInteger('Left');
      if Registry.ValueExists('Top') then
        MainForm.Top := Registry.ReadInteger('Top');
      if Registry.ValueExists('Width') then
        MainForm.Width := Registry.ReadInteger('Width');
      if Registry.ValueExists('Height') then
        MainForm.Height := Registry.ReadInteger('Height');
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
  { Synchronize menus etc..}
  // should be defaults....
  UndoIndex := 0;
  UndoMax := 0;
  ListView.RowSelect := True;
  inc(MainSeed);
  RandSeed := MainSeed;
  Variation := vRandom;
  Maincp.brightness := defBrightness;
  maincp.gamma := defGamma;
  maincp.vibrancy := defVibrancy;
  maincp.sample_density := defSampleDensity;
  maincp.spatial_oversample := defOversample;
  maincp.spatial_filter_radius := defFilterRadius;
  maincp.gammaThreshRelative := defGammaThreshold;
  inc(MainSeed);
  RandSeed := MainSeed;

// somehow this doesn't work:
//  Image.Width := BackPanel.Width - 2;
//  Image.Height := BackPanel.Height - 2;

// so we'll do it 'bad' way ;-)
  Image.Align := alNone;

  if FileExists(AppPath + 'default.map') then
  begin
    DefaultPalette := GradientBrowser.LoadFractintMap(AppPath + 'default.map');
    maincp.cmap := DefaultPalette;
  end
  else
  begin
    cmap_index := random(NRCMAPS);
    GetCMap(cmap_index, 1, maincp.cmap);
    DefaultPalette := maincp.cmap;
  end;
  if FileExists(AppPath + 'apophysis.rand') then
    DeleteFile(AppPath + 'apophysis.rand');

  // get filename from command line argument  
  if ParamCount > 0 then openFile := ParamStr(1)
  else openFile := defFlameFile;

  if (openFile = '') or (not FileExists(openFile)) then
  begin
    MainCp.Width := Image.Width;
    MainCp.Height := Image.Height;
    RandomBatch;
    MainForm.Caption := AppVersionString + ' - Random Batch';
    OpenFile := AppPath + 'apophysis.rand';
    ListXML(OpenFile, 1);
    OpenFileType := ftXML;
    if batchsize = 1 then DrawFlame;
  end
  else
  begin
    if (LowerCase(ExtractFileExt(OpenFile)) = '.apo') or (LowerCase(ExtractFileExt(OpenFile)) = '.fla') then
    begin
      ListFlames(OpenFile, 1);
      OpenFileType := ftFla;
    end
    else
    begin
      ListXML(OpenFile, 1);
      OpenFileType := ftXML;
      MainForm.ListView.Selected := MainForm.ListView.Items[0];
    end;
    MainForm.Caption := AppVersionString + ' - ' + defFlameFile;
  end;
  ListView.SetFocus;
  CanDrawOnResize := True;
  Statusbar.Panels[2].Text := maincp.name;
{
  gradientForm.cmbPalette.Items.clear;
  for i := 0 to NRCMAPS -1 do
    gradientForm.cmbPalette.Items.Add(cMapnames[i]);
  GradientForm.cmbPalette.ItemIndex := 0;
}
  AdjustForm.cmbPalette.Items.clear;
  for i := 0 to NRCMAPS -1 do
    AdjustForm.cmbPalette.Items.Add(cMapnames[i]);
  AdjustForm.cmbPalette.ItemIndex := 0;
//  AdjustForm.cmbPalette.Items.clear;

  ExportDialog.cmbDepth.ItemIndex := 2;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Registry: TRegistry;
begin
  if ConfirmExit and (UndoIndex <> 0) then
    if Application.MessageBox('Do you really want to exit?' + #13#10 +
       'All unsaved data will be lost!', 'Apophysis', MB_ICONWARNING or MB_YESNO) <> IDYES then
    begin
      Action := caNone;
      exit;
    end;

  ScriptEditor.Stopped := True;
  HtmlHelp(0, nil, HH_CLOSE_ALL, 0);
  { To capture secondary window positions }
  if EditForm.visible then EditForm.Close;
  if AdjustForm.visible then AdjustForm.close;
  if GradientBrowser.visible then GradientBrowser.close;
  if MutateForm.visible then MutateForm.Close;
//  if GradientForm.visible then GradientForm.Close;
  if ScriptEditor.visible then ScriptEditor.Close;
  { Stop the render thread }
  if RenderForm.Visible then RenderForm.Close;
  if assigned(Renderer) then Renderer.Terminate;
  if assigned(Renderer) then Renderer.WaitFor;
  { Write position to registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('\Software\' + APP_NAME + '\Forms\Main', True) then
    begin
      if MainForm.WindowState <> wsMaximized then begin
        Registry.WriteInteger('Top', MainForm.Top);
        Registry.WriteInteger('Left', MainForm.Left);
        Registry.WriteInteger('Width', MainForm.Width);
        Registry.WriteInteger('Height', MainForm.Height);
      end;
    end;
  finally
    Registry.Free;
  end;
  Application.ProcessMessages;
  CanDrawOnResize := False;
  if FileExists('apophysis.rand') then DeleteFile('apophysis.rand');
  if FileExists('apophysis.undo') then DeleteFile('apophysis.undo');
  SaveSettings;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if assigned(Renderer) then Renderer.Terminate;
  if assigned(Renderer) then Renderer.WaitFor;
  if assigned(Renderer) then Renderer.Free;
  if assigned(FViewImage) then FViewImage.Free;
  MainCP.free;
  ParseCp.free;
  Favorites.Free;
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
var
  scale: double;
begin
  if Key = #27 then begin
    case FMouseMoveState of
      msZoomWindowMove:
        FMouseMoveState := msZoomWindow;
      msZoomOutWindowMove:
        FMouseMoveState := msZoomOutWindow;
      msDragMove:
        begin
          FMouseMoveState := msDrag;

          scale := FViewScale * Image.Width / FViewImage.Width;
          FViewPos.X := FViewPos.X - (FClickRect.Right - FClickRect.Left) / scale;
          FViewPos.Y := FViewPos.Y - (FClickRect.Bottom - FClickRect.Top) / scale;
        end;
      msRotateMove:
        FMouseMoveState := msRotate;
    end;
    DrawImageView;
  end;
  ScriptEditor.Stopped := True;
end;

{ ****************************** Misc controls ****************************** }

procedure TMainForm.BackPanelResize(Sender: TObject);
begin
  StopThread;
  if CanDrawOnResize then
    reDrawTimer.Enabled := True;

  ResizeImage;  
  DrawImageView;
end;

procedure TMainForm.LoadXMLFlame(filename, name: string);
var
  i, p: integer;
  FileStrings: TStringList;
  ParamStrings: TStringList;
  Tokens: TStringList;
  time: integer;
begin
  time := -1;
  FileStrings := TStringList.Create;
  ParamStrings := TStringList.Create;

  if pos('*untitled', name) <> 0 then
  begin
    Tokens := TStringList.Create;
    GetTokens(name, tokens);
    time := StrToInt(tokens[1]);
    Tokens.free;
  end;
  try
    FileStrings.LoadFromFile(filename);
    for i := 0 to FileStrings.Count - 1 do
    begin
      pname := '';
      ptime := '';
      p := Pos('<flame ', LowerCase(FileStrings[i]));
      if (p <> 0) then
      begin
        MainForm.ListXMLScanner.LoadFromBuffer(PCHAR(FileStrings[i]));
        MainForm.ListXMLScanner.Execute;
        if pname <> '' then
        begin
          if (Trim(pname) = Trim(name)) then
          begin
            ParamStrings.Add(FileStrings[i]);
            Break;
          end;
        end
        else
        begin
          if StrToInt(ptime) = time then
          begin
            ParamStrings.Add(FileStrings[i]);
            Break;
          end;
        end;
      end;
    end;
    repeat
      inc(i);
      ParamStrings.Add(FileStrings[i]);
    until pos('</flame>', Lowercase(FileStrings[i])) <> 0;

    ScriptEditor.Stopped := True;
    StopThread;
    ParseXML(MainCp, PCHAR(PAramStrings.Text));

    mnuSaveUndo.Enabled := false;
    mnuUndo.Enabled := False;
    mnuPopUndo.Enabled := False;
    mnuRedo.enabled := False;
    mnuPopRedo.enabled := False;
    EditForm.mnuUndo.Enabled := False;
    EditForm.mnuRedo.enabled := False;
    EditForm.tbUndo.enabled := false;
    EditForm.tbRedo.enabled := false;
    AdjustForm.btnUndo.enabled := false;
    AdjustForm.btnRedo.enabled := false;
    btnUndo.Enabled := false;
    btnRedo.enabled := false;

    Transforms := MainCp.TrianglesFromCP(MainTriangles);

    UndoIndex := 0;
    UndoMax := 0;
    if fileExists(AppPath + 'apophysis.undo') then DeleteFile(AppPath + 'apophysis.undo');
    Statusbar.Panels[2].Text := Maincp.name;
    RedrawTimer.Enabled := True;
    Application.ProcessMessages;

    EditForm.SelectedTriangle := 0; // (?)

    UpdateWindows;
  finally
    FileStrings.free;
    ParamStrings.free;
  end;
end;

procedure TMainForm.LoadXMLFlame(filename: string; index: integer);
var
  i, p: integer;
  FileStrings: TStringList;
  ParamStrings: TStringList;
  Tokens: TStringList;
  flameindex: integer;
begin
  FileStrings := TStringList.Create;
  ParamStrings := TStringList.Create;

  try
    FileStrings.LoadFromFile(filename);
    flameindex := 0;
    for i := 0 to FileStrings.Count - 1 do
    begin
      pname := '';
      ptime := '';
      p := Pos('<flame ', LowerCase(FileStrings[i]));
      if (p <> 0) then
      begin
        if (flameIndex <> index) then begin
          inc(flameIndex);
          continue;
        end;
        MainForm.ListXMLScanner.LoadFromBuffer(PCHAR(FileStrings[i]));
        MainForm.ListXMLScanner.Execute;
        ParamStrings.Add(FileStrings[i]);
        Break;
      end;
    end;
    repeat
      inc(i);
      ParamStrings.Add(FileStrings[i]);
    until pos('</flame>', Lowercase(FileStrings[i])) <> 0;

    ScriptEditor.Stopped := True;
    StopThread;
    ParseXML(MainCp, PCHAR(PAramStrings.Text));

    mnuSaveUndo.Enabled := false;
    mnuUndo.Enabled := False;
    mnuPopUndo.Enabled := False;
    mnuRedo.enabled := False;
    mnuPopRedo.enabled := False;
    EditForm.mnuUndo.Enabled := False;
    EditForm.mnuRedo.enabled := False;
    EditForm.tbUndo.enabled := false;
    EditForm.tbRedo.enabled := false;
    AdjustForm.btnUndo.enabled := false;
    AdjustForm.btnRedo.enabled := false;
    btnUndo.Enabled := false;
    btnRedo.enabled := false;

    Transforms := MainCp.TrianglesFromCP(MainTriangles);

    UndoIndex := 0;
    UndoMax := 0;
    if fileExists(AppPath + 'apophysis.undo') then DeleteFile(AppPath + 'apophysis.undo');
    Statusbar.Panels[2].Text := Maincp.name;
    RedrawTimer.Enabled := True;
    Application.ProcessMessages;

    EditForm.SelectedTriangle := 0; // (?)

    UpdateWindows;
  finally
    FileStrings.free;
    ParamStrings.free;
  end;
end;

procedure TMainForm.ResizeImage;
var
  pw, ph: integer;
begin
  pw := BackPanel.Width - 2;
  ph := BackPanel.Height - 2;
  begin
    if (MainCP.Width / MainCP.Height) > (pw / ph) then
    begin
      Image.Width := pw;
      Image.Height := round(MainCP.Height / MainCP.Width * pw);
      Image.Left := 1;
      Image.Top := (ph - Image.Height) div 2;
    end
    else begin
      Image.Height := ph;
      Image.Width := round(MainCP.Width / MainCP.Height * ph);
      Image.Top := 1;
      Image.Left := (pw - Image.Width) div 2;
    end;
  end;
  //MainCP.AdjustScale(Image.Width, Image.Height);
end;

procedure TMainForm.ListViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  FStrings: TStringList;
  IFSStrings: TStringList;
  EntryStrings, Tokens: TStringList;
  SavedPal: Boolean;
  i, j: integer;
  floatcolor: double;
  s: string;
  Palette: TcolorMap;
begin
  if ((ListView.SelCount <> 0) and (Trim(ListView.Selected.Caption) <> Trim(mainCP.name))) or
    ((Change = ctState) and (Item.Selected = true) and (Item.Index <> mainCPindex)) then
  begin
    assert(ListView.Selected = Item);
    mainCPindex := Item.Index;

    RedrawTimer.Enabled := False; //?
    StopThread;

    if OpenFileType = ftXML then
    begin
      LoadXMLFlame(OpenFile, ListView.Selected.Index);
    end
    else
    begin

      SavedPal := false;
      ScriptEditor.Stopped := True;
      FStrings := TStringList.Create;
      IFSStrings := TStringList.Create;
      Tokens := TStringList.Create;
      EntryStrings := TStringList.Create;
      try
        FStrings.LoadFromFile(OpenFile);
        for i := 0 to FStrings.count - 1 do
          if Pos(ListView.Selected.Caption + ' {', Trim(FStrings[i])) = 1 then
            break;
        IFSStrings.Add(FStrings[i]);
        repeat
          inc(i);
          IFSStrings.Add(FStrings[i]);
        until Pos('}', FStrings[i]) <> 0;
        maincp.Clear; // initialize control point for new flame;
        maincp.background[0] := 0;
        maincp.background[1] := 0;
        maincp.background[2] := 0;
        maincp.sample_density := defSampleDensity;
        maincp.spatial_oversample := defOversample;
        maincp.spatial_filter_radius := defFilterRadius;
        if OpenFileType = ftFla then
        begin
          for i := 0 to FStrings.count - 1 do
          begin
            if Pos(ListView.Selected.Caption + ' {', Trim(FStrings[i])) = 1 then
              break;
          end;
          inc(i);
          while (Pos('}', FStrings[i]) = 0) and (Pos('palette:', FStrings[i]) = 0) do
          begin
            EntryStrings.Add(FStrings[i]);
            inc(i);
          end;
          if Pos('palette:', FStrings[i]) = 1 then
          begin
            SavedPal := True;
            inc(i);
            for j := 0 to 255 do begin
              s := FStrings[i];
              GetTokens(s, tokens);
              floatcolor := StrToFloat(Tokens[0]);
              Palette[j][0] := round(floatcolor);
              floatcolor := StrToFloat(Tokens[1]);
              Palette[j][1] := round(floatcolor);
              floatcolor := StrToFloat(Tokens[2]);
              Palette[j][2] := round(floatcolor);
              inc(i);
            end;
          end;
          FlameString := EntryStrings.Text;
          maincp.ParseString(FlameString);
          Transforms := MainCP.NumXForms;
        end
        else
        begin
        { Open *.ifs File }
          Variation := vLinear;
          VarMenus[0].Checked := True;
          StringToIFS(IFSStrings.Text);
          SetVariation(maincp);
          maincp.CalcBoundBox;
        end;
//        Zoom := maincp.zoom;
        Center[0] := maincp.Center[0];
        Center[1] := maincp.Center[1];
//        MainCP.NormalizeWeights;
        mnuSaveUndo.Enabled := false;
        mnuUndo.Enabled := False;
        mnuPopUndo.Enabled := False;
        mnuRedo.enabled := False;
        mnuPopRedo.enabled := False;
        EditForm.mnuUndo.Enabled := False;
        EditForm.mnuRedo.enabled := False;
        EditForm.tbUndo.enabled := false;
        EditForm.tbRedo.enabled := false;
        AdjustForm.btnUndo.enabled := false;
        AdjustForm.btnRedo.enabled := false;
        btnUndo.Enabled := false;
        btnRedo.enabled := false;
        Transforms := MainCp.TrianglesFromCP(MainTriangles);
      // Fix Apophysis 1.0 parameters with negative color parameteres!
        for i := 0 to Transforms - 1 do
          if maincp.xform[i].color < 0 then maincp.xform[i].color := 0;
        if SavedPal then maincp.cmap := Palette;
        UndoIndex := 0;
        UndoMax := 0;
        if fileExists(AppPath + 'apophysis.undo') then DeleteFile(AppPath + 'apophysis.undo');
        maincp.name := ListView.Selected.Caption;
        Statusbar.Panels[2].Text := maincp.name;
        RedrawTimer.Enabled := True;
        Application.ProcessMessages;
        UpdateWindows;
      finally
        IFSStrings.Free;
        FStrings.Free;
        Tokens.free;
        EntryStrings.free;
      end;
    end;
    {if ResizeOnLoad then}
    ResizeImage;
  end;

end;

procedure TMainForm.UpdateWindows;
begin
  if AdjustForm.visible then AdjustForm.UpdateDisplay;
  if EditForm.visible then EditForm.UpdateDisplay;
  if MutateForm.visible then MutateForm.UpdateDisplay;
end;

procedure TMainForm.LoadUndoFlame(index: integer; filename: string);
var
  FStrings: TStringList;
  IFSStrings: TStringList;
  EntryStrings, Tokens: TStringList;
  SavedPal: Boolean;
  i, j: integer;
  s: string;
  Palette: TColorMap;
begin
  ScriptEditor.Stopped := True;
  FStrings := TStringList.Create;
  IFSStrings := TStringList.Create;
  Tokens := TStringList.Create;
  EntryStrings := TStringList.Create;
  try
    FStrings.LoadFromFile(filename);
    for i := 0 to FStrings.count - 1 do
      if Pos(Format('%.4d-', [UndoIndex]), Trim(FStrings[i])) = 1 then
        break;
    IFSStrings.Add(FStrings[i]);
    repeat
      inc(i);
      IFSStrings.Add(FStrings[i]);
    until Pos('}', FStrings[i]) <> 0;
    for i := 0 to FStrings.count - 1 do
    begin
      if Pos(Format('%.4d-', [UndoIndex]), Trim(Lowercase(FStrings[i]))) = 1 then
        break;
    end;
    inc(i);
    while (Pos('}', FStrings[i]) = 0) and (Pos('palette:', FStrings[i]) = 0) do
    begin
      EntryStrings.Add(FStrings[i]);
      inc(i);
    end;
    SavedPal := false;
    if Pos('palette:', FStrings[i]) = 1 then
    begin
      SavedPal := True;
      inc(i);
      for j := 0 to 255 do begin
        s := FStrings[i];
        GetTokens(s, tokens);
        Palette[j][0] := StrToInt(Tokens[0]);
        Palette[j][1] := StrToInt(Tokens[1]);
        Palette[j][2] := StrToInt(Tokens[2]);
        inc(i);
      end;
    end;
    maincp.Clear;
    FlameString := EntryStrings.Text;
    maincp.zoom := 0;
    maincp.center[0] := 0;
    maincp.center[0] := 0;
    maincp.ParseString(FlameString);
    maincp.sample_density := defSampleDensity;
    Center[0] := maincp.Center[0];
    Center[1] := maincp.Center[1];
//    cp.CalcBoundbox;
//    MainCP.NormalizeWeights;
    Transforms := MainCp.TrianglesFromCP(MainTriangles);
    // Trim undo index from title
    maincp.name := Copy(Fstrings[0], 6, length(Fstrings[0]) - 7);

    if SavedPal then maincp.cmap := palette;
    if AdjustForm.visible then AdjustForm.UpdateDisplay;

    RedrawTimer.Enabled := True;
    UpdateWindows;
  finally
    IFSStrings.Free;
    FStrings.Free;
    Tokens.free;
    EntryStrings.free;
  end;
end;

procedure TMainForm.ResetLocation;
var
  i: integer;
label
  skip;
begin
  for i := 0 to mainCP.NumXForms-1 do
    if mainCP.xform[i].noPlot = false then goto skip;
  exit;
skip:
  maincp.zoom := 0;
  //maincp.Width := Image.Width;
  //maincp.Height := Image.Height;
  maincp.CalcBoundBox;
  center[0] := maincp.center[0];
  center[1] := maincp.center[1];
end;


procedure TMainForm.ListViewEdited(Sender: TObject; Item: TListItem;
  var S: string);
begin
  if s <> Item.Caption then

    if OpenFIleType = ftXML then
    begin
      if not RenameXML(Item.Caption, s) then
        s := Item.Caption;
    end
    else
      if not RenameIFS(Item.Caption, s) then
        s := Item.Caption

end;

procedure TMainForm.RedrawTimerTimer(Sender: TObject);
{ Draw flame when timer fires. This seems to stop a lot of errors }
begin
  if FMouseMoveState in [msZoomWindowMove, msZoomOutWindowMove, msDragMove, msRotateMove] then exit;

  RedrawTimer.enabled := False;
  DrawFlame;
end;

procedure TMainForm.mnuVRandomClick(Sender: TObject);
begin
  mnuVRandom.Checked := True;
  StopThread;
  UpdateUndo;
  inc(MainSeed);
  RandSeed := MainSeed;
  repeat
    Variation := vRandom;
    SetVariation(maincp);
  until not maincp.blowsup(1000);
  inc(randomindex);
  MainCp.name := RandomPrefix + RandomDate + '-' +
    IntToStr(RandomIndex);
  ResetLocation;
  RedrawTimer.Enabled := True;
  UpdateWindows;
end;

procedure TMainForm.mnuGradClick(Sender: TObject);
begin
  AdjustForm.UpdateDisplay;
  AdjustForm.PageControl.TabIndex:=2;
  AdjustForm.Show;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.mnuimageClick(Sender: TObject);
begin
  frmImageColoring.Show;
end;

procedure swapcolor(var clist: array of cardinal; i, j: integer);
var
  t: cardinal;
begin
  t := clist[j];
  clist[j] := clist[i];
  clist[i] := t;
end;

function diffcolor(clist: array of cardinal; i, j: integer): cardinal;
var
  r1, g1, b1, r2, g2, b2: byte;
begin
  r1 := clist[j] and 255;
  g1 := clist[j] shr 8 and 255;
  b1 := clist[j] shr 16 and 255;
  r2 := clist[i] and 255;
  g2 := clist[i] shr 8 and 255;
  b2 := clist[i] shr 16 and 255;
  Result := abs((r1 - r2) * (r1 - r2)) + abs((g1 - g2) * (g1 - g2)) +
    abs((b1 - b2) * (b1 - b2));
end;

procedure TMainForm.mnuSmoothGradientClick(Sender: TObject);
begin
  SmoothPalette;
end;

procedure TMainForm.SmoothPalette;
{ From Draves' Smooth palette Gimp plug-in }
var
  Bitmap: TBitMap;
  JPEG: TJPEGImage;
  pal: TColorMap;
  strings: TStringlist;
  ident, FileName: string;
  len, len_best, as_is, swapd: cardinal;
  cmap_best, original, clist: array[0..255] of cardinal;
  p, total, j, rand, tryit, i0, i1, x, y, i, iw, ih: integer;
begin
  Total := Trunc(NumTries * TryLength / 100);
  p := 0;
  Bitmap := TBitmap.Create;
  JPEG := TJPEGImage.Create;
  strings := TStringList.Create;
  try
    begin
      inc(MainSeed);
      RandSeed := MainSeed;
      OpenDialog.Filter := 'All (*.bmp;*.jpg;*.jpeg)|*.bmp;*.jpg;*.jpeg|JPEG images (*.jpg;*.jpeg)|*.jpg;*.jpeg|BMP images (*.bmp)|*.bmp';
      OpenDialog.InitialDir := ImageFolder;
      OpenDialog.Title := 'Select Image File';
      OpenDialog.FileName := '';
      if OpenDialog.Execute then
      begin
        ImageFolder := ExtractFilePath(OpenDialog.FileName);
        Application.ProcessMessages;
        len_best := 0;
        if UpperCase(ExtractFileExt(Opendialog.FileName)) = '.BMP' then
          Bitmap.LoadFromFile(Opendialog.FileName);
        if (UpperCase(ExtractFileExt(Opendialog.FileName)) = '.JPG')
          or (UpperCase(ExtractFileExt(Opendialog.FileName)) = '.JPEG') then
        begin
          JPEG.LoadFromFile(Opendialog.FileName);
          with Bitmap do
          begin
            Width := JPEG.Width;
            Height := JPEG.Height;
            Canvas.Draw(0, 0, JPEG);
          end;
        end;
        iw := Bitmap.Width;
        ih := Bitmap.Height;
        for i := 0 to 255 do
        begin
          { Pick colors from 256 random pixels in the image }
          x := random(iw);
          y := random(ih);
          clist[i] := Bitmap.canvas.Pixels[x, y];
        end;
        original := clist;
        cmap_best := clist;
        for tryit := 1 to NumTries do
        begin
          clist := original;
          // scramble
          for i := 0 to 255 do
          begin
            rand := random(256);
            swapcolor(clist, i, rand);
          end;
          // measure
          len := 0;
          for i := 0 to 255 do
            len := len + diffcolor(clist, i, i + 1);
          // improve
          for i := 1 to TryLength do
          begin
            inc(p);
            StatusBar.SimpleText := 'Calculating palette...' + IntToStr(p div total) + '%';
            i0 := 1 + random(254);
            i1 := 1 + random(254);
            if ((i0 - i1) = 1) then
            begin
              as_is := diffcolor(clist, i1 - 1, i1) + diffcolor(clist, i0, i0 + 1);
              swapd := diffcolor(clist, i1 - 1, i0) + diffcolor(clist, i1, i0 + 1);
            end
            else if ((i1 - i0) = 1) then
            begin
              as_is := diffcolor(clist, i0 - 1, i0) + diffcolor(clist, i1, i1 + 1);
              swapd := diffcolor(clist, i0 - 1, i1) + diffcolor(clist, i0, i1 + 1);
            end
            else
            begin
              as_is := diffcolor(clist, i0, i0 + 1) + diffcolor(clist, i0, i0 - 1) +
                diffcolor(clist, i1, i1 + 1) + diffcolor(clist, i1, i1 - 1);
              swapd := diffcolor(clist, i1, i0 + 1) + diffcolor(clist, i1, i0 - 1) +
                diffcolor(clist, i0, i1 + 1) + diffcolor(clist, i0, i1 - 1);
            end;
            if (swapd < as_is) then
            begin
              swapcolor(clist, i0, i1);
              len := abs(len + swapd - as_is);
            end;
          end;
          if (tryit = 1) or (len < len_best) then
          begin
            cmap_best := clist;
            len_best := len;
          end;
        end;
        clist := cmap_best;
        // clean
        for i := 1 to 1024 do
        begin
          i0 := 1 + random(254);
          i1 := i0 + 1;
          as_is := diffcolor(clist, i0 - 1, i0) + diffcolor(clist, i1, i1 + 1);
          swapd := diffcolor(clist, i0 - 1, i1) + diffcolor(clist, i0, i1 + 1);
          if (swapd < as_is) then
          begin
            swapcolor(clist, i0, i1);
            len_best := len_best + swapd - as_is;
          end;
        end;
        { Convert to TColorMap, Gradient and save }
        FileName := lowercase(ExtractFileName(Opendialog.FileName));
        ident := CleanEntry(FileName);
        strings.add(ident + ' {');
        strings.add('gradient:');
        strings.add(' title="' + CleanUPRTitle(FileName) + '" smooth=no');
        for i := 0 to 255 do
        begin
          pal[i][0] := clist[i] and 255;
          pal[i][1] := clist[i] shr 8 and 255;
          pal[i][2] := clist[i] shr 16 and 255;
          j := round(i * (399 / 255));
          strings.Add(' index=' + IntToStr(j) + ' color=' + intToStr(clist[i]));
        end;
        strings.Add('}');
        SaveGradient(Strings.Text, Ident, defSmoothPaletteFile);

        StopThread;
        UpdateUndo;
        maincp.cmap := Pal;
        maincp.cmapindex := -1;
        AdjustForm.UpdateDisplay;

        if EditForm.Visible then EditForm.UpdateDisplay;
        if MutateForm.Visible then MutateForm.UpdateDisplay;
        RedrawTimer.enabled := true;

      end;
      StatusBar.SimpleText := '';
    end;
  finally
    Bitmap.Free;
    JPEG.Free;
    strings.Free;
  end;
end;

procedure TMainForm.mnuToolbarClick(Sender: TObject);
begin
  Toolbar.Visible := not Toolbar.Visible;
  mnuToolbar.Checked := Toolbar.visible;
end;

procedure TMainForm.mnuStatusBarClick(Sender: TObject);
begin
  Statusbar.Visible := not Statusbar.Visible;
  mnuStatusbar.Checked := Statusbar.visible;
end;

procedure TMainForm.mnuFileContentsClick(Sender: TObject);
begin
  ListView.Visible := not ListView.Visible;
  mnuFileContents.Checked := ListView.Visible;
  if ListView.Visible then Splitter.Width := 4 else Splitter.Width := 0;
end;

procedure TMainForm.Undo;
begin
  if UndoIndex = UndoMax then
    SaveFlame(maincp, Format('%.4d-', [UndoIndex]) + maincp.name, AppPath + 'apophysis.undo');
  StopThread;
  Dec(UndoIndex);
  LoadUndoFlame(UndoIndex, AppPath + 'apophysis.undo');
  mnuRedo.Enabled := True;
  mnuPopRedo.Enabled := True;
  btnRedo.Enabled := True;
  EditForm.mnuRedo.Enabled := True;
  EditForm.tbRedo.enabled := true;
  AdjustForm.btnRedo.enabled := true;
  if UndoIndex = 0 then begin
    mnuUndo.Enabled := false;
    mnuPopUndo.Enabled := false;
    btnUndo.Enabled := false;
    EditForm.mnuUndo.Enabled := false;
    EditForm.tbUndo.enabled := false;
    AdjustForm.btnUndo.enabled := false;
  end;
end;

procedure TMainForm.mnuUndoClick(Sender: TObject);
begin
  Undo;
  StatusBar.Panels[2].Text := maincp.name;
end;

procedure TMainForm.Redo;
begin
  StopThread;
  Inc(UndoIndex);

  assert(UndoIndex <= UndoMax, 'Undo list index out of range!');

  LoadUndoFlame(UndoIndex, AppPath + 'apophysis.undo');
  mnuUndo.Enabled := True;
  mnuPopUndo.Enabled := True;
  btnUndo.Enabled := True;
  EditForm.mnuUndo.Enabled := True;
  EditForm.tbUndo.enabled := true;
  AdjustForm.btnUndo.enabled := true;
  if UndoIndex = UndoMax then begin
    mnuRedo.Enabled := false;
    mnuPopRedo.Enabled := false;
    btnRedo.Enabled := false;
    EditForm.mnuRedo.Enabled := false;
    EditForm.tbRedo.enabled := false;
    AdjustForm.btnRedo.enabled := false;
  end;
end;

procedure TMainForm.mnuRedoClick(Sender: TObject);
begin
  Redo;
  StatusBar.Panels[2].Text := maincp.name;
end;

procedure TMainForm.mnuExportBitmapClick(Sender: TObject);
begin
  SaveDialog.DefaultExt := 'bmp';
  SaveDialog.Filter := 'Bitmap files (*.bmp)|*.bmp';
  SaveDialog.Filename := maincp.name;
  if SaveDialog.Execute then
    Image.Picture.Bitmap.SaveToFile(SaveDialog.Filename)
end;

procedure TMainForm.mnuFullScreenClick(Sender: TObject);
begin
  FullScreenForm.ActiveForm := Screen.ActiveForm;
  FullScreenForm.Width := Screen.Width;
  FullScreenForm.Height := Screen.Height;
  FullScreenForm.Top := 0;
  FullScreenForm.Left := 0;
  FullScreenForm.cp.Copy(maincp);
  FullScreenForm.cp.cmap := maincp.cmap;
  FullScreenForm.center[0] := center[0];
  FullScreenForm.center[1] := center[1];
  FullScreenForm.Calculate := True;
  FullScreenForm.Show;
end;

procedure TMainForm.mnuRenderClick(Sender: TObject);
var
  Ext: string;
  NewRender: Boolean;
begin
  NewRender := True;

  if Assigned(RenderForm.Renderer) then
    if Application.MessageBox('Do you want to abort the current render?', 'Apophysis', 36) = ID_NO then
      NewRender := false;

  if NewRender then
  begin

    if Assigned(RenderForm.Renderer) then RenderForm.Renderer.Terminate;
    if Assigned(RenderForm.Renderer) then RenderForm.Renderer.WaitFor; // hmm #1
    RenderForm.ResetControls;
    RenderForm.PageCtrl.TabIndex := 0;

    case renderFileFormat of
      1: Ext := '.bmp';
      2: Ext := '.png';
      3: Ext := '.jpg';
    end;

    RenderForm.caption := 'Render ' + #39 + maincp.name + #39 + ' to Disk';
    RenderForm.Filename := RenderPath + maincp.name + Ext;
    RenderForm.SaveDialog.FileName := RenderPath + maincp.name + Ext;
    RenderForm.txtFilename.Text := ChangeFileExt(RenderForm.SaveDialog.Filename, Ext);

    RenderForm.cp.Copy(MainCP);
    RenderForm.cp.cmap := maincp.cmap;
    RenderForm.zoom := maincp.zoom;
    RenderForm.Center[0] := center[0];
    RenderForm.Center[1] := center[1];
    if Assigned(RenderForm.Renderer) then RenderForm.Renderer.WaitFor; // hmm #2
  end;
  RenderForm.Show;
end;

procedure TMainForm.mnuRenderAllClick(Sender: TObject);
var
  Ext: string;
  NewRender: Boolean;
begin
  NewRender := True;

  if Assigned(RenderForm.Renderer) then
    if Application.MessageBox('Do you want to abort the current render?', 'Apophysis', 36) = ID_NO then
      NewRender := false;

  if NewRender then
  begin

    if Assigned(RenderForm.Renderer) then RenderForm.Renderer.Terminate;
    if Assigned(RenderForm.Renderer) then RenderForm.Renderer.WaitFor; // hmm #1
    RenderForm.ResetControls;
    RenderForm.PageCtrl.TabIndex := 0;

    case renderFileFormat of
      1: Ext := '.bmp';
      2: Ext := '.png';
      3: Ext := '.jpg';
    end;

    RenderForm.caption := 'Render all flames to disk';
    RenderForm.bRenderAll := true;
    RenderForm.Filename := RenderPath + maincp.name + Ext;
    RenderForm.SaveDialog.FileName := RenderForm.Filename;
    RenderForm.txtFilename.Text := ChangeFileExt(RenderForm.SaveDialog.Filename, Ext);

    RenderForm.cp.Copy(MainCP);
    RenderForm.cp.cmap := maincp.cmap;
    RenderForm.zoom := maincp.zoom;
    RenderForm.Center[0] := center[0];
    RenderForm.Center[1] := center[1];
    if Assigned(RenderForm.Renderer) then RenderForm.Renderer.WaitFor; // hmm #2
  end;
  RenderForm.Show;
end;

procedure TMainForm.mnuMutateClick(Sender: TObject);
begin
  MutateForm.Show;
  MutateForm.UpdateDisplay;
end;

procedure TMainForm.mnuAdjustClick(Sender: TObject);
begin
  AdjustForm.UpdateDisplay;
  AdjustForm.PageControl.TabIndex := 0;
  AdjustForm.Show;
end;

procedure TMainForm.mnuResetLocationClick(Sender: TObject);
var
  scale: double;
  dx, dy, cdx, cdy: double;
  sina, cosa: extended;
begin
  UpdateUndo;

  scale := MainCP.pixels_per_unit / MainCP.Width * power(2, MainCP.zoom);
  cdx := MainCP.center[0];
  cdy := MainCP.center[1];

  ResetLocation;

  cdx := MainCP.center[0] - cdx;
  cdy := MainCP.center[1] - cdy;
  Sincos(MainCP.FAngle, sina, cosa);
  if IsZero(sina) then begin
    dy := cdy*cosa {- cdx*sina};
    dx := (cdx {+ dy*sina})/cosa;
  end
  else begin
    dx := cdy*sina + cdx*cosa;
    dy := (dx*cosa - cdx)/sina;
  end;
  FViewPos.x := FViewPos.x - dx * scale * Image.Width;
  FViewPos.y := FViewPos.y - dy * scale * Image.Width;

  FViewScale := FViewScale * MainCP.pixels_per_unit / MainCP.Width * power(2, MainCP.zoom) / scale;

  DrawImageView;

  RedrawTimer.enabled := true;
  UpdateWindows;
end;

procedure TMainForm.mnuAboutClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TMainForm.mnuOpenGradientClick(Sender: TObject);
begin
  GradientBrowser.Filename := GradientFile;
  GradientBrowser.Show;
end;

procedure TMainForm.mnuSaveUndoClick(Sender: TObject);
begin
  if FileExists(AppPath + 'apophysis.undo') then
  begin
    SaveDialog.DefaultExt := 'apo';
    SaveDialog.Filter := 'Apophysis Parameters (*.apo)|*.apo';
    SaveDialog.Filename := maincp.name;
    if SaveDialog.Execute then
    begin
      if FileExists(SaveDialog.Filename) then DeleteFile(SaveDialog.Filename);
      CopyFile(PChar(AppPath + 'apophysis.undo'), PChar(SaveDialog.Filename), False);
    end;
  end;
end;

procedure TMainForm.mnuExportBatchClick(Sender: TObject);
begin
  if FileExists(AppPath + 'apophysis.rand') then
  begin
    SaveDialog.DefaultExt := 'apo';
    SaveDialog.Filter := 'Parameter files (*.apo)|*.apo';
    SaveDialog.Filename := '';
    if SaveDialog.Execute then
    begin
      if FileExists(SaveDialog.Filename) then DeleteFile(SaveDialog.Filename);
      CopyFile(PChar(AppPath + 'apophysis.rand'), PChar(SaveDialog.Filename), False);
    end;
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Assigned(RenderForm.Renderer) then
    if Application.MessageBox('Do you want to abort the current render?', 'Apophysis', 36) = ID_NO then
      CanClose := False;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  if Assigned(Renderer) then Renderer.Priority := tpLower; //tpNormal;
end;

procedure TMainForm.FormDeactivate(Sender: TObject);
begin
  if Assigned(Renderer) then Renderer.Priority := tpLowest; //tpLower;
end;

procedure TMainForm.mnuCalculateColorsClick(Sender: TObject);
var
  i: integer;
begin
  StopThread;
  UpdateUndo;
  for i := 0 to Transforms - 1 do
    maincp.xform[i].color := i / (transforms - 1);
  RedrawTimer.Enabled := True;
  UpdateWindows;
end;

procedure TMainForm.mnuRandomizeColorValuesClick(Sender: TObject);
var
  i: integer;
begin
  inc(MainSeed);
  RandSeed := MainSeed;
  StopThread;
  UpdateUndo;
  for i := 0 to Transforms - 1 do
    maincp.xform[i].color := random;
  RedrawTimer.Enabled := True;
  UpdateWindows;
end;


procedure TMainForm.mnuEditScriptClick(Sender: TObject);
begin
  ScriptEditor.Show;
end;

procedure TMainForm.btnRunClick(Sender: TObject);
begin
  ScriptEditor.RunScript;
end;

procedure TMainForm.mnuRunClick(Sender: TObject);
begin
  ScriptEditor.RunScript;
end;

procedure TMainForm.mnuOpenScriptClick(Sender: TObject);
begin
  ScriptEditor.OpenScript;
end;

procedure TMainForm.mnuStopClick(Sender: TObject);
begin
  ScriptEditor.Stopped := True;
end;

procedure TMainForm.mnuImportGimpClick(Sender: TObject);
var
  flist: tStringList;
begin
  flist := TStringList.Create;
  OpenDialog.Filter := 'Gimp parameters (*.*)|*.*';
  try
    if OpenDialog.Execute then
    begin
      flist.loadFromFile(OpenDialog.filename);
      maincp.clear;
      maincp.ParseStringList(flist);
      maincp.Width := Image.Width;
      maincp.Height := Image.Height;
      maincp.zoom := 0;
      maincp.CalcBoundBox;
      center[0] := maincp.center[0];
      center[1] := maincp.center[1];
      RedrawTimer.Enabled := True;
      Application.ProcessMessages;
      Transforms := MainCp.TrianglesFromCP(MainTriangles);
      UpdateWindows;
    end;
  finally
    flist.free
  end;
end;

procedure TMainForm.mnuManageFavoritesClick(Sender: TObject);
var
  MenuItem: TMenuItem;
  i: integer;
  s: string;
begin
  if FavoritesForm.ShowModal = mrOK then
  begin
    if favorites.count <> 0 then
    begin
      mnuScript.Items[7].free; // remember to increment if add any items above
      for i := 0 to Favorites.Count - 1 do
      begin
        s := ExtractFileName(Favorites[i]);
        s := Copy(s, 0, length(s) - 4);
        MenuItem := mnuScript.Find(s);
        if MenuItem <> nil then
          MenuItem.Free;
      end
    end;
    GetScripts;
  end;
end;

procedure TMainForm.DisableFavorites;
var
  MenuItem: TMenuItem;
  i: integer;
  s: string;
begin
  for i := 0 to Favorites.Count - 1 do
  begin
    s := ExtractFileName(Favorites[i]);
    s := Copy(s, 0, length(s) - 4);
    MenuItem := mnuScript.Find(s);
    if MenuItem <> nil then
      MenuItem.Enabled := False;
  end;
end;

procedure TMainForm.EnableFavorites;
var
  MenuItem: TMenuItem;
  i: integer;
  s: string;
begin
  for i := 0 to Favorites.Count - 1 do
  begin
    s := ExtractFileName(Favorites[i]);
    s := Copy(s, 0, length(s) - 4);
    MenuItem := mnuScript.Find(s);
    if MenuItem <> nil then
      MenuItem.Enabled := True;
  end;
end;

procedure TMainForm.mnuShowFullClick(Sender: TObject);
begin
  FullScreenForm.Calculate := False;
  FullScreenForm.Show;
end;

procedure TMainForm.mnuImageSizeClick(Sender: TObject);
begin
//  SizeTool.Show;
  AdjustForm.UpdateDisplay;
  AdjustForm.PageControl.TabIndex:=3;
  AdjustForm.Show;
end;

procedure TMainForm.ApplicationEventsActivate(Sender: TObject);
begin
  if GradientInClipboard then
  begin
//    GradientForm.mnuPaste.enabled := true;
//    GradientForm.btnPaste.enabled := true;
    AdjustForm.mnuPaste.enabled := true;
    AdjustForm.btnPaste.enabled := true;
  end
  else
  begin
//    GradientForm.mnuPaste.enabled := false;
//    GradientForm.btnPaste.enabled := false;
    AdjustForm.mnuPaste.enabled := false;
    AdjustForm.btnPaste.enabled := false;
  end;
  if FlameInClipboard then
  begin
    mnuPaste.enabled := true;
  end
  else
  begin
    mnuPaste.enabled := false;
  end;
end;

procedure TMainForm.ParseXML(var cp1: TControlPoint; const params: PCHAR);
var
  i: integer;
  h, s, v: real;
begin
  nxform := 0;
  FinalXformLoaded := false;
  ActiveXformSet := 0;
  XMLPaletteFormat := '';
  XMLPaletteCount := 0;
//  Parsecp.cmapindex := -2; // generate palette from cmapindex and hue (apo 1 and earlier)
//  ParseCp.symmetry := 0;
//  ParseCP.finalXformEnabled := false;
  //ParseCP.Clear;

  ParseCp.Free;                    // we're creating this CP from the scratch
  ParseCp := TControlPoint.create; // to reset variables properly (randomize)

  XMLScanner.LoadFromBuffer(params);
  XMLScanner.Execute;

  cp1.copy(ParseCp);
  if Parsecp.cmapindex = -2 then
  begin
    if cp1.cmapindex < NRCMAPS then
      GetCMap(cp1.cmapindex, 1, cp1.cmap)
    else
      ShowMessage('Palette index too high');

    if (cp1.hue_rotation > 0) and (cp1.hue_rotation < 1) then begin
      for i := 0 to 255 do
      begin
        RGBToHSV(cp1.cmap[i][0], cp1.cmap[i][1], cp1.cmap[i][2], h, s, v);
        h := Round(360 + h + (cp1.hue_rotation * 360)) mod 360;
        HSVToRGB(h, s, v, cp1.cmap[i][0], cp1.cmap[i][1], cp1.cmap[i][2]);
      end;
    end;
  end;

  if FinalXformLoaded = false then begin
    cp1{MainCP}.xform[nxform].Clear;
    cp1{MainCP}.xform[nxform].symmetry := 1;
  end;

  if nxform < NXFORMS then
    for i := nxform to NXFORMS - 1 do
      cp1.xform[i].density := 0;

  // Check for symmetry parameter
  if ParseCp.symmetry <> 0 then
  begin
    add_symmetry_to_control_point(cp1, ParseCp.symmetry);
    cp1.symmetry := 0;
  end;
end;

procedure TMainForm.mnuPasteClick(Sender: TObject);
begin
  if Clipboard.HasFormat(CF_TEXT) then begin
    UpdateUndo;
    ScriptEditor.Stopped := True;
    StopThread;
    ParseXML(MainCP, PCHAR(Clipboard.AsText));
    Transforms := MainCp.TrianglesFromCP(MainTriangles);
    Statusbar.Panels[2].Text := MainCp.name;
    {if ResizeOnLoad then}
    ResizeImage;
    RedrawTimer.Enabled := True;
    Application.ProcessMessages;
    UpdateWindows;
  end;
end;

procedure TMainForm.mnuCopyClick(Sender: TObject);
var
  txt: string;
begin
  txt := Trim(FlameToXML(Maincp, false));
  Clipboard.SetTextBuf(PChar(txt));
  mnuPaste.enabled := true;

  AdjustForm.mnuPaste.enabled := False;
  AdjustForm.btnPaste.enabled := False;
end;

procedure WinShellExecute(const Operation, AssociatedFile: string);
var
  a1: string;
begin
  a1 := Operation;
  if a1 = '' then
    a1 := 'open';
  ShellExecute(
    application.handle
    , pchar(a1)
    , pchar(AssociatedFile)
    , ''
    , ''
    , SW_SHOWNORMAL
    );
end;

procedure WinShellOpen(const AssociatedFile: string);
begin
  WinShellExecute('open', AssociatedFile);
end;


procedure TMainForm.mnuExportFlameClick(Sender: TObject);
var
  FileList: Tstringlist;
  Ext, ex, Path: string;
  cp1: TControlPoint;
begin
  if not FileExists(flam3Path) then
  begin
    Application.MessageBox('The flam3-render.exe renderer could not be found'+#13#10+
                           'at a specified location.'+#13#10+
                           'Please check your settings in Options -> Paths -> Export renderer.',
                           'Apophysis', 16);
    exit;
  end;
  case ExportFileFormat of
    1: Ext := 'jpg';
    2: Ext := 'ppm';
    3: Ext := 'png';
  end;
  FileList := TstringList.Create;
  cp1 := TControlPoint.Create;
  cp1.copy(Maincp);
  ExportDialog.ImageWidth := ExportWidth;
  ExportDialog.ImageHeight := ExportHeight;
  ExportDialog.Sample_density := ExportDensity;
  ExportDialog.Filter_Radius := ExportFilter;
  ExportDialog.Oversample := ExportOversample;
  try
    ExportDialog.Filename := RenderPath + Maincp.name + '.' + Ext;
    if ExportDialog.ShowModal = mrOK then
    begin
      ex := ExtractFileExt(ExportDialog.Filename);
      if ExtractFileExt(ExportDialog.Filename) = '.ppm' then
        ExportFileFormat := 2
      else if ExtractFileExt(ExportDialog.Filename) = '.png' then
        ExportFileFormat := 3
      else
        ExportFileFormat := 1;
      case ExportFileFormat of
        1: Ext := 'jpg';
        2: Ext := 'ppm';
        3: Ext := 'png';
      end;
      ExportWidth := ExportDialog.ImageWidth;
      ExportHeight := ExportDialog.ImageHeight;
      ExportDensity := ExportDialog.Sample_density;
      ExportFilter := ExportDialog.Filter_Radius;
      ExportOversample := ExportDialog.Oversample;
      ExportBatches := ExportDialog.Batches;
      ExportEstimator := ExportDialog.Estimator;
      ExportEstimatorMin := ExportDialog.EstimatorMin;
      ExportEstimatorCurve := ExportDialog.EstimatorCurve;
      ExportJitters := ExportDialog.Jitters;
      ExportGammaTreshold := ExportDialog.GammaTreshold;
      cp1.sample_density := ExportDensity;
      cp1.spatial_oversample := ExportOversample;
      cp1.spatial_filter_radius := ExportFilter;
      cp1.nbatches := ExportBatches;
      if (cp1.width <> ExportWidth) or (cp1.Height <> ExportHeight) then
        cp1.AdjustScale(ExportWidth, ExportHeight);
      cp1.estimator := ExportEstimator;
      cp1.estimator_min := ExportEstimatorMin;
      cp1.estimator_curve := ExportEstimatorCurve;
      cp1.jitters := ExportJitters;
      cp1.gamma_threshold := ExportGammaTreshold;
      FileList.Text := FlameToXML(cp1, true);
      FileList.SaveToFile(ChangeFileExt(ExportDialog.Filename, '.flame'));
      FileList.Clear;
      FileList.Add('@echo off');
      FileList.Add('set verbose=1');
      FileList.Add('set format=' + Ext);
      if ExportFileFormat = 1 then
        FileList.Add('set jpeg=' + IntToStr(JPEGQuality));
      case ExportDialog.cmbDepth.ItemIndex of
        0: FileList.Add('set bits=16');
        1: FileList.Add('set bits=32');
        2: FileList.Add('set bits=33');
        3: FileList.Add('set bits=64');
      end;
      if ExportDialog.udStrips.Position > 1 then
        FileList.Add('set nstrips=' + IntToStr(ExportDialog.udStrips.Position));
      if (PNGTransparency > 0) then
        FileList.Add('set transparency=1')
      else
        FileList.Add('set transparency=0');
      FileList.Add('set out=' + ExportDialog.Filename);
      FileList.Add('@echo Rendering "' + ExportDialog.Filename + '"');
{
      FileList.Add(ExtractShortPathName(hqiPath) + ' < ' + ExtractShortPathName(ChangeFileExt(ExportDialog.Filename, '.flame')));
      Path := ExtractShortPathName(ExtractFileDir(ExportDialog.Filename) + '\');
}
      FileList.Add('"' + flam3Path + '" < "' + ChangeFileExt(ExportDialog.Filename, '.flame') + '"');
      Path := ExtractFilePath(ExtractFileDir(ExportDialog.Filename) + '\');

      FileList.SaveToFile(Path + 'render.bat');
      if ExportDialog.chkRender.Checked then
      begin
        SetCurrentDir(Path);
        WinShellOpen(Path + 'render.bat');
      end;
    end;
  finally
    FileList.Free;
    cp1.free;
  end;

end;

function URLEncode(const ASrc: string): string;
const
  UnsafeChars = ['*', '#', '%', '<', '>', '+', ' ']; {do not localize}
var
  i: Integer;
begin
  Result := ''; {Do not Localize}
  for i := 1 to Length(ASrc) do begin
    if (ASrc[i] in UnsafeChars) or (ASrc[i] >= #$80) or (ASrc[i] < #32) then begin
      Result := Result + '%' + IntToHex(Ord(ASrc[i]), 2); {do not localize}
    end else begin
      Result := Result + ASrc[i];
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

procedure ParseCompactColors(cp: TControlPoint; count: integer; in_data: string; alpha: boolean = true);
  function HexChar(c: Char): Byte;
  begin
    case c of
      '0'..'9':  Result := Byte(c) - Byte('0');
      'a'..'f':  Result := (Byte(c) - Byte('a')) + 10;
      'A'..'F':  Result := (Byte(c) - Byte('A')) + 10;
    else
      Result := 0;
    end;
  end;
var
  i, pos, len: integer;
  c: char;
  data: string;
begin
  // diable generating pallete
  if Parsecp.cmapindex = -2 then
    Parsecp.cmapindex := -1;

  Assert(Count = 256, 'only 256 color Colormaps are supported at the moment');
  data := '';
  for i := 1 to Length(in_data) do
  begin
    c := in_data[i];
    if c in ['0'..'9']+['A'..'F']+['a'..'f'] then data := data + c;
  end;

  if alpha then len := count * 8
  else len := count * 6;

  Assert(len = Length(data), 'Color-data size mismatch');

  for i := 0 to Count-1 do begin
    if alpha then pos := i*8 + 2
    else pos := i*6;
    Parsecp.cmap[i][0] := 16 * HexChar(Data[pos + 1]) + HexChar(Data[pos + 2]);
    Parsecp.cmap[i][1] := 16 * HexChar(Data[pos + 3]) + HexChar(Data[pos + 4]);
    Parsecp.cmap[i][2] := 16 * HexChar(Data[pos + 5]) + HexChar(Data[pos + 6]);
  end;
end;

procedure TMainForm.ListXmlScannerStartTag(Sender: TObject;
  TagName: string; Attributes: TAttrList);
begin
  pname := Attributes.value('name');
  ptime := Attributes.value('time');
end;

procedure TMainForm.XMLScannerStartTag(Sender: TObject; TagName: string;
  Attributes: TAttrList);
var
  Tokens: TStringList;
  v: string;
begin
  Tokens := TStringList.Create;
 try

  if TagName='xformset' then // unused in this release...
  begin
    v := Attributes.Value('enabled');
    if v <> '' then ParseCP.finalXformEnabled := (StrToInt(v) <> 0)
    else ParseCP.finalXformEnabled := true;

    inc(activeXformSet);
  end
  else if TagName='flame' then
  begin
    v := Attributes.value('name');
    if v <> '' then Parsecp.name := v else Parsecp.name := 'untitled';
    v := Attributes.Value('time');
    if v <> '' then Parsecp.Time := StrToFloat(v);
    v := Attributes.value('palette');
    if v <> '' then
      Parsecp.cmapindex := StrToInt(v)
    else
      Parsecp.cmapindex := -1;
    v := Attributes.value('gradient');
    if v <> '' then
      Parsecp.cmapindex := StrToInt(v)
    else
      Parsecp.cmapindex := -1;
    ParseCP.hue_rotation := 1;

    v := Attributes.value('hue');
    if v <> '' then Parsecp.hue_rotation := StrToFloat(v);
    v := Attributes.Value('brightness');
    if v <> '' then Parsecp.Brightness := StrToFloat(v);
    v := Attributes.Value('gamma');
    if v <> '' then Parsecp.gamma := StrToFloat(v);
    v := Attributes.Value('vibrancy');
    if v <> '' then Parsecp.vibrancy := StrToFloat(v);
    if (LimitVibrancy) and (Parsecp.vibrancy > 1) then Parsecp.vibrancy := 1;
    v := Attributes.Value('gamma_threshold');
    if v <> '' then Parsecp.gamma_threshold := StrToFloat(v)
    else Parsecp.gamma_threshold := 0;

    v := Attributes.Value('zoom');
    if v <> '' then Parsecp.zoom := StrToFloat(v);
    v := Attributes.Value('scale');
    if v <> '' then Parsecp.pixels_per_unit := StrToFloat(v);
    v := Attributes.Value('rotate');
    if v <> '' then Parsecp.FAngle := -PI * StrToFloat(v)/180;
    v := Attributes.Value('angle');
    if v <> '' then Parsecp.FAngle := StrToFloat(v);

    try
      v := Attributes.Value('center');
      GetTokens(v, tokens);

      Parsecp.center[0] := StrToFloat(Tokens[0]);
      Parsecp.center[1] := StrToFloat(Tokens[1]);
    except
      Parsecp.center[0] := 0;
      Parsecp.center[1] := 0;
    end;

    v := Attributes.Value('size');
    GetTokens(v, tokens);

    Parsecp.width := StrToInt(Tokens[0]);
    Parsecp.height := StrToInt(Tokens[1]);

    try
      v := Attributes.Value('background');
      GetTokens(v, tokens);

      Parsecp.background[0] := Floor(StrToFloat(Tokens[0]) * 255);
      Parsecp.background[1] := Floor(StrToFloat(Tokens[1]) * 255);
      Parsecp.background[2] := Floor(StrToFloat(Tokens[2]) * 255);
    except
      Parsecp.background[0] := 0;
      Parsecp.background[1] := 0;
      Parsecp.background[2] := 0;
    end;

    v := Attributes.Value('soloxform');
    if v <> '' then Parsecp.soloXform := StrToInt(v);

    v := Attributes.Value('nick');
    if Trim(v) = '' then v := SheepNick;
    Parsecp.Nick := v;
    v := Attributes.Value('url');
    if Trim(v) = '' then v := SheepUrl;
    Parsecp.URL := v;
  end
  else if TagName='palette' then
  begin
    XMLPaletteFormat := Attributes.Value('format');
    XMLPaletteCount := StrToIntDef(Attributes.Value('count'), 256);
  end;
 finally
    Tokens.free;
 end;
end;

procedure TMainForm.XmlScannerContent(Sender: TObject; Content: String);
begin
  if XMLPaletteCount <= 0 then begin
    ShowMessage('ERROR: No colors in palette!');
    exit;
  end;
  if XMLPaletteFormat = 'RGB' then
  begin
    ParseCompactColors(ParseCP, XMLPaletteCount, Content, false);
  end
  else if XMLPaletteFormat = 'RGBA' then
  begin
    ParseCompactColors(ParseCP, XMLPaletteCount, Content);
  end
  else begin
    ShowMessage('ERROR: Unsupported palette format!');
    exit;
  end;
  Parsecp.cmapindex := -1;

  XMLPaletteFormat := '';
  XMLPaletteCount := 0;
end;

procedure TMainForm.XMLScannerEmptyTag(Sender: TObject; TagName: string;
  Attributes: TAttrList);
var
  i: integer;
  v: string;
  d, floatcolor: double;
  Tokens: TStringList;
begin
  Tokens := TStringList.Create;
  try
    if (TagName = 'xform') or (TagName = 'finalxform') then
     if {(TagName = 'finalxform') and} (FinalXformLoaded) then ShowMessage('ERROR: No xforms allowed after FinalXform!')
     else
    begin
      if (TagName = 'finalxform') or (activeXformSet > 0) then FinalXformLoaded := true;

     with ParseCP.xform[nXform] do begin
      Clear;
      v := Attributes.Value('weight');
      if (v <> '') and (TagName = 'xform') then density := StrToFloat(v);
      if (TagName = 'finalxform') then
      begin
        v := Attributes.Value('enabled');
        if v <> '' then ParseCP.finalXformEnabled := (StrToInt(v) <> 0)
        else ParseCP.finalXformEnabled := true;
      end;

      if activexformset > 0 then density := 0; // tmp...

      v := Attributes.Value('color');
      if v <> '' then color := StrToFloat(v);
      v := Attributes.Value('symmetry');
      if v <> '' then symmetry := StrToFloat(v);
      v := Attributes.Value('coefs');
      GetTokens(v, tokens);
      if Tokens.Count < 6 then ShowMessage('Not enough coefficients...crash?');
      c[0][0] := StrToFloat(Tokens[0]);
      c[0][1] := StrToFloat(Tokens[1]);
      c[1][0] := StrToFloat(Tokens[2]);
      c[1][1] := StrToFloat(Tokens[3]);
      c[2][0] := StrToFloat(Tokens[4]);
      c[2][1] := StrToFloat(Tokens[5]);

      v := Attributes.Value('post');
      if v <> '' then begin
        GetTokens(v, tokens);
        if Tokens.Count < 6 then ShowMessage('Not enough post-coefficients...crash?');
        p[0][0] := StrToFloat(Tokens[0]);
        p[0][1] := StrToFloat(Tokens[1]);
        p[1][0] := StrToFloat(Tokens[2]);
        p[1][1] := StrToFloat(Tokens[3]);
        p[2][0] := StrToFloat(Tokens[4]);
        p[2][1] := StrToFloat(Tokens[5]);
      end;

      v := Attributes.Value('chaos');
      if v <> '' then begin
        GetTokens(v, tokens);
        for i := 0 to Tokens.Count-1 do
          modWeights[i] := Abs(StrToFloat(Tokens[i]));
      end;
      //else for i := 0 to NXFORMS-1 do modWeights[i] := 1;

      v := Attributes.Value('plotmode');
      if v <> '' then begin
        if v = 'off' then begin
          noPlot := true;
        end
        else begin
          noPlot := false;
        end;
      end;

      for i := 0 to NRVAR - 1 do
      begin
        vars[i] := 0;
        v := Attributes.Value(varnames(i));
        if v <> '' then
          vars[i] := StrToFloat(v);
      end;

      v := Attributes.Value('var1');
      if v <> '' then
      begin
        for i := 0 to NRVAR - 1 do
          vars[i] := 0;
        vars[StrToInt(v)] := 1;
      end;
      v := Attributes.Value('var');
      if v <> '' then
      begin
        for i := 0 to NRVAR - 1 do
          vars[i] := 0;
        GetTokens(v, tokens);
        if Tokens.Count > NRVAR then ShowMessage('To many vars..crash?');
        for i := 0 to Tokens.Count - 1 do
          vars[i] := StrToFloat(Tokens[i]);
      end;

      for i := 0 to GetNrVariableNames - 1 do begin
        v := Attributes.Value(GetVariableNameAt(i));
        if v <> '' then begin
{$ifndef VAR_STR}
          d := StrToFloat(v);
          SetVariable(GetVariableNameAt(i), d);
{$else}
          SetVariableStr(GetVariableNameAt(i), v);
{$endif}
        end;
      end;
     end;
      Inc(nXform);
    end;
    if TagName = 'color' then
    begin
      // diable generating pallete
      //if Parsecp.cmapindex = -2 then
        Parsecp.cmapindex := -1;

      i := StrToInt(Attributes.value('index'));
      v := Attributes.value('rgb');
      GetTokens(v, tokens);
      floatcolor := StrToFloat(Tokens[0]);
      Parsecp.cmap[i][0] := round(floatcolor);
      floatcolor := StrToFloat(Tokens[1]);
      Parsecp.cmap[i][1] := round(floatcolor);
      floatcolor := StrToFloat(Tokens[2]);
      Parsecp.cmap[i][2] := round(floatcolor);
    end;
    if TagName = 'colors' then
    begin
      ParseCompactcolors(Parsecp, StrToInt(Attributes.value('count')), Attributes.value('data'));
      Parsecp.cmapindex := -1;
    end;
    if TagName = 'symmetry' then
    begin
      i := StrToInt(Attributes.value('kind'));
      Parsecp.symmetry := i;
    end;
  finally
    Tokens.free;
  end;
end;

procedure TMainForm.mnuFlamepdfClick(Sender: TObject);
begin
  WinShellOpen('flame.pdf');
end;

///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button <> mbLeft then exit;
  FClickRect.TopLeft := Point(x, y);
  FClickRect.BottomRight := FClickRect.TopLeft;
  case FMouseMoveState of
    msZoomWindow:
      begin
        FSelectRect.TopLeft := Point(x, y);
        FSelectRect.BottomRight := Point(x, y);
        DrawZoomWindow;

//        if ssAlt in Shift then
//          FMouseMoveState := msZoomOutWindowMove
//        else
          FMouseMoveState := msZoomWindowMove;
      end;
    msZoomOutWindow:
      begin
        FSelectRect.TopLeft := Point(x, y);
        FSelectRect.BottomRight := Point(x, y);
        DrawZoomWindow;

//        if ssAlt in Shift then
//          FMouseMoveState := msZoomWindowMove
//        else
          FMouseMoveState := msZoomOutWindowMove;
      end;
    msDrag:
      begin
        if not assigned(FViewImage) then exit;

//        FSelectRect.TopLeft := Point(x, y);
//        FSelectRect.BottomRight := Point(x, y);
        FMouseMoveState := msDragMove;
      end;
    msRotate:
      begin
        FClickAngle := arctan2(y-Image.Height/2, Image.Width/2-x);

        FRotateAngle := 0;
//        FSelectRect.Left := x;
        DrawRotateLines(FRotateAngle);
        FMouseMoveState := msRotateMove;
      end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
const
  snap_angle = 15*pi/180;
var
  dx, dy, cx, cy, sgn: integer;
  scale: double;
begin
{
  case FMouseMoveState of
    msRotate, msRotateMove:
      Image.Cursor := crEditRotate;
    msDrag, msDragMove:
      Image.Cursor := crEditMove;
    else
      Image.Cursor := crEditArrow;
  end;
}
  case FMouseMoveState of
    msZoomWindowMove,
    msZoomOutWindowMove:
      begin
        if DrawSelection then DrawZoomWindow;
        FClickRect.BottomRight := Point(x, y);
        dx := x - FClickRect.TopLeft.X;
        dy := y - FClickRect.TopLeft.Y;

        if ssShift in Shift then begin
          if (dy = 0) or (abs(dx/dy) >= Image.Width/Image.Height) then
            dy := Round(dx / Image.Width * Image.Height)
          else
            dx := Round(dy / Image.Height * Image.Width);
          FSelectRect.Left := FClickRect.TopLeft.X - dx;
          FSelectRect.Top := FClickRect.TopLeft.Y - dy;
          FSelectRect.Right := FClickRect.TopLeft.X + dx;
          FSelectRect.Bottom := FClickRect.TopLeft.Y + dy;
        end
        else if ssCtrl in Shift then begin
          FSelectRect.TopLeft := FClickRect.TopLeft;
          sgn := IfThen(dy*dx >=0, 1, -1);
          if (dy = 0) or (abs(dx/dy) >= Image.Width/Image.Height) then begin
            FSelectRect.Right := x;
            FSelectRect.Bottom := FClickRect.TopLeft.Y + sgn * Round(dx / Image.Width * Image.Height);
          end
          else begin
            FSelectRect.Right := FClickRect.TopLeft.X + sgn * Round(dy / Image.Height * Image.Width);
            FSelectRect.Bottom := y;
          end;
        end
        else begin
          sgn := IfThen(dy*dx >=0, 1, -1);
          if (dy = 0) or (abs(dx/dy) >= Image.Width/Image.Height) then begin
            cy := (y + FClickRect.TopLeft.Y) div 2;
            FSelectRect.Left := FClickRect.TopLeft.X;
            FSelectRect.Right := x;
            FSelectRect.Top := cy - sgn * Round(dx / 2 / Image.Width * Image.Height);
            FSelectRect.Bottom := cy + sgn * Round(dx / 2 / Image.Width * Image.Height);
          end
          else begin
            cx := (x + FClickRect.TopLeft.X) div 2;
            FSelectRect.Left := cx - sgn * Round(dy / 2 / Image.Height * Image.Width);
            FSelectRect.Right := cx + sgn * Round(dy / 2 / Image.Height * Image.Width);
            FSelectRect.Top := FClickRect.TopLeft.Y;
            FSelectRect.Bottom := y;
          end;
        end;
        DrawZoomWindow;
        DrawSelection := true;
      end;
    msDragMove:
      begin
        assert(assigned(FviewImage));
        assert(FViewScale <> 0);

        scale := FViewScale * Image.Width / FViewImage.Width;
        FViewPos.X := FViewPos.X + (x - FClickRect.Right) / scale;
        FViewPos.Y := FViewPos.Y + (y - FClickRect.Bottom) / scale;
        //FClickRect.BottomRight := Point(x, y);

		    DrawImageView;
      end;
    msRotateMove:
      begin
        if DrawSelection then DrawRotatelines(FRotateAngle);

        FRotateAngle := arctan2(y-Image.Height/2, Image.Width/2-x) - FClickAngle;
        if ssShift in Shift then // angle snap
          FRotateAngle := Round(FRotateAngle/snap_angle)*snap_angle;
        //SelectRect.Left := x;

//        pdjpointgen.Rotate(FRotateAngle);
//        FRotateAngle := 0;

        DrawRotatelines(FRotateAngle);
        DrawSelection := true;
{
        Image.Refresh;
if AdjustForm.Visible then begin
MainCp.FAngle:=-FRotateAngle;
AdjustForm.UpdateDisplay;
end;
}
      end;
  end;
  FClickRect.BottomRight := Point(x, y);
end;

function ScaleRect(r: TRect; scale: double): TSRect;
begin
  Result.Left := r.Left * scale;
  Result.Top := r.Top * scale;
  Result.Right := r.Right * scale;
  Result.Bottom := r.Bottom * scale;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  scale: double;
  rs: TSRect;
begin
  case FMouseMoveState of
    msZoomWindowMove:
      begin
        DrawZoomWindow;
        FMouseMoveState := msZoomWindow;
        if (abs(FSelectRect.Left - FSelectRect.Right) < 10) or
           (abs(FSelectRect.Top - FSelectRect.Bottom) < 10) then
          Exit; // zoom to much or double clicked

        StopThread;
        UpdateUndo;
        MainCp.ZoomtoRect(ScaleRect(FSelectRect, MainCP.Width / Image.Width));

        FViewScale := FViewScale * Image.Width / abs(FSelectRect.Right - FSelectRect.Left);
        FViewPos.x := FViewPos.x - ((FSelectRect.Right + FSelectRect.Left) - Image.Width)/2;
        FViewPos.y := FViewPos.y - ((FSelectRect.Bottom + FSelectRect.Top) - Image.Height)/2;
        DrawImageView;

        RedrawTimer.Enabled := True;
        UpdateWindows;
      end;
    msZoomOutWindowMove:
      begin
        DrawZoomWindow;
        FMouseMoveState := msZoomOutWindow;
        if (abs(FSelectRect.Left - FSelectRect.Right) < 10) or
           (abs(FSelectRect.Top - FSelectRect.Bottom) < 10) then
          Exit; // zoom to much or double clicked

        StopThread;
        UpdateUndo;
        MainCp.ZoomOuttoRect(ScaleRect(FSelectRect, MainCP.Width / Image.Width));

        scale := Image.Width / abs(FSelectRect.Right - FSelectRect.Left);
        FViewScale := FViewScale / scale;
        FViewPos.x := scale * (FViewPos.x + ((FSelectRect.Right + FSelectRect.Left) - Image.Width)/2);
        FViewPos.y := scale * (FViewPos.y + ((FSelectRect.Bottom + FSelectRect.Top) - Image.Height)/2);

        DrawImageView;

        RedrawTimer.Enabled := True;
        UpdateWindows;
      end;
    msDragMove:
      begin
        FClickRect.BottomRight := Point(x, y);
        FMouseMoveState := msDrag;

        if ((x = 0) and (y = 0)) or // double clicked
           ((FClickRect.left = FClickRect.right) and (FClickRect.top = FClickRect.bottom))
          then Exit;

        StopThread;
        UpdateUndo;
        MainCp.MoveRect(ScaleRect(FClickRect, MainCP.Width / Image.Width));

        RedrawTimer.Enabled := True;
        UpdateWindows;
      end;
    msRotateMove:
      begin
        DrawRotatelines(FRotateAngle);

        FMouseMoveState := msRotate;

        if (FRotateAngle = 0) then Exit; // double clicked

        StopThread;
        UpdateUndo;
        if MainForm_RotationMode = 0 then MainCp.Rotate(FRotateAngle)
        else MainCp.Rotate(-FRotateAngle);

        if assigned(FViewImage) then begin
          FViewImage.Free;
          FViewImage := nil;
          DrawImageView;
        end;

        RedrawTimer.Enabled := True;
        UpdateWindows;
      end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.DrawImageView;
var
  i, j: integer;
  bm: TBitmap;
  r: TRect;
  scale: double;
const
  msg = #54; // 'NO PREVIEW';
var
  ok: boolean;
  GlobalMemoryInfo: TMemoryStatus; // holds the global memory status information
  area: int64;
begin
  bm := TBitmap.Create;
  bm.Width := Image.Width;
  bm.Height := Image.Height;
  with bm.Canvas do begin
    if ShowTransparency then begin
      Brush.Color := $F0F0F0;
      FillRect(Rect(0, 0, bm.Width, bm.Height));
      Brush.Color := $C0C0C0;
      for i := 0 to ((bm.Width - 1) shr 3) do begin
        for j := 0 to ((bm.Height - 1) shr 3) do begin
          if odd(i + j) then
            FillRect(Rect(i shl 3, j shl 3, (i+1) shl 3, (j+1) shl 3));
        end;
      end;
    end
    else begin
      Brush.Color := MainCP.background[0] or (MainCP.background[1] shl 8) or (MainCP.background[2] shl 16);
      FillRect(Rect(0, 0, bm.Width, bm.Height));
    end;
  end;
  ok := false;
  if assigned(FViewImage) then begin
    scale := FViewScale * Image.Width / FViewImage.Width;

    r.Left := Image.Width div 2 + round(scale * (FViewPos.X - FViewImage.Width/2));
    r.Right := Image.Width div 2 + round(scale * (FViewPos.X + FViewImage.Width/2));
    r.Top := Image.Height div 2 + round(scale * (FViewPos.Y - FViewImage.Height/2));
    r.Bottom := Image.Height div 2 + round(scale * (FViewPos.Y + FViewImage.Height/2));

    GlobalMemoryInfo.dwLength := SizeOf(GlobalMemoryInfo);
    GlobalMemoryStatus(GlobalMemoryInfo);
    area := abs(r.Right - r.Left) * int64(abs(r.Bottom - r.Top));

    if (area * 4 < GlobalMemoryInfo.dwAvailPhys div 2) or
      (area <= Screen.Width*Screen.Height*4) then
    try
      FViewImage.Draw(bm.Canvas, r);
      ok := true;
    except
    end;
  end;

  if not ok then
    with bm.Canvas do
    begin
      Font.Name := 'Wingdings'; // 'Arial';
      Font.Height := bm.Height div 4;
      Font.Color := $808080;
      Brush.Style := bsClear;
      i := (bm.Width - TextWidth(msg)) div 2;
      j := (bm.Height - TextHeight(msg)) div 2;
      Font.Color := 0;
      TextOut(i+2,j+2, msg);
      Font.Color := clWhite; //$808080;
      TextOut(i,j, msg);
    end;
  Image.Picture.Graphic := bm;
  Image.Refresh;
  bm.Free;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.DrawRotateLines(Angle: double);
var
  bkuPen: TPen;
  points: array[0..3] of TPoint;
  i,x,y: integer;
begin
  bkuPen := TPen.Create;
  bkuPen.Assign(Image.Canvas.Pen);
  Image.Canvas.Pen.Mode    := pmXor;
  Image.Canvas.Pen.Color   := clWhite;
  Image.Canvas.Pen.Style   := psDot; //psDash;
  Image.Canvas.Brush.Style := bsClear;

//  Image.Canvas.Rectangle(FSelectRect);
  points[0].x := (Image.Width div 2)-1;
  points[0].y := (Image.Height div 2)-1;
  points[1].x := (Image.Width div 2)-1;
  points[1].y := -Image.Height div 2;
  points[2].x := -Image.Width div 2;
  points[2].y := -Image.Height div 2;
  points[3].x := -Image.Width div 2;
  points[3].y := (Image.Height div 2)-1;

  for i := 0 to 3 do begin
    x := points[i].x;
    y := points[i].y;

    points[i].x := round(cos(Angle) * x + sin(Angle) * y) + Image.Width div 2;
    points[i].y := round(-sin(Angle) * x + cos(Angle) * y) + Image.Height div 2;
  end;

  Image.Canvas.MoveTo(Points[3].x, Points[3].y);
  for i := 0 to 3 do begin
    Image.Canvas.LineTo(Points[i].x, Points[i].y);
  end;

  Image.Canvas.Pen.Assign(bkuPen);
  bkuPen.Free;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.DrawZoomWindow;
const
  cornerSize = 32;
var
  bkuPen: TPen;
  dx, dy, cx, cy: integer;
  l, r, t, b: integer;
begin
  bkuPen := TPen.Create;
  bkuPen.Assign(Image.Canvas.Pen);
  with Image.Canvas do begin
    Pen.Mode    := pmXor;
    Pen.Color   := clWhite;
    Brush.Style := bsClear;

    Pen.Style   := psDot; //psDash;

    if ssShift in FShiftState then
    begin
      dx := FClickRect.Right - FClickRect.Left;
      dy := FClickRect.Bottom - FClickRect.Top;
      Rectangle(FClickRect.Left - dx, FClickRect.Top - dy, FClickRect.Right, FClickRect.Bottom);
    end
    else Rectangle(FClickRect);

    dx := FSelectRect.Right - FSelectRect.Left;
    if dx >= 0 then begin
      l := FSelectRect.Left - 1;
      r := FSelectRect.Right;
    end
    else begin
      dx := -dx;
      l := FSelectRect.Right - 1;
      r := FSelectRect.Left;
    end;
    dx := min(dx div 2 - 1, cornerSize);

    dy := FSelectRect.Bottom - FSelectRect.Top;
    if dy >= 0 then begin
      t := FSelectRect.Top - 1;
      b := FSelectRect.Bottom;
    end
    else begin
      dy := -dy;
      t := FSelectRect.Bottom - 1;
      b := FSelectRect.Top;
    end;
    dy := min(dy div 2, cornerSize);

    pen.Style := psSolid;

    MoveTo(l + dx, t);
    LineTo(l, t);
    LineTo(l, t + dy);
    MoveTo(r - dx, t);
    LineTo(r, t);
    LineTo(r, t + dy);
    MoveTo(r - dx, b);
    LineTo(r, b);
    LineTo(r, b - dy);
    MoveTo(l + dx, b);
    LineTo(l, b);
    LineTo(l, b - dy);
{
    cx := (l + r) div 2;
    cy := (t + b) div 2;
    MoveTo(cx - dx div 2, cy);
    LineTo(cx + dx div 2 + 1, cy);
    MoveTo(cx, cy - dy div 2);
    LineTo(cx, cy + dy div 2 + 1);
}
    Pen.Assign(bkuPen);
  end;
  bkuPen.Free;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.tbzoomwindowClick(Sender: TObject);
begin
  FMouseMoveState := msZoomWindow;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.tbzoomoutwindowClick(Sender: TObject);
begin
  FMouseMoveState := msZoomOutWindow;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.tbDragClick(Sender: TObject);
begin
  FMouseMoveState := msDrag;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.tbRotateClick(Sender: TObject);
begin
  FMouseMoveState := msRotate;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.FillVariantMenu;
var
  i: integer;
  s: string;
  NewMenuItem : TMenuItem;
begin
  SetLength(VarMenus, NrVar);

  for i := 0 to NRVAR - 1 do begin
    NewMenuItem := TMenuItem.Create(self);
    s := varnames(i);
    NewMenuItem.Caption    := uppercase(s[1]) + copy(s, 2, length(s)-1);
    NewMenuItem.OnClick    := VariantMenuClick;
    NewMenuItem.Enabled    := True;
    NewMenuItem.Name       := 'var' + intTostr(i);
    NewMenuItem.Tag        := i;
    NewMenuItem.GroupIndex := 2;
    NewMenuItem.RadioItem  := True;
    VarMenus[i] := NewMenuItem;
    if i < NumBuiltinVars then
      mnuBuiltinVars.Add(NewMenuItem)
    else
      mnuPluginVars.Add(NewMenuItem);
  end;
end;

///////////////////////////////////////////////////////////////////////////////

procedure TMainForm.VariantMenuClick(Sender: TObject);
begin
  TMenuItem(Sender).Checked := True;
  UpdateUndo;
  Variation := TVariation(TMenuItem(Sender).Tag);
  SetVariation(maincp);
  ResetLocation;
  RedrawTimer.Enabled := True;
  UpdateWindows;
end;

//--Z--////////////////////////////////////////////////////////////////////////

procedure TMainForm.tbQualityBoxKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    tbQualityBoxSet(Sender);
    key := #0;
  end
  else if key = #27 then tbQualityBox.Text := FloatToStr(defSampleDensity);
end;

procedure TMainForm.tbQualityBoxSet(Sender: TObject);
var
  q: double;
begin
  try
    q := StrToFloat(tbQualityBox.Text);
  except
    exit;
  end;
  defSampleDensity := q;

  StopThread;
  RedrawTimer.Enabled := True;
  UpdateWindows;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.ImageDblClick(Sender: TObject);
begin
  if FMouseMoveState = msRotateMove then
  begin
//        FRotateAngle := 0;
    StopThread;
    UpdateUndo;
    MainCp.FAngle := 0;
    RedrawTimer.Enabled := True;
    UpdateWindows;
  end
  else mnuResetLocationClick(Sender);
end;

{$IFDEF DEBUG}
///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.AppException(Sender: TObject; E: Exception);
var
  frmException: TfrmException;
begin
  frmException := TfrmException.Create(nil);

  JclLastExceptStackListToStrings(frmException.Memo1.Lines, False, True, True, False);

  frmException.Memo1.Lines.Insert(0,e.Message);
  frmException.Memo1.Lines.Insert(1,'');

  frmException.ShowModal;
end;
{$ENDIF}

///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.tbShowAlphaClick(Sender: TObject);
begin
  ShowTransparency := tbShowAlpha.Down;

  DrawImageView;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.tbShowTraceClick(Sender: TObject);
begin
  TraceForm.Show;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.FormKeyUpDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  MousePos: TPoint;
begin
  if Shift <> FShiftState then begin
    if FMouseMoveState in [msZoomWindowMove, msZoomOutWindowMove, msRotateMove, msDragMove] then
    begin
      // hack: to generate MouseMove event
      GetCursorPos(MousePos);
      SetCursorPos(MousePos.x, MousePos.y);
    end;

    if (FMouseMoveState in [msZoomWindowMove, msZoomOutWindowMove]) then
    begin
      DrawZoomWindow;
      FShiftState := Shift;
      DrawZoomWindow;
    end
    else FShiftState := Shift;
  end;
end;

procedure TMainForm.ListViewChanging(Sender: TObject; Item: TListItem;
  Change: TItemChange; var AllowChange: Boolean);
begin
{
  if (Trim(Item.Caption) = Trim(maincp.name)) and
     (Item.Selected) and (Change = ctState) then
    if UndoIndex <> 0 then
      if Application.MessageBox('Are you sure?', 'Apophysis', MB_ICONWARNING or MB_YESNO) <> IDYES then
      begin
        AllowChange := false;
        exit;
      end;
}
end;

procedure TMainForm.ListViewInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: String);
var
  Bitmap: TBitmap;
  lcp: TControlPoint;
begin
  // flame preview in a tooltip...
{
  BitMap := TBitMap.create;
  Bitmap.PixelFormat := pf24bit;
  BitMap.Width := 100;
  BitMap.Height := 100;

  lcp := TControlPoint.Create;
  lcp.Copy(mainCP);
  lcp.cmap := mainCP.cmap;

  if Assigned(Renderer) then begin
    Renderer.WaitFor;
    Renderer.Free;
  end;
  if not Assigned(Renderer) then
  begin
    lcp.sample_density := 1;
    lcp.spatial_oversample := 1;
    lcp.spatial_filter_radius := 0.3;
    lcp.AdjustScale(100, 100);
    lcp.Transparency := false;
  end;
  try
    Renderer := TRenderThread.Create;
    assert(Renderer <> nil);
    Renderer.BitsPerSample := 0
    Renderer.TargetHandle := self.Handle;
    Renderer.SetCP(lcp);
    Renderer.Priority := tpLower;
    Renderer.NrThreads := 1
    Renderer.Resume;
    Renderer.WaitFor;
  except
  end;


  lcp.Free;
  Bitmap.Free;
}
end;

end.
