class ImageManager {
  PImage image;
  ColorManager colorManager;
  
  ImageManager(PImage image, ColorManager colorManager) {
    this.image = image;
    this.colorManager = colorManager;
  }
  
  private Set<Integer> medianCut(color[] array, int begin, int end, int depth, int askedDepth) {
     Set<Integer> list = new LinkedHashSet<Integer>();
     int r = 0, minR = 255, maxR = -1;
     int g = 0, minG = 255, maxG = -1;
     int b = 0, minB = 255, maxB = -1;
     double rTotal = 0, gTotal = 0, bTotal = 0;
     int delta = (end - begin);
     
     for (int i = begin; i < end; i++) {
       color c = array[i];       
       r = (c >> 16 & 0xFF);
       g = (c >> 8 & 0xFF);
       b = (c & 0xFF);
       
       rTotal += r; 
       gTotal += g; 
       bTotal += b;
       
       minR = min(r, minR);
       minG = min(g, minG);
       minB = min(b, minB);
       
       maxR = max(r, maxR);
       maxG = max(g, maxG);
       maxB = max(b, maxB);
     }
     
     if(depth == askedDepth){     
       list.add(color((float)(rTotal/delta), (float)(gTotal/delta), (float)(bTotal/delta)));
     } else {
       float rangeR = maxR - minR;
       float rangeG = maxG - minG;
       float rangeB = maxB - minB;
       
       if((rangeR * rangeG * rangeB) < 1.0) {
         list.add(color((float)(rTotal/delta), (float)(gTotal/delta), (float)(bTotal/delta)));
       } else {
         char comparator = colorManager.rangeOfRGB(rangeR, rangeG, rangeB);
         
         colorManager.quicksort(array, begin, end, comparator);
         float pivot = getRGBPivot(maxR, minR, maxG, minG, maxB, minB, comparator);
         int pivotIndex = colorManager.search(array, pivot, begin, end, comparator);
         
         if(pivotIndex != begin) {
           list.addAll(medianCut(array, begin, pivotIndex, depth + 1, askedDepth));
         }
         
         if(pivotIndex != end) {
           list.addAll(medianCut(array, pivotIndex, end, depth + 1, askedDepth));
         };
       }
     }
     
     return list;
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
  
  public color[] getPalette(int askedDepth) {
    image.loadPixels();
    color[] pix = new color[image.pixels.length];
    System.arraycopy(image.pixels, 0, pix, 0, image.pixels.length);
    this.image.updatePixels();
    
    //Ensure the color is not repeated
    Set<Integer> set = medianCut(pix, 0, pix.length, 0, askedDepth);
        
    color[] toReturn = new color[set.size()];
    Iterator<Integer> iterator = set.iterator();
    for (int i = 0; i < toReturn.length; i++)
    {
        toReturn[i] = iterator.next().intValue();
    }
    return toReturn;
  }
}
