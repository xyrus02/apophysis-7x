unit XForm;

interface

uses
  XFormMan, baseVariation;

type
  TCalcMethod = procedure of object;

type
  TCPpoint = record
    x, y, c: double;
  end;
  PCPpoint = ^TCPpoint;

  TXYpoint = record
    x, y: double;
  end;
  PXYpoint = ^TXYpoint;

  TMatrix = array[0..2, 0..2] of double;

type
  TXForm = class
  private
    FNrFunctions: Integer;
    FFunctionList: array of TCalcMethod;
    FCalcFunctionList: array[0..64] of TCalcMethod;

    FTx, FTy: double;
    FPx, FPy: double;
    FAngle: double;
    FSinA: double;
    FCosA: double;
    FLength: double;
    CalculateAngle: boolean;
    CalculateLength: boolean;
    CalculateSinCos: boolean;

    FRegVariations: array of TBaseVariation;

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

    procedure Triblob;             // var[23]
    procedure Daisy;               // var[24]
    procedure Checkers;            // var[25]
    procedure CRot;                // var[26]

    function Mul33(const M1, M2: TMatrix): TMatrix;
    function Identity: TMatrix;

    procedure BuildFunctionlist;
    procedure AddRegVariations;

  public
    vars: array of double; // normalized interp coefs between variations
    c: array[0..2, 0..1] of double;      // the coefs to the affine part of the function
    p: array[0..2, 0..1] of double;      // the coefs to the affine part of the function
    density: double;                     // prob is this function is chosen. 0 - 1
    color: double;                       // color coord for this function. 0 - 1
    color2: double;                      // Second color coord for this function. 0 - 1
    symmetry: double;
    c00, c01, c10, c11, c20, c21: double;

//    nx,ny,x,y: double;
//    script: TatPascalScripter;

    Orientationtype: integer;

    constructor Create;
    destructor Destroy; override;
    procedure Prepare;

    procedure Assign(Xform: TXForm);

    procedure NextPoint(var px, py, pc: double); overload;
    procedure NextPoint(var CPpoint: TCPpoint); overload;
    procedure NextPoint(var px, py, pz, pc: double); overload;
    procedure NextPointXY(var px, py: double);
    procedure NextPoint2C(var px, py, pc1, pc2: double);

    procedure Rotate(const degrees: double);
    procedure Translate(const x, y: double);
    procedure Multiply(const a, b, c, d: double);
    procedure Scale(const s: double);

    procedure SetVariable(const name: string; var Value: double);
    procedure GetVariable(const name: string; var Value: double);

    function ToXMLString: string;
  end;

implementation

uses
  SysUtils, Math;

const
  EPS = 1E-10;

{ TXForm }

///////////////////////////////////////////////////////////////////////////////
constructor TXForm.Create;
var
  i: Integer;
begin
  density := 0;
  Color := 0;
  c[0, 0] := 1;
  c[0, 1] := 0;
  c[1, 0] := 0;
  c[1, 1] := 1;
  c[2, 0] := 0;
  c[2, 1] := 0;
  Symmetry := 0;

  AddRegVariations;
  BuildFunctionlist;

  SetLength(vars, NRLOCVAR + Length(FRegVariations));
  Vars[0] := 1;
  for i := 1 to High(vars) do
    Vars[i] := 0;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Prepare;
var
  i: integer;
begin
  c00 := c[0][0];
  c01 := c[0][1];
  c10 := c[1][0];
  c11 := c[1][1];
  c20 := c[2][0];
  c21 := c[2][1];

  FNrFunctions := 0;

  for i := 0 to High(FRegVariations) do begin
    FRegVariations[i].FPX := @FPX;
    FRegVariations[i].FPY := @FPY;
    FRegVariations[i].FTX := @FTX;
    FRegVariations[i].FTY := @FTY;

    FRegVariations[i].vvar := vars[i + NRLOCVAR];
    FRegVariations[i].prepare;
  end;

  for i := 0 to NrVar - 1 do begin
    if (vars[i] <> 0.0) then begin
      FCalcFunctionList[FNrFunctions] := FFunctionList[i];
      Inc(FNrFunctions);
    end;
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

  CalculateAngle := (vars[5] <> 0.0) or (vars[6] <> 0.0) or (vars[7] <> 0.0) or (vars[8] <> 0.0) or
                    (vars[12] <> 0.0) or (vars[13] <> 0.0) or (vars[21] <> 0.0) or (vars[22] <> 0.0);
  CalculateLength := False;
  CalculateSinCos := (vars[4] <> 0.0) or (vars[9] <> 0.0) or (vars[10] <> 0.0) or
                     (vars[11] <> 0.0) or (vars[16] <> 0.0) or (vars[19] <> 0.0) or
                     (vars[21] <> 0.0);

