float euclidianNorm(float[] v1, float[] v2){
  return sqrt(vectorSum(vectorMultiplication(v1, v2)));
}

float geometricMedium(float[] v1){
  return pow(vectorMultiply(v1), 1/(v1.length));
}

float[] vectorMultiplication(float[] v1, float[] v2){  
  if(v1.length == v2.length){
    float[] result = new float[v1.length];
    for (int i = 0; i < v1.length; i++){
      result[i] = v1[i] * v2[i];
    }
    return result;
  } else {
    throw new Error("Os vetores tem tamanhos diferentes");
  }
}

float[] constProduct(float c, float[] v){
  float[] ret = new float[v.length];
  for (int i = 0; i < v.length; i++){
    ret[i] = v[i] * c;
  }
  
  return ret;
}

float[] constDivision(float c, float[] v){
  float[] ret = new float[v.length];
  for (int i = 0; i < v.length; i++){
    ret[i] = v[i] / c;
  }
  
  return ret;
}

float[] vectorSum(float[] v1, float[] v2){
  if(v1.length == v2.length){
    float[] result = new float[v1.length];
    for (int i = 0; i < v1.length; i++){
      result[i] = v1[i] + v2[i];
    }
    return result;
  } else {
    throw new Error("Os vetores tem tamanhos diferentes");
  }
}

float[] vectorSub(float[] v1, float[] v2){
  if(v1.length == v2.length){
    float[] result = new float[v1.length];
    for (int i = 0; i < v1.length; i++){
      result[i] = v1[i] - v2[i];
    }
    return result;
  } else {
    throw new Error("Os vetores tem tamanhos diferentes");
  }
}

float vectorSum(float[] v){
  float sum = 0;
  for(float axis : v){
    sum += axis;
  };
  
  return sum;
}

float vectorMultiply(float[] v){
  float multiple = 1;
  
  for(float axis : v){
    multiple *= axis;
  };
  
  return multiple;
}

float[] toFloat(double[] v){
  float[] result = new float[v.length];
  for (int i = 0; i < v.length; i++){
    result[i] = (float) v[i];
  }
  return result;
}
