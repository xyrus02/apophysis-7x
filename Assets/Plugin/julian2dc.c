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

// Must define this structure before we include apoplugin.h
typedef struct
{
	double julian2dc_a;
    double julian2dc_b;
    double julian2dc_c;
    double julian2dc_d;
    double julian2dc_e;
    double julian2dc_f;

    int julian2dc_power;
    double julian2dc_dist,
           julian2dc_col;

    int absN;
    double cN;
    double vvar2;

} Variables;

#include "apoplugin.h"

APO_PLUGIN("julian2dc");

APO_VARIABLES(
    VAR_INTEGER_NONZERO(julian2dc_power, 2),
	VAR_REAL(julian2dc_dist, 1.0),
	VAR_REAL(julian2dc_col, 0.0),
	VAR_REAL(julian2dc_a, 1.0),
	VAR_REAL(julian2dc_b, 0.0),
	VAR_REAL(julian2dc_c, 0.0),
	VAR_REAL(julian2dc_d, 1.0),
	VAR_REAL(julian2dc_e, 0.0),
	VAR_REAL(julian2dc_f, 0.0)
);

int PluginVarPrepare(Variation* vp)
{
	VAR(absN) = (int)abs(VAR(julian2dc_power));
    VAR(cN) = VAR(julian2dc_dist) / VAR(julian2dc_power) / 2;

	return TRUE;
}

int PluginVarCalc(Variation* vp)
{
    double x = VAR(julian2dc_a) * FTx + VAR(julian2dc_b) * FTy + VAR(julian2dc_e);
    double y = VAR(julian2dc_c) * FTx + VAR(julian2dc_d) * FTy + VAR(julian2dc_f);
    double sina = 0.0, cosa = 0.0;

    double angle = (atan2(y, x) + M_2PI * (rand() % (int)VAR(absN)))/ VAR(julian2dc_power);
    double r = VVAR * pow(sqr(x) + sqr(y), VAR(cN));

    fsincos(angle, &sina, &cosa);
    FPx += r * cosa;
    FPy += r * sina;
    TC   = fmod(fabs(r * VAR(julian2dc_col) + (angle / M_2PI) * (1 - VAR(julian2dc_col))), 1.0);
	return TRUE;
}
