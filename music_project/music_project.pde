import processing.sound.*;
SoundFile megalovania;

void setup()
{
  megalovania = new SoundFile(this, "audio/Megalovania.mp3");
  megalovania.loop();
  colorMode(RGB);
  background(0, 0, 0);
  size(1000, 800);
}

void draw()
{
  
}
