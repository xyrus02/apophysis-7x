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

unit varWaves2;

interface

uses
  BaseVariation, XFormMan;

type
  TVariationWaves2 = class(TBaseVariation)
  private
    waves2_freqx, waves2_freqy, waves2_freqz: double;
    waves2_scalex, waves2_scaley, waves2_scalez: double;

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
  end;

implementation

uses
  Math;

///////////////////////////////////////////////////////////////////////////////
procedure TVariationWaves2.Prepare;
begin
end;

procedure TVariationWaves2.CalcFunction;
begin
  FPx^ := FPx^ + VVAR * (FTx^ + waves2_scalex * sin(FTy^ * waves2_freqx));
  FPy^ := FPy^ + VVAR * (FTy^ + waves2_scaley * sin(FTx^ * waves2_freqy));
  FPz^ := FPz^ + VVAR * (FTz^ + waves2_scalez * sin(sqrt(sqr(FTx^)+sqr(FTy^)) * waves2_freqz));
end;

///////////////////////////////////////////////////////////////////////////////
constructor TVariationWaves2.Create;
begin
  waves2_freqx := 2; waves2_scalex := 1;
  waves2_freqy := 2; waves2_scaley := 1;
  waves2_freqz := 0; waves2_scalez := 0;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationWaves2.GetInstance: TBaseVariation;
begin
  Result := TVariationWaves2.Create;
end;

///////////////////////////////////////////////////////////////////////////////
class function TVariationWaves2.GetName: string;
begin
  Result := 'waves2';
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationWaves2.GetVariableNameAt(const Index: integer): string;
begin
  case Index Of
  0: Result := 'waves2_freqx';
  1: Result := 'waves2_freqy';
  2: Result := 'waves2_freqz';
  3: Result := 'waves2_scalex';
  4: Result := 'waves2_scaley';
  5: Result := 'waves2_scalez';
  else
    Result := '';
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationWaves2.SetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'waves2_freqx' then begin
    waves2_freqx := Value;
    Result := True;
  end else if Name = 'waves2_freqy' then begin
    waves2_freqy := Value;
    Result := True;
  end else if Name = 'waves2_freqz' then begin
    waves2_freqz := Value;
    Result := True;
  end else if Name = 'waves2_scalex' then begin
    waves2_scalex := Value;
    Result := True;
  end else if Name = 'waves2_scaley' then begin
    waves2_scaley := Value;
    Result := True;
  end else if Name = 'waves2_scalez' then begin
    waves2_scalez := Value;
    Result := True;
  end
end;
function TVariationWaves2.ResetVariable(const Name: string): boolean;
begin
  Result := False;
  if Name = 'waves2_freqx' then begin
    waves2_freqx := 2;
    Result := True;
  end else if Name = 'waves2_freqy' then begin
    waves2_freqy := 2;
    Result := True;
  end else if Name = 'waves2_freqz' then begin
    waves2_freqz := 0;
    Result := True;
  end else if Name = 'waves2_scalex' then begin
    waves2_scalex := 1;
    Result := True;
  end else if Name = 'waves2_scaley' then begin
    waves2_scaley := 1;
    Result := True;
  end else if Name = 'waves2_scalez' then begin
    waves2_scalez := 0;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationWaves2.GetNrVariables: integer;
begin
  Result := 6
end;

///////////////////////////////////////////////////////////////////////////////
function TVariationWaves2.GetVariable(const Name: string; var value: double): boolean;
begin
  Result := False;
  if Name = 'waves2_freqx' then begin
    Value := waves2_freqx;
    Result := True;
  end else if Name = 'waves2_freqy' then begin
    Value := waves2_freqy;
    Result := True;
  end else if Name = 'waves2_freqz' then begin
    Value := waves2_freqz;
    Result := True;
  end else if Name = 'waves2_scalex' then begin
    Value := waves2_scalex;
    Result := True;
  end else if Name = 'waves2_scaley' then begin
    Value := waves2_scaley;
    Result := True;
  end else if Name = 'waves2_scalez' then begin
    Value := waves2_scalez;
    Result := True;
  end
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  RegisterVariation(TVariationClassLoader.Create(TVariationWaves2), true, false);
end.