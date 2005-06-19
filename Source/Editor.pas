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
  ControlPoint, Render, cmap, Grids, ValEdit, Buttons;

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
    mnuLockSel: TMenuItem;
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
    mnuResetLocation: TMenuItem;
    mnuVerticalFlipAll: TMenuItem;
    N4: TMenuItem;
    mnuHorizintalFlipAll: TMenuItem;
    N5: TMenuItem;
    mnuFlipVertical: TMenuItem;
    mnuFlipHorizontal: TMenuItem;
    cbTransforms: TComboBox;
    N6: TMenuItem;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    XForm: TTabSheet;
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
    TabSheet3: TTabSheet;
    VEVars: TValueListEditor;
    TabSheet2: TTabSheet;
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
    N2: TMenuItem;
    mnuRotateRight: TMenuItem;
    mnuRotateLeft: TMenuItem;
    mnuScaleUp: TMenuItem;
    mnuScaleDown: TMenuItem;
    TriangleScrollBox: TScrollBox;
    TrianglePanel: TPanel;
    txtTrgRotateValue: TEdit;
    txtTrgMoveValue: TEdit;
    txtCy: TEdit;
    txtCx: TEdit;
    txtBy: TEdit;
    txtBx: TEdit;
    txtAy: TEdit;
    txtAx: TEdit;
    Label9: TLabel;
    Label8: TLabel;
    Label7: TLabel;
    Label12: TLabel;
    Label11: TLabel;
    Label10: TLabel;
    chkPreserve: TCheckBox;
    btTrgRotateRight: TSpeedButton;
    btTrgRotateLeft: TSpeedButton;
    btTrgMoveUp: TSpeedButton;
    btTrgMoveRight: TSpeedButton;
    btTrgMoveLeft: TSpeedButton;
    btTrgMoveDown: TSpeedButton;
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
    procedure mnuLockClick(Sender: TObject);
    procedure mnuXFlipClick(Sender: TObject);
    procedure mnuYFlipClick(Sender: TObject);
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
    procedure mnuResetLocationClick(Sender: TObject);
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
    procedure mnuRotateRightClick(Sender: TObject);
    procedure mnuRotateLeftClick(Sender: TObject);
    procedure mnuScaleUpClick(Sender: TObject);
    procedure mnuScaleDownClick(Sender: TObject);
    procedure btTrgRotateLeftClick(Sender: TObject);
    procedure btTrgRotateRightClick(Sender: TObject);
    procedure btTrgMoveLeftClick(Sender: TObject);
    procedure btTrgMoveRightClick(Sender: TObject);
    procedure btTrgMoveUpClick(Sender: TObject);
    procedure btTrgMoveDownClick(Sender: TObject);
  private
    bm: TBitmap;
    cmap: TColorMap;
 //   cp1: TControlPoint;
    PreviewDensity: double;
    procedure UpdateFlame(DrawMain: boolean);
    procedure DeleteTriangle(t: integer);
    procedure UpdateFlameX;
  public
    cp: TControlPoint;
    Render: TRenderer;
    { Options}
    UseFlameBackground, UseTransformColors: boolean;
    BackGroundColor, ReferenceTrianglecolor: integer;
    procedure UpdateDisplay;
    procedure AutoZoom;
    procedure DrawGraph;
  end;

var
  EditForm: TEditForm;
  GraphZoom: double;
  CornerCaught: boolean;
  TriangleCaught: boolean;
  SelectedTriangle: integer;
  SelectedCorner: integer;
  SelLocked: boolean;
  Drawing: boolean;
  HasChanged: boolean;
  oldx, oldy: double;
  intoldx, intoldy: integer;
  clr: array[-1..11] of TColor;
  EditedVariation: integer;
  pcenterx, pcentery, pscale: double;

procedure ShowSelectedInfo;
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
procedure ScaleAll;

implementation

uses
  Main, Global, Adjust, Mutate, Xform;

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

procedure TEditForm.UpdateDisplay;
var
  i: integer;
begin
  cp.copy(MainCp);
  AdjustScale(cp, PreviewImage.Width, PreviewImage.Height);
  cp.cmap := MainCp.cmap;
  cmap := MainCp.cmap;
  cbTransforms.Clear;
  for i := 0 to Transforms - 1 do
    cbTransforms.Items.Add(IntToStr(i + 1));
  AutoZoom;
  ShowSelectedInfo;
  DrawGraph;
  DrawPreview;
end;

