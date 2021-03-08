class PerlinNoiseDither implements Dither {
  int colorSpace, factor;
  ColorManager colorManager;
  ColorPalette palette;
  String name;
  
  PerlinNoiseDither(ColorManager colorManager, ColorPalette palette) {
    this.palette = palette;
    this.factor = ceil(pow(this.palette.getColorsQuantity(), 1/3.0));
    this.colorManager = colorManager;
    this.name = "Perlin Noise Threshould";
  }
  
  public String getName() {
    return this.name;
  }
  
  public ColorPalette getPalette() {
    return this.palette;
  }
  
  public void setPalette(color[] palette) {
    this.palette = new ColorPalette(colorManager, palette);
    this.factor = ceil(pow(this.palette.getColorsQuantity(), 1/3.0));
  }
  
  public void setPalette(ColorPalette palette) {
    this.palette = palette;
  }
  
  public PImage getDitheredImage(PImage image) {
    PImage changed = image.copy();
    
    changed.loadPixels();
    for(int i = 0; i < changed.width; i++) {
      for(int j = 0; j < changed.height; j++) {
        int index = colorManager.getPixelIndex(i, j, changed);
        float noise = map(noise(i * 0.005, j * 0.005, frameCount * 0.005), 0, 1, 0, 255);
        color oldColor = changed.pixels[index];
        
        int val = round(factor * noise / 255.0) * (255 / factor);
        
        float r = red(oldColor) > noise ? val : 0;
        float g = green(oldColor) > noise ? val : 0;
        float b = blue(oldColor) > noise ? val : 0;
        //float valor = brightness(oldColor) >= noise ? round(factor * noise / 255.0) * (255 / factor) : 0;
        
        //changed.pixels[index] = palette.getEquivalentColor(color(valor));
        changed.pixels[index] = palette.getEquivalentColor(color(r, g, b));
      }
    }
      
    changed.updatePixels();
    return changed;
  }
}
