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

{%File '..\..\readme.txt'}
{%File '..\..\Changes.txt'}

uses
  Forms,
  SysUtils,
  Main in '..\..\Source\Main.pas' {MainForm},
  Editor in '..\..\Source\Editor.pas' {EditForm},
  Global in '..\..\Source\Global.pas',
  Options in '..\..\Source\Options.pas' {OptionsForm},
  Regstry in '..\..\Source\Regstry.pas',
  MyTypes in '..\..\Source\MyTypes.pas',
  Fullscreen in '..\..\Source\Fullscreen.pas' {FullscreenForm},
  FormRender in '..\..\Source\FormRender.pas' {RenderForm},
  Mutate in '..\..\Source\Mutate.pas' {MutateForm},
  Adjust in '..\..\Source\Adjust.pas' {AdjustForm},
  Browser in '..\..\Source\Browser.pas' {GradientBrowser},
  Gradient in '..\..\Source\Gradient.pas' {GradientForm},
  Save in '..\..\Source\Save.pas' {SaveForm},
  About in '..\..\Source\About.pas' {AboutForm},
  cmap in '..\..\Source\cmap.pas',
  SavePreset in '..\..\Source\SavePreset.pas' {SavePresetForm},
  ControlPoint in '..\..\Source\ControlPoint.pas',
  HtmlHlp in '..\..\Source\HtmlHlp.pas',
  ScriptForm in '..\..\Source\ScriptForm.pas' {ScriptEditor},
  Preview in '..\..\Source\Preview.pas' {PreviewForm},
  ScriptRender in '..\..\Source\ScriptRender.pas' {ScriptRenderForm},
  FormFavorites in '..\..\Source\FormFavorites.pas' {FavoritesForm},
  Size in '..\..\Source\Size.pas' {SizeTool},
  FormExport in '..\..\Source\FormExport.pas' {ExportDialog},
  MsMultiPartFormData in '..\..\Source\MsMultiPartFormData.pas',
  Sheep in '..\..\Source\Sheep.pas' {SheepDialog},
  XForm in '..\..\Source\XForm.pas',
  RenderThread in '..\..\Source\RenderThread.pas',
  Render in '..\..\Source\Render.pas',
  Render32 in '..\..\Source\Render32.pas',
  Render64 in '..\..\Source\Render64.pas',
  RenderMM in '..\..\Source\RenderMM.pas',
  ImageColoring in '..\..\Source\ImageColoring.pas' {frmImageColoring},
  GradientHlpr in '..\..\Source\GradientHlpr.pas',
  RndFlame in '..\..\Source\RndFlame.pas';

//  ImageColoring in '..\..\Source\ImageColoring.pas' {frmImageColoring};

{$R *.RES}

begin
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
  Application.CreateForm(TGradientForm, GradientForm);
  Application.CreateForm(TSaveForm, SaveForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TSavePresetForm, SavePresetForm);
  Application.CreateForm(TScriptEditor, ScriptEditor);
  Application.CreateForm(TPreviewForm, PreviewForm);
  Application.CreateForm(TScriptRenderForm, ScriptRenderForm);
  Application.CreateForm(TFavoritesForm, FavoritesForm);
  Application.CreateForm(TSizeTool, SizeTool);
  Application.CreateForm(TExportDialog, ExportDialog);
  Application.CreateForm(TSheepDialog, SheepDialog);
  //  Application.CreateForm(TfrmImageColoring, frmImageColoring);
  Application.UpdateFormatSettings := False;
  DecimalSeparator := '.';
  Application.Run;
end.

