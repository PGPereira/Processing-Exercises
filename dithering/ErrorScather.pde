public class ErrorScather {
  int x, y;
  float ratio;
  
  ErrorScather(int x, int y, float ratio) {
    this.x = x;
    this.y = y;
    this.ratio = ratio;
  }
  
  public PVector getError(PVector delta){
    return PVector.mult(delta, this.ratio);
  }
}
