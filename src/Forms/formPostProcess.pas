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

unit formPostProcess;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RenderingInterface, controlpoint, StdCtrls, ComCtrls,
  Translation;

type
  TfrmPostProcess = class(TForm)
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    Image: TImage;
    pnlBackColor: TPanel;
    ColorDialog: TColorDialog;
    ProgressBar1: TProgressBar;
    txtFilterRadius: TEdit;
    txtGamma: TEdit;
    txtVibrancy: TEdit;
    txtContrast: TEdit;
    txtBrightness: TEdit;
    pnlGamma: TPanel;
    pnlBrightness: TPanel;
    pnlContrast: TPanel;
    pnlVibrancy: TPanel;
    pnlFilter: TPanel;
    shBack: TShape;
    pnlBackground: TPanel;
    btnSave: TButton;
    chkFitToWindow: TCheckBox;
    btnApply: TButton;
    procedure chkFitToWindowClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pnlBackColorClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);

    procedure DragPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DragPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DragPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DragPanelDblClick(Sender: TObject);
    procedure shBackMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FRenderer: TBaseRenderer;
    FCP: TControlPoint;
    FImagename: string;

    pnlDragMode, pnlDragged, pnlMM: boolean;
    pnlDragPos, pnlDragOld: integer;
    pnlDragValue: double;
    mousepos: TPoint;

    BkgColor: TColor;
    Filter,
    Gamma, Brightness,
    Contrast, Vibrancy: double;

    procedure UpdateFlame;
    procedure SetDefaultValues;

    procedure OnProgress(prog: double);

  public
    cp : TControlPoint;

    procedure SetRenderer(Renderer: TBaseRenderer);
    procedure SetControlPoint(CP: TControlPoint);
    procedure SetImageName(imagename: string);
  end;

var
  frmPostProcess: TfrmPostProcess;

implementation

uses
  Registry, Global, Main;

{$R *.dfm}

{ TfrmPostProcess }

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.SetRenderer(Renderer: TBaseRenderer);
begin
  if assigned(FRenderer) then
    FRenderer.Free;

  FRenderer := Renderer;
  Frenderer.OnProgress := OnProgress;
  Image.Picture.Graphic := FRenderer.GetImage;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.FormShow(Sender: TObject);
var
  Registry: TRegistry;
