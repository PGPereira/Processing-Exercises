class point{
  float x, y;
  point(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  float euclidianDistance(point p){
    return sqrt(pow((this.x - p.x),2) + pow((this.y - p.y), 2)); 
  }
}

float baseRadius = 265;
float graduation = baseRadius/11.0;
color colorsObj[][]= {
  {231, 221, 215},
  {220, 204, 178},
  {193, 189, 177},
  {153, 147, 135},
  {40, 39, 37},
  {175, 142, 151},
  {49, 90, 120},
  {120, 156, 204},
  {76, 146, 73},
  {228, 194, 94},
  {222, 152, 66},
  {240, 91, 51},
  {169,164,149},
  {165,132,63}
};

class pointlism{
  float maxDotSize;
  dot[] dotlist;
  int colorCode[];
  
  point getPointInBoundairy(float dotSize){
    return new point(random(height), random(width));
  }
  
  void make(){
    for(dot d : this.dotlist){
      d.dotIt();
    }
  }
  
  dot getDot(){
    float dotSize = random(maxDotSize); 
    point p = this.getPointInBoundairy(dotSize);
    return new dot(p, dotSize, randomColor(colorCode[0], colorCode[1], colorCode[2]));
  }
  
  void remake(){
    for(int i = 0; i < dotlist.length; i++)
      this.dotlist[i] = getDot();
  }
}

class dot {
  point center;
  color c;
  float radius;
  
  void dotIt(){
    fill(c);
    circle(center.x, center.y, radius);
  }
  
  dot(point center, float radius, color c) {
     this.center = center;
     this.radius = radius;
     this.c = c;
  }
}

color randomColor(int red, int green, int blue){
  float total  = (float) Math.cbrt(red*red + green*green + blue*blue);
  float rand = random(total - 40, total + 40);
  float c = rand/total;
  return color(red*c, green*c, blue*c);
}

class rectanglePointlism extends pointlism{
  point topCorner;
  float h;
  float w;
  
  point getPointInBoundairy(float pointRadius){
    return new point(random(topCorner.x + pointRadius, topCorner.x + w - pointRadius), random(topCorner.y + pointRadius, topCorner.y + h - pointRadius));
  }
  
  rectanglePointlism(point topCorner, float w, float h, int points, float maxPointSize, int[] c){
    this.topCorner = topCorner;
    this.w = w;
    this.h = h;
    this.maxDotSize = maxPointSize;
    this.colorCode = c;
    this.dotlist = new dot[points];
    this.remake();
  }
}

class circlePointlism extends pointlism{
  point center;
  float radius;
  
  point getPointInBoundairy(float pointRadius){
    while (true) {
      point p = new point(random(center.x - radius, center.x + radius), random(center.y - radius, center.y + radius));
      if(this.center.euclidianDistance(p) <= radius - pointRadius){
        return p;
      }
    }
  }
  
  circlePointlism(point center, float radius, int points, float maxPointSize, int[] c){
    this.center = center;
    this.radius = radius;
    this.maxDotSize = maxPointSize;
    this.colorCode = c;
    this.dotlist = new dot[points];  
    this.remake();
  }
}

pointlism cP[] = new pointlism[14];

int getNOfDots(float largest, float smaller){
  return (int)(largest/smaller) * 20;
}

int getNOfDotsForCircle(float dotRadius, float circleRadius){
  return getNOfDots((circleRadius * circleRadius), (dotRadius * dotRadius));
}

int getNOfDotsForRectangle(float dotRadius, float w, float h){
  return getNOfDots((w * h), PI*(dotRadius * dotRadius));
}

void setup(){
  size(800, 800);
  ellipseMode(RADIUS);
  noStroke();
  point center = new point(width/2, height/2);
  float maxDotSize = graduation / 5;
  
  cP[0] = new rectanglePointlism(new point(0, 0), width, height, getNOfDotsForRectangle(maxDotSize, width, height), maxDotSize, colorsObj[0]);
  for (int i = 1; i < 12; i++){    
    cP[i] = new circlePointlism(center, baseRadius - i*graduation, getNOfDotsForCircle(maxDotSize, 165 - i * 15), maxDotSize, colorsObj[i]);
  }
  cP[12] = new rectanglePointlism(new point((width - graduation)/2, height/2), graduation, graduation*6, getNOfDotsForRectangle(graduation/4, graduation*6.5, graduation), maxDotSize, colorsObj[12]);
  cP[13] = new rectanglePointlism(new point((width - graduation)/2, height/2 + graduation * 6), graduation, graduation*4, getNOfDotsForRectangle(graduation/4, graduation*4.5, graduation), maxDotSize, colorsObj[13]);
}

void draw(){
  background(231, 221, 215);
  println(frameRate);
  for(pointlism c : cP){
    c.make();
    c.remake();
  };
  
  if (frameCount <= 200){
    saveFrame();
  } else exit();
}
