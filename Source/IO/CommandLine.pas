unit CommandLine;

interface
    uses Dialogs, PerlRegEx;

    type TCommandLine = class
    public
        CreateFromTemplate : boolean;
        TemplateFile : string;
        TemplateName : string;

        procedure Load;
      
    end;

implementation

procedure TCommandLine.Load;
var
  Regex: TPerlRegEx;
begin
  Regex := TPerlRegEx.Create(nil);
  Regex.RegEx := '-template\s+"(.+)"\s+"(.+)"';
  Regex.Options := [preSingleLine, preCaseless];
  Regex.Subject := CmdLine;

  CreateFromTemplate := false;
  if Regex.Match then begin
	  if Regex.SubExpressionCount = 2 then begin
      CreateFromTemplate := true;
      TemplateFile := Regex.SubExpressions[1];
      TemplateName := Regex.SubExpressions[2];
  	end;
  end;
end;
  
end.
