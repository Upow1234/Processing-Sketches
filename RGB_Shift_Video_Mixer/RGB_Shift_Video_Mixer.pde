import processing.video.*;
import org.monome.Monome;
import oscP5.*;

Monome grid;
Monome arc;

int[][] gridLed;
int[][] arcLed;

int[] controlSelection = {0, 1};

//above is all stuff for grid and arc
Parameter redOffsetX = new Parameter("Red Offset X", -640, 640, 1, 0, 0);
Parameter redOffsetY = new Parameter("Red Offset Y", -480, 480, 1, 0, 0);
Parameter greenOffsetX = new Parameter("Green Offset X", -640, 640, 1, 0, 0);
Parameter greenOffsetY = new Parameter("Green Offset Y", -480, 480, 1, 0, 0);
Parameter blueOffsetX = new Parameter("Blue Offset X", -640, 640, 1, 0, 0);
Parameter blueOffsetY = new Parameter("Blue Offset Y", -480, 480, 1, 0, 0);
Parameter feedbackLevel = new Parameter("Feedback Level", 0, 1, 1000, 0, 1);
Parameter feedbackDelay = new Parameter("Feedback Delay", 1, 10, 1, 0, 1);
Parameter videoSpeed = new Parameter("Video Speed", -2, 2, 100, 0, 1);


Parameter[][] pairs = {{redOffsetX, redOffsetY}, {greenOffsetX, greenOffsetY}, {blueOffsetX, blueOffsetY}, {feedbackLevel, feedbackDelay}, {videoSpeed, videoSpeed}};

//above is all stuff for arc parameters

Movie video;
PImage outputImage;

//int redOffsetX = 0;
//int redOffsetY = 0;

//int greenOffsetX = 0;
//int greenOffsetY = 0;

//int blueOffsetX = 0;
//int blueOffsetY = 0;

float[] redBuffer;
float[] greenBuffer;
float[] blueBuffer;

PImage[] feedbackBuffer = new PImage[1000];
int feedbackCount = 1;
int feedbackMax;

//float feedbackLevel = 0;

float baseRed = 200;
float depthRed = 0;
float baseGreen = 100;
float depthGreen = 0;
float baseBlue = 255;
float depthBlue = 0;

void setup() {
  size(640, 480);

  video = new Movie(this, "7529.MOV"); 
  video.loop();

  outputImage = createImage(width, height, RGB);
  redBuffer = new float[width * height];
  greenBuffer = new float[width * height];
  blueBuffer = new float[width * height];

  for (int i = 0; i < feedbackBuffer.length; i++) {
    feedbackBuffer[i] = createImage(width, height, RGB);
  }

  feedbackMax = feedbackBuffer.length;
  feedbackDelay.setMax(feedbackMax);

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
}


void movieEvent(Movie movie) {
  movie.read();
}
void draw() {

  //feedbackLevel = map(mouseX, 0, width, 0, 1);
  //feedbackMax = int(map(mouseY, 0, height, 1, feedbackBuffer.length));

  video.speed(videoSpeed.value());

  rgbSeperate(video, outputImage);
  rgbCombine(outputImage);

  tint(255, 255 * feedbackLevel.value());
  feedbackDisplay(feedbackBuffer[feedbackCount]);

  image(outputImage, 0, 0);

  feedbackCapture(feedbackBuffer[feedbackCount]);
  feedbackCount = feedbackCount % feedbackDelay.valueInt();
}

void rgbSeperate(Movie input, PImage output) {

  input.loadPixels();
  output.loadPixels();


  for (int x = 0; x < video.width; x++) {
    for (int y = 0; y < video.height; y++) {

      int loc = x + y * video.width;

      float r, g, b;

      redBuffer[loc] = red(input.pixels[loc]);
      greenBuffer[loc] = green(input.pixels[loc]);
      blueBuffer[loc] = blue(input.pixels[loc]);
    }
  }
}

void rgbCombine(PImage output) {

  output.loadPixels();

  for (int x = 0; x < video.width; x++) {
    for (int y = 0; y < video.height; y++) {

      int loc = x + y * video.width;

      float r = 0;
      float g = 0;
      float b = 0;

      r = colorThing(x, y, redOffsetX.valueInt(), redOffsetY.valueInt(), redBuffer);
      g = colorThing(x, y, greenOffsetX.valueInt(), greenOffsetY.valueInt(), greenBuffer);
      b = colorThing(x, y, blueOffsetX.valueInt(), blueOffsetY.valueInt(), blueBuffer);

      r = colorBaseDepth(r, baseRed, depthRed);
      g = colorBaseDepth(g, baseGreen, depthGreen);
      b = colorBaseDepth(b, baseBlue, depthBlue);

      output.pixels[loc] = color(r, g, b);
    }
  }

  output.updatePixels();
}

float colorThing(int x, int y, int offsetX, int offsetY, float[] bufferName ) {

  int tempX = 0;
  int tempY = 0;

  int tempLoc;

  if (offsetX != 0 && offsetY != 0) {

    if (((x > offsetX) && (x < (offsetX + width))) && ((y > offsetY) && (y < (offsetY + height)))) {

      tempX = x - offsetX;

      tempY = y - offsetY;

      tempLoc = (tempX + (tempY * width));

      return bufferName[tempLoc];
    } else {

      return 0;
    }
  } else if (offsetX != 0) {

    if ((x > offsetX) && (x < (offsetX + width))) {

      tempX = x - offsetX;

      tempLoc = (tempX + (y * width));

      return bufferName[tempLoc];
    } else {

      return 0;
    }
  } else if (offsetY != 0) {

    if ((y > offsetY) && (y < (offsetY + height))) {

      tempY = y - offsetY;

      tempLoc = (x + (tempY * width));

      return bufferName[tempLoc];
    } else {

      return 0;
    }
  } else {
    return bufferName[x + (y * width)];
  }
}

float colorBaseDepth(float input, float base, float depth) {

  return input = (input * ((depth * -1) + 1)) + (base * depth);
}

void feedbackDisplay(PImage output) {
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