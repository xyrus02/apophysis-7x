{***************************************************************************}
{ This source code was generated automatically by                           }
{ Pas file import tool for Scripter Studio                                  }
{                                                                           }
{ Scripter Studio and Pas file import tool for Scripter Studio              }
{ written by Automa / TMS Software                                          }
{            copyright © 1997 - 2003                                        }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{***************************************************************************}
unit ap_Math;

interface

uses
  SysUtils,
  Types,
  Math,
  Variants,
  atScript;

type
  TatMathLibrary = class(TatScripterLibrary)
    procedure __ArcCos(AMachine: TatVirtualMachine);
    procedure __ArcSin(AMachine: TatVirtualMachine);
    procedure __ArcTan2(AMachine: TatVirtualMachine);
    procedure __SinCos(AMachine: TatVirtualMachine);
    procedure __Tan(AMachine: TatVirtualMachine);
    procedure __Cotan(AMachine: TatVirtualMachine);
    procedure __Secant(AMachine: TatVirtualMachine);
    procedure __Cosecant(AMachine: TatVirtualMachine);
    procedure __Hypot(AMachine: TatVirtualMachine);
    procedure __RadToDeg(AMachine: TatVirtualMachine);
    procedure __RadToGrad(AMachine: TatVirtualMachine);
    procedure __RadToCycle(AMachine: TatVirtualMachine);
    procedure __DegToRad(AMachine: TatVirtualMachine);
    procedure __DegToGrad(AMachine: TatVirtualMachine);
    procedure __DegToCycle(AMachine: TatVirtualMachine);
    procedure __GradToRad(AMachine: TatVirtualMachine);
    procedure __GradToDeg(AMachine: TatVirtualMachine);
    procedure __GradToCycle(AMachine: TatVirtualMachine);
    procedure __CycleToRad(AMachine: TatVirtualMachine);
    procedure __CycleToDeg(AMachine: TatVirtualMachine);
    procedure __CycleToGrad(AMachine: TatVirtualMachine);
    procedure __Cot(AMachine: TatVirtualMachine);
    procedure __Sec(AMachine: TatVirtualMachine);
    procedure __Csc(AMachine: TatVirtualMachine);
    procedure __Cosh(AMachine: TatVirtualMachine);
    procedure __Sinh(AMachine: TatVirtualMachine);
    procedure __Tanh(AMachine: TatVirtualMachine);
    procedure __CotH(AMachine: TatVirtualMachine);
    procedure __SecH(AMachine: TatVirtualMachine);
    procedure __CscH(AMachine: TatVirtualMachine);
    procedure __ArcCot(AMachine: TatVirtualMachine);
    procedure __ArcSec(AMachine: TatVirtualMachine);
    procedure __ArcCsc(AMachine: TatVirtualMachine);
    procedure __ArcCosh(AMachine: TatVirtualMachine);
    procedure __ArcSinh(AMachine: TatVirtualMachine);
    procedure __ArcTanh(AMachine: TatVirtualMachine);
    procedure __ArcCotH(AMachine: TatVirtualMachine);
    procedure __ArcSecH(AMachine: TatVirtualMachine);
    procedure __ArcCscH(AMachine: TatVirtualMachine);
    procedure __LnXP1(AMachine: TatVirtualMachine);
    procedure __Log10(AMachine: TatVirtualMachine);
    procedure __Log2(AMachine: TatVirtualMachine);
    procedure __LogN(AMachine: TatVirtualMachine);
    procedure __IntPower(AMachine: TatVirtualMachine);
    procedure __Power(AMachine: TatVirtualMachine);
    procedure __Frexp(AMachine: TatVirtualMachine);
    procedure __Ldexp(AMachine: TatVirtualMachine);
    procedure __Ceil(AMachine: TatVirtualMachine);
    procedure __Floor(AMachine: TatVirtualMachine);
    procedure __RandG(AMachine: TatVirtualMachine);
    procedure __IsNan(AMachine: TatVirtualMachine);
    procedure __IsInfinite(AMachine: TatVirtualMachine);
    procedure __RandomRange(AMachine: TatVirtualMachine);
    procedure __DivMod(AMachine: TatVirtualMachine);
    procedure __RoundTo(AMachine: TatVirtualMachine);
    procedure __SimpleRoundTo(AMachine: TatVirtualMachine);
    procedure __DoubleDecliningBalance(AMachine: TatVirtualMachine);
    procedure __FutureValue(AMachine: TatVirtualMachine);
    procedure __InterestPayment(AMachine: TatVirtualMachine);
    procedure __InterestRate(AMachine: TatVirtualMachine);
    procedure __NumberOfPeriods(AMachine: TatVirtualMachine);
    procedure __Payment(AMachine: TatVirtualMachine);
    procedure __PeriodPayment(AMachine: TatVirtualMachine);
    procedure __PresentValue(AMachine: TatVirtualMachine);
    procedure __SLNDepreciation(AMachine: TatVirtualMachine);
    procedure __SYDDepreciation(AMachine: TatVirtualMachine);
    procedure __GetRoundMode(AMachine: TatVirtualMachine);
    procedure __SetRoundMode(AMachine: TatVirtualMachine);
    procedure __GetPrecisionMode(AMachine: TatVirtualMachine);
    procedure __SetPrecisionMode(AMachine: TatVirtualMachine);
    procedure __GetExceptionMask(AMachine: TatVirtualMachine);
    procedure __SetExceptionMask(AMachine: TatVirtualMachine);
    procedure __ClearExceptions(AMachine: TatVirtualMachine);
    procedure Init; override;
    class function LibraryName: string; override;
  end;

  EInvalidArgumentClass = class of EInvalidArgument;



