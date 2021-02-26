public class CorwellCoordinates implements CorwellBoard {
    private short[][] neighborsBoard;
    private int bWidth, bHeight;
    private ArrayList<ArrayList<short[]>> stack;
    private int[][] lastTimeAlive;
    
    CorwellCoordinates(int w, int h) {
        this.bWidth = w;
        this.bHeight = h;
        this.stack = new ArrayList<ArrayList<short[]>>();
        this.lastTimeAlive = new int[w][h];
        
        ArrayList<short[]> coordinates = new ArrayList<short[]>(this.getWidth() * this.getHeight());
        
        for (short i = 0; i < w; i++) {
            for (short j = 0; j < h; j++) {
                if (noise(i / 10.0, j / 10.0) > 0.5) { 
                    short[] coord = {i, j};
                    coordinates.add(coord); 
                }
            }
        }
        
        coordinates.trimToSize();
        this.stack.add(coordinates);
        calculateNeighborsBoard();
    }
    
    public void previousStep() {
        this.stack.remove(stack.size() - 1);
        calculateNeighborsBoard();
    }
    
    public void nextStep() {
        ArrayList<short[]> coordinates = new ArrayList<short[]>(this.getCoordinatesCount());
      
        for (short i = 0; i < bWidth; i++) {
            for (short j = 0; j < bHeight; j++) {
                if (getNextState(i, j)) {
                    short[] coord = {i, j};
                    coordinates.add(coord);
                }
            }
        }
        
        coordinates.trimToSize();
        this.stack.add(coordinates);
        calculateNeighborsBoard();
    }
    
    private boolean getNextState(short w, short h) {
        short neighbors = getNeighborsCount(w, h);
        
        return(neighbors == 3) || (neighbors == 2 && this.getCell(w, h));
    }
    
    public short getNeighborsCount(int x, int y) {
        return this.neighborsBoard[this.getX(x)][this.getY(y)];
    }
    
    public boolean getCell(int w, int h) {
        return this.stack.get(this.stack.size() - 1).parallelStream().anyMatch(a -> a[0] == getX(w) && a[1] == getY(h));
    }
    
    public int getX(int x) {
        return Math.floorMod(x, this.bWidth);
    }
    
    public int getY(int y) {
        return Math.floorMod(y, this.bHeight);
    }
    
    public int getCount() {
        return this.stack.size();
    }
    
    public int getWidth() {
        return this.bWidth;
    }
    
    public int getHeight() {
        return this.bHeight;
    }
    
    private void calculateNeighborsBoard() {
        short[][] nBoard = new short[this.getWidth()][this.getHeight()];
        
        for (short[] coordinate : this.getCoordinates()) {
            short i = coordinate[0];
            short j = coordinate[1];
            
            for (int x = i - 1; x <= i + 1; x++) {
                for (int y = j - 1; y <= j + 1; y++) {
                    nBoard[getX(x)][getY(y)]++;
                }
            }
            
            nBoard[i][j]--;
        } 
        
        this.setNeighborsBoard(nBoard);
    }
    
    public void setNeighborsBoard(short[][] board) {
        this.neighborsBoard = board;
    };
    
    public ArrayList<short[]> getCoordinates() {
        return this.stack.get(this.stack.size() - 1);
    }
    
    private int getCoordinatesCount() {
        return this.stack.get(this.stack.size() - 1).size();
    }
    
    public int getLastAlive(int i, int j) {
        return this.lastTimeAlive[i][j];
    }
}
