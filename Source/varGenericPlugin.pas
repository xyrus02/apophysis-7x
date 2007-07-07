{
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Borys, Peter Sdobnov
     Apophysis Copyright (C) 2007 Piotr Borys, Peter Sdobnov

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
{
  Variation Plugin DLL support for Apophysis:
  Generic Plugin Support Unit
  Started by Jed Kelsey, June 2007
}

{TODO : Make it creating new classes at runtime for itself...}

unit varGenericPlugin;

interface

uses
  BaseVariation, XFormMan,
  Classes,  //TStrings/TStringList
  SysUtils, //FindFirst/FindNext/FindClose
  Dialogs;  //ShowMessage

type
  TPluginVarGetName = function : PChar; cdecl;
  TPluginVarGetNrVariables = function : Integer; cdecl;
  TPluginVarGetVariableNameAt = function(const Index: integer): PChar; cdecl;

  TPluginVarCreate = function : Pointer; cdecl;
  TPluginVarDestroy = function(var MyVariation : Pointer) : LongBool; cdecl;
  TPluginVarInit = function(MyVariation, FPx, FPy, FTx, FTy: Pointer; vvar: double) : LongBool; cdecl;
  TPluginVarPrepare = function(MyVariation : Pointer) : LongBool; cdecl;
  TPluginVarCalc = function(MyVariation : Pointer) : LongBool; cdecl;
  TPluginVarGetVariable = function(MyVariation:Pointer; const Name: PChar; var value: double) : LongBool; cdecl;
  TPluginVarSetVariable = function(MyVariation:Pointer; const Name: PChar; var value: double) : LongBool; cdecl;

  TPluginVariationClass = class of TPluginVariation;

  TPluginData = record
    Instance : Integer;
    PluginHandle : THandle;
    PluginClass : TPluginVariationClass;

    PluginVarGetName : TPluginVarGetName;
    PluginVarGetNrVariables : TPluginVarGetNrVariables;
    PluginVarGetVariableNameAt: TPluginVarGetVariableNameAt;

    PluginVarCreate : TPluginVarCreate;
    PluginVarDestroy : TPluginVarDestroy;
    PluginVarInit : TPluginVarInit;
    PluginVarPrepare : TPluginVarPrepare;
    PluginVarCalc : TPluginVarCalc;
    PluginVarGetVariable : TPluginVarGetVariable;
    PluginVarSetVariable : TPluginVarSetVariable;
  end;
  PPluginData = ^TPluginData;

  // This class serves as a proxy for the plugin variations.
  TPluginVariation = class(TBaseVariation)

  private
    MyVariation : Pointer;

  public
    constructor Create;
    destructor Destroy; override;

    class function GetName: string; override;
    class function GetInstance: TBaseVariation; override;

    class function GetNrVariables: integer; override;
    class function GetVariableNameAt(const Index: integer): string; override;

    function SetVariable(const Name: string; var value: double): boolean; override;
    function GetVariable(const Name: string; var value: double): boolean; override;

    procedure Prepare; override;
    procedure CalcFunction; override;

    class function GetPluginData : PPluginData; virtual;
  end;

  //////////////////////////////////////////////////////////////////////
  {
    Either this, either interfaces...
    Anyone has some other suggestion?... :) please?
  }

  TPluginVariation0 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation1 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation2 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation3 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation4 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation5 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation6 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation7 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation8 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation9 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation10 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation11 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation12 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation13 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation14 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation15 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation16 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation17 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation18 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation19 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation20 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation21 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation22 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation23 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation24 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation25 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation26 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation27 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation28 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  TPluginVariation29 = class(TPluginVariation)
    class function GetPluginData : PPluginData; override;
  end;

  //////////////////////////////////////////////////////////////////////

  var
    //PluginVariationClasses : array of TPluginVariationClass;
    PluginData : array of TPluginData;
    NumPlugins : Integer;

implementation

uses
  Windows, //LoadLibrary
  Math;

{ TPluginVariation }

///////////////////////////////////////////////////////////////////////////////

