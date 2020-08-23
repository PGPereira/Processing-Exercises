void getTriangle(point center, float radius, float rotation){
  triangle(center.x + radius * cos(PI / 3 + rotation), center.y + radius * sin(PI / 3 + rotation), 
           center.x + radius * cos(PI + rotation), center.y + radius * sin(PI + rotation), 
           center.x + radius * cos(5 * PI / 3 + rotation), center.y + radius * sin(5 * PI / 3 + rotation));
}

void getSquare(point center, float radius, float rotation){
  quad(center.x + radius * cos(1 * PI / 4 + rotation), center.y + radius * sin(1 * PI / 4 + rotation), 
       center.x + radius * cos(3 * PI / 4 + rotation), center.y + radius * sin(3 * PI / 4 + rotation), 
       center.x + radius * cos(5 * PI / 4 + rotation), center.y + radius * sin(5 * PI / 4 + rotation),
       center.x + radius * cos(7 * PI / 4 + rotation), center.y + radius * sin(7 * PI / 4 + rotation)
       );
}

int getNumberWithBounds(int min, int n, int max){
  return max(min, min(max, n));
}

float angleFromPoints(point A, point B){
  float dx = A.x - B.x;
  float dy = A.y - B.y;
  
  return atan2(dy, dx);
}

float euclidianDistance(int x1, int y1, int x2, int y2){
  return sqrt(pow((x1 - x2),2) + pow((y1 - y2), 2));
}
