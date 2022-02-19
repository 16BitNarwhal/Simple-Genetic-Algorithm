class Saver {

  final String dir = "./saves/";

  void savePopulation(Population pop, String fileName) {
    JSONObject json = new JSONObject();
    json.setInt("generation", pop.gen);

    ArrayList<Body> bodies = pop.bodies;
    JSONArray arr = new JSONArray();
    for (int i=0;i<bodies.size();i++) {
      Brain brain = bodies.get(i).brain;
      arr.setJSONObject(i, brain.toJSON());
    }

    json.setJSONArray("population", arr);
    
    saveJSONObject(json, dir + fileName + ".json");
  }
  
  void savePopulation(Population pop) {
    savePopulation(pop, "untitled");
  }

}