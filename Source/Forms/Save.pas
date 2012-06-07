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
unit Save;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Translation;

type
  ESaveType = (stSaveParameters, stSaveAllParameters, stSaveGradient, stExportUPR);
  TSaveForm = class(TForm)
    txtFilename: TEdit;
    txtTitle: TEdit;
    btnSave: TButton;
    btnCancel: TButton;
    btnDefGradient: TSpeedButton;
    pnlTarget: TPanel;
    pnlName: TPanel;
    optUseOldFormat: TRadioButton;
    optUseNewFormat: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDefGradientClick(Sender: TObject);
  private
  public
    Title: string;
    Filename: string;
    SaveType : ESaveType;
  end;

var
  SaveForm: TSaveForm;

implementation

uses Main, Global, cmap;

{$R *.DFM}

function EntryExists(En, Fl: string): boolean;
{ Searches for existing identifier in parameter files }
var
  FStrings: TStringList;
  i: integer;
begin
  Result := False;
  if FileExists(Fl) then
  begin
    FStrings := TStringList.Create;
    try
      FStrings.LoadFromFile(Fl);
      for i := 0 to FStrings.Count - 1 do
        if Pos(LowerCase(En) + ' {', Lowercase(FStrings[i])) = 1 then
          Result := True;
    finally
      FStrings.Free;
    end
  end
  else
    Result := False;
end;

function SaveTypeTextKey(st : ESaveType) : string;
begin
  case st of
    stSaveParameters: Result := 'save-type-parameters';
    stSaveAllParameters: Result := 'save-type-allparameters';
    stSaveGradient: Result := 'save-type-gradient';
    stExportUPR: Result := 'save-type-exportupr';
  end;
end;

function SaveDefaultExt(st : ESaveType) : string;
begin
  case st of
    stSaveParameters: Result := 'flame';
    stSaveAllParameters: Result := 'flame';
    stSaveGradient: Result := 'gradient';
    stExportUPR: Result := 'upr';
  end;
end;

function SaveFilter(st : ESaveType): string;
begin
  case st of
    stSaveParameters: Result := Format('%s|*.flame;*.xml|%s|*.*',
      [TextByKey('common-filter-flamefiles'), TextByKey('common-filter-allfiles')]);
    stSaveAllParameters: Result := Format('%s|*.flame;*.xml|%s|*.*',
      [TextByKey('common-filter-flamefiles'), TextByKey('common-filter-allfiles')]);
    stSaveGradient: Result := Format('%s|*.gradient;*.ugr|%s|*.*',
      [TextByKey('common-filter-gradientfiles'), TextByKey('common-filter-allfiles')]);
    stExportUPR: Result := Format('%s|*.upr|%s|*.*',
      [TextByKey('common-filter-uprfiles'), TextByKey('common-filter-allfiles')]);
  end;

end;

procedure TSaveForm.btnSaveClick(Sender: TObject);
var
  t, f: string;
  check, onestr: boolean;
begin
  t := Trim(txtTitle.Text);
  f := Trim(txtFilename.Text);

  if ((t = '') and txtTitle.Enabled) then
  begin
    Application.MessageBox(PChar(TextByKey('save-status-notitle')), 'Apophysis', 48);
    Exit;
  end;
  if f = '' then
  begin
    Application.MessageBox(PChar(TextByKey('save-status-invalidfilename')), 'Apophysis', 48);
    Exit;
  end;
  if ExtractFileExt(f) = '' then
  begin
    Application.MessageBox(PChar(TextByKey('save-status-invalidfilename')), 'Apophysis', 48);
    Exit;
  end;

  if SaveType = stSaveParameters then
  begin
    check := XMLEntryExists(t, f);
    onestr := false;
  end
  else if SaveType = stSaveAllParameters then
  begin
    onestr := true;
    check := FileExists(f);
  end
  else
  begin
    onestr := false;
    t := CleanIdentifier(t);
    check := EntryExists(t, f);
  end;

  if check then begin if onestr then begin
    if Application.MessageBox(PChar(Format(TextByKey('save-status-alreadyexists2'), [f])),
      'Apophysis', 52) = ID_NO then exit;
  end else begin
    if Application.MessageBox(PChar(Format(TextByKey('save-status-alreadyexists'), [t, f])),
      'Apophysis', 52) = ID_NO then exit;
  end end;

  if (t = '*') then t := '';
  Title := t;
  Filename := f;
  ModalResult := mrOK;
end;

procedure TSaveForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TSaveForm.FormShow(Sender: TObject);
begin
  txtFilename.Text := Filename;
  txtTitle.Text := Title;
  //btnSave.SetFocus;
  self.Caption := TextByKey(SaveTypeTextKey(SaveType));
  {if (SaveType = stSaveParameters) or (SaveType = stSaveAllParameters) then
    self.Height := 160
  else self.Height := 120;  }

  if (SaveType = stSaveAllParameters) then txtTitle.Text := '';
  txtTitle.Enabled := (SaveType = stSaveParameters) or (SaveType = stExportUPR) or (SaveType = stSaveGradient);
  if (not txtTitle.Enabled) then pnlName.Font.Color := clGrayText
  else pnlName.Font.Color := clWindowText;

  optUseOldFormat.Visible := (SaveType = stSaveParameters) or (SaveType = stSaveAllParameters);
  optUseNewFormat.Visible := (SaveType = stSaveParameters) or (SaveType = stSaveAllParameters);
end;

procedure TSaveForm.btnDefGradientClick(Sender: TObject);
var
  fn:string;
  promptOverwrite: boolean;
begin
  promptOverwrite := (SaveType <> stSaveParameters);
  if OpenSaveFileDialog(self, SaveDefaultExt(SaveType), SaveFilter(SaveType),
    ExtractFilePath(txtFilename.Text), TextByKey('common-browse'), fn, false,
    (*promptOverwrite*)false, false, false) then
  txtFileName.Text := fn;
end;

procedure TSaveForm.FormCreate(Sender: TObject);
begin
   btnCancel.Caption := TextByKey('common-cancel');
   btnSave.Caption := TextByKey('common-ok');
   btnDefGradient.Hint := TextByKey('common-browse');
   pnlTarget.Caption := TextByKey('common-destination');
   pnlName.Caption := TextByKey('save-name');
   optUseOldFormat.Caption := TextByKey('save-oldformat');
   optUseNewFormat.Caption := TextByKey('save-newformat');
end;

end.

