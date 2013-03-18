{
     Apophysis Copyright (C) 2001-2004 Mark Townsend
     Apophysis Copyright (C) 2005-2006 Ronald Hordijk, Piotr Borys, Peter Sdobnov
     Apophysis Copyright (C) 2007-2008 Piotr Borys, Peter Sdobnov
     
     Apophysis "3D hack" Copyright (C) 2007-2008 Peter Sdobnov
     Apophysis "7X" Copyright (C) 2009-2010 Georg Kiehne

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
unit RenderingCommon;

interface
type
  TOnFinish = procedure of object;
  TOnProgress = procedure(prog: double) of object;

  {$ifdef Apo7X64}
  TBucket = Record
    Red,
    Green,
    Blue,
    Count: Double;
  end;
  {$else}
  TBucket = Record
    Red,
    Green,
    Blue,
    Count: Single;
  end;
  {$endif}
  PBucket = ^TBucket;
  TBucketArray = array of array of TBucket;
  TZBuffer = array of array of double;

  TBucketStats = record
    MaxR, MaxG, MaxB, MaxA,
    TotalA: double;
  end;
  
procedure TrimWorkingSet;

implementation
uses Windows;

procedure TrimWorkingSet;
var
  hProcess: THandle;
begin
  hProcess := OpenProcess(PROCESS_SET_QUOTA, false, GetCurrentProcessId);
  
  try SetProcessWorkingSetSize(hProcess, $FFFFFFFF, $FFFFFFFF);
  finally CloseHandle(hProcess);
  end;
end;

end.