end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Linear;
begin
  FPx := FPx + vars[0] * FTx;
  FPy := FPy + vars[0] * FTy;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Sinusoidal;
begin
  FPx := FPx + vars[1] * sin(FTx);
  FPy := FPy + vars[1] * sin(FTy);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Spherical;
var
  r2, rr2: double;
begin
  r2 := FTx * FTx + FTy * FTy + 1E-6;
  rr2 := 1 / r2;
  FPx := FPx + vars[2] * (FTx * rr2);
  FPy := FPy + vars[2] * (FTy * rr2);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Swirl;
var
  c1, c2, r2: double;
begin
  r2 := FTx * FTx + FTy * FTy;
  c1 := sin(r2);
  c2 := cos(r2);
  FPx := FPx + vars[3] * (c1 * FTx - c2 * FTy);
  FPy := FPy + vars[3] * (c2 * FTx + c1 * FTy);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Horseshoe;
//var
//  a, c1, c2: double;
begin
//  if (FTx < -EPS) or (FTx > EPS) or (FTy < -EPS) or (FTy > EPS) then
//    a := arctan2(FTx, FTy)
//  else
//    a := 0.0;
//  c1 := sin(FAngle);
//  c2 := cos(FAngle);
  FPx := FPx + vars[4] * (FSinA * FTx - FCosA * FTy);
  FPy := FPy + vars[4] * (FCosA* FTx + FSinA * FTy);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Polar;
var
  ny: double;
  rPI: double;
begin
  rPI := 0.31830989;
  ny := sqrt(FTx * FTx + FTy * FTy) - 1.0;
  FPx := FPx + vars[5] * (FAngle*rPI);
  FPy := FPy + vars[5] * ny;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.FoldedHandkerchief;
var
  r: double;
begin
  r := sqrt(FTx * FTx + FTy * FTy);
  FPx := FPx + vars[6] * sin(FAngle + r) * r;
  FPy := FPy + vars[6] * cos(FAngle - r) * r;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Heart;
var
  r: double;
begin
  r := sqrt(FTx * FTx + FTy * FTy);

  FPx := FPx + vars[7] * sin(FAngle * r) * r;
  FPy := FPy + vars[7] * cos(FAngle * r) * -r;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Disc;
var
  nx, ny, r: double;
  rPI: double;
begin
  rPI := 0.31830989;
  nx := FTx * PI;
  ny := FTy * PI;

  r := sqrt(nx * nx + ny * ny);
  FPx := FPx + vars[8] * sin(r) * FAngle * rPI;
  FPy := FPy + vars[8] * cos(r) * FAngle * rPI;

end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Spiral;
var
  r, rr: double;
begin
//  r := sqrt(FTx * FTx + FTy * FTy) + 1E-6;
  r := Flength + 1E-6;
  rr := 1 / r;
  FPx := FPx + vars[9] * (FCosA + sin(r)) * rr;
  FPy := FPy + vars[9] * (FsinA - cos(r)) * rr;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.hyperbolic;
var
  r: double;
begin
//  r := sqrt(FTx * FTx + FTy * FTy) + 1E-6;
  r := Flength + 1E-6;
  FPx := FPx + vars[10] * FSinA / r;
  FPy := FPy + vars[10] * FCosA * r;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Square;
//var
//  r: double;
begin
//  r := sqrt(FTx * FTx + FTy * FTy);
  FPx := FPx + vars[11] * FSinA * cos(Flength);
  FPy := FPy + vars[11] * FCosA * sin(Flength);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Ex;
var
  r: double;
  n0,n1, m0, m1: double;
begin
  r := sqrt(FTx * FTx + FTy * FTy);
  n0 := sin(FAngle + r);
  n1 := cos(FAngle - r);
  m0 := n0 * n0 * n0 * r;
  m1 := n1 * n1 * n1 * r;
  FPx := FPx + vars[12] * (m0 + m1);
  FPy := FPy + vars[12] * (m0 - m1);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Julia;
var
  a,r: double;
begin
  r := Math.power(FTx * FTx + FTy * FTy, 0.25);
  a := FAngle*0.5 + Trunc(random * 2) * PI;
  FPx := FPx + vars[13] * r * cos(a);
  FPy := FPy + vars[13] * r * sin(a);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Bent;
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
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Waves;
var
  dx,dy,nx,ny: double;
begin
  dx := c20;
  dy := c21;
  nx := FTx + c10 * sin(FTy / ((dx * dx) + EPS));
  ny := FTy + c11 * sin(FTx / ((dy * dy) + EPS));
  FPx := FPx + vars[15] * nx;
  FPy := FPy + vars[15] * ny;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Fisheye;
var
 { a,} r: double;
