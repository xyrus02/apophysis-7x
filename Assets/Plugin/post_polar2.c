/*
    Apophysis Plugin

    Copyright (C) 2007-2009 Joel Faber
    Copyright (C) 2007-2009 Michael Faber

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
	double post_polar2_vvar;
	double post_polar2_vvar_2;
} Variables;

#include "apoplugin.h"

// Set the name of this plugin
APO_PLUGIN("post_polar2");
APO_VARIABLES();

int PluginVarPrepare(Variation* vp)
{
	VAR(post_polar2_vvar) = VVAR / M_PI;
	VAR(post_polar2_vvar_2) = VAR(post_polar2_vvar) * 0.5;
    return TRUE;
}
int PluginVarCalc(Variation* vp)
{
	FPy = VAR(post_polar2_vvar_2) * log(FPx*FPx + FPy*FPy);
	FPx = VAR(post_polar2_vvar) * atan2(FPx, FPy);

    return TRUE;
}
