unit formPostProcess;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Render, controlpoint, StdCtrls, ComCtrls;

type
  TfrmPostProcess = class(TForm)
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    Image: TImage;
    btnSave: TButton;
    Label1: TLabel;
    pnlBackColor: TPanel;
    ColorDialog: TColorDialog;
    ProgressBar1: TProgressBar;
    Label2: TLabel;
    btnApply: TButton;
    txtFilterRadius: TEdit;
    Label3: TLabel;
    txtGamma: TEdit;
    Label4: TLabel;
    txtVib: TEdit;
    Label5: TLabel;
    txtContrast: TEdit;
    Label6: TLabel;
    txtBrightness: TEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pnlBackColorClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FRenderer: TBaseRenderer;
    FCP: TControlPoint;
    FImagename: string;

    procedure UpdateFlame;
    procedure SetDefaultValues;

    procedure OnProgress(prog: double);

  public
    procedure SetRenderer(Renderer: TBaseRenderer);
    procedure SetControlPoint(CP: TControlPoint);
    procedure SetImageName(imagename: string);
  end;

var
  frmPostProcess: TfrmPostProcess;

implementation

uses
  ImageDLLLoader, ICOLoader, PNGLOader, HIPSLoader, BMPLoader, PCXLoader, WMFLoader,
  LinarBitmap, FileUtils, JPEGLoader, JPEG, Registry, Global;

{$R *.dfm}

{ TfrmPostProcess }

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.SetRenderer(Renderer: TBaseRenderer);
begin
  if assigned(FRenderer) then
    FRenderer.Free;

  FRenderer := Renderer;
  Frenderer.OnProgress := OnProgress;
  Image.Picture.Graphic := FRenderer.GetImage;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.FormShow(Sender: TObject);
var
  Registry: TRegistry;
begin
  { Read posution from registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('Software\' + APP_NAME + '\Forms\PostProcess', False) then begin
      if Registry.ValueExists('Left') then
        Left := Registry.ReadInteger('Left');
      if Registry.ValueExists('Top') then
        Top := Registry.ReadInteger('Top');
      if Registry.ValueExists('Width') then
        Width := Registry.ReadInteger('Width');
      if Registry.ValueExists('Height') then
        Height := Registry.ReadInteger('Height');
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;

end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Registry: TRegistry;
begin
  { Write position to registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('\Software\' + APP_NAME + '\Forms\PostProcess', True) then
    begin
      Registry.WriteInteger('Top', Top);
      Registry.WriteInteger('Left', Left);
      Registry.WriteInteger('Width', Width);
      Registry.WriteInteger('Height', Height);
    end;
  finally
    Registry.Free;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.SetDefaultValues;
begin
  pnlBackColor.Color := RGB(Fcp.background[0], Fcp.background[1], Fcp.background[2]);
  txtFilterRadius.Text := FloatTostr(FCP.spatial_filter_radius);
  txtGamma.Text := FloatTostr(FCP.gamma);
  txtVib.Text := FloatTostr(FCP.vibrancy);
  txtContrast.Text := FloatTostr(FCP.contrast);
  txtBrightness.Text := FloatTostr(FCP.brightness);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.SetControlPoint(CP: TControlPoint);
begin
  if assigned(FCP) then
    FCP.Free;

  FCP := cp.Clone;
  SetDefaultValues;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.pnlBackColorClick(Sender: TObject);
var
  col: Longint;
begin
  ColorDialog.Color := pnlBackColor.Color;
  if ColorDialog.Execute then begin
    pnlBackColor.Color := ColorDialog.Color;
    col := ColorToRGB(ColorDialog.Color);
    Fcp.background[0] := col and 255;
    Fcp.background[1] := (col shr 8) and 255;
    Fcp.background[2] := (col shr 16) and 255;
    UpdateFlame;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.UpdateFlame;
begin
  FRenderer.UpdateImage(FCP);
  Image.Picture.Graphic := FRenderer.GetImage;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.FormDestroy(Sender: TObject);
begin
  if assigned(FRenderer) then
    FRenderer.Free;

  if assigned(FCP) then
    FCP.Free;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.OnProgress(prog: double);
begin
  ProgressBar1.Position := round(100 * prog);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.btnApplyClick(Sender: TObject);
begin
  TryStrToFloat(txtFilterRadius.Text, FCP.spatial_filter_radius);
  if FCP.spatial_filter_radius > 2 then begin
    FCP.spatial_filter_radius := 2;
    txtFilterRadius.Text := '2';
  end else if FCP.spatial_filter_radius < 0 then begin
    FCP.spatial_filter_radius := 0.01;
    txtFilterRadius.Text := FloatTostr(0.01);
  end;

  TryStrToFloat(txtGamma.Text, FCP.gamma);
  if FCP.gamma > 10 then begin
    FCP.gamma := 10;
    txtGamma.Text := '10';
  end else if FCP.gamma < 0.01 then begin
    FCP.gamma := 0.01;
    txtGamma.Text := FloatTostr(0.01);
  end;

  TryStrToFloat(txtVib.Text, FCP.vibrancy);
  if FCP.vibrancy > 10 then begin
    FCP.vibrancy := 10;
    txtVib.Text := '10';
  end else if FCP.vibrancy < 0.01 then begin
    FCP.vibrancy := 0.01;
    txtVib.Text := FloatTostr(0.01);
  end;

  TryStrToFloat(txtContrast.Text, FCP.contrast);
  if FCP.contrast > 10 then begin
    FCP.contrast := 10;
    txtContrast.Text := '10';
  end else if FCP.contrast < 0.01 then begin
    FCP.contrast := 0.01;
    txtContrast.Text := FloatTostr(0.01);
  end;

  TryStrToFloat(txtBrightness.Text, FCP.brightness);
  if FCP.brightness > 10 then begin
    FCP.brightness := 10;
    txtBrightness.Text := '10';
  end else if FCP.brightness < 0.01 then begin
    FCP.brightness := 0.01;
    txtBrightness.Text := FloatTostr(0.01);
  end;

  UpdateFlame;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.btnSaveClick(Sender: TObject);
begin
  with TLinearBitmap.Create do
  try
    Assign(FRenderer.GetImage);
    JPEGLoader.Default.Quality := JPEGQuality;
    SaveToFile(FImagename);
  finally
    Free;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TfrmPostProcess.SetImageName(imagename: string);
begin
  FImagename := imagename;
end;

///////////////////////////////////////////////////////////////////////////////
end.
