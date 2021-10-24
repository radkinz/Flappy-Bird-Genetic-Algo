Bird[] flappy = new Bird[100];
ArrayList<Pipe> p = new ArrayList<Pipe>();
Bird[] kid;
String[] names;
JSONArray values;
Background background;
float mutationRate, fitnessSum;
int Generation, BestScore, CurrentScore, CurrentBest, pipenum;
boolean allDead, addpipe;

void setup() {
  size(1000, 800);
  background(0); 
  values = loadJSONArray("data.json");
  names = new String[values.size()];
  
  for (int i = 0; i < flappy.length; i++) {
    flappy[i] = new Bird();
  }  
  addpipe = false;
  p.add(new Pipe(pipenum));
  mutationRate = 0.20;
  Generation = 0;
  BestScore = 0;
  CurrentScore = 0;
  CurrentBest = 0;
  allDead = false;
  background = new Background();
}

void draw() {
  background(0);

  //Generation counter
  textSize(30);
  fill(255);
  textAlign(LEFT);
  String GenerationText = "Generation" + ":" + Generation;
  text(GenerationText, 0, 30);

  //HighScore 
  String BestScoreText = "High" + " " + "Score" + ":" + BestScore;
  text(BestScoreText, 0, 60);

  //Last Gen Highest
  String LastGenScoreText = "Last" + " " + "Generation's" + " " + "Best" + " " + "Score" + ":" + CurrentBest;
  text(LastGenScoreText, 0, 90);
  
  //Current Score
  if (pipenum-2 >= 0) {
    CurrentScore = pipenum-2;
  } else {
    CurrentScore = 0;
  }
  String CurrentScoreText = "Current" + " " + "Score" + ":" + CurrentScore;
  text(CurrentScoreText, 0, 120);
  
  //yuri on ice
  background.update();
  background.display();

  for (int i = 0; i < flappy.length; i++) {
    flappy[i].update();
    flappy[i].show();
    flappy[i].CheckJump();
  }
  
  //check to see if need to add pipes
  for (int i = 0; i < p.size(); i++) {
    if (p.get(i).x < width - 300) {
      addpipe = true;
    } else {
      addpipe = false;
      break;
    }
  }
  
  //add pipes if need too
  if (addpipe == true) {
    p.add(new Pipe(pipenum)); //pipenum is there to change the argument into noise
    addpipe = false;
    pipenum += 1;
  }

  for (Pipe i : p) {
    i.update();
    i.show();
  }

  // check if bird is touching pipe or ground
  for (int i = 0; i < flappy.length; ++i) {
    for (int j = 0; j < p.size(); ++j) {
      flappy[i].TouchingBottomPipe(p.get(j));
      flappy[i].TouchingTopPipe(p.get(j));
      flappy[i].TouchingGround();
      flappy[i].TouchingCeiling();
    }
  }

  //remove flappy if the bird is dead
  for (int i = 0; i < flappy.length; ++i) {
    if (flappy[i].IsDead == true) {
      if (flappy[i].fitness == 0) {
        flappy[i].CalculateFitness();
        // to get it out dah way
        flappy[i].x = 10000;
      }
    }
  }

  //check if all birds are dead
  for (int i = 0; i < flappy.length; i++) {
    if (flappy[i].IsDead == true) {
      allDead = true;
    } else {
      allDead = false;
      break;
    }
  }

  if (allDead == true) {
    Generation += 1;
    //reset victor/yuri/yurio to the end
    background.update();

    //calculate fittest bird to know which bird to look for the closest pipe to change the High Score text 
    float maxfit = 0;
    int BestBird = 0;
    for (int i = 0; i < flappy.length; i++) {
      fitnessSum += flappy[i].fitness;
      if (maxfit < flappy[i].fitness) {
        maxfit = flappy[i].fitness;
        BestBird = i;
      }
    }

    //check to see if need to change best score/current score text variable
    flappy[BestBird].CalculatePipeJustPassed();
    CurrentBest = flappy[BestBird].closestpipe;
    if (BestScore < CurrentBest) {
      BestScore = CurrentBest;
    }

    if (mutationRate > 0.05) {
      mutationRate -= 0.02;
    }
    
    //pipe removal by just creating a new list
    p = new ArrayList<Pipe>();
    pipenum = 0;
    p.add(new Pipe(pipenum));

    Breed();

    allDead = false;
  }
}

Bird pickMate(float parent) {
  //pie method of doing weighted probability
  float sum = 0;
  int Mate = 0;
  for (int i = 0; i < flappy.length; ++i) {
    sum += flappy[i].fitness;
    if (sum > parent) {
      Mate = i;
      break;
    }
  }
  return flappy[Mate];
}

void Breed() {
  //pick parents
  Bird parentA = pickMate(random(0, fitnessSum));

  Bird parentB = pickMate(random(0, fitnessSum));

  //make sure no self-breeding
  while (parentA == parentB) {
    parentB = pickMate(random(0, fitnessSum));
  }

  //breed and replace
  for (int i = 0; i < flappy.length; i++) {
    Bird kid = parentA.Breed(parentB);
    kid.mutate(mutationRate);
    flappy[i] = kid;
  }
}
