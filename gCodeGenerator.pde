import toxi.geom.*;
import controlP5.*;
import peasy.*;

//Gcode class
GcodeWriter myGcodeWr; 

//printer dimensions
int dimX = 260;
int dimY = 195; 
int dimZ = 189;

//3D camera
PeasyCam cam; 

//GUI 
ControlP5 c5;        
PFont font01, font02, font03, font04;
Vec3D circleButton_01 =  new Vec3D(1100, 175, 0);
Vec3D circleButton_02 =  new Vec3D(1200, 225, 0);

float buttonRadius_01 = 60;
float buttonRadius_02 = 35;

//extrusion parameters
float printingPlaneOffset  = 2.5;
float extrMIN = 0.01; //0.01 //0.1
float extrMAX = 3.0; //2.25  //1.65

int extrSpeedVal = 400;
//float noiseTime = 25;
//float noiseScale = 0.05;
float extrWaves = 1;

//shape Parameters
int resolution = 50 ;
int radius = 30;
int waveNum = 3;
//int waveDepth = 10;
int vaseHeight = 35;
float elevationIncr = 0.7;//0.75; //spessore del layer
float meshElevIncr = 10.0;//0.75; //spessore del layer
float twist = 0.45;  //shape rotation in radians every 1.0 cm


int R_varTOP = 0;
int R_varBOTTOM = -5 ;
int W_varTOP = 6;
int W_varBOTTOM = 6 ;


float R_amplitude = 0.0;
float R_offset = 5;
float R_frequence = 1.5;


float W_amplitude = 0;
float W_offset = 5;
float W_frequence = 1.5;


ToxiclibsSupport gfx;      
WETriangleMesh mesh;

boolean closeShape = true;
boolean showMesh = false;
boolean showPath = true;

void setup() {
  size (1280, 720, P3D);                                          
  smooth();
  noStroke();

  cam = new PeasyCam(this, dimX/2, -dimY/2, dimZ/2, 350);       // new cam: lookAtX, lookAtY, lookAtZ, distance
  perspective(PI/3.0, float(width)/ float(height), 0.01, 100000);
  cam.rotateX(-PI/2);
  cam.rotateY(-PI/5);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);

  font01= loadFont("Calibri-Italic-25.vlw");
  font02= loadFont("Calibri-Bold-25.vlw");
  font03= loadFont("Calibri-Italic-10.vlw");
  font04= loadFont("Calibri-Italic-12.vlw");

  c5 = new ControlP5(this);                                 // new set of GUI controls (in separate tab)
  c5_setup();                                               // sets up ControlP5 GUI elements (see tab)
  c5.setAutoDraw(false);                                    // update maually to control the refresh sequence

    //initialize Gcode class 
  myGcodeWr = new GcodeWriter(dimX, dimY, dimZ);

  gfx = new ToxiclibsSupport(this);
}


void draw() {

  background(200);
  //ambientLight(128, 128, 128);
  //directionalLight(128, 128, 128, 0, 0, -1);
  //lightFalloff(1, 0, 0);
  //lightSpecular(0, 0, 0);
  //lights();
  drawShape( dimX/2, -dimY/2 );

  if (showMesh) {  
    pushStyle();
    //  fill(75);
    stroke(0, 25);
    strokeWeight(0.5);
    gfx.meshNormalMapped(mesh, false, 0);
    popStyle();
  }
  checkOverlap();
  if (showPath)  myGcodeWr.drawPath();
  myGcodeWr.display();

  //stroke(255);
  gui();
}
