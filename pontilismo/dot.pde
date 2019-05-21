static final int __CIRCLE = 1;
static final int __SQUARE = 2;
static final int __TRIANGLE = 3;
boolean rotates = false;

class dot  {
  point center;
  color c;
  float radius;
  int type;
  
  point getCenter(){
    return center;
  }
  
  float getRadius(){
    return this.radius;
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
        square(center.x, center.y, radius);
        break;
      case 3: 
        if (rotates) getTriangle(center, radius, random(0, 2 * PI)); 
        else getTriangle(center, radius, 0) ;
        break;
    }
  }
  
  dot(point center, float radius, color c, int type) {
     this.center = center;
     this.radius = radius;
     this.c = c;
     this.type = type;
  }
  
  dot(float x, float y, float radius, int type){
    this.center = new point(x, y);
    this.radius = radius;
    this.type = type;
  }
}
