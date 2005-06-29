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
unit Save;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TSaveForm = class(TForm)
    txtFilename: TEdit;
    txtTitle: TEdit;
    btnSave: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    btnDefGradient: TSpeedButton;
    SaveDialog: TSaveDialog;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDefGradientClick(Sender: TObject);
  private
  public
    Title: string;
    Filename: string;
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

procedure TSaveForm.btnSaveClick(Sender: TObject);
var
  warn, t, f: string;
  check: boolean;
begin
  if caption = 'Save Parameters' then
    warn := 'parameters'
  else if caption = 'Save Gradient' then
    warn := 'gradient'
  else if caption = 'Export UPR' then
    warn := 'UPR'
  else if caption = 'Save All Parameters' then
    warn := 'allparameters';
  t := Trim(txtTitle.Text);
  f := Trim(txtFilename.Text);

  if ((t = '') and txtTitle.Enabled) then
  begin
    Application.MessageBox(PChar('Please enter a title for the ' + warn + '.'), 'Apophysis', 48);
    Exit;
  end;
  if f = '' then
  begin
    Application.MessageBox('Please enter a file name.', 'Apophysis', 48);
    Exit;
  end;
  if ExtractFileExt(f) = '' then
  begin
    Application.MessageBox('Invalid file name.', 'Apophysis', 48);
    Exit;
  end;

  if warn = 'parameters' then
  begin
    check := XMLEntryExists(t, f);
  end
  else if warn = 'allparameters' then
  begin
    check := false;
  end
  else
  begin
    t := CleanIdentifier(t);
    check := EntryExists(t, f);
  end;

  if check then
    if Application.MessageBox(PChar(t + ' in ' + f + ' already exists.' + chr(13) + 'Do you want to replace it?'),
      'Apophysis', 52) = ID_NO then exit;

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
  btnSave.SetFocus;
end;

procedure TSaveForm.btnDefGradientClick(Sender: TObject);
begin
  if caption = 'Save Parameters' then
  begin
    SaveDialog.Title := 'Select Parameter File';
    SaveDialog.DefaultExt := 'flame';
    SaveDialog.Filter := 'Flame files (*.flame)|*.flame|Apophysis 1.0 Parameters (*.fla)|*.fla|Fractint IFS Files (*.ifs)|*.ifs';
  end
  else if caption = 'Save Gradient' then
  begin
    SaveDialog.Title := 'Select Gradient File';
    SaveDialog.DefaultExt := 'ugr';
    SaveDialog.Filter := 'Gradient files (*.ugr)|*.ugr'
  end
  else if caption = 'Export UPR' then
  begin
    SaveDialog.Title := 'Select Ultra Fractal Parameter File';
    SaveDialog.DefaultExt := 'upr';
    SaveDialog.Filter := 'UPR Files (*.upr)|*.upr';
  end
  else if caption = 'Save All Parameters' then
  begin
    SaveDialog.Title := 'Select Parameter File';
    SaveDialog.DefaultExt := 'flame';
    SaveDialog.Filter := 'Flame files (*.flame)|*.flame';
  end;
  SaveDialog.InitialDir := ExtractFilePath(txtFilename.Text);
  if SaveDialog.Execute then
    txtFileName.Text := SaveDialog.Filename;
end;

end.

