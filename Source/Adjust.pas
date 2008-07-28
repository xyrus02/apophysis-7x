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
unit Adjust;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons, Menus, AppEvnts,
  ControlPoint, Cmap, Render;

const
  WM_UPDATE_PARAMS = WM_APP + 5439;

const
  PixelCountMax = 32768;

type
  pRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = array[0..PixelCountMax - 1] of TRGBTriple;

type
  TAdjustForm = class(TForm)
    QualityPopup: TPopupMenu;
    mnuLowQuality: TMenuItem;
    mnuMediumQuality: TMenuItem;
    mnuHighQuality: TMenuItem;
    ColorDialog: TColorDialog;
    PrevPnl: TPanel;
    PreviewImage: TImage;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    scrollZoom: TScrollBar;
    txtZoom: TEdit;
    scrollCenterX: TScrollBar;
    txtCenterX: TEdit;
    scrollCenterY: TScrollBar;
    txtCenterY: TEdit;
    TabSheet2: TTabSheet;
    lblContrast: TLabel;
    scrollGamma: TScrollBar;
    txtGamma: TEdit;
    scrollBrightness: TScrollBar;
    txtBrightness: TEdit;
    scrollVibrancy: TScrollBar;
    txtVibrancy: TEdit;
    ColorPanel: TPanel;
    TabSheet3: TTabSheet;
    scrollAngle: TScrollBar;
    txtAngle: TEdit;
    GradientPnl: TPanel;
    GradientImage: TImage;
    lblVal: TLabel;
    ScrollBar: TScrollBar;
    btnMenu: TSpeedButton;
    btnOpen: TSpeedButton;
    btnSmoothPalette: TSpeedButton;
    btnPaste: TSpeedButton;
    btnCopy: TSpeedButton;
    cmbPalette: TComboBox;
    GradientPopup: TPopupMenu;
    mnuRandomize: TMenuItem;
    N7: TMenuItem;
    mnuInvert: TMenuItem;
    mnuReverse: TMenuItem;
    N3: TMenuItem;
    mnuSmoothPalette: TMenuItem;
    mnuGradientBrowser: TMenuItem;
    N4: TMenuItem;
    SaveGradient1: TMenuItem;
    SaveasMapfile1: TMenuItem;
    N6: TMenuItem;
    mnuSaveasDefault: TMenuItem;
    N5: TMenuItem;
    mnuCopy: TMenuItem;
    mnuPaste: TMenuItem;
    scrollModePopup: TPopupMenu;
    mnuRotate: TMenuItem;
    N1: TMenuItem;
    mnuHue: TMenuItem;
    mnuSaturation: TMenuItem;
    mnuBrightness: TMenuItem;
    Contrast1: TMenuItem;
    N2: TMenuItem;
    mnuBlur: TMenuItem;
    mnuFrequency: TMenuItem;
    SaveDialog: TSaveDialog;
    ApplicationEvents: TApplicationEvents;
    lblOffset: TLabel;
    TabSheet4: TTabSheet;
    btnPreset1: TButton;
    btnPreset2: TButton;
    btnPreset3: TButton;
    btnSet1: TButton;
    btnSet2: TButton;
    btnSet3: TButton;
    btnUndo: TSpeedButton;
    btnRedo: TSpeedButton;
    chkTransparent: TCheckBox;
    btnColorPreset: TSpeedButton;
    Bevel1: TBevel;
    btnApplySize: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    chkMaintain: TCheckBox;
    txtWidth: TComboBox;
    txtHeight: TComboBox;
    Bevel2: TBevel;
    N8: TMenuItem;
    mnuInstantPreview: TMenuItem;
    pnlZoom: TPanel;
    pnlXpos: TPanel;
    pnlYpos: TPanel;
    pnlAngle: TPanel;
    pnlGamma: TPanel;
    pnlBrightness: TPanel;
    pnlVibrancy: TPanel;
    chkResizeMain: TCheckBox;
    Bevel3: TBevel;
    pnlMasterScale: TPanel;
    editPPU: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure DrawPreview;
//    procedure btnOKClick(Sender: TObject);
//    procedure btnCancelClick(Sender: TObject);
//    procedure btnCanelClick(Sender: TObject);
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
    procedure txtGammaEnter(Sender: TObject);
    procedure txtBrightnessEnter(Sender: TObject);
    procedure txtVibrancyEnter(Sender: TObject);
    procedure txtZoomEnter(Sender: TObject);
    procedure txtCenterXEnter(Sender: TObject);
    procedure txtCenterYEnter(Sender: TObject);
    procedure scrollAngleChange(Sender: TObject);
    procedure scrollAngleScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure txtAngleEnter(Sender: TObject);
    procedure txtAngleExit(Sender: TObject);
    procedure txtAngleKeyPress(Sender: TObject; var Key: Char);

    // --Z-- // gradient functions
    procedure cmbPaletteChange(Sender: TObject);
//    procedure DrawPalette;
    procedure mnuReverseClick(Sender: TObject);
    procedure mnuInvertClick(Sender: TObject);
    procedure btnMenuClick(Sender: TObject);
    procedure mnuRotateClick(Sender: TObject);
    procedure mnuHueClick(Sender: TObject);
    procedure mnuSaturationClick(Sender: TObject);
    procedure ScrollBarChange(Sender: TObject);
    procedure mnuBrightnessClick(Sender: TObject);
    procedure mnuBlurClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure mnuSmoothPaletteClick(Sender: TObject);
    procedure SaveGradient1Click(Sender: TObject);
    procedure SaveasMapfile1Click(Sender: TObject);
    procedure cmbPaletteDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure btnCopyClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure ApplicationEventsActivate(Sender: TObject);
    procedure mnuSaveasDefaultClick(Sender: TObject);
    procedure mnuRandomizeClick(Sender: TObject);
    procedure mnuFrequencyClick(Sender: TObject);
    procedure mnuContrastClick(Sender: TObject);

    procedure GradImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GradImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure GradImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure btnSet1Click(Sender: TObject);
    procedure btnSet2Click(Sender: TObject);
    procedure btnSet3Click(Sender: TObject);
    procedure btnPreset1Click(Sender: TObject);
    procedure btnPreset2Click(Sender: TObject);
    procedure btnPreset3Click(Sender: TObject);
    procedure txtWidthChange(Sender: TObject);
    procedure txtHeightChange(Sender: TObject);
    procedure txtSizeKeyPress(Sender: TObject; var Key: Char);
    procedure chkMaintainClick(Sender: TObject);
    procedure SetMainWindowSize;
    procedure GetMainWindowSize;
    procedure btnUndoClick(Sender: TObject);
    procedure btnRedoClick(Sender: TObject);
    procedure GradientImageDblClick(Sender: TObject);
    procedure btnColorPresetClick(Sender: TObject);
    procedure btnApplySizeClick(Sender: TObject);
    procedure mnuInstantPreviewClick(Sender: TObject);
    procedure editPPUKeyPress(Sender: TObject; var Key: Char);
    procedure editPPUValidate(Sender: TObject);

    procedure DragPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DragPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DragPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DragPanelDblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);

    procedure PreviewImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PreviewImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PreviewImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PreviewImageDblClick(Sender: TObject);

  private
    Resetting: boolean;
    Render: TRenderer;
    bm: TBitmap;
    EditBoxValue: string;

    cp: TControlPoint;

    pnlDragMode, pnlDragged, pnlMM: boolean;
    pnlDragPos, pnlDragOld: integer;
    pnlDragValue: double;
    mousepos: TPoint;

    camDragMode, camDragged, camMM: boolean;
    camDragPos, camDragOld: TPoint;
    camDragValueX, camDragValueY, camSin, camCos: double;

  private // gradient stuff
    Palette, BackupPal: TColorMap;
    tmpBackupPal: TColorMap;

    scrollMode: (modeRotate,
                 modeHue, modeSaturation, modeBrightness, modeContrast,
                 modeBlur, modeFrequency);
    GradientChanged: boolean;
    imgDragMode: (imgDragNone, imgDragRotate, imgDragStretch);
    dragX, oldX: integer;
    oldpos, offset: integer; // for display...? :-\

    procedure Apply;
    function Blur(const radius: integer; const pal: TColorMap): TColorMap;
    function Frequency(const times: Integer; const pal: TColorMap): TColorMap;
    procedure SaveMap(FileName: string);

    procedure UpdateGradient(Pal: TColorMap);

  private // image size stuff
    ImageHeight, ImageWidth: integer;
    Preset: array[1..3] of record
      Left, Top, Width, Height: integer;
    end;
    ratio: double;

    procedure ReadPreset(n: integer);
    procedure WritePreset(n: integer);
    function PresetToStr(n: integer): string;

  public
    PreviewDensity: double;

