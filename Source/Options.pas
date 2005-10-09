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
unit Options;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Buttons, Registry, Mask, CheckLst;

type
  TOptionsForm = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    OpenDialog: TOpenDialog;
    Tabs: TPageControl;
    GeneralPage: TTabSheet;
    chkConfirmDel: TCheckBox;
    JPEG: TGroupBox;
    DisplayPage: TTabSheet;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label1: TLabel;
    Label30: TLabel;
    txtLowQuality: TEdit;
    txtMediumQuality: TEdit;
    txtHighQuality: TEdit;
    grpRendering: TGroupBox;
    lblSampleDensity: TLabel;
    lblGamma: TLabel;
    lblBrightness: TLabel;
    lblVibrancy: TLabel;
    lblOversample: TLabel;
    lblFilterRadius: TLabel;
    txtSampleDensity: TEdit;
    txtGamma: TEdit;
    txtBrightness: TEdit;
    txtVibrancy: TEdit;
    txtOversample: TEdit;
    txtFilterRadius: TEdit;
    RandomPage: TTabSheet;
    gpNumberOfTransforms: TGroupBox;
    Label28: TLabel;
    Label29: TLabel;
    txtMinXForms: TEdit;
    txtMaxXforms: TEdit;
    chkKeepBackground: TCheckBox;
    TabSheet6: TTabSheet;
    UPRPage: TPageControl;
    GroupBox11: TGroupBox;
    Label26: TLabel;
    Label27: TLabel;
    txtUPRWidth: TEdit;
    txtUPRHeight: TEdit;
    gpFlameTitlePrefix: TGroupBox;
    txtRandomPrefix: TEdit;
    gpMutationTransforms: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    txtMinMutate: TEdit;
    txtMaxMutate: TEdit;
    gpForcedSymmetry: TGroupBox;
    cmbSymType: TComboBox;
    txtSymOrder: TEdit;
    Label7: TLabel;
    Label9: TLabel;
    VariationsPage: TTabSheet;
    GroupBox17: TGroupBox;
    btnSetAll: TButton;
    btnClearAll: TButton;
    TabSheet1: TTabSheet;
    grpGradient: TRadioGroup;
    GroupBox3: TGroupBox;
    txtMinNodes: TEdit;
    txtMaxNodes: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    txtMinHue: TEdit;
    txtMaxHue: TEdit;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    txtMinSat: TEdit;
    Label34: TLabel;
    txtMaxSat: TEdit;
    Label35: TLabel;
    txtMinLum: TEdit;
    Label36: TLabel;
    txtMaxLum: TEdit;
    udMinNodes: TUpDown;
    udMaxNodes: TUpDown;
    udMinHue: TUpDown;
    udMaxHue: TUpDown;
    udMinSat: TUpDown;
    udmaxSat: TUpDown;
    udMinLum: TUpDown;
    udMaxLum: TUpDown;
    udMinXforms: TUpDown;
    udMaxXForms: TUpDown;
    udMinMutate: TUpDown;
    udMaxMutate: TUpDown;
    udSymOrder: TUpDown;
    GroupBox1: TGroupBox;
    txtBatchSize: TEdit;
    udBatchSize: TUpDown;
    GroupBox9: TGroupBox;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    txtFIterDensity: TEdit;
    txtUPRFilterRadius: TEdit;
    txtUPROversample: TEdit;
    GroupBox4: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    txtFCIdent: TEdit;
    txtFCFile: TEdit;
    GroupBox5: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    txtFFIdent: TEdit;
    txtFFFile: TEdit;
    chkAdjustDensity: TCheckBox;
    TabSheet2: TTabSheet;
    GroupBox6: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    txtNick: TEdit;
    txtURL: TEdit;
    Label15: TLabel;
    txtPassword: TEdit;
    GroupBox8: TGroupBox;
    Label17: TLabel;
    txtServer: TEdit;
    chkResize: TCheckBox;
    Paths: TTabSheet;
    GroupBox10: TGroupBox;
    btnDefGradient: TSpeedButton;
    Label25: TLabel;
    txtDefParameterFile: TEdit;
    GroupBox12: TGroupBox;
    Label23: TLabel;
    txtDefSmoothFile: TEdit;
    btnSmooth: TSpeedButton;
    GroupBox7: TGroupBox;
    btnRenderer: TSpeedButton;
    Label16: TLabel;
    txtRenderer: TEdit;
    GroupBox14: TGroupBox;
    SpeedButton2: TSpeedButton;
    Label37: TLabel;
    txtLibrary: TEdit;
    clbVarEnabled: TCheckListBox;
    GroupBox16: TGroupBox;
    cbNrTheads: TComboBox;
    chkShowTransparency: TCheckBox;
    rgReferenceMode: TRadioGroup;
    GroupBox13: TGroupBox;
    Label8: TLabel;
    Label10: TLabel;
    txtNumtries: TEdit;
    txtTryLength: TEdit;
    txtJPEGquality: TComboBox;
    rgTransparency: TRadioGroup;
    Label24: TLabel;
    txtSymNVars: TEdit;
    udSymNVars: TUpDown;
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnDefGradientClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSmoothClick(Sender: TObject);
    procedure cmbSymTypeChange(Sender: TObject);
    procedure btnSetAllClick(Sender: TObject);
    procedure btnClearAllClick(Sender: TObject);
    procedure txtMinNodesChange(Sender: TObject);
    procedure txtMaxNodesChange(Sender: TObject);
    procedure txtMaxHueChange(Sender: TObject);
    procedure txtMaxSatChange(Sender: TObject);
    procedure txtMaxLumChange(Sender: TObject);
    procedure txtMinHueChange(Sender: TObject);
    procedure txtMinSatChange(Sender: TObject);
    procedure txtMinLumChange(Sender: TObject);
    procedure txtMinXFormsChange(Sender: TObject);
    procedure txtMaxXformsChange(Sender: TObject);
    procedure txtMinMutateChange(Sender: TObject);
    procedure txtMaxMutateChange(Sender: TObject);
    procedure btnRendererClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OptionsForm: TOptionsForm;

