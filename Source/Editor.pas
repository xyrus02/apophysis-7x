{
     Apophysis Copyright (C) 2001-2004 Mark Townsend

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
  ExtCtrls, StdCtrls, ComCtrls, Math, Menus, ToolWin, Registry, MyTypes,
  ControlPoint, Render, cmap, Grids, ValEdit, Buttons, ImgList;

const
//  PixelCountMax = 32768;
  WM_PTHREAD_COMPLETE = WM_APP + 5438;

type
  TEditForm = class(TForm)
    GrphPnl: TPanel;
    GraphImage: TImage;
    StatusBar: TStatusBar;
    ControlPanel: TPanel;
    lblTransform: TLabel;
    PrevPnl: TPanel;
    PreviewImage: TImage;
    EditPopup: TPopupMenu;
    MenuItem1: TMenuItem;
    mnuDelete: TMenuItem;
    mnuDuplicate: TMenuItem;
    MenuItem2: TMenuItem;
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
    lbla: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label29: TLabel;
    txtA: TEdit;
    txtB: TEdit;
    txtC: TEdit;
    txtD: TEdit;
    txtE: TEdit;
    txtF: TEdit;
    txtP: TEdit;
    txtSymmetry: TEdit;
    tabVariations: TTabSheet;
    VEVars: TValueListEditor;
    tabColors: TTabSheet;
    GroupBox1: TGroupBox;
    scrlXFormColor: TScrollBar;
    pnlXFormColor: TPanel;
    txtXFormColor: TEdit;
    GroupBox2: TGroupBox;
    Label20: TLabel;
    Label21: TLabel;
    pnlBackColor: TPanel;
    chkUseXFormColor: TCheckBox;
    chkFlameBack: TCheckBox;
    pnlReference: TPanel;
    TriangleScrollBox: TScrollBox;
    TrianglePanel: TPanel;
    txtCy: TEdit;
    txtCx: TEdit;
    txtBy: TEdit;
    txtBx: TEdit;
    txtAy: TEdit;
    txtAx: TEdit;
    Label9: TLabel;
    Label7: TLabel;
    Label11: TLabel;
    chkPreserve: TCheckBox;
    btTrgRotateRight: TSpeedButton;
    btTrgRotateLeft: TSpeedButton;
    btTrgMoveUp: TSpeedButton;
    btTrgMoveRight: TSpeedButton;
    btTrgMoveLeft: TSpeedButton;
    btTrgMoveDown: TSpeedButton;
    btTrgScaleUp: TSpeedButton;
    btTrgScaleDown: TSpeedButton;
    rgPivot: TRadioGroup;
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
    tbFlipAllHorz: TToolButton;
    tbFlipAllVert: TToolButton;
    tbSelect: TToolButton;
    btTrgMoveLU: TSpeedButton;
    btTrgMoveLD: TSpeedButton;
    btTrgMoveRU: TSpeedButton;
    btTrgMoveRD: TSpeedButton;
    EditorTB: TImageList;
    Label8: TLabel;
    pnlGridColor1: TPanel;
    pnlGridColor2: TPanel;
    PreviewToolBar: TToolBar;
    tbFullView: TToolButton;
    tbLowQ: TToolButton;
    tbMedQ: TToolButton;
    ToolButton7: TToolButton;
    tbResetLoc: TToolButton;
    tbHiQ: TToolButton;
    ToolButton9: TToolButton;
    Panel1: TPanel;
    ColorImage: TImage;
    TabSheet4: TTabSheet;
    vleVariables: TValueListEditor;
    procedure vleVariablesValidate(Sender: TObject; ACol, ARow: Integer; const KeyName, KeyValue: string);
    procedure vleVariablesKeyPress(Sender: TObject; var Key: Char);
    procedure vleVariablesExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GraphImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: integer);
    procedure GraphImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure GraphImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormShow(Sender: TObject);
    procedure mnuDeleteClick(Sender: TObject);
    procedure mnuAddClick(Sender: TObject);
    procedure mnuDupClick(Sender: TObject);
    procedure mnuAutoZoomClick(Sender: TObject);
//    procedure mnuXFlipClick(Sender: TObject);
//    procedure mnuYFlipClick(Sender: TObject);
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
    procedure GraphImageDblClick(Sender: TObject);
    procedure cbTransformsChange(Sender: TObject);
    procedure CoefKeyPress(Sender: TObject; var Key: Char);
    procedure CoefExit(Sender: TObject);
    procedure scrlXFormColorScroll(Sender: TObject;
      ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure scrlXFormColorChange(Sender: TObject);
    procedure chkUseXFormColorClick(Sender: TObject);
    procedure chkFlameBackClick(Sender: TObject);
    procedure pnlBackColorClick(Sender: TObject);
    procedure pnlReferenceClick(Sender: TObject);
    procedure txtXFormColorExit(Sender: TObject);
    procedure txtXFormColorKeyPress(Sender: TObject; var Key: Char);
    procedure txtSymmetryExit(Sender: TObject);
    procedure txtSymmetryKeyPress(Sender: TObject; var Key: Char);
    procedure VEVarsKeyPress(Sender: TObject; var Key: Char);
    procedure VEVarsExit(Sender: TObject);
    procedure VEVarsValidate(Sender: TObject; ACol, ARow: Integer;
      const KeyName, KeyValue: String);
//    procedure mnuRotateRightClick(Sender: TObject);
//    procedure mnuRotateLeftClick(Sender: TObject);
//    procedure mnuScaleUpClick(Sender: TObject);
//    procedure mnuScaleDownClick(Sender: TObject);

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
    procedure editKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure splitterMoved(Sender: TObject);
    procedure tbSelectClick(Sender: TObject);
    procedure btTrgMoveLUClick(Sender: TObject);
    procedure btTrgMoveLDClick(Sender: TObject);
    procedure btTrgMoveRUClick(Sender: TObject);
    procedure btTrgMoveRDClick(Sender: TObject);
    procedure editMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure PreviewImageDblClick(Sender: TObject);
    procedure editKeyPress(Sender: TObject; var Key: Char);
    procedure rgPivotClicked(Sender: TObject);
    procedure tbEditModeClick(Sender: TObject);
    procedure pnlGridColor1Click(Sender: TObject);
    procedure pnlGridColor2Click(Sender: TObject);

    procedure VEVarsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VEVarsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure VEVarsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VEVarsDblClick(Sender: TObject);
    procedure VEVarsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);

    procedure cbTransformsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cbKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure tbFullViewClick(Sender: TObject);
    procedure ColorImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ColorImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ColorImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  private
    bm: TBitmap;
    cmap: TColorMap;
 //   cp1: TControlPoint;
    PreviewDensity: double;

    // --Z--
    graphDragMode, dragged: boolean;
    editMode: (modeMove, modeRotate, modeScale);
    key_handled: boolean; // hack... there must be a better way to do this :-\

    MousePos: TPoint; // in screen coordinates
    mouseOverTriangle: integer;
    mouseOverCorner: integer;

    varDragMode: boolean;
    varDragIndex, varDragPos: integer;
    varMM: boolean; //hack?

    // --Z-- variables moved from outside
    GraphZoom: double;
    CornerCaught: boolean;
    TriangleCaught: boolean;
//    SelectedTriangle: integer; // outside only for scripting (??)
    SelectedCorner: integer;
    SelectMode: boolean;
    // Drawing: boolean;
    HasChanged: boolean;

    oldx, oldy: double;
    // --Z--
    olddist: double;
    Pivot: TSPoint;
    VarsCache: array[0..64] of double; // hack

    colorDrag, colorChanged: boolean;
    colorDragX, colorOldX: integer;
    // --

//    intoldx, intoldy: integer;

    { Options }
    UseFlameBackground, UseTransformColors: boolean;
    BackGroundColor, ReferenceTrianglecolor: integer;
    GridColor1, GridColor2: integer; // --Z--

    procedure UpdateFlameX;
    procedure UpdateFlame(DrawMain: boolean);
    procedure DeleteTriangle(t: integer);

    function GetPivot: TSPoint;
    function GetTriangleColor(n: integer): TColor;
//    procedure MouseInTriangle(fx, fy: double);

    // --Z-- functions moved from outside
    procedure ShowSelectedInfo;
    procedure Scale(var fx, fy: double; x, y, Width, Height: integer);
//unused: function InsideSelected(x, y: double): boolean;
    procedure ReadjustWeights(var cp: TControlPoint);

  public
    cp: TControlPoint;
    Render: TRenderer;

    SelectedTriangle: integer;

    procedure UpdateDisplay(preview_only: boolean = false);
    procedure AutoZoom;
    procedure DrawGraph;
  end;

const
  clr: array[-1..15] of TColor = (clGray,
    clYellow, $ff55ff, clRed,  clLime, clAqua, clGreen, $007fff, clNavy,
    clOlive, clPurple, clTeal, clBlue, clFuchsia, clMoneyGreen, clSkyBlue, clCream);
var
  EditForm: TEditForm;
  pcenterx, pcentery, pscale: double;

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
procedure ScaleAll;

implementation

uses
  Main, Global, Adjust, Mutate, XformMan;

const
  SUB_BATCH_SIZE = 1000;
  SC_MyMenuItem1 = WM_USER + 1;

var
  oldTriangle: TTriangle;
  gCenterX: double;
  gCentery: double;
  gxlength: double;
  gylength: double;

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

procedure ScaleAll;
var
  i, j: integer;
begin
  for i := 0 to 2 do
  begin
    MainTriangles[-1].y[i] := MainTriangles[-1].y[i] * 0.2;
    MainTriangles[-1].x[i] := MainTriangles[-1].x[i] * 0.2;
  end;
  for j := 0 to Transforms - 1 do
    for i := 0 to 2 do
    begin
      MainTriangles[j].y[i] := MainTriangles[j].y[i] * 0.2;
      MainTriangles[j].x[i] := MainTriangles[j].x[i] * 0.2;
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
  i := Trunc(Index * 255);
  result := c[i][2] shl 16 + c[i][1] shl 8 + c[i][0];
end;

procedure TEditForm.UpdateDisplay(preview_only: boolean = false);
var
  i: integer;
  pw, ph: integer;
  r: double;
