unit ScrMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Gauges, Render64, ControlPoint;

type
  TfrmMain = class(TForm)
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    cp : TControlPoint;
    Render: TRenderer64;
    bStop : boolean;
    bm: TBitmap;

    Quality: integer;
    bSave: boolean;
    bShowOtherImages: boolean;
    Oversample: Integer;
    FilterSize: double;
    Density: double;

    SaveIndex: integer;
    SavePath: string;
    ImageList: TStringList;
    ShowNextImage: TDateTime;
    StartTime: TDateTime;
    Remainder: TDateTime;

    procedure ReadSettings;
    procedure PrePareSave;
    procedure Save;
  public
    procedure Onprogress(prog: double);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  math, jpeg, registry, FlameIO,
    rndFlame, regstry, global;

procedure TfrmMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Close;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Close;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  DecimalSeparator := '.';

  OnActivate := nil;

  ShowCursor(False);

  ReadSettings;

  Remainder := 1;

  // first one quickly
  cp.ParseString( 'pixels_per_unit 277.456647 center -1.0982659 0 gamma 2 spatial_filter_radius' +
                 ' 0.5 contrast 1 brightness 1.5 zoom 0 spatial_oversample 1 sample_density 1 nbatches' +
                 ' 1 white_level 200 cmap_inter 0 time 0 cmap 33 xform 0 density 1 color 0 var 0 0 0 1 0' +
                 ' 0 0 coefs 0.466381997 -0.0618700013 0.0792416036 0.610638022 -0.475656986 -0.28115499'+
                 ' xform 1 density 1 color 1 var 0 0 0 0 1 0 0 coefs -0.513867021 0.271649003 -0.254521996' +
                 ' -0.550984025 -0.674094975 -0.600323975');
(*
'center 0.01 1.96 pixels_per_unit 145.24' +
'spatial_oversample 3 spatial_filter_radius 0.30' +
'sample_density 200.00' +
'nbatches 1 white_level 200 background 0.00 0.00 0.00' +
'brightness 4.00 gamma 4.00 vibrancy 1.00 hue_rotation 0.68 cmap_inter 0' +
'xform 0 density 0.17 color 1.00' +
'var 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 1.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00' +
'coefs 0.94 0.69 -0.27 0.75 1.67 0.29' +
'xform 1 density 0.17 color 0.00' +
'var 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 1.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00' +
'coefs -0.07 -0.94 0.69 -0.15 1.93 -1.57' +
'xform 2 density 0.17 color 0.00' +
'var 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 1.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00' +
'coefs 0.42 -0.37 -0.88 -0.25 -0.65 0.22' +
'xform 3 density 0.17 color 0.00' +
'var 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 1.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00' +
'coefs 0.61 0.99 0.06 0.51 -1.59 -1.58' +
'xform 4 density 0.17 color 0.00' +
'var 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 1.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00' +
'coefs -0.77 0.12 -0.36 -0.69 -0.74 1.53' +
'xform 5 density 0.17 color 0.00           ' +
'var 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 1.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00' +
'coefs 0.58 -0.20 -0.92 0.60 -0.29 1.30');
*)
  cp.sample_density := 2;
  cp.Width := ClientWidth;
  cp.Height := ClientHeight;
  cp.spatial_oversample := 1;
  cp.spatial_filter_radius := 0.3;
  cp.Gamma := 4;
  cp.brightness := 4;
  cp.CalcBoundbox;
  Render.SetCP(cp);

  StartTime := Now;
  Render.Render;
  if bstop then
    Exit;
  BM.Assign(Render.GetImage);
  Canvas.StretchDraw(Rect(0,0,ClientWidth, ClientHeight),bm);

  PrepareSave;
  if bstop then
    Exit;

  ShowNextImage := Now + EncodeTime(0,0,5,0);

  cp.Width := ClientWidth;
  cp.Height := ClientHeight;
  cp.spatial_filter_radius := 0.2;
  cp.Gamma := 4;
  cp.brightness := 4;
  cp.spatial_oversample := 1;

  Case Quality of
  0:
    begin
      cp.sample_density := 10;
    end;
  1:
    begin
      cp.sample_density := 100;
    end;
  2:
    begin
      cp.sample_density := 1000;
    end;
  else
    begin
      cp.sample_density := Density;
      cp.spatial_oversample := Oversample;
      cp.spatial_filter_radius := FilterSize;
    end;
  end;

  // APO setting for randomflame
  regstry.ReadSettings;
  Global.MainSeed := Round(Random(100000));

  while true do begin
    Remainder := 0;
