import fullscreen.*;
import japplemenubar.*;
import ddf.minim.analysis.*;
import ddf.minim.*;

FullScreen fs;
Minim minim;
AudioPlayer jingle;
FFT fft;
AudioInput in;
float[] angle;
float[] y, x;
float xn, xs, yn, zn, ns;


boolean flag_0, flag;

public void init(){
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

void setup()
{
  // size(screen.width, screen.height, P3D);
  size(1920, 1080, P3D);
  frame.setLocation(1440,0);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048, 192000.0);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  y = new float[fft.specSize()];
  x = new float[fft.specSize()];
  angle = new float[fft.specSize()];
  frameRate(240);
  smooth();
  background(0);
  flag = true;
  flag_0 = false;
  //fs = new FullScreen(this);
  //fs.enter();
}
 
void draw()
{
  // background(0);
  // fill(0,10);
  // rect(0,0,width,height);
  fft.forward(in.mix);
  if(flag) doubleAtomicSprocket();
  if(!flag) randomBlurring(80);
}
 
void doubleAtomicSprocket() {
  noStroke();
  pushMatrix();
  translate(width/2, height/2);
  for (int i = 0; i < 20 ; i++) {
    y[i] = y[i] + fft.getBand(i)/100;
    x[i] = x[i] + fft.getFreq(i)/100;
    angle[i] = angle[i] + fft.getFreq(i)/2000;
    rotateX(sin(angle[i]/2));
    rotateY(cos(angle[i]/2));
    //    stroke(fft.getFreq(i)*2,0,fft.getBand(i)*2);
    fill(180,20,30,30);
    pushMatrix();
    translate((x[i]+50)%width/3, (y[i]+50)%height/3);
    rect(0, 0, fft.getBand(i)/20+fft.getFreq(i)/15,fft.getBand(i)*fft.getBand(i)/30+fft.getFreq(i)/2);
    popMatrix();
  }
  popMatrix();
  pushMatrix();
  translate(width/2, height/2, 0);
  for (int i = 0; i < fft.specSize() ; i++) {
    y[i] = y[i] + fft.getBand(i)/1000;
    x[i] = x[i] + fft.getFreq(i)/1000;
    angle[i] = angle[i] + fft.getFreq(i)/100000;
    rotateX(sin(angle[i]));
    rotateY(cos(angle[i]));
    //    stroke(fft.getFreq(i)*2,0,fft.getBand(i)*2);
    // fill(255, 255-fft.getFreq(i)*2, 255-fft.getBand(i)*2);
    fill(255,30);
    pushMatrix();
    translate((x[i]+250)%width, (y[i]+250)%height);
    rect(0, 0, fft.getBand(i)/5, fft.getBand(i)*2+fft.getFreq(i)*3);
    popMatrix();
  }
  popMatrix();
  
 // filter(BLUR,1);
}


void randomBlurring(int size)
{
  
  loadPixels();
  int x = int(random(0, width));
  int y = int(random(0, height));
  fill(pixels[x+y*width], 100);
  rect(x-size/2,y-size/2,size,size*random(0.5,1.5));
  if(flag_0) noiseBackgroundDrawer(250);
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


void mousePressed(){
  if(flag){ 
    flag = false;
  }else{
    flag = true;
  }
}

void keyPressed(){
  if (key=='0'){
    if(flag_0){ 
      flag_0 = false;
    }else{
      flag_0 = true;
    }
  }
}


void stop()
{
  // always close Minim audio classes when you finish with them
  jingle.close();
  minim.stop();
 
  super.stop();
}
