class ColorManager { 
  public PVector getColorAsPVector(color c) {
    return new PVector((c >> 16 & 0xFF),(c >> 8 & 0xFF),(c & 0xFF));
  }
  
  public ArrayList<PVector> getColorPaletteAsPVectorArray(color[] palette) {
    ArrayList<PVector> list = new ArrayList<PVector>(palette.length);
    for(int i = 0; i < palette.length; i++) {
      list.add(getColorAsPVector(palette[i]));
    }
    
    return list;
  }
  
  public color getPVectorAsColor(PVector p) {
    return color(
      max(min(p.x, 255), 0),
      max(min(p.y, 255), 0), 
      max(min(p.z, 255), 0)
    );
  }
  
  public double getColorDistance(PVector a, PVector b) {
    // TODOS OS ALGORITMOS DE PROXIMIDADE SÃO BEM RUINS, PQP
    //PVector vdiff = PVector.sub(a, b);
    //float rLine = (a.x + b.x)/2;
    //float sRGB;
    ////sRGB = (2 + rLine/256.0) * pow(vdiff.x, 2) + 4 * pow(vdiff.y, 2) + (2 + (256 - rLine)/256.0) * pow(vdiff.z, 2);
    //if(rLine < 128) {
    //  sRGB = sqrt(2 * pow(vdiff.x, 2) + 4 * pow(vdiff.y, 2) + 3 * pow(vdiff.z, 2));
    //} else {
    //  sRGB = sqrt(3 * pow(vdiff.x, 2) + 4 * pow(vdiff.y, 2) + 2 * pow(vdiff.z, 2));
    //}
    //return abs((0.2989*a.x + 0.5870*a.y + 0.1140*a.z) - (0.2989*b.x + 0.5870*b.y + 0.1140*b.z));
    
    //return sRGB;
    
    double lumaDiff = getLuma(a) - getLuma(b);
    PVector vdiff = PVector.div(PVector.sub(a, b), 255.0);
    return (pow(vdiff.x, 2) * 0.299 + pow(vdiff.y, 2) * 0.587 + pow(vdiff.z, 2) * 0.114) * 0.75 + lumaDiff * lumaDiff;
  }
  
  public double getColorDistance(PVector a, color b) {
    return getColorDistance(a, this.getColorAsPVector(b));
  }
  
  public double getColorDistance(color a, PVector b) {
    return getColorDistance(this.getColorAsPVector(a), b);
  }
  
  public double getColorDistance(color a, color b) {
    return getColorDistance(this.getColorAsPVector(a), this.getColorAsPVector(b));
  }
  
  public color getColorWithError(color a, PVector error) {
    return getPVectorAsColor(PVector.add(colorManager.getColorAsPVector(a), error));
  }
  
  public PVector getColorDelta(color a, color b) {
    return getColorDelta(this.getColorAsPVector(a), this.getColorAsPVector(b));
  }
  
  public PVector getColorDelta(PVector a, color b) {
    return getColorDelta(a, this.getColorAsPVector(b));
  }
  
  public PVector getColorDelta(color a, PVector b) {
    return getColorDelta(this.getColorAsPVector(a), b);
  }
  
  public PVector getColorDelta(PVector a, PVector b) {
    return PVector.sub(a, b);
  }
  
  public int getPixelIndex(int i, int j, PImage image) {
    return j * image.width + i;
  }
  
  public double getLuma(PVector c) {
    return (c.x * 299 + c.y * 587 + c.z * 114)/(255000.0);
  }
  
  public void quicksort(color[] array, int begin, int end, char comparator) {
    int i = begin;
    int j = end - 1;
    
    color pivot = colorPivot(array[i], array[(begin + end)/ 2], array[j], comparator);
    
    while(i <= j) {
      while(lessThen(array[i], pivot, comparator) && i < end) {
        i++;
      }
      
      while(greaterThen(array[j], pivot, comparator) && j > begin) {
        j--;
      }
      
      if(i <= j) {
        color aux = array[i];
        array[i] = array[j];
        array[j] = aux;
        i++;
        j--;
      }
    }
    
    if(j > begin) {
      quicksort(array, begin, j + 1, comparator);
    }
    
    if(i < end) {
      quicksort(array, i, end, comparator);
    }
  }
  
  public int search(color[] array, float pivot, int begin, int end, char comparator) {
     if(begin == end) {
        return greaterThenEqual(array[begin], pivot, comparator) ? begin : -1;
     }
     
     int middle = begin + (end - begin) / 2;
     if(greaterThen(array[middle], pivot, comparator)) {
        return search(array, pivot, begin, middle, comparator);
     }
  
     int ret = search(array, pivot, middle + 1, end, comparator);
     return (ret == -1) ? middle : ret;
  }
  
  public color getSteganograficColor(color c, byte hide) {
    //Using the method of two last significant bits 
    //to hide an byte inside an color
    // Normally we would do:
    //int a0 = (c >> 24) & 0xFF;
    //int r0 = (c >> 16) & 0xFF;
    //int g0 = (c >> 8) & 0xFF;
    //int b0 = c & 0xFF;
    //But we need only the six more significant bits,
    //so we shift by an extra 2, do the & only with 00111111 to 
    //get then and unshift the extra two;
    //int a = ((c >> 26) & 0x3F) << 2; // alpha is the first byte
    //int r = ((c >> 18) & 0x3F) << 2; // red is the second byte
    //int g = ((c >> 10) & 0x3F) << 2; // green is the third one
    //int b = ((c >> 2) & 0x3F) << 2;  // blue is ther forth
    
    // Get the two bits to hide inside each color;
    // 0x03 is equals to 00000011, when we do an or operation 
    // with it we take their two least significant bits
    //int a2 = (hide >> 6) & 0x03;
    //int r2 = (hide >> 4) & 0x03;
    //int g2 = (hide >> 2) & 0x03;
    //int b2 = (hide & 0x03);
    
    // We are putting the two bits inside their respective channel.
    //return color((r | r2), (g | g2), (b | b2), (a | a2));
    return (color)
      (((((c >> 26) & 0x3F) << 2) | ((hide >> 6) & 0x03)) << 24) |
      (((((c >> 18) & 0x3F) << 2) | ((hide >> 4) & 0x03)) << 16) |
      (((((c >> 10) & 0x3F) << 2) | ((hide >> 2) & 0x03)) << 8) |
      ((((c >> 2) & 0x3F) << 2) | (hide & 0x03));
  }
  