procedure TEditForm.DrawPreview;
begin
  //Render.Stop;
  cp.sample_density := PreviewDensity;
  cp.spatial_oversample := defOversample;
  cp.spatial_filter_radius := defFilterRadius;
  if mnuResetLocation.checked then
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

procedure ReadjustWeights(var cp: TControlPoint);
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
  excess := total - 1.0;
  { /* Now we need to fix'em */ }
  for i := 0 to T - 1 do
    if (i <> SelectedTriangle) and (cp.xform[i].density <> 0) then
      cp.xform[i].density := cp.xform[i].density -
        cp.xform[i].density / othertotals * excess;
end;

procedure ShowSelectedInfo;
var
  t: integer;
  i: integer;
  a, b, c, d, e, f: double;
begin
  t := SelectedTriangle;
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
  EditForm.txtXFormColor.Text := FloatToStr(EditForm.cp.xform[t].color);
  EditForm.scrlXFormcolor.Position := Trunc(EditForm.cp.xform[t].color * 100);

  for i := 0 to NRVISVAR-1 do begin
    EditForm.VEVars.Values[VarNames[i]] := Format('%.6g', [EditForm.cp.xform[SelectedTriangle].vars[i]]);
  end;

end;

procedure Scale(var fx, fy: double; x, y, Width, Height: integer);
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
    if mnuResetLocation.checked then begin
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
  for k := 0 to Transforms - 1 do
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

function InTriangle(fx, fy: double): integer;
var
  i, j: integer;
  d: double;
begin
  Result := -2;
  i := InsideTriangle(fx, fy);
  if i > -1 then
    Result := i
  else
    for i := 0 to Transforms - 1 do
      for j := 0 to 2 do
      begin
        d := dist(fx, fy, MainTriangles[i].x[j], MainTriangles[i].y[j]);
        if (d * GraphZoom * 50) < 4 then
          Result := i
      end;
end;

function InsideSelected(x, y: double): boolean;
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

procedure TEditForm.DrawGraph;
var
  i: integer;
  ix, iy, sc: double;
  ax, ay, bx, by, cx, cy: integer;
  Width, Height: integer;
  BitMap: TBitMap;
begin
  if SelectedTriangle >= Transforms then
  begin
    Dec(SelectedTriangle);
    SelLocked := False;
    EditForm.mnuLockSel.Checked := False;
  end;
  BitMap := TBitMap.Create;
  try
    Width := EditForm.GraphImage.Width;
    Height := EditForm.GraphImage.Height;
    BitMap.Width := Width;
    BitMap.Height := Height;
    ix := Width / 2;
    iy := Height / 2;
    sc := 50 * GraphZoom;
    with Bitmap.canvas do
    begin
      if chkFlameBack.checked then
        brush.Color := cp.background[2] shl 16 + cp.background[1] shl 8 + cp.background[0]
      else
        brush.Color := pnlBackColor.Color;
      FillRect(rect(0, 0, Width, Height));
      {Reference Triangle}
      Pen.Width := 1;
      Pen.Style := psDot;
      Pen.color := pnlReference.Color;
      MoveTo(integer(round(ix + MainTriangles[-1].x[0] * sc - gCenterX * sc)), integer(round(iy + (gCentery + -MainTriangles[-1].y[0]) * sc)));
      LineTo(integer(round(ix + MainTriangles[-1].x[1] * sc - gCenterX * sc)), integer(round(iy + (gCentery + -MainTriangles[-1].y[1]) * sc)));
      LineTo(integer(round(ix + MainTriangles[-1].x[2] * sc - gCenterX * sc)), integer(round(iy + (gCentery + -MainTriangles[-1].y[2]) * sc)));
      LineTo(integer(round(ix + MainTriangles[-1].x[0] * sc - gCenterX * sc)), integer(round(iy + (gCentery + -MainTriangles[-1].y[0]) * sc)));
      font.Color := pnlReference.Color;
      TextOut(integer(round(ix + MainTriangles[-1].x[0] * sc - gCenterX * sc)), integer(round(iy + (gCentery + -MainTriangles[-1].y[0]) * sc)), 'A');
      TextOut(integer(round(ix + MainTriangles[-1].x[1] * sc - gCenterX * sc)), integer(round(iy + (gCentery + -MainTriangles[-1].y[1]) * sc)), 'B');
      TextOut(integer(round(ix + MainTriangles[-1].x[2] * sc - gCenterX * sc)), integer(round(iy + (gCentery + -MainTriangles[-1].y[2]) * sc)), 'C');
      {Transforms}
      for i := 0 to Transforms - 1 do
      begin
        ax := integer(round(ix + MainTriangles[i].x[0] * sc - gCenterX * sc));
        ay := integer(round(iy + (gCentery + -MainTriangles[i].y[0]) * sc));
        bx := integer(round(ix + MainTriangles[i].x[1] * sc - gCenterX * sc));
        by := integer(round(iy + (gCentery + -MainTriangles[i].y[1]) * sc));
        cx := integer(round(ix + MainTriangles[i].x[2] * sc - gCenterX * sc));
        cy := integer(round(iy + (gCentery + -MainTriangles[i].y[2]) * sc));
        if chkUseXFormColor.checked then
          pen.color := ColorValToColor(MainCp.cmap, cp.xform[i].color)
        else Pen.color := clr[i mod 12];
        if i = SelectedTriangle then
          Pen.Style := psSolid
        else
          Pen.Style := psDot;
        MoveTo(ax, ay);
        LineTo(bx, by);
        LineTo(cx, cy);
        LineTo(ax, ay);
        Pen.Style := psSolid;
        Ellipse(ax - 4, ay - 4, ax + 4, ay + 4);
        Ellipse(bx - 4, by - 4, bx + 4, by + 4);
        Ellipse(cx - 4, cy - 4, cx + 4, cy + 4);
        Font.color := Pen.color;
        TextOut(ax, ay, 'A');
        TextOut(bx, by, 'B');
        TextOut(cx, cy, 'C');
      end;
    end;
    EditForm.GraphImage.Picture.Graphic := Bitmap;
    EditForm.GraphImage.Refresh;
  finally
    BitMap.Free;
  end;
