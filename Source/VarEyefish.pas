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
  Flength, r: double;
begin
  Flength := sqrt(FTx^ * FTx^ + FTy^ * FTy^);

  r := 2 * Flength / (Flength + 1);
  FPx^ := FPx^ + vvar * r * FTx^ / Flength;
  FPy^ := FPy^ + vvar * r * FTy^ / Flength;
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
