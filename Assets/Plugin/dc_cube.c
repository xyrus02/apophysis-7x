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
    double dc_cube_c1, dc_cube_c2, dc_cube_c3,
           dc_cube_c4, dc_cube_c5, dc_cube_c6;
    double dc_cube_x, dc_cube_y, dc_cube_z;
    double c1, c2, c3, c4, c5, c6;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("dc_cube");
APO_VARIABLES(
    VAR_REAL(dc_cube_c1, 0.0), VAR_REAL(dc_cube_c2, 0.0),
    VAR_REAL(dc_cube_c3, 0.0), VAR_REAL(dc_cube_c4, 0.0),
    VAR_REAL(dc_cube_c5, 0.0), VAR_REAL(dc_cube_c6, 0.0),
    VAR_REAL(dc_cube_x, 1.0),  VAR_REAL(dc_cube_y, 1.0),
    VAR_REAL(dc_cube_z, 1.0)
);

int PluginVarPrepare(Variation* vp)
{
    VAR(c1) = VAR(dc_cube_c1)<0?0:VAR(dc_cube_c1)>1?1:VAR(dc_cube_c1);
    VAR(c2) = VAR(dc_cube_c2)<0?0:VAR(dc_cube_c2)>1?1:VAR(dc_cube_c2);
    VAR(c3) = VAR(dc_cube_c3)<0?0:VAR(dc_cube_c3)>1?1:VAR(dc_cube_c3);
    VAR(c4) = VAR(dc_cube_c4)<0?0:VAR(dc_cube_c4)>1?1:VAR(dc_cube_c4);
    VAR(c5) = VAR(dc_cube_c5)<0?0:VAR(dc_cube_c5)>1?1:VAR(dc_cube_c5);
    VAR(c6) = VAR(dc_cube_c6)<0?0:VAR(dc_cube_c6)>1?1:VAR(dc_cube_c6);
    return TRUE; 
}

int PluginVarCalc(Variation* vp)
{
    double x, y, z;
    double p = 2*random01()-1, q = 2*random01()-1;
    int i = rand() % 3, j = rand() & 1; switch (i) {
        case 0: x = VVAR * (j?-1:1); y = VVAR * p; z = VVAR * q; 
                if(j) TC=VAR(c1); else TC=VAR(c2); break;
        case 1: x = VVAR * p; y = VVAR * (j?-1:1); z = VVAR * q; 
                if(j) TC=VAR(c3); else TC=VAR(c4); break;
        case 2: x = VVAR * p; y = VVAR * q; z = VVAR * (j?-1:1);
                if(j) TC=VAR(c5); else TC=VAR(c6); break;    
    }
    FPx += x * VAR(dc_cube_x); FPy += y * VAR(dc_cube_y); FPz += z * VAR(dc_cube_z);
    return TRUE;
}
