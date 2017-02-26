/*
 ..................................................................
 
 
 G-code export class 
 
 code by Tommaso Casucci 2014 
 (cc) creative commons [ attribution ]
 
 
 ..................................................................
 */



class GcodeWriter {

  String eol = System.getProperty("line.separator"); // line separator character

  ArrayList<ArrayList<Vec3G>> printList;

  float extrusion = 0.0; //this variable store the incremental value of extrusion  DO NOT CHANGE IT 
  float extrEval = 0; //variable containing a fast evaluation of extrusion value


  float extrusionWeight = 0.0;
  float extrusionPrice = 0.0;

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //Gcode VARIABLES

  float stepsE = 415.000;
  float acceleration = 10000; //this value can be incremented up to 25000 
  float exportScale = 1.0;

  //etrusion
  float extrusionMultiplier = 0.055; 


  //retraction (use negative values to retract) 
  //  float startEndRetraction = -0.0 ;
  float retraction =0.0;  //-2.0;

  int retrVel = 5000; //9000

    //bounce
  float bounce = 0.00; // retraction movement on the Z axis while retracting

  //velocity
  int fastMoveVel = 15000;
  int extrVel = 1000;

  int temperature = 200;

  int machineX = 260;
  int machineY = 190; 
  int machineZ = 190;


  // to have a reference 1Kg of PLA filament is around 110 meters
  float filamentCost = 35 ;// price Euro/Kg 
  float filamentDiameter = 3.0; //mesure in mm
  float filamentDensity = 1.25; //PLA is around 1.25 g/cm3 // ABS is around 1.04 g/cm3 


  //constructor
  GcodeWriter (int _machineX, int _machineY, int _machineZ) {

    printList = new ArrayList<ArrayList<Vec3G>>();

    machineX=_machineX;
    machineY = _machineY;
    machineZ = _machineZ;
  }


  void addToPrintList(ArrayList printableElements) {
    printList.add(printableElements);
  }

  void addToPrintList(Vec3G singlePt) {
    ArrayList ptList = new ArrayList();
    ptList.add(singlePt);
    printList.add(ptList);
  }


  void exportGcode( String fileName) {

    extrusion = 0;
    String pts="";

    pts+= gCodeStart(extrusionMultiplier);

    for (int i = 0; i< printList.size (); i++) {  
      ArrayList  cPts = (ArrayList) printList.get(i);

      if (cPts.size()==1) {
        pts+= writePoint(cPts);
      } else {
        pts+= writeLine(cPts );
      }
    }

    pts+= gCodeFinish();

    // creates output & writes data
    PrintWriter output;   //Declare the PrintWriter
    output = createWriter(fileName);   //Create a new PrintWriter object
    output.println(pts); // Writes the data
    output.flush();  //Write the remaining data to the file
    output.close();  //Finishes the files

    println("G-code saved!");


    //    extrusionWeight = sq( filamentDiameter / 2 ) * PI * extrusion*0.001 * filamentDensity; 
    //    extrusionPrice = ( extrusionWeight * filamentCost ) / 1000;
    //    println("extrusion length (cm): "+ nfc(extrusion/10, 2));
    //    println("extrusion weight (gr): "+ nfc(extrusionWeight, 2));
    //    println("extrusion price (Euro): "+ nfc(extrusionPrice, 2));
  }



  String writePoint(ArrayList cPts) {

    String pts="";

    Vec3G V00 = (Vec3G) cPts.get(0);
    Vec3G V0 = V00.copyV3G();
    V0.y= -V0.y; // y values are inverted to match 3Dprinter coordinate system (positive values going upwards) 
    V0.roundV3G(2);
    V0.scaleSelf(exportScale);

    println(V00.y+ " ---" + V0.y);

    pts += eol;

    pts +=("G1 F"+fastMoveVel+" X"+V0.x +" Y" +V0.y+" Z" +(V0.z+bounce));
    pts += eol;

    extrusion +=  -retraction;
    pts +=("G1 F"+retrVel+" Z" +V0.z+" E" + extrusion );
    pts += eol;

    //estrudi punto
    extrusion+= 1.0 * extrusionMultiplier * V0.extr;  
    pts +=("G1 F"+V0.extrSpeed+" E"+ extrusion  );  
    pts += eol;

    extrusion +=  retraction;
    pts +=("G1 F"+retrVel+" Z" +(V0.z+bounce)+ " E"+ extrusion );  
    pts += eol;

    return pts;
  }


