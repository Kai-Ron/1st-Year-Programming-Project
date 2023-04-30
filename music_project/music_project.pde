import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

color black = color(0, 0, 0);
color red = color(255, 0, 0);
color green = color(0, 255, 0);

Minim minim;
AudioPlayer ap;
AudioInput ai;
AudioBuffer ab;

void setup()
{
  colorMode(RGB);
  background(black);
  size(800, 800);
  
  minim = new Minim(this);
  ap = minim.loadFile("audio/Megalovania.mp3", 800);
  ap.play();
  ab = ap.mix;
}

void draw()
{
  background(black);
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
