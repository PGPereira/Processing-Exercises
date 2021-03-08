static final int __SCATHER_LTR = 0;
static final int __SCATHER_BOUSTROPHEDON = 1;
static final int __SCATHER_RTL = 2;
static final int __SCATHER_PERLIN = 3;
static final int __SCATHER_RANDOM = 4;
static final int __SCATHER_STEGANOGRAPHY = 5;
static final int __SCATHER_METHODS = 6;

class ErrorScatherDither implements Dither {
  String name;
  ColorManager colorManager;
  ColorPalette palette;
  ErrorScatherAlgorithm algorithm;
  int method;
  
  ErrorScatherDither(ColorManager colorManager, ColorPalette palette, ErrorScatherAlgorithm algorithm, int method) {
    this.palette = palette;
    this.colorManager = colorManager;
    this.algorithm = algorithm;
    this.method = method;
    
    this.name = algorithm.getName();
    if(method == __SCATHER_LTR) {
      this.name += " LTR";
    } else if(method == __SCATHER_RTL) {
      this.name += " RTL";
    } else if(method == __SCATHER_BOUSTROPHEDON){
      this.name += " Boustrophedon";
    } else if(method == __SCATHER_PERLIN){
      this.name += " with Perlin Noise";
    } else if(method == __SCATHER_RANDOM){
      this.name += " with Random Noise";
    } else if(method == __SCATHER_STEGANOGRAPHY){
      this.name += " with Steganography";
    }
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
    if (method == __SCATHER_LTR) {
      return getLeftToRightScannedImage(image);
    } else if (method == __SCATHER_RTL) {
      return getRightToLeftScannedImage(image);
    } else if (method == __SCATHER_BOUSTROPHEDON) {
      return getBoustrophedonScannedImage(image);
    } else if (method == __SCATHER_PERLIN) {
      return getDitheredImageWithNoise(image);
    } else if (method == __SCATHER_RANDOM) {
      return getDitheredImageWithRandomNoise(image);
    } else if (method == __SCATHER_STEGANOGRAPHY) {
      return getDitheredImageWithSteganography(image, this.getName() + '\n');
    }
    
    return getLeftToRightScannedImage(image);
  }
  
  public PImage getLeftToRightScannedImage(PImage image) {
    PImage changed = image.copy();
    PVector[][] errorMatrix = createErrorMatrix(changed.width, changed.height);
    
    changed.loadPixels();
    for(int j = 0; j < changed.height; j++) {
      for(int i = 0; i < changed.width; i++) {
        int index = colorManager.getPixelIndex(i, j, image);
        ColorPair pair = palette.getColorToupleWithError(changed.pixels[index], errorMatrix[i][j]);
        changed.pixels[index] = pair.getNew();
       
        algorithm.leftToRightSpread(errorMatrix, pair.getDelta(), i, j, changed.width, changed.height);
      }
    }
    changed.updatePixels();
    
    return changed;
  }
  
  public PImage getRightToLeftScannedImage(PImage image) {
   PImage changed = image.copy();
    
   PVector[][] errorMatrix = createErrorMatrix(image.width, image.height);
   
   changed.loadPixels();
    for(int j = 0; j < image.height; j++) {
      for(int i = image.width - 1; i >= 0; i--) { 
        int index = colorManager.getPixelIndex(i, j, image);
        ColorPair pair = palette.getColorToupleWithError(changed.pixels[index], errorMatrix[i][j]);
        changed.pixels[index] = pair.getNew();
        algorithm.rightToLeftSpread(errorMatrix, pair.getDelta(), i, j, changed.width, changed.height);
      }
    }
    changed.updatePixels();
    
    return changed;
  }
     
  public PImage getBoustrophedonScannedImage(PImage image) {
    PImage changed = image.copy();    
    PVector[][] errorMatrix = createErrorMatrix(changed.width, changed.height);
    
    changed.loadPixels();
    for(int j = 0; j < changed.height; j++) {
      if(j % 2 == 0) {
        for(int i = 0; i < changed.width; i++) {
          int index = colorManager.getPixelIndex(i, j, image);
          ColorPair pair = palette.getColorToupleWithError(changed.pixels[index], errorMatrix[i][j]);
          changed.pixels[index] = pair.getNew();
       
          algorithm.leftToRightSpread(errorMatrix, pair.getDelta(), i, j, changed.width, changed.height);
        }
      } else {
        for(int i = changed.width - 1; i >= 0; i--) {
          int index = colorManager.getPixelIndex(i, j, image);
          ColorPair pair = palette.getColorToupleWithError(changed.pixels[index], errorMatrix[i][j]);
          changed.pixels[index] = pair.getNew();
         
          algorithm.rightToLeftSpread(errorMatrix, pair.getDelta(), i, j, changed.width, changed.height);
        }
      }
    }
    changed.updatePixels();
    
    return changed;
  }
  
