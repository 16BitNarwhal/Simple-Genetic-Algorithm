class Body {
  
  // if true, bodies will block and collide with each other
  static final boolean doCollision = false; // will probably turn on when dots can detect each other
  
  ArrayList<Body> bodiesRef;
  Brain brain;
  public static final int speed = 2;
  PVector pos; 
  public boolean alive = true;

  public Body(ArrayList<Body> bodies, PVector pos, Body parent) {
    if (pos != null) {
      this.pos = pos.copy();
    } else {
      this.pos = getRandomPos();
    }

    if (parent == null) this.brain = new Brain(this, null);
    else this.brain = new Brain(this, parent.brain);
    this.bodiesRef = bodies;
  }

  public Body(ArrayList<Body> bodies, Body parent) {
    this(bodies, null, parent);
  }

  public Body(ArrayList<Body> bodies) {
    this(bodies, null, null);
  }

  public Body(ArrayList<Body> bodies, JSONObject brainJSON) {
    this(bodies, null, null);
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
    circle(pos.x, pos.y, speed);
  }

  void moveX(int dx) {
    dx *= speed;
    pos.x += dx;
    if (pos.x >= width - speed) {
      pos.x = width - speed;
    } else if (pos.x <= speed) {
      pos.x = speed;
    }
    // if new pos touching another body, undo move
    if (touchBody()) {
      pos.x -= dx;
    }
  }

  void moveY(int dy) {
    dy *= speed;
    pos.y += dy;
    if (pos.y >= height - speed) {
      pos.y = height - speed;
    } else if (pos.y <= speed) {
      pos.y = speed;
    }
    // if new pos touching another body, undo move
    if (doCollision && touchBody()) {
      pos.y -= dy;
    }
  }

  // collision
  boolean touchBody() {
    for (Body d : bodies) {
      if (d != this && d.pos.dist(pos) <= speed) {
        return true;
      }
    }
    return false;
  }

  void naturalSelection() {
    // // right half of screen survives
    // if (pos.x >= width/2) {
    //   alive = true;
    // } else {
    //   alive = false;
    // }

    // // circle radius 200 at center of screen
    // PVector center = new PVector(width/2, height/2);
    // if (pos.dist(center) <= 200) {
    //   alive = true;
    // } else {
    //   alive = false;
    // }

    // top left and bottom right corner
    if (pos.x <= width/3 && pos.y <= height/3) {
      alive = true;
    } else if (pos.x >= width-width/3 && pos.y >= height-height/3) {
      alive = true;
    } else if (pos.x >= width-width/3 && pos.y <= height/3) {
      alive = true;
    } else if (pos.x <= width/3 && pos.y >= height-height/3) {
      alive = true;
    } else {
      alive = false;
    }
  }

  PVector getRandomPos() {
    int x = Math.round(random(0, width) / Body.speed) * Body.speed;
    int y = Math.round(random(0, height) / Body.speed) * Body.speed;
    return new PVector(x, y);
  }

}