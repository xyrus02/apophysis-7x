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
unit FormRender;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ControlPoint, RenderThread, ComCtrls, Math, Buttons, Registry, cmap,
  ImageDLLLoader, ICOLoader, PNGLOader, HIPSLoader, BMPLoader, PCXLoader, WMFLoader,
  LinarBitmap, ExtCtrls, FileUtils, JPEGLoader, JPEG;

const
  WM_THREAD_COMPLETE = WM_APP + 5437;
  WM_THREAD_TERMINATE = WM_APP + 5438;

type
  TRenderForm = class(TForm)
    ProgressBar: TProgressBar;
    btnRender: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    btnBrowse: TSpeedButton;
    Label10: TLabel;
    txtFilename: TEdit;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    txtOversample: TEdit;
    txtFilterRadius: TEdit;
    txtDensity: TEdit;
    GroupBox4: TGroupBox;
    lblApproxMem: TLabel;
    lblPhysical: TLabel;
    Label9: TLabel;
    cbMaxMemory: TComboBox;
    chkLimitMem: TCheckBox;
    SaveDialog: TSaveDialog;
    btnPause: TButton;
    chkSave: TCheckBox;
    GroupBox5: TGroupBox;
    btnSavePreset: TSpeedButton;
    cmbPreset: TComboBox;
    btnDeletePreset: TSpeedButton;
    udOversample: TUpDown;
    chkMaintain: TCheckBox;
    cbWidth: TComboBox;
    cbHeight: TComboBox;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnRenderClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure txtWidthChange(Sender: TObject);
    procedure txtHeightChange(Sender: TObject);
    procedure txtOversampleChange(Sender: TObject);
    procedure chkLimitMemClick(Sender: TObject);
    procedure txtFilenameChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure txtDensityChange(Sender: TObject);
    procedure txtFilterRadiusChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPauseClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnSavePresetClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnDeletePresetClick(Sender: TObject);
    procedure cmbPresetChange(Sender: TObject);
    procedure chkMaintainClick(Sender: TObject);
  private

    StartTime: TDateTime;
    Remainder: TDateTime;

    procedure HandleThreadCompletion(var Message: TMessage);
      message WM_THREAD_COMPLETE;
    procedure HandleThreadTermination(var Message: TMessage);
      message WM_THREAD_TERMINATE;
    procedure ListPresets;
  public
    Renderer: TRenderThread;
    PhysicalMemory, ApproxMemory: int64;
    ColorMap: TColorMap;
    cp: TControlPoint;
    Filename: string;
    ImageWidth, ImageHeight, Oversample: Integer;
    zoom, Sample_Density, Brightness, Gamma, Vibrancy, Filter_Radius: double;
    center: array[0..1] of double;

    procedure OnProgress(prog: double);
    procedure ShowMemoryStatus;
    procedure ResetControls;
  end;

var
  RenderForm: TRenderForm;
  Ratio: double;

implementation

uses Main, Global, SavePreset, FileCtrl;

{$R *.DFM}

procedure TRenderForm.ResetControls;
begin
  txtFilename.Enabled := true;
  btnBrowse.Enabled := true;
  cbWidth.Enabled := true;
  cbHeight.Enabled := true;
  txtDensity.Enabled := true;
  txtFilterRadius.enabled := true;
  txtOversample.Enabled := true;
  chkLimitMem.Enabled := true;
  cbMaxMemory.enabled := chkLimitMem.Checked;
  btnRender.Enabled := true;
  cmbPreset.enabled := true;
  chkSave.enabled := true;
  btnSavePreset.enabled := true;
  btnDeletePreset.enabled := true;
  btnCancel.Caption := 'Close';
  btnPause.enabled := false;
  ProgressBar.Position := 0;
  ShowMemoryStatus;
end;

procedure TRenderForm.ShowMemoryStatus;
var
  GlobalMemoryInfo: TMemoryStatus; // holds the global memory status information
begin
  GlobalMemoryInfo.dwLength := SizeOf(GlobalMemoryInfo);
  GlobalMemoryStatus(GlobalMemoryInfo);
  PhysicalMemory := GlobalMemoryInfo.dwAvailPhys div 1048576;
  ApproxMemory := 32 * Oversample * Oversample;
  ApproxMemory := ApproxMemory * ImageHeight * ImageWidth;
  ApproxMemory := ApproxMemory div 1048576;
