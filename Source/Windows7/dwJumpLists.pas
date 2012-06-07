unit dwJumpLists;

interface

{$INCLUDE '..\Packages\DelphiVersions.inc'}

uses
  Classes, Contnrs, ShlObj,
  {$IFNDEF Delphi2007_Up}
  dwShellItem,
  {$ENDIF}
  dwCustomDestinationList, dwObjectArray;

type
  TJumpListKnowCategory = (jlkcFrequent, jlkcRecent);
  TJumpListKnowCategories = set of TJumpListKnowCategory;

const
  KNOWN_CATEGORIES_DEFAULT: TJumpListKnowCategories = [jlkcFrequent, jlkcRecent];

type
  TdwLinkObjectType = (lotShellLink, lotShellItem);

type
  TdwLinkObjectItem = class;
  TdwLinkObjectList = class;
  TdwLinkCategoryItem = class;
  TdwLinkCategoryList = class;
  TdwJumpLists = class;

  TObjectArray = class(TInterfacedObject, IObjectArray)
  private
    FObjectList: TInterfaceList;

    function CreateShellLink(ObjectItem: TdwLinkObjectItem): IShellLinkW;
    function CreateShellItem(ObjectItem: TdwLinkObjectItem): IShellItem;
    procedure LoadObjectList(ObjectList: TdwLinkObjectList; DeletedObjects: IObjectArray);
  protected
  public
    constructor Create(ObjectList: TdwLinkObjectList; DeletedObjects: IObjectArray);
    destructor Destroy; override;

    function GetAt(uiIndex: Cardinal; riid: PGUID): IUnknown; safecall;
    function GetCount: Cardinal; safecall;
  end;

  TdwShellItem = class(TPersistent)
  private
    FFilename: WideString;
    procedure SetFilename(const Value: WideString);
  protected
  public
    constructor Create; 
    procedure Assign(Source: TPersistent); override;
  published
    property Filename: WideString read FFilename write SetFilename;
  end;

  TdwShellLink = class(TPersistent)
  private
    FDisplayName: WideString;
    FArguments: WideString;
    FIconFilename: WideString;
    FIconIndex: Integer;
    procedure SetArguments(const Value: WideString);
    procedure SetDisplayName(const Value: WideString);
    procedure SetIconFilename(const Value: WideString);
    procedure SetIconIndex(const Value: Integer);
  protected
  public
    constructor Create; 
    procedure Assign(Source: TPersistent); override;
  published
    property Arguments: WideString read FArguments write SetArguments;
    property DisplayName: WideString read FDisplayName write SetDisplayName;
    property IconFilename: WideString read FIconFilename write SetIconFilename;
    property IconIndex: Integer read FIconIndex write SetIconIndex;
  end;

  TdwLinkObjectItem = class(TCollectionItem)
  private
    FTag: Integer;
    FObjectType: TdwLinkObjectType;
    FShellItem: TdwShellItem;
    FShellLink: TdwShellLink;
    procedure SetTag(const Value: Integer);
    procedure SetObjectType(const Value: TdwLinkObjectType);
    procedure SetShellItem(const Value: TdwShellItem);
    procedure SetShellLink(const Value: TdwShellLink);
  protected
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
  published
    property Tag: Integer read FTag write SetTag default 0;
    property ObjectType: TdwLinkObjectType read FObjectType write SetObjectType default lotShellItem;
    property ShellItem: TdwShellItem read FShellItem write SetShellItem;
    property ShellLink: TdwShellLink read FShellLink write SetShellLink;
  end;

  TdwLinkObjectList = class(TCollection)
  private
    FOwner: TPersistent;
    function GetItem(Index: Integer): TdwLinkObjectItem;
    procedure SetItem(Index: Integer; Value: TdwLinkObjectItem);
    function GetObjectArray(DeletedObjects: IObjectArray): IObjectArray;
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(Owner: TPersistent);
    destructor Destroy; override;

    function Add: TdwLinkObjectItem;
    function AddShellItem(const Filename: WideString): TdwLinkObjectItem;
    function AddShellLink(const DisplayName, Arguments: WideString; const IconFilename: WideString = ''; IconIndex: Integer = 0): TdwLinkObjectItem;
    function AddItem(Item: TdwLinkObjectItem; Index: Integer): TdwLinkObjectItem;
    function Insert(Index: Integer): TdwLinkObjectItem;

    property Items[Index: Integer]: TdwLinkObjectItem read GetItem write SetItem; default;
  end;

  TdwLinkCategoryItem = class(TCollectionItem)
  private
    FTitle: WideString;
    FTag: Integer;
    FItems: TdwLinkObjectList;
    procedure SetTitle(const Value: WideString);
    procedure SetTag(const Value: Integer);
    procedure SetItems(const Value: TdwLinkObjectList);
  protected
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
  published
    property Title: WideString read FTitle write SetTitle;
    property Tag: Integer read FTag write SetTag default 0;
    property Items: TdwLinkObjectList read FItems write SetItems;
  end;

  TdwLinkCategoryList = class(TCollection)
  private
    FOwner: TPersistent;
    function GetItem(Index: Integer): TdwLinkCategoryItem;
    procedure SetItem(Index: Integer; Value: TdwLinkCategoryItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(Owner: TPersistent);
    destructor Destroy; override;

    function Add: TdwLinkCategoryItem;
    function AddItem(Item: TdwLinkCategoryItem; Index: Integer): TdwLinkCategoryItem;
    function Insert(Index: Integer): TdwLinkCategoryItem;

    property Items[Index: Integer]: TdwLinkCategoryItem read GetItem write SetItem; default;
  end;

  TdwJumpLists = class(TComponent)
  private
    FDisplayKnowCategories: TJumpListKnowCategories;
    FDestinationList: ICustomDestinationList;
    FIsSupported: Boolean;
    FCategories: TdwLinkCategoryList;
    FTasks: TdwLinkObjectList;
    FAppID: WideString;

    procedure SetDisplayKnowCategories(const Value: TJumpListKnowCategories);
    function DoStoreDisplayKnowCategories: Boolean;
    procedure SetCategories(const Value: TdwLinkCategoryList);
    procedure SetTasks(const Value: TdwLinkObjectList);
    procedure SetAppID(const Value: WideString);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetMaxJumpListEntryCount: Integer;
    function Commit: Boolean;

    property IsSupported: Boolean read FIsSupported;
  published
    property DisplayKnowCategories: TJumpListKnowCategories read FDisplayKnowCategories write SetDisplayKnowCategories stored DoStoreDisplayKnowCategories;
    property Categories: TdwLinkCategoryList read FCategories write SetCategories;
    property Tasks: TdwLinkObjectList read FTasks write SetTasks;
    property AppID: WideString read FAppID write SetAppID;
  end;

implementation

uses
  ComObj, ActiveX, SysUtils;

{ TObjectArray }

constructor TObjectArray.Create(ObjectList: TdwLinkObjectList; DeletedObjects: IObjectArray);
begin
  inherited Create;

  FObjectList := TInterfaceList.Create;
  LoadObjectList(ObjectList, DeletedObjects);
end;

function TObjectArray.CreateShellItem(ObjectItem: TdwLinkObjectItem): IShellItem;
begin
  if ObjectItem.FObjectType = lotShellItem then
  begin
    SHCreateItemFromParsingName(PWideChar(ObjectItem.ShellItem.Filename), nil, StringToGUID(SID_IShellItem), Result);
  end
  else
  begin
    Result := nil;
  end;
end;

function TObjectArray.CreateShellLink(ObjectItem: TdwLinkObjectItem): IShellLinkW;
var
  ShellLink: IShellLinkW;
  PPS: IPropertyStore;
  K: TPropertyKey;
  P: tagPROPVARIANT;
begin
  if ObjectItem.FObjectType = lotShellLink then
  begin
    CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER, IID_IShellLinkW, ShellLink);
    ShellLink.SetPath(PWideChar(WideString(GetModuleName(HInstance))));
    ShellLink.SetArguments(PWideChar(ObjectItem.ShellLink.FArguments));
    if ObjectItem.ShellLink.FIconFilename <> '' then
      ShellLink.SetIconLocation(PWideChar(ObjectItem.ShellLink.FIconFilename), ObjectItem.ShellLink.FIconIndex)
    else
      ShellLink.SetIconLocation(PWideChar(WideString(GetModuleName(HInstance))), 0);
    PPS := ShellLink as IPropertyStore;
    K.fmtid := StringToGUID('{F29F85E0-4FF9-1068-AB91-08002B27B3D9}');
    K.pid := 2;
    P.vt := VT_LPWSTR;
    P.pwszVal := PWideChar(ObjectItem.ShellLink.FDisplayName);
    PPS.SetValue(K, P);
    PPS.Commit;
    Result := ShellLink;
  end
  else
  begin
    Result := nil;
  end;