begin
//  r := sqrt(FTx * FTx + FTy * FTy);
//  a := arctan2(FTx, FTy);
//  r := 2 * r / (r + 1);
  r := 2 * Flength / (Flength + 1);
  FPx := FPx + vars[16] * r * FCosA;
  FPy := FPy + vars[16] * r * FSinA;

end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Popcorn;
var
  dx, dy: double;
  nx, ny: double;
begin
  dx := tan(3 * FTy);
  if (dx <> dx) then
    dx := 0.0;                  // < probably won't work in Delphi
  dy := tan(3 * FTx);            // NAN will raise an exception...
  if (dy <> dy) then
    dy := 0.0;                  // remove for speed?
  nx := FTx + c20 * sin(dx);
  ny := FTy + c21 * sin(dy);
  FPx := FPx + vars[17] * nx;
  FPy := FPy + vars[17] * ny;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Exponential;
var
  dx, dy: double;
begin
  dx := exp(FTx)/ 2.718281828459045;
  dy := PI * FTy;
  FPx := FPx + vars[18] * cos(dy) * dx;
  FPy := FPy + vars[18] * sin(dy) * dx;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Power;
var
  r: double;
//  nx, ny: double;
begin
//  r := sqrt(FTx * FTx + FTy * FTy);
//  sa := sin(FAngle);
  r := Math.Power(FLength, FSinA);
//  nx := r * FCosA;
//  ny := r * FSinA;
  FPx := FPx + vars[19] * r * FCosA;
  FPy := FPy + vars[19] * r * FSinA;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Cosine;
var
  nx, ny: double;
begin
  nx := cos(FTx * PI) * cosh(FTy);
  ny := -sin(FTx * PI) * sinh(FTy);
  FPx := FPx + vars[20] * nx;
  FPy := FPy + vars[20] * ny;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Rings;
var
  r: double;
  dx: double;
begin
  dx := sqr(c20) + EPS;
  r := FLength;
  r := r + dx - System.Int((r + dx)/(2 * dx)) * 2 * dx - dx + r * (1-dx);

  FPx := FPx + vars[21] * r * cos(FAngle);
  FPy := FPy + vars[21] * r * sin(FAngle);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Fan;
var
  r,t,a : double;
  dx, dy, dx2: double;
begin
  dy := c21;
  dx := PI * (sqr(c20) + EPS);
  dx2 := dx/2;

  r := sqrt(FTx * FTx + FTy * FTy);

  t := FAngle+dy - System.Int((FAngle + dy)/dx) * dx;
  if (t > dx2) then
    a := FAngle - dx2
  else
    a := FAngle + dx2;

  FPx := FPx + vars[22] * r * cos(a);
  FPy := FPy + vars[22] * r * sin(a);
end;


///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Triblob;
var
  r : double;
  Angle: double;
begin
  r := sqrt(FTx * FTx + FTy * FTy);
  if (FTx < -EPS) or (FTx > EPS) or (FTy < -EPS) or (FTy > EPS) then
     Angle := arctan2(FTx, FTy)
  else
    Angle := 0.0;

  r := r * (0.6 + 0.4 * sin(3 * Angle));

  FPx := FPx + vars[23] * r * cos(Angle);
  FPy := FPy + vars[23] * r * sin(Angle);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Daisy;
var
  r : double;
  Angle: double;
begin
  r := sqrt(FTx * FTx + FTy * FTy);
  if (FTx < -EPS) or (FTx > EPS) or (FTy < -EPS) or (FTy > EPS) then
     Angle := arctan2(FTx, FTy)
  else
    Angle := 0.0;

//  r := r * (0.6 + 0.4 * sin(3 * Angle));
  r := r * ( 1 - Sqr(sin(5 * Angle)));

  FPx := FPx + vars[24] * r * cos(Angle);
  FPy := FPy + vars[24] * r * sin(Angle);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Checkers;
var
  dx: double;
begin
  if odd(Round(FTX * 5) + Round(FTY * 5)) then
    dx := 0.2
  else
    dx := 0;

  FPx := FPx + vars[25] * FTx + dx;
  FPy := FPy + vars[25] * FTy;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.CRot;
var
  r : double;
  Angle: double;
begin
  r := sqrt(FTx * FTx + FTy * FTy);
  if (FTx < -EPS) or (FTx > EPS) or (FTy < -EPS) or (FTy > EPS) then
     Angle := arctan2(FTx, FTy)
  else
    Angle := 0.0;

  if r < 3 then
    Angle := Angle + (3 - r) * sin(3 * r);

//   r:=  R - 0.04 * sin(6.2 * R - 1) - 0.008 * R;

  FPx := FPx + vars[26] * r * cos(Angle);
  FPy := FPy + vars[26] * r * sin(Angle);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.NextPoint(var px,py,pc: double);
var
  i: Integer;
