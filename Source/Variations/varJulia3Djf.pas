{
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Borys, Peter Sdobnov
     Apophysis Copyright (C) 2007-2008 Piotr Borys, Peter Sdobnov
     
     Apophysis "3D hack" Copyright (C) 2007-2008 Peter Sdobnov
     Apophysis "7X" Copyright (C) 2009-2010 Georg Kiehne

     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation; either version 2 of the License, or
     (at your option) any later version.

     This program is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.

     You should have received a copy of the GNU General Public License
     along with this program; if not, write to the Free Software
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}

unit varJulia3Djf; // original variation code by Joel Faber, modified & optimized by Peter Sdobnov

interface

uses
{$ifdef Apo7X64}
{$else}
AsmRandom,
{$endif}
  BaseVariation, XFormMan;

const
  var_name = 'julia3D';
  var_n_name='julia3D_power';

{$ifdef Apo7X64}
{$else}
  {$define _ASM_}
{$endif}

type
  TVariationJulia3DJF = class(TBaseVariation)
  private
    N: integer;

    absN: integer;
    cN: double;

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

// TVariationJulia3DJF

///////////////////////////////////////////////////////////////////////////////
constructor TVariationJulia3DJF.Create;
begin
  N := random(5) + 2;
  if random(2) = 0 then N := -N;
end;

procedure TVariationJulia3DJF.Prepare;
begin
  absN := abs(N);
  cN := (1/N - 1) / 2;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TVariationJulia3DJF.GetCalcFunction(var f: TCalcFunction);
begin
  if N = 2 then f := CalcPower2
  else if N = -2 then f := CalcPowerMinus2
  else if N = 1 then f := CalcPower1
  else if N = -1 then f := CalcPowerMinus1
  else f := CalcFunction;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TVariationJulia3DJF.CalcFunction;
{$ifndef _ASM_}
var
  r, r2d, z, tmp: double;
  sina, cosa: extended;
begin
  z := FTz^ / absN;
  r2d := sqr(FTx^) + sqr(FTy^);
  r := vvar * Math.Power(r2d + sqr(z), cN); // r^n / sqrt(r)  -->  r^(n-0.5)

  FPz^ := FPz^ + r * z;

  tmp := r * sqrt(r2d);
  sincos((arctan2(FTy^, FTx^) + 2*pi*random(absN)) / N, sina, cosa);

  FPx^ := FPx^ + tmp * cosa;
  FPy^ := FPy^ + tmp * sina;
{$else}
asm
    mov     edx, [eax + FTx]
    fld     qword ptr [edx + 32] // FTz
    fidiv   dword ptr [eax + absN]
    fld     qword ptr [edx]      // FTx
    fld     qword ptr [edx + 8]  // FTy
    fld     st(1)
    fmul    st, st
    fld     st(1)
    fmul    st, st
    faddp
    fld     qword ptr [eax + cN]
    fld     st(4)
    fmul    st, st
    fadd    st, st(2)
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

    fmul    st(4), st
    fxch    st(1)
    fsqrt
    fmulp

    fxch    st(2)
    fpatan
    mov     ecx, eax
    mov     eax, dword ptr [eax + absN]
    call    AsmRandInt
    push    eax
    fild    dword ptr [esp]
    add     esp, 4
    fldpi
    fadd    st, st
    fmulp
    faddp
    fidiv   dword ptr [ecx + N]

    fsincos
    mov     edx, [ecx + FPx]
    fmul    st, st(2)
    fadd    qword ptr [edx] // FPx
    fstp    qword ptr [edx]
    fmulp
    fadd    qword ptr [edx + 8] // FPy
    fstp    qword ptr [edx + 8]
    fadd    qword ptr [edx + $18] // FPz
    fstp    qword ptr [edx + $18]
    fwait
{$endif}
end;

procedure TVariationJulia3DJF.CalcPower2;
{$ifndef _ASM_}
var
  r, r2d, z, tmp: double;
  sina, cosa: extended;
begin
  z := FTz^ / 2;
  r2d := sqr(FTx^) + sqr(FTy^);
  r := vvar / sqrt(sqrt(r2d + sqr(z))); // vvar * sqrt(r3d) / r3d  -->  vvar / sqrt(r3d)

  FPz^ := FPz^ + r * z;

  tmp := r * sqrt(r2d);
  sincos(arctan2(FTy^, FTx^) / 2 + pi*random(2), sina, cosa);

  FPx^ := FPx^ + tmp * cosa;
  FPy^ := FPy^ + tmp * sina;
{$else}
asm
    mov     edx, [eax + FTx]
    fld     qword ptr [edx + 32] // FTz
    fld1
    fadd    st, st
    fdiv    st(1), st
    fld     qword ptr [edx + 8]  // FTy
    fld     qword ptr [edx]      // FTx
    fld     st(1)
    fld     st(1)
    fpatan
    fdivrp  st(3), st

    fmul    st, st
    fxch    st(1)
    fmul    st, st
    faddp
    fld     st(2)
    fmul    st, st
    fadd    st, st(1)
    fsqrt
    fsqrt
    fdivr   qword ptr [eax + vvar]
    fmul    st(3), st

    fxch    st(1)
    fsqrt
    fmulp
    fxch    st(1)

    mov     ecx, eax
    mov     eax, 2
    call    AsmRandInt
    fldpi
    push    eax
    fimul   dword ptr [esp]
    add     esp, 4
    faddp

    fsincos
    mov     edx, [ecx + FPx]
    fmul    st, st(2)
    fadd    qword ptr [edx] // FPx
    fstp    qword ptr [edx]
    fmulp
    fadd    qword ptr [edx + 8] // FPy
    fstp    qword ptr [edx + 8]
    fadd    qword ptr [edx + $18] // FPz
    fstp    qword ptr [edx + $18]
    fwait
{$endif}
end;