end;

destructor TObjectArray.Destroy;
begin
  FObjectList.Free;

  inherited;
end;

function TObjectArray.GetAt(uiIndex: Cardinal; riid: PGUID): IUnknown;
begin
  Result := FObjectList[uiIndex];
end;

function TObjectArray.GetCount: Cardinal;
begin
  Result := FObjectList.Count;
end;

procedure TObjectArray.LoadObjectList(ObjectList: TdwLinkObjectList; DeletedObjects: IObjectArray);
var
  I: Integer;
  ObjectItem: TdwLinkObjectItem;
begin
  for I := 0 to ObjectList.Count - 1 do
  begin
    ObjectItem := ObjectList.Items[I];
    case ObjectItem.FObjectType of
     lotShellLink:
     begin
       FObjectList.Add(CreateShellLink(ObjectItem));
     end;
     lotShellItem:
     begin
       FObjectList.Add(CreateShellItem(ObjectItem));
     end;
    end;
  end;
end;

{ TdwShellLink }

procedure TdwShellItem.Assign(Source: TPersistent);
begin
  if Source is TdwShellItem then
  begin
    Self.FFilename := (Source as TdwShellItem).FFilename;
  end
  else
  begin
    inherited Assign(Source);
  end;
end;

constructor TdwShellItem.Create;
begin
  inherited Create;

  FFilename := '';
