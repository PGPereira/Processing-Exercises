color randomColor(float[] col){
  float total  = euclidianNorm(col);
  float rand = random(total * 7/8, total * 9/8);
  float c = rand/total;
  return makeColor(constProduct(c, col));
}

color makeColor(float[] c){
  return color(c[0], c[1], c[2]);
}
