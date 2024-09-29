#include "sim.h"

// Определяем игровое поле
static int grid[GRID_WIDTH][GRID_HEIGHT];
static int next_grid[GRID_WIDTH][GRID_HEIGHT];

// Функция для начальной инициализации игрового поля
void gridInit()
{
  for (int x = 0; x < GRID_WIDTH; x++)
  {
    for (int y = 0; y < GRID_HEIGHT; y++)
    {
      // Заполняем клетки случайным образом (0 или 1)
      grid[x][y] = simRand() % 2;
    }
  }
}

// Функция для обновления состояния игрового поля
void gridUpdate()
{
  for (int x = 0; x < GRID_WIDTH; x++)
  {
    for (int y = 0; y < GRID_HEIGHT; y++)
    {
      int neighbors = countNeighbors(x, y);

      // Применяем правила "Игры жизни"
      if (grid[x][y] == 1)
      {
        // Живая клетка остается живой, если у нее 2 или 3 соседа
        next_grid[x][y] = (neighbors == 2 || neighbors == 3) ? 1 : 0;
      } else {
        // Мертвая клетка становится живой, если у нее ровно 3 соседа
        next_grid[x][y] = (neighbors == 3) ? 1 : 0;
      }
    }
  }

  // Копируем новое состояние в текущее
  for (int x = 0; x < GRID_WIDTH; x++)
  {
    for (int y = 0; y < GRID_HEIGHT; y++)
    {
      grid[x][y] = next_grid[x][y];
    }
  }
}

// Функция для отрисовки текущего состояния игрового поля
void gridDraw()
{
  for (int x = 0; x < GRID_WIDTH; x++)
  {
    for (int y = 0; y < GRID_HEIGHT; y++)
    {
      // Если клетка жива — рисуем белым, если мертва — черным
      int color = grid[x][y] ? 0xFFFFFFFF : 0x00000000;

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
int countNeighbors(int x, int y)
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
      if (nx >= 0 && nx < GRID_WIDTH && ny >= 0 && ny < GRID_HEIGHT)
      {
        count += grid[nx][ny];
      }
    }
  }

  return count;
}

// Функция входа в симуляцию
void app()
{
  gridInit();

  while (1)
  {
    gridUpdate();
    gridDraw();
    simFlush();
  }
}