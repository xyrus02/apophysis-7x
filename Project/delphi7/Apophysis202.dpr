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
program Apophysis202;



uses
  Forms,
  SysUtils,
  About in '..\..\Source\About.pas' {AboutForm},
  Adjust in '..\..\Source\Adjust.pas' {AdjustForm},
  bmdll32 in '..\..\Source\bmdll32.PAS',
  Browser in '..\..\Source\Browser.pas' {GradientBrowser},
  Cmap in '..\..\Source\cmap.pas',
  cmapdata in '..\..\Source\cmapdata.pas',
  ControlPoint in '..\..\Source\ControlPoint.pas',
  Editor in '..\..\Source\Editor.pas' {EditForm},
  FormExport in '..\..\Source\FormExport.pas' {ExportDialog},
  FormFavorites in '..\..\Source\FormFavorites.pas' {FavoritesForm},
  formPostProcess in '..\..\Source\formPostProcess.pas' {frmPostProcess},
  FormRender in '..\..\Source\FormRender.pas' {RenderForm},
  Fullscreen in '..\..\Source\Fullscreen.pas' {FullscreenForm},
  Global in '..\..\Source\Global.pas',
  GradientHlpr in '..\..\Source\GradientHlpr.pas',
  HtmlHlp in '..\..\Source\HtmlHlp.pas',
  ImageColoring in '..\..\Source\ImageColoring.pas' {frmImageColoring},
  ImageMaker in '..\..\Source\ImageMaker.pas',
  Main in '..\..\Source\Main.pas' {MainForm},
  MsMultiPartFormData in '..\..\Source\MsMultiPartFormData.pas',
  Mutate in '..\..\Source\Mutate.pas' {MutateForm},
  MyTypes in '..\..\Source\MyTypes.pas',
  Options in '..\..\Source\Options.pas' {OptionsForm},
  Preview in '..\..\Source\Preview.pas' {PreviewForm},
  Regstry in '..\..\Source\Regstry.pas',
  Render in '..\..\Source\Render.pas',
  Render64 in '..\..\Source\Render64.pas',
  Render64MT in '..\..\Source\Render64MT.pas',
  RenderMM in '..\..\Source\RenderMM.pas',
  RenderMM2 in '..\..\Source\RenderMM2.pas',
  RenderThread in '..\..\Source\RenderThread.pas',
  RndFlame in '..\..\Source\RndFlame.pas',
  Save in '..\..\Source\Save.pas' {SaveForm},
  SavePreset in '..\..\Source\SavePreset.pas' {SavePresetForm},
  ScriptForm in '..\..\Source\ScriptForm.pas' {ScriptEditor},
  ScriptRender in '..\..\Source\ScriptRender.pas' {ScriptRenderForm},
  Sheep in '..\..\Source\Sheep.pas' {SheepDialog},
  XForm in '..\..\Source\XForm.pas',
  pngextra in '..\..\..\..\..\..\..\compilers\components\PNGImage\pngextra.pas',
  pngimage in '..\..\..\..\..\..\..\compilers\components\PNGImage\pngimage.pas',
  pnglang in '..\..\..\..\..\..\..\compilers\components\PNGImage\pnglang.pas',
  pngzlib in '..\..\..\..\..\..\..\compilers\components\PNGImage\pngzlib.pas',
  varpdj in '..\..\Source\varpdj.pas',
  varblob in '..\..\Source\varblob.pas',
  XFormMan in '..\..\Source\XFormMan.pas',
  BaseVariation in '..\..\Source\BaseVariation.pas',
  BucketFillerThread in '..\..\Source\BucketFillerThread.pas',
  RenderMM_MT in '..\..\Source\RenderMM_MT.pas',
  varRings2 in '..\..\Source\varRings2.pas',
  varFan2 in '..\..\Source\varFan2.pas',
  CustomDrawControl in '..\..\Source\CustomDrawControl.pas';

//  ImageColoring in '..\..\Source\ImageColoring.pas' {frmImageColoring};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Apophysis';
  Application.HelpFile := 'Apophysis 2.0.chm';
  //  Application.CreateForm(TfrmImageColoring, frmImageColoring);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TAdjustForm, AdjustForm);
  Application.CreateForm(TGradientBrowser, GradientBrowser);
  Application.CreateForm(TEditForm, EditForm);
  Application.CreateForm(TExportDialog, ExportDialog);
  Application.CreateForm(TFavoritesForm, FavoritesForm);
  Application.CreateForm(TfrmPostProcess, frmPostProcess);
  Application.CreateForm(TRenderForm, RenderForm);
  Application.CreateForm(TFullscreenForm, FullscreenForm);
  Application.CreateForm(TfrmImageColoring, frmImageColoring);
  Application.CreateForm(TMutateForm, MutateForm);
  Application.CreateForm(TOptionsForm, OptionsForm);
  Application.CreateForm(TPreviewForm, PreviewForm);
  Application.CreateForm(TSaveForm, SaveForm);
  Application.CreateForm(TSavePresetForm, SavePresetForm);
  Application.CreateForm(TScriptEditor, ScriptEditor);
  Application.CreateForm(TScriptRenderForm, ScriptRenderForm);
  Application.CreateForm(TSheepDialog, SheepDialog);
  Application.UpdateFormatSettings := False;
  DecimalSeparator := '.';
  Application.Run;
end.

