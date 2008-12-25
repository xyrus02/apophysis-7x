{
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Borys, Peter Sdobnov
     Apophysis Copyright (C) 2007-2008 Piotr Borys, Peter Sdobnov

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

  
  Portions Copyright (C) 2008 Joel Faber

  February 2008:
   - Remove 30 plugin limit
   - Reset variables
}

unit varGenericPlugin;

interface

uses
  BaseVariation, XFormMan,
  Classes,  //TStrings/TStringList
  SysUtils, //FindFirst/FindNext/FindClose
  Forms;  //MessageBox

type
  TPluginVariationClass = class of TPluginVariation;

  TPluginData = record
    Instance: Integer;
    PluginHandle: THandle;
    PluginClass: TPluginVariationClass;

    PluginVarGetName:           function: PChar; cdecl;
    PluginVarGetNrVariables:    function: Integer; cdecl;
    PluginVarGetVariableNameAt: function(const Index: integer): PChar; cdecl;

    PluginVarCreate:       function: Pointer; cdecl;
    PluginVarDestroy:      function(var MyVariation: Pointer): LongBool; cdecl;
    PluginVarInit:         function(MyVariation, FPx, FPy, FTx, FTy: Pointer; vvar: double): LongBool; cdecl;
    PluginVarInit3D:       function(MyVariation, FPx, FPy, FPz, FTx, FTy, FTz: Pointer; vvar: double): LongBool; cdecl;
    PluginVarPrepare:      function(MyVariation: Pointer): LongBool; cdecl;
    PluginVarCalc:         function(MyVariation: Pointer): LongBool; cdecl;
    PluginVarGetVariable:  function(MyVariation: Pointer; const Name: PChar; var value: double): LongBool; cdecl;
    PluginVarSetVariable:  function(MyVariation: Pointer; const Name: PChar; var value: double): LongBool; cdecl;
    PluginVarResetVariable:function(MyVariation: Pointer; const Name: PChar) : LongBool; cdecl;
  end;
  PPluginData = ^TPluginData;

  // This class serves as a proxy for the plugin variations.
  TPluginVariation = class(TBaseVariation)

  private
    PluginData : TPluginData;
    MyVariation : Pointer;

  public
    constructor Create(varData : TPluginData);
    destructor Destroy; override;

    class function GetName: string; override;
    class function GetInstance: TBaseVariation; override;

    function GetNrVariables: integer; override;
    function GetVariableNameAt(const Index: integer): string; override;

    function SetVariable(const Name: string; var value: double): boolean; override;
    function GetVariable(const Name: string; var value: double): boolean; override;
    function ResetVariable(const Name: string): boolean; override;

    procedure Prepare; override;
    procedure CalcFunction; override;
  end;

type
  TVariationPluginLoader = class (TVariationLoader)
  public
    constructor Create(varData : TPluginData);
    destructor Destroy; override;
    
    function GetName: string; override;
    function GetInstance: TBaseVariation; override;
    function GetNrVariables: integer; override;
    function GetVariableNameAt(const Index: integer): string; override;

  private
    PluginData : TPluginData;
  end;
  //////////////////////////////////////////////////////////////////////

implementation

uses
  Windows, //LoadLibrary
  Math;

{ TPluginVariation }

///////////////////////////////////////////////////////////////////////////////

constructor TVariationPluginLoader.Create(varData : TPluginData);
begin
  PluginData := varData;
end;

destructor TVariationPluginLoader.Destroy;
begin
  FreeLibrary(PluginData.PluginHandle);
end;

function TVariationPluginLoader.GetName : string;
begin
  Result := PluginData.PluginVarGetName;
end;

function TVariationPluginLoader.GetInstance: TBaseVariation;
begin
  Result := TPluginVariation.Create(PluginData);
end;

function TVariationPluginLoader.GetNrVariables: integer;
begin
  Result := PluginData.PluginVarGetNrVariables;
end;

function TVariationPluginLoader.GetVariableNameAt(const Index: integer): string;
begin
  Result := PluginData.PluginVarGetVariableNameAt(Index);
end;

///////////////////////////////////////////////////////////////////////////////

procedure TPluginVariation.Prepare;
begin
  with PluginData do begin
    if @PluginVarInit3D <> nil then
      PluginVarInit3D(MyVariation, Pointer(FPX), Pointer(FPy), Pointer(FPz), Pointer(FTx), Pointer(FTy), Pointer(FTz), vvar)
    else
      PluginVarInit(MyVariation, Pointer(FPX), Pointer(FPy), Pointer(FTx), Pointer(FTy), vvar);
    PluginVarPrepare(MyVariation);
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TPluginVariation.CalcFunction;
begin
  PluginData.PluginVarCalc(MyVariation);
end;

