import java.util.*; 

PImage toDither, dithered;
ColorManager colorManager;
ImageManager iManager;
ArrayList<Dither> ditherList;
ArrayList<ColorPalette> paletteList;
ColorPalette palette;
Dither dither;
int chosenPalette, chosenDither;
ArrayList<float[][]> cohificientList;
boolean overlay;

void setup() {
  size(850, 500, P2D);
  noStroke();
  colorMode(RGB, 255);
  
  toDither = loadImage("baby.jpg");
  toDither.resize(width, 0);
  
  int paletteSize = int(random(4, 40));
  Set<Integer> list = new LinkedHashSet<Integer>(paletteSize); 
  for(int i = 0; i < paletteSize; i++) {
    list.add(color(random(255), random(255), random(255)));
  }
  
  color[] randomPalette = new color[list.size()];
  Iterator<Integer> iterator = list.iterator();
  for (int i = 0; i < randomPalette.length; i++) {
      randomPalette[i] = iterator.next().intValue();
  }
  
  paletteList = new ArrayList<ColorPalette>();
  ditherList = new ArrayList<Dither>();
  cohificientList = new ArrayList<float[][]>(20);
  
  colorManager = new ColorManager();
  ImageManager iManager = new ImageManager(toDither, colorManager);
  color[] bWhite = { #000000, #FFFFFF };
  color[] phosphor = { #000000, #00AA00 };
  color[] darkAmber = { #000000, #FFB000 };
  color[] primary = { #FF0000, #00FF00, #0000FF };
  color[] cmyk = { #FFFF00, #00FFFF, #FF00FF, #000000 };
  color[] solarized = {
    #002b36, #073642, #586e75, #657b83, #839496, #93a1a1, #eee8d5, #fdf6e3,
    #b58900, #cb4b16, #dc322f, #d33682, #6c71c4, #268bd2, #2aa198, #859900
  };
  color[] lightAmber = { #FFCC00, #FFFFFF };
  color[] daftPunk = { #8e2a8b, #ef58a0, #fde74e, #97bd4c, #86d3f1 };
  color[] soviet = { #f8c104, #cc0404, #e15e04, #d43004, #cc2004 };
  color[] propaganda = { #8C8670, #000000, #8F0000, #DB5B00, #E3D5C1 };
  color[] cyan = { #050505, #050555, #055555, #55a5a5, #a5f5f5 };
  color[] gameBoy = { #003f00, #2e7320, #8cbf0a, #a0cf0a };
  color[] brazil = {#009c3b, #ffdf00, #002776, #ffffff};
  color[] usa = {#3c3b6e, #ffffff, #b22234};
  color[] nesPalette = {
    #59595F, #00008F, #18008F, #3F0077, #550055, #550011, #550000, #442200,
    #333300, #113300, #003311, #004444, #004466, #000000, #0044DD, #5511EE, 
    #7700EE, #9900BB, #AA0055, #993300, #884400, #666600, #336600, #006600,
    #006655, #005588, #EEEEEE, #4488FF, #7777FF, #9944FF, #BB44EE, #CC5599,
    #DD6644, #CC8800, #BBAA00, #77BB00, #22BB22, #22BB77, #22BBCC, #444444,
    #99CCFF, #AAAAFF, #BB99FF, #DD99FF, #EE99DD, #EEAAAA, #EEBB99, #EEDD88,
    #BBDD88, #99DD99, #99DDBB, #99DDEE, #AAAAAA
  };
  color[] cubaLibre = { #D00C27, #FFFFFF, #002690 };
  color[] athletico = { #C8102E, #2D2926 }; 

  paletteList.add(new ColorPalette(colorManager, "Original 4-Bits", iManager.getPalette(4)));
  paletteList.add(new ColorPalette(colorManager, "Original 3-Bits", iManager.getPalette(3)));
  paletteList.add(new ColorPalette(colorManager, "Original 2-Bits", iManager.getPalette(2)));
  paletteList.add(new ColorPalette(colorManager, "Original 1-Bit", iManager.getPalette(1)));
  paletteList.add(new ColorPalette(colorManager, "GameBoy", gameBoy));
  paletteList.add(new ColorPalette(colorManager, "Cyan", cyan));
  paletteList.add(new ColorPalette(colorManager, "B&W", bWhite));
  paletteList.add(new ColorPalette(colorManager, "RGB", primary));
  paletteList.add(new ColorPalette(colorManager, "Daft Punk", daftPunk));
  paletteList.add(new ColorPalette(colorManager, "CMYK", cmyk));
  paletteList.add(new ColorPalette(colorManager, "Solarized", solarized));
  paletteList.add(new ColorPalette(colorManager, "Phosphor", phosphor));
  paletteList.add(new ColorPalette(colorManager, "Light Amber", lightAmber));
  paletteList.add(new ColorPalette(colorManager, "This is Brazil", brazil));
  paletteList.add(new ColorPalette(colorManager, "Cuba libre", cubaLibre));
  paletteList.add(new ColorPalette(colorManager, "I was born in USA", usa));
  paletteList.add(new ColorPalette(colorManager, "Dark Amber", darkAmber));
  paletteList.add(new ColorPalette(colorManager, "Slava Comrade", soviet));
  paletteList.add(new ColorPalette(colorManager, "Propaganda", propaganda));
  paletteList.add(new ColorPalette(colorManager, "Paranaense", athletico));
  paletteList.add(new ColorPalette(colorManager, "NES Palette", nesPalette));
  paletteList.add(new ColorPalette(colorManager, "Random Palette", randomPalette));
  
  ErrorScatherAlgorithm sierra, sierra2, sierraLite, atkinson, floydSteinberg, burkes, minimizedAverageError, stucki, stevensonArce;
  sierra = new ErrorScatherAlgorithm("Sierra", 10);
  sierra.addScather(1, 0, 5/32.0);
  sierra.addScather(2, 0, 3/32.0);
  sierra.addScather(-2, 1, 2/32.0);
  sierra.addScather(-1, 1, 4/32.0);
  sierra.addScather(0, 1, 5/32.0);
  sierra.addScather(1, 1, 4/32.0);
  sierra.addScather(2, 1, 2/32.0);
  sierra.addScather(-1, 2, 2/32.0);
  sierra.addScather(0, 2, 3/32.0);
  sierra.addScather(1, 2, 2/32.0);
  
  sierra2 = new ErrorScatherAlgorithm("Sierra-2", 7);
  sierra2.addScather(1, 0, 4/16.0);
  sierra2.addScather(2, 0, 3/16.0);
  sierra2.addScather(-2, 1, 1/16.0);
  sierra2.addScather(-1, 1, 2/16.0);
  sierra2.addScather(0, 1, 3/16.0);
  sierra2.addScather(1, 1, 2/16.0);
  sierra2.addScather(2, 1, 1/16.0);
  
  sierraLite = new ErrorScatherAlgorithm("Sierra Lite", 3);
  sierraLite.addScather(1, 0, 2/4.0);
  sierraLite.addScather(0, 1, 1/4.0);
  sierraLite.addScather(-1, 1, 1/4.0);
    
  atkinson = new ErrorScatherAlgorithm("Atkinson", 6);
  atkinson.addScather(1, 0, 1/8.0);
  atkinson.addScather(2, 0, 1/8.0);
  atkinson.addScather(-1, 1, 1/8.0);
  atkinson.addScather(0, 1, 1/8.0);
  atkinson.addScather(1, 1, 1/8.0);
  atkinson.addScather(0, 2, 1/8.0);
    
  floydSteinberg = new ErrorScatherAlgorithm("Floyd Steinberg", 4);
  floydSteinberg.addScather(1, 0, 7/16.0); 
  floydSteinberg.addScather(-1, 1, 3/16.0); 
  floydSteinberg.addScather(0, 1, 5/16.0); 
  floydSteinberg.addScather(1, 1, 1/16.0);
    
  burkes = new ErrorScatherAlgorithm("Burkes", 7);
  burkes.addScather(1, 0, 8/32.0);
  burkes.addScather(2, 0, 4/32.0);
  burkes.addScather(-1, 1, 2/32.0);
  burkes.addScather(1, 1, 4/32.0);
  burkes.addScather(0, 1, 8/32.0);
  burkes.addScather(1, 1, 4/32.0);
  burkes.addScather(2, 1, 2/32.0);
    
  minimizedAverageError = new ErrorScatherAlgorithm("Jarvis-Judice-Ninke", 12);
  minimizedAverageError.addScather(1, 0, 7/48.0);
  minimizedAverageError.addScather(2, 0, 5/48.0);
  minimizedAverageError.addScather(-2, 1, 3/48.0);
  minimizedAverageError.addScather(-1, 1, 5/48.0);
  minimizedAverageError.addScather(0, 1, 7/48.0);
  minimizedAverageError.addScather(1, 1, 5/48.0);
  minimizedAverageError.addScather(2, 1, 3/48.0);
  minimizedAverageError.addScather(-2, 1, 1/48.0);
  minimizedAverageError.addScather(-1, 1, 3/48.0);
  minimizedAverageError.addScather(0, 1, 5/48.0);
  minimizedAverageError.addScather(1, 1, 3/48.0);
  minimizedAverageError.addScather(2, 1, 1/48.0);
  
  stucki = new ErrorScatherAlgorithm("Stucki", 12);
  stucki.addScather(1, 0, 8/42.0);
  stucki.addScather(2, 0, 4/42.0);
  stucki.addScather(-2, 1, 2/42.0);
  stucki.addScather(-1, 1, 4/42.0);
  stucki.addScather(0, 1, 8/42.0);
  stucki.addScather(1, 1, 4/42.0);
  stucki.addScather(2, 1, 2/42.0);
  stucki.addScather(-2, 1, 1/42.0);
  stucki.addScather(-1, 1, 2/42.0);
  stucki.addScather(0, 1, 4/42.0);
  stucki.addScather(1, 1, 2/42.0);
  stucki.addScather(2, 1, 1/42.0);
  
  
  stevensonArce = new ErrorScatherAlgorithm("Stevenson-Arce", 12);
  stevensonArce.addScather(2, 0, 32/200.0);
  stevensonArce.addScather(-3, 1, 12/200.0);
  stevensonArce.addScather(-1, 1, 26/200.0);
  stevensonArce.addScather(1, 1, 30/200.0);
  stevensonArce.addScather(3, 1, 16/200.0);
  stevensonArce.addScather(-2, 2, 12/200.0);
  stevensonArce.addScather(0, 2, 26/200.0);
  stevensonArce.addScather(2, 2, 12/200.0);
  stevensonArce.addScather(-3, 3, 5/200.0);
  stevensonArce.addScather(-1, 3, 12/200.0);
  stevensonArce.addScather(1, 3, 12/200.0);
  stevensonArce.addScather(3, 3, 5/200.0);
  //            *   .  32
  //12  .   26  .  30   . 16
  // .   12  .  26  .   12  .
  // 5   .   12  .  12   .  5    / 200
  
  dither = new ErrorScatherDither(colorManager, paletteList.get(0), floydSteinberg, 0);
  
  for(int i = 0; i < __SCATHER_METHODS; i++) {
    ditherList.add(new ErrorScatherDither(colorManager, paletteList.get(0), sierra, i));
    ditherList.add(new ErrorScatherDither(colorManager, paletteList.get(0), sierra2, i));
    ditherList.add(new ErrorScatherDither(colorManager, paletteList.get(0), sierraLite, i));
    ditherList.add(new ErrorScatherDither(colorManager, paletteList.get(0), atkinson, i));
    ditherList.add(new ErrorScatherDither(colorManager, paletteList.get(0), floydSteinberg, i));
    ditherList.add(new ErrorScatherDither(colorManager, paletteList.get(0), burkes, i));
    ditherList.add(new ErrorScatherDither(colorManager, paletteList.get(0), minimizedAverageError, i));
    ditherList.add(new ErrorScatherDither(colorManager, paletteList.get(0), stucki, i));
    ditherList.add(new ErrorScatherDither(colorManager, paletteList.get(0), stevensonArce, i));
  }
  
  int[] gen = {0, 2, 3, 1};
  float[][][] seeds = {
    {
      {0}
    }, 
    //{
    //  {0, 4, 1},
    //  {3, 2, 5}
    //}, 
    //{
    //  {0, 1}
    //},{
    //  {0, 2, 3, 1}
    //}, {
    //  {0},
    //  {2},
    //  {1}
    //}
  };
  
  for(int i = 0; i < seeds.length; i++) {
    cohificientMatrixGenerator(seeds[i], 0,  3, gen);
  }
  
  for(int i = 0; i < cohificientList.size(); i++) {
    ditherList.add(new OrderedDither(colorManager, paletteList.get(0), cohificientList.get(i)));
  }
  
  ditherList.add(new PerlinNoiseDither(colorManager, paletteList.get(0)));
  ditherList.add(new RandomDither(colorManager, paletteList.get(0)));
  //dither = new GameOfLifeDither(colorManager, paletteList.get(0), toDither);
  ditherList.add(new GameOfLifeDither(colorManager, paletteList.get(0), toDither));
  chosenPalette = round(random(0, paletteList.size() - 1));
  chosenDither = round(random(0, ditherList.size() - 1));
  palette = paletteList.get(0);
}

void draw() {
  palette = paletteList.get(chosenPalette);
  dither = ditherList.get(chosenDither);
  dither.setPalette(palette);

  dithered = dither.getDitheredImage(toDither);
  background(0);
  
  float w = width/palette.getColorsQuantity();
  for(int i = 0; i < palette.getColorsQuantity(); i++){
    fill(palette.getColorByIndex(i));
    rect(i * w, 0, (i + 1) * w, height);
  }
  image(dithered, 0, 0);
  
  
  if(overlay) {
    fill(255);
    textSize(16);
    text(dither.getName(), 5, 20);
    text(palette.getName(), 5, dithered.height - 6);
    textSize(12);
    text(frameCount + "  " + frameRate, 5, 32);
  }
  
  System.gc();
}

void keyPressed(){
  if(key == 'x') {
    saveFrame("palette-#########.png");
  }
  
  if(key == 'd') {
    chosenDither = Math.floorMod(chosenDither + 1, ditherList.size());
  }
  
  if(key == 'a') {
    chosenDither = Math.floorMod(chosenDither - 1, ditherList.size());
  }
  
  if(key == 'w') {
    chosenPalette = Math.floorMod(chosenPalette + 1, paletteList.size());
  }
  
  if(key == 's') {
    chosenPalette = Math.floorMod(chosenPalette - 1, paletteList.size());
  }
  
  if(key == 'r') {
    chosenPalette = round(random(0, paletteList.size() - 1));
    chosenDither = round(random(0, ditherList.size() - 1));
  }
  
  if(key == 'o') {
    overlay = !overlay;
  }
  
  if(key == 'z') {
    color c1 = #000000, c2 = #000000;
    dithered.loadPixels();
    for(int j = 0; j < dithered.height; j++) {
      for(int i = 0; i < dithered.width; i++) {
        int index = colorManager.getPixelIndex(i, j, dithered);
        if((i + j) % 2 == 0) {
          c1 = dithered.pixels[index];
        } else {
          c2 = dithered.pixels[index];
          print(colorManager.getSteganograficChar(c1, c2));
        }
      }
    }
    dithered.updatePixels();
  }
}

private void cohificientMatrixGenerator(float[][] lesserMatrix, int depth, int maxLength, int[] generator){
    int lesserWidth = lesserMatrix.length;
    int lesserHeight = lesserMatrix[0].length;
    
    int greaterWidth = lesserWidth * 2;
    int greaterHeight = lesserHeight * 2;
    
    float k = 1.0/(greaterWidth * greaterHeight);
    float[][] greaterMatrix = new float[greaterWidth][greaterHeight];
    float[][] finalMatrix = new float[greaterWidth][greaterHeight];
    
    for(int i = 0; i < lesserWidth; i++){
      for(int j = 0; j < lesserHeight; j++){
        greaterMatrix[2 * i    ][2 * j    ] = 4 * (lesserMatrix[i][j]) + generator[0];
        greaterMatrix[2 * i + 1][2 * j    ] = 4 * (lesserMatrix[i][j]) + generator[1];
        greaterMatrix[2 * i    ][2 * j + 1] = 4 * (lesserMatrix[i][j]) + generator[2];
        greaterMatrix[2 * i + 1][2 * j + 1] = 4 * (lesserMatrix[i][j]) + generator[3];
      }
    }
    
    for(int i = 0; i < greaterWidth; i++){
      for(int j = 0; j < greaterHeight; j++){
        //finalMatrix[i][j] = greaterMatrix[i][j] * k - 0.5;
        finalMatrix[i][j] = greaterMatrix[i][j] * k;
      }
    }
    
    cohificientList.add(finalMatrix);
    
    if(depth < maxLength){
      cohificientMatrixGenerator(greaterMatrix, depth+1, maxLength, generator);
    }
}
