unit varFan2;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationFan2 = class(TBaseVariation)
  private
    FX,FY: double;
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

{ TVariationTest }

///////////////////////////////////////////////////////////////////////////////
procedure TVariationFan2.CalcFunction;
const
  EPS = 1E-10;
var
  r,t,a : double;
  dx, dy, dx2: double;
  Angle: double;
begin
  r := sqrt(FTx^ * FTx^ + FTy^ * FTy^);
  if (FTx^ < -EPS) or (FTx^ > EPS) or (FTy^ < -EPS) or (FTy^ > EPS) then
     Angle := arctan2(FTx^, FTy^)
  else
    Angle := 0.0;

  dy := FY;
  dx := PI * (sqr(FX) + EPS);
  dx2 := dx/2;

  t := Angle+dy - System.Int((Angle + dy)/dx) * dx;
  if (t > dx2) then
    a := Angle - dx2
  else
    a := Angle + dx2;

  FPx^ := FPx^ + vvar * r * sin(a);
  FPy^ := FPy^ + vvar * r * cos(a);
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationFan2.Create;
begin
  FX := 2 * Random - 1;
  FY := 2 * Random - 1;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationFan2.GetInstance: TBaseVariation;
begin
  Result := TVariationFan2.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationFan2.GetName: string;
begin
  Result := 'fan2';
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationFan2.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'fan2_x';
  1: Result := 'fan2_y';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationFan2.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'fan2_x' then begin
    FX := Value;
    Result := True;
  end else if Name = 'fan2_y' then begin
    FY := Value;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationFan2.GetNrVariables: integer;
begin
  Result := 2
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationFan2.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'fan2_x' then begin
    Value := FX;
    Result := True;
  end else if Name = 'fan2_y' then begin
    Value := FY;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationFan2);
end.
