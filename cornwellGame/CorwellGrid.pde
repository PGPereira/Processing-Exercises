public class CorwellGrid {
    private int bWidth, bHeight;
    private ArrayList<boolean[][]> boardStack;
    //private ArrayList<short[][]> neighborsStack;
    private ArrayList<ArrayList<Integer>> lastSeenStack;
    private short[][] neighborsBoard, lastSeenBoard;
    private int count;
    
    CorwellGrid(int w, int h) {
        this.bWidth = w;
        this.bHeight = h;
        this.count = 0;
        
        this.boardStack = new ArrayList<boolean[][]>();
        //this.neighborsStack = new ArrayList<short[][]>();
        this.lastSeenBoard = new short[w][h];
        this.lastSeenStack = new ArrayList<ArrayList<Integer>>(w * h);
        
        boolean[][] board = new boolean[w][h];
        
        for (int i = 0; i < w * h; i++) {
            this.lastSeenStack.add(new ArrayList());
            if(random(0, 1) > 0.7) {
                this.markAlive(i, 0);
                board[i%w][i/w] = true;
                this.lastSeenBoard[i%w][i/w] = 0;
            }  else {
                this.lastSeenBoard[i%w][i/w] = -1;
            }
        }
        
        this.boardStack.add(board);
        //this.neighborsStack.add(calculateNeighborsBoard());
        this.neighborsBoard = calculateNeighborsBoard(0);
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
        int w = this.getWidth(), h = this.getHeight();
        boolean[][] nextBoard = new boolean[w][h];
        for (int i = 0; i < w; i++) {
            for (int j = 0; j < h; j++) {
                if (getNextState(i, j)) {
                  nextBoard[i][j] = true;
                  markAlive(i * h + j, this.getStackSize());
                }
            }
        }
        
        this.boardStack.add(nextBoard);
        this.neighborsBoard = calculateNeighborsBoard(this.boardStack.size() - 1);
        //this.neighborsStack.add(calculateNeighborsBoard());
    }
    
    private boolean getNextState(int w, int h) {
        //short neighbors = getNeighborsCount(w, h, this.boardStack.size() - 1);
        short neighbors = getNeighborsCount(w, h);
        return(neighbors == 3) || (neighbors == 2 && this.getCell(w, h));
    }
    
    public short getNeighborsCount(int x, int y) {
        return this.neighborsBoard[this.getX(x)][this.getY(y)];
        //return this.getNeighborsCount(x, y, this.getCount());
    }
    
    //public short getNeighborsCount(int x, int y, int stackCount) {
        
    //    //return this.neighborsStack.get(stackCount)[this.getX(x)][this.getY(y)];
    //}
    
    private boolean getCell(int w, int h) {
        return this.boardStack.get(this.boardStack.size() - 1)[getX(w)][getY(h)];
    }
    
    private boolean getCell(int w, int h, int stackCount) {
        return this.boardStack.get(stackCount)[getX(w)][getY(h)];
    }
    
    private  int getX(int value) {
        int mod = this.getWidth();
        return ((value % mod) + mod) % mod;
    }
    
    private  int getY(int value) {
        int mod = this.getHeight();
        return ((value % mod) + mod) % mod;
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
    
    private short[][] calculateNeighborsBoard(int c) {
        short[][] nBoard = new short[this.getWidth()][this.getHeight()];
        
        getCoordinates(c)
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
    
    public int getStackSize() {
      return this.boardStack.size();
    }
    
    public ArrayList<short[]> getCoordinates() {
        return getCoordinates(this.getCount());
    }  
    
    public ArrayList<short[]> getCoordinates(int stackCount) {
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
    
    public void markAlive(int hash, int time) {       
        this.lastSeenStack.get(hash).add(time);
    }
    
    public int getLastTimeCellAlive(int w, int h, int time) {
        ArrayList<Integer> lSeen = this.lastSeenStack.get(this.getX(w) * this.getHeight() + this.getY(h));
        for (int i = lSeen.size() - 1; i >= 0; i--){
          Integer alive = lSeen.get(i);
          if(alive <= time){
            return alive;
          }
        }
        
        return -1;
    }
    
    public int roundsOfCellAlive(int w, int h, int time) {
      ArrayList<Integer> lSeen = this.lastSeenStack.get(this.getX(w) * this.getHeight() + this.getY(h));
      return lSeen.size();
    }
    
    public int[][] getLastAliveBoard(int time) {
      int[][] board = new int[this.getWidth()][this.getHeight()];
      
      for(int i = 0; i < this.getWidth(); i++) {
        for(int j = 0; j < this.getHeight(); j++) {
          board[i][j] = getLastTimeCellAlive(i, j, time);
        }
      } 
      
      return board;
    }
    
    public int[] getLastAliveExtremity(int[][] board, int time) {
      int[] minMax = new int[3];
      minMax[0] = time;
      minMax[1] = -1;
      
      for (int i = 0; i < getWidth(); i++) {
        for (int j = 0; j < getHeight(); j++) {
          if(board[i][j] < minMax[0]) {
            minMax[0] = board[i][j]; 
          }
          
          if(board[i][j] > minMax[1]) {
            minMax[1] = board[i][j]; 
          }
        }
      }
      
      minMax[2] = minMax[1] - minMax[0];
      
      return minMax;
    }
    
    public int lastTimeCellAlive(int w, int h) { 
        for (int i = this.getCount(); i > -1; i--){
          if(this.getCell(w, h, i)){
            return i;
          }
        }
        
        return -1;
    }
}
