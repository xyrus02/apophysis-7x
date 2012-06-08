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
    double pre_crop_left, pre_crop_right, pre_crop_top, pre_crop_bottom,
           pre_crop_scatter_area;
    double xmin, xmax, ymin, ymax, A;
    int pre_crop_zero;
} Variables;

// load plugin interface
#include "apoplugin.h"

// describe plugin
APO_PLUGIN("pre_crop");
APO_VARIABLES(
    VAR_REAL(pre_crop_left, -1.0),
    VAR_REAL(pre_crop_top, -1.0),
    VAR_REAL(pre_crop_right, 1.0),
    VAR_REAL(pre_crop_bottom, 1.0),
    VAR_REAL(pre_crop_scatter_area, 0.0),
    VAR_INTEGER_RANGE(pre_crop_zero, 0, 1, 0)
);

// preparation proc
int PluginVarPrepare(Variation* vp)
{
    VAR(xmin) = min(VAR(pre_crop_left), VAR(pre_crop_right));
    VAR(ymin) = min(VAR(pre_crop_top), VAR(pre_crop_bottom));
    VAR(xmax) = max(VAR(pre_crop_left), VAR(pre_crop_right));
    VAR(ymax) = max(VAR(pre_crop_top), VAR(pre_crop_bottom));
    VAR(A) = max(-1.0, min(VAR(pre_crop_scatter_area), 1.0));

    return TRUE;
}

// calculation proc
int PluginVarCalc(Variation* vp)
{
    inline double distribute(double a, double min, double max) {
           double distance = random01() * 0.5 * VAR(A);
           if (VAR(pre_crop_zero)) return 0;
           return a < min ? min + distance * (max - min) :
                            max - distance * (max - min); }
    FTx = VVAR * ((FTx >= VAR(xmin)) && (FTx <= VAR(xmax)) ? FTx :
          distribute(FTx, VAR(xmin), VAR(xmax)));
    FTy = VVAR * ((FTy >= VAR(ymin)) && (FTy <= VAR(ymax)) ? FTy :
          distribute(FTy, VAR(ymin), VAR(ymax)));
    FTz = VVAR * FTz; return TRUE;
}
