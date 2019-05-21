void getTriangle(point center, float radius, float rotation){
  triangle(center.x + radius * cos(PI/2 + rotation), center.y + radius * sin(PI/2 + rotation), 
           center.x + radius * cos(7 * PI / 6 + rotation), center.y + radius * sin(7 * PI / 6 + rotation), 
           center.x + radius * cos(11 * PI /6 + rotation), center.y + radius * sin(11 * PI / 6 + rotation));
}

void getTriangleSnow(point center, float radius, float rotation){
  triangle(center.x + radius * cos(2/3 + rotation), center.y + radius * sin(PI/2 + rotation), 
           center.x + radius * cos(4/3 + rotation), center.y + radius * sin(7 * PI / 6 + rotation), 
           center.x + radius * cos(2 + rotation), center.y + radius * sin(11 * PI / 6 + rotation));
}

int getNumberWithBounds(int min, int n, int max){
  if (n < min) return min;
  if (n > max) return max;
  return n;
}
