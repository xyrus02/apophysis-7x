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

unit ImageColoring;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, cmap;

type
  TfrmImageColoring = class(TForm)
    cbEnable: TCheckBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cmbPalette1: TComboBox;
    Label4: TLabel;
    imgPal1: TImage;
    imgpal2: TImage;
    Label5: TLabel;
    cmbPalette2: TComboBox;
    procedure cmbPalette2Change(Sender: TObject);
    procedure cmbPalette1DrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure cmbPalette1Change(Sender: TObject);
  private
    FPal1: TColorMap;
    FPal2: TColorMap;
    FBkuPal1: TColorMap;
    FBkuPal2: TColorMap;
    Index1: integer;
    Index2: integer;

    procedure DrawPalette1;
    procedure DrawPalette2;

    procedure Apply;
  public
    procedure Update; override;
  end;

var
  frmImageColoring: TfrmImageColoring;

implementation

{$R *.dfm}

uses
  Main, Editor, Mutate, GradientHlpr;

{ TfrmImageColoring }

procedure TfrmImageColoring.Update;
begin
//  FPal1 := MainCP.Pal;
  FBkuPal1 := FPal1;
end;

procedure TfrmImageColoring.cmbPalette1Change(Sender: TObject);
begin
  Index1 := cmbPalette1.ItemIndex;
  GetCmap(Index1, 1, FPal1);
  FBkuPal1 := FPal1;
//  ScrollBar.Position := 0;
  DrawPalette1;
  Apply;
end;

procedure TfrmImageColoring.Apply;
begin
  MainForm.StopThread;
  MainForm.UpdateUndo;

  MainCp.CmapIndex := cmbPalette1.ItemIndex;
  MainCp.cmap := FPal1;

  if EditForm.visible then EditForm.UpdateDisplay;
  if MutateForm.Visible then MutateForm.UpdateDisplay;

  MainForm.RedrawTimer.enabled := true;
end;

procedure TfrmImageColoring.cmbPalette1DrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Bitmap: TBitmap;
  PalName: string;
begin
  BitMap := GradientHelper.GetGradientBitmap(Index, 1);

  GetCmapName(index, PalName);

  with Control as TComboBox do  begin
    Canvas.Rectangle(Rect);

    Canvas.TextOut(4, Rect.Top, PalName);
    Rect.Left := (Rect.Left + rect.Right) div 2;
    Canvas.StretchDraw(Rect, Bitmap);
  end;
  BitMap.Free;
end;

procedure TfrmImageColoring.DrawPalette1;
var
  Bitmap: TBitmap;
begin
  BitMap := GradientHelper.GetGradientBitmap(Index1, 1);

  imgPal1.Picture.Graphic := Bitmap;
  imgPal1.Refresh;

  BitMap.Free;
end;

procedure TfrmImageColoring.DrawPalette2;
var
  Bitmap: TBitmap;
begin
  BitMap := GradientHelper.GetGradientBitmap(Index2, 1);

  imgPal2.Picture.Graphic := Bitmap;
  imgPal2.Refresh;

  BitMap.Free;
end;

procedure TfrmImageColoring.cmbPalette2Change(Sender: TObject);
begin
  Index2 := cmbPalette2.ItemIndex;
  GetCmap(Index2, 1, FPal2);
  FBkuPal2 := FPal2;
//  ScrollBar.Position := 0;
  DrawPalette2;
  Apply;
end;

end.