end;

procedure TEditForm.FormCreate(Sender: TObject);
var
  i: integer;
begin
  for i:= 0 to NRVISVAR - 1 do begin
    VEVars.InsertRow(Varnames[i], '0', True);
  end;

  bm := TBitmap.Create;
  GraphZoom := 1;
  clr[-1] := clGray;
  clr[0] := clYellow1;
  clr[1] := clPlum2;
  clr[2] := clRed;
  clr[3] := clLime;
  clr[4] := clAqua;
  clr[11] := clBlue;
  clr[6] := clMaroon;
  clr[7] := clNavy;
  clr[8] := clOlive;
  clr[9] := clPurple;
  clr[10] := clTeal;
  clr[5] := clGreen;
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
end;

procedure TEditForm.GraphImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: integer);
var
  vx, vy, fx, fy: double;
begin
  Scale(fx, fy, x, y, EditForm.GraphImage.Width, EditForm.GraphImage.Height);
  if inTriangle(fx, fy) >= 0 then
    GraphImage.Cursor := crHandPoint
  else
    GraphImage.Cursor := crArrow;
  StatusBar.Panels[0].Text := Format('X: %f', [fx]);
  StatusBar.Panels[1].Text := Format('Y: %f', [fy]);
  if CornerCaught then
  begin
    { Drag a corner }
    MainTriangles[SelectedTriangle].x[SelectedCorner] := fx;
    MainTriangles[SelectedTriangle].y[SelectedCorner] := fy;
    HasChanged := True;
    UpdateFlameX;
//    UpdateFlame(False);
  end
  else if TriangleCaught then
  begin
    { Drag a whole triangle }
    vx := oldx - fx;
    vy := oldy - fy;
    MainTriangles[SelectedTriangle].x[0] := OldTriangle.x[0] - vx;
    MainTriangles[SelectedTriangle].y[0] := OldTriangle.y[0] - vy;
    MainTriangles[SelectedTriangle].x[1] := OldTriangle.x[1] - vx;
    MainTriangles[SelectedTriangle].y[1] := OldTriangle.y[1] - vy;
    MainTriangles[SelectedTriangle].x[2] := OldTriangle.x[2] - vx;
    MainTriangles[SelectedTriangle].y[2] := OldTriangle.y[2] - vy;
    HasChanged := True;
    UpdateFlameX;

//    UpdateFlame(False);
  end;
end;

procedure TEditForm.GraphImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  d, fx, fy: double;
  i, j: integer;
