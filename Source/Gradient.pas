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
unit Gradient;

interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Registry, cmap, Menus, ToolWin, Buttons,
  AppEvnts;
const
  PixelCountMax = 32768;

type
  pRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = array[0..PixelCountMax - 1] of TRGBTriple;

type
  TGradientForm = class(TForm)
    pnlPalette: TPanel;
    pnlControls: TPanel;
    cmbPalette: TComboBox;
    GradientImage: TImage;
    PopupMenu: TPopupMenu;
    mnuReverse: TMenuItem;
    mnuInvert: TMenuItem;
    btnMenu: TSpeedButton;
    Popup: TPopupMenu;
    mnuHue: TMenuItem;
    mnuRotate: TMenuItem;
    N1: TMenuItem;
    mnuSaturation: TMenuItem;
    mnuBrightness: TMenuItem;
    N2: TMenuItem;
    ScrollBar: TScrollBar;
    lblVal: TLabel;
    mnuBlur: TMenuItem;
    btnOpen: TSpeedButton;
    N3: TMenuItem;
    mnuGradientBrowser: TMenuItem;
    mnuSmoothPalette: TMenuItem;
    btnSmoothPalette: TSpeedButton;
    N4: TMenuItem;
    SaveGradient1: TMenuItem;
    SaveasMapfile1: TMenuItem;
    SaveDialog: TSaveDialog;
    Label1: TLabel;
    btnPaste: TSpeedButton;
    btnCopy: TSpeedButton;
    N5: TMenuItem;
    mnuCopy: TMenuItem;
    mnuPaste: TMenuItem;
    ApplicationEvents: TApplicationEvents;
    mnuSaveasDefault: TMenuItem;
    N6: TMenuItem;
    mnuRandomize: TMenuItem;
    N7: TMenuItem;
    mnuFrequency: TMenuItem;
    Contrast1: TMenuItem;
    procedure cmbPaletteChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure DrawPalette;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuReverseClick(Sender: TObject);
    procedure mnuInvertClick(Sender: TObject);
    procedure btnMenuClick(Sender: TObject);
    procedure mnuRotateClick(Sender: TObject);
    procedure mnuHueClick(Sender: TObject);
    procedure mnuSaturationClick(Sender: TObject);
    procedure ScrollBarChange(Sender: TObject);
    procedure mnuBrightnessClick(Sender: TObject);
    procedure mnuBlurClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure mnuSmoothPaletteClick(Sender: TObject);
    procedure SaveGradient1Click(Sender: TObject);
    procedure SaveasMapfile1Click(Sender: TObject);
    procedure cmbPaletteDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure btnCopyClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure ApplicationEventsActivate(Sender: TObject);
    procedure mnuSaveasDefaultClick(Sender: TObject);
    procedure mnuRandomizeClick(Sender: TObject);
    procedure mnuFrequencyClick(Sender: TObject);
    procedure Contrast1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure Apply;
    function Blur(const radius: integer; const pal: TColorMap): TColorMap;
    function Frequency(const times: Integer; const pal: TColorMap): TColorMap;
    procedure SaveMap(FileName: string);
  public
    Palette: TColorMap;
    BackupPal: TColorMap;
    procedure UpdateGradient(Pal: TColorMap);
    function RandomGradient: TColorMap;
  end;

var
  GradientForm: TGradientForm;
  pCmap: integer;

function GradientInClipboard: boolean;
procedure RGBToHSV(R, G, B: byte; var H, S, V: real);
procedure HSVToRGB(H, S, V: real; var Rb, Gb, Bb: integer);

implementation

uses Main, cmapdata, Math, Browser, Editor, Global, Save, Adjust, Mutate, ClipBrd;

{$R *.DFM}

procedure TGradientForm.Apply;
begin
  MainForm.StopThread;
  MainForm.UpdateUndo;
  MainCp.CmapIndex := cmbPalette.ItemIndex;
  MainCp.cmap := Palette;
  if EditForm.visible then EditForm.UpdateDisplay;
