unit Curves;

interface

uses Windows, Classes, Graphics, Forms, Controls, CurvesControl, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, ControlPoint, Registry, Global;

type
  TCurvesForm = class(TForm)
    CurvesPanel: TPanel;
    cbChannel: TComboBox;
    tbWeightLeft: TScrollBar;
    tbWeightRight: TScrollBar;
    Panel2: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure cbChannelChange(Sender: TObject);
    procedure tbWeightChange(Sender: TObject);
    procedure tbWeightScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  published
    CurvesControl: TCurvesControl;
  public
    procedure SetCp(cp: TControlPoint);
  end;

var
  CurvesForm: TCurvesForm;

implementation

uses Main;

{$R *.DFM}

procedure TCurvesForm.tbWeightScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
  if ScrollCode = scEndScroll then
    CurvesControl.UpdateFlame;
end;

procedure TCurvesForm.SetCp(cp: TControlPoint);
begin
  if CurvesControl = nil then Exit;
  CurvesControl.SetCp(cp);
end;

procedure TCurvesForm.cbChannelChange(Sender: TObject);
begin
  if CurvesControl = nil then Exit;
  CurvesControl.ActiveChannel := TCurvesChannel(cbChannel.ItemIndex);
  tbWeightLeft.Position := Round(CurvesControl.WeightLeft * 10);
  tbWeightRight.Position := Round(CurvesControl.WeightRight * 10);
end;

procedure TCurvesForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Registry: TRegistry;
begin
  { Write position to registry }
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('\Software\' + APP_NAME + '\Forms\Curves', True) then
    begin
      Registry.WriteInteger('Top', self.Top);
      Registry.WriteInteger('Left', self.Left);
    end;
  finally
    Registry.Free;
  end;
//  bStop := True;
end;

procedure TCurvesForm.FormCreate(Sender: TObject);
begin
  //
end;

procedure TCurvesForm.FormShow(Sender: TObject);
var Registry: TRegistry;
begin
  if not (assigned(curvesControl)) then
  begin
    CurvesControl := TCurvesControl.Create(self);
    CurvesControl.Align := alClient;
    CurvesControl.Parent := CurvesPanel;
  end;

  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey('Software\' + APP_NAME + '\Forms\Curves', False) then
    begin
      if Registry.ValueExists('Left') then
        self.Left := Registry.ReadInteger('Left');
      if Registry.ValueExists('Top') then
        self.Top := Registry.ReadInteger('Top');
      Registry.CloseKey;
    end;
  finally
    Registry.Free;
  end;

  tbWeightLeft.Position := Round(CurvesControl.WeightLeft * 10);
  tbWeightRight.Position := Round(CurvesControl.WeightRight * 10);

  SetCp(MainCp);
end;

procedure TCurvesForm.tbWeightChange(Sender: TObject);
begin
  CurvesControl.WeightLeft := tbWeightLeft.Position / 10.0;
  CurvesControl.WeightRight := tbWeightRight.Position / 10.0;
end;

end.
