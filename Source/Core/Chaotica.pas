unit Chaotica;

interface

uses Global, RegularExpressionsCore, RegexHelper, Classes, SysUtils, XFormMan, Windows,
  ShellAPI, Forms, ControlPoint, Translation;

function C_GetPathOf(filename: string; usex64: boolean): string;
function C_SupportsDllPlugins(usex64: boolean): boolean;
function C_IsDllPluginBlacklisted(filename: string; usex64: boolean): boolean;
function C_IsVariationNative(name: string; usex64: boolean): boolean;
function C_IsDllPluginInstalled(filename: string): boolean;

procedure C_SyncDllPlugins;
procedure C_InstallVariation(name: string);
procedure C_ExecuteChaotica(flamexml: string; plugins: TStringList; usex64: boolean);

implementation

uses Main;

function CheckX64: Boolean;
var
  SEInfo: TShellExecuteInfo;
  ExitCode: DWORD;
  ExecuteFile, ParamString, StartInString: string;
begin
  {$ifdef Apo7X64}
  Result := true;
  exit;
  {$endif}

  ExecuteFile:=ExtractFilePath(Application.ExeName)+'chk64.exe';
  FillChar(SEInfo, SizeOf(SEInfo), 0);
  SEInfo.cbSize := SizeOf(TShellExecuteInfo);

  with SEInfo do begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    Wnd := Application.Handle;
    lpFile := PChar(ExecuteFile) ;
    nShow := SW_SHOWNORMAL;
  end;
  
  if ShellExecuteEx(@SEInfo) then
  begin
    repeat
      Application.ProcessMessages;
      GetExitCodeProcess(SEInfo.hProcess, ExitCode);
    until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
    Result := (ExitCode = 0);
  end else begin
    Result := false;
  end;
end;

function C_GetPathOf(filename: string; usex64: boolean): string;
var
  subf: string;
begin
  if usex64 then subf := '64bit'
  else subf := '32bit';
  Result := ChaoticaPath + '\' + subf + '\' + filename;
end;

function C_SupportsDllPlugins(usex64: boolean): boolean;
const
  re_root : string = '<variation_compatibility\s+(.*?)>.*?</variation_compatibility>';
  re_attrib : string = 'supports_dll_plugins="(.*?)"';
var
  xml_file : TStringList;
  xml_text, attrib, value : string;
begin
  if usex64 then begin
    Result := false;
    Exit;
  end;

  xml_file := TStringList.Create;
  xml_file.LoadFromFile(C_GetPathOf('variation_compatibility.xml', false));
  xml_text := xml_file.Text;
  xml_file.Destroy;

  attrib := GetStringPart(xml_text, re_root, 1, 'supports_dll_plugins="false"');
  value := GetStringPart(attrib, re_attrib, 1, 'false');

  Result := (value = 'true');
end;

function C_IsDllPluginBlacklisted(filename: string; usex64: boolean): boolean;
var
  i: integer;
  blacklist: TStringList;
begin
  blacklist := TStringList.Create;
  blacklist.LoadFromFile(C_GetPathOf('plugin_dll_blacklist.txt', usex64));

  for i := 0 to blacklist.Count - 1 do begin
    if LowerCase(filename) = LowerCase(blacklist.Strings[i]) then begin
      Result := true;
      blacklist.Destroy;
      Exit;
    end;
  end;

  blacklist.Destroy;
  Result := false;
end;

function C_IsVariationNative(name: string; usex64: boolean): boolean;
const
  re_root : string = '<variation_compatibility.*?>(.*?)</variation_compatibility>';
  re_var : string = '<variation name="(.*?)".*?/>';
var
  xml, var_name : string;
  xml_file : TStringList;
  find_var : TPerlRegEx;
  found_var : boolean;
begin

  xml_file := TStringList.Create;
  xml_file.LoadFromFile(C_GetPathOf('variation_compatibility.xml', false));
  xml := xml_file.Text;
  xml_file.Destroy;

  find_var := TPerlRegEx.Create;
  find_var.RegEx := Utf8String(re_var);
  find_var.Options := [preSingleLine, preCaseless];
  find_var.Subject := Utf8String(GetStringPart(xml, re_root, 1, ''));
  found_var := find_var.Match;

  while found_var do begin
    var_name := String(find_var.Groups[1]);
    found_var := find_var.MatchAgain;

    if LowerCase(name) = var_name then begin
      find_var.Destroy;
      Result := true;
      Exit;
    end;
  end;

  find_var.Destroy;
  Result := false;