begin
  { Read posution from registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('Software\' + APP_NAME + '\Forms\PostProcess', False) then begin
      if Registry.ValueExists('Left') then
        Left := Registry.ReadInteger('Left');
      if Registry.ValueExists('Top') then
        Top := Registry.ReadInteger('Top');
      //if Registry.ValueExists('Width') then
        //Width := Registry.ReadInteger('Width');
      //if Registry.ValueExists('Height') then
     //   Height := Registry.ReadInteger('Height');
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;

end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Registry: TRegistry;
begin
  { Write position to registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('\Software\' + APP_NAME + '\Forms\PostProcess', True) then
    begin
      Registry.WriteInteger('Top', Top);
      Registry.WriteInteger('Left', Left);
     // Registry.WriteInteger('Width', Width);
     // Registry.WriteInteger('Height', Height);
    end;
  finally
    Registry.Free;
  end;

  FRenderer.Free; // weirdness!!! :-/
  FRenderer := nil;
  Image.Picture.Graphic := nil;
  FCP.Free;
  FCP := nil;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.SetDefaultValues;
begin
  BkgColor := RGB(Fcp.background[0], Fcp.background[1], Fcp.background[2]);
  pnlBackColor.Color := BkgColor;
  shBack.Brush.Color := BkgColor;
  Filter := FCP.spatial_filter_radius;
  txtFilterRadius.Text := FloatTostr(Filter);
  Gamma := FCP.gamma;
  txtGamma.Text := FloatTostr(Gamma);
  Vibrancy := FCP.vibrancy;
  txtVibrancy.Text := FloatTostr(Vibrancy);
  Contrast := FCP.contrast;
  txtContrast.Text := FloatTostr(Contrast);
  Brightness := FCP.brightness;
  txtBrightness.Text := FloatTostr(brightness);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.SetControlPoint(CP: TControlPoint);
begin
  if assigned(FCP) then
    FCP.Free;

  FCP := cp.Clone;
  SetDefaultValues;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.pnlBackColorClick(Sender: TObject);
var
  col: Longint;
begin
  ColorDialog.Color := shBack.Brush.Color;
  if ColorDialog.Execute then begin
    pnlBackColor.Color := ColorDialog.Color;
    shBack.Brush.Color := ColorDialog.Color;
    col := ColorToRGB(ColorDialog.Color);
    Fcp.background[0] := col and 255;
    Fcp.background[1] := (col shr 8) and 255;
    Fcp.background[2] := (col shr 16) and 255;
    UpdateFlame;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.UpdateFlame;
begin
  Screen.Cursor := crHourGlass;
  FRenderer.UpdateImage(FCP);
  Image.Picture.Graphic := FRenderer.GetImage;
  Screen.Cursor := crDefault;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.FormDestroy(Sender: TObject);
begin
  if assigned(FRenderer) then
    FRenderer.Free;

  if assigned(FCP) then
    FCP.Free;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.OnProgress(prog: double);
begin
  ProgressBar1.Position := round(100 * prog);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.btnApplyClick(Sender: TObject);
var
  temp: double;
begin
  TryStrToFloat(txtFilterRadius.Text, FCP.spatial_filter_radius);
  if FCP.spatial_filter_radius > 2 then begin
    FCP.spatial_filter_radius := 2;
    txtFilterRadius.Text := '2';
  end else if FCP.spatial_filter_radius < 0 then begin
    FCP.spatial_filter_radius := 0.01;
    txtFilterRadius.Text := FloatTostr(0.01);
  end;

  TryStrToFloat(txtGamma.Text, FCP.gamma);
  if FCP.gamma > 10 then begin
    FCP.gamma := 10;
    txtGamma.Text := '10';
  end else if FCP.gamma < 0.01 then begin
    FCP.gamma := 0.01;
    txtGamma.Text := FloatTostr(0.01);
  end;

  TryStrToFloat(txtVibrancy.Text, FCP.vibrancy);
  if FCP.vibrancy > 10 then begin
    FCP.vibrancy := 10;
    txtVibrancy.Text := '10';
  end else if FCP.vibrancy < 0.01 then begin
    FCP.vibrancy := 0.01;
    txtVibrancy.Text := FloatTostr(0.01);
  end;

  TryStrToFloat(txtContrast.Text, FCP.contrast);
  if FCP.contrast > 10 then begin
    FCP.contrast := 10;
    txtContrast.Text := '10';
  end else if FCP.contrast < 0.01 then begin
    FCP.contrast := 0.01;
    txtContrast.Text := FloatTostr(0.01);
  end;

  if TryStrToFloat(txtBrightness.Text, temp) then FCP.brightness := temp;
  //TryStrToFloat(txtBrightness.Text, FCP.brightness);
  if FCP.brightness > 100 then begin
    FCP.brightness := 100;
    txtBrightness.Text := '100';
  end else if FCP.brightness < 0.01 then begin
    FCP.brightness := 0.01;
    txtBrightness.Text := FloatTostr(0.01);
  end;

  UpdateFlame;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.btnSaveClick(Sender: TObject);
begin
  FRenderer.SaveImage(FImagename);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.SetImageName(imagename: string);
begin
  FImagename := imagename;
end;

// -----------------------------------------------------------------------------

procedure TfrmPostProcess.DragPanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then exit;

  if (Sender = pnlFilter) then
    pnlDragValue := fcp.spatial_filter_radius * 10
  else if (Sender = pnlGamma) then
    pnlDragValue := fcp.gamma
  else if (Sender = pnlBrightness) then
    pnlDragValue := fcp.brightness
  else if (Sender = pnlContrast) then
    pnlDragValue := fcp.contrast
  else if (Sender = pnlVibrancy) then
    pnlDragValue := fcp.vibrancy
  else exit;//assert(false);

  pnlDragMode := true;
  pnlDragPos := 0;
  pnlDragOld := x;
  pnlMM := false;
  SetCaptureControl(TControl(Sender));
  Screen.Cursor := crHSplit;
  GetCursorPos(mousepos); // hmmm
  pnlDragged := false;
end;

procedure TfrmPostProcess.DragPanelMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  v: double;
  pEdit: ^TEdit;
  enableDrag : boolean;
begin
  if pnlMM then // hack: to skip MouseMove event
  begin
    pnlMM:=false;
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
    pnlMM:=true;

    enableDrag := true;
    if (Sender = pnlFilter) then
    begin
      v := v / 10;
      if v > 2 then v := 2
      else if v < 0.01 then v := 0.01;
      fcp.spatial_filter_radius := v;
      pEdit := @txtFilterRadius;
    end
    else if (Sender = pnlGamma) then
    begin
      if v > 10 then v := 10
      else if v < 0.01 then v := 0.01;
      fcp.gamma := v;
      pEdit := @txtGamma;
    end
    else if (Sender = pnlBrightness) then
    begin
      if v > 100 then v := 100
      else if v < 0.01 then v := 0.01;
      fcp.brightness := v;
      pEdit := @txtBrightness;
    end
    else if (Sender = pnlContrast) then
    begin
      if v > 10 then v := 10
      else if v < 0.01 then v := 0.01;
      fcp.contrast := v;
      pEdit := @txtContrast;
    end
    else if (Sender = pnlVibrancy) then
    begin
      if v > 10 then v := 10
      else if v < 0.01 then v := 0.01;
      fcp.vibrancy := v;
      pEdit := @txtVibrancy;
    end else exit;

    if enableDrag then begin
      pEdit^.Text := FloatToStr(v);
      //pEdit.Refresh;
      pnlDragged := True;
      // TODO: image preview (?)
      //DrawPreview;
    end;
  end;
end;

procedure TfrmPostProcess.DragPanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then exit;

  if pnlDragMode then
  begin
    SetCaptureControl(nil);
    pnlDragMode := false;
    Screen.Cursor := crDefault;

    if pnlDragged then
    begin
      //UpdateFlame;
      pnlDragged := False;
    end;
  end;
end;

procedure TfrmPostProcess.DragPanelDblClick(Sender: TObject);
var
  pValue: ^double;
  pDefaultValue: ^double;
  pEdit: ^TEdit;
begin
  if (Sender = pnlFilter) then
  begin
    pValue := @fcp.spatial_filter_radius;
    pDefaultValue := @Filter;
    pEdit := @txtFilterRadius;
  end
  else if (Sender = pnlGamma) then
  begin
    pValue := @fcp.gamma;
    pDefaultValue := @Gamma;
    pEdit := @txtGamma;
  end
  else if (Sender = pnlBrightness) then
  begin
{
    pValue := @fcp.brightness;
    pDefaultValue := @Brightness;
    pEdit := @txtBrightness;
}
    if fcp.brightness = Brightness then exit;
    fcp.brightness := Brightness;
    txtBrightness.Text := FloatToStr(fcp.brightness);
    exit;
  end
  else if (Sender = pnlContrast) then
  begin
    pValue := @fcp.contrast;
    pDefaultValue := @Contrast;
    pEdit := @txtContrast
  end
  else if (Sender = pnlVibrancy) then
  begin
    pValue := @fcp.vibrancy;
    pDefaultValue := @Vibrancy;
    pEdit := @txtVibrancy;
  end
  else exit; //assert(false);

  if pValue^ = pDefaultValue^ then exit;
  pValue^ := pDefaultValue^;
  pEdit^.Text := FloatToStr(pValue^);
  //UpdateFlame;
end;

procedure TfrmPostProcess.shBackMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   pnlBackColorClick(sender);
end;

procedure TfrmPostProcess.FormCreate(Sender: TObject);
begin
  btnApply.Caption := TextByKey('common-apply');
	pnlFilter.Caption := TextByKey('common-filterradius');
	pnlGamma.Caption := TextByKey('common-gamma');
	pnlBrightness.Caption := TextByKey('common-brightness');
	pnlContrast.Caption := TextByKey('common-contrast');
	pnlVibrancy.Caption := TextByKey('common-vibrancy');
	pnlBackground.Caption := TextByKey('common-background');
	pnlFilter.Hint := TextByKey('common-dragpanelhint');
	pnlGamma.Hint := TextByKey('common-dragpanelhint');
	pnlBrightness.Hint := TextByKey('common-dragpanelhint');
	pnlVibrancy.Hint := TextByKey('common-dragpanelhint');
	pnlContrast.Hint := TextByKey('common-dragpanelhint');
	self.Caption := TextByKey('postprocess-title');
	btnSave.Caption := TextByKey('postprocess-save');
  chkFitToWindow.Caption := TextByKey('postprocess-fittowindow');
end;

procedure TfrmPostProcess.chkFitToWindowClick(Sender: TObject);
begin
  {if (chkFitToWindow.Checked) then begin
    Image.Stretch := true;
    Image.Align := alClient;
  end else begin
    Image.Stretch := false;
    Image.Align := alNone;
  end; }
end;

end.
