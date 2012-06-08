/*
    "Cosine Wrap" plugin for Apophysis 2.x
    Copyright (C) 2010 Georg Kiehne

	Apophysis Fractal Flame Renderer
	Copyright (C) 2001-2004 Mark Townsend
	Copyright (C) 2005-2008 Peter Sdobnov, Piotr Borys, Ronald Hordijk

	flame - cosmic recursive fractal flames
	Copyright (C) 1992-2007 Scott Draves

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
    int coswrap_repeat;
	double coswrap_amount_x, coswrap_amount_y;
	double coswrap_phase_x, coswrap_phase_y;
	double ax, ay, px, py, axn, ayn, fr, vv2;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("coswrap");
APO_VARIABLES(
	VAR_INTEGER_NONZERO(coswrap_repeat, 1.0),
	VAR_REAL(coswrap_amount_x, 0.0), 
	VAR_REAL(coswrap_amount_y, 0.0), 
	VAR_REAL_CYCLE(coswrap_phase_x, -1.0, 1.0, 0.0), 
	VAR_REAL_CYCLE(coswrap_phase_y, -1.0, 1.0, 0.0)
);

// why isn't this in apoplugin.h??
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int PluginVarPrepare(Variation* vp)
{
    VAR(ax) = M_2PI * fabs(VAR(coswrap_amount_x));
	VAR(ay) = M_2PI * fabs(VAR(coswrap_amount_y));
	VAR(px) = M_PI  * VAR(coswrap_phase_x);
	VAR(py) = M_PI  * VAR(coswrap_phase_y);
	VAR(fr) = fabs((double)VAR(coswrap_repeat));
	VAR(vv2)= 2.0 * VVAR;
    return TRUE; 
}
int PluginVarCalc(Variation* vp)
{
	inline double flerp(double a, double b, double p) { return (a+(b-a)*p); }
	inline double fabsmod(double fintp) { double dummy; return modf(fintp, &dummy); }
	inline double fosc(double p, double amp, double ph) { return 0.5-cos(p*amp+ph)*0.5; }
	inline double foscn(double p, double ph) { return 0.5-cos(p+ph)*0.5; }
	
	double x = 0.5 * FTx + 0.5, y = 0.5 * FTy + 0.5;
	double bx = fabsmod(VAR(fr) * x), by = fabsmod(VAR(fr) * y);
	double oscnapx = foscn(VAR(coswrap_amount_x), VAR(px)),
		   oscnapy = foscn(VAR(coswrap_amount_y), VAR(py));
	FPx = -1.0 + VAR(vv2) * flerp(flerp(x, fosc(x, 4.0, VAR(px)), oscnapx), fosc(bx, 4.0, VAR(px)), oscnapx);
    FPy = -1.0 + VAR(vv2) * flerp(flerp(y, fosc(y, 4.0, VAR(py)), oscnapy), fosc(by, 4.0, VAR(py)), oscnapy);
    return TRUE;
}
