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
        double vvar_pi;
        double psphere_zscale;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("psphere");

APO_VARIABLES(
        VAR_REAL(psphere_zscale, 0)
);

int PluginVarPrepare(Variation* vp)
{
    VAR(vvar_pi) = VVAR * M_PI;
    return TRUE;
}

int PluginVarCalc(Variation* vp)
{
    double c0 = FTx * VAR(vvar_pi);
    double c1 = FTy * VAR(vvar_pi);
    double c2 = FTz * VAR(vvar_pi);
    
    double sinc0, cosc0, sinc1, cosc1;
    fsincos(c0, &sinc0, &cosc0);
    fsincos(c1, &sinc1, &cosc1);
    
    double x = cosc0 * -sinc1;
    double y = sinc0 * cosc1;
    double z = cosc1 * VAR(psphere_zscale);

	FPx += x;
	FPy += y;
	FPz += z;

    return TRUE;
}