end;

procedure TdwShellItem.SetFilename(const Value: WideString);
begin
  FFilename := Value;
end;

{ TdwShellLink }

procedure TdwShellLink.Assign(Source: TPersistent);
begin
  if Source is TdwShellLink then
  begin
    Self.FArguments := (Source as TdwShellLink).FArguments;
    Self.FDisplayName := (Source as TdwShellLink).FDisplayName;
    Self.FIconFilename := (Source as TdwShellLink).FIconFilename;
    Self.FIconIndex := (Source as TdwShellLink).FIconIndex;
  end
  else
  begin
    inherited Assign(Source);
  end;
end;

constructor TdwShellLink.Create;
begin
  inherited Create;

  FDisplayName := '';
  FArguments := '';
  FIconFilename := '';
  FIconIndex := 0;
end;

procedure TdwShellLink.SetArguments(const Value: WideString);
begin
  FArguments := Value;
end;

procedure TdwShellLink.SetDisplayName(const Value: WideString);
begin
  FDisplayName := Value;
end;

procedure TdwShellLink.SetIconFilename(const Value: WideString);
begin
  FIconFilename := Value;
end;

procedure TdwShellLink.SetIconIndex(const Value: Integer);
begin
  FIconIndex := Value;
end;

{ TdwLinkObjectItem }

procedure TdwLinkObjectItem.Assign(Source: TPersistent);
begin
  if Source is TdwLinkObjectItem then
  begin
    Self.FTag := (Source as TdwLinkObjectItem).FTag;
    Self.FObjectType := (Source as TdwLinkObjectItem).FObjectType;
  end
  else
  begin
    inherited Assign(Source);
  end;
end;

constructor TdwLinkObjectItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FTag := 0;
  FObjectType := lotShellItem;
  FShellItem := TdwShellItem.Create();
  FShellLink := TdwShellLink.Create();
end;

destructor TdwLinkObjectItem.Destroy;
begin
  FShellItem.Free;
  FShellLink.Free;

  inherited;
