{
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Borys, Peter Sdobnov     

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
unit Editor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Math, Menus, ToolWin, Registry,
  ControlPoint, Render, cmap, Grids, ValEdit, Buttons, ImgList, CustomDrawControl,
  Types, XForm;

const
//  PixelCountMax = 32768;
//  WM_PTHREAD_COMPLETE = WM_APP + 5438;

  crEditArrow = 20;
  crEditMove = 21;
  crEditRotate = 22;
  crEditScale = 23;

type
  TEditForm = class(TForm)
    GrphPnl: TPanel;
    StatusBar: TStatusBar;
    ControlPanel: TPanel;
    lblTransform: TLabel;
    PrevPnl: TPanel;
    PreviewImage: TImage;
    EditPopup: TPopupMenu;
    mnuAdd: TMenuItem;
    mnuAutoZoom: TMenuItem;
    N1: TMenuItem;
    mnuUndo: TMenuItem;
    mnuRedo: TMenuItem;
    QualityPopup: TPopupMenu;
    mnuLowQuality: TMenuItem;
    mnuMediumQuality: TMenuItem;
    mnuHighQuality: TMenuItem;
    N3: TMenuItem;
    mnuResetLoc: TMenuItem;
    N4: TMenuItem;
    mnuFlipVertical: TMenuItem;
    mnuFlipHorizontal: TMenuItem;
    cbTransforms: TComboBox;
    PageControl: TPageControl;
    TriangleTab: TTabSheet;
    tabXForm: TTabSheet;
    txtA: TEdit;
    txtB: TEdit;
    txtC: TEdit;
    txtD: TEdit;
    txtE: TEdit;
    txtF: TEdit;
    txtP: TEdit;
    tabVariations: TTabSheet;
    VEVars: TValueListEditor;
    tabColors: TTabSheet;
    GroupBox1: TGroupBox;
    scrlXFormColor: TScrollBar;
    pnlXFormColor: TPanel;
    txtXFormColor: TEdit;
    GroupBox2: TGroupBox;
    chkHelpers: TCheckBox;
    TriangleScrollBox: TScrollBox;
    TrianglePanel: TPanel;
    txtCy: TEdit;
    txtCx: TEdit;
    txtBy: TEdit;
    txtBx: TEdit;
    txtAy: TEdit;
    txtAx: TEdit;
    LabelB: TLabel;
    LabelA: TLabel;
    LabelC: TLabel;
    btTrgRotateRight: TSpeedButton;
    btTrgRotateLeft: TSpeedButton;
    btTrgMoveUp: TSpeedButton;
    btTrgMoveRight: TSpeedButton;
    btTrgMoveLeft: TSpeedButton;
    btTrgMoveDown: TSpeedButton;
    btTrgScaleUp: TSpeedButton;
    btTrgScaleDown: TSpeedButton;
    btTrgRotateRight90: TSpeedButton;
    btTrgRotateLeft90: TSpeedButton;
    txtTrgMoveValue: TComboBox;
    txtTrgRotateValue: TComboBox;
    txtTrgScaleValue: TComboBox;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    EditorToolBar: TToolBar;
    tbAdd: TToolButton;
    tbDuplicate: TToolButton;
    tbDelete: TToolButton;
    ToolButton4: TToolButton;
    tbMove: TToolButton;
    tbRotate: TToolButton;
    ToolButton1: TToolButton;
    tbUndo: TToolButton;
    tbRedo: TToolButton;
    ToolButton5: TToolButton;
    tbScale: TToolButton;
    tbFlipHorz: TToolButton;
    tbFlipVert: TToolButton;
    tbSelect: TToolButton;
    btTrgMoveLU: TSpeedButton;
    btTrgMoveLD: TSpeedButton;
    btTrgMoveRU: TSpeedButton;
    btTrgMoveRD: TSpeedButton;
    EditorTB: TImageList;
    TabSheet4: TTabSheet;
    vleVariables: TValueListEditor;
    tbResetAll: TToolButton;
    btnResetCoefs: TSpeedButton;
    btnXcoefs: TSpeedButton;
    btnYcoefs: TSpeedButton;
    btnOcoefs: TSpeedButton;
    btnCoefsRect: TSpeedButton;
    btnCoefsPolar: TSpeedButton;
    Label1: TLabel;
    trkVarPreviewDensity: TTrackBar;
    trkVarPreviewRange: TTrackBar;
    ToolButton2: TToolButton;
    tbVarPreview: TToolButton;
    trkVarPreviewDepth: TTrackBar;
    chkPreserve: TCheckBox;
    btnXpost: TSpeedButton;
    btnYpost: TSpeedButton;
    btnOpost: TSpeedButton;
    txtPost00: TEdit;
    txtPost01: TEdit;
    txtPost10: TEdit;
    txtPost11: TEdit;
    txtPost20: TEdit;
    txtPost21: TEdit;
    btnResetPostXForm: TSpeedButton;
    btnSwapXforms: TSpeedButton;
    GroupBox3: TGroupBox;
    editPivotY: TEdit;
    editPivotX: TEdit;
    btnResetPivot: TSpeedButton;
    btnPickPivot: TSpeedButton;
    btnPivotMode: TSpeedButton;
    tbEnableFinalXform: TToolButton;
    chkUseXFormColor: TCheckBox;
    ToolButton3: TToolButton;
    TrianglePopup: TPopupMenu;
    mnuDuplicate: TMenuItem;
    mnuDelete: TMenuItem;
    mnuAdd1: TMenuItem;
    N2: TMenuItem;
    mnuShowVarPreview: TMenuItem;
    mnuReset: TMenuItem;
    N6: TMenuItem;
    Rotatetriangle90CCW1: TMenuItem;
    Rotatetriangle90CCW2: TMenuItem;
    txtSymmetry: TEdit;
    pnlWeight: TPanel;
    pnlSymmetry: TPanel;
    procedure ValidateVariable;
    procedure vleVariablesValidate(Sender: TObject; ACol, ARow: Integer; const KeyName, KeyValue: string);
    procedure vleVariablesKeyPress(Sender: TObject; var Key: Char);
    procedure vleVariablesExit(Sender: TObject);

    procedure FormCreate(Sender: TObject);

    procedure TriangleViewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: integer);
    procedure TriangleViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure TriangleViewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure TriangleViewMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
