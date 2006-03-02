unit varSmoke2;

interface

uses
  BaseVariation, XFormMan;

const
  var_a_name='smoke2_amp';
  var_f_name='smoke2_freq';

type
  TVariationSmoke2 = class(TBaseVariation)
  private
    a, f: double;

  public
    constructor Create;

    class function GetName: string; override;
    class function GetInstance: TBaseVariation; override;

    class function GetNrVariables: integer; override;
    class function GetVariableNameAt(const Index: integer): string; override;

    function SetVariable(const Name: string; var value: double): boolean; override;
    function GetVariable(const Name: string; var value: double): boolean; override;

    procedure CalcFunction; override;
  end;

implementation

uses
  math;

// TVariationSmoke2

///////////////////////////////////////////////////////////////////////////////
constructor TVariationSmoke2.Create;
begin
  a := random;
  f := 4*random;
end;

procedure TVariationSmoke2.CalcFunction;
{$if false}
begin
  FPx^ := FPx^ + vvar*(ftx^ + a*sin(fty^*f) );
  FPy^ := FPy^ + vvar*(fty^ + a*sin(ftx^*f) );
{$else}
asm
    fld     qword ptr [eax + vvar]
    fld     qword ptr [eax + a]
    mov     ecx, [eax + FTy]
    fld     qword ptr [ecx]
    fld     qword ptr [eax + f]
    mov     ecx, [eax + FTx]
    fld     qword ptr [ecx]
    fld     st(2)
    fmul    st, st(2)
    fsin
    fmul    st, st(4)
    fadd    st, st(1)
    fmul    st, st(5)
    mov     ecx, [eax + FPx]
    fadd    qword ptr [ecx]
    fstp    qword ptr [ecx]
    fmulp
    fsin
    fmulp   st(2), st
    faddp
    fmulp
    mov     ecx, [eax + FPy]
    fadd    qword ptr [ecx]
    fstp    qword ptr [ecx]
    fwait
{$ifend}
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationSmoke2.GetInstance: TBaseVariation;
begin
  Result := TVariationSmoke2.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationSmoke2.GetName: string;
begin
  Result := 'smoke2';
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationSmoke2.GetVariableNameAt(const Index: integer): string;
begin
  case Index of
  0: Result := var_a_name;
  1: Result := var_f_name;
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationSmoke2.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = var_a_name then begin
    a := Value;
    Result := True;
  end else if Name = var_f_name then begin
    f := Value;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationSmoke2.GetNrVariables: integer;
begin
  Result := 2;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationSmoke2.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = var_a_name then begin
    Value := a;
    Result := True;
  end else if Name = var_f_name then begin
    Value := f;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationSmoke2);
end.
