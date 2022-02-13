class Brain {
  
  final float mutateRate = 0.01f;
  
  final int numGenes = 32;
  ArrayList<Gene> genome;
  
  final int numHiddenNeurons = 16;
  ArrayList<Neuron> hiddenNeurons;

  Neuron sensePosX;
  Neuron sensePosY;
  Neuron senseOsc;
  
  Neuron moveX;
  Neuron moveY;

  ArrayList<Neuron> allNeurons;

  Body body;

  long time;

  Brain(Body body, Brain parent) {
    this.time = 0;
    this.body = body;

    this.sensePosX = new Neuron(this, "sensePosX", NeuronType.INPUT);
    this.sensePosY = new Neuron(this, "sensePosY", NeuronType.INPUT);
    this.senseOsc = new Neuron(this, "senseOsc", NeuronType.INPUT);
    
    this.hiddenNeurons = new ArrayList<Neuron>();
    for (int i=0;i<numHiddenNeurons;i++) {
      this.hiddenNeurons.add(
        new Neuron(this, "hidden", NeuronType.HIDDEN, i));
    }
    
    this.moveX = new Neuron(this, "moveX", NeuronType.OUTPUT);
    this.moveY = new Neuron(this, "moveY", NeuronType.OUTPUT);

    this.allNeurons = new ArrayList<Neuron>();
    this.allNeurons.add(this.sensePosX);
    this.allNeurons.add(this.sensePosY);
    this.allNeurons.add(this.senseOsc);
    this.allNeurons.add(this.moveX);
    this.allNeurons.add(this.moveY);
    this.allNeurons.addAll(this.hiddenNeurons);

    this.genome = new ArrayList<Gene>();

    // setup genome either through inheriting or randomly
    if (parent == null) generate(); // randomly generate from scratch
    else inherit(parent); // inherit from parent
    
    // sort gene - (input, internal, output)
    Utils.sort(genome);

    // for (Gene g : genome) {
    //   System.out.println(g);
    // }

  }

  void update() {
    // reset all neurons
    for (Neuron n : hiddenNeurons) {
      n.reset();
    }
    sensePosX.reset();
    sensePosY.reset();
    senseOsc.reset();
    moveX.reset();
    moveY.reset();
    
    // sensor inputs
    sensePosX.add(body.pos.x / width);
    sensePosY.add(body.pos.y / height);
    senseOsc.add(sin(time));

    // feedforward
    feedforward();

    // update body
    if (random(1) < abs(moveX.get())) {
      body.moveX(moveX.get() < 0 ? -1 : 1); 
    }
    if (random(1) < abs(moveY.get())) {
      body.moveY(moveY.get()<0 ? -1 : 1);
    }
    
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
    while (source.type == NeuronType.INPUT && sink.type == NeuronType.INPUT) {
      sink = getRandomNeuron();
    }
    while (source.type == NeuronType.OUTPUT && sink.type == NeuronType.OUTPUT) {
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

}