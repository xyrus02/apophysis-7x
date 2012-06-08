/*
    Apophysis Plugin

    Copyright (C) 2007-2009 Joel Faber
    Copyright (C) 2007-2009 Michael Faber

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
*/

// Must define this structure before we include apoplugin.h
typedef struct
{
    double boarders2_c;
    double boarders2_left;
    double boarders2_right;
    double c, cl, cr;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("boarders2");
APO_VARIABLES(
    VAR_REAL(boarders2_c, 0.5),
    VAR_REAL(boarders2_left, 0.5),
    VAR_REAL(boarders2_right, 0.5),
);

int PluginVarPrepare(Variation* vp)
{
    double c = fabs(VAR(boarders2_c)),
           cl = fabs(VAR(boarders2_left)),
           cr = fabs(VAR(boarders2_right));
    c = c==0?EPS:c; cl = cl==0?EPS:cl; cr = cr==0?EPS:cr;
    VAR(c) = c; VAR(cl) = c*cl; VAR(cr) = c+(c*cr);
    return TRUE;
}
int PluginVarCalc(Variation* vp)
{
    const double c = vp->var.c;
    const double cl = vp->var.cl;
    const double cr = vp->var.cr;

    double roundX, roundY, offsetX, offsetY;

    roundX = rint(FTx);
    roundY = rint(FTy);
    offsetX = FTx - roundX;
    offsetY = FTy - roundY;

    if(random01() >= cr)
    {
        FPx += VVAR*(offsetX*c + roundX);
        FPy += VVAR*(offsetY*c + roundY);
    }
    else
    {
        if(fabs(offsetX) >= fabs(offsetY))
        {
            if(offsetX >= 0.0)
            {
                FPx += VVAR*(offsetX*c + roundX + cl);
                FPy += VVAR*(offsetY*c + roundY + cl * offsetY / offsetX);
            }
            else
            {
                FPx += VVAR*(offsetX*c + roundX - cl);
                FPy += VVAR*(offsetY*c + roundY - cl * offsetY / offsetX);
            }
        }
        else
        {
            if(offsetY >= 0.0)
            {
                FPy += VVAR*(offsetY*c + roundY + cl);
                FPx += VVAR*(offsetX*c + roundX + offsetX/offsetY*cl);
            }
            else
            {
                FPy += VVAR*(offsetY*c + roundY - cl);
                FPx += VVAR*(offsetX*c + roundX - offsetX/offsetY*cl);
            }
        }
    }
    return TRUE;
}

