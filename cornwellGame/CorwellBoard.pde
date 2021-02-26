public interface CorwellBoard {
    public short getNeighborsCount(int x, int y);
    
    public boolean getCell(int w, int h);
    
    public int getX(int x);
    
    public int getY(int y);
    
    public int getCount();
    
    public int getWidth();
    
    public int getHeight();
    
    public void previousStep();
    
    public void nextStep();
    
    public ArrayList<short[]> getCoordinates();
    
    private void printBoard() {
        ArrayList<short[]> coords = this.getCoordinates();
        for (int i = 0; i < coords.size(); i++) {
            short[] coord = coords.get(i);   
            print(coord[0], coord[1], '\n');
        } 
    }
}
