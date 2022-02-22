Population pop;
String savePrefix = "gen_B";

HashMap<Integer, Boolean> keyMap = new HashMap<Integer, Boolean>();

void setup() {
  size(896, 952); // (7*128, )
  pop = new Population("gen_B129");
}

int lastSaved = 0;
void draw() {
  background(255);

  pop.run(); // run simulation

  showStats();

  // automatic save
  if (pop.gen%100==0 && lastSaved >= 300) {
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
  textSize(32);
  fill(0);
  text("Gen: " + pop.gen, width/2, height-20);
  text("Prev Result: " + pop.result, 20, height-20);
}

void keyPressed() {
  keyMap.put(keyCode, true);
}

void keyReleased() {
  keyMap.put(keyCode, false);
}