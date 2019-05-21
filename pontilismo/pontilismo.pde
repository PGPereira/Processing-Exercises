float maxDotSize; //<>//
int stepSize;
color colorsObj[]= {
  color(220, 204, 178),
  color(193, 189, 177),
  color(153, 147, 135),
  color(40, 39, 37),
  color(175, 142, 151),
  color(49, 90, 120),
  color(120, 156, 204),
  color(76, 146, 73),
  color(228, 194, 94),
  color(222, 152, 66),
  color(240, 91, 51),
  color(169, 164, 149),
  color(165, 132, 63)
};

color mainColor = color(231, 221, 215);

image main;

void setup() {
  noStroke();
  ellipseMode(RADIUS);
  stepSize = 20;
  main = new image("./teste.jpg");
  
  
  size(1013, 800);
  maxDotSize = min(width, height)/50;
}


void draw() {
    if (frameCount < stepSize){
      //background(closestGray(mainColor));
      doPointlism(1, 2);
    }
    else if (frameCount < stepSize * 2){
      //background(closestGray(mainColor));
      doPointlism(2, 2);
    }
    else if (frameCount < stepSize * 3) {
      //background(closestGray(mainColor));
      rotates = false;
      doPointlism(3, 2);
    }
    else if (frameCount < stepSize * 4){
      //background(closestGray(mainColor));
      rotates = true;
      doPointlism(3, 2);
    } 
    else if (frameCount < stepSize * 5){
      background(0);
      doReticulate(1, 2);
    }
    else if (frameCount < stepSize * 6){
      background(0);
      doReticulate(2, 1);
    }
    else if (frameCount < stepSize * 7) {
      background(0);
      rotates = false;
      doReticulate(3, 1);
    }
    else if (frameCount < stepSize * 8){
      background(0);
      rotates = true;
      doReticulate(3, 1);
    } else { 
      doPixelate(2, 1, 12);
      //doReticulate(1, 4);
    } 
    
    if(frameCount < stepSize * 9){
      //saveFrame();
    } else exit();
    
    println(frameCount, frameRate);
}

void doReticulate(int modeReticulate, int colorMode){
  int step = 2;
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
    dot d = new dot(random(width), random(height), random(1, maxDotSize), modePoint);
    main.paintDot(colorMode, d);
  }
}

void doPixelate(int mode, int colorMode, int pixelSize){
  int step = pixelSize;
  for(int i = 0; i < width; i+=step){
    for(int j = 0; j < height; j+=step){
        dot d = new dot(i, j, step, mode);
        main.paintDot(colorMode, d);
    }
  }
}
