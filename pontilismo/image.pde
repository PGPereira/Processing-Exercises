class image {
  PImage baseImage;
  int w, h;
  
  int getArea(int x1, int x2, int y1, int y2){
    //println(end.x, begin.x, end.y, begin.y);
    return (x2 - x1) * (y2 - y1);
  }

  color getSquareAverageColor(dot d) {
    point center = d.getCenter();
    float radius = d.getRadius();
    
    int x1 = getNumberWithBounds(0, round(center.x - radius), w);
    int x2 = getNumberWithBounds(0, round(center.x + radius), w);
    int y1 = getNumberWithBounds(0, round(center.y - radius), h);
    int y2 = getNumberWithBounds(0, round(center.y + radius), h);
    
    float area = getArea(x1, x2, y1, y2);
    float[] v = {0, 0, 0, 0};
    
    for (int i = x1; i < x2; i++){
      for (int j = y1; j < y2; j++){
        v = vectorSum(v, colorToArray(this.baseImage.pixels[i + w * j]));
      }
    }
    
    return makeColor(constDivision(area, v));
    
    ////float[] sum = getPositionSum(a, b);
    ////return (makeColor(sum));

    
    //return this.baseImage.pixels[(int)d.getCenter().x + w * (int)d.getCenter().y];
  }

  void paintDot(int colorMode, dot d) {
    d.assignColor(getColor(colorMode, getSquareAverageColor(d)));
    d.paint();
  }

  image(String photoName) {
    this.baseImage = loadImage(photoName);
    w = this.baseImage.width;
    h = this.baseImage.height;
  }
}
