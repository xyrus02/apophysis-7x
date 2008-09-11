{
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Boris, Peter Sdobnov

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
  StdCtrls, ComCtrls, Math, Buttons, Registry, ExtCtrls, MMSystem,
  ControlPoint, RenderThread, cmap, RenderTypes;

type
  TRenderForm = class(TForm)
    ProgressBar: TProgressBar;
    btnRender: TButton;
    btnCancel: TButton;
    SaveDialog: TSaveDialog;
    btnPause: TButton;
    chkSave: TCheckBox;
    StatusBar: TStatusBar;
    chkShutdown: TCheckBox;
    chkPostProcess: TCheckBox;
    chkSaveIncompleteRenders: TCheckBox;
    PageCtrl: TPageControl;
    TabSettings: TTabSheet;
    TabOutput: TTabSheet;
    GroupBox5: TGroupBox;
    btnSavePreset: TSpeedButton;
    btnDeletePreset: TSpeedButton;
    cmbPreset: TComboBox;
    GroupBox1: TGroupBox;
    btnBrowse: TSpeedButton;
    Label10: TLabel;
    txtFilename: TEdit;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    chkMaintain: TCheckBox;
    cbWidth: TComboBox;
    cbHeight: TComboBox;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    txtOversample: TEdit;
    txtFilterRadius: TEdit;
    udOversample: TUpDown;
    txtDensity: TComboBox;
    GroupBox4: TGroupBox;
    lblApproxMem: TLabel;
    lblPhysical: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblMaxbits: TLabel;
    Label9: TLabel;
    cbMaxMemory: TComboBox;
    chkLimitMem: TCheckBox;
    cbBitsPerSample: TComboBox;
    Output: TMemo;
    chkThreadPriority: TCheckBox;
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
    procedure chkSaveIncompleteRendersClick(Sender: TObject);
    procedure cbBitsPerSampleSelect(Sender: TObject);
    procedure chkThreadPriorityClick(Sender: TObject);
  private
    StartTime, EndTime, oldElapsed, edt: TDateTime;
    oldProg: double;

    ApproxSamples: int64;

    procedure DoPostProcess;

    procedure HandleThreadCompletion(var Message: TMessage);
      message WM_THREAD_COMPLETE;
    procedure HandleThreadTermination(var Message: TMessage);
      message WM_THREAD_TERMINATE;
    procedure ListPresets;
    function WindowsExit(RebootParam: Longword = EWX_POWEROFF or EWX_FORCE): Boolean;

  public
    Renderer: TRenderThread;
    PhysicalMemory, ApproxMemory, TotalPhysicalMemory: int64;
    ColorMap: TColorMap;
    cp: TControlPoint;
    Filename: string;
    ImageWidth, ImageHeight, Oversample: Integer;
    BitsPerSample: integer;
    zoom, Sample_Density, Brightness, Gamma, Vibrancy, Filter_Radius: double;
    center: array[0..1] of double;
    MaxMemory: integer;
    bRenderAll: boolean;

    procedure OnProgress(prog: double);
    procedure ShowMemoryStatus;
    procedure ResetControls;
  end;

var
  RenderForm: TRenderForm;
  Ratio: double;

implementation

uses
  Main, Global, SavePreset, formPostProcess, PngImage, ImageMaker,
  Tracer;

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
  cbBitsPerSample.Enabled := true;
  chkPostProcess.Enabled := not chkLimitMem.Checked;
  chkSaveIncompleteRenders.Enabled := not chkLimitMem.Checked;
  btnRender.Enabled := true;
  cmbPreset.enabled := true;
  chkSave.enabled := true;
  chkPostProcess.enabled := true;
  chkShutdown.enabled := true;
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
  TotalPhysicalMemory := GlobalMemoryInfo.dwTotalPhys div 1048576;
  TotalPhysicalMemory := TotalPhysicalMemory * 9 div 10; // assume that OS will take 10% of RAM ;)
  ApproxMemory := int64(ImageHeight) * int64(ImageWidth) * sqr(Oversample) * SizeOfBucket[BitsPerSample] div 1048576;

  lblPhysical.Caption := Format('%u', [PhysicalMemory]) + ' Mb';
  lblApproxMem.Caption := Format('%u', [ApproxMemory]) + ' Mb';

  if ApproxMemory > PhysicalMemory then lblPhysical.Font.Color := clRed
  else lblPhysical.Font.Color := clWindowText;


  if  ApproxMemory > 0 then
    lblMaxbits.caption := format('%2.3f', [8 + log2(
      sample_density * sqr(power(2, cp.zoom)) * int64(ImageHeight) * int64(ImageWidth) / sqr(oversample)
    )]);
end;

procedure Trace2(const str: string);
begin
  if TraceLevel >= 2 then
    RenderForm.Output.Lines.Add('. . ' + str);
end;

procedure TRenderForm.HandleThreadCompletion(var Message: TMessage);
var
  tryAgain: boolean;
begin
  Trace2(MsgComplete + IntToStr(message.LParam));
  if not assigned(Renderer) then begin
    Trace2(MsgNotAssigned);
    exit;
  end;
  if Renderer.ThreadID <> message.LParam then begin
    Trace2(MsgAnotherRunning);
    exit;
  end;

  EndTime := Now;

  repeat
    tryAgain := false;
    try
      Renderer.SaveImage(FileName);
    except
      on e: Exception do begin
        Output.Lines.Add(TimeToStr(Now) + ' : Error saving image!');
        tryAgain := (Application.MessageBox(PChar('An error occured while saving the image:' + #13#10 + e.Message +
          #13#10 + 'Check your free disk space and try again.'), 'Error', MB_RETRYCANCEL or MB_ICONERROR) = IDRETRY);
      end;
    end;
  until tryAgain = false;

  if PlaySoundOnRenderComplete then
    if RenderCompleteSoundFile <> '' then
      sndPlaySound(PChar(RenderCompleteSoundFile), SND_FILENAME or SND_NOSTOP or SND_ASYNC)
    else
      sndPlaySound(pchar(SND_ALIAS_SYSTEMASTERISK), SND_ALIAS_ID or SND_NOSTOP or SND_ASYNC);

  PageCtrl.TabIndex := 1;
  if ShowRenderStats then
    Renderer.ShowBigStats
  else
    Renderer.ShowSmallStats;
  Output.Lines.Add('  Total time:' + TimeToString(EndTime - StartTime));
  Output.Lines.Add('');

  if not chkLimitMem.Checked and chkPostProcess.checked then
    DoPostProcess;

  Renderer.Free;
  Renderer := nil;
  if not bRenderAll then ResetControls;
  if chkShutdown.Checked then
    WindowsExit;
end;

procedure TRenderForm.HandleThreadTermination(var Message: TMessage);
begin
  Trace2(MsgTerminated + IntToStr(message.LParam));
  if not assigned(Renderer) then begin
    Trace2(MsgNotAssigned);
    exit;
  end;
  if Renderer.ThreadID <> message.LParam then begin
    Trace2(MsgAnotherRunning);
    exit;
  end;

  Output.Lines.Add(TimeToStr(Now) + ' : Rendering terminated!');
  Output.Lines.Add('');
  sndPlaySound(pchar(SND_ALIAS_SYSTEMEXCLAMATION), SND_ALIAS_ID or SND_NOSTOP or SND_ASYNC);

  Renderer.Free;
  Renderer := nil;
  ResetControls;
end;

procedure TRenderForm.OnProgress(prog: double);
var
  Elapsed, Remaining, dt: TDateTime;
begin
  Elapsed := Now - StartTime;
  dt := Elapsed - oldElapsed;
  if (prog = 1.0) then begin
    StatusBar.Panels[0].text := Format('Elapsed %2.2d:%2.2d:%2.2d.%2.2d',
      [Trunc(Elapsed * 24),
       Trunc(Elapsed * 24 * 60) mod 60,
       Trunc(Elapsed * 24 * 60 * 60) mod 60,
       Trunc(Elapsed * 24 * 60 * 60 * 100) mod 100]);
    StatusBar.Panels[1].text := 'Remaining 00:00:00.00';
    exit;
  end;

  //if (dt < 1/24/60/60/10) then exit;
  if (dt < 1/24/60/60) then exit; // PB: too much time consuming... was every 1/10th seconds!
  oldElapsed := Elapsed;

  prog := (Renderer.Slice + Prog) / Renderer.NrSlices;
  if ShowProgress then ProgressBar.Position := round(100 * prog);

  StatusBar.Panels[0].text := Format('Elapsed %2.2d:%2.2d:%2.2d.%2.2d',
    [Trunc(Elapsed * 24),
     Trunc(Elapsed * 24 * 60) mod 60,
     Trunc(Elapsed * 24 * 60 * 60) mod 60,
     Trunc(Elapsed * 24 * 60 * 60 * 100) mod 100]);

  edt := edt + dt;
  if (edt > 1/24/60/60/2) and (prog > 0) then
  begin
    Remaining := (1 - prog) * edt / (prog - oldProg);
    edt := 0;
    oldProg := prog;

    StatusBar.Panels[1].text := Format('Remaining %2.2d:%2.2d:%2.2d.%2.2d',
      [Trunc(Remaining * 24),
       Trunc(Remaining * 24 * 60) mod 60,
       Trunc(Remaining * 24 * 60 * 60) mod 60,
       Trunc(Remaining * 24 * 60 * 60 * 100) mod 100]);
  end;
  StatusBar.Panels[2].text := 'Slice ' + IntToStr(Renderer.Slice + 1) + ' of ' + IntToStr(Renderer.nrSlices);
  Application.ProcessMessages;
end;

procedure TRenderForm.FormCreate(Sender: TObject);
begin
  cp := TControlPoint.Create;
  cbMaxMemory.ItemIndex := 1;
  cbBitsPerSample.ItemIndex := 0;
  BitsPerSample := 0;
  MainForm.Buttons.GetBitmap(2, btnSavePreset.Glyph);
  MainForm.Buttons.GetBitmap(9, btnDeletePreset.Glyph);
  bRenderAll := false;
  ListPresets;
end;

procedure TRenderForm.FormDestroy(Sender: TObject);
begin
  if assigned(Renderer) then begin
    Renderer.Terminate;
    Renderer.WaitFor;
    Renderer.Free;
  end;
  cp.free;
end;

procedure TRenderForm.btnRenderClick(Sender: TObject);
var
  t: string;
  iCurrFlame: integer;
  path, ext: string;
begin
  ImageWidth := StrToInt(cbWidth.text);
  ImageHeight := StrToInt(cbHeight.text);

  if not chkLimitMem.checked then begin
    if (ApproxMemory > {Total}PhysicalMemory) then
    begin
      Application.MessageBox('You do not have enough memory for this render. Please use memory limiting.', 'Apophysis', 48);
      exit;
    end;
{
    if (ApproxMemory > PhysicalMemory) then
    begin
      if Application.MessageBox('There is not enough memory for this render. ' + #13 +
                                'You can use memory limiting, or - if you are sure that your system *should* ' + #13 +
                                'have the required amount of free RAM, you can try to allocate memory anyway. ' + #13#13 +
                                'Dou you want to try? (SLOW AND UNSTABLE - USE AT YOUR OWN RISK!!!)', 'Apophysis',
        MB_ICONWARNING or MB_YESNO) <> IDYES then exit;
    end;
}
  end
  else if (PhysicalMemory < StrToInt(cbMaxMemory.text)) and (Approxmemory > PhysicalMemory) then begin
    Application.MessageBox('You do not have enough memory for this render. Please use a lower Maximum memory setting.', 'Apophysis', 48);
    exit;
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
  if chkLimitMem.checked then
  begin
    MaxMemory := StrToIntDef(cbMaxMemory.text, 0);
    if MaxMemory * 1024*1024 < ImageWidth * (int64(ImageHeight) * 4 + oversample) then begin
      Application.MessageBox('Invalid maximum memory value', 'Apophysis', 16);
      exit;
    end;
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
  cbBitsPerSample.Enabled := false;
  cmbPreset.enabled := false;
  chkSave.enabled := false;
//  chkPostProcess.enabled := false;
//  chkShutdown.enabled := false;
  btnSavePreset.enabled := false;
  btnDeletePreset.enabled := false;
  btnRender.Enabled := false;
  btnPause.enabled := true;
  btnCancel.Caption := 'Stop';
  StartTime := Now;

  PageCtrl.TabIndex := 1;

  if Output.Lines.Count >= 1000 then Output.Lines.Clear;

  if bRenderAll then
  begin
    path := ExtractFilePath(FileName);
    ext := ExtractFileExt(FileName);

    if Assigned(Renderer) then begin
      Output.Lines.Add(TimeToStr(Now) + 'Shutting down previous render...');
      Renderer.Terminate;
      Renderer.WaitFor;
      Renderer.Free;
      Renderer := nil;
    end;

    for iCurrFlame := 0 to MainForm.ListView.Items.Count-1 do
    begin
      MainForm.ListView.ItemIndex := iCurrFlame;
      cp.Free;
      cp := TControlPoint.Create;
      cp.Copy(MainCP);
      cp.cmap := maincp.cmap;
      zoom := maincp.zoom;
      Center[0] := MainForm.center[0];
      Center[1] := MainForm.center[1];
      FileName := path + cp.name + ext;
      Output.Lines.Add('--- Rendering "' + ExtractFileName(FileName) + '" ---');
      Output.Lines.Add(Format('  Size: %dx%d', [ImageWidth, ImageHeight]));
      Output.Lines.Add(Format('  Quality: %g', [sample_density]));
      Output.Lines.Add(Format('  Oversample: %d, Filter: %g', [oversample, filter_radius]));
      Output.Lines.Add(Format('  Buffer depth: %s', [cbBitsPerSample.Items[BitsPerSample]]));
      if chkLimitMem.checked then
        Output.Lines.Add(Format('  Memory limit: %d Mb', [MaxMemory]))
      else
        if (UpperCase(ExtractFileExt(FileName)) = '.PNG') and
           (ImageWidth * ImageHeight >= 20000000) then
        begin
          Output.Lines.Add('*** WARNING *** Using PNG format with extreme high-resolution images is not recommended!');
          Output.Lines.Add('To avoid slowdown (and possible memory problems) use BMP file format instead.');
        end;

      if not Assigned(Renderer) then
      begin
        // disable screensaver
        SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, 0, nil, 0);

        cp.sample_density := Sample_density;
        cp.spatial_oversample := Oversample;
        cp.spatial_filter_radius := Filter_Radius;
        cp.AdjustScale(ImageWidth, ImageHeight);
        cp.Transparency := (PNGTransparency <> 0) and (UpperCase(ExtractFileExt(FileName)) = '.PNG');
        renderPath := ExtractFilePath(Filename);
        if chkSave.checked then
          MainForm.SaveXMLFlame(cp, ExtractFileName(FileName), renderPath + 'renders.flame');

        oldProg:=0;
        oldElapsed:=0;
        edt:=0;
        ApproxSamples := Round(sample_density * sqr(power(2, cp.zoom)) * int64(ImageHeight) * int64(ImageWidth) / sqr(oversample) );

       try

        if not bRenderAll then exit;
        if iCurrFlame = MainForm.ListView.Items.Count-1 then bRenderAll := false;

        Renderer := TRenderThread.Create;
        assert(Renderer <> nil);

        if chkThreadPriority.Checked then
          Renderer.SetPriority(tpLower)
        else
          Renderer.SetPriority(tpNormal);

        Renderer.BitsPerSample := BitsPerSample;
        if chkLimitMem.checked then
          Renderer.MaxMem := MaxMemory;//StrToInt(cbMaxMemory.text);
        Renderer.OnProgress := OnProgress;
        Renderer.TargetHandle := self.Handle;
        Renderer.SetCP(cp);
        //Renderer.Priority := tpLower;
        Renderer.NrThreads := NrTreads;
        Renderer.Output := Output.Lines;
        Renderer.Resume;
        if bRenderAll then Renderer.WaitFor;
        while Renderer <> nil do Application.ProcessMessages; // wait for HandleThreadCompletion

       except
        Output.Lines.Add(TimeToStr(Now) + ' : Rendering failed!');
        //Application.MessageBox('Error while rendering!', 'Apophysis', 48);
       end;
      end;
    end;
  end else
  begin
    Output.Lines.Add('--- Rendering "' + ExtractFileName(FileName) + '" ---');
    Output.Lines.Add(Format('  Size: %dx%d', [ImageWidth, ImageHeight]));
    Output.Lines.Add(Format('  Quality: %g', [sample_density]));
    Output.Lines.Add(Format('  Oversample: %d, Filter: %g', [oversample, filter_radius]));
    Output.Lines.Add(Format('  Buffer depth: %s', [cbBitsPerSample.Items[BitsPerSample]]));
    if chkLimitMem.checked then
      Output.Lines.Add(Format('  Memory limit: %d Mb', [MaxMemory]))
    else
      if (UpperCase(ExtractFileExt(FileName)) = '.PNG') and
         (ImageWidth * ImageHeight >= 20000000) then
      begin
        Output.Lines.Add('*** WARNING *** Using PNG format with extreme high-resolution images is not recommended!');
        Output.Lines.Add('To avoid slowdown (and possible memory problems) use BMP file format instead.');
      end;

    if Assigned(Renderer) then begin
      Output.Lines.Add(TimeToStr(Now) + 'Shutting down previous render...');
      Renderer.Terminate;
      Renderer.WaitFor;
      Renderer.Free;
      Renderer := nil;
    end;

    if not Assigned(Renderer) then
    begin
      // disable screensaver
      SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, 0, nil, 0);

      cp.sample_density := Sample_density;
      cp.spatial_oversample := Oversample;
      cp.spatial_filter_radius := Filter_Radius;
      cp.AdjustScale(ImageWidth, ImageHeight);
      cp.Transparency := (PNGTransparency <> 0) and (UpperCase(ExtractFileExt(FileName)) = '.PNG');
      renderPath := ExtractFilePath(Filename);
      if chkSave.checked then
        MainForm.SaveXMLFlame(cp, ExtractFileName(FileName), renderPath + 'renders.flame');

      oldProg:=0;
      oldElapsed:=0;
      edt:=0;
      ApproxSamples := Round(sample_density * sqr(power(2, cp.zoom)) * int64(ImageHeight) * int64(ImageWidth) / sqr(oversample) );

     try

      Renderer := TRenderThread.Create;
      assert(Renderer <> nil);

      if chkThreadPriority.Checked then
        Renderer.SetPriority(tpLower)
      else
        Renderer.SetPriority(tpNormal);

      Renderer.BitsPerSample := BitsPerSample;
      if chkLimitMem.checked then
        Renderer.MaxMem := MaxMemory;//StrToInt(cbMaxMemory.text);
      Renderer.OnProgress := OnProgress;
      Renderer.TargetHandle := self.Handle;
  //    Renderer.Output := Output.Lines;
  //    Renderer.Compatibility := compatibility;
      Renderer.SetCP(cp);
      //Renderer.Priority := tpLower;
      Renderer.NrThreads := NrTreads;

      Renderer.Output := Output.Lines;
      Renderer.Resume;

     except
      Output.Lines.Add(TimeToStr(Now) + ' : Rendering failed!');
      Application.MessageBox('Error while rendering!', 'Apophysis', 48);
     end;
    end;
  end;
  // enable screensaver
  SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, 1, nil, 0);
end;

procedure TRenderForm.FormShow(Sender: TObject);
var
  Registry: TRegistry;
begin
  { Read position from registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('Software\' + APP_NAME + '\Forms\Render', False) then
    begin
      if Registry.ValueExists('Left') then
        self.Left := Registry.ReadInteger('Left');
      if Registry.ValueExists('Top') then
        self.Top := Registry.ReadInteger('Top');
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
  cbWidth.Text := IntToStr(cp.Width);
  cbHeight.Text := IntToStr(cp.Height);
  ImageWidth := StrToInt(cbWidth.Text);
  ImageHeight := StrToInt(cbHeight.Text);
  sample_density := renderDensity;
  txtDensity.Text := FloatToStr(sample_density);
  BitsPerSample := renderBitsPerSample;
  cbBitsPerSample.ItemIndex := BitsPerSample;
  ShowMemoryStatus;
  Ratio := ImageWidth / ImageHeight;
  chkSaveIncompleteRenders.Checked := SaveIncompleteRenders;
  chkThreadPriority.Checked := LowerRenderPriority;
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
var
  o: integer;
begin
  try
    o := StrToInt(txtOversample.Text);
  except
    txtOversample.Text := IntToStr(Oversample);
    exit;
  end;
  if o > udOversample.Max then
  begin
    o := udOversample.Max;
    txtOversample.Text := IntToStr(o);
  end
  else if o < udOversample.Min then
  begin
    o := udOversample.Min;
    txtOversample.Text := IntToStr(o);
  end;
  Oversample := o;
  ShowMemoryStatus;
end;

procedure TRenderForm.chkLimitMemClick(Sender: TObject);
var
  mm: boolean;
begin
  mm := chkLimitMem.Checked;
  cbMaxMemory.enabled := mm;
  chkPostProcess.Enabled := not mm;
  chkSaveIncompleteRenders.Enabled := not mm;
end;

procedure TRenderForm.txtFilenameChange(Sender: TObject);
begin
  filename := txtFilename.text;
end;

procedure TRenderForm.btnCancelClick(Sender: TObject);
begin
  if Assigned(Renderer) or bRenderAll then
  begin
    if Assigned(Renderer) then
      if Renderer.Suspended then begin
        Renderer.Resume;
        btnPause.caption := 'Pause';
      end;

    if ConfirmStopRender then begin
      if Application.MessageBox('Do you want to stop the current render?', 'Apophysis', 36) = ID_NO then exit;
    end;

    bRenderAll := false;
    if Assigned(Renderer) then
      if SaveIncompleteRenders and not ChkLimitMem.Checked then
      begin
        Renderer.BreakRender;
        Renderer.WaitFor; //?
      end else
      begin
        Renderer.Terminate;
        Renderer.WaitFor; //?
        PageCtrl.TabIndex := 0;
      end;
  end else
    Close;
end;

procedure TRenderForm.txtDensityChange(Sender: TObject);
var
  t: double;
begin
  if TryStrToFloat(txtDensity.Text, t) then
    Sample_Density := t;
  if Sample_Density > 0 then ShowMemoryStatus;
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
  renderBitsPerSample := BitsPerSample;
  { Write position to registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('\Software\' + APP_NAME + '\Forms\Render', True) then
    begin
      Registry.WriteInteger('Top', Top);
      Registry.WriteInteger('Left', Left);
    end;
  finally
    Registry.Free;
  end;
end;

procedure TRenderForm.btnPauseClick(Sender: TObject);
begin
  if Assigned(Renderer) then
    if Renderer.Suspended = false then begin
      renderer.Suspend;
      btnPause.caption := 'Resume';
    end else begin
      renderer.Resume;
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
      if Assigned(Renderer) then begin
        Renderer.Terminate;
        Renderer.WaitFor;
      end;
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
  f: textfile;
begin
  FStrings := TStringList.Create;
  try
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
  Sample_Density := StrToFloat(txtDensity.Text);
  ShowMemoryStatus;
end;

procedure TRenderForm.chkMaintainClick(Sender: TObject);
begin
  Ratio := ImageWidth / ImageHeight;
end;

procedure TRenderForm.DoPostProcess;
begin
  frmPostProcess.SetRenderer(Renderer.GetRenderer);
  frmPostProcess.SetControlPoint(CP);
  frmPostProcess.SetImageName(FileName);
  frmPostProcess.Show;
end;

function TRenderForm.WindowsExit(RebootParam: Longword = EWX_POWEROFF or EWX_FORCE): Boolean;
var
   TTokenHd: THandle;
   TTokenPvg: TTokenPrivileges;
   cbtpPrevious: DWORD;
   rTTokenPvg: TTokenPrivileges;
   pcbtpPreviousRequired: DWORD;
   tpResult: Boolean;
const
   SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
  if ((GetWinVersion = wvWinNT) or
      (GetWinVersion = wvWin2000) or
      (GetWinVersion = wvWinXP)) then
  begin
    tpResult := OpenProcessToken(GetCurrentProcess(),
      TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,
      TTokenHd);
    if tpResult then
    begin
      tpResult := LookupPrivilegeValue(nil,
                                       SE_SHUTDOWN_NAME,
                                       TTokenPvg.Privileges[0].Luid);
      TTokenPvg.PrivilegeCount := 1;
      TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      cbtpPrevious := SizeOf(rTTokenPvg);
      pcbtpPreviousRequired := 0;
      if tpResult then
        Windows.AdjustTokenPrivileges(TTokenHd,
                                      False,
                                      TTokenPvg,
                                      cbtpPrevious,
                                      rTTokenPvg,
                                      pcbtpPreviousRequired);
    end;
  end;
  Result := ExitWindowsEx(RebootParam, 0);
end;

procedure TRenderForm.chkSaveIncompleteRendersClick(Sender: TObject);
begin
  SaveIncompleteRenders := chkSaveIncompleteRenders.Checked;
end;

procedure TRenderForm.cbBitsPerSampleSelect(Sender: TObject);
begin
  BitsPerSample := cbBitsPerSample.ItemIndex;

  ShowMemoryStatus;
end;

procedure TRenderForm.chkThreadPriorityClick(Sender: TObject);
begin
  LowerRenderPriority := chkThreadPriority.Checked;

  if Assigned(Renderer) then begin
    if LowerRenderPriority then
      Renderer.SetPriority(tpLower)
    else
      Renderer.SetPriority(tpNormal);
  end;
end;

end.

