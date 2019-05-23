void getTriangle(point center, float radius, float rotation){
  triangle(center.x + radius * cos( 2 * PI / 6 + rotation), center.y + radius * sin( 2 * PI / 6 + rotation), 
           center.x + radius * cos( 6 * PI / 6 + rotation), center.y + radius * sin( 6 * PI / 6 + rotation), 
           center.x + radius * cos(10 * PI / 6 + rotation), center.y + radius * sin(10 * PI / 6 + rotation));
}

void getSquare(point center, float radius, float rotation){
  quad(center.x + radius * cos(1 * PI / 4 + rotation), center.y + radius * sin(1 * PI / 4 + rotation), 
       center.x + radius * cos(3 * PI / 4 + rotation), center.y + radius * sin(3 * PI / 4 + rotation), 
       center.x + radius * cos(5 * PI / 4 + rotation), center.y + radius * sin(5 * PI / 4 + rotation),
       center.x + radius * cos(7 * PI / 4 + rotation), center.y + radius * sin(7 * PI / 4 + rotation)
       );
}

int getNumberWithBounds(int min, int n, int max){
  if (n < min) return min;
  if (n > max) return max;
  return n;
}

float angleFromPoints(point A, point B){
  float dx = A.x - B.x;
  float dy = A.y - B.y;
  
  return atan2(dy, dx);
}

float euclidianDistance(int x1, int x2, int y1, int y2){
  point a, b;
  a = new point(x1, y1);
  b = new point(x2, y2);
  
  return a.euclidianDistance(b);
}