{ These overridden functions are explicitly defined here to ensure that they
  return the appropriate data record for the class (need to have one per
  derived class so that class methods for multiple plugins get executed
  correctly.  Again, I'm sure there's a much better way around this, but being
  new to Delphi, I don't know what it is. }

class function TPluginVariation.GetPluginData : PPluginData;
begin
  Result := @(PluginData[0]); // As the base class, this shouldn't get called...
end;

class function TPluginVariation0.GetPluginData : PPluginData;
begin
  Result := @(PluginData[0]);
end;

class function TPluginVariation1.GetPluginData : PPluginData;
begin
  Result := @(PluginData[1]);
end;

class function TPluginVariation2.GetPluginData : PPluginData;
begin
  Result := @(PluginData[2]);
end;

class function TPluginVariation3.GetPluginData : PPluginData;
begin
  Result := @(PluginData[3]);
end;

class function TPluginVariation4.GetPluginData : PPluginData;
begin
  Result := @(PluginData[4]);
end;

class function TPluginVariation5.GetPluginData : PPluginData;
begin
  Result := @(PluginData[5]);
end;

class function TPluginVariation6.GetPluginData : PPluginData;
begin
  Result := @(PluginData[6]);
end;

class function TPluginVariation7.GetPluginData : PPluginData;
begin
  Result := @(PluginData[7]);
end;

class function TPluginVariation8.GetPluginData : PPluginData;
begin
  Result := @(PluginData[8]);
end;

class function TPluginVariation9.GetPluginData : PPluginData;
begin
  Result := @(PluginData[9]);
end;

class function TPluginVariation10.GetPluginData : PPluginData;
begin
  Result := @(PluginData[10]);
end;

class function TPluginVariation11.GetPluginData : PPluginData;
begin
  Result := @(PluginData[11]);
end;

class function TPluginVariation12.GetPluginData : PPluginData;
begin
  Result := @(PluginData[12]);
end;

class function TPluginVariation13.GetPluginData : PPluginData;
begin
  Result := @(PluginData[13]);
end;

class function TPluginVariation14.GetPluginData : PPluginData;
begin
  Result := @(PluginData[14]);
end;

class function TPluginVariation15.GetPluginData : PPluginData;
begin
  Result := @(PluginData[15]);
end;

class function TPluginVariation16.GetPluginData : PPluginData;
begin
  Result := @(PluginData[16]);
end;

class function TPluginVariation17.GetPluginData : PPluginData;
begin
  Result := @(PluginData[17]);
end;

class function TPluginVariation18.GetPluginData : PPluginData;
begin
  Result := @(PluginData[18]);
end;

class function TPluginVariation19.GetPluginData : PPluginData;
begin
  Result := @(PluginData[19]);
end;

class function TPluginVariation20.GetPluginData : PPluginData;
begin
  Result := @(PluginData[20]);
end;

class function TPluginVariation21.GetPluginData : PPluginData;
begin
  Result := @(PluginData[21]);
end;

class function TPluginVariation22.GetPluginData : PPluginData;
begin
  Result := @(PluginData[22]);
end;

class function TPluginVariation23.GetPluginData : PPluginData;
begin
  Result := @(PluginData[23]);
end;

class function TPluginVariation24.GetPluginData : PPluginData;
begin
  Result := @(PluginData[24]);
end;

class function TPluginVariation25.GetPluginData : PPluginData;
begin
  Result := @(PluginData[25]);
end;

class function TPluginVariation26.GetPluginData : PPluginData;
begin
  Result := @(PluginData[26]);
end;

class function TPluginVariation27.GetPluginData : PPluginData;
begin
  Result := @(PluginData[27]);
end;

class function TPluginVariation28.GetPluginData : PPluginData;
begin
  Result := @(PluginData[28]);
end;

class function TPluginVariation29.GetPluginData : PPluginData;
begin
  Result := @(PluginData[29]);
end;

//////////// ////////// ////////////

procedure TPluginVariation.Prepare;
begin
  GetPluginData.PluginVarInit(MyVariation, Pointer(FPX), Pointer(FPy), Pointer(FTx), Pointer(FTy), vvar);
  GetPluginData.PluginVarPrepare(MyVariation);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TPluginVariation.CalcFunction;
begin
  GetPluginData.PluginVarCalc(MyVariation);
end;

///////////////////////////////////////////////////////////////////////////////
constructor TPluginVariation.Create;
begin
  MyVariation := GetPluginData.PluginVarCreate;
end;

///////////////////////////////////////////////////////////////////////////////
destructor TPluginVariation.Destroy;
begin
  GetPluginData.PluginVarDestroy(MyVariation);
  inherited;
end;

///////////////////////////////////////////////////////////////////////////////
class function TPluginVariation.GetInstance: TBaseVariation;
begin
  Result := Self.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TPluginVariation.GetName: string;
begin
  Result := String(GetPluginData.PluginVarGetName());
end;

///////////////////////////////////////////////////////////////////////////////
class function TPluginVariation.GetNrVariables: integer;
begin
  Result := GetPluginData.PluginVarGetNrVariables();
end;

///////////////////////////////////////////////////////////////////////////////
class function TPluginVariation.GetVariableNameAt(const Index: integer): string;
begin
  Result := String(GetPluginData.PluginVarGetVariableNameAt(Index));
end;

///////////////////////////////////////////////////////////////////////////////
function TPluginVariation.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := GetPluginData.PluginVarSetVariable(MyVariation,PChar(Name),value);
end;

///////////////////////////////////////////////////////////////////////////////
function TPluginVariation.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := GetPluginData.PluginVarGetVariable(MyVariation,PChar(Name),value);
end;

///////////////////////////////////////////////////////////////////////////////
procedure InitializePlugins;
var
  searchResult : TSearchRec;
begin
  NumPlugins := 0;
  // Try to find regular files matching *.dll in the plugins dir
  if FindFirst('.\Plugins\*.dll', faAnyFile, searchResult) = 0 then
  begin
    repeat
      with PluginData[NumPlugins] do begin
        //Load DLL and initialize plugins!
        PluginHandle := LoadLibrary(PChar('.\Plugins\'+searchResult.Name));
        if PluginHandle<>0 then begin
          @PluginVarGetName := GetProcAddress(PluginHandle,'PluginVarGetName');
          if @PluginVarGetName = nil then begin  // Must not be a valid plugin!
            FreeLibrary(PluginHandle);
            ShowMessage('Invalid Plugin: Could not find PluginVarGetName in '+searchResult.Name);
          end else begin
            @PluginVarGetNrVariables    := GetProcAddress(PluginHandle,'PluginVarGetNrVariables');
            @PluginVarGetVariableNameAt := GetProcAddress(PluginHandle,'PluginVarGetVariableNameAt');
            @PluginVarCreate            := GetProcAddress(PluginHandle,'PluginVarCreate');
            @PluginVarDestroy           := GetProcAddress(PluginHandle,'PluginVarDestroy');
            @PluginVarInit              := GetProcAddress(PluginHandle,'PluginVarInit');
            @PluginVarPrepare           := GetProcAddress(PluginHandle,'PluginVarPrepare');
            @PluginVarCalc              := GetProcAddress(PluginHandle,'PluginVarCalc');
            @PluginVarGetVariable       := GetProcAddress(PluginHandle,'PluginVarGetVariable');
            @PluginVarSetVariable       := GetProcAddress(PluginHandle,'PluginVarSetVariable');
            Instance := NumPlugins+1;

            RegisterVariation(PluginClass);

            Inc(NumPlugins);
            if NumPlugins >= Length(PluginData) then
              break;
          end;
        end else
          ShowMessage('Could not load a plugin: '+searchResult.Name);
      end;
    until (FindNext(searchResult) <> 0);
    SysUtils.FindClose(searchResult); //Since we use Windows unit (LoadLibrary)
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure FinalizePlugins;
var
  I : Integer;
begin
  for I := 0 to NumPlugins - 1 do begin
    if PluginData[NumPlugins].PluginHandle<>0 then begin
      FreeLibrary(PluginData[NumPlugins].PluginHandle);
    end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  SetLength(PluginData,30);

  PluginData[0].PluginClass := TPluginVariation0;
  PluginData[1].PluginClass := TPluginVariation1;
  PluginData[2].PluginClass := TPluginVariation2;
  PluginData[3].PluginClass := TPluginVariation3;
  PluginData[4].PluginClass := TPluginVariation4;
  PluginData[5].PluginClass := TPluginVariation5;
  PluginData[6].PluginClass := TPluginVariation6;
  PluginData[7].PluginClass := TPluginVariation7;
  PluginData[8].PluginClass := TPluginVariation8;
  PluginData[9].PluginClass := TPluginVariation9;
  PluginData[10].PluginClass := TPluginVariation10;
  PluginData[11].PluginClass := TPluginVariation11;
  PluginData[12].PluginClass := TPluginVariation12;
  PluginData[13].PluginClass := TPluginVariation13;
  PluginData[14].PluginClass := TPluginVariation14;
  PluginData[15].PluginClass := TPluginVariation15;
  PluginData[16].PluginClass := TPluginVariation16;
  PluginData[17].PluginClass := TPluginVariation17;
  PluginData[18].PluginClass := TPluginVariation18;
  PluginData[19].PluginClass := TPluginVariation19;
  PluginData[20].PluginClass := TPluginVariation20;
  PluginData[21].PluginClass := TPluginVariation21;
  PluginData[22].PluginClass := TPluginVariation22;
  PluginData[23].PluginClass := TPluginVariation23;
  PluginData[24].PluginClass := TPluginVariation24;
  PluginData[25].PluginClass := TPluginVariation25;
  PluginData[26].PluginClass := TPluginVariation26;
  PluginData[27].PluginClass := TPluginVariation27;
  PluginData[28].PluginClass := TPluginVariation28;
  PluginData[29].PluginClass := TPluginVariation29;

  InitializePlugins;


finalization
  //Release all loaded plugin(s)
  FinalizePlugins;
end.

