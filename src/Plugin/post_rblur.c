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

typedef struct {
    double post_rblur_strength;
    double post_rblur_offset;
    double post_rblur_center_x;
    double post_rblur_center_y;

    double s2;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("post_rblur");
APO_VARIABLES(
    VAR_REAL(post_rblur_strength, 1.0),
    VAR_REAL(post_rblur_offset, 1.0),
    VAR_REAL(post_rblur_center_x, 0.0),
    VAR_REAL(post_rblur_center_y, 0.0)
);

int PluginVarPrepare(Variation* vp)
{
    VAR(s2) = 2.0 * VAR(post_rblur_strength);
    return TRUE;
}

int PluginVarCalc(Variation* vp)
{
    double r = sqrt(sqr(FPx - VAR(post_rblur_center_x)) + sqr(FPy - VAR(post_rblur_center_y))) - VAR(post_rblur_offset);
    r = r<0?0:r; r *= VAR(s2);
    FPx = VVAR * (FPx + (random01() - 0.5) * r);
    FPy = VVAR * (FPy + (random01() - 0.5) * r);
    return TRUE;
}