end;

function C_IsDllPluginInstalled(filename: string): boolean;
var
  path : string;
begin
  path := C_GetPathOf('plugins\' + filename, false);
  Result := FileExists(path);
end;

////////////////////////////////////////////////////////////////////

procedure C_InstallVariation(name: string);
var
  filename: string;
begin
  filename := GetFileNameOfVariation(name);

  if (filename = '') then Exit;
  if C_IsDllPluginInstalled(filename) then Exit;

  CopyFile(PCHAR(filename), PCHAR(C_GetPathOf('plugins\' +
    ExtractFileName(filename), false)), false);
end;

procedure C_SyncDllPlugins;
var
  src_dir: string;
  tgt_dir: string;

  searchResult: TSearchRec;
begin
  src_dir := PluginPath;
  tgt_dir := C_GetPathOf('Plugins', false);

  if (not DirectoryExists(src_dir)) then Exit;
  if (not DirectoryExists(tgt_dir)) then Exit;

  // First clear all plugins on Chaotica side
  if FindFirst(tgt_dir + '\*.dll', faAnyFile, searchResult) = 0 then
  begin
    repeat
      DeleteFile(PCHAR(tgt_dir + '\' + searchResult.Name)) ;
    until (FindNext(searchResult) <> 0);
    SysUtils.FindClose(searchResult);
  end;

  // Then copy all plugins from Apophysis to Chaotica
  if FindFirst(src_dir + '*.dll', faAnyFile, searchResult) = 0 then
  begin
    repeat
      if not C_IsDllPluginBlacklisted(searchResult.Name, false)
      then CopyFile(
        PCHAR(src_dir + '\' + searchResult.Name),
        PCHAR(tgt_dir + '\' + searchResult.Name),
        false);
    until (FindNext(searchResult) <> 0);
    SysUtils.FindClose(searchResult);
  end;
end;

procedure C_ExecuteChaotica(flamexml: string; plugins: TStringList; usex64: boolean);
var
  i: integer;
  name, fname: string;
  fails: TStringList;
  txt: TStringList;
  fin_usex64: boolean;
begin
  fails := TStringList.Create;

  {$ifdef Apo7X64}
  fin_usex64 := true;
  {$else}
  fin_usex64 := usex64 and CheckX64;
  for i := 0 to plugins.Count - 1 do begin
    name := GetFileNameOfVariation(plugins.Strings[i]);
    if (name = '') then name := plugins.Strings[i];
    fin_usex64 := fin_usex64 and C_IsVariationNative(name, usex64);
  end;

  for i := 0 to plugins.Count - 1 do begin
    name := GetFileNameOfVariation(plugins.Strings[i]);
    if (name = '') then name := plugins.Strings[i];           // assume built-in

    if not C_IsVariationNative(name, fin_usex64) then begin   // not native -> try install
      if C_SupportsDllPlugins(fin_usex64) then                // dll unsupported -> fail
        fails.Add(plugins.Strings[i])
      else if C_IsDllPluginBlacklisted(name, fin_usex64) then // dll supported and blacklisted -> fail
        fails.Add(plugins.Strings[i])
      ;//else C_InstallVariation(plugins.Strings[i]);         // dll supported and not blacklisted -> install
       // ^^^ this is done on Apophysis startup now!
    end;
  end;
  {$endif}

  name := C_GetPathOf('chaotica.exe', fin_usex64);
  if (not FileExists(name)) then begin
    messagebox(0, PCHAR(TextByKey('main-status-nochaotica')),
      PCHAR('Apophysis 7X'), MB_ICONHAND);
    Exit;
  end;

  if (fails.Count > 0) then begin
    messagebox(0, PCHAR(TextByKey('main-status-oldchaotica')),
      PCHAR('Apophysis 7X'), MB_ICONHAND or MB_OK);
  end;

  fname := GetEnvironmentVariable('TEMP') + '\chaotica_export.flame';
  txt := TStringList.Create;

  txt.Text := flamexml;
  txt.SaveToFile(fname);

  txt.Destroy;
  fails.Destroy;

  //if fin_usex64 then MessageBox(0, PCHAR('DBG:x64'), PCHAR(''), MB_OK)
  //else MessageBox(0, PCHAR('DBG:x86'), PCHAR(''), MB_OK) ;

  ShellExecute(application.handle, PChar('open'), pchar(name),
    PChar('"' + fname + '"'), PChar(ExtractFilePath(name)), SW_SHOWNORMAL);
end;

end.
