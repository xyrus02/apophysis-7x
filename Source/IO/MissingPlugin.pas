unit MissingPlugin;

interface
  uses Windows, Global, Classes, LoadTracker, ComCtrls, SysUtils,
       ControlPoint, Translation;
  const RegisteredAttributes : array[0..13] of string = (
    'weight', 'color', 'symmetry', 'color_speed', 'coefs', 'chaos',
    'plotmode', 'opacity', 'post', 'var', 'var1', 'var_color',
    'name', 'linear3D'
  );
  var  MissingPluginList : TStringList;
       Parsing : boolean;
       ErrorMessageString : string;

  procedure BeginParsing;
  procedure CheckAttribute(attr:string);
  function EndParsing(cp : TControlPoint; var statusPanelText : string): boolean;
  procedure AnnoyUser;
implementation

  procedure BeginParsing;
  begin
    MissingPluginList := TStringList.Create;
    if (AutoOpenLog = true) then
    if (LoadForm.Showing = false) then
      LoadForm.Show;
  end;

  procedure CheckAttribute(attr:string);
  var i : integer;
  begin
    for i := 0 to Length(RegisteredAttributes)-1 do
      if attr=RegisteredAttributes[i] then exit;
        
    if MissingPluginList.IndexOf(attr) < 0 then
      MissingPluginList.Add(attr);
  end;

  function EndParsing(cp : TControlPoint; var statusPanelText : string): boolean;
  var str, str2 : string; i : integer; newl : TStringList;
  begin
    str2 := TextByKey('main-status-variationsorvariables');
    if (cp.used_plugins.Count > 0) then begin
      newl := TStringList.Create;
      for i := 0 to MissingPluginList.Count - 1 do begin
        if cp.used_plugins.IndexOf(MissingPluginList[i]) >= 0 then
          newl.Add(MissingPluginList[i]);
      end;
      str2 := TextByKey('main-status-plugins');
      MissingPluginList.Free;
      MissingPluginList := newl;
    end;

    if MissingPluginList.Count > 0 then begin
      statusPanelText := Format(TextByKey('main-status-loadingerrorcount'), [MissingPluginList.Count]);

      for i := 0 to MissingPluginList.Count - 1 do
        str := str + #13#10 + '  - ' + MissingPluginList[i];
      ErrorMessageString := Format(TextByKey('main-status-morepluginsneeded'), [cp.name, str2]) + str;
      LoadForm.Output.Text := LoadForm.Output.Text +
        ErrorMessageString + #13#10#13#10;
      Result := false;
    end else begin
      statusPanelText := TextByKey('main-status-noloadingerrors');
      ErrorMessageString := '';
      Result := true;
    end;
    MissingPluginList.Free;
  end;

  procedure AnnoyUser;
  begin
    if (ErrorMessageString = '') or (not WarnOnMissingPlugin) then exit;
    MessageBox($00000000, PChar(ErrorMessageString), PChar('Apophysis'), MB_ICONHAND or MB_OK);
  end;
end.
