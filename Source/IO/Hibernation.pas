unit Hibernation;

interface

uses RenderingCommon, RenderingInterface, SysUtils, Windows, Forms, Classes, Binary, ControlPoint;

const
  HIB_VERSION_MAJOR     = 2;   // Apophysis7X.15
  HIB_VERSION_MINOR     = 10;
  HIB_VERSION_REVISION  = 1500;

  HIB_ADDR_HEADER       = $30; // 48 bytes
  HIB_SIZE_HEADER       = $30; // 48 bytes
  HIB_ADDR_LOCATOR      = $60; // HIB_SIZE_HEADER + HIB_ADDR_HEADER
  HIB_SIZE_LOCATOR      = $20; // 32 bytes

  HIB_COOKIE_INTRO_HIGH = $AB; // A B0F
  HIB_COOKIE_INTRO_LOW  = $0F;
  HIB_COOKIE_OUTRO_HIGH = $AE; // A E0F
  HIB_COOKIE_OUTRO_LOW  = $0F;

type
  EHibBitsPerPixel = (
    EBP_32 = 32,
    EBP_64 = 64                // 64 bit renderer; probably used later
  );
  EHibPixelLayout = (
    EPL_XYZW = 0123,
    EPL_YXZW = 1023,           // indicates different subpixel orders;
    EPL_YZXW = 1203,           // for example, metaphysis uses WXYZ (3012)
    EPL_YZWX = 1230,
    EPL_XZYW = 0213,
    EPL_XZWY = 0231,
    EPL_XYWZ = 0132,
    EPL_ZXYW = 2013,
    EPL_WXYZ = 3012,
    EPL_XWYZ = 0312
  );
  EHibFileFlags = (
    EFF_NONE = 0,              // no flags (default)
    EFF_FLOATBUFFER = 1,       // using a float buffer (32/64bit)
    EFF_SEPARATEFLAME = 2,     // flame stored in separate file (unused yet)
    EFF_BINARYFLAME = 4,       // flame stored in binary format (unused yet)
    EFF_COMPRESSED = 8         // data is GZIP-compressed (unused yet)
  );

  // some types for the header (some unused)
  THibInt2_32 = record X, Y : integer; end;
  THibInt2_64 = record X, Y : int64; end;
  THibFloat2 = record X, Y : double; end;
  THibFloat4 = record X, Y, Z, W : double; end;
  THibBoolean = (HB_YES = -1, HB_NO = 0);

  // the actual header
  THibHeader = record
    ActualDensity : double;
    Size2D : THibInt2_64;
    Size : int64;
    RenderTime : TDateTime;
    PauseTime : TDateTime;
  end;

// file allocation and release procedures
procedure HibAllocate(var handle: File; path: string);
procedure HibOpen(var handle: File; path: string);
procedure HibFree(const handle: File);

// high-level write procedures
procedure HibWriteIntro(const handle: File);
procedure HibWriteOutro(const handle: File);
procedure HibWriteGlobals(const handle: File; flags: EHibFileFlags;
  layout: EHibPixelLayout; bpp: EHibBitsPerPixel);
procedure HibWriteHeader(const handle: File; header: THibHeader);
procedure HibWriteData(const handle: File; header: THibHeader;
  flame: TControlPoint; buckets: TBucket32Array;
  colormap: TColorMapArray; callback: TOnProgress);

// high-level read procedures
procedure HibReadIntro(const handle: File; var cookieValid: boolean);
procedure HibReadOutro(const handle: File; var cookieValid: boolean);
procedure HibReadGlobals(const handle: File; var versionRel: smallint;
  var flags: EHibFileFlags; var layout: EHibPixelLayout; var bpp: EHibBitsPerPixel);
procedure HibReadHeader(const handle: File; var header: THibHeader);
procedure HibReadData(const handle: File; header: THibHeader; var flame: TStringList;
  var buckets: TBucket32Array; var colormap: TColorMapArray; callback: TOnProgress);

