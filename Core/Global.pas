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

unit Global;

interface

uses
  Windows, SysUtils, Classes, SyncObjs, Controls, Graphics, Math,
  cmap, ControlPoint, Xform, CommDlg;

type
  EFormatInvalid = class(Exception);

{ Weight manipulation }
{ Triangle transformations }
function triangle_area(t: TTriangle): double;
function transform_affine(const t: TTriangle; const Triangles: TTriangles): boolean;
function line_dist(x, y, x1, y1, x2, y2: double): double;
function dist(x1, y1, x2, y2: double): double;
{ Parsing functions }
function GetVal(token: string): string;
function ReplaceTabs(str: string): string;
{ Palette and gradient functions }
//function GetGradient(FileName, Entry: string): string;
{ Misc }
function det(a, b, c, d: double): double;
function solve3(x1, x2, x1h, y1, y2, y1h, z1, z2, z1h: double;
  var a, b, e: double): double;
function OpenSaveFileDialog(Parent: TWinControl;
                            const DefExt,
                            Filter,
                            InitialDir,
                            Title: string;
                            var FileName: string;
                            MustExist,
                            OverwritePrompt,
                            NoChangeDir,
                            DoOpen: Boolean): Boolean;
procedure LoadThumbnailPlaceholder(ThumbnailSize : integer);
function GetEnvVarValue(const VarName: string): string;


const
  APP_NAME: string = 'Apophysis 7x';
  APP_VERSION: string = 'Version 15D';
  {$ifdef Apo7X64}
  APP_BUILD: string = ' - 64 bit';
  {$else}
  APP_BUILD: string = ' - 32 bit';
  {$endif}
  MAX_TRANSFORMS: integer = 100;
  prefilter_white: integer = 1024;
  eps: double = 1E-10;
  White_level = 200;
  clyellow1 = TColor($17FCFF);
  clplum2 = TColor($ECA9E6);
  clSlateGray = TColor($837365);
  FT_BMP = 1; FT_PNG = 2; FT_JPG = 3;

const
  crEditArrow  = 20;
  crEditMove   = 21;
  crEditRotate = 22;
  crEditScale  = 23;

const
  SingleBuffer : boolean =
  {$ifdef Apo7X64}
    false
  {$else}
    true
  {$endif};
  
