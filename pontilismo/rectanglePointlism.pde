class rectanglePointlism extends pointlism{
  point topCorner;
  float h;
  float w;
  
  point getPointInBoundairy(float pointRadius){
    return new point(random(topCorner.x + pointRadius, topCorner.x + w - pointRadius), random(topCorner.y + pointRadius, topCorner.y + h - pointRadius));
  }
  
  rectanglePointlism(point topCorner, float w, float h, int points, float maxPointSize, float[] c){
    this.topCorner = topCorner;
    this.w = w;
    this.h = h;
    this.maxDotSize = maxPointSize;
    this.colorCode = c;
    this.dotlist = new dot[points];
    this.remake();
  }
}

int getNOfDotsForRectangle(float dotRadius, float w, float h){
  return getNOfDots((w * h), PI*(pow(dotRadius, 2)));
}
