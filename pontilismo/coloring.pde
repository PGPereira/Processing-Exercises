static final int __CLOSECOLOR = 0;
static final int __CLOSEGRAY = 1;
static final int __PSYCHEDELIC = 2;
static final int __MUTED = 3;
static final int __NEGATIVE = 4;
static final int __FUCKEDUP = 5;
static final int __SINGLECHANNEL = 6;
static final int __MOSTPROMINENT = 7;
static final int __MEDIUMPROMINENT = 8;
static final int __LESSPROMINENT = 9;
static final int __SECONDARY = 10;
static final int __SECONDARYP = 11;
static final int __SECONDARYLP = 12;
static final int __ORIGINAL = 13;
static final int __MIXED = 14;
static final int __LIFT = 15;
static final int __DROP = 16;

static final int __COLORS = 17;

color closeColor(color c){
  float[] col = colorToArray(c);
  
  float rand = random(0.875, 1.125);
  return color(
    rand * col[0],
    rand * col[1],
    rand * col[2],
    random(0,1) * col[3]
  );
}

color closestGray(color c){
  float[] col = colorToArrayNoAlpha(c);
   
  return color(euclidianNorm(col, col));
}

color makeColor(float[] c){
  switch (c.length){
    case 1:
      return color(c[0]);
    case 2:
      return color(c[0], c[1]);
    case 3:
      return color(c[0], c[1], c[2]);
    case 4:
      return color(c[0], c[1], c[2], c[3]);
    default:
      return color(0);
  }
}

float[] colorToArray(color c){
  float[] arr = {
    red(c), //red
    green(c),  //green
    blue(c),  //blue
    alpha(c)
  };
  return arr;
}

float[] colorToArrayNoAlpha(color c){
  float[] arr = {
    red(c), //red
    green(c),  //green
    blue(c),  //blue
  };
  return arr;
}

color psychedelicColor(color c){
   float[] col = colorToArray(c);
    
   return color(
     random(0, 1) * col[0], 
     random(0, 1) * col[1], 
     random(0, 1) * col[2],
     random(0, 1) * col[3]
   );
}

color fuckedUp(color c){
   float[] col = colorToArray(c);;
   FloatList inventory = new FloatList();
   for(int i = 0; i < col.length - 1; i++){
     inventory.append(col[i]);
   }
   inventory.shuffle();
   
   return color(
     inventory.get(0),
     inventory.get(1), 
     inventory.get(2),
     random(0, 1) * col[3]
   );
}


color muted(color c){
   float[] col = colorToArray(c);
    
   float r1 = random(0, 1);
   float r2 = random(0, 1);
   float r3 = random(0, 1);
   float total = r1 + r2 + r3;
   
   return color(
     total/r1 * col[0],
     total/r2 * col[1], 
     total/r3 * col[2],
     random(0, 1) * col[3]
    );
}

color liftColor(color c){
   float[] col = colorToArray(c);
   float[] c2 = {random(255), random(255), random(255)};
   
   return color(
     max(col[0], c2[0]),
     max(col[1], c2[1]), 
     max(col[2], c2[2]),
     random(0, 1) * col[3]
   );
}

color dropColor(color c){
   float[] col = colorToArray(c);
   float[] c2 = {random(255), random(255), random(255)};
   
   return color(
     min(col[0], c2[0]),
     min(col[1], c2[1]), 
     min(col[2], c2[2]),
     random(0, 1) * col[3]
   );
}

color negative(color c){
   float[] k = colorToArray(c);
   return closeColor(color(
     255 - k[0],
     255 - k[1], 
     255 - k[2],
     random(0, 1) * k[3]
   ));
}

color collidedColor(color c) {  
  return negative(c) + closestGray(c);
}


color singleChannel(color c){
  float[] col = colorToArray(c);
   
   float channel = random(0, vectorSum(col));
   float total = euclidianNorm(col, col)/255;
   
   if(channel < col[0]){
     return color(col[0] * total, 0, 0, random(0, 1) * col[3]);
   } else if(channel < col[0] + col[1]){
     return color(0, col[1] * total, 0, random(0, 1) * col[3]);
   } else {
     return color(0, 0, col[2] * total, random(0, 1) * col[3]);
   }
}

color mostProminent(color c){
    float[] col = colorToArray(c);
    
    float maximum = max(col[0], max(col[1], col[2]));
    
   
   if(col[0] == maximum){
     return color(col[0], 0, 0, random(0, 1) * col[3]);
   } else if(col[1] == maximum){
     return color(0, col[1], 0, random(0, 1) * col[3]);
   } else {
     return color(0, 0, col[2], random(0, 1) * col[3]);
   }
}

color mediumProminent(color c){
    float[] col = colorToArray(c);
    
    float maximum = max(col[0], max(col[1], col[2], random(0, 1) * col[3]));
    float minimum = min(col[0], min(col[1], col[2], random(0, 1) * col[3]));
    
   
   if(col[0] != maximum && col[0] != minimum){
     return color(col[0], 0, 0, random(0, 1) * col[3]);
   } else if(col[1] != maximum && col[1] != maximum){
     return color(0, col[1], 0, random(0, 1) * col[3]);
   } else {
     return color(0, 0, col[2], random(0, 1) * col[3]);
   }
}

color lessProminent(color c){
    float[] col = colorToArray(c);

    float minimum = min(col[0], min(col[1], col[2]));
    
   
   if(col[0] == minimum){
     return color(col[0], 0, 0, random(0, 1) * col[3]);
   } else if(col[1] == minimum){
     return color(0, col[1], 0, random(0, 1) * col[3]);
   } else {
     return color(0, 0, col[2], random(0, 1) * col[3]);
   }
}

color secondaryColor(color c){
  return makeColor(vectorSum(colorToArray(lessProminent(c)), colorToArray(mostProminent(c))));
}

color secondaryProminent(color c){
  return makeColor(vectorSum(colorToArray(mediumProminent(c)), colorToArray(mostProminent(c))));
}

color secondaryNotProminent(color c){
  return makeColor(vectorSum(colorToArray(mediumProminent(c)), colorToArray(lessProminent(c))));
}

color mixedColor(color c){
   int mode = (int) random(__COLORS - 1);
   
   return getColor(mode, c);
}

color getColor(int mode, color c){
  switch(mode){
    case __CLOSECOLOR:
      return closeColor(c);
    case __CLOSEGRAY:
      return closestGray(c);
    case __PSYCHEDELIC:
      return psychedelicColor(c);
    case __SINGLECHANNEL:
      return singleChannel(c);
    case __FUCKEDUP:
      return fuckedUp(c);
    case __MUTED:
      return muted(c);
    case __NEGATIVE:
      return negative(c);
    case __MOSTPROMINENT:
      return mostProminent(c);
   case __MEDIUMPROMINENT:
      return mediumProminent(c);
    case __LESSPROMINENT:
      return lessProminent(c);
    case __SECONDARY:
      return secondaryColor(c);
    case __SECONDARYLP:
      return secondaryNotProminent(c);
    case __SECONDARYP:
      return secondaryProminent(c);   
    case __MIXED:
      return mixedColor(c);
    case __LIFT:
      return liftColor(c);
    case __DROP:
      return dropColor(c);
    case __ORIGINAL:
      return c;
    default:
      return c;
  }
}
