interface Dither{
  public String getName();
  public ColorPalette getPalette();
  public void setPalette(color[] palette);
  public void setPalette(ColorPalette palette);
  public PImage getDitheredImage(PImage image);
}
