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
  
  circlePointlism(point center, float radius, int points, float maxPointSize, float[] c){
    this.center = center;
    this.radius = radius;
    this.maxDotSize = maxPointSize;
    this.colorCode = c;
    this.dotlist = new dot[points];  
    this.remake();
  }
}

int getNOfDotsForCircle(float dotRadius, float circleRadius){
  return getNOfDots(pow(circleRadius, 2), pow(dotRadius, 2));
}
