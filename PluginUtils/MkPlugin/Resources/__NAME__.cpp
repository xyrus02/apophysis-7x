/*
    Apophysis Plugin: <%NAME%>

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

#define LIFETIME_EVENTS // Enables PluginVarInitialize & PluginVarTerminate

typedef struct
{
    double <%NAME%>_real;
	double <%NAME%>_real_range;
	double <%NAME%>_real_cycle;

	int <%NAME%>_integer;
	int <%NAME%>_integer_range;
	int <%NAME%>_integer_nonzero;

} Variables;

#include "plugin.h"

APO_PLUGIN("<%NAME%>");
APO_VARIABLES(
	VAR_REAL(<%NAME%>_real, /* default: */ 0.0),
	VAR_REAL_RANGE(<%NAME%>_real_range, /* min: */ -1.0, /* max: */ 1.0, /* default: */ 0.0),
	VAR_REAL_CYCLE(<%NAME%>_real_cycle, /* min: */ -1.0, /* max: */ 1.0, /* default: */ 0.0),
	
	VAR_INTEGER(<%NAME%>_integer, /* default: */ 0),
	VAR_INTEGER_RANGE(<%NAME%>_integer_range, /* min: */ -1, /* max: */ 1, /* default: */ 0),
	VAR_INTEGER_NONZERO(<%NAME%>_integer_nonzero, /* default: */ 1),
);

int PluginVarInitialize(Variation* vp) 
{
	// Called upon initialization

	return TRUE;
}

int PluginVarPrepare(Variation* vp)
{
	// Called once per render pass

    return TRUE;
}

int PluginVarCalc(Variation* vp)
{
	// Called once per iteration

    return TRUE;
}

int PluginVarTerminate(Variation* vp) 
{
	// Called upon termination

	return TRUE;
}