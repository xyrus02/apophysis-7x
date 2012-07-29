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
unit Settings;

interface

uses graphics, Messages, Translation;

function ReadPluginDir: string;
procedure ReadSettings;
procedure SaveSettings;

implementation

uses Windows, Classes, SysUtils, StrUtils, Forms, Registry, Global, Dialogs, XFormMan;

(*
procedure UnpackVariations(v: int64);
{ Unpacks the variation options form an integer }
var
  i: integer;
begin
  for i := 0 to NRVAR - 1 do
    Variations[i] := boolean(v shr i and 1);
end;
*)

function ReadPluginDir: string;
var
  settingFileName: string;
  sl : TStringList;
begin
  sl := TStringList.Create;

  settingFileName := ExtractFilePath(Application.ExeName) + 'ApoPluginSrc.dat';
  if FileExists(settingFileName) then
    sl.LoadFromFile(settingFileName)
  else begin
    settingFileName := GetEnvVarValue('APPDATA') + '\ApoPluginSrc.dat';

    if FileExists(settingFileName) then
      sl.LoadFromFile(settingFileName)
    else
      sl.Text := ExtractFilePath(Application.ExeName) + 'Plugins\';
  end;

  if Trim(sl.Text) = '' then
    sl.Text := ExtractFilePath(Application.ExeName) + 'Plugins\';

  Result := Trim(sl.Text);
  if (RightStr(Result, 1) <> '\') and (Result <> '') then
    Result := Result + '\';

  sl.Destroy;
end;

procedure SavePluginDir(data: string);
var
  settingFileName: string;
  sl : TStringList;
begin
  settingFileName := ExtractFilePath(Application.ExeName) + 'ApoPluginSrc.dat';
  sl := TStringList.Create;
  sl.Text := PluginPath;

  try
    sl.SaveToFile(settingFileName);
    sl.Destroy;
  except
    // not elevated?
    settingFileName := GetEnvVarValue('APPDATA') + '\ApoPluginSrc.dat';
    try
      sl.SaveToFile(settingFileName);
    except
      MessageBox(0, PCHAR(TextByKey('main-status-pluginpath-ioerror')),
        PCHAR('Apophysis'), MB_ICONWARNING);
    end;
    sl.Destroy;
  end;
end;

procedure ReadSettings;
var
  Registry: TRegistry;
  DefaultPath: string;
  i, maxVars: integer;
  VariationOptions: int64;
begin
  DefaultPath := GetEnvVarValue('USERPROFILE');///ExtractFilePath(Application.Exename);
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    { Defaults }
    if Registry.OpenKey('Software\' + APP_NAME + '\Defaults', False) then
    begin
      if Registry.ValueExists('DefaultFlameFile3D') then
      begin
        defFlameFile := Registry.ReadString('DefaultFlameFile3D');
      end
      else begin
        if Registry.ValueExists('DefaultFlameFile') then
          defFlameFile := Registry.ReadString('DefaultFlameFile')
        else
          defFlameFile := '';
      end;

      if Registry.ValueExists('AlwaysCreateBlankFlame') then
      begin
        AlwaysCreateBlankFlame := Registry.ReadBool('AlwaysCreateBlankFlame');
      end
      else
      begin
        AlwaysCreateBlankFlame := false;
      end;

      if Registry.ValueExists('GradientFile') then
      begin
        GradientFile := Registry.ReadString('GradientFile');
      end
      else
      begin
        GradientFile := ''
      end;

      if Registry.ValueExists('SavePath3D') then
      begin
        SavePath := Registry.ReadString('SavePath3D');
      end
      else begin
        if Registry.ValueExists('SavePath') then
          SavePath := Registry.ReadString('SavePath')
        else
          SavePath := DefaultPath + '\Flames.flame';
      end;

      if Registry.ValueExists('EmbedThumbnails') then
      begin
        EmbedThumbnails := Registry.ReadBool('EmbedThumbnails');
      end
      else EmbedThumbnails := false;

      if Registry.ValueExists('WarnOnMissingPlugin') then
      begin
        WarnOnMissingPlugin := Registry.ReadBool('WarnOnMissingPlugin');
      end
      else WarnOnMissingPlugin := true;
      if Registry.ValueExists('LanguageFile') then
      begin
        LanguageFile := Registry.ReadString('LanguageFile');
      end
      else LanguageFile := '';

      if Registry.ValueExists('SmoothPaletteFile') then
      begin
        defSmoothPaletteFile := Registry.ReadString('SmoothPaletteFIle');
      end
      else
      begin
        defSmoothPaletteFile := DefaultPath + '\SmoothPalette.ugr';
      end;

      if Registry.ValueExists('PlaySoundOnRenderComplete') then
        PlaySoundOnRenderComplete := Registry.ReadBool('PlaySoundOnRenderComplete')
      else
        PlaySoundOnRenderComplete := false;
      if Registry.ValueExists('RenderCompleteSoundFile') then
        RenderCompleteSoundFile := Registry.ReadString('RenderCompleteSoundFile')
      else
        RenderCompleteSoundFile := '';

      if Registry.ValueExists('ConfirmDelete') then
        ConfirmDelete := Registry.ReadBool('ConfirmDelete')
      else
        ConfirmDelete := True;
      if Registry.ValueExists('OldPaletteFormat') then
        OldPaletteFormat := Registry.ReadBool('OldPaletteFormat')
      else
        OldPaletteFormat := false;
      if Registry.ValueExists('ConfirmExit') then
        ConfirmExit := Registry.ReadBool('ConfirmExit')
      else
        ConfirmExit := True;

      if Registry.ValueExists('PreserveQuality') then
      begin
        PreserveQuality := Registry.ReadBool('PreserveQuality');
      end
      else
      begin
        PreserveQuality := true;
      end;

      if Registry.ValueExists('KeepBackground') then
      begin
        KeepBackground := Registry.ReadBool('KeepBackground');
      end
      else
      begin
        KeepBackground := False;
      end;
      if Registry.ValueExists('NumTries') then
      begin
        NumTries := Registry.ReadInteger('NumTries');
      end
      else
      begin
        NumTries := 10;
      end;
      if Registry.ValueExists('TryLength') then
      begin
        TryLength := Registry.ReadInteger('TryLength');
      end
      else
      begin
        TryLength := 100000;
      end;

      if Registry.ValueExists('MinTransforms') then
      begin
        randMinTransforms := Registry.ReadInteger('MinTransforms');
        if randMinTransforms <= 0 then randMinTransforms := 2;
      end
      else
      begin
        randMinTransforms := 2;
      end;
      if Registry.ValueExists('MaxTransforms') then
      begin
        randMaxTransforms := Registry.ReadInteger('MaxTransforms');
        if randMaxTransforms < randMinTransforms then randMaxTransforms := randMinTransforms;
      end
      else
      begin
        randMaxTransforms := randMinTransforms + 1;
      end;

      if Registry.ValueExists('MutationMinTransforms') then
      begin
        mutantMinTransforms := Registry.ReadInteger('MutationMinTransforms');
        if mutantMinTransforms <= 0 then mutantMinTransforms := 2;
      end
      else
      begin
        mutantMinTransforms := 2;
      end;
      if Registry.ValueExists('MutationMaxTransforms') then
      begin
        mutantMaxTransforms := Registry.ReadInteger('MutationMaxTransforms');
        if mutantMaxTransforms < mutantMinTransforms then mutantMinTransforms := mutantMinTransforms;
      end
      else
      begin
        mutantMaxTransforms := mutantMinTransforms + 1;
      end;

      if Registry.ValueExists('RandomGradient') then
      begin
        randGradient := Registry.ReadInteger('RandomGradient');
      end
      else
      begin
        randGradient := 0;
      end;

      if Registry.ValueExists('ParameterFolder3D') then
      begin
        ParamFolder := Registry.ReadString('ParameterFolder3D');
      end
      else
      if Registry.ValueExists('ParameterFolder') then
      begin
        ParamFolder := Registry.ReadString('ParameterFolder');
      end
      else
      begin
        ParamFolder := DefaultPath + '\';
      end;

      if Registry.ValueExists('UPRPath') then
      begin
        UPRPath := Registry.ReadString('UPRPath');
      end
      else
      begin
        UPRPath := DefaultPath + '\';
      end;

      if Registry.ValueExists('ImageFolder') then
      begin
        ImageFolder := Registry.ReadString('ImageFolder');
      end
      else
      begin
        ImageFolder := DefaultPath + '\';
      end;

      if Registry.ValueExists('UPRWidth') then
      begin
        UPRWidth := Registry.ReadInteger('UPRWidth');
      end
      else
      begin
        UPRWidth := 640;
      end;
      if Registry.ValueExists('UPRHeight') then
      begin
        UPRHeight := Registry.ReadInteger('UPRHeight');
      end
      else
      begin
        UPRHeight := 480;
      end;

      if Registry.ValueExists('BrowserPath') then
      begin
        BrowserPath := Registry.ReadString('BrowserPath');
      end
      else
      begin
        BrowserPath := DefaultPath + '\';
      end;
      if Registry.ValueExists('EditPreviewQaulity') then
      begin
        EditPrevQual := Registry.ReadInteger('EditPreviewQaulity');
      end
      else
      begin
        EditPrevQual := 1;
      end;
      if Registry.ValueExists('MutatePreviewQaulity') then
      begin
        MutatePrevQual := Registry.ReadInteger('MutatePreviewQaulity');
        if MutatePrevQual <= 0 then MutatePrevQual := 1;
      end
      else
      begin
        MutatePrevQual := 1;
      end;
      if Registry.ValueExists('AdjustPreviewQaulity') then
      begin
        AdjustPrevQual := Registry.ReadInteger('AdjustPreviewQaulity');
        if AdjustPrevQual <= 0 then AdjustPrevQual := 1;
      end
      else
      begin
        AdjustPrevQual := 1;
      end;
      if Registry.ValueExists('RandomPrefix') then
      begin
        RandomPrefix := Registry.ReadString('RandomPrefix');
      end
      else
      begin
        RandomPrefix := 'Apo3D-'
      end;
      if Registry.ValueExists('RandomDate') then
      begin
        RandomDate := Registry.ReadString('RandomDate');
      end
      else
      begin
        RandomDate := ''
      end;
      if Registry.ValueExists('RandomIndex') then
      begin
        RandomIndex := Registry.ReadInteger('RandomIndex');
      end
      else
      begin
        RandomIndex := 0;
      end;
      if Registry.ValueExists('SymmetryType') then
      begin
        SymmetryType := Registry.ReadInteger('SymmetryType');
      end
      else
      begin
        SymmetryType := 0;
      end;
      if Registry.ValueExists('SymmetryOrder') then
      begin
        SymmetryOrder := Registry.ReadInteger('SymmetryOrder');
      end
      else
      begin
        SymmetryOrder := 4;
      end;
      if Registry.ValueExists('SymmetryNVars') then
      begin
        SymmetryNVars := Registry.ReadInteger('SymmetryNVars');
      end
      else
      begin
        SymmetryNVars := 12;
      end;

      if Registry.ValueExists('VariationOptions') then
      begin
        VariationOptions := Registry.ReadInteger('VariationOptions');
      end
      else
      begin
        VariationOptions := 262143;
      end;
      if Registry.ValueExists('VariationOptions2') then
      begin
        VariationOptions := VariationOptions or (int64(Registry.ReadInteger('VariationOptions2')) shl 32);
      end;
//      UnpackVariations(VariationOptions);

      if Registry.ValueExists('MinNodes') then
      begin
        MinNodes := Registry.ReadInteger('MinNodes');
        if MinNodes < 2 then MinNodes := 2;
      end
      else
      begin
        MinNodes := 2;
      end;
      if Registry.ValueExists('MinHue') then
      begin
        MinHue := Registry.ReadInteger('MinHue');
      end
      else
      begin
        MinHue := 0;
      end;
      if Registry.ValueExists('MinSat') then
      begin
        MinSat := Registry.ReadInteger('MinSat');
      end
      else
      begin
        MinSat := 0;
      end;
      if Registry.ValueExists('MinLum') then
      begin
        MinLum := Registry.ReadInteger('MinLum');
      end
      else
      begin
        MinLum := 0;
      end;
      if Registry.ValueExists('MaxNodes') then
      begin
        MaxNodes := Registry.ReadInteger('MaxNodes');
        if MaxNodes < MinNodes then MaxNodes := MinNodes;
      end
      else
      begin
        MaxNodes := 10;
      end;
      if Registry.ValueExists('MaxHue') then
      begin
        MaxHue := Registry.ReadInteger('MaxHue');
        if MaxHue < 0 then MaxHue := 0;
      end
      else
      begin
        MaxHue := 600;
      end;
      if Registry.ValueExists('MaxSat') then
      begin
        MaxSat := Registry.ReadInteger('MaxSat');
        if MaxSat < 0 then MaxSat := 0;
      end
      else
      begin
        MaxSat := 100;
      end;
      if Registry.ValueExists('RandomGradientFile') then
      begin
        randGradientFile := Registry.ReadString('RandomGradientFile');
      end
      else
      begin
        randGradientFile := ''
      end;

//      if Registry.ValueExists('ReferenceMode') then
//        ReferenceMode := Registry.ReadInteger('ReferenceMode')
//      else ReferenceMode := 0;

      if Registry.ValueExists('RotationMode') then
        MainForm_RotationMode := Registry.ReadInteger('RotationMode')
      else MainForm_RotationMode := 0;

      if Registry.ValueExists('MaxLum') then
      begin
        MaxLum := Registry.ReadInteger('MaxLum');
        if MaxLum <= 0 then MaxLum := 100;
      end
      else
      begin
        MaxLum := 100;
      end;
      if Registry.ValueExists('BatchSize') then
      begin
        BatchSize := Registry.ReadInteger('BatchSize');
        if BatchSize <= 0 then BatchSize := 10;
      end
      else
      begin
        BatchSize := 100;
      end;
      if Registry.ValueExists('ScriptPath') then
      begin
        ScriptPath := Registry.ReadString('ScriptPath');
      end
      else
      begin
        ScriptPath := DefaultPath + '\Scripts\';
      end;
      if Registry.ValueExists('FunctionLibrary') then
      begin
        defLibrary := Registry.ReadString('FunctionLibrary');
      end
      else
      begin
        defLibrary := ExtractFilePath(Application.ExeName) + 'Functions.asc';
      end;
      if Registry.ValueExists('ExportFileFormat') then
      begin
        ExportFileFormat := Registry.ReadInteger('ExportFileFormat');
      end
      else
      begin
        ExportFileFormat := 1;
      end;
      if Registry.ValueExists('ExportWidth') then
      begin
        ExportWidth := Registry.ReadInteger('ExportWidth');
        if ExportWidth <= 0 then ExportWidth := 640;
      end
      else
      begin
        ExportWidth := 640;
      end;
      if Registry.ValueExists('ExportHeight') then
      begin
        ExportHeight := Registry.ReadInteger('ExportHeight');
        if ExportHeight <= 0 then ExportHeight := 480;
      end
      else
      begin
        ExportHeight := 480;
      end;
      if Registry.ValueExists('ExportDensity') then
      begin
        ExportDensity := Registry.ReadFloat('ExportDensity');
        if ExportDensity <= 0 then ExportDensity := 100;
      end
      else
      begin
        ExportDensity := 100;
      end;
      if Registry.ValueExists('ExportOversample') then
      begin
        ExportOversample := Registry.ReadInteger('ExportOversample');
        if ExportOversample <= 0 then ExportOversample := 2;
      end
      else
      begin
        ExportOversample := 2;
      end;
      if Registry.ValueExists('ExportFilter') then
      begin
        ExportFilter := Registry.ReadFloat('ExportFilter');
        if ExportFilter <= 0 then ExportFilter := 0.6;
      end
      else
      begin
        ExportFilter := 0.6;
      end;
      if Registry.ValueExists('ExportBatches') then
      begin
        ExportBatches := Registry.ReadInteger('ExportBatches');
        if ExportBatches <= 0 then ExportBatches := 3;
      end
      else
      begin
        ExportBatches := 3;
      end;
      if Registry.ValueExists('Nick') then
      begin
        SheepNick := Registry.ReadString('Nick');
      end
      else
      begin
        SheepNick := '';
      end;
      if Registry.ValueExists('URL') then
      begin
        SheepURL := Registry.ReadString('URL');
      end
      else
      begin
        SheepURL := '';
      end;
      if Registry.ValueExists('Pass') then
      begin
        SheepPW := Registry.ReadString('Pass');
      end
      else
      begin
        SheepPW := '';
      end;
      if Registry.ValueExists('Renderer') then
      begin
        flam3Path := Registry.ReadString('Renderer');
      end
      else
      begin
        flam3Path := ExtractFilePath(Application.ExeName) + 'flam3.exe';
      end;
      if Registry.ValueExists('Server') then
      begin
        SheepServer := Registry.ReadString('Server');
      end
      else
      begin
        SheepServer := 'http://v2d5.sheepserver.net/';
      end;
      if Registry.ValueExists('ShowProgress') then
      begin
        ShowProgress := Registry.ReadBool('ShowProgress');
      end else begin
        ShowProgress := true;
      end;
      if Registry.ValueExists('ToolBarWidth1') then
      begin
        TBWidth1 := Registry.ReadInteger('ToolBarWidth1');
      end else begin
        TBWidth1 := 0;
      end;
      if Registry.ValueExists('ToolBarWidth2') then
      begin
        TBWidth2 := Registry.ReadInteger('ToolBarWidth2');
      end else begin
        TBWidth2 := 0;
      end;
      if Registry.ValueExists('ToolBarWidth3') then
      begin
        TBWidth3 := Registry.ReadInteger('ToolBarWidth3');
      end else begin
        TBWidth3 := 0;
      end;
      if Registry.ValueExists('ToolBarWidth4') then
      begin
        TBWidth4 := Registry.ReadInteger('ToolBarWidth4');
      end else begin
        TBWidth4 := 0;
      end;
      if Registry.ValueExists('ToolBarWidth5') then
      begin
        TBWidth5 := Registry.ReadInteger('ToolBarWidth5');
      end else begin
        TBWidth5 := 0;
      end;

      if Registry.ValueExists('LineCenterColor') then
      begin
        LineCenterColor := Registry.ReadInteger('LineCenterColor');
      end else begin
        LineCenterColor := $FFFFFF;
      end;
      if Registry.ValueExists('LineThirdsColor') then
      begin
        LineThirdsColor := Registry.ReadInteger('LineThirdsColor');
      end else begin
        LineThirdsColor := $0000FF;
      end;
      if Registry.ValueExists('LineGRColor') then
      begin
        LineGRColor := Registry.ReadInteger('LineGRColor');
      end else begin
        LineGRColor := $00FF00;
      end;
      if Registry.ValueExists('EnableGuides') then
      begin
        EnableGuides := Registry.ReadBool('EnableGuides');
      end else begin
        EnableGuides := false;
      end;

      { FormRender }
      if Registry.ValueExists('SaveIncompleteRenders') then begin
        SaveIncompleteRenders := Registry.ReadBool('SaveIncompleteRenders');
      end else begin
        SaveIncompleteRenders := false;
      end;
      if Registry.ValueExists('ShowRenderStats') then begin
        ShowRenderStats := Registry.ReadBool('ShowRenderStats');
      end else begin
        ShowRenderStats := false;
      end;
      if Registry.ValueExists('LowerRenderPriority') then begin
        LowerRenderPriority := Registry.ReadBool('LowerRenderPriority');
      end else begin
        LowerRenderPriority := false;
      end;

      if Registry.ValueExists('PNGTransparency') then begin
        PNGTransparency := Registry.ReadInteger('PNGTransparency');

      if PNGTransparency > 1 then PNGTransparency := 1; // tmp

      end else begin
        PNGTransparency := 1
      end;
      if Registry.ValueExists('ShowTransparency') then begin
        ShowTransparency := Registry.ReadBool('ShowTransparency');
      end else begin
        ShowTransparency := False;
      end;
      if Registry.ValueExists('ExtendMainPreview') then begin
        ExtendMainPreview := Registry.ReadBool('ExtendMainPreview');
      end else begin
        ExtendMainPreview := true;
      end;
      if Registry.ValueExists('MainPreviewScale') then begin
        MainPreviewScale := Registry.ReadFloat('MainPreviewScale');
        if MainPreviewScale < 1 then MainPreviewScale := 1
        else if MainPreviewScale > 3 then MainPreviewScale := 3;
      end else begin
        MainPreviewScale := 1.2;
      end;

      if Registry.ValueExists('NrTreads') then begin
        NrTreads := Registry.ReadInteger('NrTreads');
        if NrTreads <= 0 then NrTreads := 1;
      end else begin
        NrTreads := 1;
      end;
      if Registry.ValueExists('UseNrThreads') then begin
        UseNrThreads := Registry.ReadInteger('UseNrThreads');
        if UseNrThreads <= 0 then UseNrThreads := 1;
      end else begin
        UseNrThreads := 1;
      end;

      if Registry.ValueExists('InternalBitsPerSample') then begin
        InternalBitsPerSample := Registry.ReadInteger('InternalBitsPerSample');
      end else begin
        InternalBitsPerSample := 0;
      end;

      if Registry.ValueExists('AutoOpenLog') then begin
        AutoOpenLog := Registry.ReadBool('AutoOpenLog');
      end else begin
        AutoOpenLog := false;
      end;

      if Registry.ValueExists('StartupCheckForUpdates') then begin
        StartupCheckForUpdates := Registry.ReadBool('StartupCheckForUpdates');
      end else begin
        StartupCheckForUpdates := true;
      end;

      if Registry.ValueExists('ClassicListMode') then begin
        ClassicListMode := Registry.ReadBool('ClassicListMode');
      end else begin
        ClassicListMode := true;
      end;

      if Registry.ValueExists('LastOpenFile') then begin
        LastOpenFile := Registry.ReadString('LastOpenFile');
      end else begin
        LastOpenFile := '';
      end;

      if Registry.ValueExists('LastOpenFileEntry') then begin
        LastOpenFileEntry := Registry.ReadInteger('LastOpenFileEntry');
      end else begin
        LastOpenFileEntry := 1;
      end;

      if Registry.ValueExists('RememberLastOpenFile') then begin
        RememberLastOpenFile := Registry.ReadBool('RememberLastOpenFile');
      end else begin
        RememberLastOpenFile := false;
      end;

      if Registry.ValueExists('UseSmallThumbnails') then begin
        UseSmallThumbnails := Registry.ReadBool('UseSmallThumbnails');
      end else begin
        UseSmallThumbnails := true;
      end;

      if Registry.ValueExists('HelpPath') then begin
        HelpPath := Registry.ReadString('HelpPath');
      end else begin
        HelpPath := ExtractFilePath(Application.ExeName) + 'Apophysis 7X.chm';
      end;

      if Registry.ValueExists('ChaoticaPath') then begin
        ChaoticaPath := Registry.ReadString('ChaoticaPath');
      end else begin
        ChaoticaPath := '';
      end;
      if Registry.ValueExists('ChaoticaPath64') then begin
        ChaoticaPath64 := Registry.ReadString('ChaoticaPath64');
      end else begin
        ChaoticaPath64 := '';
      end;
      if Registry.ValueExists('UseX64IfPossible') then begin
        UseX64IfPossible := Registry.ReadBool('UseX64IfPossible');
      end else begin
        UseX64IfPossible := false;
      end;
    end
    else
    begin
      StartupCheckForUpdates := true;
      AlwaysCreateBlankFlame := false;
      MainForm_RotationMode := 0;
      EditPrevQual := 1;
      MutatePrevQual := 1;
      AdjustPrevQual := 1;
      GradientFile := '';
      defFlameFile := '';
      SavePath := DefaultPath + '\Flames.flame';
      EmbedThumbnails := false;
      WarnOnMissingPlugin := true;
      LanguageFile := '';
      HelpPath := ExtractFilePath(Application.ExeName) + 'Apophysis 7X.chm';
      defSmoothPaletteFile := DefaultPath + '\SmoothPalette.ugr';
      ConfirmDelete := True;
      ConfirmExit := True;
      OldPaletteFormat := false;
      NumTries := 10;
      TryLength := 100000;
      randMinTransforms := 2;
      randMaxTransforms := 3;
      mutantMinTransforms := 2;
      mutantMaxTransforms := 6;
      randGradient := 0;
      PreserveQuality := false;
      KeepBackground := False;
      UPRPath := DefaultPath + '\';
      ImageFolder := DefaultPath + '\';
      ParamFolder := DefaultPath + '\';
      UPRWidth := 640;
      UPRHeight := 480;
      RandomPrefix := 'Apo7X-';
      RandomIndex := 0;
      RandomDate := '';
      SymmetryType := 0;
      SymmetryOrder := 4;
      SymmetryNVars := 12;
      VariationOptions := 262143;
//      UnpackVariations(VariationOptions);
      MinNodes := 2;
      MaxNodes := 10;
      MinHue := 0;
      MinSat := 0;
      MinLum := 0;
      MaxHue := 600;
      MaxSat := 100;
      MaxLum := 100;
      randGradientFile := '';
      BatchSize := 100;
      ScriptPath := DefaultPath + '\';
      defLibrary := ExtractFilePath(Application.ExeName) + 'Functions.asc';
      ExportFileFormat := 1;
      ExportWidth := 640;
      ExportHeight := 480;
      ExportDensity := 100;
      ExportOversample := 2;
      ExportFilter := 0.6;
      ExportBatches := 3;
      SheepNick := '';
      SheepURL := '';
      SheepPW := '';
      flam3Path := ExtractFilePath(Application.ExeName) + 'flam3.exe';
      SheepServer := 'http://v2d5.sheepserver.net/';
      ShowProgress := true;
      SaveIncompleteRenders := false;
      LowerRenderPriority := false;
      ShowRenderStats := false;
      PNGTransparency := 1;
      ShowTransparency := False;
      MainPreviewScale := 1.2;
      ExtendMainPreview := true;
      NrTreads := 1;
      UseNrThreads := 1;
      InternalBitsPerSample := 0;
      AutoOpenLog := false;
      ClassicListMode := true;
      LastOpenFile := '';
      LastOpenFileEntry := 1;
      RememberLastOpenFile := false;
      UseSmallThumbnails := true;
      TBWidth1 := 0;
      TBWidth2 := 0;
      TBWidth3 := 0;
      TBWidth4 := 0;
      TBWidth5 := 0;
      LineCenterColor := $FFFFFF;
      LineThirdsColor := $0000FF;
      LineGRColor := $00FF00;
      EnableGuides := false;
      ChaoticaPath := '';
      ChaoticaPath64 := '';
      UseX64IfPossible := false;
    end;
    Registry.CloseKey;

    SetLength(Variations, NRVAR);
    if Registry.OpenKey('Software\' + APP_NAME + '\Variations', False) then
    begin
      for i := 0 to NRVAR-1 do begin
      if Registry.ValueExists(Varnames(i)) then
        Variations[i] := Registry.ReadBool(Varnames(i))
      else
        Variations[i] := false;
      end;
    end
    else begin
      if NRVAR >= 64 then maxVars := 63
      else maxVars := NRVAR-1;
      for i := 0 to maxVars do
        Variations[i] := boolean(VariationOptions shr i and 1);
    end;
    Registry.CloseKey;

    { Editor } // --Z-- moved from EditForm
    if Registry.OpenKey('Software\' + APP_NAME + '\Forms\Editor', False) then
    begin
      if Registry.ValueExists('UseTransformColors') then
        UseTransformColors := Registry.ReadBool('UseTransformColors')
      else
        UseTransformColors := False;
      if Registry.ValueExists('HelpersEnabled') then
        HelpersEnabled := Registry.ReadBool('HelpersEnabled')
      else
        HelpersEnabled := true;
      if Registry.ValueExists('ShowAllXforms') then
        ShowAllXforms := Registry.ReadBool('ShowAllXforms')
      else
        ShowAllXforms := true;
      if Registry.ValueExists('EnableEditorPreview') then
        EnableEditorPreview := Registry.ReadBool('EnableEditorPreview')
      else
        EnableEditorPreview := false;
      if Registry.ValueExists('EditorPreviewTransparency') then
        EditorPreviewTransparency := Registry.ReadInteger('EditorPreviewTransparency')
      else
        EditorPreviewTransparency := 192;

      if Registry.ValueExists('BackgroundColor') then
        EditorBkgColor := Registry.ReadInteger('BackgroundColor')
      else
        EditorBkgColor := integer(clBlack);
      if Registry.ValueExists('GridColor1') then
        GridColor1 := Registry.ReadInteger('GridColor1')
      else
        GridColor1 := $444444;
      if Registry.ValueExists('GridColor2') then
        GridColor2 := Registry.ReadInteger('GridColor2')
      else
        GridColor2 := $333333;
      if Registry.ValueExists('HelpersColor') then
        HelpersColor := Registry.ReadInteger('HelpersColor')
      else
        HelpersColor := $808080;
      if Registry.ValueExists('ReferenceTriangleColor') then
        ReferenceTriangleColor := Registry.ReadInteger('ReferenceTriangleColor')
      else
        ReferenceTriangleColor := $7f7f7f;
      if Registry.ValueExists('ExtendedEdit') then
        ExtEditEnabled := Registry.ReadBool('ExtendedEdit')
      else ExtEditEnabled := true;
      if Registry.ValueExists('LockTransformAxis') then
        TransformAxisLock := Registry.ReadBool('LockTransformAxis')
      else TransformAxisLock := true;
      if Registry.ValueExists('RebuildXaosLinks') then
        RebuildXaosLinks := Registry.ReadBool('RebuildXaosLinks')
      else RebuildXaosLinks := true;
    end
    else begin
      UseTransformColors := false;
      HelpersEnabled := true;
      ShowAllXforms := true;
      EnableEditorPreview := false;
      EditorPreviewTransparency := 192;
      EditorBkgColor := $000000;
      GridColor1 := $444444;
      GridColor2 := $333333;
      HelpersColor := $808080;
      ReferenceTriangleColor := integer(clGray);
      ExtEditEnabled := true;
      TransformAxisLock := true;
      RebuildXaosLinks := true;
    end;
    Registry.CloseKey;

    { Render }
    if Registry.OpenKey('Software\' + APP_NAME + '\Render', False) then
    begin
      if Registry.ValueExists('Path') then
      begin
        RenderPath := Registry.ReadString('Path');
      end
      else
      begin
        RenderPath := DefaultPath + '\';
      end;
      if Registry.ValueExists('SampleDensity') then
      begin
        renderDensity := Registry.ReadFloat('SampleDensity');
      end
      else
      begin
        renderDensity := 200;
      end;
      if Registry.ValueExists('FilterRadius') then
      begin
        renderFilterRadius := Registry.ReadFloat('FilterRadius');
      end
      else
      begin
        renderFilterRadius := 0.4;
      end;
      if Registry.ValueExists('Oversample') then
      begin
        renderOversample := Registry.ReadInteger('Oversample');
      end
      else
      begin
        renderOversample := 2;
      end;
      if Registry.ValueExists('Width') then
      begin
        renderWidth := Registry.ReadInteger('Width');
      end
      else
      begin
        renderWidth := 1024;
      end;
      if Registry.ValueExists('Height') then
      begin
        renderHeight := Registry.ReadInteger('Height');
      end
      else
      begin
        renderHeight := 768;
      end;
      if Registry.ValueExists('JPEGQuality') then
      begin
        JPEGQuality := Registry.ReadInteger('JPEGQuality');
      end
      else
      begin
        JPEGQuality := 100;
      end;
      if Registry.ValueExists('FileFormat') then
      begin
        renderFileFormat := Registry.ReadInteger('FileFormat');
      end
      else
      begin
        renderFileFormat := 3;
      end;
      if Registry.ValueExists('BitsPerSample') then
      begin
        renderBitsPerSample := Registry.ReadInteger('BitsPerSample');
      end
      else
      begin
        renderBitsPerSample := 0;
      end;

      if Registry.ValueExists('StoreEXIF') then begin
        StoreEXIF := Registry.ReadBool('StoreEXIF');
      end else begin
        StoreEXIF := false;
      end;
      if Registry.ValueExists('StoreParamsEXIF') then begin
        StoreParamsEXIF := Registry.ReadBool('StoreParamsEXIF');
      end else begin
        StoreParamsEXIF := false;
      end;
      if Registry.ValueExists('ExifAuthor') then begin
        ExifAuthor := Registry.ReadString('ExifAuthor');
      end else begin
        ExifAuthor := '';
      end;

    end
    else
    begin
      renderFileFormat := 2;
      JPEGQuality := 100;
      renderPath := DefaultPath + '\';
      renderDensity := 200;
      renderOversample := 2;
      renderFilterRadius := 0.4;
      renderWidth := 1024;
      renderHeight := 768;
      renderBitsPerSample := 0;
      StoreEXIF := false;
      ExifAuthor := '';
      StoreParamsEXIF := false;
    end;
    Registry.CloseKey;

    {UPR}
    if Registry.OpenKey('Software\' + APP_NAME + '\UPR', False) then
    begin
      if Registry.ValueExists('FlameColoringFile') then
      begin
        UPRColoringFile := Registry.ReadString('FlameColoringFile');
      end
      else
      begin
        UPRColoringFile := 'apophysis.ucl';
      end;
      if Registry.ValueExists('FlameColoringIdent') then
      begin
        UPRColoringIdent := Registry.ReadString('FlameColoringIdent');
      end
      else
      begin
        UPRColoringIdent := 'enr-flame-a';
      end;
      if Registry.ValueExists('FlameFormulaFile') then
      begin
        UPRFormulaFile := Registry.ReadString('FlameFormulaFile');
      end
      else
      begin
        UPRFormulaFile := 'mt.ufm';
      end;
      if Registry.ValueExists('FlameFormulaIdent') then
      begin
        UPRFormulaIdent := Registry.ReadString('FlameFormulaIdent');
      end
      else
      begin
        UPRFormulaIdent := 'mt-pixel';
      end;
      if Registry.ValueExists('FlameIterDensity') then
      begin
        UPRSampleDensity := Registry.ReadInteger('FlameIterDensity');
      end
      else
      begin
        UPRSampleDensity := 35;
      end;
      if Registry.ValueExists('FlameFilterRadius') then
      begin
        UPRFilterRadius := Registry.ReadFloat('FlameFilterRadius');
      end
      else
      begin
        UPRFilterRadius := 0.7;
      end;
      if Registry.ValueExists('FlameOversample') then
      begin
        UPROversample := Registry.ReadInteger('FlameOversample');
      end
      else
      begin
        UPROversample := 3;
      end;
      if Registry.ValueExists('FlameAdjustDensity') then
      begin
        UPRAdjustDensity := Registry.ReadBool('FlameAdjustDensity');
      end
      else
      begin
        UPRAdjustDensity := true;
      end;
    end
    else
    begin
      UPRColoringFile := 'apophysis.ucl';
      UPRColoringIdent := 'enr-flame-a';
      UPRFormulaFile := 'mt.ufm';
      UPRFormulaIdent := 'mt-pixel';
      UPRSampleDensity := 35;
      UPRFilterRadius := 0.7;
      UPROversample := 3;
      UPRAdjustDensity := True; ;
    end;
    Registry.CloseKey;
    
    if Registry.OpenKey('Software\' + APP_NAME + '\Display', False) then
    begin
      if Registry.ValueExists('SampleDensity') then
      begin
        defSampleDensity := Registry.ReadFloat('SampleDensity');
      end
      else
      begin
        defSampleDensity := 5;
      end;
      if Registry.ValueExists('Gamma') then
      begin
        defGamma := Registry.ReadFloat('Gamma');
      end
      else
      begin
        defGamma := 4;
      end;
      if Registry.ValueExists('Brightness') then
      begin
        defBrightness := Registry.ReadFloat('Brightness');
      end
      else
      begin
        defBrightness := 4;
      end;
      if Registry.ValueExists('Vibrancy') then
      begin
        defVibrancy := Registry.ReadFloat('Vibrancy');
      end
      else
      begin
        defVibrancy := 1;
      end;
      if Registry.ValueExists('FilterRadius') then
      begin
        defFilterRadius := Registry.ReadFloat('FilterRadius');
      end
      else
      begin
        defFilterRadius := 0.2;
      end;
      if Registry.ValueExists('GammaThreshold') then
      begin
        defGammaThreshold := Registry.ReadFloat('GammaThreshold');
      end
      else
      begin
        defGammaThreshold := 0.01;
      end;
      if Registry.ValueExists('Oversample') then
      begin
        defOversample := Registry.ReadInteger('Oversample');
      end
      else
      begin
        defOversample := 1;
      end;
      if Registry.ValueExists('PreviewDensity') then
      begin
        defPreviewDensity := Registry.ReadFloat('PreviewDensity');
      end
      else
      begin
        defPreviewDensity := 0.5;
      end;
      if Registry.ValueExists('PreviewLowQuality') then
      begin
        prevLowQuality := Registry.ReadFloat('PreviewLowQuality');
      end
      else
      begin
        prevLowQuality := 0.1;
      end;
      if Registry.ValueExists('PreviewMediumQuality') then
      begin
        prevMediumQuality := Registry.ReadFloat('PreviewMediumQuality');
      end
      else
      begin
        prevMediumQuality := 1;
      end;
      if Registry.ValueExists('PreviewHighQuality') then
      begin
        prevHighQuality := Registry.ReadFloat('PreviewHighQuality');
      end
      else
      begin
        prevHighQuality := 5;
      end;
    end
    else
    begin
      defSampleDensity := 5;
      defGamma := 4;
      defBrightness := 4;
      defVibrancy := 1;
      defFilterRadius := 0.2;
      defOversample := 1;
      defGammaThreshold := 0.01;
      defPreviewDensity := 0.5;
      prevLowQuality := 0.1;
      prevMediumQuality := 1;
      prevHighQuality := 5;
    end;
    Registry.CloseKey;

    if Registry.OpenKey('Software\' + APP_NAME + '\Autosave', False) then
    begin
      if Registry.ValueExists('AutoSaveEnabled') then
      begin
        AutoSaveEnabled := Registry.ReadBool('AutoSaveEnabled');
      end
      else
      begin
        AutoSaveEnabled := false;
      end;
      if Registry.ValueExists('AutoSaveFreq') then
      begin
        AutoSaveFreq := Registry.ReadInteger('AutoSaveFreq');
      end
      else
      begin
        AutoSaveFreq := 2;
      end;
      if Registry.ValueExists('AutoSavePath') then
      begin
        AutoSavePath := Registry.ReadString('AutoSavePath');
      end
      else
      begin
        AutoSavePath := GetEnvVarValue('USERPROFILE') + '\autosave.flame';
      end;
    end else begin
      AutoSaveEnabled := false;
      AutoSaveFreq := 2;
      AutoSavePath := GetEnvVarValue('USERPROFILE') + '\autosave.flame';
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;

  PluginPath := ReadPluginDir;
end;

procedure SaveSettings;
var
  Registry: TRegistry;
  i: integer;
begin
  SavePluginDir(PluginPath);

  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    { Defaults }
    if Registry.OpenKey('\Software\' + APP_NAME + '\Defaults', True) then
    begin
      Registry.WriteBool('StartupCheckForUpdates', StartupCheckForUpdates);
      Registry.WriteBool('AlwaysCreateBlankFlame', AlwaysCreateBlankFlame);
      Registry.WriteString('GradientFile', GradientFile);
      Registry.WriteString('HelpPath', HelpPath);
      Registry.WriteString('SmoothPaletteFile', SmoothPaletteFile);
      Registry.WriteBool('PlaySoundOnRenderComplete', PlaySoundOnRenderComplete);
      Registry.WriteString('RenderCompleteSoundFile', RenderCompleteSoundFile);
      Registry.WriteBool('AutoOpenLog', AutoOpenLog);
      Registry.WriteBool('ClassicListMode', ClassicListMode);
      Registry.WriteBool('EmbedThumbnails', EmbedThumbnails);
      Registry.WriteBool('WarnOnMissingPlugin', WarnOnMissingPlugin);
      Registry.WriteString('LanguageFile', LanguageFile);
      Registry.WriteString('LastOpenFile', LastOpenFile);
      Registry.WriteInteger('LastOpenFileEntry', LastOpenFileEntry);
      Registry.WriteBool('RememberLastOpenFile', RememberLastOpenFile);
      Registry.WriteBool('UseSmallThumbnails', UseSmallThumbnails);
      Registry.WriteInteger('ToolBarWidth1', TBWidth1);
      Registry.WriteInteger('ToolBarWidth2', TBWidth2);
      Registry.WriteInteger('ToolBarWidth3', TBWidth3);
      Registry.WriteInteger('ToolBarWidth4', TBWidth4);
      Registry.WriteInteger('ToolBarWidth5', TBWidth5);
      Registry.WriteInteger('LineCenterColor', LineCenterColor);
      Registry.WriteInteger('LineThirdsColor', LineThirdsColor);
      Registry.WriteInteger('LineGRColor', LineGRColor);
      Registry.WriteBool('EnableGuides', EnableGuides);
      Registry.WriteString('ChaoticaPath', ChaoticaPath);
      Registry.WriteString('ChaoticaPath64', ChaoticaPath64);
      Registry.WriteBool('UseX64IfPossible', UseX64IfPossible);

      Registry.WriteBool('ConfirmDelete', ConfirmDelete);
      Registry.WriteBool('OldPaletteFormat', OldPaletteFormat);
      Registry.WriteBool('ConfirmExit', ConfirmExit);
      Registry.WriteInteger('NumTries', NumTries);
      Registry.WriteInteger('TryLength', TryLength);
      Registry.WriteInteger('MinTransforms', randMinTransforms);
      Registry.WriteInteger('MaxTransforms', randMaxTransforms);
      Registry.WriteInteger('MutationMinTransforms', mutantMinTransforms);
      Registry.WriteInteger('MutationMaxTransforms', mutantMaxTransforms);
      Registry.WriteInteger('RandomGradient', randGradient);
      Registry.WriteString('ParameterFolder3D', ParamFolder);
      Registry.WriteString('UPRPath', UPRPath);
      Registry.WriteString('ImageFolder', ImageFolder);
      Registry.WriteString('SavePath3D', SavePath);
      Registry.WriteInteger('UPRWidth', UPRWidth);
      Registry.WriteInteger('UPRHeight', UPRHeight);
      Registry.WriteString('BrowserPath', BrowserPath);
      Registry.WriteInteger('EditPreviewQaulity', EditPrevQual);
      Registry.WriteInteger('MutatePreviewQaulity', MutatePrevQual);
      Registry.WriteInteger('AdjustPreviewQaulity', AdjustPrevQual);
      Registry.WriteString('RandomPrefix', RandomPrefix);
      Registry.WriteString('RandomDate', RandomDate);
      Registry.WriteInteger('RandomIndex', RandomIndex);
      Registry.WriteString('DefaultFlameFile3D', defFlameFile);
      Registry.WriteString('SmoothPalettePath', SmoothPalettePath);
      Registry.WriteString('GradientFile', GradientFile);
      Registry.WriteInteger('TryLength', TryLength);
      Registry.WriteInteger('NumTries', NumTries);
      Registry.WriteString('SmoothPaletteFile', defSmoothPaletteFile);
      Registry.WriteInteger('SymmetryType', SymmetryType);
      Registry.WriteInteger('SymmetryOrder', SymmetryOrder);
      Registry.WriteInteger('SymmetryNVars', SymmetryNVars);
//      Registry.WriteInteger('VariationOptions', VariationOptions);
//      Registry.WriteInteger('VariationOptions2', VariationOptions shr 32);
//      Registry.WriteInteger('ReferenceMode', ReferenceMode);
      Registry.WriteInteger('RotationMode', MainForm_RotationMode);
      Registry.WriteInteger('MinNodes', MinNodes);
      Registry.WriteInteger('MinHue', MinHue);
      Registry.WriteInteger('MinSat', MinSat);
      Registry.WriteInteger('MinLum', MinLum);
      Registry.WriteInteger('MaxNodes', MaxNodes);
      Registry.WriteInteger('MaxHue', MaxHue);
      Registry.WriteInteger('MaxSat', MaxSat);
      Registry.WriteInteger('MaxLum', MaxLum);
      Registry.WriteString('RandomGradientFile', randGradientFile);
      Registry.WriteInteger('BatchSize', BatchSize);
      Registry.WriteString('ScriptPath', ScriptPath);
      Registry.WriteInteger('ExportFileFormat', ExportFileFormat);
      Registry.WriteInteger('ExportWidth', ExportWidth);
      Registry.WriteInteger('ExportHeight', ExportHeight);
      Registry.WriteFloat('ExportDensity', ExportDensity);
      Registry.WriteFloat('ExportFilter', ExportFilter);
      Registry.WriteInteger('ExportOversample', ExportOversample);
      Registry.WriteInteger('ExportBatches', ExportBatches);
      Registry.WriteString('Nick', SheepNick);
      Registry.WriteString('URL', SheepURL);
      Registry.WriteString('Renderer', flam3Path);
      Registry.WriteString('Server', SheepServer);
      Registry.WriteString('Pass', SheepPW);
      Registry.WriteBool('ShowProgress', ShowProgress);
      Registry.WriteBool('KeepBackground', KeepBackground);
      Registry.WriteBool('PreserveQuality', PreserveQuality);
      Registry.WriteString('FunctionLibrary', defLibrary);

      Registry.WriteBool('ShowTransparency', ShowTransparency);
      Registry.WriteInteger('PNGTransparency', PNGTransparency);
      Registry.WriteBool('ExtendMainPreview', ExtendMainPreview);
      Registry.WriteFloat('MainPreviewScale', MainPreviewScale);

      Registry.WriteBool('SaveIncompleteRenders', SaveIncompleteRenders);
      Registry.WriteBool('ShowRenderStats', ShowRenderStats);
      Registry.WriteBool('LowerRenderPriority', LowerRenderPriority);

      Registry.WriteInteger('NrTreads', NrTreads);
      Registry.WriteInteger('UseNrThreads', UseNrThreads);
      Registry.WriteInteger('InternalBitsPerSample', InternalBitsPerSample);
    end;
    Registry.CloseKey;

    if Registry.OpenKey('\Software\' + APP_NAME + '\Variations', True) then
    begin
      for i := 0 to NRVAR-1 do begin
        if Registry.ValueExists(Varnames(i)) then
          if Registry.ReadBool(Varnames(i)) = Variations[i] then
            continue;
        Registry.WriteBool(Varnames(i), Variations[i]);
      end;
    end;
    Registry.CloseKey;

    { Editor }
    if Registry.OpenKey('\Software\' + APP_NAME + '\Forms\Editor', True) then
    begin
      Registry.WriteBool('UseTransformColors', UseTransformColors);
      Registry.WriteBool('HelpersEnabled', HelpersEnabled);
      Registry.WriteBool('ShowAllXforms', ShowAllXforms);
      Registry.WriteBool('EnableEditorPreview', EnableEditorPreview);
      Registry.WriteInteger('EditorPreviewTransparency', EditorPreviewTransparency);
      Registry.WriteInteger('BackgroundColor', EditorBkgColor);
      Registry.WriteInteger('GridColor1', GridColor1);
      Registry.WriteInteger('GridColor2', GridColor2);
      Registry.WriteInteger('HelpersColor', HelpersColor);
      Registry.WriteInteger('ReferenceTriangleColor', ReferenceTriangleColor);
      Registry.WriteBool('ExtendedEdit', ExtEditEnabled);
      Registry.WriteBool('LockTransformAxis', TransformAxisLock);
      Registry.WriteBool('RebuildXaosLinks', RebuildXaosLinks);
    end;
    Registry.CloseKey;

    { Display }
    if Registry.OpenKey('\Software\' + APP_NAME + '\Display', True) then
    begin
      Registry.WriteFloat('SampleDensity', defSampleDensity);
      Registry.WriteFloat('Gamma', defGamma);
      Registry.WriteFloat('Brightness', defBrightness);
      Registry.WriteFloat('Vibrancy', defVibrancy);
      Registry.WriteFloat('FilterRadius', defFilterRadius);
      Registry.WriteInteger('Oversample', defOversample);
      Registry.WriteFloat('GammaThreshold', defGammaThreshold);
      Registry.WriteFloat('PreviewDensity', defPreviewDensity);
      Registry.WriteFloat('PreviewLowQuality', prevLowQuality);
      Registry.WriteFloat('PreviewMediumQuality', prevMediumQuality);
      Registry.WriteFloat('PreviewHighQuality', prevHighQuality);
    end;
    Registry.CloseKey;

    { UPR }
    if Registry.OpenKey('\Software\' + APP_NAME + '\UPR', True) then
    begin
      Registry.WriteString('FlameColoringFile', UPRColoringFile);
      Registry.WriteString('FlameColoringIdent', UPRColoringIdent);
      Registry.WriteString('FlameFormulaFile', UPRFormulaFile);
      Registry.WriteString('FlameFormulaIdent', UPRFormulaIdent);
      Registry.WriteInteger('FlameIterDensity', UPRSampleDensity);
      Registry.WriteFloat('FlameFilterRadius', UPRFilterRadius);
      Registry.WriteInteger('FlameOversample', UPROversample);
      Registry.WriteBool('FlameAdjustDensity', UPRAdjustDensity);
    end;
    Registry.CloseKey;

    if Registry.OpenKey('\Software\' + APP_NAME + '\Render', True) then
    begin
      Registry.WriteString('Path', renderPath);
      Registry.WriteFloat('SampleDensity', renderDensity);
      Registry.WriteInteger('Oversample', renderOversample);
      Registry.WriteFloat('FilterRadius', renderFilterRadius);
      Registry.WriteInteger('Width', renderWidth);
      Registry.WriteInteger('Height', renderHeight);
      Registry.WriteInteger('JPEGQuality', JPEGQuality);
      Registry.WriteInteger('FileFormat', renderFileFormat);
      Registry.WriteInteger('BitsPerSample', renderBitsPerSample);
      Registry.WriteBool('StoreEXIF', StoreEXIF);
      Registry.WriteBool('StoreParamsEXIF', StoreParamsEXIF);
      Registry.WriteString('ExifAuthor', ExifAuthor);
    end;
    Registry.CloseKey;

    if Registry.OpenKey('\Software\' + APP_NAME + '\Autosave', True) then
    begin
      Registry.WriteBool('AutoSaveEnabled', AutoSaveEnabled);
      Registry.WriteInteger('AutoSaveFreq', AutoSaveFreq);
      Registry.WriteString('AutoSavePath', AutoSavePath);
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

end.

