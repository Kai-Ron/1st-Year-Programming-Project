class Box
{
  int x;
  int y;
  int w;
  int h;
  
  Box(int x, int y, int w, int h)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void display()
  {
    rect(x,y,w,h);
    rect(width-x,y,w,h);
    x++;
    if(x > width/2)
    {
      x = 0;
    }
  }
}
