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
        double swtin_distort;
        
} Variables;

#include "apoplugin.h"

APO_PLUGIN("stwin");

APO_VARIABLES(
    VAR_REAL(swtin_distort, 1.0)
);

int PluginVarPrepare(Variation* vp)
{
    return TRUE;
}

int PluginVarCalc(Variation* vp)
{
    // at multiplier=1 the function begins to overlap at 0.05 so we 
    // multiply with 0.05
    const double multiplier = 0.05;
    
    // then do the rest
    double x = FTx * VVAR * multiplier;
    double y = FTy * VVAR * multiplier;
    double x2 = x * x; double y2 = y * y;
    double x_plus_y = x + y;
    double x2_minus_y2 = x2 - y2;
    double x2_plus_y2 = x2 + y2;
    
    double result = x2_minus_y2 * sin(M_2PI * VAR(swtin_distort) * x_plus_y);
    double divident = 1.0;
    if (x2_plus_y2 != 0) divident = x2_plus_y2;
    
    result /= divident;
    
    FPx += VVAR * FTx + result;
    FPy += VVAR * FTy + result;

    return TRUE;
}
