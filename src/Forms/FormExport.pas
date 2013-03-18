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
unit FormExport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, Translation;

type
  TExportDialog = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    btnBrowse: TSpeedButton;
    txtFilename: TEdit;
    SaveDialog: TSaveDialog;
    GroupBox3: TGroupBox;
    txtOversample: TEdit;
    txtFilterRadius: TEdit;
    txtDensity: TEdit;
    udOversample: TUpDown;
    GroupBox2: TGroupBox;
    chkMaintain: TCheckBox;
    cbWidth: TComboBox;
    cbHeight: TComboBox;
    GroupBox4: TGroupBox;
    cmbDepth: TComboBox;
    chkRender: TCheckBox;
    txtStrips: TEdit;
    udStrips: TUpDown;
    txtEstimator: TEdit;
    txtEstimatorMin: TEdit;
    txtEstimatorCurve: TEdit;
    txtGammaTreshold: TEdit;
    Panel1: TPanel;
    Label6: TLabel;
    Label15: TLabel;
    Label13: TLabel;
    Label16: TLabel;
    Label4: TPanel;
    Label5: TPanel;
    Label3: TPanel;
    Label1: TPanel;
    Label2: TPanel;
    Label7: TPanel;
    Label8: TPanel;
    Label9: TPanel;
    Label14: TPanel;
    Label12: TPanel;
    Label11: TPanel;
    Label10: TPanel;
    procedure Panel1Resize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure txtWidthChange(Sender: TObject);
    procedure chkMaintainClick(Sender: TObject);
    procedure txtHeightChange(Sender: TObject);
    procedure txtDensityChange(Sender: TObject);
    procedure txtFilterRadiusChange(Sender: TObject);
    procedure txtOversampleChange(Sender: TObject);
    procedure txtBatchesChange(Sender: TObject);
    procedure cmbDepthChange(Sender: TObject);
    procedure txtEstimatorChange(Sender: TObject);
    procedure txtEstimatorMinChange(Sender: TObject);
    procedure txtEstimatorCurveChange(Sender: TObject);
    procedure txtJittersChange(Sender: TObject);
    procedure txtGammaTresholdChange(Sender: TObject);
    procedure lblFlam3LinkClick(Sender: TObject);
  private
    FloatFormatSettings: TFormatSettings;
  public
    Filename: string;
    ImageWidth, ImageHeight, Oversample, Batches, Strips: Integer;
    Sample_Density, Filter_Radius: double;
    Estimator, EstimatorMin, EstimatorCurve: double;
    GammaTreshold: double;
    Jitters: integer;
  end;

var
  ExportDialog: TExportDialog;
  Ratio: double;

implementation
uses Global, Main, ShellAPI;

{$R *.DFM}

procedure TExportDialog.btnBrowseClick(Sender: TObject);
begin
  SaveDialog.InitialDir := ExtractFileDir(txtFilename.text);
  SaveDialog.Filename := txtFilename.Text;
  case ExportFileFormat of
    0: SaveDialog.DefaultExt := 'jpg';
    1: SaveDialog.DefaultExt := 'ppm';
  end;
  SaveDialog.filterIndex := ExportFileFormat;
  SaveDialog.Filter := Format('Portable Pixmap (*.ppm)|*.ppm|%s|*.jpg;*.jpeg|%s|*.png|%s|*.*',
        [TextByKey('common-filter-jpeg'), TextByKey('common-filter-png'),
         TextByKey('common-filter-allfiles')]);
  if SaveDialog.Execute then
  begin
    case SaveDialog.FilterIndex of
      1: txtFilename.Text := ChangeFileExt(SaveDialog.Filename, '.jpg');
      2: txtFilename.Text := ChangeFileExt(SaveDialog.Filename, '.ppm');
      3: txtFilename.Text := ChangeFileExt(SaveDialog.Filename, '.png');
    end;
    ExportFileFormat := SaveDialog.FilterIndex;
    renderPath := ExtractFilePath(SaveDialog.Filename);
  end;

end;

procedure TExportDialog.FormShow(Sender: TObject);
begin
  txtFilename.Text := Filename;
  cbWidth.Text := IntToStr(MainCp.Width);
  cbHeight.Text := IntToStr(MainCp.Height);
  ImageWidth := MainCp.Width;
  ImageHeight := MainCp.Height;
  txtDensity.text := FloatToStr(Sample_density);
//  if cmbDepth.ItemIndex <> 2 then
//    txtBatches.text := IntToStr(Round(Sample_density / 4));
  txtFilterRadius.text := FloatToStr(Filter_Radius);
  txtOversample.text := IntToSTr(Oversample);
  udOversample.Position := Oversample;
  Ratio := ImageWidth / ImageHeight;
  Batches := 1;
  Estimator := 9.0;
  EstimatorMin := 0.0;
  EstimatorCurve := 0.4;
  Jitters := 1;
  GammaTreshold := MainCP.gamma_threshold; //0.01;
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FloatFormatSettings);
  txtEstimator.Text := FloatToStr(Estimator, FloatFormatSettings);
  txtEstimatorMin.Text := FloatToStr(EstimatorMin, FloatFormatSettings);
  txtEstimatorCurve.Text := FloatToStr(EstimatorCurve, FloatFormatSettings);
//  txtJitters.Text := IntToStr(Jitters);
  txtGammaTreshold.Text := FloatToStr(GammaTreshold, FloatFormatSettings);
end;

procedure TExportDialog.btnOKClick(Sender: TObject);
begin
  Filename := txtFilename.text;
  ImageWidth := StrToInt(cbWidth.Text);
  ImageHeight := StrToInt(cbHeight.Text);
end;

