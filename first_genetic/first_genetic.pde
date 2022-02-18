ArrayList<Body> bodies = new ArrayList<Body>();
final int numBodies = 1000;
final int stepsPerGen = 210;

HashMap<Integer, Boolean> keyMap = new HashMap<Integer, Boolean>();

void setup() {
  size(800, 800);
  for (int i=0;i<numBodies;i++) {
    bodies.add(new Body(bodies));
  }
  // Saver save = new Saver();
  // bodies = save.loadGeneration("gen_1000.txt");
}

int lastSaved = 0;
int gen=0, steps=0;
float result=0; // percent of how many survived
ArrayList<Body> newBodies;
void draw() {
  background(255);
  
  if (steps == stepsPerGen) {
    ArrayList<Body> survivors = new ArrayList<Body>();
    for (Body d : bodies) {
      d.naturalSelection();
      if (d.alive) survivors.add(d);
    }
    result = (float) survivors.size() / (float) numBodies;
    for (int i=bodies.size()-1;i>=0;i--) {
      if (!bodies.get(i).alive) bodies.remove(i);
    }
    newBodies = new ArrayList<Body>();
    for (int i=0;i<numBodies;i++) {
      Body parent = survivors.get((int)random(survivors.size()));
      newBodies.add(new Body(bodies, parent));
    }
    bodies = newBodies;
    gen++;
    steps = 0;

    if (gen%100==0) {
      Saver save = new Saver();
      save.saveGeneration(bodies, gen, "gen_A"+gen);
    }
  }
  steps++;
  for (Body d : bodies) {
    d.update();
  }

  if (mousePressed && (mouseButton == LEFT)) {
    showStats();
  }

  // check CTRL+S
  if (keyMap.containsKey(17) && keyMap.containsKey(83) 
      && keyMap.get(17) && keyMap.get(83) && lastSaved>=300) {
    Saver save = new Saver();
    save.saveGeneration(bodies, gen, "gen_A"+gen);
    lastSaved=0;
  }
  if (lastSaved < 300) lastSaved++;
}

void showStats() {
  textSize(48);
  fill(0);
  text("Gen: " + gen, 20, height-20);
  text("Result: " + result, 20, height-60);
}

void keyPressed() {
  keyMap.put(keyCode, true);
}

void keyReleased() {
  keyMap.put(keyCode, false);
}