//  if AdjustForm.visible then AdjustForm.UpdateDisplay;
  if MutateForm.Visible then MutateForm.UpdateDisplay;
  MainForm.RedrawTimer.enabled := true;
end;

procedure TGradientForm.SaveMap(FileName: string);
var
  i: Integer;
  l: string;
  MapFile: TextFile;
begin
{ Save a map file }
  AssignFile(MapFile, FileName);
  try
    ReWrite(MapFile);
    { first line with comment }
    l := Format(' %3d %3d %3d  Exported from Apophysis 2.0', [Palette[0][0], palette[0][1],
      palette[0][2]]);
    Writeln(MapFile, l);
    { now the rest }
    for i := 1 to 255 do
    begin
      l := Format(' %3d %3d %3d', [Palette[i][0], palette[i][1],
        palette[i][2]]);
      Writeln(MapFile, l);
    end;
    CloseFile(MapFile);
  except
    on EInOutError do Application.MessageBox(PChar('Cannot Open File: ' +
        FileName), 'Apophysis', 16);
  end;
end;

procedure TGradientForm.UpdateGradient(Pal: TColorMap);
begin
  Palette := Pal;
  BackupPal := Pal;
  DrawPalette;
  ScrollBar.Position := 0;
end;

procedure HSVToRGB(H, S, V: real; var Rb, Gb, Bb: integer);
var
  R, G, B, Sa, Va, Hue, i, f, p, q, t: real;
begin
  R := 0;
  G := 0;
  B := 0;
  Sa := S / 100;
  Va := V / 100;
  if S = 0 then
  begin
    R := Va;
    G := Va;
    B := Va;
  end
  else
  begin
    Hue := H / 60;
    if Hue = 6 then Hue := 0;
    i := Int(Hue);
    f := Hue - i;
    p := Va * (1 - Sa);
    q := Va * (1 - (Sa * f));
    t := Va * (1 - (Sa * (1 - f)));
    case Round(i) of
      0: begin
          R := Va;
          G := t;
          B := p;
        end;
      1: begin
          R := q;
          G := Va;
          B := p;
        end;
      2: begin
          R := p;
          G := Va;
          B := t;
        end;
      3: begin
          R := p;
          G := q;
          B := Va;
        end;
      4: begin
          R := t;
          G := p;
          B := Va;
        end;
      5: begin
          R := Va;
          G := p;
          B := q;
        end;
    end;
  end;
  Rb := Round(Int(255.9999 * R));
  Gb := Round(Int(255.9999 * G));
  Bb := Round(Int(255.9999 * B));
end;

procedure RGBToHSV(R, G, B: byte; var H, S, V: real);
var
  vRed, vGreen, vBlue, Mx, Mn, Va, Sa, rc, gc, bc: real;
begin
  vRed := R / 255;
  vGreen := G / 255;
  vBlue := B / 255;
  Mx := vRed;
  if vGreen > Mx then Mx := vGreen;
  if vBlue > Mx then Mx := vBlue;
  Mn := vRed;
  if vGreen < Mn then Mn := vGreen;
  if vBlue < Mn then Mn := vBlue;
  Va := Mx;
  if Mx <> 0 then
    Sa := (Mx - Mn) / Mx
  else
    Sa := 0;
  if Sa = 0 then
    H := 0
  else
  begin
    rc := (Mx - vRed) / (Mx - Mn);
    gc := (Mx - vGreen) / (Mx - Mn);
    bc := (Mx - vBlue) / (Mx - Mn);
    if Mx = vRed then
      H := bc - gc
    else if Mx = vGreen then
      H := 2 + rc - bc
    else if Mx = vBlue then
      H := 4 + gc - rc;
    H := H * 60;
    if H < 0 then H := H + 360;
  end;
  S := Sa * 100;
  V := Va * 100;
end;

function TGradientForm.Blur(const Radius: Integer; const pal: TColorMap): TColorMap;
var
  r, g, b, n, i, j, k: Integer;
