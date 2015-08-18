

void initializeGUI() {

  int posX = 50;
  int posY = 50;
  int sliderDist = 15;  

  cP5.addSlider("sep_val", 0, 10.0, sep_val, posX, posY, 150, 10);  //controlP5.addSlider( "name", value, MINvalue, MAXvalue, Xposition, Yposition, Xdimension, Ydimension) 
  cP5.addSlider("coh_val", 0, 0.01, coh_val, posX, posY+sliderDist, 150, 10);   
  cP5.addSlider("ali_val", 0, 1.0, ali_val, posX, posY+sliderDist*2, 150, 10);   

  cP5.addSlider("sep_rad", 0, 100, sep_rad, posX, posY+sliderDist*4, 150, 10);   
  cP5.addSlider("coh_rad", 0, 100, coh_rad, posX, posY+sliderDist*5, 150, 10);   
  cP5.addSlider("ali_rad", 0, 100, ali_rad, posX, posY+sliderDist*6, 150, 10);  


  //define colors
  color c01 = color(120);
  color c02 = color(60);
  color c03 = color(180);

  // custom settings for slider //////////////////////////////////////////////////////
  cP5.setColorBackground(c01);                // slider background color
  cP5.setColorForeground(c02);                // slider bar foreground color
  cP5.setColorActive(c03);                    // slider bar active color
  cP5.setAutoDraw(false);
}



void gui() {
  cam.beginHUD();
  cP5.draw();
  cam.endHUD();


  if (cP5.isMouseOver()) {     
    cam.setActive(false) ;
  } else { 
    cam.setActive(true);
  }
}
