class Agent {

  Vec3D loc; 
  Vec3D speed;
  Vec3D acc;

  Agent(Vec3D loc) {

    this.loc = loc;
    speed = new Vec3D(random(-1.0, 1.0), random(-1.0, 1.0), 0);
    acc = new Vec3D();
  }

  void run() {

    cohesion(0.001, 40);
    separation(5.0, 20);
    alignment(0.1, 40);

    move (1.0);

    display(3);
    displayVel(10);
    world();
  }




  void alignment(float algInt, float algRange) {

    int count = 0; 
    Vec3D steer = new Vec3D();

    for (int i=0; i< agCollection.size (); i++) {
      Agent other00 = (Agent) agCollection.get(i) ;
      float dist = other00.loc.distanceTo(loc);
      if (dist > 0 && dist< algRange) {

        steer.addSelf(other00.speed);
        count++;
      }
    }

    if (count >0 ) { 
      steer.scaleSelf(1.0/count);

      steer.scaleSelf(algInt);
      acc.addSelf(steer);
    }
  }


  void separation(float sepInt, float sepRange) {

    int count = 0; 
    Vec3D steer = new Vec3D();

    for (int i=0; i< agCollection.size (); i++) {
      Agent other00 = (Agent) agCollection.get(i) ;
      float dist = other00.loc.distanceTo(loc);
      if (dist > 0 && dist< sepRange) {

        steer.addSelf(loc.sub(other00.loc).normalizeTo(1.0/dist));
        count++;
      }
    }

    if (count >0 ) {
      steer.scaleSelf(1.0/count);

      steer.scaleSelf(sepInt);
      acc.addSelf(steer);
    }
  }



  void cohesion(float cohInt, float cohRange) {

    int count = 0; 
    Vec3D sum = new Vec3D();

    for (int i=0; i< agCollection.size (); i++) {
      Agent other00 = (Agent) agCollection.get(i) ;
      float dist = other00.loc.distanceTo(loc);
      if (dist > 0 && dist< cohRange) {

        sum.addSelf( other00.loc);
        count++;
      }
    }

    if (count >0 ) {
      sum.scaleSelf(1.0/count);

      Vec3D steer = sum.sub(loc);
      steer.scaleSelf(cohInt);
      acc.addSelf(steer);
    }
  }


  void move(float maxSpeed) {
    speed.addSelf(acc);
    speed.limit(maxSpeed);
    acc.clear();
    loc.addSelf(speed);
  }


  void world() {
    if (loc.x > width) loc.x = 0 ;
    if (loc.x < 0) loc.x = width ;
    if (loc.y > height) loc.y = 0 ;
    if (loc.y < 0) loc.y = height ;
  }

  void display(int agSize) {
    ellipse(loc.x, loc.y, agSize, agSize);
  }


  void displayVel(float lineSize) {

    Vec3D direction = speed.copy();
    direction.normalizeTo(lineSize);

    Vec3D futPos = loc.add(direction);
    pushStyle();
    stroke(255, 100);
    line(loc.x, loc.y, futPos.x, futPos.y);
    popStyle();
  }
}

