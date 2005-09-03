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
unit ScriptRender;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Render, cmap, ControlPoint;

const
  WM_THREAD_COMPLETE = WM_APP + 5437;
  WM_THREAD_TERMINATE = WM_APP + 5438;


type
  TScriptRenderForm = class(TForm)
    btnCancel: TButton;
    ProgressBar: TProgressBar;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    PixelsPerUnit: double;
    StartTime: TDateTime;
    Remainder: TDateTime;
  public
    Renderer: TRenderer;
    ColorMap: TColorMap;
    cp: TControlPoint;
    Filename: string;
    ImageWidth, ImageHeight, Oversample: Integer;
    zoom, Sample_Density, Brightness, Gamma, Vibrancy, Filter_Radius: double;
    center: array[0..1] of double;
    procedure OnProgress(prog: double);
    procedure Render;
    procedure SetRenderBounds;
  end;

var
  ScriptRenderForm: TScriptRenderForm;
  Cancelled: boolean;

implementation

uses Global, Math, FormRender, ScriptForm;
{$R *.DFM}

procedure TScriptRenderForm.SetRenderBounds;
begin
  cp.copy(ScriptEditor.cp);
  cp.Width := ScriptEditor.Renderer.Width;
  cp.Height := ScriptEditor.Renderer.Height;
  cp.CalcBoundBox;
  cp.center[0] := ScriptEditor.cp.center[0];
  cp.center[1] := ScriptEditor.cp.center[1];
  cp.zoom := ScriptEditor.cp.zoom;
  PixelsPerUnit := cp.Pixels_per_unit;
end;

procedure TScriptRenderForm.Render;
begin
  Cancelled := False;
  ScriptEditor.Scripter.Paused := True;
  StartTime := Now;
  Remainder := 1;
  cp.copy(ScriptEditor.cp);
  Filename := ScriptEditor.Renderer.Filename;
  cp.Width := ScriptEditor.Renderer.Width;
  cp.Height := ScriptEditor.Renderer.Height;
  cp.pixels_per_unit := PixelsPerUnit;
  Renderer.OnProgress := OnProgress;
  Renderer.Compatibility := Compatibility;  
  Renderer.SetCP(cp);
  if (ScriptEditor.Renderer.MaxMemory > 0) then
    Renderer.RenderMaxMem(ScriptEditor.Renderer.MaxMemory)
  else Renderer.Render;
  Renderer.SaveImage(FileName);
  ScriptEditor.Scripter.Paused := False;
end;

procedure TScriptRenderForm.OnProgress(prog: double);
var
  Elapsed: TDateTime;
begin
  prog := (Renderer.Slice + Prog) / Renderer.NrSlices;
  ProgressBar.Position := round(100 * prog);
  Elapsed := Now - StartTime;
  if prog > 0 then
    Remainder := Min(Remainder, Elapsed * (power(1 / prog, 1.2) - 1));
  Application.ProcessMessages;
end;

procedure TScriptRenderForm.FormDestroy(Sender: TObject);
begin
  cp.free;
  Renderer.free;
end;

procedure TScriptRenderForm.FormCreate(Sender: TObject);
begin
  Renderer := TRenderer.Create;
  cp := TControlPoint.Create;
end;

procedure TScriptRenderForm.btnCancelClick(Sender: TObject);
begin
  ScriptEditor.Scripter.Halt;
  Cancelled := True;
  Renderer.Stop;
  LastError := 'Render cancelled';
end;

end.

