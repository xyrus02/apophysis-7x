unit BaseVariation;

interface
type
  TBaseVariation = class
  protected

  public
    vvar:  double; // normalized interp coefs between variations
    FTx, FTy: ^double;
    FPx, FPy: ^double;

    class function GetName: string; virtual; abstract;
    class function GetInstance: TBaseVariation; virtual; abstract;

    class function GetNrVariables: integer; virtual;
    class function GetVariableNameAt(const Index: integer): string; virtual;

    function SetVariable(const Name: string; var value: double): boolean; virtual;
    function GetVariable(const Name: string; var value: double): boolean; virtual;

    procedure Prepare; virtual;

    procedure CalcFunction; virtual; abstract;
  end;

  TBaseVariationClass = class of TBaseVariation;


implementation

{ TBaseVariation }

///////////////////////////////////////////////////////////////////////////////
class function TBaseVariation.GetNrVariables: integer;
begin
  Result := 0;
end;

///////////////////////////////////////////////////////////////////////////////
function TBaseVariation.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
end;

///////////////////////////////////////////////////////////////////////////////
function TBaseVariation.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
end;

///////////////////////////////////////////////////////////////////////////////
class function TBaseVariation.GetVariableNameAt(const Index: integer): string;
begin
  Result := ''
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseVariation.prepare;
begin
end;

///////////////////////////////////////////////////////////////////////////////
end.