//    cp.RandomCP;
(*
    cp2 := cp.Clone;
    cp2.pixels_per_unit := (cp.pixels_per_unit * 128)/cp.Width;
    cp2.width := 256;
    cp2.height := 256;
    cp2.spatial_oversample := 1;
    cp2.spatial_filter_radius := 0.1;
    cp2.sample_density := 1;
    cp2.gamma := 2;
    cp2.brightness := 1;
    cp2.contrast := 1;

    Render.SetCP(cp2);
    Render.Test(fracBlack, fracWhite, avgColor);
    cp2.Free;
*)
//    Canvas.Draw(0,100,Render.GetImage);

//    if (fracBlack > 0.990) or ((avgColor/(fracBlack + 1E-6)) < 0.35) then
//      Continue;

    cp := RandomFlame(cp,0);
    cp.Width := ClientWidth;
    cp.Height := ClientHeight;
    cp.spatial_filter_radius := 0.2;
    cp.Gamma := 4;
    cp.brightness := 4;
    cp.spatial_oversample := 1;

    Case Quality of
    0:
      begin
        cp.sample_density := 10;
      end;
    1:
      begin
        cp.sample_density := 100;
      end;
    2:
      begin
        cp.sample_density := 1000;
      end;
    else
      begin
        cp.sample_density := Density;
        cp.spatial_oversample := Oversample;
        cp.spatial_filter_radius := FilterSize;
      end;
    end;
    cp.CalcBoundbox;

    Remainder := 1;
    Render.SetCP(cp);
    StartTime := Now;

    Render.Render;

    if bstop then
      Exit;

    bm.assign(Render.GetImage);
//    bm.Canvas.Font.Color := ClWhite;
//    bm.Canvas.Brush.Color := CLBlack;
//    bm.Canvas.TextOut(10,10, Format('fracBlack : %.4f',[fracBlack] ));
//    bm.Canvas.TextOut(10,26, Format('fracWhite : %.4f',[fracWhite] ));
//    bm.Canvas.TextOut(10,42, Format('avgColor  : %.4f',[avgColor] ));
//    bm.Canvas.TextOut(10,58, Format('ColorValue: %.4f',[avgColor/fracBlack] ));

    Canvas.Draw(0,0,bm);
    Save;
    ShowNextImage := Now + EncodeTime(0,0,30,0);
  end;
end;

procedure TfrmMain.Onprogress(prog: double);
var
  JPeg: TJPEGImage;
  NewIndex: Integer;
  Elapsed: TDateTime;
begin
  if bstop then
    Exit;

  if bShowOtherImages and (Now > ShowNextImage) and (ImageList.Count > 0) then begin
    NewIndex := Random(ImageList.Count);

    JPeg := TJPEGImage.Create;
    JPeg.LoadFromFile(SavePath + ImageList[NewIndex]);

    bm.Assign(JPeg);
    JPeg.Free;

    repaint;

    SetbkMode(Canvas.Handle, TRANSPARENT);
    Canvas.TextOut(ClientWidth - 150, 10, ImageList[NewIndex]);
    ShowNextImage := Now + EncodeTime(0,0,10,0);
  end;

  prog := (Render.Slice + Prog)/Render.NrSlices;

//  Canvas.Brush.Color := clBlack;
//  Canvas.Fillrect(Rect(7, ClientHeight - 13, ClientWidth - 7, ClientHeight - 7));

