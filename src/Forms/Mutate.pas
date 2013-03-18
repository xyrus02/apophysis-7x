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
unit Mutate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ControlPoint, ComCtrls, Menus, Buttons, Cmap,
  RenderingInterface, Translation, Curves;

type
  TMutateForm = class(TForm)
    GroupBox1: TGroupBox;
    Timer: TTimer;
    GroupBox2: TGroupBox;
    scrollTime: TScrollBar;
    cmbTrend: TComboBox;
    chkSameNum: TCheckBox;
    QualityPopup: TPopupMenu;
    mnuLowQuality: TMenuItem;
    mnuMediumQuality: TMenuItem;
    mnuHighQuality: TMenuItem;
    N3: TMenuItem;
    mnuResetLocation: TMenuItem;
    mnuBack: TMenuItem;
    N1: TMenuItem;
    mnuMaintainSym: TMenuItem;
    N2: TMenuItem;
    Panel10: TPanel;
    Panel6: TPanel;
    Image6: TImage;
    Panel7: TPanel;
    Image7: TImage;
    Panel4: TPanel;
    Image4: TImage;
    Panel0: TPanel;
    Image0: TImage;
    Panel8: TPanel;
    Image8: TImage;
    Panel3: TPanel;
    Image3: TImage;
    Panel2: TPanel;
    Image2: TImage;
    Panel1: TPanel;
    Image1: TImage;
    Panel5: TPanel;
    Image5: TImage;
    pnlSpeed: TPanel;
    txtTime: TEdit;
    pnlTrend: TPanel;
    procedure Panel10Resize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Image0Click(Sender: TObject);
    procedure MutantClick(Sender: TObject);
    procedure sbTimeChange(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure scrollTimeChange(Sender: TObject);
    procedure cmbTrendChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure mnuHighQualityClick(Sender: TObject);
    procedure mnuLowQualityClick(Sender: TObject);
    procedure mnuMediumQualityClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkSameNumClick(Sender: TObject);
    procedure mnuResetLocationClick(Sender: TObject);
    procedure mnuBackClick(Sender: TObject);
    procedure mnuMaintainSymClick(Sender: TObject);
  private
    name, nick, url: string;
    bm: TBitmap;
    PreviewDensity: double;
    Updating: boolean;
    cps: array[0..8] of TControlPoint;
    Mutants: array[0..8] of TControlPoint;
    Render: TRenderer;
    Time: double;
    bstop: boolean;
    brightness, gamma, vibrancy: double;
    seed, InitSeed: integer;
    procedure RandomSet;
    procedure ShowMain;
    procedure ShowMutants;
    procedure Interpolate;
  public
    Zoom: Double;
    Center: array[0..1] of double;
    cmap: TColorMap;
    procedure UpdateDisplay;
    procedure UpdateFlame;
  end;

var
  MutateForm: TMutateForm;

implementation

uses
  Main, Global, Registry, Editor, Adjust, XFormMan;

{$R *.DFM}

procedure TMutateForm.UpdateFlame;
begin
  MainForm.StopThread;
  MainForm.UpdateUndo;
  MainCp.Copy(cps[0]);
  Transforms := MainCp.TrianglesFromCP(MainTriangles);
  MainCp.cmap := cmap;
  MainCp.name := name; // this is kinda funny,
  MainCp.nick := nick; // like author's nick can change during mutation?
  mainCp.url := url;   // hee-heheee :-)
  if mnuResetLocation.checked then
  begin
    MainForm.Mainzoom := cps[0].zoom;
    MainForm.Center[0] := cps[0].Center[0];
    MainForm.Center[1] := cps[0].Center[1];
  end;
  MainForm.RedrawTimer.enabled := true;
  if EditForm.Visible then EditForm.UpdateDisplay;
//  if AdjustForm.Visible then AdjustForm.UpdateDisplay;
end;

procedure TMutateForm.UpdateDisplay;
begin
  cps[0].copy(MainCp);
  cps[0].AdjustScale(Image0.Width, Image0.Height);
  cps[0].cmap := MainCp.cmap;
  cmap := MainCp.cmap;
  name := Maincp.name;
  nick := maincp.nick;
  url := maincp.url;
  zoom := MainCp.zoom;
  center[0] := MainCp.center[0];
  center[1] := MainCp.center[1];
  vibrancy := cps[0].vibrancy;
  gamma := cps[0].gamma;
  brightness := cps[0].brightness;
  Interpolate;
  ShowMain;
  Application.ProcessMessages;
  ShowMutants;
end;

procedure TMutateForm.ShowMain;
begin
  cps[0].Width := Image0.Width;
  cps[0].Height := Image0.Height;
  cps[0].spatial_oversample := defOversample;
  cps[0].spatial_filter_radius := defFilterRadius;
  cps[0].sample_density := PreviewDensity;
  cps[0].brightness := brightness;
  cps[0].gamma := gamma;
  cps[0].vibrancy := vibrancy;
  cps[0].sample_density := PreviewDensity;
  cps[0].cmap := cmap;
  cps[0].background := MainCp.background;
  if mnuResetLocation.checked then begin
    cps[0].CalcBoundbox;
    zoom := 0;
    center[0] := cps[0].center[0];
    center[1] := cps[0].Center[1];
  end;
  cps[0].zoom := zoom;
  cps[0].center[0] := center[0];
  cps[0].center[1] := center[1];
//  Render.Compatibility := compatibility;
  Render.SetCP(cps[0]);
  Render.Render;
  BM.Assign(Render.GetImage);
  Image0.Picture.Graphic := bm;
end;

procedure TMutateForm.ShowMutants;
var
  i: integer;
begin
  if Visible = false then exit;

  Updating := true;
  for i := 1 to 8 do
  begin
    mutants[i].Width := Image1.Width;
    mutants[i].Height := Image1.Height;
    mutants[i].spatial_filter_radius := defFilterRadius;
    mutants[i].spatial_oversample := defOversample;
    mutants[i].sample_density := PreviewDensity;
    mutants[i].brightness := brightness;
    mutants[i].gamma := gamma;
    mutants[i].vibrancy := vibrancy;

{    mutants[i].zoom := 0;
    mutants[i].CalcBoundbox;
    if not mnuResetLocation.checked then begin
      mutants[i].zoom := MainCp.zoom;
      mutants[i].CalcBoundbox;
      mutants[i].center[0] := MainCp.Center[0];
      mutants[i].center[1] := MainCp.Center[1];
    end;
{    if mnuResetLocation.checked then begin
      mutants[i].CalcBoundbox;
      zoom := 0;
      center[0] := cps[0].center[0];
      center[1] := cps[0].Center[1];
    end;
}

    if mnuResetLocation.checked then
    begin
      mutants[i].CalcBoundbox;
      mutants[i].zoom := 0;
//    center[0] := cps[0].center[0];
//    center[1] := cps[0].Center[1];
    end
    else begin
      mutants[i].zoom := zoom;
      mutants[i].center[0] := center[0];
      mutants[i].center[1] := center[1];
    end;

//    Render.Compatibility := compatibility;
    Render.SetCP(mutants[i]);
    Render.Render;
    BM.Assign(Render.GetImage);
    case i of
      1: begin
          Image1.Picture.Graphic := bm;
          Image1.Refresh;
        end;
      2: begin
          Image2.Picture.Graphic := bm;
          Image2.Refresh;
        end;
      3: begin
          Image3.Picture.Graphic := bm;
          Image3.Refresh;
        end;
      4: begin
          Image4.Picture.Graphic := bm;
          Image4.Refresh;
        end;
      5: begin
          Image5.Picture.Graphic := bm;
          Image5.Refresh;
        end;
      6: begin
          Image6.Picture.Graphic := bm;
          Image6.Refresh;
        end;
      7: begin
          Image7.Picture.Graphic := bm;
          Image7.Refresh;
        end;
      8: begin
          Image8.Picture.Graphic := bm;
          Image8.Refresh;
        end;
    end;
    Updating := false;
  end;
end;

procedure TMutateForm.Interpolate;
var i, j, k: Integer;
begin
  if MainCp = nil then Exit;
  
  for i := 1 to 8 do
  begin
    if bstop then exit;
    cps[0].Time := 0;
    cps[i].Time := 1;
    (* -X- something is not right here...
      Mutants[i] may be destroyed already
      Investigate? *)
    Mutants[i].clear;
    Mutants[i].InterpolateX(cps[0], cps[i], Time / 100);
    Mutants[i].cmapindex := cps[0].cmapindex;
    Mutants[i].cmap := cps[0].cmap;
    Mutants[i].background := MainCp.background;
    if mnuMaintainSym.Checked then // maintain symmetry
    begin
      for j := 0 to transforms - 1 do
      begin
        if cps[0].xform[j].Symmetry = 1 then
        begin
          mutants[i].xform[j].Assign(cps[0].xform[j]);
{
          mutants[i].xform[j].Symmetry := 1;
          mutants[i].xform[j].Color := cps[0].xform[j].color;
          mutants[i].xform[j].Density := cps[0].xform[j].Density;
          mutants[i].xform[j].c[0][0] := cps[0].xform[j].c[0][0];
          mutants[i].xform[j].c[0][1] := cps[0].xform[j].c[0][1];
          mutants[i].xform[j].c[1][0] := cps[0].xform[j].c[1][0];
          mutants[i].xform[j].c[1][1] := cps[0].xform[j].c[1][1];
          mutants[i].xform[j].c[2][0] := cps[0].xform[j].c[2][0];
          mutants[i].xform[j].c[2][1] := cps[0].xform[j].c[2][1];
          for k := 0 to NRVAR - 1 do
            mutants[i].xform[j].vars[k] := cps[0].xform[j].vars[k];
}
        end;
      end;
    end;
  end;
end;

procedure TMutateForm.RandomSet;
var i: Integer;
begin
  RandSeed := seed;
  for i := 1 to 8 do
  begin
    cps[i].clear;
    if chkSameNum.checked then
      cps[i].RandomCP(transforms, transforms, false)
    else
      cps[i].RandomCP(mutantMinTransforms, mutantMaxTransforms, false);
    cps[i].SetVariation(TVariation(cmbTrend.Items.Objects[cmbTrend.ItemIndex]));
    if cps[0].HasFinalXForm = false then
    begin
      cps[i].xform[cps[i].NumXForms].Clear;
      cps[i].xform[cps[i].NumXForms].symmetry := 1;
    end;
  end;
  Interpolate;
end;

procedure TMutateForm.FormShow(Sender: TObject);
var
  Registry: TRegistry;
begin
  { Read posution from registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('Software\' + APP_NAME + '\Forms\Mutate', False) then
    begin
      if Registry.ValueExists('Left') then
        MutateForm.Left := Registry.ReadInteger('Left');
      if Registry.ValueExists('Top') then
        MutateForm.Top := Registry.ReadInteger('Top');
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
  if (cps[0].xform[0].density <> 0) and Assigned(MainCp) then begin // hmm...!?
    Interpolate;
    ShowMain;
    ShowMutants;
  end;
end;

procedure TMutateForm.FormCreate(Sender: TObject);
var
  i: integer;
begin
	self.Caption := TextByKey('mutation-title');
	GroupBox1.Caption := TextByKey('mutation-directions');
	pnlSpeed.Caption := TextByKey('mutation-speed');
	pnlTrend.Caption := TextByKey('mutation-trend');
	chkSameNum.Caption := TextByKey('mutation-keepnumberoftransforms');
  mnuLowQuality.Caption := TextByKey('common-lowquality');
	mnuMediumQuality.Caption := TextByKey('common-mediumquality');
	mnuHighQuality.Caption := TextByKey('common-highquality');
	mnuResetLocation.Caption := TextByKey('common-resetlocation');
	mnuMaintainSym.Caption := TextByKey('mutation-maintainsymmetry');
	mnuBack.Caption := TextByKey('mutation-previous');
  cmbTrend.Items.clear;
  cmbTrend.AddItem(TextByKey('mutation-randomtrend'), Tobject(vRandom));
  for i:= 0 to NRVAR -1 do begin
    cmbTrend.AddItem(varnames(i), Tobject(i));
  end;

  bm := TBitMap.Create;
  case MutatePrevQual of
    0: begin
        mnuLowQuality.Checked := true;
        PreviewDensity := prevLowQuality;
      end;
    1: begin
        mnuMediumQuality.Checked := true;
        PreviewDensity := prevMediumQuality;
      end;
    2: begin
        mnuHighQuality.Checked := true;
        PreviewDensity := prevHighQuality;
      end;
  end;
  Render := TRenderer.Create;
  for i := 0 to 8 do
  begin
    cps[i] := TControlPoint.Create;
    Mutants[i] := TControlPoint.Create;
  end;
  Time := 35;
  scrollTime.Position := 25;
  cmbTrend.ItemIndex := 0;
  InitSeed := random(1234567890);
  seed := InitSeed;
  RandomSet;
end;

procedure TMutateForm.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  Render.Stop;
  Render.Free;
  for i := 0 to 8 do
  begin
    cps[i].Free;
    Mutants[i].Free;
  end;
  bm.free;
end;

procedure TMutateForm.Image0Click(Sender: TObject);
begin
  Render.Stop;
  mnuBack.Enabled := true;
  inc(seed);
  RandomSet;
  ShowMutants;
end;

procedure TMutateForm.MutantClick(Sender: TObject);
var
  i, j: integer;
  cpt: TControlPoint;
begin
  cpt := TControlPoint.Create;
  cpt.Copy(cps[0]);
  bstop := true;
  if sender = Image1 then
  begin
    cps[0].Time := 0;
    cps[1].Time := 1;
    cps[0].Interpolatex(cps[0], cps[1], Time / 100);
  end
  else if sender = Image2 then
  begin
    cps[0].Time := 0;
    cps[2].Time := 1;
    cps[0].Interpolatex(cps[0], cps[2], Time / 100);
  end
  else if sender = Image3 then
  begin
    cps[0].Time := 0;
    cps[3].Time := 1;
    cps[0].InterpolateX(cps[0], cps[3], Time / 100);
  end
  else if sender = Image4 then
  begin
    cps[0].Time := 0;
    cps[4].Time := 1;
    cps[0].Interpolatex(cps[0], cps[4], Time / 100);
  end
  else if sender = Image5 then
  begin
    cps[0].Time := 0;
    cps[5].Time := 1;
    cps[0].Interpolatex(cps[0], cps[5], Time / 100);
  end
  else if sender = Image6 then
  begin
    cps[0].Time := 0;
    cps[6].Time := 1;
    cps[0].Interpolatex(cps[0], cps[6], Time / 100);
  end
  else if sender = Image7 then
  begin
    cps[0].Time := 0;
    cps[7].Time := 1;
    cps[0].Interpolatex(cps[0], cps[7], Time / 100);
  end
  else if sender = Image8 then
  begin
    cps[0].Time := 0;
    cps[8].Time := 1;
    cps[0].Interpolatex(cps[0], cps[8], Time / 100);
  end;

  if mnuMaintainSym.Checked then // maintain symmetry
  begin
    for i := 0 to transforms - 1 do
    begin
      if cpt.xform[i].Symmetry = 1 then
      begin
        cps[0].xform[i].Assign(cpt.xform[i]);
{
        cps[0].xform[i].Symmetry := 1;
        cps[0].xform[i].Color := cpt.xform[i].color;
        cps[0].xform[i].Density := cpt.xform[i].Density;
        cps[0].xform[i].c[0][0] := cpt.xform[i].c[0][0];
        cps[0].xform[i].c[0][1] := cpt.xform[i].c[0][1];
        cps[0].xform[i].c[1][0] := cpt.xform[i].c[1][0];
        cps[0].xform[i].c[1][1] := cpt.xform[i].c[1][1];
        cps[0].xform[i].c[2][0] := cpt.xform[i].c[2][0];
        cps[0].xform[i].c[2][1] := cpt.xform[i].c[2][1];
        for j := 0 to NRVAR - 1 do
          cps[0].xform[i].vars[j] := cpt.xform[i].vars[j];
}
      end;
    end;
  end;

  bstop := false;
  ShowMain;
  Interpolate;
  ShowMutants;
  UpdateFlame;
  cpt.free;
end;

procedure TMutateForm.sbTimeChange(Sender: TObject);
begin
  bstop := true;
  Render.Stop;
  Time := scrollTime.Position;
  bstop := false;
  Interpolate;
  ShowMutants;
end;

procedure TMutateForm.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := false;
  if (Time <> scrollTime.Position) and (not updating) then
  begin
    Time := scrollTime.Position;
    Interpolate;
    ShowMutants;
  end;
end;

procedure TMutateForm.scrollTimeChange(Sender: TObject);
begin
  Timer.Enabled := true;
  txtTime.Text := FloatToStr(scrollTime.Position / 100);
end;

procedure TMutateForm.cmbTrendChange(Sender: TObject);
var
  i: integer;
begin
  for i := 1 to 8 do begin
    cps[i].SetVariation(TVariation(cmbTrend.Items.Objects[cmbTrend.ItemIndex]));
  end;

  Interpolate;
  ShowMutants;
end;

procedure TMutateForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TMutateForm.mnuHighQualityClick(Sender: TObject);
begin
  mnuHighQuality.Checked := True;
  PreviewDensity := prevHighQuality;
  MutatePrevQual := 2;
  ShowMain;
  ShowMutants;
end;

procedure TMutateForm.mnuLowQualityClick(Sender: TObject);
begin
  mnuLowQuality.Checked := True;
  PreviewDensity := prevLowQuality;
  MutatePrevQual := 0;
  ShowMain;
  ShowMutants;
end;

procedure TMutateForm.mnuMediumQualityClick(Sender: TObject);
begin
  mnuMediumQuality.Checked := True;
  PreviewDensity := prevMediumQuality;
  MutatePrevQual := 1;
  ShowMain;
  ShowMutants;
end;

procedure TMutateForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Registry: TRegistry;
begin
  { Write position to registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('\Software\' + APP_NAME + '\Forms\Mutate', True) then
    begin
      Registry.WriteInteger('Top', MutateForm.Top);
      Registry.WriteInteger('Left', MutateForm.Left);
    end;
  finally
    Registry.Free;
  end;
end;

procedure TMutateForm.chkSameNumClick(Sender: TObject);
begin
  RandomSet;
  Interpolate;
  ShowMutants;
end;

procedure TMutateForm.mnuResetLocationClick(Sender: TObject);
begin
  mnuResetLocation.Checked := not mnuResetLocation.Checked;
  if not mnuResetLocation.checked then
  begin
    cps[0].width := MainCp.width;
    cps[0].height := MainCp.height;
    cps[0].pixels_per_unit := MainCp.pixels_per_unit;
    cps[0].AdjustScale(Image0.width, Image0.Height);
    cps[0].zoom := MainCp.zoom;
    cps[0].center[0] := MainCp.center[0];
    cps[0].center[1] := MainCp.center[1];
    zoom := cps[0].zoom;
    center[0] := cps[0].center[0];
    center[1] := cps[0].center[1];
  end;
  ShowMain;
  ShowMutants;
end;

procedure TMutateForm.mnuBackClick(Sender: TObject);
begin
  Render.Stop;
  if seed > InitSeed then
    dec(seed);
  if seed = InitSeed then mnuBack.enabled := false;
  RandomSet;
  ShowMutants;
end;

procedure TMutateForm.mnuMaintainSymClick(Sender: TObject);
begin
  mnuMaintainSym.Checked := not mnuMaintainSym.Checked;
  Interpolate;
  ShowMutants;
end;

procedure TMutateForm.Panel10Resize(Sender: TObject);
const gap:integer = 4 ;
var
  w, h : integer;
begin
  w := (Panel10.Width - 2*gap) div 3;
  h := (Panel10.Height - 2*gap) div 3;
  
  Panel0.Width := w; Panel1.Width := w; Panel2.Width := w;
  Panel3.Width := w; Panel4.Width := w; Panel5.Width := w;
  Panel6.Width := w; Panel7.Width := w; Panel8.Width := w;
  Panel0.Height := h; Panel1.Height := h; Panel2.Height := h;
  Panel3.Height := h; Panel4.Height := h; Panel5.Height := h;
  Panel6.Height := h; Panel7.Height := h; Panel8.Height := h;

  Panel2.Left := w + gap; Panel0.Left := w + gap; Panel6.Left := w + gap;
  Panel3.Left := 2*(w + gap); Panel4.Left := 2*(w + gap); Panel5.Left := 2*(w + gap);

  Panel8.Top := h + gap; Panel0.Top := h + gap; Panel4.Top := h + gap;
  Panel7.Top := 2*(h + gap); Panel6.Top := 2*(h + gap); Panel5.Top := 2*(h + gap);
end;

end.


