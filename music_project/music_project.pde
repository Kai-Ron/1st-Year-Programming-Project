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

int maxSaturation = 100;
int minSaturation = 50;
int saturationMovement = 1;
int saturation = maxSaturation;

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
  k = 65;
  for(int i = 0; i < leftBones.length; i++)
  {
    leftBones[i] = new Box((k)*i,height-h,h);
  }
}

void draw()
{ 
  background(0, 0, 0); // black
  stroke(0, 0, 50); // grey
  fill(0, 0, saturation);
  if (saturation <= minSaturation)
  {
    saturationMovement = 1;
  }
  if (saturation >= maxSaturation)
  {
    saturationMovement = -1;
  }
  saturation += saturationMovement;
  
  text("Press [space] to pause", width / 2, 700);
  fill (0, 0, 100); // white
  
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
  jump();
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

int k;
int x = 10;
int h = 50;
boolean jump = true;
float c = 0;
int j = 5;
float hh;
Box[] leftBones = new Box[6];

void jump()
{
  fill(255);
  for(int i = 0; i < leftBones.length; i++)
  {
    leftBones[i].display();
    //text(i,leftBones[i].x,60);
  }
  circle(width/2,height-c,10);
  hh = leftBones[j].size+ 20;
  if(jump && c < hh)
  {
    c += 1.5;
  }else if(jump)
  {
    if(leftBones[j].x == (width/2)-1)
    {
      jump = false;
      j++;
      //println(j);
    }
  }
  else
  {
    c -= 2;
    if(c <= 0)
    {
      jump = true;
    }
  }
  if(j == leftBones.length)
  {
    j = 0;
  }
}