var
  MainSeed: integer;
  MainTriangles: TTriangles;
  Transforms: integer; // Count of Tranforms
  EnableFinalXform: boolean;
  AppPath: string; // Path of applicatio file
  OpenFile: string; // Name of currently open file
  CanDrawOnResize: boolean;
  PreserveWeights: boolean;
  AlwaysCreateBlankFlame : boolean;
  StartupCheckForUpdates : boolean;
  TBWidth1 : integer;
  TBWidth2 : integer;
  TBWidth3 : integer;
  TBWidth4 : integer;
  TBWidth5 : integer;
  ThumbnailPlaceholder : TBitmap;
  WarnOnMissingPlugin : boolean;
  EmbedThumbnails : boolean;
  LanguageFile : string;
  AvailableLanguages : TStringList;
  PluginPath : string;

  { UPR Options }

  UPRSampleDensity: integer;
  UPRFilterRadius: double;
  UPROversample: integer;
  UPRAdjustDensity: boolean;
  UPRColoringIdent: string;
  UPRColoringFile: string;
  UPRFormulaIdent: string;
  UPRFormulaFile: string;
  UPRWidth: Integer;
  UPRHeight: Integer;
  ImageFolder: string;
  UPRPath: string; // Name and folder of last UPR file
  cmap_index: integer; // Index to current gradient
  Variation: TVariation; // Current variation
  NumTries, TryLength: integer; // Settings for smooth palette
  SmoothPaletteFile: string;

  { Editor }

  UseFlameBackground, UseTransformColors: boolean;
  HelpersEnabled: boolean;
  EditorBkgColor, ReferenceTriangleColor: integer;
  GridColor1, GridColor2, HelpersColor: integer;
  ExtEditEnabled, TransformAxisLock, RebuildXaosLinks: boolean;
  ShowAllXforms: boolean;
  EditorPreviewTransparency: integer;
  EnableEditorPreview: boolean;

  { Display }

  defSampleDensity, defPreviewDensity: Double;
  defGamma, defBrightness, defVibrancy,
  defFilterRadius, defGammaThreshold: Double;
  defOversample: integer;

  { Render }

  renderDensity, renderFilterRadius: double;
  renderOversample, renderWidth, renderHeight: integer;
  renderBitsPerSample: integer;
  renderPath: string;
  JPEGQuality: integer;
  renderFileFormat: integer;
  InternalBitsPerSample: integer;

  NrTreads: Integer;
  UseNrThreads: integer;

  PNGTransparency: integer;
  ShowTransparency: boolean;

  MainPreviewScale: double;
  ExtendMainPreview: boolean;

  StoreEXIF : boolean;
  StoreParamsEXIF : boolean;
  ExifAuthor : string;

  { Defaults }

  LastOpenFile: string;
  LastOpenFileEntry: integer;
  RememberLastOpenFile: boolean;
  UseSmallThumbnails: boolean;
  ClassicListMode: boolean;
  ConfirmDelete: boolean; // Flag confirmation of entry deletion
  OldPaletteFormat: boolean;
  ConfirmExit: boolean;
  ConfirmStopRender: boolean;
  SavePath, SmoothPalettePath: string;
  RandomPrefix, RandomDate: string;
  RandomIndex: integer;
  FlameFile, GradientFile, GradientEntry, FlameEntry: string;
  ParamFolder: string;
  prevLowQuality, prevMediumQuality, prevHighQuality: double;
  defSmoothPaletteFile: string;
  BrowserPath: string; // Stored path of browser open dialog
  EditPrevQual, MutatePrevQual, AdjustPrevQual: Integer;
  randMinTransforms, randMaxTransforms: integer;
  mutantMinTransforms, mutantMaxTransforms: integer;
  KeepBackground: boolean;
  randGradient: Integer;
  randGradientFile: string;
  defFlameFile: string;

  PlaySoundOnRenderComplete: boolean;
  RenderCompleteSoundFile: string;

  SaveIncompleteRenders: boolean;
  ShowRenderStats: boolean;
  LowerRenderPriority: boolean;

  SymmetryType: integer;
  SymmetryOrder: integer;
  SymmetryNVars: integer;
  Variations: array of boolean;
  //VariationOptions: int64;

  MainForm_RotationMode: integer;
  PreserveQuality: boolean;

  { For random gradients }

  MinNodes, MaxNodes, MinHue, MaxHue, MinSat, MaxSat, MinLum, MaxLum: integer;
  //ReferenceMode: integer;
  BatchSize: Integer;
  Compatibility: integer; //0 = original, 1 = Drave's
  Favorites: TStringList;
  Script: string;
  ScriptPath: string;
  SheepServer, SheepNick, SheepURL, SheepPW, flam3Path, helpPath: string;
  ExportBatches, ExportOversample, ExportWidth, ExportHeight, ExportFileFormat: Integer;
  ExportFilter, ExportDensity: Double;
  ExportEstimator, ExportEstimatorMin, ExportEstimatorCurve: double;
  ExportJitters: integer;
  ExportGammaTreshold: double;
  OpenFileType: TFileType;
//  ResizeOnLoad: Boolean;
  ShowProgress: Boolean;
  defLibrary: string;
  LimitVibrancy: Boolean;
  DefaultPalette: TColorMap;

  ChaoticaPath, ChaoticaPath64: string;
  UseX64IfPossible: boolean;

  AutoOpenLog: Boolean;
  AutoSaveEnabled: Boolean;
  AutoSaveFreq: integer;
  AutoSavePath: string;

  LineCenterColor : integer;
  LineThirdsColor : integer;
  LineGRColor : integer;
  EnableGuides : boolean;

function Round6(x: double): double;

implementation

function GetEnvVarValue(const VarName: string): string;
var
  BufSize: Integer;  // buffer size required for value
begin
  // Get required buffer size (inc. terminal #0)
  BufSize := GetEnvironmentVariable(
    PChar(VarName), nil, 0);
  if BufSize > 0 then
  begin
    // Read env var value into result string
    SetLength(Result, BufSize - 1);
    GetEnvironmentVariable(PChar(VarName),
      PChar(Result), BufSize);
  end
  else
    // No such environment variable
    Result := '';
end;

