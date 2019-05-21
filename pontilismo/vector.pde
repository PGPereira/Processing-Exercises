float euclidianNorm(float[] v){
  return sqrt(vectorSum(vectorMultiplication(v, v)));
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

double[] constProductD(double c, double[] v){
  double[] ret = new double[v.length];
  for (int i = 0; i < v.length; i++){
    ret[i] = v[i] * c;
  }
  
  return ret;
}

float[] constProduct(float c, float[] v){
  float[] ret = new float[v.length];
  for (int i = 0; i < v.length; i++){
    ret[i] = v[i] * c;
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

double[] vectorSumD(double[] v1, double[] v2){
  if(v1.length == v2.length){
    double[] result = new double[v1.length];
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
