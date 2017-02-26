void keyPressed( ) {

  String timestamp;  
  timestamp = year() + nf(month(), 2) + nf(day(), 2) + "_"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2)+ "_";

  if (key == 'g' || key == 'G') {
    myGcodeWr.exportGcode("exportData/"+timestamp+"3DshapeGcode.gcode");
  }
  
  if (key == 's' || key == 'S') {
    saveFrame("screenshots/"+timestamp+"screenshot.jpg");
    println("Screenshot saved!");
  }

   if (key == 'm' || key == 'M')   mesh.saveAsSTL(sketchPath(timestamp+"vaseGenerator.stl"));

}