procedure LoadThumbnailPlaceholder(ThumbnailSize : integer);
var
  placeholder: TBitmap;
  placeholderIcon: TBitmap;
const
  pi_width = 48;
  pi_height = 48;
begin
  placeholder := TBitmap.Create;
  placeholderIcon := TBitmap.Create;

  placeholderIcon.Handle := LoadBitmap(hInstance, 'THUMB_PLACEHOLDER');
  placeholder.PixelFormat := pf32bit;
  placeholder.HandleType := bmDIB;
  placeholder.Width := ThumbnailSize;
  placeholder.Height := ThumbnailSize;

  with placeholder.Canvas do begin
    Brush.Color := $000000;
    FillRect(Rect(0, 0, placeholder.Width, placeholder.Height));
    Draw(round(ThumbnailSize / 2 - pi_width / 2), round(ThumbnailSize / 2 - pi_height / 2), placeholderIcon);
  end;

  placeholderIcon.Free;
  ThumbnailPlaceholder := placeholder;
end;

{ IFS }

function det(a, b, c, d: double): double;
begin
  Result := (a * d - b * c);
end;


function Round6(x: double): double;
// Really ugly, but it works
begin
  // --Z-- this is ridiculous:
  //   Result := StrToFloat(Format('%.6f', [x]));
  // and yes, this is REALLY ugly :-\
  Result := RoundTo(x, -6);
end;

function solve3(x1, x2, x1h, y1, y2, y1h, z1, z2, z1h: double;
  var a, b, e: double): double;
var
  det1: double;
begin
  det1 := x1 * det(y2, 1.0, z2, 1.0) - x2 * det(y1, 1.0, z1, 1.0)
    + 1 * det(y1, y2, z1, z2);
  if (det1 = 0.0) then
  begin
    Result := det1;
    EXIT;
  end
  else
  begin
    a := (x1h * det(y2, 1.0, z2, 1.0) - x2 * det(y1h, 1.0, z1h, 1.0)
      + 1 * det(y1h, y2, z1h, z2)) / det1;
    b := (x1 * det(y1h, 1.0, z1h, 1.0) - x1h * det(y1, 1.0, z1, 1.0)
      + 1 * det(y1, y1h, z1, z1h)) / det1;
    e := (x1 * det(y2, y1h, z2, z1h) - x2 * det(y1, y1h, z1, z1h)
      + x1h * det(y1, y2, z1, z2)) / det1;
    a := Round6(a);
    b := Round6(b);
    e := Round6(e);
    Result := det1;
  end;
end;

