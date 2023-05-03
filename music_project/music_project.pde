import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer ap;
AudioInput ai;
AudioBuffer ab;
PFont font;

float fps = 30;
float smoothingFactor = 0.25;
FFT fft;
int bands = 256;
float[] spectrum = new float[bands];
float[] sum = new float[bands];
float unit;
int groundLineY;
PVector center;

int sphereRadius;

int arrayLength = 8; // Number of bones assigned here
Bone[] bones = new Bone[arrayLength];
boolean paused = false;

int[] r = new int[8];
int[] g = new int[8];
int[] b = new int[8];

Heart[] hearts = new Heart[8];

//Heart heart = new Heart(400, 400, 50, 50, 50, color(200, 100, 100));

void setup()
{
  r[0] = 255;
  r[1] = 255;
  r[2] = 255;
  r[3] = 0;
  r[4] = 0;
  r[5] = 0;
  r[6] = 127;
  r[7] = 255;
  
  g[0] = 0;
  g[1] = 127;
  g[2] = 255;
  g[3] = 255;
  g[4] = 255;
  g[5] = 0;
  g[6] = 0;
  g[7] = 0;
  
  b[0] = 0;
  b[1] = 0;
  b[2] = 0;
  b[3] = 0;
  b[4] = 255;
  b[5] = 255;
  b[6] = 255;
  b[7] = 255;

for (int i = 0; i < hearts.length; i++)
{
  colorMode(RGB);
  hearts[i] = new Heart(width / 2.0f, height / 2.0f, 50, 75, 25, (PI/4) * i, r[i], g[i], b[i]);
  colorMode(HSB);
}
  
  frameRate(fps);
 unit = height / 100;
 strokeWeight(unit/10.24);
 groundLineY = height * 2/4;
 center = new PVector(width / 2, height + 3/4);
  
  colorMode(HSB, 360, 100, 100);
  
  background(0, 0, 0);
  size(800, 800);
  
  minim = new Minim(this);
  ap = minim.loadFile("audio/Megalovania.mp3",2048); //800
  ap.play();
  ab = ap.mix;
  font = createFont("font/8bitoperator_jve.ttf", 20);
  textFont(font);
  textAlign(CENTER);
  
  //bones assigned using x, y, size, xdir, ydir, vert
  
  for (int i = 0; i < arrayLength; i++)
  {
    println(width / arrayLength * i);
    bones[i] = new Bone(width / arrayLength * i, 0, 50f, 2, 0f, true);
  }
  
  ap.loop();
  fft = new FFT(ap.bufferSize(), ap.sampleRate());
  fft.linAverages(bands);
}

void draw()
{ 
  background(0, 0, 0); //black
  stroke(0, 0, 50); //grey
  fill (0, 0, 100); // white
  text("Press [space] to pause", width / 2, 700);
  
  for (int i = 0; i < arrayLength; i++)
  {
    bones[i].display();
    if (!paused)
    {
      bones[i].movement();
    }
  }
  
  float totalSound = 0;
  float avgSound = 0;
  float visSound = 0;
  float half = height / 2;
  float soundLerp;
  
  for (int i = 0; i < ab.size(); i++)
  {
    //println("i: " + i);
    //println("ab.size: " + ab.size());
    totalSound += abs(ab.get(i));
    float m = map(i, 0, ab.size(), 0, 360); // For rainbow gradient
    //println(m);
    stroke(2.56 * m, 100, 100); //This makes the line gradient through all 360 degrees of color in HSB
    line(i, half, i, half + ab.get(i) * half / 2); // add lerp to make less jarring?
  }
  
  avgSound = totalSound / ab.size();
  visSound = lerp(visSound, avgSound, 0.1);
  soundLerp = visSound * 10000;
  fill(200, 100, 100);
  noFill();
  stroke(255, 0, 100);
  circle(half, half, 100 + soundLerp / 2); // add lerp to make less jarring?
  
  for (int i = 0; i < hearts.length; i++)
  {
  hearts[i].update();
  hearts[i].radius = hearts[i].baseRadius + soundLerp;
  hearts[i].size = hearts[i].baseSize + soundLerp;
  hearts[i].velocity = hearts[i].baseVelocity + soundLerp;
  hearts[i].display();
  }
}

void keyPressed()
{
  if (key == ' ')
  {
    if (ap.isPlaying())
    {
      paused = true;
      ap.pause();
    }
    else
    {
      paused = false;
      ap.play();
    }
  }
}

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
      radians += (velocity / 10000);
      x = startX + (cos(radians) * radius);
      y = startY + (sin(radians) * radius);
    }
    
    void display()
    {
      fill(colour);
      noStroke();
      // circle(x, y, size);
      
      beginShape();
      vertex(x, y);
      bezierVertex(x, y - (size/4), x + (size/2), y - (size/8), x, y + (size/4));
      vertex(x, y);
      bezierVertex(x, y - (size/4), x - (size/2), y - (size/8), x, y + (size/4));
      endShape();
      
    }
  }
