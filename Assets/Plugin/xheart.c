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
        double cosa, sina, rat;
        double xheart_angle;
        double xheart_ratio;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("xheart");

APO_VARIABLES(
	VAR_REAL(xheart_angle, 0.0),
	VAR_REAL(xheart_ratio, 0.0)
);

int PluginVarPrepare(Variation* vp)
{
    double c, s; double ang = M_PI_4 + (0.5 * M_PI_4 * VAR(xheart_angle));
    fsincos(ang, &s, &c); VAR(cosa) = c; VAR(sina) = s;
    
    double r = 6 + 2 * VAR(xheart_ratio);
    VAR(rat) = r;
    
    return TRUE; 
}

int PluginVarCalc(Variation* vp)
{
    inline double lerp(double a, double b, double x) { x=(x<0)?0:x; x=(x>1)?1:x;return x+(b-a)*x; }
    double r2_4 = sqr(FTx) + sqr(FTy) + 4;
    if (r2_4 == 0) r2_4 = 1;
    double bx = 4 / r2_4, by = VAR(rat) / r2_4;
    double x = VAR(cosa) * (bx*FTx) - VAR(sina) * (by*FTy);
    double y = VAR(sina) * (bx*FTx) + VAR(cosa) * (by*FTy);
    
    if (x > 0) {
    	FPx += VVAR * x;
     	FPy += VVAR * y;
    } else {
        FPx += VVAR * x;
     	FPy += -VVAR * y;
    }

    return TRUE;
}
