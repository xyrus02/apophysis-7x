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

//{$D-,L-,O+,Q-,R-,Y-,S-}

unit Editor;

//{$define VAR_STR}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Math, Menus, ToolWin, Registry,
  Grids, ValEdit, Buttons, ImgList, Types,  StrUtils , Curves,
  ControlPoint, XForm, cmap, CustomDrawControl,
  RenderingInterface, Translation, RenderThread;

type
  TEditForm = class(TForm)
    StatusBar: TStatusBar;
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
    tbScale: TToolButton;
    tbFlipHorz: TToolButton;
    tbFlipVert: TToolButton;
    tbSelect: TToolButton;
    EditorTB: TImageList;
    tbResetAll: TToolButton;
    ToolButton2: TToolButton;
    tbVarPreview: TToolButton;
    tbEnableFinalXform: TToolButton;
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
    mnuResetTrgRotation: TMenuItem;
    mnuResetTrgPosition: TMenuItem;
    mnuResetTrgScale: TMenuItem;
    N7: TMenuItem;
    mnuExtendedEdit: TMenuItem;
    N8: TMenuItem;
    mnuAxisLock: TMenuItem;
    mnuSelectmode: TMenuItem;
    ToolButton6: TToolButton;
    tbPivotMode: TToolButton;
    tbRotate90CCW: TToolButton;
    tbRotate90CW: TToolButton;
    tbPostXswap: TToolButton;
    oggleposttriangleediting1: TMenuItem;
    mnuCopyTriangle: TMenuItem;
    mnuPasteTriangle: TMenuItem;
    ChaosPopup: TPopupMenu;
    mnuChaosViewTo: TMenuItem;
    mnuChaosViewFrom: TMenuItem;
    N9: TMenuItem;
    mnuChaosClearAll: TMenuItem;
    mnuChaosSetAll: TMenuItem;
    N10: TMenuItem;
    mnuLinkPostxform: TMenuItem;
    mnuChaosRebuild: TMenuItem;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    EditPnl: TPanel;
    Splitter1: TSplitter;
    GrphPnl: TPanel;
    RightPanel: TPanel;
    Splitter2: TSplitter;
    ControlPanel: TPanel;
    cbTransforms: TComboBox;
    PageControl: TPageControl;
    TriangleTab: TTabSheet;
    TriangleScrollBox: TScrollBox;
    TrianglePanel: TPanel;
    ToolBar1: TToolBar;
    tbCopyTriangle: TToolButton;
    tbPasteTriangle: TToolButton;
    tbExtendedEdit: TToolButton;
    tbAxisLock: TToolButton;
    tbAutoWeights: TToolButton;
    tb2PostXswap: TToolButton;
    tabXForm: TTabSheet;
    tabColors: TTabSheet;
    GroupBox4: TGroupBox;
    chkXformInvisible: TCheckBox;
    tabVariations: TTabSheet;
    btnLoadVVAR: TButton;
    VEVars: TValueListEditor;
    chkCollapseVariations: TCheckBox;
    bClear: TBitBtn;
    TabSheet4: TTabSheet;
    vleVariables: TValueListEditor;
    chkCollapseVariables: TCheckBox;
    TabChaos: TTabSheet;
    vleChaos: TValueListEditor;
    optFrom: TRadioButton;
    optTo: TRadioButton;
    txtP: TEdit;
    pnlWeight: TPanel;
    Panel1: TPanel;
    txtName: TEdit;
    Panel2: TPanel;
    PrevPnl: TPanel;
    PreviewImage: TImage;
    GroupBox5: TGroupBox;
    btTrgRotateLeft90: TSpeedButton;
    btTrgRotateRight90: TSpeedButton;
    btTrgScaleDown: TSpeedButton;
    btTrgScaleUp: TSpeedButton;
    btTrgMoveDown: TSpeedButton;
    btTrgMoveLeft: TSpeedButton;
    btTrgMoveRight: TSpeedButton;
    btTrgMoveUp: TSpeedButton;
    btTrgRotateLeft: TSpeedButton;
    btTrgRotateRight: TSpeedButton;
    txtTrgScaleValue: TComboBox;
    txtTrgRotateValue: TComboBox;
    txtTrgMoveValue: TComboBox;
    GroupBox6: TGroupBox;
    LabelC: TLabel;
    LabelA: TLabel;
    LabelB: TLabel;
    txtAx: TEdit;
    txtAy: TEdit;
    txtBx: TEdit;
    txtBy: TEdit;
    txtCx: TEdit;
    txtCy: TEdit;
    ScrollBox1: TScrollBox;
    GroupBox9: TGroupBox;
    btnXcoefs: TSpeedButton;
    btnYcoefs: TSpeedButton;
    btnOcoefs: TSpeedButton;
    btnResetCoefs: TSpeedButton;
    txtA: TEdit;
    txtB: TEdit;
    txtC: TEdit;
    txtD: TEdit;
    txtE: TEdit;
    txtF: TEdit;
    GroupBox7: TGroupBox;
    btnCoefsPolar: TSpeedButton;
    btnCoefsRect: TSpeedButton;
    GroupBox8: TGroupBox;
    btnXpost: TSpeedButton;
    btnYpost: TSpeedButton;
    btnOpost: TSpeedButton;
    btnResetPostCoefs: TSpeedButton;
    txtPost00: TEdit;
    txtPost01: TEdit;
    txtPost10: TEdit;
    txtPost11: TEdit;
    txtPost20: TEdit;
    txtPost21: TEdit;
    chkAutoZscale: TCheckBox;
    ScrollBox2: TScrollBox;
    GroupBox1: TGroupBox;
    pnlSymmetry: TPanel;
    pnlXFormColor: TPanel;
    shColor: TShape;
    txtXFormColor: TEdit;
    txtSymmetry: TEdit;
    ColorBar: TPanel;
    ColorBarPicture: TImage;
    scrlXFormColor: TScrollBar;
    pnlOpacity: TPanel;
    txtOpacity: TEdit;
    chkXformSolo: TCheckBox;
    pnlDC: TPanel;
    txtDC: TEdit;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    trkVarPreviewDensity: TTrackBar;
    trkVarPreviewRange: TTrackBar;
    trkVarPreviewDepth: TTrackBar;
    ImgTemp: TImage;
    N11: TMenuItem;
    mnuEHighQuality: TMenuItem;
    mnuEMediumQuality: TMenuItem;
    mnuELowQuality: TMenuItem;
    Label4: TLabel;
    txtSearchBox: TEdit;
    ToolButton5: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    SpeedButton1: TSpeedButton;
    GroupBox3: TGroupBox;
    btnResetPivot: TSpeedButton;
    btnPickPivot: TSpeedButton;
    btnPivotMode: TSpeedButton;
    editPivotY: TEdit;
    editPivotX: TEdit;
    procedure ToolButton12Click(Sender: TObject);
    procedure btnResetSearchClick(Sender: TObject);
    procedure txtSearchBoxKeyPress(Sender: TObject; var Key: Char);
    procedure txtSearchBoxChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ScrollBox1Resize(Sender: TObject);
    procedure ScrollBox2Resize(Sender: TObject);
    procedure ControlPanelResize(Sender: TObject);
    procedure TrianglePanelResize(Sender: TObject);

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
    procedure TriangleViewDblClick(Sender: TObject);
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
    procedure mnuFlipAllVClick(Sender: TObject);
    procedure mnuFlipAllHClick(Sender: TObject);
    procedure mnuFlipVerticalClick(Sender: TObject);
    procedure mnuFlipHorizontalClick(Sender: TObject);
    procedure cbTransformsChange(Sender: TObject);
    procedure CoefKeyPress(Sender: TObject; var Key: Char);
    procedure CoefValidate(Sender: TObject);
    procedure scrlXFormColorScroll(Sender: TObject;
      ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure scrlXFormColorChange(Sender: TObject);
//    procedure chkUseXFormColorClick(Sender: TObject);
//    procedure chkHelpersClick(Sender: TObject);
    procedure txtXFormColorExit(Sender: TObject);
    procedure txtXFormColorKeyPress(Sender: TObject; var Key: Char);
    procedure txtSymmetrySet(Sender: TObject);
    procedure txtSymmetrKeyPress(Sender: TObject; var Key: Char);
    procedure txtDCSet(Sender: TObject);
    procedure txtDCKeyPress(Sender: TObject; var Key: Char);
    procedure txtOpacitySet(Sender: TObject);
    procedure txtOpacityKeyPress(Sender: TObject; var Key: Char);

    procedure btTrgRotateLeftClick(Sender: TObject);
    procedure btTrgRotateRightClick(Sender: TObject);
    procedure btTrgRotateLeft90Click(Sender: TObject);
    procedure btTrgRotateRight90Click(Sender: TObject);
    procedure TrgMove(dx, dy: double);
    procedure btTrgMoveLeftClick(Sender: TObject);
    procedure btTrgMoveRightClick(Sender: TObject);
    procedure btTrgMoveUpClick(Sender: TObject);
    procedure btTrgMoveDownClick(Sender: TObject);
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
    procedure mnuResetTriangleClick(Sender: TObject);
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
    procedure btnResetCoefsClick(Sender: TObject);
    procedure btnResetPostCoefsClick(Sender: TObject);
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
    procedure mnuResetTrgRotationClick(Sender: TObject);
    procedure mnuResetTrgScaleClick(Sender: TObject);
    procedure ResetAxisRotation(n: integer);
    procedure ResetAxisScale(n: integer);
    procedure tbExtendedEditClick(Sender: TObject);
    procedure tbAxisLockClick(Sender: TObject);
    procedure tbPostXswapClick(Sender: TObject);
    procedure btnCopyTriangleClick(Sender: TObject);
    procedure btnPasteTriangleClick(Sender: TObject);
    procedure chkAutoZscaleClick(Sender: TObject);
    procedure ValidateChaos;
    procedure vleChaosExit(Sender: TObject);
    procedure vleChaosKeyPress(Sender: TObject; var Key: Char);
    procedure vleChaosValidate(Sender: TObject; ACol, ARow: Integer;
      const KeyName, KeyValue: String);
    procedure VleChaosDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure mnuChaosViewToClick(Sender: TObject);
    procedure mnuChaosViewFromClick(Sender: TObject);
    procedure chkPlotModeClick(Sender: TObject);
    procedure mnuChaosClearAllClick(Sender: TObject);
    procedure mnuChaosSetAllClick(Sender: TObject);
    procedure mnuLinkPostxformClick(Sender: TObject);
    procedure chkXformSoloClick(Sender: TObject);
    procedure mnuChaosRebuildClick(Sender: TObject);
    procedure chkCollapseVariationsClick(Sender: TObject);
    procedure chkCollapseVariablesClick(Sender: TObject);
    procedure shColorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure shColorMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure shColorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bClearClick(Sender: TObject);
    procedure ColorBarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnLoadVVARClick(Sender: TObject);
    procedure txtNameKeyPress(Sender: TObject; var Key: Char);
    procedure txtNameExit(Sender: TObject);
//    procedure btnInvisibleClick(Sender: TObject);
//    procedure btnSoloClick(Sender: TObject);

  private
    TriangleView: TCustomDrawControl;
    cmap: TColorMap;
    PreviewDensity: double;

    viewDragMode, viewDragged: boolean;
    editMode, oldMode, widgetMode: (modeNone, modeMove, modeRotate, modeScale, modePick);
    modeHack: boolean; // for mouseOverEdge...
    modeKey: word;
    key_handled: boolean;
    updating: boolean;

    MousePos: TPoint; // in screen coordinates
    mouseOverTriangle, mouseOverEdge, mouseOverCorner, mouseOverWidget: integer;
    mouseOverPos: TSPoint;

    Widgets: array[0..3] of array [0..2] of TSPoint;
    xx, xy, yx, yy: double;

    varDragMode: boolean;
    varDragIndex: integer;
    varDragValue: double;
    varDragPos, varDragOld: integer;
    varMM: boolean; //hack?
    pDragValue: ^double;

    SelectMode, ExtendedEdit, AxisLock: boolean;
    showVarPreview: boolean;

    GraphZoom: double;
    TriangleCaught, CornerCaught, EdgeCaught: boolean;
    LocalAxisLocked: boolean;
//    SelectedTriangle: integer; // outside only for scripting
    oldSelected: integer;
    SelectedCorner: integer;
    HasChanged: boolean;

    oldTriangle: TTriangle;
    gCenterX: double;
    gCenterY: double;

    MemTriangle: TTriangle;

    oldx, oldy, olddist: double;
    Pivot: TSPoint;

    VarsCache: array[0..150] of double; // hack: to prevent slow valuelist redraw
                                        // -JF- 64 wasn't big enough... buffer overrun
    BackgroundBmp : TBitmap;
    Renderer : TRenderThread;

    pnlDragMode: boolean;
    pnlDragPos, pnlDragOld: integer;
    pnlDragValue: double;

    LastFocus: TEdit;

    procedure UpdateFlameX;
    procedure UpdateFlame(DrawMain: boolean);
    procedure UpdateWidgets;
    procedure UpdateXformsList;

    procedure DeleteTriangle(t: integer);

    function GetPivot: TSPoint; overload;
    function GetPivot(n: integer): TSPoint; overload;

    procedure ShowSelectedInfo;
    procedure Scale(var fx, fy: double; x, y: integer);

    procedure TriangleViewPaint(Sender: TObject);
    procedure AutoZoom;

    procedure KeyInput(str: string);
  public
    cp: TControlPoint;
    Render: TRenderer;

    // Accessible from scripter
    SelectedTriangle: integer;
    PivotMode: (pivotLocal, pivotWorld);
    LocalPivot, WorldPivot: TSPoint;

    procedure UpdatePreview;
    procedure UpdateDisplay(PreviewOnly: boolean = false); //(?)

    function GetTriangleColor(n: integer): TColor;
    function LastTriangle: integer;
    function InsideTriangle(x, y: double): integer;

    procedure ScriptGetPivot(var px, py: double);
    procedure InvokeResetAll;
    procedure UpdateColorBar;

    procedure PaintBackground;
  end;

const
  {TrgColors: array[-1..13] of TColor = (clGray,
    $0000ff, $00ffff, $00ff00, $ffff00, $ff0000, $ff00ff, $007fff,
    $7f00ff, $55ffff, $ccffcc, $ffffaa, $ff7f7f, $ffaaff, $55ccff );}
   TrgColors: array[-1..13] of TColor = (clGray,
    $0000ff, $00cccc, $00cc00, $cccc00, $ff4040, $cc00cc, $0080cc,
    $4f0080, $228080, $608060, $808050, $804f4f, $805080, $226080 );

var
  EditForm: TEditForm;

function ColorValToColor(c: TColorMap; index: double): TColor;
function FlipTriangleVertical(t: TTriangle): TTriangle;
function FlipTriangleHorizontal(t: TTriangle): TTriangle;
function RotateTriangle(t: TTriangle; rad: double): TTriangle;
function OffsetTriangle(t: TTriangle; range: double): TTriangle;
function ScaleTriangle(t: TTriangle; scale: double): TTriangle;
function RotateTriangleCenter(t: TTriangle; rad: double): TTriangle;
function RotateTrianglePoint(t: TTriangle; xr, yr: double; rad: double): TTriangle;
function Centroid(t: TTriangle): TSPoint;
function OffsetTriangleRandom(t: TTriangle): TTriangle;
function ScaleTriangleCenter(t: TTriangle; scale: double): TTriangle;
function ScaleTrianglePoint(t: TTriangle; x, y, scale: double): TTriangle;

implementation

uses
  Main, Global, Adjust, Mutate, XformMan;

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
  //assert(scale <> 0);
  if scale = 0 then scale := 1e-64;

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
    Result.x[i] := xr + (t.x[i] - xr) * cos(rad) - (t.y[i] - yr) * sin(rad);
    Result.y[i] := yr + (t.x[i] - xr) * sin(rad) + (t.y[i] - yr) * cos(rad);
  end;
end;

function RotateTrianglePoint(t: TTriangle; xr, yr: double; rad: double): TTriangle;
var
  i: integer;
begin
  for i := 0 to 2 do
  begin
    Result.x[i] := xr + (t.x[i] - xr) * cos(rad) - (t.y[i] - yr) * sin(rad);
    Result.y[i] := yr + (t.x[i] - xr) * sin(rad) + (t.y[i] - yr) * cos(rad);
  end;
end;

function ColorValToColor(c: TColorMap; index: double): TColor;
var
  i: integer;
begin
  i := Trunc(Index * 255);
  assert(i >= 0);
  assert(i < 256);
  result := c[i][2] shl 16 + c[i][1] shl 8 + c[i][0];
end;

procedure TEditForm.UpdatePreview;
var
  pw, ph: integer;
begin
  pw := PrevPnl.Width -2;
  ph := PrevPnl.Height -2;
  if (cp.width / cp.height) > (pw / ph) then
  begin
    PreviewImage.Width := pw;
    assert(pw <> 0);
    PreviewImage.Height := round(cp.height / cp.Width * pw);
    PreviewImage.Left := 1;
    PreviewImage.Top := (ph - PreviewImage.Height) div 2;
  end
  else begin
    PreviewImage.Height := ph;
    assert(ph <> 0);
    PreviewImage.Width := round(cp.Width / cp.Height * ph);
    PreviewImage.Top := 1;
    PreviewImage.Left := (pw - PreviewImage.Width) div 2;
  end;
  cp.AdjustScale(PreviewImage.Width, PreviewImage.Height);
  DrawPreview;
  TriangleViewPaint(TriangleView);
end;

procedure TEditForm.UpdateXformsList;
var
  i, n: integer;
  prefix: string;
begin
  cbTransforms.Clear;
  for i := 1 to Transforms do begin
    
    cbTransforms.Items.Add(IntToStr(i));
  end;
  if EnableFinalXform or cp.HasFinalXForm then cbTransforms.Items.Add(TextByKey('editor-common-finalxformlistitem'));
  cbTransforms.ItemIndex := SelectedTriangle;

  if mnuChaosViewTo.Checked then prefix := TextByKey('editor-common-toprefix')
  else prefix := TextByKey('editor-common-fromprefix');
  n := Transforms + 1;
  while vleChaos.RowCount > n do
    vleChaos.DeleteRow(vleChaos.RowCount-1);
  while vleChaos.RowCount < n do
    vleChaos.InsertRow(Format(prefix, [vleChaos.RowCount]), '1', true);

  chkCollapseVariablesClick(nil);
  chkCollapseVariationsClick(nil);
end;

procedure TEditForm.UpdateDisplay(PreviewOnly: boolean = false);
begin
  // currently EditForm does not really know if we select another
  // flame in the Main Window - which is not good...

  cp.copy(MainCp);

  if SelectedTriangle > LastTriangle{???} then
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

  UpdateXformsList;
  UpdateColorBar;

  // just in case:
  SetCaptureControl(nil);
  HasChanged := false;
//  viewDragMode := false;
  varDragMode := false;
  pnlDragMode := false;
  CornerCaught := false;
  EdgeCaught := false;
  TriangleCaught := false;

  cp.TrianglesFromCP(MainTriangles);

  ShowSelectedInfo;
  if MainForm.UndoIndex = 0 then AutoZoom // auto-zoom only on 'new' flame
  else TriangleView.Invalidate;
end;

procedure TEditForm.DrawPreview;
begin
  if EnableEditorPreview then exit;

  //Render.Stop;
  cp.sample_density := PreviewDensity;
  cp.spatial_oversample := defOversample;
  cp.spatial_filter_radius := defFilterRadius;
  if mnuResetLoc.checked then
  begin
    cp.zoom := 0;
    cp.CalcBoundbox;
{  end
  else
  begin
    cp.zoom := MainCp.zoom;
    cp.center[0] := MainCp.Center[0];
    cp.center[1] := MainCp.Center[1];
}
  end;

  cp.cmap := MainCp.cmap;
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
  n : integer;
begin
  updating := true;

  if (SelectedTriangle > LastTriangle) then
    SelectedTriangle := LastTriangle;
  for i:=0 to Transforms -1 do begin
    if (i >= Transforms) then begin
     if (cbTransforms.Items.Count > Transforms) then cbTransforms.Items[i] := TextByKey('editor-common-finalxformlistitem')
    end else begin
    n := i + 1;
    if (cp.xform[i].TransformName <> '') then
      cbTransforms.Items[i] := IntToStr(n) + ' - ' + cp.xform[i].TransformName
    else
      cbTransforms.Items[i] := IntToStr(n);
    end;
  end;

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

    tbPostXswap.Down := postXswap;
    tb2PostXswap.Down := postXswap;

    //GroupBox8.Visible := postXswap;
    //GroupBox9.Visible := not postXswap;

    (*if postXswap then begin
      GroupBox9.Top := 152;
      GroupBox8.Top := 0;
    end else begin
      GroupBox8.Top := 152;
      GroupBox9.Top := 0;
    end;   *)

    if postXswap then begin
      btnXcoefs.Font.Style := [];
      btnYcoefs.Font.Style := [];
      btnOcoefs.Font.Style := [];
      btnXpost.Font.Style := [fsBold];
      btnYpost.Font.Style := [fsBold];
      btnOpost.Font.Style := [fsBold];
      btnResetCoefs.Font.Style := [];
      btnResetPostCoefs.Font.Style := [fsBold];
    end
    else begin
      btnXcoefs.Font.Style := [fsBold];
      btnYcoefs.Font.Style := [fsBold];
      btnOcoefs.Font.Style := [fsBold];
      btnXpost.Font.Style := [];
      btnYpost.Font.Style := [];
      btnOpost.Font.Style := [];
      btnResetCoefs.Font.Style := [fsBold];
      btnResetPostCoefs.Font.Style := [];
    end;

    chkAutoZscale.Checked := autoZscale;

    if SelectedTriangle < Transforms then
    begin
      txtP.text := Format('%.6g', [density]);
      txtP.Enabled := true;
      txtName.Enabled := true;
      vleChaos.Enabled := true;
      chkXformInvisible.Enabled := true;
      chkXformInvisible.Checked := transOpacity = 0;
      chkXformSolo.Enabled := true;
      txtOpacity.Enabled := true;
      txtDC.Enabled := true;

      if cp.soloXform >= 0 then begin
        chkXformSolo.Checked := true;
        chkXformSolo.Caption := Format(TextByKey('editor-tab-color-togglesoloformat'), [cp.soloXform + 1]);
      end
      else begin
        chkXformSolo.Checked := false;
        chkXformSolo.Caption := TextByKey('editor-tab-color-togglesolo');
      end;
    end
    else begin // disable controls for FinalXform
      txtP.Enabled := false;
      txtP.Text := 'n/a';
      txtName.Enabled := false;
      vleChaos.Enabled := false;
      chkXformInvisible.Enabled := false;
      chkXformInvisible.Checked := false;
      txtOpacity.Enabled := false;
      chkXformSolo.Enabled := false;
    end;
    tbEnableFinalXform.Down := EnableFinalXform;

    txtSymmetry.text := Format('%.6g', [symmetry]);
    txtOpacity.text := Format('%.6g', [transOpacity]);
    txtDC.Text := Format('%.6g', [pluginColor]);

    pnlXFormColor.Color := ColorValToColor(cp.cmap, color);
    shColor.Brush.Color := pnlXformColor.Color;
    txtXFormColor.Text := Format('%1.3f', [color]);
    scrlXFormcolor.Position := Trunc(color * scrlXFormColor.Max);

   for i := 0 to NRVAR-1 do begin
       v := GetVariation(i);
      if v <> VarsCache[i] then
      begin
        VarsCache[i]:=v;
        VEVars.Values[VarNames(i)] := Format('%.6g', [v]);
      end;
    end;

    for i:= 0 to GetNrVariableNames - 1 do begin
{$ifndef VAR_STR}
      GetVariable(GetVariableNameAt(i), v);
      strval := Format('%.6g', [v]);
{$else}
      strval := GetVariableStr(GetVariableNameAt(i));
{$endif}
       // kinda funny, but it really helped...
      if vleVariables.Values[GetVariableNameAt(i)] <> strval then
        vleVariables.Values[GetVariableNameAt(i)] := strval;
    end;

    //Assert(vleChaos.RowCount = Transforms+1);
    if SelectedTriangle < Transforms then begin
      if mnuChaosViewTo.Checked then
        // view as "to" values
        for i := 1 to Transforms do begin
          strval := Format('%.6g', [modWeights[i - 1]]);
          if vleChaos.Cells[1, i] <> strval then
            vleChaos.Cells[1, i] := strval;
        end
      else
        // view as "from" values
        for i := 1 to Transforms do begin
          strval := Format('%.6g', [cp.xform[i - 1].modWeights[SelectedTriangle]]);
          if vleChaos.Cells[1, i] <> strval then
            vleChaos.Cells[1, i] := strval;
        end;
    end
    else
      for i := 1 to vleChaos.RowCount-1 do
        vleChaos.Cells[1, i] := 'n/a';

    txtName.Text := TransformName;
    if (SelectedTriangle >= Transforms) then begin
      txtName.Text := 'n/a';
    end;
  end;

  if PivotMode = pivotLocal then begin
    editPivotX.Text := Format('%.6g', [LocalPivot.x]);
    editPivotY.Text := Format('%.6g', [LocalPivot.y]);
    btnPivotMode.Caption := TextByKey('editor-tab-triangle-modelocal');
    tbPivotMode.Down := false;
  end
  else begin
    editPivotX.Text := Format('%.6g', [WorldPivot.x]);
    editPivotY.Text := Format('%.6g', [WorldPivot.y]);
    btnPivotMode.Caption := TextByKey('editor-tab-triangle-modeworld');
    tbPivotMode.Down := true;
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
  EditForm.StatusBar.Panels[2].Text := Format(TextByKey('editor-status-zoomformat'), [GraphZoom]);

  TriangleView.Invalidate;//Refresh;
end;

procedure TEditForm.UpdateFlameX;
begin
  cp.GetFromTriangles(MainTriangles, Transforms);

  if tbAutoWeights.Down then cp.ComputeWeights(MainTriangles, Transforms);
  DrawPreview;
  ShowSelectedInfo;
  TriangleView.Refresh;

  chkCollapseVariablesClick(nil);
  chkCollapseVariationsClick(nil);
end;

procedure TEditForm.UpdateFlame(DrawMain: boolean);
begin
  StatusBar.Panels[2].Text := Format(TextByKey('editor-status-zoomformat'), [GraphZoom]);

  cp.GetFromTriangles(MainTriangles, LastTriangle);

//  if not chkPreserve.Checked then ComputeWeights(cp, MainTriangles, transforms);
  DrawPreview;
  ShowSelectedInfo;
  TriangleView.Refresh;
  if DrawMain then begin
    MainForm.StopThread;

    MainCp.Copy(cp, true);

    MainCp.cmap := cmap;
    if mnuResetLoc.checked then begin
      MainCp.zoom := 0;
      MainForm.center[0] := cp.center[0];
      MainForm.center[1] := cp.center[1];
    end;
    if AdjustForm.Visible then AdjustForm.UpdateDisplay;
    if MutateForm.Visible then MutateForm.UpdateDisplay;
    if CurvesForm.Visible then CurvesForm.SetCp(MainCp);
    MainForm.RedrawTimer.enabled := true;
  end;

  chkCollapseVariablesClick(nil);
  chkCollapseVariationsClick(nil);
end;

procedure TEditForm.UpdateWidgets;
  function Point(x, y: double): TSPoint;
  begin
    Result.x := x;
    Result.y := y;
  end;
begin
  with mainTriangles[Selectedtriangle] do
  begin
    xx := x[0] - x[1];
    xy := y[0] - y[1];
    yx := x[2] - x[1];
    yy := y[2] - y[1];
    Widgets[0][0] := Point(x[1] + 0.8*xx + yx, y[1] + 0.8*xy + yy);
    Widgets[0][1] := Point(x[1] + xx + yx,     y[1] + xy + yy);
    Widgets[0][2] := Point(x[1] + xx + 0.8*yx, y[1] + xy + 0.8*yy);

    Widgets[1][0] := Point(x[1] - 0.8*xx + yx, y[1] - 0.8*xy + yy);
    Widgets[1][1] := Point(x[1] - xx + yx,     y[1] - xy + yy);
    Widgets[1][2] := Point(x[1] - xx + 0.8*yx, y[1] - xy + 0.8*yy);

    Widgets[2][0] := Point(x[1] - 0.8*xx - yx, y[1] - 0.8*xy - yy);
    Widgets[2][1] := Point(x[1] - xx - yx,     y[1] - xy - yy);
    Widgets[2][2] := Point(x[1] - xx - 0.8*yx, y[1] - xy - 0.8*yy);

    Widgets[3][0] := Point(x[1] + 0.8*xx - yx, y[1] + 0.8*xy - yy);
    Widgets[3][1] := Point(x[1] + xx - yx,     y[1] + xy - yy);
    Widgets[3][2] := Point(x[1] + xx - 0.8*yx, y[1] + xy - 0.8*yy);
  end;
end;

procedure TEditForm.DeleteTriangle(t: integer);
var
  i, j, nmin, nmax: integer;
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
    if (SelectedTriangle = Transforms) then Dec(SelectedTriangle);
  end
  else
  if (Transforms <= 1) then exit
  else begin
    MainForm.UpdateUndo;

    if RebuildXaosLinks then begin
      // check for single "to" links
      for i := 0 to Transforms-1 do
      with cp.xform[i] do begin
        nmin := NXFORMS;
        nmax := -1;
        for j := 0 to Transforms-1 do
          if modWeights[j] <> 0 then begin
            if j < nmin then nmin := j;
            if j > nmax then nmax := j;
          end;
        if (nmin = nmax) and (nmin = t) then begin
          for j := 0 to Transforms-1 do
            modWeights[j] := cp.xform[t].modWeights[j];
          if (transOpacity = 0) then begin
            transOpacity := cp.xform[t].transOpacity;
          end;
        end;
      end;
      // check for single "from" links
      for i := 0 to Transforms-1 do
      begin
        if cp.xform[t].modWeights[i] = 0 then continue;
        nmin := NXFORMS;
        nmax := -1;
        for j := 0 to Transforms-1 do
          if cp.xform[j].modWeights[i] <> 0 then begin
            if j < nmin then nmin := j;
            if j > nmax then nmax := j;
          end;
        if (nmin = nmax) and (nmin = t) then begin
          for j := 0 to Transforms-1 do
            cp.xform[j].modWeights[i] := cp.xform[t].modWeights[i];
        end;
      end;
    end;
      
    // delete xform from all probability tables
    for i := 0 to Transforms-1 do
    with cp.xform[i] do begin
      for j := t to Transforms-1 do
        modWeights[j] := modWeights[j+1];
      modWeights[Transforms-1] := 1;
    end;

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

    if cp.soloXform > t then Dec(cp.soloXform)
    else if cp.soloXform = t then cp.soloXform := -1;

    Dec(Transforms);
    assert(cp.xform[transforms].density = 0); // cp.xform[transforms].density := 0;
  end;
  UpdateXformsList;
  UpdateFlame(True);
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
  if UseTransformColors then
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

  procedure ToUnit(p: TPoint; var fx, fy: double);
  begin
    fx := (p.x - ix) / sc + gCenterX;
    fy := (p.y + iy) / sc + gCenterY;
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
  a, b, c: TPoint;
  e, f: TPoint;

  procedure DrawWidgets;
  var
    i: integer;
  begin
    with Bitmap.Canvas do
      with MainTriangles[SelectedTriangle] do
      begin
        for i := 0 to 3 do
        begin
          a:=toscreen(Widgets[i][0].x, Widgets[i][0].y);
          b:=toscreen(Widgets[i][1].x, Widgets[i][1].y);
          c:=toscreen(Widgets[i][2].x, Widgets[i][2].y);
          moveto(a.x, a.y);
          lineto(b.x, b.y);
          lineto(c.x, c.y);
        end
      end;
  end;

var
  i, n, tc, tn: integer;
  d, d1: double;
  tx, ty: double;

  ax, ay: integer;

  gridX1, gridX2, gridY1, gridY2, gi, gstep: double;
  gp: TRoundToRange;

  tps: TPenStyle;
  tT: TTriangle;
  txx, txy, tyx, tyy: double;
  str, vvstr: string;

  bf: TBlendFunction;
  RenderCP : TControlPoint;
  Renderer : TRenderer;
  bm : TBitmap;
  q, p0, p1: integer;
label DrawCorner;
begin
  if (SelectedTriangle < 0) then begin
    assert(false, 'Selected triangle < 0');
    SelectedTriangle := 0;
  end;
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
      try // who knows... ;)
        gp:=round(log10(max(Width, Height)/sc))-1;
        gstep:=power(10.0, gp);
      except
        gp:=0;
        gstep:=1.0;
      end;

      a := ToScreen(MainTriangles[-1].x[0], MainTriangles[-1].y[0]);
      b := ToScreen(MainTriangles[-1].x[1], MainTriangles[-1].y[1]);
      c := ToScreen(MainTriangles[-1].x[2], MainTriangles[-1].y[2]);

      brush.Color := EditorBkgColor;
      FillRect(Rect(0, 0, Width, Height));

      if EnableEditorPreview then begin
        q := 0;
        if EditPrevQual = 2 then q := 1;
        p0 := TriangleView.Width div (2 - q);
        p1 := TriangleView.Height div (2 - q);

        RenderCp := cp.Clone;
        RenderCp.Width := TriangleView.Width;
        Rendercp.Height := TriangleView.Height;
        RenderCp.pixels_per_unit := sc;
        RenderCp.AdjustScale(p0, p1);
        RenderCP.sample_density := PreviewDensity * 0.5;
        RenderCP.spatial_oversample := 1;
        RenderCP.spatial_filter_radius := 0.001;
        RenderCp.center[0] := gCenterX ;
        RenderCp.center[1] := -gCenterY ;
        RenderCp.background[0] := EditorBkgColor and $ff;
        RenderCp.background[1] := (EditorBkgColor and $ff00) shl 8;
        RenderCp.background[2] := (EditorBkgColor and $ff0000) shl 16;
        Render.SetCP(RenderCp);
        Render.Render;

        bf.BlendOp := AC_SRC_OVER;
        bf.BlendFlags := 0;
        bf.SourceConstantAlpha := 255 - EditorPreviewTransparency;
        bf.AlphaFormat := 0;
        bm := TBitmap.Create;
        bm.Width := p0;
        bm.Height := p1;
        bm.Assign(Render.GetImage);

        //Windows.BitBlt(Handle, 0, 0,
        Windows.AlphaBlend(Handle, 0, 0,
         TriangleView.Width, TriangleView.Height,
          bm.Canvas.Handle, 0, 0,
          //$CC0020);
          bm.Width, bm.Height, bf);

        RenderCp.Destroy;
        try
          bm.Dormant;
          bm.FreeImage;
        finally
          bm.Free;
        end;
      end;

      Pen.Style := psSolid;
      Pen.Width := 1;

      // draw grid
      Pen.Color := GridColor2;
      gridX1:=gCenterX-ix/sc;
      gridX2:=gCenterX+(Width-ix)/sc;
      gridY1:=gCenterY-iy/sc;
      gridY2:=gCenterY+(Height-iy)/sc;

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

        with cp.xform[i] do // draw post-triangle
        if postXswap or
         ((ShowAllXforms or (i = SelectedTriangle)) and (
          (p[0,0]<>1) or (p[0,1]<>0) or
          (p[1,0]<>0) or (p[1,1]<>1) or
          (p[2,0]<>0) or (p[2,1]<>0) )) then
        begin
          Pen.Color := GetTriangleColor(i) shr 1 and $7f7f7f;
          tps := Pen.Style;
          Pen.Style := psDot;

          cp.GetPostTriangle(tT, i);
          txx := tT.x[0] - tT.x[1];
          txy := tT.y[0] - tT.y[1];
          tyx := tT.x[2] - tT.x[1];
          tyy := tT.y[2] - tT.y[1];
          a := ToScreen(tT.x[1] + txx + tyx, tT.y[1] + txy + tyy);
          b := ToScreen(tT.x[1] - txx + tyx, tT.y[1] - txy + tyy);
          e := ToScreen(tT.x[1] + txx - tyx, tT.y[1] + txy - tyy);
          f := ToScreen(tT.x[1] - txx - tyx, tT.y[1] - txy - tyy);
          Polyline([a, b, f, e, a]);

          pen.Style := psSolid;
          a := ToScreen(tT.x[1] - txx, tT.y[1] - txy);
          b := ToScreen(tT.x[1] + txx, tT.y[1] + txy);
          e := ToScreen(tT.x[1] + tyx, tT.y[1] + tyy);
          f := ToScreen(tT.x[1] - tyx, tT.y[1] - tyy);
          Polyline([a, b, e, f]);

          if postXswap and ((i = SelectedTriangle) or ShowAllXforms) then
          begin
            Pen.Style := psDot;
            cp.GetTriangle(tT, i);

            a:=toscreen(tT.x[0], tT.y[0]);
            moveto(a.x, a.y);
            b:=toscreen(tT.x[2], tT.y[2]);
            lineto(b.x, b.y);

            pen.Style := psSolid;
            b:=toscreen(tT.x[1], tT.y[1]);
            lineto(b.x, b.y);
            lineto(a.x, a.y);
          end;

          Pen.Style := tps;
        end;

        Pen.Color := GetTriangleColor(i);
        a := ToScreen(MainTriangles[i].x[0], MainTriangles[i].y[0]);
        b := ToScreen(MainTriangles[i].x[1], MainTriangles[i].y[1]);
        c := ToScreen(MainTriangles[i].x[2], MainTriangles[i].y[2]);
        if pen.Style <> psSolid then
          Polyline([a, b, c, a])
        else begin
          Polyline([a, b, c]);
          Pen.Style := psDot;
          brush.Color := pen.color shr 1 and $7f7f7f;
          Polyline([c, a]);
          brush.Color := EditorBkgColor;
       end;

        Pen.Style := psSolid;
        Ellipse(a.x - 4, a.y - 4, a.x + 4, a.y + 4);
        Ellipse(b.x - 4, b.y - 4, b.x + 4, b.y + 4);
        Ellipse(c.x - 4, c.y - 4, c.x + 4, c.y + 4);

        Font.color := Pen.color;
        TextOut(c.x+2, c.y+1, 'Y');
        TextOut(a.x+2, a.y+1, 'X');
        TextOut(b.x+2, b.y+1, 'O');
      end;

      UpdateWidgets;
      if ExtendedEdit then begin
        n := GetTriangleColor(SelectedTriangle);// shr 1 and $7f7f7f;
        if mouseOverTriangle <> SelectedTriangle then n := n shr 1 and $7f7f7f;
        Pen.Color := n;
        Pen.Mode := pmMerge;
        DrawWidgets;

        if mouseOverWidget >= 0 then
        begin
          pen.Color := pen.Color shr 1 and $7f7f7f;
          pen.Width := 4;
          DrawWidgets;
          pen.Width := 1;
        end;
      end;

      if showVarPreview then
      begin
        assert(trkVarPreviewRange.position > 0);
        assert(trkVarPreviewDensity.position > 0);

        cp.xform[SelectedTriangle].Prepare;

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
                if d > 0 then begin
                  dx := dx/d*d1;
                  dy := dy/d*d1;
                end;
                d := d1;
              end;
            end;
          end;

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
            LineTo(c.X, c.y);
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
        with MainTriangles[mouseOverTriangle] do begin
          a := ToScreen(x[0], y[0]);
          b := ToScreen(x[1], y[1]);
          c := ToScreen(x[2], y[2]);
        end;

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
            if cp.xform[mouseOverTriangle].GetVariation(i) <> 0 then
            begin
              vvstr := Varnames(i) + Format(' = %.6g', [cp.xform[mouseOverTriangle].GetVariation(i)]);
              ax := Width-foc_ofs*2 - TextWidth(vvstr);
              TextOut(ax, ay, vvstr);
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
      else if (mouseOverTriangle>=0) then
      begin
        if (mouseOverCorner >= 0) then // highlight corner under cursor
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

        if (mouseOverEdge >= 0) then // highlight edge under cursor
        begin
          i := (mouseOverEdge + 1) mod 3;
          a := ToScreen(MainTriangles[mouseOverTriangle].x[mouseOverEdge], MainTriangles[mouseOverTriangle].y[mouseOverEdge]);
          b := ToScreen(MainTriangles[mouseOverTriangle].x[i], MainTriangles[mouseOverTriangle].y[i]);

          pen.Width:=5;
          Pen.Color:=GetTriangleColor(mouseOverTriangle) shr 1 and $7f7f7f;
          Pen.Mode:=pmMerge;

          MoveTo(a.X, a.Y);
          LineTo(b.X, b.Y);
          pen.Mode:=pmCopy;
          pen.Width:=1;
        end;
      end;

      // draw pivot point
      a := ToScreen(GetPivot.x, GetPivot.y);
      Pen.Style := psSolid;
      pen.Color := clWhite;
      brush.Color := clSilver;
      if (pivotMode = pivotLocal) or EdgeCaught then i := 2
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
  vn: string;
begin
  mnuELowQuality.Caption := TextByKey('common-lowquality');
	mnuEMediumQuality.Caption := TextByKey('common-mediumquality');
	mnuEHighQuality.Caption := TextByKey('common-highquality');
  mnuLowQuality.Caption := TextByKey('common-lowquality');
	mnuMediumQuality.Caption := TextByKey('common-mediumquality');
	mnuHighQuality.Caption := TextByKey('common-highquality');
	ToolButton9.Caption := TextByKey('common-copy');
	ToolButton9.Hint := TextByKey('common-copy');
	tbCopyTriangle.Hint := TextByKey('common-copy');
	ToolButton10.Caption := TextByKey('common-paste');
	ToolButton9.Hint := TextByKey('common-paste');
	tbPasteTriangle.Hint := TextByKey('common-paste');
	tbUndo.Caption := TextByKey('common-undo');
	tbUndo.Hint := TextByKey('common-undo');
	mnuUndo.Caption := TextByKey('common-undo');
	tbRedo.Caption := TextByKey('common-redo');
	tbRedo.Hint := TextByKey('common-redo');
	mnuRedo.Caption := TextByKey('common-redo');
	bClear.Caption := TextByKey('common-clear');
	pnlSymmetry.Hint := TextByKey('common-dragpanelhint');
	pnlOpacity.Hint := TextByKey('common-dragpanelhint');
	pnlDC.Hint := TextByKey('common-dragpanelhint');
	pnlWeight.Hint := TextByKey('common-dragpanelhint');
	self.Caption := TextByKey('editor-title');
	Panel1.Caption := TextByKey('editor-common-transform');
	Panel2.Caption := TextByKey('editor-common-name');
	pnlWeight.Caption := TextByKey('editor-common-weight');

	tabVariations.Caption := TextByKey('editor-tab-variations-title');
	VEVars.TitleCaptions[0] := TextByKey('editor-tab-variations-name');
	VEVars.TitleCaptions[1] := TextByKey('editor-tab-variations-value');
	chkCollapseVariations.Caption := TextByKey('editor-tab-variations-togglehideunused');
	TabSheet4.Caption := TextByKey('editor-tab-variables-title');
	vleVariables.TitleCaptions[0] := TextByKey('editor-tab-variables-name');
	vleVariables.TitleCaptions[1] := TextByKey('editor-tab-variables-value');
	chkCollapseVariables.Caption := TextByKey('editor-tab-variables-toggleshowall');
	TabChaos.Caption := TextByKey('editor-tab-chaos-title');
	vleChaos.TitleCaptions[0] := TextByKey('editor-tab-chaos-path');
	vleChaos.TitleCaptions[1] := TextByKey('editor-tab-chaos-modifier');
	optTo.Caption := TextByKey('editor-tab-chaos-viewasto');
	mnuChaosViewTo.Caption := TextByKey('editor-tab-chaos-viewasto');
	optFrom.Caption := TextByKey('editor-tab-chaos-viewasfrom');
	mnuChaosViewFrom.Caption := TextByKey('editor-tab-chaos-viewasfrom');
	TriangleTab.Caption := TextByKey('editor-tab-triangle-title');
	GroupBox3.Caption := TextByKey('editor-tab-triangle-pivot');

	btnResetPivot.Hint := TextByKey('editor-tab-triangle-resetpivot');
	btnPickPivot.Hint := TextByKey('editor-tab-triangle-pickpivot');
	btTrgRotateLeft.Hint := TextByKey('editor-tab-triangle-rotateleft');
	btTrgRotateRight.Hint := TextByKey('editor-tab-triangle-rotateright');
	btTrgMoveUp.Hint := TextByKey('editor-tab-triangle-moveup');
	btTrgMoveDown.Hint := TextByKey('editor-tab-triangle-movedown');
	btTrgMoveLeft.Hint := TextByKey('editor-tab-triangle-moveleft');
	btTrgMoveRight.Hint := TextByKey('editor-tab-triangle-moveright');
	btTrgScaleDown.Hint := TextByKey('editor-tab-triangle-scaledown');
	btTrgScaleUp.Hint := TextByKey('editor-tab-triangle-scaleup');
	tbAutoWeights.Hint := TextByKey('editor-tab-triangle-autoweight');
	tabXForm.Caption := TextByKey('editor-tab-transform-title');
	btnResetCoefs.Caption := TextByKey('editor-tab-transform-reset');
	btnResetCoefs.Hint := TextByKey('editor-tab-transform-resethint');
	btnCoefsRect.Caption := TextByKey('editor-tab-transform-rectangular');
	btnCoefsRect.Hint := TextByKey('editor-tab-transform-rectangularhint');
	btnCoefsPolar.Caption := TextByKey('editor-tab-transform-polar');
	btnCoefsPolar.Hint := TextByKey('editor-tab-transform-polarhint');
	btnResetPostCoefs.Caption := TextByKey('editor-tab-transform-resetpost');
	btnResetPostCoefs.Hint := TextByKey('editor-tab-transform-resetposthint');
	chkAutoZScale.Caption := TextByKey('editor-tab-transform-autozscale');
	btnXcoefs.Hint := TextByKey('editor-tab-transform-resetxhint');
	btnXpost.Hint := TextByKey('editor-tab-transform-resetxhint');
	btnYcoefs.Hint := TextByKey('editor-tab-transform-resetyhint');
	btnYpost.Hint := TextByKey('editor-tab-transform-resetyhint');
	btnOcoefs.Hint := TextByKey('editor-tab-transform-resetohint');
	btnOpost.Hint := TextByKey('editor-tab-transform-resetohint');
	tabColors.Caption := TextByKey('editor-tab-color-title');
	GroupBox1.Caption := TextByKey('editor-tab-color-transformcolor');
	pnlSymmetry.Caption := TextByKey('editor-tab-color-colorspeed');
	pnlOpacity.Caption := TextByKey('editor-tab-color-opacity');
	pnlDC.Caption := TextByKey('editor-tab-color-directcolor');
	chkXFormSolo.Caption := TextByKey('editor-tab-color-togglesolo');
	GroupBox2.Caption := TextByKey('editor-tab-color-varpreview');
	Label1.Caption := TextByKey('editor-tab-color-previewrange');
	Label2.Caption := TextByKey('editor-tab-color-previewdepth');
	Label3.Caption := TextByKey('editor-tab-color-previewdensity');
	tbResetAll.Caption := TextByKey('editor-toolbar-newflame');
	tbResetAll.Hint := TextByKey('editor-toolbar-newflame');
	tbAdd.Caption := TextByKey('editor-toolbar-newtransform');
	tbAdd.Hint := TextByKey('editor-toolbar-newtransform');
	mnuAdd.Caption := TextByKey('editor-toolbar-newtransform');
	mnuAdd1.Caption := TextByKey('editor-toolbar-newtransform');
	ToolButton7.Caption := TextByKey('editor-toolbar-addlinkedtransform');
	ToolButton7.Hint := TextByKey('editor-toolbar-addlinkedtransform');
	mnuLinkPostxform.Caption := TextByKey('editor-toolbar-addlinkedtransform');
	tbDuplicate.Caption := TextByKey('editor-toolbar-duplicatetransform');
	tbDuplicate.Hint := TextByKey('editor-toolbar-duplicatetransform');
	mnuDuplicate.Caption := TextByKey('editor-toolbar-duplicatetransform');
	tbDelete.Caption := TextByKey('editor-toolbar-removetransform');
	tbDelete.Hint := TextByKey('editor-toolbar-removetransform');
	mnuDelete.Caption := TextByKey('editor-toolbar-removetransform');
	tbSelect.Caption := TextByKey('editor-toolbar-modeselect');
	tbSelect.Hint := TextByKey('editor-toolbar-modeselect');
	mnuSelectMode.Caption := TextByKey('editor-toolbar-modeselect');
	tbMove.Caption := TextByKey('editor-toolbar-modemove');
	tbMove.Hint := TextByKey('editor-toolbar-modemove');
	tbRotate.Caption := TextByKey('editor-toolbar-moderotate');
	tbRotate.Hint := TextByKey('editor-toolbar-moderotate');
	tbScale.Caption := TextByKey('editor-toolbar-modescale');
	tbScale.Hint := TextByKey('editor-toolbar-modescale');
	tbPivotMode.Caption := TextByKey('editor-toolbar-toggleworldpivot');
	tbPivotMode.Hint := TextByKey('editor-toolbar-toggleworldpivot');
	tbRotate90CCW.Caption := TextByKey('editor-toolbar-rotate90ccw');
	tbRotate90CCW.Hint := TextByKey('editor-toolbar-rotate90ccw');
	btTrgRotateLeft90.Hint := TextByKey('editor-toolbar-rotate90ccw');
	RotateTriangle90CCW1.Caption := TextByKey('editor-toolbar-rotate90ccw');
	tbRotate90CW.Caption := TextByKey('editor-toolbar-rotate90cw');
	tbRotate90CW.Hint := TextByKey('editor-toolbar-rotate90cw');
	btTrgRotateRight90.Hint := TextByKey('editor-toolbar-rotate90cw');
	RotateTriangle90CCW2.Caption := TextByKey('editor-toolbar-rotate90cw');
	tbFlipHorz.Caption := TextByKey('editor-toolbar-fliph');
	tbFlipHorz.Hint := TextByKey('editor-toolbar-fliph');
	mnuFlipHorizontal.Caption := TextByKey('editor-toolbar-fliph');
	tbFlipVert.Caption := TextByKey('editor-toolbar-flipv');
	tbFlipVert.Hint := TextByKey('editor-toolbar-flipv');
	mnuFlipVertical.Caption := TextByKey('editor-toolbar-flipv');
	tbVarPreview.Caption := TextByKey('editor-toolbar-togglevarpreview');
	tbVarPreview.Hint := TextByKey('editor-toolbar-togglevarpreview');
	mnuShowVarPreview.Caption := TextByKey('editor-toolbar-togglevarpreview');
	tbPostXSwap.Caption := TextByKey('editor-toolbar-toggleposttransform');
	tbPostXSwap.Hint := TextByKey('editor-toolbar-toggleposttransform');
	tb2PostXSwap.Hint := TextByKey('editor-toolbar-toggleposttransform');
	oggleposttriangleediting1.Caption := TextByKey('editor-toolbar-toggleposttransform');
	tbEnableFinalxform.Caption := TextByKey('editor-toolbar-togglefinaltransform');
	tbEnableFinalxform.Hint := TextByKey('editor-toolbar-togglefinaltransform');
	mnuAutoZoom.Caption := TextByKey('editor-popup-panel-autozoom');
	tbExtendedEdit.Hint := TextByKey('editor-popup-panel-toggleextendededit');
	mnuExtendedEdit.Caption := TextByKey('editor-popup-panel-toggleextendededit');
	tbAxisLock.Hint := TextByKey('editor-popup-panel-locktransformaxes');
	mnuAxisLock.Caption := TextByKey('editor-popup-panel-locktransformaxes');

	//mnuHorizintalFlipAll.Caption := TextByKey('editor-popup-panel-allfliph');
	//mnuVerticalFlipAll.Caption := TextByKey('editor-popup-panel-allflipv');
	mnuResetLoc.Caption := TextByKey('editor-popup-quality-autoreset');
	mnuResetTrgPosition.Caption := TextByKey('editor-popup-transform-resetposition');
	mnuResetTrgRotation.Caption := TextByKey('editor-popup-transform-resetrotation');
	mnuResetTrgScale.Caption := TextByKey('editor-popup-transform-resetscale');
	mnuCopyTriangle.Caption := TextByKey('editor-popup-transform-copycoords');
	mnuPasteTriangle.Caption := TextByKey('editor-popup-transform-pastecoords');
	mnuReset.Caption := TextByKey('editor-popup-transform-resetentiretriangle');
	mnuChaosRebuild.Caption := TextByKey('editor-popup-chaos-rebuildlinks');
	mnuChaosClearAll.Caption := TextByKey('editor-popup-chaos-clearall');
	mnuChaosSetAll.Caption := TextByKey('editor-popup-chaos-setall');
  btnPivotMode.Hint := TextByKey('editor-toolbar-toggleworldpivot');
  EditPopup.Items[13].Caption := TextByKey('editor-popup-panel-allflipv');
  EditPopup.Items[14].Caption := TextByKey('editor-popup-panel-allfliph');

  // Custom control setup
  TriangleView := TCustomDrawControl.Create(self);
  TriangleView.TabStop  := True;
  TriangleView.TabOrder := 0;
  TriangleView.Parent   := GrphPnl;
  TriangleView.Align    := alClient;
  TriangleView.Visible  := True;

  TriangleView.OnPaint := TriangleViewPaint;

  TriangleView.OnDblClick   := TriangleViewDblClick;
  TriangleView.OnMouseDown  := TriangleViewMouseDown;
  TriangleView.OnMouseMove  := TriangleViewMouseMove;
  TriangleView.OnMouseUp    := TriangleViewMouseUp;
  TriangleView.OnMouseWheel := TriangleViewMouseWheel;
  TriangleView.OnKeyDown    := TriangleViewKeyDown;
  TriangleView.OnKeyUp      := TriangleViewKeyUp;

  TriangleView.OnEnter      := TriangleViewInvalidate;
  TriangleView.OnExit       := TriangleViewExit;
  TriangleView.OnMouseLeave := TriangleViewmouseLeave;

  for i:= 0 to NRVAR - 1 do begin
    vn := Varnames(i);
    VEVars.InsertRow(vn, '0', True);
  end;
  for i:= 0 to GetNrVariableNames - 1 do begin
    vn := GetVariableNameAt(i);
    vleVariables.InsertRow(vn, '0', True);
  end;

  vleChaos.InsertRow(Format(TextByKey('editor-common-toprefix'), [1]), '1', true);
  mnuChaosRebuild.Checked := RebuildXaosLinks;

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
  AxisLock := TransformAxisLock;
  tbAxisLock.Down := AxisLock;
  ExtendedEdit := ExtEditEnabled;
//  tbExtendedEdit.Down := ExtendedEdit;
  widgetMode := modeRotate;
//  tbExtendedEdit.ImageIndex := imgExtMove;

  EdgeCaught := false;
  CornerCaught := false;
  TriangleCaught := false;
  mouseOverTriangle := -1;
  mouseOverCorner := -1;
  mouseOverEdge := -1;
  mouseOverWidget := -1;
  oldSelected := -1;

  MemTriangle.x[0] := 1;
  MemTriangle.y[0] := 0;
  MemTriangle.x[1] := 0;
  MemTriangle.y[1] := 0;
  MemTriangle.x[2] := 0;
  MemTriangle.y[2] := 1;

  for i := 0 to NRVAR-1 do
    VarsCache[i] := MinDouble;

end;

procedure TEditForm.FormDestroy(Sender: TObject);
begin
  cp.free;
  Render.free;
end;

procedure TEditForm.TriangleViewMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  vx, vy, fx, fy: double;
  mt, mc, me: integer;
  a, t: double;

  i, j: integer;
  d: double;

  i0, i1: integer;

  dx, dy, x1, y1: double;
label FoundCorner, Skip1, Skip2;
begin
  Scale(fx, fy, x, y);
  StatusBar.Panels[0].Text := Format(TextByKey('editor-status-xformat'), [fx]);
  StatusBar.Panels[1].Text := Format(TextByKey('editor-status-yformat'), [fy]);

  if viewDragMode then // graph panning
  begin
    if (fx = oldx) and (fy = oldy) then exit;
    viewDragged := true;
    GcenterX := GcenterX - (fx - oldx);
    GcenterY := GcenterY - (fy - oldy);
    TriangleView.Refresh;
    exit;
  end;

  mt:=mouseOverTriangle;
  mc:=MouseOverCorner;
  me:=mouseOverEdge;

  if not (CornerCaught or TriangleCaught) then // look for a point under cursor
  begin
    mouseOverWidget := -1;
    mouseOverEdge := -1;
    mouseOverCorner:= -1;
    mouseOverPos.x := fx;
    mouseOverPos.y := fy;

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
    begin
      for j := 0 to 2 do // -- detect point hit first
      begin
        d := dist(fx, fy, MainTriangles[i].x[j], MainTriangles[i].y[j]);
        if (d * GraphZoom * 50) < 4 then
        begin
          mouseOverTriangle := i;
          mouseOverCorner := j;
//          mouseOverEdge := -1;

// -- from MouseDown -- for highlighting:
// TODO: optimize...
          if (j = 1) then 
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
    end;

    if ExtendedEdit then //and (oldMode = modeNone) then
    begin
      for i := 0 to 3 do // -- detect 'widget' hit
        for j := 0 to 1 do begin
          if abs(line_dist(fx, fy, Widgets[i][j].x, Widgets[i][j].y,
                                   Widgets[i][j+1].x, Widgets[i][j+1].y)
                 ) * GraphZoom * 50 < 3 then
          begin
            mouseOverTriangle := SelectedTriangle;
            mouseOverWidget := i;
//            mouseOverEdge := -1;
//            mouseOverCorner:= -1;
            mouseOverPos.x := fx;
            mouseOverPos.y := fy;

            goto FoundCorner;
          end;
        end;

      for i := i1 downto i0 do
      begin
        for j := 0 to 2 do // -- detect edge hit
        begin
          if abs(line_dist(fx, fy, MainTriangles[i].x[j], MainTriangles[i].y[j],
                                   MainTriangles[i].x[(j+1) mod 3], MainTriangles[i].y[(j+1) mod 3])
                 ) * GraphZoom * 50 < 3 then
          begin
            mouseOverTriangle:=i;
            mouseOverEdge := j;
//            mouseOverCorner:= -1;
            mouseOverPos.x := fx;
            mouseOverPos.y := fy;

            goto FoundCorner;
          end;
        end;
      end;
    end;

    i := InsideTriangle(fx, fy);
    if i >= 0 then mouseOverTriangle:=i
    else mouseOverTriangle:=-1;

FoundCorner:
  end;

  if (mouseOverTriangle >= 0) or (SelectMode = false) or (oldMode <> modeNone) then
  begin
    if (mouseOverWidget >= 0) and (oldMode = modeNone) then
      TriangleView.Cursor := crEditRotate
    else
    if (mouseOverEdge >= 0) and (oldMode = modeNone) then begin // kinda hack, not good...
      if mouseOverEdge = 2 then
        TriangleView.Cursor := crEditScale
      else
        TriangleView.Cursor := crEditRotate;
    end
    else
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
      StatusBar.Panels[2].Text := Format(TextByKey('editor-status-rotateformat'), [a*180/PI, vy*180/PI]);
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

        StatusBar.Panels[2].Text := Format(TextByKey('editor-status-scaleformat'),
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
      if (SelectedCorner = 1) and AxisLock then with MainTriangles[SelectedTriangle] do
      begin
        x[0] := OldTriangle.x[0] + (vx - OldTriangle.x[1]);
        y[0] := OldTriangle.y[0] + (vy - OldTriangle.y[1]);
        x[2] := OldTriangle.x[2] + (vx - OldTriangle.x[1]);
        y[2] := OldTriangle.y[2] + (vy - OldTriangle.y[1]);
      end;
      MainTriangles[SelectedTriangle].x[SelectedCorner] := vx;
      MainTriangles[SelectedTriangle].y[SelectedCorner] := vy;
      StatusBar.Panels[2].Text := Format(TextByKey('editor-status-moveformat'), [vx-(Pivot.X+oldx), vy-(Pivot.Y+oldy)]);
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
        StatusBar.Panels[2].Text := Format(TextByKey('editor-status-rotateformat2'), [a*180/PI, arctan2(vy, vx)*180/PI])
      else StatusBar.Panels[2].Text := Format(TextByKey('editor-status-rotateformat3'), [a*180/PI]);
    end
    else if (editMode = modeScale) then // scale
    begin
      if olddist<>0 then begin
        vy := (oldx*(fx-Pivot.X) + oldy*(fy-Pivot.Y))/sqr(olddist);

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
        StatusBar.Panels[2].Text := Format(TextByKey('editor-status-scaleformat2'), [vy*100]);
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
      StatusBar.Panels[2].Text := Format(TextByKey('editor-status-moveformat2'), [vx, vy]);
    end;
    HasChanged := True;
    UpdateFlameX;
//    UpdateFlame(False);
    StatusBar.Refresh;
    exit;
  end;
  if ((mt <> mouseOverTriangle) or (mc <> MouseOverCorner) or (me <> MouseOverEdge)) then
  begin
    if (mouseOverTriangle >= 0) then
      StatusBar.Panels[2].Text := Format(TextByKey('editor-status-transformformat'), [mouseOverTriangle+1])
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
label
  FoundTriangle;
begin
  TWinControl(Sender).SetFocus;

  viewDragged := false;

  Scale(fx, fy, x, y);

  if Button = mbLeft then
  begin
    if editMode = modePick then
    begin
      if (mouseOverCorner >= 0) then // snap to point
      begin
        fx := MainTriangles[mouseOverTriangle].x[mouseOverCorner];
        fy := MainTriangles[mouseOverTriangle].y[mouseOverCorner];
      end;
      if PivotMode = pivotLocal then
      with MainTriangles[SelectedTriangle] do begin
//        xx := x[0] - x[1];
//        xy := y[0] - y[1];
//        yx := x[2] - x[1];
//        yy := y[2] - y[1];
        d := (xx*yy - yx*xy);
        if d <> 0 then
        begin
          LocalPivot.x := ( (fx - x[1]) * yy - (fy - y[1]) * yx) / d;
          LocalPivot.y := (-(fx - x[1]) * xy + (fy - y[1]) * xx) / d;
        end
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
    oldSelected := SelectedTriangle;

    for i := i1 downto i0 do
    begin
      for j := 0 to 2 do // detect corner hit
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
          olddist := sqrt(sqr(oldx) + sqr(oldy));

          HasChanged := false;
          ShowSelectedInfo;
          TriangleView.Invalidate;
          exit;
        end;
      end;
    end;

    if ExtendedEdit then //and (oldMode = modeNone) then
    begin
      for i := 0 to 3 do // -- detect 'widget' hit
        for j := 0 to 1 do
        begin
          if abs(line_dist(fx, fy, Widgets[i][j].x, Widgets[i][j].y,
                                   Widgets[i][j+1].x, Widgets[i][j+1].y)
                 ) * GraphZoom * 50 < 3 then
          begin
//            modeHack := true;
            if (oldMode = modeNone) then
            begin
              modeHack := true;
              oldMode := editMode;
              editMode := modeRotate;
            end;
            goto FoundTriangle;
          end;
        end;

      for i := i1 downto i0 do
      begin
        for j := 0 to 2 do // -- detect edge hit
        begin
          if abs(line_dist(fx, fy, MainTriangles[i].x[j], MainTriangles[i].y[j],
                                   MainTriangles[i].x[(j+1) mod 3], MainTriangles[i].y[(j+1) mod 3])
                 ) * GraphZoom * 50 < 3 then
          begin
            SelectedTriangle := i;
            EdgeCaught := true;
//            modeHack := true;
            if (oldMode = modeNone) then
            begin
              modeHack := true;
              oldMode := editMode;
              if j = 2 then
                editMode := modeScale
              else
                if AxisLock then editMode := modeRotate
                else
begin
          // hacky...
          CornerCaught := True;
          editMode := modeRotate;
          if j = 1 then SelectedCorner := 2
          else SelectedCorner := 0;
          Pivot := GetPivot;
          LocalAxisLocked := false;
          OldTriangle := MainTriangles[SelectedTriangle];
          oldx := MainTriangles[SelectedTriangle].x[SelectedCorner] - Pivot.X;
          oldy := MainTriangles[SelectedTriangle].y[SelectedCorner] - Pivot.Y;
          olddist := sqrt(sqr(oldx) + sqr(oldy));

          HasChanged := false;
          ShowSelectedInfo;
          TriangleView.Invalidate;
          exit;
end;
            end;
            goto FoundTriangle;
          end;
        end;
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
FoundTriangle:
    TriangleCaught := True;

    OldTriangle := MainTriangles[SelectedTriangle];
    //MainForm.UpdateUndo;
    HasChanged := false;

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
    if modeHack then begin
      assert(oldMode <> modeNone);
      editMode := oldMode;
      oldMode := modeNone;

      modeHack := false;
    end;

    if HasChanged then
    begin
      MainForm.UpdateUndo;
      UpdateFlame(true);
      HasChanged := False;
    end;
    EdgeCaught := false;
    CornerCaught := false;
    TriangleCaught := false;
    TriangleView.Invalidate;
  end
  else if (Button = mbRight) and viewDragMode then
  begin
    viewDragMode := false;

    Screen.Cursor := crDefault;
    SetCaptureControl(nil);

    if viewDragged = false then // haven't dragged - popup menu then
    begin
      //GetCursorPos(mousepos); // hmmm
      mousePos := (Sender as TControl).ClientToScreen(Point(x, y));
      if mouseOverTriangle < 0 then
        EditPopup.Popup(mousepos.x, mousepos.y)
      else begin
        SelectedTriangle := mouseOverTriangle;
        cbTransforms.ItemIndex := SelectedTriangle;
        TriangleView.Refresh;
        TrianglePopup.Popup(mousepos.x, mousepos.y)
      end;
    end
    else viewDragged := false;
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

      if Registry.ValueExists('ResetLocation') then
        mnuResetLoc.checked := Registry.ReadBool('ResetLocation')
      else
        mnuResetLoc.checked := false;
      if Registry.ValueExists('HelpersEnabled') then
        HelpersEnabled := Registry.ReadBool('HelpersEnabled')
      else
        HelpersEnabled := true;

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
      UseFlameBackground := False;
      mnuResetLoc.checked := false;
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
//  chkUseXFormColor.checked := UseTransformColors;
//  chkHelpers.Checked := HelpersEnabled;

  if ExtendedEdit then tbExtendedEdit.Down := true
  else tbMove.Down := true;

  UpdateDisplay;
  TrianglePanelResize(nil);
  ScrollBox1Resize(nil);
end;

procedure TEditForm.mnuDeleteClick(Sender: TObject);
begin
  if (SelectedTriangle >= 0) then DeleteTriangle(SelectedTriangle);
end;

procedure TEditForm.mnuAddClick(Sender: TObject);
begin
  if Transforms < NXFORMS then
  begin
    MainForm.UpdateUndo;
    MainTriangles[Transforms+1] := MainTriangles[Transforms];
    cp.xform[Transforms+1].Assign(cp.xform[Transforms]);
    MainTriangles[Transforms] := MainTriangles[-1];
    SelectedTriangle := Transforms;
    cp.xform[Transforms].Clear;
    cp.xform[Transforms].density := 0.5;
    cp.xform[Transforms].SetVariation(0, 1);
//    for i := 1 to NRVAR - 1 do cp.xform[Transforms].vars[i] := 0;
    Inc(Transforms);
    UpdateXformsList;
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
      for i := 0 to Transforms-1 do
        cp.xform[i].modWeights[Transforms] := cp.xform[i].modWeights[SelectedTriangle];
      cp.xform[Transforms].modWeights[Transforms] := cp.xform[SelectedTriangle].modWeights[SelectedTriangle];
      SelectedTriangle := Transforms;
    end
    else cp.xform[Transforms].density := 0.5;
    Inc(Transforms);
    UpdateXformsList;
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
      TEdit(Sender).Text := Format('%.6g', [cp.xform[SelectedTriangle].density]);
    end;
    MainForm.UpdateUndo;
    UpdateFlame(True);
  end;

  self.LastFocus := TEdit(sender);
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
  if NewVal > MAX_WEIGHT then NewVal := MAX_WEIGHT;
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
  if SelectedTriangle >= Transforms then exit;
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
  if NewVal > MAX_WEIGHT then NewVal := MAX_WEIGHT;
    { If it's not the same as the old value and it was valid }
  TEdit(Sender).Text := Format('%.6g', [NewVal]);
  if (OldVal <> NewVal) and Allow then
  begin
    MainForm.UpdateUndo;
    cp.xform[SelectedTriangle].density := NewVal;
    //ReadjustWeights(cp);
    UpdateFlame(True);
  end;
  self.LastFocus := TEdit(sender);
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

procedure TEditForm.mnuLowQualityClick(Sender: TObject);
begin
  mnuLowQuality.Checked := True;
  mnuELowQuality.Checked := True;
  //tbLowQ.Down := true;
  PreviewDensity := prevLowQuality;
  EditPrevQual := 0;
  DrawPreview;
  TriangleViewPaint(TriangleView);
end;

procedure TEditForm.mnuHighQualityClick(Sender: TObject);
begin
  mnuHighQuality.Checked := True;
  mnuEHighQuality.Checked := True;
  //tbHiQ.Down := true;
  PreviewDensity := prevHighQuality;
  EditPrevQual := 2;
  DrawPreview;
  TriangleViewPaint(TriangleView);
end;

procedure TEditForm.mnuMediumQualityClick(Sender: TObject);
begin
  mnuMediumQuality.Checked := True;
  mnuEMediumQuality.Checked := True;
  //tbMedQ.Down := true;
  PreviewDensity := prevMediumQuality;
  EditPrevQual := 1;
  DrawPreview;
  TriangleViewPaint(TriangleView);
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

procedure TEditForm.mnuFlipAllVClick(Sender: TObject);
var
  i: integer;
begin
  MainForm.UpdateUndo;
  for i := -1 to Transforms do
  begin
    MainTriangles[i] := FlipTriangleVertical(MainTriangles[i]);
  end;
  cp.GetFromTriangles(MainTriangles, Transforms);
  cp.TrianglesFromCP(MainTriangles);
  AutoZoom;
  UpdateFlame(True);
end;

procedure TEditForm.mnuFlipAllHClick(Sender: TObject);
var
  i: integer;
begin
  MainForm.UpdateUndo;
  for i := -1 to Transforms do
  begin
    MainTriangles[i] := FlipTriangleHorizontal(MainTriangles[i]);
  end;
  cp.GetFromTriangles(MainTriangles, Transforms);
  cp.TrianglesFromCP(MainTriangles);
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

procedure TEditForm.cbTransformsChange(Sender: TObject);
var
  n: integer;
begin
  n := cbTransforms.ItemIndex;
  // We got a bug in the ComboBox-control :( <hack>
  {if (EnableFinalXForm or cp.HasFinalXForm) and (SelectedTriangle = LastTriangle) then
  begin
    n := cbTransforms.Items.Count - 1;
  end;}
  // </hack>

  if (n <> SelectedTriangle) and (n >= 0) and (n <= LastTriangle) then
  begin
    SelectedTriangle := n;
    ShowSelectedInfo;
    TriangleView.Invalidate;
  end;
  chkCollapseVariablesClick(nil);
  chkCollapseVariationsClick(nil);
end;

procedure TEditForm.cbTransformsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  h: integer;
  ax,ay,bx,by: integer;
  TrgColor: TColor;
begin
  assert(Index >= 0);
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

  self.LastFocus := TEdit(sender);
end;

procedure TEditForm.scrlXFormColorScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if (ScrollCode = scEndScroll) and HasChanged then begin
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
  if v <> cp.xform[SelectedTriangle].color then
  begin
    cp.xform[SelectedTriangle].color := v;
    pnlXFormColor.color := ColorValToColor(MainCp.cmap, v);
    shColor.Brush.Color := pnlXFormColor.Color;
    txtXFormColor.Text := Format('%1.3f', [v]);
    txtXFormColor.Refresh;

    HasChanged := true;
    DrawPreview;
  end;
end;

(*
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
*)

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
    updating := true;
    scrlXFormColor.Position := round(v * scrlXFormColor.Max);
    MainForm.UpdateUndo;
    cp.xform[SelectedTriangle].color := v;
    updating := false;
    UpdateFlame(true);
  end;
end;

procedure TEditForm.txtXFormColorKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    txtXFormColorExit(Sender);
  end;
end;

procedure TEditForm.txtOpacitySet(Sender: TObject);
var
  Allow: boolean;
  NewVal, OldVal: double;
begin
  Allow := True;
  OldVal := Round6(cp.xform[SelectedTriangle].transOpacity);
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
  if NewVal < 0 then NewVal := 0;
  if NewVal > 1 then NewVal := 1;
    { If it's not the same as the old value and it was valid }
  TEdit(Sender).Text := Format('%.6g', [NewVal]);
  if (OldVal <> NewVal) and Allow then
  begin
    MainForm.UpdateUndo;
    cp.xform[SelectedTriangle].transOpacity := NewVal;
    UpdateFlame(True);
  end;
end;

procedure TEditForm.txtDCSet(Sender: TObject);
var
  Allow: boolean;
  NewVal, OldVal: double;
begin
  Allow := True;
  OldVal := Round6(cp.xform[SelectedTriangle].pluginColor);
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
  if NewVal < 0 then NewVal := 0;
  if NewVal > 1 then NewVal := 1;
    { If it's not the same as the old value and it was valid }
  TEdit(Sender).Text := Format('%.6g', [NewVal]);
  if (OldVal <> NewVal) and Allow then
  begin
    MainForm.UpdateUndo;
    cp.xform[SelectedTriangle].pluginColor := NewVal;
    UpdateFlame(True);
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

procedure TEditForm.txtOpacityKeyPress(Sender: TObject; var Key: Char);
var
  Allow: boolean;
  NewVal, OldVal: double;
begin
  if key = #13 then
  begin
    { Stop the beep }
    Key := #0;
    Allow := True;
    OldVal := Round6(cp.xform[SelectedTriangle].transOpacity);
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
    if NewVal < 0 then NewVal := 0;
    if NewVal > 1 then NewVal := 1;
    { If it's not the same as the old value and it was valid }
    TEdit(Sender).Text := Format('%.6g', [NewVal]);
    if (OldVal <> NewVal) and Allow then
    begin
      MainForm.UpdateUndo;
      cp.xform[SelectedTriangle].transOpacity := NewVal;
      UpdateFlame(True);
    end;
  end;
end;

procedure TEditForm.txtDCKeyPress(Sender: TObject; var Key: Char);
var
  Allow: boolean;
  NewVal, OldVal: double;
begin
  if key = #13 then
  begin
    { Stop the beep }
    Key := #0;
    Allow := True;
    OldVal := Round6(cp.xform[SelectedTriangle].pluginColor);
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
    if NewVal < 0 then NewVal := 0;
    if NewVal > 1 then NewVal := 1;
    { If it's not the same as the old value and it was valid }
    TEdit(Sender).Text := Format('%.6g', [NewVal]);
    if (OldVal <> NewVal) and Allow then
    begin
      MainForm.UpdateUndo;
      cp.xform[SelectedTriangle].pluginColor := NewVal;
      UpdateFlame(True);
    end;
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
  OldVal := Round6(cp.xform[SelectedTriangle].GetVariation(i));
  try
    NewVal := Round6(StrToFloat(VEVars.Values[VarNames(i)]));
  except
      VEVars.Values[VarNames(i)] := Format('%.6g', [OldVal]);
      exit;
  end;
  if (NewVal <> OldVal) then
  begin
    MainForm.UpdateUndo;
    cp.xform[SelectedTriangle].SetVariation(i, NewVal);
    VEVars.Values[VarNames(i)] := Format('%.6g', [NewVal]);
    ShowSelectedInfo;
    UpdateFlame(True);
  end;
  chkCollapseVariationsClick(nil);
  chkCollapseVariablesClick(nil);
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

    varDragIndex := cell.Y-1;

    if (cell.y < 1) or (cell.y >= TValueListEditor(Sender).RowCount) or
       (cell.x <> 0) then exit;

    TValueListEditor(Sender).Row := cell.Y;

    Screen.Cursor := crHSplit;

    //GetCursorPos(mousepos); // hmmm
    mousePos := (Sender as TControl).ClientToScreen(Point(x, y));

    varDragMode:=true;
    varDragPos:=0;
    varMM := false;
    SetCaptureControl(TValueListEditor(Sender));
    if Sender = VEVars then
      varDragValue := cp.xform[SelectedTriangle].GetVariation(varDragIndex)
    else if Sender = vleVariables then
      cp.xform[SelectedTriangle].GetVariable(vleVariables.Keys[varDragIndex+1], varDragValue)
    else if Sender = vleChaos then begin
      if mnuChaosViewTo.Checked then
        pDragValue := @cp.xform[SelectedTriangle].modWeights[varDragIndex]
      else
        pDragValue := @cp.xform[varDragIndex].modWeights[SelectedTriangle];
      varDragValue := pDragValue^;
    end
    else Assert(false);

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
      cp.xform[SelectedTriangle].SetVariation(varDragIndex, v);
      VEVars.Values[VarNames(varDragIndex)] := FloatToStr(v); //Format('%.6g', [v]);
    end
    else if Sender = vleVariables then begin
      cp.xform[SelectedTriangle].SetVariable(vleVariables.Keys[varDragIndex+1], v);
      vleVariables.Values[vleVariables.Keys[varDragIndex+1]] := FloatToStr(v);
    end
    else begin
      if v < 0 then v := 0;
      //cp.xform[SelectedTriangle].modWeights[varDragIndex] := v;
      pDragValue^ := v;
      vleChaos.Cells[1, varDragIndex+1] := FloatToStr(v);
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
  n: integer;
  v, v1: double;
  changed: boolean;
begin
  n := TValueListEditor(Sender).Row - 1;
  assert(n >= 0);
  assert(n < TValueListEditor(Sender).rowCount);

  //changed := false;
  if (SelectedTriangle < 0) or (SelectedTriangle > High(cp.xform)) then
    changed := false
  else begin
    if Sender = VEVars then
    begin
      if (n < 0) or (n > (cp.xform[SelectedTriangle].NumVariations - 1)) then
        changed := false
      else begin
        v := cp.xform[SelectedTriangle].GetVariation(n);
        cp.xform[SelectedTriangle].SetVariation(n, IfThen(v = 0, 1, 0));
        //VEVars.Values[VarNames(n)] := '0';
        changed := (cp.xform[SelectedTriangle].GetVariation(n) <> v);
      end;
    end
    else if Sender = vleVariables then begin
      (*if ((n + 1) < 0) or ((n + 1) > high(vleVariables.RowCount)) then
        changed := false
      else begin      *)
        cp.xform[SelectedTriangle].GetVariable(vleVariables.Keys[n + 1], v);
        cp.xform[SelectedTriangle].ResetVariable(vleVariables.Keys[n + 1]);
        //vleVariables.Values[vleVariables.Keys[varDragIndex+1]] := '0';
        cp.xform[SelectedTriangle].GetVariable(vleVariables.Keys[n + 1], v1);
        changed := (v1 <> v);
      //end;
    end
    else if Sender = vleChaos then begin
      if ((varDragIndex) < 0) or ((varDragIndex) > high(cp.xform[SelectedTriangle].modWeights)) then
        changed := false
      else begin
        if mnuChaosViewTo.Checked then
          pDragValue := @cp.xform[SelectedTriangle].modWeights[varDragIndex]
        else
          pDragValue := @cp.xform[varDragIndex].modWeights[SelectedTriangle];
          v := pDragValue^;
          //v := cp.xform[SelectedTriangle].modWeights[n];
          v := ifthen(v = 1, 0, 1);
          //cp.xform[SelectedTriangle].modWeights[n] := v;
          pDragValue^ := v;
          vleChaos.Cells[1, n+1] := FloatToStr(v);
          changed := true;
        end
        //else Assert(false);
    end else changed := false;
  end;

  if changed then MainForm.UpdateUndo;
  UpdateFlame(true);
end;

{ **************************************************************************** }

function TEditForm.GetPivot: TSPoint;
begin
  Result := GetPivot(SelectedTriangle);
end;

function TEditForm.GetPivot(n: integer): TSPoint;
begin
  if (PivotMode = pivotLocal) or {EdgeCaught} (mouseOverEdge >= 0) then // should be always local for edges (hmm...?)
    with MainTriangles[n] do begin
      Result.x := x[1] + (x[0] - x[1])*LocalPivot.x + (x[2] - x[1])*LocalPivot.y;
      Result.y := y[1] + (y[0] - y[1])*LocalPivot.x + (y[2] - y[1])*LocalPivot.y;
    end
  else begin
      Result.x := WorldPivot.x;
      Result.y := WorldPivot.y;
  end;
end;

procedure TEditForm.ScriptGetPivot(var px, py: double);
begin
  if (PivotMode = pivotLocal) then
    with MainTriangles[SelectedTriangle] do begin
      px := x[1] + (x[0] - x[1])*LocalPivot.x + (x[2] - x[1])*LocalPivot.y;
      py := y[1] + (y[0] - y[1])*LocalPivot.x + (y[2] - y[1])*LocalPivot.y;
    end
  else begin
    px := WorldPivot.x;
    py := WorldPivot.y;
  end;
end;

procedure TEditForm.InvokeResetAll;
begin
  mnuResetAllClick(nil);
end;

procedure TEditForm.UpdateColorBar;
var
  BitMap:TBitmap;
  Row:pRGBTripleArray;
  i:integer;
begin
  BitMap := TBitMap.Create;
  try
    Bitmap.PixelFormat := pf24bit;
    BitMap.Width := 256;
    BitMap.Height := 1;
    Row := Bitmap.Scanline[0];
    for i := 0 to 255 do
      with Row[i] do
      begin
        rgbtRed   := MainCP.cmap[i][0];
        rgbtGreen := MainCP.cmap[i][1];
        rgbtBlue  := MainCP.cmap[i][2];
      end;

    EditForm.ColorBarPicture.Picture.Graphic := Bitmap;
    EditForm.ColorBarPicture.Refresh;
  finally
    BitMap.Free;
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

procedure TEditForm.PaintBackground;
begin
  assert(false);
  TriangleViewPaint(TriangleView);
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

{
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
}

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
  if scale = 0 then scale := 1e-6; //assert(scale <> 0);

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
  if scale = 0 then scale := 1e-6; //assert(scale <> 0);

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
    Ord('T'): tbPostXswapClick(Sender);

    Ord('I'): // Invisible
      begin
        //chkXformInvisible.Checked := not chkXformInvisible.Checked;
      end;
    Ord('S'): // Solo
      begin
        chkXformSolo.Checked := not chkXformSolo.Checked;
      end;

    189: // "-"
      begin
        GraphZoom := GraphZoom * 0.8;
        EditForm.StatusBar.Panels[2].Text := Format(TextByKey('editor-status-zoomformat'), [GraphZoom]);
        TriangleView.Invalidate;
      end;
    187: // "+"
      begin
        GraphZoom := GraphZoom * 1.25;
        EditForm.StatusBar.Panels[2].Text := Format(TextByKey('editor-status-zoomformat'), [GraphZoom]);
        TriangleView.Invalidate;
      end;
    VK_ESCAPE:
      begin
        if TriangleCaught or CornerCaught or EdgeCaught then begin
          if modeHack then begin
            assert(oldMode <> modeNone);
            editMode := oldMode;
            oldMode := modeNone;

            modeHack := false;
          end;

          if HasChanged then
          begin
            MainTriangles[SelectedTriangle] := OldTriangle;
            HasChanged := False;
          end;
          EdgeCaught := false;
          CornerCaught := false;
          TriangleCaught := false;
          TriangleView.Invalidate;
          UpdateFlameX;
        end;
      end
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
        txtNameExit(Sender); // store name before re-filling name box by changing xform
        Inc(SelectedTriangle);
        TriangleView.Invalidate;
        ShowSelectedInfo;
        chkCollapseVariablesClick(nil);
        chkCollapseVariationsClick(nil);
      end;
    VK_SUBTRACT:
      if SelectedTriangle > 0 then begin
        txtNameExit(Sender); // store name before re-filling name box by changing xform
        Dec(SelectedTriangle);
        TriangleView.Invalidate;
        ShowSelectedInfo;
        chkCollapseVariablesClick(nil);
        chkCollapseVariationsClick(nil);
      end;
    VK_SPACE:
      if not txtName.Focused then
        btnPivotModeClick(Sender);

  else
    key_handled := false;
    exit;
  end;
  key_handled := true;
  key := 0;
end;

procedure TEditForm.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if txtName.Focused then begin
    if (key = '+') or (key='-') then begin
      // nvm...code moved to EditKeyDown
      key := #0;
    end;
    if (key='"') then key := #0; // we dont want that in "name" box -> XML mess!
    exit;
  end else if txtSearchBox.Focused then begin
    exit;
  end;
// kill alphanumeric keys generally
  if key_handled or (CharInSet(key,['A'..'z'])) then key := #0; // hmmm...
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
    StatusBar.Panels[2].Text := TextByKey('editor-status-selecton');
  end
  else begin
    mouseOverTriangle := SelectedTriangle;
    StatusBar.Panels[2].Text := TextByKey('editor-status-selectoff');;
  end;

  // hack: to generate MouseMove event
  GetCursorPos(MousePos);
  SetCursorPos(MousePos.x, MousePos.y);
end;

procedure TEditForm.TriangleViewMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  fx, fy, sc: double;
  p: TPoint;
begin
  p := TriangleView.ScreenToClient(MousePos);
  Scale(fx, fy, p.X, p.Y);

  if WheelDelta > 0 then GraphZoom := GraphZoom * 1.25
  else GraphZoom := GraphZoom * 0.8;

  EditForm.StatusBar.Panels[2].Text := Format(TextByKey('editor-status-zoomformat'), [GraphZoom]);

  if viewDragMode then begin
    sc := GraphZoom * 50;
    gCenterX := fx - (p.X - TriangleView.Width/2) / sc;
    gCenterY := fy + (p.Y - TriangleView.Height/2) / sc;
  end;

  TriangleView.Invalidate;
  Handled := true;
end;

procedure TEditForm.TriangleViewDblClick(Sender: TObject);
begin
  if mouseOverTriangle >= 0 then
  begin
    if mouseOverCorner >= 0 then begin
      case mouseOverCorner of
        0: if editMode = modeRotate then ResetAxisRotation(0) else ResetAxisScale(0);
        1: if editMode = modeRotate then ResetAxisRotation(1)
           else begin
             if editMode = modeScale then
                ResetAxisScale(1)
              else begin
                if cp.xform[SelectedTriangle].postXswap then
                  btnOpostClick(Sender)
                else
                  btnOcoefsClick(Sender);
              end;
           end;
        2: if editMode = modeRotate then ResetAxisRotation(2) else ResetAxisScale(2);
      end;
    end
    else if mouseOverEdge >= 0 then begin
      if AxisLock then begin
        if (editMode = modeScale) or (mouseOverEdge = 2)then
          mnuResetTrgScaleClick(Sender)
        else
          mnuResetTrgRotationClick(Sender);
      end
      else case mouseOverEdge of
        0: if editMode = modeScale then ResetAxisScale(0) else ResetAxisRotation(0);
        1: if editMode = modeScale then ResetAxisScale(2) else ResetAxisRotation(2);
        2: mnuResetTrgScaleClick(Sender);
      end;
    end
    else if mouseOverWidget >= 0 then begin
      case editMode of
        modeScale: mnuResetTrgScaleClick(Sender);
        else mnuResetTrgRotationClick(Sender);
      end;
    end
    else case editMode of
      //modeMove: Do Nothing
      modeScale: mnuResetTrgScaleClick(Sender);
      modeRotate: mnuResetTrgRotationClick(Sender);
    end;
  end
  else AutoZoom;
end;

procedure TEditForm.TriangleViewInvalidate(Sender: TObject);
begin
  TriangleView.Invalidate;
end;

procedure TEditForm.tbEditModeClick(Sender: TObject);
begin
//  ExtendedEdit := (Sender = tbExtendedEdit);
  if Sender = tbRotate then
  begin
    editMode := modeRotate;
    //tbRotate.Down := true;
  end
  else if Sender = tbScale then
  begin
    editMode := modeScale;
    //tbScale.Down := true;
  end
  else begin
    editMode := modeMove;
    //tbMove.Down := true;
  end;
  TToolButton(Sender).Down := true;
  TriangleView.Invalidate;
end;

procedure TEditForm.tbExtendedEditClick(Sender: TObject);
begin
  ExtendedEdit := not ExtendedEdit;
  tbExtendedEdit.Down := ExtendedEdit;
  TriangleView.Invalidate;
end;

procedure TEditForm.tbAxisLockClick(Sender: TObject);
begin
  {if Sender = chkAxisLock then AxisLock := chkAxisLock.Checked
  else} AxisLock := not AxisLock;
  tbAxisLock.Down := AxisLock;
  //chkAxisLock.Checked := AxisLock;
end;

procedure TEditForm.tbFullViewClick(Sender: TObject);
begin
  MainForm.mnuFullScreenClick(Sender);
end;

//-- Variable List -------------------------------------------------------------

procedure TEditForm.ValidateVariable;
var
  i: integer;
  NewVal, OldVal: double;
  str, oldstr: string;
begin
  i := vleVariables.Row;

{$ifndef VAR_STR}
  cp.xform[SelectedTriangle].GetVariable(vleVariables.Keys[i], OldVal);
  { Test that it's a valid floating point number }
  try
    NewVal := Round6(StrToFloat(vleVariables.Values[vleVariables.Keys[i]]));
  except
    { It's not, so we restore the old value }
    vleVariables.Values[vleVariables.Keys[i]] := Format('%.6g', [OldVal]);
//      cp.xform[SelectedTriangle].GetVariableStr(vleVariables.Keys[i]);
    exit;
  end;
  { If it's not the same as the old value and it was valid }
  if (NewVal <> OldVal) then
  begin
    vleVariables.Cells[1,i];
    MainForm.UpdateUndo;

    cp.xform[SelectedTriangle].SetVariable(vleVariables.Keys[i], NewVal);
    vleVariables.Values[vleVariables.Keys[i]] := Format('%.6g', [NewVal]);

    ShowSelectedInfo;
    UpdateFlame(True);
  end;
{$else}
  oldstr := cp.xform[SelectedTriangle].GetVariableStr(vleVariables.Keys[i]);
  str := vleVariables.Values[vleVariables.Keys[i]];
  cp.xform[SelectedTriangle].SetVariableStr(vleVariables.Keys[i], str);

  if str <> oldstr then
  begin
    MainForm.UpdateUndo;

    vleVariables.Values[vleVariables.Keys[i]] := str;

    ShowSelectedInfo;
    UpdateFlame(True);
  end;
{$endif}

  chkCollapseVariationsClick(nil);
  chkCollapseVariablesClick(nil);
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

(*
procedure TEditForm.vleVariablesGetPickList(Sender: TObject;
  const KeyName: String; Values: TStrings);
begin
  if KeyName ='blur2_type' then
  begin
    Values.Add('gaussian');
    Values.Add('zoom');
    Values.Add('radial');
    Values.Add('defocus');
  end;
end;

procedure TEditForm.vleVariablesStringsChange(Sender: TObject);
begin
  if (vleVariables.ItemProps[vleVariables.Row - 1].ReadOnly) then ValidateVariable;
end;
*)

// -----------------------------------------------------------------------------

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

procedure TEditForm.mnuResetTriangleClick(Sender: TObject);
begin
  if (MainTriangles[SelectedTriangle].x[0] = MainTriangles[-1].x[0]) and
     (MainTriangles[SelectedTriangle].x[1] = MainTriangles[-1].x[1]) and
     (MainTriangles[SelectedTriangle].x[2] = MainTriangles[-1].x[2]) and
     (MainTriangles[SelectedTriangle].y[0] = MainTriangles[-1].y[0]) and
     (MainTriangles[SelectedTriangle].y[1] = MainTriangles[-1].y[1]) and
     (MainTriangles[SelectedTriangle].y[2] = MainTriangles[-1].y[2])
    then exit;

  MainForm.UpdateUndo;
  MainTriangles[SelectedTriangle] := MainTriangles[-1];
  UpdateFlame(True);
{
 with cp.xform[SelectedTriangle] do
 begin
  if (c[0,0]<>1) or (c[0,1]<>0) or(c[1,0]<>0) or (c[1,1]<>1) or (c[2,0]<>0) or (c[2,1]<>0) then
  begin
    MainForm.UpdateUndo;
    c[0, 0] := 1;
    c[0, 1] := 0;
    c[1, 0] := 0;
    c[1, 1] := 1;
    c[2, 0] := 0;
    c[2, 1] := 0;
    ShowSelectedInfo;
    cp.TrianglesFromCP(MainTriangles);
    UpdateFlame(True);
  end;
 end;
}
end;

procedure TEditForm.mnuResetAllClick(Sender: TObject);
var
  i: integer;
begin
  MainForm.UpdateUndo;
  for i := 0 to Transforms do cp.xform[i].Clear;
  cp.xform[0].SetVariation(0, 1);
  cp.xform[0].density := 0.5;
  cp.xform[1].symmetry := 1;

  cp.center[0] := 0;
  cp.center[1] := 0;
  cp.zoom := 0;
  cp.pixels_per_unit := PreviewImage.Width/4;
  cp.FAngle := 0;

  Transforms := 1;
  SelectedTriangle := 1;
  MainTriangles[0] := MainTriangles[-1];
  MainTriangles[1] := MainTriangles[-1]; // kinda reset finalxform

  EnableFinalXform := false;
  assert(cp.HasFinalXForm = false);

//  cbTransforms.clear;
//  cbTransforms.Items.Add('1');
//  cbTransforms.Items.Add('2');
  UpdateXformsList;
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
  if (sender = mnuResetTrgPosition) and cp.xform[SelectedTriangle].postXswap then
  begin
    btnOpostClick(Sender);
    exit;
  end;

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
  trkVarPreviewRange.Hint := Format(TextByKey('editor-tab-color-previewrange') + ' %d', [trkVarPreviewRange.position*2]);
  TriangleView.Invalidate;
end;

procedure TEditForm.trkVarPreviewDensityChange(Sender: TObject);
begin
  trkVarPreviewDensity.Hint := Format(TextByKey('editor-tab-color-previewdensity') + ' %d', [trkVarPreviewDensity.position]);
  TriangleView.Invalidate;
end;

procedure TEditForm.trkVarPreviewDepthChange(Sender: TObject);
begin
  trkVarPreviewDepth.Hint := Format(TextByKey('editor-tab-color-previewdepth') + ' %d', [trkVarPreviewDepth.position]);
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
  cp.TrianglesFromCP(MainTriangles);
  UpdateFlame(True);
end;

procedure TEditForm.btnYpostClick(Sender: TObject);
begin
  if (cp.xform[SelectedTriangle].p[1][0] = 0) and
     (cp.xform[SelectedTriangle].p[1][1] = 1) then exit;

  MainForm.UpdateUndo;
  cp.xform[SelectedTriangle].p[1][0] := 0;
  cp.xform[SelectedTriangle].p[1][1] := 1;
  cp.TrianglesFromCP(MainTriangles);
  UpdateFlame(True);
end;

procedure TEditForm.btnOpostClick(Sender: TObject);
begin
  if (cp.xform[SelectedTriangle].p[2][0] = 0) and
     (cp.xform[SelectedTriangle].p[2][1] = 0) then exit;

  MainForm.UpdateUndo;
  cp.xform[SelectedTriangle].p[2][0] := 0;
  cp.xform[SelectedTriangle].p[2][1] := 0;
  cp.TrianglesFromCP(MainTriangles);
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

  cp.TrianglesFromCP(MainTriangles);

  ShowSelectedInfo;
  UpdateFlame(true);

  self.LastFocus := TEdit(sender);
end;

procedure TEditForm.btnResetCoefsClick(Sender: TObject);
begin
 with cp.xform[SelectedTriangle] do
 begin
  if (c[0,0]<>1) or (c[0,1]<>0) or(c[1,0]<>0) or (c[1,1]<>1) or (c[2,0]<>0) or (c[2,1]<>0) then
  begin
    MainForm.UpdateUndo;
    c[0, 0] := 1;
    c[0, 1] := 0;
    c[1, 0] := 0;
    c[1, 1] := 1;
    c[2, 0] := 0;
    c[2, 1] := 0;
    ShowSelectedInfo;
    cp.TrianglesFromCP(MainTriangles);
    UpdateFlame(True);
  end;
 end;
end;

procedure TEditForm.btnResetPostCoefsClick(Sender: TObject);
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
    cp.TrianglesFromCP(MainTriangles);
    UpdateFlame(True);
  end;
 end;
end;

procedure TEditForm.btnPivotModeClick(Sender: TObject);
begin
  if PivotMode <> pivotLocal then
  // with MainTriangles[SelectedTriangle] do
  begin
    PivotMode := pivotLocal;
//    btnPivotMode.Caption := 'Local Pivot';
//    tbPivotMode.Down := false;
  end
  else
  // with MainTriangles[SelectedTriangle] do
  begin
    PivotMode := pivotWorld;
//    btnPivotMode.Caption := 'World Pivot';
//    tbPivotMode.Down := true;
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

  self.LastFocus := TEdit(sender);
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

procedure TEditForm.VEVarsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  supports3D, supportsDC : boolean;
  col : TColor; frect : TRect;
begin
  if (ARow > NRLOCVAR) and not (gdSelected in	State) then
  begin
    if Arow > NumBuiltinVars then
      col := $e0ffff
    else
      col := $ffe0e0;
    VEVars.canvas.brush.Color := col;
    VEVars.canvas.fillRect(Rect);
    VEVars.canvas.TextOut(Rect.Left+2, Rect.Top+2, VEVars.Cells[ACol,ARow]);
  end else col := VEVars.canvas.brush.color;
  if (Acol = 0) and (Arow > 0) then begin
    VEVars.Canvas.Font.Name := 'Arial';
    VEVars.Canvas.Font.Size := 5;

    VarSupports(Arow - 1, supports3D, supportsDC);

    frect.Left := Rect.Right - 12;
    frect.Right := Rect.Right;
    frect.Top := Rect.Top;
    frect.Bottom := Rect.Bottom;

    if (supports3D or supportsDC) then begin
      VEVars.canvas.brush.Color := col;
      VEVars.canvas.fillRect(frect);
    end;
    
    if (supports3D) then begin
      VEVars.Canvas.Font.Color := $a00000;
      VEVars.Canvas.TextOut(frect.Left, frect.Top + 2, '3D');
    end;

    if (supportsDC) then begin
      VEVars.Canvas.Font.Color := $0000a0;
      VEVars.Canvas.TextOut(frect.Left, frect.Top + 9, 'DC');
    end;
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
      cbTransforms.Items.Add(TextByKey('editor-common-finalxformlistitem'));
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
var dont :boolean;
begin
  if Button <> mbLeft then exit;

  // -X- why? its impossible!
  assert(pnlDragMode = false); //?
  if pnlDragMode = true then exit;

  dont := false;
  if (Sender = pnlWeight) then
    if SelectedTriangle < Transforms then
      pnlDragValue := cp.xform[SelectedTriangle].density
    else exit
  else if (Sender = pnlSymmetry) then
    pnlDragValue := cp.xform[SelectedTriangle].symmetry
  else if (Sender = pnlXformColor) then
    pnlDragValue := cp.xform[SelectedTriangle].color
  else if (Sender = pnlOpacity) then begin
    if (txtOpacity.Enabled) then begin
      pnlDragValue := cp.xform[SelectedTriangle].transOpacity;
    end else dont := true;
  end else if (Sender = pnlDC) then begin
    if (txtDC.Enabled) then begin
      pnlDragValue := cp.xform[SelectedTriangle].pluginColor;
    end else dont := true;
  end else assert(false);

  if (not dont) then begin
    pnlDragMode := true;
    pnlDragPos := 0;
    pnlDragOld := x;
    varMM := false;
    //SetCaptureControl(TControl(Sender));

    Screen.Cursor := crHSplit;
    //GetCursorPos(mousepos); // hmmm
    mousePos := (Sender as TControl).ClientToScreen(Point(x, y));
    HasChanged := false;
  end;
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
      if v <= 0.000001 then v := 0.000001
      else if v > MAX_WEIGHT then v := MAX_WEIGHT;
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
    else if (Sender = pnlOpacity) then
    begin
      if (txtOpacity.Enabled) then begin
        if v < 0 then v := 0
        else if v > 1 then v := 1;
        cp.xform[SelectedTriangle].transOpacity := v;
        pEdit := @txtOpacity;
      end else exit;
    end
    else if (Sender = pnlDC) then
    begin
      if (txtDC.Enabled) then begin
        if v < 0 then v := 0
        else if v > 1 then v := 1;
        cp.xform[SelectedTriangle].pluginColor := v;
        pEdit := @txtDC;
      end else exit;
    end
    else if (Sender = pnlXformColor) then
    begin
      if v < 0 then v := 0
      else if v > 1 then v := 1;
      cp.xform[SelectedTriangle].color := v;
      pnlXFormColor.Color := ColorValToColor(cp.cmap, v);
      shColor.Brush.Color := pnlXformColor.Color;
      updating := true;
      scrlXformColor.Position := round(v*1000);
      pEdit := @txtXformColor;
      updating := false;
    end
    else begin
      assert(false);
      exit;
    end;
    pEdit^.Text := FloatToStr(v);
    pEdit.Refresh;
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
    if SelectedTriangle >= Transforms then exit; // hmm
    pValue := @cp.xform[SelectedTriangle].density;
    if pValue^ = 0.5 then exit;
    pValue^ := 0.5;
    pEdit := @txtP;
  end
  else if (Sender = pnlSymmetry) then
  begin
    pValue := @cp.xform[SelectedTriangle].symmetry;
    if SelectedTriangle = Transforms then begin
      if pValue^ = 1 then exit;
      pValue^ := 1;
    end
    else begin
      if pValue^ = 0 then exit;
      pValue^ := 0;
    end;
    pEdit := @txtSymmetry;
  end
  else if (Sender = pnlXformColor) then
  begin
    pValue := @cp.xform[SelectedTriangle].color;
    if pValue^ = 0 then exit;
    pValue^ := 0;
    pEdit := @txtXformColor;
  end
  else if (Sender = pnlOpacity) then
  begin
    if SelectedTriangle >= Transforms then exit; // hmm
    pValue := @cp.xform[SelectedTriangle].transOpacity;
    if pValue^ = 1.0 then begin
      pValue^ := 0.0;
    end else begin
      pValue^ := 1.0;
    end;
    pEdit := @txtOpacity;
  end
  else if (Sender = pnlDC) then
  begin
    if SelectedTriangle >= Transforms then exit; // hmm
    pValue := @cp.xform[SelectedTriangle].pluginColor;
    if pValue^ = 1.0 then begin
      pValue^ := 0.0;
    end else begin
      pValue^ := 1.0;
    end;
    pEdit := @txtDC;
  end
  else begin
    assert(false);
    exit;
  end;

  MainForm.UpdateUndo;
  pEdit^.Text := FloatToStr(pValue^);
  UpdateFlame(true);
end;

procedure TEditForm.mnuResetTrgRotationClick(Sender: TObject);
var
  dx, dy: double;
  ax, ay, da: integer;
  nx0, ny0, nx2, ny2: double;
begin
  with MainTriangles[SelectedTriangle] do
  begin
//    xx := x[0] - x[1];
//    xy := y[0] - y[1];
//    yx := x[2] - x[1];
//    yy := y[2] - y[1];
    ax := round( arctan2(xy, xx) / (pi/2) );
    ay := round( arctan2(yy, yx) / (pi/2) );
    dx := Hypot(xx, xy);
    dy := Hypot(yx, yy);
    if xx*yy - yx*xy >= 0 then da := 1 else da := -1;
    if ax = ay then ay := ay + da
    else if abs(ax-ay) = 2 then ay := ay - da;

    nx0 := x[1] + dx*cos(ax*pi/2);
    ny0 := y[1] + dx*sin(ax*pi/2);
    nx2 := x[1] + dy*cos(ay*pi/2);
    ny2 := y[1] + dy*sin(ay*pi/2);
    if (x[0] = nx0) and (y[0] = ny0) and (x[2] = nx2) and (y[2] = ny2) then exit;
    MainForm.UpdateUndo;
    x[0] := nx0;
    y[0] := ny0;
    x[2] := nx2;
    y[2] := ny2;
    UpdateFlame(True);
  end;
end;

procedure TEditForm.mnuResetTrgScaleClick(Sender: TObject);
var
  dx, dy: double;
  nx0, ny0, nx2, ny2: double;
begin
  with MainTriangles[SelectedTriangle] do
  begin
//    xx := x[0] - x[1];
//    xy := y[0] - y[1];
//    yx := x[2] - x[1];
//    yy := y[2] - y[1];
    dx := Hypot(xx, xy);
    dy := Hypot(yx, yy);
    if dx <> 0 then begin
      nx0 := x[1] + (x[0] - x[1])/dx;
      ny0 := y[1] + (y[0] - y[1])/dx;
    end
    else begin
      nx0 := x[1] + 1;
      ny0 := y[1];
    end;
    if dx <> 0 then begin
      nx2 := x[1] + (x[2] - x[1])/dy;
      ny2 := y[1] + (y[2] - y[1])/dy;
    end
    else begin
      nx2 := x[1];
      ny2 := y[1] + 1;
    end;
    if (x[0] = nx0) and (y[0] = ny0) and (x[2] = nx2) and (y[2] = ny2) then exit;
    MainForm.UpdateUndo;
    x[0] := nx0;
    y[0] := ny0;
    x[2] := nx2;
    y[2] := ny2;
    UpdateFlame(True);
  end;
end;

procedure TEditForm.ResetAxisRotation(n: integer);
var
  dx, dy, d: double;
  a: integer;
  nx, ny: double;
begin
  with MainTriangles[SelectedTriangle] do
  begin
    if n = 1 then
    begin
      d := Hypot(x[1], y[1]);
      if d = 0 then exit;
      a := round( arctan2(y[1], x[1]) / (pi/2) );
      nx := d*cos(a*pi/2);
      ny := d*sin(a*pi/2);
      if (x[1] = nx) and (y[1] = ny) then exit;
      MainForm.UpdateUndo;
      x[1] := nx;
      y[1] := ny;
      x[0] := x[1] + xx;
      y[0] := y[1] + xy;
      x[2] := x[1] + yx;
      y[2] := y[1] + yy;
      UpdateFlame(True);
    end
    else begin
      dx := x[n] - x[1];
      dy := y[n] - y[1];
      a := round( arctan2(dy, dx) / (pi/2) );
      d := Hypot(dx, dy);
      nx := x[1] + d*cos(a*pi/2);
      ny := y[1] + d*sin(a*pi/2);
      if (x[n] = nx) and (y[n] = ny) then exit;
      MainForm.UpdateUndo;
      x[n] := nx;
      y[n] := ny;
      UpdateFlame(True);
    end;
  end;
end;

procedure TEditForm.ResetAxisScale(n: integer);
var
  dx, dy, d: double;
  nx, ny: double;
begin
  with MainTriangles[SelectedTriangle] do
  begin
    if n = 1 then
    begin
      d := Hypot(x[1], y[1]);
      if d = 0 then exit;
      nx := x[1]/d;
      ny := y[1]/d;
      if (x[1] = nx) and (y[1] = ny) then exit;
      MainForm.UpdateUndo;
      x[1] := nx;
      y[1] := ny;
      x[0] := x[1] + xx;
      y[0] := y[1] + xy;
      x[2] := x[1] + yx;
      y[2] := y[1] + yy;
      UpdateFlame(True);
    end
    else begin
      dx := x[n] - x[1];
      dy := y[n] - y[1];
      d := Hypot(dx, dy);
      if d <> 0 then begin
        nx := x[1] + dx / d;
        ny := y[1] + dy / d;
      end
      else begin
        nx := x[1] + ifthen(n=0, 1, 0);
        ny := y[1] + ifthen(n=2, 1, 0);
      end;
      if (x[n] = nx) and (y[n] = ny) then exit;
      MainForm.UpdateUndo;
      x[n] := nx;
      y[n] := ny;
      UpdateFlame(True);
    end;
  end;
end;

procedure TEditForm.tbPostXswapClick(Sender: TObject);
begin
  cp.GetFromTriangles(MainTriangles, cp.NumXForms);
  with cp.xform[SelectedTriangle] do begin
{    if sender = chkPostXswap then begin
      postXswap := chkPostXswap.Checked;
      tbPostXswap.Down := postXswap;
      tb2PostXswap.Down := postXswap;
    end
    else begin
      chkPostXswap.Checked := not postXswap;
      exit;
    end;
}
    if (sender = tbPostXswap) then tb2PostXswap.down := tbPostXswap.Down;
    if (sender = tb2PostXswap) then tbPostXswap.Down := tb2PostXSwap.Down;

    postXswap := TToolButton(sender).Down;
    ShowSelectedInfo;
  end;
  cp.TrianglesFromCP(MainTriangles);
  TriangleView.Refresh;
end;

procedure TEditForm.btnCopyTriangleClick(Sender: TObject);
begin
  MemTriangle := MainTriangles[SelectedTriangle];
end;

procedure TEditForm.btnPasteTriangleClick(Sender: TObject);
begin
  if (MainTriangles[SelectedTriangle].x[0] <> MemTriangle.x[0]) or
     (MainTriangles[SelectedTriangle].x[1] <> MemTriangle.x[1]) or
     (MainTriangles[SelectedTriangle].x[2] <> MemTriangle.x[2]) or
     (MainTriangles[SelectedTriangle].y[0] <> MemTriangle.y[0]) or
     (MainTriangles[SelectedTriangle].y[1] <> MemTriangle.y[1]) or
     (MainTriangles[SelectedTriangle].y[2] <> MemTriangle.y[2]) then
  begin
    MainForm.UpdateUndo;
    MainTriangles[SelectedTriangle] := MemTriangle;
    UpdateFlame(True);
  end;
end;

procedure TEditForm.chkAutoZscaleClick(Sender: TObject);
begin
  MainForm.UpdateUndo;
  cp.xform[SelectedTriangle].autoZscale := chkAutoZscale.Checked;
  UpdateFlame(True);
end;

// --------------------------------------------------------------- Chaos Editor

procedure TEditForm.ValidateChaos;
var
  i: integer;
  NewVal, OldVal: double;
begin
  i := vleChaos.Row - 1;

  if mnuChaosViewTo.Checked then
    OldVal := Round6(cp.xform[SelectedTriangle].modWeights[i])
  else
    OldVal := Round6(cp.xform[i].modWeights[SelectedTriangle]);

  try
    NewVal := Round6(StrToFloat(vleChaos.Cells[1, i+1]));
  except
    vleChaos.Cells[1, i+1] := Format('%.6g', [OldVal]);
    exit;
  end;
  if (NewVal <> OldVal) then
  begin
    MainForm.UpdateUndo;

    if mnuChaosViewTo.Checked then
      cp.xform[SelectedTriangle].modWeights[i] := NewVal
    else
      cp.xform[i].modWeights[SelectedTriangle] := NewVal;

    vleChaos.Cells[1, i+1] := Format('%.6g', [NewVal]);
    ShowSelectedInfo;
    UpdateFlame(True);
  end;
end;

procedure TEditForm.vleChaosExit(Sender: TObject);
begin
  ValidateChaos;
end;

procedure TEditForm.vleChaosKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    ValidateChaos;
  end;
end;

procedure TEditForm.vleChaosValidate(Sender: TObject; ACol, ARow: Integer;
  const KeyName, KeyValue: String);
begin
  ValidateChaos;
end;

procedure TEditForm.VleChaosDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  h,ax,ay,bx,by: integer;
  trgColor: TColor;
begin
  if (ACol > 0) or (ARow = 0) then exit;

  trgColor := GetTriangleColor(ARow - 1);
  with vleChaos.Canvas do begin
    h := Rect.Bottom - Rect.Top - 2;
//    TextOut(Rect.Left+h+2, Rect.Top+1, vleChaos.Cells[ACol, ARow]);

    ax:=Rect.Right-3;
    ay:=Rect.Top+2;
    bx:=Rect.Right-h;
    by:=Rect.Bottom-3;

    pen.Color := clBlack;
    Polyline([Point(ax+1, ay-2), Point(ax+1, by+1), Point(bx-2, by+1), Point(ax+1, ay-2)]);

    pen.Color := trgColor;
    brush.Color := pen.Color shr 1 and $7f7f7f;
    Polygon([Point(ax, ay), Point(ax, by), Point(bx, by)]);
  end;
end;

procedure TEditForm.mnuChaosViewToClick(Sender: TObject);
var
  i: integer;
begin
  mnuChaosViewTo.Checked := true;
  for i := 1 to vleChaos.RowCount-1 do begin
    vleChaos.Cells[0, i] := Format(TextByKey('editor-common-toprefix'), [i]);
    vleChaos.Cells[1, i] := FloatToStr(cp.xform[SelectedTriangle].modWeights[i-1]);
  end;
  //ShowSelectedInfo;
end;

procedure TEditForm.mnuChaosViewFromClick(Sender: TObject);
var
  i: integer;
begin
  mnuChaosViewFrom.Checked := true;
  for i := 1 to vleChaos.RowCount-1 do begin
    vleChaos.Cells[0, i] := Format(TextByKey('editor-common-fromprefix'), [i]);
    vleChaos.Cells[1, i] := FloatToStr(cp.xform[i-1].modWeights[SelectedTriangle]);
  end;
  //ShowSelectedInfo;
end;

procedure TEditForm.chkPlotModeClick(Sender: TObject);
var
  newMode: boolean;
begin
  (*if (SelectedTriangle < Transforms) then
  begin
    newMode := chkXformInvisible.Checked;
    if cp.xform[SelectedTriangle].noPlot <> newMode then begin
      MainForm.UpdateUndo;
      cp.xform[SelectedTriangle].noPlot := newMode;
      UpdateFlame(true);
    end;
  end; *)
end;

procedure TEditForm.mnuChaosClearAllClick(Sender: TObject);
var
  i: integer;
  noEdit: boolean;
begin
  noEdit := true;
  for i := 1 to cp.NumXForms do
    if mnuChaosViewTo.Checked then begin
      if cp.xform[SelectedTriangle].modWeights[i-1] <> 0 then begin
        noEdit := false;
        break;
      end;
    end
    else begin
      if cp.xform[i-1].modWeights[SelectedTriangle] <> 0 then begin
        noEdit := false;
        break;
      end;
    end;
  if noEdit then exit;

  Mainform.UpdateUndo;
  for i := 1 to cp.NumXForms do
    if mnuChaosViewTo.Checked then
      cp.xform[SelectedTriangle].modWeights[i-1] := 0
    else
      cp.xform[i-1].modWeights[SelectedTriangle] := 0;
  UpdateFlame(true);
end;

procedure TEditForm.mnuChaosSetAllClick(Sender: TObject);
var
  i: integer;
  noEdit: boolean;
begin
  noEdit := true;
  for i := 1 to cp.NumXForms do
    if mnuChaosViewTo.Checked then begin
      if cp.xform[SelectedTriangle].modWeights[i-1] <> 1 then begin
        noEdit := false;
        break;
      end;
    end
    else begin
      if cp.xform[i-1].modWeights[SelectedTriangle] <> 1 then begin
        noEdit := false;
        break;
      end;
    end;
  if noEdit then exit;

  Mainform.UpdateUndo;
  for i := 1 to cp.NumXForms do
    if mnuChaosViewTo.Checked then
      cp.xform[SelectedTriangle].modWeights[i-1] := 1
    else
      cp.xform[i-1].modWeights[SelectedTriangle] := 1;
  UpdateFlame(true);
end;

procedure TEditForm.mnuLinkPostxformClick(Sender: TObject);
var
  i: integer;
begin
  if (Transforms < NXFORMS) and (SelectedTriangle <> Transforms) then
  begin
    MainForm.UpdateUndo;
    MainTriangles[Transforms+1] := MainTriangles[Transforms];
    cp.xform[Transforms+1].Assign(cp.xform[Transforms]);

    MainTriangles[Transforms] := MainTriangles[-1];
    cp.xform[Transforms].Clear;
    cp.xform[Transforms].density := 0.5;
    cp.xform[Transforms].SetVariation(0, 1);

    for i := 0 to Transforms-1 do begin
      cp.xform[Transforms].modWeights[i] := cp.xform[SelectedTriangle].modWeights[i];
      cp.xform[SelectedTriangle].modWeights[i] := 0;
    end;

    for i := 0 to Transforms do
      cp.xform[i].modWeights[Transforms] := 0;
    cp.xform[SelectedTriangle].modWeights[Transforms] := 1;

    cp.xform[Transforms].symmetry := 1;
    cp.xform[Transforms].transOpacity := cp.xform[SelectedTriangle].transOpacity;
    cp.xform[SelectedTriangle].transOpacity := 0;

    SelectedTriangle := Transforms;

    Inc(Transforms);
    UpdateXformsList;
    UpdateFlame(True);
  end;
end;

procedure TEditForm.chkXformSoloClick(Sender: TObject);
begin
  if chkXformSolo.Checked <> (cp.soloXform >=0) then begin
    if chkXformSolo.Checked then begin
      if (SelectedTriangle < Transforms) then begin
        cp.soloXform := SelectedTriangle;
        UpdateFlame(true);
      end;
    end
    else begin
      cp.soloXform := -1;
      UpdateFlame(true);
    end;
  end;
end;

procedure TEditForm.mnuChaosRebuildClick(Sender: TObject);
begin
  RebuildXaosLinks := not RebuildXaosLinks;
  mnuChaosRebuild.Checked := RebuildXaosLinks;
end;

procedure TEditForm.chkCollapseVariationsClick(Sender: TObject);
var
  i:integer;
  s:string;
begin
  //txtSearchBox.Text := '';
  s:=Trim(txtSearchBox.Text);
  for i:= 1 to VEVars.RowCount - 1 do begin
    if (Length(s) = 0) then begin
      if ((Assigned(cp)) and (VEVars.Cells[1,i]='0')) then
        if chkCollapseVariations.Checked then VEVars.RowHeights[i] := -1
        else VEVars.RowHeights[i] := VEVars.DefaultRowHeight
      else VEVars.RowHeights[i] := VEVars.DefaultRowHeight;
    end else begin
      if (Length(s) > Length(VEVars.Cells[0, i])) then
        VEVars.RowHeights[i] := -1
      else if Pos(s, VEVars.Cells[0, i]) > 0 then begin
        if ((Assigned(cp)) and (VEVars.Cells[1,i]='0')) then
          if chkCollapseVariations.Checked then VEVars.RowHeights[i] := -1
          else VEVars.RowHeights[i] := VEVars.DefaultRowHeight
        else VEVars.RowHeights[i] := VEVars.DefaultRowHeight;
      end else VEVars.RowHeights[i] := -1;
    end;
  end;  
end;

procedure TEditForm.chkCollapseVariablesClick(Sender: TObject);
var
  i, vari: integer;
begin
  for i := 1 to vleVariables.RowCount - 1 do
  begin
    if chkCollapseVariables.Checked then
      vleVariables.RowHeights[i] := vleVariables.DefaultRowHeight
    else
    begin
      vari := GetVariationIndexFromVariableNameIndex(i-1);
      if ( (vari = -1) or
           ((Assigned(cp)) and (cp.xform[SelectedTriangle].GetVariation(vari) = 0)) ) then
        vleVariables.RowHeights[i] := -1
      else
        vleVariables.RowHeights[i] := vleVariables.DefaultRowHeight;
    end;
  end;
end;
procedure TEditForm.shColorMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DragPanelMouseDown(pnlXFormColor, Button, Shift, X, Y);
end;

procedure TEditForm.shColorMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DragPanelMouseMove(pnlXFormColor, Shift, X, Y);
end;

procedure TEditForm.shColorMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DragPanelMouseUp(pnlXFormColor, Button, Shift, X, Y);
end;

procedure TEditForm.bClearClick(Sender: TObject);
var
  i:integer;
  changed:boolean;
begin
  changed := false;
  for i := 0 to VEVars.RowCount - 1 do begin
    if (cp.xform[SelectedTriangle].GetVariation(i) <> 0) then changed := true;
    cp.xform[SelectedTriangle].SetVariation(i, 0);
  end;

  if changed then MainForm.UpdateUndo;
  UpdateFlame(true);
end;

procedure TEditForm.ColorBarMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  dx:Extended;
begin
  dx := Round(100 * X / ColorBar.Width) / 100;
  txtXFormColor.Text := FloatToStr(dx);
  txtXFormColorExit(nil);
end;

procedure TEditForm.btnLoadVVARClick(Sender: TObject);
var
  fn:string;
  i:integer;
begin
  if OpenSaveFileDialog(EditForm, '.dll', 'Dynamic Link Libraries (*.dll)|*.dll', '.\Plugins', 'LoadPlugin...', fn, true, false, false, true) then begin
    //if (fn <> '') then begin
      {LoadPlugin(fn);

      VEVars.Strings.Clear;
      vleVariables.Strings.Clear;

      for i:= 0 to NRVAR - 1 do begin
        VEVars.InsertRow(Varnames(i), '0', True);
      end;
      for i:= 0 to GetNrVariableNames - 1 do begin
        vleVariables.InsertRow(GetVariableNameAt(i), '0', True);
      end;

      for i := 0 to Transforms - 1 do begin
        cp.xform[i].InvokeAddRegVariations;
      end;
    end;   }
  end;
end;

procedure TEditForm.txtNameKeyPress(Sender: TObject; var Key: Char);
begin
  if SelectedTriangle >= Transforms then key := #0;
  if key = #13 then
  begin
    { Stop the beep }
    Key := #0;
    txtNameExit(sender);
  end;

end;

procedure TEditForm.txtNameExit(Sender: TObject);
var
  n:integer;
  oldval,newval:string;
begin

  oldval := cp.xform[SelectedTriangle].TransformName;
  newval := txtName.Text;

  if (oldval <> newval) then begin
    MainForm.UpdateUndo;
    cp.xform[SelectedTriangle].TransformName := newval;
    n := SelectedTriangle + 1;
    if (cp.xform[SelectedTriangle].TransformName <> '') then
      cbTransforms.Items[SelectedTriangle] := IntToStr(n) + ' - ' + cp.xform[SelectedTriangle].TransformName
    else
      cbTransforms.Items[SelectedTriangle] := IntToStr(n);

    //workaround..
    if (SelectedTriangle >= Transforms) then cbTransforms.Items[SelectedTriangle] := TextByKey('editor-common-finalxformlistitem');
    cbTransforms.ItemIndex := SelectedTriangle;
    UpdateFlame(True);
  end;
end;

procedure TEditForm.TrianglePanelResize(Sender: TObject);
begin
  GroupBox5.Left := TrianglePanel.CLientWidth div 2 - GroupBox5.Width div 2;
  GroupBox6.Left := TrianglePanel.CLientWidth div 2 - GroupBox6.Width div 2;
  GroupBox3.Left := TrianglePanel.CLientWidth div 2 - GroupBox3.Width div 2;
  ToolBar1.Left := TrianglePanel.CLientWidth div 2 - Toolbar1.Width div 2;
end;

procedure TEditForm.ControlPanelResize(Sender: TObject);
begin
  cbTransforms.ItemHeight := Panel1.Height - 6;
  cbTransforms.Height := Panel1.Height;
  PageControl.Top := Panel1.Height + Panel2.Height + pnlWeight.Height + 12;
  PageControl.Height := ControlPanel.Height - PageControl.Top;
end;

procedure TEditForm.ScrollBox2Resize(Sender: TObject);
begin
  // do
end;

procedure TEditForm.ScrollBox1Resize(Sender: TObject);
begin
  GroupBox7.Left := ScrollBox1.ClientWidth div 2 - GroupBox7.Width div 2;
  GroupBox8.Left := ScrollBox1.ClientWidth div 2 - GroupBox8.Width div 2;
  GroupBox9.Left := ScrollBox1.ClientWidth div 2 - GroupBox9.Width div 2;
end;

procedure TEditForm.FormActivate(Sender: TObject);
begin
  if EnableEditorPreview and PrevPnl.Visible then begin
    Splitter2.Height := 1;
    Splitter2.Visible := false;
    PrevPnl.Height := 1;
    PrevPnl.Visible := false;
  end else if (not EnableEditorPreview) and (not PrevPnl.Visible) then begin
    Splitter2.Height := 8;
    Splitter2.Visible := true;
    PrevPnl.Height := 177;
    PrevPnl.Visible := true;
  end;
end;

procedure TEditForm.txtSearchBoxChange(Sender: TObject);
var
  i:integer;
  s:string;
begin
  s:=Trim(txtSearchBox.Text);
  for i:= 1 to VEVars.RowCount - 1 do begin
    if (Length(s) = 0) then begin
      if ((Assigned(cp)) and (VEVars.Cells[1,i]='0')) then
        if chkCollapseVariations.Checked then VEVars.RowHeights[i] := -1
        else VEVars.RowHeights[i] := VEVars.DefaultRowHeight
      else VEVars.RowHeights[i] := VEVars.DefaultRowHeight;
    end else begin
      if (Length(s) > Length(VEVars.Cells[0, i])) then
        VEVars.RowHeights[i] := -1
      else if Pos(s, VEVars.Cells[0, i]) > 0 then begin
        if ((Assigned(cp)) and (VEVars.Cells[1,i]='0')) then
          if chkCollapseVariations.Checked then VEVars.RowHeights[i] := -1
          else VEVars.RowHeights[i] := VEVars.DefaultRowHeight
        else VEVars.RowHeights[i] := VEVars.DefaultRowHeight;
      end else VEVars.RowHeights[i] := -1;
    end;
  end;
end;

procedure TEditForm.txtSearchBoxKeyPress(Sender: TObject; var Key: Char);
begin
    txtSearchBoxChange(Sender);  
end;

procedure TEditForm.btnResetSearchClick(Sender: TObject);
begin
  txtSearchBox.Text := '';
end;

procedure TEditForm.KeyInput(str:string);
var
  Inp: TInput;
  I: Integer;
begin
  for I := 1 to Length(Str) do
  begin
    Inp.Itype := INPUT_KEYBOARD;
    Inp.ki.wVk := Ord(UpCase(Str[i]));
    Inp.ki.dwFlags := 0;
    SendInput(1, Inp, SizeOf(Inp));
    Inp.Itype := INPUT_KEYBOARD;
    Inp.ki.wVk := Ord(UpCase(Str[i]));
    Inp.ki.dwFlags := KEYEVENTF_KEYUP;
    SendInput(1, Inp, SizeOf(Inp));
    Application.ProcessMessages;
    Sleep(1);
  end; 
end;

procedure TEditForm.ToolButton12Click(Sender: TObject);
begin
  KeyInput('3.141592');
end;

end.

