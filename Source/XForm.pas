unit XForm;

interface

uses
  XFormMan, BaseVariation;

type
  TCPpoint = record
    x, y, c: double;
  end;
  PCPpoint = ^TCPpoint;

  TXYpoint = record
    x, y: double;
  end;
  PXYpoint = ^TXYpoint;

  T2Cpoint = record
    x, y, c1, c2: double;
  end;

  TMatrix = array[0..2, 0..2] of double;

{$define _ASM_}

type
  TXForm = class
  public
    vars: array of double; // {normalized} interp coefs between variations
    c: array[0..2, 0..1] of double;      // the coefs to the affine part of the function
    p: array[0..2, 0..1] of double;      // post-transform coefs!
    density: double;                     // prob is this function is chosen
    color: double;                       // color coord for this function. 0 - 1
    color2: double;                      // Second color coord for this function. 0 - 1
    symmetry: double;
    c00, c01, c10, c11, c20, c21: double;
    p00, p01, p10, p11, p20, p21: double;

//    nx,ny,x,y: double;
//    script: TatPascalScripter;

    Orientationtype: integer;

  private
    FNrFunctions: Integer;
    FFunctionList: array of TCalcFunction;
    FCalcFunctionList: array[0..64] of TCalcFunction;

    FTx, FTy: double;
    FPx, FPy: double;
    FAngle: double;
    FSinA: double;
    FCosA: double;
    FLength: double;
    colorC1, colorC2: double;

    // precalculated constants for some variations
    waves_f1, waves_f2,
    rings_dx,
    fan_dx, fan_dx2,
    cosine_var2,
    polar_vpi: double;

    FRegVariations: array of TBaseVariation;

    procedure PrecalcAngle;
    procedure PrecalcSinCos;
    procedure PrecalcAll;
    procedure DoPostTransform;

    procedure Linear;              // var[0]
    procedure Sinusoidal;          // var[1]
    procedure Spherical;           // var[2]
    procedure Swirl;               // var[3]
    procedure Horseshoe;           // var[4]
    procedure Polar;               // var[5]
    procedure FoldedHandkerchief;  // var[6]
    procedure Heart;               // var[7]
    procedure Disc;                // var[8]
    procedure Spiral;              // var[9]
    procedure hyperbolic;          // var[10]
    procedure Square;              // var[11]
    procedure Ex;                  // var[12]
    procedure Julia;               // var[13]
    procedure Bent;                // var[14]
    procedure Waves;               // var[15]
    procedure Fisheye;             // var[16]
    procedure Popcorn;             // var[17]
    procedure Exponential;         // var[18]
    procedure Power;               // var[19]
    procedure Cosine;              // var[20]
    procedure Rings;               // var[21]
    procedure Fan;                 // var[22]
    procedure Eyefish;             // var[23]
    procedure Bubble;              // var[24]
    procedure Cylinder;            // var[25]
    procedure Smoke;               // var[26]
    procedure Noise;               // var[27]

    function Mul33(const M1, M2: TMatrix): TMatrix;
    function Identity: TMatrix;

    procedure BuildFunctionlist;
    procedure AddRegVariations;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Prepare;

    procedure Assign(Xform: TXForm);

    procedure NextPoint(var px, py, pc: double); overload;
    procedure NextPoint(var CPpoint: TCPpoint); overload;
    procedure NextPointTo(var CPpoint, ToPoint: TCPpoint);
//    procedure NextPoint(var px, py, pz, pc: double); overload;
    procedure NextPointXY(var px, py: double);
    procedure NextPoint2C(var p: T2CPoint);

    procedure Rotate(const degrees: double);
    procedure Translate(const x, y: double);
    procedure Multiply(const a, b, c, d: double);
    procedure Scale(const s: double);

    procedure SetVariable(const name: string; var Value: double);
    procedure GetVariable(const name: string; var Value: double);

    function ToXMLString: string;
    function FinalToXMLString(IsEnabled: boolean): string;
  end;

implementation

uses
  SysUtils, Math;

const
  EPS: double = 1E-300;

procedure SinCos(const Theta: double; var Sin, Cos: double); // to avoid using 'extended' type
asm
    FLD     Theta
    FSINCOS
    FSTP    qword ptr [edx]    // Cos
    FSTP    qword ptr [eax]    // Sin
    FWAIT
end;

{ TXForm }

///////////////////////////////////////////////////////////////////////////////
constructor TXForm.Create;
begin
  AddRegVariations;
  BuildFunctionlist;
  SetLength(vars, NRLOCVAR + Length(FRegVariations));

  Clear;
end;

procedure TXForm.Clear;
var
  i: Integer;
begin
  density := 0;
  color := 0;
  symmetry := 0;

  c[0, 0] := 1;
  c[0, 1] := 0;
  c[1, 0] := 0;
  c[1, 1] := 1;
  c[2, 0] := 0;
  c[2, 1] := 0;

  p[0, 0] := 1;
  p[0, 1] := 0;
  p[1, 0] := 0;
  p[1, 1] := 1;
  p[2, 0] := 0;
  p[2, 1] := 0;

  vars[0] := 1;
  for i := 1 to High(vars) do
    vars[i] := 0;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Prepare;
var
  i: integer;
  CalculateAngle, CalculateSinCos, CalculateLength: boolean;
begin
  c00 := c[0][0];
  c01 := c[0][1];
  c10 := c[1][0];
  c11 := c[1][1];
  c20 := c[2][0];
  c21 := c[2][1];

  colorC1 := (1 + symmetry)/2;
  colorC2 := color*(1 - symmetry)/2;

  FNrFunctions := 0;

  for i := 0 to High(FRegVariations) do begin
    FRegVariations[i].FPX := @FPX;
    FRegVariations[i].FPY := @FPY;
    FRegVariations[i].FTX := @FTX;
    FRegVariations[i].FTY := @FTY;

    FRegVariations[i].vvar := vars[i + NRLOCVAR];
    FRegVariations[i].Prepare;
    FRegVariations[i].GetCalcFunction(FFunctionList[NRLOCVAR + i]);
  end;

  CalculateAngle := (vars[5] <> 0.0) or (vars[6] <> 0.0) or (vars[7] <> 0.0) or
                    (vars[8] <> 0.0) or (vars[12] <> 0.0) or (vars[13] <> 0.0) or
                    (vars[21] <> 0.0) or (vars[22] <> 0.0) or (vars[27] <> 0.0);
//  CalculateLength := False;
  CalculateSinCos := (vars[9] <> 0.0) or (vars[11] <> 0.0) or (vars[19] <> 0.0) or (vars[21] <> 0.0);

  if CalculateAngle or CalculateSinCos then
  begin
    if CalculateAngle and CalculateSinCos then
      FCalcFunctionList[FNrFunctions] := PrecalcAll
    else if CalculateAngle then
      FCalcFunctionList[FNrFunctions] := PrecalcAngle
    else //if CalculateSinCos then
      FCalcFunctionList[FNrFunctions] := PrecalcSinCos;
    Inc(FNrFunctions);
  end;

  for i := 0 to NrVar - 1 do begin
    if (vars[i] <> 0.0) then begin
      FCalcFunctionList[FNrFunctions] := FFunctionList[i];
      Inc(FNrFunctions);
    end;
  end;

  waves_f1 := 1 / (sqr(c20) + EPS);
  waves_f2 := 1 / (sqr(c21) + EPS);

  rings_dx := sqr(c20) + EPS;
  fan_dx := PI * (sqr(c20) + EPS);
  fan_dx2 := fan_dx/2;

  cosine_var2 := vars[20]/2;

  polar_vpi := vars[5]/pi;

  if (p[0,0]<>1) or (p[0,1]<>0) or(p[1,0]<>0) or (p[1,1]<>1) or (p[2,0]<>0) or (p[2,1]<>0) then
  begin
    p00 := p[0][0];
    p01 := p[0][1];
    p10 := p[1][0];
    p11 := p[1][1];
    p20 := p[2][0];
    p21 := p[2][1];

    FCalcFunctionList[FNrFunctions] := DoPostTransform;
    Inc(FNrFunctions);
  end;

