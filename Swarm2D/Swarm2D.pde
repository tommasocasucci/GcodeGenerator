import toxi.geom.Vec3D;

ArrayList <Agent> agCollection;
int agNum = 500;

void setup() {
  size(800, 600);

  agCollection = new ArrayList<Agent>();

  for (int i = 0; i<agNum; i++) {
    Agent ag00 = new Agent(new Vec3D(random(width), random(height), 0));
    agCollection.add(ag00);
  }

  noStroke();
}

void draw() {
  background(200);
  for (int i = 0; i<agCollection.size (); i++) {
    Agent ag01 = (Agent) agCollection.get(i);
    ag01.run();
  }
}
