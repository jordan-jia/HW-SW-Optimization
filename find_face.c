/* Xilinx includes. */
#include "xil_printf.h"
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include "image.h"

#include "xparameters.h"  /* SDK generated parameters */
#include "xsdps.h"        /* for SD device driver     */
#include "ff.h"
#include "xil_cache.h"
#include "xplatform_info.h"
#include "xtime_l.h"

#define TIMER_ID	1
#define DELAY_1000_SECONDS	1000000UL
#define DELAY_1_SECOND		1000UL
#define TIMER_CHECK_THRESHOLD	9
#define COUNTS_PER_USECOND  (XPAR_CPU_CORTEXA9_CORE_CLOCK_FREQ_HZ / 2000000)
#define FREQ_MHZ ((XPAR_CPU_CORTEXA9_CORE_CLOCK_FREQ_HZ+500000)/1000000)


volatile int *group_regs = (int *) (XPAR_COMPUTE_SAD_0_S00_AXI_BASEADDR + 0);
volatile int *reg_bank = (int *) (XPAR_COMPUTE_SAD_0_S00_AXI_BASEADDR + 32);
volatile int *hw_active = (int *) (XPAR_COMPUTE_SAD_0_S00_AXI_BASEADDR + 36);
volatile int *sad_result = (int *) (XPAR_COMPUTE_SAD_0_S00_AXI_BASEADDR + 40);
volatile int *sad_result1 = (int *) (XPAR_COMPUTE_SAD_0_S00_AXI_BASEADDR + 44);
volatile int *sad_result2 = (int *) (XPAR_COMPUTE_SAD_0_S00_AXI_BASEADDR + 48);
volatile int *sad_result3 = (int *) (XPAR_COMPUTE_SAD_0_S00_AXI_BASEADDR + 52);

/*-----------------------------------------------------------*/

/* Declare a microsecond-resolution timer function */
long get_usec_time()
{
	XTime time_tick;

	XTime_GetTime(&time_tick);
	return (long) (time_tick / COUNTS_PER_USECOND);
}

/* function prototypes. */
void median3x3(uint8 *image, int width, int height);
int32 compute_sad(uint8 *im1, int w1, int row, int col);
int32 match(CImage *group);
void face_cpy(CImage *face);
void face1_cpy(CImage *face);
void face2_cpy(CImage *face);
void face3_cpy(CImage *face);

/* SD card I/O variables */
static FATFS fatfs;

int main(){
	CImage group, face,face1,face2,face3;
	    int  width, height;
	    long tick;


		/* Initialize the SD card driver. */
			if (f_mount(&fatfs, "0:/", 0))
			{
				return XST_FAILURE;
			}

		    printf("1. Reading images ... ");
		    tick = get_usec_time();

		    /* Read the group image file into the DDR main memory */
		    if (read_pnm_image("group.pgm", &group))
		    {
		        printf("\nError: cannot read the group.pgm image.\n");
		    	return 1;
		    }
		    width = group.width, height = group.height;

		    /* Reading the 32x32 target face image into main memory */
		    if (read_pnm_image("face.pgm", &face))
		    {
		        printf("\nError: cannot read the face.pgm image.\n");
		    	return 1;
		    }
			if (read_pnm_image("face1.pgm", &face1))
		    {
		        printf("\nError: cannot read the face1.pgm image.\n");
		    	return 1;
		    }
			if (read_pnm_image("face2.pgm", &face2))
		    {
		        printf("\nError: cannot read the face2.pgm image.\n");
		    	return 1;
		    }
			if (read_pnm_image("face3.pgm", &face3))
		    {
		        printf("\nError: cannot read the face3.pgm image.\n");
		    	return 1;
		    }
		    tick = get_usec_time() - tick;
		    printf("done in %ld msec.\n", tick/1000);

		    /* Perform median filter for noise removal */
		    printf("2. Median filtering ... ");
		    tick = get_usec_time();
		    median3x3(group.pix, width, height);
		    tick = get_usec_time() - tick;
		    printf("done in %ld msec.\n", tick/1000);

		    /* Perform face-matching */
		    printf("3. Face-matching ... \n\n");
		    tick = get_usec_time();
			face_cpy(&face);
			face1_cpy(&face1);
			face2_cpy(&face2);
			face3_cpy(&face3);
		    match(&group);
		    tick = get_usec_time() - tick;
		    printf("done in %ld msec.\n\n", tick/1000);

		    /* free allocated memory */
		    free(face.pix);
		    free(group.pix);

}
void matrix_to_array(uint8 *pix_array, uint8 *ptr, int width)
{
    int  idx, x, y;

    idx = 0;
    for (y = -1; y <= 1; y++)
    {
        for (x = -1; x <= 1; x++)
        {
            pix_array[idx++] = *(ptr+x+width*y);
        }
    }
}

