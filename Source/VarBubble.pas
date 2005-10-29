unit VarBubble;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationBubble = class(TBaseVariation)
  public
    class function GetName: string; override;
    class function GetInstance: TBaseVariation; override;

    procedure CalcFunction; override;
  end;

implementation

uses
  math;

// TVariationBubble - a pseudo-spherical distortion

///////////////////////////////////////////////////////////////////////////////
procedure TVariationBubble.CalcFunction;
{$if false}
var
  r: double;
begin
  r := vvar / ((sqr(FTx^) + sqr(FTy^))/4 + 1);

  FPx^ := FPx^ + r * FTx^;
  FPy^ := FPy^ + r * FTy^;
{$else}
asm
    mov     ecx, [eax+FTy]
    fld     qword ptr [ecx]
    mov     ecx, [eax+FTx]
    fld     qword ptr [ecx]

    fld     st(1)
    fmul    st, st
    fld     st(1)
    fmul    st, st
    fadd

    fld1
    fadd    st, st
    fadd    st, st
    fdivp   st(1), st
    fld1
    fadd
    fdivr    qword ptr [eax+vvar]

    fmul    st(2), st
    fmulp
    mov     ecx, [eax+FPx]
    fadd    qword ptr [ecx]
    fstp    qword ptr [ecx]

    mov     ecx, [eax+FPy]
    fadd    qword ptr [ecx]
    fstp    qword ptr [ecx]

    fwait
{$ifend}
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationBubble.GetInstance: TBaseVariation;
begin
  Result := TVariationBubble.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationBubble.GetName: string;
begin
  Result := 'bubble';
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationBubble);
end.
