class Population {
  ArrayList<Body> bodies;
  int numBodies; 

  int gen;
  int steps;
  float result; // percent of how many survived

  // default
  Population() {
    this(1000);
  }

  // custom constructor
  Population(int numBodies) {
    this.numBodies = numBodies;
    bodies = new ArrayList<Body>();
    for (int i=0;i<numBodies;i++) {
      bodies.add(new Body(bodies));
    }
    gen=0;
    steps=0;
    result=0;
  }
  
  // load from a save
  Population(String fileName) {
    Loader load = new Loader(fileName);
    bodies = load.getBodies();
    numBodies = bodies.size();
    gen = load.getGeneration();
    steps=0;
    result=0;
  }

  void run() {
    if (steps == STEPSPERGEN) {
      ArrayList<Body> survivors = new ArrayList<Body>();
      for (Body d : bodies) {
        d.naturalSelection();
        if (d.alive) survivors.add(d);
      }
      result = (float) survivors.size() / (float) numBodies;
      for (int i=bodies.size()-1;i>=0;i--) {
        if (!bodies.get(i).alive) bodies.remove(i);
      }
      ArrayList<Body> newBodies = new ArrayList<Body>();
      for (int i=0;i<numBodies;i++) {
        Body parent = survivors.get((int)random(survivors.size()));
        newBodies.add(new Body(bodies, parent));
      }
      bodies = newBodies;
      gen++;
      steps = 0;
    }
    steps++;
    for (Body d : bodies) {
      d.update();
    }
  }
  
}