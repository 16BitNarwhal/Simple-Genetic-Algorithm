class Brain {
  
  final float mutateRate = 0.05f;
  
  int numGenes;
  ArrayList<Gene> genome;
  
  int numHiddenNeurons;
  ArrayList<Neuron> hiddenNeurons;

  // sensor neurons
  Neuron sensePosX;
  Neuron sensePosY;
  Neuron senseOsc;
  Neuron senseRand;
  Neuron lastMoveX;
  Neuron lastMoveY;
  Neuron senseMemory;

  // output neurons
  Neuron moveX;
  Neuron moveY;
  Neuron outMemory;

  ArrayList<Neuron> allNeurons;

  Body body;

  long time;
 
  Brain(Body body, Brain parent) {
    this(body, parent, 4, 1);
  }

  Brain(Body body, Brain parent, int numGenes, int numHiddenNeurons) {
    this.time = 0;
    this.body = body;

    setup(numGenes, numHiddenNeurons);

    this.genome = new ArrayList<Gene>();

    // setup genome either through inheriting or randomly
    if (parent == null) generate(); // randomly generate from scratch
    else inherit(parent); // inherit from parent
    
    // sort gene - (input, internal, output)
    Utils.sort(genome);

  }

  void update() {
    // reset all neurons
    for (Neuron n : hiddenNeurons) {
      n.reset();
    }
    sensePosX.reset();
    sensePosY.reset();
    senseOsc.reset();
    senseRand.reset();
    moveX.reset();
    moveY.reset();
    
    // sensor inputs
    sensePosX.add(body.pos.x / width);
    sensePosY.add(body.pos.y / height);
    senseOsc.add(sin(time));
    senseRand.add(random(-1, 1));

    // feedforward
    feedforward();

    // update memory
    senseMemory.reset();
    senseMemory.add(outMemory.get());

    // update body
    int dx = 0;
    if (random(1) < abs(moveX.get())) {
      dx = moveX.get() > 0 ? 1 : -1;
    }
    int dy = 0;
    if (random(1) < abs(moveY.get())) {
      dy = moveY.get() > 0 ? 1 : -1;
    }
    body.move(dx, dy);
    
    lastMoveX.reset();
    lastMoveY.reset();
    lastMoveX.add(dx);
    lastMoveY.add(dy);
    
    // System.out.println(moveX.get() + " " + moveY.get());

    time++; // increment time
  }

  void feedforward() {
    for (Gene g : genome) {
      g.feed();
    }
  }

  void generate() {
    // initialize genes
    // internal -> hidden, output
    // hidden -> hidden (higher id), output

    for (int i=0;i<numGenes;i++) {
      createGene();
    }
  }

  void createGene() {
    // choose random neuron from allNeurons
    Neuron source = getRandomNeuron();
    Neuron sink = getRandomNeuron(); 
    while (sink.type == NeuronType.INPUT) {
      sink = getRandomNeuron();
    }
    while (source.type == NeuronType.OUTPUT || source.name == sink.name) {
      source = getRandomNeuron();
    }
    if (sink.getOrder() < source.getOrder()) {
      // swap sink and source
      Neuron temp = sink;
      sink = source;
      source = temp;
    }
    float weight = random(-2f, 2f);
    genome.add(new Gene(this, source, sink, weight));
  }

  Neuron getRandomNeuron() {
    return allNeurons.get((int)(random(allNeurons.size())));
  }

  void inherit(Brain parent) { 
    setup(parent.numGenes, parent.numHiddenNeurons);

    // inherit genes from parent
    for (Gene g : parent.genome) {
      Neuron source = null;
      Neuron sink = null; 
      for (Neuron n : allNeurons) {
        if (n.name.equals(g.source.name)) {
          source = n;
          break;
        }
      }
      for (Neuron n : allNeurons) {
        if (n.name.equals(g.sink.name)) {
          sink = n;
          break;
        }
      }
      assert(source != null);
      assert(sink != null);
      genome.add(new Gene(this, source, sink, g.weight));
    }
    if (random(1) < mutateRate) {
      mutate();
    }
  }

  void mutate() {
    // remove a random gene
    int index = (int)(random(genome.size()));
    genome.remove(index);
    // add a new gene
    createGene();
  }

  public JSONObject toJSON() {
    JSONObject json = new JSONObject();

    json.setInt("numHiddenNeurons", numHiddenNeurons);

    JSONArray arr = new JSONArray();
    for (int i=0;i<genome.size();i++) {
      arr.setJSONObject(i, genome.get(i).toJSON());
    }
    json.setJSONArray("genome", arr);
    
    return json;
  }

  void loadJSON(JSONObject json) {
    genome = new ArrayList<Gene>();

    JSONArray arr = json.getJSONArray("genome");  

    // setup all neurons
    setup(arr.size(), json.getInt("numHiddenNeurons"));
    
    // inherit genes from parent
    for (int i=0;i<numGenes;i++) {
      JSONObject obj = arr.getJSONObject(i);

      String sourceStr = obj.getString("source");
      String sinkStr = obj.getString("sink");
      float weight = obj.getFloat("weight");

      Neuron source = null;
      Neuron sink = null;
      for (Neuron n : allNeurons) {
        if (n.name.equals(sourceStr)) {
          source = n;
          break;
        }
      }
      for (Neuron n : allNeurons) {
        if (n.name.equals(sinkStr)) {
          sink = n;
          break;
        }
      }
      assert(source != null);
      assert(sink != null);
      genome.add(new Gene(this, source, sink, weight));
    }
  } 

  void setup(int numGenes, int numHiddenNeurons) {
    this.numGenes = numGenes;
    this.numHiddenNeurons = numHiddenNeurons;
    this.allNeurons = new ArrayList<Neuron>();

    // sensor
    this.sensePosX = new Neuron(this, "sensePosX", NeuronType.INPUT);
    this.sensePosY = new Neuron(this, "sensePosY", NeuronType.INPUT);
    this.senseOsc = new Neuron(this, "senseOsc", NeuronType.INPUT);
    this.senseRand = new Neuron(this, "senseRand", NeuronType.INPUT);

    this.lastMoveX = new Neuron(this, "lastMoveX", NeuronType.INPUT);
    this.lastMoveY = new Neuron(this, "lastMoveY", NeuronType.INPUT);

    this.senseMemory = new Neuron(this, "senseMemory", NeuronType.INPUT);
    
    // hidden
    this.hiddenNeurons = new ArrayList<Neuron>();
    for (int i=0;i<numHiddenNeurons;i++) {
      this.hiddenNeurons.add(
        new Neuron(this, "hidden", NeuronType.HIDDEN, i));
    }
    
    // output
    this.moveX = new Neuron(this, "moveX", NeuronType.OUTPUT);
    this.moveY = new Neuron(this, "moveY", NeuronType.OUTPUT);
    
    this.outMemory = new Neuron(this, "outMemory", NeuronType.OUTPUT);
 
  }

}