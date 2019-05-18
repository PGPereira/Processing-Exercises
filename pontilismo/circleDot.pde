class circleDot implements dot {
  point center;
  color c;
  float radius;
  
  void paint(){
    fill(c);
    circle(center.x, center.y, radius);
  }
  
  circleDot(point center, float radius, color c) {
     this.center = center;
     this.radius = radius;
     this.c = c;
  }
}
