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

// TVariationEyefish, the correct "fish-eye" variation

///////////////////////////////////////////////////////////////////////////////
procedure TVariationEyefish.CalcFunction;
{$if false}
var
  r: double;
begin
  r := 2 * vvar / (sqrt(FTx^ * FTx^ + FTy^ * FTy^) + 1);
  FPx^ := FPx^ + r * FTx^;
  FPy^ := FPy^ + r * FTy^;
{$else}
asm
    fld     qword ptr [eax+vvar]
    fadd    st, st

    mov     ecx, [eax+FTy]
    fld     qword ptr [ecx]
    mov     ecx, [eax+FTx]
    fld     qword ptr [ecx]

    fld     st(1)
    fmul    st, st
    fld     st(1)
    fmul    st, st
    fadd
    fsqrt

    fld1
    fadd
    fdivp   st(3), st

    fmul    st, st(2)
    mov     ecx, [eax+FPx]
    fadd    qword ptr [ecx]
    fstp    qword ptr [ecx]

    fmulp
    mov     ecx, [eax+FPy]
    fadd    qword ptr [ecx]
    fstp    qword ptr [ecx]

    fwait
{$ifend}
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
