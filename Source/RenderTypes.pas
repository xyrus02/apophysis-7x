unit RenderTypes;

interface

type
  TOnProgress = procedure(prog: double) of object;
  TOnOutput = procedure(s: string) of object;

type
  TColorMapColor = Record
    Red,
    Green,
    Blue: integer; //Int64;
//    Count: Int64;
  end;
  PColorMapColor = ^TColorMapColor;
  TColorMapArray = array[0..255] of TColorMapColor;

  TFloatColor = Record
    Red,
    Green,
    Blue: single;
  end;

  TBucket64 = Record
    Red,
    Green,
    Blue,
    Count: Int64;
  end;
  PBucket64 = ^TBucket64;
  TBucket64Array = array of array of TBucket64;
//  PBucket64Array = ^PBucket64Array;

  TBucket48 = packed record
    rl: longword; rh: word;
    gl: longword; gh: word;
    bl: longword; bh: word;
    cl: longword; ch: word;
  end;
  PBucket48 = ^TBucket48;
  TBucket48Array = array of array of TBucket48;
//  PBucket48Array = ^PBucket48Array;

  TBucket32f = record
    Red,
    Green,
    Blue,
    Count: single;
  end;
  PBucket32f = ^TBucket32f;
  TBucket32fArray = array of array of TBucket32f;
//  PBucket32fArray = ^PBucket32fArray;

  TBucket32 = Record
    Red,
    Green,
    Blue,
    Count: Longword;
  end;
  PBucket32 = ^TBucket32;
  TBucket32Array = array of array of TBucket32;

  TBucket64f = Record
    Red,
    Green,
    Blue,
    Count: double;
  end;

const
  MAX_FILTER_WIDTH = 25;

const
  BITS_32 = 0;
  BITS_32f = 1;
  BITS_48 = 2;
  BITS_64 = 3;
  SizeOfBucket: array[0..3] of byte = (16, 16, 24, 32);

type
  TBucketStats = record
    MaxR, MaxG, MaxB, MaxA,
    TotalA, TotalSamples: int64;
    RenderTime: TDateTime;
  end;

implementation

end.
