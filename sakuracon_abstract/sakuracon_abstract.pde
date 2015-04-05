import fullscreen.*;
import japplemenubar.*;
import ddf.minim.analysis.*;
import ddf.minim.*;
Minim minim;
FFT fft;
AudioInput in;
float xn, xs, yn, zn, ns;

PImage seaWave; 
PImage capturedSeaWave;
PImage eyes;

boolean flag_1;

float angleX, angleY;

public void init(){
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

void setup() {
  size(1920, 1080, P3D);
  frame.setLocation(1440,0);  
  noStroke();
  rectMode(CENTER);
  imageMode(CENTER);
  colorMode(HSB, 256);
  frameRate(60);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048, 192000.0);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  
  seaWave = loadImage("RIMG3139-001.JPG");
  eyes = loadImage("RIMG3129-001.JPG");
  eyes.loadPixels();
  float r,g,b;
  for(int i=0; i<eyes.width*eyes.height; i++){
    r = 255-red(eyes.pixels[i]);
    g = 255-green(eyes.pixels[i]);
    b = 255-blue(eyes.pixels[i]);
    if(r<50||g<50||b<50){
      eyes.pixels[i] = color(255,0);
    }else{ 
      eyes.pixels[i] = color(r, g, b);
    }
  }
  eyes.updatePixels();
  flag_1 = false;
  capturedSeaWave = createImage(width, height, RGB);
  angleX = .0;
  angleY = .0;
  noCursor();
}


void draw() 
{  
   fft.forward(in.mix);
   if(flag_1){
     blendMode(BLEND);
     background(0);
     translate(width/2,height/2,-height/4);
     angleX += .001;
     angleY += .003;
     rotateY(angleX);
     rotateX(angleY);
     capturedSeaWave.loadPixels();
     for(int j=0; j<height-10; j+=10){
       for(int i=0; i<width-10; i+=10){
         colorMode(RGB,256);
         stroke(red(capturedSeaWave.pixels[i+j*width]), green(capturedSeaWave.pixels[i+j*width]), blue(capturedSeaWave.pixels[i+j*width]), 150);
         line(i-width/2, j-height/2, blue(capturedSeaWave.pixels[i+j*width])+20*getAudioTrigger(2,10), i+10-width/2, j-height/2, blue(capturedSeaWave.pixels[(i+10)+j*width])); 
         line(i-width/2, j-height/2, blue(capturedSeaWave.pixels[i+j*width])+20*getAudioTrigger(2,10), i-width/2, j+10-height/2, blue(capturedSeaWave.pixels[i+(10+j)*width])); 
         colorMode(HSB,256);
       }
     }
   }else{
   
    // println("heyya");

    counter++;
    if(counter<width) scale += 0.1/float(width);
    if(counter>width && counter<width+height) sparse += 0.5/float(height);
  
    image(seaWave, width/2 + 30*sin(radians(frameCount)), height/2 + 30*cos(radians(frameCount)), width+60, height+60);
    //sparseRandomDrawing(mouseX);
    //drawFractal(width/2, height/2, initSize);
    stroke(180, 100, 255, getAudioTrigger(2,30)*10);
    /*
    for(int i = 0; i < in.bufferSize() - 1; i++)
    { 
      line(i, height/2 + in.left.get(i)*1000, i+1, height/2 + in.left.get(i+1)*1000);
    }
    */
  
    blendMode(MULTIPLY);
    noiseBackgroundDrawer(310);  
   }
}


void drawFractal(float x, float y, float size) 
{
  float ch0 = getAudioTrigger(3,10);
  // float ch1 = getAudioTrigger(30,50);
  
  float sparse = map(mouseY, 0, height, 0.3, 0.8);
  // float sparse = ch0/200;
  float scale = map(mouseX, 0, width, 0.5, 0.6);
  
  float colorHue = map(size, 40, initSize, 150, 240);
  fill(255, 10);
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


void sparseRandomDrawing(int val)
{
  image(eyes, random(0,width), random(0,height), val, val);
}


void stop()
{
  minim.stop();
  super.stop();
}


void keyPressed(){
  if (key=='1'){
    if(flag_1){ 
      flag_1 = false;
    }else{
      flag_1 = true;
      loadPixels();
      for(int i=0; i<width*height; i++)  capturedSeaWave.pixels[i] = pixels[i];
      capturedSeaWave.updatePixels();
      angleX =.0;
      angleY =.0;
      
    }
  }
}
