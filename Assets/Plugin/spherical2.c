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
    double spherical2_re;
    double spherical2_im;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("spherical2");
APO_VARIABLES(
    VAR_REAL(spherical2_re, 1.0),
    VAR_REAL(spherical2_im, 0.0)
);

int PluginVarPrepare(Variation* vp) { return TRUE; }
int PluginVarCalc(Variation* vp) {
    double denom = MAX(EPS, sqr(FTx) + sqr(FTy));
    double a = VAR(spherical2_re) * FTx + VAR(spherical2_im) * FTy;
    double b = VAR(spherical2_im) * FTx + VAR(spherical2_re) * FTy;

    FPx += VVAR * (a) / denom;
    FPy += VVAR * (b) / denom;

    return TRUE;
}
