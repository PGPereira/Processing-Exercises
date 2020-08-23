float maxDotSize; //<>//
float minDotSize;
int stepSize;
point mousePos;
image main;

static final int __POINTLISM = 0;
static final int __VORTEX = 1;
static final int __PIXEL = 2;
static final int __RETICULATE = 3;

static final int __BRUSHS = 3;

float c;
float diagonal;
int brush;
int modePoint;
int modeColor;
int modeStroke;

void setup() {
  stepSize = 1;
  
  main = new image("Bengal Tiger.jpg");
  size(1000, 667);
  
  fill(255, 255, 255, 255);
  rect(0, 0, width, height);
  
  rotates = true;
  brush = 0;
  modePoint = 0;
  modeColor = __CLOSECOLOR;
  
  noStroke();
  diagonal = euclidianDistance(0, 0, width, height);
  maxDotSize = pow(diagonal, 1/3.0);
  minDotSize = pow(diagonal, 1/5.0);
  c = (maxDotSize - minDotSize)/(diagonal/2);
  mousePos = new point(535, 145);
  
  println(diagonal, maxDotSize, minDotSize);
}


void draw() {
  for (int i = 0; i < 100; i++){
    point center = new point(random(width), random(height));
    dot d = new dot(center, random(minDotSize, maxDotSize), angleFromPoints(center, mousePos), modePoint);
    //stroke(color(main.getSquareAverageColor(center, maxDotSize)));
    main.paintDot(modeColor, d);
  }
  saveFrame("frames/pointlism-######.tiff");
}

float getNOfDots(float dotSize, int dotType){
  float area = width * height;
  switch (dotType) {
    case __CIRCLE:
      return area/(pow(dotSize,2) * PI); 
    case __SQUARE:
      return area/(pow(dotSize,2));
    case __TRIANGLE:
      return area/(0.75 * pow(dotSize,2) * sqrt(3));
    case __SORTED:
      return area/(0.75 * pow(dotSize,2) * sqrt(3));
    default:
      return 0;
  }
}

void brush(int brush) {
  switch(brush){
    case __POINTLISM:
      doPointlism();
      break;
    case __RETICULATE:
      doReticulate();
      break;
    case __PIXEL:
      doPixelate();
      break;
    case __VORTEX:
      doVortice();
      break;
  }
}

void doPointlism(){
  for (float i = maxDotSize; i > minDotSize; i--){
    for (int j = 0; j < getNOfDots(i - 1, modePoint); j++) {
      point center = new point(random(width), random(height));
      dot d = new dot(center, random(i - 1, i), random(0, 2 * PI), modePoint);
      stroke(getColor(modeColor, color(main.getSquareAverageColor(center, maxDotSize))));
      main.paintDot(modeColor, d);
    }
  }  
}

void doReticulate(){
  int step = 2;
  for(int i = step; i <= width; i += (step*2 + 1)){
    for(int j = step; j <= height; j += (step*2 + 1)){
        dot d = new dot(i, j, step, 0, modePoint);
        main.paintDot(modeColor, d);
    }
  }
}

void doPixelate(){
  int step = (int) minDotSize;
  for(int i = step; i <= width; i+= (step*2)){
    for(int j = step; j <= height; j+= (step*2)){
        point center = new point(i, j);
        dot d = new dot(i, j, step, 0, modePoint);
        stroke(getColor(modeColor, color(main.getSquareAverageColor(center, maxDotSize))));
        main.paintDot(modeColor, d);
    }
  }
}

void doVortice(){
  float c = (maxDotSize - minDotSize)/(diagonal/2);
  for (float i = maxDotSize; i >= minDotSize; i--){  
    for (int j = 0; j < getNOfDots(i, modePoint); j++) {
      point center = new point(random(width), random(height));
      float size = (center.euclidianDistance(mousePos) * c) + minDotSize;
      dot d = new dot(center, size, angleFromPoints(center, mousePos  ), modePoint);
      
      stroke(getColor(modeColor, color(main.getSquareAverageColor(center, maxDotSize))));
      main.paintDot(modeColor, d);
    }
  } 
}