implementation

////////////////////////////////////////////////////////////////////////////////

procedure HibAllocate(var handle: File; path: string);
begin
  AssignFile(handle, path);
  ReWrite(handle, HIB_BLOCKSIZE);
end;

procedure HibOpen(var handle: File; path: string);
begin
  AssignFile(handle, path);
  FileMode := fmOpenRead;
  Reset(handle, HIB_BLOCKSIZE);
end;

procedure HibFree(const handle: File);
begin
  CloseFile(handle);
end;

////////////////////////////////////////////////////////////////////////////////

procedure HibWriteIntro(const handle: File);
var
  block: TBlock;
  chunk: string;
begin
  block[0] := HIB_COOKIE_INTRO_HIGH;
  block[1] := HIB_COOKIE_INTRO_LOW;
  chunk := 'Apophysis7X Hi';
  CopyMemory(@block[2], @chunk[1], Length(chunk));
  BlockWrite(handle, block, 1);
  chunk := 'bernation File';
  block[14] := $0; block[15] := $0;
  CopyMemory(@block[0], @chunk[1], Length(chunk));
  BlockWrite(handle, block, 1);
end;

procedure HibWriteOutro(const handle: File);
var
  block: TBlock;
begin
  block[0] := $0; block[1] := $0; block[2] := $0; block[3] := $0;
  block[4] := $0; block[5] := $0; block[6] := $0; block[7] := $0;
  block[8] := $0; block[9] := $0; block[10] := $0; block[11] := $0;
  block[12] := $0; block[13] := $0;
  block[14] := HIB_COOKIE_OUTRO_HIGH;
  block[15] := HIB_COOKIE_OUTRO_LOW;
  BlockWrite(handle, block, 1);
end;

procedure HibWriteGlobals(const handle: File; flags: EHibFileFlags;
  layout: EHibPixelLayout; bpp: EHibBitsPerPixel);
var
  block: TBlock;
begin
  Int16ToBlock(block, 0, HIB_VERSION_MAJOR);
  Int16ToBlock(block, 2, HIB_VERSION_MINOR);
  Int32ToBlock(block, 4, HIB_VERSION_REVISION);
  Int16ToBlock(block, 8, SmallInt(flags));
  Int16ToBlock(block, 10, HIB_SIZE_HEADER);
  Int16ToBlock(block, 12, SmallInt(layout));
  Int16ToBlock(block, 14, SmallInt(bpp));
  BlockWrite(handle, block, 1);
end;

procedure HibWriteHeader(const handle: File; header: THibHeader);
var
  block: TBlock;
begin
  DoubleToBlock(block, 0, header.ActualDensity);
  Int64ToBlock(block, 8, header.Size);
  BlockWrite(handle, block, 1);

  Int64ToBlock(block, 0, header.Size2D.X);
  Int64ToBlock(block, 8, header.Size2D.Y);
  BlockWrite(handle, block, 1);

  Int64ToBlock(block, 0,
    Int64(((Trunc(header.RenderTime) - 25569) * 86400) +
    Trunc(86400 * (header.RenderTime -
    Trunc(header.RenderTime))) - 7200));
  Int64ToBlock(block, 8,
    Int64(((Trunc(header.PauseTime) - 25569) * 86400) +
    Trunc(86400 * (header.PauseTime -
    Trunc(header.PauseTime))) - 7200));
  BlockWrite(handle, block, 1);
end;

procedure HibWriteData(const handle: File; header: THibHeader; flame: TControlPoint;
  buckets: TBucket32Array; colormap: TColorMapArray; callback: TOnProgress);
var
  block: TBlock;
  flametext: string;
  rawflame: THibRawString;
  rawflamesize: integer;
  rawflamechunks: integer;
  i, j, c: integer;
  p, step: double;
