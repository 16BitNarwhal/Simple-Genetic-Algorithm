class Body {
  
  // if true, bodies will block and collide with each other
  static final boolean doCollision = true; // will probably turn on when dots can detect each other
  
  Brain brain;
  PVector pos; 
  public boolean alive = true;

  public Body(PVector pos, Body parent) {
    if (pos != null) {
      this.pos = pos.copy();
    } else {
      this.pos = getRandomPos();
    }

    if (parent == null) this.brain = new Brain(this, null);
    else this.brain = new Brain(this, parent.brain); 
  }

  public Body(Body parent) {
    this(null, parent);
  }

  public Body() {
    this(null, null);
  }

  public Body(JSONObject brainJSON) {
    this(null, null);
    this.brain.loadJSON(brainJSON);
  }

  void update() {
    brain.update();
    display();
  }

  void display() {
    noStroke();
    naturalSelection();
    if (alive) fill(0, 255, 0);
    else fill(255, 0, 0);
    circle(pos.x*SCALE + SCALE/2, pos.y*SCALE + SCALE/2, SCALE);
  }

  void move(int dx, int dy) {
    int x = (int)pos.x + dx;
    int y = (int)pos.y + dy;
    if (x < 0 || x >= WIDTH || y < 0 || y >= HEIGHT) {
      return; // don't move if out of bounds
    } else if (doCollision && occupied[x][y] != null) {
      return; // don't move if occupied by another
    } else {
      occupied[(int)pos.x][(int)pos.y] = null;
      pos.x = x;
      pos.y = y;
      occupied[(int)pos.x][(int)pos.y] = this;
    }
  }

  void naturalSelection() {
    // right half of screen survives
    if (pos.x >= WIDTH/2) {
      alive = true;
    } else {
      alive = false;
    }

    // // circle radius 200 at center of screen
    // PVector center = new PVector(WIDTH/2, HEIGHT/2);
    // if (pos.dist(center) <= 200) {
    //   alive = true;
    // } else {
    //   alive = false;
    // }

    // // four corners
    // if (pos.x <= WIDTH/3 && pos.y <= HEIGHT/3) {
    //   alive = true;
    // } else if (pos.x >= WIDTH-WIDTH/3 && pos.y >= HEIGHT-HEIGHT/3) {
    //   alive = true;
    // } else if (pos.x >= WIDTH-WIDTH/3 && pos.y <= HEIGHT/3) {
    //   alive = true;
    // } else if (pos.x <= WIDTH/3 && pos.y >= HEIGHT-HEIGHT/3) {
    //   alive = true;
    // } else {
    //   alive = false;
    // }
  }

  PVector getRandomPos() {
    int x = Math.round(random(0, WIDTH-1));
    int y = Math.round(random(0, HEIGHT-1));
    return new PVector(x, y);
  }

}