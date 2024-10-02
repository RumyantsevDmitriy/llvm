// Размер окна
#define SIM_X_SIZE 800
#define SIM_Y_SIZE 600
// Размер одной клетки
#define CELL_SIZE 10
// Размер сетки
#define GRID_WIDTH (SIM_X_SIZE / CELL_SIZE)
#define GRID_HEIGHT (SIM_Y_SIZE / CELL_SIZE)

#ifndef __sim__
void simFlush();
void simPutPixel(int x, int y, int argb);
void gridInit(int *grid, int width, int height);
void gridUpdate(int *grid, int *next_grid, int width, int height);
void gridDraw(int *grid, int width, int height);
int simRand();
int countNeighbors(int *grid, int x, int y, int width, int height);
#endif

extern void simInit();
extern void app();
extern void simExit();