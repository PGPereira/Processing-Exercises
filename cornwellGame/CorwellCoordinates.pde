public class CorwellCoordinates {
    private short[][] neighborsBoard;
    private int bWidth, bHeight;
    private ArrayList<ArrayList<short[]>> boardStack;
    private int count;
    
    CorwellCoordinates(int w, int h) {
        this.bWidth = w;
        this.bHeight = h;
        this.boardStack = new ArrayList<ArrayList<short[]>>();
        this.count = 0;
        
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
        this.boardStack.add(coordinates);
        calculateNeighborsBoard();
    }
    
    public void previousStep() {
        if (count > 0) {
          this.count--;
        }
        
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
        this.boardStack.add(coordinates);
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
        return this.boardStack.get(this.boardStack.size() - 1).parallelStream().anyMatch(a -> a[0] == getX(w) && a[1] == getY(h));
    }
    
    public int getX(int x) {
        return Math.floorMod(x, this.bWidth);
    }
    
    public int getY(int y) {
        return Math.floorMod(y, this.bHeight);
    }
    
    public int getCount() {
        return this.boardStack.size();
    }
    
    public int getWidth() {
        return this.bWidth;
    }
    
    public int getHeight() {
        return this.bHeight;
    }
    
    private short[][] calculateNeighborsBoard() {
        short[][] nBoard = new short[this.getWidth()][this.getHeight()];
        
        getCoordinates(this.boardStack.size() - 1)
           .parallelStream()
           .forEach(coordinate -> {
                short i = coordinate[0];
                short j = coordinate[1];
                for (int x = i - 1; x <= i + 1; x++) {
                    for (int y = j - 1; y <= j + 1; y++) {
                        nBoard[getX(x)][getY(y)]++;
                    }
                }
                
                nBoard[i][j]--;
            });
        
        return nBoard;
    }
    
    public void setNeighborsBoard(short[][] board) {
        this.neighborsBoard = board;
    };
    
    public ArrayList<short[]> getCoordinates(int stackCount) {
        return this.boardStack.get(stackCount);
    }
    
    private int getCoordinatesCount() {
        return this.boardStack.get(this.boardStack.size() - 1).size();
    }
}
