unit BucketFillerThread;

interface

uses
  Classes, Windows,
  ControlPoint, Render;

type
  TBucketFillerThread = class(TThread)
  private
    fcp: TControlPoint;
    points: TPointsArray;
  public
    nrbatches: integer;
    batchcounter: Pinteger;

    BucketWidth: Int64;
    BucketHeight: Int64;
    bounds: array[0..3] of extended;
    size: array[0..1] of extended;
    RotationCenter: array[0..1] of extended;
    Buckets: PBucketArray;
    ColorMap: TColorMapArray;
    CriticalSection: TRTLCriticalSection;

    constructor Create(cp: TControlPoint);
    destructor Destroy; override;

    procedure Execute; override;

    procedure AddPointsToBuckets(const points: TPointsArray); overload;
    procedure AddPointsToBucketsAngle(const points: TPointsArray); overload;
  end;

implementation

{ PixelRenderThread }

///////////////////////////////////////////////////////////////////////////////
procedure TBucketFillerThread.AddPointsToBuckets(const points: TPointsArray);
var
  i: integer;
  px, py: double;
  bws, bhs: double;
  bx, by: double;
  wx, wy: double;
  Bucket: PBucket;
  MapColor: PColorMapColor;
begin
  bws := (BucketWidth - 0.5)  * size[0];
  bhs := (BucketHeight - 0.5) * size[1];
  bx := bounds[0];
  by := bounds[1];
  wx := bounds[2] - bounds[0];
  wy := bounds[3] - bounds[1];

  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
    px := points[i].x - bx;
    py := points[i].y - by;

    if ((px < 0) or (px > wx) or
        (py < 0) or (py > wy)) then
      continue;

    MapColor := @ColorMap[Round(points[i].c * 255)];
    Bucket := @TbucketArray(buckets^)[Round(bws * px) + Round(bhs * py) * BucketWidth];

    Inc(Bucket.Red,   MapColor.Red);
    Inc(Bucket.Green, MapColor.Green);
    Inc(Bucket.Blue,  MapColor.Blue);
    Inc(Bucket.Count);
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBucketFillerThread.AddPointsToBucketsAngle(const points: TPointsArray);
var
  i: integer;
  px, py: double;
  ca,sa: double;
  nx, ny: double;
  bws, bhs: double;
  bx, by: double;
  wx, wy: double;
  Bucket: PBucket;
  MapColor: PColorMapColor;
begin
  bws := (BucketWidth - 0.5)  * size[0];
  bhs := (BucketHeight - 0.5) * size[1];
  bx := bounds[0];
  by := bounds[1];
  wx := bounds[2] - bounds[0];
  wy := bounds[3] - bounds[1];

  ca := cos(FCP.FAngle);
  sa := sin(FCP.FAngle);

  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
    px := points[i].x - RotationCenter[0];
    py := points[i].y - RotationCenter[1];

    nx := px * ca + py * sa;
    ny := -px * sa + py * ca;

    px := nx + FCP.Center[0] - bx;
    py := ny + FCP.Center[1] - by;

    if ((px < 0) or (px > wx) or
        (py < 0) or (py > wy)) then
      continue;

    MapColor := @ColorMap[Round(points[i].c * 255)];
    Bucket := @TbucketArray(buckets^)[Round(bws * px) + Round(bhs * py) * BucketWidth];

    Inc(Bucket.Red,   MapColor.Red);
    Inc(Bucket.Green, MapColor.Green);
    Inc(Bucket.Blue,  MapColor.Blue);
    Inc(Bucket.Count);
  end;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TBucketFillerThread.Create(cp: TControlPoint);
begin
  inherited Create(True);
  Self.FreeOnTerminate := True;

  Fcp := cp.Clone;

  SetLength(Points, SUB_BATCH_SIZE);
end;

///////////////////////////////////////////////////////////////////////////////
destructor TBucketFillerThread.Destroy;
begin
   FCP.Free;

  inherited;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBucketFillerThread.Execute;
var
  bc: integer;
begin
  inherited;

  bc := 0;
  while (not Terminated) and (bc < Nrbatches) do begin
    fcp.iterateXYC(SUB_BATCH_SIZE, points);
    try
      EnterCriticalSection(CriticalSection);

      if FCP.FAngle = 0 then
        AddPointsToBuckets(Points)
      else
        AddPointsToBucketsAngle(Points);

      Inc(batchcounter^);
      bc := batchcounter^
    finally
      LeaveCriticalSection(CriticalSection);
    end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
end.
