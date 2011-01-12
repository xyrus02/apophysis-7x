{
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Borys, Peter Sdobnov
     Apophysis "3D hack" Copyright (C) 2007-2008 Peter Sdobnov

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
program Apophysis7X;

{%ToDo 'Apophysis7X.todo'}
{$R 'res\Apophysis7X.res'}

uses
  FastMM4 in '..\..\Source\System\FastMM4.pas',
  FastMM4Messages in '..\..\Source\System\FastMM4Messages.pas',
  Forms,
  Dialogs,
  SysUtils,
  Binary in '..\..\Source\IO\Binary.pas',
  Hibernation in '..\..\Source\IO\Hibernation.pas',
  Base64 in '..\..\Source\IO\Base64.pas',
  AsmRandom in '..\..\Source\System\AsmRandom.pas',
  CommandLine in '..\..\Source\IO\CommandLine.pas',
  BucketFillerThread in '..\..\Source\Renderer\BucketFillerThread.pas',
  cmapdata in '..\..\Source\ColorMap\cmapdata.pas',
  cmap in '..\..\Source\ColorMap\cmap.pas',
  ControlPoint in '..\..\Source\Flame\ControlPoint.pas',
  CustomDrawControl in '..\..\Source\System\CustomDrawControl.pas',
  Global in '..\..\Source\Core\Global.pas',
  GradientHlpr in '..\..\Source\ColorMap\GradientHlpr.pas',
  ImageMaker in '..\..\Source\Renderer\ImageMaker.pas',
  MissingPlugin in '..\..\Source\IO\MissingPlugin.pas',
  NativeXmlObjectStorage in '..\..\Source\System\NativeXmlObjectStorage.pas',
  NativeXml in '..\..\Source\System\NativeXml.pas',
  NativeXmlAppend in '..\..\Source\System\NativeXmlAppend.pas',
  RegexHelper in '..\..\Source\System\RegexHelper.pas',
  Regstry in '..\..\Source\IO\Regstry.pas',
  Render in '..\..\Source\Renderer\Render.pas',
  Render32 in '..\..\Source\Renderer\Render32.pas',
  Render32MT in '..\..\Source\Renderer\Render32MT.pas',
  RenderThread in '..\..\Source\Renderer\RenderThread.pas',
  RenderMT in '..\..\Source\Renderer\RenderMT.pas',
  RenderST in '..\..\Source\Renderer\RenderST.pas',
  RenderTypes in '..\..\Source\Renderer\RenderTypes.pas',
  RndFlame in '..\..\Source\Flame\RndFlame.pas',
  sdStringTable in '..\..\Source\System\sdStringTable.pas',
  Translation in '..\..\Source\Core\Translation.pas',
  varRadialBlur in '..\..\Source\Variations\varRadialBlur.pas',
  varRings2 in '..\..\Source\Variations\varRings2.pas',
  varFan2 in '..\..\Source\Variations\varFan2.pas',
  varPDJ in '..\..\Source\Variations\varPDJ.pas',
  varJuliaN in '..\..\Source\Variations\varJuliaN.pas',
  varJuliaScope in '..\..\Source\Variations\varJuliaScope.pas',
  varJulia3Djf in '..\..\Source\Variations\varJulia3Djf.pas',
  varJulia3Dz in '..\..\Source\Variations\varJulia3Dz.pas',
  varCurl in '..\..\Source\Variations\varCurl.pas',
  varCurl3D in '..\..\Source\Variations\varCurl3D.pas',
  varRectangles in '..\..\Source\Variations\varRectangles.pas',
  varHemisphere in '..\..\Source\Variations\varHemisphere.pas',
  varGenericPlugin in '..\..\Source\Variations\varGenericPlugin.pas',
  BaseVariation in '..\..\Source\Core\BaseVariation.pas',
  XFormMan in '..\..\Source\Core\XFormMan.pas',
  XForm in '..\..\Source\Flame\XForm.pas',
  Main in '..\..\Source\Forms\Main.pas' {MainForm},
  Tracer in '..\..\Source\Forms\Tracer.pas' {TraceForm},
  About in '..\..\Source\Forms\About.pas' {AboutForm},
  Adjust in '..\..\Source\Forms\Adjust.pas' {AdjustForm},
  Browser in '..\..\Source\Forms\Browser.pas' {GradientBrowser},
  Editor in '..\..\Source\Forms\Editor.pas' {EditForm},
  FormExport in '..\..\Source\Forms\FormExport.pas' {ExportDialog},
  FormExportC in '..\..\Source\Forms\FormExportC.pas' {ExportCDialog},
  FormFavorites in '..\..\Source\Forms\FormFavorites.pas' {FavoritesForm},
  formPostProcess in '..\..\Source\Forms\formPostProcess.pas' {frmPostProcess},
  FormRender in '..\..\Source\Forms\FormRender.pas' {RenderForm},
  Fullscreen in '..\..\Source\Forms\Fullscreen.pas' {FullscreenForm},
  ImageColoring in '..\..\Source\Forms\ImageColoring.pas' {frmImageColoring},
  LoadTracker in '..\..\Source\Forms\LoadTracker.pas' {LoadForm},
  Mutate in '..\..\Source\Forms\Mutate.pas' {MutateForm},
  Options in '..\..\Source\Forms\Options.pas' {OptionsForm},
  Preview in '..\..\Source\Forms\Preview.pas' {PreviewForm},
  Save in '..\..\Source\Forms\Save.pas' {SaveForm},
  SavePreset in '..\..\Source\Forms\SavePreset.pas' {SavePresetForm},
  ScriptForm in '..\..\Source\Forms\ScriptForm.pas' {ScriptEditor},
  ScriptRender in '..\..\Source\Forms\ScriptRender.pas' {ScriptRenderForm},
  SplashForm in '..\..\Source\Forms\SplashForm.pas' {SplashWindow},
  Template in '..\..\Source\Forms\Template.pas' {TemplateForm},
  MapmPlugin in '..\..\Managed\Mapm\Delphi\MapmPlugin.pas',
  Mapm in '..\..\Managed\Mapm\Delphi\Mapm.pas',
  MapmException in '..\..\Managed\Mapm\Delphi\MapmException.pas',
  MapmMonitor in '..\..\Managed\Mapm\Delphi\MapmMonitor.pas';

begin
  SplashWindow := TSplashWindow.Create(Application) ;
  SplashWindow.Show;
  Application.Initialize;
  SplashWindow.Update;

  Application.Title := 'Apophysis 7x';
  Application.HelpFile := 'Apophysis7x.chm';
  //Application.CreateForm(TSplashWindow, SplashWindow);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TTraceForm, TraceForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TAdjustForm, AdjustForm);
  Application.CreateForm(TGradientBrowser, GradientBrowser);
  Application.CreateForm(TEditForm, EditForm);
  Application.CreateForm(TExportDialog, ExportDialog);
  Application.CreateForm(TExportCDialog, ExportCDialog);
  Application.CreateForm(TFavoritesForm, FavoritesForm);
  Application.CreateForm(TfrmPostProcess, frmPostProcess);
  Application.CreateForm(TRenderForm, RenderForm);
  Application.CreateForm(TFullscreenForm, FullscreenForm);
  Application.CreateForm(TfrmImageColoring, frmImageColoring);
  Application.CreateForm(TLoadForm, LoadForm);
  Application.CreateForm(TMutateForm, MutateForm);
  Application.CreateForm(TOptionsForm, OptionsForm);
  Application.CreateForm(TPreviewForm, PreviewForm);
  Application.CreateForm(TSaveForm, SaveForm);
  Application.CreateForm(TSavePresetForm, SavePresetForm);
  Application.CreateForm(TScriptEditor, ScriptEditor);
  Application.CreateForm(TScriptRenderForm, ScriptRenderForm);
  Application.CreateForm(TTemplateForm, TemplateForm);
  Application.UpdateFormatSettings := False;
  DebugSetLogFilePath(LPMAPMCHAR(ExtractFilePath(Application.ExeName) + 'mapm.log'));
  DebugSetLoggingNoticesEnabled(B_TRUE);
  PluginMonitor := TMapmMonitor.Create(ExtractFilePath(Application.ExeName) + 'Plugins');
  PluginMonitor.OnAddPlugin := MapmPluginAdd;
  PluginMonitor.OnRemovePlugin := MapmPluginRemove;
  DecimalSeparator := '.';
  Application.Run;
end.


