int sizeX = 1000;
int sizeY = 1000;
int rows = 100;
int cols = 100;
int[][] grid = new int[rows][cols];
int[][] saveGrid = new int[rows][cols];
int ALIVE = 255;
int DECAY = 50;
int COLORRAND = 50;
color BGND = color(0,0,0,0);

int sizeScale = 500; 

boolean play = false;
char mouseState = 0;

void setup() {
  size(2000, 2000);
  background(BGND);
  blendMode(ADD);

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if (random(1) > 1.8) {
        grid[i][j] = ALIVE;
      } else {
        grid[i][j] = 0;
      }
    }
  }
  saveGrid = grid;
  stroke(0, 0, 0, 0);
  //int[][] t = {{ALIVE, ALIVE, 0,0},{ALIVE, ALIVE, 0,0},{ALIVE, ALIVE, 0,0},{ALIVE, ALIVE, 0,0}}
}

void draw() {
  boolean update = false;

  if (keyPressed && key == ' ') {
    play = true;
  } else {
    play = false;
  }

  if (!keyPressed) {
    play = false;
  }

  if (keyPressed && key == 's') {
    saveGrid = grid;
  }
  
  if (keyPressed && key == 'c') {
    clearGrid();
    update = true;
  }
  
  if (keyPressed && key == 'p') {
    saveCanvas("life");
  }
  
  if (keyPressed && key == 'l') {
    grid = saveGrid;
    update = true;
  }
  
  if (keyPressed && key == 'r') {
    randGrid();
    update = true;
  }
  
  if (keyPressed && key == 'd') {
    update = true;
  }

  if (mousePressed) {
    play = false;
    int gridPosX = int(mouseX/20);
    int gridPosY = int(mouseY/20);
    if (mouseButton == LEFT) {
      if (inBounds(gridPosX, gridPosY)) {
        grid[gridPosX][gridPosY] = ALIVE;
        update = true;
      }
    } else {
      if (inBounds(gridPosX, gridPosY)) {
        grid[gridPosX][gridPosY] = 0;
        update = true;
      }
    }
  }

  //frameRate(60);

  if (play) {
    background(0);
    int[][] nGrid = new int[rows][cols];

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        nGrid[i][j] = 0;
      }
    }


    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        int cell = grid[i][j];

        int n = getNeighbors(i, j);

        if (n > 0) {
          //print(i + ", " + j + " : "+ n + "\n");
        }

        if (cell == ALIVE) {
          if (n == 2 || n == 3) {
            nGrid[i][j] = ALIVE;
          } else {
            nGrid[i][j] = cell - DECAY;
            //nGrid[i][j] = 0;
          }
        } else {
          if (n == 3) {
            //println("reborn");
            nGrid[i][j] = ALIVE;
          } else {
            nGrid[i][j] = cell - DECAY;
            //nGrid[i][j] = 0;
          }
        }

        if (nGrid[i][j] < 0) {
          nGrid[i][j] = 0;
        }
      }
    }

    drawGrid();

    grid = nGrid;

    //println();
  } else if (update) {
    drawGrid();
  }


  //delay(100);
}

void drawGrid() {
  background(BGND);
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      int cell = grid[i][j];
      if (cell > 0) {
        if (cell < 200) {
          //fill(0,min(cell*2, 255),min(cell*2, 255), cell);
          fill(160 + random(COLORRAND), 120 + random(COLORRAND), 0 + random(10), min(150, cell));
        } else {
          //fill(0,cell,0, ALIVE);
          fill(0 + random(COLORRAND), 139+ random(COLORRAND), 48 + random(COLORRAND), 225);
        }
        
        //int rsize = 25;
        //rect(i * 20 - rsize/2, j * 20 - rsize/2, rsize, rsize);
        int radius = 20;
        polygon(i*20, j*20, radius, 6);

        
      }
    }
  }
}

void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

int getNeighbors(int i, int j) {
  int count = 0;
  for (int ii = i - 1; ii <= i+1; ii++) {
    for (int jj = j - 1; jj <= j+1; jj++) {
      if (inBounds(ii, jj)) {
        if (grid[ii][jj] == ALIVE) {
          count++;
        }
      }
    }
  }
  if (grid[i][j] == ALIVE) {
    count--;
  }
  return count;
}

void randGrid() {
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if (random(1) > 0.75) {
        grid[i][j] = ALIVE;
      } else {
        grid[i][j] = 0;
      }
    }
  }
}

void clearGrid() {
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      grid[i][j] = 0;
    }
  }
}

void saveCanvas(String name) {
  
  final PImage canvas = get();
  canvas.format = ARGB;

  final color p[] = canvas.pixels, bgt = BGND & ~#000000;
  for (int i = 0; i != p.length; ++i)  if (p[i] == BGND)  p[i] = bgt;

  canvas.updatePixels();
  canvas.save(dataPath(name + nf(frameCount, 4) + ".png"));
}

boolean inBounds(int i, int j) {
  return (i >= 0 && i < rows && j >= 0 && j < cols);
}
