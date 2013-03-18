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
unit FormFavorites;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Translation;

type
  TFavoritesForm = class(TForm)
    PageControl1: TPageControl;
    ListView: TListView;
    btnAdd: TButton;
    btnRemove: TButton;
    btnMoveUp: TButton;
    btnMoveDown: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure ListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnMoveUpClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject);
  private
    { Private declarations }
  public
    Faves: TStringList;
    { Public declarations }
  end;

var
  FavoritesForm: TFavoritesForm;

implementation

uses Global, ScriptForm;
{$R *.DFM}

procedure TFavoritesForm.FormShow(Sender: TObject);
var
  ListItem: TListItem;
  i: integer;
  s: string;
begin
  Faves.Text := Favorites.text;
  ListView.Items.Clear;
  for i := 0 to Favorites.Count - 1 do
  begin
    ListItem := ListView.Items.Add;
    s := ExtractFileName(Favorites[i]);
    s := Copy(s, 0, length(s) - Length(ExtractFileExt(s)));
    Listitem.Caption := s;
  end;
  if Favorites.Count <> 0 then ListView.Selected := ListView.Items[0]
  else
    btnRemove.Enabled := False;
  if ListView.Items.Count <= 1 then
  begin
    btnMoveUp.Enabled := False;
    btnMoveDown.Enabled := False;
  end;
end;

procedure TFavoritesForm.btnCancelClick(Sender: TObject);
begin
  Close
end;

procedure TFavoritesForm.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
  Faves.SaveToFile(AppPath + scriptFavsFilename);
end;

procedure TFavoritesForm.FormCreate(Sender: TObject);
begin
	btnOK.Caption := TextByKey('common-ok');
	btnCancel.Caption := TextByKey('common-cancel');
	self.Caption := TextByKey('favscripts-title');
	btnAdd.Caption := TextByKey('favscripts-add');
	btnRemove.Caption := TextByKey('favscripts-remove');
	btnMoveUp.Caption := TextByKey('favscripts-moveup');
	btnMoveDown.Caption := TextByKey('favscripts-movedown');

  Faves := TStringList.Create;
end;

procedure TFavoritesForm.FormDestroy(Sender: TObject);
begin
  Faves.Free;
end;

procedure TFavoritesForm.btnAddClick(Sender: TObject);
var
  ListItem: TListItem;
  i : integer;
  s: string;
begin
  ScriptEditor.MainOpenDialog.InitialDir := ScriptPath;
  ScriptEditor.MainOpenDialog.Filter := Format('%s|*.aposcript;*.asc|%s|*.*',
      [TextByKey('common-filter-script'),
       TextByKey('common-filter-allfiles')]);
  if ScriptEditor.mainOpenDialog.Execute then
  begin
    for i := 0 to Faves.Count  - 1 do
    begin
      if ScriptEditor.MainOpenDialog.Filename = Faves[i] then exit;
    end;

    Faves.add(ScriptEditor.MainOpenDialog.Filename);
    ListItem := ListView.Items.Add;
    s := ExtractFileName(ScriptEditor.MainOpenDialog.Filename);
    s := Copy(s, 0, length(s) - Length(ExtractFileExt(s)));
    Listitem.Caption := s;
    ListView.Selected := ListView.Items[ListView.Items.Count - 1];
    btnRemove.Enabled := True;
  end;
  if ListView.Items.Count <= 1 then
  begin
    btnMoveUp.Enabled := False;
    btnMoveDown.Enabled := False;
  end;
end;

procedure TFavoritesForm.btnRemoveClick(Sender: TObject);
var
  i: integer;
begin
  i := ListView.Selected.Index;
  Faves.Delete(i);
  ListView.Items[i].delete;
  if ListView.Items.Count <> 0 then
    if i < ListView.Items.Count then
      ListView.Selected := ListView.Items[i]
    else
      ListView.Selected := ListView.Items[ListView.Items.Count - 1]
  else
    btnRemove.Enabled := False;
  if ListView.Items.Count <= 1 then
  begin
    btnMoveUp.Enabled := False;
    btnMoveDown.Enabled := False;
  end;
end;

procedure TFavoritesForm.ListViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if (Item.Index = ListView.Items.Count - 1) then
    btnMoveDown.Enabled := False
  else
    btnMoveDown.Enabled := True;
  if (Item.Index = 0) then
    btnMoveUp.Enabled := False
  else
    btnMoveUp.Enabled := True;

  if (ListView.Items.Count <= 1) then
  begin
    btnMoveDown.Enabled := False;
    btnMoveUp.Enabled := False;
  end;
end;

procedure TFavoritesForm.btnMoveUpClick(Sender: TObject);
var
  i: integer;
  s: string;
begin
  i := ListView.Selected.Index;
  s := faves[i];
  Faves[i] := Faves[i - 1];
  Faves[i - 1] := s;
  s := ListView.Selected.Caption;
  ListView.Selected.Caption := Listview.Items[i - 1].Caption;
  ListView.Items[i - 1].Caption := s;
  ListView.Selected := ListView.Items[i - 1];
end;

procedure TFavoritesForm.btnMoveDownClick(Sender: TObject);
var
  i: integer;
  s: string;
begin
  i := ListView.Selected.Index;
  s := faves[i];
  Faves[i] := Faves[i + 1];
  Faves[i + 1] := s;
  s := ListView.Selected.Caption;
  ListView.Selected.Caption := Listview.Items[i + 1].Caption;
  ListView.Items[i + 1].Caption := s;
  ListView.Selected := ListView.Items[i + 1];
end;

end.

