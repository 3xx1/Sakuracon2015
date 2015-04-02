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
float shadowSize = 200.0; 
float shadowRatio = 1402.0/976.0;

PImage doller;
PImage body, left, right;
PImage fogBackground;

void setup() {
  size(1024, 768, P3D);  
  noStroke();
  rectMode(CENTER);
  imageMode(CENTER);
  initSize = 600;
  colorMode(HSB, 256);
  frameRate(240);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048, 192000.0);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  sparse = .3;
  scale = .5;
  counter = -1;
  
  doller = loadImage("doller_binary.png");
  body  = loadImage("doller_binary_body.png");
  left  = loadImage("doller_binary_left.png");
  right = loadImage("doller_binary_right.png");
  fogBackground = loadImage("fogBackground1.JPG");
}

void draw() {
  //background(255);
  image(fogBackground, width/2, height/2, width, height);
  fft.forward(in.mix);
  // noiseBackgroundDrawer(1000);
  // drawFractal(width/2, height/2, initSize);
  // drawCircle(width/2, height/2, 400);
  counter++;
  if(counter<width) scale += 0.1/float(width);
  if(counter>width && counter<width+height) sparse += 0.5/float(height);
  // image(doller, mouseX, mouseY);
  drawDoll(shadowSize, mouseX, mouseY, 0.3 * sin(radians(mouseX)), 0.5 * sin(radians(mouseY)),  -0.5 * sin(radians(mouseY)));
  noiseBackgroundDrawer(400);
  // drawDoll(mouseX-300, mouseY, radians(mouseX), radians(mouseY), radians(mouseY));
  // image(right, mouseX, mouseY, shadowSize, shadowSize*shadowRatio);
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
  for (int i = 0; i <= width/5; i++)
  {
    xn = xs;
    yn+=.002;
    zn+=.002/20;
    for (int j = 0; j <= width/5; j++)
    {
      xn+=.01;
      noStroke();
      fill(noise(xn, yn, zn)*2, 0, noise(xn, yn, zn)*level, 100);
      rect(i*5, j*5, 5, 5);
    }
  }
  /*
  for (int i = 0; i <= height; i++) {
    stroke(0, 255-i*255/height);
    line(0, i, width, i);
    noStroke();
  }
  */
}


void drawDoll(float shadowSize, int x, int y, float rotBody, float rotLeft, float rotRight) 
{
  pushMatrix();
  //translate(-shadowSize/2, -shadowSize*shadowRatio/2);
  translate(x, y);
  rotateZ(rotBody);
  translate(-x, -y);
  image(body, x, y, shadowSize, shadowSize*shadowRatio);
  popMatrix();
  
  pushMatrix(); 
  translate(x, y);
  rotateZ(rotBody);
  translate(shadowSize*0.3, shadowSize*shadowRatio*0.065); 
  rotateZ(rotLeft);
  translate(-shadowSize*0.3, -shadowSize*shadowRatio*0.065);
  translate(-x, -y);
  image(left, x, y, shadowSize, shadowSize*shadowRatio);
  popMatrix();
  
  pushMatrix();
  translate(x, y);
  rotateZ(rotBody);
  translate(-shadowSize*0.47, -shadowSize*shadowRatio*0.032); 
  rotateZ(rotRight);
  translate(shadowSize*0.47, shadowSize*shadowRatio*0.032);
  translate(-x, -y);
  image(right, x, y, shadowSize, shadowSize*shadowRatio);
  popMatrix();
}


void stop()
{
  minim.stop();
  super.stop();
}


void mousePressed(){
  
}
