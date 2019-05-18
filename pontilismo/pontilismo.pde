float baseRadius = 265; //<>//
float graduation = baseRadius/11.0;
float maxDotSize = graduation/2;
int stepSize;
float colorsObj[][]= {
  //{231, 221, 215},
  {220, 204, 178}, //0
  {193, 189, 177}, //1
  {153, 147, 135}, //2
  {40, 39, 37}, //3
  {175, 142, 151}, //4
  {49, 90, 120}, //5
  {120, 156, 204}, //6
  {76, 146, 73}, //7
  {228, 194, 94}, //8
  {222, 152, 66}, //9
  {240, 91, 51}, //10
  {169, 164, 149}, //11
  {165, 132, 63} //12
};

float[] mainColor = {231.0, 221.0, 215.0};

image main;

void setup() {
  size(800, 800);
  noStroke();
  ellipseMode(RADIUS);
  stepSize = 4 * 20;
  point center = new point(width/2, height/2);
  main = new image(13, mainColor);
  
  main.layers[0] =  new rectLayer(new point((width - graduation)/2, height/2 + graduation * 7), graduation, graduation * 4, colorsObj[12]);
  main.layers[1] =  new rectLayer(new point((width - graduation)/2, height/2), graduation, graduation*7, colorsObj[11]);


  for(int i = 2; i < 13; i++){
    int antI = 13 - i;
    main.layers[i] = new circleLayer(center, baseRadius - (12 - i) * graduation, colorsObj[antI]);
  }
}


void draw() {
    background(0);
    doPointlism(3, 2);
    doReticulate(1, 1);
  
    if (frameCount < stepSize){
      background(closestGray(mainColor));
      doPointlism(1, 2);
    }
    else if (frameCount < stepSize * 2){
      background(closestGray(mainColor));
      doPointlism(2, 2);
    }
    else if (frameCount < stepSize * 3) {
      background(closestGray(mainColor));
      rotates = false;
      doPointlism(3, 2);
    }
    else if (frameCount < stepSize * 4){
      background(closestGray(mainColor));
      rotates = true;
      doPointlism(3, 2);
    } //<>// //<>// //<>//
    else if (frameCount < stepSize * 5){
      background(0);
      doReticulate(1, 2);
    }
    else if (frameCount < stepSize * 6){
      background(0);
      doReticulate(2, 2);
    }
    else if (frameCount < stepSize * 7) {
      background(0);
      rotates = false;
      doReticulate(3, 2);
    }
    else if (frameCount < stepSize * 8){
      background(0);
      rotates = true;
      doReticulate(3, 2);
    }
    else if (frameCount < stepSize * 9){
      background(0);
      rotates = true;
      doPointlism(3, 2);
      doReticulate(1, 3);
    }
    
    if(frameCount < stepSize * 9){
      saveFrame();
    } else exit();
}

void doReticulate(int modeReticulate, int colorMode){
  int step = 3;
  for(int i = step; i < width; i+=(step*3)){
    for(int j = step; j < height; j+=(step*3)){
        dot d = new dot(i, j, step, modeReticulate);
        main.paintDot(colorMode, d);
    }
  }
}

float getNOfDots(float dotSize, int dotType){
  float area = width * height;
  switch (dotType) {
    case 1:
      return area/(pow(dotSize,2) * PI); 
    case 2:
      return area/(pow(dotSize,2) * PI);
    case 3:
      return 2 * area/(3 * pow(dotSize,2) * sqrt(3));
    default:
      return 0;
  }
}

void doPointlism(int modePoint, int colorMode){
  for (int i = 0; i < 10 * getNOfDots((maxDotSize)/2, modePoint); i++) {
    dot d = new dot(random(width), random(height), random(maxDotSize), modePoint);
    main.paintDot(colorMode, d);
  }
}
