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
    double pre_boarders2_c;
    double pre_boarders2_left;
    double pre_boarders2_right;
    double c, cl, cr;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("pre_boarders2");
APO_VARIABLES(
    VAR_REAL(pre_boarders2_c, 0.5),
    VAR_REAL(pre_boarders2_left, 0.5),
    VAR_REAL(pre_boarders2_right, 0.5),
);

int PluginVarPrepare(Variation* vp)
{
    double c = fabs(VAR(pre_boarders2_c)),
           cl = fabs(VAR(pre_boarders2_left)),
           cr = fabs(VAR(pre_boarders2_right));
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
        FTx = VVAR*(offsetX*c + roundX);
        FTy = VVAR*(offsetY*c + roundY);
    }
    else
    {
        if(fabs(offsetX) >= fabs(offsetY))
        {
            if(offsetX >= 0.0)
            {
                FTx = VVAR*(offsetX*c + roundX + cl);
                FTy = VVAR*(offsetY*c + roundY + cl * offsetY / offsetX);
            }
            else
            {
                FTx = VVAR*(offsetX*c + roundX - cl);
                FTy = VVAR*(offsetY*c + roundY - cl * offsetY / offsetX);
            }
        }
        else
        {
            if(offsetY >= 0.0)
            {
                FTy = VVAR*(offsetY*c + roundY + cl);
                FTx = VVAR*(offsetX*c + roundX + offsetX/offsetY*cl);
            }
            else
            {
                FTy = VVAR*(offsetY*c + roundY - cl);
                FTx = VVAR*(offsetX*c + roundX - offsetX/offsetY*cl);
            }
        }
    }
    return TRUE;
}

