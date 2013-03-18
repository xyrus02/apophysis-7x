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
	double sigmoid_shiftx;
	double sigmoid_shifty;
	double sx, sy, ax, ay, vv;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("sigmoid");

APO_VARIABLES(
	VAR_REAL(sigmoid_shiftx, 1.0),
	VAR_REAL(sigmoid_shifty, 1.0)
);

int PluginVarPrepare(Variation* vp)
{
	VAR(ax) = 1.0; VAR(ay) = 1.0;
	VAR(sx) = VAR(sigmoid_shiftx); VAR(sy) = VAR(sigmoid_shifty);
    if (VAR(sx) < 1 && VAR(sx) > -1) {
       if (VAR(sx) == 0) {
          VAR(sx) = EPS; VAR(ax) = 1.0;
       } else {
         VAR(ax) = (VAR(sx) < 0 ? -1 : 1);
         VAR(sx) = 1 / VAR(sx);
       }
    }
    if (VAR(sy) < 1 && VAR(sy) > -1) {
       if (VAR(sy) == 0) {
          VAR(sy) = EPS; VAR(ay) = 1.0;
       } else {
         VAR(ay) = (VAR(sy) < 0 ? -1 : 1);
         VAR(sy) = 1 / VAR(sy);
       }
    }
    
	VAR(sx) *= -5;
	VAR(sy) *= -5;
	
	VAR(vv) = fabs(VVAR);
    return TRUE;
}

int PluginVarCalc(Variation* vp)
{
    double c0 = VAR(ax) / (1.0 + exp(VAR(sx) * FTx));
    double c1 = VAR(ay) / (1.0 + exp(VAR(sy) * FTy));
    double x = (2 * (c0 - 0.5));
    double y = (2 * (c1 - 0.5));
    
    FPx += VAR(vv) * x;
    FPy += VAR(vv) * y;

    return TRUE;
}
