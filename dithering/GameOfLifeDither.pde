class GameOfLifeDither implements Dither {
  ColorManager colorManager;
  ColorPalette palette;
  boolean[][][] board;
  byte[][][] neighbors;
  int[] longTimeNoSeen;
  int gCount, bWidth, bHeight;
  int [][][] lastSeen;
  String name;
  
  GameOfLifeDither(ColorManager colorManager, ColorPalette palette, PImage image) {
    this.palette = palette;
    this.colorManager = colorManager;
    this.name = "Game of Life Dither";
    
    this.gCount = 0;
    this.bWidth = image.width;
    this.bHeight = image.height;
    this.generateBoardFromImage(image);
  }
  
  public String getName() {
    return this.name;
  }
  
  public ColorPalette getPalette() {
    return this.palette;
  }
  
  public void setPalette(color[] palette) {
    this.palette = new ColorPalette(colorManager, palette);
  }
  
  public void setPalette(ColorPalette palette) {
    this.palette = palette;
  }
  
  public PImage getDitheredImage(PImage image) {
    PImage changed = image.copy();
    
    changed.loadPixels();
    for(int i = 0; i < changed.width; i++) {
      for(int j = 0; j < changed.height; j++) {
        int index = colorManager.getPixelIndex(i, j, changed);
        color oldColor = changed.pixels[index];
        color newColor;
        
        
        //Multiply neighbors by 32
        boolean[] state = new boolean[3];
        float[] neighborsColor = new float[3];
        
        for(int k = 0; k < 3; k++){
          state[k] = this.getCell(i, j, k);
          neighborsColor[k] = map(this.getNeighborsCount(i, j, k), 0, 26, 0, 255);
        }
        
        //oldColor = palette.getEquivalentColor(oldColor);  
        int r = (oldColor >> 16 & 0xFF);
        int g = (oldColor >> 8 & 0xFF);
        int b = (oldColor & 0xFF);          
        
        newColor = color(
          r | ((int)max(map(lastSeen[0][i][j], longTimeNoSeen[0], gCount, 0, r), neighborsColor[0])),
          g | ((int)max(map(lastSeen[1][i][j], longTimeNoSeen[1], gCount, 0, g), neighborsColor[1])),
          r | ((int)max(map(lastSeen[2][i][j], longTimeNoSeen[2], gCount, 0, b), neighborsColor[2]))
        );
        
        //newColor = color(r,g,b);
        
        changed.pixels[index] = palette.getEquivalentColor(newColor);
        //changed.pixels[index] = newColor;
      }
    }
    changed.updatePixels();
    
    calculateNextStep();
    
    return changed;
  }
  
  private void generateBoardFromImage(PImage image){
    boolean[][][] board = new boolean[3][bWidth][bHeight];
    int[][][] lastSeen = new int[3][bWidth][bHeight];
    
    image.loadPixels();
    for(int i = 0; i < bWidth; i++) {
      for(int j = 0; j < bHeight; j++) {
        int index = colorManager.getPixelIndex(i, j, image);
        color c = image.pixels[index]; 
        board[0][i][j] = red(c) >= 128;
        board[1][i][j] = green(c) >= 128;
        board[2][i][j] = blue(c) >= 128;
        for(int k = 0; k < lastSeen.length; k++) {
          lastSeen[k][i][j] = (short)(board[k][i][j] ? 0 : -1);
        }
      }
    }
    image.updatePixels();
    
    this.longTimeNoSeen = new int[3];
    this.board = board;
    this.lastSeen = lastSeen;
    this.neighbors = calculateNeighborsBoard();
  }
  
  public void calculateNextStep() {
     this.gCount++;
     boolean[][][] nextBoard = new boolean[3][bWidth][bHeight];
     for (int i = 0; i < bWidth; i++) {
        for (int j = 0; j < bHeight; j++) {
          for(int k = 0; k < nextBoard.length; k++) {
            if (getNextState(i, j, k)) {
              nextBoard[k][i][j] = true;
              lastSeen[k][i][j] = this.gCount;
            }
          }
        }
      }
      
      this.board = nextBoard;
      this.neighbors = calculateNeighborsBoard(); 
    }
    
    private boolean getNextState(int w, int h, int channel) {
        //short neighbors = getNeighborsCount(w, h, this.boardStack.size() - 1);
        short neighbors = getNeighborsCount(w, h, channel);
        boolean cell = this.getCell(w, h, channel);
        return (neighbors == 3) || (neighbors == 2 && cell);
    }
    
    public byte getNeighborsCount(int x, int y, int channel) {
        return this.neighbors[channel][getX(x)][getY(y)];
    }
    
    private boolean getCell(int w, int h, int channel) {
        return this.board[channel][getX(w)][getY(h)];
    }
    
    public ArrayList<short[]> getCoordinates(int k) {
      longTimeNoSeen[k] = gCount;
      ArrayList<short[]> coordinates = new ArrayList<short[]>(bWidth * bHeight);   
      for (short i = 0; i < bWidth; i++) {
        for (short j = 0; j < bHeight; j++) {
          longTimeNoSeen[k] = min(longTimeNoSeen[k], lastSeen[k][i][j]);  
          if (this.getCell(i, j, k)) {
            short[] coord = {i, j};
            coordinates.add(coord);
          }
        }
      }
      
      coordinates.trimToSize();
      return coordinates;
    }
    
    private byte[][][] calculateNeighborsBoard() {
      byte[][][] nBoard = new byte[3][bWidth][bHeight];
      
      for(int k = 0; k < nBoard.length; k++){
        for(short[] coordinate : getCoordinates(k)){
          short i = coordinate[0];
          short j = coordinate[1];
          for (int x = i - 1; x <= i + 1; x++) {
            for (int y = j - 1; y <= j + 1; y++) {
              nBoard[k][getX(x)][getY(y)]++;
            }
          }
          
          nBoard[k][i][j]--;
        }
      }
      
      return nBoard;
    }
    
    public int getX(int x) {
        return Math.floorMod(x, this.bWidth);
    }
    
    public int getY(int y) {
        return Math.floorMod(y, this.bHeight);
    }
}
