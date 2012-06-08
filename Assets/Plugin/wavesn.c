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
	double wavesn_freqx, wavesn_freqy;
	double wavesn_scalex, wavesn_scaley;
    double wavesn_incx, wavesn_incy;
    int wavesn_power;
    
    int absN;
    double cN;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("wavesn");

APO_VARIABLES(
	VAR_REAL(wavesn_freqx, 2.0), VAR_REAL(wavesn_freqy, 2.0),
	VAR_REAL(wavesn_scalex, 1.0), VAR_REAL(wavesn_scaley, 1.0),
	VAR_REAL(wavesn_incx, 0.0), VAR_REAL(wavesn_incy, 0.0),
	VAR_INTEGER_NONZERO(wavesn_power, 1.0)
);

int PluginVarPrepare(Variation* vp)
{
    VAR(absN) = (int)abs(VAR(wavesn_power));
    if (VAR(wavesn_power) == 0) VAR(wavesn_power) = 2;
    VAR(cN) = 1.0 / VAR(wavesn_power) / 2;
    return TRUE; 
}

int PluginVarCalc(Variation* vp)
{
    double angle = (atan2(FTy, FTx) + M_2PI * (rand() % (int)VAR(absN)))/ VAR(wavesn_power);
    double r = VVAR * pow(sqr(FTx) + sqr(FTy), VAR(cN));

    double sina = 0, cosa = 0;
    fsincos(angle, &sina, &cosa);
    double xn = r * cosa;
    double yn = r * sina;
    
    double siny = sin(VAR(wavesn_freqx) * yn); double sinx = sin(VAR(wavesn_freqy) * xn);
    double dx = xn + 0.5 * (VAR(wavesn_scalex) * siny + fabs(xn) * VAR(wavesn_incx) * siny);
    double dy = yn + 0.5 * (VAR(wavesn_scaley) * sinx + fabs(yn) * VAR(wavesn_incy) * sinx);
    FPx += VVAR * dx;
    FPy += VVAR * dy;

    return TRUE;
}
