class Box
{
  int x;
  int y;
  int size;
  
  Box(int x, int y, int size)
  {
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  void display()
  {
    rect(x, y, size / 4, size * 2);
    circle(x, y, size / 3);
    circle(x + size / 4, y, size / 3);
    circle(x, y + size * 2, size / 3);
    circle(x + size / 4, y + size * 2, size / 3);
    rect(width-x, y, size / 4, size * 2);
    circle(width-x, y, size / 3);
    circle(width-x + size / 4, y, size / 3);
    circle(width-x, y + size * 2, size / 3);
    circle(width-x + size / 4, y + size * 2, size / 3);
    x++;
    if(x > width/2)
    {
      x = 0;
    }
  }
}
