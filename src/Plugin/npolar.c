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
    double npolar_vvar;
    double npolar_vvar_2;
    
    int npolar_n;
    int npolar_nnz;
    int npolar_parity;
    int npolar_isodd;
    
    double npolar_cn;
    double npolar_absn;
} Variables;

#include "apoplugin.h"
APO_PLUGIN("npolar");
APO_VARIABLES(
    VAR_INTEGER(npolar_parity, 0),
    VAR_INTEGER(npolar_n, 1)
);

int PluginVarPrepare(Variation* vp)
{
    VAR(npolar_nnz) = (VAR(npolar_n) == 0) ? 1 : VAR(npolar_n);
	VAR(npolar_vvar) = VVAR / M_PI;
    VAR(npolar_vvar_2) = VAR(npolar_vvar) * 0.5;
    VAR(npolar_absn) = abs(VAR(npolar_nnz));
    VAR(npolar_cn) = 1.0 / VAR(npolar_nnz) / 2;
    VAR(npolar_isodd) = abs(VAR(npolar_parity)) % 2;
    return TRUE; 
}
int PluginVarCalc(Variation* vp)
{
    double sina = 0.0, cosa = 0.0;
    double x = (VAR(npolar_isodd) != 0) ? FTx : VAR(npolar_vvar) * atan2(FTx, FTy);
    double y = (VAR(npolar_isodd) != 0) ? FTy : VAR(npolar_vvar_2) * log(FTx*FTx + FTy*FTy);
    double angle = (atan2(y, x) + M_2PI * (rand() % (int)VAR(npolar_absn)))/ VAR(npolar_nnz);
    double r = VVAR * pow(sqr(x) + sqr(y), VAR(npolar_cn)) * ((VAR(npolar_isodd) == 0) ? 1.0 : VAR(npolar_parity));
    
    fsincos(angle, &sina, &cosa); cosa *= r; sina *= r;
    x = (VAR(npolar_isodd) != 0) ? cosa : (VAR(npolar_vvar_2) * log(cosa*cosa + sina*sina));
    y = (VAR(npolar_isodd) != 0) ? sina : (VAR(npolar_vvar) * atan2(cosa, sina));
    FPx += x; FPy += y;

    return TRUE;
}
