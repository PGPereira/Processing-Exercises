PImage toDither, dithered, boutroDithered, colorSpaced, crossDithered;
OrderedDither crossDither, squaredDither;
ErrorScatherDither nesDither;
ColorManager colorManager;
 
color[] nesPalette = {
  #59595F, #00008F, #18008F, #3F0077,
  #550055, #550011, #550000, #442200,
  #333300, #113300, #003311, #004444,
  #004466, #000000, #0044DD, #5511EE,
  #7700EE, #9900BB, #AA0055, #993300,
  #884400, #666600, #336600, #006600,
  #006655, #005588, #EEEEEE, #4488FF,
  #7777FF, #9944FF, #BB44EE, #CC5599,
  #DD6644, #CC8800, #BBAA00, #77BB00,
  #22BB22, #22BB77, #22BBCC, #444444,
  #99CCFF, #AAAAFF, #BB99FF, #DD99FF,
  #EE99DD, #EEAAAA, #EEBB99, #EEDD88,
  #BBDD88, #99DD99, #99DDBB, #99DDEE,
  #AAAAAA
};

color[] nintendoPalette = {
  #000000, #FCFCFC, #F8F8F8, #BCBCBC,
  #7C7C7C, #a4e4fc, #3cbcfc, #0078f8,
  #0000fc, #b8b8f8, #6888fc, #0058f8,
  #0000bc, #d8b8f8, #9878f8, #6844fc,
  #4428bc, #f8b8f8, #f878f8, #d800cc,
  #940084, #f8a4c0, #f85898, #e40058,
  #a80020, #f0d0b0, #f87858, #f83800,
  #a81000, #fce0a8, #fca044, #e45c10,
  #881400, #f8d878, #f8b800, #ac7c00,
  #503000, #d8f878, #b8f818, #00b800,
  #007800, #b8f8b8, #58d854, #00a800,
  #006800, #b8f8d8, #58f898, #00a844,
  #005800, #00fcfc, #00e8d8, #008888,
  #004058, #f8d8f8, #787878
};

color[] cyan = {
  #050505, #050555, #055555, #55a5a5, #a5f5f5,
};

color[] gameBoy = {
  #003f00, 
  #2e7320, 
  #8cbf0a, 
  #a0cf0a
};

color[] soviet = {
  //#000000, #1C1C19, #FCEA97, #A60202,
  //#FFC003, #000000, #1C1C19, #FCEA97
  #f8c104, #cc0404, #e15e04, #d43004, #cc2004
};

color[] test = {
  #ffffff,
  #eeeeee,
  #dddddd,
  #cccccc,
  #bbbbbb,
  #aaaaaa,
  //#888888,
  //#444444,
  #000000,
  #FF0000,
  //#880000,
  //#AA0000,
  //#440000
};

color[] phosphor = {
  #000000,
  #00AA00,
  //#FFB000,
  //#FFCC00,
  //#33FF00,
  //#33FF33,
  //#66FF66,
  //#00FF66,
  //#FFFFFF
};

color[] bWhite = {
  #000000,
  #FFFFFF
};

void setup() {
  size(960, 800);
  noStroke();
  toDither = loadImage("eu.JPG");
  int paletteLength = 10;
  color[] palette = new color[paletteLength];
  float w = float(width)/palette.length;
  for(int i = 0; i < palette.length; i++){
    palette[i] = color(random(255), random(255), random(255));
    //fill(palette[i]);
    //rect(i * w, 0, w, height);
  }
  
  colorMode(RGB, 255);
  
  crossDither = new OrderedDither(gameBoy, 1);
  squaredDither = new OrderedDither(gameBoy, 0);
  nesDither = new ErrorScatherDither(gameBoy);
  
  toDither.resize(toDither.width/4, 0);
  //toDither = nesDither.addScanLine(toDither);
  palette = nesDither.getPalette();
  w = float(width)/palette.length;
  for(int i = 0; i < palette.length; i++){
    fill(palette[i]);
    rect(i * w, 0, w, height);
  }
 
  crossDithered = crossDither.getDitheredImage(toDither);
  colorSpaced = squaredDither.getDitheredImage(toDither);
  dithered = nesDither.getDitheredImage(toDither);
  boutroDithered = nesDither.getBoutrophedonDitheredImage(toDither);  
}

void draw() {
  //image(toDither, 0, 0);
  image(colorSpaced, 0, 0);
  image(crossDithered, toDither.width, 0);
  image(dithered, 0, toDither.height);
  image(boutroDithered, toDither.width, toDither.height);
}

void keyPressed(){
  if(key == 's') {
    saveFrame("palette-#########.png");
  }
}

public PImage addScanLine(PImage image) {
    PImage changed = image.copy();
    int scanHeigth = 1;
    int stepSize = 4;
    changed.loadPixels();
    for(int j = scanHeigth; j + scanHeigth <= changed.height - 1; j += stepSize) {
      for(int i = 0; i < changed.width; i++) {
        for(int k = 1; k <= scanHeigth; k++) {
          if((k + j + i) % 2 == 0) {
            changed.pixels[colorManager.getPixelIndex(i, j + k, image)] = color(0,0,0);
          }
        }
        
        for(int k = 1; k < scanHeigth; k++) {
          if((-k + j + i) % 2 == 0) {
            changed.pixels[colorManager.getPixelIndex(i, j - k, image)] = color(255,255,255);
          }
        }
      }
    }
    changed.updatePixels();
      
    return changed;
}
