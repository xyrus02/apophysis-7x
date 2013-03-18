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
unit SavePreset;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Translation;

type
  TSavePresetForm = class(TForm)
    txtPresetName: TEdit;
    Button1: TButton;
    Button2: TButton;
    pnlName: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SavePresetForm: TSavePresetForm;

implementation

{$R *.DFM}

procedure TSavePresetForm.Button1Click(Sender: TObject);
begin
  if txtPresetName.Text = '' then
  begin
    Application.MessageBox(PChar(TextByKey('savepreset-notitle')), 'Apophysis', 48);
    Exit;
  end;
end;

procedure TSavePresetForm.FormCreate(Sender: TObject);
begin
  self.Caption := TextBykey('savepreset-title');
  button1.Caption := TextByKey('common-ok');
  button2.Caption := TextByKey('common-cancel');
  pnlName.Caption := TextByKey('savepreset-name');
end;

end.
