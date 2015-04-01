PImage doll;
PImage processed;

void setup() {
  size(976, 1402);
  colorMode(ARGB, 256);
  doll = loadImage("doller.png");
  processed = createImage(doll.width, doll.height, ARGB);
}

void draw() {
  background(255);
  doll.loadPixels();
  for (int y=0; y<doll.height; y++){
    for (int x=0; x<doll.width; x++){
      if(dist(0,0,0,int(256*red(doll.pixels[y*doll.width+x])),int(256*green(doll.pixels[y*doll.width+x])),int(256*blue(doll.pixels[y*doll.width+x])) )>45000)
      {
        processed.pixels[y*doll.width+x] = 0;
      }else{
        processed.pixels[y*doll.width+x] = doll.pixels[y*doll.width+x];
      }
    }
  }
  // println(alpha(processed.pixels[100]));
  processed.updatePixels();
  // println(mouseX*100);
  image(processed, 0, 0);
  noLoop();
}


void mousePressed(){
  processed.save("doller_binary.png");
}
