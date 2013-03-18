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
    double example_variable;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("example");
APO_VARIABLES(
    VAR_REAL(example_variable, 1.0);
);

int PluginVarPrepare(Variation* vp)
{
    return TRUE; 
}

int PluginVarCalc(Variation* vp)
{
	// example calculation:
    FPx += VVAR * FTx;	// Xout = weight * Xin
	FPx += VVAR * FTy;	// Yout = weight * Yout
	TC   = fmod(fabs(sqrt(sqr(FTx)+sqr(FTy))), 1.0); // Color [0..1]

    return TRUE;
}
