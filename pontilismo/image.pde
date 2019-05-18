class image {
  layer[] layers;
  float[] defaultColor;
    
  void setLayer(int i, layer l){
     this.layers[i] = l;
  }
  
  void paintDot(int colorMode, dot d){ //<>// //<>//
    for(layer l : layers){ //<>//
      if(l.pointInBoundary(d)){ //<>// //<>//
        d.assignColor(getColor(colorMode, l.getColor())); //<>//
        d.paint(); //<>//
        return; //<>// //<>//
      } //<>//
    } //<>//
     //<>//
    d.assignColor(getColor(colorMode, defaultColor)); //<>// //<>//
    d.paint(); //<>// //<>//
  }
  
  image(int size, float[] defaultColor){
    this.layers = new layer[size];
    this.defaultColor = defaultColor;
  }
}