implementation

{$R *.DFM}

uses
  Main, Global, Editor, ControlPoint, XFormMan;

procedure TOptionsForm.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TOptionsForm.FormShow(Sender: TObject);
var
  Registry: TRegistry;
  i: integer;
begin
  { Read posution from registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('Software\' + APP_NAME + '\Forms\Options', False) then
    begin
      if Registry.ValueExists('Left') then
        OptionsForm.Left := Registry.ReadInteger('Left');
      if Registry.ValueExists('Top') then
        OptionsForm.Top := Registry.ReadInteger('Top');
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;

  { General tab }
  txtDefParameterFile.Text := DefFlameFile;
  txtDefSmoothFile.Text := defSmoothPaletteFile;
  txtNumtries.text := IntToStr(Numtries);
  txtTryLength.text := IntToStr(Trylength);
  chkConfirmDel.Checked := ConfirmDelete;
  txtJPEGQuality.text := IntToStr(JPEGQuality);
  rgReferenceMode.IteMindex := ReferenceMode;
  udBatchSize.Position := BatchSize;
  chkResize.checked := ResizeOnLoad;
  rgTransparency.ItemIndex :=  PNGTransparency;
  chkShowTransparency.Checked := ShowTransparency;
  if NrTreads <= 1 then
    cbNrTheads.ItemIndex := 0
  else
    cbNrTheads.text := intTostr(NrTreads);

  { Display tab }
  txtSampleDensity.Text := FloatToStr(defSampleDensity);
  txtGamma.Text := FloatToStr(defGamma);
  txtBrightness.Text := FloatToStr(defBrightness);
  txtVibrancy.Text := FloatToStr(defVibrancy);
  txtOversample.Text := IntToStr(defOversample);
  txtFilterRadius.Text := FloatToStr(defFilterRadius);
  txtLowQuality.Text := FloatToStr(prevLowQuality);
  txtMediumQuality.Text := FloatToStr(prevMediumQuality);
  txtHighQuality.Text := FloatToStr(prevHighQuality);

  { Random tab }
  udMinXforms.Position := randMinTransforms;
  udMaxXforms.Position := randMaxTransforms;
  udMinMutate.Position := mutantMinTransforms;
  udMaxMutate.Position := mutantMaxTransforms;
  txtRandomPrefix.text := RandomPrefix;
  chkKeepbackground.Checked := KeepBackground;
  cmbSymType.ItemIndex := SymmetryType;
  if (SymmetryType = 0) or (SymmetryType = 1) then
  begin
    txtSymOrder.enabled := false;
    txtSymNVars.enabled := false;
  end;
  udSymOrder.Position := SymmetryOrder;
  udSymNVars.Position := SymmetryNVars;

  { Variations tab }
  UnpackVariations(VariationOptions);
  for i := 0 to NRVAR -1 do
    clbVarEnabled.Checked[i] := Variations[i];

  { Gradient tab }
  grpGradient.ItemIndex := randGradient;
  udMinNodes.Position := MinNodes;
  udMaxNodes.Position := MaxNodes;
  udMinHue.Position := MinHue;
  udMinSat.Position := MinSat;
  udMinLum.Position := MinLum;
  udMaxHue.Position := MaxHue;
  udMaxSat.Position := MaxSat;
  udMaxLum.Position := MaxLum;

  { UPR tab }
  txtFIterDensity.text := IntToStr(UPRSampleDensity);
  txtUPRFilterRadius.text := FloatToStr(UPRFilterRadius);
  txtUPROversample.text := IntToStr(UPROversample);
  txtFCIdent.text := UPRColoringIdent;
  txtFCFile.text := UPRColoringFile;
  txtFFIdent.text := UPRFormulaIdent;
  txtFFFile.text := UPRFormulaFile;
  txtUPRWidth.text := IntToStr(UPRWidth);
  txtUPRHeight.text := IntToStr(UPRHeight);
  chkAdjustDensity.checked := UPRAdjustDensity;

  { UPR tab }
  txtNick.Text := SheepNick;
  txtURL.Text := SheepURL;
  txtPassword.Text := SheepPW;
  txtRenderer.Text := HqiPath;
  txtServer.Text := SheepServer;

  txtLibrary.text := defLibrary;
end;

procedure TOptionsForm.btnOKClick(Sender: TObject);
var
  v: integer;
  i: integer;
begin

  { Variations tab }
  { Get option values from controls. Disallow bad values }
  for i := 0 to NRVAR -1 do
    Variations[i] := clbVarEnabled.Checked[i];

  v := PackVariations;
  if v <> 0 then VariationOptions := v
  else
  begin
    Application.MessageBox('You must select at least one variation.', 'Apophysis', 48);
    Tabs.ActivePage := VariationsPage;
    Exit;
  end;

  { General tab }
  defFlameFile := txtDefParameterFile.Text;
  defSmoothPaletteFile := txtDefSmoothFile.Text;
  JPEGQuality := StrToInt(txtJPEGQuality.text);
  Numtries := StrToInt(txtNumtries.text);
  if NumTries < 1 then Numtries := 1;
  Trylength := StrToInt(txtTrylength.text);
  if Trylength < 100 then trylength := 100;
  if JPEGQuality > 100 then JPEGQuality := 100;
  if JPEGQuality < 1 then JPEGQuality := 100;
  BatchSize := udBatchSize.Position;
  if BatchSize < 1 then BatchSize := 1;
  if BatchSize > 300 then BatchSize := 300;

  PNGTransparency := rgTransparency.ItemIndex;
  ShowTransparency := chkShowTransparency.Checked;

  NrTreads := StrToIntDef(cbNrTheads.text, 0);
  ConfirmDelete := chkConfirmDel.Checked;
  ReferenceMode := rgReferenceMode.ItemIndex;
  ResizeOnLoad := chkResize.checked;
  { Display tab }
  defSampleDensity := StrToFloat(txtSampleDensity.Text);
  if defSampleDensity > 100 then defSampleDensity := 100;
  if defSampleDensity <= 0 then defSampleDensity := 0.1;
  defGamma := StrToFloat(txtGamma.Text);
  if defGamma < 0.1 then defGamma := 0.1;
  defBrightness := StrToFloat(txtBrightness.Text);
  if defBrightness < 0.1 then defBrightness := 0.1;
  defVibrancy := StrToFloat(txtVibrancy.Text);
  if defVibrancy < 0 then defVibrancy := 0.1;
  defFilterRadius := StrToFloat(txtFilterRadius.Text);
  if defFilterRadius <= 0 then defFilterRadius := 0.1;
  defOversample := StrToInt(txtOversample.Text);
  if defOversample > 4 then defOversample := 4;
  if defOversample < 1 then defOversample := 1;
  prevLowQuality := StrToFloat(txtLowQuality.Text);
  if prevLowQuality > 100 then prevLowQuality := 100;
  if prevLowQuality < 0.01 then prevLowQuality := 0.01;
  prevMediumQuality := StrToFloat(txtMediumQuality.Text);
  if prevMediumQuality > 100 then prevMediumQuality := 100;
  if prevMediumQuality < 0.01 then prevMediumQuality := 0.01;
  prevHighQuality := StrToFloat(txtHighQuality.Text);
  if prevHighQuality > 100 then prevHighQuality := 100;
  if prevHighQuality < 0.01 then prevHighQuality := 0.01;

  { Random tab }
  randMinTransforms := udMinXforms.Position;
  randMaxTransforms := udMaxXforms.Position;
  mutantMinTransforms := udMinMutate.Position;
  mutantMaxTransforms := udMaxMutate.Position;
  RandomPrefix := txtRandomPrefix.text;
  SymmetryType := cmbSymType.ItemIndex;
  SymmetryOrder := udSymOrder.Position;
  SymmetryNVars := udSymNVars.Position;
  KeepBackground := chkKeepbackground.Checked;

  {Gradient tab }
  randGradient := grpGradient.ItemIndex;
  MinNodes := udMinNodes.Position;
  MaxNodes := udMaxNodes.Position;
  MinHue := udMinHue.Position;
  MinSat := udMinSat.Position;
  MinLum := udMinLum.Position;
  MaxHue := udMaxHue.Position;
  MaxSat := udMaxSat.Position;
  MaxLum := udMaxLum.Position;

  { UPR options }
  UPRSampleDensity := StrToInt(txtFIterDensity.text);
  UPRFilterRadius := StrToFloat(txtUPRFilterRadius.text);
  UPROversample := StrToInt(txtUPROversample.text);
  UPRColoringIdent := txtFCIdent.text;
  UPRColoringFile := txtFCFile.text;
  UPRFormulaIdent := txtFFIdent.text;
  UPRFormulaFile := txtFFFile.text;
  UPRAdjustDensity := chkAdjustDensity.checked;
  UPRWidth := StrToInt(txtUPRWidth.text);
  UPRHeight := StrToInt(txtUPRHeight.text);

  { Sheep options }
  SheepNick := txtNick.Text;
  SheepURL := txtURL.Text;
  SheepPW := txtPassword.text;
  HqiPath := txtRenderer.text;
  SheepServer := txtServer.text;

  {Paths}
  defLibrary := txtLibrary.text;

  Close;
end;

procedure TOptionsForm.btnDefGradientClick(Sender: TObject);
begin
  OpenDialog.Filter := 'Flame files (*.flame)|*.flame|Apophysis 1.0 parameters (*.apo;*.fla)|*.apo;*.fla';
  OpenDialog.FileName := '';
  if OpenDialog.Execute then
  begin
    txtDefParameterFile.text := OpenDialog.FileName;
  end;
end;

procedure TOptionsForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Registry: TRegistry;
begin
  { Write position to registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('\Software\' + APP_NAME + '\Forms\Options', True) then
    begin
      Registry.WriteInteger('Top', OptionsForm.Top);
      Registry.WriteInteger('Left', OptionsForm.Left);
    end;
  finally
    Registry.Free;
  end;

end;

procedure TOptionsForm.btnSmoothClick(Sender: TObject);
begin
  OpenDialog.Filter := 'Gradient files (*.ugr)|*.ugr';
  OpenDialog.InitialDir := ExtractFilePath(defSmoothPaletteFile);
  OpenDialog.FileName := '';
  OpenDialog.DefaultExt := 'ugr';
  if OpenDialog.Execute then
  begin
    txtDefSmoothFile.text := OpenDialog.FileName;
  end;
end;

procedure TOptionsForm.cmbSymTypeChange(Sender: TObject);
begin
  if (cmbSymType.ItemIndex = 0) or (cmbSymType.ItemIndex = 1) then
  begin
    txtSymOrder.enabled := false;
    txtSymNVars.enabled := false;
  end else
  begin
    txtSymOrder.enabled := true;
    txtSymNVars.enabled := true;
  end;
end;

procedure TOptionsForm.btnSetAllClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to NRVAR - 1 do
    clbVarEnabled.Checked[i] := True;
end;

procedure TOptionsForm.btnClearAllClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to NRVAR - 1 do
    clbVarEnabled.Checked[i] := False;
end;

procedure TOptionsForm.txtMinNodesChange(Sender: TObject);
begin
  if StrToInt(txtMinNodes.Text) > udMaxNodes.position then
    udMaxNodes.Position := StrToInt(txtMinNodes.Text);
end;

procedure TOptionsForm.txtMaxNodesChange(Sender: TObject);
begin
  if StrToInt(txtMaxNodes.Text) < udMinNodes.position then
    udMinNodes.Position := StrToInt(txtMaxNodes.Text);
end;

procedure TOptionsForm.txtMaxHueChange(Sender: TObject);
begin
  if StrToInt(txtMaxHue.Text) < udMinHue.position then
    udMinHue.Position := StrToInt(txtMaxHue.Text);
end;

procedure TOptionsForm.txtMaxSatChange(Sender: TObject);
begin
  if StrToInt(txtMaxSat.Text) < udMinSat.position then
    udMinSat.Position := StrToInt(txtMaxSat.Text);
end;

procedure TOptionsForm.txtMaxLumChange(Sender: TObject);
begin
  if StrToInt(txtMaxLum.Text) < udMinLum.position then
    udMinLum.Position := StrToInt(txtMaxLum.Text);
end;

procedure TOptionsForm.txtMinHueChange(Sender: TObject);
begin
  if StrToInt(txtMinHue.Text) > udMaxHue.position then
    udMaxHue.Position := StrToInt(txtMinHue.Text);
end;

procedure TOptionsForm.txtMinSatChange(Sender: TObject);
begin
  if StrToInt(txtMinSat.Text) > udMaxSat.position then
    udMaxSat.Position := StrToInt(txtMinSat.Text);
end;

procedure TOptionsForm.txtMinLumChange(Sender: TObject);
begin
  if StrToInt(txtMinLum.Text) > udMaxLum.position then
    udMaxLum.Position := StrToInt(txtMinLum.Text);
end;

procedure TOptionsForm.txtMinXFormsChange(Sender: TObject);
begin
  if StrToInt(txtMinXForms.Text) > udMaxXForms.position then
    udMaxXFOrms.Position := StrToInt(txtMinXForms.Text);
end;

procedure TOptionsForm.txtMaxXformsChange(Sender: TObject);
begin
  if StrToInt(txtMaxXForms.Text) < udMinXForms.position then
    udMinXForms.Position := StrToInt(txtMaxXforms.Text);
end;

procedure TOptionsForm.txtMinMutateChange(Sender: TObject);
begin
  if StrToInt(txtMinMutate.Text) > udMaxMutate.position then
    udMaxMutate.Position := StrToInt(txtMinMutate.Text);
end;

procedure TOptionsForm.txtMaxMutateChange(Sender: TObject);
begin
  if StrToInt(txtMaxMutate.Text) < udMinMutate.position then
    udMinMutate.Position := StrToInt(txtMaxMutate.Text);
end;

procedure TOptionsForm.btnRendererClick(Sender: TObject);
begin
  OpenDialog.Filter := 'Executables (*.exe)|*.exe';
  OpenDialog.InitialDir := ExtractFilePath(HqiPath);
  OpenDialog.FileName := '';
  if OpenDialog.Execute then
  begin
    txtRenderer.text := OpenDialog.FileName;
  end;

end;

procedure TOptionsForm.SpeedButton2Click(Sender: TObject);
begin
  OpenDialog.Filter := 'Script files (*.asc)|*.asc';
  OpenDialog.InitialDir := ExtractFilePath(defLibrary);
  OpenDialog.FileName := '';
  if OpenDialog.Execute then
  begin
    txtLibrary.text := OpenDialog.FileName;
  end;
end;

procedure TOptionsForm.FormCreate(Sender: TObject);
var
  i: integer;
begin
  for i:= 0 to NRVAR - 1 do begin
    clbVarEnabled.AddItem(varnames(i),nil);
  end;
end;

end.

