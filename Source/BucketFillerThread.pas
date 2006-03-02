unit BucketFillerThread;

interface

uses
  Classes, Windows,
  ControlPoint, Render, XForm;

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
{
    bounds: array[0..3] of extended;
    size: array[0..1] of extended;
    RotationCenter: array[0..1] of extended;
}
    FinalXform: ^TXform;
    UseFinalXform: boolean;

    camX0, camY0, camW, camH,
    bws, bhs, cosa, sina, rcX, rcY: double;

    Buckets: PBucketArray;
    ColorMap: TColorMapArray;
    CriticalSection: TRTLCriticalSection;

    constructor Create(cp: TControlPoint);
    destructor Destroy; override;

    procedure Execute; override;

    procedure AddPointsToBuckets(const points: TPointsArray); 
    procedure AddPointsToBucketsAngle(const points: TPointsArray);
    procedure AddPointsWithFX(const points: TPointsArray);
    procedure AddPointsWithAngleFX(const points: TPointsArray);
  end;

implementation

{ PixelRenderThread }

///////////////////////////////////////////////////////////////////////////////
procedure TBucketFillerThread.AddPointsToBuckets(const points: TPointsArray);
var
  i: integer;
  px, py: double;
//  R: double;
//  V1, v2, v3: integer;
  Bucket: PBucket;
  MapColor: PColorMapColor;
begin
  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
//    if FStop then Exit;

    px := points[i].x - camX0;
    if (px < 0) or (px > camW) then continue;
    py := points[i].y - camY0;
    if (py < 0) or (py > camH) then continue;

    Bucket := @TBucketArray(buckets^)[Round(bws * px) + Round(bhs * py) * BucketWidth];
    MapColor := @ColorMap[Round(points[i].c * 255)];

    Inc(Bucket.Red,   MapColor.Red);
    Inc(Bucket.Green, MapColor.Green);
    Inc(Bucket.Blue,  MapColor.Blue);
    Inc(Bucket.Count);
  end;
end;

procedure TBucketFillerThread.AddPointsWithFX(const points: TPointsArray);
var
  i: integer;
  px, py: double;
  Bucket: PBucket;
  MapColor: PColorMapColor;
begin
 try
  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
//    if FStop then Exit;

    FinalXform.NextPoint(points[i]);

    px := points[i].x - camX0;
    if (px < 0) or (px > camW) then continue;
    py := points[i].y - camY0;
    if (py < 0) or (py > camH) then continue;

    Bucket := @TBucketArray(buckets^)[Round(bws * px) + Round(bhs * py) * BucketWidth];
    MapColor := @ColorMap[Round(points[i].c * 255)];

    Inc(Bucket.Red,   MapColor.Red);
    Inc(Bucket.Green, MapColor.Green);
    Inc(Bucket.Blue,  MapColor.Blue);
    Inc(Bucket.Count);
  end;
 except
 end
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBucketFillerThread.AddPointsToBucketsAngle(const points: TPointsArray);
var
  i: integer;
  px, py: double;
  Bucket: PBucket;
  MapColor: PColorMapColor;
begin
  for i := SUB_BATCH_SIZE - 1 downto 0 do begin
//    if FStop then Exit;

    px := points[i].x * cosa + points[i].y * sina + rcX;
    if (px < 0) or (px > camW) then continue;
    py := points[i].y * cosa - points[i].x * sina + rcY;
    if (py < 0) or (py > camH) then continue;

    Bucket := @TBucketArray(buckets^)[Round(bws * px) + Round(bhs * py) * BucketWidth];
    MapColor := @ColorMap[Round(points[i].c * 255)];

    Inc(Bucket.Red,   MapColor.Red);
    Inc(Bucket.Green, MapColor.Green);
    Inc(Bucket.Blue,  MapColor.Blue);
    Inc(Bucket.Count);
  end;
end;

procedure TBucketFillerThread.AddPointsWithAngleFX(const points: TPointsArray);
var
  i: integer;
  px, py: double;
  Bucket: PBucket;
  MapColor: PColorMapColor;
begin
 try
  for i := SUB_BATCH_SIZE - 1 downto 0 do
  begin
//    if FStop then Exit;
    FinalXform.NextPoint(points[i]);

    px := points[i].x * cosa + points[i].y * sina + rcX;
    if (px < 0) or (px > camW) then continue;
    py := points[i].y * cosa - points[i].x * sina + rcY;
    if (py < 0) or (py > camH) then continue;

    Bucket := @TBucketArray(buckets^)[Round(bws * px) + Round(bhs * py) * BucketWidth];
    MapColor := @ColorMap[Round(points[i].c * 255)];

    Inc(Bucket.Red,   MapColor.Red);
    Inc(Bucket.Green, MapColor.Green);
    Inc(Bucket.Blue,  MapColor.Blue);
    Inc(Bucket.Count);
  end;
 except
 end
end;

///////////////////////////////////////////////////////////////////////////////
constructor TBucketFillerThread.Create(cp: TControlPoint);
begin
  inherited Create(True);
  Self.FreeOnTerminate := True;

  Fcp := cp.Clone;

  SetLength(Points, SUB_BATCH_SIZE);

  FinalXForm := @fcp.xform[fcp.NumXForms];
  UseFinalXForm := fcp.finalXformEnabled and fcp.HasFinalXform;
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
  AddPointsProc: procedure (const points: TPointsArray) of object;
begin
  inherited;

  if FCP.FAngle = 0 then begin
    if UseFinalXForm then
      AddPointsProc := AddPointsWithFX
    else
      AddPointsProc := AddPointsToBuckets;
  end
  else begin
    if UseFinalXForm then
      AddPointsProc := AddPointsWithAngleFX
    else
      AddPointsProc := AddPointsToBucketsAngle;
  end;

  bc := 0;
  while (not Terminated) and (bc < Nrbatches) do begin
    fcp.iterateXYC(SUB_BATCH_SIZE, points);
    try
      EnterCriticalSection(CriticalSection);

      AddPointsProc(Points);

      Inc(batchcounter^);
      bc := batchcounter^
    finally
      LeaveCriticalSection(CriticalSection);
    end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
end.
