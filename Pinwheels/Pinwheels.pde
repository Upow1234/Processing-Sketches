Pinwheel[] pinwheel = new Pinwheel[4]; //<>//

Parameter triangleSize, triangleRadius, strokeWeight, speed, fillHue, fillSaturation, fillBrightness, fillAlpha, strokeHue, strokeSaturation, 
  strokeBrightness, strokeAlpha, feedbackLevel, addBright, feedbackDelay, slewRate, pinwheelZeroX, pinwheelZeroY, pinwheelOneX, pinwheelOneY,
  pinwheelTwoX, pinwheelTwoY, pinwheelThreeX, pinwheelThreeY;

Parameter[][] pairs;

import org.monome.Monome;
import oscP5.*;

Monome grid;
Monome arc;

int[][] gridLed;
int[][] arcLed;

float point = 0;

float[] centerXdestination = { 100, 200, 300, 400 };
float[] centerYdestination = { 100, 200, 300, 400 };

float[] centerX = {100, 200, 300, 400};
float[] centerY = {100, 200, 300, 400};

int pinwheelSelection = 0;

//0 controls arc encoders 0 and 1, 1 controls encoders 2 and 3
int[] controlSelection = {0, 1};

int[][] controlLeds = {{0, 4}, {0, 6}, {1, 4}, {1, 6}, {2, 4}, {2, 6}, {3, 4}, {3, 6}, {4, 4}, {4, 6}, {5, 4}, {5, 6}, {6, 4}, {6, 6}, {7, 4}, {7, 6}, };

//true feedback variables

PImage[] feedbackBuffer = new PImage[1000];
int feedbackCount = 1;
int feedbackMax;

void setup() {

  size(400, 400, P2D);
  //fullScreen(P2D, 2);

  arc = new Monome(this, "m1100144");
  grid = new Monome(this, "m1000370");

  pinwheel[0] = new Pinwheel(width/2, height/2);
  pinwheel[1] = new Pinwheel((width * 0.25), height/2);
  pinwheel[2] = new Pinwheel((width * 0.75), height/2);
  pinwheel[3] = new Pinwheel((width / 2), (height * 0.25));

  colorMode(HSB);

  triangleSize = new Parameter("triangle size", 0, 360, 10.0, 1, 20);
  triangleRadius = new Parameter("triangle radius", 0, 1000, 1.0, 0, 200);
  strokeWeight = new Parameter("stroke weight", 1, 30, 10.0, 0, 2);
  speed = new Parameter("speed", -20, 20, 100.0, 0, 1);

  fillHue = new Parameter("fill hue", 0, 255, 3.0, 1, 180);
  fillSaturation = new Parameter("fill saturation", 0, 255, 3.0, 0, 255);
  fillBrightness = new Parameter("fill brightness", 0, 255, 3.0, 0, 255);
  fillAlpha = new Parameter("fill alpha", 0, 255, 3.0, 0, 200);

  strokeHue = new Parameter("stroke hue", 0, 255, 3.0, 1, 40);
  strokeSaturation = new Parameter("stroke saturation", 0, 255, 3.0, 0, 255);
  strokeBrightness = new Parameter("stroke brightness", 0, 255, 3.0, 0, 255);
  strokeAlpha = new Parameter("stroke alpha", 0, 255, 3.0, 0, 200);

  feedbackLevel = new Parameter("Feedback Level", 0, 1, 1000, 0, 0);
  addBright = new Parameter("Additional Brightness", 0, 1, 1000, 0, 0);
  feedbackDelay = new Parameter("Feedback Delay", 1, 2, 1, 0, 1); 
  slewRate = new Parameter("slewRate", 0, 1, 1000.0, 0, 1);

  pinwheelZeroX = new Parameter("Pinwheel Zero X", 0, width, 1, 0, 0);
  pinwheelZeroY = new Parameter("Pinwheel Zero Y", 0, height, 1, 0, 0);
  pinwheelOneX = new Parameter("Pinwheel One X", 0, width, 1, 0, 0);
  pinwheelOneY = new Parameter("Pinwheel One Y", 0, height, 1, 0, 0);
  pinwheelTwoX = new Parameter("Pinwheel Two X", 0,  width, 1, 0, 0);
  pinwheelTwoY = new Parameter("Pinwheel Two Y", 0,  height, 1, 0, 0);
  pinwheelThreeX = new Parameter("Pinwheel Three X", 0, width, 1, 0, 0);
  pinwheelThreeY = new Parameter("Pinwheel Three Y", 0, height, 1, 0, 0);


  pairs = new Parameter[][] {{triangleSize, triangleRadius}, {strokeWeight, speed}, {fillHue, fillSaturation}, {fillBrightness, fillAlpha}, 
  {strokeHue, strokeSaturation}, {strokeBrightness, strokeAlpha}, {feedbackLevel, addBright}, {feedbackDelay, slewRate}, {pinwheelZeroX, pinwheelZeroY}, 
 {pinwheelOneX, pinwheelOneY},  {pinwheelTwoX, pinwheelTwoY},  {pinwheelThreeX, pinwheelThreeY}, };

  for (int i = 0; i < feedbackBuffer.length; i++) {
    feedbackBuffer[i] = createImage(width, height, RGB);
  }

  feedbackDelay.setMax(feedbackBuffer.length);

  arcLed = new int[4][64];
  gridLed = new int[8][16];

  delay(1500); //allows time for arc and grid to initialize before initializing leds
  arcDisplayValuesEnc(0, 0, 0);
  arcDisplayValuesEnc(1, 0, 1);
  arcDisplayValuesEnc(2, 1, 0);
  arcDisplayValuesEnc(3, 1, 1);

  gridDisplayArcSelection();
}

void draw() {

  noStroke();
  //fill(0, feedback.value()); //old fake feedback
  //rect(0, 0, width, height);
  background(0, 0, 0);
  feedbackDisplay(feedbackBuffer[feedbackCount]);

  /*
  //slews changes in pinwheel centers
   for (int i = 0; i <= 3; i++) {
   centerX[i] = slew(centerXdestination[i], centerX[i]);
   centerY[i] = slew(centerYdestination[i], centerY[i]);
   }
   */
  //increments point
  point = ((point + speed.value()) % 360);



  strokeWeight(constrain(strokeWeight.value(), 0, 200));
  stroke(strokeHue.value(), strokeSaturation.value(), strokeBrightness.value(), strokeAlpha.value());

  pinwheel[0].create(point, pinwheelZeroX.valueInt(), pinwheelZeroY.valueInt());
  pinwheel[1].create(point, pinwheelOneX.valueInt(), pinwheelOneY.valueInt());
  pinwheel[2].create(point, pinwheelTwoX.valueInt(), pinwheelTwoY.valueInt());
  pinwheel[3].create(point, pinwheelThreeX.valueInt(), pinwheelThreeY.valueInt());

  feedbackCapture(feedbackBuffer[feedbackCount]);
  feedbackCount = ((feedbackCount + 1) % feedbackDelay.valueInt());
}

float slew (float destination, float displayed) {

  if (destination > displayed) {

    displayed = displayed + slewRate.value();
  }

  if (destination < displayed) {

    displayed = displayed + (slewRate.value() * -1);
  } 

  return displayed;
}

//Feedback Functions

void feedbackDisplay(PImage output) {

  tint(255, (255 * (feedbackLevel.value() + addBright.value()))); 
  image(output, 0, 0);
}


void feedbackCapture(PImage output) {
  loadPixels();
  output.loadPixels();

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {

      int location = x + (y * width);

      output.pixels[location] = pixels[location];
    }
  }

  output.updatePixels();
  updatePixels();
}