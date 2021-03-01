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
}
