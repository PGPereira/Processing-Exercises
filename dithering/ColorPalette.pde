class ColorPalette {
  ColorManager colorManager;
  int colorDepth;
  int colorSpace;
  color[] paletteScheme;
  color[] originalScheme;
  
  ColorPalette(int[] paletteScheme) {
    this.colorManager = new ColorManager();
    this.paletteScheme = paletteScheme;
    this.colorDepth = ceil(pow(paletteScheme.length, 1/3.0));
    this.colorSpace = int(pow(this.colorDepth, 3));
    this.originalScheme = new color[this.colorSpace];
    
    for(int r = 0; r < colorDepth; r++) {
      for(int g = 0; g < colorDepth; g++) {
        for(int b = 0; b < colorDepth; b++) {
           this.originalScheme[r*colorDepth*colorDepth + g*colorDepth + b*colorDepth] = color(r/float(colorDepth), g/float(colorDepth), b/float(colorDepth));  
        }
      }
    }
    
    float[][] distMatrix = new float[paletteScheme.length][colorSpace];
    for(int i = 0; i < paletteScheme.length; i++) {
      for(int j = 0; j < colorSpace; i++) {
        distMatrix[i][j] = this.colorManager.getColorDistance(paletteScheme[i], originalScheme[j]);
      }
    }
  }
} 
