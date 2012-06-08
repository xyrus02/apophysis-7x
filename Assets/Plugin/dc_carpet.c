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
    double dc_carpet_origin;
    int dc_carpet_iterations;
    double H; int I;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("dc_carpet");
APO_VARIABLES(
    VAR_REAL(dc_carpet_origin, 1.0),
    VAR_INTEGER_NONZERO(dc_carpet_iterations, 5)
);

int PluginVarPrepare(Variation* vp)
{
    VAR(H) = 0.1 * VAR(dc_carpet_origin);
    VAR(I) = abs(VAR(dc_carpet_iterations));
    return TRUE; 
}

int PluginVarCalc(Variation* vp)
{
    // some definitions
    #define signum(n) n<0?-1:1
    #define rndsignum (rand()&1)?-1:1
    
    int x0 = rndsignum,
        y0 = rndsignum;
    double x = signum(FTx)*fmod(fabs(FTx),1.0) + x0, 
           y = signum(FTy)*fmod(fabs(FTy),1.0) + y0;
    
    double x0_xor_y0 = (double)(x0 ^ y0);
    double h = -VAR(H) + (1 - x0_xor_y0) * VAR(H);
    
    FPx += VVAR * (TM(a) * x + TM(b) * y + TM(e)); 
    FPy += VVAR * (TM(c) * x + TM(d) * y + TM(f));
    TC = fmod(fabs(TC * 0.5 * (1 + h) + x0_xor_y0 * (1 - h) * 0.5), 1.0);
    
    return TRUE;
}
