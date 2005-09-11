unit TriangleGraph;

interface

uses
  Classes, Controls, Messages, Windows, Graphics;

type
  TTriangleGraph = class(TWinControl)
  private
    FOnPaint: TNotifyEvent;
    FCanvas: TCanvas;

    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  protected
    procedure PaintWindow(DC: HDC); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Paint; virtual;

    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property Canvas: TCanvas read FCanvas;

    property OnDblClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
  end;

implementation

constructor TTriangleGraph.Create(AOwner: TComponent);
begin
  inherited;

  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
end;

destructor TTriangleGraph.Destroy;
begin
  FCanvas.Free;

  inherited;
end;

procedure TTriangleGraph.Paint;
begin
  if Assigned(FOnPaint) then FOnPaint(Self);
end;

procedure TTriangleGraph.PaintWindow(DC: HDC);
begin
  FCanvas.Handle := DC;
  try
    Paint;
  finally
    FCanvas.Handle := 0;
  end;
end;

procedure TTriangleGraph.WMPaint(var Message: TWMPaint);
begin
  PaintHandler(Message);
end;

end.

