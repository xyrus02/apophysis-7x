unit varJuliaScope;

interface

uses
  BaseVariation, XFormMan;

const
  variation_name='juliascope';
  var_n_name='juliascope_power';
  var_c_name='juliascope_dist';

{$define _ASM_}

type
  TVariationJuliaScope = class(TBaseVariation)
  private
    power: integer;
    distortion: double;

    rN: integer;
    invDistPower: double;

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
  math;

// TVariationJuliaScope

///////////////////////////////////////////////////////////////////////////////
constructor TVariationJuliaScope.Create;
begin
  power := random(5) + 2;
  distortion := 1.0;
end;

procedure TVariationJuliaScope.Prepare;
begin
  rN := abs(power);
  invDistPower := distortion / power / 2;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TVariationJuliaScope.GetCalcFunction(var f: TCalcFunction);
begin
  if distortion = 1 then begin
    if power = 2 then f := CalcPower2
    else if power = -2 then f := CalcPowerMinus2
    else if power = 1 then f := CalcPower1
    else if power = -1 then f := CalcPowerMinus1
    else f := CalcFunction;
  end
  else f := CalcFunction;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TVariationJuliaScope.CalcFunction;
{$ifndef _ASM_}
var
  rnd: integer;
  r: double;
  sina, cosa: extended;
begin
  rnd := random(rN);
  if (rnd and 1) = 0 then
    sincos( (2*pi*rnd + arctan2(FTy^, FTx^)) / power, sina, cosa)
  else
    sincos( (2*pi*rnd - arctan2(FTy^, FTx^)) / power, sina, cosa);
  r := vvar * Math.Power(sqr(FTx^) + sqr(FTy^), invDistPower);
  FPx^ := FPx^ + r * cosa;
  FPy^ := FPy^ + r * sina;
{$else}
asm
    mov     edx, [eax + FTy]
    fld     qword ptr [edx]
    fld     qword ptr [eax + invDistPower]
    mov     edx, [eax + FTx]
    fld     qword ptr [edx]
    fld     st(2)
    fld     st(1)
    fpatan
    mov     ecx, eax
    mov     eax, dword ptr [eax + rN]
    call    System.@RandInt
    push    eax

    shr     eax, 1
    jnc     @even
    fchs
@even:

    fldpi
    fadd    st, st
    fimul   dword ptr [esp]
    add     esp, 4
    faddp
    fidiv   dword ptr [ecx + power]

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
{$endif}
end;

procedure TVariationJuliaScope.CalcPower2;
{$ifndef _ASM_}
var
  r: double;
  sina, cosa: extended;
begin
  if random(2) = 0 then
    sincos(arctan2(FTy^, FTx^)/2, sina, cosa)
  else
    sincos(pi - arctan2(FTy^, FTx^)/2, sina, cosa);

  r := vvar * sqrt(sqrt(sqr(FTx^) + sqr(FTy^)));

  FPx^ := FPx^ + r * cosa;
  FPy^ := FPy^ + r * sina;
{$else}
asm
    mov     edx, [eax + FTy]
    fld     qword ptr [edx]
    mov     edx, [eax + FTx]
    fld     qword ptr [edx]
    fld     st(1)
    fld     st(1)
    fpatan
    fld1
    fadd    st, st
    fdivp   st(1), st
    mov     ecx, eax
    //mov     eax, 2
    call    System.@RandInt

    shr     eax, 1
    jnc     @skip
    fldpi
    fsubrp  st(1), st
@skip:

{
    push    eax

    shr     eax, 1
    jnc     @even
    fchs
@even:

    fldpi
    fimul   dword ptr [esp]
    add     esp, 4
    faddp
}
    fxch    st(2)
    fmul    st, st
    fxch    st(1)
    fmul    st, st
    faddp
    fsqrt
    fsqrt
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
{$endif}
end;

procedure TVariationJuliaScope.CalcPowerMinus2;
{$ifndef _ASM_}
var
  r: double;
  sina, cosa: extended;
