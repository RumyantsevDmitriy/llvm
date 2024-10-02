#include "sim.h"

// Функция для начальной инициализации игрового поля
void gridInit(int *grid, int width, int height)
{
  for (int x = 0; x < width; x++)
  {
    for (int y = 0; y < height; y++)
    {
      // Заполняем клетки случайным образом (0 или 1)
      grid[y * width + x] = simRand() % 2;
    }
  }
}

// Функция для обновления состояния игрового поля
void gridUpdate(int *grid, int *next_grid, int width, int height)
{
  for (int x = 0; x < width; x++)
  {
    for (int y = 0; y < height; y++)
    {
      int neighbors = countNeighbors(grid, x, y, width, height);

      // Применяем правила "Игры жизни"
      if (grid[y * width + x] == 1)
      {
          // Живая клетка остается живой, если у нее 2 или 3 соседа
          next_grid[y * width + x] = (neighbors == 2 || neighbors == 3) ? 1 : 0;
      } else {
          // Мертвая клетка становится живой, если у нее ровно 3 соседа
          next_grid[y * width + x] = (neighbors == 3) ? 1 : 0;
      }
    }
  }

  // Копируем новое состояние в текущее
  for (int x = 0; x < width; x++)
  {
    for (int y = 0; y < height; y++)
    {
      grid[y * width + x] = next_grid[y * width + x];
    }
  }
}

// Функция для отрисовки текущего состояния игрового поля
void gridDraw(int *grid, int width, int height)
{
  for (int x = 0; x < width; x++)
  {
    for (int y = 0; y < height; y++)
    {
      // Если клетка жива — рисуем белым, если мертва — черным
      int color = grid[y * width + x] ? 0xFFFFFFFF : 0x00000000;

      // Рисуем клетку (CELL_SIZE на CELL_SIZE пикселей)
      for (int dx = 0; dx < CELL_SIZE; dx++)
      {
        for (int dy = 0; dy < CELL_SIZE; dy++)
        {
          simPutPixel(x * CELL_SIZE + dx, y * CELL_SIZE + dy, color);
        }
      }
    }
  }
}

// Функция для подсчета количества живых соседей клетки (x, y)
int countNeighbors(int *grid, int x, int y, int width, int height)
{
  int count = 0;

  for (int dx = -1; dx <= 1; dx++)
  {
    for (int dy = -1; dy <= 1; dy++)
    {
      // Пропускаем саму клетку
      if (dx == 0 && dy == 0)
      {
        continue;
      }

      int nx = x + dx;
      int ny = y + dy;

      // Проверяем границы поля
      if (nx >= 0 && nx < width && ny >= 0 && ny < height)
      {
        count += grid[ny * width + nx];
      }
    }
  }

  return count;
}

// Функция входа в симуляцию
void app()
{
  // Создаем одномерные массивы для текущего и следующего состояния игрового поля
  int grid[GRID_WIDTH * GRID_HEIGHT];
  int next_grid[GRID_WIDTH * GRID_HEIGHT];

  gridInit(grid, GRID_WIDTH, GRID_HEIGHT);

  while (1)
  {
    gridUpdate(grid, next_grid, GRID_WIDTH, GRID_HEIGHT);
    gridDraw(grid, GRID_WIDTH, GRID_HEIGHT);
    simFlush();
  }
}