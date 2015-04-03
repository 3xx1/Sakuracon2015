import ddf.minim.analysis.*;
import ddf.minim.*;
Minim minim;
AudioPlayer jingle;
FFT fft;
AudioInput in;
float[] angle;
float[] y, x;
 
void setup()
{
  // size(screen.width, screen.height, P3D);
  size(1680, 1050, P3D);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048, 192000.0);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  y = new float[fft.specSize()];
  x = new float[fft.specSize()];
  angle = new float[fft.specSize()];
  frameRate(240);
  smooth();
  background(0);
}
 
void draw()
{
  // background(0);
  // fill(0,10);
  // rect(0,0,width,height);
  fft.forward(in.mix);
  doubleAtomicSprocket();
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
    stroke(180, 20, 50);
    pushMatrix();
    translate((x[i]+50)%width/3, (y[i]+50)%height/3);
    line(0, 0, fft.getBand(i)/20+fft.getFreq(i)/15,fft.getBand(i)/10);
    popMatrix();
  }
  //noStroke();
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
    stroke(255,30);
    pushMatrix();
    translate((x[i]+250)%width, (y[i]+250)%height);
    line(0, 0, fft.getBand(i+1)/5, fft.getBand(i+1)+fft.getFreq(i)*3);
    popMatrix();
  }
  popMatrix();
  
 // filter(BLUR,1);
}



 
void stop()
{
  // always close Minim audio classes when you finish with them
  jingle.close();
  minim.stop();
 
  super.stop();
}