function dist(x1, y1, x2, y2: double): double;
//var
//  d2: double;
begin
(*
  { From FDesign source
  { float pt_pt_distance(float x1, float y1, float x2, float y2) }
  d2 := (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
  if (d2 = 0.0) then
  begin
    Result := 0.0;
    exit;
  end
  else
    Result := sqrt(d2);
*)

  // --Z-- This is just amazing... :-\
  // Someone needed an 'FDesign source' -  to compute distance between two points??!?

  Result := Hypot(x2-x1, y2-y1);
end;

function line_dist(x, y, x1, y1, x2, y2: double): double;
var
  a, b, e, c: double;
begin
  if ((x = x1) and (y = y1)) then
    a := 0.0
  else
    a := sqrt((x - x1) * (x - x1) + (y - y1) * (y - y1));
  if ((x = x2) and (y = y2)) then
    b := 0.0
  else
    b := sqrt((x - x2) * (x - x2) + (y - y2) * (y - y2));
  if ((x1 = x2) and (y1 = y2)) then
    e := 0.0
  else
    e := sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
  if ((a * a + e * e) < (b * b)) then
    Result := a
  else if ((b * b + e * e) < (a * a)) then
    Result := b
  else if (e <> 0.0) then
  begin
    c := (b * b - a * a - e * e) / (-2 * e);
    if ((a * a - c * c) < 0.0) then
      Result := 0.0
    else
      Result := sqrt(a * a - c * c);
  end
  else
    Result := a;
end;

function transform_affine(const t: TTriangle; const Triangles: TTriangles): boolean;
var
  ra, rb, rc, a, b, c: double;
begin
  Result := True;
  ra := dist(Triangles[-1].y[0], Triangles[-1].x[0],
    Triangles[-1].y[1], Triangles[-1].x[1]);
  rb := dist(Triangles[-1].y[1], Triangles[-1].x[1],
    Triangles[-1].y[2], Triangles[-1].x[2]);
  rc := dist(Triangles[-1].y[2], Triangles[-1].x[2],
    Triangles[-1].y[0], Triangles[-1].x[0]);
  a := dist(t.y[0], t.x[0], t.y[1], t.x[1]);
  b := dist(t.y[1], t.x[1], t.y[2], t.x[2]);
  c := dist(t.y[2], t.x[2], t.y[0], t.x[0]);
  if (a > ra) then
    Result := False
  else if (b > rb) then
    Result := False
  else if (c > rc) then
    Result := False
  else if ((a = ra) and (b = rb) and (c = rc)) then
    Result := False;
end;

function triangle_area(t: TTriangle): double;
var
  base, height: double;
begin
  try
    base := dist(t.x[0], t.y[0], t.x[1], t.y[1]);
    height := line_dist(t.x[2], t.y[2], t.x[1], t.y[1],
      t.x[0], t.y[0]);
    if (base < 1.0) then
      Result := height
    else if (height < 1.0) then
      Result := base
    else
      Result := 0.5 * base * height;
  except on E: EMathError do
      Result := 0;
  end;
end;

{ Parse }

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

(*
{ Palette and gradient functions }

function RGBToColor(Pal: TMapPalette; index: integer): Tcolor;
begin
  { Converts the RGB values from a palette index to the TColor type ...
    could maybe change it to SHLs }
  Result := (Pal.Blue[index] * 65536) + (Pal.Green[index] * 256)
    + Pal.Red[index];
end;

procedure rgb2hsv(const rgb: array of double; out hsv: array of double);
var
  maxval, minval: double;
  del: double;
begin
  Maxval := Max(rgb[0], Max(rgb[1], rgb[2]));
  Minval := Min(rgb[0], Min(rgb[1], rgb[2]));

  hsv[2] := maxval; // v

  if (Maxval > 0) and (maxval <> minval) then begin
    del := maxval - minval;
    hsv[1] := del / Maxval; //s

    hsv[0] := 0;
    if (rgb[0] > rgb[1]) and (rgb[0] > rgb[2]) then begin
      hsv[0] := (rgb[1] - rgb[2]) / del;
    end else if (rgb[1] > rgb[2]) then begin
      hsv[0] := 2 + (rgb[2] - rgb[0]) / del;
    end else begin
      hsv[0] := 4 + (rgb[0] - rgb[1]) / del;
    end;

    if hsv[0] < 0 then
      hsv[0] := hsv[0] + 6;

  end else begin
    hsv[0] := 0;
    hsv[1] := 0;
  end;
end;

procedure hsv2rgb(const hsv: array of double; out rgb: array of double);
var
  j: integer;
  f, p, q, t, v: double;
begin
  j := floor(hsv[0]);
  f := hsv[0] - j;
  v := hsv[2];
  p := hsv[2] * (1 - hsv[1]);
  q := hsv[2] * (1 - hsv[1] * f);
  t := hsv[2] * (1 - hsv[1] * (1 - f));

  case j of
    0: begin rgb[0] := v; rgb[1] := t; rgb[2] := p; end;
    1: begin rgb[0] := q; rgb[1] := v; rgb[2] := p; end;
    2: begin rgb[0] := p; rgb[1] := v; rgb[2] := t; end;
    3: begin rgb[0] := p; rgb[1] := q; rgb[2] := v; end;
    4: begin rgb[0] := t; rgb[1] := p; rgb[2] := v; end;
    5: begin rgb[0] := v; rgb[1] := p; rgb[2] := t; end;
  end;
end;

function GetGradient(FileName, Entry: string): string;
var
  FileStrings: TStringList;
  GradStrings: TStringList;
  i: integer;
begin
  FileStrings := TStringList.Create;
  GradStrings := TStringList.Create;
  try
    try
      FileStrings.LoadFromFile(FileName);
      for i := 0 to FileStrings.count - 1 do
        if Pos(Entry + ' ', Trim(FileStrings[i])) = 1 then break;
      GradStrings.Add(FileStrings[i]);
      repeat
        inc(i);
        GradStrings.Add(FileStrings[i]);
      until Pos('}', FileStrings[i]) <> 0;
      GetGradient := GradStrings.Text;
    except on exception do
        Result := '';
    end;
  finally
    GradStrings.Free;
    FileStrings.Free;
  end;
end;
*)

function ReplaceStr(Str, SearchStr, ReplaceStr: string): string;
begin
  while Pos(SearchStr, Str) <> 0 do
  begin
    Insert(ReplaceStr, Str, Pos(SearchStr, Str));
    system.Delete(Str, Pos(SearchStr, Str), Length(SearchStr));
  end;
  Result := Str;
end;

function SplitFilter(const fText: String; const fSep: Char; fTrim: Boolean=false; fQuotes: Boolean=false):TStringList;
var vI: Integer;
    vBuffer: String;
    vOn: Boolean;
begin
  Result:=TStringList.Create;
  vBuffer:='';
  vOn:=true;
  for vI:=1 to Length(fText) do
  begin
    if (fQuotes and(fText[vI]=fSep)and vOn)or(Not(fQuotes) and (fText[vI]=fSep)) then
    begin
      if fTrim then vBuffer:=Trim(vBuffer);
      if vBuffer='' then vBuffer:=fSep; // !!! e.g. split(',**',',')...
      if vBuffer[1]=fSep then
        vBuffer:=Copy(vBuffer,2,Length(vBuffer));
      Result.Add(vBuffer);
      vBuffer:='';
    end;
    if fQuotes then
    begin
      if fText[vI]='"' then
      begin
        vOn:=Not(vOn);
        Continue;
      end;
      if (fText[vI]<>fSep)or((fText[vI]=fSep)and(vOn=false)) then
        vBuffer:=vBuffer+fText[vI];
    end else
      if fText[vI]<>fSep then
        vBuffer:=vBuffer+fText[vI];
  end;
  if vBuffer<>'' then
  begin
    if fTrim then vBuffer:=Trim(vBuffer);
    Result.Add(vBuffer);
  end;
end;

function OpenSaveFileDialog(Parent: TWinControl;
                            const DefExt,
                            Filter,
                            InitialDir,
                            Title: string;
                            var FileName: string;
                            MustExist,
                            OverwritePrompt,
                            NoChangeDir,
                            DoOpen: Boolean): Boolean;
// uses commdlg
var
  ofn: TOpenFileName;
  szFile: array[0..260] of Char;
  fa, fa2: TStringList;
  h,i,j,k,c : integer;
  cs, s : string;
begin
  Result := False;
  FillChar(ofn, SizeOf(TOpenFileName), 0);
  with ofn do
  begin
    lStructSize := SizeOf(TOpenFileName);
    hwndOwner := Parent.Handle;
    lpstrFile := szFile;
    nMaxFile := SizeOf(szFile);
    if (Title <> '') then
      lpstrTitle := PChar(Title);
    if (InitialDir <> '') then
      lpstrInitialDir := PChar(InitialDir);
    StrPCopy(lpstrFile, FileName);
    lpstrFilter := PChar(ReplaceStr(Filter, '|', #0)+#0#0);
    fa := splitFilter(Filter, '|');

    k := 0;
    c := (fa.Count div 2);
    for i := 0 to c - 1 do begin
      j := 2 * i + 1;
      cs := LowerCase(fa.Strings[j]);
      fa2 := splitFilter(cs, ';');
      for h := 0 to fa2.Count - 1 do begin
        cs := fa2.Strings[h];
        s := '*.' + LowerCase(DefExt);
        if (cs = s) then k := i;
      end;
    end;

    nFilterIndex := k + 1;
    if DefExt <> '' then
      lpstrDefExt := PChar(DefExt);
  end;

  if MustExist then ofn.Flags := ofn.Flags or OFN_FILEMUSTEXIST;
  if OverwritePrompt then ofn.Flags := ofn.Flags or OFN_OVERWRITEPROMPT;
  if NoChangeDir then ofn.Flags := ofn.Flags or OFN_NOCHANGEDIR;

  if DoOpen then
  begin
    if GetOpenFileName(ofn) then
    begin
      Result := True;
      FileName := StrPas(szFile);
    end;
  end
  else
  begin
    if GetSaveFileName(ofn) then
    begin
      Result := True;
      FileName := StrPas(szFile);
    end;
  end
end; // function OpenSaveFileDialog

end.

