unit dwCustomDestinationList;

interface

uses
  Windows,
  dwObjectArray;

const
  CLSID_CustomDestinationList: TGUID = '{77f10cf0-3db5-4966-b520-b7c54fd35ed6}';

const
  KDC_FREQUENT = $01;
  KDC_RECENT = $02;

type
  ICustomDestinationList = interface
    ['{6332debf-87b5-4670-90c0-5e57b408a49e}']
    procedure SetAppID(pszAppID: LPWSTR); safecall;
    function BeginList(out pcMaxSlots: UINT; riid: PGUID): IObjectArray; safecall;
    procedure AppendCategory(pszCategory: LPWSTR; poa: IObjectArray); safecall;
    procedure AppendKnownCategory(Category: Integer); safecall;
    procedure AddUserTasks(poa: IUnknown); safecall;
    procedure CommitList(); safecall;
    function GetRemovedDestinations(riid: PGUID): IUnknown; safecall;
    procedure DeleteList(pszAppID:LPWSTR); safecall;
    procedure AbortList(); safecall;
  end;

implementation

end.