(*
  if (vars[27] <> 0.0) then begin
    FFunctionList[FNrFunctions] := TestScript;
    Inc(FNrFunctions);

    Script := TatPascalScripter.Create(nil);
    Script.SourceCode.Text :=
       'function test(x, y; var nx, ny);' + #10#13 +
       'begin' +  #10#13 +
         'nx := x;' +  #10#13 +
         'ny := y;' +  #10#13 +
       'end;' + #10#13 +
       'function test2;' + #10#13 +
       'begin' +  #10#13 +
         'nx := x;' +  #10#13 +
         'ny := y;' +  #10#13 +
       'end;' + #10#13 +
       'nx := x;' +  #10#13 +
       'ny := y;' +  #10#13;
    Script.AddVariable('x',x);
    Script.AddVariable('y',y);
    Script.AddVariable('nx',nx);
    Script.AddVariable('ny',ny);
    Script.Compile;
  end;

  if (vars[NRLOCVAR -1] <> 0.0) then begin
    FFunctionList[FNrFunctions] := TestVar;
    Inc(FNrFunctions);
  end;
*)
end;

procedure TXForm.PrecalcAngle;
{$ifndef _ASM_}
begin
  FAngle := arctan2(FTx, FTy);
{$else}
asm
    fld     qword ptr [eax + FTx]
    fld     qword ptr [eax + FTy]
    fpatan
    fstp    qword ptr [eax + FAngle]
    //fwait
{$endif}
end;

procedure TXForm.PrecalcSinCos;
{$ifndef _ASM_}
begin
  FLength := sqrt(sqr(FTx) + sqr(FTy)) + EPS;
  FSinA := FTx / FLength;
  FCosA := FTy / FLength;
{$else}
asm
    fld     qword ptr [eax + FTx]
    fld     qword ptr [eax + FTy]
    fld     st(1)
    fmul    st, st
    fld     st(1)
    fmul    st, st
    faddp
    fsqrt
    fadd    qword ptr [EPS] // avoid divide by zero...(?)
    fdiv    st(1), st
    fdiv    st(2), st
    fstp    qword ptr [eax + FLength]
    fstp    qword ptr [eax + FCosA]
    fstp    qword ptr [eax + FSinA]
    //fwait
{$endif}
end;

procedure TXForm.PrecalcAll;
{$ifndef _ASM_}
begin
  FLength := sqrt(sqr(FTx) + sqr(FTy)) + EPS;
  FSinA := FTx / FLength;
  FCosA := FTy / FLength;
  FAngle := arctan2(FTx, FTy);
{$else}
asm
    fld     qword ptr [eax + FTx]
    fld     qword ptr [eax + FTy]
    fld     st(1)
    fld     st(1)
    fpatan
    fstp    qword ptr [eax + FAngle]
    fld     st(1)
    fmul    st, st
    fld     st(1)
    fmul    st, st
    faddp
    fsqrt
    fadd    qword ptr [EPS] // avoid divide by zero...(?)
    fdiv    st(1), st
    fdiv    st(2), st
    fstp    qword ptr [eax + FLength]
    fstp    qword ptr [eax + FCosA]
    fstp    qword ptr [eax + FSinA]
    //fwait
{$endif}
end;

procedure TXForm.DoPostTransform;
{$ifndef _ASM_}
begin
  FPx := p00 * FPx + p10 * FPy + p20;
  FPy := p01 * FPx + p11 * FPy + p21;
{$else}
asm
    fld     qword ptr [eax + FPy]
    fld     qword ptr [eax + FPx]
    fld     st(1)
    fmul    qword ptr [eax + p10]
    fld     st(1)
    fmul    qword ptr [eax + p00]
    faddp
    fadd    qword ptr [eax + p20]
    fstp    qword ptr [eax + FPx]
    fmul    qword ptr [eax + p01]
    fld     qword ptr [eax + p11]
    fmulp   st(2), st
    faddp
    fadd    qword ptr [eax + p21]
    fstp    qword ptr [eax + FPy]
    fwait
{$endif}
end;

//--0--////////////////////////////////////////////////////////////////////////
procedure TXForm.Linear;
{$ifndef _ASM_}
begin
  FPx := FPx + vars[0] * FTx;
  FPy := FPy + vars[0] * FTy;
{$else}
asm
    mov     edx, [eax + vars]
    fld     qword ptr [edx]
    fld     qword ptr [eax + FTx]
    fmul    st, st(1)
    fld     qword ptr [eax + FTy]
    fmulp   st(2), st
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fadd    qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fwait
{$endif}
end;

//--1--////////////////////////////////////////////////////////////////////////
procedure TXForm.Sinusoidal;
{$ifndef _ASM_}
begin
  FPx := FPx + vars[1] * sin(FTx);
  FPy := FPy + vars[1] * sin(FTy);
{$else}
asm
    mov     edx, [eax + vars]
    fld     qword ptr [edx + 1*8]
    fld     qword ptr [eax + FTx]
    fsin
    fmul    st, st(1)
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fld     qword ptr [eax + FTy]
    fsin
    fmulp
    fadd    qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fwait
{$endif}
end;

//--2--////////////////////////////////////////////////////////////////////////
procedure TXForm.Spherical;
{$ifndef _ASM_}
var
  r: double;
begin
  r := vars[2] / (sqr(FTx) + sqr(FTy) + EPS);
  FPx := FPx + FTx * r;
  FPy := FPy + FTy * r;
{$else}
asm
    fld     qword ptr [eax + FTy]
    fld     qword ptr [eax + FTx]
    fld     st(1)
    fmul    st, st
    fld     st(1)
    fmul    st, st
    faddp
    fadd    qword ptr [EPS]
    mov     edx, [eax + vars]
    fdivr   qword ptr [edx + 2*8]
    fmul    st(2), st
    fmulp
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fadd    qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fwait
{$endif}
end;

//--3--////////////////////////////////////////////////////////////////////////
procedure TXForm.Swirl;
{$ifndef _ASM_}
{
  r2 := FTx * FTx + FTy * FTy;
  c1 := sin(r2);
  c2 := cos(r2);
  FPx := FPx + vars[3] * (c1 * FTx - c2 * FTy);
  FPy := FPy + vars[3] * (c2 * FTx + c1 * FTy);
}
var
  sinr, cosr: double;
begin
  SinCos(sqr(FTx) + sqr(FTy), sinr, cosr);
  FPx := FPx + vars[3] * (sinr * FTx - cosr * FTy);
  FPy := FPy + vars[3] * (cosr * FTx + sinr * FTy);
{$else}
asm
    mov     edx, [eax + vars]
    fld     qword ptr [edx + 3*8]
    fld     qword ptr [eax + FTy]
    fld     qword ptr [eax + FTx]
    fld     st(1)
    fmul    st, st
    fld     st(1)
    fmul    st, st
    faddp
    fsincos
    fld     st(1)
    fmul    st, st(3)
    fld     st(1)
    fmul    st, st(5)
    fsubp   st(1), st
    fmul    st, st(5)
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fmulp    st(2), st
    fmulp    st(2), st
    faddp
    fmulp
    fadd    qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fwait
{$endif}
end;