end;

procedure TdwLinkObjectItem.SetObjectType(const Value: TdwLinkObjectType);
begin
  FObjectType := Value;
end;

procedure TdwLinkObjectItem.SetShellItem(const Value: TdwShellItem);
begin
  FShellItem.Assign(Value);
end;

procedure TdwLinkObjectItem.SetShellLink(const Value: TdwShellLink);
begin
  FShellLink := Value;
end;

procedure TdwLinkObjectItem.SetTag(const Value: Integer);
begin
  FTag := Value;
end;

{ TdwLinkObjectList }

function TdwLinkObjectList.Add: TdwLinkObjectItem;
begin
  Result := AddItem(nil, -1);
end;

function TdwLinkObjectList.AddItem(Item: TdwLinkObjectItem; Index: Integer): TdwLinkObjectItem;
begin
  if Item = nil then
  begin
    Result := TdwLinkObjectItem.Create(Self);
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

function TdwLinkObjectList.AddShellItem(const Filename: WideString): TdwLinkObjectItem;
begin
  Result := Add;

  Result.FObjectType := lotShellItem;
  Result.ShellItem.FFilename := Filename;
end;

function TdwLinkObjectList.AddShellLink(const DisplayName, Arguments, IconFilename: WideString; IconIndex: Integer): TdwLinkObjectItem;
begin
  Result := Add;
  Result.FObjectType := lotShellLink;
  Result.ShellLink.FDisplayName := DisplayName;
  Result.ShellLink.FArguments := Arguments;
  Result.ShellLink.FIconFilename := IconFilename;
  Result.ShellLink.FIconIndex := IconIndex;
end;

constructor TdwLinkObjectList.Create(Owner: TPersistent);
begin
  inherited Create(TdwLinkObjectItem);
  FOwner := Owner;
end;

destructor TdwLinkObjectList.Destroy;
begin

  inherited;
end;

function TdwLinkObjectList.GetItem(Index: Integer): TdwLinkObjectItem;
begin
  Result := TdwLinkObjectItem(inherited GetItem(Index));
end;

function TdwLinkObjectList.GetObjectArray(DeletedObjects: IObjectArray): IObjectArray;
begin
  Result := TObjectArray.Create(Self, DeletedObjects) as IObjectArray;
end;

function TdwLinkObjectList.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TdwLinkObjectList.Insert(Index: Integer): TdwLinkObjectItem;
begin
  Result := AddItem(nil, Index);
end;

procedure TdwLinkObjectList.SetItem(Index: Integer; Value: TdwLinkObjectItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TdwLinkObjectList.Update(Item: TCollectionItem);
begin
  // nothing to do
end;

{ TdwLinkCategoryItem }

procedure TdwLinkCategoryItem.Assign(Source: TPersistent);
begin
  if Source is TdwLinkCategoryItem then
  begin
    Self.FTitle := (Source as TdwLinkCategoryItem).FTitle;
    Self.FTag := (Source as TdwLinkCategoryItem).FTag;
  end
  else
  begin
    inherited Assign(Source);
  end;
end;

constructor TdwLinkCategoryItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);

  FTitle := '';
  FTag := 0;
  FItems := TdwLinkObjectList.Create(Self);
end;

destructor TdwLinkCategoryItem.Destroy;
begin
  FItems.Free;

  inherited Destroy;
end;

procedure TdwLinkCategoryItem.SetItems(const Value: TdwLinkObjectList);
begin
  FItems.Assign(Value);
end;

procedure TdwLinkCategoryItem.SetTag(const Value: Integer);
begin
  FTag := Value;
end;

procedure TdwLinkCategoryItem.SetTitle(const Value: WideString);
begin
  FTitle := Value;
end;

{ TdwLinkCategoryList }

function TdwLinkCategoryList.Add: TdwLinkCategoryItem;
begin
  Result := AddItem(nil, -1);
end;

function TdwLinkCategoryList.AddItem(Item: TdwLinkCategoryItem; Index: Integer): TdwLinkCategoryItem;
begin
  if Item = nil then
  begin
    Result := TdwLinkCategoryItem.Create(Self);
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