begin
  rawflamesize := CalcBinaryFlameSize(flame);

  Int64ToBlock(block, 0, HIB_ADDR_LOCATOR + HIB_SIZE_LOCATOR);
  Int64ToBlock(block, 8, Int64(rawflamesize) );
  BlockWrite(handle, block, 1);

  Int64ToBlock(block, 0, HIB_ADDR_LOCATOR + HIB_SIZE_LOCATOR + rawflamesize);
  Int64ToBlock(block, 8, 16 * header.Size2D.X * header.Size2D.Y);
  BlockWrite(handle, block, 1);

  flame.SaveToBinary(handle);

  callback(0);
  c := 0; p := 0;
  step := 1.0 / (header.Size2D.X * header.Size2D.Y);
  for j := 0 to header.Size2D.Y - 1 do
    for i := 0 to header.Size2D.X - 1 do
      with buckets[j][i] do begin
        Int32ToBlock(block, 0, Red);
        Int32ToBlock(block, 4, Green);
        Int32ToBlock(block, 8, Blue);
        Int32ToBlock(block, 12, Count);
        BlockWrite(handle, block, 1);
        p := p + step;
        c := (c + 1) mod 64;
        if (c = 0) then begin
          callback(p*0.99);
          Application.ProcessMessages;
        end;
      end;
  callback(0.99);

  i := 0;
  while i < 256 do begin
    Int32ToBlock(block, 0,
      (colormap[i+0].Red) or
      (((colormap[i+0].Green) and $ff) shl 8) or
      (((colormap[i+0].Blue) and $ff) shl 16));
    Int32ToBlock(block, 4,
      (colormap[i+1].Red) or
      (((colormap[i+1].Green) and $ff) shl 8) or
      (((colormap[i+1].Blue) and $ff) shl 16));
    Int32ToBlock(block, 8,
      (colormap[i+2].Red) or
      (((colormap[i+2].Green) and $ff) shl 8) or
      (((colormap[i+2].Blue) and $ff) shl 16));
    Int32ToBlock(block, 12,
      (colormap[i+3].Red) or
      (((colormap[i+3].Green) and $ff) shl 8) or
      (((colormap[i+3].Blue) and $ff) shl 16));
    BlockWrite(handle, block, 1);
    i := i + 4;
  end;
  callback(1);
end;

////////////////////////////////////////////////////////////////////////////////

procedure HibReadIntro(const handle: File; var cookieValid: boolean);
var
  block1, block2: TBlock;
begin
  BlockRead(handle, block1, 1);
  BlockRead(handle, block2, 1);
  cookieValid :=
    (block1[0] = HIB_COOKIE_INTRO_HIGH) and
    (block1[1] = HIB_COOKIE_INTRO_LOW);
end;
procedure HibReadOutro(const handle: File; var cookieValid: boolean);
var
  block1, block2: TBlock;
begin
  BlockRead(handle, block1, 1);
  BlockRead(handle, block2, 1);
  cookieValid :=
    (block2[14] = HIB_COOKIE_OUTRO_HIGH) and
    (block2[15] = HIB_COOKIE_OUTRO_LOW);
end;
procedure HibReadGlobals(const handle: File; var versionRel: SmallInt;
  var flags: EHibFileFlags; var layout: EHibPixelLayout; var bpp: EHibBitsPerPixel);
var
  block: TBlock;
  major, minor, rev: Integer;
begin
  BlockRead(handle, block, 1);
  major := BlockToInt16(block, 0);
  minor := BlockToInt16(block, 2);
  rev := BlockToInt32(block, 4);
  flags := EHibFileFlags(BlockToInt16(block, 8));
  assert(BlockToInt16(block, 10) <> HIB_SIZE_HEADER, 'Invalid header size');
  layout := EHibPixelLayout(BlockToInt16(block, 12));
  bpp := EHibBitsPerPixel(BlockToInt16(block, 14));

  if major < HIB_VERSION_MAJOR then versionRel := -1
  else if major > HIB_VERSION_MAJOR then versionRel := 1
  else begin
    if minor < HIB_VERSION_MINOR then versionRel := -1
    else if minor > HIB_VERSION_MINOR then versionRel := 1
    else begin
      if rev < HIB_VERSION_REVISION then versionRel := -1
      else if rev > HIB_VERSION_REVISION then versionRel := 1
      else versionRel := 0;
    end;
  end;