//--4--////////////////////////////////////////////////////////////////////////
procedure TXForm.Horseshoe;
{$ifndef _ASM_}
// --Z-- he he he...
//                       FTx/FLength   FTy/FLength
//  FPx := FPx + vars[4] * (FSinA * FTx - FCosA * FTy);
//  FPy := FPy + vars[4] * (FCosA* FTx + FSinA * FTy);
var
  r: double;
begin
  r := vars[4] / (sqrt(sqr(FTx) + sqr(FTy)) + EPS);
  FPx := FPx + (FTx - FTy) * (FTx + FTy) * r;
  FPy := FPy + (2*FTx*FTy) * r;
{$else}
asm
    fld     qword ptr [eax + FTx]
    fld     qword ptr [eax + FTy]
    fld     st(1)
    fmul    st, st
    fld     st(1)
    fmul    st, st
    faddp
    fsqrt
    fadd    qword ptr [EPS]
    mov     edx, [eax + vars]
    fdivr   qword ptr [edx + 4*8]
    fld     st(2)
    fadd    st, st(2)
    fld     st(3)
    fsub    st, st(3)
    fmulp
    fmul    st, st(1)
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fmulp
    fmulp
    fadd    st, st
    fadd    qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fwait
{$endif}
end;

//--5--////////////////////////////////////////////////////////////////////////
procedure TXForm.Polar;
{$ifndef _ASM_}
{
var
  ny: double;
  rPI: double;
begin
  rPI := 0.31830989;
  ny := sqrt(FTx * FTx + FTy * FTy) - 1.0;
  FPx := FPx + vars[5] * (FAngle*rPI);
  FPy := FPy + vars[5] * ny;
}
begin
  FPx := FPx + polar_vpi * FAngle; //vars[5] * FAngle / PI;
  FPy := FPy + vars[5] * (sqrt(sqr(FTx) + sqr(FTy)) - 1.0);
{$else}
asm
    fld     qword ptr [eax + FAngle]
    fmul    qword ptr [eax + polar_vpi]
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fld     qword ptr [eax + FTx]
    fmul    st, st
    fld     qword ptr [eax + FTy]
    fmul    st, st
    faddp
    fsqrt
    fld1
    fsubp   st(1), st
    mov     edx, [eax + vars]
    fmul    qword ptr [edx + 5*8]
    fadd    qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fwait
{$endif}
end;

//--6--////////////////////////////////////////////////////////////////////////
procedure TXForm.FoldedHandkerchief;
{$ifndef _ASM_}
var
  r: double;
begin
  r := sqrt(sqr(FTx) + sqr(FTy));
  FPx := FPx + vars[6] * sin(FAngle + r) * r;
  FPy := FPy + vars[6] * cos(FAngle - r) * r;
{$else}
asm
    mov     edx, [eax + vars]
    fld     qword ptr [edx + 6*8]
    fld     qword ptr [eax + FTx]
    fmul    st, st
    fld     qword ptr [eax + FTy]
    fmul    st, st
    faddp
    fsqrt
    fld     qword ptr [eax + FAngle]
    fld     st
    fadd    st, st(2)
    fsin
    fmul    st, st(2)
    fmul    st, st(3)
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fsub    st, st(1)
    fcos
    fmulp
    fmulp
    fadd    qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fwait
{$endif}
end;

//--7--////////////////////////////////////////////////////////////////////////
procedure TXForm.Heart;
{$ifndef _ASM_}
var
  r, sinr, cosr: double;
begin
  r := sqrt(sqr(FTx) + sqr(FTy));
  Sincos(r*FAngle, sinr, cosr);
  r := r * vars[7];
  FPx := FPx + r * sinr;
  FPy := FPy - r * cosr;
{$else}
asm
    mov     edx, [eax + vars]
    fld     qword ptr [edx + 7*8]
    fld     qword ptr [eax + FTx]
    fmul    st, st
    fld     qword ptr [eax + FTy]
    fmul    st, st
    faddp
    fsqrt
    fmul    st(1), st
    fmul    qword ptr [eax + FAngle]
    fsincos
    fmul    st, st(2)
    fsubr   qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fmulp
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fwait
{$endif}
end;

//--8--////////////////////////////////////////////////////////////////////////
procedure TXForm.Disc;
{$ifndef _ASM_}
var
  r, sinr, cosr: double;
begin
  SinCos(PI * sqrt(sqr(FTx) + sqr(FTy)), sinr, cosr);
  r := vars[8] * FAngle / PI;
  FPx := FPx + sinr * r;
  FPy := FPy + cosr * r;
{$else}
asm
    mov     edx, [eax + vars]
    fld     qword ptr [edx + 8*8]
    fmul    qword ptr [eax + FAngle]
    fldpi
    fdivp   st(1), st
    fld     qword ptr [eax + FTx]
    fmul    st, st
    fld     qword ptr [eax + FTy]
    fmul    st, st
    faddp
    fsqrt
    fldpi
    fmulp
    fsincos
    fmul    st, st(2)
    fadd    qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fmulp
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fwait
{$endif}
end;

//--9--////////////////////////////////////////////////////////////////////////
procedure TXForm.Spiral;
{$ifndef _ASM_}
var
  r, sinr, cosr: double;
begin
  r := Flength + 1E-6;
  SinCos(r, sinr, cosr);
  r := vars[9] / r;
  FPx := FPx + (FCosA + sinr) * r;
  FPy := FPy + (FsinA - cosr) * r;
{$else}
asm
    mov     edx, [eax + vars]
    fld     qword ptr [edx + 9*8]
    fld     qword ptr [eax + FLength]
    fadd    qword ptr [EPS]
    fdiv    st(1), st
    fsincos
    fsubr   qword ptr [eax + FSinA]
    fmul    st, st(2)
    fadd    qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fadd    qword ptr [eax + FCosA]
    fmulp
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fwait
{$endif}
end;

//--10--///////////////////////////////////////////////////////////////////////
procedure TXForm.Hyperbolic;
{$ifndef _ASM_}
{
var
  r: double;
begin
  r := Flength + 1E-6;
  FPx := FPx + vars[10] * FSinA / r;
  FPy := FPy + vars[10] * FCosA * r;
}
// --Z-- Yikes!!! SOMEONE SHOULD GO BACK TO SCHOOL!!!!!!!
// Now watch and learn how to do this WITHOUT calculating sin and cos:
begin
  FPx := FPx + vars[10] * FTx / (sqr(FTx) + sqr(FTy) + EPS);
  FPy := FPy + vars[10] * FTy;
{$else}
asm
    mov     edx, [eax + vars]
    fld     qword ptr [edx + 10*8]
    fld     qword ptr [eax + FTy]
    fld     qword ptr [eax + FTx]
    fld     st(1)
    fmul    st, st
    fld     st(1)
    fmul    st, st
    faddp
    fadd    qword ptr [EPS]
    fdivp   st(1), st
    fmul    st, st(2)
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fmulp
    fadd    qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fwait
{$endif}
end;

//--11--///////////////////////////////////////////////////////////////////////
procedure TXForm.Square;
{$ifndef _ASM_}
var
  sinr, cosr: double;
begin
  SinCos(FLength, sinr, cosr);
  FPx := FPx + vars[11] * FSinA * cosr;
  FPy := FPy + vars[11] * FCosA * sinr;
{$else}
asm
    mov     edx, [eax + vars]
    fld     qword ptr [edx + 11*8]
    fld     qword ptr [eax + FLength]
    fsincos
    fmul    qword ptr [eax + FSinA]
    fmul    st, st(2)
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fmul    qword ptr [eax + FCosA]
    fmulp
    fadd    qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fwait
{$endif}
end;

