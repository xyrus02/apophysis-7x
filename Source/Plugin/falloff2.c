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
	double x;
	double y;
	double z;
} double3;
typedef struct {
	double x;
	double y;
	double z;
	double c;
} double4;

typedef struct {
    double falloff2_scatter;
    double falloff2_mindist;
	
	double falloff2_mul_x;
	double falloff2_mul_y;
	double falloff2_mul_z;
	double falloff2_mul_c;
	
    double falloff2_x0;
    double falloff2_y0;
	double falloff2_z0;
	
	int falloff2_invert;
	int falloff2_type;

	double4 mul;
	double3 center;
    double d, r_max;
	int invert, type;
} Variables;

#include "apoplugin.h"

//few macros to let me copy-paste MetaCore variation code :)
#define weight (vp->vvar)
#define param(x) (vp->var.x)

#define mind(x, x0) (x<x0?x0:x)
#define maxd(x, x1) (x>x1?x1:x)

#define random_double ((((rand()^(rand()<<15))&0xfffffff)*3.72529e-09)-0.5)

// adjustment coefficients
#define scatter_adjust 0.04

// blur types
#define bt_linear   0
#define bt_radial   1
#define bt_gaussian 2

// i/o mode
#define io_default // io_pre, io_post

APO_PLUGIN("falloff2");
APO_VARIABLES(
    VAR_REAL_RANGE(falloff2_scatter, EPS, DBL_MAX, 1.0),
    VAR_REAL_RANGE(falloff2_mindist, 0.0, DBL_MAX, 0.5),
	
	VAR_REAL_RANGE(falloff2_mul_x, 0.0, 1.0, 1.0),
	VAR_REAL_RANGE(falloff2_mul_y, 0.0, 1.0, 1.0),
	VAR_REAL_RANGE(falloff2_mul_z, 0.0, 1.0, 0.0),
	VAR_REAL_RANGE(falloff2_mul_c, 0.0, 1.0, 0.0),
	
    VAR_REAL(falloff2_x0, 0.0),
    VAR_REAL(falloff2_y0, 0.0),
	VAR_REAL(falloff2_z0, 0.0),
	
	VAR_INTEGER_RANGE(falloff2_invert, 0, 1, 0),
	VAR_INTEGER_RANGE(falloff2_type, 0, 2, 0),
);

int PluginVarPrepare(Variation* vp)
{
	double4 m = { 
		param(falloff2_mul_x), 
		param(falloff2_mul_y), 
		param(falloff2_mul_z),
		param(falloff2_mul_c) }; 
	double3 c = { 
		param(falloff2_x0), 
		param(falloff2_y0), 
		param(falloff2_z0) }; 

	param(r_max) = scatter_adjust * param(falloff2_scatter);
	param(d) = param(falloff2_mindist);
	
	param(mul) = m;
	param(center) = c;
	
	param(invert) = param(falloff2_invert);
	param(type) = param(falloff2_type);

    return 1;
}

int PluginVarCalc(Variation* vp)
{
	const double4 v_in = 
	#ifdef io_post 
		{ *(vp->pFPx), *(vp->pFPy), *(vp->pFPz), *(vp->pColor) };
	#else
		{ *(vp->pFTx), *(vp->pFTy), *(vp->pFTz), *(vp->pColor) };
	#endif
	
	const double3 center = param(center);
	const double4 mul = param(mul);
	
	const double d_0 = param(d);
	const double r_max = param(r_max);
	
	const double4 random = { 
		random_double, random_double, 
		random_double, random_double };
	
	const double dist_a = sqrt( 
		sqr(v_in.x - center.x) +
		sqr(v_in.y - center.y) +
		sqr(v_in.z - center.z));
	const double dist_b = param(invert) != 0 ?
		mind(1 - dist_a, 0) :
		mind(dist_a, 0);
	const double dist = mind((dist_b - d_0) * r_max, 0);
	
	inline double4 __linear() {
		const double4 result = {
			v_in.x + mul.x * random.x * dist,
			v_in.y + mul.y * random.y * dist,
			v_in.z + mul.z * random.z * dist,
			v_in.c + mul.c * random.c * dist };
		return result;
	}
	inline double4 __radial() {
		if (v_in.x == 0 && v_in.y == 0 && v_in.z == 0) 
			return v_in;
			
		const double r_in = sqrt( sqr(v_in.x) + sqr(v_in.y) + sqr(v_in.z) );
		const double sigma = asin( v_in.z / r_in ) + mul.z * random.z * dist;
		const double phi = atan2( v_in.y, v_in.x ) + mul.y * random.y * dist;
		const double r = r_in + mul.x * random.x * dist;
		
		double sigma_s, sigma_c; fsincos(sigma, &sigma_s, &sigma_c);
		double phi_s, phi_c; fsincos(phi, &phi_s, &phi_c);
		
		const double4 result = {
			r * sigma_c * phi_c,
			r * sigma_c * phi_s,
			r * sigma_s,
			v_in.c + mul.c * random.c * dist };
		return result;
	}
	inline double4 __gaussian() {
		const double sigma = dist * random.y * M_2PI;
		const double phi = dist * random.z * M_PI;
		const double rad = dist * random.x; //* sqrt( sqr(v_in.x) + sqr(v_in.y) + sqr(v_in.z) );
		
		double sigma_s, sigma_c; fsincos(sigma, &sigma_s, &sigma_c);
		double phi_s, phi_c; fsincos(phi, &phi_s, &phi_c);
		
		const double4 result = {
			v_in.x + mul.x * rad * sigma_c * phi_c,
			v_in.y + mul.y * rad * sigma_c * phi_s,
			v_in.z + mul.z * rad * sigma_s,
			v_in.c + mul.c * dist * random.c };
		return result;
	}
	
	double4 v_out; switch (param(type)) {
		case bt_linear: 	v_out = __linear(); 	break;
		case bt_radial: 	v_out = __radial(); 	break;
		case bt_gaussian: 	v_out = __gaussian(); 	break;
	}
	
	// write back output vector
	#ifdef io_post
		*(vp->pFPx) = v_out.x * weight;
		*(vp->pFPy) = v_out.y * weight;
		*(vp->pFPz) = v_out.z * weight;
	#else
		#ifdef io_pre
			*(vp->pFTx) = v_out.x * weight;
			*(vp->pFTy) = v_out.y * weight;
			*(vp->pFTz) = v_out.z * weight;
		#else
			*(vp->pFPx) += v_out.x * weight;
			*(vp->pFPy) += v_out.y * weight;
			*(vp->pFPz) += v_out.z * weight;
		#endif
	#endif
	
	// write back output color
	*(vp->pColor) = fabs(fmod(v_out.c, 1.0));
	
    return 1;
}
