/*
    Apophysis Plugin
    
    Mandelbrot Set Plugin v2 - Copyright 2008,2009 Jed Kelsey
    Changed to work with Apophysis 7X / DC in 2010 by Georg Kiehne
    
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
	int dcm_iter;
	int dcm_miniter;
	int dcm_smooth_iter;
	int dcm_retries;
	int dcm_mode;
	int dcm_pow;
	int dcm_color_method;
	double dcm_invert;
	double dcm_xmin;
	double dcm_xmax;
	double dcm_ymin;
	double dcm_ymax;
	double dcm_scatter;
	double dcm_sx;
	double dcm_sy;
	double dcm_zscale;

	double x0, y0;
	double zs, sc;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("dc_mandelbrot");
APO_VARIABLES(
    VAR_INTEGER_RANGE(dcm_iter, 5, INT_MAX, 25),
    VAR_INTEGER_RANGE(dcm_miniter, 0, INT_MAX, 1),
    VAR_INTEGER_RANGE(dcm_smooth_iter, 0, INT_MAX, 0),
    VAR_INTEGER_RANGE(dcm_retries, 0, INT_MAX, 50),
    VAR_INTEGER_RANGE(dcm_mode, 0, 5, 0),
    VAR_INTEGER_RANGE(dcm_pow, -6, 6, 2), // TODO: negative powers
    VAR_INTEGER_RANGE(dcm_color_method, 0, 7, 0),
    VAR_REAL_RANGE(dcm_invert, 0.0, 1.0, 0.0),
    VAR_REAL(dcm_xmin, -2.0),
    VAR_REAL(dcm_xmax, 2.0),
    VAR_REAL(dcm_ymin, -1.5),
    VAR_REAL(dcm_ymax, 1.5),
    VAR_REAL_RANGE(dcm_scatter, -1000.0, 1000.0, 0.0),
    
    // Following parameters don't affect iterations, just the output point positions.
    VAR_REAL(dcm_sx, 0.0),
    VAR_REAL(dcm_sy, 0.0),
    VAR_REAL(dcm_zscale, 0.0)
);

int PluginVarPrepare(Variation* vp)
{
	VAR(zs) = VVAR * VAR(dcm_zscale) / VAR(dcm_iter);
    VAR(sc) = VAR(dcm_scatter) / 10.0;
	return TRUE;
}

int PluginVarCalc(Variation* vp)
{
	inline double fmod2(double h, double q) { return fmod(fabs(h),q); }

	double x=0.0, y=0.0, x1=0.0, y1=0.0, x2, y2, xtemp=0.0;
	double cx=0.0, cy=0.0;
	
	int maxiter = VAR(dcm_iter);
	int miniter = VAR(dcm_miniter); // = 0.1*(maxiter*(1-scatter));
	
	double xmax = VAR(dcm_xmax);
	double xmin = VAR(dcm_xmin);
	double ymax = VAR(dcm_ymax);
	double ymin = VAR(dcm_ymin);
	
	int maxRetries = VAR(dcm_retries);
	int mode = VAR(dcm_mode); /* 0=Mandelbrot, 1=Julia, 3=Tricorn(Mandelbar) */

	int color_method = VAR(dcm_color_method);
	double xp = 0.0, yp = 0.0;

	int smooth_iter=0, max_smooth_iter=VAR(dcm_smooth_iter);
	int inverted, iter=0, retries=0;
	int isblur = (VAR(sc)>=0);
	
	double smoothed_iter = 0.0, inv_iter = 1.0;
	double mag2 = 0.0;
	
	int m_power = VAR(dcm_pow);
	int m_power_abs = ((m_power<0) ? -m_power : m_power);

	inverted = random01() < VAR(dcm_invert);

	if (!isblur) {
		VAR(x0) = FTx;
		VAR(y0) = FTy;
	}

	do {
		if (VAR(sc)==0) {
			// Force selection of point at random
			VAR(x0) = VAR(y0) = 0;
		}

		if (VAR(x0)==0 && VAR(y0)==0) {
			// Choose a point at random
			VAR(x0) = (xmax-xmin)*random01() + xmin;
			VAR(y0) = (ymax-ymin)*random01() + ymin;
		} else {
			// Choose a point close to previous point
			VAR(x0) += VAR(sc)*(random01()-0.5);
			VAR(y0) += VAR(sc)*(random01()-0.5);
		}

		// default to Mandelbrot Set
		cx = x1 = x = xp = VAR(x0);
		cy = y1 = y = yp = VAR(y0);

		switch(mode) {
            case 1: // Julia Set
                cx = TM(e);
		        cy = TM(f);
		        break;
			case 2: // tricorn (Mandelbar)
				// leave as-is, handled below
				break;
			default: // Regular Mandelbrot set
				// Leave as-is
				break;
		}

		iter = smooth_iter = 0;

		while ( (((x2=x*x) + (y2=y*y) < 4) && (iter < maxiter)) || (smooth_iter++<max_smooth_iter) ) {
			if (smooth_iter==0)
				xp=x; yp=y;

			if (mode==2) y=-y;

			switch(m_power_abs) {
				case 3:
					xtemp = x*(x2 - 3*y2) + cx;
					y = y*(3*x2 - y2) + cy;
					x = xtemp;
					break;
				case 4:
					xtemp = (x2-y2)*(x2-y2)-4*x2*y2 + cx;
					y = 4*x*y*(x2 - y2) + cy;
					x = xtemp;
					break;
				case 5:
					xtemp = x2*x2*x - 10*x2*x*y2 + 5*x*y2*y2 + cx;
					y = 5*x2*x2*y - 10*x2*y2*y + y2*y2*y + cy;
					x = xtemp;
					break;
				case 6:
					xtemp = x2*x2*x2 - 15*x2*x2*y2 + 15*x2*y2*y2 - y2*y2*y2 + cx;
					y = 6*x2*x2*x*y - 20*x2*x*y2*y + 6*x*y2*y2*y + cy;
					x = xtemp;
					break;
				case 1:
					if ((m_power>0) && (iter<maxiter)) // (more iterations not helpful)
						iter = maxiter-1;
					break;
				case 2:
				default:
					xtemp = x2 - y2 + cx;
					y = 2*x*y + cy;
					x = xtemp;
					break;
			}

			if ((m_power<0) && (xtemp=x2+y2)>0) {
				x = x/xtemp;
				y = -y/xtemp;
			}

			iter++;
		}

		iter -= (smooth_iter-1);

		// could probably bypass check and always select next point at random
		if ( (miniter==0) || (!inverted && (iter>=maxiter)) /*|| (iter < miniter)*/ ) {
			VAR(x0) = VAR(y0) = 0; // Random point next time
		} else if ( (iter < miniter) || (inverted && (iter<maxiter/2)) ) {
			//if (retries>maxRetries-5) {
			//   VAR(x0) /= 100;
			//   VAR(y0) /= 100;
			//} else
			VAR(x0) = VAR(y0) = 0;
		}

		if (++retries > maxRetries)
			break;

	} while ((inverted && (iter < maxiter)) || (!inverted && ((iter >= maxiter) || ((miniter>0) && (iter < miniter)))));

	smoothed_iter = iter;
	if (max_smooth_iter>0) {
		// use Normalized Iteration Count Algorithm for smoothing
		mag2 = x2 + y2;
		if (mag2 > 1.1) //FIXME: change this back to if(mag2>4) ?
			smoothed_iter += 1 - log(log(mag2)/2)/M_LN2;
	}
	if (smoothed_iter>0)
		inv_iter = 1/smoothed_iter;
	else
		inv_iter = 1;

	// Adjust location of point according to sx,sy and final iterated point (x,y)
	// (use of inv_iter reduces effect of factor near regions of high gradient
	FPx += VVAR*(x1 + VAR(dcm_sx)*x*inv_iter);
	FPy += VVAR*(y1 + VAR(dcm_sy)*y*inv_iter);
	//FPx += VVAR*(x1 + VAR(dcm_sx)*x);
	//FPy += VVAR*(y1 + VAR(dcm_sy)*y);

	// TODO: add check to see whether this Apo supports 3D?
	if (VAR(dcm_zscale)) {
		FPz += smoothed_iter * VAR(zs);
	}

	// Allow plugin to influence coloring (-X- changed for Apo7X/DC)

	if (smoothed_iter<0) smoothed_iter=0;
	if (smoothed_iter>maxiter) smoothed_iter=maxiter;

	switch (color_method) {

		case 1: 
			// scale colormap indexing extent by the final angle of the iterated point 
			// after the extra "smoothing" iterations complete
			xtemp = 0.0;
			if (y != 0.0) xtemp = atan2(x,y) * M_1_2PI;
			TC = fmod2(xtemp, 1);
			break;
		case 2: 
			// scale colormap indexing extent by the angle of the iterated point at time of escape
			xtemp = 0.0;
			if (yp != 0.0) xtemp = atan2(xp,yp) * M_1_2PI;
			TC = fmod2(xtemp, 1);
			break;
		case 3: 
			// combination of mode 4 and 2
			xtemp = 0.0;
			if (y-yp != 0.0) xtemp = atan2(x-xp,y-yp) * M_1_2PI;
			TC = fmod2((smoothed_iter/maxiter * xtemp), 1);
			break;
		case 4: 
			// scale colormap indexing extent by the product of the scaled iteration count and 
			// the angle of the iterated point at time of escape
			xtemp = 0.0;
			if (yp != 0.0) xtemp = atan2(xp,yp) * M_1_2PI;
			TC = fmod2((smoothed_iter/maxiter * xtemp), 1);
			break;
		case 5: 
			// scale colormap indexing extent by a combination of scaled iteration count, 
			// the squared magnitude and adjusted angle of the iterated point at time of escape
			xtemp = 0.0;
			if (yp != 0.0) xtemp = (0.5 + atan2(xp,yp) * M_1_2PI) * (xp*xp+yp*yp);
			TC = fmod2((smoothed_iter/maxiter * xtemp), 1);
			break;
		case 6: 
			// scale colormap indexing extent by a combination of scaled iteration count and 
			// the squared magnitude of the iterated point at time of escape
			xtemp = xp*xp+yp*yp;
			TC = fmod2((smoothed_iter/maxiter * xtemp), 1);
			break;
		case 7: 
			// scale colormap indexing extent by a combination of scaled iteration count and 
			// the squared magnitude of the iterated point at time of escape
			// (slightly more relaxed color rolloff than case 6)
			xtemp = sqrt(xp*xp+yp*yp);
			TC = fmod2((smoothed_iter/maxiter * xtemp), 1);
			break;
		case 0: 
			// default coloring method: scale colormap indexing extent by the scaled "escape time" 
			// (iteration count)
		default:
			TC = fmod2(smoothed_iter/maxiter, 1);
			break;
	}

	return TRUE;
}
