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

unit Template;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Translation,
  Dialogs, StdCtrls, ComCtrls, ImgList, ControlPoint, cmap, RenderingInterface, Main,
  Global, Adjust;

type
  TTemplateForm = class(TForm)
    TemplateList: TListView;
    btnCancel: TButton;
    btnOK: TButton;
    UsedThumbnails: TImageList;
    Files: TListBox;
    lblFile: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TemplateListChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TemplateForm: TTemplateForm;
const
  blankFlameXML1 = '<flame name="Blank Flame" version="Apophysis" size="1500 1000" center="0 0" background="0 0 0">';
  blankFlameXML2 = '<xform weight="0.5" color="0" linear3D="1" coefs="1 0 0 1 0 0" />';
  blankFlameXML3 = '<palette count="256" format="RGB">';

  procedure ListTemplateByFileName(filename:string);

implementation

{$R *.dfm}

function LoadUserTemplates2(mask:string): integer;
var
 FindResult: integer;
 SearchRec : TSearchRec;
 Path : string;
begin
 Path:=AppPath + templatePath + '\';
 result := 0;

 FindResult := FindFirst(Path + Mask, faAnyFile - faDirectory, SearchRec);
 while FindResult = 0 do
 begin
  ListTemplateByFileName(Path + SearchRec.Name);
   result := result + 1;

   FindResult := FindNext(SearchRec);
 end;
 { free memory }
 FindClose(SearchRec);
end;

function LoadUserTemplates:integer;
begin
  LoadUserTemplates2('*.flame');
  LoadUserTemplates2('*.template');
  Result := 0; // make RTL happy
end;

function BlankXML:string;
var
  i:integer;
  s:string;
const
  break = ' ';
begin
  s:=blankFlameXML1 + break + blankFlameXML2 + break + blankFlameXML3 + break;
  for i:=1 to 256 do begin
    s := s + '000000';
    if (i mod 32 = 0) then s := s + break;
  end;
  s := s + '</palette></flame>';
  Result := s;
end;

procedure DropBlank();
var
  flameXML: string;
  cp: TControlPoint;
  bm: TBitmap;
  cmap: TColorMap;
  zoom: double;
  center: array[0..1] of double;
  brightness, gamma, vibrancy: double;
  Render: TRenderer;
  ListItem: TListItem;
  index: integer;
begin
  cp := TControlPoint.Create;
  Render := TRenderer.Create;
  bm := TBitmap.Create;

  cp.Clear;
  flameXML := BlankXML;
  MainForm.ParseXML(cp, PCHAR(flameXML), true);
  cp.AdjustScale(TemplateForm.UsedThumbnails.Width, TemplateForm.UsedThumbnails.Height);

  //Clipboard.SetTextBuf(PChar(Trim(flameXML)));

  // start preview
    cp.Width := TemplateForm.UsedThumbnails.Width;
    cp.Height := TemplateForm.UsedThumbnails.Height;
    cp.spatial_oversample := 1;
    cp.spatial_filter_radius := 0.1;
    cp.sample_density := 3;
    //  Render.Compatibility := compatibility;
    try
      Render.SetCP(cp);
      Render.Render;
    finally
      BM.Assign(Render.GetImage);
      cp.Free;
      Render.free;
    end;
//    Thumbnails
    TemplateForm.UsedThumbnails.Add(bm, nil);
    ListItem := TemplateForm.TemplateList.Items.Add;
    ListItem.Caption := 'Blank Flame';
    ListItem.ImageIndex := 0;
    TemplateForm.Files.Items.Add('n/a');
  //end preview
  //
  Application.ProcessMessages;
end;

procedure DropListItem(FileName: string; FlameName: string);
var
  flameXML: string;
  cp: TControlPoint;
  bm: TBitmap;
  cmap: TColorMap;
  zoom: double;
  center: array[0..1] of double;
  brightness, gamma, vibrancy: double;
  Render: TRenderer;
  ListItem: TListItem;
  index: integer;
begin
  cp := TControlPoint.Create;
  Render := TRenderer.Create;
  bm := TBitmap.Create;

  cp.Clear;
  flameXML := LoadXMLFlameText(filename, FlameName);
  MainForm.ParseXML(cp, PCHAR(flameXML), true);
  cp.AdjustScale(TemplateForm.UsedThumbnails.Width, TemplateForm.UsedThumbnails.Height);

  //Clipboard.SetTextBuf(PChar(Trim(flameXML)));

  // start preview
    cp.Width := TemplateForm.UsedThumbnails.Width;
    cp.Height := TemplateForm.UsedThumbnails.Height;
    cp.spatial_oversample := 1;
    cp.spatial_filter_radius := 0.1;
    cp.sample_density := 3;
    //  Render.Compatibility := compatibility;
    try
      Render.SetCP(cp);
      Render.Render;
    finally
      BM.Assign(Render.GetImage);
      cp.Free;
      Render.free;
    end;
