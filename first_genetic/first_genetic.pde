ArrayList<Body> bodies = new ArrayList<Body>();
final int numBodies = 400;
final int stepsPerGen = 210;

void setup() {
  size(800, 800);
  for (int i=0;i<numBodies;i++) {
    bodies.add(new Body(bodies, getRandomPos()));
  }
}

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
      newBodies.add(new Body(bodies, getRandomPos(), parent));
    }
    bodies = newBodies;
    gen++;
    steps = 0;
  }
  steps++;
  for (Body d : bodies) {
    d.update();
  }

  if (mousePressed && (mouseButton == LEFT)) {
    showStats();
  }
}

PVector getRandomPos() {
  int x = Math.round(random(0, width) / Body.speed) * Body.speed;
  int y = Math.round(random(0, height) / Body.speed) * Body.speed;
  return new PVector(x, y);
}

void showStats() {
  textSize(48);
  fill(0);
  text("Gen: " + gen, 20, height-20);
  text("Result: " + result, 20, height-60);
}