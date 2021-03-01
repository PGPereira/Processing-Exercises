class ErrorScatherDither {
  ColorManager colorManager;
  int colorSpace;
  int factor;
  short[][][] ditheringSpace;
  color[] colorPalette;
  float[][][] ditherParam = {
    {
      {1, 0, 7/16.0}, 
      {-1, 1, 3/16.0} , 
      {0, 1, 5/16.0}, 
      {1, 1, 1/16.0}
    },
    {
       {1, 0, 7/48.0},
       {2, 0, 5/48.0},
       {-2, 1, 3/48.0},
       {-1, 1, 5/48.0},
       {0, 1, 7/48.0},
       {1, 1, 5/48.0},
       {2, 1, 3/48.0},
       {-2, 1, 1/48.0},
       {-1, 1, 3/48.0},
       {0, 1, 5/48.0},
       {1, 1, 3/48.0},
       {2, 1, 1/48.0},
    }
  };
  
  ErrorScatherDither(color[] palette) {
    this.colorPalette = palette;
    this.colorSpace = colorPalette.length;
    this.factor = int(pow(colorPalette.length, 1/3.0));
    println(this.factor);
    this.ditheringSpace = new short[256][256][256];
    this.colorManager = new ColorManager();
    
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
      float lessDistance = 999999999999999.0;
      for(short i = 0; i < this.colorSpace; i++) {
        color f = color(r,g,b);
        float distance = colorManager.getColorDistance(f, this.colorPalette[i]);
        if (distance <= lessDistance) {
          k = this.ditheringSpace[r][g][b] = i;
          lessDistance = distance;
        }
      }
    }
    
    return colorPalette[k];
  }
     
  public PImage getBoutrophedonDitheredImage(PImage image) {
    PImage changed = image.copy();
    
    changed.loadPixels();
    for(int j = 0; j < changed.height; j++) {
      if(j % 2 == 0) {
        for(int i = 0; i < changed.width; i++) {
          int index = colorManager.getPixelIndex(i, j, image);
          color oldColor = changed.pixels[index];
          color newColor = getColorInPalette(oldColor);
          changed.pixels[index] = newColor;
          PVector delta = colorManager.getColorDelta(oldColor, newColor);
          for(int d = 0; d < ditherParam[0].length; d++) {
            float[] param = ditherParam[0][d];
            if((i + param[0] < changed.width) && (i - param[0] < changed.width) && j + param[1] < changed.height) {
              index = colorManager.getPixelIndex(int(i + param[0]), int(j + param[1]), image);
              PVector toDither = colorManager.getColorAsPVector(changed.pixels[index]);
              PVector quanta = PVector.mult(delta, param[2]);
              
              changed.pixels[index] = colorManager.getPVectorAsColor(PVector.add(toDither, quanta));
            }  
          }
        }
      } else {
        for(int i = changed.width - 1; i >= 0; i--) {
          int index = colorManager.getPixelIndex(i, j, image);
          color oldColor = changed.pixels[index];
          color newColor = getColorInPalette(oldColor);
          changed.pixels[index] = newColor;
          PVector delta = colorManager.getColorDelta(oldColor, newColor);
          for(int d = 0; d < this.ditherParam[0].length; d++) {
            float[] param = ditherParam[0][d];
            if((i - param[0] >= 0) && (i - param[0] < changed.width)  && j + param[1] < changed.height) {
              index = colorManager.getPixelIndex(int(i - param[0]), int(j + param[1]), image);
              PVector toDither = colorManager.getColorAsPVector(changed.pixels[index]);
              PVector quanta = PVector.mult(delta, param[2]);
              
              changed.pixels[index] = colorManager.getPVectorAsColor(PVector.add(toDither, quanta));
            }  
          }
        }
      }
    }
    changed.updatePixels();
    
    return changed;
  }
  
  public PImage getImageInColorSpace(PImage image) {
    PImage changed = image.copy();
    
    changed.loadPixels();
    for(int i = 0; i < image.width; i++) {
      for(int j = 0; j < image.height; j++) {
        int index = colorManager.getPixelIndex(i, j, image);
        color c = changed.pixels[index];
        changed.pixels[index] = getColorInPalette(c);
      }
    }
    changed.updatePixels();
    
    return changed;
  }
  
  public color[] getPalette() {
    return this.colorPalette;
  }
  
  public PImage getDitheredImage(PImage image) {
    PImage changed = image.copy();
    
    changed.loadPixels();
    for(int j = 0; j < changed.height; j++) {
      for(int i = 0; i < changed.width; i++) {
        color oldColor = changed.pixels[colorManager.getPixelIndex(i, j, image)];
        //int r = round(factor * red(oldColor) / 255) * (255/factor);
        //int g = round(factor * green(oldColor) / 255) * (255/factor);
        //int b = round(factor * blue(oldColor) / 255) * (255/factor);
        color newColor = getColorInPalette(oldColor);
        //color newColor = getColorInPalette(color(r,g,b));
        
        changed.pixels[colorManager.getPixelIndex(i, j, image)] = newColor;
        PVector delta = colorManager.getColorDelta(oldColor, newColor);
        for(int d = 0; d < this.ditherParam[1].length; d++) {
          float[] param = ditherParam[1][d];
          if((i + param[0] < changed.width) && (i + param[0] >= 0) && (j + param[1] < changed.height)) {
            int index = colorManager.getPixelIndex(int(i + param[0]), int(j + param[1]), image);
            PVector toDither = colorManager.getColorAsPVector(changed.pixels[index]);
            PVector quanta = PVector.mult(delta, param[2]);
            changed.pixels[index] = colorManager.getPVectorAsColor(PVector.add(toDither, quanta));
          }  
        }
      }
    }
    changed.updatePixels();
    
    return changed;
  }
}
