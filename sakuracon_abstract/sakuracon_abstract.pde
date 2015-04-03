import ddf.minim.analysis.*;
import ddf.minim.*;
Minim minim;
FFT fft;
AudioInput in;
float xn, xs, yn, zn, ns;

float initSize;
float sparse;
float scale;
int counter;

PImage seaWave; 

void setup() {
  size(1024, 768, P3D);  
  noStroke();
  rectMode(CENTER);
  imageMode(CENTER);
  initSize = 600;
  colorMode(HSB, 256);
  frameRate(30);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048, 192000.0);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  sparse = .3;
  scale = .5;
  counter = -1;
  seaWave = loadImage("RIMG3139-001.JPG");
}


void draw() 
{   
  fft.forward(in.mix);
  counter++;
  if(counter<width) scale += 0.1/float(width);
  if(counter>width && counter<width+height) sparse += 0.5/float(height);
  
  image(seaWave, width/2 + 30*sin(radians(frameCount)), height/2 + 30*cos(radians(frameCount)), width+60, height+60);
  blendMode(MULTIPLY);
  noiseBackgroundDrawer(300);
  // drawFractal(width/2, height/2, initSize);
}


void drawFractal(float x, float y, float size) 
{
  float ch0 = getAudioTrigger(3,10);
  // float ch1 = getAudioTrigger(30,50);
  
  float sparse = map(mouseY, 0, height, 0.3, 0.8);
  // float sparse = ch0/200;
  float scale = map(mouseX, 0, width, 0.5, 0.6);
  
  float colorHue = map(size, 40, initSize, 150, 240);
  fill(colorHue, 255, 255, size/3);
  if(size < initSize) ellipse(x, y, size*1.2, size*1.2);
  if (size > 30) {
    drawFractal(x + size*sparse, y, size*scale);
    drawFractal(x - size*sparse, y, size*scale);
    drawFractal(x, y + size*sparse, size*scale);
    drawFractal(x, y - size*sparse, size*scale);
  }
}

float getAudioTrigger(int bandLeft, int bandRight) {
  if (bandRight<bandLeft) return 0;
  float amplitude=.0;
  for (int i=bandLeft; i<bandRight; i++)
  {
    amplitude += fft.getBand(i);
  }
  amplitude /= bandRight-bandLeft;
  return amplitude;
}


void noiseBackgroundDrawer(int level)
{
  noiseSeed((long)ns);
  xn=noise(ns);
  yn=noise(ns);
  xs=xn;
  for (int i = 0; i <= width/3; i++)
  {
    xn = xs;
    yn+=getAudioTrigger(40,50)/1000;
    zn+=getAudioTrigger(2,30)/5000;
    for (int j = 0; j <= width/3; j++)
    {
      xn+=getAudioTrigger(2,30)/2000;
      noStroke();
      fill(170+noise(xn, yn, zn)*10, 80, noise(xn, yn, zn)*level, 100);
      rect(i*3, j*3, 3, 3);
    } 
  }
  
  
}




void stop()
{
  minim.stop();
  super.stop();
}


void mousePressed(){
  println("x:", mouseX, ", y:", mouseY);
}
