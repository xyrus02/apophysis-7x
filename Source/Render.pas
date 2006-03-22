{
     Flame screensaver Copyright (C) 2002 Ronald Hordijk
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Borys, Peter Sdobnov     

     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation; either version 2 of the License, or
     (at your option) any later version.

     This program is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.

     You should have received a copy of the GNU General Public License
     along with this program; if not, write to the Free Software
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}
unit Render;

interface

uses
  Windows, Graphics,
  Controlpoint;

type
  TOnProgress = procedure(prog: double) of object;

type
  TColorMapColor = Record
    Red,
    Green,
    Blue: integer; //Int64;
//    Count: Int64;
  end;
  PColorMapColor = ^TColorMapColor;
  TColorMapArray = array[0..255] of TColorMapColor;

  TBucket = Record
    Red,
    Green,
    Blue,
    Count: Int64;
  end;
  PBucket = ^TBucket;
  TBucketArray = array of TBucket;
  PBucketArray = ^PBucketArray;

type
  TBaseRenderer = class
  private
    FOnProgress: TOnProgress;
    procedure SetOnProgress(const Value: TOnProgress);
  protected
    FMaxMem: integer;
    FCompatibility: integer;
    FStop: boolean;
    FCP: TControlPoint;

    procedure Progress(value: double);

    function GetSlice: integer; virtual;
    function GetNrSlices: integer; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure SetCP(CP: TControlPoint);
    procedure Render; virtual; abstract;

    function  GetImage: TBitmap; virtual; abstract;
    procedure UpdateImage(CP: TControlPoint); virtual;
    procedure SaveImage(const FileName: String); virtual;

    procedure Stop; virtual;
    procedure Pause(paused: boolean); virtual;

    property OnProgress: TOnProgress
        read FOnProgress
       write SetOnProgress;
    property compatibility : integer
        read Fcompatibility
       write Fcompatibility;
    property MaxMem : integer
        read FMaxMem
       write FMaxMem;
    property NrSlices: integer
        read GetNrSlices;
    property Slice: integer
        read GetSlice;
  end;

type
  TRenderer = class
  private
    FRenderer: TBaseRenderer;

    FOnProgress: TOnProgress;
    FCP: TControlPoint;
    Fcompatibility: Integer;
    FMaxMem: int64;

    function GetNrSlices: integer;
    function GetSlice: integer;
    procedure Setcompatibility(const Value: Integer);
    procedure SetMaxMem(const Value: int64);
  public

    constructor Create;
    destructor Destroy; override;

    procedure SetCP(CP: TControlPoint);
    procedure Render;
    procedure RenderMaxMem(MaxMem: Int64);

    function GetImage: TBitmap;
    procedure UpdateImage(CP: TControlPoint);
    procedure SaveImage(const FileName: String);

    procedure Stop;

    property OnProgress: TOnProgress
      read FOnProgress
      write FOnProgress;

    property Slice: integer
        read GetSlice;
    property NrSlices: integer
        read GetNrSlices;
    property MaxMem: int64
        read FMaxMem
       write SetMaxMem;
    property compatibility: Integer
        read Fcompatibility
       write Setcompatibility;
  end;

implementation

uses
  Math, Sysutils, Render64, RenderMM;

{ TRenderThread }

///////////////////////////////////////////////////////////////////////////////
destructor TRenderer.Destroy;
begin
  if assigned(FRenderer) then
    FRenderer.Free;

  inherited;
end;

///////////////////////////////////////////////////////////////////////////////
function TRenderer.GetImage: TBitmap;
begin
  Result := nil;
  if assigned(FRenderer) then
    Result := FRenderer.GetImage;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer.SetCP(CP: TControlPoint);
begin
  FCP := CP;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TRenderer.Create;
begin
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer.Render;
begin
  if assigned(FRenderer) then
    FRenderer.Free;

  if MaxMem = 0 then begin
    FRenderer := TRenderer64.Create;
  end else begin
    FRenderer := TRendererMM64.Create;
    FRenderer.MaxMem := MaxMem
  end;

  FRenderer.SetCP(FCP);
  FRenderer.compatibility := compatibility;
  FRenderer.OnProgress := FOnProgress;
  Frenderer.Render;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer.Stop;
begin

  if assigned(FRenderer) then
    FRenderer.Stop;
end;

///////////////////////////////////////////////////////////////////////////////
function TRenderer.GetNrSlices: integer;
begin
  if assigned(FRenderer) then
    Result := FRenderer.Nrslices
  else
    Result := 1;
end;

///////////////////////////////////////////////////////////////////////////////
function TRenderer.GetSlice: integer;
begin
  if assigned(FRenderer) then
    Result := FRenderer.Slice
  else
    Result := 1;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer.Setcompatibility(const Value: Integer);
begin
  Fcompatibility := Value;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer.SetMaxMem(const Value: int64);
begin
  FMaxMem := Value;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer.RenderMaxMem(MaxMem: Int64);
begin
  FMaxMem := MaxMem;
  Render;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer.UpdateImage(CP: TControlPoint);
begin

end;

///////////////////////////////////////////////////////////////////////////////
procedure TRenderer.SaveImage(const FileName: String);
begin
  if assigned(FRenderer) then
    FRenderer.SaveImage(FileName);
end;


{ TBaseRenderer }

///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.SetOnProgress(const Value: TOnProgress);
begin
  FOnProgress := Value;
end;

///////////////////////////////////////////////////////////////////////////////
constructor TBaseRenderer.Create;
begin
  inherited Create;
  FCompatibility := 1;
  FStop := False;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.SetCP(CP: TControlPoint);
begin
  if assigned(FCP) then
    FCP.Free;

  FCP := Cp.Clone;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.UpdateImage(CP: TControlPoint);
begin

end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.Stop;
begin
  FStop := True;
end;

procedure TBaseRenderer.Pause(paused: boolean);
begin

end;

///////////////////////////////////////////////////////////////////////////////
destructor TBaseRenderer.Destroy;
begin
  if assigned(FCP) then
    FCP.Free;

  inherited;
end;

///////////////////////////////////////////////////////////////////////////////
function TBaseRenderer.GetNrSlices: integer;
begin
  Result := 1;
end;

///////////////////////////////////////////////////////////////////////////////
function TBaseRenderer.GetSlice: integer;
begin
  Result := 0;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.Progress(value: double);
begin
  if assigned(FOnprogress) then
    FOnprogress(Value);
end;

///////////////////////////////////////////////////////////////////////////////
procedure TBaseRenderer.SaveImage(const FileName: String);
begin

end;

///////////////////////////////////////////////////////////////////////////////
end.

