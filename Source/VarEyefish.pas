unit VarEyefish;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationEyefish = class(TBaseVariation)
  public
    class function GetName: string; override;
    class function GetInstance: TBaseVariation; override;

    procedure CalcFunction; override;
  end;

implementation

uses
  math;

// TVariationEyefish

///////////////////////////////////////////////////////////////////////////////
procedure TVariationEyefish.CalcFunction;
var
  r: double;
begin
  r := 2 / (sqrt(FTx^ * FTx^ + FTy^ * FTy^) + 1);
  FPx^ := FPx^ + vvar * r * FTx^;
  FPy^ := FPy^ + vvar * r * FTy^;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationEyefish.GetInstance: TBaseVariation;
begin
  Result := TVariationEyefish.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationEyefish.GetName: string;
begin
  Result := 'eyefish';
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationEyefish);
end.
