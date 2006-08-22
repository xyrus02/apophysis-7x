unit varJuliaN;

interface

uses
  BaseVariation, XFormMan;

const
  var_n_name='julian_power';
  var_c_name='julian_dist';

{$define _ASM_}

type
  TVariationJulian = class(TBaseVariation)
  private
    N: integer;
    c: double;

    rN: integer;
    cn: double;

    procedure CalcPower1;
    procedure CalcPowerMinus1;
    procedure CalcPower2;
    procedure CalcPowerMinus2;

  public
    constructor Create;

    class function GetName: string; override;
    class function GetInstance: TBaseVariation; override;

    class function GetNrVariables: integer; override;
    class function GetVariableNameAt(const Index: integer): string; override;

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

// TVariationJulian

///////////////////////////////////////////////////////////////////////////////
constructor TVariationJulian.Create;
begin
  N := random(5) + 2;
  c := 1.0;
end;

procedure TVariationJulian.Prepare;
begin
  rN := abs(N);
  cn := c / N / 2;
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
{$ifndef _ASM_}
var
  r: double;
  sina, cosa: extended;
begin
  sincos((arctan2(FTy^, FTx^) + 2*pi*random(rn)) / N, sina, cosa);
  r := vvar * Math.Power(sqr(FTx^) + sqr(FTy^), cn);

  FPx^ := FPx^ + r * cosa;
  FPy^ := FPy^ + r * sina;
{$else}
asm
    mov     edx, [eax + FTx]
    fld     qword ptr [edx + 8]
    fld     qword ptr [eax + cn]
//    mov     edx, [eax + FTx]
    fld     qword ptr [edx]
    fld     st(2)
    fld     st(1)
    fpatan
    mov     ecx, eax
    mov     eax, dword ptr [eax + rN]
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
//    mov     edx, [ecx + FPy]
    fadd    qword ptr [edx + 8]
    fstp    qword ptr [edx + 8]
    fwait
{$endif}
end;

procedure TVariationJulian.CalcPower2;
{$ifndef _ASM_}
var
  r: double;
  sina, cosa: extended;
begin
  sincos((arctan2(FTy^, FTx^)/2 + pi*random(2)), sina, cosa);
  r := vvar * sqrt(sqrt(sqr(FTx^) + sqr(FTy^)));

  FPx^ := FPx^ + r * cosa;
  FPy^ := FPy^ + r * sina;
{$else}
asm
    mov     edx, [eax + FTx]
    fld     qword ptr [edx + 8]
//    mov     edx, [eax + FTx]
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
    fldpi
    push    eax
    fimul   dword ptr [esp]
    add     esp, 4
    faddp

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
//    mov     edx, [ecx + FPy]
    fadd    qword ptr [edx + 8]
    fstp    qword ptr [edx + 8]
    fwait
{$endif}
end;

procedure TVariationJulian.CalcPowerMinus2;
{$ifndef _ASM_}
var
  r: double;
  sina, cosa: extended;
begin
  sincos((arctan2(FTy^, FTx^)/2 + pi*random(2)), sina, cosa);
  r := vvar / sqrt(sqrt(sqr(FTx^) + sqr(FTy^)));

  FPx^ := FPx^ + r * cosa;
  FPy^ := FPy^ - r * sina;
{$else}
asm
    mov     edx, [eax + FTx]
    fld     qword ptr [edx + 8]
//    mov     edx, [eax + FTx]
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
    fldpi
    push    eax
    fimul   dword ptr [esp]
    add     esp, 4
    faddp

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
//    mov     edx, [ecx + FPy]
    fsubr   qword ptr [edx + 8]
    fstp    qword ptr [edx + 8]
    fwait
{$endif}
end;

procedure TVariationJulian.CalcPower1;
{$ifndef _ASM_}
begin
  FPx^ := FPx^ + vvar * FTx^;
  FPy^ := FPy^ + vvar * FTy^;
{$else}
asm
    mov     edx, [eax + FTx] //[eax + FTy]
    fld     qword ptr [edx]
//    mov     edx, [eax + FTx]
    fld     qword ptr [edx + 8]
    fld     qword ptr [eax + vvar]
    fmul    st(2), st
    fmulp
//    mov     edx, [eax + FPx]
    fadd    qword ptr [edx + 16]
    fstp    qword ptr [edx + 16]
//    mov     edx, [eax + FPy]
    fadd    qword ptr [edx + 24]
    fstp    qword ptr [edx + 24]
    fwait
{$endif}
end;

procedure TVariationJulian.CalcPowerMinus1;
{$ifndef _ASM_}
var
  r: double;
begin
  r := vvar / (sqr(FTx^) + sqr(FTy^));

  FPx^ := FPx^ + r * FTx^;
  FPy^ := FPy^ - r * FTy^;
{$else}
asm
    mov     edx, [eax + FTx]
    fld     qword ptr [edx + 8] // FTy
//    mov     edx, [eax + FTx]
    fld     qword ptr [edx]     // FTx
    fld     st(1)
    fmul    st, st
    fld     st(1)
    fmul    st, st
    faddp
    fdivr   qword ptr [eax + vvar]
    fmul    st(2), st
    fmulp
//    mov     edx, [eax + FPx]
    fadd    qword ptr [edx + 16] // FPx
    fstp    qword ptr [edx + 16] // FPx
//    mov     edx, [eax + FPy]
    fsubr   qword ptr [edx + 24] // FPy
    fstp    qword ptr [edx + 24] // FPy
    fwait
{$endif}
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
    Result := True;
  end;
end;

function TVariationJulian.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = var_n_name then begin
    N := 2;
    Result := True;
  end
  else if Name = var_c_name then begin
    c := 1;
    Result := True;
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