//--12--///////////////////////////////////////////////////////////////////////
procedure TXForm.Ex;
{$ifndef _ASM_}
var
  r: double;
  n0, n1, m0, m1: double;
begin
  r := sqrt(sqr(FTx) + sqr(FTy));
  n0 := sin(FAngle + r);
  n1 := cos(FAngle - r);
  m0 := sqr(n0) * n0;
  m1 := sqr(n1) * n1;
  r := r * vars[12];
  FPx := FPx + r * (m0 + m1);
  FPy := FPy + r * (m0 - m1);
{$else}
asm
    fld     qword ptr [eax + FTx]
    fmul    st, st
    fld     qword ptr [eax + FTy]
    fmul    st, st
    faddp
    fsqrt
    fld     qword ptr [eax + FAngle]
    fld     st
    fadd    st, st(2)
    fsin
    fld     st
    fld     st
    fmulp
    fmulp
    fxch    st(1)
    fsub    st, st(2)
    fcos
    fld     st
    fld     st
    fmulp
    fmulp
    mov     edx, [eax + vars]
    fld     qword ptr [edx + 12*8]
    fmulp   st(3), st
    fld     st
    fadd    st, st(2)
    fmul    st, st(3)
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fsubp   st(1), st
    fmulp
    fadd    qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fwait
{$endif}
end;

//--13--///////////////////////////////////////////////////////////////////////
procedure TXForm.Julia;
{$ifndef _ASM_}
var
  r, sina, cosa: double;
begin
  SinCos(FAngle/2 + pi*random(2), sina, cosa);
  r := vars[13] * sqrt(sqrt(sqr(FTx) + sqr(FTy)));
  FPx := FPx + r * cosa;
  FPy := FPy + r * sina;
{$else}
asm
    fld     qword ptr [ebx + FAngle] // assert: self is in ebx
    fld1
    fld1
    faddp
    fdivp   st(1), st
    mov     eax, 2
    call    System.@RandInt

    shr     eax, 1
    jnc     @skip
    fldpi
    faddp
@skip:
{
    push    eax
    fild    dword ptr [esp]
    add     esp, 4
    fldpi
    fmulp
    faddp
}
    fsincos
    fld     qword ptr [ebx + FTx]
    fmul    st, st
    fld     qword ptr [ebx + FTy]
    fmul    st, st
    faddp
    fsqrt
    fsqrt
    mov     edx, [ebx + vars]
    fmul    qword ptr [edx + 13*8]
    fmul    st(2), st
    fmulp   st(1), st
    fadd    qword ptr [ebx + FPx]
    fstp    qword ptr [ebx + FPx]
    fadd    qword ptr [ebx + FPy]
    fstp    qword ptr [ebx + FPy]
    fwait
{$endif}
end;

//--14--///////////////////////////////////////////////////////////////////////
procedure TXForm.Bent;
{$ifndef _ASM_}
{
var
  nx, ny: double;
begin
  nx := FTx;
  ny := FTy;
  if (nx < 0) and (nx > -1E100) then
     nx := nx * 2;
  if ny < 0 then
    ny := ny / 2;
  FPx := FPx + vars[14] * nx;
  FPy := FPy + vars[14] * ny;
}
// --Z-- This variation is kinda weird...
begin
  if FTx < 0 then
    FPx := FPx + vars[14] * (FTx*2)
  else
    FPx := FPx + vars[14] * FTx;
  if FTy < 0 then
    FPy := FPy + vars[14] * (FTy/2)
  else
    FPy := FPy + vars[14] * FTy;
{$else}
// haven't noticed any improvement here... :-/
asm
    mov     edx, [eax + vars]
    fld     qword ptr [edx + 14*8]
    fld     qword ptr [ebx + FTx]
    ftst
    fstsw   ax
    sahf
    ja      @posx
    fadd    st, st
@posx:
    fmul    st, st(1)
    fadd    qword ptr [ebx + FPx]
    fstp    qword ptr [ebx + FPx]
    fld     qword ptr [ebx + FTy]
    ftst
    fstsw   ax
    sahf
    ja      @posy
    fld1
    fadd    st, st
    fdivp   st(1), st
@posy:
    fmulp
    fadd    qword ptr [ebx + FPy]
    fstp    qword ptr [ebx + FPy]
    fwait
{$endif}
end;

//--15--///////////////////////////////////////////////////////////////////////
procedure TXForm.Waves;
{$ifndef _ASM_}
{
var
  dx,dy,nx,ny: double;
begin
  dx := c20;
  dy := c21;
  nx := FTx + c10 * sin(FTy / ((dx * dx) + EPS));
  ny := FTy + c11 * sin(FTx / ((dy * dy) + EPS));
  FPx := FPx + vars[15] * nx;
  FPy := FPy + vars[15] * ny;
}
begin
  //FPx := FPx + vars[15] * (FTx + c10 * sin(FTy / (sqr(c20) + EPS)));
  //FPy := FPy + vars[15] * (FTy + c11 * sin(FTx / (sqr(c21) + EPS)));
  FPx := FPx + vars[15] * (FTx + c10 * sin(FTy * waves_f1));
  FPy := FPy + vars[15] * (FTy + c11 * sin(FTx * waves_f2));
{$else}
asm
    mov     edx, [eax + vars]
    fld     qword ptr [edx + 15*8]
    fld     qword ptr [eax + FTy]
    fld     qword ptr [eax + FTx]
    fld     st(1)
    fmul    qword ptr [eax + waves_f1]
    fsin
    fmul    qword ptr [eax + c10]
    fadd    st, st(1)
    fmul    st, st(3)
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fmul    qword ptr [eax + waves_f2]
    fsin
    fmul    qword ptr [eax + c11]
    faddp
    fmulp
    fadd    qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fwait
{$endif}
end;

//--16--///////////////////////////////////////////////////////////////////////
procedure TXForm.Fisheye;
{$ifndef _ASM_}
var
  r: double;
begin
{
//  r := sqrt(FTx * FTx + FTy * FTy);
//  a := arctan2(FTx, FTy);
//  r := 2 * r / (r + 1);
  r := 2 * Flength / (Flength + 1);
  FPx := FPx + vars[16] * r * FCosA;
  FPy := FPy + vars[16] * r * FSinA;
}
// --Z-- and again, sin & cos are NOT necessary here:
  r := 2 * vars[16] / (sqrt(sqr(FTx) + sqr(FTy)) + 1);
// by the way, now we can clearly see that the original author messed X and Y:
  FPx := FPx +  r * FTy;
  FPy := FPy +  r * FTx;
{$else}
asm
    mov     edx, [eax + vars]
    fld     qword ptr [edx + 16*8]
    fadd    st, st
    fld     qword ptr [eax + FTx]
    fld     qword ptr [eax + FTy]
    fld     st(1)
    fmul    st, st
    fld     st(1)
    fmul    st, st
    faddp
    fsqrt
    fld1
    faddp
    fdivp   st(3), st
    fmul    st, st(2)
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fmulp
    fadd    qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fwait
{$endif}
end;

//--17--///////////////////////////////////////////////////////////////////////
procedure TXForm.Popcorn;
{$ifndef _ASM_}
var
  dx, dy: double;
//  nx, ny: double;
begin
  dx := tan(3 * FTy);
  if (dx <> dx) then
    dx := 0.0;                  // < probably won't work in Delphi
  dy := tan(3 * FTx);            // NAN will raise an exception...
  if (dy <> dy) then
    dy := 0.0;                  // remove for speed?