begin
  cp.copy(MainCp);

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

  AdjustScale(cp, PreviewImage.Width, PreviewImage.Height);

  DrawPreview;
  if preview_only then exit;

  cp.cmap := MainCp.cmap;
  cmap := MainCp.cmap;

  cbTransforms.Clear;
  for i := 0 to Transforms - 1 do
    cbTransforms.Items.Add(IntToStr(i + 1));

  ShowSelectedInfo;
  AutoZoom;
  DrawGraph;
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

procedure TEditForm.ReadjustWeights(var cp: TControlPoint);
{ Thanks to Rudy...code from Chaos}
var
  total, othertotals, excess: double;
  t, i: integer;
begin
  t := NumXForms(cp);
  { /* First determine the excess. */ }
  total := 0.0;
  othertotals := 0.0;
  for i := 0 to T - 1 do
    if cp.xform[i].density <> 0.0 then
    begin
      total := total + cp.xform[i].density;
      if (i <> SelectedTriangle) then
        othertotals := othertotals + cp.xform[i].density;
    end;
  { /* Now we need to fix'em */ }
//z  excess := total - 1.0;
  excess := 1.0 - (total - 1.0)/othertotals; // --Z--
  for i := 0 to T - 1 do
    if (i <> SelectedTriangle) and (cp.xform[i].density <> 0) then
//z      cp.xform[i].density := cp.xform[i].density - cp.xform[i].density / othertotals * excess;
      cp.xform[i].density := cp.xform[i].density * excess; // --Z--
end;

procedure TEditForm.ShowSelectedInfo;
var
  t: integer;
  i: integer;
  a, b, c, d, e, f: double;
  v: double;
  val: double;
begin
  t := SelectedTriangle; // why 't' ?

  assert(t < Transforms); // ?? hmm..

  if (t >= Transforms) then t := Transforms - 1;
  //if EditForm.cbTransforms.ItemIndex <> t then EditForm.cbTransforms.ItemIndex := t;
  EditForm.cbTransforms.ItemIndex := t;
  //select combobox item
  EditForm.txtAx.text := Format('%.6g', [MainTriangles[t].x[0]]);
  EditForm.txtAy.text := Format('%.6g', [MainTriangles[t].y[0]]);
  EditForm.txtBx.text := Format('%.6g', [MainTriangles[t].x[1]]);
  EditForm.txtBy.text := Format('%.6g', [MainTriangles[t].y[1]]);
  EditForm.txtCx.text := Format('%.6g', [MainTriangles[t].x[2]]);
  EditForm.txtCy.text := Format('%.6g', [MainTriangles[t].y[2]]);
  EditForm.lblTransform.Refresh;
  EditForm.txtAx.Refresh;
  EditForm.txtAy.Refresh;
  EditForm.txtBx.Refresh;
  EditForm.txtBy.Refresh;
  EditForm.txtCx.Refresh;
  EditForm.txtCy.Refresh;
  a := EditForm.cp.xform[t].c[0][0];
  b := EditForm.cp.xform[t].c[1][0];
  c := EditForm.cp.xform[t].c[0][1];
  d := EditForm.cp.xform[t].c[1][1];
  e := EditForm.cp.xform[t].c[2][0];
  f := EditForm.cp.xform[t].c[2][1];

  EditForm.txtA.text := Format('%.6g', [a]);
  EditForm.txtB.text := Format('%.6g', [b]);
  EditForm.txtC.text := Format('%.6g', [c]);
  EditForm.txtD.text := Format('%.6g', [d]);
  EditForm.txtE.text := Format('%.6g', [e]);
  EditForm.txtF.text := Format('%.6g', [f]);

  EditForm.txtP.text := Format('%.6g', [EditForm.cp.xform[t].density]);
  EditForm.txtSymmetry.text := Format('%.6g', [EditForm.cp.xform[t].symmetry]);
  EditForm.txtA.Refresh;
  EditForm.txtB.Refresh;
  EditForm.txtC.Refresh;
  EditForm.txtD.Refresh;
  EditForm.txtE.Refresh;
  EditForm.txtF.Refresh;
  EditForm.txtP.Refresh;
  EditForm.pnlXFormColor.Color := ColorValToColor(EditForm.cp.cmap, EditForm.cp.xform[t].color);
  EditForm.txtXFormColor.Text := Format('%1.3f', [cp.xform[t].color]);//FloatToStr(EditForm.cp.xform[t].color);
  EditForm.scrlXFormcolor.Position := Trunc(EditForm.cp.xform[t].color * scrlXFormColor.Max);

  for i := 0 to NRVAR-1 do begin
    v:=EditForm.cp.xform[SelectedTriangle].vars[i];
    if v <> VarsCache[i] then
    begin
      VarsCache[i]:=v;
      EditForm.VEVars.Values[VarNames(i)] := Format('%.6g', [v]);
    end;
  end;

  for i:= 0 to GetNrVariableNames - 1 do begin
    EditForm.cp.xform[SelectedTriangle].GetVariable(GetVariableNameAt(i), val);
    EditForm.vleVariables.Values[GetVariableNameAt(i)] := Format('%.6g', [val]);
  end;
end;

procedure TEditForm.Scale(var fx, fy: double; x, y, Width, Height: integer);
var
  sc: double;
begin
  sc := 50 * GraphZoom;
  fx := (x - (Width / 2)) / sc + gCenterX;
  fy := -((y - (Height / 2)) / sc - gCentery);
end;

procedure TEditForm.AutoZoom;
var
  i, j: integer;
  xminz, yminz, xmaxz, ymaxz: double;
begin
  xminz := 0;
  yminz := 0;
  xmaxz := 0;
  ymaxz := 0;
  for i := -1 to Transforms - 1 do
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
  begin
    GraphZoom := EditForm.GraphImage.Width / 60 / gxlength;
  end
  else
  begin
    GraphZoom := EditForm.GraphImage.Height / 60 / gylength;
  end;
  EditForm.StatusBar.Panels[2].Text := Format('Zoom: %f', [GraphZoom]);
end;

procedure TEditForm.UpdateFlameX;
var
  i: integer;
begin
  for i := 0 to transforms - 1 do
  begin
//    CP_compute(cp1, Triangles[i], Triangles[-1], i);
    solve3(MainTriangles[-1].x[0], MainTriangles[-1].y[0], MainTriangles[i].x[0],
      MainTriangles[-1].x[1], MainTriangles[-1].y[1], MainTriangles[i].x[1],
      MainTriangles[-1].x[2], MainTriangles[-1].y[2], MainTriangles[i].x[2],
      cp.xform[i].c[0][0], cp.xform[i].c[1][0], cp.xform[i].c[2][0]);

    solve3(MainTriangles[-1].x[0], MainTriangles[-1].y[0], MainTriangles[i].y[0],
      MainTriangles[-1].x[1], MainTriangles[-1].y[1], MainTriangles[i].y[1],
      MainTriangles[-1].x[2], MainTriangles[-1].y[2], MainTriangles[i].y[2],
      cp.xform[i].c[0][1], cp.xform[i].c[1][1], cp.xform[i].c[2][1]);
  end;

  GetXForms(cp, MainTriangles, transforms);
  if not chkPreserve.checked then ComputeWeights(cp, MainTriangles, transforms);
  DrawPreview;
  ShowSelectedInfo;
  DrawGraph;
end;

procedure TEditForm.UpdateFlame(DrawMain: boolean);
begin
//;    MainForm.StopThread;
  StatusBar.Panels[2].Text := Format('Zoom: %f', [GraphZoom]);
  GetXForms(cp, MainTriangles, transforms);
  if not chkPreserve.Checked then ComputeWeights(cp, MainTriangles, transforms);
  DrawPreview;
  ShowSelectedInfo;
  DrawGraph;
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
  i, j: integer;
