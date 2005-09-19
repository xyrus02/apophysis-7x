unit varblob;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationBlob = class(TBaseVariation)
  private
    FWaves: double;
    FLow:   double;
    FHigh:  double;
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
procedure TVariationBlob.CalcFunction;
const
  EPS = 1E-10;
var
  r : double;
  Angle: double;
begin
  r := sqrt(FTx^ * FTx^ + FTy^ * FTy^);
  if (FTx^ < -EPS) or (FTx^ > EPS) or (FTy^ < -EPS) or (FTy^ > EPS) then
     Angle := arctan2(FTx^, FTy^)
  else
    Angle := 0.0;

  r := r * (FLow + (FHigh - FLow) * (0.5 + 0.5 * sin(FWaves * Angle)));

  FPx^ := FPx^ + vvar * r * sin(Angle);
  FPy^ := FPy^ + vvar * r * cos(Angle);
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationBlob.GetName: string;
begin
  Result := 'blob';
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationBlob.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'blob_low';
  1: Result := 'blob_high';
  2: Result := 'blob_waves';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationBlob.GetNrVariables: integer;
begin
  Result := 3;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationBlob.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'blob_low' then begin
    FLow := Value;
    Result := True;
  end else if Name = 'blob_high' then begin
    FHigh := Value;
    Result := True;
  end else if Name = 'blob_waves' then begin
    //???????????? what for?:
    // Value is a var variable the checked/changed value is returned for showing 
    Value := Round(Value);
    FWaves := Value;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationBlob.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'blob_low' then begin
    Value := FLow;
    Result := True;
  end else if Name = 'blob_high' then begin
    Value := FHigh;
    Result := True;
  end else if Name = 'blob_waves' then begin
    Value := FWaves;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationBlob.Create;
begin
  inherited Create;

  FWaves := Round(2 + 5 * Random);
  FLow  := 0.2 + 0.5 * random;
  FHigh := 0.8 + 0.4 * random;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationBlob.GetInstance: TBaseVariation;
begin
  Result := TVariationBlob.Create;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationBlob);
end.