//  nx := FTx + c20 * sin(dx);
//  ny := FTy + c21 * sin(dy);
//  FPx := FPx + vars[17] * nx;
//  FPy := FPy + vars[17] * ny;
  FPx := FPx + vars[17] * (FTx + c20 * sin(dx));
  FPy := FPy + vars[17] * (FTy + c21 * sin(dy));
{$else}
asm
    mov     edx, [eax + vars]
    fld     qword ptr [edx + 17*8]
    fld     qword ptr [eax + FTy]
    fld     qword ptr [eax + FTx]
    fld     st(1)
    fld     st
    fld     st
    faddp
    faddp
    fptan
    fstp    st
    fsin
    fmul    qword ptr [eax + c20]
    fadd    st, st(1)
    fmul    st, st(3)
    fadd    qword ptr [ebx + FPx]
    fstp    qword ptr [ebx + FPx]
    fld     st
    fld     st
    faddp
    faddp
    fptan
    fstp    st
    fsin
    fmul    qword ptr [eax + c21]
    faddp
    fmulp
    fadd    qword ptr [ebx + FPy]
    fstp    qword ptr [ebx + FPy]
    fwait
{$endif}
end;

//--18--///////////////////////////////////////////////////////////////////////
procedure TXForm.Exponential;
{$ifndef _ASM_}
var
  d: double;
  sinr, cosr: double;
begin
  SinCos(PI * FTy, sinr, cosr);
  d := vars[18] * exp(FTx - 1); // --Z-- (e^x)/e = e^(x-1)
  FPx := FPx +  cosr * d;
  FPy := FPy +  sinr * d;
{$else}
asm
    fld     qword ptr [eax + FTx]
    fld1
    fsubp   st(1), st
// --Z-- here goes exp(x) code from System.pas
    FLDL2E
    FMUL
    FLD     ST(0)
    FRNDINT
    FSUB    ST(1), ST
    FXCH    ST(1)
    F2XM1
    FLD1
    FADD
    FSCALE
    FSTP    ST(1)
// -----
    mov     edx, [eax + vars]
    fmul    qword ptr [edx + 18*8]
    fld     qword ptr [eax + FTy]
    fldpi
    fmulp
    fsincos
    fmul    st, st(2)
    fadd    qword ptr [ebx + FPx]
    fstp    qword ptr [ebx + FPx]
    fmulp
    fadd    qword ptr [ebx + FPy]
    fstp    qword ptr [ebx + FPy]
    fwait
{$endif}
end;

//--19--///////////////////////////////////////////////////////////////////////
procedure TXForm.Power;
{$ifndef _ASM_}
var
  r: double;
begin
  r := vars[19] * Math.Power(FLength, FSinA);
  FPx := FPx + r * FCosA;
  FPy := FPy + r * FSinA;
{$else}
// --Z-- x^y = 2^(y*log2(x))
asm
    fld     qword ptr [ebx + FSinA]
    fld     st
    fld     qword ptr [ebx + FLength]
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
    mov     edx, [eax + vars]
    fmul    qword ptr [edx + 19*8]
    fmul    st(1), st
    fmul    qword ptr [ebx + FCosA]
    fadd    qword ptr [ebx + FPx]
    fstp    qword ptr [ebx + FPx]
    fadd    qword ptr [ebx + FPy]
    fstp    qword ptr [ebx + FPy]
    fwait
{$endif}
end;

//--20--///////////////////////////////////////////////////////////////////////
procedure TXForm.Cosine;
{$ifndef _ASM_}
var
  sinr, cosr: double;
  e1, e2: double;
begin
//  SinCos(FTx * PI, sinr, cosr);
//  FPx := FPx + vars[20] * cosr * cosh(FTy);
//  FPy := FPy - vars[20] * sinr * sinh(FTy);
  SinCos(FTx * PI, sinr, cosr);
  if FTy = 0 then
  begin
    // sinh(0) = 0, cosh(0) = 1
    FPx := FPx + vars[20] * cosr;
  end
  else begin
    // --Z-- sinh() and cosh() both calculate exp(y) and exp(-y)
    e1 := exp(FTy);
    e2 := exp(-FTy);
    FPx := FPx + vars[20] * cosr * (e1 + e2)/2;
    FPy := FPy - vars[20] * sinr * (e1 - e2)/2;
  end;
{$else}
asm
    fld     qword ptr [eax + FTx]
    fldpi
    fmulp
    fsincos
    fld     qword ptr [eax + cosine_var2]
    fmul    st(2), st
    fmulp
    fld     qword ptr [eax + FTy]
// --Z-- here goes exp(x) modified to compute both exp(x) and exp(-x)
    FLDL2E
    FMUL
    FLD     ST(0)
    FRNDINT
    FSUB    ST(1), ST
    fld     st
    fchs
    fld     st(2)
    fchs
    F2XM1
    FLD1
    FADD
    FSCALE
    FSTP    ST(1)
    fxch    st(2)
    F2XM1
    FLD1
    FADD
    FSCALE
    FST     ST(1)
// -----
    fadd    st, st(2)
    fmulp   st(3), st
    fsubp   st(1), st
    fmulp   st(2), st
    fadd    qword ptr [ebx + FPx]
    fstp    qword ptr [ebx + FPx]
    fadd    qword ptr [ebx + FPy] // "add" because:
    fstp    qword ptr [ebx + FPy] // FPy := FPy + vars[20] * sinr * (e2 - e1)/2;
    fwait
{$endif}
end;

//--21--///////////////////////////////////////////////////////////////////////
procedure TXForm.Rings;
{$ifndef _ASM_}
var
  r: double;
  //dx: double;
begin
  //dx := sqr(c20) + EPS;
//  r := FLength;
//  r := r + dx - System.Int((r + dx)/(2 * dx)) * 2 * dx - dx + r * (1-dx);
// --Z--   ^^^^               heheeeee :-)               ^^^^

  r := vars[21] * (
         2 * FLength - rings_dx * (System.Int((FLength/rings_dx + 1)/2) * 2 + FLength)
       );
  FPx := FPx + r * FCosA;
  FPy := FPy + r * FSinA;
{$else}
asm
    fld     qword ptr [eax + FLength]
    fld     qword ptr [eax + rings_dx]
    fld     st(1)
    fdiv    st, st(1)
    fld1
    faddp
    fld1
    fld1
    faddp
    fdivp   st(1), st
    call    System.@Int
    fadd    st, st
    fadd    st, st(2)
    fmulp
    fsub    st, st(1)
    fsubp   st(1), st
    mov     edx, [eax + vars]
    fmul    qword ptr [edx + 21*8]
    fld     st
    fmul    qword ptr [eax + FCosA]
    fadd    qword ptr [ebx + FPx]
    fstp    qword ptr [ebx + FPx]
    fmul    qword ptr [eax + FSinA]
    fadd    qword ptr [ebx + FPy]
    fstp    qword ptr [ebx + FPy]
    fwait
{$endif}
end;

//--22--///////////////////////////////////////////////////////////////////////
procedure TXForm.Fan;
{$ifndef _ASM_}
var
  r, a : double;
  sinr, cosr: double;
  //dx, dy, dx2: double;
begin
  //dy := c21;
  //dx := PI * (sqr(c20) + EPS);
  //dx2 := dx/2;

//  if (FAngle+c21 - System.Int((FAngle + c21)/fan_dx) * fan_dx) > fan_dx2 then
//  if (FAngle + c21)/fan_dx - System.Int((FAngle + c21)/fan_dx) > 0.5 then
  if System.Frac((FAngle + c21)/fan_dx) > 0.5 then
    a := FAngle - fan_dx2
  else
    a := FAngle + fan_dx2;
  SinCos(a, sinr, cosr);
  r := vars[22] * sqrt(sqr(FTx) + sqr(FTy));
  FPx := FPx + r * cosr;
  FPy := FPy + r * sinr;
{$else}
asm
    fld     qword ptr [ebx + FAngle]
    fld     st
    fadd    qword ptr [ebx + c21]
    fdiv    qword ptr [ebx + fan_dx]
