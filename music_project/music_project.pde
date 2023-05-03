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
FFT fft;

int arrayLength = 8; // Number of bones assigned here
Bone[] bones = new Bone[arrayLength];
boolean paused = false;

void setup()
{
  colorMode(HSB, 360, 100, 100);
  
  background(0, 0, 0);
  size(800, 800);
  
  minim = new Minim(this);
  ap = minim.loadFile("audio/Megalovania.mp3", 1024);
  ap.play();
  ab = ap.mix;
  font = createFont("font/8bitoperator_jve.ttf", 20);
  textFont(font);
  textAlign(CENTER);
  
  //bones assigned using x, y, size, xdir, ydir, vert
  for (int i = 0; i < arrayLength; i++)
  {
    bones[i] = new Bone(width / arrayLength * i, 0, 50f, 2, 0f, true);
  }
  
  fft = new FFT(ap.bufferSize(), ap.sampleRate());
  println(ap.bufferSize());
  println(ap.sampleRate());
}

void draw()
{ 
  background(0, 0, 0); //black
  stroke(0, 0, 50); //grey
  
  fft.forward(ap.mix);
  
  /*for (int i = 0; i < fft.specSize(); i++)
  {
    line(i, height, i, height - fft.getBand(i) * 8);
    println(fft.getBand(i));
  }*/
  
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
    totalSound += abs(ab.get(i));
    //float m = map(i, 0, ab.size(), 0, 360); // For rainbow gradient
    //println(m);
    //stroke(m, 100, 100); This makes the line gradient through all 360 degrees of color in HSB
    line(i, half, i, half + ab.get(i) * half / 2); // add lerp to make less jarring?
  }
  
  avgSound = totalSound / ab.size();
  visSound = lerp(visSound, avgSound, 0.1);
  soundLerp = visSound * 10000;
  circle(half, half, 100 + soundLerp / 2); // add lerp to make less jarring?
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
