class pointlism{
  float maxDotSize;
  dot[] dotlist;
  float colorCode[];
  
  point getPointInBoundairy(float dotSize){
    return new point(random(height), random(width));
  }
  
  void make(){
    stroke(makeColor(colorCode));
    for(dot d : this.dotlist){
      d.paint();
    }
  }
  
  dot getDot(){
    float dotSize = random(maxDotSize); 
    point p = this.getPointInBoundairy(dotSize);
    return new dot(p, dotSize, randomColor(colorCode));
  }
  
  void remake(){
    for(int i = 0; i < dotlist.length; i++)
      this.dotlist[i] = getDot();
  }
}

int getNOfDots(float largest, float smaller){
  return (int)(largest/smaller) * 20;
}
