public class CorwellGrid {
    private int bWidth, bHeight;
    private ArrayList<boolean[][]> boardStack;
    private ArrayList<short[][]> neighborsStack;
    private int count;
    
    CorwellGrid(int w, int h) {
        this.bWidth = w;
        this.bHeight = h;
        this.count = 0;
        
        this.boardStack = new ArrayList<boolean[][]>();
        this.neighborsStack = new ArrayList<short[][]>();
        
        boolean[][] board = new boolean[w][h];
        
        for (int i = 0; i < w; i++) {
            for (int j = 0; j < h; j++) {
                board[i][j] = noise(i, j) > 0.5;
            }
        }
        
        this.boardStack.add(board);
        this.neighborsStack.add(calculateNeighborsBoard());
    }
    
    public void previousStep() {
        if (this.getCount() > 0) {
            this.count--;
        }
    }
    
    public void nextStep() {
        if (this.getCount() < this.boardStack.size() - 1) {
            this.count++;
        }
    }
    
    public void calculateNextStep() {
        boolean[][] nextBoard = new boolean[this.getWidth()][this.getHeight()];
        for (int i = 0; i < bWidth; i++) {
            for (int j = 0; j < bHeight; j++) {
                nextBoard[i][j] = getNextState(i, j);
            }
        }
        
        this.boardStack.add(nextBoard);
        this.neighborsStack.add(calculateNeighborsBoard());
    }
    
    private boolean getNextState(int w, int h) {
        short neighbors = getNeighborsCount(w, h, this.boardStack.size() - 1);
        return(neighbors == 3) || (neighbors == 2 && this.getCell(w, h));
    }
    
    public short getNeighborsCount(int x, int y) {
        return this.getNeighborsCount(x, y, this.getCount());
    }
    
    private short getNeighborsCount(int x, int y, int stackCount) {
        return this.neighborsStack.get(stackCount)[this.getX(x)][this.getY(y)];
    }
    
    private boolean getCell(int w, int h) {
        return this.boardStack.get(this.boardStack.size() - 1)[getX(w)][getY(h)];
    }
    
    private boolean getCell(int w, int h, int stackCount) {
        return this.boardStack.get(stackCount)[getX(w)][getY(h)];
    }
    
    private  int getX(int x) {
        return Math.floorMod(x, this.getWidth());
    }
    
    private  int getY(int y) {
        return Math.floorMod(y, this.getHeight());
    }
    
    public int getCount() {
        return this.count;
    }
    
    public int getWidth() {
        return this.bWidth;
    }
    
    public int getHeight() {
        return this.bHeight;
    }
    
    private short[][] calculateNeighborsBoard() {
        short[][] nBoard = new short[this.getWidth()][this.getHeight()];
        for (short[] coordinate : this.getCoordinates(this.boardStack.size() - 1)) {
            short i = coordinate[0];
            short j = coordinate[1];
            
            for (int x = i - 1; x <= i + 1; x++) {
                for (int y = j - 1; y <= j + 1; y++) {
                    nBoard[getX(x)][getY(y)]++;
                }
            }
            
            nBoard[i][j]--;
        } 
        
        return nBoard;
    }
    
    public ArrayList<short[]> getCoordinates() {
        return getCoordinates(this.getCount());
    }  
    
    private ArrayList<short[]> getCoordinates(int stackCount) {
        ArrayList<short[]> coordinates = new ArrayList<short[]>(this.getWidth() * this.getHeight());
        
        for (short i = 0; i < bWidth; i++) {
            for (short j = 0; j < bHeight; j++) {
                if (this.getCell(i, j, stackCount)) {
                    short[] coord = {i, j};
                    coordinates.add(coord);
                }
            }
        }
        
        coordinates.trimToSize();
        return coordinates;
    }
}
