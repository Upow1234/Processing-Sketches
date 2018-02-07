class Pinwheel {

  float centerXXX;
  float centerYYY;

  Pinwheel (float x, float y) {
    centerXXX = x;
    centerYYY = y;
  }


  void create(float x, float centerXXX, float centerYYY) {
    pushMatrix();
    translate(centerXXX, centerYYY);
    for (int i = 0, deg = 0; i <= 7; i = i + 1, deg = deg + 45) {

      fill(fillHue.value(), fillSaturation.value(), fillBrightness.value(), fillAlpha.value());
      triangle((cos(radians((x + deg) % 360)) * (triangleRadius.value())), (sin(radians((x + deg) % 360)) * (triangleRadius.value())), 0, 0, (cos(radians(((x + deg) % 360)+triangleSize.value())) * (triangleRadius.value())), (sin(radians(((x + deg) % 360)+triangleSize.value())) * (triangleRadius.value())));
   
  }
    popMatrix();
  }
}