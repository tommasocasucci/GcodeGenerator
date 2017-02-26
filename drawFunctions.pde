import toxi.geom.mesh.*;
import toxi.processing.*;



void drawShape(float xPos, float yPos) {

  float rotation=0;

  //float rotationIncr = radians( _twist/ (_vaseHeight/ _elevationIncr ) );
  myGcodeWr.printList.clear();


  for (float z =printingPlaneOffset; z< vaseHeight; z+= elevationIncr) {

    ArrayList layer = new ArrayList();

    for (int i=0; i<resolution; i++) {
      float wAngle = map(z, 0, vaseHeight, 0, TWO_PI* W_frequence);
      float wDisplace = sin(wAngle+ W_offset) * W_amplitude ;

      float waveAngle = map(i, 0, resolution, 0, TWO_PI*waveNum);
      float waveOffset = sin(waveAngle) * (  map(z, 0, vaseHeight, W_varBOTTOM, W_varTOP) + wDisplace );

      float angle = map (i, 0, resolution, 0, TWO_PI );

      rotation = map(z, 0, 10, 0, twist);
      angle +=  rotation; 

      float radiusAngle = map(z, 0, vaseHeight, 0, TWO_PI* R_frequence);
      float radiusDisplace = sin(radiusAngle+ R_offset) * R_amplitude ;

      float circleOffX = cos(angle) * (radius + map(z, 0, vaseHeight, R_varBOTTOM, R_varTOP) + waveOffset + radiusDisplace);
      float circleOffY = sin(angle) * (radius +  map(z, 0, vaseHeight, R_varBOTTOM, R_varTOP) + waveOffset + radiusDisplace);

      float x = xPos + circleOffX ;
      float y = yPos + circleOffY ;


      //      Vec3G pt  = new Vec3G(x, y, z, map(sin(angle), -1, 1, extrMIN, extrMAX), extrSpeedGlobal);

      float extrAngle= map(i, 0, resolution, 0, TWO_PI* extrWaves) ;
      float extrWave = sin (extrAngle);

      Vec3G pt  = new Vec3G(x, y, z, map( extrWave, -1, 1, extrMIN, extrMAX), extrSpeedVal );

      //      if (i==0) {
      //        strokeWeight(15);
      //        stroke(255, 0, 0);
      //        point(x,y,z);
      //      }

      //  Vec3G pt  = new Vec3G(x, y, z, map(noise(x*noiseScale, y*noiseScale, z*noiseScale) , 0, 1, extrMIN, extrMAX), extrSpeedGlobal);

      layer.add(pt);
    }

    myGcodeWr.addToPrintList(layer);
  }

  drawMesh(xPos, yPos);
}







void drawMesh(float _xPos, float _yPos) {
  //INITIALIZE MESH


  mesh = new WETriangleMesh();
  Vertex[] vertList;

  if (closeShape) {
    vertList = new Vertex[resolution * myGcodeWr.printList.size() +2 ];
  } else {
    vertList = new Vertex[resolution * myGcodeWr.printList.size()];
  }

  int vNum = 0;


  //add all vertex to the vertList
  for (int i = 0; i< myGcodeWr.printList.size (); i++) {  
    ArrayList  cPts = (ArrayList) myGcodeWr.printList.get(i);
    for (int j=0; j< cPts.size (); j++) {
      Vec3G V00 = (Vec3G) cPts.get(j);
      vertList[vNum] = new Vertex( new Vec3D (V00.x, V00.y, V00.z ), vNum);
      vNum++;
    }
  }

  if (closeShape) {
    ArrayList  cPts00 = (ArrayList) myGcodeWr.printList.get(0);

    Vec3G V00 = (Vec3G) cPts00.get(0);
    vertList[vNum] = new Vertex( new Vec3D (_xPos, _yPos, V00.z ), vNum);
    vNum++;

    ArrayList  cPts01 = (ArrayList) myGcodeWr.printList.get(myGcodeWr.printList.size()-1);

    Vec3G V01 = (Vec3G) cPts01.get(0);
    vertList[vNum] = new Vertex( new Vec3D (_xPos, _yPos, V01.z ), vNum);
  }


  //create mesh triangles
  for (int h = 0; h<myGcodeWr.printList.size ()-1; h++) {   
    for (int k = 0; k<resolution-1; k++) {
      mesh.addFace(vertList[k +(h*resolution)+ resolution], vertList[k+1 +(h*resolution)], vertList[k +(h*resolution)] );
    }

    mesh.addFace(vertList[ resolution-1 +(h*resolution)+ resolution], vertList[ 0 + (h*resolution)], vertList[resolution-1 +(h*resolution)]   );
  }

  for (int h = 1; h<myGcodeWr.printList.size (); h++) {   
    for (int k = 1; k<resolution; k++) {
      mesh.addFace(vertList[k-1 +(h*resolution)], vertList[k +(h*resolution)], vertList[k +(h*resolution)-resolution]  );
    }

    mesh.addFace(vertList[resolution-1 +(h*resolution)], vertList[0 +(h*resolution)], vertList[0 +(h*resolution)-resolution] );
  }


  if (closeShape) {

    //bottom
    for (int k = 0; k<resolution-1; k++) {
      mesh.addFace(vertList[k], vertList[k+1], vertList[vertList.length-2]  ); //bottom
      mesh.addFace(vertList[vertList.length-1], vertList[k+1 +((myGcodeWr.printList.size()-1)*resolution)], vertList[k +((myGcodeWr.printList.size()-1)*resolution)]   );//top
    }
    mesh.addFace(vertList[resolution-1], vertList[0], vertList[vertList.length-2]  ); //bottom


    mesh.addFace(vertList[vertList.length-1], vertList[0+((myGcodeWr.printList.size()-1)*resolution)], vertList[resolution-1+((myGcodeWr.printList.size()-1)*resolution)]   ); //top
  }
}
