/*
    Apophysis Plugin
    (C) 2007 Joel Faber

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

#ifndef _APOPLUGIN_H_
#define _APOPLUGIN_H_

#include <malloc.h>
#include <math.h>
#include <time.h>
#include <string.h>
#include <limits.h>
#include <float.h>

#ifndef TRUE
#define TRUE (1)
#define FALSE (0)
#endif

/* The following ahve been defined in math.h:
    M_E		    2.7182818284590452354
    M_LOG2E		1.4426950408889634074
    M_LOG10E	0.43429448190325182765
    M_LN2		0.69314718055994530942
    M_LN10		2.30258509299404568402
    M_PI		3.14159265358979323846
    M_PI_2		1.57079632679489661923
    M_PI_4		0.78539816339744830962
    M_1_PI		0.31830988618379067154
    M_2_PI		0.63661977236758134308
    M_2_SQRTPI	1.12837916709551257390
    M_SQRT2		1.41421356237309504880
    M_SQRT1_2	0.70710678118654752440
*/

// Define a few more that might be commonly used:
#define M_2PI       6.283185307179586476925286766559
#define M_3PI_4     2.3561944901923449288469825374596
#define M_SQRT3     1.7320508075688772935274463415059
#define M_SQRT3_2   0.86602540378443864676372317075249
#define M_SQRT5     2.2360679774997896964091736687313
#define M_PHI       1.61803398874989484820458683436563 // Goldon ratio
#define M_1_2PI     0.15915494309189533576888376337251

#define EPS 1.0e-20

#define MAX(a, b) ((a) > (b) ? (a) : (b))

# define DLLIMPORT __declspec (dllexport)

typedef enum
{
    REAL,
    REAL_CYCLIC,
    INTEGER,
    INTEGER_NONZERO
} VarType;

typedef union
{
    int i;
    double d;
} IntOrDouble;

typedef struct
{
    const char* name;
    const VarType type;
    int offset;
    IntOrDouble min;
    IntOrDouble max;
    IntOrDouble def;
} VariableInfo;

VariableInfo VarInfo[];
const char* VariationName;
const int NumVariables;

double dummyFTz, dummyFPz, dummyColor;

/*************** Variation variable code ***************/

typedef struct
{
	double vvar;
	double* pFTx;
    double* pFTy;
    double* pFTz;
	double* pFPx;
    double* pFPy;
    double* pFPz;
    double* pColor;
    double a, b, c, d, e, f;
	Variables var;
} Variation;

#define OFFSET(name) ((int) &(((Variables*) 0)->name))

#define INT_LVALUE(varptr, info)    ( *((int*)    (((int) &((varptr)->var)) + (info).offset)))
#define DOUBLE_LVALUE(varptr, info) ( *((double*) (((int) &((varptr)->var)) + (info).offset)))
#define VALUE(varptr, info) ( (info).type >= INTEGER ? INT_LVALUE(varptr, info) : DOUBLE_LVALUE(varptr, info) )


#define APO_VARIABLES(...) VariableInfo VarInfo[] = {__VA_ARGS__};       \
        const int NumVariables = sizeof(VarInfo) / sizeof(VariableInfo)

#define VAR_REAL(nm, def) { #nm, REAL, OFFSET(nm), (IntOrDouble) -DBL_MAX, (IntOrDouble) DBL_MAX, (IntOrDouble) (def) }
#define VAR_INTEGER(nm, def) { #nm, INTEGER, OFFSET(nm), (IntOrDouble) INT_MIN, (IntOrDouble) INT_MAX, (IntOrDouble) (def) }
#define VAR_REAL_RANGE(nm, min, max, def) {#nm, REAL, OFFSET(nm), (IntOrDouble) (min), (IntOrDouble) (max), (IntOrDouble) (def) }
#define VAR_INTEGER_RANGE(nm, min, max, def) {#nm, INTEGER, OFFSET(nm), (IntOrDouble) (min), (IntOrDouble) (max), (IntOrDouble) (def) }
#define VAR_INTEGER_NONZERO(nm, def) {#nm, INTEGER_NONZERO, OFFSET(nm), (IntOrDouble) INT_MIN, (IntOrDouble) INT_MAX, (IntOrDouble) (def) }
#define VAR_REAL_CYCLE(nm, min, max, def) {#nm, REAL_CYCLIC, OFFSET(nm), (IntOrDouble) (min), (IntOrDouble) (max), (IntOrDouble) (def) }

#define INTDOUBLE(intordouble, type) ((type) >= INTEGER ? (intordouble).i : (intordouble).d)

// Convert the variable to a double
#define DBL_VALUE(intordouble, type) ( (type) >= INTEGER ? ((double) (intordouble).i) : (intordouble).d )

