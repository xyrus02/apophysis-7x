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
unit Preview;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ControlPoint, RenderingInterface, Translation;

type
  TPreviewForm = class(TForm)
    BackPanel: TPanel;
    Image: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
    cp: TControlPoint;
    Render: TRenderer;
    procedure DrawFlame;
  end;

var
  PreviewForm: TPreviewForm;

implementation

uses Main, Global, ScriptForm;

{$R *.DFM}

procedure TPreviewForm.DrawFlame;
begin
  Render.Stop;
//  ScriptEditor.GetCpFromFlame(cp);
  cp.width := Image.width;
  cp.Height := Image.Height;
//  Render.Compatibility := Compatibility;
  Render.SetCP(cp);
  Render.Render;
  Image.Picture.Bitmap.Assign(Render.GetImage);
  Application.ProcessMessages;
end;


procedure TPreviewForm.FormCreate(Sender: TObject);
begin
  self.Caption := TextbyKey('preview-title');
  cp := TControlPoint.Create;
  Render := TRenderer.Create;
end;

procedure TPreviewForm.FormDestroy(Sender: TObject);
begin
  Render.Free;
  cp.Free;
end;

procedure TPreviewForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
     ScriptEditor.Stopped := True;
end;

procedure TPreviewForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ScriptEditor.Stopped := True;
end;

end.

