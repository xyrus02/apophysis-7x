{
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Borys, Peter Sdobnov
     Apophysis Copyright (C) 2007-2008 Piotr Borys, Peter Sdobnov
     
     Apophysis "3D hack" Copyright (C) 2007-2008 Peter Sdobnov
     Apophysis "7X" Copyright (C) 2009-2010 Georg Kiehne

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
  BaseVariation,  XFormMan,  Settings,
  Classes,  //TStrings/TStringList
  SysUtils, //FindFirst/FindNext/FindClose
  Forms;  //MessageBox

type
  TPluginVariationClass = class of TPluginVariation;

  TPluginData = record
    Instance: Integer;
    PluginHandle: THandle;
    PluginClass: TPluginVariationClass;

    PluginVarGetName:           function: PAnsiChar; cdecl;
    PluginVarGetNrVariables:    function: Integer; cdecl;
    PluginVarGetVariableNameAt: function(const Index: integer): PAnsiChar; cdecl;

    PluginVarCreate:       function: Pointer; cdecl;
    PluginVarDestroy:      function(var MyVariation: Pointer): LongBool; cdecl;
    PluginVarInit:         function(MyVariation, FPx, FPy, FTx, FTy: Pointer; vvar: double): LongBool; cdecl;
    PluginVarInit3D:       function(MyVariation, FPx, FPy, FPz, FTx, FTy, FTz: Pointer; vvar: double): LongBool; cdecl;
    PluginVarInitDC:       function(MyVariation, FPx, FPy, FPz, FTx, FTy, FTz, color: Pointer; vvar, a, b, c, d, e, f: double): LongBool; cdecl;
    PluginVarPrepare:      function(MyVariation: Pointer): LongBool; cdecl;
    PluginVarCalc:         function(MyVariation: Pointer): LongBool; cdecl;
    PluginVarGetVariable:  function(MyVariation: Pointer; const Name: PAnsiChar; var value: double): LongBool; cdecl;
    PluginVarSetVariable:  function(MyVariation: Pointer; const Name: PAnsiChar; var value: double): LongBool; cdecl;
    PluginVarResetVariable:function(MyVariation: Pointer; const Name: PAnsiChar) : LongBool; cdecl;
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

procedure InitializePlugins;

const CurrentPlatform =
{$ifdef Apo7X64}
  $00000040
{$else}
  $00000020
{$endif};

  //////////////////////////////////////////////////////////////////////

implementation

uses
  Windows, //LoadLibrary
  Math,
  Global,
  Registry;

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
  Result := String(PluginData.PluginVarGetName);
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
  Result := String(PluginData.PluginVarGetVariableNameAt(Index));
end;

///////////////////////////////////////////////////////////////////////////////

procedure TPluginVariation.Prepare;
begin
  with PluginData do begin
    if @PluginVarInitDC <> nil then
      PluginVarInitDC(MyVariation, Pointer(FPX), Pointer(FPy), Pointer(FPz), Pointer(FTx), Pointer(FTy), Pointer(FTz), Pointer(color), vvar, a, b, c, d, e, f)
    else if @PluginVarInit3D <> nil then
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
  Result := String(PluginData.PluginVarGetVariableNameAt(Index));
end;

///////////////////////////////////////////////////////////////////////////////
function TPluginVariation.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := PluginData.PluginVarSetVariable(MyVariation,PAnsiChar(AnsiString(Name)),value);
end;

///////////////////////////////////////////////////////////////////////////////
function TPluginVariation.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := PluginData.PluginVarGetVariable(MyVariation,PAnsiChar(AnsiString(Name)),value);
end;

///////////////////////////////////////////////////////////////////////////////
function TPluginVariation.ResetVariable(const Name: string) : boolean;
var
  dummy: double;
begin
  if @PluginData.PluginVarResetVariable <> nil then
    Result := PluginData.PluginVarResetVariable(MyVariation, PAnsiChar(AnsiString(Name)))
  else begin
    dummy := 0;
    Result := PluginData.PluginVarSetVariable(MyVariation,PAnsiChar(AnsiString(Name)), dummy);
  end;
end;

function GetPlatformOf(dllPath: string): integer;
var
  fs: TFilestream;
  signature: DWORD;
  dos_header: IMAGE_DOS_HEADER;
  pe_header: IMAGE_FILE_HEADER;
  opt_header: IMAGE_OPTIONAL_HEADER;
begin
  fs := TFilestream.Create(dllPath, fmOpenread or fmShareDenyNone);
  try
    fs.read(dos_header, SizeOf(dos_header));
    if dos_header.e_magic <> IMAGE_DOS_SIGNATURE then
    begin
      Result := 0;
      Exit;
    end;

    fs.seek(dos_header._lfanew, soFromBeginning);
    fs.read(signature, SizeOf(signature));
    if signature <> IMAGE_NT_SIGNATURE then
    begin
      Result := 0;
      Exit;
    end;

    fs.read(pe_header, SizeOf(pe_header));
    case pe_header.Machine of
      IMAGE_FILE_MACHINE_I386: Result := $00000020;
      IMAGE_FILE_MACHINE_AMD64: Result := $00000040;
    else
      Result := 0;
  end; { Case }

  finally
    fs.Free;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure InitializePlugins;
var
  Registry: TRegistry;
  searchResult: TSearchRec;
  dllPath, name, msg: string;
  PluginData : TPluginData;
  errno:integer;
  errstr:string;
begin
  NumBuiltinVars := NRLOCVAR + GetNrRegisteredVariations;
  PluginPath := ReadPluginDir;

  // Try to find regular files matching *.dll in the plugins dir
  if FindFirst(PluginPath + '*.dll', faAnyFile, searchResult) = 0 then
  begin
    repeat
      with PluginData do begin
        dllPath := PluginPath + searchResult.Name;

        //Check plugin platform
         if CurrentPlatform <> GetPlatformOf(dllPath)
         then continue;

        //Load DLL and initialize plugins!
        PluginHandle := LoadLibrary(PChar(dllPath));
        if PluginHandle<>0 then begin
          @PluginVarGetName := GetProcAddress(PluginHandle,'PluginVarGetName');
          if @PluginVarGetName = nil then begin  // Must not be a valid plugin!
            FreeLibrary(PluginHandle);
            msg := msg + 'Invalid plugin type: "' + searchResult.Name + '" is not a plugin' + #13#10;
            continue;
          end;
          name := String(PluginVarGetName);
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
            @PluginVarInitDC            := GetProcAddress(PluginHandle,'PluginVarInitDC');
            @PluginVarPrepare           := GetProcAddress(PluginHandle,'PluginVarPrepare');
            @PluginVarCalc              := GetProcAddress(PluginHandle,'PluginVarCalc');
            @PluginVarGetVariable       := GetProcAddress(PluginHandle,'PluginVarGetVariable');
            @PluginVarSetVariable       := GetProcAddress(PluginHandle,'PluginVarSetVariable');
            @PluginVarResetVariable     := GetProcAddress(PluginHandle,'PluginVarResetVariable');

            RegisterVariation(TVariationPluginLoader.Create(PluginData), @PluginVarInit3D <> nil, @PluginVarInitDC <> nil);
            RegisterVariationFile(ExtractFilePath(Application.ExeName) + 'Plugins\' + searchResult.Name, name);
          end;
        end else begin
          errno := GetLastError;
          errstr := SysErrorMessage(errno);
          msg := msg + 'Cannot open plugin file: ' + searchResult.Name + ' (Error #' + IntToStr(GetLastError) + ' - ' + errstr + ')' + #13#10;
        end;
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

end.