/*************** Declarations for .C file ***************/
/* These functions must be defined in the variation .c file. */
DLLIMPORT int   PluginVarPrepare(Variation* vp);
DLLIMPORT int   PluginVarCalc(Variation* vp);

// Useful defines for the Prepare and Calc functions.  Makes the code easier
// on the coder, but requires him/her to call the variation pointer "vp".
#define FTx (*(vp->pFTx))
#define FTy (*(vp->pFTy))
#define FTz (*(vp->pFTz))
#define FPx (*(vp->pFPx))
#define FPy (*(vp->pFPy))
#define FPz (*(vp->pFPz))
#define VAR(name) (vp->var.name)
#define VVAR (vp->vvar)

// Defines for DirectColor (TC = Transform color, TM = TransformMatrix - name is a-f)
#define TC  (*(vp->pColor))
#define TM(name) (vp->name)

/*************** Additional Function Prototypes ***************/
DLLIMPORT int PluginVarResetVariable(void* VariationPtr, const char* name);

/*************** Variation information code ***************/
#define APO_PLUGIN(x) const char* VariationName = x

DLLIMPORT const char* PluginVarGetName(void)
{
    return VariationName;
}

DLLIMPORT int PluginVarGetNrVariables(void)
{
    return NumVariables;
}

/*************** Plugin Creation, Destruction & Initialization ***************/
DLLIMPORT void* PluginVarCreate(void)
{
    int i;
	Variation* vp = (Variation*) calloc(1, sizeof(Variation));

	// reset every variable to the default value.
    for (i = 0 ; i < NumVariables; i++)
    {
        PluginVarResetVariable(vp, VarInfo[i].name);
    }

	return vp;
}

DLLIMPORT int PluginVarDestroy(void** vpp)
{
    if (vpp && *vpp)
    {
        free(*vpp);
        *vpp = NULL;
        return TRUE;
    }

    return FALSE;
}

DLLIMPORT int PluginVarInit(void* varptr, void* pFPx, void* pFPy, void* pFTx, void* pFTy, double vvar)
{
    Variation* vp = (Variation*) varptr;

    if (vp == NULL)
        return FALSE;
    vp->pFPx = (double*) pFPx;
    vp->pFPy = (double*) pFPy;
    vp->pFTx = (double*) pFTx;
    vp->pFTy = (double*) pFTy;

    // Dummy values... must call PluginVarInit3D to set the
    // pointers to addresses that Apophysis knows about.
    vp->pFTz = &dummyFTz;
    vp->pFPz = &dummyFPz;
    vp->pColor = &dummyColor;
    dummyFTz = 0;
    dummyFPz = 0;
    
    // dummies for DC
    dummyColor = 0;
    vp->a = vp->d = 1;
    vp->b = vp->c = vp->e = vp->f = 0;

    vp->vvar = vvar;

    return TRUE;
}

DLLIMPORT int PluginVarInit3D(void* varptr, void* pFPx, void* pFPy, void* pFPz, void* pFTx, void* pFTy, void* pFTz, double vvar)
{
    Variation* vp = (Variation*) varptr;

    if (vp == NULL)
        return FALSE;
    vp->pFPx = (double*) pFPx;
    vp->pFPy = (double*) pFPy;
    vp->pFPz = (double*) pFPz;
    vp->pFTx = (double*) pFTx;
    vp->pFTy = (double*) pFTy;
    vp->pFTz = (double*) pFTz;
    vp->pColor = &dummyColor;
    vp->vvar = vvar;
    
    // dummies for DC
    dummyColor = 0;
    vp->a = vp->d = 1;
    vp->b = vp->c = vp->e = vp->f = 0;

    return TRUE;
}

// DirectColor support for Apo7X
DLLIMPORT int PluginVarInitDC(void* varptr, void* pFPx, void* pFPy, void* pFPz, void* pFTx, void* pFTy, void* pFTz, void* pColor, double vvar, double a, double b, double c, double d, double e, double f)
{
    Variation* vp = (Variation*) varptr;

    if (vp == NULL)
        return FALSE;
    vp->pFPx = (double*) pFPx;
    vp->pFPy = (double*) pFPy;
    vp->pFPz = (double*) pFPz;
    vp->pFTx = (double*) pFTx;
    vp->pFTy = (double*) pFTy;
    vp->pFTz = (double*) pFTz;
    vp->vvar = vvar;
    
    vp->pColor = (double*) pColor;
    vp->a = a; vp->b = b; vp->c = c;
    vp->d = d; vp->e = e; vp->f = f;

    return TRUE;
}

