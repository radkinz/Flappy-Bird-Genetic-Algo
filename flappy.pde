class Bird {
  float x, y, Vy, r, jump, d;
  boolean IsDead;
  float fitness;
  int closestpipe;
  String name;
  IntList genotype;

  Bird() {
    //took the names from the weighted probability baby names activity from in class
    JSONObject bird = values.getJSONObject(floor(random(1, values.size()))); 
    name = bird.getString("name");

    //flexible list so can add more genotypes with more pipes
    genotype = new IntList();

    //color
    for (int i = 0; i < 3; i++) {
      genotype.append(round(random(0, 255)));
    }

    //2 jumps per each pipe 
    for (int i = 0; i < 50; i++) {
      genotype.append(round(random(width/2, width))); //xpos for each pipe that triggers jump
    }

    x = width/2;
    y = height/2;
    Vy = 0;
    r = 5;
    jump = -2.5;
    closestpipe = 0;
    IsDead = false;
    fitness = 0;
  }

  void update() {
    //apply velocity
    Vy += 0.2;
    y += Vy;

    //name of birds
    fill(255);
    textAlign(CENTER);
    textSize(14);
    text(name, x, y-5);
    
    //add new genotypes with more pipes
    if (pipenum*2 > genotype.size()-5) {
      genotype.append(round(random(width/2, width)));
      genotype.append(round(random(width/2, width)));
    }
  }

  void show() {
    noStroke();
    fill(genotype.get(0), genotype.get(1), genotype.get(2));
    circle(x, y, r*2);
  }

  void jump() {
    Vy += jump;
  }

  void TouchingBottomPipe(Pipe other) {
    if (this.x > other.x & this.x < other.x + 50 & this.y > height-other.BottomPipeLength & this.y < height) {
      this.IsDead = true;
    }
  }

  void TouchingTopPipe(Pipe other) {
    if (this.x > other.x & this.x < other.x + 50 & this.y < other.TopPipeLength & this.y > 0) {
      this.IsDead = true;
    }
  }

  void TouchingGround() {
    if (this.y > height) {
      this.IsDead = true;
    }
  }

  void TouchingCeiling() {
    if (this.y < 0) {
      this.IsDead = true;
    }
  }

  void CheckJump() {
    int arraypos = 3; //begins at arraypos 3 because 0-2 genotypes are for color
    for (int j = 0; j < p.size(); ++j) {
      if (dist(p.get(j).x, height, this.genotype.get(arraypos), height) < 7 || dist(p.get(j).x, height, this.genotype.get(arraypos+1), height) < 7) {
        this.jump();
      }
      //increases by two because there are two genotypes for every pipe since there are two x-pos a pipe can get close to that will cause the bird to jump
      arraypos += 2;
    }
  }

  void CalculatePipeJustPassed() {
    float mindist = 10000;
    for (int i = 0; i < p.size(); ++i) {
      float d = dist(this.x, this.y, p.get(i).x, this.y);
      if (d < mindist & p.get(i).x < width/2 - 50) {
        mindist = d;
        closestpipe = i;
      }
    }
  }

  void CalculateFitness() { 
    //fitness algorithm is split up into 3 factors:

    //1.) distance or time the bird was alive
    //finding the distance between bird and first pipe by multipying the number of the pipe the bid died at by the gap
    fitness = pipenum*300;

    //2.) having a multiplier for every pipe the bird passes
    //calculate pipe just passed to get a value for closest pipe
    this.CalculatePipeJustPassed();

    //increase in fitness for passing a pipe
    if (closestpipe < 0) {
      fitness = fitness*closestpipe;
    }

    //3.) take into account the y-pos of where the bird dies at 
    //calculate pipe it failed at by taking the pipe that it passed plus 1
    closestpipe += 1;
    if (closestpipe < p.size()) {
      //distance between the bird and the average y-pos of the gap
      float d = dist(this.x, this.y, p.get(closestpipe).x + 25, 275+(p.get(closestpipe).TopPipeLength));
      //subtract the distance from fit so the bigger the distance=smaller the fitness
      fitness = fitness-d;
    } 

    //to create a bigger disparity between the birds
    fitness = pow(fitness, 5);
  }

  Bird Breed(Bird mate) {
    Bird kid = new Bird();

    //weighted probs so more genes of the successful bird will transfer
    float fitnessSum = this.fitness + mate.fitness;
    
    //give kid new list so the original set-up values that are only intended for the first set of birds won't cause problems
    kid.genotype = new IntList();
    // crossing over process
    for (int i = 0; i < genotype.size(); i++) {
      // choose between THIS and MATE for KID
      if (random(1) < this.fitness/fitnessSum) {  // choose THIS
        kid.genotype.append(this.genotype.get(i));
      } else {  // choose MATE
        kid.genotype.append(mate.genotype.get(i));
      }
    }
    return kid;
  }

  void mutate(float mutationRate) {
    for (int i = 0; i < genotype.size(); i++) {
      if (random(1) < mutationRate) {
        if (i == 0) {
          genotype.set(i,round(random(0, height)));
        }
        if (i > 0 & i < 4) {
          genotype.set(i, round(random(0, 255)));
        }
        if (i >= 4) {
          genotype.set(i, round(random(width/2, width)));
        }
      }
    }
  }
}