// --Z-- here goes Frac() code from System.pas
    FLD     ST(0)
    SUB     ESP,4
    FNSTCW  [ESP].Word     // save
    FNSTCW  [ESP+2].Word   // scratch
    FWAIT
    OR      [ESP+2].Word, $0F00  // trunc toward zero, full precision
    FLDCW   [ESP+2].Word
    FRNDINT
    FWAIT
    FLDCW   [ESP].Word
    ADD     ESP,4
    FSUB
// -----
    fadd    st, st
    fld1
//    fcompp        <-- replaced with FCOMIP
//    fnstsw  ax
//    shr     ah, 1
//    jnc     @else
    fcomip  st, st(1)
    fstp    st
    //fwait?
    ja @else
    fsub    qword ptr [ebx + fan_dx2]
    jmp     @skip
@else:
    fadd    qword ptr [ebx + fan_dx2]
@skip:
    fsincos
    fld     qword ptr [ebx + FTx]
    fmul    st, st
    fld     qword ptr [ebx + FTy]
    fmul    st, st
    faddp
    fsqrt
    mov     edx, [ebx + vars]
    fmul    qword ptr [edx + 22*8]
    fmul    st(2), st
    fmulp
    fadd    qword ptr [ebx + FPx]
    fstp    qword ptr [ebx + FPx]
    fadd    qword ptr [ebx + FPy]
    fstp    qword ptr [ebx + FPy]
    fwait
{$endif}
end;

//--23--///////////////////////////////////////////////////////////////////////
procedure TXForm.Eyefish;
{$ifndef _ASM_}
var
  r: double;
begin
  r := 2 * vars[23] / (sqrt(sqr(FTx) + sqr(FTy)) + 1);
  FPx := FPx + r * FTx;
  FPy := FPy + r * FTy;
{$else}
asm
    mov     edx, [eax + vars]
    fld     qword ptr [edx + 23*8]
    fadd    st, st
    fld     qword ptr [eax + FTy]
    fld     qword ptr [eax + FTx]
    fld     st(1)
    fmul    st, st
    fld     st(1)
    fmul    st, st
    faddp
    fsqrt
    fld1
    faddp
    fdivp   st(3), st
    fmul    st, st(2)
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fmulp
    fadd    qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fwait
{$endif}
end;

//--24--///////////////////////////////////////////////////////////////////////
procedure TXForm.Bubble;
{$ifndef _ASM_}
var
  r: double;
begin
  r := vars[24] / ((sqr(FTx) + sqr(FTy))/4 + 1);

  FPx := FPx + r * FTx;
  FPy := FPy + r * FTy;
{$else}
asm
    fld     qword ptr [eax + FTy]
    fld     qword ptr [eax + FTx]
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
    mov     edx, [eax + vars]
    fdivr   qword ptr [edx + 24*8]
    fmul    st(2), st
    fmulp
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fadd    qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fwait
{$endif}
end;

//--25--///////////////////////////////////////////////////////////////////////
procedure TXForm.Cylinder;
{$ifndef _ASM_}
begin
  FPx := FPx + vars[25] * sin(FTx);
  FPy := FPy + vars[25] * FTy;
{$else}
asm
    mov     edx, [eax + vars]
    fld     qword ptr [edx + 25*8]
    fld     qword ptr [eax + FTx]
    fsin
    fld     qword ptr [eax + FTy]
    fmul    st, st(2)
    fadd    qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fmulp
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fwait
{$endif}
end;

//--26--///////////////////////////////////////////////////////////////////////
procedure TXForm.Smoke;
const
  amplitude: single = 0.353553390593274; // a = sqrt(2)/4
{$ifndef _ASM_}
begin
  FPx := FPx + vars[26] * (FTx + amplitude * sin(FTy * pi));
  FPy := FPy + vars[26] * (FTy + amplitude * sin(FTx * pi));
{$else}
asm
    mov     edx, [eax + vars]
    fld     qword ptr [edx + 26*8]
    fld     dword ptr [amplitude]
    fld     qword ptr [eax + FTy]
    fldpi
    fld     qword ptr [eax + FTx]
    fld     st(2)
    fmul    st, st(2)
    fsin
    fmul    st, st(4)
    fadd    st, st(1)
    fmul    st, st(5)
    fadd    qword ptr [eax + FPx]
    fstp    qword ptr [eax + FPx]
    fmulp
    fsin
    fmulp   st(2), st
    faddp
    fmulp
    fadd    qword ptr [eax + FPy]
    fstp    qword ptr [eax + FPy]
    fwait
{$endif}
end;

//--27--///////////////////////////////////////////////////////////////////////
procedure TXForm.Noise;
{$ifndef _ASM_}
var
  r, sinr, cosr: double;
begin
  SinCos(random * 2*pi, sinr, cosr);
  r := vars[27] * random;
  FPx := FPx + FTx * r * cosr;
  FPy := FPy + FTy * r * sinr;
{$else}
asm
    mov     edx, [ebx + vars]
    fld     qword ptr [edx + 27*8]
    call    System.@RandExt
    fmulp
    call    System.@RandExt
    fadd    st, st
    fldpi
    fmulp
    fsincos
    fmul    st, st(2)
    fmul    qword ptr [ebx + FTx]
    fadd    qword ptr [ebx + FPx]
    fstp    qword ptr [ebx + FPx]
    fmulp
    fmul    qword ptr [ebx + FTy]
    fadd    qword ptr [ebx + FPy]
    fstp    qword ptr [ebx + FPy]
    fwait
{$endif}
end;

//***************************************************************************//

procedure TXForm.NextPoint(var px, py, pc: double);
var
  i: Integer;
begin
  // first compute the color coord
// --Z-- no, first let's optimize this huge expression ;)
//  pc := (pc + color) * 0.5 * (1 - symmetry) + symmetry * pc;
//      = (pc + color)/2 - (pc + color)/2*symmetry + symmetry * pc;
//      = (pc + color)/2 - (pc + color)*symmetry/2 + 2*pc*symmetry/2
//      = (pc + color - pc*symmetry - color*symmetry + 2*pc*symmetry)/2
//      = (pc + pc*symmetry + color - color*symmetry)/2
//      = (pc*(1 + symmetry) + color*(1 - symmetry))/2;
// ---> = pc*(1 + symmetry)/2 + color*(1 - symmetry)/2;
//           ^^^^^^const^^^^^   ^^^^^^^^^const^^^^^^^^
  pc := pc * colorC1 + colorC2; // heh! :-)

  FTx := c00 * px + c10 * py + c20;
  FTy := c01 * px + c11 * py + c21;

  Fpx := 0;
  Fpy := 0;

  for i := 0 to FNrFunctions - 1 do
    FCalcFunctionList[i];

  px := FPx;
  py := FPy;
//  px := p[0,0] * FPx + p[1,0] * FPy + p[2,0];
//  py := p[0,1] * FPx + p[1,1] * FPy + p[2,1];
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.NextPoint(var CPpoint: TCPpoint);
var
  i: Integer;
begin
  // first compute the color coord
//  CPpoint.c := (CPpoint.c + color) * 0.5 * (1 - symmetry) + symmetry * CPpoint.c;
  CPpoint.c := CPpoint.c * colorC1 + colorC2;

  FTx := c00 * CPpoint.x + c10 * CPpoint.y + c20;
  FTy := c01 * CPpoint.x + c11 * CPpoint.y + c21;

  Fpx := 0;
  Fpy := 0;

  for i:= 0 to FNrFunctions-1 do
    FCalcFunctionList[i];

  CPpoint.x := FPx;
  CPpoint.y := FPy;
