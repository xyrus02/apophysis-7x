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
unit Sheep;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Global, ControlPoint, Render;

type
  TSheepDialog = class(TForm)
    Button1: TButton;
    Button2: TButton;
    PrevPnl: TPanel;
    PreviewImage: TImage;
    txtNick: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    txtURL: TEdit;
    Label3: TLabel;
    txtPassword: TEdit;
    ScrollBar: TScrollBar;
    lblLicense: TLabel;
    lblLink: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ScrollBarChange(Sender: TObject);
    procedure lblLinkClick(Sender: TObject);
  private
    Render: TRenderer;
    bm: TBitmap;

    procedure DrawPreview;
    { Private declarations }
  public
    cp: TControlPoint;
    { Public declarations }
  end;

var
  SheepDialog: TSheepDialog;

implementation

uses Main, cmap, ShellAPI;

{$R *.DFM}

procedure TSheepDialog.DrawPreview;
begin
  Render.Stop;
  cp.Width := PreviewImage.Width;
  cp.Height := PreviewImage.Height;
  cp.sample_density := 10;
  cp.spatial_oversample := 2;
  cp.spatial_filter_radius := 0.4;
  cp.Zoom := 0;
  cp.center[0] := 0;
  cp.center[1] := 0;
  cp.pixels_per_unit := 60;
  cp.gamma := 4;
  cp.brightness := 4;
  cp.vibrancy := 1;
  GetCMap(cp.cmapindex, cp.hue_rotation, cp.cmap);
  Render.Compatibility := compatibility;
  Render.SetCP(cp);
  Render.Render;
  BM.Assign(Render.GetImage);
  PreviewImage.Picture.Graphic := bm;
end;

procedure TSheepDialog.FormShow(Sender: TObject);
var
  i: integer;
begin
  scrollbar.position := 0;
  txtNick.text := MainCp.nick;
  txtURL.text := MainCp.URL;
  txtPassword.text := SheepPW;
  cp.copy(MainCp);
  for i := 0 to 2 do cp.background[i] := 0;
  DrawPreview;
end;

procedure TSheepDialog.FormCreate(Sender: TObject);
begin
  bm := TbitMap.Create;
  cp := TControlPoint.Create;
  Render := TRenderer.Create;
end;

procedure TSheepDialog.FormDestroy(Sender: TObject);
begin
  bm.free;
  cp.free;
  Render.free;
end;

procedure TSheepDialog.Button1Click(Sender: TObject);
begin
  SheepNick := txtNick.Text;
  SheepURL := txtURL.Text;
  SheepPW := txtPassword.Text;
end;

procedure TSheepDialog.ScrollBarChange(Sender: TObject);
begin
  cp.hue_rotation := ScrollBar.Position / 100;
  DrawPreview;
end;

procedure TSheepDialog.lblLinkClick(Sender: TObject);
begin
  ShellExecute(ValidParentForm(Self).Handle, 'open', PChar('http://creativecommons.org/licenses/by-sa/1.0/'),
    nil, nil, SW_SHOWNORMAL);
end;

end.

