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

    Written by Georg Kiehne
    --> http://xyrus-worx.net, http://xyrus02.deviantart.com

    If you find any bugs / nags - keep them :)
*/

typedef struct {
  double post_dcztransl_x0;
  double post_dcztransl_x1;
  double post_dcztransl_factor;
  double x0_, x1_, x1_m_x0;
  int post_dcztransl_overwrite;
  int post_dcztransl_clamp;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("post_dcztransl");
APO_VARIABLES(
  VAR_REAL_RANGE(post_dcztransl_x0, 0.0, 1.0, 0.0),
  VAR_REAL_RANGE(post_dcztransl_x1, 0.0, 1.0, 1.0),
  VAR_REAL(post_dcztransl_factor, 1.0),
  VAR_INTEGER_RANGE(post_dcztransl_overwrite, 0, 1, 1),
  VAR_INTEGER_RANGE(post_dcztransl_clamp, 0, 1, 0)
);

int PluginVarPrepare(Variation* vp)
{
  vp->var.x0_ = vp->var.post_dcztransl_x0 < vp->var.post_dcztransl_x1 ? vp->var.post_dcztransl_x0 : vp->var.post_dcztransl_x1;
  vp->var.x1_ = vp->var.post_dcztransl_x0 > vp->var.post_dcztransl_x1 ? vp->var.post_dcztransl_x0 : vp->var.post_dcztransl_x1;
  vp->var.x1_m_x0 = vp->var.x1_ - vp->var.x0_ == 0 ? EPS : vp->var.x1_ - vp->var.x0_;

  return 1;
}
int PluginVarCalc(Variation* vp)
{
  inline double flip(double a, double b, double c){return (c*(b-a)+a);}

  double zf = vp->var.post_dcztransl_factor * (*(vp->pColor) - vp->var.x0_) / vp->var.x1_m_x0;
  if (vp->var.post_dcztransl_clamp != 0)
     zf = zf < 0 ? 0 : zf > 1 ? 1 : zf;

  *(vp->pFPx) = vp->vvar*(*(vp->pFPx));
  *(vp->pFPy) = vp->vvar*(*(vp->pFPy));

  if (vp->var.post_dcztransl_overwrite == 0)
    *(vp->pFPz) = vp->vvar*(*(vp->pFPz))*zf;
  else *(vp->pFPz) = vp->vvar*zf;

	return 1;
}
