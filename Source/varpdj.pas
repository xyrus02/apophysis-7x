unit varpdj;

interface

uses
  BaseVariation, XFormMan;

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

{ TVariationTest }

///////////////////////////////////////////////////////////////////////////////
procedure TVariationPDJ.CalcFunction;
begin
  FPx^ := FPx^ + vvar * (sin(FA * FTy^) - cos(FB * FTx^));
  FPy^ := FPy^ + vvar * (sin(FC * FTx^) - cos(FD * FTy^));
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
