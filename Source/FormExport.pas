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
unit FormExport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls;

type
  TExportDialog = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    btnBrowse: TSpeedButton;
    Label10: TLabel;
    txtFilename: TEdit;
    SaveDialog: TSaveDialog;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    txtOversample: TEdit;
    txtFilterRadius: TEdit;
    txtDensity: TEdit;
    udOversample: TUpDown;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    chkMaintain: TCheckBox;
    cbWidth: TComboBox;
    cbHeight: TComboBox;
    GroupBox4: TGroupBox;
    Label6: TLabel;
    txtBatches: TEdit;
    udBatches: TUpDown;
    Label7: TLabel;
    cmbDepth: TComboBox;
    chkRender: TCheckBox;
    Label8: TLabel;
    txtStrips: TEdit;
    udStrips: TUpDown;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    txtJitters: TEdit;
    txtEstimator: TEdit;
    txtEstimatorMin: TEdit;
    txtEstimatorCurve: TEdit;
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
  private
    FloatFormatSettings: TFormatSettings;
  public
    Filename: string;
    ImageWidth, ImageHeight, Oversample, Batches, Strips: Integer;
    Sample_Density, Filter_Radius: double;
    Estimator, EstimatorMin, EstimatorCurve, Jitters: double;
  end;

var
  ExportDialog: TExportDialog;
  Ratio: double;

implementation
uses Global, Main;

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
  SaveDialog.Filter := 'JPEG image (*.jpg) |*.jpg|PPM image (*.ppm)|*.ppm|PNG Image (*.png)|*.png';
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
  if cmbDepth.ItemIndex <> 2 then
    txtBatches.text := IntToStr(Round(Sample_density / 4));
  txtFilterRadius.text := FloatToStr(Filter_Radius);
  txtOversample.text := IntToSTr(Oversample);
  udOversample.Position := Oversample;
  Ratio := ImageWidth / ImageHeight;
  Estimator := 5.0;
  EstimatorMin := 0.0;
  EstimatorCurve := 0.6;
  Jitters := 1;
  txtEstimator.Text := '5.0';
  txtEstimatorMin.Text := '0.0';
  txtEstimatorCurve.Text := '0.6';
  txtJitters.Text := '1';

  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FloatFormatSettings);
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
    if cmbDepth.ItemIndex <> 2 then
      txtBatches.text := IntToStr(Round(Sample_density / 4));
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
  if StrToInt(txtBatches.Text) > udBatches.Max then
    txtBatches.Text := IntToStr(udBatches.Max);
  if StrToInt(txtBatches.Text) < udBatches.Min then
    txtBatches.Text := IntToStr(udBatches.Min);
  try
    Batches := StrToInt(txtBatches.Text);
  except
  end;
end;

procedure TExportDialog.cmbDepthChange(Sender: TObject);
begin
  if cmbDepth.ItemIndex <> 2 then
    txtBatches.text := IntToStr(Round(Sample_density / 4))
  else
    txtBatches.text := IntToStr(1);
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
  Jitters := 0;
  try
    Jitters := StrToFloat(txtJitters.Text, FloatFormatSettings);
  except
  end;
end;

end.

