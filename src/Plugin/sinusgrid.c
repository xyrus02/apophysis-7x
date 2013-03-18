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
        double sinusgrid_ampx;
        double sinusgrid_ampy;
        double sinusgrid_freqx;
        double sinusgrid_freqy;
        
        double fx, fy, ax, ay;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("sinusgrid");

APO_VARIABLES(
        //VAR_REAL_CYCLE(sinusgrid_ampx, 0.0, 1.0, 0.5),
        //VAR_REAL_CYCLE(sinusgrid_ampy, 0.0, 1.0, 0.5),
        VAR_REAL(sinusgrid_ampx, 0.5),
        VAR_REAL(sinusgrid_ampy, 0.5),
        VAR_REAL(sinusgrid_freqx, 1.0),
        VAR_REAL(sinusgrid_freqy, 1.0)
);

int PluginVarPrepare(Variation* vp)
{
    VAR(ax) = VAR(sinusgrid_ampx);
    VAR(ay) = VAR(sinusgrid_ampy);
    VAR(fx) = VAR(sinusgrid_freqx) * M_2PI;
    VAR(fy) = VAR(sinusgrid_freqy) * M_2PI;
    if (VAR(fx) == 0.0) VAR(fx) = EPS;
    if (VAR(fy) == 0.0) VAR(fy) = EPS;
    return TRUE; 
}

int PluginVarCalc(Variation* vp)
{
    inline double lerp(double a, double b, double p) { return a + p * (b-a); }
    double x = FTx, y = FTy;
    double sx = -1.0 * cos(x * VAR(fx));
    double sy = -1.0 * cos(y * VAR(fy));
    double tx = lerp(FTx, sx, VAR(ax)), ty = lerp(FTy, sy, VAR(ay)), tz = FTz;
    FPx += VVAR * tx;
    FPy += VVAR * ty;
    FPz += VVAR * tz;
    return TRUE;
}