implementation

{$WARNINGS OFF}



procedure TatMathLibrary.__ArcCos(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.ArcCos(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__ArcSin(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.ArcSin(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__ArcTan2(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.ArcTan2(GetInputArg(0),GetInputArg(1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__SinCos(AMachine: TatVirtualMachine);
  var
  Param1: Extended;
  Param2: Extended;
begin
  with AMachine do
  begin
Param1 := GetInputArg(1);
Param2 := GetInputArg(2);
    Math.SinCos(GetInputArg(0),Param1,Param2);
    SetInputArg(1,Param1);
    SetInputArg(2,Param2);
  end;
end;

procedure TatMathLibrary.__Tan(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.Tan(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__Cotan(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.Cotan(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__Secant(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.Secant(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__Cosecant(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.Cosecant(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__Hypot(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.Hypot(GetInputArg(0),GetInputArg(1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__RadToDeg(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.RadToDeg(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__RadToGrad(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.RadToGrad(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__RadToCycle(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.RadToCycle(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__DegToRad(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.DegToRad(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__DegToGrad(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.DegToGrad(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__DegToCycle(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.DegToCycle(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__GradToRad(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.GradToRad(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__GradToDeg(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.GradToDeg(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__GradToCycle(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.GradToCycle(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__CycleToRad(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.CycleToRad(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__CycleToDeg(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.CycleToDeg(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__CycleToGrad(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.CycleToGrad(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__Cot(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.Cot(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__Sec(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.Sec(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__Csc(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.Csc(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__Cosh(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.Cosh(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__Sinh(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.Sinh(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__Tanh(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.Tanh(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__CotH(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.CotH(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__SecH(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.SecH(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__CscH(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.CscH(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__ArcCot(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.ArcCot(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__ArcSec(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.ArcSec(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__ArcCsc(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.ArcCsc(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__ArcCosh(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.ArcCosh(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__ArcSinh(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.ArcSinh(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__ArcTanh(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.ArcTanh(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__ArcCotH(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.ArcCotH(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__ArcSecH(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.ArcSecH(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__ArcCscH(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.ArcCscH(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__LnXP1(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.LnXP1(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__Log10(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.Log10(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__Log2(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.Log2(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__LogN(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.LogN(GetInputArg(0),GetInputArg(1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__IntPower(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.IntPower(GetInputArg(0),VarToInteger(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__Power(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.Power(GetInputArg(0),GetInputArg(1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__Frexp(AMachine: TatVirtualMachine);
  var
  Param1: Extended;
  Param2: Integer;
begin
  with AMachine do
  begin
Param1 := GetInputArg(1);
Param2 := VarToInteger(GetInputArg(2));
    Math.Frexp(GetInputArg(0),Param1,Param2);
    SetInputArg(1,Param1);
    SetInputArg(2,Integer(Param2));
  end;
end;

procedure TatMathLibrary.__Ldexp(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.Ldexp(GetInputArg(0),VarToInteger(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__Ceil(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(Math.Ceil(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__Floor(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(Math.Floor(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__RandG(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.RandG(GetInputArg(0),GetInputArg(1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__IsNan(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.IsNan(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__IsInfinite(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.IsInfinite(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__RandomRange(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(Math.RandomRange(VarToInteger(GetInputArg(0)),VarToInteger(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__DivMod(AMachine: TatVirtualMachine);
  var
  Param2: Word;
  Param3: Word;
begin
  with AMachine do
  begin
Param2 := VarToInteger(GetInputArg(2));
Param3 := VarToInteger(GetInputArg(3));
    Math.DivMod(VarToInteger(GetInputArg(0)),VarToInteger(GetInputArg(1)),Param2,Param3);
    SetInputArg(2,Integer(Param2));
    SetInputArg(3,Integer(Param3));
  end;
end;

procedure TatMathLibrary.__RoundTo(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.RoundTo(GetInputArg(0),GetInputArg(1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__SimpleRoundTo(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.SimpleRoundTo(GetInputArg(0),GetInputArg(1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__DoubleDecliningBalance(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.DoubleDecliningBalance(GetInputArg(0),GetInputArg(1),VarToInteger(GetInputArg(2)),VarToInteger(GetInputArg(3)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__FutureValue(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.FutureValue(GetInputArg(0),VarToInteger(GetInputArg(1)),GetInputArg(2),GetInputArg(3),GetInputArg(4));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__InterestPayment(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.InterestPayment(GetInputArg(0),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),GetInputArg(3),GetInputArg(4),GetInputArg(5));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__InterestRate(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.InterestRate(VarToInteger(GetInputArg(0)),GetInputArg(1),GetInputArg(2),GetInputArg(3),GetInputArg(4));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__NumberOfPeriods(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.NumberOfPeriods(GetInputArg(0),GetInputArg(1),GetInputArg(2),GetInputArg(3),GetInputArg(4));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__Payment(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.Payment(GetInputArg(0),VarToInteger(GetInputArg(1)),GetInputArg(2),GetInputArg(3),GetInputArg(4));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__PeriodPayment(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.PeriodPayment(GetInputArg(0),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),GetInputArg(3),GetInputArg(4),GetInputArg(5));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__PresentValue(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.PresentValue(GetInputArg(0),VarToInteger(GetInputArg(1)),GetInputArg(2),GetInputArg(3),GetInputArg(4));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__SLNDepreciation(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.SLNDepreciation(GetInputArg(0),GetInputArg(1),VarToInteger(GetInputArg(2)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__SYDDepreciation(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.SYDDepreciation(GetInputArg(0),GetInputArg(1),VarToInteger(GetInputArg(2)),VarToInteger(GetInputArg(3)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__GetRoundMode(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.GetRoundMode;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__SetRoundMode(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.SetRoundMode(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__GetPrecisionMode(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.GetPrecisionMode;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__SetPrecisionMode(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Math.SetPrecisionMode(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__GetExceptionMask(AMachine: TatVirtualMachine);
  var
  AResultSet: TFPUExceptionMask;
  AResult: variant;
begin
  with AMachine do
  begin
AResultSet := Math.GetExceptionMask;
AResult := IntFromSet(AResultSet);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__SetExceptionMask(AMachine: TatVirtualMachine);
  var
  Param0: TFPUExceptionMask;
  AResultSet: TFPUExceptionMask;
  AResult: variant;
begin
  with AMachine do
  begin
IntToSet(Param0,VarToInteger(GetInputArg(0)));
AResultSet := Math.SetExceptionMask(Param0);
AResult := IntFromSet(AResultSet);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatMathLibrary.__ClearExceptions(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Math.ClearExceptions;
  end;
end;

procedure TatMathLibrary.Init;
begin
  With Scripter.DefineClass(EInvalidArgument) do
  begin
  end;
  With Scripter.DefineClass(ClassType) do
  begin
    DefineMethod('ArcCos',1,tkVariant,nil,__ArcCos,false);
    DefineMethod('ArcSin',1,tkVariant,nil,__ArcSin,false);
    DefineMethod('ArcTan2',2,tkVariant,nil,__ArcTan2,false);
    DefineMethod('SinCos',3,tkNone,nil,__SinCos,false).SetVarArgs([1,2]);
    DefineMethod('Tan',1,tkVariant,nil,__Tan,false);
    DefineMethod('Cotan',1,tkVariant,nil,__Cotan,false);
    DefineMethod('Secant',1,tkVariant,nil,__Secant,false);
    DefineMethod('Cosecant',1,tkVariant,nil,__Cosecant,false);
    DefineMethod('Hypot',2,tkVariant,nil,__Hypot,false);
    DefineMethod('RadToDeg',1,tkVariant,nil,__RadToDeg,false);
    DefineMethod('RadToGrad',1,tkVariant,nil,__RadToGrad,false);
    DefineMethod('RadToCycle',1,tkVariant,nil,__RadToCycle,false);
    DefineMethod('DegToRad',1,tkVariant,nil,__DegToRad,false);
    DefineMethod('DegToGrad',1,tkVariant,nil,__DegToGrad,false);
    DefineMethod('DegToCycle',1,tkVariant,nil,__DegToCycle,false);
    DefineMethod('GradToRad',1,tkVariant,nil,__GradToRad,false);
    DefineMethod('GradToDeg',1,tkVariant,nil,__GradToDeg,false);
    DefineMethod('GradToCycle',1,tkVariant,nil,__GradToCycle,false);
    DefineMethod('CycleToRad',1,tkVariant,nil,__CycleToRad,false);
    DefineMethod('CycleToDeg',1,tkVariant,nil,__CycleToDeg,false);
    DefineMethod('CycleToGrad',1,tkVariant,nil,__CycleToGrad,false);
    DefineMethod('Cot',1,tkVariant,nil,__Cot,false);
    DefineMethod('Sec',1,tkVariant,nil,__Sec,false);
    DefineMethod('Csc',1,tkVariant,nil,__Csc,false);
    DefineMethod('Cosh',1,tkVariant,nil,__Cosh,false);
    DefineMethod('Sinh',1,tkVariant,nil,__Sinh,false);
    DefineMethod('Tanh',1,tkVariant,nil,__Tanh,false);
    DefineMethod('CotH',1,tkVariant,nil,__CotH,false);
    DefineMethod('SecH',1,tkVariant,nil,__SecH,false);
    DefineMethod('CscH',1,tkVariant,nil,__CscH,false);
    DefineMethod('ArcCot',1,tkVariant,nil,__ArcCot,false);
    DefineMethod('ArcSec',1,tkVariant,nil,__ArcSec,false);
    DefineMethod('ArcCsc',1,tkVariant,nil,__ArcCsc,false);
    DefineMethod('ArcCosh',1,tkVariant,nil,__ArcCosh,false);
    DefineMethod('ArcSinh',1,tkVariant,nil,__ArcSinh,false);
    DefineMethod('ArcTanh',1,tkVariant,nil,__ArcTanh,false);
    DefineMethod('ArcCotH',1,tkVariant,nil,__ArcCotH,false);
    DefineMethod('ArcSecH',1,tkVariant,nil,__ArcSecH,false);
    DefineMethod('ArcCscH',1,tkVariant,nil,__ArcCscH,false);
    DefineMethod('LnXP1',1,tkVariant,nil,__LnXP1,false);
    DefineMethod('Log10',1,tkVariant,nil,__Log10,false);
    DefineMethod('Log2',1,tkVariant,nil,__Log2,false);
    DefineMethod('LogN',2,tkVariant,nil,__LogN,false);
    DefineMethod('IntPower',2,tkVariant,nil,__IntPower,false);
    DefineMethod('Power',2,tkVariant,nil,__Power,false);
    DefineMethod('Frexp',3,tkNone,nil,__Frexp,false).SetVarArgs([1,2]);
    DefineMethod('Ldexp',2,tkVariant,nil,__Ldexp,false);
    DefineMethod('Ceil',1,tkInteger,nil,__Ceil,false);
    DefineMethod('Floor',1,tkInteger,nil,__Floor,false);
    DefineMethod('RandG',2,tkVariant,nil,__RandG,false);
    DefineMethod('IsNan',1,tkVariant,nil,__IsNan,false);
    DefineMethod('IsInfinite',1,tkVariant,nil,__IsInfinite,false);
    DefineMethod('RandomRange',2,tkInteger,nil,__RandomRange,false);
    DefineMethod('DivMod',4,tkNone,nil,__DivMod,false).SetVarArgs([2,3]);
    DefineMethod('RoundTo',2,tkVariant,nil,__RoundTo,false);
    DefineMethod('SimpleRoundTo',2,tkVariant,nil,__SimpleRoundTo,false);
    DefineMethod('DoubleDecliningBalance',4,tkVariant,nil,__DoubleDecliningBalance,false);
    DefineMethod('FutureValue',5,tkVariant,nil,__FutureValue,false);
    DefineMethod('InterestPayment',6,tkVariant,nil,__InterestPayment,false);
    DefineMethod('InterestRate',5,tkVariant,nil,__InterestRate,false);
    DefineMethod('NumberOfPeriods',5,tkVariant,nil,__NumberOfPeriods,false);
    DefineMethod('Payment',5,tkVariant,nil,__Payment,false);
    DefineMethod('PeriodPayment',6,tkVariant,nil,__PeriodPayment,false);
    DefineMethod('PresentValue',5,tkVariant,nil,__PresentValue,false);
    DefineMethod('SLNDepreciation',3,tkVariant,nil,__SLNDepreciation,false);
    DefineMethod('SYDDepreciation',4,tkVariant,nil,__SYDDepreciation,false);
    DefineMethod('GetRoundMode',0,tkEnumeration,nil,__GetRoundMode,false);
    DefineMethod('SetRoundMode',1,tkEnumeration,nil,__SetRoundMode,false);
    DefineMethod('GetPrecisionMode',0,tkEnumeration,nil,__GetPrecisionMode,false);
    DefineMethod('SetPrecisionMode',1,tkEnumeration,nil,__SetPrecisionMode,false);
    DefineMethod('GetExceptionMask',0,tkInteger,nil,__GetExceptionMask,false);
    DefineMethod('SetExceptionMask',1,tkInteger,nil,__SetExceptionMask,false);
    DefineMethod('ClearExceptions',0,tkNone,nil,__ClearExceptions,false);
    AddConstant('ptEndOfPeriod',ptEndOfPeriod);
    AddConstant('ptStartOfPeriod',ptStartOfPeriod);
    AddConstant('rmNearest',rmNearest);
    AddConstant('rmDown',rmDown);
    AddConstant('rmUp',rmUp);
    AddConstant('rmTruncate',rmTruncate);
    AddConstant('pmSingle',pmSingle);
    AddConstant('pmReserved',pmReserved);
    AddConstant('pmDouble',pmDouble);
    AddConstant('pmExtended',pmExtended);
    AddConstant('exInvalidOp',exInvalidOp);
    AddConstant('exDenormalized',exDenormalized);
    AddConstant('exZeroDivide',exZeroDivide);
    AddConstant('exOverflow',exOverflow);
    AddConstant('exUnderflow',exUnderflow);
    AddConstant('exPrecision',exPrecision);
    AddConstant('MinSingle',MinSingle);
    AddConstant('MaxSingle',MaxSingle);
    AddConstant('MinDouble',MinDouble);
    AddConstant('MaxDouble',MaxDouble);
    AddConstant('NaN',NaN);
    AddConstant('Infinity',Infinity);
    AddConstant('NegInfinity',NegInfinity);
    AddConstant('NegativeValue',NegativeValue);
    AddConstant('ZeroValue',ZeroValue);
    AddConstant('PositiveValue',PositiveValue);
  end;
end;

class function TatMathLibrary.LibraryName: string;
begin
  result := 'Math';
end;

initialization
  RegisterScripterLibrary(TatMathLibrary, True);

{$WARNINGS ON}

end.
