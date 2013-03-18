/*
    Apophysis Plugin

    Copyright (C) 2007-2008 Michael Faber
    Copyright (C) 2007-2008 Joel Faber

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

// Must define this structure before we include apoplugin.h
typedef struct
{
} Variables;

#include "apoplugin.h"

// Set the name of this plugin
APO_PLUGIN("dc_gridout");

// Define the Variables
APO_VARIABLES(
);

// You must call the argument "vp".
int PluginVarPrepare(Variation* vp)
{
    return TRUE; // Always return TRUE.
}

// You must call the argument "vp".
int PluginVarCalc(Variation* vp)
{
	double x = rint(FTx);
	double y = rint(FTy);
	double c = TC;

	if (y <= 0.0)
	{
		if (x > 0.0)
		{
			if (-y >= x)
			{
				FPx += VVAR * (FTx + 1.0);
				FPy += VVAR * FTy;
				c += 0.25;
			}
			else
			{
				FPx += VVAR * FTx;
				FPy += VVAR * (FTy + 1.0);
				c += 0.75;
			}
		}
		else
		{
			if (y <= x)
			{
				FPx += VVAR * (FTx + 1.0);
				FPy += VVAR * FTy;
				c += 0.25;
			}
			else
			{
				FPx += VVAR * FTx;
				FPy += VVAR * (FTy - 1.0);
				c += 0.75;
			}
		}
	}
	else
	{
		if (x > 0.0)
		{
			if (y >= x)
			{
				FPx += VVAR * (FTx - 1.0);
				FPy += VVAR * FTy;
				c += 0.25;
			}
			else
			{
				FPx += VVAR * FTx;
				FPy += VVAR * (FTy + 1.0);
				c += 0.75;
			}
		}
		else
		{
			if (y > -x)
			{
				FPx += VVAR * (FTx - 1.0);
				FPy += VVAR * FTy;
				c += 0.25;
			}
			else
			{
				FPx += VVAR * FTx;
				FPy += VVAR * (FTy - 1.0);
				c += 0.75;
			}
		}
	}
	
	TC = fmod(c, 1.0);

    return TRUE;
}
