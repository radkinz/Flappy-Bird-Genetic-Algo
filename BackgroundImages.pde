class Background {
  //PImage img;
  PImage[] img = new PImage[3];
  float x, Vx;
  int imgcounter;
  
  Background() {
    x = width + 1500;
    Vx = 25;
    imgcounter = 0;
    img[0] = loadImage("victor.jpg");
    img[1] = loadImage("yurio.jpg");
    img[2] = loadImage("yuri.jpg");
  }
  
  void update() {
    x -= Vx;
    
    if (allDead == true) {
      x = width + 1500;
      imgcounter += 1;
    }
    
    if (x < -300) {
      x = width + 1500;
      imgcounter += 1;
    }
    
    if (imgcounter > 2) {
      imgcounter = 0;
    }
  }
  
  void display() {
    imageMode(CENTER);
    image(img[imgcounter], x, height-300);
  }
}
