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
        double bcbw;
        double bcircle_scale;
        double bcircle_borderwidth;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("bcircle");

APO_VARIABLES(
              VAR_REAL(bcircle_scale, 1.0),
              VAR_REAL(bcircle_borderwidth, 0.0)
);

int PluginVarPrepare(Variation* vp)
{
    VAR(bcbw) = fabs(VAR(bcircle_borderwidth));
    return TRUE;
}

int PluginVarCalc(Variation* vp)
{
    if ((FTx == 0) && (FTy == 0)) {
       return TRUE;
    }
    double x = FTx * VAR(bcircle_scale);
    double y = FTy * VAR(bcircle_scale);
    double r = sqrt(x * x + y * y);
    
    if (r <= 1) {
      FPx += VVAR * x;
      FPy += VVAR * y;       
    } else {
      if (VAR(bcbw) != 0) {
         double ang = atan2(y, x);     
         double omega = (0.2 * VAR(bcbw) * random01()) + 1;
         double px = omega * cos(ang);
         double py = omega * sin(ang);
         FPx += VVAR * px;
         FPy += VVAR * py;
       }
    }

    return TRUE;
}
