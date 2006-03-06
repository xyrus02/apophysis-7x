unit varJuliaN;

interface

uses
  BaseVariation, XFormMan;

const
  var_n_name='julian_power';
  var_c_name='julian_c';

type
  TVariationJulian = class(TBaseVariation)
  private
    N: integer;
    c: double;

    cn: double;

  public
    constructor Create;

    class function GetName: string; override;
    class function GetInstance: TBaseVariation; override;

    class function GetNrVariables: integer; override;
    class function GetVariableNameAt(const Index: integer): string; override;

    function SetVariable(const Name: string; var value: double): boolean; override;
    function GetVariable(const Name: string; var value: double): boolean; override;

    procedure Prepare; override;
    procedure CalcFunction; override;
  end;

implementation

uses
  math;

// TVariationJulian

///////////////////////////////////////////////////////////////////////////////
constructor TVariationJulian.Create;
begin
  N := random(5) + 2;
  c := 1.0;
end;

procedure TVariationJulian.Prepare;
begin
  cn := c / N / 2;
end;

procedure TVariationJulian.CalcFunction;
{$if false}
var
  r: double;
  sina, cosa: extended;
begin
  sincos((arctan2(FTy^, FTx^) + 2*pi*random(n)) / N, sina, cosa);
  r := vvar * Math.Power(sqr(FTx^) + sqr(FTy^), cn);

  FPx^ := FPx^ + r * cosa;
  FPy^ := FPy^ + r * sina;
{$else}
asm
    mov     edx, [eax + FTy]
    fld     qword ptr [edx]
    fld     qword ptr [eax + cn]
    mov     edx, [eax + FTx]
    fld     qword ptr [edx]
    fld     st(2)
    fld     st(1)
    fpatan
    mov     ecx, eax
    mov     eax, dword ptr [eax + N]
    call    System.@RandInt
    push    eax
    fild    dword ptr [esp]
    add     esp, 4
    fldpi
    fadd    st, st
    fmulp
    faddp
    fidiv   dword ptr [ecx + N]

    fxch    st(3)
    fmul    st, st
    fxch    st(1)
    fmul    st, st
    faddp
//  ---  x^y = 2^(y*log2(x))
    fyl2x
    fld     st
    frndint
    fsub    st(1), st
    fxch    st(1)
    f2xm1
    fld1
    fadd
    fscale
    fstp    st(1)
//  ---
    fmul    qword ptr [ecx + vvar]
    fxch    st(1)
    fsincos
    fmul    st, st(2)

    mov     edx, [ecx + FPx]
    fadd    qword ptr [edx]
    fstp    qword ptr [edx]
    fmulp
    mov     edx, [ecx + FPy]
    fadd    qword ptr [edx]
    fstp    qword ptr [edx]
    fwait
{$ifend}
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationJulian.GetInstance: TBaseVariation;
begin
  Result := TVariationJulian.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationJulian.GetName: string;
begin
  Result := 'julian';
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationJulian.GetVariableNameAt(const Index: integer): string;
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
  end;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationJulian.GetNrVariables: integer;
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
  RegisterVariation(TVariationJulian);
end.
