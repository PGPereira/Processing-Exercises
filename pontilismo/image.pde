class image {
  PImage baseImage;
  int w, h;
  float maxColor[][][];
  
  int getArea(int x1, int x2, int y1, int y2) {
    return (x2 - x1) * (y2 - y1);
  }

  color getSquareAverageColor(point center, float radius) {   
    int x1 = getNumberWithBounds(0, round(center.x - radius), w);
    int x2 = getNumberWithBounds(0, round(center.x + radius), w);
    int y1 = getNumberWithBounds(0, round(center.y - radius), h);
    int y2 = getNumberWithBounds(0, round(center.y + radius), h);
    
    float area = getArea(x1, x2, y1, y2);
    float[] v = vectorSum(vectorSub(vectorSub(this.maxColor[x2][y2], this.maxColor[x1][y2]), this.maxColor[x2][y1]), this.maxColor[x1][y1]);
    
    return makeColor(constDivision(area, v));
  }

  void paintDot(int colorMode, dot d) {
    point center = d.getCenter();
    float radius = d.getRadius();
    
    d.assignColor(
      getColor(
        colorMode, 
        getSquareAverageColor(center, radius/2)
       )
    );
    
    d.paint(d.getType());
  }
  
  void assignMaxColor(int w, int h){
    this.maxColor = new float[w+1][h+1][4];
    float[] zero = {0, 0, 0, 0};
    
    for (int i = 0; i <= w; i++){
      for (int j = 0; j <= h; j++){
        if(i == 0 || j == 0){
          this.maxColor[i][j] = zero;
        } else {
          this.maxColor[i][j] = vectorSum(
            colorToArray(this.baseImage.pixels[(i - 1) + w * (j - 1)]),
            vectorSub(vectorSum(this.maxColor[i - 1][j], this.maxColor[i][j - 1]), this.maxColor[i - 1][j - 1]));    
        }
      }
    }
  }

  image(String photoName) {
    this.baseImage = loadImage(photoName);
    w = this.baseImage.width;
    h = this.baseImage.height;
    
    assignMaxColor(w, h);
  }
}
