/**************************************************************************

    Apophysis Plugin
	Copyright (c) 2006-2011 Apophysis Development Team.
	
	DirectColor Apophysis Plugin
	Copyright (c) 2010-2011 Georg Kiehne.

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
	
***************************************************************************
	
	DC_Image plugin for Apophysis
	Copyright (c) 2010-2011 Georg Kiehne. 
	
	This plugin was very hard work. Please respect this by crediting
	properly if you are going to use this source code in your own
	Apophysis plugins or any other software.
	
	Please keep this comment header in your source code and place a
	link to http://xyrus-worx.net to the download page of your software
	or Apophysis plugin.
	
	Version is 1.1
	Revision is 616
	Build is 1905
	
	Tested with Apophysis 7X.15
	
**************************************************************************/

#include <windows.h>
#include <string.h>
#include <stdio.h>
#include <malloc.h>
#include <math.h>
#include <time.h>
#include <string.h>
#include <limits.h>
#include <float.h>
#include <dirent.h>

#define MAX_NUM_BITMAPS 1024

#define OFFSET(name) ((int) &(((Variables*) 0)->name))
#define INT_LVALUE(varptr, info)    ( *((int*)    (((int) &((varptr)->var)) + (info).offset)))
#define DOUBLE_LVALUE(varptr, info) ( *((double*) (((int) &((varptr)->var)) + (info).offset)))
#define VALUE(varptr, info) ( (info).type >= INTEGER ? INT_LVALUE(varptr, info) : DOUBLE_LVALUE(varptr, info) )
#define INTDOUBLE(intordouble, type) ((type) >= INTEGER ? (intordouble).i : (intordouble).d)
#define DBL_VALUE(intordouble, type) ((type) >= INTEGER ? ((double) (intordouble).i) : (intordouble).d )

#define VAR_REAL(nm, def) { #nm, REAL, OFFSET(nm), (IntOrDouble) -DBL_MAX, (IntOrDouble) DBL_MAX, (IntOrDouble) (def) }
#define VAR_INTEGER(nm, def) { #nm, INTEGER, OFFSET(nm), (IntOrDouble) INT_MIN, (IntOrDouble) INT_MAX, (IntOrDouble) (def) }
#define VAR_REAL_RANGE(nm, min, max, def) {#nm, REAL, OFFSET(nm), (IntOrDouble) (min), (IntOrDouble) (max), (IntOrDouble) (def) }
#define VAR_INTEGER_RANGE(nm, min, max, def) {#nm, INTEGER, OFFSET(nm), (IntOrDouble) (min), (IntOrDouble) (max), (IntOrDouble) (def) }
#define VAR_INTEGER_NONZERO(nm, def) {#nm, INTEGER_NONZERO, OFFSET(nm), (IntOrDouble) INT_MIN, (IntOrDouble) INT_MAX, (IntOrDouble) (def) }
#define VAR_REAL_CYCLE(nm, min, max, def) {#nm, REAL_CYCLIC, OFFSET(nm), (IntOrDouble) (min), (IntOrDouble) (max), (IntOrDouble) (def) }

typedef struct {
    int width; int height;
    int stride; int size;
    unsigned char* pixels;
    short bytes_per_pixel;
} DciBitmap;
typedef struct
{
    int dc_image_index;
    int dc_image_mode;
	int dc_image_input;
	int dc_image_output;
	int dc_image_overwrite;
	double dc_image_mul;
    double dc_image_c0;
    double dc_image_c1;
    double dc_image_x;
    double dc_image_y;
    double dc_image_angle;
    double dc_image_scale;
	
    int has_bitmap;
    double cmapmin, cmapmax,
           cmaprange, a, q;
		   
	int width, height, bytes_per_pixel;
	int stride, size;
	
	unsigned char* pixels;
} Variables;
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

VariableInfo VarInfo[] = {
    VAR_INTEGER_RANGE(dc_image_index, -1, (MAX_NUM_BITMAPS-1), -1),
    VAR_INTEGER_RANGE(dc_image_mode, 0, 4, 0),
	VAR_INTEGER_RANGE(dc_image_input, 0, 1, 0),
	VAR_INTEGER_RANGE(dc_image_output, 0, 3, 0),
	VAR_INTEGER_RANGE(dc_image_overwrite, 0, 1, 1),
	VAR_REAL(dc_image_mul, 1.0),
    VAR_REAL_RANGE(dc_image_c0, 0.0, 1.0, 0.0),
    VAR_REAL_RANGE(dc_image_c1, 0.0, 1.0, 1.0),
    VAR_REAL(dc_image_x, 0.0),
    VAR_REAL(dc_image_y, 0.0),
    VAR_REAL(dc_image_angle, 0.0),
    VAR_REAL(dc_image_scale, 1.0)
};

