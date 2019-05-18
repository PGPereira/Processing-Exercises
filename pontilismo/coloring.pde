color randomColor(float[] col){
  float total  = euclidianNorm(col);
  float rand = random(total * 7/8, total * 9/8);
  float c = rand/total;
  return makeColor(constProduct(c, col));
}

color closestGray(float[] col){
  return color(euclidianNorm(col));
}

color makeColor(float[] c){
  return color(c[0], c[1], c[2]);
}

color getColor(int mode, float[] c){
  switch(mode){
    case 1:
      return makeColor(c);
    case 2:
      return randomColor(c);
    case 3:
      return closestGray(c);
    default:
      return makeColor(c);
  }
}
