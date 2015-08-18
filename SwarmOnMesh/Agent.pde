class Agent {

  Vec3D loc; 
  Vec3D speed;
  Vec3D acc;

  float meshAttr = 0.5;

  boolean active = true; 


  Agent(Vec3D loc) {

    this.loc = loc;
    speed = new Vec3D(random(-1.0, 1.0), random(-1.0, 1.0), 1.0);
    acc = new Vec3D();
  }

  void run() {

    cohesion(coh_val, coh_rad);
    separation(sep_val, sep_rad);
    alignment(ali_val, ali_rad);


    meshAttraction(meshAttr);

    move (1.0);

    display(3);
    displayVel(25);

    paintVolume();
    world();
  }

  void meshAttraction(float attrVal) {

    Vec3D closestVert = new Vec3D(); 
    float closestDist = 999999999999.0;
    
    //define future location
    Vec3D futLoc = loc.add(speed.normalizeTo(20.0));

    //find closest vertex 
    for (Vertex v : meshObject.vertices.values()) {
         
      float distVal = v.distanceTo(futLoc);

      if (distVal < closestDist) {
        closestDist = distVal ;
        closestVert = v.copy();
      }
    }

    //define attraction force
    Vec3D attrForce = closestVert.sub(loc);
    attrForce.normalizeTo(attrVal);


    //add attractino to acceleration 
    acc.addSelf(attrForce);
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


  void addForce(Vec3D force) {

    acc.addSelf(force);
  }


  void move(float maxSpeed) {

    speed.addSelf(acc);
    speed.limit(maxSpeed);
    acc.clear();   

    loc.addSelf(speed);
  }


  void world() {

    if (loc.x > worldX/2) loc.x = - worldX/2 ;
    if (loc.x < -worldX/2) loc.x =  worldX/2 ;
    if (loc.y > worldY/2) loc.y = - worldY/2 ;
    if (loc.y < -worldY/2) loc.y =  worldY/2 ;

    if (loc.z > worldX/2) active =false ;


  }


  void display(int agSize) {
    pushStyle();
    stroke(255);
    strokeWeight(agSize);   
    point(loc.x, loc.y, loc.z);
    popStyle();
  }


  void displayVel(float lineSize) {   

    Vec3D direction = speed.copy();
    direction.normalizeTo(lineSize);

    Vec3D futPos = loc.add(direction);
    pushStyle();
    stroke(255, 175);
    strokeWeight(1.0);
    line(loc.x, loc.y, loc.z, futPos.x, futPos.y, futPos.z);
    popStyle();
  }

  void paintVolume() {

    brush.drawAtAbsolutePos(loc, density);
  }
}
