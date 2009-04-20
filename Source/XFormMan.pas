unit XFormMan;

interface

uses
  BaseVariation;

const
  NRLOCVAR = 30;

var
  NumBuiltinVariations: integer;
  NumBuiltinVariables: integer;

function NrVar: integer;
function Varnames(const index: integer): String;
procedure RegisterVariation(Variation: TVariationLoader);
function GetNrRegisteredVariations: integer;
function GetRegisteredVariation(const Index: integer): TVariationLoader;
function GetNrVariableNames: integer;
function GetVariableNameAt(const Index: integer): string;
function GetVariationIndex(const str: string): integer;

implementation

uses
  Classes;

var
  VariationList: TList;
  VariableNames: TStringlist;
  loaderNum : integer;

///////////////////////////////////////////////////////////////////////////////
function NrVar: integer;
begin
  Result := NRLOCVAR + VariationList.Count;
end;

///////////////////////////////////////////////////////////////////////////////
function Varnames(const index: integer): String;
const
  cvarnames: array[0..NRLOCVAR-1] of string = (
    'linear',
    'sinusoidal',
    'spherical',
    'swirl',
    'horseshoe',
    'polar',
    'handkerchief',
    'heart',
    'disc',
    'spiral',
    'hyperbolic',
    'diamond',
    'ex',
    'julia',
    'bent',
    'waves',
    'fisheye',
    'popcorn',
    'exponential',
    'power',
    'cosine',
    'rings',
    'fan',
    'eyefish',
    'bubble',
    'cylinder',
    'noise',
    'blur',
    'gaussian_blur',
    'pre_blur'
    );
begin
  if Index < NRLOCVAR then
    Result := cvarnames[Index]
  else
    Result := TVariationLoader(VariationList[Index - NRLOCVAR]).GetName;
end;

///////////////////////////////////////////////////////////////////////////////
function GetVariationIndex(const str: string): integer;
var
  i: integer;
begin
  i := NRVAR-1;
  while (i >= 0) and (Varnames(i) <> str) do Dec(i);
  Result := i;
end;

///////////////////////////////////////////////////////////////////////////////
procedure RegisterVariation(Variation: TVariationLoader);
var
  i: integer;
  newvars: integer;
begin
  VariationList.Add(Variation);

  newvars := Variation.GetNrVariables;
  if newvars > 0 then begin
    Variation.firstVariableIndex := VariableNames.Count;

    for i := 0 to newvars-1 do
      VariableNames.Add(Variation.GetVariableNameAt(i));
  end
  else
    Variation.firstVariableIndex := -1;
end;

///////////////////////////////////////////////////////////////////////////////
function GetNrRegisteredVariations: integer;
begin
  Result := VariationList.count;
end;

///////////////////////////////////////////////////////////////////////////////
function GetRegisteredVariation(const Index: integer): TVariationLoader;
begin
  Result := TVariationLoader(VariationList[Index]);
end;

///////////////////////////////////////////////////////////////////////////////
function GetNrVariableNames: integer;
begin
  Result := VariableNames.Count;
end;

///////////////////////////////////////////////////////////////////////////////
function GetVariableNameAt(const Index: integer): string;
begin
  Result := VariableNames[Index];
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  VariationList := TList.Create;
  VariableNames := TStringlist.create;

finalization

  VariableNames.Free;

  // The registered variation loaders are owned here, so we must free them.
  for loaderNum := 0 to VariationList.Count-1 do
    TVariationLoader(VariationList[loaderNum]).Free;
  VariationList.Free;
end.
