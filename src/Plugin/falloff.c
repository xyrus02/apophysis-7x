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
	
	Copyright (c) 2011 Georg Kiehne
*/

// Partially adapted from "falloff" variation from MetaCore V0.9.23.17

typedef struct {
	int falloff_mode;

    double falloff_scatter;
    double falloff_mindist;
	
	double falloff_mul_x;
	double falloff_mul_y;
	double falloff_mul_z;
	
    double falloff_x0;
    double falloff_y0;
	double falloff_z0;
	
	int falloff_invert;
	int falloff_type;
	int falloff_boxpow;

    double falloff_internal_scatter;
} Variables;

#include "apoplugin.h"

//few macros to let me copy-paste MetaCore variation code :)
#define weight (vp->vvar)
#define param(x) (vp->var.x)

#define vari int
#define vard double
#define defi const vari
#define defd const vard

#define does(x) (x != 0)
#define mind(x, x0) (x<x0?x0:x)
#define maxd(x, x1) (x>x1?x1:x)
#define clampd(x, x0, x1) maxd(x0,mind(x,x1))
#define lerpd(x, a, b) (a + x * (b - a))
#define random_double ((((rand()^(rand()<<15))&0xfffffff)*3.72529e-09)-0.5)

// adjustment coefficients
#define scatter_adjust 0.04

// blur types
#define bt_linear 0
#define bt_radial 1
#define bt_box    2

// i/o modes
#define io_default 0
#define io_pre     1
#define io_post    2

APO_PLUGIN("falloff");
APO_VARIABLES(
	VAR_INTEGER_RANGE(falloff_mode, 0, 2, 0),

    VAR_REAL_RANGE(falloff_scatter, EPS, DBL_MAX, 1.0),
    VAR_REAL_RANGE(falloff_mindist, 0.0, DBL_MAX, 0.5),
	
	VAR_REAL_RANGE(falloff_mul_x, 0.0, 1.0, 1.0),
	VAR_REAL_RANGE(falloff_mul_y, 0.0, 1.0, 1.0),
	VAR_REAL_RANGE(falloff_mul_z, 0.0, 1.0, 0.0),
	
    VAR_REAL(falloff_x0, 0.0),
    VAR_REAL(falloff_y0, 0.0),
	VAR_REAL(falloff_z0, 0.0),
	
	VAR_INTEGER_RANGE(falloff_invert, 0, 1, 0),
	VAR_INTEGER_RANGE(falloff_type, 0, 2, 0),
	VAR_INTEGER_RANGE(falloff_boxpow, 2, 32, 0)
);

int PluginVarPrepare(Variation* vp)
{
	vp->var.falloff_internal_scatter = scatter_adjust * vp->var.falloff_scatter;

    return 1;
}

int PluginVarCalc(Variation* vp)
{
	defi mode = param(falloff_mode);
	
	defd x_in = mode == io_post ? *(vp->pFPx) : *(vp->pFTx);
	defd y_in = mode == io_post ? *(vp->pFPy) : *(vp->pFTy);
	defd z_in = mode == io_post ? *(vp->pFPz) : *(vp->pFTz);
	
	defd x0 = param(falloff_x0);
	defd y0 = param(falloff_y0);
	defd z0 = param(falloff_z0);
	
	defd d = param(falloff_mindist);
	defd s = param(falloff_internal_scatter);
	
	defi i = param(falloff_invert);

	defd rx = param(falloff_mul_x);
	defd ry = param(falloff_mul_y);
	defd rz = param(falloff_mul_z);
	
	defd ax = random_double;
	defd ay = random_double;
	defd az = random_double;
	
	defd r = (sqrt(sqr(x_in-x0)+sqr(y_in-y0)+sqr(z_in-z0)));
	defd rc = ((does(i)?mind(1-r,0):mind(r,0))-d)*s;
	defd rs = mind(rc,0);
	
	vard sigma, phi, rad, sigma_s, sigma_c, phi_s, phi_c;
	vard x_out, y_out, z_out, scale, denom, bp;
	
	switch (param(falloff_type)) {
		case bt_radial:
			sigma = asin(r==0?0:z_in/r)+rz*az*rs;
			phi = atan2(y_in,x_in)+ry*ay*rs;
			rad = r+rx*ax*rs;
			
			fsincos(sigma, &sigma_s, &sigma_c);
			fsincos(phi, &phi_s, &phi_c);
		
			x_out = weight * (rad * sigma_c * phi_c);
			y_out = weight * (rad * sigma_c * phi_s);
			z_out = weight * (rad * sigma_s);
			break;
		case bt_box:
			scale = clampd(rs, 0, 0.9) + 0.1; denom = 1.0 / scale; bp = param(falloff_boxpow);
			x_out = weight * lerpd(rx * rs, x_in, floor(x_in * denom) + scale * ax) + rx * pow(ax, bp) * rs * denom;
			y_out = weight * lerpd(ry * rs, y_in, floor(y_in * denom) + scale * ay) + ry * pow(ay, bp) * rs * denom;
			z_out = weight * lerpd(rz * rs, z_in, floor(z_in * denom) + scale * az) + rz * pow(az, bp) * rs * denom;
			break;
		default: // bt_linear
			x_out = weight * (x_in + rx * ax * rs);
			y_out = weight * (y_in + ry * ay * rs);
			z_out = weight * (z_in + rz * az * rs);
			break;
	}
	
	switch (mode) {
		case io_post:
			*(vp->pFPx) = x_out;
			*(vp->pFPy) = y_out;
			*(vp->pFPz) = z_out;
			break;
		case io_pre:
			*(vp->pFTx) = x_out;
			*(vp->pFTy) = y_out;
			*(vp->pFTz) = z_out;
			break;
		default: // io_default
			*(vp->pFPx) += x_out;
			*(vp->pFPy) += y_out;
			*(vp->pFPz) += z_out;
			break;
	}
	
    return 1;
}