//  CPpoint.x := p[0,0] * FPx + p[1,0] * FPy + p[2,0];
//  CPpoint.y := p[0,1] * FPx + p[1,1] * FPy + p[2,1];
end;

procedure TXForm.NextPointTo(var CPpoint, ToPoint: TCPpoint);
var
  i: Integer;
begin
  ToPoint.c := CPpoint.c * colorC1 + colorC2;

  FTx := c00 * CPpoint.x + c10 * CPpoint.y + c20;
  FTy := c01 * CPpoint.x + c11 * CPpoint.y + c21;

  Fpx := 0;
  Fpy := 0;

  for i:= 0 to FNrFunctions-1 do
    FCalcFunctionList[i];

  ToPoint.x := FPx;
  ToPoint.y := FPy;
end;

{
///////////////////////////////////////////////////////////////////////////////
procedure TXForm.NextPoint(var px, py, pz, pc: double);
var
  i: Integer;
  tpx, tpy: double;
begin
  // first compute the color coord
  pc := (pc + color) * 0.5 * (1 - symmetry) + symmetry * pc;

  case Orientationtype of
  1:
     begin
       tpx := px;
       tpy := pz;
     end;
  2:
     begin
       tpx := py;
       tpy := pz;
     end;
  else
    tpx := px;
    tpy := py;
  end;

  FTx := c00 * tpx + c10 * tpy + c20;
  FTy := c01 * tpx + c11 * tpy + c21;

(*
  if CalculateAngle then begin
    if (FTx < -EPS) or (FTx > EPS) or (FTy < -EPS) or (FTy > EPS) then
       FAngle := arctan2(FTx, FTy)
    else
       FAngle := 0.0;
  end;

  if CalculateSinCos then begin
    Flength := sqrt(sqr(FTx) + sqr(FTy));
    if FLength = 0 then begin
      FSinA := 0;
      FCosA := 1;
    end else begin
      FSinA := FTx/FLength;
      FCosA := FTy/FLength;
    end;
  end;

//  if CalculateLength then begin
//    FLength := sqrt(FTx * FTx + FTy * FTy);
//  end;
*)

  Fpx := 0;
  Fpy := 0;

  for i:= 0 to FNrFunctions-1 do
    FFunctionList[i];

  case Orientationtype of
  1:
     begin
       px := FPx;
       pz := FPy;
     end;
  2:
     begin
       py := FPx;
       pz := FPy;
     end;
  else
    px := FPx;
    py := FPy;
  end;
end;
}

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.NextPoint2C(var p: T2CPoint);
var
  i: Integer;
begin
  // first compute the color coord
//  pc1 := (pc1 + color) * 0.5 * (1 - symmetry) + symmetry * pc1;
//  pc2 := (pc2 + color) * 0.5 * (1 - symmetry) + symmetry * pc2;
  p.c1 := p.c1 * colorC1 + colorC2;
  p.c2 := p.c2 * colorC1 + colorC2;

  FTx := c00 * p.x + c10 * p.y + c20;
  FTy := c01 * p.x + c11 * p.y + c21;

  Fpx := 0;
  Fpy := 0;

  for i:= 0 to FNrFunctions-1 do
    FCalcFunctionList[i];

  p.x := FPx;
  p.y := FPy;
//  px := p[0,0] * FPx + p[1,0] * FPy + p[2,0];
//  py := p[0,1] * FPx + p[1,1] * FPy + p[2,1];
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.NextPointXY(var px, py: double);
var
  i: integer;
begin
  FTx := c00 * px + c10 * py + c20;
  FTy := c01 * px + c11 * py + c21;

  Fpx := 0;
  Fpy := 0;

  for i:= 0 to FNrFunctions-1 do
    FCalcFunctionList[i];

  px := FPx;
  py := FPy;
//  px := p[0,0] * FPx + p[1,0] * FPy + p[2,0];
//  py := p[0,1] * FPx + p[1,1] * FPy + p[2,1];
end;

///////////////////////////////////////////////////////////////////////////////
function TXForm.Mul33(const M1, M2: TMatrix): TMatrix;
begin
  result[0, 0] := M1[0][0] * M2[0][0] + M1[0][1] * M2[1][0] + M1[0][2] * M2[2][0];
  result[0, 1] := M1[0][0] * M2[0][1] + M1[0][1] * M2[1][1] + M1[0][2] * M2[2][1];
  result[0, 2] := M1[0][0] * M2[0][2] + M1[0][1] * M2[1][2] + M1[0][2] * M2[2][2];
  result[1, 0] := M1[1][0] * M2[0][0] + M1[1][1] * M2[1][0] + M1[1][2] * M2[2][0];
  result[1, 1] := M1[1][0] * M2[0][1] + M1[1][1] * M2[1][1] + M1[1][2] * M2[2][1];
  result[1, 2] := M1[1][0] * M2[0][2] + M1[1][1] * M2[1][2] + M1[1][2] * M2[2][2];
  result[2, 0] := M1[2][0] * M2[0][0] + M1[2][1] * M2[1][0] + M1[2][2] * M2[2][0];
  result[2, 0] := M1[2][0] * M2[0][1] + M1[2][1] * M2[1][1] + M1[2][2] * M2[2][1];
  result[2, 0] := M1[2][0] * M2[0][2] + M1[2][1] * M2[1][2] + M1[2][2] * M2[2][2];
end;

///////////////////////////////////////////////////////////////////////////////
function TXForm.Identity: TMatrix;
var
  i, j: integer;
begin
  for i := 0 to 2 do
    for j := 0 to 2 do
      Result[i, j] := 0;
  Result[0][0] := 1;
  Result[1][1] := 1;
  Result[2][2] := 1;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Rotate(const degrees: double);
var
  r: double;
  Matrix, M1: TMatrix;
begin
  r := degrees * pi / 180;
  M1 := Identity;
  M1[0, 0] := cos(r);
  M1[0, 1] := -sin(r);
  M1[1, 0] := sin(r);
  M1[1, 1] := cos(r);
  Matrix := Identity;

  Matrix[0][0] := c[0, 0];
  Matrix[0][1] := c[0, 1];
  Matrix[1][0] := c[1, 0];
  Matrix[1][1] := c[1, 1];
  Matrix[0][2] := c[2, 0];
  Matrix[1][2] := c[2, 1];
  Matrix := Mul33(Matrix, M1);
  c[0, 0] := Matrix[0][0];
  c[0, 1] := Matrix[0][1];
  c[1, 0] := Matrix[1][0];
  c[1, 1] := Matrix[1][1];
  c[2, 0] := Matrix[0][2];
  c[2, 1] := Matrix[1][2];
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Translate(const x, y: double);
var
  Matrix, M1: TMatrix;
begin
  M1 := Identity;
  M1[0, 2] := x;
  M1[1, 2] := y;
  Matrix := Identity;

  Matrix[0][0] := c[0, 0];
  Matrix[0][1] := c[0, 1];
  Matrix[1][0] := c[1, 0];
  Matrix[1][1] := c[1, 1];
  Matrix[0][2] := c[2, 0];
  Matrix[1][2] := c[2, 1];
  Matrix := Mul33(Matrix, M1);
  c[0, 0] := Matrix[0][0];
  c[0, 1] := Matrix[0][1];
  c[1, 0] := Matrix[1][0];
  c[1, 1] := Matrix[1][1];
  c[2, 0] := Matrix[0][2];
  c[2, 1] := Matrix[1][2];
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Multiply(const a, b, c, d: double);
var
  Matrix, M1: TMatrix;
