class Bone
{
  float x, y, size, xdir, ydir;
  boolean vert;
  
  Bone(float X, float Y, float Size, float Xdir, float Ydir, boolean Vert)
  {
    x = X;
    y = Y;
    size = Size;
    xdir = Xdir;
    ydir = Ydir;
    vert = Vert;
  }
  
  void display()
  {
    fill(0, 0, 100); // white
    stroke(0, 0, 100); // white
    
    if (!vert)
    {
      rect(x, y, size * 2, size / 4);
      circle(x, y + size / 4, size / 3);
      circle(x, y, size / 3);
      circle(x + size * 2, y + size / 4, size / 3);
      circle(x + size * 2, y, size / 3);
    }
    else
    {
      rect(x, y, size / 4, size * 2);
      circle(x, y, size / 3);
      circle(x + size / 4, y, size / 3);
      circle(x, y + size * 2, size / 3);
      circle(x + size / 4, y + size * 2, size / 3);
    }
    stroke(0, 0, 50); // grey
  }
  
  void movement()
  {
    x += xdir;
    y += ydir;
    
    if (x > width)
    {
      x = -size/2;
    }
    
    if (y > height)
    {
      y = -size/4;
    }
  }
}
