class Vec3G extends Vec3D {
  float extr = 1.0 ;
  int extrSpeed = 400;


  Vec3G(float _x, float _y, float _z) {
    super(_x, _y, _z);
  }

  Vec3G(float _x, float _y, float _z, float _extr, int _extrSpeed) {
    super(_x, _y, _z);
    extr = _extr;
    extrSpeed = _extrSpeed;
  }


  Vec3G copyV3G() {
    Vec3G v01 = new Vec3G(x, y, z, extr, extrSpeed);
    return v01;
  }

  void roundV3G(int decPos) {
    x = round( x * pow(10, decPos)) / pow(10, decPos); 
    y = round( y * pow(10, decPos) ) / pow(10, decPos); 
    z = round( z * pow(10, decPos) ) / pow(10, decPos);
  }
}
