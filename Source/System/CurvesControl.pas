unit CurvesControl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Math, ControlPoint,
  Graphics, Controls, Forms, Bezier, CustomDrawControl, Vcl.ExtCtrls;

const
  point_size: double = 8;
  accurancy: double = 3;
  channel_count: integer = 4;
  padding = 3;

const
  MAX_CHANNEL = 3;

type
  TCurvesChannel = (ccAll = 0, ccRed = 1, ccGreen = 2, ccBlue = 3);
  TCurvesControl = class(TFrame)
    Host: TPanel;
  private
    FRect: BezierRect;

    FPoints: array [0..3] of BezierPoints;
    FWeights: array [0..3] of BezierWeights;

    FDragging: boolean;
    FDragIndex: integer;

    FActiveChannel : TCurvesChannel;
    FChannelIndex : integer;

    FFrame : TCustomDrawControl;
    FCP: TControlPoint;

    p: array [0..MAX_CHANNEL] of BezierPoints;
    w: array [0..MAX_CHANNEL] of BezierWeights;
    wsum: array [0..MAX_CHANNEL] of double;

    procedure SetChannel(value: TCurvesChannel);
    procedure SetWeightLeft(value: double);
    procedure SetWeightRight(value: double);

    function GetChannel: TCurvesChannel;
    function GetWeightLeft: double;
    function GetWeightRight: double;

    procedure FrameMouseLeave(Sender: TObject);
    procedure FrameMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FrameMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FrameMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FrameResize(Sender: TObject);
    procedure FramePaint(Sender: TObject);
    procedure FrameCreate;

    procedure PaintCurve(Bitmap: TBitmap; c: integer; p: BezierPoints; w: BezierWeights; widgets: boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property WeightLeft : double read GetWeightLeft write SetWeightLeft;
    property WeightRight : double read GetWeightRight write SetWeightRight;
    property ActiveChannel : TCurvesChannel read GetChannel write SetChannel;

    procedure SetCp(cp: TControlPoint);
    procedure UpdateFlame;
  end;

implementation

{$R *.DFM}

uses Main, Editor, Mutate, Adjust;

constructor TCurvesControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FFrame := TCustomDrawControl.Create(self);
  FFrame.TabStop  := True;
  FFrame.TabOrder := 0;
  FFrame.Parent   := Host;
  FFrame.Align    := alClient;
  FFrame.Visible  := True;

  FFrame.OnPaint      := FramePaint;
  FFrame.OnMouseDown  := FrameMouseDown;
  FFrame.OnMouseMove  := FrameMouseMove;
  FFrame.OnMouseUp    := FrameMouseUp;
  FFrame.OnMouseLeave := FrameMouseLeave;

  FCP := TControlPoint.Create;

  FrameCreate;
end;
destructor  TCurvesControl.Destroy;
begin
  FCP.Destroy;
  inherited Destroy;
end;

procedure TCurvesControl.SetCp(cp: TControlPoint);
var i, j: integer;
begin
  FCP.Copy(cp, true);
  for i := 0 to 3 do
    for j := 0 to 3 do begin
      FWeights[i,j] := FCP.curveWeights[i,j];
      FPoints[i,j].x := FCP.curvePoints[i,j].x;
      FPoints[i,j].y := FCP.curvePoints[i,j].y;
    end;
  Invalidate;
  FFrame.Invalidate;
end;
procedure TCurvesControl.UpdateFlame;
begin
  MainForm.StopThread;
  MainForm.UpdateUndo;
  MainCp.Copy(FCP, true);

  if EditForm.Visible then EditForm.UpdateDisplay;
  if MutateForm.Visible then MutateForm.UpdateDisplay;
  if AdjustForm.Visible then AdjustForm.UpdateDisplay(true);

  MainForm.RedrawTimer.enabled := true;
end;

procedure TCurvesControl.FrameMouseLeave(Sender: TObject);
begin
  FrameMouseUp(nil, mbLeft, [], 0, 0);
end;
procedure TCurvesControl.FrameMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ps_half: double;
  i, n: integer;
  p: BezierPoints;
begin
  BezierCopy(FPoints[FChannelIndex], p);
  BezierSetRect(p, true, FRect);

  FDragIndex := -1;
  FDragging := false;

  n := Length(p);
  for i := 1 to n - 2 do if
    (X >= p[i].x - point_size) and (X <= p[i].x + point_size) and
    (Y >= p[i].y - point_size) and (Y <= p[i].y + point_size) then
  begin
    FDragging := true;
    FDragIndex := i;
    Break;
  end;
end;
procedure TCurvesControl.FrameMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  m: BezierPoints;
  tmp: BezierPoint;
  i: Integer;
  j: Integer;
begin

  if (y < 0) then Exit;
  if (x < 0) then Exit;

  m[0].x := x; m[0].y := y;
  BezierUnsetRect(m, true, FRect);

  if FDragging then
  begin
    FPoints[FChannelIndex][FDragIndex] := m[0];
    if (FPoints[FChannelIndex][FDragIndex].x <= 0)
    then FPoints[FChannelIndex][FDragIndex].x := 0;
    if (FPoints[FChannelIndex][FDragIndex].y <= 0)
    then FPoints[FChannelIndex][FDragIndex].y := 0;
    if (FPoints[FChannelIndex][FDragIndex].x >= 1)
    then FPoints[FChannelIndex][FDragIndex].x := 1;
    if (FPoints[FChannelIndex][FDragIndex].y >= 1)
    then FPoints[FChannelIndex][FDragIndex].y := 1;

    if (FPoints[FChannelIndex][1].x > FPoints[FChannelIndex][2].x) then
    begin
      tmp := FPoints[FChannelIndex][1];
      FPoints[FChannelIndex][1] := FPoints[FChannelIndex][2];
      FPoints[FChannelIndex][2] := tmp;
      if (FDragIndex = 1) then FDragIndex := 2
      else FDragIndex := 1;
    end;

    for i := 0 to 3 do
    for j := 0 to 3 do begin
      FCP.curveWeights[i,j] := FWeights[i,j];
      FCP.curvePoints[i,j].x := FPoints[i,j].x;
      FCP.curvePoints[i,j].y := FPoints[i,j].y;
    end;


    FFrame.Refresh;
  end;
end;
procedure TCurvesControl.FrameMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FDragIndex := -1;
  FDragging := false;

  if (sender <> nil) then UpdateFlame;
end;

procedure TCurvesControl.FrameCreate;
var i: integer;
begin
  for i := 0 to channel_count - 1 do
  begin
    FPoints[i][0].x := 0.00; FPoints[i][0].y := 0.00; FWeights[i][0] := 1;
    FPoints[i][1].x := 0.00; FPoints[i][1].y := 0.00; FWeights[i][1] := 1;
    FPoints[i][2].x := 1.00; FPoints[i][2].y := 1.00; FWeights[i][2] := 1;
    FPoints[i][3].x := 1.00; FPoints[i][3].y := 1.00; FWeights[i][3] := 1;
  end;

  FDragIndex := -1;
  FDragging := false;
end;
procedure TCurvesControl.FrameResize(Sender: TObject);
begin
  FRect.x0 := 0; FRect.y0 := 0;
  FRect.x1 := self.Width - 1;
  FRect.y1 := self.Height - 1;
end;
procedure TCurvesControl.FramePaint(Sender: TObject);
var
  clientRect: TRect;
  i, j, x, y, sx, sy: integer;
  bitmap: TBitMap;
begin
  if (FFrame.Width <= 0) or (FFrame.Height <= 0) then Exit;
  FrameResize(Sender);

  Bitmap := TBitmap.Create;
  Bitmap.Width := FFrame.Width;
  Bitmap.Height := FFrame.Height;

  sx := Bitmap.Width;
  sy := Bitmap.Height;

  try
    with Bitmap.Canvas do
    begin
      Brush.Color := $000000;
      FillRect(Rect(0, 0, sx, sy));

      Pen.Color := $555555;
      Pen.Style := psSolid;
      Pen.Width := 1;

      for x := 1 to 7 do begin
        MoveTo(Round(0.125 * x * FRect.x1), Round(FRect.y0));
        LineTo(Round(0.125 * x * FRect.x1), Round(FRect.y1));
      end;
      for y := 1 to 3 do begin
        MoveTo(Round(FRect.x0), Round(0.25 * y * FRect.y1));
        LineTo(Round(FRect.x1), Round(0.25 * y * FRect.y1));
      end;

      for i := 0 to channel_count - 1 do begin
        for j := 0 to 3 do
          wsum[i] := wsum[i] + FWeights[i][j];
        for j := 0 to 3 do
          w[i][j] := FWeights[i][j] / wsum[i];

        BezierCopy(FPoints[i], p[i]);
        BezierSetRect(p[i], true, FRect);

        if i <> FChannelIndex then PaintCurve(Bitmap, i, p[i], w[i], false);
      end;
      PaintCurve(Bitmap, FChannelIndex, p[FChannelIndex], w[FChannelIndex], true);

      FFrame.Canvas.Draw(0, 0, Bitmap);
    end;
  finally
    Bitmap.Free;
  end;
end;

procedure TCurvesControl.PaintCurve(Bitmap: TBitmap; c: integer; p: BezierPoints; w: BezierWeights; widgets: boolean);
var
  pos0, pos1: BezierPoint;
  t, step: Double;
  r, g, b: array [0 .. MAX_CHANNEL] of integer;
  rgbv: integer;
begin
  with Bitmap.Canvas do
  begin
    if c <> FChannelIndex then begin
      r[0] := $aa; r[1] := $aa; r[2] := $40; r[3] := $40;
      g[0] := $aa; g[1] := $40; g[2] := $aa; g[3] := $40;
      b[0] := $aa; b[1] := $40; b[2] := $40; b[3] := $aa;
    end else begin
      r[0] := $ff; r[1] := $ff; r[2] := $80; r[3] := $80;
      g[0] := $ff; g[1] := $80; g[2] := $ff; g[3] := $80;
      b[0] := $ff; b[1] := $80; b[2] := $80; b[3] := $ff;
    end;

    rgbv := RGB(r[c], g[c], b[c]);

    t := 0;
    step := 0.001;

    BezierSolve(0, p, w, pos1);
    pos0.x := 0; pos0.y := pos1.y;

    if widgets then begin
      Pen.Color := $808080; Pen.Width := 1;
      MoveTo(Round(p[1].x), Round(p[1].y));
      LineTo(Round(p[2].x), Round(p[2].y));
      MoveTo(Round(FRect.x0), Round(FRect.y1));
      LineTo(Round(p[1].x), Round(p[1].y));
      MoveTo(Round(FRect.x1), Round(FRect.y0));
      LineTo(Round(p[2].x), Round(p[2].y));
    end;

    while t < 1 do begin
      BezierSolve(t, p, w, pos1);
      Pen.Color := rgbv;
      Pen.Width := 1;
      MoveTo(Round(pos0.x), Round(pos0.y));
      LineTo(Round(pos1.x), Round(pos1.y));
      t := t + step;
      pos0 := pos1;
    end;

    MoveTo(Round(pos0.x), Round(pos0.y));
    LineTo(Round(FRect.x1), Round(pos0.y));

    if widgets then begin
      Brush.Color := rgbv;
      Ellipse(
        Round(p[1].x - point_size / 2.0),
        Round(p[1].y - point_size / 2.0),
        Round(p[1].x + point_size / 2.0),
        Round(p[1].y + point_size / 2.0)
      );
      Ellipse(
        Round(p[2].x - point_size / 2.0),
        Round(p[2].y - point_size / 2.0),
        Round(p[2].x + point_size / 2.0),
        Round(p[2].y + point_size / 2.0)
      );
    end;
  end;
end;

procedure TCurvesControl.SetChannel(value: TCurvesChannel);
begin
  FActiveChannel := value;
  FChannelIndex := Integer(value);
  FFrame.Refresh;
end;
procedure TCurvesControl.SetWeightLeft(value: double);
begin
  FWeights[FChannelIndex][1] := value;
  FCP.curveWeights[FChannelIndex][1] := value;
  FFrame.Refresh;
end;
procedure TCurvesControl.SetWeightRight(value: double);
begin
  FWeights[FChannelIndex][2] := value;
  FCP.curveWeights[FChannelIndex][2] := value;
  FFrame.Refresh;
end;

function TCurvesControl.GetChannel: TCurvesChannel;
begin
  Result := FActiveChannel;
end;
function TCurvesControl.GetWeightLeft: double;
begin
  Result := FWeights[FChannelIndex][1];
end;
function TCurvesControl.GetWeightRight: double;
begin
  Result := FWeights[FChannelIndex][2];
end;

end.
