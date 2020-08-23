static final int __TRIANGLE = 1;
static final int __SQUARE = 2;
static final int __CIRCLE = 0;
static final int __SORTED = 3;

static final int __DOTS = 4;
boolean rotates = false;

class dot  {
  point center;
  color c;
  float angle;
  float radius;
  int type;
  
  point getCenter(){
    return center;
  }
  
  float getRadius(){
    return this.radius;
  }
  
  color getColor(){
    return this.c;
  }
  
  float getAngle(){
     return this.angle;
  }
  
  int getType(){
    return this.type;
  }
  
  void assignColor(color c){
    this.c = c;
  }
  
  void paint(int type) {
    fill(c);
    
    switch (type){
      case __TRIANGLE: 
        if (rotates) {
          getTriangle(center, radius, angle);
        } else {
          getTriangle(center, radius, 0);
        }
        break;
      case __SQUARE:
        rectMode(RADIUS);
        if (rotates) {
          getSquare(center, radius, angle);
        } else {
          square(center.x, center.y, radius);
        }
        break;
      case __CIRCLE:
        ellipseMode(RADIUS);
        circle(center.x, center.y, radius);
        break;
      case __SORTED:
        paint((int)random(0, this.getType()));
        break;
      default:
        ellipseMode(RADIUS);
        circle(center.x, center.y, radius);
        break;
    }
  }
  
  dot(point center, float radius, float angle, int type) {
     this.center = center;
     this.radius = radius;
     this.angle = angle;
     this.type = type;
  }
  
  dot(float x, float y, float radius, float angle, int type){
    this.center = new point(x, y);
    this.radius = radius;
    this.angle = angle;
    this.type = type;
  }
}
