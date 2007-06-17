{
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Borys, Peter Sdobnov
     Apophysis Copyright (C) 2007 Piotr Borys, Peter Sdobnov

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

unit varSuperShape;

interface

uses
  BaseVariation, XFormMan, XForm;

type
  TVariationSuperShape = class(TBaseVariation)
  private
    m, n, rnd, a, b, holes : double;
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

{ TVariationSuperShape }

///////////////////////////////////////////////////////////////////////////////
procedure SinCos(const Theta: double; var Sin, Cos: double);
asm
    FLD     Theta
    FSINCOS
    FSTP    qword ptr [edx]    // Cos
    FSTP    qword ptr [eax]    // Sin
    FWAIT
end;

procedure TVariationSuperShape.CalcFunction;
var
  r, theta, tmp : double;
  t1, t2 : double;
  dist: double;
  t1a, t2a: double;
begin

  if n = 0 then
    r := 0
  else begin
    theta := arctan2(FTy^, FTx^);
    SinCos((m*theta+pi)/4, t2, t1);

    t1 := t1/a;
    t1 := abs(t1);
    t1 := power(t1, n);

    t2 := t2/b;
    t2 := abs(t2);
    t2 := power(t2, n);

    if rnd < 1.0 then
      dist := sqrt(sqr(FTx^)+sqr(FTy^))
    else
      dist := 0;

    r := (rnd*random + (1.0-rnd)*dist - holes) * power(t1+t2, -1/n);
  end;

  if (abs(r) = 0) then
    begin
      FPx^ := FPx^;
      FPy^ := FPy^;
    end
  else
    begin
      SinCos(theta, t2a, t1a);
      FPx^ := FPx^ + vvar*r*t1a;
      FPy^ := FPy^ + vvar*r*t2a;
    end;
end;


///////////////////////////////////////////////////////////////////////////////
class function TVariationSuperShape.GetName: string;
begin
  Result := 'super_shape';
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationSuperShape.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'super_shape_m';
  1: Result := 'super_shape_n';
  2: Result := 'super_shape_rnd';
  3: Result := 'super_shape_a';
  4: Result := 'super_shape_b';
  5: Result := 'super_shape_holes';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationSuperShape.GetNrVariables: integer;
begin
  Result := 6;
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationSuperShape.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'super_shape_m' then begin
    m := Value;
    Result := True;
  end else if Name = 'super_shape_n' then begin
    n := Value;
    Result := True;
  end
  else if Name = 'super_shape_rnd' then begin
    if Value > 1.0 then
      rnd := 1.0
    else if Value < 0.0 then
      rnd := 0.0
    else
      rnd := Value;
    Result := True;
  end
  else if Name = 'super_shape_a' then begin
    a := Value;
    Result := True;
  end
  else if Name = 'super_shape_b' then begin
    b := Value;
    Result := True;
  end
  else if Name = 'super_shape_holes' then begin
    holes := Value;
    Result := True;
  end

end;

///////////////////////////////////////////////////////////////////////////////
function TVariationSuperShape.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'super_shape_m' then begin
    Value := m;
    Result := True;
  end else if Name = 'super_shape_n' then begin
    Value := n;
    Result := True;
  end
  else if Name = 'super_shape_rnd' then begin
    Value := rnd;
    Result := True;
  end
  else if Name = 'super_shape_a' then begin
    Value := a;
    Result := True;
  end
  else if Name = 'super_shape_b' then begin
    Value := b;
    Result := True;
  end
  else if Name = 'super_shape_holes' then begin
    Value := holes;
    Result := True;
  end

end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationSuperShape.Create;
begin
  inherited Create;

  m  := 4.0;
  n := 1.0;
  rnd := 0.0;
  a := 1.0;
  b := 1.0;
  holes := 1.0;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationSuperShape.GetInstance: TBaseVariation;
begin
  Result := TVariationSuperShape.Create;
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationSuperShape);
end.
