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
unit Adjust;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ControlPoint, Render, Buttons, Menus, cmap;

const
  WM_UPDATE_PARAMS = WM_APP + 5439;

type
  TAdjustForm = class(TForm)
    QualityPopup: TPopupMenu;
    mnuLowQuality: TMenuItem;
    mnuMediumQuality: TMenuItem;
    mnuHighQuality: TMenuItem;
    ColorDialog: TColorDialog;
    PrevPnl: TPanel;
    PreviewImage: TImage;
    GroupBox1: TGroupBox;
    Label8: TLabel;
    scrollGamma: TScrollBar;
    txtGamma: TEdit;
    Label9: TLabel;
    scrollBrightness: TScrollBar;
    txtBrightness: TEdit;
    Label10: TLabel;
    scrollVibrancy: TScrollBar;
    txtVibrancy: TEdit;
    lblContrast: TLabel;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    scrollZoom: TScrollBar;
    txtZoom: TEdit;
    Label6: TLabel;
    scrollCenterX: TScrollBar;
    txtCenterX: TEdit;
    scrollCenterY: TScrollBar;
    txtCenterY: TEdit;
    Label1: TLabel;
    ColorPanel: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure DrawPreview;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCanelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnuLowQualityClick(Sender: TObject);
    procedure mnuMediumQualityClick(Sender: TObject);
    procedure mnuHighQualityClick(Sender: TObject);
    procedure txtZoomKeyPress(Sender: TObject; var Key: Char);
    procedure txtZoomExit(Sender: TObject);
    procedure txtCenterXKeyPress(Sender: TObject; var Key: Char);
    procedure txtCenterXExit(Sender: TObject);
    procedure txtCenterYKeyPress(Sender: TObject; var Key: Char);
    procedure txtCenterYExit(Sender: TObject);
    procedure txtGammaKeyPress(Sender: TObject; var Key: Char);
    procedure txtGammaExit(Sender: TObject);
    procedure txtBrightnessKeyPress(Sender: TObject; var Key: Char);
    procedure txtBrightnessExit(Sender: TObject);
    procedure txtVibrancyKeyPress(Sender: TObject; var Key: Char);
    procedure txtVibrancyExit(Sender: TObject);
    procedure scrollZoomScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure scrollCenterXScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure scrollCenterYScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure scrollGammaScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure scrollBrightnessScroll(Sender: TObject;
      ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure scrollVibrancyScroll(Sender: TObject;
      ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure scrollVibrancyChange(Sender: TObject);
    procedure scrollGammaChange(Sender: TObject);
    procedure scrollBrightnessChange(Sender: TObject);
    procedure scrollZoomChange(Sender: TObject);
    procedure scrollCenterXChange(Sender: TObject);
    procedure scrollCenterYChange(Sender: TObject);
    procedure ColorPanelClick(Sender: TObject);
    procedure scrollContrastScroll(Sender: TObject;
      ScrollCode: TScrollCode; var ScrollPos: Integer);
  private
    Resetting: boolean;
    Render: TRenderer;
    bm: TBitmap;
  public
    PreviewDensity: double;
    cp: TControlPoint;
//    cmap: TColorMap;
//    Sample_Density, Zoom: double;
//    Center: array[0..1] of double;
    procedure UpdateDisplay;
    procedure UpdateFlame;
  end;

var
  AdjustForm: TAdjustForm;

implementation

uses Main, Global, Registry, Mutate, Editor;

{$R *.DFM}

procedure TAdjustForm.UpdateDisplay;
var
  pw, ph: integer;
  r: double;
begin
  pw := PrevPnl.Width - 2;
  ph := PrevPnl.Height - 2;
  cp.copy(MainCp);
  if cp.width > cp.height then
  begin
    PreviewImage.Width := pw;
    r := cp.width / PreviewImage.Width;
    PreviewImage.height := round(cp.height / r);
    PreviewImage.Left := 1;
    PreviewImage.Top := (ph - PreviewImage.Height) div 2;
  end
  else
  begin
    PreviewImage.Height := ph;
    r := cp.height / PreviewImage.height;
    PreviewImage.Width := round(cp.Width / r);
    PreviewImage.Top := 1;
    PreviewImage.Left := (pw - PreviewImage.Width) div 2;
  end;
  cp.cmap := MainCp.cmap;
  AdjustScale(cp, PreviewImage.Width, PreviewImage.Height);
//  zoom := MainForm.zoom;
//  cp.zoom := zoom;
  Resetting := True; // So the preview doesn't get drawn with these changes..
  scrollGamma.Position := trunc(cp.Gamma * 100);
  scrollBrightness.Position := trunc(cp.Brightness * 100);
  scrollVibrancy.Position := trunc(cp.vibrancy * 100);
  scrollZoom.Position := trunc(cp.zoom * 100);
  if (abs(cp.Center[0]) < 1000) and (abs(cp.Center[1]) < 1000) then begin
    scrollCenterX.Position := trunc(cp.Center[0] * 100);
    scrollCenterY.Position := trunc(cp.Center[1] * 100);
  end else begin
    scrollCenterX.Position := 0;
    scrollCenterY.Position := 0;
  end;
  ColorPanel.color := cp.background[2] shl 16 +
    cp.background[1] shl 8 + cp.background[0];
  Resetting := False;
  DrawPreview;
end;

procedure TAdjustForm.UpdateFlame;
begin
  MainForm.StopThread;
  MainForm.UpdateUndo;
  MainCp.Copy(cp);
//  MainCp.cmap := cmap;
//  MainForm.zoom := zoom;
//  MainForm.Center[0] := Center[0];
//  MainForm.Center[1] := Center[1];
  if EditForm.Visible then EditForm.UpdateDisplay;
  if MutateForm.Visible then MutateForm.UpdateDisplay;
  MainForm.RedrawTimer.enabled := true;
end;

procedure TAdjustForm.DrawPreview;
begin
  if not Resetting then begin
    Render.Stop;
//    AdjustScale(cp, PreviewImage.Width, PreviewImage.Height);
    cp.sample_density := PreviewDensity;
    cp.spatial_oversample := defOversample;
    cp.spatial_filter_radius := defFilterRadius;
//    cp.Zoom := Zoom;
//    cp.center[0] := Center[0];
//    cp.center[1] := Center[1];
    Render.Compatibility := compatibility;
    Render.SetCP(cp);
    Render.Render;
    BM.Assign(Render.GetImage);
    PreviewImage.Picture.Graphic := bm;
  end;
end;

procedure TAdjustForm.FormCreate(Sender: TObject);
begin
  bm := TbitMap.Create;
  cp := TControlPoint.Create;
  Render := TRenderer.Create;
  case AdjustPrevQual of
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
end;

procedure TAdjustForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Registry: TRegistry;
begin
  Render.Stop;
  { Write position to registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('\Software\' + APP_NAME + '\Forms\Adjust', True) then
    begin
      Registry.WriteInteger('Top', AdjustForm.Top);
      Registry.WriteInteger('Left', AdjustForm.Left);
    end;
  finally
    Registry.Free;
  end;
//  bStop := True;
end;

procedure TAdjustForm.FormDestroy(Sender: TObject);
begin
  bm.free;
  cp.free;
  Render.free;
end;

procedure TAdjustForm.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TAdjustForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TAdjustForm.btnCanelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TAdjustForm.FormShow(Sender: TObject);
var
  Registry: TRegistry;
begin
  if LimitVibrancy then scrollVibrancy.Max := 100 else scrollVibrancy.Max := 300;
  { Read posution from registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('Software\' + APP_NAME + '\Forms\Adjust', False) then
    begin
      if Registry.ValueExists('Left') then
        AdjustForm.Left := Registry.ReadInteger('Left');
      if Registry.ValueExists('Top') then
        AdjustForm.Top := Registry.ReadInteger('Top');
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

procedure TAdjustForm.mnuLowQualityClick(Sender: TObject);
begin
  mnuLowQuality.Checked := True;
  PreviewDensity := prevLowQuality;
  AdjustPrevQual := 0;
  DrawPreview;
end;

procedure TAdjustForm.mnuMediumQualityClick(Sender: TObject);
begin
  mnuMediumQuality.Checked := True;
  PreviewDensity := prevMediumQuality;
  AdjustPrevQual := 1;
  DrawPreview;
end;

procedure TAdjustForm.mnuHighQualityClick(Sender: TObject);
begin
  mnuHighQuality.Checked := True;
  PreviewDensity := prevHighQuality;
  AdjustPrevQual := 2;
  DrawPreview;
end;

procedure TAdjustForm.txtZoomKeyPress(Sender: TObject; var Key: Char);
var v: integer;
begin
  if key = #13 then
  begin
    key := #0;
    try
      v := Trunc(StrToFloat(txtZoom.Text) * 100);
      if v > scrollZoom.Max then v := scrollZoom.Max;
      if v < scrollZoom.Min then v := scrollZoom.Min;
      if v <> ScrollZoom.Position then begin
        ScrollZoom.Position := v;
        UpdateFlame;
      end;
    except on EConvertError do
    end;
  end;
end;

procedure TAdjustForm.txtZoomExit(Sender: TObject);
var
  v: integer;
begin
  try
    v := Trunc(StrToFloat(txtZoom.Text) * 100);
    if v > scrollZoom.Max then v := scrollZoom.Max;
    if v < scrollZoom.Min then v := scrollZoom.Min;
    if v <> ScrollZoom.Position then begin
      ScrollZoom.Position := v;
      UpdateFlame;
    end;
  except on EConvertError do
      txtZoom.Text := FloatToStr(cp.zoom)
  end;
end;

procedure TAdjustForm.txtCenterXKeyPress(Sender: TObject; var Key: Char);
var
  v: integer;
begin
  if key = #13 then
  begin
    key := #0;
    try
      v := Trunc(StrToFloat(txtCenterX.Text) * 100);
      if v > scrollCenterX.Max then v := scrollCenterX.Max;
      if v < scrollCenterX.Min then v := scrollCenterX.Min;
      ScrollCenterX.Position := v;
    except on EConvertError do
    end;
  end;
end;

procedure TAdjustForm.txtCenterXExit(Sender: TObject);
var
  v: integer;
begin
  try
    v := Trunc(StrToFloat(txtCenterX.Text) * 100);
    if v > scrollCenterX.Max then v := scrollCenterX.Max;
    if v < scrollCenterX.Min then v := scrollCenterX.Min;
    ScrollCenterX.Position := v;
    UpdateFlame;
  except on EConvertError do
      txtCenterX.Text := FloatToStr(cp.center[0]);
  end;
end;

procedure TAdjustForm.txtCenterYKeyPress(Sender: TObject; var Key: Char);
var
  v: integer;
begin
  if key = #13 then
  begin
    key := #0;
    try
      v := Trunc(StrToFloat(txtCenterY.Text) * 100);
      if v > ScrollCenterY.Max then v := ScrollCenterY.Max;
      if v < ScrollCenterY.Min then v := ScrollCenterY.Min;
      ScrollCenterY.Position := v;
      UpdateFlame;
    except on EConvertError do
    end;
  end;
end;

procedure TAdjustForm.txtCenterYExit(Sender: TObject);
var
  v: integer;
begin
  try
    v := Trunc(StrToFloat(txtCenterY.Text) * 100);
    if v > ScrollCenterY.Max then v := ScrollCenterY.Max;
    if v < ScrollCenterY.Min then v := ScrollCenterY.Min;
    ScrollCenterY.Position := v;
    UpdateFlame;
  except on EConvertError do
      txtCenterY.Text := FloatToStr(cp.center[1]);
  end;
end;

procedure TAdjustForm.txtGammaExit(Sender: TObject);
var
  v: integer;
begin
  try
    v := Trunc(StrToFloat(txtGamma.Text) * 100);
    if v > scrollGamma.Max then v := scrollGamma.Max;
    if v < scrollGamma.Min then v := scrollGamma.Min;
    ScrollGamma.Position := v;
    UpdateFlame;
  except on EConvertError do
      txtGamma.Text := FloatToStr(cp.gamma);
  end;
end;

procedure TAdjustForm.txtGammaKeyPress(Sender: TObject; var Key: Char);
var
  v: integer;
begin
  if key = #13 then
  begin
    key := #0;
    try
      v := Trunc(StrToFloat(txtGamma.Text) * 100);
      if v > scrollGamma.Max then v := scrollGamma.Max;
      if v < scrollGamma.Min then v := scrollGamma.Min;
      ScrollGamma.Position := v;
      UpdateFlame;
    except on EConvertError do
    end;
  end;
end;

procedure TAdjustForm.txtBrightnessExit(Sender: TObject);
var
  v: integer;
begin
  try
    v := Trunc(StrToFloat(txtBrightness.Text) * 100);
    if v > scrollBrightness.Max then v := scrollBrightness.Max;
    if v < scrollBrightness.Min then v := scrollBrightness.Min;
    ScrollBrightness.Position := v;
    UpdateFlame;
  except on EConvertError do
      txtBrightness.Text := FloatToStr(cp.brightness);
  end;
end;

procedure TAdjustForm.txtBrightnessKeyPress(Sender: TObject;
  var Key: Char);
var
  v: integer;
begin
  if key = #13 then
  begin
    key := #0;
    try
      v := Trunc(StrToFloat(txtBrightness.Text) * 100);
      if v > scrollBrightness.Max then v := scrollBrightness.Max;
      if v < scrollBrightness.Min then v := scrollBrightness.Min;
      ScrollBrightness.Position := v;
      UpdateFlame;
    except on EConvertError do
    end;
  end;
end;

procedure TAdjustForm.txtVibrancyKeyPress(Sender: TObject; var Key: Char);
var
  v: integer;
begin
  if key = #13 then
  begin
    key := #0;
    try
      v := Trunc(StrToFloat(txtVibrancy.Text) * 100);
      if v > scrollVibrancy.Max then v := scrollVibrancy.Max;
      if v < scrollVibrancy.Min then v := scrollVibrancy.Min;
      ScrollVibrancy.Position := v;
      UpdateFlame;
    except on EConvertError do
    end;
  end;
end;

procedure TAdjustForm.txtVibrancyExit(Sender: TObject);
var
  v: integer;
begin
  try
    v := Trunc(StrToFloat(txtVibrancy.Text) * 100);
    if v > scrollVibrancy.Max then v := scrollVibrancy.Max;
    if v < scrollVibrancy.Min then v := scrollVibrancy.Min;
    ScrollVibrancy.Position := v;
    UpdateFlame;
  except on EConvertError do
      txtVibrancy.Text := FloatToStr(cp.Vibrancy);
  end;
end;

procedure TAdjustForm.scrollZoomScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if ScrollCode = scEndScroll then UpdateFlame;
end;

procedure TAdjustForm.scrollCenterXScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if ScrollCode = scEndScroll then UpdateFlame;
end;

procedure TAdjustForm.scrollCenterYScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if ScrollCode = scEndScroll then UpdateFlame;
end;

procedure TAdjustForm.scrollGammaScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if ScrollCode = scEndScroll then UpdateFlame;
end;

procedure TAdjustForm.scrollBrightnessScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if ScrollCode = scEndScroll then UpdateFlame;
end;

procedure TAdjustForm.scrollVibrancyScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if ScrollCode = scEndScroll then UpdateFlame;
end;

procedure TAdjustForm.scrollVibrancyChange(Sender: TObject);
begin
  cp.Vibrancy := ScrollVibrancy.Position / 100;
  txtVibrancy.text := FloatToStr(cp.Vibrancy);
  DrawPreview;
end;

procedure TAdjustForm.scrollGammaChange(Sender: TObject);
begin
  cp.Gamma := scrollGamma.Position / 100;
  txtGamma.text := FloatToStr(cp.Gamma);
  DrawPreview;
end;

procedure TAdjustForm.scrollBrightnessChange(Sender: TObject);
begin
  cp.Brightness := ScrollBrightness.Position / 100;
  txtBrightness.text := FloatToStr(cp.Brightness);
  DrawPreview;
end;

procedure TAdjustForm.scrollZoomChange(Sender: TObject);
begin
  cp.zoom := scrollZoom.Position / 100;
  txtZoom.text := FloatToStr(cp.zoom);
  DrawPreview;
end;

procedure TAdjustForm.scrollCenterXChange(Sender: TObject);
begin
  cp.center[0] := scrollCenterX.Position / 100;
  txtCenterX.text := FloatToStr(cp.center[0]);
  DrawPreview;
end;

procedure TAdjustForm.scrollCenterYChange(Sender: TObject);
begin
  cp.center[1] := scrollCenterY.Position / 100;
  txtCentery.text := FloatToStr(cp.center[1]);
  DrawPreview;
end;

procedure TAdjustForm.ColorPanelClick(Sender: TObject);
var
  col: Longint;
begin
  ColorDialog.Color := COlorPanel.Color;
  if ColorDialog.Execute then
  begin
    ColorPanel.Color := ColorDialog.Color;
    col := ColorToRGB(ColorDialog.Color);
    cp.background[0] := col and 255;
    cp.background[1] := col shr 8 and 255;
    cp.background[2] := col shr 16 and 255;
    DrawPreview;
    UpdateFlame;
  end;
end;

procedure TAdjustForm.scrollContrastScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if ScrollCode = scEndScroll then UpdateFlame;
end;

end.