//  ApproxMemory := (32 * Oversample * Oversample * ImageHeight * ImageWidth) div 1048576; // or 1000000?
  lblPhysical.Caption := 'Physical memory available: ' + Format('%d', [PhysicalMemory]) + ' MB';
  lblApproxMem.Caption := 'Approximate memory required: ' + Format('%d', [ApproxMemory]) + ' MB';
  if ApproxMemory > PhysicalMemory then
    ; // show warning icon.
end;

procedure TRenderForm.HandleThreadCompletion(var Message: TMessage);
begin
  with TLinearBitmap.Create do
  try
    Assign(Renderer.GetImage);
    JPEGLoader.Default.Quality := JPEGQuality;
    SaveToFile(RenderForm.FileName);
    Renderer.Free;
    Renderer := nil;
    ResetControls;
  finally
    Free;
  end;
end;

procedure TRenderForm.HandleThreadTermination(var Message: TMessage);
begin
  if Assigned(Renderer) then
  begin
    Renderer.Free;
    Renderer := nil;
    ResetControls;
  end;
end;

procedure TRenderForm.OnProgress(prog: double);
var
  Elapsed: TDateTime;
  e, r: string;
begin

  prog := (Renderer.Slice + Prog) / Renderer.NrSlices;

  if ShowProgress then ProgressBar.Position := round(100 * prog);

  Elapsed := Now - StartTime;
  e := Format('Elapsed %2.2d:%2.2d:%2.2d.%2.2d',
    [Trunc(Elapsed * 24),
    Trunc((Elapsed * 24 - Trunc(Elapsed * 24)) * 60),
      Trunc((Elapsed * 24 * 60 - Trunc(Elapsed * 24 * 60)) * 60),
      Trunc((Elapsed * 24 * 60 * 60 - Trunc(Elapsed * 24 * 60 * 60)) * 100)]);

  if prog > 0 then
    Remainder := Min(Remainder, Elapsed * (power(1 / prog, 1.2) - 1));

  r := Format('Remaining %2.2d:%2.2d:%2.2d.%2.2d',
    [Trunc(Remainder * 24),
    Trunc((Remainder * 24 - Trunc(Remainder * 24)) * 60),
      Trunc((Remainder * 24 * 60 - Trunc(Remainder * 24 * 60)) * 60),
      Trunc((Remainder * 24 * 60 * 60 - Trunc(Remainder * 24 * 60 * 60)) * 100)]);

    StatusBar.Panels[0].text := e;
    StatusBar.Panels[1].text := r;
    StatusBar.Panels[2].text := 'Slice ' + IntToStr(Renderer.Slice + 1) + ' of ' + IntToStr(Renderer.nrSlices);
end;

procedure TRenderForm.FormCreate(Sender: TObject);
begin
  cp := TControlPoint.Create;
  ImageDLLLoader.Default.FindDLLs(ProgramPath);
  cbMaxMemory.ItemIndex := 1;
  MainForm.Buttons.GetBitmap(2, btnSavePreset.Glyph);
  MainForm.Buttons.GetBitmap(9, btnDeletePreset.Glyph);
  ListPresets;
end;

procedure TRenderForm.FormDestroy(Sender: TObject);
begin
  if assigned(Renderer) then Renderer.Terminate;
  if assigned(Renderer) then Renderer.WaitFor;
  if assigned(Renderer) then Renderer.Free;
  cp.free;
end;

procedure TRenderForm.btnRenderClick(Sender: TObject);
var
  t: string;
begin
  ImageWidth := StrToInt(cbWidth.text);
  ImageHeight := StrToInt(cbHeight.text);
  if (not chkLimitMem.checked) and (ApproxMemory > PhysicalMemory) then
  begin
    Application.MessageBox('You do not have enough memory for this render. Please use memory limiting.', 'Apophysis', 48);
//    exit;
  end;
  if chkLimitMem.checked and (PhysicalMemory < StrToInt(cbMaxMemory.text)) and (Approxmemory > PhysicalMemory) then begin
    Application.MessageBox('You do not have enough memory for this render. Please use a lower Maximum memory setting.', 'Apophysis', 48);
