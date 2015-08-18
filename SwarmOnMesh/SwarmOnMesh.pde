import toxi.geom.Vec3D;

import toxi.geom.mesh.*;
import toxi.volume.*;
import toxi.processing.*;


import controlP5.*;
import peasy.*;

ControlP5 cP5;
PeasyCam cam;

ArrayList <Agent> agCollection;
int agNum = 250;
int count= 0;

float sep_val = 7.5 ;
float coh_val = 0.001 ;
float ali_val = 0.1 ;

float sep_rad = 75.0;
float coh_rad = 85.0 ;
float ali_rad = 85.0;


int worldX = 1000;
int worldY = 1000; 
int worldZ = 1000; 

int DIMX = 65;
int DIMY = 65; 
int DIMZ = 65; 


float ISO_THRESHOLD = 0.1;
Vec3D SCALE = new Vec3D(1, 1, 1).scaleSelf(max(worldX, worldY, worldZ));

VolumetricSpaceArray volume;
VolumetricBrush brush;
IsoSurface surface;
WETriangleMesh mesh;

TriangleMesh meshObject;

ToxiclibsSupport gfx;


float density=0.25;

float brushRadius = 20.0;


boolean drawMesh = true;




void setup() {
  size(1280, 720, OPENGL);
  cam = new PeasyCam(this, 0, 0, 0, 2000);

  cP5 = new ControlP5(this);
  initializeGUI();


  gfx=new ToxiclibsSupport(this);

  volume=new VolumetricSpaceArray(SCALE, DIMX, DIMY, DIMZ);

  brush=new RoundBrush(volume, brushRadius);
  surface=new ArrayIsoSurface(volume);
  mesh=new WETriangleMesh();


  meshObject = new TriangleMesh();
  meshObject.addMesh(new STLReader().loadBinary(openStream("myMESH.stl"), "N_name", STLReader.TRIANGLEMESH));


  Vec3D scaleFactor = new Vec3D(1, 1, 1);
  meshObject.scale(scaleFactor);


  agCollection = new ArrayList<Agent>();

  for (int i = 0; i< agNum; i++ ) {    
    Vec3D origin = new Vec3D(0, 0, 0);
    Agent ag00 = new Agent(origin);
    agCollection.add(ag00);
  }

  noStroke();
  noFill();
}

void draw() {
  background(200);


  for (int i = 0; i<agCollection.size (); i++) {
    Agent ag01 = (Agent) agCollection.get(i);
    if (ag01.active ==true) ag01.run();
  }


    evaporateTraces();


  if (drawMesh) {
    
    computeVolume();
    gfx.meshNormalMapped(mesh, true, 0);
  }


  pushStyle();
  noFill();
  stroke(50);
  strokeWeight(1.0);
  gfx.mesh(meshObject, true);
  popStyle();
  gui();



  pushStyle();
  stroke(0, 50);
  strokeWeight(1.0);
  noFill();

  box(worldX, worldY, worldZ);
  popStyle();
}





void keyPressed() {

 if (key == 's' || key == 'S')   mesh.saveAsSTL(sketchPath("noise.stl"));
}
