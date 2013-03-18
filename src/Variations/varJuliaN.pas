unit varJuliaN;

interface

uses
  BaseVariation, XFormMan;

const
  var_name = 'julian';
  var_n_name='julian_power';
  var_c_name='julian_dist';

{$ifdef Apo7X64}
{$else}
  {$define _ASM_}
{$endif}

type
  TVariationJulian = class(TBaseVariation)
  private
    N: integer;
    c: double;

    absN: integer;
    cN, vvar2: double;

    procedure CalcPower1;
    procedure CalcPowerMinus1;
    procedure CalcPower2;
    procedure CalcPowerMinus2;

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
    procedure GetCalcFunction(var f: TCalcFunction); override;
  end;

implementation

uses
  Math;

// TVariationJulian

///////////////////////////////////////////////////////////////////////////////
constructor TVariationJulian.Create;
begin
  N := random(5) + 2;
  c := 1.0;
end;

procedure TVariationJulian.Prepare;
begin
  absN := abs(N);
  cN := c / N / 2;

  vvar2 := vvar * sqrt(2)/2;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TVariationJulian.GetCalcFunction(var f: TCalcFunction);
begin
  if c = 1 then begin
    if N = 2 then f := CalcPower2
    else if N = -2 then f := CalcPowerMinus2
    else if N = 1 then f := CalcPower1
    else if N = -1 then f := CalcPowerMinus1
    else f := CalcFunction;
  end
  else f := CalcFunction;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TVariationJulian.CalcFunction;
var
  r: double;
  sina, cosa: extended;
begin
  sincos((arctan2(FTy^, FTx^) + 2*pi*random(absN)) / N, sina, cosa);
  r := vvar * Math.Power(sqr(FTx^) + sqr(FTy^), cN);

  FPx^ := FPx^ + r * cosa;
  FPy^ := FPy^ + r * sina;
  FPz^ := FPz^ + vvar * FTz^;
end;

procedure TVariationJulian.CalcPower2;
var
  d: double;
begin
  d := sqrt( sqrt(sqr(FTx^) + sqr(FTy^)) + FTx^ );

  if random(2) = 0 then begin
    FPx^ := FPx^ + vvar2 * d;
    FPy^ := FPy^ + vvar2 / d * FTy^;
  end
  else begin
    FPx^ := FPx^ - vvar2 * d;
    FPy^ := FPy^ - vvar2 / d * FTy^;
  end;
  FPz^ := FPz^ + vvar * FTz^;
end;

procedure TVariationJulian.CalcPowerMinus2;

var
  r, xd: double;
begin
  r := sqrt(sqr(FTx^) + sqr(FTy^));
  xd := r + FTx^;

  r := vvar / sqrt(r * (sqr(Fty^) + sqr(xd)) );

  if random(2) = 0 then begin
    FPx^ := FPx^ + r * xd;
    FPy^ := FPy^ - r * FTy^;
  end
  else begin
    FPx^ := FPx^ - r * xd;
    FPy^ := FPy^ + r * FTy^;
  end;
  FPz^ := FPz^ + vvar * FTz^;
end;

procedure TVariationJulian.CalcPower1;
begin
  FPx^ := FPx^ + vvar * FTx^;
  FPy^ := FPy^ + vvar * FTy^;
  FPz^ := FPz^ + vvar * FTz^;
end;

procedure TVariationJulian.CalcPowerMinus1;
var
  r: double;
begin
  r := vvar / (sqr(FTx^) + sqr(FTy^));

  FPx^ := FPx^ + r * FTx^;
  FPy^ := FPy^ - r * FTy^;
  FPz^ := FPz^ + vvar * FTz^;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationJulian.GetInstance: TBaseVariation;
begin
  Result := TVariationJulian.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationJulian.GetName: string;
begin
  Result := var_name;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationJulian.GetVariableNameAt(const Index: integer): string;
begin
  case Index of
  0: Result := var_n_name;
  1: Result := var_c_name;
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationJulian.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = var_n_name then begin
    N := Round(Value);
    if N = 0 then N := 1;
    Value := N;
    Result := True;
  end
  else if Name = var_c_name then begin
    c := value;
    Result := True;
  end;
end;

function TVariationJulian.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = var_n_name then begin
    if N = 2 then N := -2
    else N := 2;
    Result := True;
  end
  else if Name = var_c_name then begin
    c := 1;
    Result := True;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationJulian.GetNrVariables: integer;
begin
  Result := 2;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationJulian.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = var_n_name then begin
    Value := N;
    Result := true;
  end
  else if Name = var_c_name then begin
    Value := c;
    Result := true;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationJulian), true, false);
end.

