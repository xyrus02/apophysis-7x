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

unit LoadTracker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Global, Settings, ExtCtrls, Translation;

type
  TLoadForm = class(TForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    Button2: TButton;
    Bevel1: TBevel;
    Output: TMemo;
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoadForm: TLoadForm;

implementation

{$R *.dfm}

procedure TLoadForm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TLoadForm.CheckBox1Click(Sender: TObject);
begin
  AutoOpenLog := CheckBox1.Checked;
end;

procedure TLoadForm.FormCreate(Sender: TObject);
begin
  Button2.Caption := TextByKey('common-clear');
	Button1.Caption := TextByKey('common-close');
	self.Caption := TextByKey('messages-title');
	CheckBox1.Caption := TextByKey('messages-openautomatically');
  CheckBox1.Checked := AutoOpenLog;
end;

procedure TLoadForm.Button2Click(Sender: TObject);
begin
  Output.Text := '';
end;

procedure TLoadForm.FormResize(Sender: TObject);
begin
  CheckBox1.Left := 2;
  Checkbox1.Top := self.ClientHeight - Checkbox1.Height - 2;
  CheckBox1.Width := self.ClientWidth - button1.Width - button2.Width - 8;

  Button1.Left := self.ClientWidth - button1.Width - button2.Width - 4;
  Button1.Top := self.ClientHeight - Checkbox1.Height - 2 + Checkbox1.Height div 2 - Button1.Height div 2;

  Button2.Left := self.ClientWidth - button2.Width - 2;
  Button2.Top := Button1.Top;

  Bevel1.Left := 2;
  Bevel1.Top := 2;
  Bevel1.Width := self.ClientWidth - 4;
  Bevel1.Height := self.ClientHeight - 6 - checkbox1.Height;

  Output.Left := Bevel1.Left + 2;
  Output.Top := Bevel1.Top + 2;
  Output.Width := Bevel1.Width - 4;
  Output.Height := Bevel1.Height -4;
end;

end.
