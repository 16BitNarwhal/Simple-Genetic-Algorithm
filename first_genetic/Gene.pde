class Gene implements Comparable<Gene> {

  Brain brain;
  Neuron source;
  Neuron sink;
  float weight;

  Gene(Brain brain, Neuron source, Neuron sink, float weight) {
    this.brain = brain;
    this.source = source;
    this.sink = sink;
    this.weight = weight;
  }

  void feed() {
    float value = source.get();
    sink.add(value * weight);
  }

  // compare genes by type
  @Override
  int compareTo(Gene other) {
    if (getOrder() == other.getOrder()) return 0;
    else return getOrder() < other.getOrder() ? -1 : 1;
  }

  // get order of gene for feedforward
  int getOrder() {
    if (source.type == NeuronType.INPUT) {
      return -1; // sorted to left
    } else if (source.type == NeuronType.HIDDEN) {
      return source.hiddenId; // [0, hiddenCount)
    } else {
      return brain.numHiddenNeurons; // sorted to right
    }
  }

  @Override
  public String toString() {
    return "Gene{\n" +
        "  source=" + source + "\n" +
        "  sink=" + sink + "\n" +
        "  weight=" + weight + "\n" +
        "}";
  }

}