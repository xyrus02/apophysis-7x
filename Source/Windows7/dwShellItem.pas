unit dwShellItem;

interface

{$INCLUDE '.\..\Packages\DelphiVersions.inc'}

uses
  ActiveX, Windows;

const
  SID_IShellItem         = '{43826d1e-e718-42ee-bc55-a1e261c37bfe}';
  SID_IPropertyStore     = '{886d8eeb-8cf2-4446-8d02-cdba1dbdcf99}';

type
  TIID = TGUID;

  IShellItem = interface(IUnknown)
    [SID_IShellItem]
    function BindToHandler(const pbc: IUnknown; const bhid: TGUID; const riid: TIID; out ppv): HResult; stdcall;
    function GetParent(var ppsi: IShellItem): HResult; stdcall;
    function GetDisplayName(sigdnName: DWORD; var ppszName: LPWSTR): HResult; stdcall;
    function GetAttributes(sfgaoMask: DWORD; var psfgaoAttribs: DWORD): HResult; stdcall;
    function Compare(const psi: IShellItem; hint: DWORD; var piOrder: Integer): HResult; stdcall;
  end;

  _tagpropertykey = packed record
    fmtid: TGUID;
    pid: DWORD;
  end;
  PROPERTYKEY = _tagpropertykey;
  PPropertyKey = ^TPropertyKey;
  TPropertyKey = _tagpropertykey;

  IPropertyStore = interface(IUnknown)
    [SID_IPropertyStore]
    function GetCount(out cProps: DWORD): HResult; stdcall;
    function GetAt(iProp: DWORD; out pkey: TPropertyKey): HResult; stdcall;
    function GetValue(const key: TPropertyKey; out pv: TPropVariant): HResult; stdcall;
    function SetValue(const key: TPropertyKey; const propvar: TPropVariant): HResult; stdcall;
    function Commit: HResult; stdcall;
  end;

type
  PSHItemID = ^TSHItemID;
  _SHITEMID = record
    cb: Word;
    abID: array[0..0] of Byte;
  end;
  TSHItemID = _SHITEMID;
  SHITEMID = _SHITEMID;

  PItemIDList = ^TItemIDList;
  _ITEMIDLIST = record
     mkid: TSHItemID;
   end;
  TItemIDList = _ITEMIDLIST;
  ITEMIDLIST = _ITEMIDLIST;

function SHCreateItemFromIDList(pidl: PItemIDList; const riid: TIID; out ppv): HResult;
function SHCreateItemFromParsingName(pszPath: LPCWSTR; const pbc: IUnknown; const riid: TIID; out ppv): HResult;

implementation

const
  shell32 = 'shell32.dll';

var
  Shell32Lib: HModule;
  _SHCreateItemFromParsingName: function(pszPath: LPCWSTR; const pbc: IUnknown; const riid: TIID; out ppv): HResult; stdcall;
  _SHCreateItemFromIDList: function(pidl: PItemIDList; const riid: TIID; out ppv): HResult; stdcall;

procedure InitShlObj; {$IFDEF Delphi2006_Up} inline; {$ENDIF}
begin
  Shell32Lib := GetModuleHandle(shell32);
end;

function SHCreateItemFromParsingName(pszPath: LPCWSTR; const pbc: IUnknown; const riid: TIID; out ppv): HResult;
begin
  if Assigned(_SHCreateItemFromParsingName) then
    Result := _SHCreateItemFromParsingName(pszPath, pbc, riid, ppv)
  else
  begin
    InitShlObj;
    Result := E_NOTIMPL;
    if Shell32Lib > 0 then
    begin
      _SHCreateItemFromParsingName := GetProcAddress(Shell32Lib, 'SHCreateItemFromParsingName'); // Do not localize
      if Assigned(_SHCreateItemFromParsingName) then
        Result := _SHCreateItemFromParsingName(pszPath, pbc, riid, ppv);
    end;
  end;
end;

function SHCreateItemFromIDList(pidl: PItemIDList; const riid: TIID; out ppv): HResult;
begin
  if Assigned(_SHCreateItemFromIDList) then
    Result := _SHCreateItemFromIDList(pidl, riid, ppv)
  else
  begin
    InitShlObj;
    Result := E_NOTIMPL;
    if Shell32Lib > 0 then
    begin
      _SHCreateItemFromIDList := GetProcAddress(Shell32Lib, 'SHCreateItemFromIDList'); // Do not localize
      if Assigned(_SHCreateItemFromIDList) then
        Result := _SHCreateItemFromIDList(pidl, riid, ppv);
    end;
  end;
end;

end.
