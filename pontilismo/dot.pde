static final int __CIRCLE = 1;
static final int __SQUARE = 2;
static final int __TRIANGLE = 3;
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
  
  float getAngle(){
     return this.angle;
  }
  
  void assignColor(color c){
    this.c = c;
  }
  
  void paint(){
    fill(c);
    switch (type){
      case 1:
        circle(center.x, center.y, radius);
        break;
      case 2:
        rectMode(RADIUS);
        if (rotates) getSquare(center, radius, angle); 
        else square(center.x, center.y, radius);
        break;
      case 3: 
        if (rotates) getTriangle(center, radius, angle); 
        else getTriangle(center, radius, 0) ;
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
    this.type = type;
  }
}