//  Canvas.Brush.Color := clBlack;
//  Canvas.Fillrect(Rect(5, ClientHeight - 15, ClientWidth - 5, ClientHeight - 5));


  Canvas.Brush.Color := clYellow;
  Canvas.FrameRect(Rect(5, ClientHeight - 15, ClientWidth - 5, ClientHeight - 5));
  Canvas.Brush.Color := clYellow;
  Canvas.Fillrect(Rect(7, ClientHeight - 13, 7 + Round(prog * (ClientWidth - 14)), ClientHeight - 7));
  Canvas.Brush.Color := clBlack;
  Canvas.Fillrect(Rect(7 + Round(prog * (ClientWidth - 14)), ClientHeight - 13, ClientWidth - 7, ClientHeight - 7));

  Elapsed := Now - StartTime;
  Canvas.Brush.Color := clBlack;
  Canvas.TextOut(5, ClientHeight - 25 - 2 * Canvas.TextHeight('X'), Format('Elapsed %2.2d:%2.2d:%2.2d.%2.2d',
                     [Trunc(Elapsed * 24),
                       Trunc((Elapsed * 24 - Trunc(Elapsed * 24)) * 60),
                        Trunc((Elapsed * 24 * 60 - Trunc(Elapsed * 24 * 60)) * 60),
                         Trunc((Elapsed * 24 * 60 * 60 - Trunc(Elapsed * 24 * 60 * 60)) * 100)]));

  if prog > 0 then
    Remainder := Min(Remainder, Elapsed * (power(1/prog, 1.2) - 1));

  Canvas.TextOut(5, ClientHeight - 20 - Canvas.TextHeight('X'), Format('Remainder %2.2d:%2.2d:%2.2d.%2.2d',
                     [Trunc(Remainder * 24),
                       Trunc((Remainder * 24 - Trunc(Remainder * 24)) * 60),
                        Trunc((Remainder * 24 * 60 - Trunc(Remainder * 24 * 60)) * 60),
                         Trunc((Remainder * 24 * 60 * 60 - Trunc(Remainder * 24 * 60 * 60)) * 100)]));

  Canvas.TextOut(5, ClientHeight - 50 - Canvas.TextHeight('X'), IncludeTrailingPathDelimiter(ExtractFileDir(paramstr(0))) + 'images');

  Application.ProcessMessages;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  bm:= TBitmap.create;
  randomize;
  cp := TControlPoint.Create;
  Render := TRenderer64.Create;
  Render.OnProgress := Onprogress;
  ImageList := TStringList.Create;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  ShowCursor(true);
  cp.Free;
  render.Free;
  ImageList.Free;
end;

procedure TfrmMain.FormPaint(Sender: TObject);
begin
  if assigned(bm) then
    Canvas.Draw(0,0,bm);
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  bm.Free;
  Render.Stop;
  bStop := True;
end;

procedure TfrmMain.ReadSettings;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('\Software\BobsFreubels\FlameSS', False) then begin
      if Registry.ValueExists('SaveImage') then begin
        bSave := Registry.ReadBool('SaveImage');
      end else begin
        bSave := False;
      end;
      if Registry.ValueExists('ShowOtherImages') then begin
        bShowOtherImages := Registry.ReadBool('ShowOtherImages');
      end else begin
        bShowOtherImages := False;
      end;
      if Registry.ValueExists('Quality') then begin
        Quality := Registry.ReadInteger('Quality');
      end else begin
        Quality := 1;
      end;
      if Registry.ValueExists('Oversample') then begin
        Oversample := Registry.ReadInteger('Oversample');
      end else begin
        Oversample := 1;
      end;
      if Registry.ValueExists('Filter') then begin
        Filtersize := Registry.ReadFloat('Filter');
      end else begin
        Filtersize := 0.1;
      end;
      if Registry.ValueExists('Density') then begin
        Density := Registry.ReadFloat('Density');
      end else begin
        Density := 100;
      end;

    end else begin
      bSave := False;
      Quality := 1;
    end;
  finally
    Registry.Free;
  end;
end;

procedure TfrmMain.PrePareSave;
var
  sr: TSearchRec;
begin
//  if not bSave then
//    Exit;

  SaveIndex := 1;

  SavePath := IncludeTrailingPathDelimiter(ExtractFileDir(paramstr(0))) + 'images';
  SavePath := IncludeTrailingPathDelimiter(SavePath);

  ForceDirectories(SavePath);

  if FindFirst(SavePath + '*.jpg', faAnyFile, sr) = 0 then begin
    repeat
      ImageList.Add(UpperCase(sr.Name));
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure TfrmMain.Save;
var
  sl: TStringlist;
  ImageName: string;
  jpeg : TJPegImage;
begin
  if not bSave then
    Exit;

  repeat
    ImageName := Format('FL_%5.5d.JPG',[SaveIndex]);
    Inc(SaveIndex);
  until (ImageList.IndexOf(ImageName) < 0);

  jpeg := TJPegImage.Create;
  jpeg.assign(bm);
  jpeg.CompressionQuality := 80;
  jpeg.SaveToFile(SavePath+ImageName);
  jpeg.free;

  ImageList.Add(ImageName);

  sl := TStringlist.Create;

  Cp.name := ChangeFileExt(ImageName,'');
  sl.add(FlameToXML(cp,False, True));

  sl.SaveToFile(ChangeFileExt(SavePath+ImageName,'.flame'));
  sl.Free;

//  cp.SaveToFile(ChangeFileExt(SavePath+ImageName,'.TXT'));
end;

end.

