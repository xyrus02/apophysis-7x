unit ScrConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmConfig = class(TForm)
    btnCancel: TButton;
    btnOk: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    chkSave: TCheckBox;
    chkShowOtherImages: TCheckBox;
    rgQuality: TRadioGroup;
    edtOversample: TEdit;
    edtFiltersize: TEdit;
    edtDensity: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    pnlFilterpixels: TPanel;
    chkShowRndInfo: TCheckBox;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure rgQualityClick(Sender: TObject);
    procedure edtDensityExit(Sender: TObject);
    procedure edtFiltersizeExit(Sender: TObject);
    procedure edtOversampleExit(Sender: TObject);
  private
    procedure SetFilterPixels;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfig: TfrmConfig;

implementation

{$R *.dfm}

uses
  ControlPoint, Registry;

procedure TfrmConfig.FormCreate(Sender: TObject);
var
  Registry: TRegistry;
  locale: LCID;
  FloatFormatSettings: TFormatSettings;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('\Software\BobsFreubels\FlameSS', False) then begin
      if Registry.ValueExists('SaveImage') then begin
        chkSave.Checked := Registry.ReadBool('SaveImage');
      end else begin
        chkSave.Checked := False;
      end;
      if Registry.ValueExists('ShowOtherImages') then begin
        chkShowOtherImages.Checked := Registry.ReadBool('ShowOtherImages');
      end else begin
        chkShowOtherImages.Checked := False;
      end;
      if Registry.ValueExists('ShowRenderInfo') then begin
        chkShowRndInfo.Checked := Registry.ReadBool('ShowRenderInfo');
      end else begin
        chkShowRndInfo.Checked := True;
      end;
      if Registry.ValueExists('Quality') then begin
        rgQuality.itemindex := Registry.ReadInteger('Quality');
      end else begin
        rgQuality.itemindex := 1;
      end;
      if Registry.ValueExists('Oversample') then begin
        edtOversample.Text := IntToStr(Registry.ReadInteger('Oversample'));
      end else begin
        edtOversample.Text := '1';
      end;
      locale := GetSystemDefaultLCID;
      GetLocaleFormatSettings(locale, FloatFormatSettings);
      if Registry.ValueExists('Filter') then begin
        edtFiltersize.Text := FloatToStrF(Registry.ReadFloat('Filter'),
                                          ffFixed,
                                          6, 2,
                                          FloatFormatSettings
                                          );
      end else begin
        edtFiltersize.Text := '0.1';
      end;
      if Registry.ValueExists('Density') then begin
        edtDensity.Text := FloatToStrF(Registry.ReadFloat('Density'),
                                       ffFixed,
                                       6, 2,
                                       FloatFormatSettings
                                       );
      end else begin
        edtDensity.Text := '100';
      end;
    end else begin
      chkSave.Checked := False;
      chkShowOtherImages.Checked := False;
      chkShowRndInfo.Checked := True;
      rgQuality.itemindex := 1;
      edtOversample.Text := '1';
      edtFiltersize.Text := '0.1';
      edtDensity.Text := '100';
    end;
  finally
    Registry.Free;
  end;
  SetFilterPixels;
  rgQualityClick(nil);
end;


procedure TfrmConfig.btnCancelClick(Sender: TObject);
begin
  Close
end;

procedure TfrmConfig.btnOkClick(Sender: TObject);
var
  Registry: TRegistry;
  locale: LCID;
  FloatFormatSettings: TFormatSettings;
begin
  Registry := TRegistry.Create;
  try
    locale := GetSystemDefaultLCID;
    GetLocaleFormatSettings(locale, FloatFormatSettings);
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('\Software\BobsFreubels\FlameSS', True) then begin
      Registry.WriteBool('SaveImage', chkSave.Checked);
      Registry.WriteBool('ShowOtherImages', chkShowOtherImages.Checked);
      Registry.WriteBool('ShowRenderInfo', chkShowRndInfo.Checked);
      Registry.WriteInteger('Quality', rgQuality.itemindex);
      Registry.WriteInteger('Oversample', StrToInt(edtOversample.Text));
      Registry.WriteFloat('Filter', StrToFloat(edtFiltersize.Text, FloatFormatSettings));
      Registry.WriteFloat('Density', StrToFloat(edtDensity.Text, FloatFormatSettings));
    end;
  finally
    Registry.Free;
  end;

  Close
end;

procedure TfrmConfig.edtOversampleExit(Sender: TObject);
begin
  try
    StrToInt(edtOversample.Text);
  except
    edtOversample.Text := '1';
  end;

  SetFilterPixels
end;

procedure TfrmConfig.edtFiltersizeExit(Sender: TObject);
begin
  try
    StrToFloat(edtFiltersize.Text);
  except
    edtFiltersize.Text := '0.1';
  end;

  SetFilterPixels
end;

procedure TfrmConfig.edtDensityExit(Sender: TObject);
begin
  try
    StrToFloat(edtDensity.Text);
  except
    edtDensity.Text := '10';
  end;
end;

procedure TfrmConfig.SetFilterPixels;
var
  filter_width: integer;
begin
  filter_width := Round(2.0 * FILTER_CUTOFF * StrToFloat(edtFiltersize.Text) * StrToInt(edtOversample.Text) );
  if odd(filter_width + StrToInt(edtOversample.Text)) then
    inc(filter_width);
  pnlFilterpixels.Caption := IntToStr(filter_width);
end;

procedure TfrmConfig.rgQualityClick(Sender: TObject);
begin
  if rgQuality.ItemIndex = 3 then
    ClientHeight := panel1.Height + Panel2.Height + panel3.Height
  else
    ClientHeight := panel1.Height + Panel2.Height;
end;

end.
