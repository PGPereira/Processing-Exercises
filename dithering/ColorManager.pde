class ColorManager { 
  public PVector getColorAsPVector(color c) {
    return new PVector(c >> 16 & 0xFF, c >> 8 & 0xFF, c & 0xFF);
  }
  
  public color getPVectorAsColor(PVector p) {
    return color(p.x, p.y, p.z);
  }
  
  public float getChroma(color p) {
    return max(red(p), green(p), blue(p)) - min(red(p), green(p), blue(p)); 
  }
  
  public float getColorDistance(color a, color b) {
    PVector va = this.getColorAsPVector(a);
    PVector vb = this.getColorAsPVector(b);
    PVector vdiff = PVector.sub(va, vb); 
    float rLine = (va.x + vb.x)/2;
    // TODOS OS ALGORITMOS DE PROXIMIDADE SÃO BEM RUINS, PQP
    float sRGB = sqrt((2 + rLine/256.0) * pow(vdiff.x, 2) + 4 * pow(vdiff.y, 2) + (2 + (256 - rLine)/256.0) * pow(vdiff.z, 2));
    //float sRGB;
    //if(rLine < 128) {
    //  sRGB = sqrt(2 * pow(vdiff.x, 2) + 4 * pow(vdiff.y, 2) + 3 * pow(vdiff.z, 2));
    //} else {
    //  sRGB = sqrt(3 * pow(vdiff.x, 2) + 4 * pow(vdiff.y, 2) + 2 * pow(vdiff.z, 2));
    //}
    
    return sRGB;
    //return abs(brightness(a) - brightness(b));
    //return sqrt(pow(255 - abs(red(a) - red(b)), 2) + pow(255 - abs(green(a) - green(b)),2) + pow(255 - abs(blue(a) - blue(b)),2));
    
    //return sqrt(pow(hue(a) - hue(b), 2) + pow(saturation(a) - saturation(b), 2) + pow(brightness(a) - brightness(b), 2));
    //float lumen = abs(sqrt( .241 * va.x + .691 * va.y + .068 * va.z ) -sqrt( .241 * vb.x + .691 * vb.y + .068 * vb.z ));
    
    //return sRGB - lumen;
    //return abs(red(a) - red(b)) + abs(green(a) - green(b)) + abs(blue(a) - blue(b));
    //return sRGB;
    //return lumen;
  }
  
  public PVector getColorDelta(color a, color b) {
    PVector aVector = this.getColorAsPVector(a);
    PVector bVector = this.getColorAsPVector(b);
    
    return PVector.sub(aVector, bVector);
  }
  
  public int getPixelIndex(int i, int j, PImage image) {
    return j * image.width + i;
  }
  
  
}
