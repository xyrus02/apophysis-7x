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
unit About;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Global, Translation;

type
  TAboutForm = class(TForm)
    btnOK: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    lblFlamecom: TLabel;
    Bevel1: TBevel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Bevel3: TBevel;
    Label17: TLabel;
    Label18: TLabel;
    Label16: TLabel;
    Label2: TLabel;
    Bevel2: TBevel;
    Label19: TLabel;
    Label5: TLabel;
    Label20: TLabel;
    Image1: TImage;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblCreditClick(Sender: TObject);
    procedure DevelopersClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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

procedure TAboutForm.FormShow(Sender: TObject);
begin
  //lblCredit.Caption := MainCp.Nick;
  //URL := MainCp.URL;
  //if URL <> '' then lblCredit.Font.color := clBlue else lblCredit.Font.color := clBlack;
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

procedure TAboutForm.FormCreate(Sender: TObject);
var s1, s2, s3:string;
begin
//  Label2.Caption:='version 2.08.500.7X.update'+ApophysisSVN;
//  Label16.Caption := APP_BUILD;
  btnOK.Caption := TextByKey('common-close');
  if (LanguageFile <> AvailableLanguages.Strings[0]) and (LanguageFile <> '') then
  begin
    LanguageInfo(LanguageFile, s1, s2);
    s3 := LanguageAuthor(LanguageFile);
    Label5.Visible := (s1 <> '') and (s3 <> '');
    Label5.Caption := s1 + ' translation contributed by: ' + s3;
  end;
  Label20.Caption := APP_VERSION;
end;

end.
