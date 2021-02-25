float sq;
int x_offset, y_offset;
CorwellBoard game;

void setup() {
    fullScreen(P2D);
    noStroke();
    background(0);
    colorMode(HSB);
    
    sq = 2.0;
    x_offset = 0;
    y_offset = 0;
    
    game = new CorwellBoard(width / 8, height / 8);
}

void draw() {
    background(0);
    
    for (int i = 0; i < width / sq; i++) {
        for (int j = 0; j < height / sq; j++) {
            int nCount = game.getNeighborsCount(i + x_offset, j + y_offset);
            if (game.getCell(i + x_offset, j + y_offset)) {    
                fill(127.5 * (sin(float(nCount)/8.0 * TWO_PI) + 1), 255.0, 255);
                circle(i * sq, j * sq, sq);
            }
        }
    }
    
    game.nextStep();
}

void keyPressed() {
    if (keyCode == UP || key == 'w') {
        y_offset++;
    }
    
    if (keyCode == LEFT || key == 'a') {
        x_offset--;
    }
    
    if (keyCode == DOWN || key == 's') {
        y_offset--;
    }
    
    if (keyCode == RIGHT || key == 'd') {
        x_offset++;
    }
    
    if (key == 'o') {
        sq = max(0.1, sq - 0.1);
    }
    
    if (key == 'p') {
        sq += 0.1;
    } 
}
