unit dwObjectArray;

interface

uses
  Windows;

const
  IID_IObjectArray: TGUID = '{92CA9DCD-5622-4BBA-A805-5E9F541BD8C9}';

type
  IObjectArray = interface
     ['{92CA9DCD-5622-4BBA-A805-5E9F541BD8C9}']
     function GetCount(): UInt; safecall;
     function GetAt(uiIndex: UInt; riid: PGUID): IUnknown; safecall;
  end;

implementation

end.
