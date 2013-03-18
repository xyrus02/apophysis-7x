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

unit Tracer;

{$define TRACEFORM_HIDDEN}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TTraceForm = class(TForm)
    PageControl1: TPageControl;
    TabMain: TTabSheet;
    TabFullscreen: TTabSheet;
    FullscreenTrace: TMemo;
    cbTraceLevel: TComboBox;
    MainTrace: TMemo;
    procedure cbTraceLevelSelect(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TraceForm: TTraceForm;

var
  TraceLevel: integer;

const
  MsgComplete = '< Received WM_THREAD_COMPLETE from RenderThread #';
  MsgTerminated = '< Received WM_THREAD_TERMINATE from RenderThread #';
  MsgNotAssigned = 'Ignoring message: RenderThread does not exist';
  MsgAnotherRunning = 'Ignoring message: another RenderThread is running';

implementation

{$R *.dfm}

uses
  Registry,
  Global, Main;

procedure TTraceForm.cbTraceLevelSelect(Sender: TObject);
begin
  TraceLevel := cbTraceLevel.ItemIndex;
end;

procedure TTraceForm.FormCreate(Sender: TObject);
var
  Registry: TRegistry;
begin
  { Read position from registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('Software\' + APP_NAME + '\Forms\Trace', False) then
    begin
      if Registry.ValueExists('Top') then
        self.Top := Registry.ReadInteger('Top');
      if Registry.ValueExists('Left') then
        self.Left := Registry.ReadInteger('Left');
      if Registry.ValueExists('Width') then
        self.Width := Registry.ReadInteger('Width');
      if Registry.ValueExists('Height') then
        self.Height := Registry.ReadInteger('Height');

{$ifndef TRACEFORM_HIDDEN}

      if Registry.ValueExists('TraceLevel') then
        TraceLevel := Registry.ReadInteger('TraceLevel')
      else
        TraceLevel := 0;
      MainForm.tbShowTrace.Visible := true;
      MainForm.tbShowTrace.Enabled := true;
      MainForm.tbTraceSeparator.Visible := true;
      MainForm.tbTraceSeparator.Enabled := true;

{$else} // Tracer disabled in release version

      TraceLevel := 0;
      //MainForm.tbShowTrace.Visible := false;
      //MainForm.tbShowTrace.Enabled := false;
      //MainForm.tbTraceSeparator.Visible := false;
      //MainForm.tbTraceSeparator.Enabled := false;

{$endif}

    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;

  cbTraceLevel.ItemIndex := TraceLevel;
end;

procedure TTraceForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Registry: TRegistry;
begin
  { Write position to registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('\Software\' + APP_NAME + '\Forms\Trace', True) then
    begin
      if self.WindowState <> wsMaximized then begin
        Registry.WriteInteger('Top', self.Top);
        Registry.WriteInteger('Left', self.Left);
        Registry.WriteInteger('Width', self.Width);
        Registry.WriteInteger('Height', self.Height);

        Registry.WriteInteger('TraceLevel', TraceLevel);
      end;
    end;
  finally
    Registry.Free;
  end;
end;

end.
