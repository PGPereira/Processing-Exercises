class ColorMixer {
    color[] colors;
    float ratio; /* 0 = always index1, 1 = always index2, 0.5 = 50% of both */
    
    ColorMixer(color[] colors, float ratio) {
      this.colors = colors;
      this.ratio = ratio;  
    }
    
    ColorMixer(color c1, color c2, float ratio) {
      this.colors = new color[2];
      this.ratio = ratio;  
      
      this.colors[0] = c1;
      this.colors[1] = c2;
    }
    
    //public int bestRatioForTargetColor(color target, int paletteColors){
    
    //}
    //ColorMixer(PVector c1, PVector c2, float ratio) {
    //  this.colors = new color[2];
    //  this.ratio = ratio;  
      
    //  this.colors[0] = c1;
    //  this.colors[1] = c2;
    //}
};
