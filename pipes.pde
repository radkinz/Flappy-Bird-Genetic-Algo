class Pipe {
  float TopPipeLength, BottomPipeLength, x, pipenum, Vx;

  Pipe(float num) {
    TopPipeLength = 250*noise(num*300);
    BottomPipeLength = height-(TopPipeLength + 450);
    x = width;
    pipenum = num;
    Vx = 35;
  }

  void update() {
    x -= Vx;
  }    

  void show() {
    noStroke();
    fill(255);
    quad(x, height, x + 50, height, x + 50, height-BottomPipeLength, x, height-BottomPipeLength);
    quad(x, 0, x + 50, 0, x + 50, TopPipeLength, x, TopPipeLength);
  }
}
