unit CommandLine;

interface
    uses Dialogs, RegularExpressionsCore;

    type TCommandLine = class
    public
        CreateFromTemplate : boolean;
        TemplateFile : string;
        TemplateName : string;
        Lite: boolean;

        procedure Load;
      
    end;

implementation

procedure TCommandLine.Load;
var
  Regex: TPerlRegEx;
begin
  Regex := TPerlRegEx.Create;
  Regex.RegEx := '-template\s+"(.+)"\s+"(.+)"';
  Regex.Options := [preSingleLine, preCaseless];
  Regex.Subject := Utf8String(CmdLine);
  CreateFromTemplate := false;
  if Regex.Match then begin
	  if Regex.GroupCount = 2 then begin
      CreateFromTemplate := true;
      TemplateFile := String(Regex.Groups[1]);
      TemplateName := String(Regex.Groups[2]);
  	end;
  end;
  Regex.Destroy;

  Regex := TPerlRegEx.Create;
  Regex.RegEx := '-lite';
  Regex.Options := [preSingleLine, preCaseless];
  Regex.Subject := Utf8String(CmdLine);
  CreateFromTemplate := false;
  if Regex.Match then begin
    Lite := true;
  end;
  Regex.Destroy;
end;
  
end.
