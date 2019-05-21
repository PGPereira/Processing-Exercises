class image {
  float  subset[][][];
  PImage baseImage;
  int w, h;

  void colorSum() {
    this.baseImage.loadPixels();
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        subset[i][j] = colorToArray(this.baseImage.pixels[i + w * j]);
        
        if (i > 0) {
          subset[i][j] = vectorSum(subset[i][j], subset[i - 1][j]);
        }
        
        if (j > 0) {
          subset[i][j] = vectorSum(subset[i][j], subset[i][j - 1]);
        }
        
        if (i > 0 && j > 0) {
          subset[i][j] = vectorSub(subset[i][j], subset[i - 1][j - 1]);
        } 
        
        //println(subset[i][j][0] + ' ' + subset[i][j][1] + ' ' + subset[i][j][2] + ' ' + subset[i][j][3]);
        this.baseImage.updatePixels();
      }
    }
  }

  color getSquareAverageColor(dot d) {
    //int x1, x2, y1, y2;
    //float radius = (float) d.getRadius();
    //x1 = getNumberWithBounds(0, (int)(d.getCenter().x - radius), w - 1);
    //x2 = getNumberWithBounds(0, (int)(d.getCenter().x + radius), w - 1);
    //y1 = getNumberWithBounds(0, (int)(d.getCenter().y - radius), h - 1);
    //y2 = getNumberWithBounds(0, (int)(d.getCenter().y + radius), h - 1);

    //float[] v = vectorSub(subset[x2][y2], subset[x1][y1]);
    //return makeColor(constProduct(1/((x2 - x1) * (y2 - y1)), v));

    this.baseImage.loadPixels();
    return this.baseImage.pixels[(int)d.getCenter().x + w * (int)d.getCenter().y];
  }

  void paintDot(int colorMode, dot d) {
    d.assignColor(getColor(colorMode, getSquareAverageColor(d)));
    d.paint();
  }

  image(String photoName) {
    this.baseImage = loadImage(photoName);
    w = this.baseImage.width;
    h = this.baseImage.height;
    this.subset = new float [w][h][4];
    //this.colorSum();
  }
}
