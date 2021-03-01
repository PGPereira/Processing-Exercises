class OrderedDither {
  int colorSpace, algorithm;
  ColorManager colorManager;
  color[] colorPalette;
  short[][][] ditheringSpace;
  int[][][] threshold = {
    {
      {64,  128},
      {192, 0}
    },{
      {0, 128, 32, 160},
      {192, 64, 224, 96},
      {48, 176, 16, 144},
      {246, 112, 208, 80},
    }
  };
  
  OrderedDither(color[] palette, int algorithm) {
    this.colorSpace = palette.length;
    this.algorithm = algorithm;
    this.ditheringSpace = new short[256][256][256];
    this.colorManager = new ColorManager();
    this.colorPalette = palette;
    
    for (int r = 0; r < 256; r++) {
      for (int g = 0; g < 256; g++) {
        for (int b = 0; b < 256; b++) {
          this.ditheringSpace[r][g][b] = -1;
          // INITIALIZE PD ONLY WHEN THE COLOR GET ACESSED.
          //for(short i = 0; i < this.colorSpace; i++) {
          //  float distance = this.getColorDistance(color(r, g, b), this.colorPalette[i]);
          //  if (distance < lessDistance) {
          //    this.ditheringSpace[r][g][b] = i;
          //    lessDistance = distance;
          //  }
          //}
        }
      }  
    }
  }
  
  public color getColorInPalette(color c) {
    int r = int(c >> 16 & 0xFF);
    int g = int(c >> 8 & 0xFF);
    int b = int(c & 0xFF);
    int k = ditheringSpace[r][g][b];
    if (k == -1) {
      float lessDistance = 999999999;
      for(short i = 0; i < this.colorSpace; i++) {
        color f = color(r,g,b);
        float distance = colorManager.getColorDistance(f, this.colorPalette[i]);
        if (distance < lessDistance) {
          k = this.ditheringSpace[r][g][b] = i;
          lessDistance = distance;
        }
      }
    }

    return colorPalette[k];
  }
  
  public PImage getDitheredImage(PImage image) {
    PImage changed = image.copy();
    
    changed.loadPixels();
    int tWidth = threshold[algorithm].length;
    
    for(int i = 0; i < changed.width; i++) {
      int tHeight = threshold[algorithm][i % tWidth].length;
      for(int j = 0; j < changed.height; j++) {
        int index = colorManager.getPixelIndex(i, j, image);
        color oldColor = changed.pixels[index];
        int lim = threshold[algorithm][i % tWidth][j % tHeight];
        float r = (red(oldColor) >= lim) ? 255 : 0;
        float g = (green(oldColor) >= lim) ? 255 : 0;
        float b = (blue(oldColor) >= lim) ? 255 : 0;
        changed.pixels[index] = getColorInPalette(color(r,g,b));
      }
    }
      
    changed.updatePixels();
    
    return changed;
  }
}
