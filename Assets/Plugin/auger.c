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
    double auger_freq;
	double auger_scale;
	double auger_weight;
	double auger_sym;
	double as, af, aw, sy;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("auger");

APO_VARIABLES(
    VAR_REAL(auger_sym, 0.0),
	VAR_REAL(auger_weight, 0.5),
	VAR_REAL(auger_freq, 5.0),
	VAR_REAL(auger_scale, 0.1)
);

int PluginVarPrepare(Variation* vp)
{
    VAR(as) = 0.5 * VAR(auger_scale);
    VAR(af) = VAR(auger_freq);
    VAR(aw) = VAR(auger_weight);
    VAR(sy) = VAR(auger_sym);
    return TRUE;
}

int PluginVarCalc(Variation* vp)
{
    double y = FTy, x = FTx;
    double s = sin(VAR(af) * x), t = sin(VAR(af) * y),
           dy = y + VAR(aw) * (VAR(as) * s + fabs(y) * s),
           dx = x + VAR(aw) * (VAR(as) * t + fabs(x) * t);
	FPx += VVAR * (x + VAR(sy) * (dx - x));
	FPy += VVAR * dy;
    return TRUE;
}
