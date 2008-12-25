unit varCurl;

interface

uses
  BaseVariation, XFormMan;

const
  variation_name = 'curl';
  num_vars = 2;
  var_c1_name='curl_c1';
  var_c2_name='curl_c2';

{$define _ASM_}

//                                 z
//  The formula is: f(z) = ------------------- , where z = complex (x + i*y)
//                        c2*(z^2) + c1*z + 1

type
  TVariationCurl = class(TBaseVariation)
  private
    c2, c1: double;

    c2x2: double;

    procedure CalcZeroC2;
    procedure CalcZeroC1;
    procedure CalcZeroC2C1;

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

// TVariationCurl

///////////////////////////////////////////////////////////////////////////////
constructor TVariationCurl.Create;
begin
  c1 := random;
  c2 := random;

  case random(3) of
    0: c1 := 0;
    1: c2 := 0;
   {else: do nothing}
  end;
end;

procedure TVariationCurl.Prepare;
begin
  c2x2 := 2 * c2;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TVariationCurl.GetCalcFunction(var f: TCalcFunction);
begin
  if IsZero(c1) then begin
    if IsZero(c2) then
      f := CalcZeroC2C1
    else
      f := CalcZeroC1
  end
  else begin
    if IsZero(c2) then
      f := CalcZeroC2
    else
      f := CalcFunction
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TVariationCurl.CalcFunction;
{$ifndef _ASM_}
var
  r: double;
  re, im: double;
begin
  re := 1 + c1*FTx^ + c2*(sqr(FTx^) - sqr(FTy^));
  im :=     c1*FTy^ + c2x2*FTx^*FTy^;

  r := vvar / (sqr(re) + sqr(im));

  FPx^ := FPx^  + (FTx^*re + FTy^*im) * r;
  FPy^ := FPy^  + (FTy^*re - FTx^*im) * r;
{$else}
asm
    mov     edx, [eax + FTx]
    fld     qword ptr [edx + 8] // FTy
    fld     qword ptr [edx]     // FTx
    fld     st(1)
    fmul    st, st(1)
    fmul    qword ptr [eax + c2x2]
   fld     st(2)
   fmul    qword ptr [eax + c1]
   faddp
    fld     st(2)
    fmul    st, st
    fld     st(2)
    fmul    st, st
    fsubrp
    fmul    qword ptr [eax + c2]
    fld1
    faddp
   fld     st(2)
   fmul    qword ptr [eax + c1]
   faddp

    fld     st(1)
    fmul    st, st
    fld     st(1)
    fmul    st, st
    faddp
    fdivr   qword ptr [eax + vvar]

    fld     st(3)
    fmul    st, st(2)
    fld     st(5)
    fmul    st, st(4)
    faddp
    fmul    st, st(1)
    fadd    qword ptr [edx + 16] // FPx
    fstp    qword ptr [edx + 16]

    fxch    st(4)
    fmulp
    fxch    st(2)
    fmulp
    fsubp
    fmulp
    fadd    qword ptr [edx + 24] // FPy
    fstp    qword ptr [edx + 24]
{$endif}
end;

procedure TVariationCurl.CalcZeroC2;
{$ifndef _ASM_}
var
  r: double;
  re, im: double;
begin
  re := 1 + c1*FTx^;
  im :=     c1*FTy^;

  r := vvar / (sqr(re) + sqr(im));

  FPx^ := FPx^  + (FTx^*re + FTy^*im) * r;
  FPy^ := FPy^  + (FTy^*re - FTx^*im) * r;
{$else}
asm
    mov     edx, [eax + FTx]
    fld     qword ptr [edx + 8] // FTy
    fld     qword ptr [edx]     // FTx
    fld     st(1)
    fld     qword ptr [eax + c1]
    fmul    st(1), st
    fmul    st, st(2)
    fld1
    faddp

    fld     st(1)
    fmul    st, st
    fld     st(1)
    fmul    st, st
    faddp
    fdivr   qword ptr [eax + vvar]

    fld     st(3)
    fmul    st, st(2)
    fld     st(5)
    fmul    st, st(4)
    faddp
    fmul    st, st(1)
    fadd    qword ptr [edx + 16] // FPx
    fstp    qword ptr [edx + 16]

    fxch    st(4)
    fmulp
    fxch    st(2)
    fmulp
    fsubp
    fmulp
    fadd    qword ptr [edx + 24] // FPy
    fstp    qword ptr [edx + 24]
{$endif}
end;

procedure TVariationCurl.CalcZeroC1;
{$ifndef _ASM_}
var
  r: double;
  re, im: double;
begin
  re := 1 + c2*(sqr(FTx^) - sqr(FTy^));
  im :=   c2x2*FTx^*FTy^;

  r := vvar / (sqr(re) + sqr(im));

  FPx^ := FPx^  + (FTx^*re + FTy^*im) * r;
  FPy^ := FPy^  + (FTy^*re - FTx^*im) * r;
{$else}
asm
    mov     edx, [eax + FTx]
    fld     qword ptr [edx + 8] // FTy
    fld     qword ptr [edx]     // FTx
    fld     st(1)
    fmul    st, st(1)
    fmul    qword ptr [eax + c2x2]
    fld     st(2)
    fmul    st, st
    fld     st(2)
    fmul    st, st
    fsubrp
    fmul    qword ptr [eax + c2]
    fld1
    faddp

    fld     st(1)
    fmul    st, st
    fld     st(1)
    fmul    st, st
    faddp
    fdivr   qword ptr [eax + vvar]

    fld     st(3)
    fmul    st, st(2)
    fld     st(5)
    fmul    st, st(4)
    faddp
    fmul    st, st(1)
    fadd    qword ptr [edx + 16] // FPx
    fstp    qword ptr [edx + 16]

    fxch    st(4)
    fmulp
    fxch    st(2)
    fmulp
    fsubp
    fmulp
    fadd    qword ptr [edx + 24] // FPy
    fstp    qword ptr [edx + 24]
{$endif}
end;

procedure TVariationCurl.CalcZeroC2C1;
{$ifndef _ASM_}
var
  r: double;
begin
  FPx^ := FPx^  + vvar*FTx^;
  FPy^ := FPy^  + vvar*FTy^;
{$else}
asm
    mov     edx, [eax + FTx]
    fld     qword ptr [edx + 8] // FTy
    fld     qword ptr [eax + vvar]
    fmul    st(1), st
    fmul    qword ptr [edx]     // FTx
    fadd    qword ptr [edx + 16] // FPx
    fstp    qword ptr [edx + 16]
    fadd    qword ptr [edx + 24] // FPy
    fstp    qword ptr [edx + 24]
{$endif}
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationCurl.GetInstance: TBaseVariation;
begin
  Result := TVariationCurl.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationCurl.GetName: string;
begin
  Result := variation_name;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationCurl.GetVariableNameAt(const Index: integer): string;
begin
  case Index of
    0: Result := var_c1_name;
    1: Result := var_c2_name;
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationCurl.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = var_c1_name then begin
    c1 := value;
    Result := True;
  end
  else if Name = var_c2_name then begin
    c2 := value;
    Result := True;
  end;
end;

function TVariationCurl.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = var_c1_name then begin
    c1 := 0;
    Result := True;
  end
  else if Name = var_c2_name then begin
    c2 := 0;
    Result := True;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationCurl.GetNrVariables: integer;
begin
  Result := num_vars;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationCurl.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = var_c1_name then begin
    value := c1;
    Result := True;
  end
  else if Name = var_c2_name then begin
    value := c2;
    Result := True;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationCurl));
end.
