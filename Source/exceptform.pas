unit exceptform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmException = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure AddLine(s: string);
  end;

var
  frmException: TfrmException;

implementation

{$R *.dfm}

{ TForm1 }

procedure TfrmException.AddLine(s: string);
begin
  Memo1.Lines.Add(s);
end;

procedure TfrmException.Button1Click(Sender: TObject);
begin
  Halt;
end;

initialization
  frmException := TfrmException.Create(nil);
finalization
  frmException.Free;
end.