const int NumVariables = sizeof(VarInfo) / sizeof(VariableInfo);

double dummyFTz, dummyFPz, dummyColor;
DciBitmap* bitmaps = 0;
int bitmap_count = 0;

int warned_faulty_image_dir = 0;
int warn_faulty_image_dir = 0;

int warned_non_dc_apophysis = 0;
int warn_non_dc_apophysis = 0;

char* GetModuleDirectory();

inline void fsincos(double theta, double* s, double* c) {
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
      *s = sin(theta);
      *c = cos(theta);
    #endif
}
inline void logw(const char* text) {
	int len = strlen(text);

	char* apo_dir = GetModuleDirectory(0);
    char* log_path = (char*)malloc(sizeof(char) * MAX_PATH);

    ZeroMemory(log_path, MAX_PATH * sizeof(char));
    sprintf(log_path, "%sdc_image.log", apo_dir);

	FILE* lf = fopen(log_path, "a+");
    fwrite(text, 1, len, lf);
	fwrite("\n", 1, 1, lf);
	fclose(lf);
	
	free(apo_dir);
	free(log_path);
}

int DirectoryExists(const char* pzPath ) {
    if (pzPath == 0) return 0;
    DIR *pDir; int bExists = 0;
    pDir = opendir (pzPath);
    if (pDir != 0) {
        bExists = 1;
        (void) closedir (pDir);
    }
    return bExists;
}
char* GetModuleDirectory() {
    HMODULE handle = GetModuleHandleA(0);
    char* buffer = (char*)malloc(MAX_PATH * sizeof(char));

    ZeroMemory(buffer, MAX_PATH);
    GetModuleFileNameA(handle, buffer, MAX_PATH);

    int n = strlen(buffer), i;
    for (i = n-1; i>=0&&buffer[i]!='\\'; i--) buffer[i]=(char)0;

    return buffer;
}
DciBitmap AllocBitmap(char* path, int* success) {
    FILE* file = 0;
	
    unsigned char* pixels = 0;
	char* message = (char*)malloc(2048);
	
	ZeroMemory(message, 2047); sprintf(message, "Opening bitmap \"%s\" in AllocBitmap. Status output pointer is 0x%x", path, (int)success); logw(message);

    DciBitmap bitmap;

    BITMAPFILEHEADER bitmapFileHeader;
    BITMAPINFOHEADER bitmapInfoHeader;

    *success = 0;
    ZeroMemory(&bitmap, sizeof(DciBitmap));

    file = fopen(path,"rb");
    if (file == 0) {
		ZeroMemory(message, 2047); sprintf(message, "Failed to open file (fopen returned zero)"); logw(message);
        if (pixels != 0) free((void*)pixels);
        if (file != 0) fclose((void*)file);
        return bitmap;
    } else {
		ZeroMemory(message, 2047); sprintf(message, "Successfully opened file; file pointer is 0x%x", (int)file); logw(message);
	}

    fread(&bitmapFileHeader, sizeof(BITMAPFILEHEADER),1,file);
    if (bitmapFileHeader.bfType !=0x4D42) {
		ZeroMemory(message, 2047); sprintf(message, "Invalid bitmap cookie: %x", bitmapFileHeader.bfType); logw(message);
        if (pixels != 0) free((void*)pixels);
        if (file != 0) fclose((void*)file);
        return bitmap;
    } else {
		ZeroMemory(message, 2047); sprintf(message, "Successfully verified bitmap cookie."); logw(message);
	}

	ZeroMemory(message, 2047); sprintf(message, "Reading bitmap header"); logw(message);
    fread(&bitmapInfoHeader, sizeof(BITMAPINFOHEADER), 1, file);
	
	bitmap.width = bitmapInfoHeader.biWidth;
    bitmap.height = bitmapInfoHeader.biHeight;
    bitmap.stride = ((((bitmapInfoHeader.biWidth * bitmapInfoHeader.biBitCount) + 31) & ~31) >> 3);
    bitmap.bytes_per_pixel = (short)((double)bitmapInfoHeader.biBitCount / 8.0);
	
	int size = bitmap.stride * bitmap.height; //bitmapInfoHeader.biSizeImage;
	ZeroMemory(message, 2047); sprintf(message, "Allocating pixel buffer: %i bytes", size); logw(message);
    pixels = (unsigned char*)malloc(sizeof(unsigned char) * size);
	
	ZeroMemory(message, 2047); sprintf(message, "Seeking bitmap data offset: 0x%x", (int)bitmapFileHeader.bfOffBits); logw(message);
    fseek(file, bitmapFileHeader.bfOffBits, SEEK_SET);
    fread(pixels, 1, size, file);    
	bitmap.size = size; bitmap.pixels = pixels;

    if (bitmapInfoHeader.biBitCount % 4 != 0 || bitmapInfoHeader.biBitCount <= 0) {
		ZeroMemory(message, 2047); sprintf(message, "Unable to process bitmap - odd bit count: %i", bitmapInfoHeader.biBitCount); logw(message);
        if (pixels != 0) free((void*)pixels);
        if (file != 0) fclose((void*)file);
        return bitmap;
    } else {
		ZeroMemory(message, 2047); sprintf(message, "Sucessfully processed bitmap - bit count: %i", bitmapInfoHeader.biBitCount); logw(message);
	}

	ZeroMemory(message, 2047); sprintf(message, "Closing bitmap file"); logw(message);
    fclose((void*)file);

    *success = 1;
    return bitmap;
}
void LoadBitmaps(Variation* vp, const char* apo_dir) {
    int i = 0;
    WIN32_FIND_DATA ffd;
    HANDLE hFind = INVALID_HANDLE_VALUE;

    char* img_dir = (char*)malloc(sizeof(char) * MAX_PATH);
    char* img_path = (char*)malloc(sizeof(char) * MAX_PATH);
    char* logline_init = (char*)malloc(sizeof(char) * 2048);

    ZeroMemory(img_dir, MAX_PATH * sizeof(char));
    sprintf(img_dir, "%sImages\\*.bmp", apo_dir);

    ZeroMemory(img_path, MAX_PATH * sizeof(char));
    sprintf(img_path, "%sImages", apo_dir);

    bitmaps = (DciBitmap*)malloc(MAX_NUM_BITMAPS * sizeof(DciBitmap));
    ZeroMemory(bitmaps, MAX_NUM_BITMAPS * sizeof(DciBitmap));

	int exists = DirectoryExists(img_path);
	
    ZeroMemory(logline_init, 2048 * sizeof(char));
    sprintf(logline_init, "Enumeration of \"%s\", exists: %i", img_path, exists);

    logw(logline_init);
    free(logline_init);

    hFind = exists == 0 ? INVALID_HANDLE_VALUE : FindFirstFile(img_dir, &ffd);
    if (INVALID_HANDLE_VALUE != hFind) {
        char* logline = (char*)malloc(sizeof(char) * 2048);
        do {
            if ((ffd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0) {
                int success = 0;
                char* fullpath = (char*)malloc(sizeof(char) * MAX_PATH);

                ZeroMemory(fullpath, MAX_PATH * sizeof(char));
                ZeroMemory(logline, 2048 * sizeof(char));

                sprintf(fullpath, "%sImages\\%s", apo_dir, ffd.cFileName);
                bitmaps[i] = AllocBitmap(fullpath, &success);
				
                if (success != 0)
                    sprintf(logline, "Successfully loaded bitmap \"%s\" - dc_image_index for this bitmap is %i.", ffd.cFileName, i++);
                else sprintf(logline, "Failed to load bitmap \"%s\" - skipping!", ffd.cFileName);

                logw(logline);
                free(fullpath);
            }
        } while ((FindNextFile(hFind, &ffd) != 0) && (i <= MAX_NUM_BITMAPS));
        ZeroMemory(logline, 2048 * sizeof(char));
        sprintf(logline, "Loaded %i bitmaps.", i);

        logw(logline);
        free(logline);

        warn_faulty_image_dir = (i == 0) ? 1 : 0;
        bitmap_count = i;
        FindClose(hFind);
    } else {
        logw("Error enumerating image directory!");
        warn_faulty_image_dir = 1;
        bitmap_count = 0;
    }

	if (img_path) free((void*)img_path);
    if (img_dir) free((void*)img_dir);
    if (apo_dir) free((void*)apo_dir);
}

__declspec (dllexport) int PluginVarGetVariable(void* VariationPtr, const char* name, double* value) {
    int i;
    Variation* var;

    if ((var = (Variation*) VariationPtr) == 0)
        return 0;

    for (i = 0 ; i < NumVariables; i++)
    {
        if (strcmp(VarInfo[i].name, name) == 0)
        {
            *value = (double) VALUE(var, VarInfo[i]);
            return 1;
        }
    }

    return 0;
}
__declspec (dllexport) int PluginVarSetVariable(void* VariationPtr, const char* name, double* value) {
    int i;
    Variation* var;

    if ((var = (Variation*) VariationPtr) == 0)
        return 0;

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

            return 1;
        }
    }

    return 0;
}
__declspec (dllexport) int PluginVarResetVariable(void* VariationPtr, const char* name) {
    int i;
    Variation* var;

    if ((var = (Variation*) VariationPtr) == 0)
        return 0;

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

            return 1;
        }
    }

    return 0;
}