begin
  intoldx := x;
  intoldy := y;
  CornerCaught := False;
  TriangleCaught := False;
  Scale(fx, fy, x, y, EditForm.GraphImage.Width, EditForm.GraphImage.Height);
  {Has user grabbed a corner?}
  if Button = mbLeft then
  begin
    if SelLocked then
      { Only change the locked triangle}
    begin
      for j := 0 to 2 do
      begin
        d := dist(fx, fy, MainTriangles[SelectedTriangle].x[j], MainTriangles[SelectedTriangle].y[j]);
        if (d * GraphZoom * 50) < 4 then
        begin
          SelectedCorner := j;
          MainForm.UpdateUndo;
          CornerCaught := True;
          oldx := fx;
          oldy := fy;
          Break;
        end;
      end;
    end
    else
      { Find a corner and select triangle }
      for i := 0 to Transforms - 1 do
        for j := 0 to 2 do
        begin
          d := dist(fx, fy, MainTriangles[i].x[j], MainTriangles[i].y[j]);
          if (d * GraphZoom * 50) < 4 then
          begin
            SelectedTriangle := i;
            SelectedCorner := j;
            MainForm.UpdateUndo;
            CornerCaught := True;
            oldx := fx;
            oldy := fy;
            Break;
          end;
        end;
    if CornerCaught then
    begin
      DrawPreview;
      ShowSelectedInfo;
      DrawGraph;
    end
    else
    begin
      if SelLocked then
      begin
        { Only move locked triangle }
        if InsideSelected(fx, fy) then
        begin
          OldTriangle := MainTriangles[SelectedTriangle];
          MainForm.UpdateUndo;
          TriangleCaught := True;
          oldx := fx;
          oldy := fy;
          DrawPreview;
          ShowSelectedInfo;
          DrawGraph;
        end;
      end
      else
      begin
        { Mouse inside a triangle?}
        i := InsideTriangle(fx, fy);
        if i > -1 then
        begin
          SelectedTriangle := i;
          OldTriangle := MainTriangles[i];
          MainForm.UpdateUndo;
          TriangleCaught := True;
          oldx := fx;
          oldy := fy;
          DrawPreview;
          ShowSelectedInfo;
          DrawGraph;
        end;
      end;
    end;
  end;
end;

procedure TEditForm.GraphImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  fx, fy: double;
  i: integer;
begin
  Scale(fx, fy, x, y, EditForm.GraphImage.Width, EditForm.GraphImage.Height);
  { Mouse inside a triangle?}
  i := InsideTriangle(fx, fy);
  if i = -1 then
  begin
    if Button = mbLeft then
      if Shift = [ssCtrl] then
      begin
        AutoZoom;
        ShowSelectedInfo;
        DrawGraph;
      end
  end
  else
  begin
    if SelLocked and (i <> SelectedTriangle) then
    begin
    end
    else if Button = mbLeft then
      if Shift = [ssAlt] then
      begin
        MainTriangles[i] := RotateTriangleCenter(MainTriangles[i], -(PI / 20));
        HasChanged := True;
        UpdateFlame(False);
      end
      else if Shift = [ssCtrl, ssAlt] then
      begin
        MainTriangles[i] := RotateTriangleCenter(MainTriangles[i], PI / 20);
        HasChanged := True;
        UpdateFlame(False);
      end
      else if Shift = [ssShift] then
      begin
        MainTriangles[i] := ScaleTriangleCenter(MainTriangles[i], 1.1);
        HasChanged := True;
        UpdateFlame(False);
      end
      else if Shift = [ssCtrl, ssShift] then
      begin
        MainTriangles[i] := ScaleTriangleCenter(MainTriangles[i], 0.9);
        HasChanged := True;
        UpdateFlame(False);
      end;
  end;
  CornerCaught := False;
  TriangleCaught := False;
  if HasChanged then
  begin
    UpdateFlame(true);
  end;
  HasChanged := False;
end;

procedure TEditForm.mnuRotateRightClick(Sender: TObject);
begin
  MainTriangles[SelectedTriangle] := RotateTriangleCenter(MainTriangles[SelectedTriangle], -(PI / 20));
  HasChanged := True;
  UpdateFlame(true);
end;

procedure TEditForm.mnuRotateLeftClick(Sender: TObject);
begin
  MainTriangles[SelectedTriangle] := RotateTriangleCenter(MainTriangles[SelectedTriangle], PI / 20);
  HasChanged := True;
  UpdateFlame(true);
end;

procedure TEditForm.mnuScaleUpClick(Sender: TObject);
begin
  MainTriangles[SelectedTriangle] := ScaleTriangleCenter(MainTriangles[SelectedTriangle], 1.1);
  HasChanged := True;
  UpdateFlame(true);
end;