  public byte getSteganographicByte(color c) {
    //byte bt;
    
    //int a = ((c >> 24) & 0x03) << 6;
    //int r = ((c >> 16) & 0x03) << 4;
    //int g = ((c >> 8) & 0x03) << 2;
    //int b = (c & 0x03);
    
    //bt = (byte)(a | r | g | b);
    
    //return bt;
    
    return (byte)((((c >> 24) & 0x03) << 6) | (((c >> 16) & 0x03) << 4) | (((c >> 8) & 0x03) << 2) | (c & 0x03));
  }
  
  public char getSteganograficChar(color c1, color c2) {
      //byte b1, b2;
      //b1 = getSteganographicByte(c1);
      //b2 = getSteganographicByte(c2);
      
      //println("char:", (b1 << 8) | b2, "bytes:", b1, b2);
      
      //return (char)((b1 << 8) | b2); 
      return (char)((getSteganographicByte(c1) << 8) | getSteganographicByte(c2));
  }
  
  private boolean greaterThenEqual(color c, float k, char comparator) {
    return (comparator == 'r' && red(c) >= k) || (comparator == 'g' && green(c) >= k) || (comparator == 'b' && blue(c) >= k);
    //return (comparator == 'r' && (c >> 16 & 0xFF) >= k) || (comparator == 'g' && (c >> 8 & 0xFF) >= k) || (comparator == 'b' && (c & 0xFF) >= k);
  }
  
  private boolean greaterThen(color c, float k, char comparator) {
    return (comparator == 'r' && red(c) > k) || (comparator == 'g' && green(c) > k) || (comparator == 'b' && green(c) > k);
    //return (comparator == 'r' && (c >> 16 & 0xFF) > k) || (comparator == 'g' && (c >> 8 & 0xFF) > k) || (comparator == 'b' && (c & 0xFF) > k);
  }
  
  //private boolean lessThenEqual(color c, float k, char comparator) {
  //  return (comparator == 'r' && (c >> 16 & 0xFF) <= k) || (comparator == 'g' && (c >> 8 & 0xFF) <= k) || (comparator == 'b' && (c & 0xFF) <= k);
  //}
  
  //private boolean lessThen(color c, float k, char comparator) {
  //  return (comparator == 'r' && (c >> 16 & 0xFF) < k) || (comparator == 'g' && (c >> 8 & 0xFF) < k) || (comparator == 'b' && (c & 0xFF) < k);
  //}
  
  private boolean lessThen(color a, color b, char comparator) {    
      return (
        (comparator == 'r' && red(a) < red(b))
        || (comparator == 'g' && green(a) < green(b)) 
        || (comparator == 'b' && blue(a) < blue(b))
      );
      
      //return (
      //  (comparator == 'r' && (a >> 16 & 0xFF) < (b >> 16 & 0xFF))
      //  || (comparator == 'g' && (a >> 8 & 0xFF) < (b >> 8 & 0xFF)) 
      //  || (comparator == 'b' && (a & 0xFF) < (b & 0xFF))
      //);
  }
  
  private boolean greaterThen(color a, color b, char comparator) {      
      return (
        (comparator == 'r' && red(a) > red(b))
        || (comparator == 'g' && green(a) > green(b))
        || (comparator == 'b' && blue(a) > blue(b))
      );
      
      //return (
      //  (comparator == 'r' && (a >> 16 & 0xFF) > (b >> 16 & 0xFF))
      //  || (comparator == 'g' && (a >> 8 & 0xFF) > (b >> 8 & 0xFF)) 
      //  || (comparator == 'b' && (a & 0xFF) > (b & 0xFF))
      //);
  }
  
  private color colorPivot(color a, color b, color c, char comparator) {
    float ac, bc, cc;
    
    if(comparator == 'r') {
      ac = (a >> 16 & 0xFF);
      bc = (b >> 16 & 0xFF);
      cc = (b >> 16 & 0xFF);
    } else if(comparator == 'b') {
      ac = (a >> 8 & 0xFF);
      bc = (b >> 8 & 0xFF);
      cc = (c >> 8 & 0xFF);
    } else {
      ac = (a & 0xFF);
      bc = (b & 0xFF);
      cc = (c & 0xFF);
    }
    
    float max = max(ac, bc, cc);
    float min = min(ac, bc, cc);
      
    if (ac != max && ac != min) {
      return a;
    } else if (cc != max && cc != min) {
      return c;
    } else {
      return b;
    }
  }
  
  private char rangeOfRGB(float r, float g, float b) {
    float range = max(r, g, b);
    
    // don't prioritize blue, as it's less perceivable by human eyes;
    if(range == g) {
      return 'g';
    } else if(range == r) {
      return 'r';
    } else {
      return 'b';
    }
  }
}
