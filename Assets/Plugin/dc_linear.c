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
    double dc_linear_offset, dc_linear_angle, dc_linear_scale;
    double ldcs, ldca;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("dc_linear");
APO_VARIABLES(
    VAR_REAL(dc_linear_offset, 0.0),
    VAR_REAL(dc_linear_angle,  0.0),
    VAR_REAL(dc_linear_scale,  1.0),
);

int PluginVarPrepare(Variation* vp)
{
    VAR(ldcs) = 1.0 / (VAR(dc_linear_scale) == 0.0 ? 10E-6 : VAR(dc_linear_scale));
    VAR(ldca) = VAR(dc_linear_offset) * M_PI;
    return TRUE; 
}

int PluginVarCalc(Variation* vp)
{
    FPx += VVAR * FTx;
    FPy += VVAR * FTy;
    FPz += VVAR * FTz;
    
    double c, s; fsincos(VAR(dc_linear_angle), &s, &c);
    TC   = fmod( fabs( 0.5 * (VAR(ldcs) * ((c * FPx + s * FPy + VAR(dc_linear_offset))) + 1.0) ), 1.0 );
    
    return TRUE;
}
