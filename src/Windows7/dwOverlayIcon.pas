unit dwOverlayIcon;

interface

uses
  Classes, ImgList,
  dwTaskbarComponents;

type
  TdwOverlayIcon = class(TdwTaskbarComponent)
  private
    FImages: TCustomImageList;
    FImageIndex: Integer;
    FHint: WideString;
    procedure SetImages(const Value: TCustomImageList);
    procedure SetImageIndex(const Value: Integer);
    function DoShowOverlay: Boolean;
    procedure SetHint(const Value: WideString);
  protected
    function DoInitialize: Boolean; override;
    procedure DoUpdate; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property Images: TCustomImageList read FImages write SetImages;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property Hint: WideString read FHint write SetHint;
  end;

implementation

uses
  SysUtils, Graphics;

{ TdwOverlayIcon }

constructor TdwOverlayIcon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FImages := nil;
  FImageIndex := -1;
  FHint := '';
end;

destructor TdwOverlayIcon.Destroy;
begin
  inherited Destroy;
end;

function TdwOverlayIcon.DoInitialize: Boolean;
begin
  Result := DoShowOverlay;
end;

function TdwOverlayIcon.DoShowOverlay: Boolean;
var
  Icon: TIcon;
begin
  if CheckWin32Version(6, 1) and (TaskbarList3 <> nil) then
  begin
    if (FImages = nil) or (FImageIndex < 0) or (FImageIndex >= FImages.Count) then
    begin
      TaskbarList3.SetOverlayIcon(TaskBarEntryHandle, 0, nil);
      Result := True;
    end
    else
    begin
      Icon := TIcon.Create;
      try
        FImages.GetIcon(FImageIndex, Icon);
        TaskbarList3.SetOverlayIcon(TaskBarEntryHandle, Icon.ReleaseHandle, PWideChar(FHint));
        Result := True;
      finally
       Icon.Free;
      end;
    end;
  end
  else
  begin
    Result := False;
  end;
end;

procedure TdwOverlayIcon.DoUpdate;
begin
  DoShowOverlay;
end;

procedure TdwOverlayIcon.SetHint(const Value: WideString);
begin
  if FHint <> Value then
  begin
    FHint := Value;
    SendUpdateMessage;
  end;
end;

procedure TdwOverlayIcon.SetImageIndex(const Value: Integer);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    SendUpdateMessage;
  end;
end;

procedure TdwOverlayIcon.SetImages(const Value: TCustomImageList);
begin
  FImages := Value;
  SendUpdateMessage;
end;

end.
