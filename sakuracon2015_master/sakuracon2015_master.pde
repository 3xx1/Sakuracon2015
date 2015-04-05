import fullscreen.*;
import japplemenubar.*;
import ddf.minim.analysis.*;
import ddf.minim.*;
Minim minim;
FFT fft;
AudioInput in;
float xn, xs, yn, zn, ns;
boolean flag_z, flag_x, flag_c, flag_v;

PImage seaWave; 
PImage capturedSeaWave;
PImage eyes;
boolean flag_1;
float angleX, angleY;

float shadowSize = 200.0; 
float shadowRatio = 1402.0/976.0;
float face0_size=100.0;
PImage doller;
PImage body, left, right;
PImage fogBackground;
PImage face0, face0_p; 
float[] py = {.0, .0, .0};
float[] vy = {.0, .0, .0};
boolean[] fy = {true, true, true};
float gravity = 1.7;
boolean flag_2; 

float[] angle;
float[] y, x;
boolean flag_3, flag_4;


public void init(){
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

void setup() {
  size(1280, 720, P3D); 
  frame.setLocation(1440,0); 
  noStroke();
  rectMode(CENTER);
  imageMode(CENTER);
  colorMode(HSB, 256);
  frameRate(60);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048, 192000.0);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  flag_z = false;
  flag_x = false;
  flag_c = false;
  flag_v = false;
  
  seaWave = loadImage("RIMG3139-001.JPG");
  flag_1 = false;
  capturedSeaWave = createImage(width, height, RGB);
  angleX = .0;
  angleY = .0;
  
  doller = loadImage("doller_binary.png");
  body  = loadImage("doller_binary_body.png");
  left  = loadImage("doller_binary_left.png");
  right = loadImage("doller_binary_right.png");
  fogBackground = loadImage("fogBackground1.JPG");
  face0 = loadImage("RIMG2829.JPG");
  face0_p = createImage(face0.width, face0.height, ARGB);
  face0.loadPixels();
  for(int i=0; i<face0.width*face0.height; i++){
    if(red(face0.pixels[i])>100 || green(face0.pixels[i])>100 ||blue(face0.pixels[i])>100 ){
      face0_p.pixels[i] = color(0, 0, 0, 0); 
    }else{
      face0_p.pixels[i] = color(int(255-blue(face0.pixels[i])), 0, int(255-blue(face0.pixels[i])), 50);
    }
  }
  face0_p.updatePixels();
  flag_2 = false;
  
  
  y = new float[fft.specSize()];
  x = new float[fft.specSize()];
  angle = new float[fft.specSize()];
  smooth();
  flag_3 = false;
  flag_4 = false;
  
  noCursor();
  background(0);

}

