unit dwTaskbarThumbnails;

interface

uses
  Classes, Messages, ImgList, AppEvnts, Windows,
  dwTaskbarComponents, dwTaskbarList;

type
  TdwTaskbarThumbnails = class;
  TdwTaskbarThumbnailList = class;
  TdwTaskbarThumbnailItem = class;

  TOnThumbnailClick = procedure(Sender: TdwTaskbarThumbnailItem) of object;

  TdwTaskbarThumbnailItem = class(TCollectionItem)
  private
    FImageIndex: Integer;
    FHint: WideString;
    FEnabled: Boolean;
    FShowBorder: Boolean;
    FDismissOnClick: Boolean;
    FVisible: Boolean;
    FTag: Integer;
    procedure SetImageIndex(const Value: Integer);
    procedure SetHint(const Value: WideString);
    procedure SetEnabled(const Value: Boolean);
    procedure SetShowBorder(const Value: Boolean);
    procedure SetDismissOnClick(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
  protected
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property Hint: WideString read FHint write SetHint;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property ShowBorder: Boolean read FShowBorder write SetShowBorder default True;
    property DismissOnClick: Boolean read FDismissOnClick write SetDismissOnClick default False;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Tag: Integer read FTag write FTag default 0;
  end;

  TdwTaskbarThumbnailList = class(TCollection)
  private
    FTaskbarThumbnails: TdwTaskbarThumbnails;
    function GetItem(Index: Integer): TdwTaskbarThumbnailItem;
    procedure SetItem(Index: Integer; Value: TdwTaskbarThumbnailItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(TaskbarThumbnails: TdwTaskbarThumbnails);
    function Add: TdwTaskbarThumbnailItem;
    function AddItem(Item: TdwTaskbarThumbnailItem; Index: Integer): TdwTaskbarThumbnailItem;
    function Insert(Index: Integer): TdwTaskbarThumbnailItem;
    property Items[Index: Integer]: TdwTaskbarThumbnailItem read GetItem write SetItem; default;
  end;

  TdwTaskbarThumbnails = class(TdwTaskbarComponent)
  private
    FAppEvents: TApplicationEvents;

    FImages: TCustomImageList;
    FThumbnails: TdwTaskbarThumbnailList;
    FOnThumbnailClick: TOnThumbnailClick;
    procedure SetImages(const Value: TCustomImageList);
    procedure UpdateThumbnail(Index: Integer);
    procedure UpdateThumbnails;
    procedure SetThumbnails(const Value: TdwTaskbarThumbnailList);
    function GetThumbButtons: TThumbButtonList;
    procedure DoAppMessage(var Msg: TMsg; var Handled: Boolean);
  protected
    function DoInitialize: Boolean; override;
    procedure DoUpdate; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ShowThumbnails;
    function ClipThumbnail(window:Cardinal; left:integer; right:integer; top:integer; bottom:integer):cardinal;
  published
    property AutoInitialize;
    property Images: TCustomImageList read FImages write SetImages;
    property Thumbnails: TdwTaskbarThumbnailList read FThumbnails write SetThumbnails;
    property OnThumbnailClick: TOnThumbnailClick read FOnThumbnailClick write FOnThumbnailClick;
  end;

implementation

uses
  SysUtils, Graphics;

{ TdwTaskbarThumbnailItem }

procedure TdwTaskbarThumbnailItem.Assign(Source: TPersistent);
begin
  if Source is TdwTaskbarThumbnailItem then
  begin
    Self.FImageIndex := (Source as TdwTaskbarThumbnailItem).FImageIndex;
    Self.FHint := (Source as TdwTaskbarThumbnailItem).FHint;
    Self.FEnabled := (Source as TdwTaskbarThumbnailItem).FEnabled;
    Self.FShowBorder := (Source as TdwTaskbarThumbnailItem).FShowBorder;
    Self.FDismissOnClick := (Source as TdwTaskbarThumbnailItem).FDismissOnClick;
    Self.FVisible := (Source as TdwTaskbarThumbnailItem).FVisible;
    Self.FTag := (Source as TdwTaskbarThumbnailItem).FTag;
  end
  else
  begin
    inherited Assign(Source);
  end;
end;

constructor TdwTaskbarThumbnailItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);

  FImageIndex := Index;
  FHint := '';
  FEnabled := True;
  FShowBorder := True;
  FDismissOnClick := False;
  FVisible := True;
  FTag := 0;
end;

procedure TdwTaskbarThumbnailItem.SetDismissOnClick(const Value: Boolean);
begin
  if FDismissOnClick <> Value then
  begin
    FDismissOnClick := Value;
    Changed(False);
  end;
end;

procedure TdwTaskbarThumbnailItem.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    Changed(False);
  end;
end;

procedure TdwTaskbarThumbnailItem.SetHint(const Value: WideString);
begin
  if FHint <> Value then
  begin
    FHint := Value;
    Changed(False);
  end;
end;

procedure TdwTaskbarThumbnailItem.SetImageIndex(const Value: Integer);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Changed(False);
  end;
end;

procedure TdwTaskbarThumbnailItem.SetShowBorder(const Value: Boolean);
begin
  if FShowBorder <> Value then
  begin
    FShowBorder := Value;
    Changed(False);
  end;
end;

procedure TdwTaskbarThumbnailItem.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed(False);
  end;
end;

{ TdwTaskbarThumbnailList }

function TdwTaskbarThumbnailList.Add: TdwTaskbarThumbnailItem;
begin
  FTaskbarThumbnails.CheckInitalization;
  
  Result := AddItem(nil, -1);
end;

function TdwTaskbarThumbnailList.AddItem(Item: TdwTaskbarThumbnailItem; Index: Integer): TdwTaskbarThumbnailItem;
begin
  FTaskbarThumbnails.CheckInitalization;
  
  if Item = nil then
  begin
    Result := TdwTaskbarThumbnailItem.Create(Self);
  end
  else
  begin
    Result := Item;
    if Assigned(Item) then
    begin
      Result.Collection := Self;
      if Index < Count then
        Index := Count - 1;
      Result.Index := Index;
    end;
  end;
end;

constructor TdwTaskbarThumbnailList.Create(TaskbarThumbnails: TdwTaskbarThumbnails);
begin
  inherited Create(TdwTaskbarThumbnailItem);
  FTaskbarThumbnails := TaskbarThumbnails;
end;

function TdwTaskbarThumbnailList.GetItem(Index: Integer): TdwTaskbarThumbnailItem;
begin
  Result := TdwTaskbarThumbnailItem(inherited GetItem(Index));
end;

function TdwTaskbarThumbnailList.GetOwner: TPersistent;
begin
  Result := FTaskbarThumbnails;
end;

function TdwTaskbarThumbnailList.Insert(Index: Integer): TdwTaskbarThumbnailItem;
begin
  FTaskbarThumbnails.CheckInitalization;
  
  Result := AddItem(nil, Index);
end;

procedure TdwTaskbarThumbnailList.SetItem(Index: Integer; Value: TdwTaskbarThumbnailItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TdwTaskbarThumbnailList.Update(Item: TCollectionItem);
begin
  if Item <> nil then
    FTaskbarThumbnails.UpdateThumbnail(Item.Index)
  else
    FTaskbarThumbnails.UpdateThumbnails;
end;

{ TdwTaskbarThumbnails }

constructor TdwTaskbarThumbnails.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FThumbnails := TdwTaskbarThumbnailList.Create(Self);

  FAppEvents := TApplicationEvents.Create(Self);
  FAppEvents.OnMessage := DoAppMessage;
end;

destructor TdwTaskbarThumbnails.Destroy;
begin
  FThumbnails.Free;
  FAppEvents.Free;
  
  inherited;
end;

procedure TdwTaskbarThumbnails.DoAppMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if Msg.hwnd = TaskBarEntryHandle then
    if Msg.message = WM_COMMAND then
      if HiWord(Msg.wParam) = THBN_CLICKED then
      begin
        Handled := True;
        if Assigned(FOnThumbnailClick) then
          FOnThumbnailClick(FThumbnails[LoWord(Msg.wParam)]);
      end;
end;

function TdwTaskbarThumbnails.ClipThumbnail(window:Cardinal; left:integer; right:integer; top:integer; bottom:integer):cardinal;
var
  rect:TRect;
  rectp:PRect;
begin
  //rect:=TRect.Create;
  rect.Left := left;
  rect.Top := top;
  rect.Right := right;
  rect.Bottom := bottom;
  rectp:=@rect;
  if (TaskbarList3<>nil) then
    Result := TaskbarList3.SetThumbnailClip(window, rectp)
  else
    Result := 16777216;
end;

function TdwTaskbarThumbnails.DoInitialize: Boolean;
var
  Buttons: TThumbButtonList;
begin
  SetLength(Buttons, 0);
  if CheckWin32Version(6, 1) and (TaskbarList3 <> nil) then
  begin
    Buttons := GetThumbButtons;
    if TaskbarList3 <> nil then
    begin
      TaskbarList3.ThumbBarSetImageList(TaskBarEntryHandle, FImages.Handle);
      TaskbarList3.ThumbBarAddButtons(TaskBarEntryHandle, Length(Buttons), @Buttons[0]);
      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;
end;

procedure TdwTaskbarThumbnails.DoUpdate;
var
  Buttons: TThumbButtonList;
begin
  SetLength(Buttons, 0);
  if not IsInitialized then
    Exit;

  Buttons := GetThumbButtons;
  TaskbarList3.ThumbBarSetImageList(TaskBarEntryHandle, FImages.Handle);
  TaskbarList3.ThumbBarUpdateButtons(TaskBarEntryHandle, Length(Buttons), @Buttons[0]);
end;

function TdwTaskbarThumbnails.GetThumbButtons: TThumbButtonList;
var
  I: Integer;
  Thumb: TdwTaskbarThumbnailItem;
begin
  if (FThumbnails.Count < 1) or (FThumbnails.Count > 7) then
    raise Exception.Create('The thumbnail count must be at least 1 and can be up to 7.');

  SetLength(Result, FThumbnails.Count);
  for I := 0 to FThumbnails.Count - 1 do
  begin
    Thumb := FThumbnails[I];

    Result[I].dwMask := THB_FLAGS;

    Result[I].iId := Thumb.Index;

    if FImages <> nil then
      if (Thumb.ImageIndex >= 0) and (Thumb.ImageIndex < FImages.Count) then
      begin
        Result[I].dwMask := Result[I].dwMask or THB_BITMAP;
        Result[I].iBitmap := Thumb.ImageIndex;
      end;

    if Thumb.FHint <> '' then
    begin
      Result[I].dwMask := Result[I].dwMask or THB_TOOLTIP;
      StringToWideChar(Thumb.Hint, Result[I].szTip, Length(Result[I].szTip));
    end;

    Result[I].dwFlags := 0;
    if Thumb.FEnabled then
      Result[I].dwFlags := Result[I].dwFlags or THBF_ENABLED
    else
      Result[I].dwFlags := Result[I].dwFlags or THBF_DISABLED;

    if not Thumb.FShowBorder then
      Result[I].dwFlags := Result[I].dwFlags or THBF_NOBACKGROUND;

    if Thumb.DismissOnClick then
      Result[I].dwFlags := Result[I].dwFlags or THBF_DISMISSONCLICK;

    if not Thumb.Visible then
      Result[I].dwFlags := Result[I].dwFlags or THBF_HIDDEN;
  end;
end;

procedure TdwTaskbarThumbnails.SetImages(const Value: TCustomImageList);
begin
  FImages := Value;
  SendUpdateMessage;
end;

procedure TdwTaskbarThumbnails.SetThumbnails(const Value: TdwTaskbarThumbnailList);
begin
  FThumbnails.Assign(Value);
  SendUpdateMessage;
end;

procedure TdwTaskbarThumbnails.ShowThumbnails;
begin
  CheckInitalization;
  DoInitialize;
end;

procedure TdwTaskbarThumbnails.UpdateThumbnail(Index: Integer);
begin
  SendUpdateMessage;
end;

procedure TdwTaskbarThumbnails.UpdateThumbnails;
begin
  SendUpdateMessage;
end;

end.