procedure TExportDialog.txtWidthChange(Sender: TObject);
begin
  try
    ImageWidth := StrToInt(cbWidth.Text);
    if chkMaintain.checked and cbWidth.Focused then
    begin
      ImageHeight := Round(ImageWidth / ratio);
      cbHeight.Text := IntToStr(ImageHeight)
    end;
  except
  end;
end;

procedure TExportDialog.chkMaintainClick(Sender: TObject);
begin
  Ratio := ImageWidth / ImageHeight;
end;

procedure TExportDialog.txtHeightChange(Sender: TObject);
begin
  try
    ImageHeight := StrToInt(cbHeight.Text);
    if chkMaintain.checked and cbHeight.Focused then
    begin
      ImageWidth := Round(ImageHeight * ratio);
      cbWidth.Text := IntToStr(ImageWidth)
    end;
  except
  end;
end;

procedure TExportDialog.txtDensityChange(Sender: TObject);
begin
  try
    Sample_Density := StrToFloat(txtDensity.Text);
//    if cmbDepth.ItemIndex <> 2 then
//      txtBatches.text := IntToStr(Round(Sample_density / 4));
  except
  end;
end;

procedure TExportDialog.txtFilterRadiusChange(Sender: TObject);
begin
  try
    Filter_Radius := StrToFloat(txtFilterRadius.Text);
  except
  end;
end;

procedure TExportDialog.txtOversampleChange(Sender: TObject);
begin
  if StrToInt(txtOversample.Text) > udOversample.Max then
    txtOversample.Text := IntToStr(udOversample.Max);
  if StrToInt(txtOversample.Text) < udOversample.Min then
    txtOversample.Text := IntToStr(udOversample.Min);
  try
    Oversample := StrToInt(txtOversample.Text);
  except
  end;
end;

procedure TExportDialog.txtBatchesChange(Sender: TObject);
begin
{
  if StrToInt(txtBatches.Text) > udBatches.Max then
    txtBatches.Text := IntToStr(udBatches.Max);
  if StrToInt(txtBatches.Text) < udBatches.Min then
    txtBatches.Text := IntToStr(udBatches.Min);
  try
    Batches := StrToInt(txtBatches.Text);
  except
  end;
}  
end;

procedure TExportDialog.cmbDepthChange(Sender: TObject);
begin
{
  if cmbDepth.ItemIndex <> 2 then
    txtBatches.text := IntToStr(Round(Sample_density / 4))
  else
    txtBatches.text := IntToStr(1);
}    
end;

procedure TExportDialog.txtEstimatorChange(Sender: TObject);
begin
  Estimator := 0;
  try
    Estimator := StrToFloat(txtEstimator.Text, FloatFormatSettings);
  except
  end;
end;

procedure TExportDialog.txtEstimatorMinChange(Sender: TObject);
begin
  EstimatorMin := 0;
  try
    EstimatorMin := StrToFloat(txtEstimatorMin.Text, FloatFormatSettings);
  except
  end;
end;

procedure TExportDialog.txtEstimatorCurveChange(Sender: TObject);
begin
  EstimatorCurve := 0;
  try
    EstimatorCurve := StrToFloat(txtEstimatorCurve.Text, FloatFormatSettings);
  except
  end;
end;

procedure TExportDialog.txtJittersChange(Sender: TObject);
begin
{
  Jitters := 0;
  try
    Jitters := StrToInt(txtJitters.Text);
  except
  end;
}  
end;

procedure TExportDialog.txtGammaTresholdChange(Sender: TObject);
begin
  //GammaTreshold := 0.01;
  try
    GammaTreshold := StrToFloat(txtGammaTreshold.Text, FloatFormatSettings);
  except
  end;
end;

procedure TExportDialog.lblFlam3LinkClick(Sender: TObject);
begin
  ShellExecute(ValidParentForm(Self).Handle, 'open', PChar(TLabel(Sender).Hint),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TExportDialog.FormCreate(Sender: TObject);
begin
  btnOK.Caption := TextByKey('common-ok');
	btnCancel.Caption := TextByKey('common-cancel');
	Label1.Caption := TextByKey('common-width');
	Label2.Caption := TextByKey('common-height');
	GroupBox2.Caption := TextByKey('common-size');
	Label13.Caption := TextByKey('common-pixels');
	chkMaintain.Caption := TextByKey('common-keepaspect');
	GroupBox1.Caption := TextByKey('common-destination');
	Label10.Caption := TextByKey('common-filename');
	btnBrowse.Hint := TextByKey('common-browse');
	GroupBox3.Caption := TextByKey('common-quality');
	Label5.Caption := TextByKey('common-filterradius');
	Label4.Caption := TextByKey('common-density');
	Label3.Caption := TextByKey('common-oversample');
	Label14.Caption := TextByKey('common-gammathreshold');
	self.Caption := TextByKey('main-menu-file-exportflame');
	GroupBox4.Caption := TextByKey('export-paramoptions-title');
	Label7.Caption := TextByKey('export-paramoptions-bufferdepth');
	Label8.Caption := TextByKey('export-paramoptions-strips');
	Label9.Caption := TextByKey('export-paramoptions-estimatorradius');
	Label12.Caption := TextByKey('export-paramoptions-estimatorcurve');
	Label11.Caption := TextByKey('export-paramoptions-estimatormin');
	chkRender.Caption := TextByKey('export-paramoptions-dorender');
	Label6.Caption := TextByKey('export-paramoptions-warningtitle');
	Label15.Caption := TextByKey('export-paramoptions-warningtext');
end;

procedure TExportDialog.Panel1Resize(Sender: TObject);
begin
  Label15.Top := (Panel1.Height - 30) div 2 - Label15.Height div 2 + 25;
end;

end.

