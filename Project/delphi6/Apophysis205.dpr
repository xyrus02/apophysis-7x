{
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Borys, Peter Sdobnov     

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
program Apophysis205;

{$SetPEFlags $20} // set LARGE_ADDRESS_AWARE flag!

{%ToDo 'Apophysis205.todo'}

uses
  FastMM4 in '..\..\Source\FastMM4.pas',
  Forms,
  Dialogs,
  SysUtils,
  Main in '..\..\Source\Main.pas' {MainForm},
  Editor in '..\..\Source\Editor.pas' {EditForm},
  Global in '..\..\Source\Global.pas',
  Options in '..\..\Source\Options.pas' {OptionsForm},
  Regstry in '..\..\Source\Regstry.pas',
  Fullscreen in '..\..\Source\Fullscreen.pas' {FullscreenForm},
  FormRender in '..\..\Source\FormRender.pas' {RenderForm},
  Mutate in '..\..\Source\Mutate.pas' {MutateForm},
  Adjust in '..\..\Source\Adjust.pas' {AdjustForm},
  Browser in '..\..\Source\Browser.pas' {GradientBrowser},
  Save in '..\..\Source\Save.pas' {SaveForm},
  About in '..\..\Source\About.pas' {AboutForm},
  Cmap in '..\..\Source\cmap.pas',
  SavePreset in '..\..\Source\SavePreset.pas' {SavePresetForm},
  ControlPoint in '..\..\Source\ControlPoint.pas',
  Tracer in '..\..\Source\Tracer.pas',
  HtmlHlp in '..\..\Source\HtmlHlp.pas',
  Preview in '..\..\Source\Preview.pas' {PreviewForm},
  ScriptForm in '..\..\Source\ScriptForm.pas' {ScriptEditor},
  ScriptRender in '..\..\Source\ScriptRender.pas' {ScriptRenderForm},
  FormFavorites in '..\..\Source\FormFavorites.pas' {FavoritesForm},
  FormExport in '..\..\Source\FormExport.pas' {ExportDialog},
  MsMultiPartFormData in '..\..\Source\MsMultiPartFormData.pas',
  XForm in '..\..\Source\XForm.pas',
  XFormMan in '..\..\Source\XFormMan.pas',
  cmapdata in '..\..\Source\cmapdata.pas',
  GradientHlpr in '..\..\Source\GradientHlpr.pas',
  formPostProcess in '..\..\Source\formPostProcess.pas' {frmPostProcess},
  RndFlame in '..\..\Source\RndFlame.pas',
  bmdll32 in '..\..\Source\bmdll32.PAS',
  ImageColoring in '..\..\Source\ImageColoring.pas' {frmImageColoring},
  BaseVariation in '..\..\Source\BaseVariation.pas',
  ImageMaker in '..\..\Source\ImageMaker.pas',
  CustomDrawControl in '..\..\Source\CustomDrawControl.pas',
  Render in '..\..\Source\Render.pas',
  RenderTypes in '..\..\Source\RenderTypes.pas',
  RenderST in '..\..\Source\RenderST.pas',
  RenderMT in '..\..\Source\RenderMT.pas',
  RenderThread in '..\..\Source\RenderThread.pas',
  BucketFillerThread in '..\..\Source\BucketFillerThread.pas',
  Render64 in '..\..\Source\Render64.pas',
  Render64MT in '..\..\Source\Render64MT.pas',
  Render48 in '..\..\Source\Render48.pas',
  Render48MT in '..\..\Source\Render48MT.pas',
  Render32f in '..\..\Source\Render32f.pas',
  Render32fMT in '..\..\Source\Render32fMT.pas',
  Render32 in '..\..\Source\Render32.pas',
  Render32MT in '..\..\Source\Render32MT.pas',
  FastMM4Messages in '..\..\Source\FastMM4Messages.pas',
  varRadialBlur in '..\..\Source\varRadialBlur.pas',
  varRings2 in '..\..\Source\varRings2.pas',
  varFan2 in '..\..\Source\varFan2.pas',
  varblob in '..\..\Source\varBlob.pas',
  varpdj in '..\..\Source\varPDJ.pas',
  varPerspective in '..\..\Source\varPerspective.pas',
  varJuliaN in '..\..\Source\varJuliaN.pas',
  varJuliaScope in '..\..\Source\varJuliaScope.pas',
  varCurl in '..\..\Source\varCurl.pas';

{$R *.RES}

begin
  if now > EncodeDate(2007, 3, 31) then begin
    ShowMessage('This version has expired. Please go to http://sourceforge.net/project/apophysis and download the latest version.');
    Halt
  end;

  Application.Initialize;
  Application.Title := 'Apophysis';
  Application.HelpFile := 'Apophysis 2.0.chm';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TEditForm, EditForm);
  Application.CreateForm(TOptionsForm, OptionsForm);
  Application.CreateForm(TFullscreenForm, FullscreenForm);
  Application.CreateForm(TRenderForm, RenderForm);
  Application.CreateForm(TMutateForm, MutateForm);
  Application.CreateForm(TAdjustForm, AdjustForm);
  Application.CreateForm(TGradientBrowser, GradientBrowser);
  Application.CreateForm(TSaveForm, SaveForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TSavePresetForm, SavePresetForm);
  Application.CreateForm(TScriptEditor, ScriptEditor);
  Application.CreateForm(TPreviewForm, PreviewForm);
  Application.CreateForm(TScriptRenderForm, ScriptRenderForm);
  Application.CreateForm(TFavoritesForm, FavoritesForm);
  Application.CreateForm(TExportDialog, ExportDialog);
  Application.CreateForm(TfrmPostProcess, frmPostProcess);
  Application.CreateForm(TfrmImageColoring, frmImageColoring);
  Application.CreateForm(TTraceForm, TraceForm);
  Application.UpdateFormatSettings := False;
  DecimalSeparator := '.';
  Application.Run;
end.

