typedef struct
{
	// variables
    double ripple_frequency,
    	   ripple_velocity,
    	   ripple_amplitude,
    	   ripple_centerx,
    	   ripple_centery,
    	   ripple_phase,
    	   ripple_scale;
    	   
	// private stuff
    double f, a, p, s, is,
		   vxp, pxa, pixa;
} Variables;

#include "apoplugin.h"

APO_PLUGIN("ripple");
APO_VARIABLES(
	// wave function frequency
    VAR_REAL(ripple_frequency, 2.0),
    
    // wave velocity
    VAR_REAL(ripple_velocity, 1.0),
    
    // wave amplitude
    VAR_REAL(ripple_amplitude, 0.5),
    
    // origin of the ripple (x,y)
    VAR_REAL(ripple_centerx, 0.0),
    VAR_REAL(ripple_centery, 0.0),
    
    // wave phase / interpolation coefficient
    VAR_REAL(ripple_phase, 0.0),
    
    // ripple scale
    VAR_REAL(ripple_scale, 1.0)
);

int PluginVarPrepare(Variation* vp)
{
	// some variables are settled in another range for edit comfort
	// - transform them
	VAR(f) = VAR(ripple_frequency) * 5;
	VAR(a) = VAR(ripple_amplitude) * 0.01;
	VAR(p) = VAR(ripple_phase) * M_2PI - M_PI; 
	
	// scale must not be zero
	VAR(s) = VAR(ripple_scale) == 0 ? EPS : VAR(ripple_scale);
	
	// we will need the inverse scale
	VAR(is) = 1 / VAR(s);
	
	// pre-multiply velocity+phase, phase+amplitude and (PI-phase)+amplitude
	VAR(vxp) = VAR(ripple_velocity) * VAR(p);
	VAR(pxa) = VAR(p) * VAR(a);
	VAR(pixa) = (M_PI - VAR(p)) * VAR(a);
	
	// done
    return TRUE; 
}

int PluginVarCalc(Variation* vp)
{
	// linear interpolation
	inline double lerp(double a, double b, double p) 
		{ return a + (b - a) * p; }
	
	//align input x, y to given center and multiply with scale
    double x = (FTx * VAR(s)) - VAR(ripple_centerx),
           y = (FTy * VAR(s)) + VAR(ripple_centery);
           
    // calculate distance from center but constrain it to EPS
    double d = MAX(EPS, sqrt(sqr(x) * sqr(y)));
    
    // normalize (x,y)
    double nx = x / d, 
	       ny = y / d;
	       
	// calculate cosine wave with given frequency, velocity 
	// and phase based on the distance to center
    double wave = cos(VAR(f) * d - VAR(vxp));
    
    // calculate the wave offsets
    double d1 = wave * VAR(pxa) + d,
   		   d2 = wave * VAR(pixa) + d;
   		   
   	// we got two offsets, so we also got two new positions (u,v)
    double u1 = (VAR(ripple_centerx) + nx * d1),
    	   v1 = (-VAR(ripple_centery) + ny * d1);
    double u2 = (VAR(ripple_centerx) + nx * d2),
    	   v2 = (-VAR(ripple_centery) + ny * d2);
    
    // interpolate the two positions by the given phase and
    // invert the multiplication with scale from before
    FPx = VVAR * (lerp(u1, u2, VAR(p))) * VAR(is);
    FPy = VVAR * (lerp(v1, v2, VAR(p))) * VAR(is);
    
    // done
    return TRUE;
}
