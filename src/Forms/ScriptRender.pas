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
unit ScriptRender;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, RenderThread, cmap, ControlPoint, Translation;

type
  TScriptRenderForm = class(TForm)
    btnCancel: TButton;
    ProgressBar: TProgressBar;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
//    PixelsPerUnit: double;
    StartTime: TDateTime;
    Remainder: TDateTime;

    procedure HandleThreadCompletion(var Message: TMessage);
      message WM_THREAD_COMPLETE;
    procedure HandleThreadTermination(var Message: TMessage);
      message WM_THREAD_TERMINATE;
  public
    Renderer: TRenderThread;
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
  //cp.Width := ScriptEditor.Renderer.Width;
  //cp.Height := ScriptEditor.Renderer.Height;
  cp.AdjustScale(ScriptEditor.Renderer.Width, ScriptEditor.Renderer.Height);
  // --?-- cp.CalcBoundBox;
  cp.center[0] := ScriptEditor.cp.center[0];
  cp.center[1] := ScriptEditor.cp.center[1];
  cp.zoom := ScriptEditor.cp.zoom;
  //PixelsPerUnit := cp.Pixels_per_unit;
end;

procedure TScriptRenderForm.Render;
begin
  assert(not Assigned(Renderer));
  Renderer := TRenderThread.Create;

  Cancelled := False;
  ScriptEditor.Scripter.Paused := True;
  StartTime := Now;
  Remainder := 1;
  cp.copy(ScriptEditor.cp);
  Filename := ScriptEditor.Renderer.Filename;
  //cp.Width := ScriptEditor.Renderer.Width;
  //cp.Height := ScriptEditor.Renderer.Height;
  //cp.pixels_per_unit := PixelsPerUnit;
  cp.AdjustScale(ScriptEditor.Renderer.Width, ScriptEditor.Renderer.Height);
  cp.Transparency := (PNGTransparency <> 0) and (UpperCase(ExtractFileExt(ScriptEditor.Renderer.FileName)) = '.PNG');

  Renderer.OnProgress := OnProgress;
//  Renderer.Compatibility := Compatibility;
  Renderer.SetCP(cp);
  if (ScriptEditor.Renderer.MaxMemory > 0) then Renderer.MaxMem := ScriptEditor.Renderer.MaxMemory;
  Renderer.TargetHandle := Handle;
  renderPath := ExtractFilePath(ScriptEditor.Renderer.Filename);
  Renderer.Priority := tpLower;
  Renderer.NrThreads := NrTreads;
  Renderer.Resume;

//  Renderer.SaveImage(FileName);
//  ScriptEditor.Scripter.Paused := False;
end;

procedure TScriptRenderForm.OnProgress(prog: double);
var
  Elapsed: TDateTime;
begin
  prog := (Renderer.Slice + Prog) / Renderer.NrSlices;
  ProgressBar.Position := round(100 * prog);
  Elapsed := Now - StartTime;
//  if prog > 0 then Remainder := Elapsed * (1/prog - 1);
  //Application.ProcessMessages;
end;

procedure TScriptRenderForm.FormDestroy(Sender: TObject);
begin
  cp.free;
  assert(not Assigned(Renderer)); //if Assigned(Renderer) then Renderer.free;
end;

procedure TScriptRenderForm.FormCreate(Sender: TObject);
begin
  //Renderer := TRenderThread.Create;
  self.Caption := TextByKey('script-rendering');
  btnCancel.Caption := TextByKey('common-cancel');
  cp := TControlPoint.Create;
end;

procedure TScriptRenderForm.btnCancelClick(Sender: TObject);
begin
  ScriptEditor.Scripter.Halt;
  Cancelled := True;
//  Renderer.Stop;
  if Assigned(Renderer) then begin
    Renderer.Terminate;
    Renderer.WaitFor;
    Renderer.Free;
    Renderer := nil;
  end;
  LastError := 'Render cancelled';
end;

procedure TScriptRenderForm.HandleThreadCompletion(var Message: TMessage);
begin
  Renderer.SaveImage(FileName);

  Renderer.Free;
  Renderer := nil;

  ScriptEditor.Scripter.Paused := False;
end;

procedure TScriptRenderForm.HandleThreadTermination(var Message: TMessage);
begin
  if Assigned(Renderer) then
  begin
    Renderer.Free;
    Renderer := nil;
  end;
end;

end.