begin
  Result := Pal;
  if Radius <> 0 then
    for i := 0 to 255 do
    begin
      n := -1;
      r := 0;
      g := 0;
      b := 0;
      for j := i - radius to i + radius do
      begin
        inc(n);
        k := (256 + j) mod 256;
        if k <> i then begin
          r := r + Pal[k][0];
          g := g + Pal[k][1];
          b := b + Pal[k][2];
        end;
      end;
      if n <> 0 then begin
        Result[i][0] := r div n;
        Result[i][1] := g div n;
        Result[i][2] := b div n;
      end;
    end;
end;

function TGradientForm.Frequency(const times: Integer; const pal: TColorMap): TColorMap;
{ This can be improved }
var
  n, i, j: Integer;
begin
  Result := Pal;
  if times <> 1 then
  begin
    n := 256 div times;
    for j := 0 to times do
      for i := 0 to n do
      begin
        if (i + j * n) < 256 then
        begin
          Result[i + j * n][0] := pal[i * times][0];
          Result[i + j * n][1] := pal[i * times][1];
          Result[i + j * n][2] := pal[i * times][2];
        end;
      end;
  end;
end;

procedure TGradientForm.DrawPalette;
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
    GradientImage.Picture.Graphic := Bitmap;
    GradientImage.Refresh;
  finally
    BitMap.Free;
  end;
end;

procedure TGradientForm.cmbPaletteChange(Sender: TObject);
var
  i: integer;
begin
  i := cmbPalette.ItemIndex;
  GetCmap(i, 1, Palette);
  BackupPal := Palette;
  ScrollBar.Position := 0;
  DrawPalette;
  Apply;
end;

procedure TGradientForm.FormShow(Sender: TObject);
var
  Registry: TRegistry;
