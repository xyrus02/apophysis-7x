unit Binary;

interface

const

  HIB_BLOCKSIZE         = $10; // 16 bytes
  HIB_MAXOFFSET         = $0F; // HIB_BLOCKSIZE - 1

type

  // low-level binary types
  TBlock = array[0..HIB_MAXOFFSET] of byte;
  TWord  = array[0..1] of byte;
  TDWord = array[0..3] of byte;
  TQWord = array[0..7] of byte;
  THibRawString = array of byte;

// procedures to write blocks at low level
procedure WriteData2(var target: TBlock; data: TWord; pos: integer);
procedure WriteData4(var target: TBlock; data: TDWord; pos: integer);
procedure WriteData8(var target: TBlock; data: TQWord; pos: integer);

// procedures to read blocks at low level
procedure ReadData2(source: TBlock; var data: TWord; pos: integer);
procedure ReadData4(source: TBlock; var data: TDWord; pos: integer);
procedure ReadData8(source: TBlock; var data: TQWord; pos: integer);

// procedures to write typed data to blocks
procedure Int16ToBlock(var target: TBlock; pos: integer; data: SmallInt);
procedure Int32ToBlock(var target: TBlock; pos: integer; data: Integer);
procedure LongWordToBlock(var target: TBlock; pos: integer; data: LongWord);
procedure Int64ToBlock(var target: TBlock; pos: integer; data: Int64);
procedure SingleToBlock(var target: TBlock; pos: integer; data: Single);
procedure DoubleToBlock(var target: TBlock; pos: integer; data: Double);

// procedures to read typed data from blocks
function BlockToInt16(source: TBlock; pos: integer): SmallInt;
function BlockToInt32(source: TBlock; pos: integer): Integer;
function BlockToLongWord(source: TBlock; pos: integer): LongWord;
function BlockToInt64(source: TBlock; pos: integer): Int64;
function BlockToSingle(source: TBlock; pos: integer): Single;
function BlockToDouble(source: TBlock; pos: integer): Double;

implementation

procedure ReadData2(source: TBlock; var data: TWord; pos: integer);
const size = 2;
var i: integer;
begin
  for i := 0 to size - 1 do
  if i + pos < HIB_BLOCKSIZE then
  data[i] := source[i + pos];
end;
procedure ReadData4(source: TBlock; var data: TDWord; pos: integer);
const size = 4;
var i: integer;
begin
  for i := 0 to size - 1 do
  if i + pos < HIB_BLOCKSIZE then
  data[i] := source[i + pos];
end;
procedure ReadData8(source: TBlock; var data: TQWord; pos: integer);
const size = 8;
var i: integer;
begin
  for i := 0 to size - 1 do
  if i + pos < HIB_BLOCKSIZE then
  data[i] := source[i + pos];
end;

procedure WriteData2(var target: TBlock; data: TWord; pos: integer);
const size = 2;
var i: integer;
begin
  for i := 0 to size - 1 do
  if i + pos < HIB_BLOCKSIZE then
  target[i + pos] := data[i];
end;
procedure WriteData4(var target: TBlock; data: TDWord; pos: integer);
const size = 4;
var i: integer;
begin
  for i := 0 to size - 1 do
  if i + pos < HIB_BLOCKSIZE then
  target[i + pos] := data[i];
end;
procedure WriteData8(var target: TBlock; data: TQWord; pos: integer);
const size = 8;
var i: integer;
begin
  for i := 0 to size - 1 do
  if i + pos < HIB_BLOCKSIZE then
  target[i + pos] := data[i];
end;

function BlockToInt16(source: TBlock; pos: integer): SmallInt;
var temp: TWord; data: SmallInt;
begin
  ReadData2(source, temp, pos);
  Move(temp, data, SizeOf(TWord));
  Result := data;
end;
function BlockToInt32(source: TBlock; pos: integer): Integer;
var temp: TDWord; data: Integer;
begin
  ReadData4(source, temp, pos);
  Move(temp, data, SizeOf(TDWord));
  Result := data;
end;
function BlockToLongWord(source: TBlock; pos: integer): LongWord;
var temp: TDWord; data: LongWord;
begin
  ReadData4(source, temp, pos);
  Move(temp, data, SizeOf(TDWord));
  Result := data;
end;
function BlockToInt64(source: TBlock; pos: integer): Int64;
var temp: TQWord; data: Int64;
begin
  ReadData8(source, temp, pos);
  Move(temp, data, SizeOf(TQWord));
  Result := data;
end;
function BlockToSingle(source: TBlock; pos: integer): Single;
var temp: TDWord; data: Single;
begin
  ReadData4(source, temp, pos);
  Move(temp, data, SizeOf(TDWord));
  Result := data;
end;
function BlockToDouble(source: TBlock; pos: integer): Double;
var temp: TQWord; data: Double;
begin
  ReadData8(source, temp, pos);
  Move(temp, data, SizeOf(TQWord));
  Result := data;
end;

procedure Int16ToBlock(var target: TBlock; pos: integer; data: SmallInt);
var temp: TWord;
begin
  Move(data, temp, SizeOf(TWord));
  WriteData2(target, temp, pos);
end;
procedure Int32ToBlock(var target: TBlock; pos: integer; data: Integer);
var temp: TDWord;
begin
  Move(data, temp, SizeOf(TDWord));
  WriteData4(target, temp, pos);
end;
procedure LongWordToBlock(var target: TBlock; pos: integer; data: LongWord);
var temp: TDWord;
begin
  Move(data, temp, SizeOf(TDWord));
  WriteData4(target, temp, pos);
end;
procedure Int64ToBlock(var target: TBlock; pos: integer; data: Int64);
var temp: TQWord;
begin
  Move(data, temp, SizeOf(TQWord));
  WriteData8(target, temp, pos);
end;
procedure SingleToBlock(var target: TBlock; pos: integer; data: single);
var temp: TDWord;
begin
  Move(data, temp, SizeOf(TDWord));
  WriteData4(target, temp, pos);
end;
procedure DoubleToBlock(var target: TBlock; pos: integer; data: double);
var temp: TQWord;
begin
  Move(data, temp, SizeOf(TQWord));
  WriteData8(target, temp, pos);
end;

end.
