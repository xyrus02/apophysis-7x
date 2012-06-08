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
    double dc_triangle_scatter_area, A;
    int dc_triangle_zero_edges;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("dc_triangle");
APO_VARIABLES(
    VAR_REAL(dc_triangle_scatter_area, 0.0),
    VAR_INTEGER_RANGE(dc_triangle_zero_edges, 0, 1, 0)
);

int PluginVarPrepare(Variation* vp)
{
    VAR(A) = VAR(dc_triangle_scatter_area) < -1 ? -1 :
             VAR(dc_triangle_scatter_area) > 1 ? 1 :
             VAR(dc_triangle_scatter_area);
    return TRUE; 
}

/* This function is called during calculation.
   You must call the argument "vp"
*/
int PluginVarCalc(Variation* vp)
{
    // set up triangle
    const double 
      xx = TM(a), xy = TM(b),  // X
      yx = TM(c) * -1, yy = TM(d) * -1,  // Y
      ox = TM(e), oy = TM(f),  // O
      px = FTx - ox, py = FTy - oy; // P
    
    // calculate dot products
    const double dot00 = xx * xx + xy * xy; // X * X
    const double dot01 = xx * yx + xy * yy; // X * Y
    const double dot02 = xx * px + xy * py; // X * P
    const double dot11 = yx * yx + yy * yy; // Y * Y
    const double dot12 = yx * px + yy * py; // Y * P
    
    // calculate barycentric coordinates
    const double denom = (dot00 * dot11 - dot01 * dot01);
    const double num_u = (dot11 * dot02 - dot01 * dot12);
    const double num_v = (dot00 * dot12 - dot01 * dot02);
    
    // u, v must not be constant
    double u = num_u / denom;
    double v = num_v / denom;
    int inside = 0, f = 1;
    
    // case A - point escapes edge XY
    if (u + v > 1) { f = -1;
       if (u > v) { u = u>1?1:u; v = 1-u; }
       else       { v = v>1?1:v; u = 1-v; } }
           
    // case B - point escapes either edge OX or OY
    else if ((u < 0) || (v < 0)) { 
       u = u<0?0:u>1?1:u; v = v<0?0:v>1?1:v; }
       
    // case C - point is in triangle
    else inside = 1;
    
    // handle outside points
    if (VAR(dc_triangle_zero_edges) && !inside) u = v = 0;
    else if (!inside) {
        u = (u + random01() * VAR(A) * f);
        v = (v + random01() * VAR(A) * f);
        u = u<-1?-1:u>1?1:u; v = v<-1?-1:v>1?1:v;
        
        if ((u + v > 1) && (VAR(A) > 0))  
           if (u > v) { u = u>1?1:u; v = 1-u; }       
           else       { v = v>1?1:v; u = 1-v; } 
    }

    // set output
    FPx += VVAR * (ox + u * xx + v * yx);
    FPy += VVAR * (oy + u * xy + v * yy);
    FPz += VVAR * FTz;
    TC   = fmod(fabs(u+v),1.0);
    
    // done
    return TRUE;
}
