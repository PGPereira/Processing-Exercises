class ColorPalette {
  ColorManager colorManager;
  color[] palette;
  ArrayList<PVector> paletteVector;
  short[][][] ditheringSpace;
  int paletteSize; 
  String paletteName;
  
  ColorPalette(ColorManager colorManager, String paletteName, color[] palette) {
    this.colorManager = colorManager;
    this.palette = palette;
    this.paletteName = paletteName;
    this.paletteSize = palette.length;
    this.ditheringSpace = new short[256][256][256];
    
    sortPalette(palette, 0, paletteSize - 1);
    
    this.paletteVector = new ArrayList<PVector>(palette.length);
    for(int i = 0; i < palette.length; i++) {
      paletteVector.add(colorManager.getColorAsPVector(palette[i]));
    }
    
    for (int r = 0; r < 256; r++) {
      for (int g = 0; g < 256; g++) {
        for (int b = 0; b < 256; b++) {
          this.ditheringSpace[r][g][b] = -1;
        }
      }  
    }
  }
  
  ColorPalette(ColorManager colorManager, color[] palette) {
    this.colorManager = colorManager;
    this.palette = palette;
    this.paletteSize = palette.length;
    this.ditheringSpace = new short[256][256][256];
    
    sortPalette(this.palette, 0, this.paletteSize);
    
    paletteVector = new ArrayList<PVector>(palette.length);
    for(int i = 0; i < palette.length; i++) {
      paletteVector.add(colorManager.getColorAsPVector(palette[i]));
    }
    
    for (int r = 0; r < 256; r++) {
      for (int g = 0; g < 256; g++) {
        for (int b = 0; b < 256; b++) {
          this.ditheringSpace[r][g][b] = -1;
        }
      }  
    }
  }
  
  public String getName() {
    return this.paletteName;
  }
  
  public ArrayList<PVector> getPaletteVector() {
    return paletteVector;
  }
  
  public color getEquivalentColor(color c) {
    int r = (int)red(c);
    int g = (int)green(c);
    int b = (int)blue(c);
    
    int k = ditheringSpace[r][g][b];
    if (k == -1) {
      double[] a = colorSearch(c);
      k = ditheringSpace[r][g][b] = (short)a[0];
    }
    
    return palette[k];
  }
  
  private void sortPalette(color[] array, int begin, int end) {
     if(begin <= end)
       return; 
       
     float r = 0, minR = 256, maxR = -1;
     float g = 0, minG = 256, maxG = -1;
     float b = 0, minB = 256, maxB = -1;
     
     for (int i = begin; i < end; i++) {
       color c = array[i];
       r = red(c);
       g = green(c);
       b = blue(c);
       
       minR = min(r, minR);
       minG = min(g, minG);
       minB = min(b, minB);
       
       maxR = max(r, maxR);
       maxG = max(g, maxG);
       maxB = max(b, maxB);
     }
     
     float rangeR = maxR - minR;
     float rangeG = maxG - minG;
     float rangeB = maxB - minB;
     
     char comparator = colorManager.rangeOfRGB(rangeR, rangeG, rangeB);
     colorManager.quicksort(array, begin, end, comparator);
     
     float pivot = getRGBPivot(maxR, minR, maxG, minG, maxB, minB, comparator);
     int middle = colorManager.search(array, pivot, begin, end, comparator);
     
     println(begin, middle, end); 
     
     if(begin < middle) {
       sortPalette(array, begin, middle);
     }
     
     if(middle < end) {
       sortPalette(array, middle, end);
     }
  }
  
  private float getRGBPivot(float maxR, float minR, float maxG, float minG, float maxB, float minB, char comparator) {
    if(comparator == 'r'){
      return floor(minR + (maxR - minR)/2.0);
    } else if(comparator == 'g') {
      return floor(minG + (maxG - minG)/2.0);
    } else {
      return floor(minB + (maxB - minB)/2.0); 
    }
  }
  
  public PImage getImageInColorSpace(PImage image) {
    PImage changed = image.copy();
    
    changed.loadPixels();
    for(int i = 0; i < image.pixels.length; i++) {
      color c = changed.pixels[i];
      changed.pixels[i] = getEquivalentColor(c);
    }
    changed.updatePixels();
    
    return changed;
  }
  
  public PImage getStenographicImageInColorSpace(PImage image, String hideMessage) {
    PImage changed = image.copy();
    int k = 0;
    byte b1, b2;
    
    changed.loadPixels();
    for(int i = 0; i < image.pixels.length; i += 2) {
      char ch = hideMessage.charAt(k);
      b1 = (byte)((ch >> 8) & 0xFF);
      b2 = (byte)(ch & 0xFF);
      
      k = Math.floorMod(k + 1, hideMessage.length());
        
      color c1 = changed.pixels[i];
      color c2 = changed.pixels[i + 1];
      
      changed.pixels[i] = colorManager.getSteganograficColor(getEquivalentColor(c1), b1);
      changed.pixels[i + 1] = colorManager.getSteganograficColor(getEquivalentColor(c2), b2);
    }
    changed.updatePixels();
    
    return changed;
  }
  
  public color getColorByIndex(int index) {
    return palette[index];
  }
  
  public ColorPair getColorToupleWithStenography(color oldColor, PVector error, byte b) {
    return new ColorPair(colorManager, oldColor, getEquivalentStenographicColor(getEquivalentColor(colorManager.getColorWithError(oldColor, error)), b));
  }
  
  public ColorPair getColorToupleWithStenography(color oldColor, byte b) {
    return new ColorPair(colorManager, oldColor, getEquivalentStenographicColor(oldColor, b));
  }
  
  public ColorPair getColorToupleWithError(color oldColor, PVector error) {
    return new ColorPair(colorManager, oldColor, getEquivalentColor(colorManager.getColorWithError(oldColor, error)));
  }
  
  public ColorPair getColorTouple(color oldColor) {
    return new ColorPair(colorManager, oldColor, getEquivalentColor(oldColor));
  }
  
  public color getEquivalentColor(PVector c) {
    int r = int(max(min(c.x, 255), 0));
    int g = int(max(min(c.y, 255), 0));
    int b = int(max(min(c.z, 255), 0));
    int k = ditheringSpace[r][g][b];
    
    if (k == -1) {
      double[] a = colorSearch(c);
      k = ditheringSpace[r][g][b] = (short)a[0];
    }
    
    return palette[k];
  }
  
  public color getEquivalentStenographicColor(color c, byte b) {
    return colorManager.getSteganograficColor(getEquivalentColor(c), b);
  }
  
  public color getEquivalentStenographicColor(PVector c, byte b) {
    return colorManager.getSteganograficColor(getEquivalentColor(c), b);
  }
  
  public int getColorsQuantity() {
    return this.palette.length;
  }
  
  public double[] colorSearch(color c) {
    return colorSearch(colorManager.getColorAsPVector(c));
  }
  
  public double[] colorSearch(PVector c) {
    double distance = Double.MAX_VALUE;
    int position = -1;
    
    for(int i = 0; i < paletteVector.size(); i++) {
      double d = colorManager.getColorDistance(c, paletteVector.get(i));
      if(distance > d) {
        position = i;
        distance = d;
      }
    }
    
    double[] arr = {position, distance};
    return arr;
  }
  
  ColorMixer deviseBestMixingPlan(color c, int maxRatio) {
    return deviseBestMixingPlan(colorManager.getColorAsPVector(c), maxRatio);
  }
  
  ColorMixer deviseBestMixingPlan(PVector c, int maxRatio) {
    ColorMixer result = new ColorMixer(this.palette[0], this.palette[0], 0.5);
    double leastPenalty = Double.MAX_VALUE;
    int ratio = maxRatio/2;
    PVector c1, c2, diff;
    // Loop through every unique combination of two colors from the palette,
    // and through each possible way to mix those two colors. They can be
    // mixed in exactly 64 ways, when the threshold matrix is 8x8.
    
    for(int i = 0; i < palette.length; i++) {
      c1 = this.paletteVector.get(i);
      for(int j = i + 1; j < palette.length; j++) {
        c2 = this.paletteVector.get(j);
        diff = PVector.sub(c2, c1);        
        if(i != j) {
          // Determine the ratio of mixing for each channel.
          //   solve(r1 + ratio*(r2-r1)/64 = r, ratio)
          // Take a weighed average of these three ratios according to the
          // perceived luminosity of each channel (according to CCIR 601).
          ratio = ((c2.x != c1.x ? 299*64 * int(c.x - c1.x)/int(c2.x - c1.x)  :  0)
                +  (c2.y != c1.y ? 587*64 * int(c.y - c1.y)/int(c2.y - c1.y)  :  0)
                +  (c2.z != c1.z ? 114*64 * int(c.z - c1.z)/int(c2.z - c1.z)  :  0))
                / ((c2.x != c1.x ? 299 : 0)
                 + (c2.y != c1.y ? 587 : 0)
                 + (c2.z != c1.z ? 114 : 0));
                 
          if(ratio < 0) {
             ratio = 0;
          } else if(ratio > maxRatio) {
             ratio = maxRatio - 1;
          }
        } else {
          ratio = maxRatio/2;
        }
          
        float actualRatio = (float)ratio/maxRatio;  
        // Determine the two component colors
        
        // Determine what mixing them in this proportion will produce
        PVector sum = PVector.add(c1, PVector.mult(diff, actualRatio));
        // Determine how well that matches what we want to accomplish
        double penalty = evaluateMixingError(c, sum, c1, c2, actualRatio);
        if (penalty < leastPenalty) {
          leastPenalty = penalty;
          result = new ColorMixer(palette[i], palette[j], actualRatio);
        }
      }
    }
    
    println(leastPenalty, hex(result.colors[0]), hex(result.colors[1]), result.ratio);
    return result;
  }
  
  private double evaluateMixingError(PVector c, PVector sum, PVector c1, PVector c2, float ratio) {
    return colorManager.getColorDistance(c, sum) + colorManager.getColorDistance(c1, c2) * 0.1 * (Math.abs(ratio - 0.5) + 0.5);
  }
} 
