class RandomDither implements Dither {
  int colorSpace, factor;
  ColorManager colorManager;
  ColorPalette palette;
  String name;
  
  RandomDither(ColorManager colorManager, ColorPalette palette) {
    this.palette = palette;
    this.factor = ceil(pow(this.palette.getColorsQuantity(), 1/3.0));
    this.colorManager = colorManager;
    this.name = "Random Threshould";
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
    for(int i = 0; i < changed.pixels.length; i++) {
        float rand = random(0, 255);
        color oldColor = changed.pixels[i];
        //ColorMixer plan = palette.deviseBestMixingPlan(oldColor, factor);
        
        int val = round(factor * rand/255) * (255 / factor);   
        int r = (oldColor >> 16 & 0xFF) > rand ? val : 0;
        int g = (oldColor >> 8 & 0xFF) > rand ? val : 0;
        int b = (oldColor & 0xFF) > rand ? val : 0;
        //float valor = brightness(oldColor) >= noise ? round(factor * noise / 255.0) * (255 / factor) : 0;
        
        //changed.pixels[index] = palette.getEquivalentColor(color(valor));
        changed.pixels[i] = palette.getEquivalentColor(color(r, g, b));
        //changed.pixels[i] = plan.colors[rand < plan.ratio ? 1 : 0];
    }
      
    changed.updatePixels();
    return changed;
  }
}