//    procedure TriangleViewDblClick(Sender: TObject);
    procedure TriangleViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TriangleViewKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TriangleViewExit(Sender: TObject);
    procedure TriangleViewMouseLeave(Sender: TObject);
    procedure TriangleViewInvalidate(Sender: TObject);

    procedure FormShow(Sender: TObject);
    procedure mnuDeleteClick(Sender: TObject);
    procedure mnuAddClick(Sender: TObject);
    procedure mnuDupClick(Sender: TObject);
    procedure mnuAutoZoomClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure txtPKeyPress(Sender: TObject; var Key: Char);
    procedure CornerEditKeyPress(Sender: TObject; var Key: Char);
    procedure CornerEditExit(Sender: TObject);
    procedure txtPExit(Sender: TObject);
    procedure DrawPreview;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuUndoClick(Sender: TObject);
    procedure mnuRedoClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuLowQualityClick(Sender: TObject);
    procedure mnuHighQualityClick(Sender: TObject);
    procedure mnuMediumQualityClick(Sender: TObject);
    procedure mnuResetLocClick(Sender: TObject);
    procedure mnuVerticalFlipAllClick(Sender: TObject);
    procedure mnuHorizintalFlipAllClick(Sender: TObject);
    procedure mnuFlipVerticalClick(Sender: TObject);
    procedure mnuFlipHorizontalClick(Sender: TObject);
    procedure cbTransformsChange(Sender: TObject);
    procedure CoefKeyPress(Sender: TObject; var Key: Char);
    procedure CoefValidate(Sender: TObject);
    procedure scrlXFormColorScroll(Sender: TObject;
      ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure scrlXFormColorChange(Sender: TObject);
    procedure chkUseXFormColorClick(Sender: TObject);
    procedure chkHelpersClick(Sender: TObject);
    procedure txtXFormColorExit(Sender: TObject);
    procedure txtXFormColorKeyPress(Sender: TObject; var Key: Char);
    procedure txtSymmetrySet(Sender: TObject);
    procedure txtSymmetrKeyPress(Sender: TObject; var Key: Char);

    procedure btTrgRotateLeftClick(Sender: TObject);
    procedure btTrgRotateRightClick(Sender: TObject);
    procedure btTrgRotateLeft90Click(Sender: TObject);
    procedure btTrgRotateRight90Click(Sender: TObject);
    procedure TrgMove(dx, dy: double);
    procedure btTrgMoveLeftClick(Sender: TObject);
    procedure btTrgMoveRightClick(Sender: TObject);
    procedure btTrgMoveUpClick(Sender: TObject);
    procedure btTrgMoveDownClick(Sender: TObject);
    procedure btTrgMoveLUClick(Sender: TObject);
    procedure btTrgMoveLDClick(Sender: TObject);
    procedure btTrgMoveRUClick(Sender: TObject);
    procedure btTrgMoveRDClick(Sender: TObject);
    procedure btTrgScaleUpClick(Sender: TObject);
    procedure btTrgScaleDownClick(Sender: TObject);
    procedure splitterMoved(Sender: TObject);
    procedure tbSelectClick(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure tbEditModeClick(Sender: TObject);

    procedure ValidateVariation;
//    procedure ValidateValue(Sender: TObject);
    procedure VEVarsKeyPress(Sender: TObject; var Key: Char);
    procedure VEVarsChange(Sender: TObject);
    procedure VEVarsValidate(Sender: TObject; ACol, ARow: Integer;
      const KeyName, KeyValue: String);
    procedure VEVarsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VEVarsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure VEVarsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VEVarsDblClick(Sender: TObject);

    procedure cbTransformsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);

    procedure tbFullViewClick(Sender: TObject);

    procedure EditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtValidateValue(Sender: TObject);
    procedure txtValKeyPress(Sender: TObject; var Key: Char);
    procedure mnuResetClick(Sender: TObject);
    procedure mnuResetAllClick(Sender: TObject);
    procedure btnXcoefsClick(Sender: TObject);
    procedure btnYcoefsClick(Sender: TObject);
    procedure btnOcoefsClick(Sender: TObject);
    procedure btnCoefsModeClick(Sender: TObject);
    procedure tbVarPreviewClick(Sender: TObject);
    procedure trkVarPreviewRangeChange(Sender: TObject);
    procedure trkVarPreviewDensityChange(Sender: TObject);
    procedure trkVarPreviewDepthChange(Sender: TObject);
    procedure btnXpostClick(Sender: TObject);
    procedure btnYpostClick(Sender: TObject);
    procedure btnOpostClick(Sender: TObject);
    procedure PostCoefValidate(Sender: TObject);
    procedure PostCoefKeypress(Sender: TObject; var Key: Char);
    procedure btnResetPostXFormClick(Sender: TObject);
    procedure btnSwapXformsClick(Sender: TObject);
    procedure btnPivotModeClick(Sender: TObject);
    procedure PivotValidate(Sender: TObject);
    procedure PivotKeyPress(Sender: TObject; var Key: Char);
    procedure btnResetPivotClick(Sender: TObject);
    procedure btnPickPivotClick(Sender: TObject);
    procedure VEVarsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure tbEnableFinalXformClick(Sender: TObject);
    procedure DragPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DragPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DragPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DragPanelDblClick(Sender: TObject);

  private
    TriangleView: TCustomDrawControl;
    cmap: TColorMap;
    PreviewDensity: double;

    // --Z--
    viewDragMode, viewDragged: boolean;
    editMode, oldMode: (modeNone, modeMove, modeRotate, modeScale, modePick);
    modeKey: word;
    key_handled: boolean;
    updating: boolean;

    MousePos: TPoint; // in screen coordinates
    mouseOverTriangle, mouseOverCorner: integer;
    mouseOverPos: TSPoint;

    varDragMode: boolean;
    varDragIndex: integer;
    varDragValue: double;
    varDragPos, varDragOld: integer;
    varMM: boolean; //hack?

    showVarPreview: boolean;

    // --Z-- variables moved from outside
    GraphZoom: double;
    TriangleCaught, CornerCaught: boolean;
    LocalAxisLocked: boolean;
//    SelectedTriangle: integer; // outside only for scripting (??)
    SelectedCorner: integer;
    SelectMode: boolean;
    HasChanged: boolean;

    oldx, oldy, olddist: double;
    Pivot, LocalPivot, WorldPivot: TSPoint;
    PivotMode: (pivotLocal, pivotWorld); 
    VarsCache: array[0..64] of double; // hack: to prevent slow valuelist redraw

    pnlDragMode: boolean;
    pnlDragPos, pnlDragOld: integer;
    pnlDragValue: double;

(*
    { Options }
    UseFlameBackground, UseTransformColors: boolean;
    BackGroundColor, ReferenceTrianglecolor: integer;
    GridColor1, GridColor2, HelpersColor: integer;
*)
    procedure UpdateFlameX;
    procedure UpdateFlame(DrawMain: boolean);
    procedure DeleteTriangle(t: integer);

    function GetPivot: TSPoint; overload;
    function GetPivot(n: integer): TSPoint; overload;
//moved to public:    function GetTriangleColor(n: integer): TColor;

    // --Z-- functions moved from outside (?)
    procedure ShowSelectedInfo;
    procedure Scale(var fx, fy: double; x, y: integer);
//    procedure ReadjustWeights(var cp: TControlPoint);

    procedure TriangleViewPaint(Sender: TObject);
    procedure AutoZoom;
  public
    cp: TControlPoint;
    Render: TRenderer;

    SelectedTriangle: integer;

    procedure UpdatePreview;
    procedure UpdateDisplay(PreviewOnly: boolean = false); //(?)

    function GetTriangleColor(n: integer): TColor;
    function LastTriangle: integer;
    function InsideTriangle(x, y: double): integer;
  end;

const
  TrgColors: array[-1..13] of TColor = (clGray,
    $0000ff, $00ffff, $00ff00, $ffff00, $ff0000, $ff00ff, $007fff,
    $7f00ff, $55ffff, $ccffcc, $ffffaa, $ff7f7f, $ffaaff, $55ccff );
var
  EditForm: TEditForm;
//  pcenterx, pcentery, pscale: double;

function ColorValToColor(c: TColorMap; index: double): TColor;
function FlipTriangleVertical(t: TTriangle): TTriangle;
function FlipTriangleHorizontal(t: TTriangle): TTriangle;
function RotateTriangle(t: TTriangle; rad: double): TTriangle;
function OffsetTriangle(t: TTriangle; range: double): TTriangle;
function ScaleTriangle(t: TTriangle; scale: double): TTriangle;
function RotateTriangleCenter(t: TTriangle; rad: double): TTriangle;
function RotateTrianglePoint(t: TTriangle; x, y, rad: double): TTriangle;
function Centroid(t: TTriangle): TSPoint;
function OffsetTriangleRandom(t: TTriangle): TTriangle;
function ScaleTriangleCenter(t: TTriangle; scale: double): TTriangle;
function ScaleTrianglePoint(t: TTriangle; x, y, scale: double): TTriangle;
//procedure ScaleAll;

implementation

uses
  Main, Global, Adjust, Mutate, XformMan;

var
  oldTriangle: TTriangle;
  gCenterX: double;
  gCenterY: double;

  HelpersEnabled: boolean = true;

{$R *.DFM}

{ Triangle transformations }

function OffsetTriangleRandom(t: TTriangle): TTriangle;
var
  r: integer;
begin
  r := random(3);
  Result.x[r] := t.x[r] + random - 0.5;
  Result.y[r] := t.y[r] + random - 0.5;
end;

function FlipTriangleVertical(t: TTriangle): TTriangle;
begin
  Result := t;
  Result.y[0] := -t.y[0];
  Result.y[1] := -t.y[1];
  Result.y[2] := -t.y[2];
end;

function FlipTriangleHorizontal(t: TTriangle): TTriangle;
begin
  Result := t;
  Result.x[0] := -t.x[0];
  Result.x[1] := -t.x[1];
  Result.x[2] := -t.x[2];
end;

function ScaleTriangle(t: TTriangle; scale: double): TTriangle;
begin
  Result.y[0] := scale * t.y[0];
  Result.y[1] := scale * t.y[1];
  Result.y[2] := scale * t.y[2];
  Result.x[0] := scale * t.x[0];
  Result.x[1] := scale * t.x[1];
  Result.x[2] := scale * t.x[2];
end;

function Centroid(t: TTriangle): TSPoint;
begin
  Result.x := (t.x[0] + t.x[1] + t.x[2]) / 3;
  Result.y := (t.y[0] + t.y[1] + t.y[2]) / 3;
end;

function ScaleTriangleCenter(t: TTriangle; scale: double): TTriangle;
var
  xr, yr: double;
  z: TSPoint;
begin
  assert(scale <> 0);

  z := Centroid(t);
  xr := z.x;
  yr := z.y;
  Result.y[0] := scale * (t.y[0] - yr) + yr;
  Result.y[1] := scale * (t.y[1] - yr) + yr;
  Result.y[2] := scale * (t.y[2] - yr) + yr;
  Result.x[0] := scale * (t.x[0] - xr) + xr;
  Result.x[1] := scale * (t.x[1] - xr) + xr;
  Result.x[2] := scale * (t.x[2] - xr) + xr;
end;

function ScaleTrianglePoint(t: TTriangle; x, y, scale: double): TTriangle;
begin
  assert(scale <> 0);

  Result.y[0] := scale * (t.y[0] - y) + y;
  Result.y[1] := scale * (t.y[1] - y) + y;
  Result.y[2] := scale * (t.y[2] - y) + y;
  Result.x[0] := scale * (t.x[0] - x) + x;
  Result.x[1] := scale * (t.x[1] - x) + x;
  Result.x[2] := scale * (t.x[2] - x) + x;
end;

function RotateTriangle(t: TTriangle; rad: double): TTriangle; //rad in Radians
var
  i: integer;
begin
  for i := 0 to 2 do
  begin
    Result.x[i] := t.x[i] * cos(rad) - t.y[i] * sin(rad);
    Result.y[i] := t.x[i] * sin(rad) + t.y[i] * cos(rad);
  end;
end;

function OffsetTriangle(t: TTriangle; range: double): TTriangle;
var
  i: integer;
  r: double;
begin
  r := (random * 2 * range) - range;
  for i := 0 to 2 do
  begin
    Result.x[i] := t.x[i] + r;
    Result.y[i] := t.y[i] + r;
  end;
end;

function RotateTriangleCenter(t: TTriangle; rad: double): TTriangle;
var
  i: integer;
  xr, yr: double;
  z: TSPoint;
begin
  z := Centroid(t);
  xr := z.x;
  yr := z.y;
  for i := 0 to 2 do
  begin
    Result.x[i] := xr + (t.x[i] - xr) * cos(rad) -
      (t.y[i] - yr) * sin(rad);
    Result.y[i] := yr + (t.x[i] - xr) * sin(rad) +
      (t.y[i] - yr) * cos(rad);
  end;
end;

function RotateTrianglePoint(t: TTriangle; x, y, rad: double): TTriangle;
var
  i: integer;
  xr, yr: double;
begin
  xr := x;
  yr := y;
  for i := 0 to 2 do
  begin
    Result.x[i] := xr + (t.x[i] - xr) * cos(rad) -
      (t.y[i] - yr) * sin(rad);
    Result.y[i] := yr + (t.x[i] - xr) * sin(rad) +
      (t.y[i] - yr) * cos(rad);
  end;
end;

function ColorValToColor(c: TColorMap; index: double): TColor;
var
  i: integer;
begin
  i := Trunc(Index * 255); //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! >>TODO: check<<
  result := c[i][2] shl 16 + c[i][1] shl 8 + c[i][0];
end;

procedure TEditForm.UpdatePreview;
var
  pw, ph: integer;
  r: double;
begin
  pw := PrevPnl.Width - 2;
  ph := PrevPnl.Height - 2;
  if (cp.width / cp.height) > (PrevPnl.Width / PrevPnl.Height) then
  begin
    PreviewImage.Width := pw;
    r := cp.width / PreviewImage.Width;
    PreviewImage.height := round(cp.height / r);
    PreviewImage.Left := 1;
    PreviewImage.Top := (ph - PreviewImage.Height) div 2;
  end
  else begin
    PreviewImage.Height := ph;
    r := cp.height / PreviewImage.height;
    PreviewImage.Width := round(cp.Width / r);
    PreviewImage.Top := 1;
    PreviewImage.Left := (pw - PreviewImage.Width) div 2;
  end;
  cp.AdjustScale(PreviewImage.Width, PreviewImage.Height);
  DrawPreview;
end;

procedure TEditForm.UpdateDisplay(PreviewOnly: boolean = false);
var
  i: integer;
//  pw, ph: integer;
begin
  // currently EditForm does not really know if we select another
  // flame in the Main Window - which is not good...
  {
  if NumXForms(cp) <> NumXForms(MainCp) then
  begin
    SelectedTriangle := 0;
    mouseOverTriangle := -1;
  end;
  }
  cp.copy(MainCp);

  if SelectedTriangle > LastTriangle{???} then//NumXForms(cp) then
  begin
    SelectedTriangle := cp.NumXForms-1;
    mouseOverTriangle := -1;
  end;

  EnableFinalXform := cp.finalXformEnabled;
  tbEnableFinalXform.Down := EnableFinalXform;

  UpdatePreview;

  if PreviewOnly then exit;

  cp.cmap := MainCp.cmap;
  cmap := MainCp.cmap;

  cbTransforms.Clear;
  for i := 1 to Transforms do cbTransforms.Items.Add(IntToStr(i));
  if cp.HasFinalXForm then cbTransforms.Items.Add('Final');

  // just in case:
  SetCaptureControl(nil);
  HasChanged := false;
  viewDragMode := false;
  varDragMode := false;
  pnlDragMode := false;
  CornerCaught := false;
  TriangleCaught := false;

  ShowSelectedInfo;
  if MainForm.UndoIndex = 0 then AutoZoom // auto-zoom only on 'new' flame - hmm...?
  else TriangleView.Invalidate;
end;

procedure TEditForm.DrawPreview;
begin
  //Render.Stop;
  cp.sample_density := PreviewDensity;
  cp.spatial_oversample := defOversample;
  cp.spatial_filter_radius := defFilterRadius;
  if mnuResetLoc.checked then
  begin
    cp.zoom := 0;
    cp.CalcBoundbox;
  end
  else
  begin
    cp.zoom := MainCp.zoom;
    cp.center[0] := MainCp.Center[0];
    cp.center[1] := MainCp.Center[1];
  end;
  cp.cmap := MainCp.cmap;
  Render.Compatibility := compatibility;
  Render.SetCP(cp);
  Render.Render;
  PreviewImage.Picture.Bitmap.Assign(Render.GetImage);
  PreviewImage.refresh;
end;

procedure TEditForm.ShowSelectedInfo;
var
  i: integer;
  v: double;
  strval: string;
begin
  updating := true;

  if (SelectedTriangle > LastTriangle) then SelectedTriangle := LastTriangle;

  cbTransforms.ItemIndex := SelectedTriangle;
  cbTransforms.Refresh;

  with MainTriangles[SelectedTriangle] do
  begin
    txtAx.text := Format('%.6g', [x[0]]);
    txtAy.text := Format('%.6g', [y[0]]);
    txtBx.text := Format('%.6g', [x[1]]);
    txtBy.text := Format('%.6g', [y[1]]);
    txtCx.text := Format('%.6g', [x[2]]);
    txtCy.text := Format('%.6g', [y[2]]);
  end;

  with cp.xform[SelectedTriangle] do
  begin
   if btnCoefsRect.Down then begin
    txtA.text := Format('%.6g', [ c[0][0]]);
    txtB.text := Format('%.6g', [-c[0][1]]);
    txtC.text := Format('%.6g', [-c[1][0]]);
    txtD.text := Format('%.6g', [ c[1][1]]);
    txtE.text := Format('%.6g', [ c[2][0]]);
    txtF.text := Format('%.6g', [-c[2][1]]);
    txtPost00.text := Format('%.6g', [ p[0][0]]);
    txtPost01.text := Format('%.6g', [-p[0][1]]);
    txtPost10.text := Format('%.6g', [-p[1][0]]);
    txtPost11.text := Format('%.6g', [ p[1][1]]);
    txtPost20.text := Format('%.6g', [ p[2][0]]);
    txtPost21.text := Format('%.6g', [-p[2][1]]);
   end
   else begin
    txtA.text := Format('%.6g', [Hypot(c[0][0], c[0][1])]);
    txtB.text := Format('%.6g', [arctan2(-c[0][1], c[0][0])*180/PI]);
    txtC.text := Format('%.6g', [Hypot(c[1][0], c[1][1])]);
    txtD.text := Format('%.6g', [arctan2(c[1][1], -c[1][0])*180/PI]);
    txtE.text := Format('%.6g', [Hypot(c[2][0], c[2][1])]);
    txtF.text := Format('%.6g', [arctan2(-c[2][1], c[2][0])*180/PI]);
    txtPost00.text := Format('%.6g', [Hypot(p[0][0], p[0][1])]);
    txtPost01.text := Format('%.6g', [arctan2(-p[0][1], p[0][0])*180/PI]);
    txtPost10.text := Format('%.6g', [Hypot(p[1][0], p[1][1])]);
    txtPost11.text := Format('%.6g', [arctan2(p[1][1], -p[1][0])*180/PI]);
    txtPost20.text := Format('%.6g', [Hypot(p[2][0], p[2][1])]);
    txtPost21.text := Format('%.6g', [arctan2(-p[2][1], p[2][0])*180/PI]);
   end;

    if SelectedTriangle < Transforms then
    begin
      txtP.text := Format('%.6g', [density]);
      txtP.Enabled := true;
    end
    else begin
      txtP.Enabled := false;
      txtP.Text := 'n/a';
    end;
    tbEnableFinalXform.Down := EnableFinalXform;

    txtSymmetry.text := Format('%.6g', [symmetry]);

    pnlXFormColor.Color := ColorValToColor(cp.cmap, color);
    txtXFormColor.Text := Format('%1.3f', [color]);
    scrlXFormcolor.Position := Trunc(color * scrlXFormColor.Max);

   for i := 0 to NRVAR-1 do begin
       v := vars[i];
      if v <> VarsCache[i] then
      begin
        VarsCache[i]:=v;
        VEVars.Values[VarNames(i)] := Format('%.6g', [v]);
      end;
    end;

    for i:= 0 to GetNrVariableNames - 1 do begin
      GetVariable(GetVariableNameAt(i), v);
      strval := Format('%.6g', [v]);
       // kinda funny, but it really helped...
      if vleVariables.Values[GetVariableNameAt(i)] <> strval then
        vleVariables.Values[GetVariableNameAt(i)] := strval;
    end;
  end;

  if PivotMode = pivotLocal then begin
    editPivotX.Text := Format('%.6g', [LocalPivot.x]);
    editPivotY.Text := Format('%.6g', [LocalPivot.y]);
  end
  else begin
    editPivotX.Text := Format('%.6g', [WorldPivot.x]);
    editPivotY.Text := Format('%.6g', [WorldPivot.y]);
  end;

  PageControl.Refresh;

  updating := false;
end;

procedure TEditForm.Scale(var fx, fy: double; x, y: integer);
var
  sc: double;
begin
  sc := 50 * GraphZoom;
  fx := (x - (TriangleView.Width / 2)) / sc + gCenterX;
  fy := -((y - (TriangleView.Height / 2)) / sc - gCentery);
end;

procedure TEditForm.AutoZoom;
var
  i, j: integer;
  xminz, yminz, xmaxz, ymaxz: double;
  gxlength, gylength: double;
begin
  xminz := 0;
  yminz := 0;
  xmaxz := 0;
  ymaxz := 0;
  for i := -1 to LastTriangle do
  begin
    for j := 0 to 2 do
    begin
      if MainTriangles[i].x[j] < xminz then xminz := MainTriangles[i].x[j];
      if MainTriangles[i].y[j] < yminz then yminz := MainTriangles[i].y[j];
      if MainTriangles[i].x[j] > xmaxz then xmaxz := MainTriangles[i].x[j];
      if MainTriangles[i].y[j] > ymaxz then ymaxz := MainTriangles[i].y[j];
    end;
  end;
  gxlength := xmaxz - xminz;
  gylength := ymaxz - yminz;
  gCenterX := xminz + gxlength / 2;
  gCentery := yminz + gylength / 2;

  if gxlength >= gylength then
    GraphZoom := TriangleView.Width / 60 / gxlength
  else
    GraphZoom := TriangleView.Height / 60 / gylength;
  EditForm.StatusBar.Panels[2].Text := Format('Zoom: %f', [GraphZoom]);

  TriangleView.Invalidate;//Refresh;
end;

procedure TEditForm.UpdateFlameX;
begin
  cp.GetFromTriangles(MainTriangles, Transforms);
  if not chkPreserve.checked then cp.ComputeWeights(MainTriangles, Transforms);
  DrawPreview;
  ShowSelectedInfo;
  TriangleView.Refresh;;
end;

procedure TEditForm.UpdateFlame(DrawMain: boolean);
begin
//;    MainForm.StopThread;
  StatusBar.Panels[2].Text := Format('Zoom: %f', [GraphZoom]);
  cp.GetFromTriangles(MainTriangles, LastTriangle);
//  if not chkPreserve.Checked then ComputeWeights(cp, MainTriangles, transforms);
  DrawPreview;
  ShowSelectedInfo;
  TriangleView.Refresh;
  if DrawMain then begin
    MainForm.StopThread;
    MainCp.Copy(cp);
    MainCp.cmap := cmap;
    if mnuResetLoc.checked then begin
      MainCp.zoom := 0;
      MainForm.center[0] := cp.center[0];
      MainForm.center[1] := cp.center[1];
    end;
//    if AdjustForm.Visible then AdjustForm.UpdateDisplay;
    if MutateForm.Visible then MutateForm.UpdateDisplay;
    MainForm.RedrawTimer.enabled := true;
  end;
end;

procedure TEditForm.DeleteTriangle(t: integer);
var
  i: integer;
begin
  if (t = Transforms) then
  begin
    assert(cp.HasFinalXForm or EnableFinalXform);
    MainForm.UpdateUndo;
    EnableFinalXform := false;
    cp.finalXformEnabled := false;
    cp.xform[Transforms].Clear;
    cp.xform[Transforms].symmetry := 1;
    assert(cp.HasFinalXForm = false);
    MainTriangles[Transforms] := MainTriangles[-1];
    tbEnableFinalXform.Down := false;
    if (SelectedTriangle = Transforms ) then Dec(SelectedTriangle);
  end
  else
  if (Transforms <= 2) then exit
  else begin
    MainForm.UpdateUndo;
    if t = (Transforms - 1) then
    begin
      MainTriangles[t] := MainTriangles[Transforms];
      cp.xform[t].Assign(cp.xform[Transforms]);
      Dec(SelectedTriangle);
    end
    else begin
      for i := t to Transforms-1 do // was: -2
      begin
        { copy higher transforms down }
        MainTriangles[i] := MainTriangles[i + 1];
        cp.xform[i].Assign(cp.xform[i + 1]);
      end;
    end;
    Dec(Transforms);
    assert(cp.xform[transforms].density = 0); // cp.xform[transforms].density := 0;
  end;
  UpdateFlame(True);
  cbTransforms.clear;
  for i := 1 to Transforms do cbTransforms.Items.Add(IntToStr(i));
  if cp.HasFinalXForm then cbTransforms.Items.Add('Final');
  cbTransforms.ItemIndex := SelectedTriangle;
end;

function TEditForm.InsideTriangle(x, y: double): integer;
var
  i, j, k: integer;
  inside: boolean;
begin
{ is x, y inside a triangle }
  Result := -1;
  inside := False;
  j := 2;
  for k := LastTriangle downto 0 do
  begin
    for i := 0 to 2 do
    begin
      if (((MainTriangles[k].y[i] <= y) and
        (y < MainTriangles[k].y[j])) or
        ((MainTriangles[k].y[j] <= y) and
        (y < MainTriangles[k].y[i]))) and
        (x < (MainTriangles[k].x[j] - MainTriangles[k].x[i]) *
        (y - MainTriangles[k].y[i]) /
        (MainTriangles[k].y[j] - MainTriangles[k].y[i]) +
        MainTriangles[k].x[i]) then
          Inside := not Inside;
      j := i
    end;
    if inside then break;
  end;
  if inside then Result := k;
end;

function TEditForm.GetTriangleColor(n: integer): TColor;
begin
  if n = Transforms then Result := clWhite
  else
  if chkUseXFormColor.checked then
    Result := ColorValToColor(MainCp.cmap, cp.xform[n].color)
  else Result := TrgColors[n mod 14];
end;

function TEditForm.LastTriangle: integer;
begin
  if EnableFinalXform or cp.HasFinalXForm then Result := Transforms
  else Result := Transforms-1;
end;

procedure TEditForm.TriangleViewPaint(Sender: TObject);
const
  foc_ofs = 4;
  foc_size = 32;
var
  ix, iy, sc: double;

  function ToScreen(fx, fy: double): TPoint;
  begin
    Result.x := integer(round(ix + (fx - gCenterX) * sc));
    Result.y := integer(round(iy - (fy - gCenterY) * sc));
  end;

var
  dx, dy: double;
  Width, Height: integer;
  BitMap: TBitMap;

  procedure LineDxDy;
  var
    k: double;
  begin
    if (dx <> 0) and (dy <> 0) then with Bitmap.Canvas do
    begin
      k := dy / dx;
      if abs(k) < 1 then begin
        MoveTo(0,     round(iy - sc*(Pivot.y - ( ix/sc-GCenterX+Pivot.x)*k - GCenterY)));
        LineTo(Width, round(iy - sc*(Pivot.y - (-ix/sc-GCenterX+Pivot.x)*k - GCenterY)));
      end
      else begin
        MoveTo(round(ix + sc*(Pivot.x - (-iy/sc-GCenterY+Pivot.y)/k - GCenterX)), 0);
        LineTo(round(ix + sc*(Pivot.x - ( iy/sc-GCenterY+Pivot.y)/k - GCenterX)), Height);
      end;
    end;
  end;
var
  i, n, tc, tn: integer;
  d, d1: double;
  tx, ty: double;

  ax, ay: integer;
  a, b, c: TPoint;

  gridX1, gridX2, gridY1, gridY2, gi, gstep: double;
  gp: TRoundToRange;

  tps: TPenStyle;
label DrawCorner;
begin
  assert(SelectedTriangle >= 0);
  assert(TCustomDrawControl(Sender) = TriangleView);
  if SelectedTriangle > LastTriangle then SelectedTriangle := LastTriangle;

  BitMap := TBitMap.Create;
  Width := TriangleView.Width;
  Height := TriangleView.Height;
  Bitmap.Width := Width;
  Bitmap.Height := Height;
  ix := Width / 2;
  iy := Height / 2;
  sc := 50 * GraphZoom;
  try
    with Bitmap.Canvas do
    begin
      brush.Color := EditorBkgColor; 
      FillRect(Rect(0, 0, Width, Height));

      Pen.Style := psSolid;
      Pen.Width := 1;

      // draw grid
      Pen.Color := GridColor2;
      gridX1:=gCenterX-ix/sc;
      gridX2:=gCenterX+(Width-ix)/sc;
      gridY1:=gCenterY-iy/sc;
      gridY2:=gCenterY+(Height-iy)/sc;
      try // who knows... ;)
        gp:=round(log10(max(Width, Height)/sc))-1;
        gstep:=power(10.0, gp);
      except
        gp:=0;
        gstep:=1.0;
      end;

      gi:=RoundTo(gridX1, gp);
      while gi <= gridX2 do
      begin
        ax:=integer(round(ix + (gi - gCenterX)*sc));
        MoveTo(ax, 0);
        LineTo(ax, Height);
        gi:=gi+gstep;
      end;
      gi:=RoundTo(gridY1, gp);
      while gi <= gridY2 do
      begin
        ay:=integer(round(iy - (gi - gCenterY)*sc));
        MoveTo(0, ay);
        LineTo(Width, ay);
        gi:=gi+gstep;
      end;
      // draw axis
      Pen.Color := GridColor1;
      ax := integer(round(ix - gCenterX*sc));
      ay := integer(round(iy + gCentery*sc));
      MoveTo(ax, 0);
      LineTo(ax, Height-1);
      MoveTo(0, ay);
      LineTo(Width-1, ay);

      {Reference Triangle}
      Pen.Style := psDot;
      Pen.color := ReferenceTriangleColor;
      brush.Color := gridColor1 shr 1 and $7f7f7f;
      a := ToScreen(MainTriangles[-1].x[0], MainTriangles[-1].y[0]);
      b := ToScreen(MainTriangles[-1].x[1], MainTriangles[-1].y[1]);
      c := ToScreen(MainTriangles[-1].x[2], MainTriangles[-1].y[2]);
      Polyline([a, b, c, a]);

      brush.Color := EditorBkgColor;
      Font.color := Pen.color;
      TextOut(c.x-9, c.y-12, 'Y');
      TextOut(a.x+2, a.y+1, 'X');
      TextOut(b.x-8, b.y+1, 'O');

      Pen.Style := psSolid;

      // Draw Triangles
      for i := 0 to LastTriangle do
      begin
        if i <> SelectedTriangle then Pen.Style := psDot;

with cp.xform[i] do
if (p[0,0]<>1) or (p[0,1]<>0) or(p[1,0]<>0) or (p[1,1]<>1) or (p[2,0]<>0) or (p[2,1]<>0) then
begin
  Pen.Color := GetTriangleColor(i) shr 1 and $7f7f7f;
  //Pen.Mode := pmMerge;
  a:=toscreen(p[0,0] - p[1,0] + p[2,0], -p[0,1] + p[1,1] - p[2,1]);
  moveto(a.x, a.y);
  b:=toscreen(p[0,0] + p[1,0] + p[2,0], -p[0,1] - p[1,1] - p[2,1]);
  lineto(b.x, b.y);
  b:=toscreen(-p[0,0] + p[1,0] + p[2,0], p[0,1] - p[1,1] - p[2,1]);
  lineto(b.x, b.y);
  b:=toscreen(-p[0,0] - p[1,0] + p[2,0], p[0,1] + p[1,1] - p[2,1]);
  lineto(b.x, b.y);
  lineto(a.x, a.y);


  tps := Pen.Style;
  Pen.Style := psDot;
  a:=toscreen(p[1,0] + p[2,0], -p[1,1] - p[2,1]);
  moveto(a.x, a.y);
  a:=toscreen(-p[1,0] + p[2,0], p[1,1] - p[2,1]);
  lineto(a.x, a.y);

  a:=toscreen(p[0,0] + p[2,0], -p[0,1] - p[2,1]);
  lineto(a.x, a.y);
  a:=toscreen(-p[0,0] + p[2,0], p[0,1] - p[2,1]);
  lineto(a.x, a.y);
  Pen.Style := tps;
end;

        Pen.Color := GetTriangleColor(i);
        a := ToScreen(MainTriangles[i].x[0], MainTriangles[i].y[0]);
        b := ToScreen(MainTriangles[i].x[1], MainTriangles[i].y[1]);
        c := ToScreen(MainTriangles[i].x[2], MainTriangles[i].y[2]);
        Polyline([a, b, c, a]);

        Pen.Style := psSolid;
        Ellipse(a.x - 4, a.y - 4, a.x + 4, a.y + 4);
        Ellipse(b.x - 4, b.y - 4, b.x + 4, b.y + 4);
        Ellipse(c.x - 4, c.y - 4, c.x + 4, c.y + 4);

        Font.color := Pen.color;
        TextOut(c.x+2, c.y+1, 'Y');
        TextOut(a.x+2, a.y+1, 'X');
        TextOut(b.x+2, b.y+1, 'O');
      end;

      if showVarPreview then
      begin
        assert(trkVarPreviewRange.position > 0);
        assert(trkVarPreviewDensity.position > 0);

        cp.xform[SelectedTriangle].prepare;

        n := trkVarPreviewRange.position * trkVarPreviewDensity.position * 5;
        d1 := trkVarPreviewDensity.position * 5;
        tc := GetTriangleColor(SelectedTriangle);
        for ax := -n to n do
          for ay := -n to n do
          try
            tx := ax / d1;
            ty := ay / d1;
            for i := trkVarPreviewDepth.position downto 1 do
              cp.xform[SelectedTriangle].NextPointXY(tx, ty);
            a := toscreen(tx, -ty);
            Pixels[a.x, a.y] := tc;
          except
          end;
      end;

      if (TriangleCaught or CornerCaught) then // if dragging, draw pivot axis
      begin
       mouseOverTriangle := SelectedTriangle;

       if HelpersEnabled then
       begin
        pen.Color := HelpersColor;
        pen.Mode := pmMerge;
        pen.Style := psSolid;
        a := ToScreen(Pivot.x, Pivot.y);
        MoveTo(a.x, 0);
        LineTo(a.x, Height);
        MoveTo(0, a.y);
        LineTo(Width, a.y);

        if (editMode = modeRotate) then // draw circle
        begin
          if CornerCaught then begin
            dx := MainTriangles[SelectedTriangle].x[SelectedCorner] - Pivot.x;
            dy := MainTriangles[SelectedTriangle].y[SelectedCorner] - Pivot.y;
            d := Hypot(dx, dy);
          end
          else begin
            dx := MainTriangles[SelectedTriangle].x[0] - Pivot.x;
            dy := MainTriangles[SelectedTriangle].y[0] - Pivot.y;
            d := Hypot(dx, dy);
            for i := 1 to 2 do
            begin
              d1 := dist(Pivot.x, Pivot.y, MainTriangles[SelectedTriangle].x[i], MainTriangles[SelectedTriangle].y[i]);
              if d1 > d then
              begin
                dx := dx/d*d1;
                dy := dy/d*d1;
                d := d1;
              end;
            end;
          end;

          //i := min( min(Width, Height), integer(round(dmax * sc)));
          i := integer(round(d * sc));
          if i > 4 then
          begin
            pen.Color := HelpersColor;
            brush.Style := bsClear;
            Ellipse(a.x - i, a.y - i, a.x + i, a.y + i);

            a := ToScreen(Pivot.x - dy, Pivot.y + dx);
            b := ToScreen(Pivot.x + dy, Pivot.y - dx);
            c := ToScreen(Pivot.x, Pivot.y);
            MoveTo(a.x, a.y);
            LineTo(c.X, c.y); // not necessary but it looks better with it...
            LineTo(b.X, b.y);
          end;

          // rotated axis
          LineDxDy;
        end
        else if (editMode = modeScale) then // draw lines
        begin
          if CornerCaught then begin
            dx := MainTriangles[SelectedTriangle].x[SelectedCorner] - Pivot.x;
            dy := MainTriangles[SelectedTriangle].y[SelectedCorner] - Pivot.y;
            LineDxDy;
          end
          else begin // hmmm...
            dx := MainTriangles[SelectedTriangle].x[0] - Pivot.x;
            dy := MainTriangles[SelectedTriangle].y[0] - Pivot.y;
            LineDxDy;
            dx := MainTriangles[SelectedTriangle].x[1] - Pivot.x;
            dy := MainTriangles[SelectedTriangle].y[1] - Pivot.y;
            LineDxDy;
            dx := MainTriangles[SelectedTriangle].x[2] - Pivot.x;
            dy := MainTriangles[SelectedTriangle].y[2] - Pivot.y;
            LineDxDy;
          end;
        end
        else //if editMode = modeMove then // draw target axis
        begin
          Pen.Color := HelpersColor;
          Pen.Mode := pmMerge;//Xor;
          brush.Color := 0;
          if CornerCaught then
            a := ToScreen(MainTriangles[SelectedTriangle].x[SelectedCorner],
                          MainTriangles[SelectedTriangle].y[SelectedCorner])
          else
            a := ToScreen(GetPivot.x, GetPivot.y);
          MoveTo(a.x, 0);
          LineTo(a.x, Height);
          MoveTo(0, a.y);
          LineTo(Width, a.y);
          Pen.Mode := pmCopy;
        end;
       end; // endif HelpersEnabled
      end;

      if (mouseOverTriangle >= 0) then // highlight triangle under cursor
      begin
        a := ToScreen(MainTriangles[mouseOverTriangle].x[0], MainTriangles[mouseOverTriangle].y[0]);
        b := ToScreen(MainTriangles[mouseOverTriangle].x[1], MainTriangles[mouseOverTriangle].y[1]);
        c := ToScreen(MainTriangles[mouseOverTriangle].x[2], MainTriangles[mouseOverTriangle].y[2]);

        pen.Width:=2;
        Pen.Color:=GetTriangleColor(mouseOverTriangle) shr 1 and $7f7f7f;
        Pen.Mode:=pmMerge;
        brush.Color:=Pen.Color shr 1 and $7f7f7f;

        if (SelectMode and (editMode <> modePick)) or (mouseOverTriangle = SelectedTriangle) then
          Polygon([a, b, c])
        else
          PolyLine([a, b, c, a]);

        pen.width:=4;
        Ellipse(a.x - 3, a.y - 3, a.x + 3, a.y + 3);
        Ellipse(b.x - 3, b.y - 3, b.x + 3, b.y + 3);
        Ellipse(c.x - 3, c.y - 3, c.x + 3, c.y + 3);
        pen.width:=1;
        pen.mode:=pmCopy;

        if not (CornerCaught or TriangleCaught) then // show used variations
        begin
          font.Color := GetTriangleColor(mouseOverTriangle);
          brush.Style := bsClear;
          ay := Height-foc_ofs*2 + font.Height; // font.height < 0
          for i:= NRVAR - 1 downto 0 do
            if cp.xform[mouseOverTriangle].vars[i] <> 0 then
            begin
              ax := Width-foc_ofs*2 - TextWidth(Varnames(i));
              TextOut(ax, ay, Varnames(i));
              Inc(ay, font.Height);
            end;
//        brush.Style := bsSolid;
        end;
      end;

      pen.color := clWhite;
      if CornerCaught then // draw selected corner
      begin
        brush.Color:=clSilver;
        a := ToScreen(MainTriangles[SelectedTriangle].x[SelectedCorner], MainTriangles[SelectedTriangle].y[SelectedCorner]);
        Ellipse(a.x - 4, a.y - 4, a.x + 4, a.y + 4);
      end
      else if (mouseOverTriangle>=0) and (mouseOverCorner >= 0) then // highlight corner under cursor
      begin
        case mouseOverCorner of
          0: brush.Color:=clRed;
          2: brush.Color:=clBlue;
          else brush.Color:=clSilver;
        end;

        a := ToScreen(MainTriangles[mouseOverTriangle].x[mouseOverCorner], MainTriangles[mouseOverTriangle].y[mouseOverCorner]);
        Ellipse(a.x - 4, a.y - 4, a.x + 4, a.y + 4);

        // hmm... TODO: optimize
        if HelpersEnabled then begin
          pen.Color := HelpersColor;
          pen.Mode := pmMerge;
          pen.Style := psDot;
          brush.Style := bsClear;
          if (editMode = modeRotate) then
          begin
            i := integer(round(olddist * sc));
            if i > 4 then begin
              a := ToScreen(pivot.x, pivot.y);
              Ellipse(a.x - i, a.y - i, a.x + i, a.y + i);
            end;
          end
          else if editMode = modeScale then
          begin
            dx := MainTriangles[mouseOverTriangle].x[mouseOverCorner] - Pivot.x;
            dy := MainTriangles[mouseOverTriangle].y[mouseOverCorner] - Pivot.y;
            LineDxDy;
          end;
        end;
      end;

      // draw pivot point
      a := ToScreen(GetPivot.x, GetPivot.y);
      Pen.Style := psSolid;
      pen.Color := clWhite;
      brush.Color := clSilver;
      if pivotMode = pivotLocal then i := 2
      else i := 3;
      Ellipse(a.x - i, a.y - i, a.x + i, a.y + i);

      if editMode = modePick then begin // hmm...
        a := ToScreen(mouseOverPos.x, mouseOverPos.y);
        brush.Style := bsClear;
        Ellipse(a.x - i, a.y - i, a.x + i, a.y + i);
      end;

      if TWinControl(Sender).Focused then
      begin
        pen.Color := HelpersColor;
        pen.Mode := pmXor;
        MoveTo(foc_ofs, foc_size);
        LineTo(foc_ofs, foc_ofs);
        LineTo(foc_size, foc_ofs);
        MoveTo(Width-1-foc_ofs, foc_size);
        LineTo(Width-1-foc_ofs, foc_ofs);
        LineTo(Width-1-foc_size, foc_ofs);
        MoveTo(Width-1-foc_ofs, Height-1-foc_size);
        LineTo(Width-1-foc_ofs, Height-1-foc_ofs);
        LineTo(Width-1-foc_size, Height-1-foc_ofs);
        MoveTo(foc_ofs, Height-1-foc_size);
        LineTo(foc_ofs, Height-1-foc_ofs);
        LineTo(foc_size, Height-1-foc_ofs);
      end;
    end;
    TriangleView.Canvas.Draw(0, 0, Bitmap);
  finally
    BitMap.Free;
  end;
end;

procedure TEditForm.FormCreate(Sender: TObject);
var
  i: integer;
begin
  Screen.Cursors[crEditArrow]  := LoadCursor(HInstance, 'ARROW_WHITE');
  Screen.Cursors[crEditMove]   := LoadCursor(HInstance, 'MOVE_WB');
  Screen.Cursors[crEditRotate] := LoadCursor(HInstance, 'ROTATE_WB');
  Screen.Cursors[crEditScale]  := LoadCursor(HInstance, 'SCALE_WB');

  // Custom control setup
  TriangleView := TCustomDrawControl.Create(self);
  TriangleView.TabStop  := True;
  TriangleView.TabOrder := 0;
  TriangleView.Parent   := GrphPnl;
  TriangleView.Align    := alClient;
  TriangleView.Visible  := True;

  TriangleView.OnPaint := TriangleViewPaint;

  TriangleView.OnDblClick   := mnuAutoZoomClick;
  TriangleView.OnMouseDown  := TriangleViewMouseDown;
  TriangleView.OnMouseMove  := TriangleViewMouseMove;
  TriangleView.OnMouseUp    := TriangleViewMouseUp;
  TriangleView.OnMouseWheel := TriangleViewMouseWheel;
  TriangleView.OnKeyDown    := TriangleViewKeyDown;
  TriangleView.OnKeyUp      := TriangleViewKeyUp;

  TriangleView.OnEnter      := TriangleViewInvalidate;
  TriangleView.OnExit       := TriangleViewExit;
  TriangleView.OnMouseLeave := TriangleViewmouseLeave;
//

  for i:= 0 to NRVAR - 1 do begin
    VEVars.InsertRow(Varnames(i), '0', True);
  end;

  for i:= 0 to GetNrVariableNames - 1 do begin
    vleVariables.InsertRow(GetVariableNameAt(i), '0', True);
  end;

  GraphZoom := 1;

  case EditPrevQual of
    0: begin
        mnuLowQuality.Checked := true;
        PreviewDensity := prevLowQuality;
      end;
    1: begin
        mnuMediumQuality.Checked := true;
        PreviewDensity := prevMediumQuality;
      end;
    2: begin
        mnuHighQuality.Checked := true;
        PreviewDensity := prevHighQuality;
      end;
  end;
  cp := TControlPoint.Create;
  Render := TRenderer.Create;

  SelectMode := true;
  editMode := modeMove;

  CornerCaught := False;
  TriangleCaught := False;
  mouseOverTriangle := -1;
  mouseOverCorner := -1;

  for i := 0 to NRVAR-1 do
    VarsCache[i] := MinDouble;
end;

procedure TEditForm.TriangleViewMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  vx, vy, fx, fy: double;
  mt, mc: integer;
  a, t: double;

  i, j: integer;
  d: double;

  i0, i1: integer;
label FoundCorner, Skip1, Skip2;
begin
  Scale(fx, fy, x, y);
  StatusBar.Panels[0].Text := Format('X: %f', [fx]);
  StatusBar.Panels[1].Text := Format('Y: %f', [fy]);

  if viewDragMode then // graph panning
  begin
    viewDragged := true;
    GcenterX := GcenterX - (fx - oldx);
    GcenterY := GcenterY - (fy - oldy);
    TriangleView.Refresh;
    exit;
  end;

  mt:=mouseOverTriangle;
  mc:=MouseOverCorner;

  if not (CornerCaught or TriangleCaught) then // look for a point under cursor
  begin
    if SelectMode then
    begin
      i0:=0;
      i1:=LastTriangle;//Transforms-1;
    end
    else begin
      i0:=SelectedTriangle;
      i1:=i0;
    end;

    for i := i1 downto i0 do
      for j := 0 to 2 do
      begin
        d := dist(fx, fy, MainTriangles[i].x[j], MainTriangles[i].y[j]);
        if (d * GraphZoom * 50) < 4 then
        begin
          mouseOverTriangle:=i;
          mouseOverCorner:=j;

// -- from MouseDown -- for highlighting:
// TODO: optimize...
    if (j = 1) then //and ((rgPivot.ItemIndex = 1) or (rgPivot.ItemIndex = 4)) then
    begin
      if PivotMode = pivotLocal then begin
        Pivot.x := 0;
        Pivot.y := 0;
      end
      else Pivot := GetPivot;

      LocalAxisLocked := true;
    end
    else begin
      Pivot := GetPivot(mouseOverTriangle);
      LocalAxisLocked := false;
    end;
    oldx := MainTriangles[mouseOverTriangle].x[j] - Pivot.X;
    oldy := MainTriangles[mouseOverTriangle].y[j] - Pivot.Y;
    olddist := Hypot(oldx, oldy);
// --

// -- for Pick Pivot
    if editMode = modePick then
    begin
      mouseOverPos.x := MainTriangles[mouseOverTriangle].x[mouseOverCorner];
      mouseOverPos.y := MainTriangles[mouseOverTriangle].y[mouseOverCorner];
    end;
// ---
          goto FoundCorner;
        end;
      end;
    mouseOverCorner:=-1;
    mouseOverPos.x := fx;
    mouseOverPos.y := fy;

    i := InsideTriangle(fx, fy);
    if i >= 0 then mouseOverTriangle:=i
    else mouseOverTriangle:=-1;

FoundCorner:
  end;

  if (mouseOverTriangle >= 0) or (SelectMode = false) or (oldMode <> modeNone) then
    case editMode of
      modeMove:
        TriangleView.Cursor := crEditMove;
      modeRotate:
        TriangleView.Cursor := crEditRotate;
      modeScale:
        TriangleView.Cursor := crEditScale;
      modePick:
        TriangleView.Cursor := crEditArrow;
    end
  else
    TriangleView.Cursor := crEditArrow; //crDefault;

  Shift := Shift - [ssLeft];

  if CornerCaught then // Modify a point ///////////////////////////////////////
  begin
    if (editMode = modeRotate) then // rotate point
    begin // rotate point around pivot
      d := dist(Pivot.X, Pivot.Y, fx, fy);
      if d<>0 then begin
        if ssShift in Shift then // angle snap
        begin
          try
            t := StrToFloat(txtTrgRotateValue.Text)/180*PI;
            //assert(t<>0);
          except
            t := 15.0*PI/180.0;
            txtTrgRotateValue.Text := '15';
          end;
          if t = 0 then goto Skip1; //?

          a := Round(arctan2(fy-Pivot.Y, fx-Pivot.X)/t)*t;
          vx := olddist*cos(a);
          vy := olddist*sin(a);
        end
        else begin
Skip1:
          vx := (fx-Pivot.X)*olddist/d;
          vy := (fy-Pivot.Y)*olddist/d;
          a := arctan2(vy,vx) - arctan2(oldy,oldx);
        end;

        if LocalAxisLocked then with MainTriangles[SelectedTriangle] do
        begin
          assert(SelectedCorner = 1);
          x[0] := OldTriangle.x[0] + Pivot.X+vx - OldTriangle.x[1];
          y[0] := OldTriangle.y[0] + Pivot.Y+vy - OldTriangle.y[1];
          x[2] := OldTriangle.x[2] + Pivot.X+vx - OldTriangle.x[1];
          y[2] := OldTriangle.y[2] + Pivot.Y+vy - OldTriangle.y[1];
        end;
        MainTriangles[SelectedTriangle].x[SelectedCorner] := Pivot.X+vx;
        MainTriangles[SelectedTriangle].y[SelectedCorner] := Pivot.Y+vy;
      end
      else a := 0;
      vy := abs(
        arctan2(MainTriangles[SelectedTriangle].y[0]-MainTriangles[SelectedTriangle].y[1],
                MainTriangles[SelectedTriangle].x[0]-MainTriangles[SelectedTriangle].x[1])
       -arctan2(MainTriangles[SelectedTriangle].y[2]-MainTriangles[SelectedTriangle].y[1],
                MainTriangles[SelectedTriangle].x[2]-MainTriangles[SelectedTriangle].x[1])
                );
      if vy > PI then vy := 2*PI - vy;
      StatusBar.Panels[2].Text := Format('Rotate: %3.2f°  <ABC: %3.2f°', [a*180/PI, vy*180/PI]);
    end
    else if (editMode = modeScale) then
    begin // move point along vector ("scale")
      if olddist<>0 then begin
        d := (oldx*(fx-Pivot.X) + oldy*(fy-Pivot.Y))/olddist;

        if ssShift in Shift then // 'snapped' scale
        begin
          try // use move-value for 'scaling' point:
            t := abs(StrToFloat(txtTrgMoveValue.Text));
            //assert(t<>0);
          except
            t := 0.1;
            txtTrgMoveValue.Text := '0.1';
          end;
          if t <> 0 then d := Trunc(d/t)*t;
        end;
        vx := oldx*d/olddist;
        vy := oldy*d/olddist;

        if LocalAxisLocked then with MainTriangles[SelectedTriangle] do
        begin
          assert(SelectedCorner = 1);
          x[0] := OldTriangle.x[0] + Pivot.X+vx - OldTriangle.x[1];
          y[0] := OldTriangle.y[0] + Pivot.Y+vy - OldTriangle.y[1];
          x[2] := OldTriangle.x[2] + Pivot.X+vx - OldTriangle.x[1];
          y[2] := OldTriangle.y[2] + Pivot.Y+vy - OldTriangle.y[1];
        end;
        MainTriangles[SelectedTriangle].x[SelectedCorner] := Pivot.X + vx;
        MainTriangles[SelectedTriangle].y[SelectedCorner] := Pivot.Y + vy;

        StatusBar.Panels[2].Text := Format('Distance: %3.3f  Scale: %3.2f%%',
          [Hypot(vx, vy), d*100/olddist]);
      end
      else begin
        MainTriangles[SelectedTriangle].x[SelectedCorner] := Pivot.X;
        MainTriangles[SelectedTriangle].y[SelectedCorner] := Pivot.Y;
      end;
    end
    else begin // snap/move
      if ssShift in Shift then // snap to axis
      begin
        if abs(fx-Pivot.X) > abs(fy-Pivot.Y) then begin
          vx := fx;
          vy := Pivot.Y;
        end
        else begin
          vx := Pivot.x;
          vy := fy;
        end;
      end
      else begin // just move
        vx := fx;
        vy := fy;
      end;
      MainTriangles[SelectedTriangle].x[SelectedCorner] := vx;
      MainTriangles[SelectedTriangle].y[SelectedCorner] := vy;
      StatusBar.Panels[2].Text := Format('Move: %3.3f ; %3.3f', [vx-(Pivot.X+oldx), vy-(Pivot.Y+oldy)]);
    end;
    // --
    HasChanged := True;
    UpdateFlameX;
//    UpdateFlame(False);
    StatusBar.Refresh;
    exit;
  end
  else if TriangleCaught then // Modify a whole triangle ///////////////////////
  begin
    if (editMode = modeRotate) then // rotate triangle
    begin
      a := arctan2(fy-Pivot.Y, fx-Pivot.X) - arctan2(oldy, oldx);
      if ssShift in Shift then // angle snap
      begin
        try
          t := StrToFloat(txtTrgRotateValue.Text)/180*PI;
          //assert(t<>0);
        except
          t := 15.0*PI/180.0;
          txtTrgRotateValue.Text := '15';
        end;
        if t = 0 then goto Skip2;

        a := Round(a/t)*t
      end;
Skip2:
      MainTriangles[SelectedTriangle] :=
             RotateTrianglePoint(OldTriangle, Pivot.X, Pivot.Y, a);

      vx := MainTriangles[SelectedTriangle].x[0]-MainTriangles[SelectedTriangle].x[1];
      vy := MainTriangles[SelectedTriangle].y[0]-MainTriangles[SelectedTriangle].y[1];
      if abs(vx*(MainTriangles[SelectedTriangle].x[2]-MainTriangles[SelectedTriangle].x[1])+
             vy*(MainTriangles[SelectedTriangle].y[2]-MainTriangles[SelectedTriangle].y[1])) < 0.001
      then
        StatusBar.Panels[2].Text := Format('Rotate: %3.2f°  Local axis: %3.2f°', [a*180/PI, arctan2(vy, vx)*180/PI])
      else StatusBar.Panels[2].Text := Format('Rotate: %3.2f°', [a*180/PI]);
    end
    else if (editMode = modeScale) then // scale
    begin
      if olddist<>0 then begin
        vy := (oldx*(fx-Pivot.X) + oldy*(fy-Pivot.Y))/(olddist*olddist);

        if ssShift in Shift then // 'snapped' scale
        begin
          try
            t := abs(StrToFloat(txtTrgScaleValue.Text)/100.0 - 1.0);
            //assert(t<>0);
          except
            t := 0.1;
            txtTrgRotateValue.Text := '0.1';
          end;
          if t <> 0 then vy := Trunc(vy/t)*t;
        end;

        MainTriangles[SelectedTriangle] :=
          ScaleTrianglePoint(OldTriangle, Pivot.X, Pivot.Y, vy);
        StatusBar.Panels[2].Text := Format('Scale: %3.2f%%', [vy*100]);
      end
      else MainTriangles[SelectedTriangle] := OldTriangle;
    end
    else begin // snap/move
      vx := fx - (Pivot.x + oldx);
      vy := fy - (Pivot.y + oldy);
      if ssShift in Shift then // snap to axis
      begin
        if abs(vx) > abs(vy) then vy := 0
        else vx := 0;
      end;
      with MainTriangles[SelectedTriangle] do
      begin
        x[0] := OldTriangle.x[0] + vx;
        y[0] := OldTriangle.y[0] + vy;
        x[1] := OldTriangle.x[1] + vx;
        y[1] := OldTriangle.y[1] + vy;
        x[2] := OldTriangle.x[2] + vx;
        y[2] := OldTriangle.y[2] + vy;
      end;
      StatusBar.Panels[2].Text := Format('Move: %3.3f ; %3.3f', [vx, vy]);
    end;
    HasChanged := True;
    UpdateFlameX;
//    UpdateFlame(False);
    StatusBar.Refresh;
    exit;
  end;
  if ((mt <> mouseOverTriangle) or (mc <> MouseOverCorner)) then
  begin
    if (mouseOverTriangle >= 0) then
      StatusBar.Panels[2].Text := Format('Transform #%d', [mouseOverTriangle+1])
    else StatusBar.Panels[2].Text := '';
    TriangleView.Refresh;
  end
  else if editMode = modePick then TriangleView.Refresh; // hmm...
end;

procedure TEditForm.TriangleViewMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  d, fx, fy: double;
  i, j: integer;
  i0, i1: integer;
begin
  TWinControl(Sender).SetFocus;

  viewDragged := false;

  Scale(fx, fy, x, y);

  if editMode = modePick then
  begin
    if (mouseOverCorner >= 0) then // snap to point
    begin
      fx := MainTriangles[mouseOverTriangle].x[mouseOverCorner];
      fy := MainTriangles[mouseOverTriangle].y[mouseOverCorner];
    end;
    if PivotMode = pivotLocal then
    with MainTriangles[SelectedTriangle] do begin
      LocalPivot.x :=
        ((fx - x[1]) - (x[2]-x[1])/(y[2]-y[1])*(fy - y[1]))/
        ((x[0]-x[1]) - (x[2]-x[1])/(y[2]-y[1])*(y[0]-y[1]));
      LocalPivot.y :=
        ((fy - y[1]) - (y[0]-y[1])*LocalPivot.x)/(y[2]-y[1]);
    end
    else begin
      WorldPivot.x := fx;
      WorldPivot.y := fy;
    end;
    editMode := oldMode;
    oldMode := modeNone;
    btnPickPivot.Down := false;
    ShowSelectedInfo;
    TriangleView.Invalidate;
    exit;
  end;

  if Button = mbLeft then
  begin
    Shift := Shift - [ssLeft];
    if SelectMode then
    begin
      i0:=0;
      i1:=LastTriangle;
    end
    else begin // Only check selected triangle
      i0:=SelectedTriangle;
      i1:=i0;
    end;

    // Find a corner
    for i := i1 downto i0 do
      for j := 0 to 2 do
      begin
        d := dist(fx, fy, MainTriangles[i].x[j], MainTriangles[i].y[j]);
        if (d * GraphZoom * 50) < 4 then
        begin
          SelectedTriangle := i;
          CornerCaught := True;

          SelectedCorner := j;
//          Pivot := GetPivot;
          if (j = 1) then //and ((rgPivot.ItemIndex = 1) or (rgPivot.ItemIndex = 4)) then
          begin
            if PivotMode = pivotLocal then begin
              Pivot.x := 0;
              Pivot.y := 0;
            end
            else Pivot := GetPivot;

            LocalAxisLocked := true;
          end
          else begin
            Pivot := GetPivot;
            LocalAxisLocked := false;
          end;
          OldTriangle := MainTriangles[SelectedTriangle];
          oldx := MainTriangles[SelectedTriangle].x[j] - Pivot.X;
          oldy := MainTriangles[SelectedTriangle].y[j] - Pivot.Y;
          olddist := sqrt(oldx*oldx + oldy*oldy);

          MainForm.UpdateUndo;
          ShowSelectedInfo;
          TriangleView.Invalidate;
          exit;
        end;
      end;

    // so user hasn't selected any corners,
    // let's check for triangles then!

    if SelectMode then
    begin
      i := InsideTriangle(fx, fy);
      if i >= 0 then SelectedTriangle := i
      else
        if (oldMode = modeNone) and not(ssShift in Shift) then exit;
    end;
    TriangleCaught := True;

    OldTriangle := MainTriangles[SelectedTriangle];
    MainForm.UpdateUndo;

    Pivot := GetPivot;
    oldx := fx-Pivot.X;
    oldy := fy-Pivot.Y;
    olddist := sqrt(oldx*oldx + oldy*oldy);

    ShowSelectedInfo;
    TriangleView.Invalidate;
    exit;
  end
  else if (Button = mbRight) and
      not (TriangleCaught or CornerCaught) then // graph panning
  begin
    SetCaptureControl(TriangleView);
    Screen.Cursor := crSizeAll;

    viewDragMode := true;
    oldx := fx;
    oldY := fy;
  end;
end;

procedure TEditForm.TriangleViewMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Button = mbLeft then
  begin
    CornerCaught := False;
    TriangleCaught := False;
    if HasChanged then
    begin
      UpdateFlame(true);
      HasChanged := False;
    end
    else TriangleView.Invalidate;
  end
  else if (Button = mbRight) and viewDragMode then
  begin
    viewDragMode := false;
    if viewDragged=false then // haven't dragged - popup menu then
    begin
      GetCursorPos(mousepos); // hmmm
      if mouseOverTriangle < 0 then
        EditPopup.Popup(mousepos.x, mousepos.y)
      else begin
        SelectedTriangle := mouseOverTriangle;
        TriangleView.Refresh;
        TrianglePopup.Popup(mousepos.x, mousepos.y)
      end;
    end
    else viewDragged := false;
    Screen.Cursor := crDefault;
    SetCaptureControl(nil);
    exit;
  end
end;

procedure TEditForm.FormShow(Sender: TObject);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('Software\' + APP_NAME + '\Forms\Editor', False) then
    begin
    { Size and position }
      if Registry.ValueExists('Left') then
        EditForm.Left := Registry.ReadInteger('Left');
      if Registry.ValueExists('Top') then
        EditForm.Top := Registry.ReadInteger('Top');
      if Registry.ValueExists('Width') then
        EditForm.Width := Registry.ReadInteger('Width');
      if Registry.ValueExists('Height') then
        EditForm.Height := Registry.ReadInteger('Height');
     { Options }
      if Registry.ValueExists('UseTransformColors') then
      begin
        UseTransformColors := Registry.ReadBool('UseTransformColors');
      end
      else
      begin
        UseTransformColors := False;
      end;

      if Registry.ValueExists('ResetLocation') then
        mnuResetLoc.checked := Registry.ReadBool('ResetLocation')
      else mnuResetLoc.checked := true;
      //tbResetLoc.Down := mnuResetLoc.checked;
      if Registry.ValueExists('HelpersEnabled') then
      begin
        HelpersEnabled := Registry.ReadBool('HelpersEnabled');
      end
      else
      begin
        HelpersEnabled := true;
      end;

      if Registry.ValueExists('VariationPreview') then
      begin
        showVarPreview := Registry.ReadBool('VariationPreview');
        tbVarPreview.Down := showVarPreview;
      end
      else begin
        showVarPreview := false;
        tbVarPreview.Down := false;
      end;
      if Registry.ValueExists('VariationPreviewRange') then
        trkVarPreviewRange.Position := Registry.ReadInteger('VariationPreviewRange');
      if Registry.ValueExists('VariationPreviewDensity') then
        trkVarPreviewDensity.Position := Registry.ReadInteger('VariationPreviewDensity');
      if Registry.ValueExists('VariationPreviewDepth') then
        trkVarPreviewDepth.Position := Registry.ReadInteger('VariationPreviewDepth');
    end
    else begin
      UseTransformColors := False;
      UseFlameBackground := False;
      mnuResetLoc.checked := true;
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
  chkUseXFormColor.checked := UseTransformColors;
  UpdateDisplay;
end;

procedure TEditForm.mnuDeleteClick(Sender: TObject);
begin
  if (SelectedTriangle > -1) then DeleteTriangle(SelectedTriangle);
end;

procedure TEditForm.mnuAddClick(Sender: TObject);
var
  i: integer;
begin
  if Transforms < NXFORMS then
  begin
    MainForm.UpdateUndo;
    MainTriangles[Transforms+1] := MainTriangles[Transforms];
    cp.xform[Transforms+1].Assign(cp.xform[Transforms]);
    MainTriangles[Transforms] := MainTriangles[-1];
    SelectedTriangle := Transforms;
    cp.xform[Transforms].density := 0.5;
    cp.xform[Transforms].vars[0] := 1;
    for i := 1 to NRVAR - 1 do
      cp.xform[Transforms].vars[i] := 0;
    Inc(Transforms);
    cbTransforms.clear;
    for i := 1 to Transforms do cbTransforms.Items.Add(IntToStr(i));
    if EnableFinalXform or (cp.HasFinalXForm = true) then cbTransforms.Items.Add('Final');
    UpdateFlame(True);
  end;
end;

procedure TEditForm.mnuDupClick(Sender: TObject);
var
  i: integer;
begin
  if Transforms < NXFORMS then
  begin
    MainForm.UpdateUndo;
    MainTriangles[Transforms+1] := MainTriangles[Transforms];
    cp.xform[Transforms+1].Assign(cp.xform[Transforms]);
    if SelectedTriangle <> Transforms then
    begin
      MainTriangles[Transforms] := MainTriangles[SelectedTriangle];
      cp.xform[Transforms].Assign(cp.xform[SelectedTriangle]);
      SelectedTriangle := Transforms;
    end
    else cp.xform[Transforms].density := 0.5;
    Inc(Transforms);
    cbTransforms.clear;
    for i := 1 to Transforms do cbTransforms.Items.Add(IntToStr(i));
    if EnableFinalXform or (cp.HasFinalXForm = true) then cbTransforms.Items.Add('Final');
    UpdateFlame(True);
  end;
end;


procedure TEditForm.mnuAutoZoomClick(Sender: TObject);
begin
  AutoZoom;
end;

procedure TEditForm.btnCloseClick(Sender: TObject);
begin
  EditForm.Close;
end;

procedure TEditForm.FormResize(Sender: TObject);
begin
  AutoZoom;
end;

procedure TEditForm.CornerEditExit(Sender: TObject);
var
  Allow: boolean;
  OldText: string;
  Val: string;
begin
  Allow := True;
  if Sender = txtAx then
    Val := Format('%.6f', [MainTriangles[SelectedTriangle].x[0]])
  else if Sender = txtAy then
    Val := Format('%.6f', [MainTriangles[SelectedTriangle].y[0]])
  else if Sender = txtBx then
    Val := Format('%.6f', [MainTriangles[SelectedTriangle].x[1]])
  else if Sender = txtBy then
    Val := Format('%.6f', [MainTriangles[SelectedTriangle].y[1]])
  else if Sender = txtCx then
    Val := Format('%.6f', [MainTriangles[SelectedTriangle].x[2]])
  else if Sender = txtCy then
    Val := Format('%.6f', [MainTriangles[SelectedTriangle].y[2]])
  else if Sender = txtP then
    if SelectedTriangle < Transforms then
      val := Format('%.6f', [cp.xform[SelectedTriangle].density]);
  OldText := Val;
  { Test that it's a valid floating point number }
  try
    StrToFloat(TEdit(Sender).Text);
  except on Exception do
    begin
      { It's not, so we restore the old value }
      TEdit(Sender).Text := OldText;
      Allow := False;
    end;
  end;
  { If it's not the same as the old value and it was valid }
  if (val <> TEdit(Sender).Text) and Allow then
  begin
    if Sender = txtAx then
      MainTriangles[SelectedTriangle].x[0] := StrToFloat(TEdit(Sender).Text)
    else if Sender = txtAy then
      MainTriangles[SelectedTriangle].y[0] := StrToFloat(TEdit(Sender).Text)
    else if Sender = txtBx then
      MainTriangles[SelectedTriangle].x[1] := StrToFloat(TEdit(Sender).Text)
    else if Sender = txtBy then
      MainTriangles[SelectedTriangle].y[1] := StrToFloat(TEdit(Sender).Text)
    else if Sender = txtCx then
      MainTriangles[SelectedTriangle].x[2] := StrToFloat(TEdit(Sender).Text)
    else if Sender = txtCy then
      MainTriangles[SelectedTriangle].y[2] := StrToFloat(TEdit(Sender).Text)
    else if Sender = txtP then
    begin
      cp.xform[SelectedTriangle].density := StrToFloat(TEdit(Sender).Text);
      //ReadjustWeights(cp);
      TEdit(Sender).Text := Format('%.6g', [cp.xform[SelectedTriangle].density]);
    end;
    MainForm.UpdateUndo;
    UpdateFlame(True);
  end;
end;

procedure TEditForm.CornerEditKeyPress(Sender: TObject; var Key: Char);
var
  Allow: boolean;
  OldText: string;
  Val: string;
begin
  if key = #13 then
  begin
    Allow := True;
    if Sender = txtAx then
      Val := Format('%.6f', [MainTriangles[SelectedTriangle].x[0]])
    else if Sender = txtAy then
      Val := Format('%.6f', [MainTriangles[SelectedTriangle].y[0]])
    else if Sender = txtBx then
      Val := Format('%.6f', [MainTriangles[SelectedTriangle].x[1]])
    else if Sender = txtBy then
      Val := Format('%.6f', [MainTriangles[SelectedTriangle].y[1]])
    else if Sender = txtCx then
      Val := Format('%.6f', [MainTriangles[SelectedTriangle].x[2]])
    else if Sender = txtCy then
      Val := Format('%.6f', [MainTriangles[SelectedTriangle].y[2]])
    else if Sender = txtP then
      val := Format('%.6f', [cp.xform[SelectedTriangle].density]);
    OldText := Val;
    { Stop the beep }
    Key := #0;
    { Test that it's a valid floating point number }
    try
      StrToFloat(TEdit(Sender).Text);
    except on Exception do
      begin
        { It's not, so we restore the old value }
        TEdit(Sender).Text := OldText;
        Allow := False;
      end;
    end;
    { If it's not the same as the old value and it was valid }
    if (val <> TEdit(Sender).Text) and Allow then
    begin
      if Sender = txtAx then
        MainTriangles[SelectedTriangle].x[0] := StrToFloat(TEdit(Sender).Text)
      else if Sender = txtAy then
        MainTriangles[SelectedTriangle].y[0] := StrToFloat(TEdit(Sender).Text)
      else if Sender = txtBx then
        MainTriangles[SelectedTriangle].x[1] := StrToFloat(TEdit(Sender).Text)
      else if Sender = txtBy then
        MainTriangles[SelectedTriangle].y[1] := StrToFloat(TEdit(Sender).Text)
      else if Sender = txtCx then
        MainTriangles[SelectedTriangle].x[2] := StrToFloat(TEdit(Sender).Text)
      else if Sender = txtCy then
        MainTriangles[SelectedTriangle].y[2] := StrToFloat(TEdit(Sender).Text)
      else if Sender = txtP then
      begin
        cp.xform[SelectedTriangle].density := StrToFloat(TEdit(Sender).Text);
        //ReadjustWeights(cp);
        TEdit(Sender).Text := Format('%.6g', [cp.xform[SelectedTriangle].density]);
      end;
      MainForm.UpdateUndo;
      UpdateFlame(True);
    end;
  end;
end;

{ ************************* Probability input ******************************** }

procedure TEditForm.txtPKeyPress(Sender: TObject; var Key: Char);
var
  Allow: boolean;
  NewVal, OldVal: double;
begin
  if SelectedTriangle >= Transforms then key := #0;
  if key = #13 then
  begin
    { Stop the beep }
    Key := #0;
    Allow := True;
    OldVal := Round6(cp.xform[SelectedTriangle].density);
    { Test that it's a valid floating point number }
    try
      StrToFloat(TEdit(Sender).Text);
    except on Exception do
      begin
        { It's not, so we restore the old value }
        TEdit(Sender).Text := Format('%.6g', [OldVal]);
        Allow := False;
      end;
    end;
    NewVal := Round6(StrToFloat(TEdit(Sender).Text));
  if NewVal < 0.000001 then NewVal := 0.000001;
  if NewVal > 100 then NewVal := 100;
    { If it's not the same as the old value and it was valid }
    TEdit(Sender).Text := Format('%.6g', [NewVal]);
    if (OldVal <> NewVal) and Allow then
    begin
      MainForm.UpdateUndo;
      cp.xform[SelectedTriangle].density := NewVal;
      //ReadjustWeights(cp);
      UpdateFlame(True);
    end;
  end;
end;

procedure TEditForm.txtPExit(Sender: TObject);
var
  Allow: boolean;
  NewVal, OldVal: double;
begin
  Allow := True;
  OldVal := Round6(cp.xform[SelectedTriangle].density);
    { Test that it's a valid floating point number }
  try
    StrToFloat(TEdit(Sender).Text);
  except on Exception do
    begin
        { It's not, so we restore the old value }
      TEdit(Sender).Text := Format('%.6g', [OldVal]);
      Allow := False;
    end;
  end;
  NewVal := Round6(StrToFloat(TEdit(Sender).Text));
  if NewVal < 0.000001 then NewVal := 0.000001;
  if NewVal > 100 then NewVal := 100;
    { If it's not the same as the old value and it was valid }
  TEdit(Sender).Text := Format('%.6g', [NewVal]);
  if (OldVal <> NewVal) and Allow then
  begin
    MainForm.UpdateUndo;
    cp.xform[SelectedTriangle].density := NewVal;
    //ReadjustWeights(cp);
    UpdateFlame(True);
  end;
end;

{ **************************************************************************** }

procedure TEditForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Registry: TRegistry;
begin
  { Write position to registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    { Defaults }
    if Registry.OpenKey('\Software\' + APP_NAME + '\Forms\Editor', True) then
    begin
      { Options }
//      Registry.WriteBool('UseFlameBackground', UseFlameBackground);
{
      Registry.WriteBool('UseTransformColors', UseTransformColors);
      Registry.WriteInteger('BackgroundColor', BackgroundColor);
      Registry.WriteInteger('GridColor1', GridColor1);
      Registry.WriteInteger('GridColor2', GridColor2);
      Registry.WriteInteger('HelpersColor', HelpersColor);
      Registry.WriteInteger('ReferenceTriangleColor', ReferenceTriangleColor);
}
      Registry.WriteBool('ResetLocation', mnuResetLoc.checked);
      Registry.WriteBool('VariationPreview', showVarPreview);
      Registry.WriteBool('HelpersEnabled', HelpersEnabled);
      Registry.WriteInteger('VariationPreviewRange', trkVarPreviewRange.Position);
      Registry.WriteInteger('VariationPreviewDensity', trkVarPreviewDensity.Position);
      Registry.WriteInteger('VariationPreviewDepth', trkVarPreviewDepth.Position);
      { Size and position }
      if EditForm.WindowState <> wsMaximized then begin
        Registry.WriteInteger('Top', EditForm.Top);
        Registry.WriteInteger('Left', EditForm.Left);
        Registry.WriteInteger('Width', EditForm.Width);
        Registry.WriteInteger('Height', EditForm.Height);
      end;
    end;
  finally
    Registry.Free;
  end;
end;

procedure TEditForm.mnuUndoClick(Sender: TObject);
begin
  MainForm.Undo;
end;

procedure TEditForm.mnuRedoClick(Sender: TObject);
begin
  MainForm.Redo;
end;

procedure TEditForm.FormDestroy(Sender: TObject);
begin
  cp.free;
  Render.free;
end;

procedure TEditForm.mnuLowQualityClick(Sender: TObject);
begin
  mnuLowQuality.Checked := True;
  //tbLowQ.Down := true;
  PreviewDensity := prevLowQuality;
  EditPrevQual := 0;
  DrawPreview;
end;

procedure TEditForm.mnuHighQualityClick(Sender: TObject);
begin
  mnuHighQuality.Checked := True;
  //tbHiQ.Down := true;
  PreviewDensity := prevHighQuality;
  EditPrevQual := 2;
  DrawPreview;
end;

procedure TEditForm.mnuMediumQualityClick(Sender: TObject);
begin
  mnuMediumQuality.Checked := True;
  //tbMedQ.Down := true;
  PreviewDensity := prevMediumQuality;
  EditPrevQual := 1;
  DrawPreview;
end;

procedure TEditForm.mnuResetLocClick(Sender: TObject);
var
  reset: boolean;
begin
  reset:= not mnuResetLoc.Checked;
  mnuResetLoc.Checked := reset;
  //tbResetLoc.Down := reset;
  if reset then
  begin
    cp.width := MainCp.width;
    cp.height := MainCp.height;
    cp.pixels_per_unit := MainCp.pixels_per_unit;
    cp.AdjustScale(PreviewImage.width, PreviewImage.Height);
    cp.zoom := MainCp.zoom;
    cp.center[0] := MainCp.center[0];
    cp.center[1] := MainCp.center[1];
  end;
  DrawPreview;
end;

procedure TEditForm.mnuVerticalFlipAllClick(Sender: TObject);
var
  i: integer;
begin
  MainForm.UpdateUndo;
  for i := -1 to Transforms - 1 do
  begin
    MainTriangles[i] := FlipTriangleVertical(MainTriangles[i]);
  end;
  //cp.TrianglesFromCP(MainTriangles);
  AutoZoom;
  UpdateFlame(True);
end;

procedure TEditForm.mnuHorizintalFlipAllClick(Sender: TObject);
var
  i: integer;
begin
  MainForm.UpdateUndo;
  for i := -1 to Transforms - 1 do
  begin
    MainTriangles[i] := FlipTriangleHorizontal(MainTriangles[i]);
  end;
  //cp.TrianglesFromCP(MainTriangles);
  AutoZoom;
  UpdateFlame(True);
end;

procedure TEditForm.mnuFlipVerticalClick(Sender: TObject);
var
  p: double;
begin
  MainForm.UpdateUndo;
  with MainTriangles[SelectedTriangle] do
  begin
    p := GetPivot.y * 2;
    y[0] := p - y[0];
    y[1] := p - y[1];
    y[2] := p - y[2];
  end;
  //AutoZoom;
  UpdateFlame(True);
end;

procedure TEditForm.mnuFlipHorizontalClick(Sender: TObject);
var
  p: double;
begin
  MainForm.UpdateUndo;
  with MainTriangles[SelectedTriangle] do
  begin
    p := GetPivot.x * 2;
    x[0] := p - x[0];
    x[1] := p - x[1];
    x[2] := p - x[2];
  end;
  //AutoZoom;
  UpdateFlame(True);
end;

{
procedure TEditForm.TriangleViewDblClick(Sender: TObject);
begin
  AutoZoom;
end;
}

procedure TEditForm.cbTransformsChange(Sender: TObject);
begin
  if SelectedTriangle <> cbTransforms.ItemIndex then SelectedTriangle := cbTransforms.ItemIndex;
  ShowSelectedInfo;
  TriangleView.Invalidate;
end;

procedure TEditForm.cbTransformsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  h: integer;
  ax,ay,bx,by: integer;
  TrgColor: TColor;
begin
  TrgColor := GetTriangleColor(Index);
  with cbTransforms.Canvas do
  begin
    h := Rect.Bottom - Rect.Top;

    brush.Color:=clBlack;
    FillRect(Rect);

    Font.Color := clWhite;
    TextOut(Rect.Left+h+2, Rect.Top, cbTransforms.Items[Index]);//IntToStr(Index+1));

    pen.Color := TrgColor;
    brush.Color := pen.Color shr 1 and $7f7f7f;

    ax:=Rect.Left+h-2;
    ay:=Rect.Top+1;
    bx:=Rect.Left+2;
    by:=Rect.Bottom-3;
    Polygon([Point(ax, ay), Point(ax, by), Point(bx, by)]);
  end;
end;

procedure TEditForm.CoefKeyPress(Sender: TObject; var Key: Char);
begin
  if key <> #13 then exit;
  key := #0;
  CoefValidate(Sender);
end;

procedure TEditForm.CoefValidate(Sender: TObject);
var
  NewVal: double;
  x, y, r, a: double; // dumb... must optimize
begin
  try
    NewVal := Round6(StrToFloat(TEdit(Sender).Text));
  except on Exception do
    begin
      ShowSelectedInfo; //TEdit(Sender).Text := Format('%.6g', [pVal^]);
      exit;
    end;
  end;

  //TEdit(Sender).Text := Format('%.6g', [NewVal]);

  MainForm.UpdateUndo; // TODO - prevent unnecessary UpdateUndo...
 with cp.xform[SelectedTriangle] do
 begin
  if btnCoefsRect.Down = true then
  begin
    if Sender = txtA then c[0][0] := NewVal
    else if Sender = txtB then c[0][1] := -NewVal
    else if Sender = txtC then c[1][0] := -NewVal
    else if Sender = txtD then c[1][1] := NewVal
    else if Sender = txtE then c[2][0] := NewVal
    else if Sender = txtF then c[2][1] := -NewVal;
  end
  else begin
    if (Sender = txtA) or (Sender = txtB) then begin
      x := c[0][0];
      y := -c[0][1];
    end else
    if (Sender = txtC) or (Sender = txtD) then begin
      x := -c[1][0];
      y := c[1][1];
    end else
    {if (Sender = txtE) or (Sender = txtF) then}
    begin
      x := c[2][0];
      y := -c[2][1];
    end;
    r := Hypot(x, y);
    a := arctan2(y, x);

    if (Sender = txtA) or (Sender = txtC) or (Sender = txtE) then
      r := NewVal
    else
      a := NewVal*PI/180;

    x := r * cos(a);
    y := r * sin(a);
    if (Sender = txtA) or (Sender = txtB) then begin
      c[0][0] := x;
      c[0][1] := -y;
    end else
    if (Sender = txtC) or (Sender = txtD) then begin
      c[1][0] := -x;
      c[1][1] := y;
    end else
    {if (Sender = txtE) or (Sender = txtF) then}
    begin
      c[2][0] := x;
      c[2][1] := -y;
    end;
  end;
 end;
  cp.TrianglesFromCP(MainTriangles);
  ShowSelectedInfo;
  UpdateFlame(true);
end;

procedure TEditForm.scrlXFormColorScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if ScrollCode = scEndScroll then begin
    MainForm.UpdateUndo;
    UpdateFlame(True);
  end;
end;

procedure TEditForm.scrlXFormColorChange(Sender: TObject);
var
  v: double;
begin
  if updating then exit;

  v := (scrlXFormColor.Position) / scrlXFormColor.Max;
  cp.xform[SelectedTriangle].color := v;
  pnlXFormColor.color := ColorValToColor(MainCp.cmap, v);
  txtXFormColor.Text := Format('%1.3f', [v]);
  txtXFormColor.Refresh;

  DrawPreview;
end;

procedure TEditForm.chkUseXFormColorClick(Sender: TObject);
begin
  UseTransformColors := chkUseXFormColor.checked;
  TriangleView.Invalidate;
end;

procedure TEditForm.chkHelpersClick(Sender: TObject);
begin
  HelpersEnabled := chkHelpers.checked;
  TriangleView.Invalidate;
end;

procedure TEditForm.txtXFormColorExit(Sender: TObject);
var
  v: double;
begin
  try
    v := StrToFloat(txtXFormColor.Text);
  except on EConvertError do
    begin
      txtXformColor.text := Format('%1.3f', [cp.xform[SelectedTriangle].color]);
      exit;
    end;
  end;
  if v > 1 then v := 1;
  if v < 0 then v := 0;
  if v <> cp.xform[SelectedTriangle].color then
  begin
    scrlXFormColor.Position := round(v * scrlXFormColor.Max);
    UpdateFlame(true);
  end;
end;

procedure TEditForm.txtXFormColorKeyPress(Sender: TObject; var Key: Char);
var
  v: double;
begin
  if key = #13 then
  begin
    key := #0;
    try
      v := StrToFloat(txtXFormColor.Text);
    except on EConvertError do
      begin
        txtXformColor.text := Format('%1.3f', [cp.xform[SelectedTriangle].color]);
        exit;
      end;
    end;
    if v > 1 then v := 1;
    if v < 0 then v := 0;
    if v <> cp.xform[SelectedTriangle].color then
    begin
      scrlXFormColor.Position := round(v * scrlXFormColor.Max);
      UpdateFlame(true);
    end;
  end;
end;

procedure TEditForm.txtSymmetrySet(Sender: TObject);
var
  Allow: boolean;
  NewVal, OldVal: double;
begin
  Allow := True;
  OldVal := Round6(cp.xform[SelectedTriangle].symmetry);
    { Test that it's a valid floating point number }
  try
    StrToFloat(TEdit(Sender).Text);
  except on Exception do
    begin
        { It's not, so we restore the old value }
      TEdit(Sender).Text := Format('%.6g', [OldVal]);
      Allow := False;
    end;
  end;
  NewVal := Round6(StrToFloat(TEdit(Sender).Text));
  if NewVal < -1 then NewVal := -1;
  if NewVal > 1 then NewVal := 1;
    { If it's not the same as the old value and it was valid }
  TEdit(Sender).Text := Format('%.6g', [NewVal]);
  if (OldVal <> NewVal) and Allow then
  begin
    MainForm.UpdateUndo;
    cp.xform[SelectedTriangle].symmetry := NewVal;
    UpdateFlame(True);
  end;
end;

procedure TEditForm.txtSymmetrKeyPress(Sender: TObject; var Key: Char);
var
  Allow: boolean;
  NewVal, OldVal: double;
begin
  if key = #13 then
  begin
    { Stop the beep }
    Key := #0;
    Allow := True;
    OldVal := Round6(cp.xform[SelectedTriangle].symmetry);
    { Test that it's a valid floating point number }
    try
      StrToFloat(TEdit(Sender).Text);
    except on Exception do
      begin
        { It's not, so we restore the old value }
        TEdit(Sender).Text := Format('%.6g', [OldVal]);
        Allow := False;
      end;
    end;
    NewVal := Round6(StrToFloat(TEdit(Sender).Text));
    if NewVal < -1 then NewVal := -1;
    if NewVal > 1 then NewVal := 1;
    { If it's not the same as the old value and it was valid }
    TEdit(Sender).Text := Format('%.6g', [NewVal]);
    if (OldVal <> NewVal) and Allow then
    begin
      MainForm.UpdateUndo;
      cp.xform[SelectedTriangle].symmetry := NewVal;
      UpdateFlame(True);
    end;
  end;
end;

// -- Variation List Editor ----------------------------------------------------

procedure TEditForm.ValidateVariation;
var
  i: integer;
  NewVal, OldVal: double;
begin
  i := VEVars.Row - 1;
  OldVal := Round6(cp.xform[SelectedTriangle].vars[i]);
  try
    NewVal := Round6(StrToFloat(VEVars.Values[VarNames(i)]));
  except
      VEVars.Values[VarNames(i)] := Format('%.6g', [OldVal]);
      exit;
  end;
  if (NewVal <> OldVal) then
  begin
    MainForm.UpdateUndo;
    cp.xform[SelectedTriangle].vars[i] := NewVal;
    VEVars.Values[VarNames(i)] := Format('%.6g', [NewVal]);
    ShowSelectedInfo;
    UpdateFlame(True);
  end;
end;

(*

// here's another way to do this -
// we could use it with variables value editor,
// only if we had an *array* of variables

type
  TDblArray = array of double;
  PDblArray = ^TDblArray;

procedure ValidateValue(Sender: TValueListEditor; values: PDblArray);
var
  Allow: boolean;
  i: integer;
  NewVal, OldVal: double;
begin
  Allow := True;

  i := Sender.Row - 1;

  OldVal := values^[i];
{ Test that it's a valid floating point number }
  try
    StrToFloat(Sender.Values[VarNames(i)]);
  except on Exception do
    begin
    { It's not, so we restore the old value }
      Sender.Values[VarNames(i)] := Format('%.6g', [OldVal]);
      Allow := False;
    end;
  end;
  NewVal := Round6(StrToFloat(Sender.Values[VarNames(i)]));
  Sender.Values[VarNames(i)] := Format('%.6g', [NewVal]);

{ If it's not the same as the old value and it was valid }
  if (NewVal <> OldVal) and Allow then
  begin
    MainForm.UpdateUndo;
    values^[i] := NewVal;
    Sender.Values[VarNames(i)] := Format('%.6g', [NewVal]);
    EditForm.ShowSelectedInfo;
    EditForm.UpdateFlame(True);
  end;
end;
*)

procedure TEditForm.VEVarsKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    ValidateVariation;
  end;
end;

procedure TEditForm.VEVarsChange(Sender: TObject);
begin
  ValidateVariation;
end;

procedure TEditForm.VEVarsValidate(Sender: TObject; ACol, ARow: Integer; const KeyName, KeyValue: String);
begin
  ValidateVariation;
end;

// -- ValueList mouse stuff ----------------------------------------------------

procedure TEditForm.VEVarsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  cell: TGridCoord;
begin
  if Button = mbLeft then begin
    varDragOld:=x;
    cell := TValueListEditor(Sender).MouseCoord(x, y);
    if (cell.y < 1) or (cell.y >= TValueListEditor(Sender).RowCount) or
       (cell.x <> 0) then exit;

    TValueListEditor(Sender).Row := cell.Y;

    varDragIndex := cell.Y-1;

    Screen.Cursor := crHSplit;

    GetCursorPos(mousepos); // hmmm

    varDragMode:=true;
    varDragPos:=0;
    varMM := false;
    SetCaptureControl(TValueListEditor(Sender));
    if Sender = VEVars then
      varDragValue := cp.xform[SelectedTriangle].vars[varDragIndex]
    else
      cp.xform[SelectedTriangle].GetVariable(vleVariables.Keys[varDragIndex+1], varDragValue);

    HasChanged := False;
  end;
end;

procedure TEditForm.VEVarsMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  v: double;
  cell: TGridCoord;
begin
  cell := TValueListEditor(Sender).MouseCoord(x, y);
  if (cell.Y > 0) and (cell.X = 0) then TValueListEditor(Sender).Cursor := crHandPoint
  else TValueListEditor(Sender).Cursor := crDefault;

  if varMM then // hack: to skip MouseMove event
  begin
    varMM:=false;
  end
  else
  if varDragMode and (x <> varDragOld) then
  begin
    Inc(varDragPos, x - varDragOld);

    if GetKeyState(VK_MENU) < 0 then v := 100000
    else if GetKeyState(VK_CONTROL) < 0 then v := 10000
    else if GetKeyState(VK_SHIFT) < 0 then v := 100
    else v := 1000;

    v := Round6(varDragValue + varDragPos/v);

    SetCursorPos(MousePos.x, MousePos.y); // hmmm
    // this Delphi is WEIRD!
    // why GetCursorPos deals with TPoint,
    // and SetCursorPos - with two integers? :)
    varMM:=true;

    //cp.xform[SelectedTriangle].vars[varDragIndex] := v;
    if Sender = VEVars then
    begin
      cp.xform[SelectedTriangle].vars[varDragIndex] := v;
      TValueListEditor(Sender).Values[VarNames(varDragIndex)] := FloatToStr(v); //Format('%.6g', [v]);
    end
    else begin
      cp.xform[SelectedTriangle].SetVariable(vleVariables.Keys[varDragIndex+1], v);
      vleVariables.Values[vleVariables.Keys[varDragIndex+1]] := FloatToStr(v); //Format('%.6g', [v]);
    end;

    HasChanged := True;
    UpdateFlameX;
  end;
end;

procedure TEditForm.VEVarsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then exit;
  SetCaptureControl(nil);
  if varDragMode then
  begin
    varDragMode:=false;
    Screen.Cursor := crDefault;

    if HasChanged then
    begin
      MainForm.UpdateUndo;

      UpdateFlame(true);
      HasChanged := False;
    end;
  end;
end;

procedure TEditForm.VEVarsDblClick(Sender: TObject);
var
  v: double;
begin
  if (TValueListEditor(Sender).Values[VarNames(varDragIndex)] = '0') or
     (varDragOld >=  TValueListEditor(Sender).ColWidths[0]) then exit;

  MainForm.UpdateUndo;
  if Sender = VEVars then
  begin
    cp.xform[SelectedTriangle].vars[varDragIndex] := 0;
    VEVars.Values[VarNames(varDragIndex)] := '0';
  end
  else begin
    v := 0; // hmm
    cp.xform[SelectedTriangle].SetVariable(vleVariables.Keys[varDragIndex+1], v);
    vleVariables.Values[vleVariables.Keys[varDragIndex+1]] := '0';
  end;

  UpdateFlame(true);
end;

{ **************************************************************************** }

function TEditForm.GetPivot: TSPoint;
begin
  Result := GetPivot(SelectedTriangle);
end;

function TEditForm.GetPivot(n: integer): TSPoint;
begin
  if PivotMode = pivotLocal then
    with MainTriangles[n] do begin
      Result.x := x[1] + (x[0] - x[1])*LocalPivot.x + (x[2] - x[1])*LocalPivot.y;
      Result.y := y[1] + (y[0] - y[1])*LocalPivot.x + (y[2] - y[1])*LocalPivot.y;
    end
  else begin
      Result.x := WorldPivot.x;
      Result.y := WorldPivot.y;
  end;
end;

procedure TEditForm.btTrgRotateLeftClick(Sender: TObject);
var
  angle: double;
begin
  try
    angle := StrToFloat(txtTrgRotateValue.Text);
  except
    txtTrgRotateValue.ItemIndex := 1;
    exit;
  end;
  assert(angle <> 0);

  if GetKeyState(VK_CONTROL) < 0 then angle := angle/6.0
  else if GetKeyState(VK_SHIFT) < 0 then angle := angle*6.0;

  MainForm.UpdateUndo;
  MainTriangles[SelectedTriangle] :=
    RotateTrianglePoint(MainTriangles[SelectedTriangle], GetPivot.x, GetPivot.y, (PI/180)*angle);
  HasChanged := True;
  UpdateFlame(true);
end;

procedure TEditForm.btTrgRotateLeft90Click(Sender: TObject);
begin
  MainForm.UpdateUndo;
  MainTriangles[SelectedTriangle] :=
    RotateTrianglePoint(MainTriangles[SelectedTriangle], GetPivot.x, GetPivot.y, PI/2);
  HasChanged := True;
  UpdateFlame(true);
end;

procedure TEditForm.btTrgRotateRightClick(Sender: TObject);
var
  angle: double;
begin
  try
    angle := StrToFloat(txtTrgRotateValue.Text);
  except
    txtTrgRotateValue.ItemIndex := 1;
    exit;
  end;
  assert(angle <> 0);

  if GetKeyState(VK_CONTROL) < 0 then angle := angle/6.0
  else if GetKeyState(VK_SHIFT) < 0 then angle := angle*6.0;

  MainForm.UpdateUndo;
  MainTriangles[SelectedTriangle] :=
    RotateTrianglePoint(MainTriangles[SelectedTriangle], GetPivot.x, GetPivot.y, -(PI/180)*angle);
  HasChanged := True;
  UpdateFlame(true);
end;

procedure TEditForm.btTrgRotateRight90Click(Sender: TObject);
begin
  MainForm.UpdateUndo;
  MainTriangles[SelectedTriangle] :=
    RotateTrianglePoint(MainTriangles[SelectedTriangle], GetPivot.x, GetPivot.y, -PI/2);
  HasChanged := True;
  UpdateFlame(true);
end;

procedure TEditForm.TrgMove(dx, dy: double);
var
  i: integer;
  offset: double;
begin
  try
    offset := StrToFloat(txtTrgMoveValue.Text);
    assert(offset <> 0);
  except
    txtTrgMoveValue.ItemIndex := 1;
    exit;
  end;

  if GetKeyState(VK_CONTROL) < 0 then offset := offset/10.0
  else if GetKeyState(VK_SHIFT) < 0 then offset := offset*10.0;

  MainForm.UpdateUndo;
  for i := 0 to 2 do begin
    MainTriangles[SelectedTriangle].x[i] :=
                  MainTriangles[SelectedTriangle].x[i] + dx*offset;
    MainTriangles[SelectedTriangle].y[i] :=
                  MainTriangles[SelectedTriangle].y[i] + dy*offset;
  end;
//  HasChanged := True;
  UpdateFlame(true);
end;

procedure TEditForm.btTrgMoveLeftClick(Sender: TObject);
begin
  TrgMove(-1,0);
end;

procedure TEditForm.btTrgMoveRightClick(Sender: TObject);
begin
  TrgMove(1,0);
end;

procedure TEditForm.btTrgMoveUpClick(Sender: TObject);
begin
  TrgMove(0,1);
end;

procedure TEditForm.btTrgMoveDownClick(Sender: TObject);
begin
  TrgMove(0,-1);
end;

procedure TEditForm.btTrgMoveLUClick(Sender: TObject);
begin
  TrgMove(-1,1);
end;

procedure TEditForm.btTrgMoveLDClick(Sender: TObject);
begin
  TrgMove(-1,-1);
end;

procedure TEditForm.btTrgMoveRUClick(Sender: TObject);
begin
  TrgMove(1,1);
end;

procedure TEditForm.btTrgMoveRDClick(Sender: TObject);
begin
  TrgMove(1,-1);
end;

procedure TEditForm.btTrgScaleUpClick(Sender: TObject);
var
  scale: double;
begin
  try
    scale := StrToFloat(txtTrgScaleValue.Text) / 100.0;
  except
    txtTrgScaleValue.ItemIndex := 1;
    exit;
  end;
  assert(scale <> 0);

  if GetKeyState(VK_CONTROL) < 0 then scale := sqrt(scale)
  else if GetKeyState(VK_SHIFT) < 0 then scale := scale*scale;

  MainForm.UpdateUndo;
  MainTriangles[SelectedTriangle] :=
    ScaleTrianglePoint(MainTriangles[SelectedTriangle], GetPivot.x, GetPivot.y, scale);
  HasChanged := True;
  UpdateFlame(true);
end;

procedure TEditForm.btTrgScaleDownClick(Sender: TObject);
var
  scale: double;
begin
  try
    scale := 100.0 / StrToFloat(txtTrgScaleValue.Text);
  except
    txtTrgScaleValue.ItemIndex := 1;
    exit;
  end;
  assert(scale <> 0);

  if GetKeyState(VK_CONTROL) < 0 then scale := sqrt(scale)
  else if GetKeyState(VK_SHIFT) < 0 then scale := scale*scale;

  MainForm.UpdateUndo;
  MainTriangles[SelectedTriangle] :=
    ScaleTrianglePoint(MainTriangles[SelectedTriangle], GetPivot.x, GetPivot.y, scale);
  HasChanged := True;
  UpdateFlame(true);
end;

procedure TEditForm.TriangleViewKeyDown(Sender: TObject; var Key: Word;
 Shift: TShiftState);
begin
  if (oldMode = modeNone) and
     (key in [{VK_SHIFT,} VK_MENU, VK_CONTROL]) then
  begin
    oldMode := editMode;
    modeKey := key;

    if key = VK_MENU then
      if editMode <> modeRotate then
      begin
        editMode := modeRotate;
        TriangleView.Cursor := crEditRotate;
      end
      else begin
        editMode := modeMove;
        TriangleView.Cursor := crEditMove;
      end
    else {if key = VK_CONTROL then}
    begin
      if editMode <> modeScale then
      begin
        editMode := modeScale;
        TriangleView.Cursor := crEditScale;
      end
      else begin
        editMode := modeMove;
        TriangleView.Cursor := crEditMove;
      end
    end;
{
    case key of
      VK_MENU:
        begin
          editMode := modeRotate;
//          tbRotate.Down := true;
          TriangleView.Cursor := crEditRotate;
        end;
      VK_CONTROL:
        begin
          editMode := modeScale;
//          tbScale.Down := true;
          TriangleView.Cursor := crEditScale;
        end;
      else //VK_SHIFT:
        begin
          editMode := modeMove;
//          tbMove.Down := true;
          TriangleView.Cursor := crEditMove;
        end;
    end;
//    EditorToolBar.Refresh;
}
  end
  else
  case key of
    VK_LEFT:
      if Shift = [ssAlt] then btTrgRotateLeftClick(Sender)
      else TrgMove(-1,0);
    VK_RIGHT:
      if Shift = [ssAlt] then btTrgRotateRightClick(Sender)
      else TrgMove(1,0);
    VK_UP:
      if Shift = [ssAlt] then btTrgScaleUpClick(Sender)
      else TrgMove(0,1);
    VK_DOWN:
      if Shift = [ssAlt] then btTrgScaleDownClick(Sender)
      else TrgMove(0,-1);
    VK_PRIOR: btTrgRotateLeftClick(Sender);
    VK_NEXT: btTrgRotateRightClick(Sender);
    VK_HOME: btTrgScaleUpClick(Sender);
    VK_END: btTrgScaleDownClick(Sender);
    VK_INSERT: mnuDupClick(Sender);
    VK_DELETE: mnuDeleteClick(Sender);

    // can be changed in the future...
    Ord('R'): btnResetPivotClick(Sender);
    Ord('P'): btnPickPivotClick(Sender);
  end;
end;

procedure TEditForm.TriangleViewKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (oldMode <> modeNone) and (key = modeKey) then
  begin
    assert(key in [VK_MENU, VK_CONTROL]);

    editMode := oldMode;
    oldMode := modeNone;
//    tbMove.Down   := (editMode = modeMove);
//    tbRotate.Down := (editMode = modeRotate);
//    tbScale.Down  := (editMode = modeScale);

    // hack: to generate MouseMove event
    GetCursorPos(MousePos);
    SetCursorPos(MousePos.x, MousePos.y);
  end;
end;

procedure TEditForm.TriangleViewExit(Sender: TObject);
begin
  if oldMode <> modeNone then
  begin
    editMode := oldMode;
    oldMode := modeNone;
//    tbMove.Down   := (editMode = modeMove);
//    tbRotate.Down := (editMode = modeRotate);
//    tbScale.Down  := (editMode = modeScale);
  end;

  mouseOverTriangle := -1;
  TriangleView.Invalidate;
end;

procedure TEditForm.TriangleViewMouseLeave(Sender: TObject);
begin
  if viewDragMode = false then
  begin
    mouseOverTriangle := -1;
    TriangleView.Invalidate;
  end;
end;

procedure TEditForm.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ADD:
      if SelectedTriangle < LastTriangle then begin
        Inc(SelectedTriangle);
        TriangleView.Invalidate;
        ShowSelectedInfo;
      end;
    VK_SUBTRACT:
      if SelectedTriangle > 0 then begin
        Dec(SelectedTriangle);
        TriangleView.Invalidate;
        ShowSelectedInfo;
      end;

    VK_SPACE: btnPivotModeClick(Sender);

{   // these keys are not so good, must think about it...

    Ord('Q'): EditForm.tbEditModeClick(tbMove);
    Ord('W'): EditForm.tbEditModeClick(tbRotate);
    Ord('E'): EditForm.tbEditModeClick(tbScale);

    Ord('A'): PageControl.TabIndex := 0;
    Ord('S'): PageControl.TabIndex := 1;
    Ord('D'): PageControl.TabIndex := 2;
    Ord('F'): PageControl.TabIndex := 3;
}
  else
    key_handled := false;
    exit;
  end;
  key_handled := true;
  key := 0;
end;

procedure TEditForm.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if key_handled or (key in ['A'..'z']) then key := #0; // hmmm...
end;

procedure TEditForm.splitterMoved(Sender: TObject);
begin
  UpdatePreview;
end;

procedure TEditForm.tbSelectClick(Sender: TObject);
begin
  SelectMode := not SelectMode;
  tbSelect.Down := SelectMode;

  if SelectMode then
  begin
    StatusBar.Panels[2].Text := 'Select ON'
  end
  else begin
    mouseOverTriangle := SelectedTriangle;
    StatusBar.Panels[2].Text := 'Select OFF';
  end;

  // hack: to generate MouseMove event
  GetCursorPos(MousePos);
  SetCursorPos(MousePos.x, MousePos.y);
end;

procedure TEditForm.TriangleViewMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if WheelDelta > 0 then GraphZoom := GraphZoom * 1.25
  else GraphZoom := GraphZoom * 0.8;
  EditForm.StatusBar.Panels[2].Text := Format('Zoom: %f', [GraphZoom]);

  TriangleView.Invalidate;
  Handled := true;
end;

procedure TEditForm.TriangleViewInvalidate(Sender: TObject);
begin
  TriangleView.Invalidate;
end;

procedure TEditForm.tbEditModeClick(Sender: TObject);
begin
{
  if Sender = tbRotate then editMode := modeRotate
  else if Sender = tbScale then editMode := modeScale
  else editMode := modeMove;
  tbMove.Down := (editMode = modeMove);
  tbRotate.Down := (editMode = modeRotate);
  tbScale.Down := (editMode = modeScale);
}
  if Sender = tbRotate then
  begin
    editMode := modeRotate;
    tbRotate.Down := true;
  end
  else if Sender = tbScale then
  begin
    editMode := modeScale;
    tbScale.Down := true;
  end
  else begin
    editMode := modeMove;
    tbMove.Down := true;
  end;
end;

procedure TEditForm.tbFullViewClick(Sender: TObject);
begin
  MainForm.mnuFullScreenClick(Sender);
end;

//-- Variable List -------------------------------------------------------------

// --Z-- hmmmm!
// this procedure is EXACT copy of ValidateVariation,
// the only difference is Set/Get-Variable instead of array access,
// which kinda is not good! :-\
// I think we should make an array of variables, maybe just for the editor...

procedure TEditForm.ValidateVariable;
var
  i: integer;
  NewVal, OldVal: double;
begin
  i := vleVariables.Row;

  cp.xform[SelectedTriangle].GetVariable(vleVariables.Keys[i], OldVal);
  { Test that it's a valid floating point number }
  try
    NewVal := Round6(StrToFloat(vleVariables.Values[vleVariables.Keys[i]]));
  except
    { It's not, so we restore the old value }
    vleVariables.Values[vleVariables.Keys[i]] := Format('%.6g', [OldVal]);
    exit;
  end;
  { If it's not the same as the old value and it was valid }
  if (NewVal <> OldVal) then
  begin
    MainForm.UpdateUndo;
    cp.xform[SelectedTriangle].SetVariable(vleVariables.Keys[i], NewVal);
    vleVariables.Values[vleVariables.Keys[i]] := Format('%.6g', [NewVal]);
    ShowSelectedInfo;
    UpdateFlame(True);
  end;
end;

procedure TEditForm.vleVariablesExit(Sender: TObject);
begin
  ValidateVariable;
end;

procedure TEditForm.vleVariablesKeyPress(Sender: TObject; var Key: Char);
begin
  if key <> #13 then Exit;
  key := #0;

  ValidateVariable;
end;

procedure TEditForm.vleVariablesValidate(Sender: TObject; ACol, ARow: Integer; const KeyName, KeyValue: string);
begin
  ValidateVariable;
end;

procedure TEditForm.txtValidateValue(Sender: TObject);
var
  t: double;
begin
  try
    t := StrToFloat(TComboBox(Sender).Text);
    if t <> 0 then exit;
  except
    TComboBox(Sender).ItemIndex := 1;
  end;
end;

procedure TEditForm.txtValKeyPress(Sender: TObject; var Key: Char);
begin
  if key <> #13 then exit;
  key := #0;
  txtValidateValue(Sender);
end;

procedure TEditForm.mnuResetClick(Sender: TObject);
begin
  MainForm.UpdateUndo;
  MainTriangles[SelectedTriangle] := MainTriangles[-1];
  UpdateFlame(True);
end;

procedure TEditForm.mnuResetAllClick(Sender: TObject);
var
  i: integer;
begin
  MainForm.UpdateUndo;
  for i := 0 to Transforms-1 do cp.xform[i].Clear;//density := 0;
  cp.xform[0].vars[0] := 1;
  cp.xform[0].density := 0.5;
  cp.xform[1].vars[0] := 1;
  cp.xform[1].density := 0.5;
  cp.xform[1].color := 1;
  cp.xform[2].symmetry := 1;

  Transforms := 2;
  SelectedTriangle := 1;
  MainTriangles[0] := MainTriangles[-1];
  MainTriangles[1] := MainTriangles[-1];
  MainTriangles[2] := MainTriangles[-1];

  assert(cp.HasFinalXForm = false);
{  with cp.xform[0] do begin
    density := 0.5;
    color := 0;
    symmetry := 0;
    vars[0] := 1;
    p[0, 0] := 1;
    p[0, 1] := 0;
    p[1, 0] := 0;
    p[1, 1] := 1;
    p[2, 0] := 0;
    p[2, 1] := 0;
  end;
  with cp.xform[1] do begin
    density := 0.5;
    color := 1;
    symmetry := 0;
    vars[0] := 1;
    p[0, 0] := 1;
    p[0, 1] := 0;
    p[1, 0] := 0;
    p[1, 1] := 1;
    p[2, 0] := 0;
    p[2, 1] := 0;
  end;
  for i := 1 to NRVAR - 1 do
  begin
    cp.xform[0].vars[i] := 0;
    cp.xform[1].vars[i] := 0;
  end;
}
  cbTransforms.clear;
  cbTransforms.Items.Add('1');
  cbTransforms.Items.Add('2');
  AutoZoom;
  UpdateFlame(True);
end;

// -----------------------------------------------------------------------------

procedure TEditForm.btnXcoefsClick(Sender: TObject);
begin
  with cp.xform[SelectedTriangle] do
  begin
    if (c[0][0] = 1) and (c[0][1] = 0) then exit;

    MainForm.UpdateUndo;
    c[0][0] := 1;
    c[0][1] := 0;
  end;
  cp.TrianglesFromCP(MainTriangles);
  UpdateFlame(True);
end;

procedure TEditForm.btnYcoefsClick(Sender: TObject);
begin
  if (cp.xform[SelectedTriangle].c[1][0] = 0) and
     (cp.xform[SelectedTriangle].c[1][1] = 1) then exit;

  MainForm.UpdateUndo;
  cp.xform[SelectedTriangle].c[1][0] := 0;
  cp.xform[SelectedTriangle].c[1][1] := 1;
  cp.TrianglesFromCP(MainTriangles);
  UpdateFlame(True);
end;

procedure TEditForm.btnOcoefsClick(Sender: TObject);
begin
  if (cp.xform[SelectedTriangle].c[2][0] = 0) and
     (cp.xform[SelectedTriangle].c[2][1] = 0) then exit;

  MainForm.UpdateUndo;
  cp.xform[SelectedTriangle].c[2][0] := 0;
  cp.xform[SelectedTriangle].c[2][1] := 0;
  cp.TrianglesFromCP(MainTriangles);
  UpdateFlame(True);
end;

procedure TEditForm.btnCoefsModeClick(Sender: TObject);
begin
  ShowSelectedInfo;
end;

procedure TEditForm.tbVarPreviewClick(Sender: TObject);
begin
  showVarPreview := not showVarPreview;
  tbVarPreview.Down := showVarPreview;
  TriangleView.Invalidate;
end;

procedure TEditForm.trkVarPreviewRangeChange(Sender: TObject);
begin
  trkVarPreviewRange.Hint := Format('Range: %d', [trkVarPreviewRange.position]);
  TriangleView.Invalidate;
end;

procedure TEditForm.trkVarPreviewDensityChange(Sender: TObject);
begin
  trkVarPreviewDensity.Hint := Format('Density: %d', [trkVarPreviewDensity.position]);
  TriangleView.Invalidate;
end;

procedure TEditForm.trkVarPreviewDepthChange(Sender: TObject);
begin
  trkVarPreviewDepth.Hint := Format('Depth: %d', [trkVarPreviewDepth.position]);
  TriangleView.Invalidate;
end;

procedure TEditForm.btnXpostClick(Sender: TObject);
begin
  with cp.xform[SelectedTriangle] do
  begin
    if (p[0][0] = 1) and (p[0][1] = 0) then exit;

    MainForm.UpdateUndo;
    p[0][0] := 1;
    p[0][1] := 0;
  end;
  UpdateFlame(True);
end;

procedure TEditForm.btnYpostClick(Sender: TObject);
begin
  if (cp.xform[SelectedTriangle].p[1][0] = 0) and
     (cp.xform[SelectedTriangle].p[1][1] = 1) then exit;

  MainForm.UpdateUndo;
  cp.xform[SelectedTriangle].p[1][0] := 0;
  cp.xform[SelectedTriangle].p[1][1] := 1;
  UpdateFlame(True);
end;

procedure TEditForm.btnOpostClick(Sender: TObject);
begin
  if (cp.xform[SelectedTriangle].p[2][0] = 0) and
     (cp.xform[SelectedTriangle].p[2][1] = 0) then exit;

  MainForm.UpdateUndo;
  cp.xform[SelectedTriangle].p[2][0] := 0;
  cp.xform[SelectedTriangle].p[2][1] := 0;
  UpdateFlame(True);
end;

// --Z-- copying functions is dumb... I am so lazy :-(

procedure TEditForm.PostCoefKeypress(Sender: TObject; var Key: Char);
begin
  if key <> #13 then exit;
  key := #0;
  PostCoefValidate(Sender);
end;

procedure TEditForm.PostCoefValidate(Sender: TObject);
var
  NewVal: double;
  x, y, r, a: double; // dumb... must optimize
begin
  try
    NewVal := Round6(StrToFloat(TEdit(Sender).Text));
  except on Exception do
    begin
      ShowSelectedInfo;
      exit;
    end;
  end;

  MainForm.UpdateUndo; // TODO - prevent unnecessary UpdateUndo...
 with cp.xform[SelectedTriangle] do
 begin
  if btnCoefsRect.Down = true then
  begin
    if Sender = txtPost00 then p[0][0] := NewVal
    else if Sender = txtPost01 then p[0][1] := -NewVal
    else if Sender = txtPost10 then p[1][0] := -NewVal
    else if Sender = txtPost11 then p[1][1] := NewVal
    else if Sender = txtPost20 then p[2][0] := NewVal
    else if Sender = txtPost21 then p[2][1] := -NewVal;
  end
  else begin
    if (Sender = txtPost00) or (Sender = txtPost01) then begin
      x := p[0][0];
      y := -p[0][1];
    end else
    if (Sender = txtPost10) or (Sender = txtPost11) then begin
      x := -p[1][0];
      y := p[1][1];
    end else
    begin
      x := p[2][0];
      y := -p[2][1];
    end;
    r := Hypot(x, y);
    a := arctan2(y, x);

    if (Sender = txtPost00) or (Sender = txtPost10) or (Sender = txtPost20) then
      r := NewVal
    else
      a := NewVal*PI/180;

    x := r * cos(a);
    y := r * sin(a);
    if (Sender = txtPost00) or (Sender = txtPost01) then begin
      p[0][0] := x;
      p[0][1] := -y;
    end else
    if (Sender = txtPost10) or (Sender = txtPost11) then begin
      p[1][0] := -x;
      p[1][1] := y;
    end else
    begin
      p[2][0] := x;
      p[2][1] := -y;
    end;
  end;
 end;
  ShowSelectedInfo;
  UpdateFlame(true);
end;

procedure TEditForm.btnResetPostXFormClick(Sender: TObject);
begin
 with cp.xform[SelectedTriangle] do
 begin
  if (p[0,0]<>1) or (p[0,1]<>0) or(p[1,0]<>0) or (p[1,1]<>1) or (p[2,0]<>0) or (p[2,1]<>0) then
  begin
    MainForm.UpdateUndo;
    p[0, 0] := 1;
    p[0, 1] := 0;
    p[1, 0] := 0;
    p[1, 1] := 1;
    p[2, 0] := 0;
    p[2, 1] := 0;
    ShowSelectedInfo;
    UpdateFlame(True);
  end;
 end;
end;

procedure TEditForm.btnPivotModeClick(Sender: TObject);
begin
  if PivotMode <> pivotLocal then
  with MainTriangles[SelectedTriangle] do begin
    PivotMode := pivotLocal;
    btnPivotMode.Caption := 'Local Pivot';
  end
  else
  with MainTriangles[SelectedTriangle] do begin
    PivotMode := pivotWorld;
    btnPivotMode.Caption := 'World Pivot';
  end;

  TriangleView.Invalidate;
  ShowSelectedInfo;
end;

procedure TEditForm.PivotValidate(Sender: TObject);
var
  v: double;
begin
  try
    v := Round6(StrToFloat(TEdit(Sender).Text));
  except on Exception do
    begin
      ShowSelectedInfo;
      exit;
    end;
  end;

  if Sender = editPivotX then
    if v <> Round6(GetPivot.x) then begin
      if PivotMode = pivotLocal then LocalPivot.x := v
      else WorldPivot.x := v;
    end
    else exit
  else
    if v <> Round6(GetPivot.y) then begin
      if PivotMode = pivotLocal then LocalPivot.y := v
      else WorldPivot.y := v;
    end
    else exit;

  TriangleView.Invalidate;
  ShowSelectedInfo;
end;

procedure TEditForm.PivotKeyPress(Sender: TObject; var Key: Char);
begin
  if key <> #13 then exit;
  key := #0;
  PivotValidate(Sender);
end;

procedure TEditForm.btnResetPivotClick(Sender: TObject);
begin
  if editMode = modePick then begin
    editMode := oldMode;
    oldMode := modeNone;
    // hack: to generate MouseMove event
    GetCursorPos(MousePos);
    SetCursorPos(MousePos.x, MousePos.y);
    //
  end;
  if PivotMode = pivotLocal then
  begin
    LocalPivot.x := 0;
    LocalPivot.y := 0;
  end
  else begin
    WorldPivot.x := 0;
    WorldPivot.y := 0;
  end;
  TriangleView.Invalidate;
  ShowSelectedInfo;
end;

procedure TEditForm.btnPickPivotClick(Sender: TObject);
begin
  if editMode = modePick then begin
    editMode := oldMode;
    oldMode := modeNone;
    TriangleView.Invalidate;
    // hack: to generate MouseMove event
    GetCursorPos(MousePos);
    SetCursorPos(MousePos.x, MousePos.y);
    //
    exit;
  end;
  if oldMode <> modeNone then exit;
  oldMode := editMode;
  editMode := modePick;
  TriangleView.Invalidate;
  btnPickPivot.Down := true;
end;

// this function is temporary...................................................
procedure TEditForm.btnSwapXformsClick(Sender: TObject);
var
  i, j: integer;
  t: double;
begin
  MainForm.UpdateUndo;
  for i := 0 to 2 do
    for j := 0 to 1 do
      with cp.xform[SelectedTriangle] do
      begin
        t:=c[i,j];
        c[i,j]:=p[i,j];
        p[i,j]:=t;
      end;
  cp.TrianglesFromCP(MainTriangles);
  ShowSelectedInfo;
  UpdateFlame(true);
end;
// .............................................................................

procedure TEditForm.VEVarsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if (ARow > NRLOCVAR) and not (gdSelected in	State) then
  begin
    VEVars.canvas.brush.Color := $ffe0e0;
    VEVars.canvas.fillRect(Rect);
    VEVars.canvas.TextOut(Rect.Left+2, Rect.Top+2, VEVars.Cells[ACol,ARow]);
  end;
end;

procedure TEditForm.tbEnableFinalXformClick(Sender: TObject);
begin
  MainForm.UpdateUndo;
  EnableFinalXform := tbEnableFinalXform.Down;
  if (cp.HasFinalXForm = false) then
  begin
    if (EnableFinalXform = true) then
    begin
      cbTransforms.Items.Add('Final');
      SelectedTriangle := Transforms;
      if (mouseOverTriangle > LastTriangle) then mouseOverTriangle := -1;
    end
    else begin
      if cbTransforms.Items.Count = Transforms+1 then
        cbTransforms.Items.Delete(Transforms);
      if SelectedTriangle >= Transforms then SelectedTriangle := Transforms-1;
    end;
  end;
  cp.finalXformEnabled := EnableFinalXform;
  UpdateFlame(True);
  TriangleView.Invalidate;
end;

procedure TEditForm.DragPanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then exit;

  //assert(pnlDragMode = false);

  if (Sender = pnlWeight) then
    if SelectedTriangle < Transforms then
      pnlDragValue := cp.xform[SelectedTriangle].density
    else exit
  else if (Sender = pnlSymmetry) then
    pnlDragValue := cp.xform[SelectedTriangle].symmetry
  else if (Sender = pnlXformColor) then
    pnlDragValue := cp.xform[SelectedTriangle].color
  else assert(false);

  pnlDragMode := true;
  pnlDragPos := 0;
  pnlDragOld := x;
  varMM := false;
  //SetCaptureControl(TControl(Sender));

  Screen.Cursor := crHSplit;
  GetCursorPos(mousepos); // hmmm
  HasChanged := false;
end;

procedure TEditForm.DragPanelMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  v: double;
  pEdit: ^TEdit;
begin
  if varMM then // hack: to skip MouseMove event
  begin
    varMM:=false;
  end
  else
  if pnlDragMode and (x <> pnlDragOld) then
  begin
    Inc(pnlDragPos, x - pnlDragOld);

    if GetKeyState(VK_MENU) < 0 then v := 100000
    else if GetKeyState(VK_CONTROL) < 0 then v := 10000
    else if GetKeyState(VK_SHIFT) < 0 then v := 100
    else v := 1000;

    v := Round6(pnlDragValue + pnlDragPos / v);

    SetCursorPos(MousePos.x, MousePos.y); // hmmm
    varMM:=true;

    if (Sender = pnlWeight) then
    begin
      if v <= 0.000001 then v := 0.000001;
      cp.xform[SelectedTriangle].density := v;
      pEdit := @txtP;
    end
    else if (Sender = pnlSymmetry) then
    begin
      if v < -1 then v := -1
      else if v > 1 then v := 1;
      cp.xform[SelectedTriangle].symmetry := v;
      pEdit := @txtSymmetry;
    end
    else if (Sender = pnlXformColor) then
    begin
      if v < 0 then v := 0
      else if v > 1 then v := 1;
      cp.xform[SelectedTriangle].color := v;
      pnlXFormColor.Color := ColorValToColor(cp.cmap, v);
      updating := true;
      scrlXformColor.Position := round(v*1000);
      pEdit := @txtXformColor;
      updating := false;
    end
    else assert(false);
    pEdit^.Text := FloatToStr(v); // Format('%.6g', [v])
    //pEdit.Refresh;
    HasChanged := True;
    DrawPreview;
  end;
end;

procedure TEditForm.DragPanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then exit;

  if pnlDragMode then
  begin
    //SetCaptureControl(nil);

    pnlDragMode := false;
    Screen.Cursor := crDefault;

    if HasChanged then
    begin
      MainForm.UpdateUndo;

      UpdateFlame(true);
      HasChanged := False;
    end;
  end;
end;

procedure TEditForm.DragPanelDblClick(Sender: TObject);
var
  pValue: ^double;
  pEdit: ^TEdit;
begin
  if (Sender = pnlWeight) then
  begin
    if SelectedTriangle = LastTriangle then exit; // hmm
    pValue := @cp.xform[SelectedTriangle].density;
    if pValue^ = 0.5 then exit;
    pValue^ := 0.5;
    pEdit := @txtP;
  end
  else if (Sender = pnlSymmetry) then
  begin
    pValue := @cp.xform[SelectedTriangle].symmetry;
    if pValue^ = 0 then exit;
    pValue^ := 0;
    pEdit := @txtSymmetry;
  end
  else if (Sender = pnlXformColor) then
  begin
    pValue := @cp.xform[SelectedTriangle].color;
    if pValue^ = 0 then exit;
    pValue^ := 0;
    pEdit := @txtXformColor;
  end
  else assert(false);

  MainForm.UpdateUndo;
  pEdit^.Text := FloatToStr(pValue^);
  UpdateFlame(true);
end;

end.

