/*
Apophysis Plugin

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

/*
Some comments on TriBorders plugin structure. It builds dual tessellation
on triangle grid as Boarders variation does for square one and it uses
trilinear coordinates ([link])
instead of usual Cartesian system (from where Tri Borders in plugin name).
Hex function doesn’t work correctly in general case because its second part
(determines nonlinear texture) doesn’t transform lines (passes from triangle vertex)
to itself for arbitrary triangle.
It possible to do and I’ve done main job but have not finished.
*/

// Must define this structure before we include apoplugin.h
typedef struct
{
    int xtrb_power;
    double xtrb_dist;
	double xtrb_radius, xtrb_width, xtrb_a, xtrb_b;
	double angle_Ar, angle_Br, angle_Cr;
	double sinA2, cosA2, sinB2, cosB2, sinC2, cosC2, sinC, cosC;
	double a, b, c;
	double Ha, Hb, Hc, S2;
	double ab, ac, ba, bc, ca, cb, S2a, S2b, S2c, S2ab, S2ac, S2bc;
	double width1, width2, width3;
	double absN, cN;
} Variables;

#include "apoplugin.h"

// Set the name of this plugin
APO_PLUGIN("xtrb");

// Define the Variables
APO_VARIABLES(
			  VAR_INTEGER_NONZERO(xtrb_power, 2),
			  VAR_REAL(xtrb_radius, 1.0),
			  VAR_REAL(xtrb_width, 0.5),
              VAR_REAL(xtrb_dist, 1.0),
			  VAR_REAL(xtrb_a, 1.0),
			  VAR_REAL(xtrb_b, 1.0)
			  );

// You must call the argument "vp".
int PluginVarPrepare(Variation* vp)
{
	//VAR(angle_B)= 60;
	//VAR(angle_C)= 60;

	VAR(angle_Br) = 0.047 + VAR(xtrb_a);///180.0*M_PI; // angeles in radians
	VAR(angle_Cr) = 0.047 + VAR(xtrb_b);///180.0*M_PI;
	VAR(angle_Ar) =M_PI - VAR(angle_Br) - VAR(angle_Cr);

	fsincos(0.5*VAR(angle_Ar), &VAR(sinA2), &VAR(cosA2)); // its sin, cos
	fsincos(0.5*VAR(angle_Br), &VAR(sinB2), &VAR(cosB2));
	fsincos(0.5*VAR(angle_Cr), &VAR(sinC2), &VAR(cosC2));
	fsincos( VAR(angle_Cr), &VAR(sinC), &VAR(cosC));

	VAR(a) = VAR(xtrb_radius)*( VAR(sinC2)/VAR(cosC2)+ VAR(sinB2)/VAR(cosB2)); //sides
	VAR(b) = VAR(xtrb_radius)*( VAR(sinC2)/VAR(cosC2)+ VAR(sinA2)/VAR(cosA2));
	VAR(c) = VAR(xtrb_radius)*( VAR(sinB2)/VAR(cosB2)+ VAR(sinA2)/VAR(cosA2));

	VAR(width1) = 1 - VAR(xtrb_width);
	VAR(width2) = 2* VAR(xtrb_width);
	VAR(width3) = 1 - VAR(xtrb_width)*VAR(xtrb_width);

	VAR(S2) = VAR(xtrb_radius)*( VAR(a)+VAR(b) +VAR(c)); //square

	VAR(Ha) = VAR(S2)/VAR(a)/6.0; //Hight div on 6.0
	VAR(Hb) = VAR(S2)/VAR(b)/6.0;
	VAR(Hc) = VAR(S2)/VAR(c)/6.0;

	VAR(ab) = VAR(a)/VAR(b);// a div on b
	VAR(ac) = VAR(a)/VAR(c);
	VAR(ba) = VAR(b)/VAR(a);
	VAR(bc) = VAR(b)/VAR(c);
	VAR(ca) = VAR(c)/VAR(a);
	VAR(cb) = VAR(c)/VAR(b);
	VAR(S2a) = 6.0*VAR(Ha);
	VAR(S2b) = 6.0*VAR(Hb);
	VAR(S2c) = 6.0*VAR(Hc);
	VAR(S2bc) =VAR(S2)/(VAR(b)+VAR(c))/6.0;
	VAR(S2ab) =VAR(S2)/(VAR(a)+VAR(b))/6.0;
	VAR(S2ac) =VAR(S2)/(VAR(a)+VAR(c))/6.0;
	
	VAR(absN) = (int)abs(VAR(xtrb_power));
    VAR(cN) = VAR(xtrb_dist) / VAR(xtrb_power) / 2;


	// Always return TRUE.
	return TRUE;
}

