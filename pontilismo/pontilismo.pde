float baseRadius = 265;
float graduation = baseRadius/11.0;
float colorsObj[][]= {
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

pointlism cP[] = new pointlism[14];

void setup(){
  size(800, 800);
  ellipseMode(RADIUS);
  point center = new point(width/2, height/2);
  float maxDotSize = graduation / 3;
  
  cP[0] = new rectanglePointlism(new point(0, 0), width, height, getNOfDotsForRectangle(maxDotSize, width, height), maxDotSize, colorsObj[0]);
  for (int i = 1; i < 12; i++){    
    cP[i] = new circlePointlism(center, baseRadius - i*graduation, getNOfDotsForCircle(maxDotSize, 165 - i * 15), maxDotSize, colorsObj[i]);
  }
  cP[12] = new rectanglePointlism(new point((width - graduation)/2, height/2), graduation, graduation*6, getNOfDotsForRectangle(maxDotSize, graduation*6, graduation), maxDotSize, colorsObj[12]);
  cP[13] = new rectanglePointlism(new point((width - graduation)/2, height/2 + graduation * 6), graduation, graduation*4, getNOfDotsForRectangle(maxDotSize, graduation*4, graduation), maxDotSize, colorsObj[13]);
}

void draw(){
  background(231, 221, 215);
  println(frameRate);
  for(pointlism c : cP){
    c.make();
    c.remake();
  };
}