__declspec (dllexport) const char* PluginVarGetName() { return "dc_image"; }
__declspec (dllexport) int PluginVarGetNrVariables() { return NumVariables; }
__declspec (dllexport) const char* PluginVarGetVariableNameAt(int index) {
    if (index >= 0 && index < NumVariables)
        return VarInfo[index].name;
    return "";
}

__declspec (dllexport) void* PluginVarCreate() {
    int i; Variation* vp = (Variation*) calloc(1, sizeof(Variation));

    for (i = 0 ; i < NumVariables; i++)
        PluginVarResetVariable(vp, VarInfo[i].name);

    char* apo_dir = GetModuleDirectory(0);
    char* log_path = (char*)malloc(sizeof(char) * MAX_PATH);

    ZeroMemory(log_path, MAX_PATH * sizeof(char));
    sprintf(log_path, "%sdc_image.log", apo_dir);

    if (bitmaps == 0) {
		fclose(fopen(log_path, "w+"));
		LoadBitmaps(vp, apo_dir);
	}

    free(log_path);
    free(apo_dir);

	return vp;
}
__declspec (dllexport) int PluginVarInitDC(void* varptr, void* pFPx, void* pFPy, void* pFPz, void* pFTx, void* pFTy, void* pFTz, void* pColor, double vvar, double a, double b, double c, double d, double e, double f) {
    Variation* vp = (Variation*) varptr;
    if (vp == 0) return 0;

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

	if (warned_non_dc_apophysis == 0 && warn_non_dc_apophysis != 0) {
        warned_non_dc_apophysis = 1;
		warn_faulty_image_dir = 0;
		MessageBox(0, "You must use Apophysis 7X at version 14 or higher to properly use the DC_Image plugin.\0", "Apophysis\0", MB_ICONWARNING | MB_OK);
	}
	
    if (warned_faulty_image_dir == 0 && warn_faulty_image_dir != 0) {
        warned_faulty_image_dir = 1;
		MessageBox(0, "You must place Bitmap files (*.bmp) in the folder \"Images\" in your Apophysis directory to properly setup the DC_Image plugin.\0", "Apophysis\0", MB_ICONWARNING | MB_OK);
	}
	
    return 1;
}
__declspec (dllexport) int PluginVarInit3D(void* varptr, void* pFPx, void* pFPy, void* pFPz, void* pFTx, void* pFTy, void* pFTz, double vvar) {
	warn_non_dc_apophysis = 1;
    return PluginVarInitDC(varptr, pFPx, pFPy, pFPz, pFTx, pFTy, pFTz, &dummyColor, vvar, 1, 0, 0, 1, 0, 0);
}
__declspec (dllexport) int PluginVarInit(void* varptr, void* pFPx, void* pFPy, void* pFTx, void* pFTy, double vvar) {
	warn_non_dc_apophysis = 1;
    return PluginVarInitDC(varptr, pFPx, pFPy, &dummyFPz, pFTx, pFTy, &dummyFTz, &dummyColor, vvar, 1, 0, 0, 1, 0, 0);
}
__declspec (dllexport) int PluginVarDestroy(void** vpp) {
    if (vpp && *vpp)
    {
        free(*vpp);
        *vpp = 0;
        return 1;
    }
    return 0;
}

