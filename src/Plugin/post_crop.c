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

// we need this later
#define max(a, b) ((a) > (b) ? (a) : (b))
#define min(a, b) ((a) < (b) ? (a) : (b))

// reserve mem for variables
typedef struct
{
    double post_crop_left, post_crop_right, post_crop_top, post_crop_bottom, 
           post_crop_scatter_area;
    double xmin, xmax, ymin, ymax, A;
} Variables;

// load plugin interface
#include "apoplugin.h"

// describe plugin
APO_PLUGIN("post_crop");
APO_VARIABLES(
    VAR_REAL(post_crop_left, -1.0),
    VAR_REAL(post_crop_top, -1.0),
    VAR_REAL(post_crop_right, 1.0),
    VAR_REAL(post_crop_bottom, 1.0),
    VAR_REAL(post_crop_scatter_area, 0.0)
);

// preparation proc
int PluginVarPrepare(Variation* vp)
{
    VAR(xmin) = min(VAR(post_crop_left), VAR(post_crop_right));
    VAR(ymin) = min(VAR(post_crop_top), VAR(post_crop_bottom));
    VAR(xmax) = max(VAR(post_crop_left), VAR(post_crop_right));
    VAR(ymax) = max(VAR(post_crop_top), VAR(post_crop_bottom));
    VAR(A) = max(-1.0, min(VAR(post_crop_scatter_area), 1.0));
    
    return TRUE; 
}

// calculation proc
int PluginVarCalc(Variation* vp)
{   
    inline double distribute(double a, double min, double max) {    
           double distance = random01() * 0.5 * VAR(A);
           return a < min ? min + distance * (max - min) :
                            max - distance * (max - min); }                
    FPx = VVAR * ((FPx >= VAR(xmin)) && (FPx <= VAR(xmax)) ? FPx : 
          distribute(FPx, VAR(xmin), VAR(xmax)));
    FPy = VVAR * ((FPy >= VAR(ymin)) && (FPy <= VAR(ymax)) ? FPy : 
          distribute(FPy, VAR(ymin), VAR(ymax)));
    FPz = VVAR * FPz; return TRUE;
}
