import toxi.geom.Vec3D;

import toxi.geom.mesh.*;
import toxi.volume.*;
import toxi.processing.*;


import controlP5.*;
import peasy.*;

ControlP5 cP5;
PeasyCam cam;

ArrayList <Agent> agCollection;
int agNum = 150;
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

int DIMX = 50;
int DIMY = 50; 
int DIMZ = 50; 

ToxiclibsSupport gfx;

WETriangleMesh mesh;

VolumetricSpaceArray volume;
Vec3D SCALE = new Vec3D(1, 1, 1).scaleSelf(max(worldX, worldY, worldZ));

IsoSurface surface;
float ISO_THRESHOLD = 0.1;

VolumetricBrush brush;
float density=0.25;
float brushRadius = 20.0;

boolean drawMesh = true;



void setup() {
  size(1280, 720, OPENGL);
  cam = new PeasyCam(this, 0, 0, 0, 2000);

  cP5 = new ControlP5(this);
  initializeGUI();


  gfx=new ToxiclibsSupport(this);
  mesh=new WETriangleMesh();

  volume=new VolumetricSpaceArray(SCALE, DIMX, DIMY, DIMZ);

  brush=new RoundBrush(volume, brushRadius);
  surface=new ArrayIsoSurface(volume);



  agCollection = new ArrayList<Agent>();

  while (count <agNum) {

    Vec3D origin = new Vec3D(random (-worldX/2, worldX/2), random (-worldY/2, worldY/2), -worldZ/2);
    if ( noise(origin.x*0.01, origin.y*0.01)  > 0.5) {
      Agent ag00 = new Agent(origin);
      agCollection.add(ag00);
      count++;
    }
  }


  noStroke();
}

void draw() {
  background(200);


  for (int i = 0; i<agCollection.size (); i++) {
    Agent ag01 = (Agent) agCollection.get(i);
    if (ag01.active ==true) ag01.run();
  }


  if (drawMesh) gfx.meshNormalMapped(mesh, true, 0);


  gui();


  pushStyle();
  stroke(0, 50);
  strokeWeight(1.0);
  noFill();

  box(worldX, worldY, worldZ);
  popStyle();
}





void keyPressed() {
  if (key == ' ')  computeVolume(); 
  if (key == 'd' || key == 'D') drawMesh = !drawMesh ;
  if (key == 's' || key == 'S')   mesh.saveAsSTL(sketchPath("noise.stl"));
}
