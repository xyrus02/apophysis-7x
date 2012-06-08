/*
    Octapol plugin for Apophysis
    Written by Georg K. (http://xyrus02.deviantart.com)

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
	double x;
	double y;
} double2;

#define DOUBLE2(x,y) { x, y }
#define DENOM_SQRT2 0.707106781

typedef struct
{
	double rad, s, t, a;
	double ax, ay, bx, by, cx, cy, 
		   dx, dy, ex, ey, fx, fy,
		   gx, gy, hx, hy, ix, iy,
		   jx, jy, kx, ky, lx, ly;
	
	double octapol_polarweight;
	double octapol_radius;
	double octapol_s;
	double octapol_t;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("octapol");

APO_VARIABLES(
	VAR_REAL(octapol_polarweight, 0.0),
	VAR_REAL(octapol_radius, 1.0),
	VAR_REAL(octapol_s, 0.5),
	VAR_REAL(octapol_t, 0.5)
);

int PluginVarPrepare(Variation* vp)
{
	VAR(s) = fabs(VAR(octapol_s));
	VAR(t) = fabs(VAR(octapol_t));
	VAR(a) = VAR(s) * 0.5 + VAR(t);
	
	VAR(rad) = DENOM_SQRT2 * VAR(s) * fabs(VAR(octapol_radius));
	
	VAR(ax) = -0.5 * VAR(s); VAR(ay) = 0.5 * VAR(s) + VAR(t);	
	VAR(bx) = 0.5 * VAR(s); VAR(by) = 0.5 * VAR(s) + VAR(t);
	VAR(cx) = VAR(t); VAR(cy) = 0.5 * VAR(s);
	VAR(dx) = VAR(t); VAR(dy) = -0.5 * VAR(s);
	VAR(ex) = 0.5 * VAR(s); VAR(ey) = -0.5 * VAR(s) - VAR(t);
	VAR(fx) = -0.5 * VAR(s); VAR(fy) = -0.5 * VAR(s) - VAR(t);
	VAR(gx) = -VAR(t); VAR(gy) = -0.5 * VAR(s);
	VAR(hx) = -VAR(t); VAR(hy) = 0.5 * VAR(s);
	VAR(ix) = -0.5 * VAR(s); VAR(iy) = 0.5 * VAR(s);
	VAR(jx) = 0.5 * VAR(s); VAR(jy) = 0.5 * VAR(s);
	VAR(kx) = -0.5 * VAR(s); VAR(ky) = -0.5 * VAR(s);
	VAR(lx) = 0.5 * VAR(s); VAR(ly) = -0.5 * VAR(s);
	
    return TRUE; 
}

int PluginVarCalc(Variation* vp)
{
	inline double dot(double2 a, double2 b) {
		return a.x * b.x + a.y * b.y;	
	}
	inline double lerp(double a, double b, double p) {
		return a + p * (b - a);	
	}
	inline int hits_rect(double2 tl, double2 br, double2 p) {
		return (p.x >= tl.x && p.y >= tl.y && p.x <= br.x && p.y <= br.y);
	}
	inline int hits_triangle(double2 a, double2 b, double2 c, double2 p, double* u, double* v) {
		double2 v0 = DOUBLE2(c.x - a.x, c.y - a.y);
		double2 v1 = DOUBLE2(b.x - a.x, b.y - a.y);
		double2 v2 = DOUBLE2(p.x - a.x, p.y - a.y);
		
		double d00 = dot(v0, v0);
		double d01 = dot(v0, v1);
		double d02 = dot(v0, v2);
		double d11 = dot(v1, v1);
		double d12 = dot(v1, v2);
		
		double denom = (d00 * d11 - d01 * d01);
		if (denom != 0) {
			*u = (d11 * d02 - d01 * d12) / denom;
			*v = (d00 * d12 - d01 * d02) / denom;
		} else {
			*u = *v = 0;	
		}
		
		return ((*u + *v) < 1.0) && (*u > 0) && (*v > 0);
	}
	inline int hits_square_around_origin(double a, double2 p) {
		return (fabs(p.x) <= a && fabs(p.y) <= a);
	}
	inline int hits_circle_around_origin(double radius, double2 p, double* r) {
		if (radius == 0.0) return TRUE;
		*r = sqrt(sqr(p.x) + sqr(p.y));
		return (*r <= radius);
	}
	
	double x = FTx * 0.15, y = FTy * 0.15, z = FTz, r = 0, u = 0, v = 0, x2 = 0, y2 = 0;
	double2 XY = DOUBLE2(x, y);
	
	double2 A = DOUBLE2(VAR(ax), VAR(ay)), B = DOUBLE2(VAR(bx), VAR(by)), C = DOUBLE2(VAR(cx), VAR(cy)),
			D = DOUBLE2(VAR(dx), VAR(dy)), E = DOUBLE2(VAR(ex), VAR(ey)), F = DOUBLE2(VAR(fx), VAR(fy)),
			G = DOUBLE2(VAR(gx), VAR(gy)), H = DOUBLE2(VAR(hx), VAR(hy)), I = DOUBLE2(VAR(ix), VAR(iy)),
			J = DOUBLE2(VAR(jx), VAR(jy)), K = DOUBLE2(VAR(kx), VAR(ky)), L = DOUBLE2(VAR(lx), VAR(ly));
	
	if ((VAR(rad) > 0) && hits_circle_around_origin(VAR(rad), XY, &r)) {
		double rd = log(sqr(r / VAR(rad)));
		double phi = atan2(y, x);
		FPx += VVAR * lerp(x, phi, rd * VAR(octapol_polarweight)); 
		FPy += VVAR * lerp(y, r, rd * VAR(octapol_polarweight));
	} else if (hits_square_around_origin(VAR(a), XY)) {
		if (hits_rect(H, K, XY) || hits_rect(J, D, XY) ||
		    hits_rect(A, J, XY) || hits_rect(K, E, XY) ||
		    hits_triangle(I, A, H, XY, &u, &v) || 
			hits_triangle(J, B, C, XY, &u, &v) ||
		    hits_triangle(L, D, E, XY, &u, &v) || 
			hits_triangle(K, F, G, XY, &u, &v)) {
			FPx += VVAR * x; FPy += VVAR * y;
		} else FPx = FPy = 0;
	} else FPx = FPy = 0;
	
	FPx += VVAR * x; 
	FPy += VVAR * y;
	FPz += VVAR * z;
    return TRUE;
}