procedure TVariationJulia3DJF.CalcPowerMinus2;
{$ifndef _ASM_}
var
  r, r2d, r3d, z, tmp: double;
  sina, cosa: extended;
begin
  z := FTz^ / 2;
  r2d := sqr(FTx^) + sqr(FTy^);
  r3d := sqrt(r2d + sqr(z));
  r := vvar / (sqrt(r3d) * r3d);

  FPz^ := FPz^ + r * z;

  tmp := r * sqrt(r2d);
  sincos(arctan2(FTy^, FTx^) / 2 + pi*random(2), sina, cosa);

  FPx^ := FPx^ + tmp * cosa;
  FPy^ := FPy^ - tmp * sina;
{$else}
asm
    mov     edx, [eax + FTx]
    fld     qword ptr [edx + 32] // FTz
    fld1
    fadd    st, st
    fdiv    st(1), st
    fld     qword ptr [edx + 8]  // FTy
    fld     qword ptr [edx]      // FTx
    fld     st(1)
    fld     st(1)
    fpatan
    fdivrp  st(3), st

    fmul    st, st
    fxch    st(1)
    fmul    st, st
    faddp
    fld     st(2)
    fmul    st, st
    fadd    st, st(1)
    fsqrt
    fld     st
    fsqrt
    fmulp
    fdivr   qword ptr [eax + vvar]
    fmul    st(3), st

    fxch    st(1)
    fsqrt
    fmulp
    fxch    st(1)

    mov     ecx, eax
    mov     eax, 2
    call    AsmRandInt
    fldpi
    push    eax
    fimul   dword ptr [esp]
    add     esp, 4
    faddp

    fsincos
    mov     edx, [ecx + FPx]
    fmul    st, st(2)
    fadd    qword ptr [edx] // FPx
    fstp    qword ptr [edx]
    fmulp
    fsubr   qword ptr [edx + 8] // FPy
    fstp    qword ptr [edx + 8]
    fadd    qword ptr [edx + $18] // FPz
    fstp    qword ptr [edx + $18]
    fwait
{$endif}
end;

procedure TVariationJulia3DJF.CalcPower1;
{$ifndef _ASM_}
begin
  FPx^ := FPx^ + vvar * FTx^;
  FPy^ := FPy^ + vvar * FTy^;
  FPz^ := FPz^ + vvar * FTz^;
{$else}
asm
    fld     qword ptr [eax + vvar]
    mov     edx, [eax + FTx]
    fld     qword ptr [edx]      // FTx
    fmul    st, st(1)
    fadd    qword ptr [edx + 16] // FPx
    fstp    qword ptr [edx + 16]

    fld     qword ptr [edx + 8]  // FTy
    fmul    st, st(1)
    fadd    qword ptr [edx + 24] // FPy
    fstp    qword ptr [edx + 24]

    fmul    qword ptr [edx + 32] // FTz
    fadd    qword ptr [edx + 40] // FPz
    fstp    qword ptr [edx + 40]

    fwait
{$endif}
end;

procedure TVariationJulia3DJF.CalcPowerMinus1;
{$ifndef _ASM_}
var
  r: double;
begin
  r := vvar / (sqr(FTx^) + sqr(FTy^) + sqr(FTz^));

  FPx^ := FPx^ + r * FTx^;
  FPy^ := FPy^ - r * FTy^;
  FPz^ := FPz^ + r * FTz^;
{$else}
asm
    mov     edx, [eax + FTx]
    fld     qword ptr [edx + 32] // FTz
    fld     qword ptr [edx + 8]  // FTy
    fld     qword ptr [edx]      // FTx
    fld     st(2)
    fmul    st, st
    fld     st(2)
    fmul    st, st
    faddp
    fld     st(1)
    fmul    st, st
    faddp
    fdivr   qword ptr [eax + vvar]

    fmul    st(3), st
    fmul    st(2), st
    fmulp
    fadd    qword ptr [edx + 16] // FPx
    fstp    qword ptr [edx + 16]
    fsubr   qword ptr [edx + 24] // FPy
    fstp    qword ptr [edx + 24]
    fadd    qword ptr [edx + 40] // FPz
    fstp    qword ptr [edx + 40]
    fwait
{$endif}
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationJulia3DJF.GetInstance: TBaseVariation;
begin
  Result := TVariationJulia3DJF.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationJulia3DJF.GetName: string;
begin
  Result := var_name;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationJulia3DJF.GetVariableNameAt(const Index: integer): string;
begin
  case Index of
    0: Result := var_n_name;
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationJulia3DJF.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = var_n_name then begin
    N := Round(Value);
    if N = 0 then N := 1;
    Value := N;
    Result := True;
  end;
end;

function TVariationJulia3DJF.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = var_n_name then begin
    if N = 2 then N := -2
    else N := 2;
    Result := True;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationJulia3DJF.GetNrVariables: integer;
begin
  Result := 1;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationJulia3DJF.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = var_n_name then begin
    Value := N;
    Result := true;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationJulia3DJF), true, false);
end.

