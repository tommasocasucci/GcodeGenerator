

void gui() {

  cam.beginHUD();                               //  resets camera to 2D plan view

  c5.draw();                                         //  draws 2D ControlP5 interface

  pushStyle();
  textAlign(CENTER);
  //    and some text as well...
  strokeWeight(0.5);
  fill(255);  
  textFont(font02, 25);
  text(" G-code generator ", 175, 110);

  textFont(font03, 10);
  text("Gcode exporter for Processing", 175, 120);

  text("__________________________________________________", 175, 125);
  text("__________________________________________________", 175, 600);

  textAlign(LEFT);

  textFont(font04, 12);
  text("[G] export G-code", 60, 615 );
//  text("[D] show Petri dish", 60, 380 );
//  text("[O] show origin", 60, 390 );
//  text("[R] start/stop rotation", 60, 400 );
  text("[S] save screenshot", 60, 630 );
//  text("[V] start/stop video recording", 60, 420 );

  popStyle();
  
  
//  strokeWeight(2 );
//  stroke(255);
//  line (300,0, 300, height);

  //circle button
  pushStyle();
  noStroke();

  ellipseMode(CENTER); 

  float testDist_01 = circleButton_01.distanceTo(new Vec3D(mouseX, mouseY, 0));

  if (testDist_01<buttonRadius_01) {
    fill(150);
    ellipse(circleButton_01.x, circleButton_01.y, buttonRadius_01*2, buttonRadius_01*2 );
  } else {
    fill(0); 
    ellipse(circleButton_01.x, circleButton_01.y, buttonRadius_01*2, buttonRadius_01*2 );
  }


  float testDist_02 = circleButton_02.distanceTo(new Vec3D(mouseX, mouseY, 0));

  if (testDist_02<buttonRadius_01) {
    fill(150);
    ellipse(circleButton_02.x, circleButton_02.y, buttonRadius_02*2, buttonRadius_02*2 );
  } else {
    fill(0); 
    ellipse(circleButton_02.x, circleButton_02.y, buttonRadius_02*2, buttonRadius_02*2 );
  }


  popStyle();



  textFont(font01, 25);
  textAlign(CENTER);

  text("G-code ", circleButton_01.x+3, circleButton_01.y+7);
  text(".obj", circleButton_02.x, circleButton_02.y+5);


  textFont(font03, 10);
  text("__________________________________________________", circleButton_01.x+3, circleButton_01.y+105);

  textAlign(RIGHT);
  textFont(font04, 12);
  text("extrusion lenght(cm): ", circleButton_01.x+3, circleButton_01.y+130);
  text("extrusion weight(gr): ", circleButton_01.x+3, circleButton_01.y+160);
  text("extrusion price(Euro): ", circleButton_01.x+3, circleButton_01.y+190);

  textAlign(LEFT);
  textFont(font01, 25);
  //  if (myGcodeWr.extrusion == 0.0) {
  //    text( " -- ", circleButton.x+3, circleButton.y+130);
  //    text(" -- ", circleButton.x+3, circleButton.y+160);
  //    text(" -- ", circleButton.x+3, circleButton.y+190);
  //  } else {
  text( nfc(myGcodeWr.extrEval/10, 2), circleButton_01.x+3, circleButton_01.y+130);
  text( nfc(myGcodeWr.extrusionWeight, 2), circleButton_01.x+3, circleButton_01.y+160);
  text( nfc(myGcodeWr.extrusionPrice, 2), circleButton_01.x+3, circleButton_01.y+190);
  //  }

  textAlign(CENTER);
  textFont(font03, 10);
  text("__________________________________________________", circleButton_01.x+3, circleButton_01.y+205);

  textFont(font04, 12);
  text(" push G-code button to refresh the values! ", circleButton_01.x+3, circleButton_01.y+220);

  cam.endHUD();                                      // restores current camera matrix
}


void mouseClicked() {

  if (mouseButton == LEFT) {
    float testDist_01 = circleButton_01.distanceTo(new Vec3D(mouseX, mouseY, 0));
    float testDist_02 = circleButton_02.distanceTo(new Vec3D(mouseX, mouseY, 0));
    String timestamp = year() + nf(month(), 2) + nf(day(), 2) + "_"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2)+ "_";

    if (testDist_01<buttonRadius_01) {
      myGcodeWr.exportGcode("exportData/"+timestamp+"3DshapeGcode.gcode");
    }

    if (testDist_02<buttonRadius_02) {
      mesh.saveAsSTL(sketchPath(timestamp+"vaseGenerator.stl"));
    }
  }
}  
