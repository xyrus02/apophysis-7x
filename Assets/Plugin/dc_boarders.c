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
*/

// Must define this structure before we include apoplugin.h
typedef struct 
{
} Variables;

#include "apoplugin.h"

// Set the name of this plugin
APO_PLUGIN("dc_boarders");

// Define the Variables
APO_VARIABLES(
);

// You must call the argument "vp".
int PluginVarPrepare(Variation* vp)
{
    // Always return TRUE.
    return TRUE;
}

// You must call the argument "vp".
int PluginVarCalc(Variation* vp)
{
    double roundX, roundY, offsetX, offsetY;
    
    roundX = rint(FTx);
    roundY = rint(FTy);
    offsetX = FTx - roundX;
    offsetY = FTy - roundY;
    
    if(random01() >= 0.75)
    {
        FPx += VVAR*(offsetX*0.5 + roundX);
        FPy += VVAR*(offsetY*0.5 + roundY);
    }
    else
    {
        if(fabs(offsetX) >= fabs(offsetY))
        {
            if(offsetX >= 0.0)
            {
                FPx += VVAR*(offsetX*0.5 + roundX + 0.25);
                FPy += VVAR*(offsetY*0.5 + roundY + 0.25 * offsetY / offsetX);
            }
            else
            {
                FPx += VVAR*(offsetX*0.5 + roundX - 0.25);
                FPy += VVAR*(offsetY*0.5 + roundY - 0.25 * offsetY / offsetX);  
            }
        }
        else
        {
            if(offsetY >= 0.0)
            {
                FPy += VVAR*(offsetY*0.5 + roundY + 0.25);
                FPx += VVAR*(offsetX*0.5 + roundX + offsetX/offsetY*0.25);
            }
            else
            {
                FPy += VVAR*(offsetY*0.5 + roundY - 0.25);
                FPx += VVAR*(offsetX*0.5 + roundX - offsetX/offsetY*0.25);
            }
        }
    }
    return TRUE;
}

