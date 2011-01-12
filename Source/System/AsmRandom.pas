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

     This module is (c) Jed Kelsey and originally created for Apophysis JK 2.10.
}

unit AsmRandom;

interface

procedure AsmRandInt;
procedure AsmRandExt;
procedure AsmRandomize;

var
  RandSeed: Longint = 0;    { Base for random number generator }

implementation

const
  advapi32 = 'advapi32.dll';
  kernel = 'kernel32.dll';

function QueryPerformanceCounter(var lpPerformanceCount: Int64): LongBool; stdcall;
  external kernel name 'QueryPerformanceCounter';

function GetTickCount: Cardinal;
  external kernel name 'GetTickCount';


procedure AsmRandomize;
{$IFDEF LINUX}
begin
  RandSeed := _time(nil);
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
var
  Counter: Int64;
begin
  if QueryPerformanceCounter(Counter) then
    RandSeed := Counter
  else
    RandSeed := GetTickCount;
end;
{$ENDIF}

procedure       AsmRandInt;
asm
{     ->EAX     Range   }
{     <-EAX     Result  }
        IMUL    EDX,RandSeed,08088405H
        INC     EDX
        MOV     RandSeed,EDX
        MUL     EDX
        MOV     EAX,EDX
end;

procedure       AsmRandExt;
const two2neg32: double = ((1.0/$10000) / $10000);  // 2^-32
asm
{       FUNCTION _RandExt: Extended;    }

        IMUL    EDX,RandSeed,08088405H
        INC     EDX
        MOV     RandSeed,EDX

        FLD     two2neg32
        PUSH    0
        PUSH    EDX
        FILD    qword ptr [ESP]
        ADD     ESP,8
        FMULP  ST(1), ST(0)
end;

end.
