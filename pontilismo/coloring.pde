color randomColor(color c){
  float[] col = colorToArray(c);
  float total  = euclidianNorm(col);
  float rand = random(total * 7/8, total * 9/8);
  float cnst = rand/total;
  return makeColor(constProduct(cnst, col));
}

color closestGray(color c){
  float[] col = {red(c), green(c), blue(c), alpha(c)};
  return color(euclidianNorm(col));
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
    c >> 16 & 0xFF, //red
    c >> 8 & 0xFF,  //green
    c & 0xFF,  //blue
    alpha(c)
  };
  return arr;
}

color psychedelicColor(){ 
   return color(random(255), random(255), random(255), random(255));
}

color getColor(int mode, color c){
  switch(mode){
    case 1:
      return c;
    case 2:
      return randomColor(c);
    case 3:
      return closestGray(c);
    case 4:
      return psychedelicColor();
    default:
      return c;
  }
}
