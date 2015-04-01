import ddf.minim.analysis.*;
import ddf.minim.*;
Minim minim;
FFT fft;
AudioInput in;
PImage doller; 
 
void setup()
{
  size(1280,768,P3D);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048, 192000.0);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  y = new float[fft.specSize()];
  x = new float[fft.specSize()];
  angle = new float[fft.specSize()];
  doller = loadImage("doller_binary.png");
  frameRate(240);
  smooth();
  background(0);
}
 
void draw()
{
  fill(0,10);
  rect(0,0,width,height);
  fft.forward(in.mix);
  drawRectangles();
  image(doller, mouseX, mouseY);
}
 
void drawRectangles()
{
  
}
 
void stop()
{
  minim.stop(); 
  super.stop();
}
