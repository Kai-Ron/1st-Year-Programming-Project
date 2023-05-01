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

void setup()
{
  colorMode(HSB, 360, 100, 100);
  
  background(0, 0, 0);
  size(800, 800);
  
  minim = new Minim(this);
  ap = minim.loadFile("audio/Megalovania.mp3", 800);
  ap.play();
  ab = ap.mix;
}

void draw()
{
  
  background(0, 0, 0); //black
  stroke(0, 0, 50); //grey
  
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
    float m = map(i, 0, ab.size(), 0, 360); // For color
    //println(m);
    //stroke(m, 100, 100); This makes the line gradient through all 360 degrees of color in HSB
    line(i, half, i, half + ab.get(i) * half / 2); // add lerp to make less jarring?
  }
  
  println("totalSound: " + totalSound);
  avgSound = totalSound / ab.size();
  println("avgSound: " + avgSound);
  visSound = lerp(visSound, avgSound, 0.1);
  println("visSound: " + visSound);
  soundLerp = visSound * 10000;
  circle(half, half, 100 + soundLerp / 2); // add lerp to make less jarring?
  println("soundlerp" + soundLerp);
  
  createBone(100, 100, 50, false);
  createBone(600, 500, 50, true);
}

void keyPressed()
{
  if (key == ' ')
  {
    if (ap.isPlaying())
    {
      ap.pause();
    }
    else
    {
      ap.play();
    }
  }
}

void createBone(float startingPosX, float startingPosY, float size, boolean vertical)
{
  noStroke();
  if (!vertical)
  {
    rect(startingPosX, startingPosY, size * 2, size / 4);
    circle(startingPosX, startingPosY + size / 4, size / 3);
    circle(startingPosX, startingPosY, size / 3);
    circle(startingPosX + size * 2, startingPosY + size / 4, size /3);
    circle(startingPosX + size * 2, startingPosY, size / 3);
  }
  else
  {
    rect(startingPosX, startingPosY, size / 4, size * 2);
    circle(startingPosX, startingPosY, size / 3);
    circle(startingPosX + size / 4, startingPosY, size / 3);
    circle(startingPosX, startingPosY + size * 2, size / 3);
    circle(startingPosX + size / 4, startingPosY + size * 2, size / 3);
  }
}