begin
  // first compute the color coord
  pc := (pc + color) * 0.5 * (1 - symmetry) + symmetry * pc;

  FTx := c00 * px + c10 * py + c20;
  FTy := c01 * px + c11 * py + c21;

  if CalculateAngle then begin
    if (FTx < -EPS) or (FTx > EPS) or (FTy < -EPS) or (FTy > EPS) then
       FAngle := arctan2(FTx, FTy)
    else
       FAngle := 0.0;
  end;

  if CalculateSinCos then begin
    Flength := sqrt(FTx * FTx + FTy * FTy);
    if FLength = 0 then begin
      FSinA := 0;
      FCosA := 0;
    end else begin
      FSinA := FTx/FLength;
      FCosA := FTy/FLength;
    end;
  end;

//  if CalculateLength then begin
//    FLength := sqrt(FTx * FTx + FTy * FTy);
//  end;

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
  CPpoint.c := (CPpoint.c + color) * 0.5 * (1 - symmetry) + symmetry * CPpoint.c;

  FTx := c00 * CPpoint.x + c10 * CPpoint.y + c20;
  FTy := c01 * CPpoint.x + c11 * CPpoint.y + c21;

  if CalculateAngle then begin
    if (FTx < -EPS) or (FTx > EPS) or (FTy < -EPS) or (FTy > EPS) then
       FAngle := arctan2(FTx, FTy)
    else
       FAngle := 0.0;
  end;

  if CalculateSinCos then begin
    Flength := sqrt(FTx * FTx + FTy * FTy);
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

  Fpx := 0;
  Fpy := 0;

  for i:= 0 to FNrFunctions-1 do
    FFunctionList[i];

  CPpoint.x := FPx;
  CPpoint.y := FPy;
//  CPpoint.x := p[0,0] * FPx + p[1,0] * FPy + p[2,0];
//  CPpoint.y := p[0,1] * FPx + p[1,1] * FPy + p[2,1];
end;


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

  if CalculateAngle then begin
    if (FTx < -EPS) or (FTx > EPS) or (FTy < -EPS) or (FTy > EPS) then
       FAngle := arctan2(FTx, FTy)
    else
       FAngle := 0.0;
  end;

  if CalculateSinCos then begin
    Flength := sqrt(FTx * FTx + FTy * FTy);
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

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.NextPoint2C(var px, py, pc1, pc2: double);
var
  i: Integer;
begin
  // first compute the color coord
  pc1 := (pc1 + color) * 0.5 * (1 - symmetry) + symmetry * pc1;
  pc2 := (pc2 + color) * 0.5 * (1 - symmetry) + symmetry * pc2;

  FTx := c00 * px + c10 * py + c20;
  FTy := c01 * px + c11 * py + c21;

  if CalculateAngle then begin
    if (FTx < -EPS) or (FTx > EPS) or (FTy < -EPS) or (FTy > EPS) then
       FAngle := arctan2(FTx, FTy)
    else
       FAngle := 0.0;
  end;

  if CalculateSinCos then begin
    Flength := sqrt(FTx * FTx + FTy * FTy);
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

  Fpx := 0;
  Fpy := 0;

  for i:= 0 to FNrFunctions-1 do
    FFunctionList[i];

  px := FPx;
  py := FPy;
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

  if CalculateAngle then begin
    if (FTx < -EPS) or (FTx > EPS) or (FTy < -EPS) or (FTy > EPS) then
       FAngle := arctan2(FTx, FTy)
    else
       FAngle := 0.0;
  end;

  if CalculateSinCos then begin
    Flength := sqrt(FTx * FTx + FTy * FTy);
    if FLength = 0 then begin
      FSinA := 0;
      FCosA := 0;
    end else begin
      FSinA := FTx/FLength;
      FCosA := FTy/FLength;
    end;
  end;

  Fpx := 0;
  Fpy := 0;

  for i:= 0 to FNrFunctions-1 do
    FFunctionList[i];

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
  FFunctionList[21] := Fan;
  FFunctionList[22] := Rings;
  FFunctionList[23] := Triblob;
  FFunctionList[24] := Daisy;
  FFunctionList[25] := Checkers;
  FFunctionList[26] := CRot;

  //registered
  for i := 0 to High(FRegVariations) do
    FFunctionList[27 + i] := FRegVariations[i].CalcFunction;
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
      Result := Result + varnames(i) + format('="%f" ', [vars[i]]);
  end;
  Result := Result + Format('coefs="%g %g %g %g %g %g" ', [c[0,0], c[0,1], c[1,0], c[1,1], c[2,0], c[2,1]]);
//  Result := Result + Format('post="%g %g %g %g %g %g" ', [p[0,0], p[0,1], p[1,0], p[1,1], p[2,0], p[2,1]]);

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
