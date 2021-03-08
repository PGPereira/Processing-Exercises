class ColorPair {
  private ColorManager colorManager;
  private color originalColor, newColor;
  
  ColorPair(ColorManager colorManager, color originalColor, color newColor) {
    this.originalColor = originalColor;
    this.newColor = newColor;
    this.colorManager = colorManager;
  }
  
  ColorPair(ColorManager colorManager, PVector originalColor, color newColor) {
    this.originalColor = colorManager.getPVectorAsColor(originalColor);
    this.newColor = newColor;
    this.colorManager = colorManager;
  }
  
  public PVector getDelta(){
    return this.colorManager.getColorDelta(originalColor, newColor);
  }
  
  public color getOriginal() {
    return this.originalColor;
  }
  
  public color getNew() {
    return this.newColor;
  }
}
