class Saver {

  final String dir = "./saves/";

  void saveGeneration(ArrayList<Body> pop, int gen, String fileName) {
    JSONObject json = new JSONObject();
    json.setInt("generation", gen);

    JSONArray arr = new JSONArray();
    for (int i=0;i<pop.size();i++) {
      Brain brain = pop.get(i).brain;
      arr.setJSONObject(i, brain.toJSON());
    }

    json.setJSONArray("population", arr);
    
    saveJSONObject(json, dir + fileName + ".json");
  }

  void saveGeneration(ArrayList<Body> pop, int gen) {
    saveGeneration(pop, gen, "untitled");
  }

  ArrayList<Body> loadGeneration(String fileName) {
    JSONObject json = loadJSONObject(dir + fileName + ".json");
    int gen = json.getInt("generation");
    JSONArray arr = json.getJSONArray("population");

    ArrayList<Body> pop = new ArrayList<Body>();
    for (int i=0;i<arr.size();i++) { 
      Body body = new Body(pop, arr.getJSONObject(i));
      pop.add(body);
    }

    return pop;
  }

}