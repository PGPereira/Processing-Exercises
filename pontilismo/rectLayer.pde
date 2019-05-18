class rectLayer implements layer {
    point topCorner;
    float h, w;
    float[] c;
    
    float[] getColor(){
      return c;
    }
  
    boolean pointInBoundary(dot d){
      point p = d.getCenter();  //<>//
      return (p.x >= topCorner.x && p.x <= (topCorner.x + w) && p.y >= topCorner.y && p.y <= (topCorner.y + h)); //<>//
    }
    
    void paint(){
      rect(topCorner.x, topCorner.y, w, h);
    }

    rectLayer(point topCorner, float w, float h, float[] c) {
      this.topCorner = topCorner;
      this.h = h;
      this.w = w;
      this.c = c;
    }
}