begin
  if random(2) = 0 then
    sincos(arctan2(FTy^, FTx^)/2, sina, cosa)
  else
    sincos(pi - arctan2(FTy^, FTx^)/2, sina, cosa);
  r := vvar / sqrt(sqrt(sqr(FTx^) + sqr(FTy^)));

  FPx^ := FPx^ + r * cosa;
  FPy^ := FPy^ - r * sina;
{$else}
asm
    mov     edx, [eax + FTy]
    fld     qword ptr [edx]
    mov     edx, [eax + FTx]
    fld     qword ptr [edx]
    fld     st(1)
    fld     st(1)
    fpatan
    fld1
    fadd    st, st
    fdivp   st(1), st
    mov     ecx, eax
    mov     eax, 2
    call    System.@RandInt

    shr     eax, 1
    jnc     @skip
    fldpi
    fsubrp  st(1), st
@skip:
    
{    push    eax

    shr     eax, 1
    jnc     @even
    fchs
@even:

    fldpi
    fimul   dword ptr [esp]
    add     esp, 4
    faddp
}
    fxch    st(2)
    fmul    st, st
    fxch    st(1)
    fmul    st, st
    faddp
    fsqrt
    fsqrt
    fdivr   qword ptr [ecx + vvar]
    fxch    st(1)

    fsincos

    fmul    st, st(2)
    mov     edx, [ecx + FPx]
    fadd    qword ptr [edx]
    fstp    qword ptr [edx]
    fmulp
    mov     edx, [ecx + FPy]
    fsubr   qword ptr [edx]
    fstp    qword ptr [edx]
    fwait
{$endif}
end;

procedure TVariationJuliaScope.CalcPower1;
{$ifndef _ASM_}
begin
  FPx^ := FPx^ + vvar * FTx^;
  FPy^ := FPy^ + vvar * FTy^;
{$else}
asm
    mov     edx, [eax + FTy]
    fld     qword ptr [edx]
    mov     edx, [eax + FTx]
    fld     qword ptr [edx]
    fld     qword ptr [eax + vvar]
    fmul    st(2), st
    fmulp
    mov     edx, [eax + FPx]
    fadd    qword ptr [edx]
    fstp    qword ptr [edx]
    mov     edx, [eax + FPy]
    fadd    qword ptr [edx]
    fstp    qword ptr [edx]
    fwait
{$endif}
end;

procedure TVariationJuliaScope.CalcPowerMinus1;
{$ifndef _ASM_}
var
  r: double;
begin
  r := vvar / (sqr(FTx^) + sqr(FTy^));

  FPx^ := FPx^ + r * FTx^;
  FPy^ := FPy^ - r * FTy^;
{$else}
asm
    mov     edx, [eax + FTy]
    fld     qword ptr [edx]
    mov     edx, [eax + FTx]
    fld     qword ptr [edx]
    fld     st(1)
    fmul    st, st
    fld     st(1)
    fmul    st, st
    faddp
    fdivr   qword ptr [eax + vvar]
    fmul    st(2), st
    fmulp
    mov     edx, [eax + FPx]
    fadd    qword ptr [edx]
    fstp    qword ptr [edx]
    mov     edx, [eax + FPy]
    fsubr   qword ptr [edx]
    fstp    qword ptr [edx]
    fwait
{$endif}
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationJuliaScope.GetInstance: TBaseVariation;
begin
  Result := TVariationJuliaScope.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationJuliaScope.GetName: string;
begin
  Result := variation_name;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationJuliaScope.GetVariableNameAt(const Index: integer): string;
begin
  case Index of
  0: Result := var_n_name;
  1: Result := var_c_name;
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationJuliaScope.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = var_n_name then begin
    power := Round(Value);
    if power = 0 then power := 1;
    Value := power;
    Result := True;
  end
  else if Name = var_c_name then begin
    distortion := value;
    Result := True;
  end;
end;

function TVariationJuliaScope.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = var_n_name then begin
    if power = 2 then power := -2
    else power := 2;
    Result := True;
  end
  else if Name = var_c_name then begin
    distortion := 1;
    Result := True;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationJuliaScope.GetNrVariables: integer;
begin
  Result := 2;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationJuliaScope.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = var_n_name then begin
    Value := power;
    Result := true;
  end
  else if Name = var_c_name then begin
    Value := distortion;
    Result := true;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationJuliaScope));
end.
