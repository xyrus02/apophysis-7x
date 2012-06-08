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
	double post_julian2_a;
    double post_julian2_b;
    double post_julian2_c;
    double post_julian2_d;
    double post_julian2_e;
    double post_julian2_f;

    int post_julian2_power;
    double post_julian2_dist;

    int pabsN;
    double pcN;
    double pvvar2;

} Variables;

#include "apoplugin.h"

APO_PLUGIN("post_julian2");

APO_VARIABLES(
    VAR_INTEGER_NONZERO(post_julian2_power, 2),
	VAR_REAL(post_julian2_dist, 1.0),
	VAR_REAL(post_julian2_a, 1.0),
	VAR_REAL(post_julian2_b, 0.0),
	VAR_REAL(post_julian2_c, 0.0),
	VAR_REAL(post_julian2_d, 1.0),
	VAR_REAL(post_julian2_e, 0.0),
	VAR_REAL(post_julian2_f, 0.0)
);

int PluginVarPrepare(Variation* vp)
{
	VAR(pabsN) = (int)abs(VAR(post_julian2_power));
    VAR(pcN) = VAR(post_julian2_dist) / VAR(post_julian2_power) / 2;

	return TRUE;
}

int PluginVarCalc(Variation* vp)
{
    double x = VAR(post_julian2_a) * FPx + VAR(post_julian2_b) * FPy + VAR(post_julian2_e);
    double y = VAR(post_julian2_c) * FPx + VAR(post_julian2_d) * FPy + VAR(post_julian2_f);
    double sina = 0.0, cosa = 0.0;

    double angle = (atan2(y, x) + M_2PI * (rand() % (int)VAR(pabsN)))/ VAR(post_julian2_power);
    double r = VVAR * pow(sqr(x) + sqr(y), VAR(pcN));

    fsincos(angle, &sina, &cosa);
    FPx = r * cosa;
    FPy = r * sina;
	return TRUE;
}
