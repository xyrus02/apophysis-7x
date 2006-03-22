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
unit Regstry;

interface

uses graphics, Messages;

procedure ReadSettings;
procedure SaveSettings;

implementation

uses Windows, SysUtils, Forms, Registry, Global, Dialogs, XFormMan;

procedure UnpackVariations(v: integer);
{ Unpacks the variation options form an integer }
var
  i: integer;
begin
  for i := 0 to NRVAR - 1 do
    Variations[i] := boolean(v shr i and 1);
end;


procedure ReadSettings;
var
  Registry: TRegistry;
  DefaultPath: string;
begin
  DefaultPath := ExtractFilePath(Application.Exename);
//  ShowMessage(DefaultPath);
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    { Defaults }
    if Registry.OpenKey('Software\' + APP_NAME + '\Defaults', False) then
    begin
      if Registry.ValueExists('DefaultFlameFile') then
      begin
        defFlameFile := Registry.ReadString('DefaultFlameFile');
      end
      else
      begin
        defFlameFile := '';
      end;
      if Registry.ValueExists('GradientFile') then
      begin
        GradientFile := Registry.ReadString('GradientFile');
      end
      else
      begin
        GradientFile := ''
      end;
      if Registry.ValueExists('SavePath') then
      begin
        SavePath := Registry.ReadString('SavePath');
      end
      else
      begin
        SavePath := DefaultPath + 'Parameters\My Flames.flame';
      end;
      if Registry.ValueExists('SmoothPaletteFile') then
      begin
        defSmoothPaletteFile := Registry.ReadString('SmoothPaletteFIle');
      end
      else
      begin
        defSmoothPaletteFile := DefaultPath + 'smooth.ugr';
      end;
      if Registry.ValueExists('ConfirmDelete') then
      begin
        ConfirmDelete := Registry.ReadBool('ConfirmDelete');
      end
      else
      begin
        ConfirmDelete := True;
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
      end
      else
      begin
        randMinTransforms := 2;
      end;
      if Registry.ValueExists('MaxTransforms') then
      begin
        randMaxTransforms := Registry.ReadInteger('MaxTransforms');
      end
      else
      begin
        randMaxTransforms := 3;
      end;
      if Registry.ValueExists('MutationMinTransforms') then
      begin
        mutantMinTransforms := Registry.ReadInteger('MutationMinTransforms');
      end
      else
      begin
        mutantMinTransforms := 2;
      end;
      if Registry.ValueExists('MutationMaxTransforms') then
      begin
        mutantMaxTransforms := Registry.ReadInteger('MutationMaxTransforms');
      end
      else
      begin
        mutantMaxTransforms := 6;
      end;
      if Registry.ValueExists('RandomGradient') then
      begin
        randGradient := Registry.ReadInteger('RandomGradient');
      end
      else
      begin
        randGradient := 0;
      end;
      if Registry.ValueExists('ParameterFolder') then
      begin
        ParamFolder := Registry.ReadString('ParameterFolder');
      end
      else
      begin
        ParamFolder := DefaultPath + 'Parameters\';
      end;
      if Registry.ValueExists('UPRPath') then
      begin
        UPRPath := Registry.ReadString('UPRPath');
      end
      else
      begin
        UPRPath := DefaultPath;
      end;
      if Registry.ValueExists('ImageFolder') then
      begin
        ImageFolder := Registry.ReadString('ImageFolder');
      end
      else
      begin
        ImageFolder := DefaultPath;
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
        BrowserPath := DefaultPath;
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
      end
      else
      begin
        MutatePrevQual := 1;
      end;
      if Registry.ValueExists('AdjustPreviewQaulity') then
      begin
        AdjustPrevQual := Registry.ReadInteger('AdjustPreviewQaulity');
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
        RandomPrefix := 'Apophysis-'
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
        Registry.ReadBinaryData('VariationOptions', VariationOptions, 8);
//        Delphi_Suxx := Registry.ReadString('VariationOptions');
//        VariationOptions := StrToInt64(Delphi_Suxx);
      end
      else
      begin
        VariationOptions := 262143;
      end;
      UnpackVariations(VariationOptions);

      if Registry.ValueExists('MinNodes') then
      begin
        MinNodes := Registry.ReadInteger('MinNodes');
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
      end
      else
      begin
        MaxNodes := 10;
      end;
      if Registry.ValueExists('MaxHue') then
      begin
        MaxHue := Registry.ReadInteger('MaxHue');
      end
      else
      begin
        MaxHue := 600;
      end;
      if Registry.ValueExists('MaxSat') then
      begin
        MaxSat := Registry.ReadInteger('MaxSat');
      end
      else
      begin
        MaxSat := 100;
      end;
{
      if Registry.ValueExists('FixedReference') then
      begin
        FixedReference := Registry.ReadBool('FixedReference');
      end
      else FixedReference := False;
}
      if Registry.ValueExists('ReferenceMode') then
        ReferenceMode := Registry.ReadInteger('ReferenceMode')
      else ReferenceMode := 0;
      if Registry.ValueExists('RotationMode') then
        MainForm_RotationMode := Registry.ReadInteger('RotationMode')
      else MainForm_RotationMode := 0;

      if Registry.ValueExists('MaxLum') then
      begin
        MaxLum := Registry.ReadInteger('MaxLum');
      end
      else
      begin
        MaxLum := 100;
      end;
      if Registry.ValueExists('BatchSize') then
      begin
        BatchSize := Registry.ReadInteger('BatchSize');
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
        ScriptPath := DefaultPath + 'Scripts\';
      end;
      if Registry.ValueExists('FunctionLibrary') then
      begin
        defLibrary := Registry.ReadString('FunctionLibrary');
      end
      else
      begin
        defLibrary := DefaultPath + 'Scripts\Functions.asc';
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
      end
      else
      begin
        ExportWidth := 640;
      end;
      if Registry.ValueExists('ExportHeight') then
      begin
        ExportHeight := Registry.ReadInteger('ExportHeight');
      end
      else
      begin
        ExportHeight := 480;
      end;
      if Registry.ValueExists('ExportDensity') then
      begin
        ExportDensity := Registry.ReadFloat('ExportDensity');
      end
      else
      begin
        ExportDensity := 100;
      end;
      if Registry.ValueExists('ExportOversample') then
      begin
        ExportOversample := Registry.ReadInteger('ExportOversample');
      end
      else
      begin
        ExportOversample := 2;
      end;
      if Registry.ValueExists('ExportFilter') then
      begin
        ExportFilter := Registry.ReadFloat('ExportFilter');
      end
      else
      begin
        ExportFilter := 0.6;
      end;
      if Registry.ValueExists('ExportBatches') then
      begin
        ExportBatches := Registry.ReadInteger('ExportBatches');
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
        HQIPath := Registry.ReadString('Renderer');
      end
      else
      begin
        HQIPath := DefaultPath + 'flam3.exe';
      end;
      if Registry.ValueExists('Server') then
      begin
        SheepServer := Registry.ReadString('Server');
      end
      else
      begin
        SheepServer := 'http://v2d5.sheepserver.net/';
      end;
      if Registry.ValueExists('ResizeOnLoad') then
      begin
        ResizeOnLoad := Registry.ReadBool('ResizeOnLoad');
      end
      else
      begin
        ResizeOnLoad := False;
      end;
      if Registry.ValueExists('ShowProgress') then
      begin
        ShowProgress := Registry.ReadBool('ShowProgress');
      end else begin
        ShowProgress := true;
      end;
      if Registry.ValueExists('PNGTransparency') then begin
        PNGTransparency := Registry.ReadInteger('PNGTransparency');
      end else begin
        PNGTransparency := 1
      end;
      if Registry.ValueExists('ShowTransparency') then begin
        ShowTransparency := Registry.ReadBool('ShowTransparency');
      end else begin
        ShowTransparency := False;
      end;
      if Registry.ValueExists('NrTreads') then begin
        NrTreads := Registry.ReadInteger('NrTreads');
      end else begin
        NrTreads := 1;
      end;
      if Registry.ValueExists('UseNrThreads') then begin
        UseNrThreads := Registry.ReadInteger('UseNrThreads');
      end else begin
        UseNrThreads := 1;
      end;
    end
    else
    begin
      ReferenceMode := 0;
      MainForm_RotationMode := 0;
      EditPrevQual := 1;
      MutatePrevQual := 1;
      AdjustPrevQual := 1;
      GradientFile := '';
      defFlameFile := '';
      SavePath := DefaultPath + 'Parameters\My Flames.flame';
      defSmoothPaletteFile := DefaultPath + 'smooth.ugr';
      ConfirmDelete := True;
      NumTries := 10;
      TryLength := 100000;
      randMinTransforms := 2;
      randMaxTransforms := 3;
      mutantMinTransforms := 2;
      mutantMaxTransforms := 6;
      randGradient := 0;
      KeepBackground := False;
      UPRPath := DefaultPath;
      ImageFolder := DefaultPath;
      ParamFolder := DefaultPath + 'Parameters\';
      UPRWidth := 640;
      UPRHeight := 480;
      RandomPrefix := 'Apophysis-';
      RandomIndex := 0;
      RandomDate := '';
      SymmetryType := 0;
      SymmetryOrder := 4;
      SymmetryNVars := 12;
      VariationOptions := 262143;
      UnpackVariations(VariationOptions);
      MinNodes := 2;
      MaxNodes := 10;
      MinHue := 0;
      MinSat := 0;
      MinLum := 0;
      MaxHue := 600;
      MaxSat := 100;
      MaxLum := 100;
      BatchSize := 100;
      ScriptPath := DefaultPath + 'Scripts\';
      defLibrary := DefaultPath + 'Scripts\Functions.asc';
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
      HQIPath := DefaultPath + 'flam3.exe';
      SheepServer := 'http://v2d5.sheepserver.net/';
      ResizeOnLoad := False;
      ShowProgress := true;
      PNGTransparency := 2;
      ShowTransparency := False;
      NrTreads := 1;
      UseNrThreads := 1;
    end;
    Registry.CloseKey;

    { Editor } // --Z-- moved from EditForm
    if Registry.OpenKey('Software\' + APP_NAME + '\Forms\Editor', False) then
    begin
{      if Registry.ValueExists('UseTransformColors') then
      begin
        UseTransformColors := Registry.ReadBool('UseTransformColors');
      end
      else
      begin
        UseTransformColors := False;
      end;
      if Registry.ValueExists('UseFlameBackground') then
      begin
        UseFlameBackground := Registry.ReadBool('UseFlameBackground');
      end
      else
      begin
        UseFlameBackground := False;
      end;
}
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
    end
    else begin
      EditorBkgColor := $000000;
      GridColor1 := $444444;
      GridColor2 := $333333;
      HelpersColor := $808080;
      ReferenceTriangleColor := integer(clGray);
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
        RenderPath := DefaultPath;
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
    end
    else
    begin
      renderFileFormat := 2;
      JPEGQuality := 100;
      renderPath := DefaultPath;
      renderDensity := 200;
      renderOversample := 2;
      renderFilterRadius := 0.4;
      renderWidth := 1024;
      renderHeight := 768;
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
      defPreviewDensity := 0.5;
      prevLowQuality := 0.1;
      prevMediumQuality := 1;
      prevHighQuality := 5;
    end;
    Registry.CloseKey;

  finally
    Registry.Free;
  end;
end;

procedure SaveSettings;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    { Defaults }
    if Registry.OpenKey('\Software\' + APP_NAME + '\Defaults', True) then
    begin
      Registry.WriteString('GradientFile', GradientFile);
      Registry.WriteString('SmoothPaletteFile', SmoothPaletteFile);
      Registry.WriteBool('ConfirmDelete', ConfirmDelete);
      Registry.WriteInteger('NumTries', NumTries);
      Registry.WriteInteger('TryLength', TryLength);
      Registry.WriteInteger('MinTransforms', randMinTransforms);
      Registry.WriteInteger('MaxTransforms', randMaxTransforms);
      Registry.WriteInteger('MutationMinTransforms', mutantMinTransforms);
      Registry.WriteInteger('MutationMaxTransforms', mutantMaxTransforms);
      Registry.WriteInteger('RandomGradient', randGradient);
      Registry.WriteString('ParameterFolder', ParamFolder);
      Registry.WriteString('UPRPath', UPRPath);
      Registry.WriteString('ImageFolder', ImageFolder);
      Registry.WriteString('SavePath', SavePath);
      Registry.WriteInteger('UPRWidth', UPRWidth);
      Registry.WriteInteger('UPRHeight', UPRHeight);
      Registry.WriteString('BrowserPath', BrowserPath);
      Registry.WriteInteger('EditPreviewQaulity', EditPrevQual);
      Registry.WriteInteger('MutatePreviewQaulity', MutatePrevQual);
      Registry.WriteInteger('AdjustPreviewQaulity', AdjustPrevQual);
      Registry.WriteString('RandomPrefix', RandomPrefix);
      Registry.WriteString('RandomDate', RandomDate);
      Registry.WriteInteger('RandomIndex', RandomIndex);
      Registry.WriteString('DefaultFlameFile', defFlameFile);
      Registry.WriteString('SmoothPalettePath', SmoothPalettePath);
      Registry.WriteString('GradientFile', GradientFile);
      Registry.WriteInteger('TryLength', TryLength);
      Registry.WriteInteger('NumTries', NumTries);
      Registry.WriteString('SmoothPaletteFile', defSmoothPaletteFile);
      Registry.WriteInteger('SymmetryType', SymmetryType);
      Registry.WriteInteger('SymmetryOrder', SymmetryOrder);
      Registry.WriteInteger('SymmetryNVars', SymmetryNVars);
      Registry.WriteBinaryData('VariationOptions', VariationOptions, 8);
      Registry.WriteInteger('ReferenceMode', ReferenceMode);
      Registry.WriteInteger('RotationMode', MainForm_RotationMode);
      Registry.WriteInteger('MinNodes', MinNodes);
      Registry.WriteInteger('MinHue', MinHue);
      Registry.WriteInteger('MinSat', MinSat);
      Registry.WriteInteger('MinLum', MinLum);
      Registry.WriteInteger('MaxNodes', MaxNodes);
      Registry.WriteInteger('MaxHue', MaxHue);
      Registry.WriteInteger('MaxSat', MaxSat);
      Registry.WriteInteger('MaxLum', MaxLum);
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
      Registry.WriteString('Renderer', HqiPath);
      Registry.WriteString('Server', SheepServer);
      Registry.WriteString('Pass', SheepPW);
      Registry.WriteBool('ResizeOnLoad', ResizeOnLoad);
      Registry.WriteBool('ShowProgress', ShowProgress);
      Registry.WriteBool('KeepBackground', KeepBackground);
      Registry.WriteString('FunctionLibrary', defLibrary);

      Registry.WriteBool('ShowTransparency', ShowTransparency);
      Registry.WriteInteger('PNGTransparency', PNGTransparency);
      Registry.WriteInteger('NrTreads', NrTreads);
      Registry.WriteInteger('UseNrThreads', UseNrThreads);
    end;
    { Editor }
    if Registry.OpenKey('\Software\' + APP_NAME + '\Forms\Editor', True) then
    begin
      Registry.WriteBool('UseTransformColors', UseTransformColors);
      Registry.WriteInteger('BackgroundColor', EditorBkgColor);
      Registry.WriteInteger('GridColor1', GridColor1);
      Registry.WriteInteger('GridColor2', GridColor2);
      Registry.WriteInteger('HelpersColor', HelpersColor);
      Registry.WriteInteger('ReferenceTriangleColor', ReferenceTriangleColor);
    end;
    { Display }
    if Registry.OpenKey('\Software\' + APP_NAME + '\Display', True) then
    begin
      Registry.WriteFloat('SampleDensity', defSampleDensity);
      Registry.WriteFloat('Gamma', defGamma);
      Registry.WriteFloat('Brightness', defBrightness);
      Registry.WriteFloat('Vibrancy', defVibrancy);
      Registry.WriteFloat('FilterRadius', defFilterRadius);
      Registry.WriteInteger('Oversample', defOversample);
      Registry.WriteFloat('PreviewDensity', defPreviewDensity);
      Registry.WriteFloat('PreviewLowQuality', prevLowQuality);
      Registry.WriteFloat('PreviewMediumQuality', prevMediumQuality);
      Registry.WriteFloat('PreviewHighQuality', prevHighQuality);
    end;
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
    end;
  finally
    Registry.Free;
  end;
end;

end.