//    cmap: TColorMap;
//    Sample_Density, Zoom: double;
//    Center: array[0..1] of double;
    procedure UpdateDisplay(PreviewOnly: boolean = false);
    procedure UpdateFlame(bBgOnly: boolean = false);

  end;

var
  AdjustForm: TAdjustForm;

function GradientInClipboard: boolean;
procedure RGBToHSV(R, G, B: byte; var H, S, V: real);
procedure HSVToRGB(H, S, V: real; var Rb, Gb, Bb: integer);

implementation

//uses Main, Global, Registry, Mutate, Editor, Save, Browser;
uses
  RndFlame, Main, cmapdata, Math, Browser, Editor, Global,
  Save, Mutate, ClipBrd, GradientHlpr, Registry;

{$R *.DFM}

procedure TAdjustForm.UpdateDisplay(PreviewOnly: boolean = false);
var
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
  cp.AdjustScale(PreviewImage.Width, PreviewImage.Height);

  cp.cmap := MainCp.cmap;

  if not PreviewOnly then begin //***

//  zoom := MainForm.zoom;
//  cp.zoom := zoom;
    Resetting := True; // So the preview doesn't get drawn with these changes..
    scrollGamma.Position := trunc(cp.Gamma * 100);
    scrollBrightness.Position := trunc(cp.Brightness * 100);
    scrollVibrancy.Position := trunc(cp.vibrancy * 100);
    scrollZoom.Position := trunc(cp.zoom * 1000);
//  ScrollAngle.Position := Trunc(cp.FAngle * 18000.0 / PI) mod scrollAngle.Max;
    scrollAngle.Position := Trunc(cp.FAngle * 18000.0 / PI) mod 36000;

    if (abs(cp.Center[0]) < 1000) and (abs(cp.Center[1]) < 1000) then begin
      scrollCenterX.Position := trunc(cp.Center[0] * 1000);
      scrollCenterY.Position := trunc(cp.Center[1] * 1000);
    end else begin
      scrollCenterX.Position := 0;
      scrollCenterY.Position := 0;
    end;

    ColorPanel.color := cp.background[2] shl 16 + cp.background[1] shl 8 + cp.background[0];
    //cbColor.text := IntToHex(integer(ColorPanel.Color), 6);

    GetMainWindowSize;

    // gradient
    if cp.cmapindex >= 0 then
      cmbPalette.ItemIndex := cp.cmapindex;
    ScrollBar.Position := 0;
    Palette := cp.cmap;
    BackupPal := cp.cmap;

    Resetting := False;
    editPPU.Text := Format('%.6g', [100*cp.pixels_per_unit/PreviewImage.Width]);
  end; //***
  DrawPreview;
end;

procedure TAdjustForm.UpdateFlame(bBgOnly: boolean = false);
begin
  if not bBgOnly then
    MainForm.StopThread;
  MainForm.UpdateUndo;
  MainCp.Copy(cp, true);
  if EditForm.Visible then EditForm.UpdateDisplay;
  if MutateForm.Visible then MutateForm.UpdateDisplay;
  if bBgOnly then
    MainForm.tbShowAlphaClick(Self)
  else
    MainForm.RedrawTimer.enabled := true;
end;

procedure TAdjustForm.DrawPreview;
var
  i: integer;
  Row: pRGBTripleArray;
  BitMap: TBitMap;
begin
  if Resetting then exit;

  Render.Stop;
//  AdjustScale(cp, PreviewImage.Width, PreviewImage.Height);
  cp.sample_density := PreviewDensity;
  cp.spatial_oversample := defOversample;
  cp.spatial_filter_radius := defFilterRadius;
//  cp.Zoom := Zoom;
//  cp.center[0] := Center[0];
//  cp.center[1] := Center[1];
//  Render.Compatibility := compatibility;
  Render.SetCP(cp);
  Render.Render;
  BM.Assign(Render.GetImage);
  PreviewImage.Picture.Graphic := bm;

  if mnuInstantPreview.Checked then PreviewImage.Refresh;

//--begin DrawPalette
  BitMap := TBitMap.Create;
  try
    Bitmap.PixelFormat := pf24bit;
    BitMap.Width := 256;
    BitMap.Height := 1;
    Row := Bitmap.Scanline[0];
    for i := 0 to 255 do
      with Row[i] do
      begin
        rgbtRed   := cp.cmap[i][0];
        rgbtGreen := cp.cmap[i][1];
        rgbtBlue  := cp.cmap[i][2];
      end;

    GradientImage.Picture.Graphic := Bitmap;
    GradientImage.Refresh;
  finally
    BitMap.Free;
  end;
//--end DrawPalette
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

  Sendmessage(cmbPalette.Handle, CB_SETDROPPEDWIDTH , cmbPalette.width * 2, 0);
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
      Registry.WriteBool('InstantPreview', mnuInstantPreview.Checked);
      Registry.WriteBool('ResizeMain', chkResizeMain.Checked);
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

procedure TAdjustForm.FormShow(Sender: TObject);
var
  Registry: TRegistry;
  i: integer;
  strx, stry, strw, strh: string;
