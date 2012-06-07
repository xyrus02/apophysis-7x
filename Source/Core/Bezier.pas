unit Bezier;

interface

uses Math;


type
  BezierPoint = record
    x, y: double;
  end;
  BezierRect = record
    x0, y0, x1, y1: double;
  end;

  BezierPoints = array [0..3] of BezierPoint;
  BezierWeights = array [0..3] of double;

procedure BezierCopy(src: BezierPoints; var tgt: BezierPoints);
procedure BezierSetRect(var points: BezierPoints; flip: boolean; rect: BezierRect);
procedure BezierUnsetRect(var points: BezierPoints; flip: boolean; rect: BezierRect);

procedure BezierSolve(t: double; src: BezierPoints; w: BezierWeights; var solution: BezierPoint);
function  BezierFunc(t: double; src: BezierPoints; w: BezierWeights): double;

implementation
  procedure BezierCopy(src: BezierPoints; var tgt: BezierPoints);
  var
    i, n: integer;
  begin
    n := Length(src);
    for i  := 0 to n - 1 do
      tgt[i] := src[i];
  end;
  procedure BezierSetRect(var points: BezierPoints; flip: boolean; rect: BezierRect);
  var
    i, n: integer;
    f: double;
  begin
    n := Length(points);
    for i := 0 to n - 1 do
    begin
      if (flip) then f := 1 - points[i].y
      else f := points[i].y;

      points[i].x := points[i].x * (rect.x1 - rect.x0) + rect.x0;
      points[i].y := f * (rect.y1 - rect.y0) + rect.y0;
    end;
  end;
  procedure BezierUnsetRect(var points: BezierPoints; flip: boolean; rect: BezierRect);
  var
    i, n: integer;
    f: double;
  begin
    if ((rect.x1 - rect.x0) = 0) or ((rect.y1 - rect.y0) = 0) then Exit;

    n := Length(points);
    for i := 0 to n - 1 do
    begin
      points[i].x := (points[i].x - rect.x0) / (rect.x1 - rect.x0);
      points[i].y := (points[i].y - rect.y0) / (rect.y1 - rect.y0);

      if (flip) then points[i].y := 1 - points[i].y;
    end;
  end;

  procedure BezierSolve(t: double; src: BezierPoints; w: BezierWeights; var solution: BezierPoint);
  var
    s, s2, s3, t2, t3, nom_x, nom_y, denom: double;
  begin
    s := 1 - t;
    s2 := s * s; s3 := s * s * s;
    t2 := t * t; t3 := t * t * t;

    nom_x := w[0] * s3 * src[0].x + w[1] * s2 * 3 * t * src[1].x +
             w[2] * s * 3 * t2 * src[2].x + w[3] * t3 * src[3].x;
    nom_y := w[0] * s3 * src[0].y + w[1] * s2 * 3 * t * src[1].y +
             w[2] * s * 3 * t2 * src[2].y + w[3] * t3 * src[3].y;
    denom := w[0] * s3 + w[1] * s2 * 3 * t + w[2] * s * 3 * t2 + w[3] * t3;

    if (IsNaN(nom_x)) or (IsNaN(nom_y)) or (IsNaN(denom)) then Exit;
    if denom = 0 then Exit;
    
    solution.x := nom_x / denom;
    solution.y := nom_y / denom;
  end;
  function BezierFunc(t: double; src: BezierPoints; w: BezierWeights): double;
  var
    p: BezierPoint;
  begin
    BezierSolve(t, src, w, p);
    Result := p.y;
  end;
end.
