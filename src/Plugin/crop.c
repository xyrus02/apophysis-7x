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
    double crop_left, crop_right, crop_top, crop_bottom, 
           crop_scatter_area;
    double xmin, xmax, ymin, ymax, A;
} Variables;

// load plugin interface
#include "apoplugin.h"

// describe plugin
APO_PLUGIN("crop");
APO_VARIABLES(
    VAR_REAL(crop_left, -1.0),
    VAR_REAL(crop_top, -1.0),
    VAR_REAL(crop_right, 1.0),
    VAR_REAL(crop_bottom, 1.0),
    VAR_REAL(crop_scatter_area, 0.0)
);

// preparation proc
int PluginVarPrepare(Variation* vp)
{
    VAR(xmin) = min(VAR(crop_left), VAR(crop_right));
    VAR(ymin) = min(VAR(crop_top), VAR(crop_bottom));
    VAR(xmax) = max(VAR(crop_left), VAR(crop_right));
    VAR(ymax) = max(VAR(crop_top), VAR(crop_bottom));
    VAR(A) = max(-1.0, min(VAR(crop_scatter_area), 1.0));
    
    return TRUE; 
}

// calculation proc
int PluginVarCalc(Variation* vp)
{   
    inline double distribute(double a, double min, double max) {    
           double distance = random01() * 0.5 * VAR(A);
           return a < min ? min + distance * (max - min) :
                            max - distance * (max - min); }                
    FPx += VVAR * ((FTx >= VAR(xmin)) && (FTx <= VAR(xmax)) ? FTx : 
           distribute(FTx, VAR(xmin), VAR(xmax)));
    FPy += VVAR * ((FTy >= VAR(ymin)) && (FTy <= VAR(ymax)) ? FTy : 
           distribute(FTy, VAR(ymin), VAR(ymax)));
    FPz += VVAR * FTz; return TRUE;
}
