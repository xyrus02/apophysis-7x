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
unit Browser;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, ControlPoint, ToolWin, ImgList, StdCtrls,
  Cmap, Menus, Global, Buttons, Translation,
  RenderingInterface;

const
  PixelCountMax = 32768;
  PaletteTooltipTimeout = 1500;

type
  TGradientBrowser = class(TForm)
    SmallImages: TImageList;
    pnlMain: TPanel;
    PopupMenu: TPopupMenu;
    DeleteItem: TMenuItem;
    RenameItem: TMenuItem;
    OpenDialog: TOpenDialog;
    LargeImages: TImageList;
    TooltipTimer: TTimer;
    ListView: TListView;
    pnlPreview: TPanel;
    Image: TImage;
    btnDefGradient: TSpeedButton;
    procedure FormResize(Sender: TObject);
    procedure ListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DeleteItemClick(Sender: TObject);
    procedure RenameItemClick(Sender: TObject);
    procedure ListViewEdited(Sender: TObject; Item: TListItem;
      var S: string);
    procedure btnDefGradientClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ListViewKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListViewInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
    procedure TooltipTimerTimer(Sender: TObject);
  private
    procedure DrawPalette;
    procedure Apply;
  public
    PreviewDensity: double;
    FlameIndex, GradientIndex: Integer;
    Extension, Identifier, Filename: string;
    cp: TControlPoint;
    Palette: TColorMap;
    zoom: double;
    Center: array[0..1] of double;
    Render: TRenderer;
    procedure ListFileContents;
    function LoadFractintMap(filen: string): TColorMap;
  end;

type
  EFormatInvalid = class(Exception);
  pRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = array[0..PixelCountMax - 1] of TRGBTriple;

var
  GradientBrowser: TGradientBrowser;
  FlameString: string;

function CreatePalette(strng: string): TColorMap;

implementation

uses Main, Options, Editor, {Gradient,} Registry, Adjust, Mutate;

{$R *.DFM}


procedure RGBBlend(a, b: integer; var Palette: TColorMap);
{ Linear blend between to indices of a palette }
var
  c, v: real;
  vrange, range: real;
  i: integer;
begin
  if a = b then
  begin
    Exit;
  end;
  range := b - a;
  vrange := Palette[b mod 256][0] - Palette[a mod 256][0];
  c := Palette[a mod 256][0];
  v := vrange / range;
  for i := (a + 1) to (b - 1) do
  begin
    c := c + v;
    Palette[i mod 256][0] := Round(c);
  end;
  vrange := Palette[b mod 256][1] - Palette[a mod 256][1];
  c := Palette[a mod 256][1];
  v := vrange / range;
  for i := a + 1 to b - 1 do
  begin
    c := c + v;
    Palette[i mod 256][1] := Round(c);
  end;
  vrange := Palette[b mod 256][2] - Palette[a mod 256][2];
  c := Palette[a mod 256][2];
  v := vrange / range;
  for i := a + 1 to b - 1 do
  begin
    c := c + v;
    Palette[i mod 256][2] := Round(c);
  end;
end;

function GetVal(token: string): string;
var
  p: integer;
begin
  p := Pos('=', token);
  Delete(Token, 1, p);
  Result := Token;
end;

function ReplaceTabs(str: string): string;
{Changes tab characters in a string to spaces}
var
  i: integer;