  String writeLine(ArrayList cPts) {

    String pts="";

    for (int j=0; j< cPts.size (); j++) {
      Vec3G V00 = (Vec3G) cPts.get(j);
      Vec3G V0 = V00.copyV3G();
      V0.y= -V0.y; // y values are inverted to match 3Dprinter coordinate system (positive values going upwards) 
      V0.roundV3G(2);
      V0.scaleSelf(exportScale);

      if ( j == 0) {

        // first point of the curve 
        pts += eol;
        pts +=("G1 F"+fastMoveVel+" X"+V0.x +" Y" +V0.y+" Z" +(V0.z+ bounce));
        pts += eol;
        extrusion +=  -retraction;
        pts +=("G1 F"+retrVel+" Z" +V0.z + " E"+ extrusion );
        pts += eol;
      } else if (j==cPts.size()-1) {

        //last point of each curve
        Vec3G V01 = (Vec3G) cPts.get(j-1);
        Vec3G V1 = V01.copyV3G();
        V1.y = -V1.y; // y values are inverted to match 3Dprinter coordinate system (positive values going upwards) 
        V1.roundV3G(2);
        V1.scaleSelf(exportScale);

        float extrusion_00 = V0.distanceTo(V1) * extrusionMultiplier * V1.extr;
        extrusion +=  extrusion_00;
        pts +=("G1 F"+V1.extrSpeed+" X"+V0.x +" Y" +V0.y+" Z" +V0.z    +" E" + extrusion  );  
        pts += eol;
        extrusion +=  retraction;
        pts +=("G1 F"+retrVel+" X"+V0.x +" Y" +V0.y+" Z" + (V0.z+bounce )   +" E" + extrusion  );  
        pts += eol;
      } else {
        //each point on the curve but not the first or the last one
        Vec3G V01 = (Vec3G) cPts.get(j-1);
        Vec3G V1 = V01.copyV3G();
        V1.y= -V1.y; // y values are inverted to match 3Dprinter coordinate system (positive values going upwards) 
        V1.roundV3G(2);
        V1.scaleSelf(exportScale);

        float extrusion_00 = V0.distanceTo(V1)*extrusionMultiplier* V1.extr;
        extrusion +=  extrusion_00;
        pts +=("G1 F"+V1.extrSpeed+" X"+V0.x +" Y" +V0.y+" Z" +V0.z    +" E" + extrusion );  
        pts += eol;
      }
    }

    return pts;
  }

  String gCodeStart(float exMult) {

    String pts="";

    pts+=  "M92 E"+ stepsE + eol ; //steps per E
    pts+=  "T0" +eol;
    pts+= "M109 S"+ temperature +eol ;  //set target temperature value
    pts+=  "G21" +eol ;  //metric values
    pts+=  "G90" +eol; //absolute positioning

    pts+=  "G28 X0 Y0" +eol; //absolute positioning
    pts+=  "G28 Z0" +eol; //absolute positioning
    pts+=  "G1 Z15.0 F9000" +eol; //absolute positioning

    pts+=  "M107" +eol; //start with the fan off
    pts+=  "G92 E0" +eol;
    pts+=  "M117 Printing..." +eol; //put printing message on LCD screen
    pts+=  "M201 X"+ acceleration + " Y" + acceleration +eol; //acceleration control
    pts+=  "M302" +eol; // allow cold extrusion


    /////////WARMUP path

    float lineOffset= 50;
    float boardOffset = 25;

    Vec3D W1 =    new Vec3D(lineOffset, boardOffset, 0);  
    Vec3D W2 = new Vec3D(machineX-lineOffset, boardOffset, 0);   

    float extrusion_00 = W1.distanceTo(W2)*extrusionMultiplier;
    extrusion +=  extrusion_00; 

    pts+= "G1 F"+fastMoveVel+" X"+ W1.x +" Y"+ W1.y+ " Z" +W1.z+ eol;
    pts+=  "G1 F"+500+" X"+ W2.x +" Y"+ W2.y+ " Z" +W2.z+" E"+ (extrusion)+ eol;


    //retract
    extrusion += retraction;
    pts+=  "G1 F"+retrVel+" E"+ (extrusion) +eol;

    return pts;
  }


  String gCodeFinish() {

    String pts="";

    pts+= eol;


    pts+=  "M104 S0" +eol;  //extruder heater Off
    pts+=  "G91" +eol;  //relative positioning

    pts+= "G1 Z+0.5 E"+ (2*retraction) +" X-20.0 Y-20.0 F9000" + eol;   //move Z up a bit and retract filament 
    pts += "G28 X0 Y0" + eol ; //  move X/Y to min endstops, so the head is out of the way

    pts+=  "M84" +eol;  //steppers off
    pts+=  "G90" +eol;   //absolute positioning

    return pts;
  }



  void display() {

    //display 3Dprinter volume
    pushStyle();
    noFill();
    pushMatrix();
    scale(machineX, machineY, machineZ);
    stroke(255, 150);
    strokeWeight(0.005);
    translate (+0.5, -0.5, +0.5);
    box(1);
    popMatrix();
    popStyle();

    // display origin
    pushStyle();
    stroke(200, 250, 0);
    strokeWeight(10.0);
    point(0, 0, 0);
    popStyle();
  }



  void drawPath() {

    extrEval = 0;

    for (int i = 0; i< printList.size (); i++) {  
      ArrayList  cPts = (ArrayList) printList.get(i);

      for (int k = 0; k<cPts.size (); k++) {
        pushStyle();
        Vec3G cp00 = (Vec3G) cPts.get( k );
        stroke(0, map(cp00.extr, 0.5, 1.5, 0, 255));
        //stroke(255,200,0);
        //stroke(0);
        strokeWeight(map(cp00.extr, 0.5, 1.5, 0.0, 10.0));
        //        strokeWeight(5.0);
        point(cp00.x, cp00.y, cp00.z);

        if (k>0) {
          Vec3G cp01 = (Vec3G) cPts.get( k-1 );
          stroke(175);
          strokeWeight(0.5);
          line(cp00.x, cp00.y, cp00.z, cp01.x, cp01.y, cp01.z);
          extrEval += cp01.distanceTo(cp00)*extrusionMultiplier* cp01.extr;
        } else {
          extrEval += 1.0 *extrusionMultiplier* cp00.extr;
        }
        popStyle();
      }
    }


    extrusionWeight = sq( filamentDiameter / 2 ) * PI * extrEval*0.001 * filamentDensity; 
    extrusionPrice = ( extrusionWeight * filamentCost ) / 1000;
    //    println("extrusion length (cm): "+ nfc(extrEval/10, 2));
    //    println("extrusion weight (gr): "+ nfc(extrusionWeight, 2));
    //    println("extrusion price (Euro): "+ nfc(extrusionPrice, 2));
  }
}
