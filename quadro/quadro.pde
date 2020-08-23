int x, y;
float minSpeed = -10;
float maxSpeed = 10;
float baseRadius = 165;
int convergence;
float rectX;

color colorsObj[] = {
  color(220, 204, 178),
  color(193, 189, 177),
  color(153, 147, 135),
  color(40, 39, 37),
  color(175, 142, 151),
  color(49, 90, 120),
  color(120, 156, 204),
  color(76, 146, 73),
  color(228, 194, 94),
  color(222, 152, 66),
  color(240, 91, 51),
  color(169,164,149),
  color(165,132,63)
};

color colorsStroke[] = {
  color(214,197,167),
  color(165,132,63)
};

movingObject obj[] = new movingObject[13];

class movingObject {
  boolean hasStroke;
  color col, strk;
  float posX, posY;
  float velX, velY;
  
  void make(){};
  
  void stroker(){
    if(this.hasStroke){
      strokeWeight(4);
      stroke(this.strk);
    } else {
      noStroke();
    }
  }
  
  void update(){
    posX += velX;
    posY += velY;
    if(frameCount % (convergence * 2) == 0){
      velX *= -0.9;
      velY *= -0.9;
    }
  };
}

class movingCircle extends movingObject {
  float radius;

  movingCircle(float radius, float velX, float velY, color col, int convergence) {
    this.radius = radius;
    this.velX = velX;
    this.velY = velY;
    this.col = col;
    this.calculateInitialPosition(velX, velY, convergence);
    this.hasStroke = false;
  }
  
  movingCircle(float radius, float velX, float velY, color col, color strk, int convergence) {
    this.radius = radius;
    this.velX = velX;
    this.velY = velY;
    this.col = col;
    this.calculateInitialPosition(velX, velY, convergence);
    this.hasStroke = true;
    this.strk = strk;
  }

  void calculateInitialPosition(float velX, float velY, int convergence) {
    posX = x - velX * convergence;
    posY = y - velY * convergence;
  }

  void make() {
    this.stroker();
    ellipseMode(RADIUS);
    fill(this.col);
    circle(this.posX, this.posY, this.radius);
    this.update();
  }
}

class movingRect extends movingObject{
  float h, w;

  movingRect(float cX, float cY, float w, float h, float velX, float velY, color col, int convergence) {
    this.h = h;
    this.w = w;
    this.velX = velX;
    this.velY = velY;
    this.col = col;
    this.calculateInitialPosition(cX, cY, velX, velY, convergence);
  }

  void calculateInitialPosition(float cX, float cY, float velX, float velY, int convergence) {
    posX = cX - velX * convergence;
    posY = cY - velY * convergence;
  }

  void make() {
    fill(this.col);
    rect(this.posX, this.posY, this.w, this.h);
    this.update();
  }
}

void setup() {
  smooth();
  frameRate(30);
  size(600, 600);
  x = width/2;
  y = height/2;
  rectX = (width - 4)/2;
  //convergence = (int) random(100);
  convergence = 120;
  int j = 0;

  for(int i = 0; i < 11; i++){
    if (i == 0 || i == 4) {
        obj[i] = new movingCircle(baseRadius - i * 15, random(minSpeed, maxSpeed), random(minSpeed, maxSpeed), colorsObj[i], colorsStroke[j], convergence);
        j++;
    } else {
        obj[i] = new movingCircle(baseRadius - i * 15, random(minSpeed, maxSpeed), random(minSpeed, maxSpeed), colorsObj[i], convergence);    
    }
  };
    
  obj[11] = new movingRect(rectX, 300, 4, 165, random(-1, 1), random(-1, 1), colorsObj[11], convergence);
  obj[12] = new movingRect(rectX, 403, 4, 62, random(-1, 1), random(-1, 1), colorsObj[12], convergence);
}

void draw() {
  background(221, 211, 199);
  
  for(int i = 0; i < 13; i++){
    obj[i].make(); 
  }
}