begin
  if LimitVibrancy then scrollVibrancy.Max := 100 else scrollVibrancy.Max := 3000;
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
      if Registry.ValueExists('InstantPreview') then
        mnuInstantPreview.Checked := Registry.ReadBool('InstantPreview');
      if Registry.ValueExists('ResizeMain') then
        chkResizeMain.Checked := Registry.ReadBool('ResizeMain');
      Registry.CloseKey;
    end;

    if Registry.OpenKey('Software\' + APP_NAME + '\ImageSizePresets', False) then
    begin
      for i:=1 to 3 do begin
        strx:='Preset'+IntToStr(i)+'Left';
        stry:='Preset'+IntToStr(i)+'Top';
        strw:='Preset'+IntToStr(i)+'Width';
        strh:='Preset'+IntToStr(i)+'Height';
        if Registry.ValueExists(strw) and Registry.ValueExists(strh)
        then begin
          Preset[i].Left := Registry.ReadInteger(strx);
          Preset[i].Top  := Registry.ReadInteger(stry);
          Preset[i].Width := Registry.ReadInteger(strw);
          Preset[i].Height := Registry.ReadInteger(strh);
          if (Preset[1].Width>0) and (Preset[1].Height>0) then continue;
        end;
        Preset[i].Left := MainForm.Left;
        Preset[i].Top := MainForm.Top;
        Preset[i].Width := 512;
        Preset[i].Height := 384;
      end;
    end
    else
      for i:=1 to 3 do begin
        Preset[i].Left := MainForm.Left;
        Preset[i].Top := MainForm.Top;
        Preset[i].Width := 512;
        Preset[i].Height := 384;
      end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
  GetMainWindowSize;

  btnPreset1.Caption := PresetToStr(1);
  btnPreset2.Caption := PresetToStr(2);
  btnPreset3.Caption := PresetToStr(3);
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

procedure TAdjustForm.txtZoomEnter(Sender: TObject);
begin
  EditBoxValue := txtZoom.Text;
end;

procedure TAdjustForm.txtZoomKeyPress(Sender: TObject; var Key: Char);
var v: integer;
begin
  if ((key = #13) and (EditBoxValue <> txtZoom.Text)) then
  begin
    key := #0;
    try
      v := Trunc(StrToFloat(txtZoom.Text) * 1000);
      if v > scrollZoom.Max then v := scrollZoom.Max;
      if v < scrollZoom.Min then v := scrollZoom.Min;
      if v <> ScrollZoom.Position then begin
        ScrollZoom.Position := v;
        UpdateFlame;
        EditBoxValue := txtZoom.Text;
      end;
    except on EConvertError do
    end;
  end;
end;

procedure TAdjustForm.txtZoomExit(Sender: TObject);
var
  v: integer;
begin
  if (EditBoxValue <> txtZoom.Text) then
  try
    v := Trunc(StrToFloat(txtZoom.Text) * 1000);
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

procedure TAdjustForm.txtCenterXEnter(Sender: TObject);
begin
  EditBoxValue := txtCenterX.Text;
end;

procedure TAdjustForm.txtCenterXKeyPress(Sender: TObject; var Key: Char);
var
  v: integer;
begin
  if ((key = #13) and (EditBoxValue <> txtCenterX.Text)) then
  begin
    key := #0;
    try
      v := Trunc(StrToFloat(txtCenterX.Text) * 1000);
      if v > scrollCenterX.Max then v := scrollCenterX.Max;
      if v < scrollCenterX.Min then v := scrollCenterX.Min;
      ScrollCenterX.Position := v;
      UpdateFlame;
      EditBoxValue := txtCenterX.Text;
    except on EConvertError do
    end;
  end;
end;

procedure TAdjustForm.txtCenterXExit(Sender: TObject);
var
  v: integer;
begin
  if (EditBoxValue <> txtCenterX.Text) then
  try
    v := Trunc(StrToFloat(txtCenterX.Text) * 1000);
    if v > scrollCenterX.Max then v := scrollCenterX.Max;
    if v < scrollCenterX.Min then v := scrollCenterX.Min;
    ScrollCenterX.Position := v;
    UpdateFlame;
  except on EConvertError do
      txtCenterX.Text := FloatToStr(cp.center[0]);
  end;
end;

procedure TAdjustForm.txtCenterYEnter(Sender: TObject);
begin
  EditBoxValue := txtCenterY.Text;
end;

procedure TAdjustForm.txtCenterYKeyPress(Sender: TObject; var Key: Char);
var
  v: integer;
begin
  if ((key = #13) and (EditBoxValue <> txtCenterY.Text)) then
  begin
    key := #0;
    try
      v := Trunc(StrToFloat(txtCenterY.Text) * 1000);
      if v > ScrollCenterY.Max then v := ScrollCenterY.Max;
      if v < ScrollCenterY.Min then v := ScrollCenterY.Min;
      ScrollCenterY.Position := v;
      UpdateFlame;
      EditBoxValue := txtCenterY.Text;
    except on EConvertError do
    end;
  end;
end;

procedure TAdjustForm.txtCenterYExit(Sender: TObject);
var
  v: integer;
begin
  if (EditBoxValue <> txtCenterY.Text) then
  try
    v := Trunc(StrToFloat(txtCenterY.Text) * 1000);
    if v > ScrollCenterY.Max then v := ScrollCenterY.Max;
    if v < ScrollCenterY.Min then v := ScrollCenterY.Min;
    ScrollCenterY.Position := v;
    UpdateFlame;
  except on EConvertError do
      txtCenterY.Text := FloatToStr(cp.center[1]);
  end;
end;

procedure TAdjustForm.txtGammaEnter(Sender: TObject);
begin
  EditBoxValue := txtGamma.Text;
end;

procedure TAdjustForm.txtGammaExit(Sender: TObject);
var
  v: integer;
begin
  if (txtGamma.Text <> EditBoxValue) then
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
  if ((key = #13) and (txtGamma.Text <> EditBoxValue)) then
  begin
    key := #0;
    try
      v := Trunc(StrToFloat(txtGamma.Text) * 100);
      if v > scrollGamma.Max then v := scrollGamma.Max;
      if v < scrollGamma.Min then v := scrollGamma.Min;
      ScrollGamma.Position := v;
      UpdateFlame;
      EditBoxValue := txtGamma.Text;
    except on EConvertError do
    end;
  end;
end;

procedure TAdjustForm.txtBrightnessEnter(Sender: TObject);
begin
  EditBoxValue := txtBrightness.Text;
end;

procedure TAdjustForm.txtBrightnessExit(Sender: TObject);
var
  v: integer;
begin
  if (txtBrightness.Text <> EditBoxValue) then
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
  if ((key = #13) and (txtBrightness.Text <> EditBoxValue)) then
  begin
    key := #0;
    try
      v := Trunc(StrToFloat(txtBrightness.Text) * 100);
      if v > scrollBrightness.Max then v := scrollBrightness.Max;
      if v < scrollBrightness.Min then v := scrollBrightness.Min;
      ScrollBrightness.Position := v;
      UpdateFlame;
      EditBoxValue := txtBrightness.Text;
    except on EConvertError do
    end;
  end;
end;

procedure TAdjustForm.txtVibrancyEnter(Sender: TObject);
begin
  EditBoxValue := txtVibrancy.Text;
end;

procedure TAdjustForm.txtVibrancyKeyPress(Sender: TObject; var Key: Char);
var
  v: integer;
begin
  if ((key = #13) and (txtVibrancy.Text <> EditBoxValue)) then
  begin
    key := #0;
    try
      v := Trunc(StrToFloat(txtVibrancy.Text) * 100);
      if v > scrollVibrancy.Max then v := scrollVibrancy.Max;
      if v < scrollVibrancy.Min then v := scrollVibrancy.Min;
      ScrollVibrancy.Position := v;
      UpdateFlame;
      EditBoxValue := txtVibrancy.Text;
    except on EConvertError do
    end;
  end;
end;

procedure TAdjustForm.txtVibrancyExit(Sender: TObject);
var
  v: integer;
begin
  if (txtVibrancy.Text <> EditBoxValue) then
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
  txtVibrancy.Refresh;
  DrawPreview;
end;

procedure TAdjustForm.scrollGammaChange(Sender: TObject);
begin
  cp.Gamma := scrollGamma.Position / 100;
  txtGamma.text := FloatToStr(cp.Gamma);
  txtGamma.Refresh;
  DrawPreview;
end;

procedure TAdjustForm.scrollBrightnessChange(Sender: TObject);
begin
  cp.Brightness := ScrollBrightness.Position / 100;
  txtBrightness.text := FloatToStr(cp.Brightness);
  txtBrightness.Refresh;
  DrawPreview;
end;

procedure TAdjustForm.scrollZoomChange(Sender: TObject);
begin
  cp.zoom := scrollZoom.Position / 1000;
  txtZoom.text := FloatToStr(cp.zoom);
  txtZoom.Refresh;
  DrawPreview;
end;

procedure TAdjustForm.scrollCenterXChange(Sender: TObject);
begin
  cp.center[0] := scrollCenterX.Position / 1000;
  txtCenterX.text := FloatToStr(cp.center[0]);
  txtCenterX.Refresh;
  DrawPreview;
end;

procedure TAdjustForm.scrollCenterYChange(Sender: TObject);
begin
  cp.center[1] := scrollCenterY.Position / 1000;
  txtCenterY.text := FloatToStr(cp.center[1]);
  txtCenterY.Refresh;
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
    //cbColor.text := IntToHex(integer(ColorDialog.Color), 6);
    col := ColorToRGB(ColorDialog.Color);
    cp.background[0] := col and 255;
    cp.background[1] := col shr 8 and 255;
    cp.background[2] := col shr 16 and 255;
    DrawPreview;
    UpdateFlame(true);
  end;
end;

procedure TAdjustForm.scrollContrastScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if ScrollCode = scEndScroll then UpdateFlame;
end;

procedure TAdjustForm.scrollAngleChange(Sender: TObject);
begin
  cp.FAngle := scrollAngle.Position * PI / 18000.0;
  txtAngle.text := FloatToStr(cp.FAngle * 180 / PI);
  txtAngle.Refresh;
  DrawPreview;
end;

procedure TAdjustForm.scrollAngleScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if ScrollCode = scEndScroll then UpdateFlame;
end;

procedure TAdjustForm.txtAngleEnter(Sender: TObject);
begin
  EditBoxValue := txtAngle.Text;
end;

procedure TAdjustForm.txtAngleKeyPress(Sender: TObject; var Key: Char);
var
  v: integer;
begin
  if ((key = #13) and (txtAngle.Text <> EditBoxValue)) then
  begin
    key := #0;
    try
      v := Trunc(StrToFloat(txtAngle.Text) * 100) mod scrollAngle.Max;
      //if v > scrollAngle.Max then v := v - scrollAngle.Max*2
      if v < scrollAngle.Min then v := v + scrollAngle.Max;
      ScrollAngle.Position := v;
      UpdateFlame;
      EditBoxValue := txtAngle.Text;
    except on EConvertError do
    end;
  end;
end;

procedure TAdjustForm.txtAngleExit(Sender: TObject);
var
  v: integer;
begin
  if (txtAngle.Text <> EditBoxValue) then
  try
    v := Trunc(StrToFloat(txtAngle.Text) * 100) mod scrollAngle.Max;
//    if v > scrollAngle.Max then v := v - scrollAngle.Max*2
//    else if v < scrollAngle.Min then v := v + scrollAngle.Max*2;
    ScrollAngle.Position := v;
    UpdateFlame;
  except on EConvertError do
      txtAngle.Text := FloatToStr(cp.FAngle * 180 / PI);
  end;
end;

// --Z-- // gradient stuff implementation --------------------------------------

procedure TAdjustForm.Apply;
begin
  MainForm.StopThread;
  MainForm.UpdateUndo;

  MainCp.CmapIndex := cmbPalette.ItemIndex;
  MainCp.cmap := Palette;

  if EditForm.visible then EditForm.UpdateDisplay;
  if MutateForm.Visible then MutateForm.UpdateDisplay;

  if mnuInstantPreview.Checked then DrawPreview;

  MainForm.RedrawTimer.enabled := true;
end;

procedure TAdjustForm.SaveMap(FileName: string);
var
  i: Integer;
  l: string;
  MapFile: TextFile;
begin
{ Save a map file }
  AssignFile(MapFile, FileName);
  try
    ReWrite(MapFile);
    { first line with comment }
    l := Format(' %3d %3d %3d  Exported from Apophysis 2.0', [Palette[0][0], palette[0][1],
      palette[0][2]]);
    Writeln(MapFile, l);
    { now the rest }
    for i := 1 to 255 do
    begin
      l := Format(' %3d %3d %3d', [Palette[i][0], palette[i][1],
        palette[i][2]]);
      Writeln(MapFile, l);
    end;
    CloseFile(MapFile);
  except
    on EInOutError do Application.MessageBox(PChar('Cannot Open File: ' +
        FileName), 'Apophysis', 16);
  end;
end;

procedure TAdjustForm.UpdateGradient(Pal: TColorMap);
begin
  ScrollBar.Position := 0;

  Palette := Pal;
  BackupPal := Pal;
//  DrawPalette;

  cp.cmap := pal;
//  cp.copy(MainCp);

  if mnuInstantPreview.Checked then DrawPreview;
end;

procedure HSVToRGB(H, S, V: real; var Rb, Gb, Bb: integer);
var
  R, G, B, Sa, Va, Hue, i, f, p, q, t: real;
begin
  R := 0;
  G := 0;
  B := 0;
  Sa := S / 100;
  Va := V / 100;
  if S = 0 then
  begin
    R := Va;
    G := Va;
    B := Va;
  end
  else
  begin
    Hue := H / 60;
    if Hue = 6 then Hue := 0;
    i := Int(Hue);
    f := Hue - i;
    p := Va * (1 - Sa);
    q := Va * (1 - (Sa * f));
    t := Va * (1 - (Sa * (1 - f)));
    case Round(i) of
      0: begin
          R := Va;
          G := t;
          B := p;
        end;
      1: begin
          R := q;
          G := Va;
          B := p;
        end;
      2: begin
          R := p;
          G := Va;
          B := t;
        end;
      3: begin
          R := p;
          G := q;
          B := Va;
        end;
      4: begin
          R := t;
          G := p;
          B := Va;
        end;
      5: begin
          R := Va;
          G := p;
          B := q;
        end;
    end;
  end;
  Rb := Round(Int(255.9999 * R));
  Gb := Round(Int(255.9999 * G));
  Bb := Round(Int(255.9999 * B));
end;

procedure RGBToHSV(R, G, B: byte; var H, S, V: real);
var
  vRed, vGreen, vBlue, Mx, Mn, Va, Sa, rc, gc, bc: real;
begin
  vRed := R / 255;
  vGreen := G / 255;
  vBlue := B / 255;
  Mx := vRed;
  if vGreen > Mx then Mx := vGreen;
  if vBlue > Mx then Mx := vBlue;
  Mn := vRed;
  if vGreen < Mn then Mn := vGreen;
  if vBlue < Mn then Mn := vBlue;
  Va := Mx;
  if Mx <> 0 then
    Sa := (Mx - Mn) / Mx
  else
    Sa := 0;
  if Sa = 0 then
    H := 0
  else
  begin
    rc := (Mx - vRed) / (Mx - Mn);
    gc := (Mx - vGreen) / (Mx - Mn);
    bc := (Mx - vBlue) / (Mx - Mn);
    if Mx = vRed then
      H := bc - gc
    else if Mx = vGreen then
      H := 2 + rc - bc
    else if Mx = vBlue then
      H := 4 + gc - rc;
    H := H * 60;
    if H < 0 then H := H + 360;
  end;
  S := Sa * 100;
  V := Va * 100;
end;

function TAdjustForm.Blur(const Radius: Integer; const pal: TColorMap): TColorMap;
var
  r, g, b, n, i, j, k: Integer;
begin
  Result := Pal;
  if Radius <> 0 then
    for i := 0 to 255 do
    begin
      n := -1;
      r := 0;
      g := 0;
      b := 0;
      for j := i - radius to i + radius do
      begin
        inc(n);
        k := (256 + j) mod 256;
        if k <> i then begin
          r := r + Pal[k][0];
          g := g + Pal[k][1];
          b := b + Pal[k][2];
        end;
      end;
      if n <> 0 then begin
        Result[i][0] := r div n;
        Result[i][1] := g div n;
        Result[i][2] := b div n;
      end;
    end;
end;

function TAdjustForm.Frequency(const times: Integer; const pal: TColorMap): TColorMap;
{ This can be improved }
var
  n, i, j: Integer;
begin
  Result := Pal;
  if times <> 1 then
  begin
    n := 256 div times;
    for j := 0 to times do
      for i := 0 to n do
      begin
        if (i + j * n) < 256 then
        begin
          Result[i + j * n][0] := pal[i * times][0];
          Result[i + j * n][1] := pal[i * times][1];
          Result[i + j * n][2] := pal[i * times][2];
        end;
      end;
  end;
end;

procedure TAdjustForm.cmbPaletteChange(Sender: TObject);
var
  i: integer;
begin
  if Resetting then exit;

  i := cmbPalette.ItemIndex;
  GetCmap(i, 1, Palette);
  BackupPal := Palette;
  ScrollBar.Position := 0;
  //DrawPalette;
//  MainForm.UpdateUndo;
  Apply;
end;

procedure TAdjustForm.mnuReverseClick(Sender: TObject);
var
  i: integer;
  pal: TColorMap;
begin
  for i := 0 to 255 do begin
    pal[i][0] := Palette[255 - i][0];
    pal[i][1] := Palette[255 - i][1];
    pal[i][2] := Palette[255 - i][2];
  end;
  UpdateGradient(pal);
//  MainForm.UpdateUndo;
  Apply;
end;

procedure TAdjustForm.mnuInvertClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to 255 do
  begin
    Palette[i][0] := 255 - Palette[i][0];
    Palette[i][1] := 255 - Palette[i][1];
    Palette[i][2] := 255 - Palette[i][2];
  end;
  UpdateGradient(palette);
//  MainForm.UpdateUndo;
  Apply;
end;

procedure TAdjustForm.btnMenuClick(Sender: TObject);
begin
  scrollModePopup.Popup(btnMenu.ClientOrigin.x, btnMenu.ClientOrigin.y + btnMenu.Height);
end;

procedure TAdjustForm.ScrollBarChange(Sender: TObject);
var
  intens, i, r, g, b: integer;
  h, s, v: real;
begin
  lblVal.Caption := IntToStr(ScrollBar.Position);
  lblVal.Refresh;

  if Resetting then exit;

  GradientChanged:=true; // hmm

  case scrollMode of
    modeHue:
      for i := 0 to 255 do
      begin
        RGBToHSV(BackupPal[i][0], BackupPal[i][1], BackupPal[i][2], h, s, v);
        if s <> 0 then // --Z-- //(?)
        begin
          h := Round(360 + h + ScrollBar.Position) mod 360;
          HSVToRGB(h, s, v, Palette[i][0], Palette[i][1], Palette[i][2]);
        end;
      end;
    modeSaturation:
      for i := 0 to 255 do
      begin
        RGBToHSV(BackupPal[i][0], BackupPal[i][1], BackupPal[i][2], h, s, v);
        if s <> 0 then // --Z-- //(?)
        begin
          s := s + ScrollBar.Position;
          if s > 100 then s := 100;
          if s < 0 then s := 0;
          HSVToRGB(h, s, v, Palette[i][0], Palette[i][1], Palette[i][2]);
        end;
      end;
    modeContrast:
    begin
      intens := scrollBar.Position;
      if intens > 0 then intens := intens * 2;
      for i := 0 to 255 do
      begin
        r := BackupPal[i][0];
        g := BackupPal[i][1];
        b := BackupPal[i][2];
        r := round(r + intens / 100 * (r - 127));
        g := round(g + intens / 100 * (g - 127));
        b := round(b + intens / 100 * (b - 127));
        if R > 255 then R := 255 else if R < 0 then R := 0;
        if G > 255 then G := 255 else if G < 0 then G := 0;
        if B > 255 then B := 255 else if B < 0 then B := 0;
        Palette[i][0] := r;
        Palette[i][1] := g;
        Palette[i][2] := b;
      end;
    end;
    modeBrightness:
      for i := 0 to 255 do
      begin
        Palette[i][0] := BackupPal[i][0] + ScrollBar.Position;
        if Palette[i][0] > 255 then Palette[i][0] := 255;
        if Palette[i][0] < 0 then Palette[i][0] := 0;
        Palette[i][1] := BackupPal[i][1] + ScrollBar.Position;
        if Palette[i][1] > 255 then Palette[i][1] := 255;
        if Palette[i][1] < 0 then Palette[i][1] := 0;
        Palette[i][2] := BackupPal[i][2] + ScrollBar.Position;
        if Palette[i][2] > 255 then Palette[i][2] := 255;
        if Palette[i][2] < 0 then Palette[i][2] := 0;
      end;
    modeRotate:
      for i := 0 to 255 do
      begin
        Palette[i][0] := BackupPal[(256 + i - ScrollBar.Position) mod 256][0];
        Palette[i][1] := BackupPal[(256 + i - ScrollBar.Position) mod 256][1];
        Palette[i][2] := BackupPal[(256 + i - ScrollBar.Position) mod 256][2];
      end;
    modeBlur:
      Palette := Blur(ScrollBar.Position, BackupPal);
    modeFrequency:
      Palette := Frequency(ScrollBar.Position, BackupPal);
  end;

  cp.cmap:=Palette;
  DrawPreview;
end;

procedure TAdjustForm.ScrollBarScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if ScrollCode = scEndScroll then
  begin
    GradientChanged:=false;
    Apply;
  end;
end;

{ ***************************** Adjust menu ********************************* }

procedure TAdjustForm.mnuRotateClick(Sender: TObject);
begin
  btnMenu.Caption := 'Rotate';
  scrollMode:=modeRotate;

  BackupPal := Palette;
  ScrollBar.Min := -128;
  ScrollBar.Max := 128;
  ScrollBar.LargeChange := 16;
  ScrollBar.Position := 0;
end;

procedure TAdjustForm.mnuHueClick(Sender: TObject);
begin
  btnMenu.Caption := 'Hue';
  scrollMode:=modeHue;

  BackupPal := Palette;
  ScrollBar.Min := -180;
  ScrollBar.Max := 180;
  ScrollBar.LargeChange := 15;
  ScrollBar.Position := 0;
end;

procedure TAdjustForm.mnuSaturationClick(Sender: TObject);
begin
  btnMenu.Caption := 'Saturation';
  scrollMode:=modeSaturation;

  BackupPal := Palette;
  ScrollBar.Min := -100;
  ScrollBar.Max := 100;
  ScrollBar.LargeChange := 15;
  ScrollBar.Position := 0;
end;

procedure TAdjustForm.mnuBrightnessClick(Sender: TObject);
begin
  btnMenu.Caption := 'Brightness';
  scrollMode:=modeBrightness;

  BackupPal := Palette;
  ScrollBar.Min := -255;
  ScrollBar.Max := 255;
  ScrollBar.LargeChange := 15;
  ScrollBar.Position := 0;
end;

procedure TAdjustForm.mnuContrastClick(Sender: TObject);
begin
  btnMenu.Caption := 'Contrast';
  scrollMode := modeContrast;
  BackupPal := Palette;

  ScrollBar.Min := -100;
  ScrollBar.Max := 100;
  ScrollBar.LargeChange := 15;
  ScrollBar.Position := 0;
end;

procedure TAdjustForm.mnuBlurClick(Sender: TObject);
begin
  btnMenu.Caption := 'Blur';
  scrollMode:=modeBlur;

  BackupPal := Palette;
  ScrollBar.Min := 0;
  ScrollBar.Max := 127;
  ScrollBar.LargeChange := 15;
  ScrollBar.Position := 0;
end;

procedure TAdjustForm.mnuFrequencyClick(Sender: TObject);
begin
  btnMenu.Caption := 'Frequency';
  scrollMode:=modeFrequency;

  BackupPal := Palette;
  ScrollBar.Min := 1;
  ScrollBar.Max := 10;
  ScrollBar.LargeChange := 1;
  ScrollBar.Position := 1;
end;

// -----------------------------------------------------------------------------

procedure TAdjustForm.btnOpenClick(Sender: TObject);
begin
  GradientBrowser.Filename := GradientFile;
  GradientBrowser.Show;
end;

procedure TAdjustForm.mnuSmoothPaletteClick(Sender: TObject);
begin
  MainForm.SmoothPalette;
end;

procedure TAdjustForm.SaveGradient1Click(Sender: TObject);
var
  gradstr: TStringList;
begin
  gradstr := TStringList.Create;
  try
    SaveForm.Caption := 'Save Gradient';
    SaveForm.Filename := GradientFile;
    SaveForm.Title := MainCp.name;
    if SaveForm.ShowModal = mrOK then
    begin
      gradstr.add(CleanIdentifier(SaveForm.Title) + ' {');
      gradstr.add(MainForm.GradientFromPalette(Palette, SaveForm.Title));
      gradstr.add('}');
      if MainForm.SaveGradient(gradstr.text, SaveForm.Title, SaveForm.Filename) then
        GradientFile := SaveForm.FileName;
    end;
  finally
    gradstr.free
  end;
end;

procedure TAdjustForm.SaveasMapfile1Click(Sender: TObject);
begin
  SaveDialog.Filename := MainCp.name + '.map';
  if SaveDialog.execute then
    SaveMap(SaveDialog.Filename);
end;

procedure TAdjustForm.cmbPaletteDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  i, j: integer;
  Row: pRGBTripleArray;
  Bitmap: TBitmap;
  pal: TColorMap;
  PalName: string;
begin
{ Draw the preset palettes on the combo box items }
  GetCMap(index, 1, pal);
  GetCmapName(index, PalName);

  BitMap := TBitMap.create;
  Bitmap.PixelFormat := pf24bit;
  BitMap.Width := 256;
  BitMap.Height := 100;

  for j := 0 to Bitmap.Height - 1 do
  begin
    Row := Bitmap.Scanline[j];
    for i := 0 to Bitmap.Width - 1 do
    begin
      with Row[i] do
      begin
        rgbtRed := Pal[i][0];
        rgbtGreen := Pal[i][1];
        rgbtBlue := Pal[i][2];
      end
    end
  end;
  with Control as TComboBox do
  begin
    Canvas.Rectangle(Rect);

    Canvas.TextOut(4, Rect.Top, PalName);
    Rect.Left := (Rect.Left + rect.Right) div 2;
    Canvas.StretchDraw(Rect, Bitmap);
  end;
  BitMap.Free;
end;

procedure TAdjustForm.btnCopyClick(Sender: TObject);
var
  gradstr: TStringList;
begin
  gradstr := TStringList.Create;
  try
    gradstr.add(CleanIdentifier(MainCp.name) + ' {');
    gradstr.add('gradient:');
    gradstr.add(' title="' + MainCp.name + '" smooth=no');
    gradstr.add(GradientString(Palette));
    gradstr.add('}');
    Clipboard.SetTextBuf(PChar(gradstr.text));
    btnPaste.enabled := true;
    mnuPaste.enabled := true;
//z    MainForm.btnPaste.enabled := False;
    MainForm.mnuPaste.enabled := False;
  finally
    gradstr.free
  end;
end;

procedure TAdjustForm.btnPasteClick(Sender: TObject);
begin
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    UpdateGradient(CreatePalette(Clipboard.AsText));
//    MainForm.UpdateUndo;
    Apply;
  end;
end;

function GradientInClipboard: boolean;
var
  gradstr: TStringList;
begin
  { returns true if gradient in clipboard - can be tricked }
  result := true;
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    gradstr := TStringList.Create;
    try
      gradstr.text := Clipboard.AsText;
      if (Pos('}', gradstr.text) = 0) or (Pos('{', gradstr.text) = 0) or
        (Pos('gradient:', gradstr.text) = 0) or (Pos('fractal:', gradstr.text) <> 0) then
      begin
        result := false;
        exit;
      end;
    finally
      gradstr.free;
    end;
  end
  else
    result := false;
end;

procedure TAdjustForm.ApplicationEventsActivate(Sender: TObject);
begin
  if GradientInClipboard then begin
    mnuPaste.enabled := true;
    btnPaste.enabled := true;
  end
  else
  begin
    mnuPaste.enabled := false;
    btnPaste.enabled := false;
  end;
end;

procedure TAdjustForm.mnuSaveasDefaultClick(Sender: TObject);
begin
  DefaultPalette := Palette;
  SaveMap(AppPath + 'default.map');
end;

procedure TAdjustForm.mnuRandomizeClick(Sender: TObject);
begin
  UpdateGradient(GradientHelper.RandomGradient);
  Apply;
end;

procedure TAdjustForm.GradientImageDblClick(Sender: TObject);
begin
  mnuRandomizeClick(Sender);
end;

procedure TAdjustForm.GradImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    dragX:=x;
    oldX:=x; // hmmm
    oldpos := ( ((x) shl 8) div GradientImage.Width) mod 256;
if oldpos = 0 then oldpos := 1;
    tmpBackupPal := BackupPal;
    if ssCtrl in Shift then
      imgDragMode := imgDragStretch
    else
      imgDragMode := imgDragRotate;
    GradientChanged:=false;
  end;
end;

procedure TAdjustForm.GradImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
  procedure StretchGradient(i0, i1, j0, j1: integer);
  var
    k, f: double;
    i, j, jj, n: integer;
  begin
    k := (j1 - j0) / (i1 - i0);

    if k >= 1 then
    begin
      for i := i0 to i1-1 do
      begin
        j := j0 + round((i - i0) * k);

assert(j >= 0);
assert(j < 256);

        cp.cmap[i] := Palette[j];
        BackupPal[i] := tmpBackupPal[j]; //?
      end;
    end
    else begin
      for i := i0 to i1-1 do
      begin
        f := (i - i0) * k;
        j := j0 + trunc(f);
        f := frac(f);

assert(j >= 0);
assert(j < 256);

        if j < 255 then jj := j + 1
        else jj := 0;
        for n := 0 to 2 do begin
          cp.cmap[i][n] := round( Palette[j][n]*(1-f) + Palette[jj][n]*f );
          BackupPal[i][n] := round( tmpBackupPal[j][n]*(1-f) + tmpBackupPal[jj][n]*f ); //?
        end;
      end;
    end;
  end;
var
  i, j: integer;
  k: double;
begin
  if (imgDragMode <> imgDragNone) and (oldX<>x) then
  begin
    oldX:=x;
    offset := ( ((x - dragX) shl 8) div GradientImage.Width) mod 256;
    lblOffset.Caption:=IntToStr(offset);
    lblOffset.Refresh;
    GradientChanged := true;

    if imgDragmode = imgDragRotate then begin
      for i := 0 to 255 do
      begin
        cp.cmap[i] := Palette[(256 + i - offset) and $FF];

        BackupPal[i] := tmpBackupPal[(256 + i - offset) and $FF];
      end;
    end
    else begin
      offset := ( (x shl 8) div GradientImage.Width);
      if offset <= 0 then offset := 1
      else if offset > 255 then offset := 255;

      StretchGradient(0, offset, 0, oldpos);
      StretchGradient(offset, 256, oldpos, 256);
    end;

    DrawPreview;
  end;
end;

procedure TAdjustForm.GradImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if imgDragMode <> imgDragNone then
  begin
    imgDragMode := imgDragNone;
    lblOffset.Caption:='';

    Palette := cp.cmap;

    if GradientChanged then Apply;
  end;
end;

// --Z-- // image size functions -----------------------------------------------

function TAdjustForm.PresetToStr(n: integer): string;
begin
  Result:=IntToStr(Preset[n].Width) + ' x ' + IntToStr(Preset[n].Height)
end;

procedure TAdjustForm.ReadPreset(n: integer);
begin
  ImageWidth := Preset[n].Width;
  ImageHeight := Preset[n].Height;
  txtWidth.Text := IntToStr(ImageWidth);
  txtHeight.Text := IntToStr(ImageHeight);

  if chkResizeMain.Checked then begin
    MainForm.Left:=Preset[n].Left;
    MainForm.Top:=Preset[n].Top;
  end;

  SetMainWindowSize;
end;

procedure TAdjustForm.WritePreset(n: integer);
var
  Registry: TRegistry;
  w,h: integer;
begin
  // Write preset to registry
  Registry := TRegistry.Create;
  try
    w:=StrToInt(txtWidth.text);
    h:=StrToInt(txtHeight.text);
    if (w>0) and (h>0) then begin
      Preset[n].Left:=MainForm.Left;
      Preset[n].Top:=MainForm.Top;
      Preset[n].Width:=w;
      Preset[n].Height:=h;
    end
    else exit;

    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('\Software\' + APP_NAME + '\ImageSizePresets', True) then
    begin
      Registry.WriteInteger('Preset'+IntToStr(n)+'Left', Preset[n].Left);
      Registry.WriteInteger('Preset'+IntToStr(n)+'Top', Preset[n].Top);
      Registry.WriteInteger('Preset'+IntToStr(n)+'Width', Preset[n].Width);
      Registry.WriteInteger('Preset'+IntToStr(n)+'Height', Preset[n].Height);
    end;
  except
  end;
end;

procedure TAdjustForm.txtSizeKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    SetMainWindowSize;
  end;
end;

procedure TAdjustForm.chkMaintainClick(Sender: TObject);
begin
  Ratio := ImageWidth / ImageHeight;
end;

procedure TAdjustForm.SetMainWindowSize;
var
  l, t, w, h: integer;
begin
  MainCp.AdjustScale(ImageWidth, ImageHeight);
  MainForm.ResizeImage; //?

  if chkResizeMain.Checked then begin
    l := MainForm.Left;
    t := MainForm.Top;
    w := ImageWidth + MainForm.Width - (MainForm.BackPanel.Width - 2);
    h := ImageHeight + MainForm.Height - (MainForm.BackPanel.Height - 2);
    if w > Screen.Width then
    begin
      l := 0;
      w := Screen.width;
    end;
    if h > Screen.height then
    begin
      t := 0;
      h := Screen.height;
    end;

    MainForm.SetBounds(l, t, w, h);
  end;
  MainForm.RedrawTimer.Enabled := true;
end;

procedure TAdjustForm.GetMainWindowSize;
begin
  ImageWidth := MainCP.Width;
  ImageHeight := MainCP.Height;
  txtWidth.text := IntToStr(ImageWidth);
  txtHeight.text := IntToStr(ImageHeight);
end;

procedure TAdjustForm.btnSet1Click(Sender: TObject);
begin
  WritePreset(1);
  btnPreset1.Caption := PresetToStr(1);
  SetMainWindowSize;
end;

procedure TAdjustForm.btnSet2Click(Sender: TObject);
begin
  WritePreset(2);
  btnPreset2.Caption := PresetToStr(2);
  SetMainWindowSize;
end;

procedure TAdjustForm.btnSet3Click(Sender: TObject);
begin
  WritePreset(3);
  btnPreset3.Caption := PresetToStr(3);
  SetMainWindowSize;
end;

procedure TAdjustForm.btnPreset1Click(Sender: TObject);
begin
  ReadPreset(1);
end;

procedure TAdjustForm.btnPreset2Click(Sender: TObject);
begin
  ReadPreset(2);
end;

procedure TAdjustForm.btnPreset3Click(Sender: TObject);
begin
  ReadPreset(3);
end;

procedure TAdjustForm.txtWidthChange(Sender: TObject);
begin
  try
    ImageWidth := StrToInt(txtWidth.Text);
    if chkMaintain.checked and txtWidth.Focused then
    begin
      ImageHeight := Round(ImageWidth / ratio);
      txtHeight.Text := IntToStr(ImageHeight)
    end;
  except
  end;
end;

procedure TAdjustForm.txtHeightChange(Sender: TObject);
begin
  try
    ImageHeight := StrToInt(txtHeight.Text);
    if chkMaintain.checked and txtHeight.Focused then
    begin
      ImageWidth := Round(ImageHeight * ratio);
      txtWidth.Text := IntToStr(ImageWidth)
    end;
  except
  end;
end;

procedure TAdjustForm.btnUndoClick(Sender: TObject);
begin
  MainForm.Undo;
end;

procedure TAdjustForm.btnRedoClick(Sender: TObject);
begin
  MainForm.Redo;
end;

procedure TAdjustForm.btnColorPresetClick(Sender: TObject);
begin
  cmbPalette.ItemIndex := Random(NRCMAPS);
  cmbPaletteChange(Sender);
end;

procedure TAdjustForm.btnApplySizeClick(Sender: TObject);
begin
  SetMainWindowSize;
end;

procedure TAdjustForm.mnuInstantPreviewClick(Sender: TObject);
begin
  mnuInstantPreview.Checked := not mnuInstantPreview.Checked;
end;

procedure TAdjustForm.editPPUKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
  begin
    key := #0;
    editPPUValidate(Sender);
  end;
end;

procedure TAdjustForm.editPPUValidate(Sender: TObject);
var
  v: double;
begin
  try
    v := strtofloat(editPPU.Text);
  except
    exit;
  end;
  if v > 0 then begin
    MainForm.UpdateUndo;
    cp.pixels_per_unit := v/100*PreviewImage.Width;
    UpdateFlame;
  end;
end;

// -----------------------------------------------------------------------------

procedure TAdjustForm.DragPanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then exit;

  if (Sender = pnlMasterScale) then
    pnlDragValue := cp.pixels_per_unit / PreviewImage.Width
  else if (Sender = pnlZoom) then
    pnlDragValue := cp.zoom
  else if (Sender = pnlXpos) then
    pnlDragValue := cp.Center[0]
  else if (Sender = pnlYpos) then
    pnlDragValue := cp.Center[1]
  else if (Sender = pnlAngle) then
    pnlDragValue := cp.FAngle
  else if (Sender = pnlGamma) then
    pnlDragValue := cp.gamma
  else if (Sender = pnlBrightness) then
    pnlDragValue := cp.brightness
  else if (Sender = pnlVibrancy) then
    pnlDragValue := cp.vibrancy
  else assert(false);

  pnlDragMode := true;
  pnlDragPos := 0;
  pnlDragOld := x;
  pnlMM := false;
  //SetCaptureControl(TControl(Sender));

  Screen.Cursor := crHSplit;
  //GetCursorPos(mousepos); // hmmm
  mousePos := (Sender as TControl).ClientToScreen(Point(x, y));
  pnlDragged := false;
end;

procedure TAdjustForm.DragPanelMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  sc, v: double;
begin
  if pnlMM then // hack: to skip MouseMove event
  begin
    pnlMM:=false;
  end
  else
  if pnlDragMode and (x <> pnlDragOld) then
  begin
    Inc(pnlDragPos, x - pnlDragOld);

    if GetKeyState(VK_MENU) < 0 then sc := 100000
    else if GetKeyState(VK_CONTROL) < 0 then sc := 10000
    else if GetKeyState(VK_SHIFT) < 0 then sc := 100
    else sc := 1000;

    v := Round6(pnlDragValue + pnlDragPos / sc);

    SetCursorPos(MousePos.x, MousePos.y); // hmmm
    pnlMM:=true;

    if (Sender = pnlMasterScale) then
    begin
      v := Round6(pnlDragValue * power(2, pnlDragPos / sc / 2));
      if v <= 0.0001 then v := 0.0001;
      cp.pixels_per_unit := v*PreviewImage.Width;
      editPPU.Text := FloatToStr(v*100);
    end
    else if (Sender = pnlZoom) then
    begin
      scrollZoom.Position := trunc(v * 1000);
    end
    else if (Sender = pnlXpos) then
    begin
      scrollCenterX.Position := trunc(v * 1000);
    end
    else if (Sender = pnlYpos) then
    begin
      scrollCenterY.Position := trunc(v * 1000);
    end
    else if (Sender = pnlAngle) then
    begin
      scrollAngle.Position := Trunc(v * 18000.0 / PI) mod 36000;
    end
    else if (Sender = pnlGamma) then
    begin
      scrollGamma.Position := trunc(v * 100);
    end
    else if (Sender = pnlBrightness) then
    begin
      scrollBrightness.Position := trunc(v * 100);
    end
    else if (Sender = pnlVibrancy) then
    begin
      scrollVibrancy.Position := trunc(v * 100);
    end;
    //pEdit^.Text := FloatToStr(v);
    //pEdit.Refresh;
    pnlDragged := True;
    DrawPreview;
  end;
end;

procedure TAdjustForm.DragPanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then exit;

  if pnlDragMode then
  begin
    //SetCaptureControl(nil);

    pnlDragMode := false;
    Screen.Cursor := crDefault;

    if pnlDragged then
    begin
      UpdateFlame;
      pnlDragged := False;
    end;
  end;
end;

procedure TAdjustForm.DragPanelDblClick(Sender: TObject);
var
  pValue: ^double;
begin
  if (Sender = pnlMasterScale) then
  begin
    pValue := @cp.pixels_per_unit;
    if pValue^ = PreviewImage.Width/4 then exit;
    pValue^ := PreviewImage.Width/4;
    editPPU.Text := FloatToStr(100*pValue^/PreviewImage.Width);
  end
  else if (Sender = pnlZoom) then
  begin
    scrollZoom.Position := 0;
  end
  else if (Sender = pnlXpos) then
  begin
    scrollCenterX.Position := 0;
  end
  else if (Sender = pnlYpos) then
  begin
    scrollCenterY.Position := 0;
  end
  else if (Sender = pnlAngle) then
  begin
    scrollAngle.Position := 0;
  end
  else if (Sender = pnlGamma) then
  begin
    scrollGamma.Position := 400;
  end
  else if (Sender = pnlBrightness) then
  begin
    scrollBrightness.Position := 400;
  end
  else if (Sender = pnlVibrancy) then
  begin
    scrollVibrancy.Position := 100;
  end
  else assert(false);

  UpdateFlame;
end;

procedure TAdjustForm.FormActivate(Sender: TObject);
begin
  txtVibrancy.text := FloatToStr(cp.Vibrancy);
  txtGamma.text := FloatToStr(cp.Gamma);
  txtBrightness.text := FloatToStr(cp.Brightness);
  txtZoom.text := FloatToStr(cp.zoom);
  txtCenterX.text := FloatToStr(cp.center[0]);
  txtCentery.text := FloatToStr(cp.center[1]);
  txtAngle.text := FloatToStr(cp.FAngle * 180 / PI);
end;

///////////////////////////////////////////////////////////////////////////////

procedure TAdjustForm.PreviewImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then exit;

  camDragValueX := cp.Center[0];
  camDragValueY := cp.Center[1];

  camDragMode := true;
  camDragPos.x := 0;
  camDragPos.y := 0;
  camDragOld.x := x;
  camDragOld.y := y;
  camSin := sin(cp.FAngle);
  camCos := cos(cp.FAngle);
  camMM := false;
  //SetCaptureControl(TControl(Sender));

  Screen.Cursor := crNone;
  //GetCursorPos(mousepos); // hmmm
  mousePos := (Sender as TControl).ClientToScreen(Point(x, y));
  camDragged := false;
end;

procedure TAdjustForm.PreviewImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  sc, vx, vy: double;
begin
  if camMM then // hack: to skip MouseMove event
  begin
    camMM:=false;
  end
  else
  if camDragMode and ( (x <> camDragOld.x) or (y <> camDragOld.y) ) then
  begin
    Inc(camDragPos.x, x - camDragOld.x);
    Inc(camDragPos.y, y - camDragOld.y);

    if GetKeyState(VK_MENU) < 0 then sc := 1000
    else if GetKeyState(VK_CONTROL) < 0 then sc := 100
    else if GetKeyState(VK_SHIFT) < 0 then sc := 1
    else sc := 10;

    sc := sc * cp.pixels_per_unit;

    vx := Round6(camDragValueX - (camDragPos.x * camCos - camDragPos.y * camSin) / sc);
    vy := Round6(camDragValueY - (camDragPos.x * camSin + camDragPos.y * camCos) / sc);

    cp.center[0] := vx;
    txtCenterX.Text := FloatToStr(vx);
    txtCenterX.Refresh;
    cp.center[1] := vy;
    txtCenterY.Text := FloatToStr(vy);
    txtCenterY.Refresh;

    SetCursorPos(MousePos.x, MousePos.y); // hmmm
    pnlMM:=true;

    camDragged := True;
    DrawPreview;
  end;
end;

procedure TAdjustForm.PreviewImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then exit;

  if camDragMode then
  begin
    camDragMode := false;
    Screen.Cursor := crDefault;

    if camDragged then
    begin
      UpdateFlame;
      camDragged := False;
    end;
  end;
end;

procedure TAdjustForm.PreviewImageDblClick(Sender: TObject);
begin
  cp.center[0] := 0;
  cp.center[1] := 0;
  txtCenterX.Text := '0';
  txtCenterY.Text := '0';

  UpdateFlame;
end;

end.

