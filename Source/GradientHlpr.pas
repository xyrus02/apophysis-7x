unit GradientHlpr;

interface

uses
  windows, Graphics;

const
  PixelCountMax = 32768;

type
  pRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = array[0..PixelCountMax - 1] of TRGBTriple;

type
  TGradientHelper = class
  private
  public
    function GetGradientBitmap(Index: integer; const hue_rotation: double): TBitmap;
  end;

var
  GradientHelper: TGradientHelper;

implementation

uses
  Cmap;

{ TGradientHelper }

function TGradientHelper.GetGradientBitmap(Index: integer; const hue_rotation: double): TBitmap;
var
  BitMap: TBitMap;
  i, j: integer;
  Row: pRGBTripleArray;
  pal: TColorMap;
begin
  GetCMap(index, hue_rotation, pal);

  BitMap := TBitMap.create;
  Bitmap.PixelFormat := pf24bit;
  BitMap.Width := 256;
  BitMap.Height := 2;

  for j := 0 to Bitmap.Height - 1 do begin
    Row := Bitmap.Scanline[j];
    for i := 0 to Bitmap.Width - 1 do begin
      Row[i].rgbtRed := Pal[i][0];
      Row[i].rgbtGreen := Pal[i][1];
      Row[i].rgbtBlue := Pal[i][2];
    end
  end;

  Result := BitMap;
end;

initialization
  GradientHelper := TGradientHelper.create;
finalization
  GradientHelper.Free;
end.
