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
unit Size;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TSizeTool = class(TForm)
    Label1: TLabel;
    txtWidth: TEdit;
    Bevel: TBevel;
    txtHeight: TEdit;
    Label2: TLabel;
    chkMaintain: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure txtHeightKeyPress(Sender: TObject; var Key: Char);
    procedure txtWidthKeyPress(Sender: TObject; var Key: Char);
    procedure chkMaintainClick(Sender: TObject);
    procedure txtWidthChange(Sender: TObject);
    procedure txtHeightChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SizeTool: TSizeTool;
  ImageHeight, ImageWidth: integer;
  ratio: double;
  xdif, ydif: integer;

implementation

uses Main, Registry, Global;

{$R *.DFM}

procedure TSizeTool.FormShow(Sender: TObject);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('Software\' + APP_NAME + '\Forms\SizeTool', False) then
    begin
      if Registry.ValueExists('Left') then
        SizeTool.Left := Registry.ReadInteger('Left');
      if Registry.ValueExists('Top') then
        SizeTool.Top := Registry.ReadInteger('Top');
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
  txtWidth.text := IntToStr(MainForm.Image.Width);
  txtHeight.text := IntToStr(MainForm.Image.Height);
end;

procedure AdjustWindow;
var
  xtot, ytot: integer;
begin
  xtot := ImageWidth + xdif;
  ytot := ImageHeight + ydif;
  if xtot > Screen.Width then
  begin
    MainForm.Left := 0;
    xtot := Screen.width;
  end;
  if ytot > Screen.height then
  begin
    MainForm.Top := 0;
    ytot := Screen.height;
  end;
  MainForm.Width := xtot;
  MainForm.Height := ytot;
end;

procedure TSizeTool.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Registry: TRegistry;
begin
  { Write position to registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('\Software\' + APP_NAME + '\Forms\SizeTool', True) then
    begin
      Registry.WriteInteger('Top', SizeTool.Top);
      Registry.WriteInteger('Left', SizeTool.Left);
    end;
  finally
    Registry.Free;
  end;
end;

procedure TSizeTool.FormActivate(Sender: TObject);
begin
  xdif := MainForm.Width - MainForm.Image.Width;
  ydif := MainForm.Height - MainForm.Image.Height;
end;

procedure TSizeTool.txtHeightKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    AdjustWindow;
  end;
end;

procedure TSizeTool.txtWidthKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    AdjustWindow;
  end;
end;

procedure TSizeTool.chkMaintainClick(Sender: TObject);
begin
  Ratio := ImageWidth / ImageHeight;
end;

procedure TSizeTool.txtWidthChange(Sender: TObject);
begin
  try
    ImageWidth := StrToInt(txtWidth.Text);
    if chkMaintain.checked and txtWidth.Focused then
    begin
      ImageHeight := Round(ImageWidth / ratio);
      txtHeight.Text := IntToStr(ImageHeight)
    end;
  except
  end;
end;

procedure TSizeTool.txtHeightChange(Sender: TObject);
begin
  try
    ImageHeight := StrToInt(txtHeight.Text);
    if chkMaintain.checked and txtHeight.Focused then
    begin
      ImageWidth := Round(ImageHeight * ratio);
      txtWidth.Text := IntToStr(ImageWidth)
    end;
  except
  end;
end;

end.

