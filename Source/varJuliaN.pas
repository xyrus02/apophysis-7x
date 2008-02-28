unit varJuliaN;

interface

uses
  BaseVariation, XFormMan;

const
  var_name = 'julian';
  var_n_name='julian_power';
  var_c_name='julian_dist';

{$define _ASM_}

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
{$ifndef _ASM_}
var
  r: double;
  sina, cosa: extended;
begin
  sincos((arctan2(FTy^, FTx^) + 2*pi*random(absN)) / N, sina, cosa);
  r := vvar * Math.Power(sqr(FTx^) + sqr(FTy^), cN);

  FPx^ := FPx^ + r * cosa;
  FPy^ := FPy^ + r * sina;
{$else}
asm
    mov     edx, [eax + FTx]
    fld     qword ptr [edx]     // FTx
    fld     qword ptr [edx + 8] // FTy
    fld     qword ptr [eax + cN]
    fld     st(2)
    fmul    st, st
    fld     st(2)
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
    fmul    qword ptr [eax + vvar]

    fxch    st(2)
    fpatan
    mov     ecx, eax
    mov     eax, dword ptr [eax + absN]
    call    System.@RandInt
    push    eax
    fild    dword ptr [esp]
    add     esp, 4
    fldpi
    fadd    st, st
    fmulp
    faddp
    fidiv   dword ptr [ecx + N]
    fsincos

    fmul    st, st(2)
    mov     edx, [ecx + FPx]
    fadd    qword ptr [edx] // FPx
    fstp    qword ptr [edx]
    fmulp
    fadd    qword ptr [edx + 8] // FPy
    fstp    qword ptr [edx + 8]
    fwait
{$endif}
end;

procedure TVariationJulian.CalcPower2;
{$ifndef _ASM_}
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
{$else}
asm
    mov     edx, [eax + FTx]
    fld     qword ptr [edx + 8] // FTy
    fld     qword ptr [edx]     // FTx
    fld     st(1)
    fmul    st,st
    fld     st(1)
    fmul    st,st
    faddp
    fsqrt
    faddp
    fsqrt

    fld     qword ptr [eax + vvar2]
    mov     ecx,eax
    mov     eax,2
    call    System.@RandInt
    shr eax,1
    jc      @skip
    fchs
@skip:

    fmul    st(2),st
    fmul    st,st(1)

    mov     edx, [ecx + FPx]
    fadd    qword ptr [edx]
    fstp    qword ptr [edx]
    fdivp   st(1),st
    fadd    qword ptr [edx + 8]
    fstp    qword ptr [edx + 8]
    fwait
{$endif}
end;

procedure TVariationJulian.CalcPowerMinus2;
{$ifndef _ASM_}
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
{$else}
asm

    mov     edx, [eax + FTx]
    fld     qword ptr [edx + 8]
    fld     qword ptr [edx]
    fld     st(1)
    fmul    st,st
    fld     st(1)
    fmul    st,st
    faddp
    fsqrt
    fadd    st(1),st
    fld     st(1)
    fmul    st,st
    fld     st(3)
    fmul    st,st
    faddp
    fmulp
    fsqrt

    fdivr   qword ptr [eax + vvar]

    mov     ecx,eax
    mov     eax,2
    call    System.@RandInt
    shr eax,1
    jc      @skip
    fchs
@skip:

    fmul    st(1),st
    fmulp   st(2),st

    mov     edx, [ecx + FPx]
    fsubr   qword ptr [edx]
    fstp    qword ptr [edx]
    fadd    qword ptr [edx + 8]
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
  RegisterVariation(TVariationClassLoader.Create(TVariationJulian));
end.
