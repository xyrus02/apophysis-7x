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
  { Derive a number of classes from the base TPluginVariation class and
    ensure a unique PluginData record for each derived class (each plugin),
    and override a class function to return the appropriate PluginData.
    There's got to be a much more straightforward way to do this, taking
    advantage of Delphi's late (run-time) binding to make it work with an
    arbitrary number of class "instances" and build them on the fly,
    but I'm new to Delphi & not sure what it is :)  Suggestions anyone? }

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

//////////// ////////// ////////////

procedure TPluginVariation.Prepare;
begin
  GetPluginData.PluginVarInit(MyVariation, Pointer(FPX), Pointer(FPy), Pointer(FTx), Pointer(FTy), vvar);
  GetPluginData.PluginVarPrepare(MyVariation);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TPluginVariation.CalcFunction;
begin
  GetPluginData.PluginVarInit(MyVariation, Pointer(FPX), Pointer(FPy), Pointer(FTx), Pointer(FTy), vvar);
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
  //Result := TPluginVariation.Create; // Want derived class's constructor!
  Result := Self.Create; //So the derived class type gets preserved...
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
      //ShowMessage('Found plugin: '+searchResult.Name+' ('+IntToStr(searchResult.Size)+' bytes)');
      // Work with PluginData for the derived class (would be returned by GetPluginData)
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
  SetLength(PluginData,10);

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

  InitializePlugins;


finalization
  //Release all loaded plugin(s)
  FinalizePlugins;
end.

