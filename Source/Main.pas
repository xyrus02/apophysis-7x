{
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Boris, Peter Sdobnov     

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

interface

uses
  Windows, Forms, Dialogs, Menus, Controls, ComCtrls,
  ToolWin, StdCtrls, Classes, Messages, ExtCtrls, ImgList, controlpoint,
  Jpeg, SyncObjs, SysUtils, ClipBrd, Graphics, Math, Global,
  Registry, RenderThread, Cmap, ExtDlgs, AppEvnts, ShellAPI,
  LibXmlParser, LibXmlComps, Xform, XFormMan;

const
  PixelCountMax = 32768;
  RS_A1 = 0;
  RS_DR = 1;
  RS_XO = 2;
  RS_VO = 3;

  AppVersionString = 'Apophysis 2.03d pre-release 2';

type
  TMouseMoveState = (msUsual, msZoomWindow, msZoomOutWindow, msZoomWindowMove, msZoomOutWindowMove, msDrag, msDragMove, msRotate, msRotateMove);

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
    mnuPopCopyUPR: TMenuItem;
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
    procedure mnuExportFLameClick(Sender: TObject);
    procedure mnuPostSheepClick(Sender: TObject);
{
    procedure HTTPRedirect(Sender: TObject; var dest: string;
      var NumRedirect: Integer; var Handled: Boolean;
      var VMethod: TIdHTTPMethod);
    procedure HTTPStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
}
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
  private
    Renderer: TRenderThread;

    FMouseMoveState: TMouseMoveState;
    FSelectRect: TRect;
    FRotateAngle: double;
    FClickAngle: double; // --Z--
    FViewBMP: Graphics.TBitmap;

    procedure DrawZoomWindow(ARect: TRect);
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
    Remainder: TDateTime;
    AnimPal: TColorMap;

    VarMenus: array of TMenuItem;

    procedure LoadXMLFlame(filename, name: string);
    procedure DisableFavorites;
    procedure EnableFavorites;
    procedure ParseXML(var cp1: TControlPoint; const params: PCHAR);
    function SaveFlame(cp1: TControlPoint; title, filename: string): boolean;
    function SaveXMLFlame(const cp1: TControlPoint; title, filename: string): boolean;
    //function TrianglesFromCP(const cp1: TControlPoint; var Triangles: TTriangles): integer;
    procedure DisplayHint(Sender: TObject);
    procedure OnProgress(prog: double);
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
function PackVariations: cardinal;
procedure UnpackVariations(v: integer);
//procedure NormalizeWeights(var cp: TControlPoint);
//procedure EqualizeWeights(var cp: TControlPoint);
procedure MultMatrix(var s: TMatrix; const m: TMatrix);
procedure ListFlames(FileName: string; sel: integer);
procedure ListIFS(FileName: string; sel: integer);
//procedure AdjustScale(var cp1: TControlPoint; width, height: integer);
procedure NormalizeVariations(var cp1: TControlPoint);
function GetWinVersion: TWin32Version;

var
  MainForm: TMainForm;
  pname, ptime: string;
  nxform: integer;
  FinalXformLoaded: boolean;
  ParseCp: TControlPoint; // For parsing;
  MainCp: TControlPoint;

implementation


uses
{$IFDEF DEBUG}
  JclDebug, ExceptForm, 
{$ENDIF}
  Editor, Options, Regstry,  Render,
  FullScreen, FormRender, Mutate, Adjust, Browser, Save, About, CmapData,
  HtmlHlp, ScriptForm, FormFavorites, FormExport, msMultiPartFormData,
  ImageColoring, RndFlame;

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

function PackVariations: cardinal;
{ Packs the variation options into an integer with Linear as lowest bit }
var
  r, i: cardinal;
begin
  r := 0;
  for i := 0 to NRVAR - 1 do
  begin
    r := r or byte(Variations[i]) shl i;
  end;
  Result := r;
end;

procedure UnpackVariations(v: integer);
{ Unpacks the variation options form an integer }
var
  i: integer;
begin
  for i := 0 to NRVAR - 1 do
    Variations[i] := boolean(v shr i and 1);
end;

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
  Elapsed: TDateTime;
begin
  Elapsed := Now - StartTime;
  StatusBar.Panels[0].Text := Format('Elapsed %2.2d:%2.2d:%2.2d.%2.2d',
    [Trunc(Elapsed * 24),
    Trunc((Elapsed * 24 - Trunc(Elapsed * 24)) * 60),
      Trunc((Elapsed * 24 * 60 - Trunc(Elapsed * 24 * 60)) * 60),
      Trunc((Elapsed * 24 * 60 * 60 - Trunc(Elapsed * 24 * 60 * 60)) * 100)]);
  if prog > 0 then 
    Remainder := Min(Remainder, Elapsed * (power(1 / prog, 1.2) - 1));

  StatusBar.Panels[1].Text := Format('Remaining %2.2d:%2.2d:%2.2d.%2.2d',
    [Trunc(Remainder * 24),
    Trunc((Remainder * 24 - Trunc(Remainder * 24)) * 60),
      Trunc((Remainder * 24 * 60 - Trunc(Remainder * 24 * 60)) * 60),
      Trunc((Remainder * 24 * 60 * 60 - Trunc(Remainder * 24 * 60 * 60)) * 100)]);
  StatusBar.Panels[2].Text := MainCp.name;
  Application.ProcessMessages;
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
  Result := '   <colors count="256" data="';

  for i := 0 to 255 do  begin
    Result := Result + '00' //IntToHex(0,2)
                     + IntToHex(cp1.cmap[i, 0],2)
                     + IntToHex(cp1.cmap[i, 1],2)
                     + IntToHex(cp1.cmap[i, 2],2);
    if ((i and 7) = 7) and (i <> 255) then Result := Result + #13#10 + '    ';
  end;
  Result := Result + '"/>';
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


function FlameToXML(const cp1: TControlPoint; sheep: boolean; compact: boolean = false): string;
var
  t, i{, j}: integer;
  FileList: TStringList;
  x, y{, a, b, cc, d, e, f}: double;
  {varlist,} nick, url, pal, hue: string;
begin
  FileList := TStringList.create;
  x := cp1.center[0];
  y := cp1.center[1];
  pal := ''; hue := '';
  if sheep then begin
    if cp1.cmapindex >= 0 then pal := 'palette="' + IntToStr(cp1.cmapindex) + '" ';
    hue := 'hue="' + format('%g', [cp1.hue_rotation]) + '" ';
  end;

  if cp1.cmapindex >= 0 then
    pal := pal + 'gradient="' + IntToStr(cp1.cmapindex) + '" ';

  if Trim(SheepNick) <> '' then nick := 'nick="' + Trim(SheepNick) + '"';
  if Trim(SheepURL) <> '' then url := 'url="' + Trim(SheepURL) + '" ';
  try
    FileList.Add('<flame name="' + CleanXMLName(cp1.name) + format('" time="%g" ', [cp1.time]) +
      pal + 'size="' + IntToStr(cp1.width) + ' ' + IntToStr(cp1.height) +
      format('" center="%g %g" ', [x, y]) +
      format('scale="%g" ', [cp1.pixels_per_unit]) +
      format('angle="%g" ', [cp1.FAngle]) +
      format('rotate="%g" ', [-180 * cp1.FAngle/Pi]) +
      format('zoom="%g" ', [cp1.zoom]) +
      'oversample="' + IntToStr(cp1.spatial_oversample) +
      format('" filter="%g" ', [cp1.spatial_filter_radius]) +
      format('quality="%g" ', [cp1.sample_density]) +
      'batches="' + IntToStr(cp1.nbatches) +
      format('" background="%g %g %g" ', [cp1.background[0] / 255, cp1.background[1] / 255, cp1.background[2] / 255]) +
      format('brightness="%g" ', [cp1.brightness]) +
      format('gamma="%g" ', [cp1.gamma]) +
      format('vibrancy="%g" ', [cp1.vibrancy]) + hue + url + nick + '>');

   { Write transform parameters }
    t := cp1.NumXForms;
    for i := 0 to t - 1 do
      FileList.Add(cp1.xform[i].ToXMLString);
//  if cp1.HasFinalXForm then FileList.Add(cp1.finalxform.FinalToXMLString(cp1.finalXformEnabled));
    if cp1.HasFinalXForm then FileList.Add(cp1.xform[t].FinalToXMLString(cp1.finalXformEnabled));
   { Write palette data }
    if not sheep then begin
      if compact then // say no to duplicated data! (?)
        FileList.Add(ColorToXmlCompact(cp1))
      else FileList.Add(ColorToXml(cp1));
   end;

    FileList.Add('</flame>');
    result := FileList.text;
  finally
    FileList.free
  end;
end;

//function FlameToXMLSheep(const cp1: TControlPoint): string;
//var
//  t, i, j: integer;
//  FileList: TStringList;
//  x, y, a, b, cc, d, e, f: double;
//  varlist, pal, hue: string;
//begin
//  FileList := TStringList.create;
//  x := cp1.center[0];
//  y := cp1.center[1];
//  pal := ''; hue := '';
//  pal := 'palette="' + IntToStr(cp1.cmapindex) + '" ';
////  if cp1.hue_rotation = 0 then cp1.hue_rotation := 1;
//  hue := ' hue="' + format('%g', [cp1.hue_rotation]) + '"';
//  try
//    FileList.Add('<flame' + format(' time="%g" ', [cp1.time]) +
//      pal + 'size="' + IntToStr(cp1.width) + ' ' + IntToStr(cp1.height) +
//      format('" center="%g %g" ', [x, y]) +
//      format('scale="%g" ', [cp1.pixels_per_unit]) +
//      format('zoom="%g" ', [cp1.zoom]) +
//      'oversample="' + IntToStr(cp1.spatial_oversample) +
//      format('" filter="%g" ', [cp1.spatial_filter_radius]) +
//      format('quality="%g" ', [cp1.sample_density]) +
//      'batches="' + IntToStr(cp1.nbatches) +
//      format('" background="%g %g %g" ', [cp1.background[0] / 255, cp1.background[1] / 255, cp1.background[2] / 255]) +
//      format('brightness="%g" ', [cp1.brightness]) +
//      format('gamma="%g" ', [cp1.gamma]) +
//      format('vibrancy="%g"', [cp1.vibrancy]) + hue + '>');
//   { Write transform parameters }
//    t := NumXForms(cp1);
//    for i := 0 to t - 1 do
//    begin
//      with cp1.xform[i] do
//      begin
//        a := c[0][0];
//        b := c[1][0];
//        cc := c[0][1];
//        d := c[1][1];
//        e := c[2][0];
//        f := c[2][1];
//        varlist := '';
//        for j := 0 to NRVAR - 1 do
//        begin
//          if vars[j] <> 0 then
//          begin
//            varlist := varlist + varnames(j) + format('="%f" ', [vars[j]]);
//          end;
//        end;
//        FileList.Add(Format('   <xform weight="%g" color="%g" symmetry="%g" ', [density, color, symmetry]) +
//          varlist + Format('coefs="%g %g %g %g %g %g"/>', [a, cc, b, d, e, f]));
//      end;
//    end;
//    FileList.Add('</flame>');
//    result := FileList.text;
//  finally
//    FileList.free
//  end;
//end;


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
      if pos(title, FileList.Text) <> 0 then Result := true;
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
begin
  Tag := RemoveExt(filename);
  Result := True;
  try
    if FileExists(filename) then
    begin
      if XMLEntryExists(title, filename) then
      begin
        DeleteXMLEntry(title, filename);
      end;

      FileList := TStringList.create;
      try
        FileList.LoadFromFile(filename);

        // fix first line
        if (FileList.Count > 0) then begin
          FileList[0] := '<Flames name="' + Tag + '">';
        end;

        if pos('<flame ', FileList.text) <> 0 then
          repeat
            FileList.Delete(FileList.Count - 1);
          until (Pos('</flame>', FileList[FileList.count - 1]) <> 0)
        else
          repeat
            FileList.Delete(FileList.Count - 1);
          until (Pos('<' + Tag + '>', FileList[FileList.count - 1]) <> 0) or
                (Pos('</Flames>', FileList[FileList.count - 1]) <> 0);

        FileList.Add(Trim(FlameToXML(cp1, false, true)));
        FileList.Add('</Flames>');
        FileList.SaveToFile(filename);

      finally
        FileList.Free;
      end;
    end
    else
    begin
    // New file ... easy
      AssignFile(IFile, filename);
      ReWrite(IFile);
      Writeln(IFile, '<Flames name="' + Tag + '">');
      Write(IFile, FlameToXML(cp1, false, true));
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

procedure TMainForm.HandleThreadCompletion(var Message: TMessage);
var
  bm: TBitmap;
begin
  if Assigned(Renderer) then begin
    bm := TBitmap.Create;
    bm.assign(Renderer.GetImage);
    Image.Picture.Graphic := bm;
    Renderer.Free;
    Renderer := nil;
    bm.Free;
  end;
end;

procedure TMainForm.HandleThreadTermination(var Message: TMessage);
begin
  if Assigned(Renderer) then begin
    Renderer.Free;
    Renderer := nil;
  end;
end;

procedure TMainForm.DrawFlame;
begin
  RedrawTimer.Enabled := False;
  if Assigned(Renderer) then begin
    Renderer.Terminate;
    Renderer.WaitFor;
    Renderer.Free;
    Renderer := nil;
  end;

  assert(Renderer = nil); //...

  if not Assigned(Renderer) then
  begin
    if (MainCp.width <> Image.Width) or (MainCp.height <> Image.height) then
    begin
      MainCp.AdjustScale(Image.width, Image.height);
      if EditForm.Visible then EditForm.UpdateDisplay(true); // preview only?
    end;
    if AdjustForm.Visible then AdjustForm.UpdateDisplay(true); // preview only!
    // following needed ?
//    cp.Zoom := Zoom;
//    cp.center[0] := center[0];
//    cp.center[1] := center[1];
    MainCp.sample_density := defSampleDensity;
    Maincp.spatial_oversample := defOversample;
    Maincp.spatial_filter_radius := defFilterRadius;
    StartTime := Now;
    Remainder := 1;
    try
      Renderer := TRenderThread.Create;
      Renderer.TargetHandle := MainForm.Handle;
      Renderer.OnProgress := OnProgress;
      Renderer.Compatibility := Compatibility;
      Renderer.SetCP(Maincp);
      Renderer.Resume;
    except
    end;
  end;
end;

{ ************************** IFS and triangle stuff ************************* }

                   { ---Z--- moved to ControlPoint ---Z--- }

{ // unused function, hmmm...

procedure CP_compute(var cp1: TControlPoint; t1, t0: TTriangle; const i: integer);
begin
  solve3(t0.x[0], t0.y[0], t1.x[0],
    t0.x[1], t0.y[1], t1.x[1],
    t0.x[2], t0.y[2], t1.x[2],
    cp1.xform[i].c[0][0], cp1.xform[i].c[1][0], cp1.xform[i].c[2][0]);

  solve3(t0.x[0], t0.y[0], t1.y[0],
    t0.x[1], t0.y[1], t1.y[1],
    t0.x[2], t0.y[2], t1.y[2],
    cp1.xform[i].c[0][1], cp1.xform[i].c[1][1], cp1.xform[i].c[2][1]);
end;
}

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
    WriteLn(F, '<random batch>');
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
      Write(F, FlameToXML(MainCp, False, true));
//      Write(F, FlameToString(Title));
//      WriteLn(F, ' ');
    end;
    Write(F, '</random batch>');
    CloseFile(F);
  except
    on EInOutError do Application.MessageBox('Error creating batch', PChar(APP_NAME), 16);
  end;
  RandFile := AppPath + 'apophysis.rand';
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
  OpenDialog.Filter := 'Flame files (*.flame)|*.flame|Apophysis 1.0 parameters (*.fla;*.apo)|*.fla;*.apo|Fractint IFS Files (*.ifs)|*.ifs';
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
  IterDensity, m, i: integer;
  scale, a, b, c, d, e, f, p: double;
  GradStrings, Strings: TStringList;
  rept, cby, smap, sol: string;
  uprcenter: array[0..1] of double; // camera center
  Backcolor: longint;
begin
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
    Strings.Add('  maxiter=100 filename="' + UPRFormulaFile + '" entry="' + UPRFormulaIdent + '"');
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
    for m := 0 to Transforms - 1 do
    begin
      a := cp1.xform[m].c[0][0];
      c := cp1.xform[m].c[0][1];
      b := cp1.xform[m].c[1][0];
      d := cp1.xform[m].c[1][1];
      e := cp1.xform[m].c[2][0];
      f := cp1.xform[m].c[2][1];
      p := cp1.xform[m].Density;
      Strings.Add('  p_xf' + inttostr(m) + '_p=' + Format('%.6g ', [p]));
      Strings.Add('  p_xf' + inttostr(m) + '_c=' + floatTostr(cp1.xform[m].color));
      Strings.Add('  p_xf' + inttostr(m) + '_sym=' + floatTostr(cp1.xform[m].symmetry));
      Strings.Add('  p_xf' + inttostr(m) + '_cfa=' + Format('%.6g ', [a]) +
        'p_xf' + inttostr(m) + '_cfb=' + Format('%.6g ', [b]) +
        'p_xf' + inttostr(m) + '_cfc=' + Format('%.6g ', [c]) +
        'p_xf' + inttostr(m) + '_cfd=' + Format('%.6g ', [d]));
      Strings.Add('  p_xf' + inttostr(m) + '_cfe=' + Format('%.6g ', [e]) +
        ' p_xf' + inttostr(m) + '_cff=' + Format('%.6g ', [f]));
      for i := 0 to NRVAR - 1 do
        Strings.Add('  p_xf' + inttostr(m) + '_var' + inttostr(i) + '=' +
          floatToStr(cp1.xform[m].vars[i]));
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
{$IFDEF DEBUG}
  // Enable raw mode (default mode uses stack frames which aren't always generated by the compiler)
  Include(JclStackTrackingOptions, stRawMode);
  // Disable stack tracking in dynamically loaded modules (it makes stack tracking code a bit faster)
  Include(JclStackTrackingOptions, stStaticModuleList);

  // Initialize Exception tracking
  JclStartExceptionTracking;
  Application.OnException := AppException;
{$ENDIF}

  FMouseMoveState := msDrag; // --Z-- was: msZoomWindow;
  LimitVibrancy := True;
  Favorites := TStringList.Create;
  GetScripts;
  Compatibility := 1; // for Drave's compatibility
  Randomize;
  MainSeed := Random(1234567890);
  maincp := TControlPoint.Create;
  ParseCp := TControlPoint.create;
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
  if VariationOptions = 0 then VariationOptions := 16383; // it shouldn't hapen but just in case;
  UnpackVariations(VariationOptions);
  FillVariantMenu;

  tbQualityBox.Text := FloatToStr(defSampleDensity);
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
  inc(MainSeed);
  RandSeed := MainSeed;
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
  if (defFlameFile = '') or (not FileExists(defFlameFile)) then
  begin
    MainCp.Width := image.width;
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
    OpenFile := defFlameFile;
    if (LowerCase(ExtractFileExt(defFlameFile)) = '.apo') or (LowerCase(ExtractFileExt(defFlameFile)) = '.fla') then
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
  maincp.free;
  ParseCp.free;
  Favorites.Free;
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  ScriptEditor.Stopped := True;
end;

{ ****************************** Misc controls ****************************** }

procedure TMainForm.BackPanelResize(Sender: TObject);
begin
  StopThread;
  if CanDrawOnResize then
    reDrawTimer.Enabled := True;
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

procedure ResizeWindow;
var
  x, y, xdf, ydf: integer;
begin
  xdf := MainForm.Width - MainForm.Image.Width;
  ydf := MainForm.Height - MainForm.Image.Height;
  x := Maincp.Width + xdf;
  y := Maincp.height + ydf;
  if x <= Screen.width then
    MainForm.Width := x
  else
    MainForm.Width := Screen.Width;
  if y <= Screen.height then
    MainForm.height := y
  else
    MainForm.height := Screen.height;
end;

procedure TMainForm.ListViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  FStrings: TStringList;
  IFSStrings: TStringList;
  EntryStrings, Tokens: TStringList;
  SavedPal: Boolean;
  i, j: integer;
  s: string;
  Palette: TcolorMap;
begin
  if (ListView.SelCount <> 0) and
    (Trim(ListView.Selected.Caption) <> Trim(maincp.name)) then
  begin
    RedrawTimer.Enabled := False; //?
    StopThread;

    if OpenFileType = ftXML then
    begin
      LoadXMLFlame(OpenFile, ListView.Selected.caption);
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
              Palette[j][0] := StrToInt(Tokens[0]);
              Palette[j][1] := StrToInt(Tokens[1]);
              Palette[j][2] := StrToInt(Tokens[2]);
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
    if ResizeOnLoad then ResizeWindow;
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
begin
  maincp.zoom := 0;
  maincp.FAngle := 0;
  maincp.Width := Image.Width;
  maincp.Height := Image.Height;
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
    if Assigned(RenderForm.Renderer) then RenderForm.Renderer.WaitFor; ;
    RenderForm.ResetControls;

    case renderFileFormat of
      1: Ext := '.bmp';
      2: Ext := '.png';
      3: Ext := '.jpg';
    end;

    RenderForm.caption := 'Render ' + #39 + maincp.name + #39 + ' to Disk';
    RenderForm.Filename := RenderPath + maincp.name + Ext;
    RenderForm.SaveDialog.FileName := RenderPath + maincp.name + Ext;
    RenderForm.txtFilename.Text := ChangeFileExt(RenderForm.SaveDialog.Filename, Ext);

    RenderForm.cp.Copy(maincp);
    RenderForm.cp.cmap := maincp.cmap;
    RenderForm.zoom := maincp.zoom;
    RenderForm.Center[0] := center[0];
    RenderForm.Center[1] := center[1];
    if Assigned(RenderForm.Renderer) then RenderForm.Renderer.WaitFor;
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
begin
  UpdateUndo;
  ResetLocation;
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
  if Assigned(Renderer) then Renderer.Priority := tpNormal;
end;

procedure TMainForm.FormDeactivate(Sender: TObject);
begin
  if Assigned(Renderer) then Renderer.Priority := tpLower;
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
//z    btnPaste.enabled := true;
  end
  else
  begin
    mnuPaste.enabled := false;
//z    btnPaste.enabled := false;
  end;
end;

procedure TMainForm.ParseXML(var cp1: TControlPoint; const params: PCHAR);
var
  i: integer;
  h, s, v: real;
begin
  ScriptEditor.Stopped := True;
  StopThread;
  nxform := 0;
  FinalXformLoaded := false;
  Parsecp.cmapindex := -2; // generate pallet from cmapindex and hue (apo 1 and earlier)
  ParseCp.symmetry := 0;
  ParseCP.finalXformEnabled := false;
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
    MainCP.xform[nxform].Clear;
    MainCP.xform[nxform].symmetry := 1;
  end;

  if nxform < NXFORMS then
    for i := nxform to NXFORMS - 1 do
      cp1.xform[i].density := 0;
//  cp1.NormalizeWeights;
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
    ParseXML(MainCP, PCHAR(Clipboard.AsText));
    Transforms := MainCp.TrianglesFromCP(MainTriangles);
    Statusbar.Panels[2].Text := MainCp.name;
    if ResizeOnLoad then ResizeWindow;
    RedrawTimer.Enabled := True;
    Application.ProcessMessages;
    UpdateWindows;
  end;
end;

procedure TMainForm.mnuCopyClick(Sender: TObject);
var
  txt: string;
begin
  txt := Trim(FlameToXML(Maincp, false, true));
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
  if (MainCp.NumXForms > 12) or
     (MainCP.HasNewVariants) then begin
    showMessage('This flame will not be correctly rendered this way. Please use the internal renderer.');
  end;

  if not FileExists(HqiPath) then
  begin
    Application.MessageBox('Renderer does not exist.', 'Apophysis', 16);
    exit
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
      cp1.sample_density := ExportDensity;
      cp1.spatial_oversample := ExportOversample;
      cp1.spatial_filter_radius := ExportFilter;
      cp1.nbatches := ExportBatches;
      if (cp1.width <> ExportWidth) or (cp1.Height <> ExportHeight) then
        cp1.AdjustScale(ExportWidth, ExportHeight);
      FileList.Text := FlameToXML(cp1, false);
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
        2: FileList.Add('set bits=64');
      end;
      if ExportDialog.udStrips.Position > 1 then
        FileList.Add('set nstrips=' + IntToStr(ExportDialog.udStrips.Position));
      FileList.Add('set out=' + ExportDialog.Filename);
      FileList.Add('@echo Rendering ' + ExportDialog.Filename);

      FileList.Add(ExtractShortPathName(hqiPath) + ' < ' + ExtractShortPathName(ChangeFileExt(ExportDialog.Filename, '.flame')));

      Path := ExtractShortPathName(ExtractFileDir(ExportDialog.Filename) + '\');
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

procedure TMainForm.mnuPostSheepClick(Sender: TObject);
{
var
  URL: string;
  StringList: TStringList;
  ResponseStream: TMemoryStream;
  MultiPartFormDataStream: TmsMultiPartFormDataStream;
}
begin
//  if MainCp.HasNewVariants then begin
//    showMessage('The posting of sheep with new variants (exponential, power, cosine and sawtooth) is disabled in this version.');
//    Exit;
//  end;

//  if MainCp.FAngle <> 0 then begin
//    showMessage('The posting of sheep with are rotated is disabled in this version.');
//    Exit;
//  end;
{
  if SheepDialog.ShowModal = mrOK then
  begin
    DeleteFile('apophysis.log');
    SetCurrentDir(ExtractFilePath(Application.exename));
    StringList := TStringList.Create;
    MultiPartFormDataStream := TmsMultiPartFormDataStream.Create;
    ResponseStream := TMemoryStream.Create;
    try
      LogFile.Active := True;
      StringList.Text := FlameToXMLSheep(SheepDialog.cp);
      if FileExists('sheep.flame') then DeleteFile('sheep.flame');
      StringList.SaveToFile('sheep.flame');
      HTTP.Request.ContentType := MultiPartFormDataStream.RequestContentType;
      MultiPartFormDataStream.AddFormField('type', 'upload');
      MultiPartFormDataStream.AddFile('file', 'sheep.flame', 'text/xml');
      MultiPartFormDataStream.AddFormField('nick', SheepDialog.txtNick.text);
      MultiPartFormDataStream.AddFormField('url', SheepDialog.txtURL.text);
      MultiPartFormDataStream.AddFormField('pw', SheepPW); //SheepPw
    // You must make sure you call this method *before* sending the stream
      MultiPartFormDataStream.PrepareStreamForDispatch;
      MultiPartFormDataStream.Position := 0;
      URL := URLEncode(SheepServer + 'cgi/apophysis.cgi');
      try
        HTTP.Post(URL, MultiPartFormDataStream, ResponseStream);
      except
        on E: Exception do
          StatusBar.SimpleText := (E.Message);
      end;
      ResponseStream.SaveToFile('response.log');
      StringList.LoadFromFile('response.log');
      if Trim(StringList.Text) = 'bad password.' then
        ShowMessage('Bad Password');
    finally
      MultiPartFormDataStream.Free;
      ResponseStream.Free;
      StringList.Free;
      logFile.Active := False;
    end;
  end;
}
end;

{
procedure TMainForm.HTTPRedirect(Sender: TObject; var dest: string;
  var NumRedirect: Integer; var Handled: Boolean;
  var VMethod: TIdHTTPMethod);
var
  URL: string;
begin
  URL := SheepServer + 'cgi/' + dest;
  ShellExecute(ValidParentForm(Self).Handle, 'open', PChar(URL),
    nil, nil, SW_SHOWNORMAL);
  Handled := True;
end;

procedure TMainForm.HTTPStatus(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  StatusBar.SimpleText := AStatusTExt;
end;
}

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

    v := Attributes.Value('nick');
    if Trim(v) = '' then v := SheepNick;
    Parsecp.Nick := v;
    v := Attributes.Value('url');
    if Trim(v) = '' then v := SheepUrl;
    Parsecp.URL := v;

  finally
    Tokens.free;
  end;
end;

procedure ParseCompactcolors(cp: TControlPoint; count: integer; in_data: string);
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
  i: integer;
  c: char;
  data: string;
begin
  // diable generating pallete
  if Parsecp.cmapindex = -2 then
    Parsecp.cmapindex := -1;

  Assert(Count = 256, 'only 256 color Colormaps are supported at the moment');
  data := '';
  for i := 0 to Length(in_data) do
  begin
    c := in_data[i];
    if c in ['0'..'9']+['A'..'F']+['a'..'f'] then data := data + c;
  end;
  Assert((Count * 8) = Length(data), 'Color-data size mismatch');
  for i := 0 to Count -1 do begin
    Parsecp.cmap[i][0] := 16 * HexChar(Data[i*8 + 3]) + HexChar(Data[i*8 + 4]);
    Parsecp.cmap[i][1] := 16 * HexChar(Data[i*8 + 5]) + HexChar(Data[i*8 + 6]);
    Parsecp.cmap[i][2] := 16 * HexChar(Data[i*8 + 7]) + HexChar(Data[i*8 + 8]);
  end;
end;

procedure TMainForm.XMLScannerEmptyTag(Sender: TObject; TagName: string;
  Attributes: TAttrList);
var
  i: integer;
  v: string;
  d: double;
  Tokens: TStringList;
begin
  Tokens := TStringList.Create;
  try
    if (TagName = 'xform') or (TagName = 'finalxform') then
     if (TagName = 'finalxform') and (FinalXformLoaded) then ShowMessage('ERROR: No xforms allowed after FinalXform!')
     else
    begin
      if (TagName = 'finalxform') then FinalXformLoaded := true;

     with ParseCP.xform[nXform] do begin
      Clear;
      v := Attributes.Value('weight');
      if (v <> '') and (TagName = 'xform') then density := StrToFloat(v);
      if (TagName = 'finalxform') then
      begin
        v := Attributes.Value('enabled');
        if v <> '' then ParseCP.finalXformEnabled := (StrToInt(v) <> 0)
        else ParseCP.finalXformEnabled := false;
      end;
      v := Attributes.Value('color');
      if v <> '' then color := StrToFloat(v);
      v := Attributes.Value('symmetry');
      if v <> '' then symmetry := StrToFloat(v);
      v := Attributes.Value('coefs');
      GetTokens(v, tokens);
      if Tokens.Count < 6 then ShowMessage('Not enough cooeficients...crash?');
      c[0][0] := StrToFloat(Tokens[0]);
      c[0][1] := StrToFloat(Tokens[1]);
      c[1][0] := StrToFloat(Tokens[2]);
      c[1][1] := StrToFloat(Tokens[3]);
      c[2][0] := StrToFloat(Tokens[4]);
      c[2][1] := StrToFloat(Tokens[5]);

      v := Attributes.Value('post');
      if v <> '' then begin
        GetTokens(v, tokens);
        if Tokens.Count < 6 then ShowMessage('Not enough post-cooeficients...crash?');
        p[0][0] := StrToFloat(Tokens[0]);
        p[0][1] := StrToFloat(Tokens[1]);
        p[1][0] := StrToFloat(Tokens[2]);
        p[1][1] := StrToFloat(Tokens[3]);
        p[2][0] := StrToFloat(Tokens[4]);
        p[2][1] := StrToFloat(Tokens[5]);
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
          d := StrToFloat(v);
          SetVariable(GetVariableNameAt(i), d);
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
      Parsecp.cmap[i][0] := StrToInt(Tokens[0]);
      Parsecp.cmap[i][1] := StrToInt(Tokens[1]);
      Parsecp.cmap[i][2] := StrToInt(Tokens[2]);
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
var
  DestRect: TRect;
  SourceRect: TRect;
begin
  if button <> mbLeft then exit;
  case FMouseMoveState of
    msZoomWindow:
      begin
        FSelectRect.TopLeft := Point(x, y);
        FSelectRect.BottomRight := Point(x, y);
        DrawZoomWindow(FSelectRect);
        FMouseMoveState := msZoomWindowMove;
      end;
    msZoomOutWindow:
      begin
        FSelectRect.TopLeft := Point(x, y);
        FSelectRect.BottomRight := Point(x, y);
        DrawZoomWindow(FSelectRect);
        FMouseMoveState := msZoomOutWindowMove;
      end;
    msDrag:
      begin
        if not assigned(FViewBMP) then
        FViewBMP := TBitmap.Create;
        FViewBMP.Width := ClientWidth + 100;
        FViewBMP.Height := ClientHeight + 100;
        FViewBMP.Canvas.Brush.Color := clWhite;

        DestRect.Left := 0;
        DestRect.Right := FViewBMP.Width;
        DestRect.Top := 0;
        DestRect.Bottom := FViewBMP.Height;

        FviewBMP.Canvas.Pen.Color := RGB(MainCP.background[0], MainCP.background[1], MainCP.background[2]);
        FviewBMP.Canvas.Brush.Color := RGB(MainCP.background[0], MainCP.background[1], MainCP.background[2]);
        FViewBMP.Canvas.Rectangle(DestRect);

        SourceRect := ClientRect;
        DestRect := SourceRect;
        DestRect.TopLeft.X := DestRect.TopLeft.X + 50;
        DestRect.TopLeft.Y := DestRect.TopLeft.Y + 50;
        DestRect.BottomRight.X := DestRect.BottomRight.X + 50;
        DestRect.BottomRight.Y := DestRect.BottomRight.Y + 50;

        FViewBMP.Canvas.CopyRect(DestRect, Image.Canvas, SourceRect);

        FSelectRect.TopLeft := Point(x, y);
        FSelectRect.BottomRight := Point(x, y);
        FMouseMoveState := msDragMove;
      end;
    msRotate:
      begin
        FClickAngle:=arctan2(y-Image.Height/2, Image.Width/2-x);

        FRotateAngle := 0;
        FSelectRect.Left := x;
        DrawRotateLines(FRotateAngle);
        FMouseMoveState := msRotateMove;
      end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  DestRect, SrcRect: TRect;
  FOffs : TPoint;
begin
  case FMouseMoveState of
    msZoomWindowMove,
    msZoomOutWindowMove:
      begin
        DrawZoomWindow(FSelectRect);
        FSelectRect.BottomRight := Point(x, y);
        DrawZoomWindow(FSelectRect);
      end;
    msDragMove:
      begin
        FOffs.X := x - FSelectRect.TopLeft.x;
        FOffs.Y := y - FSelectRect.TopLeft.Y;
        FSelectRect.BottomRight := Point(x, y);

        DestRect := ClientRect;

        SrcRect.Left := -FOffs.X + 50;
        SrcRect.Right := ClientRect.Right - FOffs.X + 50;;
        SrcRect.Top := - FOffs.Y + 50;
        SrcRect.Bottom := ClientRect.Bottom - FOffs.Y + 50;

        Image.Canvas.CopyRect(DestRect, FViewBMP.Canvas, SrcRect);
      end;
    msRotateMove:
      begin
        DrawRotatelines(FRotateAngle);

//        FRotateAngle := FRotateAngle + 0.004 * (FSelectRect.Left - X);
        FRotateAngle:=arctan2(y-Image.Height/2, Image.Width/2-x) - FClickAngle;
        FSelectRect.Left := x;

//        pdjpointgen.Rotate(FRotateAngle);
//        FRotateAngle := 0;

        DrawRotatelines(FRotateAngle);
{
        Image.Refresh;
if AdjustForm.Visible then begin
MainCp.FAngle:=-FRotateAngle;
AdjustForm.UpdateDisplay;
end;
}
      end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TMainForm.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  case FMouseMoveState of
    msZoomWindowMove:
      begin
        DrawZoomWindow(FSelectRect);
        FSelectRect.BottomRight := Point(x, y);
        FMouseMoveState := msZoomWindow;
        if (abs(FSelectRect.Left - FSelectRect.Right) < 10) or
           (abs(FSelectRect.Top - FSelectRect.Bottom) < 10) then
          Exit; // zoom to much or double clicked

        StopThread;
        UpdateUndo;
        MainCp.ZoomtoRect(FSelectRect);

        RedrawTimer.Enabled := True;
        UpdateWindows;
      end;
    msZoomOutWindowMove:
      begin
        DrawZoomWindow(FSelectRect);
        FSelectRect.BottomRight := Point(x, y);
        FMouseMoveState := msZoomOutWindow;
        if (abs(FSelectRect.Left - FSelectRect.Right) < 10) or
           (abs(FSelectRect.Top - FSelectRect.Bottom) < 10) then
          Exit; // zoom to much or double clicked

        StopThread;
        UpdateUndo;
        MainCp.ZoomOuttoRect(FSelectRect);

        RedrawTimer.Enabled := True;
        UpdateWindows;
      end;
    msDragMove:
      begin
        FViewBMP.Free;
        FViewBMP := nil;

        FSelectRect.BottomRight := Point(x, y);
        FMouseMoveState := msDrag;

        if ((x = 0) and (y = 0)) or // double clicked
           ((FSelectRect.left = FSelectRect.right) and (FSelectRect.top = FSelectRect.bottom))
          then Exit;

        StopThread;
        UpdateUndo;
        MainCp.MoveRect(FSelectRect);

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

        RedrawTimer.Enabled := True;
        UpdateWindows;
      end;
  end;
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
  Image.Canvas.Pen.Mode    := pmNotXor;
  Image.Canvas.Pen.Color   := clBlack;
  Image.Canvas.Pen.Style   := psDash;
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
procedure TMainForm.DrawZoomWindow(ARect: TRect);
var
  bkuPen: TPen;
begin
  bkuPen := TPen.Create;
  bkuPen.Assign(Image.Canvas.Pen);
  Image.Canvas.Pen.Mode    := pmNotXor;
  Image.Canvas.Pen.Color   := clBlack;
  Image.Canvas.Pen.Style   := psDash;
  Image.Canvas.Brush.Style := bsClear;

  Image.Canvas.Rectangle(FSelectRect);

  Image.Canvas.Pen.Assign(bkuPen);
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
    mnuvar.Add(NewMenuItem);
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

end.