procedure TEditForm.mnuScaleDownClick(Sender: TObject);
begin
  MainTriangles[SelectedTriangle] := ScaleTriangleCenter(MainTriangles[SelectedTriangle], 0.9);
  HasChanged := True;
  UpdateFlame(true);
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
      if Registry.ValueExists('UseFlameBackground') then
      begin
        UseFlameBackground := Registry.ReadBool('UseFlameBackground');
      end
      else
      begin
        UseFlameBackground := False;
      end;
      if Registry.ValueExists('BackgroundColor') then
      begin
        BackgroundColor := Registry.ReadInteger('BackgroundColor');
      end
      else
      begin
        BackgroundColor := integer(clBlack);
      end;
      if Registry.ValueExists('ReferenceTriangleColor') then
      begin
        ReferenceTriangleColor := Registry.ReadInteger('ReferenceTriangleColor');
      end
      else
      begin
        ReferenceTriangleColor := integer(clGray);
      end;
    end
    else begin
      UseTransformColors := False;
      UseFlameBackground := False;
      BackgroundColor := integer(clBlack);
      ReferenceTriangleColor := integer(clGray);
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
  chkUseXFormColor.checked := UseTransformColors;
  chkFlameBack.checked := UseFlameBackground;
  pnlBackColor.Color := TColor(BackgroundColor);
  GrphPnl.Color := TColor(BackgroundColor);
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

procedure TEditForm.mnuLockClick(Sender: TObject);
begin
  EditForm.mnuLockSel.Checked := not EditForm.mnuLockSel.Checked;
  SelLocked := EditForm.mnuLockSel.Checked;
end;

procedure TEditForm.mnuXFlipClick(Sender: TObject);
begin
  MainTriangles[SelectedTriangle] := FlipTriangleHorizontal(MainTriangles[SelectedTriangle]);
  UpdateFlame(True);
end;

procedure TEditForm.mnuYFlipClick(Sender: TObject);
begin
  MainTriangles[SelectedTriangle] := FlipTriangleVertical(MainTriangles[SelectedTriangle]);
  UpdateFlame(True);
end;

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
      Registry.WriteInteger('ReferenceTriangleColor', ReferenceTriangleColor);
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
  PreviewDensity := prevLowQuality;
  EditPrevQual := 0;
  DrawPreview;
end;

procedure TEditForm.mnuHighQualityClick(Sender: TObject);
begin
  mnuHighQuality.Checked := True;
  PreviewDensity := prevHighQuality;
  EditPrevQual := 2;
  DrawPreview;
end;

procedure TEditForm.mnuMediumQualityClick(Sender: TObject);
begin
  mnuMediumQuality.Checked := True;
  PreviewDensity := prevMediumQuality;
  EditPrevQual := 1;
  DrawPreview;
end;

procedure TEditForm.mnuResetLocationClick(Sender: TObject);
begin
  mnuResetLocation.Checked := not mnuResetLocation.Checked;
  if not mnuResetLocation.checked then
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
begin
  MainForm.UpdateUndo;
  MainTriangles[SelectedTriangle] := FlipTriangleVertical(MainTriangles[SelectedTriangle]);
  AutoZoom;
  UpdateFlame(True);
end;

procedure TEditForm.mnuFlipHorizontalClick(Sender: TObject);
begin
  MainForm.UpdateUndo;
  MainTriangles[SelectedTriangle] := FlipTriangleHorizontal(MainTriangles[SelectedTriangle]);
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
  cp.xform[SelectedTriangle].color := (scrlXFormColor.Position) / 100;
  txtXFormColor.Text := FloatToStr(cp.xform[SelectedTriangle].color);
  pnlXFormColor.color := ColorValToColor(MainCp.cmap, cp.xform[SelectedTriangle].color);
  DrawGraph;
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

procedure TEditForm.txtXFormColorExit(Sender: TObject);
var
  v: double;