__declspec (dllexport) int PluginVarPrepare(Variation* vp) {
    const double cmin = (vp->var.dc_image_c0);
    const double cmax = (vp->var.dc_image_c1);

    vp->var.cmapmin = cmin<0?0:cmin>1?1:cmin;
    vp->var.cmapmax = cmax<vp->var.cmapmin?vp->var.cmapmin:cmax>1?1:cmax;

    vp->var.cmaprange = vp->var.cmapmax - vp->var.cmapmin;
    vp->var.a = vp->var.dc_image_angle * M_PI;
    vp->var.q = fabs(vp->var.dc_image_scale) < 0.000001 ? 100000 : 1 / vp->var.dc_image_scale;
    vp->var.has_bitmap = (vp->var.dc_image_index >= 0 && vp->var.dc_image_index < bitmap_count) ? 1 : 0;
	
	if (vp->var.has_bitmap != 0) {
		const int index = vp->var.dc_image_index;
		vp->var.width             = bitmaps[index].width;
        vp->var.height            = bitmaps[index].height;
        vp->var.stride            = bitmaps[index].stride;
        vp->var.bytes_per_pixel   = bitmaps[index].bytes_per_pixel;
        vp->var.size              = bitmaps[index].size;
        vp->var.pixels 			  = bitmaps[index].pixels;
	} else {
		vp->var.width             = 0;
        vp->var.height            = 0;
        vp->var.stride            = 0;
        vp->var.bytes_per_pixel   = 0;
        vp->var.size              = 0;
        vp->var.pixels 			  = 0;
	}
    return 1;
}
__declspec (dllexport) int PluginVarCalc(Variation* vp) {
    if (vp->var.has_bitmap != 0 && vp->var.pixels) {
        const double cmapmin    	= vp->var.cmapmin;
        const double cmaprange  	= vp->var.cmaprange;
        const double x0         	= vp->var.dc_image_x;
        const double y0         	= vp->var.dc_image_y;
        const double a          	= vp->var.a;
        const double q          	= vp->var.q;
		const double f              = vp->var.dc_image_mul;
        const int mode          	= vp->var.dc_image_mode;
		const int width             = vp->var.width;
        const int height            = vp->var.height;
        const int stride            = vp->var.stride;
        const int bytes_per_pixel   = vp->var.bytes_per_pixel;
        const int size              = vp->var.size;
		const int output            = vp->var.dc_image_output;
		const int clear             = vp->var.dc_image_overwrite;
        const unsigned char* pixels = vp->var.pixels;

		const double *x = vp->var.dc_image_input == 0 ? vp->pFPx : vp->pFTx;
		const double *y = vp->var.dc_image_input == 0 ? vp->pFPy : vp->pFTy;
		
        double s, c, r, g, b; fsincos(a, &s, &c);
        double tx = 0.5 * (*x * q * c - *y * q * s) + 0.5;
        double ty = 0.5 * (*x * q * s + *y * q * c) + 0.5;

        tx = fmod(fabs(tx - x0), 1.0) * width;
        ty = fmod(fabs(ty - y0), 1.0) * height;
		r = g = b = 0;

        unsigned int pos = (height -
            (unsigned int)round(ty) - 1) * stride +
            (unsigned int)round(tx) * bytes_per_pixel;

        if (pos >= 0 && pos < size) {
            switch (bytes_per_pixel) {
                case 2:
                    b = (double)(( pixels[pos+0] & 0x1F /*00011111*/)     );  // blue - five least significant bits
                    r = (double)(( pixels[pos+1] & 0xFC /*11111100*/) >> 2);  // red - five most significant bits
                    g = (double)(((pixels[pos+0] & 0xE0 /*11100000*/) >> 5)|  // green - shares bits between p0 and p1
                                 ((pixels[pos+1] & 0x03 /*00000011*/) << 3));
                    break;
                case 3:
					r = (double)pixels[pos+2];
                    g = (double)pixels[pos+1];
                    b = (double)pixels[pos+0];
                    break;
                case 4:
                    r = (double)pixels[pos+2];
                    g = (double)pixels[pos+1];
                    b = (double)pixels[pos+0];
                    break;
                case 1:
                    r = g = b = (double)(pixels[pos]);
                    break;
			}
			double result = 0.0;
            switch (mode) {
                case 0:
                    result = ((0.2989 * r + 0.5870 * g + 0.1140 * b) / 256.0) * cmaprange + cmapmin;
                    break;
                case 1:
                    result = ((16384.0 * r + 256.0 * g + b) / 16777215.0) * cmaprange + cmapmin;
                    break;
                case 2:
                    result = (r / 256.0) * cmaprange + cmapmin;
                    break;
                case 3:
                    result = (g / 256.0) * cmaprange + cmapmin;
                    break;
                case 4:
                    result = (b / 256.0) * cmaprange + cmapmin;
                    break;
                default: break;
            }
			result *= f;
			if (clear == 0) {
				switch (output) {
					case 0: result += *(vp->pColor); break;
					case 1: result += *(vp->pFTx); break;
					case 2: result += *(vp->pFTy); break;
					case 3: result += *(vp->pFTz); break;
				}
			}
			switch (output) {
				case 0: *(vp->pColor) = fmod(fabs(result), 1.0); break;
				case 1: *(vp->pFPx) = result; break;
				case 2: *(vp->pFPy) = result; break;
				case 3: *(vp->pFPz) = result; break;
			}
			
        }
    }
    return 1;
}
