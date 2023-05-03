class Heart
  {
    float startX, startY, size, radius, velocity;
    float baseSize, baseRadius, baseVelocity;
    color colour = color(100, 100, 100);
    float radians = 0;
    int r, g, b;
    
    float x = 0;
    float y = -1;
    
    Heart(float xPos, float yPos, float diameter, float distance, float speed, float degree, int red, int green, int blue)
    {
      startX = xPos;
      startY = yPos;
      size = diameter;
      baseSize = diameter;
      radius = distance;
      baseRadius = distance;
      velocity = speed;
      baseVelocity = speed;
      radians = degree;
      r = red;
      g = green;
      b = blue;
      colour = color(r, g, b);
    }
    
    void update()
    {
      if (!paused)
      {
        radians += (velocity / 10000);
        x = startX + (cos(radians) * radius);
        y = startY + (sin(radians) * radius);
      }
    }
    
    void display()
    {
      fill(colour);
      noStroke();
      // circle(x, y, size);
      
      pushMatrix();
      translate(x, y);
      rotate(radians);
      beginShape();
      vertex(0, 0);
      bezierVertex(- size/4, 0, - size/8, size/2, size/4, 0);
      vertex(0, 0);
      bezierVertex(- size/4, 0, - size/8, - size/2, size/4, 0);
      endShape();
      popMatrix();
      
    }
  }
