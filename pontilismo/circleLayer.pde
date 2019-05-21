class circleLayer implements layer {
    point center;
    float radius;
    color c;
  
    boolean pointInBoundary(dot d){
      return (this.center.euclidianDistance(d.getCenter()) <= radius);
    }
    
    color getColor(){
      return c;
    }
    
    void paint(){
      ellipseMode(RADIUS);
      circle(center.x, center.y, radius);
    }

    circleLayer(point center, float radius, color c) {
      this.center = center;
      this.radius = radius;
      this.c = c;
    }
}
