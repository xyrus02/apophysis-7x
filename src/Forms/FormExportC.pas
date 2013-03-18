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
unit FormExportC;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, Translation;

type
  TExportCDialog = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    btnBrowse: TSpeedButton;
    txtFilename: TEdit;
    SaveDialog: TSaveDialog;
    GroupBox3: TGroupBox;
    txtOversample: TEdit;
    txtFilterRadius: TEdit;
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
    txtDensity: TEdit;
    Label4: TPanel;
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
    procedure txtGammaTresholdChange(Sender: TObject);
  private
    FloatFormatSettings: TFormatSettings;
    Estimator, EstimatorMin, EstimatorCurve: double;
    Jitters, Batches, Strips: integer;
  public
    Filename: string;
    ImageWidth, ImageHeight, Oversample: Integer;
    Sample_Density, Filter_Radius: double;
    GammaTreshold: double;
  end;

var
  ExportCDialog: TExportCDialog;
  Ratio: double;

implementation
uses Global, Main, ShellAPI;

{$R *.DFM}

procedure TExportCDialog.btnBrowseClick(Sender: TObject);
begin
  SaveDialog.InitialDir := ExtractFileDir(txtFilename.text);
  SaveDialog.Filename := txtFilename.Text;
  SaveDialog.DefaultExt := 'png';
  SaveDialog.filterIndex := ExportFileFormat;
  SaveDialog.Filter := Format('%s|*.png|%s|*.*',
        [TextByKey('common-filter-png'),
         TextByKey('common-filter-allfiles')]);
  if SaveDialog.Execute then
  begin
    ExportFileFormat := SaveDialog.FilterIndex;
    renderPath := ExtractFilePath(SaveDialog.Filename);
  end;

end;

procedure TExportCDialog.FormShow(Sender: TObject);
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

procedure TExportCDialog.btnOKClick(Sender: TObject);
begin
  Filename := txtFilename.text;
  ImageWidth := StrToInt(cbWidth.Text);
  ImageHeight := StrToInt(cbHeight.Text);
end;

procedure TExportCDialog.txtWidthChange(Sender: TObject);
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

procedure TExportCDialog.chkMaintainClick(Sender: TObject);
begin
  Ratio := ImageWidth / ImageHeight;
end;

procedure TExportCDialog.txtHeightChange(Sender: TObject);
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

procedure TExportCDialog.txtDensityChange(Sender: TObject);
begin
  try
    Sample_Density := StrToFloat(txtDensity.Text);
//    if cmbDepth.ItemIndex <> 2 then
//      txtBatches.text := IntToStr(Round(Sample_density / 4));
  except
  end;
end;

procedure TExportCDialog.txtFilterRadiusChange(Sender: TObject);
begin
  try
    Filter_Radius := StrToFloat(txtFilterRadius.Text);
  except
  end;
end;

procedure TExportCDialog.txtOversampleChange(Sender: TObject);
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

procedure TExportCDialog.txtGammaTresholdChange(Sender: TObject);
begin
  //GammaTreshold := 0.01;
  try
    GammaTreshold := StrToFloat(txtGammaTreshold.Text, FloatFormatSettings);
  except
  end;
end;

procedure TExportCDialog.FormCreate(Sender: TObject);
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
	self.Caption := TextByKey('main-menu-file-exportchaotica');
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

end.

