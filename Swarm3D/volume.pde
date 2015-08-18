

void computeVolume(){

    
    volume.closeSides();  
    surface.reset();
    surface.computeSurfaceMesh(mesh, ISO_THRESHOLD);
      new LaplacianSmooth().filter(mesh, 1);
      
}


void evaporateTraces(){
      float[] volumeData=volume.getData();   

  for (int z=0,index=0; z<DIMZ; z++) {
    for (int y=0; y<DIMY; y++) {
      for (int x=0; x<DIMX; x++) {
        volumeData[index++] -= 0.0075;
      }
    }
  }
  
}