  public PVector[][] createErrorMatrix(int w, int h) {
    PVector[][] errorMatrix = new PVector[w][h];
    for(int i = 0; i < w; i++) {
      for(int j = 0; j < h; j++) {
        errorMatrix[i][j] = new PVector(0,0,0);
        //errorMatrix[i][j] = new PVector(random(0,1), random(0,1), random(0,1));
      }
    }
    
    return errorMatrix;
  }
  
  public PImage getDitheredImageWithNoise(PImage image) {
    PImage changed = image.copy();
    int factor = ceil(pow(palette.getColorsQuantity(), 1/3.0)); 
    PVector[][] errorMatrix = createErrorMatrix(changed.width, changed.height);
    
    changed.loadPixels();
    for(int j = 0; j < changed.height; j++) {
      for(int i = 0; i < changed.width; i++) {
        int index = colorManager.getPixelIndex(i, j, image);
        float noise = map(noise(i * 0.01, j * 0.01, frameCount * 0.005), 0, 1, 0, 255);
        color oldColor = colorManager.getPVectorAsColor(PVector.add(colorManager.getColorAsPVector(changed.pixels[index]), errorMatrix[i][j]));
        
        int val = round(factor * noise / 255.0) * round(255.0 / factor);
        
        float r = red(oldColor) > noise ? val : 0;
        float g = green(oldColor) > noise ? val : 0;
        float b = blue(oldColor) > noise ? val : 0;
        
        color newColor = palette.getEquivalentColor(color(r,g,b));
        changed.pixels[index] = newColor;
        
        PVector delta = colorManager.getColorDelta(oldColor, newColor);
        algorithm.leftToRightSpread(errorMatrix, delta, i, j, changed.width, changed.height);
      }
    }
    changed.updatePixels();
    
    return changed;
  }
  
  public PImage getDitheredImageWithRandomNoise(PImage image) {
    PImage changed = image.copy();
    int factor = ceil(pow(palette.getColorsQuantity(), 1/3.0)); 
    PVector[][] errorMatrix = createErrorMatrix(changed.width, changed.height);
    
    changed.loadPixels();
    for(int i = 0; i < changed.width; i++) {
      for(int j = 0; j < changed.height; j++) {
        int index = colorManager.getPixelIndex(i, j, image);
        float noise = random(0,255);
        color oldColor = colorManager.getPVectorAsColor(PVector.add(colorManager.getColorAsPVector(changed.pixels[index]), errorMatrix[i][j]));
        
        int val = round((noise/255) * (255.0 / factor));
        
        float r = ((oldColor >> 16) & 0xFF) > val ? val : 0;
        float g = ((oldColor >> 8) & 0xFF) > val ? val : 0;
        float b = (oldColor & 0xFF) > val ? val : 0;
        
        color newColor = palette.getEquivalentColor(color(r,g,b));
        changed.pixels[index] = newColor;
        
        PVector delta = colorManager.getColorDelta(oldColor, newColor);
        algorithm.leftToRightSpread(errorMatrix, delta, i, j, changed.width, changed.height);
      }
    }
    changed.updatePixels();
    
    return changed;
  }
  
  public PImage getDitheredImageWithSteganography(PImage image, String hideMessage) {
    int k = 0;
    byte b;
    PImage changed = image.copy();
    PVector[][] errorMatrix = createErrorMatrix(changed.width, changed.height);
    
    changed.loadPixels();
    for(int j = 0; j < changed.height; j++) {
      for(int i = 0; i < changed.width; i++) {
        char ch = hideMessage.charAt(k);
        int index = colorManager.getPixelIndex(i, j, image);
        if((i + j) % 2 == 0) {
          b = (byte)((ch >> 8) & 0xFF);
        } else {
          b = (byte)(ch & 0xFF);
          k = Math.floorMod(k + 1, hideMessage.length());
        }
        
        ColorPair pair = palette.getColorToupleWithStenography(changed.pixels[index], errorMatrix[i][j], b);
        changed.pixels[index] = pair.getNew();
        
        algorithm.leftToRightSpread(errorMatrix, pair.getDelta(), i, j, changed.width, changed.height);
      }
    }
    changed.updatePixels();
    
    return changed;
  }
}
