unit XForm;

interface

const
  NVARS = 22;
  EPS = 1E-10;

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

type
  TXForm = class
  private
    FNrFunctions: Integer;
    FFunctionList: array[0..NVARS] of TCalcMethod;

    FTx, FTy: double;
    FPx, FPy: double;
    FAngle: double;
    FSinA: double;
    FCosA: double;
    FLength: double;
    CalculateAngle: boolean;
    CalculateLength: boolean;
    CalculateSinCos: boolean;

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
    procedure SawTooth;            // var[21]


  public
    vars: array[0..NVARS - 1] of double; // normalized interp coefs between variations
    c: array[0..2, 0..1] of double;      // the coefs to the affine part of the function
    density: double;                     // prob is this function is chosen. 0 - 1
    color: double;                       // color coord for this function. 0 - 1
    color2: double;                      // Second color coord for this function. 0 - 1
    symmetry: double;
    c00, c01, c10, c11, c20, c21: double;

    varType: integer;

    Orientationtype: integer;

    constructor Create;
    procedure Prepare;

    procedure NextPoint(var px, py, pc: double); overload;
    procedure NextPoint(var CPpoint: TCPpoint); overload;
    procedure NextPoint(var px, py, pz, pc: double); overload;
    procedure NextPointXY(var px, py: double);
    procedure NextPoint2C(var px, py, pc1, pc2: double);

  end;

implementation

uses
  SysUtils, Math;

{ TXForm }

///////////////////////////////////////////////////////////////////////////////
constructor TXForm.Create;
var
  i: Integer;
begin
  density := 0;
  Color := 0;
  Vars[0] := 1;
  for i := 1 to NVARS - 1 do begin
    Vars[i] := 0;
  end;
  c[0, 0] := 1;
  c[0, 1] := 0;
  c[1, 0] := 0;
  c[1, 1] := 1;
  c[2, 0] := 0;
  c[2, 1] := 0;
  Symmetry := 0;
end;


///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Prepare;
begin
  c00 := c[0][0];
  c01 := c[0][1];
  c10 := c[1][0];
  c11 := c[1][1];
  c20 := c[2][0];
  c21 := c[2][1];

  FNrFunctions := 0;

  if (vars[0] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Linear;
    Inc(FNrFunctions);
  end;

  if (vars[1] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Sinusoidal;
    Inc(FNrFunctions);
  end;

  if (vars[2] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Spherical;
    Inc(FNrFunctions);
  end;

  if (vars[3] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Swirl;
    Inc(FNrFunctions);
  end;

  if (vars[4] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Horseshoe;
    Inc(FNrFunctions);
  end;

  if (vars[5] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Polar;
    Inc(FNrFunctions);
  end;

  if (vars[6] <> 0.0) then begin
    FFunctionList[FNrFunctions] := FoldedHandkerchief;
    Inc(FNrFunctions);
  end;

  if (vars[7] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Heart;
    Inc(FNrFunctions);
  end;

  if (vars[8] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Disc;
    Inc(FNrFunctions);
  end;

  if (vars[9] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Spiral;
    Inc(FNrFunctions);
  end;

  if (vars[10] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Hyperbolic;
    Inc(FNrFunctions);
  end;

  if (vars[11] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Square;
    Inc(FNrFunctions);
  end;

  if (vars[12] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Ex;
    Inc(FNrFunctions);
  end;

  if (vars[13] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Julia;
    Inc(FNrFunctions);
  end;

  if (vars[14] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Bent;
    Inc(FNrFunctions);
  end;

  if (vars[15] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Waves;
    Inc(FNrFunctions);
  end;

  if (vars[16] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Fisheye;
    Inc(FNrFunctions);
  end;

  if (vars[17] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Popcorn;
    Inc(FNrFunctions);
  end;

  if (vars[18] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Exponential;
    Inc(FNrFunctions);
  end;

  if (vars[19] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Power;
    Inc(FNrFunctions);
  end;

  if (vars[20] <> 0.0) then begin
    FFunctionList[FNrFunctions] := Cosine;
    Inc(FNrFunctions);
  end;

  if (vars[21] <> 0.0) then begin
    FFunctionList[FNrFunctions] := SawTooth;
    Inc(FNrFunctions);
  end;

  CalculateAngle := (vars[5] <> 0.0) or (vars[6] <> 0.0) or (vars[7] <> 0.0) or (vars[8] <> 0.0) or
                    (vars[12] <> 0.0) or (vars[13] <> 0.0);
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
  r2: double;
begin
  r2 := FTx * FTx + FTy * FTy + 1E-6;
  FPx := FPx + vars[2] * (FTx / r2);
  FPy := FPy + vars[2] * (FTy / r2);
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
begin
  ny := sqrt(FTx * FTx + FTy * FTy) - 1.0;
  FPx := FPx + vars[5] * (FAngle/PI);
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
begin
  nx := FTx * PI;
  ny := FTy * PI;

  r := sqrt(nx * nx + ny * ny);
  FPx := FPx + vars[8] * sin(r) * FAngle / PI;
  FPy := FPy + vars[8] * cos(r) * FAngle / PI;

end;

///////////////////////////////////////////////////////////////////////////////
procedure TXForm.Spiral;
var
  r: double;
begin
//  r := sqrt(FTx * FTx + FTy * FTy) + 1E-6;
  r := Flength + 1E-6;
  FPx := FPx + vars[9] * (FCosA + sin(r)) / r;
  FPy := FPy + vars[9] * (FsinA - cos(r)) / r;
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
  a := FAngle/2 + Trunc(random * 2) * PI;
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
procedure TXForm.SawTooth;
var
  r: double;
//  nx, ny: double;
begin
//  r := sqrt(FTx * FTx + FTy * FTy);
//  r := fmod(r + 1.0, 2.0) - 1.0;
  r := FLength + 1;
  r := r - System.Int(r/2) * 2.0 - 1;

//  nx := cos(FAngle) * r;
//  ny := sin(FAngle) * r;

  FPx := FPx + vars[21] * r * FCosA;
  FPy := FPy + vars[21] * r * FSinA;
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
    FFunctionList[i];

  px := FPx;
  py := FPy;
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
  if CalculateLength then begin
    FLength := sqrt(FTx * FTx + FTy * FTy);
  end;

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
//  if CalculateLength then begin
//    FLength := sqrt(FTx * FTx + FTy * FTy);
//  end;

  Fpx := 0;
  Fpy := 0;

  for i:= 0 to FNrFunctions-1 do
    FFunctionList[i];

  px := FPx;
  py := FPy;
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
end;

end.
