unit varRings2;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationRings2 = class(TBaseVariation)
  private
    FVal: double;
  public
    constructor Create;

    class function GetName: string; override;
    class function GetInstance: TBaseVariation; override;

    class function GetNrVariables: integer; override;
    class function GetVariableNameAt(const Index: integer): string; override;

    function SetVariable(const Name: string; var value: double): boolean; override;
    function GetVariable(const Name: string; var value: double): boolean; override;


    procedure CalcFunction; override;
  end;

implementation

uses
  Math;

const
  EPS = 1E-10;


{ TVariationTest }

///////////////////////////////////////////////////////////////////////////////
procedure TVariationRings2.CalcFunction;
var
  dx,r: double;
  Length: double;
  Angle: double;
begin
  Length := sqrt(FTx^ * FTx^ + FTy^ * FTy^);
  if (FTx^ < -EPS) or (FTx^ > EPS) or (FTy^ < -EPS) or (FTy^ > EPS) then
     Angle := arctan2(FTx^, FTy^)
  else
    Angle := 0.0;

  dx := sqr(FVal) + EPS;
  r := Length + dx - System.Int((Length + dx)/(2 * dx)) * 2 * dx - dx + Length * (1-dx);

  FPx^ := FPx^ + vvar * r * sin(Angle);
  FPy^ := FPy^ + vvar * r * cos(Angle);
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationRings2.Create;
begin
  FVal := Random * 2;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationRings2.GetInstance: TBaseVariation;
begin
  Result := TVariationRings2.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationRings2.GetName: string;
begin
  Result := 'rings2';
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationRings2.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'rings2_val';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationRings2.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'rings2_val' then begin
    FVal := Value;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationRings2.GetNrVariables: integer;
begin
  Result := 1
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationRings2.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'rings2_val' then begin
    Value := FVal;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationRings2);
end.
