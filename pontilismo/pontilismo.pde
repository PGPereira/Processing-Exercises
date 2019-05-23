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
point mousePos;
image main;

float diagonal; 

void setup() {
  noStroke();
  ellipseMode(RADIUS);
  
  stepSize = 20;
  main = new image("Fidel.jpg");
  
  size(1013, 800);
  diagonal = euclidianDistance(0, 0, width, height);
  maxDotSize = min(width, height)/50;
}


void draw() {
    mousePos = new point(mouseX, mouseY);
    fill(255,255, 255, 10);
    rect(0, 0, width, height);
    
    int brush = frameCount / stepSize;
    brush %= 9;
    
    switch(brush){
      case 0:
        doPointlism(1, 2);
        break;
      case 1:
        rotates = true;
        doPointlism(2, 2);
        break;
      case 2:
        rotates = false;
        doPointlism(3, 2);
        break;
      case 3:
        doPixelate(2, 2, 6);
        doReticulate(1, 2);
        break;
      case 4:
        doPixelate(2, 1, 6);
        doReticulate(2, 2);
        break;
      case 5:
        doPixelate(2, 1, 6);
        rotates = false;
        doReticulate(3, 2);
        break;
      case 6:
        doPixelate(2, 1, 12);
        rotates = true;
        doReticulate(3, 2);
        break;
       case 7:
        rotates = true;
        doVortice(2, 1);
        break;
      case 8:
        doPixelate(2, 4, 6);
        doPixelate(1, 2, 3);
        doReticulate(3, 2);
        break;
    }
    
    //if(frameCount < stepSize * 9){
    //  saveFrame("frames/fidel-######.png");
    //} else exit();
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
    point center = new point(random(width), random(height));
    dot d = new dot(center, random(1, maxDotSize), angleFromPoints(mousePos, center), modePoint);
    main.paintDot(colorMode, d);
  }
}

void doReticulate(int modeReticulate, int colorMode){
  int step = 2;
  for(int i = step; i < width; i+=(step*3)){
    for(int j = step; j < height; j+=(step*3)){
        dot d = new dot(i, j, step, random(0, 2 * PI), modeReticulate);
        main.paintDot(colorMode, d);
    }
  }
}

void doPixelate(int mode, int colorMode, int pixelSize){
  int step = pixelSize;
  for(int i = 0; i < width; i+= (2 * step)){
    for(int j = 0; j < height; j+=(2 * step)){
        dot d = new dot(i, j, step, random(0, 2 * PI), mode);
        main.paintDot(colorMode, d);
    }
  }
}

void doVortice(int mode, int colorMode){
  float c = maxDotSize/diagonal;
  for (int i = 0; i < 10 * getNOfDots((maxDotSize)/2, mode); i++) {
    point center = new point(random(width), random(height));
    float size = (center.euclidianDistance(mousePos) * c) + 1;
    dot d = new dot(center, size, angleFromPoints(mousePos, center), mode);
    main.paintDot(colorMode, d);
  }
}
