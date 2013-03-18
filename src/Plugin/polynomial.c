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
	double polynomial_powx, polynomial_powy;
	double polynomial_lcx, polynomial_lcy;
	double polynomial_scx, polynomial_scy;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("polynomial");

APO_VARIABLES(
	VAR_REAL(polynomial_powx, 1.0),
	VAR_REAL(polynomial_powy, 1.0),
	VAR_REAL(polynomial_lcx, 0.0),
	VAR_REAL(polynomial_lcy, 0.0),
	VAR_REAL(polynomial_scx, 0.0),
	VAR_REAL(polynomial_scy, 0.0)
);

int PluginVarPrepare(Variation* vp)
{
    return TRUE;
}

int PluginVarCalc(Variation* vp)
{   
    inline double sgn(double v) { return (v < 0) ? -1 : (v > 0) ? 1 : 0; }
    
    double xp = pow(VVAR * fabs(FTx), VAR(polynomial_powx));
    double yp = pow(VVAR * fabs(FTy), VAR(polynomial_powy));
    double zp = VVAR * FTz;

	FPx += xp * sgn(FTx) + VAR(polynomial_lcx) * FTx + VAR(polynomial_scx);
	FPy += yp * sgn(FTy) + VAR(polynomial_lcy) * FTy + VAR(polynomial_scy);
	FPz += zp;

    return TRUE;
}
