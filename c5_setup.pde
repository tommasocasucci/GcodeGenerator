
void c5_setup() {

  // custom settings for interface //////////////////////////////////////////////////////

  color c_white = color(255, 255, 255);
  color c_black = color (25, 25, 25) ;
  color c_grey = color (100, 100, 100);

  c5.setColorBackground(c_white);
  c5.setColorForeground(c_black);
  c5.setColorActive(c_grey);
  c5.setColorLabel(c_white);
  c5.setColorValue(c_white);

  int checkVal = min(dimX - 20, dimY -20);

  //addSlider
  c5.addSlider("resolution")
    .setPosition(60, 160)
      .setSize(200, 10)
        .setRange(10, 200)
          //          .setValue(100)
          ;

  c5.addSlider("radius")
    .setPosition(60, 180)
      .setSize(200, 10)
        .setRange(checkVal/2  *1/3  + 5, checkVal/2 *2/3)
          //          .setValue(0.25)
          ;


  c5.addSlider("waveNum")
    .setPosition(60, 200)
      .setSize(200, 10)
        .setRange(1, 12)
          //          .setValue(0.01)
          ;
//
//  c5.addSlider("noiseTime")
//    .setPosition(60, 220)
//      .setSize(200, 10)
//        .setRange(0, 100)
//          //          .setValue(5)
//          ;



  c5.addSlider("extrWaves")
    .setPosition(60, 220)
      .setSize(200, 10)
        .setRange(0.00, 3.0)
          ////          .setValue(50)
          ;



  c5.addSlider("vaseHeight")
    .setPosition(60, 240)
      .setSize(200, 10)
        .setRange(5, dimZ)
//              .setValue(vaseHeight);

          ;



  c5.addSlider("twist")
    .setPosition(60, 260)
      .setSize(200, 10)
        .setRange(-0.75, 0.75)
          //          .setValue(50)
          ;

  c5.addSlider("R_varTOP")
    .setPosition(60, 280)
      .setSize(200, 10)
        .setRange(-35, 35)
          //          .setValue(50)
          ;

  c5.addSlider("R_varBOTTOM")
    .setPosition(60, 300)
      .setSize(200, 10)
        .setRange(-35, 35)
          //          .setValue(50)
          ;


//  c5.addSlider("R_varTOP")
//    .setPosition(60, 320)
//      .setSize(200, 10)
//        .setRange(-35, 35)
//          //          .setValue(50)
//          ;

//  c5.addSlider("R_varBOTTOM")
//    .setPosition(60, 320)
//      .setSize(200, 10)
//        .setRange(-35, 35)
//          //          .setValue(50)
//          ;


  c5.addSlider("W_varTOP")
    .setPosition(60, 320)
      .setSize(200, 10)
        .setRange(-35, 35)
          //          .setValue(50)
          ;

  c5.addSlider("W_varBOTTOM")
    .setPosition(60, 340)
      .setSize(200, 10)
        .setRange(-35, 35)
          //          .setValue(50)
          ;



  c5.addSlider("R_amplitude")
    .setPosition(60, 360)
      .setSize(200, 10)
        .setRange(0, 25)
          //          .setValue(50)
          ;

  c5.addSlider("R_offset")
    .setPosition(60, 380)
      .setSize(200, 10)
        .setRange(0, 50)
          //          .setValue(50)
          ;

  c5.addSlider("R_frequence")
    .setPosition(60, 400)
      .setSize(200, 10)
        .setRange(0, 5.0)
          //          .setValue(50)
          ;


  c5.addSlider("W_amplitude")
    .setPosition(60, 420)
      .setSize(200, 10)
        .setRange(0, 25)
          //          .setValue(50)
          ;

  c5.addSlider("W_offset")
    .setPosition(60, 440)
      .setSize(200, 10)
        .setRange(0, 50)
          //          .setValue(50)
          ;

  c5.addSlider("W_frequence")
    .setPosition(60, 460)
      .setSize(200, 10)
        .setRange(0, 5.0)
          //          .setValue(50)
          ;





  //addButton
  c5.addButton("closeShape")
    .setPosition(75, 500)
      .setSize(80, 30)
        .setColorBackground(c_black)
          .setColorForeground(c_grey)
            .setColorActive(c_white)
              .setColorLabel(c_white)
                ;


  //addButton
  c5.addButton("showMesh")
    .setPosition(165, 500)
      .setSize(80, 30)
        .setColorBackground(c_black)
          .setColorForeground(c_grey)
            .setColorActive(c_white)
              .setColorLabel(c_white)
                ;



  //addButton
  c5.addButton("showPath")
    .setPosition(120, 540)
      .setSize(80, 30)
        .setColorBackground(c_black)
          .setColorForeground(c_grey)
            .setColorActive(c_white)
              .setColorLabel(c_white)
                ;
}



//  ControlP5 in GUI FUNCTIONS

void checkOverlap() {   
  // avoid rotation by mouse drag when using sliders of ControlP5
//  if (c5.window(this).isMouseOver()) {  // if mouse is over controllers
if(mouseX< 300 || mouseX>width-300){
    cam.setActive(false);               // disable camera mouse controls
  } else {                               
    cam.setActive(true);
  }
}


public void closeShape(int theValue) {
  //add here button behaviour
  closeShape = !closeShape;
}

public void showMesh(int theValue) {
  //add here button behaviour
  showMesh = !showMesh;
}


public void showPath(int theValue) {
  //add here button behaviour
  showPath = !showPath;
}
