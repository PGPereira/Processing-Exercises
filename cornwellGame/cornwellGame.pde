CorwellGrid game;
float sq; 
int x_offset, y_offset;
boolean timeForward = true;
boolean remixing = false;
boolean overlay = false;
int remixTime;
int iterationsPerSecond = 60;
boolean recording = true;
int recordFrameRate = 30;
int recordTime = 150;
float[][] colorGraph;
int[] ordered;
ArrayList<Integer> orderedList;

color[] nesPalette = {
  #59595F,
  #00008F,
  #18008F,
  #3F0077,
  #550055,
  #550011,
  #550000,
  #442200,
  #333300,
  #113300,
  #003311,
  #004444,
  #004466,
  //#000000,
  #0044DD,
  #5511EE,
  #7700EE,
  #9900BB,
  #AA0055,
  #993300,
  #884400,
  #666600,
  #336600,
  #006600,
  #006655,
  #005588,
  #EEEEEE,
  #4488FF,
  #7777FF,
  #9944FF,
  #BB44EE,
  #CC5599,
  #DD6644,
  #CC8800,
  #BBAA00,
  #77BB00,
  #22BB22,
  #22BB77,
  #22BBCC,
  #444444,
  #99CCFF,
  #AAAAFF,
  #BB99FF,
  #DD99FF,
  #EE99DD,
  #EEAAAA,
  #EEBB99,
  #EEDD88,
  #BBDD88,
  #99DD99,
  #99DDBB,
  #99DDEE,
  #AAAAAA
};

void setup() {
    size(1080, 1920, P2D);
    //fullScreen(P2D);
    //size(320, 240, P2D);
    //size(1280, 960, P2D);
    noStroke();
    //smooth();
    background(0);
    
    sq = 4.0;
    x_offset = 0;
    y_offset = 0;
    
    game = new CorwellGrid(width / 16, height / 16);
    //nesPalette = sort(nesPalette);
    colorGraph = new float[nesPalette.length][nesPalette.length];
    for (int i = 0; i < nesPalette.length; i++) {
      for (int j = 0; j < nesPalette.length; j++) {
          colorGraph[i][j] = colorDistance(nesPalette[i], nesPalette[j]);
      }
    }
    
    float mDistance = 999999999999999999999.0;
    orderedList = new ArrayList<Integer>();
    for (int begin = 0; begin < nesPalette.length; begin++) {
      ArrayList<Integer> actualList = new ArrayList<Integer>(nesPalette.length);
      actualList.add(begin);
      int i = begin;
      float summedDistance = 0;
      while (actualList.size() < nesPalette.length) {
        float distance = 999999999999999999.0;
        int actual = -1;
        
        for (Integer j = 0; j < nesPalette.length; j++) {
          if (!actualList.contains(j) && colorGraph[i][j] < distance) {
            distance = colorGraph[i][j];
            actual = j;
          }
        }
        
        summedDistance += colorGraph[i][actual];
        i = actual;
        actualList.add(i);
      }
        
      if (summedDistance < mDistance) {
        mDistance = summedDistance;
        orderedList = actualList;
      }
    }
    
    color[] orderedPalette = new color[nesPalette.length]; 
    for(int i = 0; i < nesPalette.length; i++) {
      orderedPalette[i] = nesPalette[orderedList.get(i)];      
    }
    nesPalette = reverse(orderedPalette);
    //reverse(nesPalette);
        
    //thread("calculateSteps");
    //thread("iterate");
    thread("stepsForRecord");
    colorMode(HSB);
}

