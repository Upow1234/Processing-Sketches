import org.monome.Monome;
import oscP5.*;

Monome grid;
Monome arc;

int[][] gridLed;
int[][] arcLed;

int[] controlSelection = {0, 1};

//above is all stuff for grid and arc
Parameter colorSpeed = new Parameter("Color Speed", 0.2, 10, 100, 0, 1);
Parameter colorRandomness = new Parameter("Color Randomness", 0, 360, 1, 0, 0);
Parameter locationRandomness = new Parameter("Location Randomness", 0, 2000, 1, 0, 0);
Parameter rotationSpeed = new Parameter("Rotation Speed", 0, 50, 100, 0, 0);
Parameter colorMin = new Parameter("Color Minimum", 0, 360, 1, 1, 0);
Parameter colorDistance = new Parameter("Color Distance", 1, 360, 1, 0, 0);
Parameter rotationAngle = new Parameter("Rotation Angle", 0, 360, 4, 1, 0);
Parameter zoom = new Parameter("Zoom", 1, 10, 100, 0, 1);

Parameter[][] pairs = {{colorMin, colorDistance}, {colorRandomness, locationRandomness}, {colorSpeed, rotationSpeed}, {zoom, rotationAngle}};

//above is all stuff for arc parameters

float baseColorOffset = 0;

void setup() {

  arc = new Monome(this, "m1100144");
  grid = new Monome(this, "m1000370");

  arcLed = new int[4][64];
  gridLed = new int[8][16];

  //size(400, 400, P3D);
  fullScreen(P3D, 2);
  colorMode(HSB, 360, 255, 255);

  delay(1500); //allows time for arc and grid to initialize before initializing leds
  arcDisplayValuesEnc(0, 0, 0);
  arcDisplayValuesEnc(1, 0, 1);
  arcDisplayValuesEnc(2, 1, 0);
  arcDisplayValuesEnc(3, 1, 1);

  gridDisplayArcSelection();
}

void draw() {
  background(0, 0, 0);

  int[] colorArray = new int[colorDistance.valueInt() * 2];

  for (int colUp = 0, colDown = 0; colUp < colorDistance.valueInt(); colUp++, colDown++) {
    colorArray[colUp] = colorMin.valueInt() + colUp;
    colorArray[(colorArray.length - 1) - colDown] = colorMin.valueInt() + colDown;
  }

  pushMatrix();
  translate(width/2, height/2);
  
  scale(zoom.value());
  rotateZ(radians(rotationAngle.value()));

  for (int i = 0, k = int(baseColorOffset); i < colorArray.length; i++, k++) {
    int locationOffset = width;
    
    stroke(colorArray[k % colorArray.length] + int(random(-colorRandomness.value(), colorRandomness.value())), 255, 255);
    
    for (int j = 0; j < width + locationOffset; j = j + colorArray.length) {
      line((i + (j + int(random(-locationRandomness.value(), locationRandomness.value()))) - locationOffset), 0 - locationOffset, (i + (j + int(random(-locationRandomness.value(), locationRandomness.value()))) - locationOffset), height + locationOffset);
    }
  }

  popMatrix();

  rotationAngle.setValueFloat((rotationAngle.value() + rotationSpeed.value()) % 360); //could this be modified so the rotation angle ring spins?
  baseColorOffset = baseColorOffset + colorSpeed.value();
}
