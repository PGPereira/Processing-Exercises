float sq, x_offset, y_offset;
boolean timeForward = true;
boolean remixing;
boolean pool = false;
int remixTime;
CorwellGrid game;

void setup() {
    fullScreen(P2D);
    noStroke();
    
    background(0);
    colorMode(HSB);
    
    sq = 2.0;
    x_offset = 0;
    y_offset = 0;
    
    game = new CorwellGrid(width / 8, height / 8);
}

void draw() {
    background(0);
    
    if (!pool && game.boardStack.size() - 51 < game.getCount()) {
        thread("calculateSteps");
    }
    
    float fillsX = (sq * game.getWidth());
    float fillsY = (sq * game.getHeight());
    float x_offsetA = x_offset;
    float y_offsetA = y_offset;
    
    print(game.getCount(), game.boardStack.size(), '\n');
    
    for (short[] coordinate : game.getCoordinates()) {  
        for (float i = coordinate[0] * sq; i < width; i += fillsX) {
            for (float j = coordinate[1] * sq; j < height; j += fillsY) {
                int nCount = game.getNeighborsCount(coordinate[0], coordinate[1]);
                fill(255 * (float(nCount) / 8.0), 255, 255);
                float xPos = i + x_offsetA;
                float yPos = j + y_offsetA;
                square(Math.floorMod(int(xPos), width) , Math.floorMod(int(yPos), height) + (yPos - int(yPos)), sq);
            }
        }
    }
    
    //float count = float(game.getCount()); 
    //for (int x = 0; x < game.getWidth(); x++){
    //  for (int y = 0; y < game.getHeight(); y++) {
    //    for (float i = x * sq - 1; i <= width + 1; i += fillsX) {
    //      for (float j = y * sq - 1; j < height + 1; j += fillsY) {
    //        float xPos = i + x_offsetA;
    //        float yPos = j + y_offsetA;
    //        int nCount = game.getLastAlive(x, y);
    //        if (nCount > 0 && nCount <= count) {
    //          fill(255.0 * (nCount / count), 255, 255);
    //          square(Math.floorMod(int(xPos), width)  + (xPos - int(xPos)), Math.floorMod(int(yPos), height) + (yPos - int(yPos)), sq);
    //        }
    //      }
    //    }
    //  }
   //}
    
    fill(color(255));
    textSize(20);
    text(int(game.getCount()), 10, 30);
    textSize(12);
    text(frameRate, 10, 50);
    
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
}

void remix() {
    timeForward = !timeForward;
    remixing = true;
    remixTime = int(frameCount + random(0, 2 * frameRate));
}

void calculateSteps() {
    pool = true;
    for (int i = 0; i < 50; i++) {
        game.calculateNextStep();
    }
    pool = false;
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
        sq = max(0.1, sq - 0.05);
    }
    
    if (key == 'p') {
        sq += 0.05;
    }
    
    if (key == 'r') {
        remix();
    }
}