end;
procedure HibReadHeader(const handle: File; var header: THibHeader);
var
  block: TBlock;
begin
  BlockRead(handle, block, 1);
  header.ActualDensity := BlockToDouble(block, 0);
  header.Size := BlockToInt64(block, 8);

  BlockRead(handle, block, 1);
  header.Size2D.X := BlockToInt64(block, 0);
  header.Size2D.Y := BlockToInt64(block, 8);

  BlockRead(handle, block, 1);
  header.RenderTime := ((BlockToInt64(block, 0) + 7200) / 86500) + 25569;
  header.PauseTime := ((BlockToInt64(block, 8) + 7200) / 86500) + 25569;
end;
procedure HibReadData(const handle: File; header: THibHeader; var flame: TStringList;
  var buckets: TBucket32Array; var colormap: TColorMapArray; callback: TOnProgress);
var
  block: TBlock;
  pos, offsf, sizef, offsd, sized : Int64;
  fbytes: THibRawString;
  i, c, bx, by: Integer;
  p, step: Double;
begin
  BlockRead(handle, block, 1);
  offsf := BlockToInt64(block, 0);
  sizef := BlockToInt64(block, 8);

  BlockRead(handle, block, 1);
  offsd := BlockToInt64(block, 0);
  sized := BlockToInt64(block, 8);

  pos := 0;
  Seek(handle, offsf);
  SetLength(fbytes, sizef);

  while pos < sizef do begin
    BlockRead(handle, block, 1);
    CopyMemory(@fbytes[pos], @block[0], HIB_BLOCKSIZE);
    pos := pos + HIB_BLOCKSIZE;
  end;
  flame := TStringList.Create;
  flame.Text := PChar(fbytes);

  pos := 0;
  bx := 0; by := 0;
  Seek(handle, offsd);
  SetLength(buckets, header.Size2D.Y, header.Size2D.X);

  callback(0);
  c := 0; p := 0;
  step := 1.0 / sized;
  while pos < sized do begin
    with buckets[by][bx] do begin
      BlockRead(handle, block, 1);
      Red := BlockToInt32(block, 0);
      Green := BlockToInt32(block, 4);
      Blue := BlockToInt32(block, 8);
      Count := BlockToInt32(block, 12);
    end;
    Inc(bx);
    pos := pos + HIB_BLOCKSIZE;
    if bx >= header.Size2D.X then begin
      Inc(by); bx := 0;
    end;
    p := p + step;
    c := (c + 1) mod 64;
    if (c = 0) then begin
      callback(p*0.99);
      Application.ProcessMessages;
    end;
  end;
  callback(0.99);

  i := 0;
  while i < 256 do begin
    BlockRead(handle, block, 1);

    c := BlockToInt32(block, 0);
    colormap[i+0].Red := c and $ff;
    colormap[i+0].Green := (c and $ff00) shr 8;
    colormap[i+0].Blue := (c and $ff0000) shr 16;

    c := BlockToInt32(block, 4);
    colormap[i+1].Red := c and $ff;
    colormap[i+1].Green := (c and $ff00) shr 8;
    colormap[i+1].Blue := (c and $ff0000) shr 16;

    c := BlockToInt32(block, 8);
    colormap[i+2].Red := c and $ff;
    colormap[i+2].Green := (c and $ff00) shr 8;
    colormap[i+2].Blue := (c and $ff0000) shr 16;

    c := BlockToInt32(block, 12);
    colormap[i+3].Red := c and $ff;
    colormap[i+3].Green := (c and $ff00) shr 8;
    colormap[i+3].Blue := (c and $ff0000) shr 16;

    i := i + 4;
  end;
end;

end.
