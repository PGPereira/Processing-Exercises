class OrderedDither implements Dither {
  int colorSpace, algorithm;
  ColorManager colorManager;
  ColorPalette palette;
  float[][] threshouldMatrix;
  String name;
  
  OrderedDither(ColorManager colorManager, ColorPalette palette, float[][] threshouldMatrix) {
    this.palette = palette;
    this.colorManager = colorManager;
    this.threshouldMatrix = threshouldMatrix;
    this.name = "Ordered Dither " + threshouldMatrix.length + "x" + threshouldMatrix[0].length;
  }
  
  public String getName() {
    return this.name;
  }
  
  public ColorPalette getPalette() {
    return this.palette;
  }
  
  public void setPalette(color[] palette) {
    this.palette = new ColorPalette(colorManager, palette);
  }
  
  public void setPalette(ColorPalette palette) {
    this.palette = palette;
  }
  
  public PImage getDitheredImage(PImage image) {
    PImage changed = image.copy();
    
    int tWidth = threshouldMatrix.length;
    //int maxRatio = threshouldMatrix[0].length * threshouldMatrix.length;
    //color[][] mix = getMathematicalMixColor(image, threshouldMatrix);
    //float factor = 255/4.0;
    changed.loadPixels();
    for(int i = 0; i < changed.width; i++) {
      int tHeight = threshouldMatrix[i % tWidth].length;
      for(int j = 0; j < changed.height; j++) {
        int index = colorManager.getPixelIndex(i, j, changed);
        color oldColor = changed.pixels[index];
        //ColorMixer plan = palette.deviseBestMixingPlan(oldColor, maxRatio);
        
        float lim = threshouldMatrix[i % tWidth][j % tHeight];
        
        ////float value = brightness(oldColor) > lim ? lim : 0;
        float r = (float)(oldColor >> 16 & 0xFF) * (1 + lim);
        float g = (float)(oldColor >> 8 & 0xFF) * (1 + lim);
        float b = (float)(oldColor & 0xFF) * (1 + lim);
        
        //float r = (float)(oldColor >> 16 & 0xFF) + (lim * factor);
        //float g = (float)(oldColor >> 8 & 0xFF) + (lim * factor);
        //float b = (float)(oldColor & 0xFF) + (lim * factor);
        
        changed.pixels[index] = palette.getEquivalentColor(color(r,g,b));
        //changed.pixels[index] = plan.colors[lim < plan.ratio ? 1 : 0];
      }
    }
      
    changed.updatePixels();
    return changed;
  }
}