DLLIMPORT int PluginVarGetVariable(void* VariationPtr, const char* name, double* value)
{
    int i;
    Variation* var;

    if ((var = (Variation*) VariationPtr) == 0)
        return FALSE;

    for (i = 0 ; i < NumVariables; i++)
    {
        if (strcmp(VarInfo[i].name, name) == 0)
        {
            *value = (double) VALUE(var, VarInfo[i]);
            return TRUE;
        }
    }

    return FALSE;
}

DLLIMPORT int PluginVarSetVariable(void* VariationPtr, const char* name, double* value)
{
    int i;
    Variation* var;

    if ((var = (Variation*) VariationPtr) == 0)
        return FALSE;

    for (i = 0 ; i < NumVariables; i++)
    {
        if (strcmp(VarInfo[i].name, name) == 0)
        {
            int v = 0;

            switch (VarInfo[i].type)
            {
            case REAL :
                DOUBLE_LVALUE(var, VarInfo[i]) = fmax(fmin(*value, VarInfo[i].max.d), VarInfo[i].min.d);
                break;
            case REAL_CYCLIC :
                if (*value > VarInfo[i].max.d)
                    DOUBLE_LVALUE(var, VarInfo[i]) = VarInfo[i].min.d + fmod(*value - VarInfo[i].min.d, VarInfo[i].max.d - VarInfo[i].min.d);
                else if (*value < VarInfo[i].min.d)
                    DOUBLE_LVALUE(var, VarInfo[i]) = VarInfo[i].max.d - fmod(VarInfo[i].max.d - *value, VarInfo[i].max.d - VarInfo[i].min.d);
                else
                    DOUBLE_LVALUE(var, VarInfo[i]) = *value;
                break;
            case INTEGER :
                INT_LVALUE(var, VarInfo[i]) = (int) fmax(fmin(floor(*value + 0.5), VarInfo[i].max.i), VarInfo[i].min.i);
                break;
            case INTEGER_NONZERO :
                v = (int) fmax(fmin(floor(*value + 0.5), VarInfo[i].max.i), VarInfo[i].min.i);
                if (v == 0)
                    v = 1;
                INT_LVALUE(var, VarInfo[i]) = v;
                break;
            }

            return TRUE;
        }
    }

    return FALSE;
}

DLLIMPORT int PluginVarResetVariable(void* VariationPtr, const char* name)
{
    int i;
    Variation* var;

    if ((var = (Variation*) VariationPtr) == 0)
        return FALSE;

    for (i = 0 ; i < NumVariables; i++)
    {
        if (strcmp(VarInfo[i].name, name) == 0)
        {
            switch (VarInfo[i].type)
            {
            case REAL :
            case REAL_CYCLIC :
                DOUBLE_LVALUE(var, VarInfo[i]) = VarInfo[i].def.d;
                break;
            case INTEGER :
            case INTEGER_NONZERO :
                INT_LVALUE(var, VarInfo[i]) = VarInfo[i].def.i;
                break;
            }

            return TRUE;
        }
    }

    return FALSE;
}

DLLIMPORT const char* PluginVarGetVariableNameAt(int index)
{
    if (index >= 0 && index < NumVariables)
        return VarInfo[index].name;

    return "";
}

/*************** Utility functions ***************/

/* Calculate both the sine and cosine of an angle theta (in radians). */
inline void fsincos(double theta, double* s, double* c)
{
#if !defined(NO_ASM) && defined(__GNUC__)
  __asm__ (
    "fsincos\n\t"
    : "=t" (*c), "=u" (*s)
    : "0" (theta)
  );
#elif !defined(NO_ASM) && defined(_MSC_VER)
  __asm {
    fld QWORD PTR theta
    fsincos
    mov ebx,[c]
    fstp QWORD PTR [ebx]
    mov ebx,[s]
    fstp QWORD PTR [ebx]
  }
#else
  /* Fall back to individual calls to sin/cos. To enforce this, define
     NO_ASM in the plugin code prior to including this header file.  */
  *s = sin(theta);
  *c = cos(theta);
#endif
}

// Calculating hyperbolic functions is slow.  Calculate exp(u) once and use
// the result to calculate cosh(t) and sinh(t).
//     cosh(t) = (exp(t) + exp(-t)) / 2
//     sinh(t) = (exp(t) - exp(-t)) / 2
inline void sinhcosh(double theta, double* sh, double* ch)
{
    double expt = exp(theta);
    double exptinv = 1.0 / expt;
    *sh = (expt - exptinv) * 0.5;
    *ch = (expt + exptinv) * 0.5;
}

/* Calculate a random number between 0 and 1.  From flam3 source code. */
inline double random01()
{
    return ((rand() ^ (rand()<<15)) & 0xfffffff) / (double) 0xfffffff;
}

inline double sqr(double x)
{
    return x*x;
}

#endif /* _APOPLUGIN_H_ */

