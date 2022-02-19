class Loader {

  final String dir = "./saves/";

  JSONObject json;
  int gen;
  ArrayList<Body> bodies;

  Loader(String fileName) {
    json = loadJSONObject(dir + fileName + ".json");
    gen = json.getInt("generation");
    
    JSONArray arr = json.getJSONArray("population");
    bodies = new ArrayList<Body>();
    for (int i=0;i<arr.size();i++) { 
      Body body = new Body(bodies, arr.getJSONObject(i));
      bodies.add(body);
    }
  }

  int getGeneration() {
    return gen;
  }

  ArrayList<Body> getBodies() {
    return bodies;
  }

}