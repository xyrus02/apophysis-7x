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
    double barycentroid_a, barycentroid_b, barycentroid_c, barycentroid_d;
    double a, b, c, d;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("barycentroid");

APO_VARIABLES(
    VAR_REAL(barycentroid_a, 1.0),
    VAR_REAL(barycentroid_b, 0.0),
    VAR_REAL(barycentroid_c, 0.0),
    VAR_REAL(barycentroid_d, 1.0)
);

int PluginVarPrepare(Variation* vp)
{
    // alias
    VAR(a) = VAR(barycentroid_a);
    VAR(b) = VAR(barycentroid_b);
    VAR(c) = VAR(barycentroid_c);
    VAR(d) = VAR(barycentroid_d);
    
    return TRUE; 
}

int PluginVarCalc(Variation* vp)
{
    // helpers
    inline double sgn(double v) { return v < 0 ? -1 : v > 0 ? 1 : 0; }
    
    /*  The code is supposed to be fast and you all can read it so I dont 
        create those aliases for readability in actual code:
               
        v0x = VAR(a)
        v0y = VAR(b) 
        v1x = VAR(c)
        v1y = VAR(d)
        v2x = FTx
        v2y = FTy
    */
    
    // compute dot products
    double dot00 = VAR(a) * VAR(a) + VAR(b) * VAR(b);   // v0 * v0
    double dot01 = VAR(a) * VAR(c) + VAR(b) * VAR(d);   // v0 * v1
    double dot02 = VAR(a) * FTx    + VAR(b) * FTy;      // v0 * v2
    double dot11 = VAR(c) * VAR(c) + VAR(d) * VAR(d);   // v1 * v1
    double dot12 = VAR(c) * FTx    + VAR(d) * FTy;      // v1 * v2
    
    // compute inverse denomiator
    double invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
    
    /* now we can pull [u,v] as the barycentric coordinates of the point 
       P in the triangle [A, B, C]
    */
    double u = (dot11 * dot02 - dot01 * dot12) * invDenom;
    double v = (dot00 * dot12 - dot01 * dot02) * invDenom;
    
    // now combine with input
    double um = sqrt(sqr(u) + sqr(FTx)) * sgn(u);
    double vm = sqrt(sqr(v) + sqr(FTy)) * sgn(v);

    FPx += VVAR * um;
    FPy += VVAR * vm;
    FPz += VVAR * FTz; // just pass

    return TRUE;
}