///////////////////////////////////////////////////////////////////////////////
constructor TPluginVariation.Create(varData : TPluginData);
begin
  PluginData := varData;
  MyVariation := PluginData.PluginVarCreate;
end;

///////////////////////////////////////////////////////////////////////////////
destructor TPluginVariation.Destroy;
begin
  PluginData.PluginVarDestroy(MyVariation);
  inherited;
end;

///////////////////////////////////////////////////////////////////////////////
class function TPluginVariation.GetInstance: TBaseVariation;
begin
  Result := nil;
end;

///////////////////////////////////////////////////////////////////////////////
class function TPluginVariation.GetName: string;
begin
  Result := '';
end;

///////////////////////////////////////////////////////////////////////////////
function TPluginVariation.GetNrVariables: integer;
begin
  Result := PluginData.PluginVarGetNrVariables;
end;

///////////////////////////////////////////////////////////////////////////////
function TPluginVariation.GetVariableNameAt(const Index: integer): string;
begin
  Result := PluginData.PluginVarGetVariableNameAt(Index);
end;

///////////////////////////////////////////////////////////////////////////////
function TPluginVariation.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := PluginData.PluginVarSetVariable(MyVariation,PChar(Name),value);
end;

///////////////////////////////////////////////////////////////////////////////
function TPluginVariation.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := PluginData.PluginVarGetVariable(MyVariation,PChar(Name),value);
end;

///////////////////////////////////////////////////////////////////////////////
function TPluginVariation.ResetVariable(const Name: string) : boolean;
var
  dummy: double;
begin
  if @PluginData.PluginVarResetVariable <> nil then
    Result := PluginData.PluginVarResetVariable(MyVariation, PChar(Name))
  else begin
    dummy := 0;
    Result := PluginData.PluginVarSetVariable(MyVariation,PChar(Name), dummy);
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure InitializePlugins;
var
  searchResult: TSearchRec;
  name, msg: string;
  PluginData : TPluginData;
begin
  NumBuiltinVars := NRLOCVAR + GetNrRegisteredVariations;
  // Try to find regular files matching *.dll in the plugins dir
  if FindFirst('.\Plugins3D\*.dll', faAnyFile, searchResult) = 0 then
  begin
    repeat
      with PluginData do begin
        //Load DLL and initialize plugins!
        PluginHandle := LoadLibrary(PChar('.\Plugins3D\'+searchResult.Name));
        if PluginHandle<>0 then begin
          @PluginVarGetName := GetProcAddress(PluginHandle,'PluginVarGetName');
          if @PluginVarGetName = nil then begin  // Must not be a valid plugin!
            FreeLibrary(PluginHandle);
            msg := msg + 'Invalid plugin type: "' + searchResult.Name + '" is not a plugin' + #13#10;
            continue;
          end;
          name := PluginVarGetName;
          if GetVariationIndex(name) >= 0 then begin
            FreeLibrary(PluginHandle);
            msg := msg + 'Cannot load plugin from ' + searchResult.Name + ': variation "' + name + '" already exists!' + #13#10;
          end
          else begin
            @PluginVarGetNrVariables    := GetProcAddress(PluginHandle,'PluginVarGetNrVariables');
            @PluginVarGetVariableNameAt := GetProcAddress(PluginHandle,'PluginVarGetVariableNameAt');
            @PluginVarCreate            := GetProcAddress(PluginHandle,'PluginVarCreate');
            @PluginVarDestroy           := GetProcAddress(PluginHandle,'PluginVarDestroy');
            @PluginVarInit              := GetProcAddress(PluginHandle,'PluginVarInit');
            @PluginVarInit3D            := GetProcAddress(PluginHandle,'PluginVarInit3D');
            @PluginVarPrepare           := GetProcAddress(PluginHandle,'PluginVarPrepare');
            @PluginVarCalc              := GetProcAddress(PluginHandle,'PluginVarCalc');
            @PluginVarGetVariable       := GetProcAddress(PluginHandle,'PluginVarGetVariable');
            @PluginVarSetVariable       := GetProcAddress(PluginHandle,'PluginVarSetVariable');
            @PluginVarResetVariable     := GetProcAddress(PluginHandle,'PluginVarResetVariable');

            RegisterVariation(TVariationPluginLoader.Create(PluginData));
          end;
        end else
          msg := msg + 'Cannot open plugin file: ' + searchResult.Name + #13#10;
      end;
    until (FindNext(searchResult) <> 0);
    SysUtils.FindClose(searchResult); //Since we use Windows unit (LoadLibrary)

    if msg <> '' then
      Application.MessageBox(
        PChar('There were problems with some of the plugins:' + #13#10#13#10 + msg),
        'Warning', MB_ICONWARNING or MB_OK);
  end;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  InitializePlugins;
end.

