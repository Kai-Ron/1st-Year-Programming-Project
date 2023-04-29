import processing.sound.*;
SoundFile megalovania;
BeatDetector bd;
Amplitude amp;
AudioIn in;
color black = color(0, 0, 0);

void setup()
{
  megalovania = new SoundFile(this, "audio/Megalovania.mp3");
  megalovania.loop();
  colorMode(RGB);
  background(0, 0, 0);
  size(1000, 800);
  bd = new BeatDetector(this);
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.play();
  amp.input(in);
}

void draw()
{
  background(black);
  println(bd.isBeat());
  println(megalovania.duration());
  println(amp.analyze());
  
  float sans = amp.analyze() * (float)Math.pow(10, 6);
  
  /*float totalSound = 0;
  totalSound += abs(amp.analyze());
  println(totalSound);*/
  fill(255, 0, 0);
  circle(width / 2, height / 2, sans);
  println(sans);
}
