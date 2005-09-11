unit VarTest;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationTest = class(TBaseVariation)
  public
    class function GetName: string; override;
    class function GetInstance: TBaseVariation; override;

    procedure CalcFunction; override;
  end;

implementation

uses
  math;

{ TVariationTest }

///////////////////////////////////////////////////////////////////////////////
procedure TVariationTest.CalcFunction;
const
  EPS = 1E-10;
var
  r : double;
//  dx, dy, dx2: double;
  Angle: double;
begin
  r := sqrt(FTx^ * FTx^ + FTy^ * FTy^);
  if (FTx^ < -EPS) or (FTx^ > EPS) or (FTy^ < -EPS) or (FTy^ > EPS) then
     Angle := arctan2(FTx^, FTy^)
  else
    Angle := 0.0;

  Angle := Angle + Max(0, (3 - r)) * sin(2 * r);

//   r:=  R - 0.04 * sin(6.2 * R - 1) - 0.008 * R;

  FPx^ := FPx^ + vvar * r * cos(Angle);
  FPy^ := FPy^ + vvar * r * sin(Angle);

//  FPx^ := FPx^ + vvar * FTx^;
//  FPy^ := FPy^ + vvar * FTy^;

end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationTest.GetInstance: TBaseVariation;
begin
  Result := TVariationTest.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationTest.GetName: string;
begin
  Result := 'test';
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationTest);
end.