void draw() {
    float scale = sq;
    int count = game.getCount();
    int gWidth = game.getWidth();
    int gHeight = game.getHeight();
    float sWidth = width/scale;
    float sHeight = height/scale;
    int x_offsetA = x_offset;
    int y_offsetA = y_offset;
    
    scale(scale);
    color c = nesPalette[0];
    background(c);
    int[][] lastAliveBoard = game.getLastAliveBoard(count);
    int[] minMax = game.getLastAliveExtremity(lastAliveBoard, count);
    for (int x = 0; x < gWidth; x++) {
      for (int y = 0; y < gHeight; y++) {
        int lastAlive = lastAliveBoard[x][y];
        if(lastAlive >= 0) {
          float fRatio = float(lastAlive - minMax[0])/minMax[2];
          color col = nesPalette[int((nesPalette.length - 1) * fRatio)];
          float delta = ceil(fRatio) - fRatio;
          color ceil = nesPalette[ceil((nesPalette.length - 1) * fRatio)];
          for (int i = Math.floorMod((x + x_offsetA), gWidth); i < sWidth; i += gWidth) {
            for (int j = Math.floorMod((y + y_offsetA), gHeight); j < sHeight; j += gHeight) {
                fill(col);
                square(i, j, 1);
                //int k = ceil(1/delta) + 1;
                //if(k >= 2 && k <= scale) {
                //  fill(ceil);
                //  println(delta, 1/delta, k);
                //  for(int w = 0; w < scale; w++) {
                //    for(int h = 0; h < scale; h++) {
                //       if ((w + h) % k == k - 1) {
                //          square(i + w/scale, j + h/scale, 1/scale);
                //        }
                //      }
                //  }
                //}
            }
          }
        }
      }
    }
    
    //textSize(7);
    //float palletes = float(width)/(nesPalette.length);
    //for (int x = 0; x < nesPalette.length; x++){
    //  fill(nesPalette[x]);
    //  rect(x * palletes, 0, (x + 1) * palletes, height);
      
    //  fill(255);
    //  text(hex(nesPalette[x]), x * palletes, height);
    //}
    
    if(overlay) {
      fill(nesPalette[nesPalette.length - 1]);
      scale(1/scale);
      float overlayWidth = width/64.0;
      float overlayHeight = height/64.0;
      translate(width - 9 * overlayWidth, overlayHeight);
      rect(0.0, 0.0, 8 * overlayWidth, 8 * overlayHeight);
      
      short[][] neighborsBoard = game.calculateNeighborsBoard(count);
      for (short[] coordinate : game.getCoordinates(count)) {
          int nCount = neighborsBoard[game.getX(coordinate[0])][game.getY(coordinate[1])];
          c = nesPalette[nCount];
          //fill(255 * (float(nCount) / 8.0), 255, 255);
          fill(c);
          for (int i = Math.floorMod((coordinate[0] + x_offsetA), gWidth); i < overlayWidth * 8.0; i += gWidth) {
              for (int j = Math.floorMod((coordinate[1] + y_offsetA), gHeight); j < overlayHeight * 8.0; j += gHeight) {
                  square(i, j, 1); 
              }
          }
      }
            
      fill(255);
      translate(10 * overlayWidth - width, overlayHeight);
      textSize(20);
      text(int(game.getCount()), 0, 0);
      textSize(12);
      text(frameRate, 0, 20);
      translate(-overlayWidth, -overlayHeight);
    }
    
    if (remixing && frameCount > remixTime) {
        remixing = false;
        timeForward = !timeForward;
    }
    
    if (timeForward) {
        game.nextStep();
    } else if (game.getCount() == 0) {
        timeForward = true;
    } else {
        game.previousStep();
    }
    
    if (recording) {
        print(game.getCount(), game.boardStack.size(), frameRate, '\n');
        saveFrame("teste/corwell-#####.tif");
        if(frameCount == recordFrameRate * recordTime) {
          exit();
        }
    }
}

void remix() {
    timeForward = !timeForward;
    remixing = true;
    remixTime = int(frameCount + random(0, 2 * frameRate));
}

void iterate() {
  while (true) {
    if (timeForward) {
        game.nextStep();
    } else if (game.getCount() == 0) {
        timeForward = true;
    } else {
        game.previousStep();
    }
    delay(1000/iterationsPerSecond);
  }
}

void stepsForRecord() {
  while(game.getStackSize() < recordFrameRate * recordTime) {
    game.calculateNextStep();
  }
}

void calculateSteps() {
    int count, stackSize;
    float frames;
    while(true) {
        count = game.getCount();
        stackSize = game.boardStack.size();
        frames = frameRate;
        
        if (count + frames >= stackSize) {
            for (int i = 0; i < ceil(2 * frames); i++) {
                game.calculateNextStep();
            }
        }
        
        print(game.getCount(), game.boardStack.size(), frames, '\n');
    }
}

void keyPressed() {
    if (key == 'q' || key == 'e') {
        timeForward = !timeForward;  
    }
    
    if (keyCode == UP || key == 'w') {
        y_offset += 0.5;
    }
    
    if (keyCode == LEFT || key == 'a') {
        x_offset -= 0.5;
    }
    
    if (keyCode == DOWN || key == 's') {
        y_offset -= 0.5;
    }
    
    if (keyCode == RIGHT || key == 'd') {
        x_offset += 0.5;
    }
    
    if (key == 'o') {
        sq--;
    }
    
    if (key == 'p') {
        sq++;
    }
    
    if (key == 'r') {
        remix();
    }
    
    if (key == 'f') {
        overlay = !overlay;
    }
}

float colorDistance(color a, color b) {
  float rLine = (red(a)+ red(b))/2;
  return sqrt((2 + rLine/256.0) * pow(red(a) - red(b),2) + 4 * pow(green(a) - green(b),2) + (2 + (256 - rLine)/256.0) * pow(blue(a) - blue(b),2));
}