//    Thumbnails
    TemplateForm.UsedThumbnails.Add(bm, nil);
    ListItem := TemplateForm.TemplateList.Items.Add;
    ListItem.Caption := FlameName;
    ListItem.ImageIndex := TemplateForm.TemplateList.Items.Count - 1;
    TemplateForm.Files.Items.Add(FileName);
  //end preview
  //
  Application.ProcessMessages;
end;

procedure ListTemplateByFileName(filename:string);
{ List .flame file }
var
  sel:integer;
  i, p, img: integer;
  Title: string;
  ListItem: TListItem;
  FStrings: TStringList;
  bm: TBitmap;
begin
  sel := 0;
  if not FileExists(FileName) then exit;
  FStrings := TStringList.Create;
  FStrings.LoadFromFile(FileName);
  try
    if (Pos('<flame ', Lowercase(FStrings.Text)) <> 0) then
    begin
      for i := 0 to FStrings.Count - 1 do
      begin
        p := Pos('<flame ', LowerCase(FStrings[i]));
        if (p <> 0) then
        begin
          MainForm.ListXMLScanner.LoadFromBuffer(PAnsiChar(AnsiString(FSTrings[i])));
          MainForm.ListXMLScanner.Execute;

          if Length(pname) = 0 then
            Title := '*untitled ' + ptime
          else
            Title := Trim(pname);
          if Title <> '' then
          begin { Otherwise bad format }
            //ListItem := MainForm.ListView.Items.Add;
            //Listitem.Caption := Title;
            DropListItem(FileName, Title);
          end;
        end;
      end;
    end;
  finally
    FStrings.Free;
  end;
end;

procedure ListTemplate;
var
  i:integer;
  bm:TBitmap;
begin
  TemplateForm.TemplateList.Items.BeginUpdate;
  TemplateForm.TemplateList.Items.Clear;
  TemplateForm.UsedThumbnails.Clear;

  // hmmm...
  (*for i := 0 to TemplateForm.UsedThumbnails.Count - 1 do
  begin
    TemplateForm.UsedThumbnails.GetBitmap(i, bm);
    bm.Free;
  end;  *)
  
  DropBlank;
  
  ListTemplateByFileName(AppPath + templateFileName);
  LoadUserTemplates;

  TemplateForm.TemplateList.Items.EndUpdate;
  TemplateForm.TemplateList.Selected := TemplateForm.TemplateList.Items[0];
end;

procedure TTemplateForm.FormCreate(Sender: TObject);
begin
  self.Caption := TextByKey('template-title');
  btnOK.Caption := TextByKey('common-ok');
  btnCancel.Caption := TextByKey('common-cancel');
end;

procedure TTemplateForm.TemplateListChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
var
  fn : string;
begin
  if (TemplateList.Selected = nil) then begin
    btnOK.Enabled := false;
  end else begin
    if (TemplateList.Selected.Index >= 0) then begin
      btnOK.Enabled := true;
      if (TemplateList.Selected.Index > 0) then begin
        fn := ChangeFileExt(ExtractFileName(Files.Items[TemplateList.Selected.Index]), '');
        if (LowerCase(fn) <> 'default') then lblFile.Caption := 'Template file: ' + fn
        else lblFile.Caption := '';
      end else begin
        lblFile.Caption := '';
      end;
    end else begin
      btnOK.Enabled := false;
    end;
  end;
end;

procedure TTemplateForm.btnOKClick(Sender: TObject);
var
  flameXML:string;
  fn:string;
  ci:integer;
begin
  fn:=Files.Items[TemplateList.Selected.Index];
  if (TemplateList.Selected.Index = 0) then flameXML := BlankXML
  else flameXML := LoadXMLFlameText(fn, TemplateList.Selected.Caption);
  MainForm.UpdateUndo;
  MainForm.StopThread;
  MainForm.InvokeLoadXML(flameXML);
  Transforms := MainCp.TrianglesFromCP(MainTriangles);
  MainForm.Statusbar.Panels[3].Text := MainCp.name;
  {if ResizeOnLoad then}
  MainForm.ResizeImage;
  MainForm.RedrawTimer.Enabled := True;
  Application.ProcessMessages;
  MainForm.UpdateWindows;
  ci := Random(256); //Random(NRCMAPS);
  GetCMap(ci, 1, MainCp.cmap);
  MainCp.cmapIndex := ci;
  AdjustForm.TemplateRandomizeGradient;
  btnCancelClick(sender);
end;

procedure TTemplateForm.btnCancelClick(Sender: TObject);
begin
  Close();
end;

procedure TTemplateForm.FormShow(Sender: TObject);
begin
  ListTemplate;
end;

end.
