public class CorwellBoard {
    //private boolean[][] board;
    private short[][] neighborsBoard;
    private int bWidth, bHeight;
    private ArrayList<boolean[][]> stack;
    
    CorwellBoard(int w, int h) {
        this.bWidth = w;
        this.bHeight = h;
        
        boolean[][] board = new boolean[w][h];
        
        for (int i = 0; i < w; i++) {
            for (int j = 0; j < h; j++) {
                board[i][j] = noise(i/10.0, j/10.0) > 0.5; 
            }
        }
        
        this.stack = new ArrayList<boolean[][]>();
        this.stack.add(board);
        this.calculateNeighborsBoard();
    }
    
    public void previousStep() {
      this.stack.remove(stack.size() - 1);
      calculateNeighborsBoard();
    }
    
    public void nextStep() {
        boolean[][] nextBoard = new boolean[this.bWidth][this.bHeight];
        
        for (int i = 0; i < bWidth; i++) {
            for (int j = 0; j < bHeight; j++) {
                nextBoard[i][j] = getNextState(i, j); 
            }
        }
        
        this.stack.add(nextBoard);
        calculateNeighborsBoard();
    }
    
    private boolean getNextState(int w, int h) {
        int neighbors = getNeighborsCount(w, h);
        
        return(neighbors == 3) || (neighbors == 2 && this.getCell(w, h));
    }
    
    
    
    private void calculateNeighborsBoard() {
        short[][] nBoard = new short[this.bWidth][this.bHeight];
        
        for (int i = 0; i < bWidth; i++) {
            for (int j = 0; j < bHeight; j++) {
                if (this.getCell(i, j)) {
                    for (int x = i - 1; x <= i + 1; x++) {
                        for (int y = j - 1; y <= j + 1; y++) {
                            nBoard[getX(x)][getY(y)]++;
                        }
                    }
                    
                    nBoard[i][j]--;
                }
            } 
        }
        
        this.neighborsBoard = nBoard;
    }
    
    public int getNeighborsCount(int x, int y) {
        return this.neighborsBoard[this.getX(x)][this.getY(y)];
    }
    
    public boolean getCell(int w, int h) {
        return this.stack.get(this.stack.size() - 1)[getX(w)][getY(h)];
    }
    
    public int getX(int x) {
        return Math.floorMod(x, this.bWidth);
    }
    
    public int getY(int y) {
        return Math.floorMod(y, this.bHeight);
    }
    
    public long getCount() {
        return this.stack.size();
    }
    
    public int getWidth() {
        return this.bWidth;
    }
    
    public int getHeight() {
        return this.bHeight;
    }
}
