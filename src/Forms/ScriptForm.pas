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
unit ScriptForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ControlPoint, Buttons, ComCtrls, ToolWin, Menus,
  XFormMan, XForm, GradientHlpr, cmap,LibXmlParser, LibXmlComps, Math, Translation,
  atScript, atPascal, AdvMemo, Advmps;

const
  NCPS = 10;

  scriptFavsFilename = 'scripts7X.fav';

type
  TOptions = class
  public
  end;
  TFlame = class
  public
  { Byte sized properties, since
    they're just place-holders }
    Hue: double;
    Time: byte;
    Gamma: byte;
    Brightness: byte;
    Vibrancy: byte;
    Zoom: byte;
    SampleDensity: byte;
    Oversample: byte;
    FilterRadius: byte;
    PixelsPerUnit: byte;
    Width: byte;
    Height: byte;
    x: byte;
    y: byte;
    Gradient: byte;
    Background: byte;
  end;
  TScriptRender = class
  public
    MaxMemory, Width, Height: integer;
    Filename: string;
  end;
  TPivot = class
  public
  end;
  TScriptEditor = class(TForm)
    MainOpenDialog: TOpenDialog;
    MainSaveDialog: TSaveDialog;
    ToolBar: TToolBar;
    btnOpen: TToolButton;
    btnSave: TToolButton;
    btnRun: TToolButton;
    StatusBar: TStatusBar;
    btnNew: TToolButton;
    PopupMenu: TPopupMenu;
    mnuCut: TMenuItem;
    mnuCopy: TMenuItem;
    mnuPaste: TMenuItem;
    mnuUndo: TMenuItem;
    N1: TMenuItem;
    BackPanel: TPanel;
    Editor: TAdvMemo;
    Scripter: TatPascalScripter;
    Splitter1: TSplitter;
    Console: TMemo;
    btnStop: TToolButton;
    btnBreak: TToolButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Styler: TAdvPascalMemoStyler;
    procedure F2SXMLStartTag(Sender: TObject; TagName: string;
      Attributes: TAttrList);
    procedure F2SXMLEndTag(Sender: TObject; TagName: string);
    procedure F2SXMLEmptyTag(Sender: TObject; TagName: string;
      Attributes: TAttrList);
    procedure F2SXMLContent(Sender: TObject; Content: string);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure mnuCutClick(Sender: TObject);
    procedure mnuCopyClick(Sender: TObject);
    procedure mnuPasteClick(Sender: TObject);
    procedure mnuUndoClick(Sender: TObject);
    procedure EditorChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ScripterCompileError(Sender: TObject; var msg: string; row,
      col: Integer; var ShowException: Boolean);
    procedure btnStopClick(Sender: TObject);
    procedure btnBreakClick(Sender: TObject);
    procedure btnFavoriteClick(Sender: TObject);
  public
    cp: TControlPoint;
    Stopped: boolean;
    cmap: TColorMap;
    Flame: TFlame;
    Options: TOptions;
    Pivot: TPivot;
    Renderer: TScriptRender;
    Another: TScriptRender;
    AddedXForms : integer;
    chaosLines : TStringList;
    procedure LoadRunAndClear(scriptFile:string);
    procedure LoadScriptFile(filename:string);
    procedure ScriptFromFlame(flameXML:string);
    procedure UpdateFlame;
    procedure PrepareScripter;
    procedure OpenScript;
    procedure RunScript;
    { Flame interface }
    procedure SetFlameNameProc(AMachine: TatVirtualMachine);
    procedure GetFlameNameProc(AMachine: TatVirtualMachine);
    procedure SetFlameHueProc(AMachine: TatVirtualMachine);
    procedure GetFlameHueProc(AMachine: TatVirtualMachine);
    procedure GetFlameGammaProc(AMachine: TatVirtualMachine);
    procedure SetFlameGammaProc(AMachine: TatVirtualMachine);
    procedure GetFlameGammaTresholdProc(AMachine: TatVirtualMachine);
    procedure SetFlameGammaTresholdProc(AMachine: TatVirtualMachine);
    procedure GetFlameBrightnessProc(AMachine: TatVirtualMachine);
    procedure SetFlameBrightnessProc(AMachine: TatVirtualMachine);
    procedure GetFlameVibrancyProc(AMachine: TatVirtualMachine);
    procedure SetFlameVibrancyProc(AMachine: TatVirtualMachine);
    procedure GetFlameTimeProc(AMachine: TatVirtualMachine);
    procedure SetFlameTimeProc(AMachine: TatVirtualMachine);
    procedure GetFlameDensityProc(AMachine: TatVirtualMachine);
    procedure SetFlameDensityProc(AMachine: TatVirtualMachine);
    procedure GetFlameOversampleProc(AMachine: TatVirtualMachine);
    procedure SetFlameOversampleProc(AMachine: TatVirtualMachine);
    procedure GetFlameFilterRadiusProc(AMachine: TatVirtualMachine);
    procedure SetFlameFilterRadiusProc(AMachine: TatVirtualMachine);
    procedure GetFlameWidthProc(AMachine: TatVirtualMachine);
    procedure SetFlameWidthProc(AMachine: TatVirtualMachine);
    procedure GetFlameHeightProc(AMachine: TatVirtualMachine);
    procedure SetFlameHeightProc(AMachine: TatVirtualMachine);
    procedure GetFlameZoomProc(AMachine: TatVirtualMachine);
    procedure SetFlameZoomProc(AMachine: TatVirtualMachine);
    procedure GetFlameXProc(AMachine: TatVirtualMachine);
    procedure SetFlameXProc(AMachine: TatVirtualMachine);
    procedure GetFlameYProc(AMachine: TatVirtualMachine);
    procedure SetFlameYProc(AMachine: TatVirtualMachine);
    procedure GetFlamePixelsPerUnitProc(AMachine: TatVirtualMachine);
    procedure SetFlamePixelsPerUnitProc(AMachine: TatVirtualMachine);
    procedure GetFlamePaletteProc(AMachine: TatVirtualMachine);
    procedure SetFlamePaletteProc(AMachine: TatVirtualMachine);
    procedure GetFlameBackgroundProc(AMachine: TatVirtualMachine);
    procedure SetFlameBackgroundProc(AMachine: TatVirtualMachine);
    procedure SetFlameNickProc(AMachine: TatVirtualMachine);
    procedure GetFlameNickProc(AMachine: TatVirtualMachine);
    procedure SetFlameURLProc(AMachine: TatVirtualMachine);
    procedure GetFlameURLProc(AMachine: TatVirtualMachine);
    procedure SetFlameBatchesProc(AMachine: TatVirtualMachine);
    procedure GetFlameBatchesProc(AMachine: TatVirtualMachine);
    procedure GetFlameFinalxformEnabledProc(AMachine: TatVirtualMachine);
    procedure SetFlameFinalxformEnabledProc(AMachine: TatVirtualMachine);
    procedure GetFlameSoloXformProc(AMachine: TatVirtualMachine);
    procedure SetFlameSoloXformProc(AMachine: TatVirtualMachine);
    procedure GetFlameAngleProc(AMachine: TatVirtualMachine);
    procedure SetFlameAngleProc(AMachine: TatVirtualMachine);
    procedure GetFlamePitchProc(AMachine: TatVirtualMachine);
    procedure SetFlamePitchProc(AMachine: TatVirtualMachine);
    procedure GetFlameYawProc(AMachine: TatVirtualMachine);
    procedure SetFlameYawProc(AMachine: TatVirtualMachine);
    procedure GetFlameCamZposProc(AMachine: TatVirtualMachine);
    procedure SetFlameCamZposProc(AMachine: TatVirtualMachine);
    procedure GetFlamePerspectiveProc(AMachine: TatVirtualMachine);
    procedure SetFlamePerspectiveProc(AMachine: TatVirtualMachine);
    procedure GetFlameDOFProc(AMachine: TatVirtualMachine);
    procedure SetFlameDOFProc(AMachine: TatVirtualMachine);

    { Transform interface }
    procedure GetTransformAProc(AMachine: TatVirtualMachine);
    procedure SetTransformAProc(AMachine: TatVirtualMachine);
    procedure GetTransformBProc(AMachine: TatVirtualMachine);
    procedure SetTransformBProc(AMachine: TatVirtualMachine);
    procedure GetTransformCProc(AMachine: TatVirtualMachine);
    procedure SetTransformCProc(AMachine: TatVirtualMachine);
    procedure GetTransformDProc(AMachine: TatVirtualMachine);
    procedure SetTransformDProc(AMachine: TatVirtualMachine);
    procedure GetTransformEProc(AMachine: TatVirtualMachine);
    procedure SetTransformEProc(AMachine: TatVirtualMachine);
    procedure GetTransformFProc(AMachine: TatVirtualMachine);
    procedure SetTransformFProc(AMachine: TatVirtualMachine);
    procedure GetTransformVarProc(AMachine: TatVirtualMachine);
    procedure SetTransformVarProc(AMachine: TatVirtualMachine);
    procedure GetTransformVariProc(AMachine: TatVirtualMachine);
    procedure SetTransformVariProc(AMachine: TatVirtualMachine);

    procedure GetTransformChaosProc(AMachine: TatVirtualMachine);
    procedure SetTransformChaosProc(AMachine: TatVirtualMachine);
    procedure GetTransformPlotModeProc(AMachine: TatVirtualMachine);
    procedure SetTransformPlotModeProc(AMachine: TatVirtualMachine);
    procedure GetTransformOpacityProc(AMachine: TatVirtualMachine);
    procedure SetTransformOpacityProc(AMachine: TatVirtualMachine);

    procedure GetTransformColorProc(AMachine: TatVirtualMachine);
    procedure SetTransformColorProc(AMachine: TatVirtualMachine);
    procedure GetTransformVarColorProc(AMachine: TatVirtualMachine);
    procedure SetTransformVarColorProc(AMachine: TatVirtualMachine);
    procedure GetTransformWeightProc(AMachine: TatVirtualMachine);
    procedure SetTransformWeightProc(AMachine: TatVirtualMachine);
    procedure GetTransformSymProc(AMachine: TatVirtualMachine);
    procedure SetTransformSymProc(AMachine: TatVirtualMachine);

    procedure GetTransformVariationProc(AMachine: TatVirtualMachine);
    procedure SetTransformVariationProc(AMachine: TatVirtualMachine);
    procedure GetTransformVariableProc(AMachine: TatVirtualMachine);
    procedure SetTransformVariableProc(AMachine: TatVirtualMachine);

    procedure GetTransformCoefsProc(AMachine: TatVirtualMachine);
    procedure SetTransformCoefsProc(AMachine: TatVirtualMachine);
    procedure GetTransformPostCoefsProc(AMachine: TatVirtualMachine);
    procedure SetTransformPostCoefsProc(AMachine: TatVirtualMachine);

    procedure TransformClearProc(AMachine: TatVirtualMachine);
    procedure TransformRotateProc(AMachine: TatVirtualMachine);
    procedure TransformScaleProc(AMachine: TatVirtualMachine);
    procedure TransformRotateOriginProc(AMachine: TatVirtualMachine);

    { Render interface }
    procedure GetRenderFilenameProc(AMachine: TatVirtualMachine);
    procedure SetRenderFilenameProc(AMachine: TatVirtualMachine);
    procedure GetRenderWidthProc(AMachine: TatVirtualMachine);
    procedure SetRenderWidthProc(AMachine: TatVirtualMachine);
    procedure GetRenderHeightProc(AMachine: TatVirtualMachine);
    procedure SetRenderHeightProc(AMachine: TatVirtualMachine);
    procedure GetRenderMaxMemoryProc(AMachine: TatVirtualMachine);
    procedure SetRenderMaxMemoryProc(AMachine: TatVirtualMachine);
    procedure FillFileList;

    { Options interface }
    procedure GetJPEGQuality(AMachine: TatVirtualMachine);
    procedure SetJPEGQuality(AMachine: TatVirtualMachine);
    procedure GetBatchSize(AMachine: TatVirtualMachine);
    procedure SetBatchSize(AMachine: TatVirtualMachine);
    procedure GetParameterFile(AMachine: TatVirtualMachine);
    procedure SetParameterFile(AMachine: TatVirtualMachine);
    procedure GetSmoothPaletteFile(AMachine: TatVirtualMachine);
    procedure SetSmoothPaletteFile(AMachine: TatVirtualMachine);
    procedure GetNumTries(AMachine: TatVirtualMachine);
    procedure SetNumTries(AMachine: TatVirtualMachine);
    procedure GetTryLength(AMachine: TatVirtualMachine);
    procedure SetTryLength(AMachine: TatVirtualMachine);
    procedure GetConfirmDelete(AMachine: TatVirtualMachine);
    procedure SetConfirmDelete(AMachine: TatVirtualMachine);
    procedure GetFixedReference(AMachine: TatVirtualMachine);
    procedure SetFixedReference(AMachine: TatVirtualMachine);
    procedure GetSampleDensity(AMachine: TatVirtualMachine);
    procedure SetSampleDensity(AMachine: TatVirtualMachine);
    procedure GetGamma(AMachine: TatVirtualMachine);
    procedure SetGamma(AMachine: TatVirtualMachine);
    procedure GetBrightness(AMachine: TatVirtualMachine);
    procedure SetBrightness(AMachine: TatVirtualMachine);
    procedure GetVibrancy(AMachine: TatVirtualMachine);
    procedure SetVibrancy(AMachine: TatVirtualMachine);
    procedure GetOversample(AMachine: TatVirtualMachine);
    procedure SetOversample(AMachine: TatVirtualMachine);
    procedure GetFilterRadius(AMachine: TatVirtualMachine);
    procedure SetFilterRadius(AMachine: TatVirtualMachine);
    procedure GetTransparency(AMachine: TatVirtualMachine);
    procedure SetTransparency(AMachine: TatVirtualMachine);
    procedure GetLowQuality(AMachine: TatVirtualMachine);
    procedure SetLowQuality(AMachine: TatVirtualMachine);
    procedure GetMediumQuality(AMachine: TatVirtualMachine);
    procedure SetMediumQuality(AMachine: TatVirtualMachine);
    procedure GetHighQuality(AMachine: TatVirtualMachine);
    procedure SetHighQuality(AMachine: TatVirtualMachine);
    procedure GetMinTransforms(AMachine: TatVirtualMachine);
    procedure SetMinTransforms(AMachine: TatVirtualMachine);
    procedure GetMaxTransforms(AMachine: TatVirtualMachine);
    procedure SetMaxTransforms(AMachine: TatVirtualMachine);
    procedure GetMutateMinTransforms(AMachine: TatVirtualMachine);
    procedure SetMutateMinTransforms(AMachine: TatVirtualMachine);
    procedure GetMutateMaxTransforms(AMachine: TatVirtualMachine);
    procedure SetMutateMaxTransforms(AMachine: TatVirtualMachine);
    procedure GetPrefix(AMachine: TatVirtualMachine);
    procedure SetPrefix(AMachine: TatVirtualMachine);
    procedure GetKeepBackground(AMachine: TatVirtualMachine);
    procedure SetKeepBackground(AMachine: TatVirtualMachine);
    procedure GetSymmetryType(AMachine: TatVirtualMachine);
    procedure SetSymmetryType(AMachine: TatVirtualMachine);
    procedure GetSymmetryOrder(AMachine: TatVirtualMachine);
    procedure SetSymmetryOrder(AMachine: TatVirtualMachine);
    procedure GetVariations(AMachine: TatVirtualMachine);
    procedure SetVariations(AMachine: TatVirtualMachine);
    procedure GetRandomGradient(AMachine: TatVirtualMachine);
    procedure SetRandomGradient(AMachine: TatVirtualMachine);
    procedure GetMinNodes(AMachine: TatVirtualMachine);
    procedure SetMinNodes(AMachine: TatVirtualMachine);
    procedure GetMaxNodes(AMachine: TatVirtualMachine);
    procedure SetMaxNodes(AMachine: TatVirtualMachine);
    procedure GetMinHue(AMachine: TatVirtualMachine);
    procedure SetMinHue(AMachine: TatVirtualMachine);
    procedure GetMaxHue(AMachine: TatVirtualMachine);
    procedure SetMaxHue(AMachine: TatVirtualMachine);
    procedure GetMinSat(AMachine: TatVirtualMachine);
    procedure SetMinSat(AMachine: TatVirtualMachine);
    procedure GetMaxSat(AMachine: TatVirtualMachine);
    procedure SetMaxSat(AMachine: TatVirtualMachine);
    procedure GetMinLum(AMachine: TatVirtualMachine);
    procedure SetMinLum(AMachine: TatVirtualMachine);
    procedure GetMaxLum(AMachine: TatVirtualMachine);
    procedure SetMaxLum(AMachine: TatVirtualMachine);
    procedure GetUPRSampleDensity(AMachine: TatVirtualMachine);
    procedure SetUPRSampleDensity(AMachine: TatVirtualMachine);
    procedure GetUPROversample(AMachine: TatVirtualMachine);
    procedure SetUPROversample(AMachine: TatVirtualMachine);
    procedure GetUPRFilterRadius(AMachine: TatVirtualMachine);
    procedure SetUPRFilterRadius(AMachine: TatVirtualMachine);
    procedure GetUPRColoringIdent(AMachine: TatVirtualMachine);
    procedure SetUPRColoringIdent(AMachine: TatVirtualMachine);
    procedure GetUPRColoringFile(AMachine: TatVirtualMachine);
    procedure SetUPRColoringFile(AMachine: TatVirtualMachine);
    procedure GetUPRFormulaIdent(AMachine: TatVirtualMachine);
    procedure SetUPRFormulaIdent(AMachine: TatVirtualMachine);
    procedure GetUPRFormulaFile(AMachine: TatVirtualMachine);
    procedure SetUPRFormulaFile(AMachine: TatVirtualMachine);
    procedure GetUPRAdjustDensity(AMachine: TatVirtualMachine);
    procedure SetUPRAdjustDensity(AMachine: TatVirtualMachine);
    procedure GetUPRWidth(AMachine: TatVirtualMachine);
    procedure SetUPRWidth(AMachine: TatVirtualMachine);
    procedure GetUPRHeight(AMachine: TatVirtualMachine);
    procedure SetUPRHeight(AMachine: TatVirtualMachine);
    procedure GetExportPath(AMachine: TatVirtualMachine);
    procedure SetExportPath(AMachine: TatVirtualMachine);

    { Pivot interface }
    procedure GetPivotModeProc(AMachine: TatVirtualMachine);
    procedure SetPivotModeProc(AMachine: TatVirtualMachine);
    procedure GetPivotXProc(AMachine: TatVirtualMachine);
    procedure SetPivotXProc(AMachine: TatVirtualMachine);
    procedure GetPivotYProc(AMachine: TatVirtualMachine);
    procedure SetPivotYProc(AMachine: TatVirtualMachine);
    procedure SetPivotProc(AMachine: TatVirtualMachine);
    procedure ResetPivotProc(AMachine: TatVirtualMachine);

  end;
  TTransform = class
  public
  { Transform class only serves as an
    interface to active transform }
    a: byte;
    b: byte;
    c: byte;
    d: byte;
    e: byte;
    f: byte;
    Color: byte;
    Weight: byte;
    Variation: byte;
    VarColor: byte;
  end;

  TMatrix = array[0..2, 0..2] of double;

var
  ScriptEditor: TScriptEditor;
  LastParseError: string;
  NumTransforms: integer; // Keeps track of number of xforms in flame.
  ActiveTransform: integer; // Operations affect this transform.
  LastError: string;
  color: double;
  cps: array[0..NCPS - 1] of TControlPoint;
  Transform: TTransform;
  Stopped, ResetLocation, UpdateIt: Boolean;
  ParamFile: string;
  FileList: TStringList;

function Mul33(M1, M2: TMatrix): TMatrix;
//procedure Normalize(var cp: TControlPoint);

implementation

{
[00 01 02]
[10 11 12]
[20 21 22]

[a  b  e ]
[c  d  f ]
[0  0  1 ]
}

uses Main, Editor, Adjust, Global, Mutate, Registry, Preview,
  ScriptRender, ap_math, ap_classes, ap_sysutils, ap_Dialogs,
  SavePreset, ap_windows, ap_FileCtrl(*, bmdll32*);

{$R *.DFM}

const
  ErrorOutOfRange = 'Transform out of range!';

type
{ Library for math functions }
  TMathLibrary = class(TatScripterLibrary)
  protected
    procedure CosProc(AMachine: TatVirtualMachine);
    procedure SinProc(AMachine: TatVirtualMachine);
    procedure Init; override;
  end;

  TOperationLibrary = class(TatScripterLibrary)
  protected
    procedure RotateFlameProc(AMachine: TatVirtualMachine);
    procedure RotateReferenceProc(AMachine: TatVirtualMachine);
    procedure RotateProc(AMachine: TatVirtualMachine);
    procedure ScaleProc(AMachine: TatVirtualMachine);
    procedure MulProc(AMachine: TatVirtualMachine);
    procedure TranslateProc(AMachine: TatVirtualMachine);
    procedure GetActiveTransformProc(AMachine: TatVirtualMachine);
    procedure SetActiveTransformProc(AMachine: TatVirtualMachine);
    procedure TransformsProc(AMachine: TatVirtualMachine);
    procedure FileCountProc(AMachine: TatVirtualMachine);
    procedure AddTransformProc(AMachine: TatVirtualMachine);
    procedure DeleteTransformProc(AMachine: TatVirtualMachine);
    procedure CopyTransformProc(AMachine: TatVirtualMachine);
    procedure ClearProc(AMachine: TatVirtualMachine);
    procedure PreviewProc(AMachine: TatVirtualMachine);
    procedure Print(AMachine: TatVirtualMachine);
    procedure MorphProc(AMachine: TatVirtualMachine);
    procedure RenderProc(AMachine: TatVirtualMachine);
    procedure AddSymmetryProc(AMachine: TatVirtualMachine);
    procedure StoreFlameProc(AMachine: TatVirtualMachine);
    procedure GetFlameProc(AMachine: TatVirtualMachine);
    procedure LoadFlameProc(AMachine: TatVirtualMachine);
    procedure SetRenderBounds(AMachine: TatVirtualMachine);
    procedure GetFileName(AMachine: TatVirtualMachine);
    procedure ListFileProc(AMachine: TatVirtualMachine);
    procedure SetParamFileProc(AMachine: TatVirtualMachine);
    procedure SaveFlameProc(AMachine: TatVirtualMachine);
    procedure ShowStatusProc(AMachine: TatVirtualMachine);
    procedure RandomFlame(AMachine: TatVirtualMachine);
    procedure RandomGradientProc(AMachine: TatVirtualMachine);
    procedure SaveGradientProc(AMachine: TatVirtualMachine);
    procedure GetVariation(AMachine: TatVirtualMachine);
    procedure SetVariation(AMachine: TatVirtualMachine);

    procedure VariationIndexProc(AMachine: TatVirtualMachine);
    procedure VariationNameProc(AMachine: TatVirtualMachine);
    procedure VariableIndexProc(AMachine: TatVirtualMachine);
    procedure VariableNameProc(AMachine: TatVirtualMachine);

    procedure CalculateScale(AMachine: TatVirtualMachine);
    procedure NormalizeVars(AMachine: TatVirtualMachine);
    procedure CalculateBounds(AMachine: TatVirtualMachine);
    procedure GetSaveFileName(AMachine: TatVirtualMachine);
    procedure CopyFileProc(AMachine: TatVirtualMachine);
   // procedure BM_OpenProc(AMachine: TatVirtualMachine);
   // procedure BM_DllCFuncProc(AMachine: TatVirtualMachine);
    procedure Init; override;
  end;

procedure TScriptEditor.ScriptFromFlame(flameXML:string);
var i : integer; xml : TXmlScanner;
begin
  // Clear & Set caption to "New Script"
  btnNewClick(btnNew);

  chaosLines := TStringList.Create;
  xml := TXmlScanner.Create(nil);
  xml.Normalize := True;
  xml.OnContent := F2SXMLContent;
  xml.OnEmptyTag := F2SXMLEmptyTag;
  xml.OnEndTag := F2SXMLEndTag;
  xml.OnStartTag := F2SXMLStartTag;
  xml.LoadFromBuffer(PANSICHAR(AnsiString(flameXML)));
  xml.Execute;
  xml.Destroy;

  // use chaosLines...
  for i := 0 to chaosLines.Count - 1 do
    Editor.Lines.Add(chaosLines.Strings[i]);
  chaosLines.Destroy;
end;
{ ************************ Options interface ********************************* }

procedure TScriptEditor.GetJPEGQuality(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(JPEGQuality);
end;

procedure TScriptEditor.SetJPEGQuality(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v > 0) and (v <= 100) then JPEGQuality := v;
  end;
end;

procedure TScriptEditor.GetBatchSize(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(BatchSize);
end;

procedure TScriptEditor.SetBatchSize(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 10) and (v <= 100) then BatchSize := v;
  end;
end;

procedure TScriptEditor.GetParameterFile(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(defFlameFile);
end;

procedure TScriptEditor.SetParameterFile(AMachine: TatVirtualMachine);
begin
  with AMachine do
    defFlameFile := GetInputArgAsString(0);
end;

procedure TScriptEditor.GetSmoothPaletteFile(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(defSmoothPaletteFile);
end;

procedure TScriptEditor.SetSmoothPaletteFile(AMachine: TatVirtualMachine);
begin
  with AMachine do
    defSmoothPaletteFile := GetInputArgAsString(0);
end;

procedure TScriptEditor.GetNumTries(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(NumTries);
end;

procedure TScriptEditor.SetNumTries(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v > 0) and (v <= 100) then NumTries := v;
  end;
end;

procedure TScriptEditor.GetTryLength(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(TryLength);
end;

procedure TScriptEditor.SetTryLength(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 100) and (v <= 1000000) then TryLength := v;
  end;
end;

procedure TScriptEditor.GetConfirmDelete(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(ConfirmDelete);
end;

procedure TScriptEditor.SetConfirmDelete(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ConfirmDelete := GetInputArgAsBoolean(0);
end;

procedure TScriptEditor.GetFixedReference(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(true); //ReferenceMode = 0);
end;

procedure TScriptEditor.SetFixedReference(AMachine: TatVirtualMachine);
begin
//  with AMachine do
//    if GetInputArgAsBoolean(0) then ReferenceMode := 0
//    else ReferenceMode := 1;
end;

procedure TScriptEditor.GetSampleDensity(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(defSampleDensity);
end;

procedure TScriptEditor.SetSampleDensity(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if (v >= 0.1) and (v <= 100) then defSampleDensity := v;
  end;
end;

procedure TScriptEditor.GetGamma(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(defGamma);
end;

procedure TScriptEditor.SetGamma(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if (v >= 0.1) and (v <= 100) then defGamma := v;
  end;
end;

procedure TScriptEditor.GetBrightness(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(defBrightness);
end;

procedure TScriptEditor.SetBrightness(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if (v >= 0.1) and (v <= 100) then defBrightness := v;
  end;
end;

procedure TScriptEditor.GetVibrancy(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(defVibrancy);
end;

procedure TScriptEditor.SetVibrancy(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if (v >= 0) and (v <= 100) then defVibrancy := v;
  end;
end;

procedure TScriptEditor.GetOversample(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(defOversample);
end;

procedure TScriptEditor.SetOversample(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 1) and (v <= 4) then defOversample := v;
  end;
end;

procedure TScriptEditor.GetFilterRadius(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(defFilterRadius);
end;

procedure TScriptEditor.SetFilterRadius(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if (v >= 0.1) then defFilterRadius := v;
  end;
end;

procedure TScriptEditor.GetTransparency(AMachine: TatVirtualMachine);
begin
  AMachine.ReturnOutPutArg(PNGTransparency);
end;

procedure TScriptEditor.SetTransparency(AMachine: TatVirtualMachine);
var
  v: double;
begin
  if AMachine.GetInputArgAsInteger(0) = 0 then
    PNGTransparency := 0
  else
    PNGTransparency := 1;
end;

procedure TScriptEditor.GetLowQuality(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(prevLowQuality);
end;

procedure TScriptEditor.SetLowQuality(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if (v >= 0.01) and (v <= 100) then prevLowQuality := v;
  end;
end;

procedure TScriptEditor.GetMediumQuality(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(prevMediumQuality);
end;

procedure TScriptEditor.SetMediumQuality(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if (v >= 0.01) and (v <= 100) then prevMediumQuality := v;
  end;
end;

procedure TScriptEditor.GetHighQuality(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(prevHighQuality);
end;

procedure TScriptEditor.SetHighQuality(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if (v >= 0.01) and (v <= 100) then prevHighQuality := v;
  end;
end;

procedure TScriptEditor.GetMinTransforms(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(randMinTransforms);
end;

procedure TScriptEditor.SetMinTransforms(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 2) and (v <= NXFORMS) and (v <= randMaxTransforms) then randMinTransforms := v;
  end;
end;

procedure TScriptEditor.GetMaxTransforms(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(randMaxTransforms);
end;

procedure TScriptEditor.SetMaxTransforms(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 2) and (v <= NXFORMS) and (v >= randMinTransforms) then randMaxTransforms := v;
  end;
end;

procedure TScriptEditor.GetMutateMinTransforms(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(mutantMinTransforms);
end;

procedure TScriptEditor.SetMutateMinTransforms(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 2) and (v <= NXFORMS) and (v <= mutantMaxTransforms) then mutantMinTransforms := v;
  end;
end;

procedure TScriptEditor.GetMutateMaxTransforms(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(mutantMaxTransforms);
end;

procedure TScriptEditor.SetMutateMaxTransforms(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 2) and (v <= NXFORMS) and (v >= mutantMinTransforms) then mutantMaxTransforms := v;
  end;
end;

procedure TScriptEditor.GetPrefix(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(RandomPrefix);
end;

procedure TScriptEditor.SetPrefix(AMachine: TatVirtualMachine);
begin
  with AMachine do
    RandomPrefix := GetInputArgAsString(0);
end;

procedure TScriptEditor.GetKeepBackground(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(KeepBackground);
end;

procedure TScriptEditor.SetKeepBackground(AMachine: TatVirtualMachine);
begin
  with AMachine do
    KeepBackground := GetInputArgAsBoolean(0);
end;

procedure TScriptEditor.GetSymmetryType(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(SymmetryType);
end;

procedure TScriptEditor.SetSymmetryType(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 0) and (v <= 3) then SymmetryType := v;
  end;
end;

procedure TScriptEditor.GetSymmetryOrder(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(SymmetryOrder);
end;

procedure TScriptEditor.SetSymmetryOrder(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 2) and (v <= 2000) then SymmetryOrder := v;
  end;
end;

procedure TScriptEditor.GetVariations(AMachine: TatVirtualMachine);
var
  I: Integer;
begin
  with AMachine do
  begin
    i := GetArrayIndex(0);
    if (i >= 0) and (i < NRVAR) then
      ReturnOutPutArg(Variations[i]);
  end;
end;

procedure TScriptEditor.SetVariations(AMachine: TatVirtualMachine);
var
  v: boolean;
  i, vars: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsBoolean(0);
    i := GetArrayIndex(0);
    if (i >= 0) and (i < NRVAR) then
    begin
      Variations[i] := v;
{
      vars := PackVariations;
      if vars <> 0 then
        VariationOptions := vars
      else
        VariationOptions := 1;
}
    end;

  end;
end;

procedure TScriptEditor.GetRandomGradient(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(randGradient);
end;

procedure TScriptEditor.SetRandomGradient(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 0) and (v <= 3) then randGradient := v;
  end;
end;

procedure TScriptEditor.GetMinNodes(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(MinNodes);
end;

procedure TScriptEditor.SetMinNodes(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 2) and (v <= 64) and (v <= MaxNodes) then MinNodes := v;
  end;
end;

procedure TScriptEditor.GetMaxNodes(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(MaxNodes);
end;

procedure TScriptEditor.SetMaxNodes(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 2) and (v <= 64) and (v >= MinNodes) then MaxNodes := v;
  end;
end;

procedure TScriptEditor.GetMinHue(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(MinHue);
end;

procedure TScriptEditor.SetMinHue(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 0) and (v <= 600) and (v <= MaxHue) then MinHue := v;
  end;
end;

procedure TScriptEditor.GetMaxHue(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(MaxHue);
end;

procedure TScriptEditor.SetMaxHue(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 0) and (v <= 600) and (v >= MinHue) then MaxHue := v;
  end;
end;


procedure TScriptEditor.GetMinSat(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(MinSat);
end;

procedure TScriptEditor.SetMinSat(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 0) and (v <= 100) and (v <= MaxSat) then MinSat := v;
  end;
end;

procedure TScriptEditor.GetMaxSat(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(MaxSat);
end;

procedure TScriptEditor.SetMaxSat(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 0) and (v <= 100) and (v >= MinSat) then MaxSat := v;
  end;
end;

procedure TScriptEditor.GetMinLum(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(MinLum);
end;

procedure TScriptEditor.SetMinLum(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 0) and (v <= 100) and (v <= MaxLum) then MinLum := v;
  end;
end;

procedure TScriptEditor.GetMaxLum(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(MaxLum);
end;

procedure TScriptEditor.SetMaxLum(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 0) and (v <= 100) and (v >= MinLum) then MaxLum := v;
  end;
end;

procedure TScriptEditor.GetUPRSampleDensity(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(UPRSampleDensity);
end;

procedure TScriptEditor.SetUPRSampleDensity(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v > 0) then UPRSampleDensity := v;
  end;
end;

procedure TScriptEditor.GetUPROversample(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(UPROversample);
end;

procedure TScriptEditor.SetUPROversample(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v > 0) then UPROversample := v;
  end;
end;

procedure TScriptEditor.GetUPRFilterRadius(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(UPRFilterRadius);
end;

procedure TScriptEditor.SetUPRFilterRadius(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if (v > 0) then UPRFilterRadius := v;
  end;
end;

procedure TScriptEditor.GetUPRColoringIdent(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(UPRColoringIdent);
end;

procedure TScriptEditor.SetUPRColoringIdent(AMachine: TatVirtualMachine);
begin
  with AMachine do
    UPRColoringIdent := GetInputArgAsString(0);
end;

procedure TScriptEditor.GetUPRColoringFile(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(UPRColoringFile);
end;

procedure TScriptEditor.SetUPRColoringFile(AMachine: TatVirtualMachine);
begin
  with AMachine do
    UPRColoringFile := GetInputArgAsString(0);
end;

procedure TScriptEditor.GetUPRFormulaFile(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(UPRFormulaFile);
end;

procedure TScriptEditor.SetUPRFormulaFile(AMachine: TatVirtualMachine);
begin
  with AMachine do
    UPRFormulaFile := GetInputArgAsString(0);
end;

procedure TScriptEditor.GetUPRFormulaIdent(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(UPRFormulaIdent);
end;

procedure TScriptEditor.SetUPRFormulaIdent(AMachine: TatVirtualMachine);
begin
  with AMachine do
    UPRFormulaIdent := GetInputArgAsString(0);
end;

procedure TScriptEditor.GetUPRAdjustDensity(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(UPRAdjustDensity);
end;

procedure TScriptEditor.SetUPRAdjustDensity(AMachine: TatVirtualMachine);
begin
  with AMachine do
    UPRAdjustDensity := GetInputArgAsBoolean(0);
end;

procedure TScriptEditor.GetUPRWidth(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(UPRWidth);
end;

procedure TScriptEditor.SetUPRWidth(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v > 0) then UPRWidth := v;
  end;
end;

procedure TScriptEditor.GetUPRHeight(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(UPRHeight);
end;

procedure TScriptEditor.SetUPRHeight(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v > 0) then UPRHeight := v;
  end;
end;

procedure TScriptEditor.GetExportPath(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(flam3Path);
end;

procedure TScriptEditor.SetExportPath(AMachine: TatVirtualMachine);
begin
  with AMachine do
    flam3Path := GetInputArgAsString(0);
end;

{ ***************************** Operation Library **************************** }

procedure TOperationLibrary.Init;
begin
  Scripter.DefineMethod('RotateFlame', 1, tkNone, nil, RotateFlameProc);
  Scripter.DefineMethod('RotateReference', 1, tkNone, nil, RotateReferenceProc);
  Scripter.DefineMethod('Rotate', 1, tkNone, nil, RotateProc);
  Scripter.DefineMethod('Multiply', 4, tkNone, nil, MulProc);
  Scripter.DefineMethod('StoreFlame', 1, tkNone, nil, StoreFlameProc);
  Scripter.DefineMethod('GetFlame', 1, tkNone, nil, GetFlameProc);
  Scripter.DefineMethod('LoadFlame', 1, tkNone, nil, LoadFlameProc);
  Scripter.DefineMethod('Scale', 1, tkNone, nil, ScaleProc);
  Scripter.DefineMethod('Translate', 2, tkNone, nil, TranslateProc);
//  Scripter.DefineMethod('ActiveTransform', 0, tkInteger, nil, GetActiveTransformProc);
  Scripter.DefineProp('ActiveTransform', tkInteger, GetActiveTransformProc, SetActiveTransformProc);
  Scripter.DefineMethod('SetActiveTransform', 1, tkInteger, nil, SetActiveTransformProc);
  Scripter.DefineMethod('Transforms', 0, tkInteger, nil, TransformsProc);
  Scripter.DefineMethod('FileCount', 0, tkInteger, nil, FileCountProc);
  Scripter.DefineMethod('AddTransform', 0, tkNone, nil, AddTransformProc);
  Scripter.DefineMethod('DeleteTransform', 0, tkNone, nil, DeleteTransformProc);
  Scripter.DefineMethod('CopyTransform', 0, tkNone, nil, CopyTransformProc);
  Scripter.DefineMethod('Clear', 0, tkNone, nil, ClearProc);
  Scripter.DefineMethod('Preview', 0, tkNone, nil, PreviewProc);
  Scripter.DefineMethod('Render', 0, tkNone, nil, RenderProc);
  Scripter.DefineMethod('Print', 1, tkNone, nil, Print);
  Scripter.DefineMethod('AddSymmetry', 1, tkNone, nil, AddSymmetryProc);
  Scripter.DefineMethod('Morph', 3, tkNone, nil, MorphProc);
  Scripter.DefineMethod('SetRenderBounds', 0, tkNone, nil, SetRenderBounds);
  Scripter.DefineMethod('SetFlameFile', 1, tkNone, nil, SetParamFileProc);
  Scripter.DefineMethod('ListFile', 1, tkNone, nil, ListFileProc);
  Scripter.DefineMethod('SaveFlame', 1, tkNone, nil, SaveFlameProc);
  Scripter.DefineMethod('GetFileName', 0, tkString, nil, GetFileName);
  Scripter.DefineMethod('ShowStatus', 1, tkNone, nil, ShowStatusProc);
  Scripter.DefineMethod('RandomFlame', 1, tkNone, nil, RandomFlame);
  Scripter.DefineMethod('RandomGradient', 0, tkNone, nil, RandomGradientProc);
  Scripter.DefineMethod('SaveGradient', 2, tkNone, nil, SaveGradientProc);
  Scripter.DefineMethod('Variation', 0, tkInteger, nil, GetVariation);
  Scripter.DefineMethod('SetVariation', 1, tkInteger, nil, SetVariation);

  Scripter.AddConstant('ProgramVersionString', AppVersionString);
  Scripter.DefineMethod('VariationIndex', 1, tkInteger, nil, VariationIndexProc);
  Scripter.DefineMethod('VariationName', 1, tkString, nil, VariationNameProc);
  Scripter.DefineMethod('VariableIndex', 1, tkInteger, nil, VariableIndexProc);
  Scripter.DefineMethod('VariableName', 1, tkString, nil, VariableNameProc);

  Scripter.DefineMethod('CalculateScale', 0, tkNone, nil, CalculateScale);
  Scripter.DefineMethod('CalculateBounds', 0, tkNone, nil, CalculateBounds);
  Scripter.DefineMethod('NormalizeVars', 0, tkNone, nil, NormalizeVars);
  Scripter.DefineMethod('GetSaveFileName', 0, tkString, nil, GetSaveFileName);
  Scripter.DefineMethod('CopyFile', 2, tkString, nil, CopyFileProc);

  //Scripter.DefineMethod('StrToFloat', 1, tkFloat, nil, StrToFloatProc);

  //Scripter.DefineMethod('BM_Open', 1, tkInteger, nil, BM_OpenProc);
  //Scripter.DefineMethod('BM_DllCFunc', 2, tkInteger, nil, BM_DllCFuncProc);
end;

procedure TOperationLibrary.RandomFlame(AMachine: TatVirtualMachine);
var
  i: integer;
begin
  try
    i := AMachine.GetInputArgAsInteger(0);
    MainForm.RandomizeCP(ScriptEditor.cp, i);
    for i := 0 to NXFORMS - 1 do
      if ScriptEditor.cp.xform[i].density = 0 then break;
    NumTransforms := i;
  except on E: EMathError do
  end;
end;

procedure TOperationLibrary.RandomGradientProc(AMachine: TatVirtualMachine);
begin
  ScriptEditor.cp.cmap := GradientHelper.RandomGradient;
end;

procedure TOperationLibrary.CalculateScale(AMachine: TatVirtualMachine);
var
  x, y: double;
begin
  x := ScriptEditor.cp.center[0];
  y := ScriptEditor.cp.center[1];
  ScriptEditor.cp.CalcBoundBox;
  ScriptEditor.cp.center[0] := x;
  ScriptEditor.cp.center[1] := y
end;

procedure TOperationLibrary.CalculateBounds(AMachine: TatVirtualMachine);
begin
  ScriptEditor.cp.CalcBoundBox;
end;


procedure TOperationLibrary.SetRenderBounds(AMachine: TatVirtualMachine);
begin
  ScriptRenderForm.SetRenderBounds;
end;

procedure TOperationLibrary.GetFileName(AMachine: TatVirtualMachine);
begin
  if ScriptEditor.OpenDialog.Execute then
    with AMachine do
      ReturnOutputArg(ScriptEditor.OpenDialog.Filename)
  else
  begin
    LastError := 'Invalid file name.';
    AMachine.Halt;
  end;
end;

procedure TOperationLibrary.GetSaveFileName(AMachine: TatVirtualMachine);
begin
  if ScriptEditor.SaveDialog.Execute then
    with AMachine do
      ReturnOutputArg(ScriptEditor.SaveDialog.Filename)
  else
  begin
    LastError := 'Invalid file name.';
    AMachine.Halt;
  end;
end;

procedure TOperationLibrary.CopyFileProc(AMachine: TatVirtualMachine);
var
  src, dest: string;
  FileList: TStringList;
begin
  src := AMachine.GetInputArgAsString(0);
  dest := AMachine.GetInputArgAsString(1);
  FileList := TStringList.Create;
  try

    if FileExists(src) then
    begin
      FileList.LoadFromFile(src);
      try
        FileList.SaveToFile(dest);
      except
        LastError := 'Cannot copy file';
        AMachine.Halt;
      end;

    end
    else

    begin
      LastError := 'Cannot copy file';
      AMachine.Halt;
    end;

  finally
    FileList.free;
  end;
end;

(*procedure TOperationLibrary.BM_OpenProc(AMachine: TatVirtualMachine);
var
  Name: string;
begin
  Name := AMachine.GetInputArgAsString(0);

  if @bmdll32.Open <> nil then begin
    AMachine.ReturnOutputArg(bmdll32.Open(Pchar(Name)));
  end else begin
    LastError := 'bmdll32.dll not loaded';
    AMachine.Halt;
  end;
end; *)

(*procedure TOperationLibrary.BM_DllCFuncProc(AMachine: TatVirtualMachine);
var
  var1, var2: Integer;
begin
  var1 := AMachine.GetInputArgAsInteger(0);
  var2 := AMachine.GetInputArgAsInteger(1);

  if @bmdll32.DllCFunc <> nil then begin
    AMachine.ReturnOutputArg(bmdll32.DllCFunc(var1, var2));
  end else begin
    LastError := 'bmdll32.dll not loaded';
    AMachine.Halt;
  end;
end; *)

procedure TOperationLibrary.SetParamFileProc(AMachine: TatVirtualMachine);
var
  filen: string;
begin
  filen := AMachine.GetInputArgAsString(0);
  if FileExists(filen) then
  begin
    ParamFile := filen;
    ScriptEditor.FillFileList;
  end
  else
  begin
    LastError := 'Parameter file does not exist.';
    AMachine.Halt;
  end;
end;

procedure TOperationLibrary.RotateProc(AMachine: TatVirtualMachine);
begin
  try
    if (ActiveTransform < 0) or (ActiveTransform > NXFORMS) then raise EFormatInvalid.Create(ErrorOutOfRange);
    with AMachine do
      ScriptEditor.cp.xform[ActiveTransform].Rotate(GetInputArgAsFloat(0));
  except on E: EFormatInvalid do
    begin
      ScriptEditor.Console.Lines.Add('Rotate: ' + E.message);
      Application.ProcessMessages;
      LastError := E.Message;
    end;
  end;
end;

procedure TOperationLibrary.MulProc(AMachine: TatVirtualMachine);
begin
  try
    if (ActiveTransform < 0) or (ActiveTransform > NXFORMS) then raise EFormatInvalid.Create(ErrorOutOfRange);
    with AMachine do
      ScriptEditor.cp.xform[ActiveTransform].Multiply(GetInputArgAsFloat(0), GetInputArgAsFloat(1), GetInputArgAsFloat(2), GetInputArgAsFloat(3));
  except on E: EFormatInvalid do
    begin
      ScriptEditor.Console.Lines.Add('Multiply: ' + E.message);
      Application.ProcessMessages;
      LastError := E.Message;
    end;
  end;
end;

procedure TOperationLibrary.Print(AMachine: TatVirtualMachine);
begin
  ScriptEditor.Console.Lines.Add(AMachine.GetInputArg(0));
  Application.ProcessMessages;
end;

procedure TOperationLibrary.ShowStatusProc(AMachine: TatVirtualMachine);
begin
  MainForm.StatusBar.Panels[0].Text := AMachine.GetInputArg(0);
  Application.ProcessMessages;
end;


procedure TOperationLibrary.SaveFlameProc(AMachine: TatVirtualMachine);
var
  filename: string;
begin
  with AMachine do
  begin
    filename := GetInputArgAsString(0);
    (*if (LowerCase(ExtractFileExt(filename)) = '.apo') or
      (LowerCase(ExtractFileExt(filename)) = '.fla') then
      MainForm.SaveFlame(ScriptEditor.cp, ScriptEditor.cp.name, filename)
    else  *)
      MainForm.SaveXMLFlame(ScriptEditor.cp, ScriptEditor.cp.name, filename)
  end;
end;

procedure TOperationLibrary.SaveGradientProc(AMachine: TatVirtualMachine);
var
  gradstr: TStringList;
begin
  gradstr := TStringList.Create;
  try
    gradstr.add(CleanIdentifier(AMachine.GetInputArgAsString(1)) + ' {');
    gradstr.add(MainForm.GradientFromPalette(ScriptEditor.cp.cmap, AMachine.GetInputArgAsString(1)));
    gradstr.add('}');
    MainForm.SaveGradient(gradstr.text, AMachine.GetInputArgAsString(1), AMachine.GetInputArgAsString(0))
  finally
    gradstr.free
  end;
end;

procedure TOperationLibrary.ListFileProc(AMachine: TatVirtualMachine);
var
  flafile: string;
begin
  flafile := AMachine.GetInputArgAsString(0);
  if FileExists(flafile) then
  begin
    OpenFile := flafile;
    MainForm.Caption := AppVersionString + ' - ' + OpenFile;
    (*if (LowerCase(ExtractFileExt(flafile)) = '.apo') or
      (LowerCase(ExtractFileExt(flafile)) = '.fla') then
    begin
      ListIFS(OpenFile, 1);
      OpenFileType := ftFla
    end
    else
    begin*)
      ListXML(OpenFile, 1);
      OpenFileType := ftXML;
    //end;
    MainForm.SetFocus;
  end
  else
  begin
    LastError := 'Cannot open file: ' + Flafile;
    AMachine.Halt;
  end;
end;

procedure TOperationLibrary.StoreFlameProc(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  v := AMachine.GetInputArgAsInteger(0);
  if (v >= 0) and (v < NCPS) then
  begin
    cps[v].copy(ScriptEditor.cp);
    cps[v].cmap := ScriptEditor.cp.cmap;
  end;
end;

procedure TOperationLibrary.GetFlameProc(AMachine: TatVirtualMachine);
var
  i, v: integer;
begin
  v := AMachine.GetInputArgAsInteger(0);
  if (v >= 0) and (v < NCPS) then
  begin
    ScriptEditor.cp.copy(cps[v]);
    ScriptEditor.cp.cmap := cps[v].cmap;
  end;
  for i := 0 to NXFORMS - 1 do
    if ScriptEditor.cp.xform[i].density = 0 then break;
  NumTransforms := i;
end;

(*
procedure ParseXML(var cp1: TControlPoint; const params: PCHAR);
var
  i: integer;
  h, s, v: real;
begin
  nxform := 0;
  FinalXformLoaded := false;
  MainForm.XMLScanner.LoadFromBuffer(params);
  MainForm.XMLScanner.Execute;
  cp1.copy(ParseCp);
  if Parsecp.cmapindex <> -1 then
  begin
    if cp1.cmapindex < NRCMAPS then
      GetCMap(cp1.cmapindex, 1, cp1.cmap)
    else
      ShowMessage('Palette index too high');
  end;
  if (cp1.hue_rotation > 0) and (cp1.hue_rotation < 1) then
  begin
    for i := 0 to 255 do
    begin
      RGBToHSV(cp1.cmap[i][0], cp1.cmap[i][1], cp1.cmap[i][2], h, s, v);
      h := Round(360 + h + (cp1.hue_rotation * 360)) mod 360;
      HSVToRGB(h, s, v, cp1.cmap[i][0], cp1.cmap[i][1], cp1.cmap[i][2]);
    end;
  end;
  if nxform < NXFORMS then
    for i := nxform to NXFORMS - 1 do
      cp1.xform[i].density := 0;
  // Check for symmetry parameter
  if cp1.symmetry <> 0 then
  begin
    add_symmetry_to_control_point(cp1, cp1.symmetry);
    cp1.symmetry := 0;
  end;
end;
*)

procedure LoadXMLFlame(index: integer);
var
  FStrings: TStringList;
  IFSStrings: TStringList;
  EntryStrings, Tokens: TStringList;
  i: integer;
begin
  FStrings := TStringList.Create;
  IFSStrings := TStringList.Create;
  Tokens := TStringList.Create;
  EntryStrings := TStringList.Create;
  try
    FStrings.LoadFromFile(ParamFile);

    for i := 0 to FStrings.count - 1 do
    begin
      if Pos('<flame ', Trim(FStrings[i])) = 1 then
      begin
        MainForm.ListXMLScanner.LoadFromBuffer(PANSICHAR(AnsiString(FStrings[i])));
        MainForm.ListXMLScanner.Execute;
        if FileList[index] = (pname) then
          break;
      end;
    end;
    IFSStrings.Add(FStrings[i]);
    repeat
      inc(i);
      IFSStrings.Add(FStrings[i]);
    until Pos('</flame>', FStrings[i]) <> 0;
    MainForm.ParseXML(ScriptEditor.Cp, IFSStrings.Text, true);
    for i := 0 to NXFORMS - 1 do
      if ScriptEditor.cp.xform[i].density = 0 then break;
    NumTransforms := i;
//    FlameName := FileList[index];
  finally
    IFSStrings.Free;
    FStrings.Free;
    Tokens.free;
    EntryStrings.free;
  end;
end;

procedure LoadFlame(index: integer);
var
  FStrings: TStringList;
  IFSStrings: TStringList;
  EntryStrings, Tokens: TStringList;
  SavedPal: Boolean;
  i, j: integer;
  FlameString, s: string;
  Palette: TcolorMap;
//  x, y: double;
begin
  SavedPal := false;
  FStrings := TStringList.Create;
  IFSStrings := TStringList.Create;
  Tokens := TStringList.Create;
  EntryStrings := TStringList.Create;
  try
    FStrings.LoadFromFile(ParamFile);
    for i := 0 to FStrings.count - 1 do
      if Pos(FileList[index] + ' ', Trim(FStrings[i])) = 1 then
        break;
    IFSStrings.Add(FStrings[i]);
    repeat
      inc(i);
      IFSStrings.Add(FStrings[i]);
    until Pos('}', FStrings[i]) <> 0;
    ScriptEditor.cp.Clear; // initialize control point for new flame;
    ScriptEditor.cp.background[0] := 0;
    ScriptEditor.cp.background[1] := 0;
    ScriptEditor.cp.background[2] := 0;
    ScriptEditor.cp.sample_density := defSampleDensity;
    ScriptEditor.cp.spatial_oversample := defOversample;
    ScriptEditor.cp.spatial_filter_radius := defFilterRadius;
    for i := 0 to FStrings.count - 1 do
    begin
      if Pos(Lowercase(FileList[index]) + ' ', Trim(Lowercase(FStrings[i]))) = 1 then
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
        GetTokens(s, Tokens);
        Palette[j][0] := StrToInt(Tokens[0]);
        Palette[j][1] := StrToInt(Tokens[1]);
        Palette[j][2] := StrToInt(Tokens[2]);
        inc(i);
      end;
    end;
    FlameString := EntryStrings.Text;
    ScriptEditor.cp.ParseString(FlameString);
    for i := 0 to NXFORMS - 1 do
      if ScriptEditor.cp.xform[i].density = 0 then break;
    NumTransforms := i;
    if SavedPal then ScriptEditor.cp.cmap := Palette;
    ScriptEditor.cp.name := FileList[index];
  finally
    IFSStrings.Free;
    FStrings.Free;
    Tokens.free;
    EntryStrings.free;
  end;
end;

procedure TOperationLibrary.LoadFlameProc(AMachine: TatVirtualMachine);
var
  i: integer;
begin
  i := AMachine.GetInputArgAsInteger(0);
  if (i >= 0) and (i < FileList.count) then
  begin
    (*if (LowerCase(ExtractFileExt(ParamFile)) = '.fla') or
      (LowerCase(ExtractFileExt(ParamFile)) = '.apo') then
      LoadFlame(i)
    else*)
      LoadXMLFlame(i); ;
  end;
end;

procedure TOperationLibrary.RotateFlameProc(AMachine: TatVirtualMachine);
var
  Triangles: TTriangles;
  i: integer;
  r: double;
begin
  ScriptEditor.cp.TrianglesFromCp(Triangles);
  r := AMachine.GetInputArgAsFloat(0) * pi / 180;
  for i := -1 to NumTransforms - 1 do
  begin
    Triangles[i] := RotateTriangle(Triangles[i], r);
  end;
  ScriptEditor.cp.GetFromTriangles(Triangles, NumTransforms);
end;

procedure TOperationLibrary.AddSymmetryProc(AMachine: TatVirtualMachine);
var
  i: integer;
begin
  add_symmetry_to_control_point(ScriptEditor.cp, AMachine.GetInputArgAsInteger(0));
  for i := 0 to NXFORMS - 1 do
    if ScriptEditor.cp.xform[i].density = 0 then break;
  NumTransforms := i;
end;

procedure TOperationLibrary.RotateReferenceProc(AMachine: TatVirtualMachine);
var
  Triangles: TTriangles;
  r: double;
  tx: TXForm;
begin
  tx := TXForm.Create;
  tx.Assign(scripteditor.cp.xform[NumTransforms]);
  ScriptEditor.cp.TrianglesFromCp(Triangles);
  r := AMachine.GetInputArgAsFloat(0) * pi / 180;
  Triangles[-1] := RotateTriangle(Triangles[-1], r);
  ScriptEditor.cp.GetFromTriangles(Triangles, NumTransforms);
  scripteditor.cp.xform[NumTransforms].Assign(tx);
  tx.Free;
end;

procedure TOperationLibrary.ScaleProc(AMachine: TatVirtualMachine);
begin
  try
    if (ActiveTransform < 0) or (ActiveTransform >= ScriptEditor.cp.NumXForms) then raise EFormatInvalid.Create(ErrorOutOfRange);
    with AMachine do
      ScriptEditor.cp.xform[ActiveTransform].Scale(GetInputArgAsFloat(0));
  except on E: EFormatInvalid do
    begin
      ScriptEditor.Console.Lines.Add('Scale: ' + E.message);
      Application.ProcessMessages;
      LastError := E.Message;
    end;
  end;
end;

procedure TOperationLibrary.GetActiveTransformProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutputArg(ActiveTransform);
end;

procedure TOperationLibrary.TransformsProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutputArg(NumTransforms);
end;

procedure TOperationLibrary.GetVariation(AMachine: TatVirtualMachine);
var
  i: integer;
begin
  with AMachine do
  begin
    i := integer(Variation);
    if (i >= NRVAR) or (i < 0) then
      i := -1;
    ReturnOutputArg(i);
  end
end;

procedure TOperationLibrary.SetVariation(AMachine: TatVirtualMachine);
var
  i: integer;
begin
  with AMachine do
  begin
    i := GetInputArgAsInteger(0);
    if (i < 0) or (i >= NRVAR) then
      i := NRVAR ;
    Variation := TVariation(i);
    if i = NRVAR then
      MainForm.mnuVRandom.checked := True
    else
      MainForm.VarMenus[i].Checked := True;
  end
end;

procedure TOperationLibrary.VariationIndexProc(AMachine: TatVirtualMachine);
var
  i: integer;
  str: string;
begin
  with AMachine do begin
    str := LowerCase(GetInputArgAsString(0));
    i := NRVAR-1;
    while (i >= 0) and (LowerCase(varnames(i)) <> str) do Dec(i);
    ReturnOutputArg(i);
  end;
end;

procedure TOperationLibrary.VariationNameProc(AMachine: TatVirtualMachine);
var
  i: integer;
  str: string;
begin
  with AMachine do begin
    i := GetInputArgAsInteger(0);
    if (i >= 0) and (i < NRVAR) then
      ReturnOutputArg(varnames(i))
    else
      ReturnOutputArg('');
  end;
end;

procedure TOperationLibrary.VariableIndexProc(AMachine: TatVirtualMachine);
var
  i: integer;
  str: string;
begin
  with AMachine do begin
    str := LowerCase(GetInputArgAsString(0));
    i := GetNrVariableNames-1;
    while (i >= 0) and (LowerCase(GetVariableNameAt(i)) <> str) do Dec(i);
    ReturnOutputArg(i);
  end;
end;

procedure TOperationLibrary.VariableNameProc(AMachine: TatVirtualMachine);
var
  i: integer;
  str: string;
begin
  with AMachine do begin
    i := GetInputArgAsInteger(0);
    if (i >= 0) and (i < GetNrVariableNames) then
      ReturnOutputArg(GetVariableNameAt(i))
    else
      ReturnOutputArg('');
  end;
end;

procedure TOperationLibrary.FileCountProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutputArg(FileList.Count);
end;

procedure TOperationLibrary.ClearProc(AMachine: TatVirtualMachine);
var
  i: integer;
begin
  NumTransforms := 0;
  ActiveTransform := -1;
{
  for i := 0 to NXFORMS - 1 do
    ScriptEditor.cp.xform[i].density := 0;
}
  ScriptEditor.cp.Clear;
  ScriptEditor.cp.xform[0].symmetry := 1;
end;

procedure TOperationLibrary.MorphProc(AMachine: TatVirtualMachine);
var
  a, b, i: integer;
  v: double;
begin
  with AMachine do
  begin
    a := GetInputArgAsInteger(0);
    b := GetInputArgAsInteger(1);
    v := GetInputArgAsFloat(2);
    if (a >= 0) and (a < NCPS) and (b >= 0) and (b < NCPS) then
    begin
      ScriptEditor.cp.InterpolateX(cps[a], cps[b], v);
      for i := 0 to NXFORMS - 1 do
        if ScriptEditor.cp.xform[i].density = 0 then break;
      NumTransforms := i;
    end;
  end;
end;

procedure TOperationLibrary.PreviewProc(AMachine: TatVirtualMachine);
begin
  if NumTransforms > 0 then
  begin
    AMachine.Paused := True;
    PreviewForm.cp.Copy(ScriptEditor.cp);
    PreviewForm.cp.AdjustScale(PreviewForm.Image.Width, PreviewForm.Image.Height);
    PreviewForm.Show;
    PreviewForm.DrawFlame;
    AMachine.Paused := False;
    Application.ProcessMessages;
  end
  else AMachine.Halt;
end;

procedure TOperationLibrary.RenderProc(AMachine: TatVirtualMachine);
begin
  if NumTransforms > 0 then
  begin
    ScriptRenderForm.cp.Copy(ScriptEditor.cp);
    //ScriptRenderForm.Caption := 'Rendering ' + ScriptEditor.Renderer.Filename; ;
    ScriptRenderForm.Show;
    ScriptRenderForm.Render;
  end
  else AMachine.Halt;
end;

procedure TOperationLibrary.SetActiveTransformProc(AMachine: TatVirtualMachine);
var
  i: integer;
begin
  try
    with AMachine do
      i := GetInputArgAsInteger(0);
    if (i >= 0) and (i < NXFORMS) then
      ActiveTransform := i
    else raise EFormatInvalid.Create(ErrorOutOfRange);
  except on E: EFormatInvalid do
    begin
      Application.ProcessMessages;
      LastError := E.Message;
      Scripter.Halt;
    end;
  end;
end;

procedure TOperationLibrary.AddTransformProc(AMachine: TatVirtualMachine);
var
  i: integer;
begin
  try
    if NumTransforms < NXFORMS then
    begin
      ActiveTransform := NumTransforms;
      inc(NumTransforms);
      scriptEditor.cp.xform[NumTransforms].Assign(scriptEditor.cp.xform[ActiveTransform]);
{      ScriptEditor.cp.xform[ActiveTransform].c[0, 0] := 1;
      ScriptEditor.cp.xform[ActiveTransform].c[0, 1] := 0;
      ScriptEditor.cp.xform[ActiveTransform].c[1, 0] := 0;
      ScriptEditor.cp.xform[ActiveTransform].c[1, 1] := 1;
      ScriptEditor.cp.xform[ActiveTransform].c[2, 0] := 0;
      ScriptEditor.cp.xform[ActiveTransform].c[2, 1] := 0;
      ScriptEditor.cp.xform[ActiveTransform].color := 0;
      ScriptEditor.cp.xform[ActiveTransform].density := 1 / NumTransforms;
      ScriptEditor.cp.xform[ActiveTransform].vars[0] := 1;
      for i := 1 to NRVAR - 1 do
        ScriptEditor.cp.xform[ActiveTransform].vars[i] := 0;}
      scriptEditor.cp.xform[ActiveTransform].Clear;
      ScriptEditor.cp.xform[ActiveTransform].density := 0.5;
    end
    else raise EFormatInvalid.Create('Too many transforms.');
  except on E: EFormatInvalid do
    begin
      Application.ProcessMessages;
      LastError := E.Message;
      Scripter.Halt;
    end;
  end;
end;

procedure TOperationLibrary.DeleteTransformProc(AMachine: TatVirtualMachine);
var
  i, j: integer;
begin
  try
    // I'm not sure, but *maybe* this will help scripts not to screw up finalXform
    if ActiveTransform = NumTransforms then
    // final xform - just clear it
    begin
      scriptEditor.cp.xform[NumTransforms].Clear;
      scriptEditor.cp.xform[NumTransforms].symmetry := 1;
      scriptEditor.cp.finalXformEnabled := false;
      exit;
    end;
    if NumTransforms <= 1 then exit;

    // delete xform from all probability tables
    for i := 0 to NumTransforms-1 do
    with scriptEditor.cp.xform[i] do begin
      for j := ActiveTransform to NumTransforms-1 do
        modWeights[j] := modWeights[j+1];
      modWeights[NumTransforms-1] := 1;
    end;
    //

    with scriptEditor.cp do begin
      if ActiveTransform = (NumTransforms - 1) then
        Dec(ActiveTransform)
      else begin
        for i := ActiveTransform to NumTransforms - 2 do
          xform[i].Assign(xform[i + 1]);
      end;
      Dec(NumTransforms);
      xform[NumTransforms].Assign(xform[NumTransforms+1]);
      xform[NumTransforms+1].Clear;
    end;
  except
    begin
      Application.ProcessMessages;
      LastError := 'Oops!';
      Scripter.Halt;
    end;
  end;
end;


procedure TOperationLibrary.CopyTransformProc(AMachine: TatVirtualMachine);
var
  old, i: integer;
begin
  try
    if NumTransforms < NXFORMS then
    with ScriptEditor.cp do
    begin
      old := ActiveTransform;
      ActiveTransform := NumTransforms;
      inc(NumTransforms);
      xform[NumTransforms].Assign(xform[ActiveTransform]); // final xform
      xform[ActiveTransform].Assign(xform[old]);

      for i := 0 to NumTransforms-1 do
        xform[i].modWeights[ActiveTransform] := xform[i].modWeights[old];
      xform[ActiveTransform].modWeights[ActiveTransform] := xform[old].modWeights[old];
    end
    else raise EFormatInvalid.Create('Too many transforms.');
  except on E: EFormatInvalid do
    begin
      Application.ProcessMessages;
      LastError := E.Message;
      Scripter.Halt;
    end;
  end;
end;

procedure TOperationLibrary.TranslateProc(AMachine: TatVirtualMachine);
begin
  try
    if (ActiveTransform < 0) or (ActiveTransform > NXFORMS) then // was: NXFORMS-1
      raise EFormatInvalid.Create(ErrorOutOfRange);
    with AMachine do
      ScriptEditor.cp.xform[ActiveTransform].Translate(GetInputArgAsFloat(0), GetInputArgAsFloat(1));
  except on E: EFormatInvalid do
    begin
      Application.ProcessMessages;
      LastError := E.Message;
      Scripter.Halt;
    end;
  end;
end;

procedure TOperationLibrary.NormalizeVars(AMachine: TatVirtualMachine);
begin
  NormalizeVariations(ScriptEditor.cp);
end;

{ ******************************** Math Library ****************************** }

procedure TMathLibrary.Init;
begin
  Scripter.DefineMethod('Cos', 1, tkfloat, nil, CosProc);
  Scripter.DefineMethod('Sin', 1, tkfloat, nil, SinProc);
end;

procedure TMathLibrary.CosProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutputArg(cos(GetInputArgAsFloat(0)));
end;

procedure TMathLibrary.SinProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutputArg(sin(GetInputArgAsFloat(0)));
end;

{ **************************** Matrix functions ******************************* }


function Mul33(M1, M2: TMatrix): TMatrix;
begin
  result[0, 0] := M1[0][0] * M2[0][0] + M1[0][1] * M2[1][0] + M1[0][2] * M2[2][0];
  result[0, 1] := M1[0][0] * M2[0][1] + M1[0][1] * M2[1][1] + M1[0][2] * M2[2][1];
  result[0, 2] := M1[0][0] * M2[0][2] + M1[0][1] * M2[1][2] + M1[0][2] * M2[2][2];
  result[1, 0] := M1[1][0] * M2[0][0] + M1[1][1] * M2[1][0] + M1[1][2] * M2[2][0];
  result[1, 1] := M1[1][0] * M2[0][1] + M1[1][1] * M2[1][1] + M1[1][2] * M2[2][1];
  result[1, 2] := M1[1][0] * M2[0][2] + M1[1][1] * M2[1][2] + M1[1][2] * M2[2][2];
  result[2, 0] := M1[2][0] * M2[0][0] + M1[2][1] * M2[1][0] + M1[2][2] * M2[2][0];
  result[2, 0] := M1[2][0] * M2[0][1] + M1[2][1] * M2[1][1] + M1[2][2] * M2[2][1];
  result[2, 0] := M1[2][0] * M2[0][2] + M1[2][1] * M2[1][2] + M1[2][2] * M2[2][2];
end;

function Identity: TMatrix;
var i, j: integer;
begin
  for i := 0 to 2 do
    for j := 0 to 2 do
      Result[i, j] := 0;
  Result[0][0] := 1;
  Result[1][1] := 1;
  Result[2][2] := 1;
end;

procedure init(var xform: Txform);
var
  i: integer;
begin
  xform.c[0, 0] := 1;
  xform.c[0, 1] := 0;
  xform.c[1, 0] := 0;
  xform.c[1, 1] := 1;
  xform.c[2, 0] := 0;
  xform.c[2, 1] := 0;
  xform.color := 0;
  xform.density := 1 / NumTransforms;
  xform.SetVariation(0, 1);
  for i := 1 to NRVAR - 1 do
    xform.SetVariation(i, 0);
end;

{ ************************************* Form ********************************* }

procedure TScriptEditor.FormCreate(Sender: TObject);
var
  i: integer;
begin
	self.Caption := TextByKey('script-title');
	btnBreak.Hint := TextByKey('script-break');
	btnNew.Hint := TextByKey('script-new');
	btnOpen.Hint := TextByKey('script-open');
	btnSave.Hint := TextByKey('script-save');
	btnRun.Hint := TextByKey('script-run');
	btnStop.Hint := TextByKey('script-stop');

  Transform := TTransform.create;
  FileList := TStringList.Create;
  Flame := TFlame.Create;
  Options := TOptions.Create;
  Pivot := TPivot.Create;
  Renderer := TScriptRender.create;
  Another := TScriptRender.create;
  cp := TControlPoint.create;
  for i := 0 to 9 do
    cps[i] := TControlPoint.create;
  ScriptEditor.PrepareScripter;
end;

procedure TScriptEditor.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  FileList.Free;
  Renderer.Free;
  Another.Free;
  for i := 0 to 9 do
    cps[i].free;
  cp.free;
  Flame.Free;
  Transform.Free;
  Options.Free;
  Pivot.Free;
end;

procedure TScriptEditor.FormShow(Sender: TObject);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('Software\' + APP_NAME + '\Forms\Script', False) then
    begin
    { Size and position }
      if Registry.ValueExists('Left') then
        ScriptEditor.Left := Registry.ReadInteger('Left');
      if Registry.ValueExists('Top') then
        ScriptEditor.Top := Registry.ReadInteger('Top');
      if Registry.ValueExists('Width') then
        ScriptEditor.Width := Registry.ReadInteger('Width');
      if Registry.ValueExists('Height') then
        ScriptEditor.Height := Registry.ReadInteger('Height');
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

procedure TScriptEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  Registry: TRegistry;
begin
  { Write position to registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    { Defaults }
    if Registry.OpenKey('\Software\' + APP_NAME + '\Forms\Script', True) then
    begin
      { Size and position }
      if ScriptEditor.WindowState <> wsMaximized then begin
        Registry.WriteInteger('Top', ScriptEditor.Top);
        Registry.WriteInteger('Left', ScriptEditor.Left);
        Registry.WriteInteger('Width', ScriptEditor.Width);
        Registry.WriteInteger('Height', ScriptEditor.Height);
      end;
    end;
  finally
    Registry.Free;
  end;
end;
{ ************************ Flame interface *********************************** }

{ The TFlame class is used only as an interface. The control point parameters
  are read and set directly. Parameter ranges aren't limited but values not
  in the correct range are ignored. }

procedure TScriptEditor.GetFlameGammaTresholdProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.gammaThreshRelative);
end;

procedure TScriptEditor.SetFlameGammaTresholdProc(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if (v > 0) then cp.gammaThreshRelative := v;
  end;
end;

procedure TScriptEditor.GetFlameGammaProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.Gamma);
end;

procedure TScriptEditor.SetFlameGammaProc(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if (v > 0) then cp.Gamma := v;
  end;
end;

procedure TScriptEditor.GetFlameBrightnessProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.Brightness);
end;

procedure TScriptEditor.SetFlameBrightnessProc(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if v > 0 then cp.Brightness := v;
  end;
end;

procedure TScriptEditor.GetFlameVibrancyProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.Vibrancy);
end;

procedure TScriptEditor.SetFlameVibrancyProc(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if v > 0 then cp.Vibrancy := v;
  end;
end;

procedure TScriptEditor.GetFlameTimeProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.Time);
end;

procedure TScriptEditor.SetFlameTimeProc(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if (v >= 0) then cp.Time := v;
  end;
end;

procedure TScriptEditor.GetFlameZoomProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.Zoom);
end;

procedure TScriptEditor.SetFlameZoomProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    cp.Zoom := GetInputArgAsFloat(0);
end;

procedure TScriptEditor.GetFlameXProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.center[0]);
end;

procedure TScriptEditor.SetFlameXProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    cp.center[0] := GetInputArgAsFloat(0);
end;


procedure TScriptEditor.GetFlameYProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.center[1]);
end;

procedure TScriptEditor.SetFlameYProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    cp.center[1] := GetInputArgAsFloat(0);
end;

procedure TScriptEditor.GetFlameDensityProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.sample_density);
end;

procedure TScriptEditor.SetFlameDensityProc(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if v >= 0 then cp.sample_density := v;
  end;
end;

procedure TScriptEditor.GetFlameOversampleProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.spatial_oversample);
end;

procedure TScriptEditor.SetFlameOversampleProc(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    { Range = 1 to 4 ... (document this) }
    if (v >= 1) and (v <= 4) then cp.spatial_oversample := v;
  end;
end;

procedure TScriptEditor.GetFlameFilterRadiusProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.spatial_filter_radius);
end;

procedure TScriptEditor.SetFlameFilterRadiusProc(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if v >= 0 then cp.spatial_filter_radius := v;
  end;
end;

procedure TScriptEditor.GetFlameFinalxformEnabledProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.finalXformEnabled);
end;

procedure TScriptEditor.SetFlameFinalxformEnabledProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    cp.finalXformEnabled := (GetInputArgAsInteger(0) <> 0);
end;

procedure TScriptEditor.GetFlameSoloXformProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.soloXform);
end;

procedure TScriptEditor.SetFlameSoloXformProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    cp.soloXform := GetInputArgAsInteger(0);
    if (cp.soloXform < 0) or (cp.soloXform >= NumTransforms) then
      cp.soloXform := -1;
end;

procedure TScriptEditor.GetFlameWidthProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.width);
end;

procedure TScriptEditor.SetFlameWidthProc(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if v >= 1 then cp.width := v;
  end;
end;

procedure TScriptEditor.GetFlameHeightProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.height);
end;

procedure TScriptEditor.SetFlameHeightProc(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if v >= 1 then cp.height := v;
  end;
end;

procedure TScriptEditor.GetFlamePixelsPerUnitProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
//    ReturnOutPutArg(cp.pixels_per_unit);
    ReturnOutPutArg(100*cp.pixels_per_unit/cp.Width);
end;

procedure TScriptEditor.SetFlamePixelsPerUnitProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
//    cp.pixels_per_unit := GetInputArgAsInteger(0);  <<--- hmm, ppu isn't integer :-\
    cp.pixels_per_unit := GetInputArgAsFloat(0) * cp.Width / 100.0;
end;

procedure TScriptEditor.GetFlamePaletteProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.cmap[Integer(GetArrayIndex(0)), Integer(GetArrayIndex(1))]);
end;

procedure TScriptEditor.SetFlamePaletteProc(AMachine: TatVirtualMachine);
var
  i0, i1, v: integer;
begin
  with AMachine do
  begin
    i0 := GetArrayIndex(0);
    i1 := GetArrayIndex(1);
    v := GetInputArgAsInteger(0);
    if (i0 >= 0) and (i0 <= 255) and (i1 >= 0) and (i1 <= 2) and
      (v >= 0) and (v < 256) then
      cp.cmap[i0, i1] := v;
  end;
end;

procedure TScriptEditor.GetFlameBackgroundProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.background[Integer(GetArrayIndex(0))]);
end;

procedure TScriptEditor.SetFlameBackgroundProc(AMachine: TatVirtualMachine);
var
  i, v: integer;
begin
  with AMachine do
  begin
    i := GetArrayIndex(0);
    v := GetInputArgAsInteger(0);
    if (i >= 0) and (i <= 2) and (v >= 0) and (v < 256) then
      cp.Background[i] := v;
  end;
end;

procedure TScriptEditor.SetFlameNameProc(AMachine: TatVirtualMachine);
begin
  cp.name := AMachine.GetInputArgAsString(0);
end;

procedure TScriptEditor.GetFlameNameProc(AMachine: TatVirtualMachine);
begin
  AMachine.ReturnOutPutArg(cp.name);
end;

procedure TScriptEditor.SetFlameNickProc(AMachine: TatVirtualMachine);
begin
  cp.nick := AMachine.GetInputArgAsString(0);
end;

procedure TScriptEditor.GetFlameURLProc(AMachine: TatVirtualMachine);
begin
  AMachine.ReturnOutPutArg(cp.url);
end;

procedure TScriptEditor.SetFlameURLProc(AMachine: TatVirtualMachine);
begin
  cp.url := AMachine.GetInputArgAsString(0);
end;


procedure TScriptEditor.GetFlameNickProc(AMachine: TatVirtualMachine);
begin
  AMachine.ReturnOutPutArg(cp.nick);
end;


procedure TScriptEditor.SetFlameHueProc(AMachine: TatVirtualMachine);
var
  v: double;
begin
  v := AMachine.GetInputArgAsFloat(0);
  if (v >= 0) and (v <= 1) then
    cp.hue_rotation := v;
end;

procedure TScriptEditor.GetFlameHueProc(AMachine: TatVirtualMachine);
begin
  AMachine.ReturnOutPutArg(cp.hue_rotation);
end;

procedure TScriptEditor.GetFlameBatchesProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.nbatches);
end;

procedure TScriptEditor.SetFlameBatchesProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    cp.nbatches := GetInputArgAsInteger(0);
end;

procedure TScriptEditor.GetFlameAngleProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.FAngle);
end;

procedure TScriptEditor.SetFlameAngleProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    cp.FAngle := GetInputArgAsFloat(0);
end;

procedure TScriptEditor.GetFlamePitchProc(AMachine: TatVirtualMachine);
var
  v:double;
begin
  // fix: someone forgot to translate from/to radians
  v := cp.cameraPitch * 180 / PI;
  with AMachine do
    ReturnOutPutArg(v);
end;

procedure TScriptEditor.SetFlamePitchProc(AMachine: TatVirtualMachine);
var
 v:double;
begin
  // fix: someone forgot to translate from/to radians
  with AMachine do
    v := GetInputArgAsFloat(0);
  cp.cameraPitch := v * PI / 180;
end;

procedure TScriptEditor.GetFlameYawProc(AMachine: TatVirtualMachine);
var
  v:double;
begin
  // fix: someone forgot to translate from/to radians
  v := cp.cameraYaw * 180 / PI;
  with AMachine do
    ReturnOutPutArg(v);
end;

procedure TScriptEditor.SetFlameYawProc(AMachine: TatVirtualMachine);
var
  v:double;
begin
  // fix: someone forgot to translate from/to radians
  with AMachine do
    v := GetInputArgAsFloat(0);
  cp.cameraYaw := v * PI / 180;
end;

procedure TScriptEditor.GetFlameCamZposProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.cameraZpos);
end;

procedure TScriptEditor.SetFlameCamZposProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    cp.cameraZpos := GetInputArgAsFloat(0);
end;

procedure TScriptEditor.GetFlamePerspectiveProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.cameraPersp);
end;

procedure TScriptEditor.SetFlamePerspectiveProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    cp.cameraPersp := GetInputArgAsFloat(0);
end;

procedure TScriptEditor.GetFlameDOFProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.cameraDOF);
end;

procedure TScriptEditor.SetFlameDOFProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    cp.cameraDOF := GetInputArgAsFloat(0);
end;

{ *************************** Transform interface **************************** }

procedure TScriptEditor.GetTransformAProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.xform[ActiveTransform].c[0, 0]);
end;

procedure TScriptEditor.SetTransformAProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    cp.xform[ActiveTransform].c[0, 0] := GetInputArgAsFloat(0);
end;

procedure TScriptEditor.GetTransformBProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.xform[ActiveTransform].c[1, 0]);
end;

procedure TScriptEditor.SetTransformBProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    cp.xform[ActiveTransform].c[1, 0] := GetInputArgAsFloat(0);
end;

procedure TScriptEditor.GetTransformCProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.xform[ActiveTransform].c[0, 1]);
end;

procedure TScriptEditor.SetTransformCProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    cp.xform[ActiveTransform].c[0, 1] := GetInputArgAsFloat(0);
end;

procedure TScriptEditor.GetTransformDProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.xform[ActiveTransform].c[1, 1]);
end;

procedure TScriptEditor.SetTransformDProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    cp.xform[ActiveTransform].c[1, 1] := GetInputArgAsFloat(0);
end;

procedure TScriptEditor.GetTransformEProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.xform[ActiveTransform].c[2, 0]);
end;

procedure TScriptEditor.SetTransformEProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    cp.xform[ActiveTransform].c[2, 0] := GetInputArgAsFloat(0);
end;

procedure TScriptEditor.GetTransformFProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.xform[ActiveTransform].c[2, 1]);
end;

procedure TScriptEditor.SetTransformFProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    cp.xform[ActiveTransform].c[2, 1] := GetInputArgAsFloat(0);
end;

procedure TScriptEditor.GetTransformColorProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.xform[ActiveTransform].Color);
end;

procedure TScriptEditor.SetTransformColorProc(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if (v >= 0) and (v <= 1) then
      cp.xform[ActiveTransform].Color := v;
  end;
end;

procedure TScriptEditor.GetTransformVarColorProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.xform[ActiveTransform].pluginColor);
end;

procedure TScriptEditor.SetTransformVarColorProc(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if (v >= 0) and (v <= 1) then
      cp.xform[ActiveTransform].pluginColor := v;
  end;
end;

procedure TScriptEditor.GetTransformWeightProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.xform[ActiveTransform].density);
end;

procedure TScriptEditor.SetTransformWeightProc(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if (v > 0) and (v <= MAX_WEIGHT) then
      cp.xform[ActiveTransform].density := v;
  end;
end;

procedure TScriptEditor.GetTransformSymProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.xform[ActiveTransform].symmetry);
end;

procedure TScriptEditor.SetTransformSymProc(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    if (v >= -1) and (v <= 1) then
      cp.xform[ActiveTransform].symmetry := v;
  end;
end;

procedure TScriptEditor.GetTransformVarProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.xform[ActiveTransform].GetVariation(Integer(GetArrayIndex(0))));
end;

procedure TScriptEditor.SetTransformVarProc(AMachine: TatVirtualMachine);
var
  v: double;
  i: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    i := GetArrayIndex(0);
    if (i >= 0) and (i < NRVAR) then
      cp.xform[ActiveTransform].SetVariation(i, v);
  end;
end;

procedure TScriptEditor.GetTransformVariProc(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do begin
    cp.xform[ActiveTransform].GetVariable(GetVariableNameAt(Integer(GetArrayIndex(0))), v);
    ReturnOutPutArg(v);
  end;
end;

procedure TScriptEditor.SetTransformVariProc(AMachine: TatVirtualMachine);
var
  v: double;
  i: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    i := GetArrayIndex(0);
    if (i >= 0) and (i < GetNrVariableNames) then
      cp.xform[ActiveTransform].SetVariable(GetVariableNameAt(i), v);
  end;
end;

procedure TScriptEditor.GetTransformChaosProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(cp.xform[ActiveTransform].modWeights[Integer(GetArrayIndex(0))]);
end;

procedure TScriptEditor.SetTransformChaosProc(AMachine: TatVirtualMachine);
var
  v: double;
  i: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    i := GetArrayIndex(0);
    if (i >= 0) and (i < NumTransforms) then
      cp.xform[ActiveTransform].modWeights[i] := v;
  end;
end;

procedure TScriptEditor.GetTransformPlotModeProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    if cp.xform[ActiveTransform].transOpacity=0 then
      ReturnOutPutArg(1)
    else
      ReturnOutPutArg(0);
end;

procedure TScriptEditor.SetTransformPlotModeProc(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v <> 0) then cp.xform[ActiveTransform].transOpacity := 1
    else cp.xform[ActiveTransform].transOpacity := 0;
  end;
end;

procedure TScriptEditor.GetTransformOpacityProc(AMachine: TatVirtualMachine);
begin
    AMachine.ReturnOutPutArg(cp.xform[ActiveTransform].transOpacity)
end;

procedure TScriptEditor.SetTransformOpacityProc(AMachine: TatVirtualMachine);
var
  v: double;
begin
  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    cp.xform[ActiveTransform].transOpacity := v;
  end;
end;

// -- vars as props --

procedure TScriptEditor.GetTransformVariationProc(AMachine: TatVirtualMachine);
var
  i: integer;
  v: double;
begin
  if (ActiveTransform < 0) or (ActiveTransform > NXFORMS) then begin
    ScriptEditor.Console.Lines.Add(ErrorOutOfRange);
    LastError := ErrorOutOfRange;
    Scripter.Halt;
    exit;
  end;

  with AMachine do
  begin
    i := 0;
    while (i < NRVAR) and (Lowercase(varnames(i)) <> Lowercase(CurrentPropertyName)) do Inc(i);
    if (i < NRVAR) then
      ReturnOutPutArg(cp.xform[ActiveTransform].GetVariation(i))
    else begin // shouldn't happen
      LastError := 'Cannot find variation at index ' + CurrentPropertyName + ' - ignoring';
      ScriptEditor.Console.Lines.Add(LastError);
      //Scripter.Halt;
    end;
  end;
end;

procedure TScriptEditor.SetTransformVariationProc(AMachine: TatVirtualMachine);
var
  i: integer;
  v: double;
begin
  if (ActiveTransform < 0) or (ActiveTransform > NXFORMS) then begin
    ScriptEditor.Console.Lines.Add(ErrorOutOfRange);
    LastError := ErrorOutOfRange;
    Scripter.Halt;
    exit;
  end;

  with AMachine do
  begin
    i := 0;
    while (i < NRVAR) and (lowercase(varnames(i)) <> lowercase(CurrentPropertyName)) do Inc(i);
    if (i < NRVAR) then
      cp.xform[ActiveTransform].SetVariation(i, GetInputArgAsFloat(0))
    else begin // shouldn't happen
      LastError := 'Cannot find variation at index ' + CurrentPropertyName + ' - ignoring';
      ScriptEditor.Console.Lines.Add(LastError);
      //Scripter.Halt;
    end;
  end;
end;

procedure TScriptEditor.GetTransformVariableProc(AMachine: TatVirtualMachine);
var
  v: double;
begin
  if (ActiveTransform < 0) or (ActiveTransform > NXFORMS) then begin
    ScriptEditor.Console.Lines.Add(ErrorOutOfRange);
    LastError := ErrorOutOfRange;
    Scripter.Halt;
    exit;
  end;

  with AMachine do
  begin
    cp.xform[ActiveTransform].GetVariable(CurrentPropertyName, v);
    ReturnOutPutArg(v);
  end;
end;

procedure TScriptEditor.SetTransformVariableProc(AMachine: TatVirtualMachine);
var
  v: double;
begin
  if (ActiveTransform < 0) or (ActiveTransform > NXFORMS) then begin
    ScriptEditor.Console.Lines.Add(ErrorOutOfRange);
    LastError := ErrorOutOfRange;
    Scripter.Halt;
    exit;
  end;

  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    cp.xform[ActiveTransform].SetVariable(CurrentPropertyName, v);
  end
end;

// -- coefs & post-coefs --

procedure TScriptEditor.GetTransformCoefsProc(AMachine: TatVirtualMachine);
var
  v: double;
  i, j: integer;
begin
  if (ActiveTransform < 0) or (ActiveTransform > NXFORMS) then begin
    ScriptEditor.Console.Lines.Add(ErrorOutOfRange);
    LastError := ErrorOutOfRange;
    Scripter.Halt;
    exit;
  end;

  with AMachine do begin
    i := GetArrayIndex(0);
    j := GetArrayIndex(1);
    v := cp.xform[ActiveTransform].c[i, j];
    if (i=0)and(j=0) or (i=1)and(j=1) or (i=2)and(j=0) then
      ReturnOutPutArg(v)
    else
      ReturnOutPutArg(-v);
  end;
end;

procedure TScriptEditor.SetTransformCoefsProc(AMachine: TatVirtualMachine);
var
  v: double;
  i, j: integer;
begin
  if (ActiveTransform < 0) or (ActiveTransform > NXFORMS) then begin
    ScriptEditor.Console.Lines.Add(ErrorOutOfRange);
    LastError := ErrorOutOfRange;
    Scripter.Halt;
    exit;
  end;

  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    i := GetArrayIndex(0);
    j := GetArrayIndex(1);
    if (i=0)and(j=0) or (i=1)and(j=1) or (i=2)and(j=0) then
      cp.xform[ActiveTransform].c[i, j] := v
    else if (i=0)and(j=1) or (i=1)and(j=0) or (i=2)and(j=1) then
      cp.xform[ActiveTransform].c[i, j] := -v;
  end;
end;

procedure TScriptEditor.GetTransformPostCoefsProc(AMachine: TatVirtualMachine);
var
  v: double;
  i, j: integer;
begin
  if (ActiveTransform < 0) or (ActiveTransform > NXFORMS) then begin
    ScriptEditor.Console.Lines.Add(ErrorOutOfRange);
    LastError := ErrorOutOfRange;
    Scripter.Halt;
    exit;
  end;

  with AMachine do begin
    i := GetArrayIndex(0);
    j := GetArrayIndex(1);
    v := cp.xform[ActiveTransform].p[i, j];
    if (i=0)and(j=0) or (i=1)and(j=1) or (i=2)and(j=0) then
      ReturnOutPutArg(v)
    else
      ReturnOutPutArg(-v);
  end;
end;

procedure TScriptEditor.SetTransformPostCoefsProc(AMachine: TatVirtualMachine);
var
  v: double;
  i, j: integer;
begin
  if (ActiveTransform < 0) or (ActiveTransform > NXFORMS) then begin
    ScriptEditor.Console.Lines.Add(ErrorOutOfRange);
    LastError := ErrorOutOfRange;
    Scripter.Halt;
    exit;
  end;

  with AMachine do
  begin
    v := GetInputArgAsFloat(0);
    i := GetArrayIndex(0);
    j := GetArrayIndex(1);
    if (i=0)and(j=0) or (i=1)and(j=1) or (i=2)and(j=0) then
      cp.xform[ActiveTransform].p[i, j] := v
    else if (i=0)and(j=1) or (i=1)and(j=0) or (i=2)and(j=1) then
      cp.xform[ActiveTransform].p[i, j] := -v;
  end;
end;

procedure TScriptEditor.TransformClearProc(AMachine: TatVirtualMachine);
begin
  cp.xform[ActiveTransform].Clear;
  if ActiveTransform < Transforms then
    cp.xform[ActiveTransform].density := 0.5
  else
    cp.xform[ActiveTransform].symmetry := 1;
end;

procedure TScriptEditor.TransformRotateOriginProc(AMachine: TatVirtualMachine);
var
  tx, ty, rad: double;
begin
  if (ActiveTransform < 0) or (ActiveTransform > NXFORMS) then begin
    ScriptEditor.Console.Lines.Add(ErrorOutOfRange);
    LastError := ErrorOutOfRange;
    Scripter.Halt;
    exit;
  end;

  rad := AMachine.GetInputArgAsFloat(0) * pi / 180;
  with EditForm.WorldPivot do
  with cp.xform[ActiveTransform] do begin
    tx := x + (c[2,0] - x) * cos(rad) - (-c[2,1] - y) * sin(rad);
    ty := y + (c[2,0] - x) * sin(rad) + (-c[2,1] - y) * cos(rad);
    c[2,0] := tx;
    c[2,1] := -ty;
  end;
end;

// -- pivot-aware rotating & scaling --

procedure TScriptEditor.TransformRotateProc(AMachine: TatVirtualMachine);
var
  Triangles: TTriangles;
  px, py: double;

  tx: TXForm;
begin
  if (ActiveTransform < 0) or (ActiveTransform > NXFORMS) then begin
    ScriptEditor.Console.Lines.Add(ErrorOutOfRange);
    LastError := ErrorOutOfRange;
    Scripter.Halt;
    exit;
  end;

  tx := TXForm.Create;
  tx.Assign(scripteditor.cp.xform[NumTransforms]); // just in case (?)

  EditForm.ScriptGetPivot(px, py);
  cp.TrianglesFromCp(Triangles); // it's ugly but it works...
  Triangles[ActiveTransform] :=
    RotateTrianglePoint(Triangles[ActiveTransform], px, py, AMachine.GetInputArgAsFloat(0) * pi / 180);
  cp.GetFromTriangles(Triangles, NumTransforms);

  cp.xform[NumTransforms].Assign(tx);
  tx.Free;
end;

procedure TScriptEditor.TransformScaleProc(AMachine: TatVirtualMachine);
var
  Triangles: TTriangles;
  px, py: double;

  tx: TXForm;
begin
  if (ActiveTransform < 0) or (ActiveTransform > NXFORMS) then begin
    ScriptEditor.Console.Lines.Add(ErrorOutOfRange);
    LastError := ErrorOutOfRange;
    Scripter.Halt;
    exit;
  end;

  tx := TXForm.Create;
  tx.Assign(scripteditor.cp.xform[NumTransforms]); // just in case (?)

  EditForm.ScriptGetPivot(px, py);
  cp.TrianglesFromCp(Triangles); // it's ugly but it works...
  Triangles[ActiveTransform] :=
    ScaleTrianglePoint(Triangles[ActiveTransform], px, py, AMachine.GetInputArgAsFloat(0));
  cp.GetFromTriangles(Triangles, NumTransforms);

  cp.xform[NumTransforms].Assign(tx);
  tx.Free;
end;

{ *************************** Render interface ****************************** }


procedure TScriptEditor.GetRenderFilenameProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(TScriptRender(CurrentObject).Filename);
end;

procedure TScriptEditor.SetRenderFilenameProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    TScriptRender(CurrentObject).Filename := GetInputArgAsString(0);
end;

procedure TScriptEditor.GetRenderWidthProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(TScriptRender(CurrentObject).Width);
end;

procedure TScriptEditor.SetRenderWidthProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    TScriptRender(CurrentObject).Width := GetInputArgAsInteger(0);
end;

procedure TScriptEditor.GetRenderHeightProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(TScriptRender(CurrentObject).Height);
end;

procedure TScriptEditor.SetRenderHeightProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    TScriptRender(CurrentObject).Height := GetInputArgAsInteger(0);
end;

procedure TScriptEditor.GetRenderMaxMemoryProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutPutArg(TScriptRender(CurrentObject).Height);
end;

procedure TScriptEditor.SetRenderMaxMemoryProc(AMachine: TatVirtualMachine);
var
  v: integer;
begin
  with AMachine do
  begin
    v := GetInputArgAsInteger(0);
    if (v >= 0) then
      TScriptRender(CurrentObject).MaxMemory := v;
  end;
end;

{ **************************************************************************** }

procedure TScriptEditor.GetPivotModeProc(AMachine: TatVirtualMachine);
begin
  AMachine.ReturnOutputArg(Integer(EditForm.PivotMode));
end;

procedure TScriptEditor.SetPivotModeProc(AMachine: TatVirtualMachine);
var
  n: integer;
begin
  n := AMachine.GetInputArgAsInteger(0);
  if n = 0 then
    EditForm.PivotMode := pivotLocal
  else
    EditForm.PivotMode := pivotWorld;
end;

procedure TScriptEditor.GetPivotXProc(AMachine: TatVirtualMachine);
begin
//  EditForm.ScriptGetPivot(px, py);
//  AMachine.ReturnOutputArg(px);
  if EditForm.PivotMode = pivotLocal then
    AMachine.ReturnOutputArg(EditForm.LocalPivot.x)
  else
    AMachine.ReturnOutputArg(EditForm.WorldPivot.x);
end;

procedure TScriptEditor.SetPivotXProc(AMachine: TatVirtualMachine);
begin
  if EditForm.PivotMode = pivotLocal then
    EditForm.LocalPivot.x := AMachine.GetInputArgAsFloat(0)
  else
    EditForm.WorldPivot.x := AMachine.GetInputArgAsFloat(0);
end;

procedure TScriptEditor.GetPivotYProc(AMachine: TatVirtualMachine);
begin
//  EditForm.ScriptGetPivot(px, py);
//  AMachine.ReturnOutputArg(py);
  if EditForm.PivotMode = pivotLocal then
    AMachine.ReturnOutputArg(EditForm.LocalPivot.y)
  else
    AMachine.ReturnOutputArg(EditForm.WorldPivot.y);
end;

procedure TScriptEditor.SetPivotYProc(AMachine: TatVirtualMachine);
begin
  if EditForm.PivotMode = pivotLocal then
    EditForm.LocalPivot.y := AMachine.GetInputArgAsFloat(0)
  else
    EditForm.WorldPivot.y := AMachine.GetInputArgAsFloat(0);
end;

procedure TScriptEditor.SetPivotProc(AMachine: TatVirtualMachine);
begin
  with AMachine do begin
    if EditForm.PivotMode = pivotLocal then begin
      EditForm.LocalPivot.x := GetInputArgAsFloat(0);
      EditForm.LocalPivot.y := GetInputArgAsFloat(1);
    end
    else begin
      EditForm.WorldPivot.x := GetInputArgAsFloat(0);
      EditForm.WorldPivot.y := GetInputArgAsFloat(1);
    end;
  end;
end;

procedure TScriptEditor.ResetPivotProc(AMachine: TatVirtualMachine);
begin
  EditForm.btnResetPivotClick(nil);
end;

{ ********************************* Scripter ********************************* }

procedure TScriptEditor.PrepareScripter;
var
  i: integer;
begin
  Scripter.AddLibrary(TatSysUtilsLibrary);
  with Scripter.defineClass(TScriptRender) do
  begin
    DefineProp('Filename', tkString, GetRenderFilenameProc, SetRenderFilenameProc);
    DefineProp('Width', tkInteger, GetRenderWidthProc, SetRenderWidthProc);
    DefineProp('Height', tkInteger, GetRenderHeightProc, SetRenderHeightProc);
    DefineProp('MaxMemory', tkInteger, GetRenderMaxMemoryProc, SetRenderMaxMemoryProc);
  end;
  Scripter.AddObject('Renderer', Renderer);

  { Flame interface }
  with Scripter.defineClass(TFlame) do
  begin
    DefineProp('Gamma', tkFloat, GetFlameGammaProc, SetFlameGammaProc);
    DefineProp('GammaTreshold', tkFloat, GetFlameGammaTresholdProc, SetFlameGammaTresholdProc);
    DefineProp('Brightness', tkFloat, GetFlameBrightnessProc, SetFlameBrightnessProc);
    DefineProp('Vibrancy', tkFloat, GetFlameVibrancyProc, SetFlameVibrancyProc);
    DefineProp('Time', tkFloat, GetFlameTimeProc, SetFlameTimeProc);
    DefineProp('Zoom', tkFloat, GetFlameZoomProc, SetFlameZoomProc);
    DefineProp('X', tkFloat, GetFlameXProc, SetFlameXProc);
    DefineProp('Y', tkFloat, GetFlameYProc, SetFlameYProc);
    DefineProp('Width', tkFloat, GetFlameWidthProc, SetFlameWidthProc);
    DefineProp('Height', tkFloat, GetFlameHeightProc, SetFlameHeightProc);
    DefineProp('SampleDensity', tkFloat, GetFlameDensityProc, SetFlameDensityProc);
    DefineProp('Quality', tkFloat, GetFlameDensityProc, SetFlameDensityProc);
    DefineProp('Oversample', tkInteger, GetFlameOversampleProc, SetFlameOversampleProc);
    DefineProp('FilterRadius', tkFloat, GetFlameFilterRadiusProc, SetFlameFilterRadiusProc);
    DefineProp('Scale', tkFloat, GetFlamePixelsPerUnitProc, SetFlamePixelsPerUnitProc);
    DefineProp('Gradient', tkInteger, GetFlamePaletteProc, SetFlamePaletteProc, nil, false, 2);
    DefineProp('Background', tkInteger, GetFlameBackgroundProc, SetFlameBackgroundProc, nil, false, 1);
    DefineProp('Name', tkString, GetFlameNameProc, SetFlameNameProc);
    DefineProp('Nick', tkString, GetFlameNickProc, SetFlameNickProc);
    DefineProp('URL', tkString, GetFlameURLProc, SetFlameURLProc);
    DefineProp('Hue', tkFloat, GetFlameHueProc, SetFlameHueProc);
    DefineProp('Batches', tkInteger, GetFlameBatchesProc, SetFlameBatchesProc);
    DefineProp('FinalXformEnabled', tkInteger, GetFlameFinalxformEnabledProc, SetFlameFinalxformEnabledProc);
    DefineProp('Angle', tkFloat, GetFlameAngleProc, SetFlameAngleProc);
    DefineProp('Pitch', tkFloat, GetFlamePitchProc, SetFlamePitchProc);
    DefineProp('Yaw', tkFloat, GetFlameYawProc, SetFlameYawProc);
    DefineProp('Perspective', tkFloat, GetFlamePerspectiveProc, SetFlamePerspectiveProc);
    DefineProp('Z', tkFloat, GetFlameCamZposProc, SetFlameCamZposProc);
    DefineProp('DOF', tkFloat, GetFlameDOFProc, SetFlameDOFProc);
    DefineProp('SoloXform', tkInteger, GetFlameSoloXformProc, SetFlameSoloXformProc);
  end;
  Scripter.AddObject('Flame', Flame);

  { Transform interface }
  with Scripter.defineClass(TTransform) do
  begin
    DefineProp('coefs', tkFloat, GetTransformCoefsProc, SetTransformCoefsProc, nil, false, 2);
    DefineProp('post', tkFloat, GetTransformPostCoefsProc, SetTransformPostCoefsProc, nil, false, 2);
    DefineProp('Color', tkFloat, GetTransformColorProc, SetTransformColorProc);
    DefineProp('VarColor', tkFloat, GetTransformVarColorProc, SetTransformVarColorProc);
    DefineProp('Weight', tkFloat, GetTransformWeightProc, SetTransformWeightProc);
    DefineProp('Symmetry', tkFloat, GetTransformSymProc, SetTransformSymProc);
    DefineProp('ColorSpeed', tkFloat, GetTransformSymProc, SetTransformSymProc);
    for i:= 0 to NRVAR - 1 do begin
      DefineProp(Varnames(i), tkFloat, GetTransformVariationProc, SetTransformVariationProc);
      Editor.SyntaxStyles.AutoCompletion.Add(Varnames(i));
    end;
    for i:= 0 to GetNrVariableNames - 1 do begin
      DefineProp(GetVariableNameAt(i), tkFloat, GetTransformVariableProc, SetTransformVariableProc);
      Editor.SyntaxStyles.AutoCompletion.Add(GetVariableNameAt(i));
    end;
    Editor.SyntaxStyles.AutoCompletion.Sort;
    while Editor.SyntaxStyles.AutoCompletion.Strings[0] = '' do Editor.SyntaxStyles.AutoCompletion.Delete(0);

    DefineMethod('Clear', 0, tkNone, nil, TransformClearProc);
    DefineMethod('Rotate', 1, tkNone, nil, TransformRotateProc);
    DefineMethod('Scale', 1, tkNone, nil, TransformScaleProc);
    DefineMethod('RotateOrigin', 1, tkNone, nil, TransformRotateOriginProc);

    DefineProp('a', tkFloat, GetTransformAProc, SetTransformAProc);
    DefineProp('b', tkFloat, GetTransformBProc, SetTransformBProc);
    DefineProp('c', tkFloat, GetTransformCProc, SetTransformCProc);
    DefineProp('d', tkFloat, GetTransformDProc, SetTransformDProc);
    DefineProp('e', tkFloat, GetTransformEProc, SetTransformEProc);
    DefineProp('f', tkFloat, GetTransformFProc, SetTransformFProc);
    DefineProp('Variation', tkFloat, GetTransformVarProc, SetTransformVarProc, nil, false, 1);
    DefineProp('Variable', tkFloat, GetTransformVariProc, SetTransformVariProc, nil, false, 1);
    DefineProp('Chaos', tkFloat, GetTransformChaosProc, SetTransformChaosProc, nil, false, 1);
    DefineProp('PlotMode', tkInteger, GetTransformPlotModeProc, SetTransformPlotModeProc);
    DefineProp('Opacity', tkFloat, GetTransformOpacityProc, SetTransformOpacityProc);
  end;
  Scripter.AddObject('Transform', Transform);

  { Options interface }
  with Scripter.defineClass(TOptions) do
  begin
    DefineProp('JPEGQuality', tkInteger, GetJPEGQuality, SetJPEGQuality);
    DefineProp('BatchSize', tkInteger, GetBatchSize, SetBatchSize);
    DefineProp('ParameterFile', tkString, GetParameterFile, SetParameterFile);
    DefineProp('SmoothPaletteFile', tkString, GetSmoothPaletteFile, SetSmoothPaletteFile);
    DefineProp('NumTries', tkInteger, GetNumTries, SetNumTries);
    DefineProp('TryLength', tkInteger, GetTryLength, SetTryLength);
    DefineProp('ConfirmDelete', tkVariant, GetConfirmDelete, SetConfirmDelete);
    DefineProp('FixedReference', tkVariant, GetFixedReference, SetFixedReference);
    DefineProp('SampleDensity', tkFloat, GetSampleDensity, SetSampleDensity);
    DefineProp('Gamma', tkFloat, GetGamma, SetGamma);
    DefineProp('Brightness', tkFloat, GetBrightness, SetBrightness);
    DefineProp('Vibrancy', tkFloat, GetVibrancy, SetVibrancy);
    DefineProp('Oversample', tkInteger, GetOversample, SetOversample);
    DefineProp('FilterRadius', tkFloat, GetFilterRadius, SetFilterRadius);
    DefineProp('Transparency', tkInteger, GetTransparency, SetTransparency);
    DefineProp('PreviewLowQuality', tkFloat, GetLowQuality, SetLowQuality);
    DefineProp('PreviewMediumQuality', tkFloat, GetMediumQuality, SetMediumQuality);
    DefineProp('PreviewHighQuality', tkFloat, GetHighQuality, SetHighQuality);
    DefineProp('MinTransforms', tkInteger, GetMinTransforms, SetMinTransforms);
    DefineProp('MaxTransforms', tkInteger, GetMaxTransforms, SetMaxTransforms);
    DefineProp('MutateMinTransforms', tkInteger, GetMutateMinTransforms, SetMutateMinTransforms);
    DefineProp('MutateMaxTransforms', tkInteger, GetMutateMaxTransforms, SetMutateMaxTransforms);
    DefineProp('RandomPrefix', tkString, GetPrefix, SetPrefix);
    DefineProp('KeepBackground', tkInteger, GetKeepBackground, SetKeepBackground);
    DefineProp('SymmetryType', tkInteger, GetSymmetryType, SetSymmetryType);
    DefineProp('SymmetryOrder', tkInteger, GetSymmetryOrder, SetSymmetryOrder);
    DefineProp('Variations', tkVariant, GetVariations, SetVariations, nil, false, 1);
    DefineProp('GradientOnRandom', tkInteger, GetRandomGradient, SetRandomGradient);
    DefineProp('MinNodes', tkInteger, GetMinNodes, SetMinNodes);
    DefineProp('MaxNodes', tkInteger, GetMaxNodes, SetMaxNodes);
    DefineProp('MinHue', tkInteger, GetMinHue, SetMinHue);
    DefineProp('MaxHue', tkInteger, GetMaxHue, SetMaxHue);
    DefineProp('MinSaturation', tkInteger, GetMinSat, SetMinSat);
    DefineProp('MaxSaturation', tkInteger, GetMaxSat, SetMaxSat);
    DefineProp('MinLuminance', tkInteger, GetMinLum, SetMinLum);
    DefineProp('MaxLuminance', tkInteger, GetMaxLum, SetMaxLum);
    DefineProp('UPRSampleDensity', tkInteger, GetUPRSampleDensity, SetUPRSampleDensity);
    DefineProp('UPRFilterRadius', tkFloat, GetUPRFilterRadius, SetUPRFilterRadius);
    DefineProp('UPROversample', tkInteger, GetUPROversample, SetUPROversample);
    DefineProp('UPRAdjustDensity', tkVariant, GetUPRAdjustDensity, SetUPRAdjustDensity);
    DefineProp('UPRColoringIdent', tkString, GetUPRColoringIdent, SetUPRColoringIdent);
    DefineProp('UPRColoringFile', tkString, GetUPRColoringFile, SetUPRColoringFile);
    DefineProp('UPRFormulaFile', tkString, GetUPRFormulaFile, SetUPRFormulaFile);
    DefineProp('UPRFormulaIdent', tkString, GetUPRFormulaIdent, SetUPRFormulaIdent);
    DefineProp('UPRWidth', tkInteger, GetUPRWidth, SetUPRWidth);
    DefineProp('UPRHeight', tkInteger, GetUPRHeight, SetUPRHeight);
    DefineProp('ExportRenderer', tkInteger, GetExportPath, SetExportPath);
  end;
  Scripter.AddObject('Options', Options);

  with Scripter.defineClass(TPivot) do
  begin
    DefineProp('Mode', tkInteger, GetPivotModeProc, SetPivotModeProc);
    DefineProp('X', tkFloat, GetPivotXProc, SetPivotXProc);
    DefineProp('Y', tkFloat, GetPivotYProc, SetPivotYProc);
    DefineMethod('Set', 2, tkNone, nil, SetPivotProc);
    DefineMethod('Reset', 0, tkNone, nil, ResetPivotProc);
  end;
  Scripter.AddObject('Pivot', Pivot);

  Scripter.AddComponent(OpenDialog);
  Scripter.AddLibrary(TOperationLibrary);
  Scripter.AddLibrary(TatClassesLibrary);

  { Variables and constants }
  Scripter.AddConstant('PI', pi);
  Scripter.AddConstant('NVARS', NRVAR);
  Scripter.AddConstant('NumVariables', GetNrVariableNames);
  Scripter.AddConstant('NXFORMS', NXFORMS);
  Scripter.AddConstant('INSTALLPATH', ExtractFilePath(Application.exename));
  Scripter.AddConstant('SYM_NONE', 0);
  Scripter.AddConstant('SYM_BILATERAL', 1);
  Scripter.AddConstant('SYM_ROTATIONAL', 2);
  { Variations }
  Scripter.AddConstant('V_LINEAR', 0);
  Scripter.AddConstant('V_SINUSOIDAL', 1);
  Scripter.AddConstant('V_SPHERICAL', 2);
  Scripter.AddConstant('V_SWIRL', 3);
  Scripter.AddConstant('V_HORSESHOE', 4);
  Scripter.AddConstant('V_POLAR', 5);
  Scripter.AddConstant('V_HANDKERCHIEF', 6);
  Scripter.AddConstant('V_HEART', 7);
  Scripter.AddConstant('V_DISC', 8);
  Scripter.AddConstant('V_SPIRAL', 9);
  Scripter.AddConstant('V_HYPERBOLIC', 10);
  Scripter.AddConstant('V_DIAMOND', 11);
  Scripter.AddConstant('V_EX', 12);
  Scripter.AddConstant('V_JULIA', 13);
  Scripter.AddConstant('V_BENT', 14);
  Scripter.AddConstant('V_WAVES', 15);
  Scripter.AddConstant('V_FISHEYE', 16);
  Scripter.AddConstant('V_POPCORN', 17);
  Scripter.AddConstant('V_EXPONENTIAL', 18);
  Scripter.AddConstant('V_POWER', 19);
  Scripter.AddConstant('V_COSINE', 20);
  Scripter.AddConstant('V_RINGS', 21);
  Scripter.AddConstant('V_FAN', 22);
  Scripter.AddConstant('V_EYEFISH', 23);
  Scripter.AddConstant('V_BUBBLE', 24);
  Scripter.AddConstant('V_CYLINDER', 25);
  Scripter.AddConstant('V_NOISE', 26);
  Scripter.AddConstant('V_BLUR', 27);
  Scripter.AddConstant('V_GAUSSIANBLUR', 28);
  Scripter.AddConstant('V_RADIALBLUR', 29);
  Scripter.AddConstant('V_RINGS2', 30);
  Scripter.AddConstant('V_FAN2', 31);
  Scripter.AddConstant('V_BLOB', 32);
  Scripter.AddConstant('V_PDJ', 33);
  Scripter.AddConstant('V_PERSPECTIVE', 34);
  Scripter.AddConstant('V_JULIAN', 35);
  Scripter.AddConstant('V_JULIASCOPE', 36);
  Scripter.AddConstant('V_CURL', 37);
  Scripter.AddConstant('V_RANDOM', -1);
(*
  { Variation parameters }
  Scripter.AddConstant('RADIALBLUR_ANGLE', 0);
  Scripter.AddConstant('RINGS2_VAL', 1);
  Scripter.AddConstant('FAN2_X', 2);
  Scripter.AddConstant('FAN2_Y', 3);
  Scripter.AddConstant('BLOB_LOW', 4);
  Scripter.AddConstant('BLOB_HI', 5);
  Scripter.AddConstant('BLOB_WAVES', 6);
  Scripter.AddConstant('PDJ_A', 7);
  Scripter.AddConstant('PDJ_B', 8);
  Scripter.AddConstant('PDJ_C', 9);
  Scripter.AddConstant('PDJ_D', 10);
  Scripter.AddConstant('PERSPECTIVE_ANGLE', 11);
  Scripter.AddConstant('PERSPECTIVE_DIST', 12);
  Scripter.AddConstant('JULIAN_POWER', 13);
  Scripter.AddConstant('JULIAN_DIST', 14);
  Scripter.AddConstant('JULIASCOPE_POWER', 15);
  Scripter.AddConstant('JULIASCOPE_DIST', 16);
  Scripter.AddConstant('CURL_C1', 17);
  Scripter.AddConstant('CURL_C2', 18);
*)
  { Variables }
  Scripter.AddVariable('SelectedTransform', EditForm.SelectedTriangle);
  Scripter.AddVariable('Compatibility', Compatibility); // obsolete
  Scripter.AddVariable('ActiveTransform', ActiveTransform);
  Scripter.AddVariable('UpdateFlame', UpdateIt);
  Scripter.AddVariable('ResetLocation', ResetLocation);
  Scripter.AddVariable('BatchIndex', RandomIndex);
  Scripter.AddVariable('DateCode', RandomDate);
  Scripter.AddVariable('Stopped', Stopped);
  Scripter.AddVariable('ShowProgress', ShowProgress);
  Scripter.AddVariable('CurrentFile', OpenFile);
  Scripter.AddVariable('LimitVibrancy', LimitVibrancy);

  Scripter.AddLibrary(TMathLibrary);
  Scripter.AddLibrary(TatMathLibrary);
//  Scripter.AddLibrary(TatWindowsLibrary);
  Scripter.AddLibrary(TatSysUtilsLibrary);
  Scripter.AddLibrary(TatFileCtrlLibrary);
  { Nonsense - it's the only way to get the last real
    library to work! }
  Scripter.AddObject('Not_Any_Thing_Useful', Another);
  Scripter.AddObject('IglooFunkyRubber', Another);
  Scripter.AddObject('Darn it', Another);
  Scripter.AddObject('Scrumptious', Another);
end;

{ ************************* Buttons ***************************************** }

procedure TScriptEditor.btnNewClick(Sender: TObject);

begin
  Editor.Lines.Clear;
  Caption := TextByKey('script-title'); //'New Script';
  Script := '';
end;

procedure TScriptEditor.LoadScriptFile(filename:string);
var
  s: string;
  fn:string;
begin
  Editor.Lines.LoadFromFile(filename);
  s := ExtractFileName(filename);
  s := Copy(s, 0, length(s) - Length(ExtractFileExt(s)));
  MainForm.mnuRun.Caption := Format(TextByKey('main-menu-script-run2'), [s]);
  Caption := s;
end;

procedure TScriptEditor.OpenScript;
var
  s: string;
  fn:string;
begin
  MainOpenDialog.InitialDir := ScriptPath;
  MainOpenDialog.Filename := '';
  MainOpenDialog.Filter := Format('%s|*.aposcript;*.asc|%s|*.*', [TextByKey('common-filter-script'), TextByKey('common-filter-allfiles')]);
  if OpenSaveFileDialog(ScriptEditor, '.aposcript', MainOpenDialog.Filter, MainOpenDialog.InitialDir, TextByKey('common-browse'), fn, true, false, false, true) then
//  if MainOpenDialog.execute then
  begin
    MainOpenDialog.FileName := fn;
    Script := MainOpenDialog.Filename;
    Editor.Lines.LoadFromFile(MainOpenDialog.Filename);
    s := ExtractFileName(MainOpenDialog.Filename);
    s := Copy(s, 0, length(s) - Length(ExtractFileExt(s)));
    MainForm.mnuRun.Caption := Format(TextByKey('main-menu-script-run2'), [s]);
    Caption := s;
    ScriptPath := ExtractFileDir(MainOpenDialog.Filename);
  end;
end;

procedure TScriptEditor.btnOpenClick(Sender: TObject);
begin
  OpenScript;
end;

procedure TScriptEditor.btnSaveClick(Sender: TObject);
var fn : string;
begin
  if Script = '' then fn := '' else fn := ChangeFileExt(ExtractFileName(Script), '.aposcript');
  if OpenSaveFileDialog(ScriptEditor, '.aposcript',
    Format('%s|*.aposcript;*.asc|%s|*.*',
      [TextByKey('common-filter-script'),
       TextByKey('common-filter-allfiles')]),
    ScriptPath, TextByKey('common-browse'), fn,
    false, true, false, false) then
  //if MainSaveDialog.Execute then
  begin
    MainOpenDialog.FileName := fn;
    Script := fn;
    Editor.Lines.SaveToFile(fn);
    Caption := ExtractFileName(fn);
    ScriptPath := ExtractFileDir(fn);
  end;
end;

procedure TScriptEditor.FillFileList;
var
  i, p: integer;
  ext, Title: string;
  FStrings: TStringList;
begin
  FStrings := TStringList.Create;
  FStrings.LoadFromFile(ParamFile);
  try
    FileList.Clear;

    ext := LowerCase(ExtractFileExt(ParamFile));
    (*if (ext = '.fla') or (ext = '.apo') then
    begin

    // Get names from .fla or .apo file
      if (Pos('{', FStrings.Text) <> 0) then
        for i := 0 to FStrings.Count - 1 do
        begin
          p := Pos('{', FStrings[i]);
          if (p <> 0) then
          begin
            Title := Trim(Copy(FStrings[i], 1, p - 1));
            if Title <> '' then
            begin { Otherwise bad format }
              FileList.Add(Trim(Copy(FStrings[i], 1, p - 1)));
            end;
          end;
        end;

    end
    else

    begin *)
    // Get names from .flame file
      if (Pos('<flame ', Lowercase(FStrings.Text)) <> 0) then
      begin
        for i := 0 to FStrings.Count - 1 do
        begin
          p := Pos('<flame ', LowerCase(FStrings[i]));
          if (p <> 0) then
          begin
            pname := '';
            MainForm.ListXMLScanner.LoadFromBuffer(PANSICHAR(AnsiString(FSTrings[i])));
            MainForm.ListXMLScanner.Execute;
            if Trim(pname) = '' then
              Title := '*untitled ' + ptime
            else
              FileList.Add(pname);
          end;
        end;

      end;
    //end;
  finally
    FStrings.Free;
  end;
end;

procedure TScriptEditor.RunScript;
var
  lib: TStringList;
begin

  btnRun.Enabled := False;
  btnBreak.Enabled := True;
  MainForm.btnRunScript.Enabled := False;
  MainForm.mnuRun.Enabled := False;
  MainForm.DisableFavorites;

  ParamFile := OpenFile;
  FillFileList;
  { Set defaults }
  { Set render defaults }
  Renderer.Width := 320;
  Renderer.Height := 240;
  Stopped := False;
  UpdateIt := True;
  ResetLocation := False;
  Console.Clear;
  LastError := '';
  ActiveTransform := EditForm.SelectedTriangle;
  NumTransforms := Transforms;
  cp.copy(MainCp);
  cmap := MainCp.cmap;
  Application.ProcessMessages;
  Randomize;
  
  // what in the sweet loving sake of jesus is this fuck?
  if Pos('stopped', Lowercase(Editor.Lines.text)) <> 0 then
  begin
    btnStop.Enabled := True;
    MainForm.mnuStop.Enabled := True;
    MainForm.btnStopScript.Enabled := True;
  end;
  with Scripter do
  begin
    SourceCode.Assign(Editor.Lines);
    if FileExists(defLibrary) then
    begin
      lib := TStringList.Create;
      try
        Lib.LoadFromFile(defLibrary);
        with Scripts.Add do
        begin
          SourceCode := lib;
          SelfRegisterAsLibrary('Functions');
        end;
      finally
        lib.free;
      end;
    end;
    //Compile;
    Execute;
  end;
  if (NumTransforms < 1) and UpdateIt then
  begin
    Console.Lines.Add('Not enough transforms.');
    ScriptRenderForm.Close;
    btnRun.Enabled := True;
    btnStop.Enabled := False;
    MainForm.btnRunScript.Enabled := True;
    MainForm.btnStopScript.Enabled := False;
    MainForm.mnuRun.Enabled := True;
    MainForm.mnuStop.Enabled := False;
    btnBreak.Enabled := False;
    Exit;
  end
  else
    if (LastError = '') and UpdateIt then
    begin
      MainForm.UpdateUndo;
      MainCp.Copy(cp);
      UpdateFlame;
      if ResetLocation then MainForm.ResetLocation;
    end
    else
    begin
      Console.Lines.Add(LastError);
    end;
  ScriptRenderForm.Close;
  btnRun.Enabled := True;
  btnStop.Enabled := False;
  MainForm.btnRunScript.Enabled := True;
  MainForm.btnStopScript.Enabled := False;
  MainForm.mnuRun.Enabled := True;
  MainForm.mnuStop.Enabled := False;
  btnBreak.Enabled := False;
  MainForm.EnableFavorites;
end;

procedure TScriptEditor.btnRunClick(Sender: TObject);
begin
  RunScript;
end;

{ ****************************** Update flame ******************************* }

procedure TScriptEditor.UpdateFlame;
begin
  MainForm.StopThread;
  MainForm.UpdateUndo;
  MainCp.Copy(cp);
//  MainCp.name := FlameName;
  Transforms := MainCp.TrianglesFromCP(MainTriangles);
  MainCp.AdjustScale(MainForm.Image.Width, MainForm.Image.Height);
  if ResetLocation then MainCp.CalcBoundBox else
  begin;
    MainCp.Zoom := cp.zoom;
    MainCp.center[0] := cp.center[0];
    MainCp.center[1] := cp.center[1];
  end;
  MainCp.cmap := cp.cmap;
  MainForm.RedrawTimer.enabled := true;
  if EditForm.Visible then EditForm.UpdateDisplay;
  if AdjustForm.Visible then AdjustForm.UpdateDisplay;
  if MutateForm.Visible then MutateForm.UpdateDisplay;
end;

{ ******************************* functions ********************************** }


{ ******************************* Parseing *********************************** }

procedure copyxform(var dest: Txform; const source: TXform);
var
  i: integer;
begin
  dest.c[0, 0] := source.c[0, 0];
  dest.c[0, 1] := source.c[0, 1];
  dest.c[1, 0] := source.c[1, 0];
  dest.c[1, 1] := source.c[1, 1];
  dest.c[2, 0] := source.c[2, 0];
  dest.c[2, 1] := source.c[2, 1];
  dest.color := source.color;
// hmm, why no symmetry here? // dest.symmetry := source.symmetry;
  dest.density := source.density;
  for i := 0 to NRVAR - 1 do
    dest.SetVariation(i, source.GetVariation(i));
end;

{ ************************ Editor Popup menu ********************************* }

procedure TScriptEditor.mnuCutClick(Sender: TObject);
begin
  Editor.CutToClipboard;
end;

procedure TScriptEditor.mnuCopyClick(Sender: TObject);
begin
  Editor.CopyToClipboard;
end;

procedure TScriptEditor.mnuPasteClick(Sender: TObject);
begin
  Editor.PasteFromClipboard;
end;

procedure TScriptEditor.mnuUndoClick(Sender: TObject);
begin
  if Editor.CanUndo then Editor.Undo;
end;

procedure TScriptEditor.EditorChange(Sender: TObject);
begin
  Editor.activeLine := -1;
  if not Editor.CanUndo then mnuUndo.Enabled := false
  else mnuUndo.Enabled := true;
end;

procedure TScriptEditor.ScripterCompileError(Sender: TObject;
  var msg: string; row, col: Integer; var ShowException: Boolean);
begin
  Editor.ActiveLine := row - 1;
  Console.Lines.Add('Line '+IntToStr(row)+' : '+msg);
  ScriptRenderForm.Close;
  btnRun.Enabled := True;
  btnStop.Enabled := False;
  MainForm.btnRunScript.Enabled := True;
  MainForm.btnStopScript.Enabled := False;
  MainForm.mnuRun.Enabled := True;
  MainForm.mnuStop.Enabled := False;
  btnBreak.Enabled := False;
  ShowException := true;
  Application.ProcessMessages;
end;

procedure TScriptEditor.btnStopClick(Sender: TObject);
begin
  Stopped := True;
end;

procedure TScriptEditor.btnBreakClick(Sender: TObject);
begin
  LastError := 'Execution stopped by user.';
  Scripter.Halt;
end;

procedure TScriptEditor.btnFavoriteClick(Sender: TObject);
var
  i: integer;
  there: boolean;
begin
  there := False;
  for i := 0 to Favorites.Count - 1 do
    if Lowercase(Script) = Favorites[i] then
      There := true;
  if there then exit;
  Favorites.Add(Script);
  Favorites.SaveToFile(GetEnvVarValue('APPDATA') + '\' + scriptFavsFilename);
end;

procedure TScriptEditor.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  if GetKeyState(VK_CONTROL) >= 0 then
    Exit;

  if Msg.CharCode = Ord('C')  then begin
    Editor.CopyToClipBoard;
    Handled := True;
  end;

  if Msg.CharCode = Ord('V') then begin
    Editor.PasteFromClipBoard;
    Handled := True;
  end;

  if Msg.CharCode = Ord('X') then begin
    Editor.CutToClipBoard;
    Handled := True;
  end;
end;

procedure TScriptEditor.F2SXMLContent(Sender: TObject; Content: string);
begin
//
end;

procedure TScriptEditor.F2SXMLEmptyTag(Sender: TObject; TagName: string;
  Attributes: TAttrList);
var
  i: integer;
  v,w: TStringType;
  d, floatcolor: double;
  Tokens: TStringList;
begin

  Tokens := TStringList.Create;
  try
    if (TagName = 'xform') or (TagName = 'finalxform') then
      Editor.Lines.Add('');
      if TagName = 'finalxform' then begin
        Editor.Lines.Add('{ Final Transform }');
        Editor.Lines.Add('Flame.FinalXformEnabled := True;');
        Editor.Lines.Add('SetActiveTransform(transforms);');
      end else begin
        w := TStringType('{ Transform ' + IntToStr(AddedXForms + 1));
        v := Attributes.Value('name');
        if (v <> '') then w := w + ' (' + v + ')';
        w := w + ' }';
        Editor.Lines.Add(String(w));
        Editor.Lines.Add('AddTransform;');
      end;
      Editor.Lines.Add('with Transform do begin');
      //Editor.Lines.Add('  for i := 0 to NXFORMS do Chaos[i] := 1;');
      Editor.Lines.Add('  for i := 0 to NVARS do Variation[i] := 0;');

      v := Attributes.Value('weight');
      if (v <> '') and (TagName = 'xform') then
        Editor.Lines.Add('  Weight := ' + String(v) + ';');
      v := Attributes.Value('color');
      if (v <> '') then Editor.Lines.Add('  Color := ' + String(v) + ';');
      v := Attributes.Value('var_color');
      if (v <> '') then Editor.Lines.Add('  VarColor := ' + String(v) + ';');
      v := Attributes.Value('symmetry');
      if (v <> '') and (TagName = 'xform') then Editor.Lines.Add('  Symmetry := ' + String(v) + ';');
      v := Attributes.Value('coefs');
      if (v <> '') then begin
        GetTokens(String(v), tokens);
        Editor.Lines.Add('  a := ' + Tokens[0] + ';');
        Editor.Lines.Add('  b := ' + Tokens[2] + ';');
        Editor.Lines.Add('  c := ' + Tokens[1] + ';');
        Editor.Lines.Add('  d := ' + Tokens[3] + ';');
        Editor.Lines.Add('  e := ' + Tokens[4] + ';');
        Editor.Lines.Add('  f := ' + Tokens[5] + ';');
      end;

      v := Attributes.Value('post');
      if v <> '' then begin
        GetTokens(String(v), tokens);
        Editor.Lines.Add('  post[0,0] := ' + Tokens[0] + ';');
        Editor.Lines.Add('  post[0,1] := (-1) * ' + Tokens[1] + ';');
        Editor.Lines.Add('  post[1,0] := (-1) * ' + Tokens[2] + ';');
        Editor.Lines.Add('  post[1,1] := ' + Tokens[3] + ';');
        Editor.Lines.Add('  post[2,0] := ' + Tokens[4] + ';');
        Editor.Lines.Add('  post[2,1] := (-1) * ' + Tokens[5] + ';');
      end;


      v := Attributes.Value('chaos');
      if v <> '' then begin
        chaosLines.Add('');
        chaosLines.Add('{ Weight modifiers for transform ' + IntToStr(AddedXForms + 1) + ' }');
        chaosLines.Add('SetActiveTransform(' + IntToStr(AddedXForms) + ');');
        chaosLines.Add('with Transform do begin');
        GetTokens(String(v), tokens);
        for i := 0 to Tokens.Count-1 do
          chaosLines.Add('  chaos[' + IntToStr(i) + '] := ' + Tokens[i]) ;
        chaosLines.Add('end;');
      end;

      v := Attributes.Value('opacity');
      if v <> '' then begin
        Editor.Lines.Add('  Opacity := ' + String(v));
      end;

      for i := 0 to NRVAR - 1 do
      begin
        v := Attributes.Value(TStringType(varnames(i)));
        if v <> '' then
          Editor.Lines.Add('  ' + varnames(i) + ' := ' + String(v));
      end;

      for i := 0 to GetNrVariableNames - 1 do begin
        v := Attributes.Value(TStringType(GetVariableNameAt(i)));
        if v <> '' then begin
          Editor.Lines.Add('  ' + GetVariableNameAt(i) + ' := ' + String(v));
        end;
      end;

      Editor.Lines.Add('end;');
      AddedXForms := AddedXForms + 1;
  finally
    Tokens.free;
  end;
end;

procedure TScriptEditor.F2SXMLEndTag(Sender: TObject; TagName: string);
begin
//
end;

procedure TScriptEditor.F2SXMLStartTag(Sender: TObject; TagName: string;
  Attributes: TAttrList);
var
  Tokens: TStringList;
  v: TStringType;
  f, b: double;
begin
  Tokens := TStringList.Create;
 try

  if TagName='flame' then
  begin
    AddedXForms := 0;
    Editor.Lines.Add('{ Flame }');
    Editor.Lines.Add('Clear;');
    Editor.Lines.Add('if (pos(''7x'', LowerCase(ProgramVersionString)) >= 0) then');
    Editor.Lines.Add('  AngleTransform := 180 / PI else AngleTransform := 1;');
    Editor.Lines.Add('with Flame do begin');

    v := Attributes.Value(TStringType('size'));
    if (v <> '') then begin
      GetTokens(String(v), tokens);

      Editor.Lines.Add('  Width := ' + Tokens[0] + ';');
      Editor.Lines.Add('  Height := ' + Tokens[1] + ';');

      f := 100 / StrToFloat(Tokens[0]);
    end else f := 0;
    b := 0;
    
    v := Attributes.Value(TStringType('brightness'));
    if (v <> '') then begin
      Editor.Lines.Add('  Brightness := ' + String(v) + ';');
      b := StrToFloat(String(v));
    end;
    v := Attributes.Value(TStringType('gamma'));
    if (v <> '') then Editor.Lines.Add('  Gamma := ' + String(v) + ';');
    v := Attributes.Value(TStringType('vibrancy'));
    if (v <> '') then Editor.Lines.Add('  Vibrancy := ' + String(v) + ';');
    v := Attributes.Value(TStringType('gamma_threshold'));
    if (v <> '') then begin
      if b <> 0 then b := StrToFloat(String(v)) / b;
      Editor.Lines.Add('  GammaTreshold := ' + FloatToStr(b) + ';');
    end;

    v := Attributes.Value(TStringType('zoom'));
    if (v <> '') then Editor.Lines.Add('  Zoom := ' + String(v) + ';');
    v := Attributes.Value(TStringType('scale'));
    if (v <> '') then Editor.Lines.Add('  Scale := ' + FloatToStr(StrToFloat(String(v)) * f) + ';');
    v := Attributes.Value(TStringType('angle'));
    if (v <> '') then Editor.Lines.Add('  Angle := ' + String(v) + ';');

    // 3d
    v := Attributes.Value(TStringType('cam_pitch'));
    if (v <> '') then Editor.Lines.Add('  Pitch := ' + String(v) + ' * AngleTransform;');
    v := Attributes.Value(TStringType('cam_yaw'));
    if (v <> '') then Editor.Lines.Add('  Yaw := ' + String(v) + ' * AngleTransform;');
    v := Attributes.Value(TStringType('cam_perspective'));
    if (v <> '') then Editor.Lines.Add('  Perspective := ' + String(v) + ';');
    v := Attributes.Value(TStringType('cam_zpos'));
    if (v <> '') then Editor.Lines.Add('  Z := ' + String(v) + ';');
    v := Attributes.Value(TStringType('cam_dof'));
    if (v <> '') then Editor.Lines.Add('  DOF := ' + String(v) + ';');

    try
      v := Attributes.Value(TStringType('center'));
      if (v <> '') then begin
        GetTokens(String(v), tokens);
        Editor.Lines.Add('  X := ' + Tokens[0] + ';');
        Editor.Lines.Add('  Y := ' + Tokens[1] + ';');
      end;
    except
      Editor.Lines.Add('  X := 0' + ';');
      Editor.Lines.Add('  Y := 0' + ';');
    end;

    try
      v := Attributes.Value(TStringType('background'));
      if (v <> '') then begin
        GetTokens(String(v), tokens);

        Editor.Lines.Add('  Background[0] := ' + FloatToStr(Floor(StrToFloat(Tokens[0]) * 255)) + ';');
        Editor.Lines.Add('  Background[1] := ' + FloatToStr(Floor(StrToFloat(Tokens[1]) * 255)) + ';');
        Editor.Lines.Add('  Background[2] := ' + FloatToStr(Floor(StrToFloat(Tokens[2]) * 255)) + ';');
      end;
    except
      Editor.Lines.Add('  Background[0] := 0' + ';');
      Editor.Lines.Add('  Background[1] := 0' + ';');
      Editor.Lines.Add('  Background[2] := 0' + ';');
    end;

    v := Attributes.Value(TStringType('soloxform'));
    if (v <> '') then Editor.Lines.Add('SoloXform := ' + String(v) + ';');

    Editor.Lines.Add('end;');
  end;
 finally
    Tokens.free;
 end;
end;

procedure TScriptEditor.LoadRunAndClear(scriptFile:string);
begin
  LoadScriptFile(scriptFile);
  RunScript;
  btnNewClick(btnNew);
end;

end.


