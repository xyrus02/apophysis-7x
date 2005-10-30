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
unit About;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TAboutForm = class(TForm)
    btnOK: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    lblFlamecom: TLabel;
    Label5: TLabel;
    Bevel1: TBevel;
    lblCredit: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    procedure Label15Click(Sender: TObject);
    procedure Label14Click(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure lblFlamecomClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblCreditClick(Sender: TObject);
    procedure DevelopersClick(Sender: TObject);
  private
    { Private declarations }
    URL :String;
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

uses Main, ShellAPI;

{$R *.DFM}

procedure TAboutForm.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TAboutForm.Label4Click(Sender: TObject);
begin
  ShellExecute(ValidParentForm(Self).Handle, 'open', PChar('http://www.apophysis.org'),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutForm.lblFlamecomClick(Sender: TObject);
begin
  ShellExecute(ValidParentForm(Self).Handle, 'open', PChar('http://flam3.com'),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutForm.FormShow(Sender: TObject);
begin
  lblCredit.Caption := MainCp.Nick;
  URL := MainCp.URL;
  if URL <> '' then lblCredit.Font.color := clBlue else lblCredit.Font.color := clBlack;
end;

procedure TAboutForm.lblCreditClick(Sender: TObject);
begin
  if URL <> '' then
  ShellExecute(ValidParentForm(Self).Handle, 'open', PChar(URL),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutForm.DevelopersClick(Sender: TObject);
begin
  ShellExecute(ValidParentForm(Self).Handle, 'open', PChar(TLabel(Sender).Hint),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutForm.Label13Click(Sender: TObject);
begin
  ShellExecute(ValidParentForm(Self).Handle, 'open', PChar('http://www.tmssoftware.com/'),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutForm.Label14Click(Sender: TObject);
begin
  ShellExecute(ValidParentForm(Self).Handle, 'open', PChar('http://www.destructor.de/'),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutForm.Label15Click(Sender: TObject);
begin
  ShellExecute(ValidParentForm(Self).Handle, 'open', PChar('http://pngdelphi.sourceforge.net/'),
    nil, nil, SW_SHOWNORMAL);
end;

end.