void insertion_sort(uint8 *pix_array, int size)
{
    int idx, jdx;
    uint8 temp;

    for (idx = 1; idx < size; idx++)
    {
        for (jdx = idx; jdx > 0; jdx--)
        {
            if (pix_array[jdx] < pix_array[jdx-1])
            {
                /* swap */
                temp = pix_array[jdx];
                pix_array[jdx] = pix_array[jdx-1];
                pix_array[jdx-1] = temp;
            }
        }
    }
}

void median3x3(uint8 *image, int width, int height)
{
    int   row, col;
    uint8 pix_array[9], *ptr;

    for (row = 1; row < height-1; row++)
    {
        for (col = 1; col < width-1; col++)
        {
            ptr = image + row*width + col;
            matrix_to_array(pix_array, ptr, width);
            insertion_sort(pix_array, 9);
            *ptr = pix_array[4];
        }
    }
}

int32 compute_sad(uint8 *group, int width, int row, int col)
{
	if (!row)
	{
		for (int y = 0; y < 32; y++)
		{
			/* send 32x32 pixels into the HW IP */
			*reg_bank = y;
			memcpy((void *) group_regs, group+y*width+col, 32);
			*hw_active = 2;
			while (*hw_active) ;
		}
	}
	else
	{   /* row != 0 */
		/* send the last row of 32 pixels into the HW IP */
		*reg_bank=(row-1)%32;
		memcpy((void *) group_regs, group+(row+31)*width+col, 32);
		*hw_active = 2;
		while (*hw_active) ;
	}
	*hw_active = 1;
	//xil_printf("start\n");
	while (*hw_active) ; /* busy waiting, not good but faster */
	//xil_printf("success\n");
	return 0;
}

int32 match(CImage *group)
{
	int32 row, col, min_sad,min_sad1,min_sad2,min_sad3,posx,posy,posx1,posy1,posx2,posy2,posx3,posy3;
	min_sad = 256*32*32;
	min_sad1= 256*32*32;
	min_sad2= 256*32*32;
	min_sad3= 256*32*32;
	for (col = 0; col < group->width-32; col++) {
		for (row = 0; row < group->height-32; row++) {
			/* trying to compute the matching cost at (col, row) */
			compute_sad(group->pix, group->width, row, col);
			/* if the matching cost is minimal, record it */

			if (*sad_result <= min_sad){
				min_sad = *sad_result;
				posx = col;
				posy = row;
			}
			if (*sad_result1 <= min_sad1){
				min_sad1 = *sad_result1;
				posx1 = col;
				posy1 = row;
			}
			if (*sad_result2 <= min_sad2){
				min_sad2 = *sad_result2;
				posx2 = col;
				posy2 = row;
			}
			if (*sad_result3 <= min_sad3){
				min_sad3 = *sad_result3;
				posx3 = col;
				posy3 = row;
			}
		}
	}

	printf("** Found the face at (%d, %d) with cost %ld\n\n", posx, posy, min_sad);
	printf("** Found the face1 at (%d, %d) with cost %ld\n\n", posx1, posy1, min_sad1);
	printf("** Found the face2 at (%d, %d) with cost %ld\n\n", posx2, posy2, min_sad2);
	printf("** Found the face3 at (%d, %d) with cost %ld\n\n", posx3, posy3, min_sad3);
	return 0;
}

void face_cpy(CImage *face)
{
	for(int y=0;y<32;y++)
	{
		*reg_bank = y;
		memcpy((void *) group_regs, face->pix+y*32, 32);
		*hw_active = 3;
		while (*hw_active);
	}
}

void face1_cpy(CImage *face)
{
	for(int y=0;y<32;y++)
	{
		*reg_bank = y;
		memcpy((void *) group_regs, face->pix+y*32, 32);
		*hw_active = 4;
		while (*hw_active);
	}
}

void face2_cpy(CImage *face)
{
	for(int y=0;y<32;y++)
	{
		*reg_bank = y;
		memcpy((void *) group_regs, face->pix+y*32, 32);
		*hw_active = 5;
		while (*hw_active);
	}
}

void face3_cpy(CImage *face)
{
	for(int y=0;y<32;y++)
	{
		*reg_bank = y;
		memcpy((void *) group_regs, face->pix+y*32, 32);
		*hw_active = 6;
		while (*hw_active);
	}
}
