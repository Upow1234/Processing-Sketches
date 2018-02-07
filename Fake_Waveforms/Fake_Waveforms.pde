//this comment is just to test git push problem I'm having 

import processing.sound.*;
import org.monome.Monome;
import oscP5.*;

//parameter and monome variables

Parameter hueLevel, hueDeviation, saturationLevel, saturationDeviation, brightnessLevel, 
  brightnessDeviation, alphaLevel, alphaDeviation, rotationZero, rotationOne, rotationTwo, 
  rotationThree, feedbackLevel, addBright, feedbackDelay, masterRotation, scale, dummy;

Parameter[][] pairs;

import org.monome.Monome;
import oscP5.*;

Monome grid;
Monome arc;

int[][] gridLed;
int[][] arcLed;

//0 controls arc encoders 0 and 1, 1 controls encoders 2 and 3
int[] controlSelection = {0, 1};

//end parameter and monome variables

FakeWaveform[] faker = new FakeWaveform[4]; //don't change the number or you'll break everything

AudioIn input;
Amplitude rms;

//float scale=1;

PImage[] feedbackBuffer = new PImage[1000];
int feedbackCount = 1;
int feedbackMax;
//int feedbackDelay = 2;

//float feedbackLevel = 0;

//float addBright;

void setup() {

  //size(400, 400, P3D);
  fullScreen(P3D, 2); 
  colorMode(HSB, 360, 255, 255, 255);

  for (int i = 0; i < faker.length; i++) {
    faker[i] = new FakeWaveform();
  }

  for (int i = 0; i < feedbackBuffer.length; i++) {
    feedbackBuffer[i] = createImage(width, height, RGB);
  }

  hueLevel = new Parameter("Hue Level", 0, 360, 5, 1, 0);
  hueDeviation = new Parameter("Hue Deviation", 0, 360, 5, 0, 0);
  saturationLevel = new Parameter("Saturation Level", 0, 255, 5, 0, 255);
  saturationDeviation = new Parameter("Saturation Deviation", 0, 255, 5, 0, 0);
  brightnessLevel = new Parameter("Brightness Level", 0, 255, 5, 0, 255);
  brightnessDeviation = new Parameter("Brightness Deviation", 0, 255, 5, 0, 0);
  alphaLevel = new Parameter("Alpha Level", 0, 255, 5, 0, 0);
  alphaDeviation = new Parameter("Alpha Devitation", 0, 255, 5, 0, 0);
  rotationZero = new Parameter("Rotation Zero", 0, 360, 5, 1, 0);
  rotationOne = new Parameter("Rotation One", 0, 360, 5, 1, 0);
  rotationTwo = new Parameter("Rotation Two", 0, 360, 5, 1, 0);
  rotationThree = new Parameter("Rotation Three", 0, 360, 5, 1, 0);
  feedbackLevel = new Parameter("Feedback Level", 0, 1, 1000, 0, 0);
  addBright = new Parameter("Additional Brightness", 0, 1, 1000, 0, 0);
  feedbackDelay = new Parameter("Feedback Delay", 1, feedbackBuffer.length, 1, 0, 1); 
  masterRotation = new Parameter("Master Rotation", 0, 360, 5, 1, 0);
  scale = new Parameter("Scale", 0, 1, 1000, 0, 0);
  dummy = new Parameter("Dummy", 0, 1, 1000, 0, 0);

  pairs = new Parameter[][] {{hueLevel, hueDeviation}, {saturationLevel, saturationDeviation}, 
    {brightnessLevel, brightnessDeviation}, {alphaLevel, alphaDeviation}, 
    {rotationZero, rotationOne}, {rotationTwo, rotationThree}, {feedbackLevel, addBright}, 
    {feedbackDelay, masterRotation}, {scale, dummy}};

  feedbackDelay.setMax(feedbackBuffer.length);

  arc = new Monome(this, "m1100144");
  grid = new Monome(this, "m1000370");

  arcLed = new int[4][64];
  gridLed = new int[8][16];

  delay(1500); //allows time for arc and grid to initialize before initializing leds
  arcDisplayValuesEnc(0, 0, 0);
  arcDisplayValuesEnc(1, 0, 1);
  arcDisplayValuesEnc(2, 1, 0);
  arcDisplayValuesEnc(3, 1, 1);

  gridDisplayArcSelection();

  //Create an Audio input and grab the 1st channel
  input = new AudioIn(this, 0);

  // start the Audio Input
  input.start();

  // create a new Amplitude analyzer
  rms = new Amplitude(this);

  // Patch the input to an volume analyzer
  rms.input(input);
}

void draw() {

  background(0, 0, 0);

  feedbackDisplay(feedbackBuffer[feedbackCount]);

  // adjust the volume of the audio input
  input.amp(1);

  // rms.analyze() return a value between 0 and 1. To adjust
  // the scaling and mapping of an ellipse we scale from 0 to 0.5
  float volumeLevel = rms.analyze();
  noStroke();

  for (int i = 0; i < faker.length; i++) {
    int tempRotationArray[] = new int[] {rotationZero.valueInt(), rotationOne.valueInt(), 
      rotationTwo.valueInt(), rotationThree.valueInt()}; //HARD CODED! BAD OOP!

    int tempHue = hueLevel.valueInt() + int(random((-1 * hueDeviation.valueInt()), hueDeviation.valueInt()));
    int tempSaturation = saturationLevel.valueInt() + int(random((-1 * saturationDeviation.valueInt()), saturationDeviation.valueInt()));
    int tempBrightness = brightnessLevel.valueInt() + int(random((-1 * brightnessDeviation.valueInt()), brightnessDeviation.valueInt()));
    int tempAlpha = alphaLevel.valueInt() + int(random((-1 * alphaDeviation.valueInt()), alphaDeviation.valueInt()));

    faker[i].drawWaveform((volumeLevel * scale.value()), tempRotationArray[i], tempHue, tempSaturation, tempBrightness, tempAlpha);
  }

  feedbackCapture(feedbackBuffer[feedbackCount]);
  feedbackCount = ((feedbackCount + 1) % feedbackDelay.valueInt());
}

class FakeWaveform {

  int widthOffset = width;
  int heightOffset = height/2;
  int rotationAngle;

  FakeWaveform () {
  }

  void drawWaveform(float waveformSize, int tempRotationAngle, int tempHue, int tempSaturation, int tempBrightness, int tempAlpha) {

    float randomSize = 2000 * waveformSize;

    pushMatrix();

    translate(width/2, height/2);
    rotateZ(radians(tempRotationAngle));
    rotateZ(radians(masterRotation.valueInt()));

    stroke(tempHue, tempSaturation, tempBrightness, tempAlpha); 

    for (int i = 0 - widthOffset; i < width + widthOffset; i++) {
      line(i, height/2 - heightOffset, i, (height/2 - heightOffset) + int(random(-randomSize, randomSize)));
    }
    popMatrix();
  }
}