begin
  try
    v := StrToFloat(txtXFormColor.Text);
  except on EConvertError do
    begin
      txtXformColor.text := FLoattoStr(cp.xform[SelectedTriangle].color);
      exit;
    end;
  end;
  if v > 1 then v := 1;
  if v < 0 then v := 0;
  if v <> cp.xform[SelectedTriangle].color then
  begin
    scrlXFormColor.Position := round(v * 100);
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
        txtXformColor.text := FLoattoStr(cp.xform[SelectedTriangle].color);
        exit;
      end;
    end;
    if v > 1 then v := 1;
    if v < 0 then v := 0;
    if v <> cp.xform[SelectedTriangle].color then
    begin
      scrlXFormColor.Position := round(v * 100);
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
      StrToFloat(VEVars.Values[VarNames[i]]);
    except on Exception do
      begin
      { It's not, so we restore the old value }
        VEVars.Values[VarNames[i]] := Format('%.6g', [OldVal]);
        Allow := False;
      end;
    end;
    NewVal := Round6(StrToFloat(VEVars.Values[VarNames[i]]));
//    if NewVal < 0 then NewVal := 0;
    VEVars.Values[VarNames[i]] := Format('%.6g', [NewVal]);

  { If it's not the same as the old value and it was valid }
    if (NewVal <> OldVal) and Allow then
    begin
      MainForm.UpdateUndo;
      EditedVariation := i;
      cp.xform[SelectedTriangle].vars[i] := NewVal;
//      VarNormalize(cp);
      VEVars.Values[VarNames[i]] := Format('%.6g', [cp.xform[SelectedTriangle].vars[i]]);
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
    StrToFloat(VEVars.Values[VarNames[i]]);
  except on Exception do
    begin
    { It's not, so we restore the old value }
      VEVars.Values[VarNames[i]] := Format('%.6g', [OldVal]);
      Allow := False;
    end;
  end;
  NewVal := Round6(StrToFloat(VEVars.Values[VarNames[i]]));
//    if NewVal < 0 then NewVal := 0;
  VEVars.Values[VarNames[i]] := Format('%.6g', [NewVal]);

{ If it's not the same as the old value and it was valid }
  if (NewVal <> OldVal) and Allow then
  begin
    MainForm.UpdateUndo;
    EditedVariation := i;
    cp.xform[SelectedTriangle].vars[i] := NewVal;
//      VarNormalize(cp);
    VEVars.Values[VarNames[i]] := Format('%.6g', [cp.xform[SelectedTriangle].vars[i]]);
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
    StrToFloat(VEVars.Values[VarNames[i]]);
  except on Exception do
    begin
    { It's not, so we restore the old value }
      VEVars.Values[VarNames[i]] := Format('%.6g', [OldVal]);
      Allow := False;
    end;
  end;
  NewVal := Round6(StrToFloat(VEVars.Values[VarNames[i]]));
//    if NewVal < 0 then NewVal := 0;
  VEVars.Values[VarNames[i]] := Format('%.6g', [NewVal]);

{ If it's not the same as the old value and it was valid }
  if (NewVal <> OldVal) and Allow then
  begin
    MainForm.UpdateUndo;
    EditedVariation := i;
    cp.xform[SelectedTriangle].vars[i] := NewVal;
//      VarNormalize(cp);
    VEVars.Values[VarNames[i]] := Format('%.6g', [cp.xform[SelectedTriangle].vars[i]]);
    ShowSelectedInfo;
    UpdateFlame(True);
  end;
end;

{ **************************************************************************** }

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
    MainTriangles[SelectedTriangle] := RotateTriangleCenter(MainTriangles[SelectedTriangle], (PI/180) * offset);    HasChanged := True;
    UpdateFlame(true);
  end;
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
    MainTriangles[SelectedTriangle] := RotateTriangleCenter(MainTriangles[SelectedTriangle], -((PI/180) * offset));
    HasChanged := True;
    UpdateFlame(true);
  end;
end;

procedure TEditForm.btTrgMoveLeftClick(Sender: TObject);
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
    for i := 0 to 2 do
      MainTriangles[SelectedTriangle].x[i] :=
                    MainTriangles[SelectedTriangle].x[i] - offset;
    HasChanged := True;
    UpdateFlame(true);
  end;
end;

procedure TEditForm.btTrgMoveRightClick(Sender: TObject);
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
    for i := 0 to 2 do
      MainTriangles[SelectedTriangle].x[i] :=
                    MainTriangles[SelectedTriangle].x[i] + offset;
    HasChanged := True;
    UpdateFlame(true);
  end;
end;

procedure TEditForm.btTrgMoveUpClick(Sender: TObject);
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
    for i := 0 to 2 do
      MainTriangles[SelectedTriangle].y[i] :=
                    MainTriangles[SelectedTriangle].y[i] + offset;
    HasChanged := True;
    UpdateFlame(true);
  end;
end;

procedure TEditForm.btTrgMoveDownClick(Sender: TObject);
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
    for i := 0 to 2 do
      MainTriangles[SelectedTriangle].y[i] :=
                    MainTriangles[SelectedTriangle].y[i] - offset;
    HasChanged := True;
    UpdateFlame(true);
  end;
end;

end.

