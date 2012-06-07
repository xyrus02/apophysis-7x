unit SplashForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Global;

type
  TSplashWindow = class(TForm)
    BackgroundImage: TImage;
    lblVersion: TLabel;
    lblInfo: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure SetInfo(info:string);
  end;

var
  SplashWindow: TSplashWindow;

implementation

{$R *.dfm}

procedure TSplashWindow.FormCreate(Sender: TObject);
begin
  lblVersion.Caption := APP_VERSION + APP_BUILD;
end;

procedure TSplashWindow.SetInfo(info:string);
begin
  lblInfo.Caption := info;
  //Application.ProcessMessages;
end;

end.
