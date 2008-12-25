unit varHemisphere;

interface

uses
  BaseVariation, XFormMan;

const
  var_name = 'hemisphere';

{$define _ASM_}

type
  TVariationHemisphere = class(TBaseVariation)
  private

  public
    constructor Create;

    class function GetName: string; override;
    class function GetInstance: TBaseVariation; override;

    function GetNrVariables: integer; override;

    procedure CalcFunction; override;
  end;

implementation

uses
  Math;

{ TVariationSpherize }

///////////////////////////////////////////////////////////////////////////////
procedure TVariationHemisphere.CalcFunction;
{$ifndef _ASM_}
var
  t: double;
begin
  t := vvar / sqrt(sqr(FTx^) + sqr(FTy^) + 1);

  FPx^ := FPx^ + FTx^ * t;
  FPy^ := FPy^ + FTy^ * t;
  FPz^ := FPz^ + t;
{$else}
asm
    mov     edx, [eax + FTx]
    fld     qword ptr [edx + 8]  // FTy
    fld     qword ptr [edx]      // FTx
    fld     st(1)
    fmul    st, st
    fld     st(1)
    fmul    st, st
    faddp
    fld1
    faddp
    fsqrt
    fdivr   qword ptr [eax + vvar]
    fmul    st(2), st
    fmul    st(1), st
    fadd    qword ptr [edx + 40] // FPz
    fstp    qword ptr [edx + 40]
    fadd    qword ptr [edx + 16] // FPx
    fstp    qword ptr [edx + 16]
    fadd    qword ptr [edx + 24] // FPy
    fstp    qword ptr [edx + 24]
    fwait
{$endif}
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationHemisphere.Create;
begin

end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationHemisphere.GetInstance: TBaseVariation;
begin
  Result := TVariationHemisphere.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationHemisphere.GetName: string;
begin
  Result := var_name;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationHemisphere.GetNrVariables: integer;
begin
  Result := 0;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationHemisphere));
end.
