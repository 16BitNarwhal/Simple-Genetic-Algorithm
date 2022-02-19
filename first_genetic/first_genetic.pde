Population pop;
String savePrefix = "gen_A";

HashMap<Integer, Boolean> keyMap = new HashMap<Integer, Boolean>();

void setup() {
  size(800, 800);
  pop = new Population("gen_500");
}

int lastSaved = 0;
void draw() {
  background(255);

  pop.run(); // run simulation

  if (mousePressed && (mouseButton == LEFT)) {
    showStats();
  }

  // automatic save
  if (pop.gen%100==0 && pop.steps==0) {
    Saver save = new Saver();
    save.savePopulation(pop, savePrefix+pop.gen);
    lastSaved=0;
  }

  // check CTRL+S for manual save
  if (keyMap.containsKey(17) && keyMap.containsKey(83) 
      && keyMap.get(17) && keyMap.get(83) && lastSaved>=300) {
    Saver save = new Saver();
    save.savePopulation(pop, savePrefix+pop.gen);
    lastSaved=0;
  }
  if (lastSaved < 300) lastSaved++;
}

void showStats() {
  textSize(48);
  fill(0);
  text("Gen: " + pop.gen, 20, height-20);
  text("Result: " + pop.result, 20, height-60);
}

void keyPressed() {
  keyMap.put(keyCode, true);
}

void keyReleased() {
  keyMap.put(keyCode, false);
}