//    exit;
  end;
  t := txtFilename.Text;
  if t = '' then
  begin
    Application.MessageBox(PChar('Please enter a file name.'), 'Apophysis', 48);
    Exit;
  end;
  if FileExists(t) then
    if Application.MessageBox(PChar(t + ' already exists.' + chr(13) + 'Do you want to replace it?'),
      'Apophysis', 52) = ID_NO then exit;
  if not DirectoryExists(ExtractFileDir(t)) then
  begin
    Application.MessageBox('The directory does not exist.', 'Apophyis', 16);
    exit;
  end;
  {Check for invalid values }
  if sample_density <= 0 then
  begin
    Application.MessageBox('Invalid Sample Density value', 'Apophysis', 16);
    exit;
  end;
  if filter_radius <= 0 then
  begin
    Application.MessageBox('Invalid Filter Radius value', 'Apophysis', 16);
    exit;
  end;
  if Oversample < 1 then
  begin
    Application.MessageBox('Invalid Oversmple value', 'Apophysis', 16);
    exit;
  end;
  if ImageWidth < 1 then
  begin
    Application.MessageBox('Invalid image width', 'Apophysis', 16);
    exit;
  end;
  if ImageHeight < 1 then
  begin
    Application.MessageBox('Invalid image height', 'Apophysis', 16);
    exit;
  end;
  txtFilename.Enabled := false;
  btnBrowse.Enabled := false;
  cbWidth.Enabled := False;
  cbHeight.Enabled := false;
  txtDensity.Enabled := false;
  txtFilterRadius.enabled := false;
  txtOversample.Enabled := false;
  chkLimitMem.Enabled := false;
  cbMaxMemory.Enabled := false;
  cmbPreset.enabled := false;
  chkSave.enabled := false;
  btnSavePreset.enabled := false;
  btnDeletePreset.enabled := false;
  btnRender.Enabled := false;
  btnPause.enabled := true;
  btnCancel.Caption := 'Stop';
  StartTime := Now;
  Remainder := 365;
  if Assigned(Renderer) then Renderer.Terminate;
  if Assigned(Renderer) then Renderer.WaitFor;
  if not Assigned(Renderer) then
  begin
      // disable screensaver
    SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, 0, nil, 0);

    cp.sample_density := Sample_density;
    cp.spatial_oversample := Oversample;
    cp.spatial_filter_radius := Filter_Radius;
    AdjustScale(cp, ImageWidth, ImageHeight);
    renderPath := ExtractFilePath(Filename);
    if chkSave.checked then
      MainForm.SaveXMLFlame(cp, ExtractFileName(FileName), renderPath + 'renders.flame');
    Renderer := TRenderThread.Create;
    if chkLimitMem.checked then
      Renderer.MaxMem := StrToInt(cbMaxMemory.text);
    Renderer.OnProgress := OnProgress;
    Renderer.TargetHandle := RenderForm.Handle;
    Renderer.Compatibility := compatibility;
    Renderer.SetCP(cp);
    Renderer.Priority := tpLower;
    Renderer.Resume;

    // enable screensaver
    SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, 1, nil, 0);
  end;
end;

procedure TRenderForm.FormShow(Sender: TObject);
var
  Registry: TRegistry;