begin
  if Transforms > 2 then
  { Can't have less than 2 transofms}
  begin
    MainForm.UpdateUndo;
    if t = (Transforms - 1) then
    { Last triangle...just reduce number}
    begin
      Transforms := Transforms - 1;
      SelectedTriangle := Transforms - 1;
      cp.xform[transforms].density := 0;
      cbTransforms.Clear;
      UpdateFlame(True);
    end
    else
    begin
      for i := t to Transforms - 2 do
      begin
      { copy higher transforms down }
        MainTriangles[i] := MainTriangles[i + 1];
        cp.xform[i].density := cp.xform[i + 1].density;
        cp.xform[i].color := cp.xform[i + 1].color;
        cp.xform[i].symmetry := cp.xform[i + 1].symmetry;
        for j := 0 to NRVAR - 1 do
          cp.xform[i].vars[j] := cp.xform[i + 1].vars[j];
      end;
      Transforms := Transforms - 1;
      cp.xform[transforms].density := 0;
      UpdateFlame(True);
    end;
    cbTransforms.clear;
    for i := 0 to Transforms - 1 do
      cbTransforms.Items.Add(IntToStr(i + 1));
    cbTransforms.ItemIndex := SelectedTriangle;
  end;
end;

function InsideTriangle(x, y: double): integer;
var
  i, j, k: integer;
  inside: boolean;
begin
{ is x, y inside a triangle }
  Result := -1;
  inside := False;
  j := 2;
  for k := Transforms - 1 downto 0 do
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

{
//used only one time - moved into procedure
procedure TEditForm.MouseInTriangle(fx, fy: double);
var
  i, j: integer;
  d: double;
begin
  for i := 0 to Transforms - 1 do
    for j := 0 to 2 do
    begin
      d := dist(fx, fy, MainTriangles[i].x[j], MainTriangles[i].y[j]);
      if (d * GraphZoom * 50) < 4 then
      begin
        mouseOverTriangle:=i;
        mouseOverCorner:=j;
        exit;
      end;
    end;

  i := InsideTriangle(fx, fy);
  if i >= 0 then // i > -1
  begin
    mouseOverTriangle:=i;
  end
  else begin
    mouseOverTriangle:=-2;
  end;
  mouseOverCorner:=-1;
end;
}

{
function TEditForm.InsideSelected(x, y: double): boolean;
var
  i, j, k: integer;
  inside: boolean;
begin
  inside := False;
  j := 2;
  k := SelectedTriangle;
  for i := 0 to 2 do
  begin
    if (((MainTriangles[k].y[i] <= y) and
      (y < MainTriangles[k].y[j])) or
      ((MainTriangles[k].y[j] <= y) and
      (y < MainTriangles[k].y[i]))) and
      (x < (MainTriangles[k].x[j] - MainTriangles[k].x[i]) *
      (y - MainTriangles[k].y[i]) /
      (MainTriangles[k].y[j] - MainTriangles[k].y[i]) +
      MainTriangles[k].x[i]) then inside := not inside;
    j := i
  end;
  InsideSelected := inside;
end;
}

function TEditForm.GetTriangleColor(n: integer): TColor;
begin
  if chkUseXFormColor.checked then
    Result := ColorValToColor(MainCp.cmap, cp.xform[n].color)
  else Result := clr[n mod 16];
end;

procedure TEditForm.DrawGraph;
var
  i: integer;
  ix, iy, sc: double;
  ax, ay, bx, by, cx, cy: integer;
  Width, Height: integer;
  BitMap: TBitMap;
  // --Z--
  gridX1, gridX2, gridY1, gridY2, gi, gstep: double;
  gp: TRoundToRange;
//  TrgPoints: array[0..2] of TPoint;
label DrawCorner;
begin
  // --Z-- hmmm:
  if SelectedTriangle < 0 then SelectedTriangle := 0
  else if SelectedTriangle >= Transforms then SelectedTriangle := Transforms-1;

  BitMap := TBitMap.Create;
  try
    Width := GraphImage.Width;
    Height := GraphImage.Height;
    BitMap.Width := Width;
    BitMap.Height := Height;
    ix := Width / 2;
    iy := Height / 2;
    sc := 50 * GraphZoom;
    with Bitmap.canvas do
    begin
      brush.Color := pnlBackColor.Color;
      FillRect(rect(0, 0, Width, Height));

      Pen.Width := 1;
      // --Z--
      // draw grid
      Pen.Style := psSolid;
      Pen.Color := GridColor2;
      gridX1:=gCenterX-ix/sc;
      gridX2:=gCenterX+(Width-ix)/sc;
      gridY1:=gCenterY-iy/sc;
      gridY2:=gCenterY+(Height-iy)/sc;
      try // who knows... ;)
        gp:=round(log10(gridX2-gridX1));
        if gp < log10(gridY2-gridY1) then gp:=round(log10(gridY2-gridY1));
        Dec(gp);
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
      Pen.Style := psSolid;
      ax := integer(round(ix - gCenterX*sc));
      ay := integer(round(iy + gCentery*sc));
      MoveTo(ax, 0);
      LineTo(ax, Height-1);
      MoveTo(0, ay);
      LineTo(Width-1, ay);
      // --

      {Reference Triangle}
      Pen.Style := psDot;
      Pen.color := pnlReference.Color;
      ax := integer(round(ix + (MainTriangles[-1].x[0] - gCenterX) * sc));
      ay := integer(round(iy - (MainTriangles[-1].y[0] - gCenterY) * sc));
      bx := integer(round(ix + (MainTriangles[-1].x[1] - gCenterX) * sc));
      by := integer(round(iy - (MainTriangles[-1].y[1] - gCenterY) * sc));
      cx := integer(round(ix + (MainTriangles[-1].x[2] - gCenterX) * sc));
      cy := integer(round(iy - (MainTriangles[-1].y[2] - gCenterY) * sc));
      Polyline([Point(ax,ay), Point(bx,by), Point(cx,cy), Point(ax,ay)]);
      Font.color := Pen.color;
      TextOut(ax, ay, 'A');
      TextOut(bx, by, 'B');
      TextOut(cx, cy, 'C');

      Pen.Style := psSolid;

      {Transforms}
      for i := 0 to Transforms - 1 do
      begin
        ax := integer(round(ix + (MainTriangles[i].x[0] - gCenterX) * sc));
        ay := integer(round(iy - (MainTriangles[i].y[0] - gCenterY) * sc));
        bx := integer(round(ix + (MainTriangles[i].x[1] - gCenterX) * sc));
        by := integer(round(iy - (MainTriangles[i].y[1] - gCenterY) * sc));
        cx := integer(round(ix + (MainTriangles[i].x[2] - gCenterX) * sc));
        cy := integer(round(iy - (MainTriangles[i].y[2] - gCenterY) * sc));
{
        TrgPoints[0].x := integer(round(ix + (MainTriangles[i].x[0] - gCenterX) * sc));
        TrgPoints[0].y := integer(round(iy - (MainTriangles[i].y[0] - gCenterY) * sc));
        TrgPoints[1].x := integer(round(ix + (MainTriangles[i].x[1] - gCenterX) * sc));
        TrgPoints[1].y := integer(round(iy - (MainTriangles[i].y[1] - gCenterY) * sc));
        TrgPoints[2].x := integer(round(ix + (MainTriangles[i].x[2] - gCenterX) * sc));
        TrgPoints[2].y := integer(round(iy - (MainTriangles[i].y[2] - gCenterY) * sc));
}
        //brush.Color := pnlBackColor.Color;

        Pen.Color := GetTriangleColor(i);

        if i <> SelectedTriangle then Pen.Style := psDot;
        //MoveTo(ax, ay); LineTo(bx, by); LineTo(cx, cy); LineTo(ax, ay);
        Polyline([Point(ax,ay), Point(bx,by), Point(cx,cy), Point(ax,ay)]);

        Pen.Style := psSolid;
        Ellipse(ax - 4, ay - 4, ax + 4, ay + 4);
        Ellipse(bx - 4, by - 4, bx + 4, by + 4);
        Ellipse(cx - 4, cy - 4, cx + 4, cy + 4);

        Font.color := Pen.color;
        //brush.Color := pnlBackColor.Color;
        TextOut(ax, ay, 'A');
        TextOut(bx, by, 'B');
        TextOut(cx, cy, 'C');
{
        brush.style:=bsClear;
        Font.color := pnlBackColor.Color;
        font.style:=[fsBold];
        TextOut(ax+2, ay+2, 'A');
        TextOut(bx+2, by+2, 'B');
        TextOut(cx+2, cy+2, 'C');
        font.style:=[];

        Font.color := Pen.color;
        TextOut(ax+1, ay+1, 'A');
        TextOut(bx+1, by+1, 'B');
        TextOut(cx+1, cy+1, 'C');
}
      end;

      // if dragging, draw pivot axis
      if TriangleCaught or CornerCaught then
      begin
        Pen.Mode := pmMerge;
        Pen.Color := $555555;
        Pen.Style := psDot;
        ax := integer(round(ix + (Pivot.x - gCenterX)*sc));
        ay := integer(round(iy + (gCentery - Pivot.y)*sc));
        MoveTo(ax, 0);
        LineTo(ax, Height);
        MoveTo(0, ay);
        LineTo(Width, ay);
        Pen.Color := $707070;
        Pen.Style := psSolid;
        Pen.Mode := pmXor;
        if CornerCaught then
        begin
          ax := integer(round(ix + (MainTriangles[SelectedTriangle].x[SelectedCorner] - gCenterX)*sc));
          ay := integer(round(iy - (MainTriangles[SelectedTriangle].y[SelectedCorner] - gCenterY)*sc));
        end
        else begin
          ax := integer(round(ix + (GetPivot.x - gCenterX)*sc));
          ay := integer(round(iy - (GetPivot.y - gCenterY)*sc));
        end;
        MoveTo(ax, 0);
        LineTo(ax, Height);
        MoveTo(0, ay);
        LineTo(Width, ay);
        Pen.Mode := pmCopy;

        mouseOverTriangle := SelectedTriangle;
      end;

      if (mouseOverTriangle >= 0) then // highlight triangle under cursor
      begin
        ax := integer(round(ix + (MainTriangles[mouseOverTriangle].x[0] - gCenterX) * sc));
        ay := integer(round(iy - (MainTriangles[mouseOverTriangle].y[0] - gCenterY) * sc));
        bx := integer(round(ix + (MainTriangles[mouseOverTriangle].x[1] - gCenterX) * sc));
        by := integer(round(iy - (MainTriangles[mouseOverTriangle].y[1] - gCenterY) * sc));
        cx := integer(round(ix + (MainTriangles[mouseOverTriangle].x[2] - gCenterX) * sc));
        cy := integer(round(iy - (MainTriangles[mouseOverTriangle].y[2] - gCenterY) * sc));
//          Pen.Style:=psSolid;
        pen.Width:=2;
        Pen.Color:=GetTriangleColor(mouseOverTriangle) shr 1 and $7f7f7f;
        Pen.Mode:=pmMerge;//pmXor;
        brush.Color:=Pen.Color shr 1 and $7f7f7f;
        //Polyline([Point(ax,ay), Point(bx,by), Point(cx,cy), Point(ax,ay)]);
        Polygon([Point(ax,ay), Point(bx,by), Point(cx,cy)]);
        pen.width:=4;
        Ellipse(ax - 3, ay - 3, ax + 3, ay + 3);
        Ellipse(bx - 3, by - 3, bx + 3, by + 3);
        Ellipse(cx - 3, cy - 3, cx + 3, cy + 3);
        pen.width:=1;
        pen.mode:=pmCopy;
//        brush.Color := pen.Color;
      end;

      pen.color := clWhite;
      brush.Color:=clSilver;
      if CornerCaught then // draw selected corner
      begin
        ax := integer(round(ix + (MainTriangles[SelectedTriangle].x[SelectedCorner] - gCenterX) * sc));
        ay := integer(round(iy - (MainTriangles[SelectedTriangle].y[SelectedCorner] - gCenterY) * sc));
        Ellipse(ax - 4, ay - 4, ax + 4, ay + 4);
      end
      else if (mouseOverTriangle>=0) and (mouseOverCorner >= 0) then // highlight corner under cursor
      begin
//        brush.Color := GetTriangleColor(mouseOverTriangle) shr 1 and $7f7f7f;
        ax := integer(round(ix + (MainTriangles[mouseOverTriangle].x[mouseOverCorner] - gCenterX) * sc));
        ay := integer(round(iy - (MainTriangles[mouseOverTriangle].y[mouseOverCorner] - gCenterY) * sc));
        Ellipse(ax - 4, ay - 4, ax + 4, ay + 4);
      end;

      // draw pivot point
      ax := integer(round(ix + (GetPivot.x - gCenterX) * sc));
      ay := integer(round(iy - (GetPivot.y - gCenterY) * sc));
      Pen.Style := psSolid;
      pen.Color:=clWhite;
      brush.Color:=clSilver;
      Ellipse(ax - 2, ay - 2, ax + 2, ay + 2);
{
      MoveTo(ax-3, ay);
      LineTo(ax, ay-3);
      LineTo(ax+3, ay);
      LineTo(ax, ay+3);
      LineTo(ax-3, ay);
}
      // --
    end;
    GraphImage.Picture.Graphic := Bitmap;
    GraphImage.Refresh;
  finally
    BitMap.Free;
  end;
end;

procedure TEditForm.FormCreate(Sender: TObject);
var
  i: integer;
begin
(*
  Drawcntrl := TDrawingControl.Create(self);
  Drawcntrl.TabStop := True;
  Drawcntrl.Parent := GrphPnl;
  Drawcntrl.Align := alClient;
  Drawcntrl.Visible := True;

  Drawcntrl.OnDblClick := GraphImageDblClick;
  Drawcntrl.Onpaint :=  viewPaint;
*)

  for i:= 0 to NRVAR - 1 do begin
    VEVars.InsertRow(Varnames(i), '0', True);
  end;

  for i:= 0 to GetNrVariableNames - 1 do begin
    vleVariables.InsertRow(GetVariableNameAt(i), '0', True);
  end;

  bm := TBitmap.Create;
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
  mouseOverTriangle := -1;
  mouseOverCorner := -1;

  for i := 0 to NRVAR-1 do
    VarsCache[i] := MinDouble;
end;

procedure TEditForm.GraphImageMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  vx, vy, fx, fy: double;
  mt,mc: integer;

  i, j: integer;
  d: double;
label FoundCorner;
begin
  Scale(fx, fy, x, y, EditForm.GraphImage.Width, EditForm.GraphImage.Height);
  // --Z--
  StatusBar.Panels[0].Text := Format('X: %f', [fx]);
  StatusBar.Panels[1].Text := Format('Y: %f', [fy]);

  mt:=mouseOverTriangle;
  mc:=MouseOverCorner;

  if SelectMode then // look for point or triangle under cursor
  begin
  for i := 0 to Transforms - 1 do
    for j := 0 to 2 do
    begin
      d := dist(fx, fy, MainTriangles[i].x[j], MainTriangles[i].y[j]);
      if (d * GraphZoom * 50) < 4 then
      begin
        mouseOverTriangle:=i;
        mouseOverCorner:=j;

        goto FoundCorner;
      end;
    end;

  i := InsideTriangle(fx, fy);
  if i >= 0 then // i > -1
  begin
    mouseOverTriangle:=i;
  end
  else begin
    mouseOverTriangle:=-2;
  end;
  mouseOverCorner:=-1;
FoundCorner:

  end; // if selectmode


  if  (mouseOverTriangle >= 0) and (SelectMode or (mouseOverTriangle = SelectedTriangle)) then
    GraphImage.Cursor := crHandPoint
  else
    GraphImage.Cursor := crArrow;

  if graphDragMode then // graph panning
  begin
    dragged := true;
    GcenterX := GcenterX - (fx - oldx);
    GcenterY := GcenterY - (fy - oldy);
    DrawGraph;
    exit;
  end;

  Shift := Shift - [ssLeft];

  if CornerCaught then
  begin { Drag a corner }
    // --Z--
    if (Shift = [ssAlt]) or ((editMode = modeRotate) and (Shift = [])) then
    begin // rotate point around pivot
      vy := dist(Pivot.X, Pivot.Y, fx, fy);
      if vy<>0 then begin
        vx := (fx-Pivot.X)*olddist/vy;
        vy := (fy-Pivot.Y)*olddist/vy;
      end
      else begin
        vx := 0;
        vy := 0;
      end;
      MainTriangles[SelectedTriangle].x[SelectedCorner] := Pivot.X+vx;
      MainTriangles[SelectedTriangle].y[SelectedCorner] := Pivot.Y+vy;
      vx:=arctan2(vy,vx);
      vy:=arctan2(oldy,oldx);
      StatusBar.Panels[2].Text := Format('Rotate: %3.2f°', [(vx-vy)*180/PI]);
    end
    else if (Shift = [ssCtrl]) or ((editMode = modeScale) and (Shift = [])) then
    begin // move point along vector
      if olddist<>0 then begin
        vy := (oldx*(fx-Pivot.X) + oldy*(fy-Pivot.Y))/(olddist*olddist);
        MainTriangles[SelectedTriangle].x[SelectedCorner] := Pivot.X+oldx*vy;
        MainTriangles[SelectedTriangle].y[SelectedCorner] := Pivot.Y+oldy*vy;
        StatusBar.Panels[2].Text := Format('Scale: %3.2f%%', [vy*100]);
      end
      else begin
        MainTriangles[SelectedTriangle].x[SelectedCorner] := Pivot.X;
        MainTriangles[SelectedTriangle].y[SelectedCorner] := Pivot.Y;
      end;
    end
    else begin // snap/move
      if Shift = [ssShift] then // snap to axis
      begin
        if abs(fx-Pivot.X) > abs(fy-Pivot.Y) then begin
          MainTriangles[SelectedTriangle].x[SelectedCorner] := fx;
          MainTriangles[SelectedTriangle].y[SelectedCorner] := Pivot.Y;
        end
        else begin
          MainTriangles[SelectedTriangle].x[SelectedCorner] := Pivot.x;
          MainTriangles[SelectedTriangle].y[SelectedCorner] := fy;
        end;
      end
      else begin // just move
        MainTriangles[SelectedTriangle].x[SelectedCorner] := fx;
        MainTriangles[SelectedTriangle].y[SelectedCorner] := fy;
      end;
      StatusBar.Panels[2].Text := Format('Move: %3.3f ; %3.3f', [fx-(Pivot.X+oldx), fy-(Pivot.Y+oldy)]);
    end;
    // --
    HasChanged := True;
    UpdateFlameX;
//    UpdateFlame(False);
StatusBar.Refresh;
    exit;
  end
  else if TriangleCaught then { Modify a whole triangle }
  begin
    if (Shift = [ssAlt]) or ((editMode = modeRotate) and (Shift = [])) then // rotate
    begin
      vy := arctan2(oldy, oldx);
      vx := arctan2(fy-Pivot.Y, fx-Pivot.X);
      MainTriangles[SelectedTriangle] :=
        RotateTrianglePoint(OldTriangle, Pivot.X, Pivot.Y, vx-vy);
      StatusBar.Panels[2].Text := Format('Rotate: %3.2f°', [(vx-vy)*180/PI]);
    end
    else if (Shift = [ssCtrl]) or ((editMode = modeScale) and (Shift = [])) then
    begin // scale
      if olddist<>0 then begin
        vy := (oldx*(fx-Pivot.X) + oldy*(fy-Pivot.Y))/(olddist*olddist);
        MainTriangles[SelectedTriangle] :=
          ScaleTrianglePoint(OldTriangle, Pivot.X, Pivot.Y, vy);
        StatusBar.Panels[2].Text := Format('Scale: %3.2f%%', [vy*100]);
      end
      else MainTriangles[SelectedTriangle] := OldTriangle;
    end
    else begin // snap/move
      vx := fx - (Pivot.x + oldx);
      vy := fy - (Pivot.y + oldy);
      if Shift = [ssShift] then // snap to axis
      begin
        //if abs(fx - Pivot.X) > abs(fy - Pivot.Y) then vy := 0
        if abs(vx) > abs(vy) then vy := 0
        else vx := 0;
      end;
      MainTriangles[SelectedTriangle].x[0] := OldTriangle.x[0] + vx;
      MainTriangles[SelectedTriangle].y[0] := OldTriangle.y[0] + vy;
      MainTriangles[SelectedTriangle].x[1] := OldTriangle.x[1] + vx;
      MainTriangles[SelectedTriangle].y[1] := OldTriangle.y[1] + vy;
      MainTriangles[SelectedTriangle].x[2] := OldTriangle.x[2] + vx;
      MainTriangles[SelectedTriangle].y[2] := OldTriangle.y[2] + vy;
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
    DrawGraph;
  end
end;

procedure TEditForm.GraphImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  d, fx, fy: double;
  i, j: integer;
//label GotCorner;
begin
//  intoldx := x;
//  intoldy := y;
  CornerCaught := False;
  TriangleCaught := False;
  dragged := false; // --Z--
  Scale(fx, fy, x, y, EditForm.GraphImage.Width, EditForm.GraphImage.Height);
  Shift := Shift - [ssLeft]; // --Z--
  if Button = mbLeft then
  begin
    if SelectMode = false then // Only change the selected triangle
    begin
      {Has user grabbed a corner?}
      for j := 0 to 2 do
      begin
        d := dist(fx, fy, MainTriangles[SelectedTriangle].x[j], MainTriangles[SelectedTriangle].y[j]);
        if (d * GraphZoom * 50) < 4 then begin//goto GotCorner;
// WTF!?! goto isn't working right way in this shitty pascal!!! 8-()
          SelectedCorner := j;
          Pivot := GetPivot;
          oldx := MainTriangles[SelectedTriangle].x[j] - Pivot.X;
          oldy := MainTriangles[SelectedTriangle].y[j] - Pivot.Y;
          olddist := sqrt(oldx*oldx + oldy*oldy);

          MainForm.UpdateUndo;
          CornerCaught := True;
          DrawPreview;
          ShowSelectedInfo;
          DrawGraph;
          exit;
//
        end;
      end;
    end
    else begin // Find a corner and select triangle
      for i := Transforms - 1 downto 0 do
        for j := 0 to 2 do
        begin
          d := dist(fx, fy, MainTriangles[i].x[j], MainTriangles[i].y[j]);
          if (d * GraphZoom * 50) < 4 then
          begin
            SelectedTriangle := i;
//GotCorner:
            SelectedCorner := j;
            Pivot := GetPivot;
            oldx := MainTriangles[SelectedTriangle].x[j] - Pivot.X;
            oldy := MainTriangles[SelectedTriangle].y[j] - Pivot.Y;
            olddist := sqrt(oldx*oldx + oldy*oldy);

            MainForm.UpdateUndo;
            CornerCaught := True;
            DrawPreview;
            ShowSelectedInfo;
            DrawGraph;
            exit;
          end;
        end;
    end;
      // so user hasn't selected any vertices,
      // let's check for triangles then!

//      // --Z-- // alt=rotate, ctrl=scale, shift=move

    if SelectMode then
    begin
      i := InsideTriangle(fx, fy);
      if i >= 0 then SelectedTriangle := i
      else
        if Shift * [ssAlt,ssCtrl,ssShift] = [] then exit;
    end;

    OldTriangle := MainTriangles[SelectedTriangle];
    MainForm.UpdateUndo;
    TriangleCaught := True;

    Pivot := GetPivot;
    oldx := fx-Pivot.X;
    oldy := fy-Pivot.Y;
    olddist := sqrt(oldx*oldx + oldy*oldy);

    DrawPreview;
    ShowSelectedInfo;
    DrawGraph;
    exit;
  end
  else if Button = mbRight then // graph panning
  begin
    SetCaptureControl(GraphImage);
    Screen.Cursor := crSizeAll;

    graphDragMode := true;
    oldx := fx;
    oldY := fy;
  end;
end;

procedure TEditForm.GraphImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
//var
//fx, fy: double;
//i: integer;
//transformvalue: double;
begin
  if Button = mbRight then // --Z-- panning
  begin
    graphDragMode := false;
    if dragged=false then // haven't dragged - popup menu then
    begin
      GetCursorPos(mousepos); // hmmm
      EditPopup.Popup(mousepos.x, mousepos.y);
    end
    else dragged := false;
    Screen.Cursor := crDefault;
    SetCaptureControl(nil);
    exit;
  end;

  CornerCaught := False;
  TriangleCaught := False;
  if HasChanged then
  begin
    UpdateFlame(true);
    HasChanged := False;
  end
  else DrawGraph;
end;

{
procedure TEditForm.mnuRotateRightClick(Sender: TObject);
var
  offset: double;
begin
  try
    offset := StrToFloat(txtTrgRotateValue.Text);
  except
    offset := 0;
    txtTrgRotateValue.Text := '0';
  end;
  if offset <> 0 then
  begin
    MainTriangles[SelectedTriangle] := RotateTriangleCenter(MainTriangles[SelectedTriangle], -((PI/180) * offset));
    HasChanged := True;
    UpdateFlame(true);
  end;
end;

procedure TEditForm.mnuRotateLeftClick(Sender: TObject);
var
  offset: double;
begin
  try
    offset := StrToFloat(txtTrgRotateValue.Text);
  except
    offset := 0;
    txtTrgRotateValue.Text := '0';
  end;
  if offset <> 0 then
  begin
    MainTriangles[SelectedTriangle] := RotateTriangleCenter(MainTriangles[SelectedTriangle], (PI/180) * offset);
    HasChanged := True;
    UpdateFlame(true);
  end;
end;

procedure TEditForm.mnuScaleUpClick(Sender: TObject);
var
  scale: double;
begin
  try
    scale := StrToFloat(txtTrgScaleValue.Text);
  except
    scale := 0.0;
    txtTrgScaleValue.Text := '0.0';
  end;
  if scale <> 0 then
  begin
    MainTriangles[SelectedTriangle] := ScaleTriangleCenter(MainTriangles[SelectedTriangle], scale+1.0);
    HasChanged := True;
    UpdateFlame(true);
  end;
end;

procedure TEditForm.mnuScaleDownClick(Sender: TObject);
var
  scale: double;
begin
  try
    scale := StrToFloat(txtTrgScaleValue.Text);
  except
    scale := 0.0;
    txtTrgScaleValue.Text := '0.0';
  end;
  if scale <> 0 then
  begin
    MainTriangles[SelectedTriangle] := ScaleTriangleCenter(MainTriangles[SelectedTriangle], 1.0-scale);
    HasChanged := True;
    UpdateFlame(true);
  end;
end;
}

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
      if Registry.ValueExists('UseFlameBackground') then
      begin
        UseFlameBackground := Registry.ReadBool('UseFlameBackground');
      end
      else
      begin
        UseFlameBackground := False;
      end;
      if Registry.ValueExists('BackgroundColor') then
        BackgroundColor := Registry.ReadInteger('BackgroundColor')
      else
        BackgroundColor := integer(clBlack);
      if Registry.ValueExists('GridColor1') then
        GridColor1 := Registry.ReadInteger('GridColor1')
      else
        GridColor1 := $444444;
      if Registry.ValueExists('GridColor2') then
        GridColor2 := Registry.ReadInteger('GridColor2')
      else
        GridColor2 := $333333;
      if Registry.ValueExists('ReferenceTriangleColor') then
        ReferenceTriangleColor := Registry.ReadInteger('ReferenceTriangleColor')
      else
        ReferenceTriangleColor := integer(clGray);
      if Registry.ValueExists('ResetLocation') then
        mnuResetLoc.checked := Registry.ReadBool('ResetLocation')
      else mnuResetLoc.checked := true;
      tbResetLoc.Down := mnuResetLoc.checked;
    end
    else begin
      UseTransformColors := False;
      UseFlameBackground := False;
      BackgroundColor := $000000;
      GridColor1 := $444444;
      GridColor2 := $333333;
      ReferenceTriangleColor := integer(clGray);
      mnuResetLoc.checked := true;
      tbResetLoc.Down := true;
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
  chkUseXFormColor.checked := UseTransformColors;
  chkFlameBack.checked := UseFlameBackground;
  pnlBackColor.Color := TColor(BackgroundColor);
  GrphPnl.Color := TColor(BackgroundColor);
  pnlGridColor1.Color := GridColor1;
  pnlGridColor2.Color := GridColor2;
  pnlReference.color := TColor(ReferenceTriangleColor);
  UpdateDisplay;
end;

procedure TEditForm.mnuDeleteClick(Sender: TObject);
begin
  if SelectedTriangle > -1 then DeleteTriangle(SelectedTriangle);
end;

procedure TEditForm.mnuAddClick(Sender: TObject);
var
  i: integer;
begin
  if Transforms < NXFORMS then
  begin
    MainForm.UpdateUndo;
    Transforms := Transforms + 1;
    MainTriangles[Transforms - 1] := MainTriangles[-1];
    SelectedTriangle := Transforms - 1;
    ComputeWeights(cp, MainTriangles, transforms);
    cp.xform[Transforms - 1].vars[0] := 1;
    for i := 1 to NRVAR - 1 do
      cp.xform[Transforms - 1].vars[i] := 0;
    cbTransforms.clear;
    for i := 0 to Transforms - 1 do
      cbTransforms.Items.Add(IntToStr(i + 1));
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
    Transforms := Transforms + 1;
    MainTriangles[Transforms - 1] := MainTriangles[SelectedTriangle];
    ComputeWeights(cp, MainTriangles, transforms);
    for i := 0 to NRVAR - 1 do
      cp.xform[Transforms - 1].vars[i] := cp.xform[SelectedTriangle].vars[i];
    SelectedTriangle := Transforms - 1;
    cbTransforms.clear;
    for i := 0 to Transforms - 1 do
      cbTransforms.Items.Add(IntToStr(i + 1));
    UpdateFlame(True);
  end;
end;


procedure TEditForm.mnuAutoZoomClick(Sender: TObject);
begin
  AutoZoom;
  DrawGraph;
end;
{
procedure TEditForm.mnuXFlipClick(Sender: TObject);
begin
//  MainTriangles[SelectedTriangle] := FlipTriangleHorizontal(MainTriangles[SelectedTriangle]);
  with MainTriangles[SelectedTriangle] do // --Z--
  begin
    x[0] := GetPivot.x - x[0];
    x[1] := x[1];
    x[2] := x[2];
  end;
  UpdateFlame(True);
end;

procedure TEditForm.mnuYFlipClick(Sender: TObject);
begin
  MainTriangles[SelectedTriangle] := FlipTriangleVertical(MainTriangles[SelectedTriangle]);
  UpdateFlame(True);
end;
}

procedure TEditForm.btnCloseClick(Sender: TObject);
begin
  EditForm.Close;
end;

procedure TEditForm.FormResize(Sender: TObject);
begin
  Autozoom;
  DrawGraph;
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
  else if Sender = txtP then ;
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
      ReadjustWeights(cp);
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
    else if Sender = txtP then ;
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
        ReadjustWeights(cp);
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
    if NewVal < 0 then NewVal := 0;
    if NewVal > 0.99 then NewVal := 0.99;
    { If it's not the same as the old value and it was valid }
    TEdit(Sender).Text := Format('%.6g', [NewVal]);
    if (OldVal <> NewVal) and Allow then
    begin
      MainForm.UpdateUndo;
      cp.xform[SelectedTriangle].density := NewVal;
      ReadjustWeights(cp);
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
  if NewVal < 0 then NewVal := 0;
  if NewVal > 0.99 then NewVal := 0.99;
    { If it's not the same as the old value and it was valid }
  TEdit(Sender).Text := Format('%.6g', [NewVal]);
  if (OldVal <> NewVal) and Allow then
  begin
    MainForm.UpdateUndo;
    cp.xform[SelectedTriangle].density := NewVal;
    ReadjustWeights(cp);
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
      Registry.WriteBool('UseTransformColors', UseTransformColors);
      Registry.WriteBool('UseFlameBackground', UseFlameBackground);
      Registry.WriteInteger('BackgroundColor', BackgroundColor);
      Registry.WriteInteger('GridColor1', GridColor1);
      Registry.WriteInteger('GridColor2', GridColor2);
      Registry.WriteInteger('ReferenceTriangleColor', ReferenceTriangleColor);
      Registry.WriteBool('ResetLocation', mnuResetLoc.checked);
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
  bm.free;
  cp.free;
  Render.free;
end;

procedure TEditForm.mnuLowQualityClick(Sender: TObject);
begin
  mnuLowQuality.Checked := True;
  tbLowQ.Down := true;
  PreviewDensity := prevLowQuality;
  EditPrevQual := 0;
  DrawPreview;
end;

procedure TEditForm.mnuHighQualityClick(Sender: TObject);
begin
  mnuHighQuality.Checked := True;
  tbHiQ.Down := true;
  PreviewDensity := prevHighQuality;
  EditPrevQual := 2;
  DrawPreview;
end;

procedure TEditForm.mnuMediumQualityClick(Sender: TObject);
begin
  mnuMediumQuality.Checked := True;
  tbMedQ.Down := true;
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
  tbResetLoc.Down := reset;
  if reset then
  begin
    cp.width := MainCp.width;
    cp.height := MainCp.height;
    cp.pixels_per_unit := MainCp.pixels_per_unit;
    AdjustScale(cp, PreviewImage.width, PreviewImage.Height);
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
  AutoZoom;
  UpdateFlame(True);
end;

procedure TEditForm.mnuFlipVerticalClick(Sender: TObject);
var
  p: double;
begin
  MainForm.UpdateUndo;
//  MainTriangles[SelectedTriangle] := FlipTriangleVertical(MainTriangles[SelectedTriangle]);
  with MainTriangles[SelectedTriangle] do // --Z--
  begin
    p := GetPivot.y * 2;
    y[0] := p - y[0];
    y[1] := p - y[1];
    y[2] := p - y[2];
  end;
  AutoZoom;
  UpdateFlame(True);
end;

procedure TEditForm.mnuFlipHorizontalClick(Sender: TObject);
var
  p: double;
begin
  MainForm.UpdateUndo;
//  MainTriangles[SelectedTriangle] := FlipTriangleHorizontal(MainTriangles[SelectedTriangle]);
  with MainTriangles[SelectedTriangle] do // --Z--
  begin
    p := GetPivot.x * 2;
    x[0] := p - x[0];
    x[1] := p - x[1];
    x[2] := p - x[2];
  end;
  AutoZoom;
  UpdateFlame(True);
end;

procedure TEditForm.GraphImageDblClick(Sender: TObject);
begin
  AutoZoom;
  DrawGraph;
end;

procedure TEditForm.cbTransformsChange(Sender: TObject);
begin
  if SelectedTriangle <> cbTransforms.ItemIndex then SelectedTriangle := cbTransforms.ItemIndex;
  ShowSelectedInfo;
  DrawGraph;
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
    //TextOut(Rect.Left+h+2, Rect.Top, eqListBox.Items[Index]);
    TextOut(Rect.Left+h+2, Rect.Top, IntToStr(Index+1)); // hack

    pen.Color := TrgColor;
    brush.Color := pen.Color shr 1 and $7f7f7f;
    //pen.Style := psClear;

    ax:=Rect.Left+h-2;
    ay:=Rect.Top+1;
    bx:=Rect.Left+2;
    by:=Rect.Bottom-3;
    Polygon([Point(ax, ay), Point(ax, by), Point(bx, by)]);
  end;
end;

procedure TEditForm.CoefKeyPress(Sender: TObject; var Key: Char);
var
  Allow: boolean;
  i: integer;
  OldVal, NewVal: double;
begin
  i := 0; OldVal := 0;
  if key = #13 then
  begin
    key := #0;
    Allow := True;
    if Sender = txtA then
      i := 0
    else if Sender = txtB then
      i := 1
    else if Sender = txtC then
      i := 2
    else if Sender = txtD then
      i := 3
    else if Sender = txtE then
      i := 4
    else if Sender = txtF then
      i := 5;
    case i of
      0: OldVal := Round6(cp.xform[SelectedTriangle].c[0][0]); //a
      1: OldVal := Round6(cp.xform[SelectedTriangle].c[1][0]); //b
      2: OldVal := Round6(cp.xform[SelectedTriangle].c[0][1]); //c
      3: OldVal := Round6(cp.xform[SelectedTriangle].c[1][1]); //d
      4: OldVal := Round6(cp.xform[SelectedTriangle].c[2][0]); //e
      5: OldVal := Round6(cp.xform[SelectedTriangle].c[2][1]); //f
    end;
//  OldText := Val;
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
    TEdit(Sender).Text := Format('%.6g', [NewVal]);

    { If it's not the same as the old value and it was valid }
    if (NewVal <> OldVal) and Allow then
    begin
      MainForm.UpdateUndo;
      case i of
        0: cp.xform[SelectedTriangle].c[0][0] := NewVal; //a
        1: cp.xform[SelectedTriangle].c[1][0] := NewVal; //b
        2: cp.xform[SelectedTriangle].c[0][1] := NewVal; //c
        3: cp.xform[SelectedTriangle].c[1][1] := NewVal; //d
        4: cp.xform[SelectedTriangle].c[2][0] := NewVal; //e
        5: cp.xform[SelectedTriangle].c[2][1] := NewVal; //f
      end;
      MainForm.TrianglesFromCP(cp, MainTriangles);
      ShowSelectedInfo;
      UpdateFlame(true);
    end;
  end;
end;

procedure TEditForm.CoefExit(Sender: TObject);
var
  Allow: boolean;
  i: integer;
  NewVal, OldVal: double;
begin
  i := 0; OldVal := 0;
  Allow := True;
  if Sender = txtA then
    i := 0
  else if Sender = txtB then
    i := 1
  else if Sender = txtC then
    i := 2
  else if Sender = txtD then
    i := 3
  else if Sender = txtE then
    i := 4
  else if Sender = txtF then
    i := 5;
  case i of
    0: OldVal := Round6(cp.xform[SelectedTriangle].c[0][0]); //a
    1: OldVal := Round6(cp.xform[SelectedTriangle].c[1][0]); //b
    2: OldVal := Round6(cp.xform[SelectedTriangle].c[0][1]); //c
    3: OldVal := Round6(cp.xform[SelectedTriangle].c[1][1]); //d
    4: OldVal := Round6(cp.xform[SelectedTriangle].c[2][0]); //e
    5: OldVal := Round6(cp.xform[SelectedTriangle].c[2][1]); //f
  end;
//  OldText := Val;
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
  TEdit(Sender).Text := Format('%.6g', [NewVal]);

    { If it's not the same as the old value and it was valid }
  if (NewVal <> OldVal) and Allow then
  begin
    MainForm.UpdateUndo;
    case i of
      0: cp.xform[SelectedTriangle].c[0][0] := NewVal; //a
      1: cp.xform[SelectedTriangle].c[1][0] := NewVal; //b
      2: cp.xform[SelectedTriangle].c[0][1] := NewVal; //c
      3: cp.xform[SelectedTriangle].c[1][1] := NewVal; //d
      4: cp.xform[SelectedTriangle].c[2][0] := NewVal; //e
      5: cp.xform[SelectedTriangle].c[2][1] := NewVal; //f
    end;
    MainForm.TrianglesFromCP(cp, MainTriangles);
    ShowSelectedInfo;
    UpdateFlame(true);
  end;
end;

procedure TEditForm.scrlXFormColorScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if ScrollCode = scEndScroll then UpdateFlame(True);
end;

procedure TEditForm.scrlXFormColorChange(Sender: TObject);
begin
  cp.xform[SelectedTriangle].color := (scrlXFormColor.Position) / scrlXFormColor.Max;
  txtXFormColor.Text := Format('%1.3f', [cp.xform[SelectedTriangle].color]);
  pnlXFormColor.color := ColorValToColor(MainCp.cmap, cp.xform[SelectedTriangle].color);
{
  with ColorImage.Canvas do ///..........!
  begin
    Row := Bitmap.Scanline[0];
    for i := 0 to Bitmap.Width - 1 do
    begin
      with Row[i] do
      begin
        rgbtRed := Palette[i][0];
        rgbtGreen := Palette[i][1];
        rgbtBlue := Palette[i][2];
      end;
    end;
  end;
}
  DrawPreview;
end;

procedure TEditForm.chkUseXFormColorClick(Sender: TObject);
begin
  UseTransformColors := chkUseXFormColor.checked;
  DrawGraph;
end;

procedure TEditForm.chkFlameBackClick(Sender: TObject);
begin
  UseFlameBackground := chkFlameBack.checked;
  DrawGraph;
end;

procedure TEditForm.pnlBackColorClick(Sender: TObject);
begin
  AdjustForm.ColorDialog.Color := pnlBackColor.Color;
  if AdjustForm.ColorDialog.Execute then
  begin
    pnlBackColor.Color := AdjustForm.ColorDialog.Color;
    BackgroundColor := Integer(pnlBackColor.color);
    GrphPnl.Color := BackgroundColor;
    DrawGraph;
  end;
end;

procedure TEditForm.pnlReferenceClick(Sender: TObject);
begin
  AdjustForm.ColorDialog.Color := pnlReference.Color;
  if AdjustForm.ColorDialog.Execute then
  begin
    pnlReference.Color := AdjustForm.ColorDialog.Color;
    ReferenceTriangleColor := Integer(pnlReference.color);
    DrawGraph;
  end;
end;

procedure TEditForm.pnlGridColor1Click(Sender: TObject);
begin
  AdjustForm.ColorDialog.Color := pnlGridColor1.Color;
  if AdjustForm.ColorDialog.Execute then
  begin
    pnlGridColor1.Color := AdjustForm.ColorDialog.Color;
    GridColor1 := Integer(pnlGridColor1.color);
    DrawGraph;
  end;
end;

procedure TEditForm.pnlGridColor2Click(Sender: TObject);
begin
  AdjustForm.ColorDialog.Color := pnlGridColor2.Color;
  if AdjustForm.ColorDialog.Execute then
  begin
    pnlGridColor2.Color := AdjustForm.ColorDialog.Color;
    GridColor2 := Integer(pnlGridColor2.color);
    DrawGraph;
  end;
end;

procedure TEditForm.txtXFormColorExit(Sender: TObject);
var
  v: double;
begin
  try
    v := StrToFloat(txtXFormColor.Text);
  except on EConvertError do
    begin
      txtXformColor.text := Format('%1.3f', [cp.xform[SelectedTriangle].color]);//FLoatToStr(cp.xform[SelectedTriangle].color);
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
        txtXformColor.text := Format('%1.3f', [cp.xform[SelectedTriangle].color]);//FLoattoStr(cp.xform[SelectedTriangle].color);
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

procedure TEditForm.txtSymmetryExit(Sender: TObject);
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
  if NewVal < 0 then NewVal := 0;
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

procedure TEditForm.txtSymmetryKeyPress(Sender: TObject; var Key: Char);
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
    if NewVal < 0 then NewVal := 0;
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

procedure TEditForm.VEVarsKeyPress(Sender: TObject; var Key: Char);
var
  Allow: boolean;
  i: integer;
  NewVal, OldVal: double;
begin
  if key = #13 then
  begin
    key := #0;
    Allow := True;

    i := EditForm.VEVars.Row - 1;

    OldVal := Round6(cp.xform[SelectedTriangle].vars[i]);
  { Test that it's a valid floating point number }
    try
      StrToFloat(VEVars.Values[VarNames(i)]);
    except on Exception do
      begin
      { It's not, so we restore the old value }
        VEVars.Values[VarNames(i)] := Format('%.6g', [OldVal]);
        Allow := False;
      end;
    end;
    NewVal := Round6(StrToFloat(VEVars.Values[VarNames(i)]));
//    if NewVal < 0 then NewVal := 0;
    VEVars.Values[VarNames(i)] := Format('%.6g', [NewVal]);

  { If it's not the same as the old value and it was valid }
    if (NewVal <> OldVal) and Allow then
    begin
      MainForm.UpdateUndo;
//      EditedVariation := i;
      cp.xform[SelectedTriangle].vars[i] := NewVal;
//      VarNormalize(cp);
      VEVars.Values[VarNames(i)] := Format('%.6g', [cp.xform[SelectedTriangle].vars[i]]);
      ShowSelectedInfo;
      UpdateFlame(True);
    end;
  end;
end;

procedure TEditForm.VEVarsExit(Sender: TObject);
var
  Allow: boolean;
  i: integer;
  NewVal, OldVal: double;
begin
  Allow := True;

  i := EditForm.VEVars.Row - 1;

  OldVal := Round6(cp.xform[SelectedTriangle].vars[i]);
{ Test that it's a valid floating point number }
  try
    StrToFloat(VEVars.Values[VarNames(i)]);
  except on Exception do
    begin
    { It's not, so we restore the old value }
      VEVars.Values[VarNames(i)] := Format('%.6g', [OldVal]);
      Allow := False;
    end;
  end;
  NewVal := Round6(StrToFloat(VEVars.Values[VarNames(i)]));
//    if NewVal < 0 then NewVal := 0;
  VEVars.Values[VarNames(i)] := Format('%.6g', [NewVal]);

{ If it's not the same as the old value and it was valid }
  if (NewVal <> OldVal) and Allow then
  begin
    MainForm.UpdateUndo;
//    EditedVariation := i;
    cp.xform[SelectedTriangle].vars[i] := NewVal;
//      VarNormalize(cp);
    VEVars.Values[VarNames(i)] := Format('%.6g', [cp.xform[SelectedTriangle].vars[i]]);
    ShowSelectedInfo;
    UpdateFlame(True);
  end;
end;

procedure TEditForm.VEVarsValidate(Sender: TObject; ACol, ARow: Integer; const KeyName, KeyValue: String);
var
  Allow: boolean;
  i: integer;
  NewVal, OldVal: double;
begin
  Allow := True;

  i := EditForm.VEVars.Row - 1;

  OldVal := Round6(cp.xform[SelectedTriangle].vars[i]);
{ Test that it's a valid floating point number }
  try
    StrToFloat(VEVars.Values[VarNames(i)]);
  except on Exception do
    begin
    { It's not, so we restore the old value }
      VEVars.Values[VarNames(i)] := Format('%.6g', [OldVal]);
      Allow := False;
    end;
  end;
  NewVal := Round6(StrToFloat(VEVars.Values[VarNames(i)]));
//    if NewVal < 0 then NewVal := 0;
  VEVars.Values[VarNames(i)] := Format('%.6g', [NewVal]);

{ If it's not the same as the old value and it was valid }
  if (NewVal <> OldVal) and Allow then
  begin
    MainForm.UpdateUndo;
//    EditedVariation := i;
    cp.xform[SelectedTriangle].vars[i] := NewVal;
//      VarNormalize(cp);
    VEVars.Values[VarNames(i)] := Format('%.6g', [cp.xform[SelectedTriangle].vars[i]]);
    ShowSelectedInfo;
    UpdateFlame(True);
  end;
end;

{ **************************************************************************** }

function TEditForm.GetPivot: TSPoint;
begin
  case (rgPivot.ItemIndex) of
    0: begin
        Result.x:=MainTriangles[SelectedTriangle].x[0];
        Result.y:=MainTriangles[SelectedTriangle].y[0];
       end;
    1: begin
        Result.x:=MainTriangles[SelectedTriangle].x[1];
        Result.y:=MainTriangles[SelectedTriangle].y[1];
       end;
    2: begin
        Result.x:=MainTriangles[SelectedTriangle].x[2];
        Result.y:=MainTriangles[SelectedTriangle].y[2];
       end;
    3: Result:=Centroid(MainTriangles[SelectedTriangle]);
    else
      Result.x:=0;
      Result.y:=0;
  end;
end;

procedure TEditForm.btTrgRotateLeftClick(Sender: TObject);
var
  offset: double;
begin
  try
    offset := StrToFloat(txtTrgRotateValue.Text);
  except
    offset := 0;
    txtTrgRotateValue.Text := '0';
  end;
  if offset <> 0 then
  begin
    MainForm.UpdateUndo;
    MainTriangles[SelectedTriangle] :=
      RotateTrianglePoint(MainTriangles[SelectedTriangle], GetPivot.x, GetPivot.y, (PI/180)*offset);
    HasChanged := True;
    UpdateFlame(true);
  end;
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
  offset: double;
begin
  try
    offset := StrToFloat(txtTrgRotateValue.Text);
  except
    offset := 0;
    txtTrgRotateValue.Text := '0';
  end;
  if offset <> 0 then
  begin
    MainForm.UpdateUndo;
    MainTriangles[SelectedTriangle] :=
      RotateTrianglePoint(MainTriangles[SelectedTriangle], GetPivot.x, GetPivot.y, -((PI/180) * offset));
    HasChanged := True;
    UpdateFlame(true);
  end;
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
  except
    offset := 0;
    txtTrgMoveValue.Text := '0';
  end;
  if offset <> 0 then
  begin
    MainForm.UpdateUndo;
    for i := 0 to 2 do begin
      MainTriangles[SelectedTriangle].x[i] :=
                    MainTriangles[SelectedTriangle].x[i] + dx*offset;
      MainTriangles[SelectedTriangle].y[i] :=
                    MainTriangles[SelectedTriangle].y[i] + dy*offset;
    end;
    HasChanged := True;
    UpdateFlame(true);
  end;
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
    scale := StrToFloat(txtTrgScaleValue.Text);
  except
    scale := 0.0;
    txtTrgScaleValue.Text := '0.0';
  end;
  if scale <> 0 then
  begin
    MainForm.UpdateUndo;
    MainTriangles[SelectedTriangle] :=
      ScaleTrianglePoint(MainTriangles[SelectedTriangle], GetPivot.x, GetPivot.y, 1.0+scale);
    HasChanged := True;
    UpdateFlame(true);
  end;
end;

procedure TEditForm.btTrgScaleDownClick(Sender: TObject);
var
  scale: double;
begin
  try
    scale := StrToFloat(txtTrgScaleValue.Text);
  except
    scale := 0.0;
    txtTrgScaleValue.Text := '0.0';
  end;
  if scale <> 0 then
  begin
    MainForm.UpdateUndo;
    MainTriangles[SelectedTriangle] :=
      ScaleTrianglePoint(MainTriangles[SelectedTriangle], GetPivot.x, GetPivot.y, 1.0-scale);
    HasChanged := True;
    UpdateFlame(true);
  end;
end;

procedure TEditForm.editKeyDown(Sender: TObject; var Key: Word;
 Shift: TShiftState);
var
  coeff: double;
label goNext;
begin
  //if VEVars.Focused then exit;

  if Shift = [ssShift] then coeff := 10
  else if Shift = [ssCtrl] then coeff := 0.1
  else coeff := 1.0;

//  if (key in [VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN,VK_PRIOR,VK_NEXT,VK_HOME,VK_END]) and
//  if VEVars.Focused = false then
//  if FocusedControl = VEVars then
  if (PageControl.TabIndex <> 2) or    // variations
     (PageControl.TabIndex <> 3) then  // variables
  begin
//    MainForm.UpdateUndo;
    case key of
      VK_LEFT:
        if Shift = [ssAlt] then btTrgRotateLeftClick(Sender)
        else TrgMove(-coeff,0);
      VK_RIGHT:
        if Shift = [ssAlt] then btTrgRotateRightClick(Sender)
        else TrgMove(coeff,0);
      VK_UP:
        if Shift = [ssAlt] then btTrgScaleUpClick(Sender)
        else TrgMove(0,coeff);
      VK_DOWN:
        if Shift = [ssAlt] then btTrgScaleDownClick(Sender)
        else TrgMove(0,-coeff);
      VK_PRIOR: btTrgRotateLeftClick(Sender);
      VK_NEXT: btTrgRotateRightClick(Sender);
      VK_HOME: btTrgScaleUpClick(Sender);
      VK_END: btTrgScaleDownClick(Sender);
      VK_INSERT: mnuDupClick(Sender);
      VK_DELETE: {if Shift = [ssShift] then} mnuDeleteClick(Sender);
      else goto goNext;
    end;
//    HasChanged := True;
    key_handled:=true;
    exit;
  end;

goNext:

  case key of
    VK_ADD:
      if SelectedTriangle < Transforms-1 then begin
        Inc(SelectedTriangle);
        DrawGraph;
        ShowSelectedInfo;
      end;
    VK_SUBTRACT:
      if SelectedTriangle > 0 then begin
        Dec(SelectedTriangle);
        DrawGraph;
        ShowSelectedInfo;
      end;
    VK_SPACE: EditForm.tbSelectClick(Sender);
    Ord('Q'): EditForm.tbEditModeClick(tbMove);
    Ord('W'): EditForm.tbEditModeClick(tbRotate);
    Ord('E'): EditForm.tbEditModeClick(tbScale);

    Ord('A'): PageControl.TabIndex := 0;
    Ord('S'): PageControl.TabIndex := 1;
    Ord('D'): PageControl.TabIndex := 2;
    Ord('F'): PageControl.TabIndex := 3;

    Ord('Z'): EditForm.rgPivot.ItemIndex:=0;
    Ord('X'): EditForm.rgPivot.ItemIndex:=1;
    Ord('C'): EditForm.rgPivot.ItemIndex:=2;
    Ord('V'): EditForm.rgPivot.ItemIndex:=3;
    Ord('B'): EditForm.rgPivot.ItemIndex:=4;
  else
    key_handled := false;
    exit;
  end;
  key := 0;
  key_handled := true;
end;

procedure TEditForm.editKeyPress(Sender: TObject; var Key: Char);
begin
  if key_handled then key := #0
  else if key in ['A'..'z'] then key := #0; // hmmm...
end;

procedure TEditForm.splitterMoved(Sender: TObject);
begin
  UpdateDisplay;
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

  // hack:
  GetCursorPos(MousePos);
  SetCursorPos(MousePos.x, MousePos.y);
end;

procedure TEditForm.editMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if WheelDelta > 0 then GraphZoom := GraphZoom * 1.25
  else GraphZoom := GraphZoom * 0.8;
//  if GraphZoom < 0 the GraphZoom := 0;
  EditForm.StatusBar.Panels[2].Text := Format('Zoom: %f', [GraphZoom]);

  DrawGraph;
  Handled := true;
end;

procedure TEditForm.PreviewImageDblClick(Sender: TObject);
begin
  MainForm.UpdateUndo;
  MainForm.ResetLocation;
  MainForm.RedrawTimer.enabled := true;
  MainForm.UpdateWindows;
end;

procedure TEditForm.rgPivotClicked(Sender: TObject);
begin
  DrawGraph;
end;

{
procedure TEditForm.VEVarsSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  DrawGraph;
end;
}

procedure TEditForm.tbEditModeClick(Sender: TObject);
begin
  if Sender = tbRotate then editMode := modeRotate
  else if Sender = tbScale then editMode := modeScale
  else editMode := modeMove;
  tbMove.Down := (editMode = modeMove);
  tbRotate.Down := (editMode = modeRotate);
  tbScale.Down := (editMode = modeScale);
end;

// --Z-- Value List Editor

procedure TEditForm.VEVarsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  cell: TGridCoord;
begin
  if Button = mbLeft then begin
    cell:=VEVars.MouseCoord(x, y);
    VEVars.Row := cell.Y;
    varDragIndex := cell.Y-1;
    Screen.Cursor := crHSplit;

    GetCursorPos(mousepos); // hmmm

    varDragMode:=true;
    varDragPos:=x;
    SetCaptureControl(VEVars);

    MainForm.UpdateUndo;
  end;
end;

procedure TEditForm.VEVarsMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  v: double;
//  i: integer;
  cell: TGridCoord;
begin
  cell := VEVars.MouseCoord(x, y);
  if (cell.Y > 0) and (cell.X = 0) then VEVars.Cursor := crHandPoint
  else VEVars.Cursor := crDefault;

  if varMM then
  begin
    varMM:=false;
    varDragPos:=x;
  end
  else
  if varDragMode and (x <> varDragPos) then
  begin
//    i := EditForm.VEVars.Row - 1;
    v := cp.xform[SelectedTriangle].vars[varDragIndex];
    v := RoundTo(v + ((x-varDragPos)*2)/1000.0, -3);

    varDragPos:=x;
    SetCursorPos(MousePos.x, MousePos.y); // hmmm
    varMM:=true;

    cp.xform[SelectedTriangle].vars[varDragIndex] := v;
    VEVars.Values[VarNames(varDragIndex)] := Format('%.6g', [v]);

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
      UpdateFlame(true);
      HasChanged := False;
    end;
  end;
end;

procedure TEditForm.VEVarsDblClick(Sender: TObject);
//var
//  i: integer;
begin
  MainForm.UpdateUndo;

//  i := EditForm.VEVars.Row - 1;
  cp.xform[SelectedTriangle].vars[varDragIndex] := 0;
  VEVars.Values[VarNames(varDragIndex)] := '0';
  HasChanged := True;
  UpdateFlameX;
end;

procedure TEditForm.VEVarsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
{
//  if gdFocused in State then
    with eqListBox.Canvas do
  begin
    Brush.Color:=clBlue;
    FillRect(Rect);
  end;
//  VEVars.DrawCell(Sender, ACol, ARow, Rect, State);
}
end;

procedure TEditForm.cbKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  key:=0;
end;

procedure TEditForm.tbFullViewClick(Sender: TObject);
begin
  MainForm.mnuFullScreenClick(Sender);
end;

// --Z-- // transform color scroller

procedure TEditForm.ColorImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    colorDragX:=x;
    colorOldX:=x;
//    BackupPal:=Palette;
    colorDrag:=true;
    colorChanged:=false;
  end;
end;

procedure TEditForm.ColorImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  i, offset: integer;
begin
  if colorDrag and (oldX<>x) then
  begin
    oldX:=x;
    offset := ( ((x - colorDragX) shl 8) div ColorImage.Width ) mod 256;
    colorChanged := true;
{
    for i := 0 to 255 do
    begin
      Palette[i][0] := BackupPal[(255 + i - offset) and $FF][0];
      Palette[i][1] := BackupPal[(255 + i - offset) and $FF][1];
      Palette[i][2] := BackupPal[(255 + i - offset) and $FF][2];
    end;

    cp.CmapIndex := cmbPalette.ItemIndex;
    cp.cmap := Palette;
}
    colorImage.Refresh;
  end;
end;

procedure TEditForm.ColorImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if colorDrag then
  begin
    colorDrag := false;

    if colorChanged then begin
    // MainForm.UpdateUndo;
    // cp.xxx := xxx;
    // MainCP.copy(cp);
    // UpdateXXXX;
    end;
  end;
end;

procedure TEditForm.vleVariablesExit(Sender: TObject);
var
  Allow: boolean;
  i: integer;
  NewVal, OldVal: double;
begin
  Allow := True;

  i := vleVariables.Row;

  cp.xform[SelectedTriangle].GetVariable(vleVariables.Keys[i], OldVal);
  { Test that it's a valid floating point number }
  try
    StrToFloat(vleVariables.Values[vleVariables.Keys[i]]);
  except on Exception do
    begin
    { It's not, so we restore the old value }
      vleVariables.Values[vleVariables.Keys[i]] := Format('%.6g', [OldVal]);
      Allow := False;
    end;
  end;

  NewVal := Round6(StrToFloat(vleVariables.Values[vleVariables.Keys[i]]));
  vleVariables.Values[vleVariables.Keys[i]] := Format('%.6g', [NewVal]);

  { If it's not the same as the old value and it was valid }
  if (NewVal <> OldVal) and Allow then
  begin
    MainForm.UpdateUndo;
    cp.xform[SelectedTriangle].SetVariable(vleVariables.Keys[i], NewVal);
    vleVariables.Values[vleVariables.Keys[i]] := Format('%.6g', [NewVal]);
    ShowSelectedInfo;
    UpdateFlame(True);
  end;
end;

procedure TEditForm.vleVariablesKeyPress(Sender: TObject; var Key: Char);
var
  Allow: boolean;
  i: integer;
  NewVal, OldVal: double;
begin
  if key <> #13 then
    Exit;

  key := #0;

  Allow := True;

  i := vleVariables.Row;

  cp.xform[SelectedTriangle].GetVariable(vleVariables.Keys[i], OldVal);
  { Test that it's a valid floating point number }
  try
    StrToFloat(vleVariables.Values[vleVariables.Keys[i]]);
  except on Exception do
    begin
    { It's not, so we restore the old value }
      vleVariables.Values[vleVariables.Keys[i]] := Format('%.6g', [OldVal]);
      Allow := False;
    end;
  end;

  NewVal := Round6(StrToFloat(vleVariables.Values[vleVariables.Keys[i]]));
  vleVariables.Values[vleVariables.Keys[i]] := Format('%.6g', [NewVal]);

  { If it's not the same as the old value and it was valid }
  if (NewVal <> OldVal) and Allow then
  begin
    MainForm.UpdateUndo;
    cp.xform[SelectedTriangle].SetVariable(vleVariables.Keys[i], NewVal);
    vleVariables.Values[vleVariables.Keys[i]] := Format('%.6g', [NewVal]);
    ShowSelectedInfo;
    UpdateFlame(True);
  end;
end;

procedure TEditForm.vleVariablesValidate(Sender: TObject; ACol, ARow: Integer; const KeyName, KeyValue: string);
var
  Allow: boolean;
  i: integer;
  NewVal, OldVal: double;
begin
  Allow := True;

  i := vleVariables.Row;

  cp.xform[SelectedTriangle].GetVariable(vleVariables.Keys[i], OldVal);
  { Test that it's a valid floating point number }
  try
    StrToFloat(vleVariables.Values[vleVariables.Keys[i]]);
  except on Exception do
    begin
    { It's not, so we restore the old value }
      vleVariables.Values[vleVariables.Keys[i]] := Format('%.6g', [OldVal]);
      Allow := False;
    end;
  end;

  NewVal := Round6(StrToFloat(vleVariables.Values[vleVariables.Keys[i]]));
  vleVariables.Values[vleVariables.Keys[i]] := Format('%.6g', [NewVal]);

  { If it's not the same as the old value and it was valid }
  if (NewVal <> OldVal) and Allow then
  begin
    MainForm.UpdateUndo;
    cp.xform[SelectedTriangle].SetVariable(vleVariables.Keys[i], NewVal);
    vleVariables.Values[vleVariables.Keys[i]] := Format('%.6g', [NewVal]);
    ShowSelectedInfo;
    UpdateFlame(True);
  end;
end;

end.

