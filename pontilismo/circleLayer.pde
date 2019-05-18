class circleLayer implements layer {
    point center;
    float radius;
    float[] c;
  
    boolean pointInBoundary(dot d){
      return (this.center.euclidianDistance(d.getCenter()) <= radius);
    }
    
    float[] getColor(){
      return c;
    }
    
    void paint(){
      ellipseMode(RADIUS);
      circle(center.x, center.y, radius);
    }

    circleLayer(point center, float radius, float[] c) {
      this.center = center;
      this.radius = radius;
      this.c = c;
    }
}
