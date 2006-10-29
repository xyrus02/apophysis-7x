unit varPDJ;

interface

uses
  BaseVariation, XFormMan;

{$define _ASM_}

type
  TVariationPDJ = class(TBaseVariation)
  private
    FA,FB,FC,FD: double;
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
  Math;

{ TVariationPDJ }

///////////////////////////////////////////////////////////////////////////////
procedure TVariationPDJ.CalcFunction;
{$ifndef _ASM_}
begin
  FPx^ := FPx^ + vvar * (sin(FA * FTy^) - cos(FB * FTx^));
  FPy^ := FPy^ + vvar * (sin(FC * FTx^) - cos(FD * FTy^));
{$else}
asm
    fld     qword ptr [eax + vvar]
    mov     edx, [eax + FTx]
    fld     qword ptr [edx + 8] // FTy
    fld     qword ptr [edx]     // FTx

    fld     st(1)
    fmul    qword ptr [eax + Fa]
    fsin
    fld     st(1)
    fmul    qword ptr [eax + Fb]
    fcos
    fsubp   st(1), st
    fmul    st, st(3)
    fadd    qword ptr [edx + 16] // FPx
    fstp    qword ptr [edx + 16]

    fmul    qword ptr [eax + Fc]
    fsin
    fxch    st(1)
    fmul    qword ptr [eax + Fd]
    fcos
    fsubp   st(1), st
    fmulp
    fadd    qword ptr [edx + 24] // FPy
    fstp    qword ptr [edx + 24]
{$endif}
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationPDJ.Create;
begin
  FA := 6 * Random - 3;
  FB := 6 * Random - 3;
  FC := 6 * Random - 3;
  FD := 6 * Random - 3;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationPDJ.GetInstance: TBaseVariation;
begin
  Result := TVariationPDJ.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationPDJ.GetName: string;
begin
  Result := 'pdj';
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationPDJ.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'pdj_a';
  1: Result := 'pdj_b';
  2: Result := 'pdj_c';
  3: Result := 'pdj_d';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPDJ.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'pdj_a' then begin
    FA := Value;
    Result := True;
  end else if Name = 'pdj_b' then begin
    FB := Value;
    Result := True;
  end else if Name = 'pdj_c' then begin
    FC := Value;
    Result := True;
  end else if Name = 'pdj_d' then begin
    FD := Value;
    Result := True;
  end 
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationPDJ.GetNrVariables: integer;
begin
  Result := 4
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationPDJ.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'pdj_a' then begin
    Value := FA;
    Result := True;
  end else if Name = 'pdj_b' then begin
    Value := FB;
    Result := True;
  end else if Name = 'pdj_c' then begin
    Value := FC;
    Result := True;
  end else if Name = 'pdj_d' then begin
    Value := FD;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationPDJ);
end.
