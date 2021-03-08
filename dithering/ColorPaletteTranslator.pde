class ColorPaletteTranslator {
  double[][] distMatrix;
  int originalQuantity, translatedQuantity;
  ColorPalette original, translated;

  ColorPaletteTranslator(ColorPalette original, ColorPalette translated){
    // We need to assure that original palette has the same or more colors to the palette translated
    this.original = original;
    this.translated = translated;
    this.originalQuantity = original.getColorsQuantity();
    this.translatedQuantity = translated.getColorsQuantity();
    
    this.distMatrix = new double[original.getColorsQuantity()][translated.getColorsQuantity()];
    for (int i = 0; i < originalQuantity; i++){
       for (int j = 0; j < translatedQuantity; j++){
          distMatrix[i][j] = colorManager.getColorDistance(original.getColorByIndex(i),original.getColorByIndex(0));
      } 
    }
  }
  
  void hungarianMethod() {
    int hungarianIndex = max(originalQuantity, translatedQuantity);
    double[][] hungarianMatrix = new double[hungarianIndex][hungarianIndex];
    
    for (int i = 0; i < originalQuantity; i++){
       for (int j = 0; j < translatedQuantity; j++){
          hungarianMatrix[i][j] = distMatrix[i][j];
      } 
    }
  }
}
