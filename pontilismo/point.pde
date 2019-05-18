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