void draw() 
{
  fft.forward(in.mix);
   
   if(flag_z){ 
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
          image(seaWave, width/2 + 30*sin(radians(frameCount)), height/2 + 30*cos(radians(frameCount)), width+60, height+60);
          blendMode(MULTIPLY);
          noiseBackgroundDrawer4Amb(310);  
         }
   }
   
   if(flag_x){
      if(flag_2)
      {
        background(0);
        blendMode(BLEND);
        tint(255,mouseX);
        image(fogBackground, width/2, height/2, width, height); 
        noiseBackgroundDrawer(250);
    
        int xPos = width/2 + int(100*sin(radians(frameCount)));
        for(int i=0; i<3; i++)
        {
            py[i] += vy[i];
            vy[i] += gravity;
            if(py[i]>0){ 
              py[i] = 0.0;
              vy[i] = 0.0;
              fy[i] = true;
            }else{
              fy[i] = false;
            }
          }
          if(fy[0]==true && fy[2]==true && getAudioTrigger(2,30)>1){
            vy[0] = -5*getAudioTrigger(2,30);
            vy[2] = -5*getAudioTrigger(2,30);
            if(vy[0]<-30.0) vy[0]=-30.0;
            if(vy[2]<-30.0) vy[2]=-30.0;
          }
          if(fy[1]==true && getAudioTrigger(50,60)>1){
            vy[1] = -5*getAudioTrigger(50,60);
            if(vy[1]<-35.0) vy[1]=-35.0;
          }
          tint(255,mouseX);
          drawDoll(shadowSize, xPos-300, 3*height/4 + py[0], radians(8*sin(radians(frameCount*10))), radians(10+10*sin(getAudioTrigger(50,60))), -radians(10+10*sin(getAudioTrigger(50,60))));
          drawDoll(shadowSize, xPos, 3*height/4 + py[1], radians(10*cos(radians(frameCount*10))), radians(10+10*sin(getAudioTrigger(2,10))), -radians(10+10*sin(getAudioTrigger(2,10))));
          drawDoll(shadowSize, xPos+300, 3*height/4 + py[2], radians(8*sin(radians(frameCount*10))), radians(10+10*sin(getAudioTrigger(50,60))), -radians(10+10*sin(getAudioTrigger(50,60))));  
          noiseBackgroundDrawer(250);
          
        }else{
          
          background(0);
          noiseBackgroundDrawer(250);
          tint(255,mouseX);
          image(face0_p, width/2+30*cos(radians(frameCount/20)), height/2, width+60, height+60);
          blendMode(EXCLUSION);
          noiseBackgroundDrawer(250);
          blendMode(BLEND);
        }
   }
   
   if(flag_c){
      if(!flag_3) doubleAtomicSprocket();
      if(flag_3) randomBlurring(80);
   }
   
   if(flag_v){
     noStroke();
     fill(0,30);
     rect(width/2, height/2, width, height);
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


void noiseBackgroundDrawer4Amb(int level)
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

void noiseBackgroundDrawer(int level)
{
  if(level<0) level = 0;
  noiseSeed((long)ns);
  xn=noise(ns);
  yn=noise(ns);
  xs=xn;
  for (int i = 0; i <= width/5; i++)
  {
    xn = xs;
    yn+=getAudioTrigger(2,30)/5000;
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


void drawDoll(float shadowSize, float x, float y, float rotBody, float rotLeft, float rotRight) 
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
    fill(255,15);
    pushMatrix();
    translate((x[i]+250)%width, (y[i]+250)%height);
    rect(0, 0, fft.getBand(i)/15, fft.getBand(i)*2+fft.getFreq(i)*3);
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
  if(flag_4) noiseBackgroundDrawer(250);
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
  if (key=='2'){
    if(flag_2){ 
      flag_2 = false;
    }else{
      flag_2 = true;
    }
  }
  if (key=='3'){
    if(flag_3){ 
      flag_3 = false;
    }else{
      flag_3 = true;
    }
  }
  if (key=='4'){
    if(flag_4){ 
      flag_4 = false;
    }else{
      flag_4 = true;
    }
  }
  
  if (key=='z'){
    if(flag_z){ 
      flag_z = false;
    }else{
      flag_z = true;
      flag_x = false;
      flag_c = false;
      flag_v = false;
      rectMode(CENTER);
      colorMode(HSB,256);
      frameRate(60);
    }
  }
  if (key=='x'){
    if(flag_x){ 
      flag_x = false;
    }else{
      flag_x = true;
      flag_z = false;
      flag_c = false;
      flag_v = false;
      blendMode(BLEND);
      rectMode(CENTER);
      colorMode(HSB,256);
      frameRate(60);
    }
  }
  if (key=='c'){
    if(flag_c){ 
      flag_c = false;
    }else{
      flag_c = true;
      flag_z = false;
      flag_x = false;
      flag_v = false;
      rectMode(CORNER);
      frameRate(240);
      colorMode(RGB,256);
    }
  }
  if (key=='v'){
    if(flag_v){ 
      flag_v = false;
    }else{
      flag_v = true;
      flag_z = false;
      flag_x = false;
      flag_c = false;
      rectMode(CENTER);
      colorMode(HSB,256);
      frameRate(60);
    }
  }
}

void mousePressed(){
  
  
}
