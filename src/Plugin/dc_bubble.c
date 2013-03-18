/*
    Apophysis Plugin

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

typedef struct
{
        double dc_bubble_centerx;
        double dc_bubble_centery;
        double dc_bubble_scale;
        
        double bdcs;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("dc_bubble");
APO_VARIABLES(
        VAR_REAL(dc_bubble_centerx, 0.0),
        VAR_REAL(dc_bubble_centery, 0.0),
        VAR_REAL(dc_bubble_scale, 1.0)
);

int PluginVarPrepare(Variation* vp)
{
    VAR(bdcs) = 1.0 / (VAR(dc_bubble_scale) == 0.0 ? 10E-6 : VAR(dc_bubble_scale));
    return TRUE; 
}

int PluginVarCalc(Variation* vp)
{
    double r = (sqr(FTx) + sqr(FTy));
    double r4_1 = r / 4.0 + 1.0;
    r4_1 = VVAR / r4_1;
    FPx += FPx + r4_1 * FTx;
    FPy += FPy + r4_1 * FTy;
    FPz += FPz + VVAR * (2.0 / r4_1 - 1.0);
    
    TC = fmod(fabs(VAR(bdcs) * (sqr(FPx + VAR(dc_bubble_centerx)) + sqr(FPy + VAR(dc_bubble_centery)))), 1.0);

    return TRUE;
}