begin
  for i := 1 to Length(str) do
  begin
    if str[i] = #9 then
    begin
      Delete(str, i, 1);
      Insert(#32, str, i);
    end;
  end;
  Result := str;
end;

function TGradientBrowser.LoadFractintMap(filen: string): TColorMap;
var
  i: integer;
  s: string;
  pal: TColorMap;
  MapFile: TextFile;
begin
{ Load a map file }
  AssignFile(MapFile, Filen);
  try
    Reset(MapFile);
    for i := 0 to 255 do
    begin
      Read(MapFile, Pal[i][0]);
      Read(MapFile, Pal[i][1]);
      Read(MapFile, Pal[i][2]);
      Read(MapFile, s);
    end;
    CloseFile(MapFile);
    Result := Pal;
  except
    on EInOutError do Application.MessageBox(PChar(Format(TextByKey('common-genericopenfailure'), [FileName])), PCHAR('Apophysis'), 16);
  end;
end;

function CreatePalette(strng: string): TColorMap;
{ Loads a palette from a gradient string }
var
  Strings: TStringList;
  index, i: integer;
  Tokens: TStringList;
  Indices, Colors: TStringList;
  a, b: integer;
begin
  Strings := TStringList.Create;
  Tokens := TStringList.Create;
  Indices := TStringList.Create;
  Colors := TStringList.Create;
  try
    try
      Strings.Text := strng;
      if Pos('}', Strings.Text) = 0 then raise EFormatInvalid.Create('No closing brace');
      if Pos('{', Strings[0]) = 0 then raise EFormatInvalid.Create('No opening brace.');
      GetTokens(ReplaceTabs(strings.text), tokens);
      Tokens.Text := Trim(Tokens.text);
      i := 0;
      while (Pos('}', Tokens[i]) = 0) and (Pos('opacity:', Lowercase(Tokens[i])) = 0) do
      begin
        if Pos('index=', LowerCase(Tokens[i])) <> 0 then
          Indices.Add(GetVal(Tokens[i]))
        else if Pos('color=', LowerCase(Tokens[i])) <> 0 then
          Colors.Add(GetVal(Tokens[i]));
        inc(i)
      end;
      for i := 0 to 255 do
      begin
        Result[i][0] := 0;
        Result[i][1] := 0;
        Result[i][2] := 0;
      end;
      if Indices.Count = 0 then raise EFormatInvalid.Create('No color info');
      for i := 0 to Indices.Count - 1 do
      begin
       try
        index := StrToInt(Indices[i]);
        while index < 0 do inc(index, 400);
        index := Round(Index * (255 / 399));
        indices[i] := IntToStr(index);
        assert(index>=0);
        assert(index<256);
        Result[index][0] := StrToInt(Colors[i]) mod 256;
        Result[index][1] := trunc(StrToInt(Colors[i]) / 256) mod 256;
        Result[index][2] := trunc(StrToInt(Colors[i]) / 65536);
       except
       end;
      end;
      i := 1;
      repeat
        a := StrToInt(Trim(Indices[i - 1]));
        b := StrToInt(Trim(Indices[i]));
        RGBBlend(a, b, Result);
        inc(i);
      until i = Indices.Count;
      if (Indices[0] <> '0') or (Indices[Indices.Count - 1] <> '255') then
      begin
        a := StrToInt(Trim(Indices[Indices.Count - 1]));
        b := StrToInt(Trim(Indices[0])) + 256;
        RGBBlend(a, b, Result);
      end;
    except on EFormatInvalid do
      begin
//        Result := False;
      end;
    end;
  finally
    Tokens.Free;
    Strings.Free;
    Indices.Free;
    Colors.Free;
  end;
end;

procedure TGradientBrowser.DrawPalette;
var
  i, j: integer;
  Row: pRGBTripleArray;
  BitMap: TBitMap;
begin
  BitMap := TBitMap.Create;
  try
    Bitmap.PixelFormat := pf24bit;
    BitMap.Width := 256;
    BitMap.Height := 1;
    for j := 0 to Bitmap.Height - 1 do
    begin
      Row := Bitmap.Scanline[j];
      for i := 0 to Bitmap.Width - 1 do
      begin
        with Row[i] do
        begin
          rgbtRed := Palette[i][0];
          rgbtGreen := Palette[i][1];
          rgbtBlue := Palette[i][2];
        end
      end
    end;
    Image.Picture.Graphic := Bitmap;
    Image.Refresh;
  finally
    BitMap.Free;
  end;
end;

procedure TGradientBrowser.ListFileContents;
{ List identifiers in file }
var
  i, p: integer;
  Title: string;
  ListItem: TListItem;
  FStrings: TStringList;
begin
  FStrings := TStringList.Create;
  FStrings.LoadFromFile(filename);
  try
    ListView.Items.BeginUpdate;
    ListView.Items.Clear;
    if Lowercase(ExtractFileExt(filename)) = '.map' then
    begin
      ListItem := ListView.Items.Add;
      Listitem.Caption := Trim(filename);
    end
    else
      if (Pos('{', FStrings.Text) <> 0) then
      begin
        for i := 0 to FStrings.Count - 1 do
        begin
          p := Pos('{', FStrings[i]);
          if (p <> 0) and (Pos('(3D)', FStrings[i]) = 0) then
          begin
            Title := Trim(Copy(FStrings[i], 1, p - 1));
            if Title <> '' then
            begin { Otherwise bad format }
              ListItem := ListView.Items.Add;
              Listitem.Caption := Trim(Copy(FStrings[i], 1, p - 1));
            end;
          end;
        end;
      end;
    ListView.Items.EndUpdate;
    ListView.Selected := ListView.Items[0];
  finally
    FStrings.Free;
  end;
end;

procedure TGradientBrowser.ListViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  Tokens, FStrings: TStringList;
  EntryStrings: TStringList;
  i: integer;
begin
  Application.ProcessMessages;
  FStrings := TStringList.Create;
  EntryStrings := TStringList.Create;
  Tokens := TStringList.Create;
  try
    if Lowercase(ExtractFileExt(filename)) = '.map' then
    begin
      Palette := LoadFractintMap(filename);
      DrawPalette;
    end
    else
      if (ListView.SelCount <> 0) and (ListView.Selected.Caption <> Identifier) then
      begin
        Identifier := ListView.Selected.Caption;
        FStrings.LoadFromFile(Filename);
        for i := 0 to FStrings.count - 1 do
          if Pos(Lowercase(ListView.Selected.Caption) + ' ', Trim(Lowercase(FStrings[i]))) = 1 then break;
        EntryStrings.Add(FStrings[i]);
        repeat
          inc(i);
          EntryStrings.Add(FStrings[i]);
        until Pos('}', FStrings[i]) <> 0;
        Palette := CreatePalette(EntryStrings.Text);
        DrawPalette;
      end;
  finally
    EntryStrings.Free;
    FStrings.Free;
    Tokens.Free;
  end;
end;

procedure TGradientBrowser.FormCreate(Sender: TObject);
begin
  self.Caption := TextByKey('gradientbrowser-title');
	btnDefGradient.Hint := TextByKey('common-browse');
	DeleteItem.Caption := TextByKey('common-delete');
	RenameItem.Caption := TextByKey('common-rename');
  PreviewDensity := prevMediumQuality;
  cp := TControlPoint.Create;
  cp.gamma := defGamma;
  cp.brightness := defBrightness;
  cp.vibrancy := defVibrancy;
  cp.spatial_oversample := defOversample;
  cp.spatial_filter_radius := defFilterRadius;
  Render := TRenderer.Create;
  FlameIndex := 0;
  GradientIndex := 0;
end;

procedure TGradientBrowser.FormDestroy(Sender: TObject);
begin
  Render.Free;
  cp.Free;
end;

procedure TGradientBrowser.FormShow(Sender: TObject);
var
  Registry: TRegistry;
begin
  { Read posution from registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('Software\' + APP_NAME + '\Forms\Browser', False) then
    begin
      if Registry.ValueExists('Left') then
        GradientBrowser.Left := Registry.ReadInteger('Left');
      if Registry.ValueExists('Top') then
        GradientBrowser.Top := Registry.ReadInteger('Top');
      if Registry.ValueExists('Width') then
        GradientBrowser.Width := Registry.ReadInteger('Width');
      if Registry.ValueExists('Height') then
        GradientBrowser.Height := Registry.ReadInteger('Height');
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
  if FileExists(filename) then ListFileContents;
end;

procedure TGradientBrowser.DeleteItemClick(Sender: TObject);
var
  c: boolean;
begin
  if ListView.SelCount <> 0 then
  begin
    if ConfirmDelete then
      c := Application.MessageBox(
        PChar(Format(TextByKey('common-confirmdelete'), [ListView.Selected.Caption])), 'Apophysis', 36) = IDYES
    else
      c := True;
    if c then
      if ListView.Focused and (ListView.SelCount <> 0) then
      begin
        Application.ProcessMessages;
        if DeleteEntry(ListView.Selected.Caption, Filename) then
        begin
          ListView.Items.Delete(ListView.Selected.Index);
          ListView.Selected := ListView.ItemFocused;
        end;
      end;
  end;
end;

procedure TGradientBrowser.RenameItemClick(Sender: TObject);
begin
  if ListView.SelCount <> 0 then
    ListView.Items[ListView.Selected.Index].EditCaption;
end;

procedure TGradientBrowser.ListViewEdited(Sender: TObject; Item: TListItem;
  var S: string);
begin
//  if s <> Item.Caption then
//    if not RenameIFS(Item.Caption, s, Filename) then
//      s := Item.Caption;
end;

procedure TGradientBrowser.btnDefGradientClick(Sender: TObject);
var
  fn:string;
begin
  OpenDialog.InitialDir := BrowserPath;
  OpenDialog.Filter := Format('%s|*.gradient;*.ugr|%s|*.map|%s|*.*',
      [TextByKey('common-filter-gradientfiles'),
      TextByKey('common-filter-fractintfiles'),
      TextByKey('common-filter-allfiles')]);
  OpenDialog.FileName := '';
  if OpenSaveFileDialog(GradientBrowser, OpenDialog.DefaultExt, OpenDialog.Filter, OpenDialog.InitialDir, TextByKey('common-browse'), fn, true, false, false, true) then
  //if OpenDialog.Execute then
  begin
    Filename := fn; //OpenDialog.FileName;
    GradientFile := Filename;
    BrowserPath := ExtractFilePath(fn); //ExtractFilePath(OpenDialog.FileName);
    ListFileContents;
  end;
end;

procedure TGradientBrowser.Apply;
begin
  MainForm.StopThread;
  MainForm.UpdateUndo;
  MainCp.cmap := Palette;
  MainCP.cmapindex := -1;
  if EditForm.Visible then EditForm.UpdateDisplay;
  if AdjustForm.Visible then AdjustForm.UpdateDisplay;
  if MutateForm.Visible then MutateForm.UpdateDisplay;
  MainForm.RedrawTimer.enabled := true;
end;

procedure TGradientBrowser.SpeedButton1Click(Sender: TObject);
begin
  Apply;
end;

procedure TGradientBrowser.ListViewKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then Apply;
end;

procedure TGradientBrowser.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  Registry: TRegistry;
begin
  { Write position to registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    { Defaults }
    if Registry.OpenKey('\Software\' + APP_NAME + '\Forms\Browser', True) then
    begin
      Registry.WriteInteger('Top', GradientBrowser.Top);
      Registry.WriteInteger('Left', GradientBrowser.Left);
      Registry.WriteInteger('Width', GradientBrowser.Width);
      Registry.WriteInteger('Height', GradientBrowser.Height);
    end;
  finally
    Registry.Free;
  end;
end;

procedure TGradientBrowser.ListViewInfoTip(Sender: TObject;
  Item: TListItem; var InfoTip: String);
var
  i, j: integer;
  Row: pRGBTripleArray;
  Bitmap: TBitmap;
  pal: TColorMap;
  EntryStrings, FStrings: TStringList;
  rect: TRect;
begin
  BitMap := TBitMap.create;
  Bitmap.PixelFormat := pf24bit;
  BitMap.Width := 256;
  BitMap.Height := 100;

  FStrings := TStringList.Create;
  EntryStrings := TStringList.Create;
  try
    if Lowercase(ExtractFileExt(filename)) = '.map' then
    begin
      pal := LoadFractintMap(filename);
    end
    else
    begin
      Identifier := Item.Caption;
      FStrings.LoadFromFile(Filename);
      for i := 0 to FStrings.count - 1 do
        if Pos(Lowercase(Item.Caption) + ' ', Trim(Lowercase(FStrings[i]))) = 1 then break;
      EntryStrings.Add(FStrings[i]);
      repeat
        inc(i);
        EntryStrings.Add(FStrings[i]);
      until Pos('}', FStrings[i]) <> 0;
      pal := CreatePalette(EntryStrings.Text);
    end;
  finally
    EntryStrings.Free;
    FStrings.Free;
  end;

  for j := 0 to Bitmap.Height - 1 do
  begin
    Row := Bitmap.Scanline[j];
    for i := 0 to Bitmap.Width - 1 do
    begin
      with Row[i] do
      begin
        rgbtRed := pal[i][0];
        rgbtGreen := pal[i][1];
        rgbtBlue := pal[i][2];
      end
    end
  end;
  rect.TopLeft := Item.Position;
  rect.BottomRight.X := rect.TopLeft.X + 100;
  rect.BottomRight.Y := rect.TopLeft.Y + 16;
  with ListView do
  begin
    Canvas.Rectangle(Rect);
    //Canvas.TextOut(Rect.Left, Rect.Top, Item.Caption);
    //Rect.Left := (Rect.Left + rect.Right) div 3;
    Canvas.StretchDraw(Rect, Bitmap);
  end;
  BitMap.Free;
  InfoTip := '';
  TooltipTimer.Interval := PaletteTooltipTimeout;
  TooltipTimer.Enabled := true;
end;

procedure TGradientBrowser.TooltipTimerTimer(Sender: TObject);
begin
  ListView.Repaint;
  TooltipTimer.Enabled := false;
end;

procedure TGradientBrowser.FormResize(Sender: TObject);
begin
  Listview.Width := self.ClientWidth - 4;
  btnDefGradient.Left := self.ClientWidth - 2 - btnDefGradient.Width;
  ListView.Height := self.ClientHeight - pnlPreview.Height - 6;
  btnDefGradient.Top := self.ClientHeight - pnlPreview.Height - 2 + pnlPreview.Height div 2 - btnDefGradient.Height div 2;
  ListView.Top := 2;
  ListView.Left := 2;
  pnlPreview.Top := self.ClientHeight - pnlPreview.Height - 2;
  pnlPreview.Left := 2;
  pnlPreview.Width := self.ClientWidth - btnDefGradient.Width - 6;
end;

end.