begin
  { Read posution from registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('Software\' + APP_NAME + '\Forms\Render', False) then
    begin
      if Registry.ValueExists('Left') then
        RenderForm.Left := Registry.ReadInteger('Left');
      if Registry.ValueExists('Top') then
        RenderForm.Top := Registry.ReadInteger('Top');
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
  SaveDialog.FileName := Filename;
  case renderFileFormat of
    1: txtFilename.Text := ChangeFileExt(SaveDialog.Filename, '.bmp');
    2: txtFilename.Text := ChangeFileExt(SaveDialog.Filename, '.png');
    3: txtFilename.Text := ChangeFileExt(SaveDialog.Filename, '.jpg');
  end;
  txtOversample.Text := IntToStr(renderOversample);
  txtFilterRadius.Text := FloatToStr(renderFilterRadius);
  cbWidth.Text := IntToStr(MainForm.Image.Width);
  cbHeight.Text := IntToStr(MainForm.Image.Height);
  ImageWidth := StrToInt(cbWidth.Text);
  ImageHeight := StrToInt(cbHeight.Text);
  txtDensity.Text := FloatToStr(renderDensity);
  ShowMemoryStatus;
  Ratio := ImageWidth / ImageHeight;
end;

procedure TRenderForm.txtWidthChange(Sender: TObject);
begin
  try
    ImageWidth := StrToInt(cbWidth.Text);
    if chkMaintain.checked and cbWidth.Focused then
    begin
      ImageHeight := Round(ImageWidth / ratio);
      cbHeight.Text := IntToStr(ImageHeight)
    end;
  except
  end;
  ShowMemoryStatus;
end;

procedure TRenderForm.txtHeightChange(Sender: TObject);
begin
  try
    ImageHeight := StrToInt(cbHeight.Text);
    if chkMaintain.checked and cbHeight.Focused then
    begin
      ImageWidth := Round(ImageHeight * ratio);
      cbWidth.Text := IntToStr(ImageWidth)
    end;
  except
  end;
  ShowMemoryStatus;
end;

procedure TRenderForm.txtOversampleChange(Sender: TObject);
begin
  if StrToInt(txtOversample.Text) > udOversample.Max then
    txtOversample.Text := IntToStr(udOversample.Max);
  if StrToInt(txtOversample.Text) < udOversample.Min then
    txtOversample.Text := IntToStr(udOversample.Min);
  try
    Oversample := StrToInt(txtOversample.Text);
  except
  end;
  ShowMemoryStatus;
end;

procedure TRenderForm.chkLimitMemClick(Sender: TObject);
begin
  cbMaxMemory.enabled := chkLimitMem.Checked;
end;

procedure TRenderForm.txtFilenameChange(Sender: TObject);
begin
  filename := txtFilename.text;
end;

procedure TRenderForm.btnCancelClick(Sender: TObject);
begin
  if Assigned(Renderer) then
    Renderer.Terminate
  else
    close;
end;

procedure TRenderForm.txtDensityChange(Sender: TObject);
begin
  try
    Sample_Density := StrToFloat(txtDensity.Text);
  except
  end;
end;

procedure TRenderForm.txtFilterRadiusChange(Sender: TObject);
begin
  try
    Filter_Radius := StrToFloat(txtFilterRadius.Text);
  except
  end;
end;

procedure TRenderForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Ext: string;
  Registry: TRegistry;
begin
  Ext := ExtractFileExt(txtFileName.Text);
  if Ext = '.bmp' then renderFileFormat := 1;
  if Ext = '.png' then renderFileFormat := 2;
  if (Ext = '.jpg') or (Ext = '.jpeg') then renderFileFormat := 3;
  renderFilterRadius := Filter_Radius;
  renderWidth := ImageWidth;
  renderHeight := ImageHeight;
  renderDensity := Sample_density;
  renderOversample := Oversample;
  { Write position to registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('\Software\' + APP_NAME + '\Forms\Render', True) then
    begin
      Registry.WriteInteger('Top', RenderForm.Top);
      Registry.WriteInteger('Left', RenderForm.Left);
    end;
  finally
    Registry.Free;
  end;
end;

procedure TRenderForm.btnPauseClick(Sender: TObject);
begin
  if Assigned(Renderer) then
    if Renderer.Suspended = false then
    begin
      renderer.suspend;
      btnPause.caption := 'Resume';
    end
    else
    begin
      renderer.resume;
      btnPause.caption := 'Pause';
    end;
end;

procedure TRenderForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if Assigned(Renderer) then
    if Application.MessageBox('Do you want to abort the current render?', 'Apophysis', 36) = ID_NO then
      CanClose := False
    else
    begin
      if Assigned(Renderer) then Renderer.Terminate;
    end;
end;

procedure TRenderForm.btnSavePresetClick(Sender: TObject);
var
  IFile: TextFile;
  Title, Filename: string;
begin
  SavePresetForm.txtPresetName.Text := cmbPreset.Text;
  if SavePresetForm.ShowModal = mrOK then
  begin
    Title := Trim(SavePresetForm.txtPresetName.Text);
    Filename := AppPath + 'render presets';
    try
      AssignFile(IFile, FileName);
      if FileExists(FileName) then
      begin
        if EntryExists(Title, FileName) then DeleteEntry(Title, FileName);
        Append(IFile);
      end
      else
        ReWrite(IFile);
      WriteLn(IFile, Title + ' {');
      WriteLn(IFile, Trim(cbWidth.text));
      WriteLn(IFile, Trim(cbHeight.text));
      WriteLn(IFile, Trim(txtDensity.text));
      WriteLn(IFile, Trim(txtFilterRadius.text));
      WriteLn(IFile, Trim(txtOversample.text));
      WriteLn(IFile, ExtractFileExt(txtFileName.Text));
      if chkLimitMem.Checked then
        WriteLn(IFile, 'true')
      else
        WriteLn(IFile, 'false');
      WriteLn(IFile, IntToStr(cbMaxMemory.ItemIndex));
      WriteLn(IFile, cbMaxMemory.Text);
      WriteLn(IFile, '}');
      WriteLn(IFile, '');
      CloseFile(IFile);
    except on EInOutError do
      begin
        Application.MessageBox('Cannot save preset.', 'Apophysis', 16);
        Exit;
      end;
    end;
    ListPresets;
    cmbPreset.ItemIndex := cmbPreset.Items.count - 1;
  end;
end;

procedure TRenderForm.btnBrowseClick(Sender: TObject);
begin
  SaveDialog.Filename := Filename;
  case renderFileFormat of
    1: SaveDialog.DefaultExt := 'bmp';
    2: SaveDialog.DefaultExt := 'png';
    3: SaveDialog.DefaultExt := 'jpg';
  end;
  SaveDialog.filterIndex := renderFileFormat;
  SaveDialog.Filter := 'Bitmap image (*.bmp) | *.bmp|PNG Image (*.png)|*.png|JPEG image (*.jpg;*.jpeg)|*.jpg;*.jpeg';
  if SaveDialog.Execute then
  begin
    case SaveDialog.FilterIndex of
      1: txtFilename.Text := ChangeFileExt(SaveDialog.Filename, '.bmp');
      2: txtFilename.Text := ChangeFileExt(SaveDialog.Filename, '.png');
      3: txtFilename.Text := ChangeFileExt(SaveDialog.Filename, '.jpg');
    end;
    renderFileFormat := SaveDialog.FilterIndex;
    renderPath := ExtractFilePath(SaveDialog.Filename);
  end;
end;

procedure TRenderForm.ListPresets;
{ List identifiers in file }
var
  i, p: integer;
  Title: string;
  FStrings: TStringList;
begin
  try
    FStrings := TStringList.Create;
    if fileExists(AppPath + 'render presets') then begin
      FStrings.LoadFromFile(AppPath + 'render presets');
      cmbPreset.Clear;
      if (Pos('{', FStrings.Text) <> 0) then begin
        for i := 0 to FStrings.Count - 1 do begin
          p := Pos('{', FStrings[i]);
          if (p <> 0) then  begin
            Title := Trim(Copy(FStrings[i], 1, p - 1));
            if Title <> '' then begin
              cmbPreset.Items.add(Copy(FStrings[i], 1, p - 1));
            end;
          end;
        end;
      end;
    end;
  finally
    FStrings.Free;
  end;
end;

procedure TRenderForm.btnDeletePresetClick(Sender: TObject);
var
  Title, Filename: string;
begin
  Title := Trim(cmbPreset.Text);
  if Title = '' then exit;
  Filename := AppPath + 'render presets';
  if EntryExists(Title, FileName) then DeleteEntry(Title, FileName);
  ListPresets;
end;

procedure TRenderForm.cmbPresetChange(Sender: TObject);
var
  chk: boolean;
  i, j: integer;
  FStrings: TStringList;
  Title, Filename: string;
begin
  Title := Trim(cmbPreset.Text);
  Filename := AppPath + 'render presets';
  if Title = '' then exit;
  if EntryExists(Title, FileName) then
  begin
  // Load preset
    FStrings := TStringList.Create;
    try
      FStrings.LoadFromFile(Filename);
      for i := 0 to FStrings.Count - 1 do
        if Pos(LowerCase(Title) + ' {', Lowercase(FStrings[i])) <> 0 then
        begin
          chk := chkMaintain.checked;
          chkMaintain.Checked := False;
          j := i + 1;
          cbWidth.Text := FStrings[j];
          inc(j);
          cbHeight.text := FStrings[j];
          chkMaintain.Checked := chk;
          inc(j);
          txtDensity.text := FStrings[j];
          inc(j);
          txtFilterRadius.text := FStrings[j];
          inc(j);
          txtOversample.text := FStrings[j];
          inc(j);
          txtFileName.Text := ChangeFileExt(txtFileName.Text, FStrings[j]);
          inc(j);
          if Fstrings[j] = 'true' then chkLimitMem.checked := true else chkLimitMem.checked := false;
          inc(j);
          cbMaxMemory.ItemIndex := StrToInt(Fstrings[j]);
          cbMaxMemory.enabled := chkLimitMem.checked;
          inc(j);
          cbMaxMemory.Text := Fstrings[j];
          break;
        end;
    finally
      FStrings.Free;
    end
  end;
  ImageWidth := StrToInt(cbWidth.Text);
  ImageHeight := StrToInt(cbHeight.Text);
  ShowMemoryStatus;
end;

procedure TRenderForm.chkMaintainClick(Sender: TObject);
begin
  Ratio := ImageWidth / ImageHeight;
end;

end.