begin
  M1 := Identity;
  M1[0, 0] := a;
  M1[0, 1] := b;
  M1[1, 0] := c;
  M1[1, 1] := d;
  Matrix := Identity;
  Matrix[0][0] := Self.c[0, 0];
  Matrix[0][1] := Self.c[0, 1];
  Matrix[1][0] := Self.c[1, 0];
  Matrix[1][1] := Self.c[1, 1];
  Matrix[0][2] := Self.c[2, 0];
  Matrix[1][2] := Self.c[2, 1];
  Matrix := Mul33(Matrix, M1);
  Self.c[0, 0] := Matrix[0][0];
  Self.c[0, 1] := Matrix[0][1];
  Self.c[1, 0] := Matrix[1][0];
  Self.c[1, 1] := Matrix[1][1];
  Self.c[2, 0] := Matrix[0][2];
  Self.c[2, 1] := Matrix[1][2];
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Scale(const s: double);
var
  Matrix, M1: TMatrix;
begin
  M1 := Identity;
  M1[0, 0] := s;
  M1[1, 1] := s;
  Matrix := Identity;
  Matrix[0][0] := c[0, 0];
  Matrix[0][1] := c[0, 1];
  Matrix[1][0] := c[1, 0];
  Matrix[1][1] := c[1, 1];
  Matrix[0][2] := c[2, 0];
  Matrix[1][2] := c[2, 1];
  Matrix := Mul33(Matrix, M1);
  c[0, 0] := Matrix[0][0];
  c[0, 1] := Matrix[0][1];
  c[1, 0] := Matrix[1][0];
  c[1, 1] := Matrix[1][1];
  c[2, 0] := Matrix[0][2];
  c[2, 1] := Matrix[1][2];
end;

///////////////////////////////////////////////////////////////////////////////
destructor TXForm.Destroy;
var
  i: integer;
begin
//  if assigned(Script) then
//    Script.Free;

  for i := 0 to High(FRegVariations) do
    FRegVariations[i].Free;

  inherited;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.BuildFunctionlist;
var
  i: integer;
begin
  SetLength(FFunctionList, NrVar + Length(FRegVariations));

  //fixed
  FFunctionList[0] := Linear;
  FFunctionList[1] := Sinusoidal;
  FFunctionList[2] := Spherical;
  FFunctionList[3] := Swirl;
  FFunctionList[4] := Horseshoe;
  FFunctionList[5] := Polar;
  FFunctionList[6] := FoldedHandkerchief;
  FFunctionList[7] := Heart;
  FFunctionList[8] := Disc;
  FFunctionList[9] := Spiral;
  FFunctionList[10] := Hyperbolic;
  FFunctionList[11] := Square;
  FFunctionList[12] := Ex;
  FFunctionList[13] := Julia;
  FFunctionList[14] := Bent;
  FFunctionList[15] := Waves;
  FFunctionList[16] := Fisheye;
  FFunctionList[17] := Popcorn;
  FFunctionList[18] := Exponential;
  FFunctionList[19] := Power;
  FFunctionList[20] := Cosine;
  FFunctionList[21] := Rings;
  FFunctionList[22] := Fan;
  FFunctionList[23] := Eyefish;
  FFunctionList[24] := Bubble;
  FFunctionList[25] := Cylinder;
  FFunctionList[26] := Smoke;
  FFunctionList[27] := Noise;

  //registered
  for i := 0 to High(FRegVariations) do
    FFunctionList[NRLOCVAR + i] := FRegVariations[i].CalcFunction;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.AddRegVariations;
var
  i: integer;
begin
  SetLength(FRegVariations, GetNrRegisteredVariations);
  for i := 0 to GetNrRegisteredVariations - 1 do begin
    FRegVariations[i] := GetRegisteredVariation(i).GetInstance;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Assign(XForm: TXForm);
var
  i,j: integer;
  Name: string;
  Value: double;
begin
  if Not assigned(XForm) then
    Exit;

  for i := 0 to High(vars) do
    vars[i] := XForm.vars[i];

  c := Xform.c;
  p := Xform.p;
  density := XForm.density;
  color := XForm.color;
  color2 := XForm.color2;
  symmetry := XForm.symmetry;
  Orientationtype := XForm.Orientationtype;

  for i := 0 to High(FRegVariations)  do begin
    for j:= 0 to FRegVariations[i].GetNrVariables -1 do begin
      Name := FRegVariations[i].GetVariableNameAt(j);
      XForm.FRegVariations[i].GetVariable(Name,Value);
      FRegVariations[i].SetVariable(Name,Value);
    end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TXForm.ToXMLString: string;
var
  i, j: integer;
  Name: string;
  Value: double;
begin
  result := Format('   <xform weight="%g" color="%g" symmetry="%g" ', [density, color, symmetry]);
  for i := 0 to nrvar - 1 do begin
    if vars[i] <> 0 then
      Result := Result + varnames(i) + format('="%g" ', [vars[i]]);
  end;
  Result := Result + Format('coefs="%g %g %g %g %g %g" ', [c[0,0], c[0,1], c[1,0], c[1,1], c[2,0], c[2,1]]);
  if (p[0,0]<>1) or (p[0,1]<>0) or(p[1,0]<>0) or (p[1,1]<>1) or (p[2,0]<>0) or (p[2,1]<>0) then
    Result := Result + Format('post="%g %g %g %g %g %g" ', [p[0,0], p[0,1], p[1,0], p[1,1], p[2,0], p[2,1]]);

  for i := 0 to High(FRegVariations)  do begin
    if vars[i+NRLOCVAR] <> 0 then
      for j:= 0 to FRegVariations[i].GetNrVariables -1 do begin
        Name := FRegVariations[i].GetVariableNameAt(j);
        FRegVariations[i].GetVariable(Name,Value);
        Result := Result + Format('%s="%g" ', [name, value]);
      end;
  end;

  Result := Result + '/>';
end;

function TXForm.FinalToXMLString(IsEnabled: boolean): string;
var
  i, j: integer;
  Name: string;
  Value: double;
begin
  result := Format('   <finalxform enabled="%d" color="%g" symmetry="%g" ',
                   [ifthen(IsEnabled, 1, 0), color, symmetry]);
  for i := 0 to nrvar - 1 do begin
    if vars[i] <> 0 then
      Result := Result + varnames(i) + format('="%g" ', [vars[i]]);
  end;
  Result := Result + Format('coefs="%g %g %g %g %g %g" ', [c[0,0], c[0,1], c[1,0], c[1,1], c[2,0], c[2,1]]);
  if (p[0,0]<>1) or (p[0,1]<>0) or(p[1,0]<>0) or (p[1,1]<>1) or (p[2,0]<>0) or (p[2,1]<>0) then
    Result := Result + Format('post="%g %g %g %g %g %g" ', [p[0,0], p[0,1], p[1,0], p[1,1], p[2,0], p[2,1]]);

  for i := 0 to High(FRegVariations)  do begin
    if vars[i+NRLOCVAR] <> 0 then
      for j:= 0 to FRegVariations[i].GetNrVariables -1 do begin
        Name := FRegVariations[i].GetVariableNameAt(j);
        FRegVariations[i].GetVariable(Name,Value);
        Result := Result + Format('%s="%g" ', [name, value]);
      end;
  end;

  Result := Result + '/>';
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.SetVariable(const name: string; var Value: double);
var
  i: integer;
begin
  for i := 0 to High(FRegVariations) do
    if FRegVariations[i].SetVariable(name, value) then
      break;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.GetVariable(const name: string; var Value: double);
var
  i: integer;
begin
  for i := 0 to High(FRegVariations) do
    if FRegVariations[i].GetVariable(name, value) then
      break;
end;

///////////////////////////////////////////////////////////////////////////////
end.