begin
  { Read posution from registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('Software\' + APP_NAME + '\Forms\Gradient', False) then
    begin
      if Registry.ValueExists('Left') then
        GradientForm.Left := Registry.ReadInteger('Left');
      if Registry.ValueExists('Top') then
        GradientForm.Top := Registry.ReadInteger('Top');
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
  DrawPalette;
end;

procedure TGradientForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  Registry: TRegistry;
begin
  { Write position to registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    { Defaults }
    if Registry.OpenKey('\Software\' + APP_NAME + '\Forms\Gradient', True) then
    begin
      Registry.WriteInteger('Top', GradientForm.Top);
      Registry.WriteInteger('Left', GradientForm.Left);
    end;
  finally
    Registry.Free;
  end;
end;


procedure TGradientForm.btnApplyClick(Sender: TObject);
begin
  Apply;
end;

procedure TGradientForm.mnuReverseClick(Sender: TObject);
var
  i: integer;
  pal: TColorMap;
begin
  for i := 0 to 255 do begin
    pal[i][0] := Palette[255 - i][0];
    pal[i][1] := Palette[255 - i][1];
    pal[i][2] := Palette[255 - i][2];
  end;
  UpdateGradient(pal);
  Apply;
end;

procedure TGradientForm.mnuInvertClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to 255 do
  begin
    Palette[i][0] := 255 - Palette[i][0];
    Palette[i][1] := 255 - Palette[i][1];
    Palette[i][2] := 255 - Palette[i][2];
  end;
  UpdateGradient(palette);
  Apply;
end;

procedure TGradientForm.btnMenuClick(Sender: TObject);
begin
  Popup.Popup(btnMenu.ClientOrigin.x, btnMenu.ClientOrigin.y + btnMenu.Height);
end;

procedure TGradientForm.ScrollBarChange(Sender: TObject);
var
  intens, i, r, g, b: integer;
  h, s, v: real;
begin
  lblVal.Caption := IntToStr(ScrollBar.Position);
  if btnMenu.Caption = 'Hue' then
  begin
    for i := 0 to 255 do
    begin
      RGBToHSV(BackupPal[i][0], BackupPal[i][1], BackupPal[i][2], h, s, v);
      h := Round(360 + h + ScrollBar.Position) mod 360;
      HSVToRGB(h, s, v, Palette[i][0], Palette[i][1], Palette[i][2]);
    end;
  end;
  if btnMenu.Caption = 'Saturation' then
  begin
    for i := 0 to 255 do
    begin
      RGBToHSV(BackupPal[i][0], BackupPal[i][1], BackupPal[i][2], h, s, v);
      s := s + ScrollBar.Position;
      if s > 100 then s := 100;
      if s < 0 then s := 0;
      HSVToRGB(h, s, v, Palette[i][0], Palette[i][1], Palette[i][2]);
    end;
  end;
  if btnMenu.Caption = 'Contrast' then
  begin
    intens := scrollBar.Position;
    if intens > 0 then intens := intens * 2;
    for i := 0 to 255 do
    begin
      r := BackupPal[i][0];
      g := BackupPal[i][1];
      b := BackupPal[i][2];
      r := round(r + intens / 100 * (r - 127));
      g := round(g + intens / 100 * (g - 127));
      b := round(b + intens / 100 * (b - 127));
      if R > 255 then R := 255 else if R < 0 then R := 0;
      if G > 255 then G := 255 else if G < 0 then G := 0;
      if B > 255 then B := 255 else if B < 0 then B := 0;
      Palette[i][0] := r;
      Palette[i][1] := g;
      Palette[i][2] := b;
    end;
  end;
  if btnMenu.Caption = 'Brightness' then
  begin
    for i := 0 to 255 do
    begin
      Palette[i][0] := BackupPal[i][0] + ScrollBar.Position;
      if Palette[i][0] > 255 then Palette[i][0] := 255;
      if Palette[i][0] < 0 then Palette[i][0] := 0;
      Palette[i][1] := BackupPal[i][1] + ScrollBar.Position;
      if Palette[i][1] > 255 then Palette[i][1] := 255;
      if Palette[i][1] < 0 then Palette[i][1] := 0;
      Palette[i][2] := BackupPal[i][2] + ScrollBar.Position;
      if Palette[i][2] > 255 then Palette[i][2] := 255;
      if Palette[i][2] < 0 then Palette[i][2] := 0;
    end;
  end;
  if btnMenu.Caption = 'Rotate' then
  begin
    for i := 0 to 255 do
    begin
      Palette[i][0] := BackupPal[(255 + i - ScrollBar.Position) mod 256][0];
      Palette[i][1] := BackupPal[(255 + i - ScrollBar.Position) mod 256][1];
      Palette[i][2] := BackupPal[(255 + i - ScrollBar.Position) mod 256][2];
    end;
  end;
  if btnMenu.Caption = 'Blur' then
  begin
    Palette := Blur(ScrollBar.Position, BackupPal);
  end;
  if btnMenu.Caption = 'Frequency' then
  begin
    Palette := Frequency(ScrollBar.Position, BackupPal);
  end;
  DrawPalette;
end;

{ ***************************** Adjust menu ********************************* }

procedure TGradientForm.mnuRotateClick(Sender: TObject);
begin
  btnMenu.Caption := 'Rotate';
  BackupPal := Palette;
  ScrollBar.Min := 0;
  ScrollBar.Max := 255;
  ScrollBar.LargeChange := 15;
  ScrollBar.Position := 0;
end;

procedure TGradientForm.mnuHueClick(Sender: TObject);
begin
  btnMenu.Caption := 'Hue';
  BackupPal := Palette;
  ScrollBar.Min := 0;
  ScrollBar.Max := 360;
  ScrollBar.LargeChange := 15;
  ScrollBar.Position := 0;
end;

procedure TGradientForm.mnuBrightnessClick(Sender: TObject);
begin
  btnMenu.Caption := 'Brightness';
  BackupPal := Palette;
  ScrollBar.Min := -255;
  ScrollBar.Max := 255;
  ScrollBar.LargeChange := 15;
  ScrollBar.Position := 0;
end;

procedure TGradientForm.mnuSaturationClick(Sender: TObject);
begin
  btnMenu.Caption := 'Saturation';
  BackupPal := Palette;
  ScrollBar.Min := -100;
  ScrollBar.Max := 100;
  ScrollBar.LargeChange := 15;
  ScrollBar.Position := 0;
end;

procedure TGradientForm.mnuBlurClick(Sender: TObject);
begin
  btnMenu.Caption := 'Blur';
  BackupPal := Palette;
  ScrollBar.Min := 0;
  ScrollBar.Max := 127;
  ScrollBar.LargeChange := 15;
  ScrollBar.Position := 0;
end;

procedure TGradientForm.mnuFrequencyClick(Sender: TObject);
begin
  btnMenu.Caption := 'Frequency';
  BackupPal := Palette;
  ScrollBar.Min := 1;
  ScrollBar.Max := 10;
  ScrollBar.LargeChange := 1;
  ScrollBar.Position := 1;
end;

procedure TGradientForm.btnOpenClick(Sender: TObject);
begin
  GradientBrowser.Filename := GradientFile;
  GradientBrowser.Show;
end;

procedure TGradientForm.mnuSmoothPaletteClick(Sender: TObject);
begin
  MainForm.SmoothPalette;
end;

procedure TGradientForm.SaveGradient1Click(Sender: TObject);
var
  gradstr: TStringList;
begin
  gradstr := TStringList.Create;
  try
    SaveForm.Caption := 'Save Gradient';
    SaveForm.Filename := GradientFile;
    SaveForm.Title := MainCp.name;
    if SaveForm.ShowModal = mrOK then
    begin
      gradstr.add(CleanIdentifier(SaveForm.Title) + ' {');
      gradstr.add(MainForm.GradientFromPalette(Palette, SaveForm.Title));
      gradstr.add('}');
      if MainForm.SaveGradient(gradstr.text, SaveForm.Title, SaveForm.Filename) then
        GradientFile := SaveForm.FileName;
    end;
  finally
    gradstr.free
  end;
end;

procedure TGradientForm.SaveasMapfile1Click(Sender: TObject);
begin
  SaveDialog.Filename := MainCp.name + '.map';
  if SaveDialog.execute then
    SaveMap(SaveDialog.Filename);
end;

procedure TGradientForm.cmbPaletteDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  i, j: integer;
  Row: pRGBTripleArray;
  Bitmap: TBitmap;
  pal: TColorMap;
  PalName: string;
begin
{ Draw the preset palettes on the combo box items }
  GetCMap(index, 1, pal);
  GetCmapName(index, PalName);

  BitMap := TBitMap.create;
  Bitmap.PixelFormat := pf24bit;
  BitMap.Width := 256;
  BitMap.Height := 100;

  for j := 0 to Bitmap.Height - 1 do
  begin
    Row := Bitmap.Scanline[j];
    for i := 0 to Bitmap.Width - 1 do
    begin
      with Row[i] do
      begin
        rgbtRed := Pal[i][0];
        rgbtGreen := Pal[i][1];
        rgbtBlue := Pal[i][2];
      end
    end
  end;
  with Control as TComboBox do
  begin
    Canvas.Rectangle(Rect);

    Canvas.TextOut(4, Rect.Top, PalName);
    Rect.Left := (Rect.Left + rect.Right) div 2;
    Canvas.StretchDraw(Rect, Bitmap);
  end;
  BitMap.Free;
end;

procedure TGradientForm.ScrollBarScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if ScrollCode = scEndScroll then Apply;
end;

procedure TGradientForm.btnCopyClick(Sender: TObject);
var
  gradstr: TStringList;
begin
  gradstr := TStringList.Create;
  try
    gradstr.add(CleanIdentifier(MainCp.name) + ' {');
    gradstr.add('gradient:');
    gradstr.add(' title="' + MainCp.name + '" smooth=no');
    gradstr.add(GradientString(Palette));
    gradstr.add('}');
    Clipboard.SetTextBuf(PChar(gradstr.text));
    btnPaste.enabled := true;
    mnuPaste.enabled := true;
    MainForm.btnPaste.enabled := False;
    MainForm.mnuPaste.enabled := False;
  finally
    gradstr.free
  end;
end;

procedure TGradientForm.btnPasteClick(Sender: TObject);
begin
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    UpdateGradient(CreatePalette(Clipboard.AsText));
    Apply;
  end;
end;

function GradientInClipboard: boolean;
var
  gradstr: TStringList;
begin
  { returns true if gradient in clipboard - can be tricked }
  result := true;
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    gradstr := TStringList.Create;
    try
      gradstr.text := Clipboard.AsText;
      if (Pos('}', gradstr.text) = 0) or (Pos('{', gradstr.text) = 0) or
        (Pos('gradient:', gradstr.text) = 0) or (Pos('fractal:', gradstr.text) <> 0) then
      begin
        result := false;
        exit;
      end;
    finally
      gradstr.free;
    end;
  end
  else
    result := false;
end;

procedure TGradientForm.ApplicationEventsActivate(Sender: TObject);
begin
  if GradientInClipboard then begin
    mnuPaste.enabled := true;
    btnPaste.enabled := true;
  end
  else
  begin
    mnuPaste.enabled := false;
    btnPaste.enabled := false;
  end;
end;

procedure TGradientForm.mnuSaveasDefaultClick(Sender: TObject);
begin
  MainForm.DefaultPalette := Palette;
  SaveMap(AppPath + 'default.map');
end;

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

function TGradientForm.RandomGradient: TColorMap;
var
  a, b, n, nodes: integer;
  rgb: array[0..2] of double;
  hsv: array[0..2] of double;
  pal: TColorMap;
begin
  inc(MainForm.Seed);
  RandSeed := MainForm.seed;
  nodes := random((MaxNodes - 1) - (MinNodes - 2)) + (MinNodes - 1);
  n := 256 div nodes;
  b := 0;
  hsv[0] := (random(MaxHue - (MinHue - 1)) + MinHue) / 100;
  hsv[1] := (random(MaxSat - (MinSat - 1)) + MinSat) / 100;
  hsv[2] := (random(MaxLum - (MinLum - 1)) + MinLum) / 100;
  hsv2rgb(hsv, rgb);
  Pal[0][0] := Round(rgb[0] * 255);
  Pal[0][1] := Round(rgb[1] * 255);
  Pal[0][2] := Round(rgb[2] * 255);
  repeat
    a := b;
    b := b + n;
    hsv[0] := (random(MaxHue - (MinHue - 1)) + MinHue) / 100;
    hsv[1] := (random(MaxSat - (MinSat - 1)) + MinSat) / 100;
    hsv[2] := (random(MaxLum - (MinLum - 1)) + MinLum) / 100;
    hsv2rgb(hsv, rgb);
    if b > 255 then b := 255;
    Pal[b][0] := Round(rgb[0] * 255);
    Pal[b][1] := Round(rgb[1] * 255);
    Pal[b][2] := Round(rgb[2] * 255);
    RGBBlend(a, b, pal);
  until b = 255;
  Result := Pal;
end;

procedure TGradientForm.mnuRandomizeClick(Sender: TObject);
begin
  GradientForm.UpdateGradient(RandomGradient);
  GradientForm.Apply;
end;

procedure TGradientForm.Contrast1Click(Sender: TObject);
begin
  btnMenu.Caption := 'Contrast';
  BackupPal := Palette;
  ScrollBar.Min := -100;
  ScrollBar.Max := 100;
  ScrollBar.LargeChange := 15;
  ScrollBar.Position := 0;
end;

procedure TGradientForm.FormCreate(Sender: TObject);
begin
  Sendmessage(cmbPalette.Handle, CB_SETDROPPEDWIDTH , cmbPalette.width * 2, 0);
end;

end.

