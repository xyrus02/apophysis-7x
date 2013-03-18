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

// Types
typedef struct {
  double hexcrop_side;
  double hexcrop_scatter_area;

  double _hexcrop_h;
  double _hexcrop_a;
  double _hexcrop_b;
  double _hexcrop_c;
  double _hexcrop_n;
  double _hexcrop_s;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("hexcrop");
APO_VARIABLES(
  VAR_REAL(hexcrop_side, 0.5),
  VAR_REAL(hexcrop_scatter_area, 0.0)
);

int PluginVarPrepare(Variation* vp)
{
  const double ang = 0.52359877559829887307710723054658;
  double s, c; fsincos(ang, &s, &c);
    
  vp->var._hexcrop_a = vp->var.hexcrop_side * s;
  vp->var._hexcrop_b = vp->var.hexcrop_side * 0.5;
  vp->var._hexcrop_h = vp->var.hexcrop_side * c;
  vp->var._hexcrop_c = vp->var._hexcrop_b + vp->var._hexcrop_a;
  vp->var._hexcrop_s = vp->var.hexcrop_scatter_area;
  vp->var._hexcrop_n = 0; // for now

  return 1;
}

int PluginVarCalc(Variation* vp)
{ 
  const double ax = -vp->var._hexcrop_b, ay =  vp->var._hexcrop_h;
  const double bx =  vp->var._hexcrop_b, by =  vp->var._hexcrop_h;
  const double cx =  vp->var._hexcrop_c, cy =  vp->var._hexcrop_n;
  const double dx =  vp->var._hexcrop_b, dy = -vp->var._hexcrop_h;
  const double ex = -vp->var._hexcrop_b, ey = -vp->var._hexcrop_h;
  const double fx = -vp->var._hexcrop_c, fy = -vp->var._hexcrop_n;
  const double px = *(vp->pFTx),   py = *(vp->pFTy);
  const double As = vp->var._hexcrop_s;

  inline void fbarycht(
    const double Xx, const double Xy,
    const double Yx, const double Yy,
    const double Ox, const double Oy,
    const double Px, const double Py,
    double* u, double* v) {
            
    const double xx = Xx - Ox, xy = Xy - Oy;
    const double yx = Yx - Ox, yy = Yy - Oy;
    const double px = Px - Ox, py = Py - Oy;
    
    const double dot00 = xx * xx + xy * xy; 
    const double dot01 = xx * yx + xy * yy; 
    const double dot02 = xx * px + xy * py; 
    const double dot11 = yx * yx + yy * yy; 
    const double dot12 = yx * px + yy * py; 
    
    const double denom = (dot00 * dot11 - dot01 * dot01);
    const double num_u = (dot11 * dot02 - dot01 * dot12);
    const double num_v = (dot00 * dot12 - dot01 * dot02);
    
    *u = num_u / denom; 
    *v = num_v / denom;       
  }
  
  int inside = 0;
  double u, v; fbarycht(ax, ay, ex, ey, fx, fy, px, py, &u, &v);
  
  if (u + v > 1) { // escapes AE
    fbarycht(dx, dy, bx, by, cx, cy, px, py, &u, &v);
    
    if (u + v > 1) { // escapes BD
      double dist = random01() * 0.5 * As;
      
      *(vp->pFPx) = vp->vvar * px;
      *(vp->pFPy) = vp->vvar * ((py > ay || py < dy) ? py < dy ? dy + dist * (ay - dy) : ay - dist * (ay - dy) : py);
      
      return 1;
    } else if ((u < 0) || (v < 0)) { // escapes BC or CD
      u = ((u < 0 ? 0 : u > 1 ? 1 : u) + random01() * As);
      v = ((v < 0 ? 0 : v > 1 ? 1 : v) + random01() * As);
      
      *(vp->pFPx) = vp->vvar * (cx + u * (dx - cx) + v * (bx - cx));
      *(vp->pFPy) = vp->vvar * (cy + u * (dy - cy) + v * (by - cy));
      
      return 1;
    }  
  } else if ((u < 0) || (v < 0)) { // escapes AF or AE
    u = ((u < 0 ? 0 : u > 1 ? 1 : u) + random01() * As);
    v = ((v < 0 ? 0 : v > 1 ? 1 : v) + random01() * As);
    
    *(vp->pFPx) = vp->vvar * (fx + u * (ax - fx) + v * (ex - fx));
    *(vp->pFPy) = vp->vvar * (fy + u * (ay - fy) + v * (ey - fy));
    
    return 1;
  } 
  
  *(vp->pFPx) = vp->vvar * px;
  *(vp->pFPy) = vp->vvar * py;
  
  return 1;
  
}
