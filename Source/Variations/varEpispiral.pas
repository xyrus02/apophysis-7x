unit varEpispiral; // <-- JK Changed unit name to avoid clobbering original
//by Joel Faber  (adapted for plugin example by Jed Kelsey (JK)
interface

uses
  BaseVariation, XFormMan;  // <-- JK Removed some (unnecessary?) units

const
  EPS: double = 1E-6;
type
  TVariationEpispiral = class(TBaseVariation)
  private
   n, thickness, holes : double;

  public
    constructor Create;

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

implementation

uses
  Math;

// TVariationEpispiral

///////////////////////////////////////////////////////////////////////////////
constructor TVariationEpispiral.Create;
begin
  n  := 6.0;
  thickness := 0.0;
  holes := 1.0;
end;

procedure TVariationEpispiral.Prepare;
begin                             //calculate constants
  // nothing for now
end;

///////////////////////////////////////////////////////////////////////////////
procedure TVariationEpispiral.CalcFunction;
var
  t, theta : double;
begin
  theta := arctan2(FTy^, FTx^);

  t := (random*thickness)*(1/cos(n*theta)) - holes;


  if (abs(t) = 0) then
    begin
      FPx^ := FPx^;
      FPy^ := FPy^;
    end
  else
    begin
      FPx^ := FPx^ + vvar*t*cos(theta);
      FPy^ := FPy^ + vvar*t*sin(theta);
    end;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationEpispiral.GetInstance: TBaseVariation;
begin
  Result := TVariationEpispiral.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationEpispiral.GetName: string;
begin
  Result := 'epispiral';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationEpispiral.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'epispiral_n';
  1: Result := 'epispiral_thickness';
  2: Result := 'epispiral_holes';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationEpispiral.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'epispiral_n' then begin
    n := Value;
    Result := True;
  end else if Name = 'epispiral_thickness' then begin
    thickness := Value;
    Result := True;
  end
  else if Name = 'epispiral_holes' then begin
    holes := Value;
    Result := True;
  end
end;

function TVariationEpispiral.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = 'epispiral_n' then begin
    n := 6.0;
    Result := True;
  end else if Name = 'epispiral_thickness' then begin
    thickness := 0.0;
    Result := True;
  end
  else if Name = 'epispiral_holes' then begin
    holes := 0.0;
    Result := True;
  end
end;


///////////////////////////////////////////////////////////////////////////////
function TVariationEpispiral.GetNrVariables: integer;
begin
   Result := 3;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationEpispiral.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'epispiral_n' then begin
    Value := n;
    Result := True;
  end else if Name = 'epispiral_thickness' then begin
    Value := thickness;
    Result := True;
  end
  else if Name = 'epispiral_holes' then begin
    Value := holes;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationEpispiral), true, false);  // <-- JK Plugin manager does this
end.