constructor TdwLinkCategoryList.Create(Owner: TPersistent);
begin
  inherited Create(TdwLinkCategoryItem);
  FOwner := Owner;
end;

destructor TdwLinkCategoryList.Destroy;
begin

  inherited Destroy;
end;

function TdwLinkCategoryList.GetItem(Index: Integer): TdwLinkCategoryItem;
begin
  Result := TdwLinkCategoryItem(inherited GetItem(Index));
end;

function TdwLinkCategoryList.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TdwLinkCategoryList.Insert(Index: Integer): TdwLinkCategoryItem;
begin
  Result := AddItem(nil, Index);
end;

procedure TdwLinkCategoryList.SetItem(Index: Integer; Value: TdwLinkCategoryItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TdwLinkCategoryList.Update(Item: TCollectionItem);
begin
  // nothing to do
end;

{ TdwJumpLists }

function TdwJumpLists.Commit: Boolean;
var
  MaxSlots: Cardinal;
  IdxCat: Integer;
  DeletedObjects: IObjectArray;
  Category: TdwLinkCategoryItem;
begin
  if IsSupported then
  try
    DeletedObjects := FDestinationList.BeginList(MaxSlots, @IID_IObjectArray);

    for IdxCat := 0 to FCategories.Count - 1 do
    begin
      Category := FCategories.Items[IdxCat];
      if Category.Items.Count > 0 then
      begin
        FDestinationList.AppendCategory(PWideChar(Category.FTitle), Category.Items.GetObjectArray(DeletedObjects));
      end;
    end;

    if FTasks.Count > 0 then
      FDestinationList.AddUserTasks(FTasks.GetObjectArray(DeletedObjects));

    if jlkcFrequent in FDisplayKnowCategories then
      FDestinationList.AppendKnownCategory(KDC_FREQUENT);
    if jlkcRecent in FDisplayKnowCategories then
      FDestinationList.AppendKnownCategory(KDC_RECENT);

    FDestinationList.CommitList;
    Result := True;
  except
    Result := False;
  end
  else
  begin
    Result := False;
  end;
end;

constructor TdwJumpLists.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if CheckWin32Version(6, 1) then
  begin
    FDisplayKnowCategories := KNOWN_CATEGORIES_DEFAULT;
    FDestinationList := CreateComObject(CLSID_CustomDestinationList) as ICustomDestinationList;
  end
  else
  begin
    FDestinationList := nil;
  end;
  FIsSupported := FDestinationList <> nil;

  FCategories := TdwLinkCategoryList.Create(Self);
  FTasks := TdwLinkObjectList.Create(Self);
end;

destructor TdwJumpLists.Destroy;
begin
  FDestinationList := nil;
  FCategories.Free;
  FTasks.Free;
  
  inherited Destroy;
end;

function TdwJumpLists.DoStoreDisplayKnowCategories: Boolean;
begin
  Result := FDisplayKnowCategories <> KNOWN_CATEGORIES_DEFAULT;
end;

function TdwJumpLists.GetMaxJumpListEntryCount: Integer;
var
  Objects: IObjectArray;
  MaxSlots: Cardinal;
begin
  if not IsSupported then
  begin
    Result := -1;
  end
  else
  begin
    Objects := FDestinationList.BeginList(MaxSlots, @IID_IObjectArray);
    FDestinationList.AbortList;
    Result := MaxSlots;
  end;
end;

procedure TdwJumpLists.SetAppID(const Value: WideString);
begin
  FAppID := Value;
  FDestinationList.SetAppID(PWideChar(Value));
end;

procedure TdwJumpLists.SetCategories(const Value: TdwLinkCategoryList);
begin
  FCategories.Assign(Value);
end;

procedure TdwJumpLists.SetDisplayKnowCategories(const Value: TJumpListKnowCategories);
begin
  if FDisplayKnowCategories <> Value then
  begin
    FDisplayKnowCategories := Value;
  end;
end;

procedure TdwJumpLists.SetTasks(const Value: TdwLinkObjectList);
begin
  FTasks.Assign(Value);
end;

end.
