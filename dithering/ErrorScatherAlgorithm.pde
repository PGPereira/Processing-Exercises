public class ErrorScatherAlgorithm {
  String name;
  Set<ErrorScather> algorithm;
  
  ErrorScatherAlgorithm(String name) {
    this.name = name;
    this.algorithm = new LinkedHashSet<ErrorScather>();
  }
  
  ErrorScatherAlgorithm(String name, int scathers) {
    this.name = name;
    this.algorithm = new LinkedHashSet<ErrorScather>(scathers);
  }
  
  ErrorScatherAlgorithm(String name, Set<ErrorScather> algorithm) {
    this.name = name;
    this.algorithm = algorithm;
  }
  
  public void addScather(ErrorScather scather){
    this.algorithm.add(scather);
  }
  
  public void addScather(int x, int y, float ratio) {
    this.algorithm.add(new ErrorScather(x, y, ratio));
  }
  
  public String getName() {
    return this.name;
  }
  
  private void setError(PVector[][] errorMatrix, int i, int j, int w, int h, PVector delta) {
    if((i >= 0) && (i < w) && (j < h) && (j >= 0)) {
      errorMatrix[i][j] = PVector.add(errorMatrix[i][j], delta);
    }  
  }
  
  public void rightToLeftSpread(PVector[][] errorMatrix, PVector delta, int i, int j, int w, int h) {
    for(ErrorScather e : algorithm) {
      setError(errorMatrix, i + e.x, j + e.y, w, h, e.getError(delta));  
    }
  }
  
  public void leftToRightSpread(PVector[][] errorMatrix, PVector delta, int i, int j, int w, int h) {
    for(ErrorScather e : algorithm) {
      setError(errorMatrix, i - e.x, j + e.y, w, h, e.getError(delta));  
    }
  }
}