// You must call the argument "vp".
int PluginVarCalc(Variation* vp)
{
	void DirectTrilinear(double x, double y, double* Al, double* Be, double* Ga)
	{
		double U = y + VAR(xtrb_radius);
		double V = x * VAR(sinC) - y * VAR(cosC) + VAR(xtrb_radius);
		*Al =U;
		*Be =V;
		*Ga = VAR(S2c) - VAR(ac) * U - VAR(bc) * V;
	}

	void InverseTrilinear(double Al, double Be, double* x, double* y)
	{
		double inx = (Be - VAR(xtrb_radius) +(Al - VAR(xtrb_radius))* VAR(cosC))/ VAR(sinC);
		double iny = Al - VAR(xtrb_radius);
		
		double sina = 0.0, cosa = 0.0;

        double angle = (atan2(iny, inx) + M_2PI * (rand() % (int)VAR(absN)))/ VAR(xtrb_power);
        double r = VVAR * pow(sqr(inx) + sqr(iny), VAR(cN));
    
        fsincos(angle, &sina, &cosa);
        *x = r * cosa;
        *y = r * sina;
        //*x = 0; *y = 0;
	}

	void Hex(double Al, double Be, double Ga, double* Al1, double* Be1) // it's necessary
		//to improve for correct work for any triangle
	{
		double Ga1, De1, R;
		R = random01();
		if (Be < Al)
		{
			if (Ga < Be)
			{
				if (R >= VAR(width3))
				{
					De1 = VAR(xtrb_width) * Be;
					Ga1 = VAR(xtrb_width) * Ga;
				}
				else
				{
					Ga1 = VAR(width1) * Ga + VAR(width2)*VAR(Hc)* Ga / Be;
					De1 = VAR(width1)*Be+VAR(width2)*VAR(S2ab)*(3 -Ga / Be);

				}
				*Al1 = VAR(S2a) - VAR(ba)* De1 - VAR(ca)* Ga1;
				*Be1 = De1;

			}
			else
			{
				if (Ga < Al)
				{
					if (R >= VAR(width3))
					{
						Ga1 = VAR(xtrb_width) * Ga;
						De1 = VAR(xtrb_width) * Be;
					}
					else
					{
						De1 = VAR(width1) * Be + VAR(width2)*VAR(Hb)* Be / Ga;
						Ga1 = VAR(width1)*Ga+VAR(width2)*VAR(S2ac)*(3 -Be / Ga);

					}
					*Al1 = VAR(S2a) - VAR(ba)* De1 - VAR(ca)* Ga1;
					*Be1 = De1;
				}
				else
				{
					if (R >= VAR(width3))
					{
						*Al1 = VAR(xtrb_width) * Al;
						*Be1 = VAR(xtrb_width) * Be;
					}
					else
					{
						*Be1 = VAR(width1) * Be+VAR(width2)*VAR(Hb)* Be / Al;
						*Al1 = VAR(width1) * Al+VAR(width2)*VAR(S2ac)*(3-Be /Al);

					}

				}
			}
		}
		else
		{
			if (Ga < Al)
			{
				if (R >= VAR(width3))
				{
					De1 = VAR(xtrb_width) * Al;
					Ga1 = VAR(xtrb_width) * Ga;

				}
				else
				{
					Ga1 = VAR(width1) * Ga+VAR(width2)*VAR(Hc)* Ga / Al;
					De1 = VAR(width1) *Al+VAR(width2)*VAR(S2ab)*(3 -Ga /Al);

				}
				*Be1 = VAR(S2b) - VAR(ab)* De1 - VAR(cb)* Ga1;
				*Al1 = De1;

			}
			else
			{
				if (Ga < Be)
				{
					if (R >= VAR(width3))
					{
						Ga1 = VAR(xtrb_width) * Ga;
						De1 = VAR(xtrb_width) * Al;
					}
					else
					{
						De1 = VAR(width1) * Al + VAR(width2)*VAR(Ha)* Al / Ga;
						Ga1 = VAR(width1)*Ga + VAR(width2)*VAR(S2bc)*(3 -Al/Ga);

					}
					*Be1 = VAR(S2b) - VAR(ab)* De1 - VAR(cb)* Ga1;
					*Al1 = De1;

				}
				else
				{
					if (R >= VAR(width3))
					{
						*Be1 = VAR(xtrb_width) * Be;
						*Al1 = VAR(xtrb_width) * Al;
					}
					else
					{
						*Al1 = VAR(width1) * Al + VAR(width2)*VAR(Ha)* Al / Be;
						*Be1 = VAR(width1)*Be+VAR(width2)*VAR(S2bc)*(3-Al / Be);

					}

				}
			}
		}
	}
	double Alpha, Beta, Gamma, OffsetAl, OffsetBe, OffsetGa, X, Y;
	int M, N;

	// transfer to trilinear coordinates, normalized to real distances from triangle sides

	DirectTrilinear(FTx, FTy, &Alpha, &Beta, &Gamma);

	M = floor(Alpha/VAR(S2a));
	OffsetAl = Alpha - M*VAR(S2a);
	N = floor(Beta/VAR(S2b));
	OffsetBe = Beta - N*VAR(S2b);
	OffsetGa = VAR(S2c) - VAR(ac)*OffsetAl - VAR(bc)*OffsetBe;

	if ( OffsetGa > 0 )
	{
		Hex(OffsetAl, OffsetBe, OffsetGa, &Alpha, &Beta);

	}

	else
	{
		OffsetAl = VAR(S2a) - OffsetAl;
		OffsetBe = VAR(S2b) - OffsetBe;
		OffsetGa = - OffsetGa;

		Hex(OffsetAl, OffsetBe, OffsetGa, &Alpha, &Beta);

		Alpha = VAR(S2a) - Alpha;
		Beta = VAR(S2b) - Beta;

	}
	Alpha = Alpha + M*VAR(S2a);
	Beta = Beta + N*VAR(S2b);

	InverseTrilinear(Alpha, Beta, &X, &Y);
	FPx += VVAR * X;
	FPy += VVAR * Y;

	return TRUE;
} 
