static enum NeuronType {
  INPUT, 
  HIDDEN, 
  OUTPUT
}

class Neuron {
  
  String name;

  public float data;
  int hiddenId;

  Brain brain;
  NeuronType type;

  Neuron(Brain brain, String name, NeuronType type, int id) {
    this.brain = brain;
    this.name = name;
    if (id != -1) this.name += String.valueOf(id);
    this.type = type;
    this.hiddenId = id;
  }

  Neuron(Brain brain, String name, NeuronType type) {
    this(brain, name, type, -1);
  }
  
  void reset() {
    data = 0;
  }
  
  void add(float value) {
    data += value;
  }

  float get() {
    if (type == NeuronType.INPUT) {
      return data;
    } else {
      return (float)Math.tanh(data);
    }
  }

  // get order of neuron in the network
  int getOrder() {
    if (type == NeuronType.INPUT) {
      return -1;
    } else if (type == NeuronType.HIDDEN) {
      return hiddenId;
    } else {
      return brain.numHiddenNeurons;
    }
  }

  @Override
  public String toString() {
    return "Neuron(data=" + data + ", name=" + this.name + ", type=" + type + ")";
  }

}