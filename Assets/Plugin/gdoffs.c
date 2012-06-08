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
  double gdoffs_delta_x, gdoffs_delta_y;
  double gdoffs_area_x, gdoffs_area_y;
  double gdoffs_center_x, gdoffs_center_y;
  int gdoffs_gamma, gdoffs_square;
  
  double gdodx, gdoax, gdocx;
  double gdody, gdoay, gdocy;
  double gdob;
  int gdog, gdos;
} Variables;

#include "apoplugin.h"

// Fine tune stuff, try not to touch :)
const double __agdod = 0.1;
const double __agdoa = 2.0;
const double __agdoc = 1.0;

APO_PLUGIN("gdoffs");
APO_VARIABLES(
  VAR_REAL_RANGE(gdoffs_delta_x, 0.0, 16.0, 0.0),
  VAR_REAL_RANGE(gdoffs_delta_y, 0.0, 16.0, 0.0),
  VAR_REAL(gdoffs_area_x, 2.0),
  VAR_REAL(gdoffs_area_y, 2.0),
  VAR_REAL(gdoffs_center_x, 0.0),
  VAR_REAL(gdoffs_center_y, 0.0),
  VAR_INTEGER_RANGE(gdoffs_gamma, 1, 6, 1),
  VAR_INTEGER_RANGE(gdoffs_square, 0, 1, 0)
);

int PluginVarPrepare(Variation* vp)
{
  vp->var.gdodx = (vp->var.gdoffs_delta_x) * __agdod;
  vp->var.gdody = (vp->var.gdoffs_delta_y) * __agdod;
  
  vp->var.gdoax = ((fabs(vp->var.gdoffs_area_x) < 0.1) ? 0.1 : fabs(vp->var.gdoffs_area_x)) * __agdoa;
  vp->var.gdoay = ((fabs(vp->var.gdoffs_area_y) < 0.1) ? 0.1 : fabs(vp->var.gdoffs_area_y)) * __agdoa;
  
  vp->var.gdocx = (vp->var.gdoffs_center_x) * __agdoc;
  vp->var.gdocy = (vp->var.gdoffs_center_y) * __agdoc;
  
  vp->var.gdog = (vp->var.gdoffs_gamma);
  vp->var.gdos = (vp->var.gdoffs_square);
  
  vp->var.gdob = (double)(vp->var.gdog) * __agdoa / (MAX(vp->var.gdoax, vp->var.gdoay));

  return 1; 
}
int PluginVarCalc(Variation* vp)
{
  inline double fcip(double a){return ((a<0)?-((int)(fabs(a))+1):0)+((a>1)?((int)(a)):0);}
  inline double fclp(double a){return ((a<0)?-(fmod(fabs(a),1)):fmod(fabs(a),1));}
  inline double fscl(double a){return fclp((a+1)/2); }
  inline double fosc(double p, double a){return fscl(-1*cos(p*a*M_2PI));}   
  inline double flip(double a, double b, double c){return (c*(b-a)+a);}
    
  double osc_x=fosc(vp->var.gdodx,1),osc_y=fosc(vp->var.gdody,1);
  double in_x=(*(vp->pFTx)+vp->var.gdocx),in_y=(*(vp->pFTy)+vp->var.gdocy);
  double out_x=0,out_y=0;
  
  if ((vp->var.gdos) != 0) {
    out_x = flip(flip(in_x,fosc(in_x,4),osc_x),fosc(fclp(vp->var.gdob*in_x),4),osc_x);
    out_y = flip(flip(in_y,fosc(in_y,4),osc_x),fosc(fclp(vp->var.gdob*in_y),4),osc_x);
  } else {
    out_x = flip(flip(in_x,fosc(in_x,4),osc_x),fosc(fclp(vp->var.gdob *in_x),4),osc_x);
    out_y = flip(flip(in_y,fosc(in_y,4),osc_y),fosc(fclp(vp->var.gdob *in_y),4),osc_y);
  }
  
  *(vp->pFPx) = vp->vvar*out_x;
  *(vp->pFPy) = vp->vvar*out_y;
  *(vp->pFPz) = vp->vvar*(*(vp->pFTz));
  
	return 1;
}
