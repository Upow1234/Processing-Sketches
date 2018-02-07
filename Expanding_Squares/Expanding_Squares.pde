//there is a bug, cannot make this work in HSB color space

import org.monome.Monome;
import oscP5.*;

Monome grid;
Monome arc;

int[][] gridLed;
int[][] arcLed;

int[] controlSelection = {0, 1};

//above is all stuff for grid and arc
Parameter feedbackLevel, addBright, feedbackDelay, numberOfSquares, vertex0X, vertex0Y, vertex1X, vertex1Y, vertex2X, vertex2Y, vertex3X, vertex3Y, redValue, redDeviation, greenValue, greenDeviation, blueValue, blueDeviation, speed, speedDeviation; 

Parameter[][] pairs; 

//above is all stuff for arc parameters

Square[] square;

PImage[] feedbackBuffer = new PImage[1000];
int feedbackCount = 1;
int feedbackMax;

int widthOffset;
int heightOffset;

void setup() {
  //size(200, 200, P2D);
  fullScreen(P2D, 2);
  rectMode(CENTER);

  square = new Square[15]; 

  feedbackLevel = new Parameter("Feedback Level", 0, 1, 1000, 0, 0);
  addBright = new Parameter("Additional Brightness", 0, 1, 1000, 0, 0);
  feedbackDelay = new Parameter("Feedback Delay", 1, 2, 1, 0, 1); 
  numberOfSquares = new Parameter("Number of Squares", 0, square.length, 10, 0, 0);
  vertex0X = new Parameter("Vertex 0 X Location", 0, width, 1, 0, 0); 
  vertex0Y = new Parameter("Vertex 0 Y Location", 0, height, 1, 0, 0);
  vertex1X = new Parameter("Vertex 1 X Location", 0, width, 1, 0, 0); 
  vertex1Y = new Parameter("Vertex 1 Y Location", 0, height, 1, 0, height);
  vertex2X = new Parameter("Vertex 2 X Location", 0, width, 1, 0, width);
  vertex2Y = new Parameter("Vertex 2 Y Location", 0, height, 1, 0, height);
  vertex3X = new Parameter("Vertex 3 X Location", 0, width, 1, 0, width); 
  vertex3Y = new Parameter("Vertex 3 Y Location", 0, height, 1, 0, 0);
  redValue = new Parameter("Red Value", 0, 255, 4, 0, 0);
  redDeviation = new Parameter("Red Deviation", 0, 255, 4, 0, 0);
  greenValue = new Parameter("Green Value", 0, 255, 4, 0, 0);
  greenDeviation = new Parameter("Green Deviation", 0, 255, 4, 0, 0);
  blueValue = new Parameter("Blue Value", 0, 255, 4, 0, 0);
  blueDeviation = new Parameter("Blue Deviation", 0, 255, 4, 0, 0);  
  speed = new Parameter("Speed", 0, 20, 100, 0, 20);
  speedDeviation = new Parameter("Speed Deviation", 1, 5, 100, 0, 1);

  pairs = new Parameter[][] {{feedbackLevel, addBright}, {feedbackDelay, numberOfSquares}, {redValue, redDeviation}, {greenValue, greenDeviation}, {blueValue, blueDeviation}, {speed, speedDeviation}, {vertex0X, vertex0Y}, {vertex3X, vertex3Y}, {vertex1X, vertex1Y}, {vertex2X, vertex2Y}};

  widthOffset = width/2;
  heightOffset = height/2;

  PShape basicSquare = createShape();

  basicSquare.beginShape();
  basicSquare.stroke(0, 0, 0, 0);
  basicSquare.vertex(0 - widthOffset, 0 - heightOffset);
  basicSquare.vertex(0 - widthOffset, (height) - heightOffset);
  basicSquare.vertex((width) - widthOffset, (height) - heightOffset);
  basicSquare.vertex((width) - widthOffset, 0 - heightOffset);
  basicSquare.endShape(CLOSE);

  for (int i = 0; i < square.length; i++) {
    square[i] = new Square(basicSquare, redValue.valueInt(), greenValue.valueInt(), blueValue.valueInt(), int(random(0, width)), int(random(0, height)), speed.value());
  }


  for (int i = 0; i < feedbackBuffer.length; i++) {
    feedbackBuffer[i] = createImage(width, height, RGB);
  }

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

  feedbackDelay.setMax(feedbackBuffer.length);
}

void draw() {
  background(0, 0, 0);

  feedbackDisplay(feedbackBuffer[feedbackCount]);

  for (int i = 0; i < square.length; i++) {

    square[i].changeVertex(0, vertex0X.valueInt() - widthOffset, vertex0Y.valueInt() - heightOffset); 
    square[i].changeVertex(1, vertex1X.valueInt() - widthOffset, vertex1Y.valueInt() - heightOffset); 
    square[i].changeVertex(2, vertex2X.valueInt() - widthOffset, vertex2Y.valueInt() - heightOffset); 
    square[i].changeVertex(3, vertex3X.valueInt() - widthOffset, vertex3Y.valueInt() - heightOffset);

    int redTemp = redValue.valueInt() + int(random(-1 * redDeviation.value(), redDeviation.value()));
    int greenTemp = greenValue.valueInt() + int(random(-1 * greenDeviation.value(), greenDeviation.value()));
    int blueTemp = blueValue.valueInt() + int(random(-1 * blueDeviation.value(), blueDeviation.value()));
    float speedTemp = speed.value() * random(1 / speedDeviation.value(), 1 * speedDeviation.value()); 
    int xLocationTemp = int(random(0, width));
    int yLocationTemp = int(random(0, height));
   
    if(i < numberOfSquares.valueInt()) {
      square[i].redrawOnOff(1);
    } else {
      square[i].redrawOnOff(0);
    }

    if(square[i].activeCheck() == 0) {
    square[i].setParameters(redTemp, greenTemp, blueTemp, speedTemp, 1, xLocationTemp, yLocationTemp);
        } else if(square[i].activeCheck() == 1) {
    square[i].drawSquare(redTemp, greenTemp, blueTemp, speedTemp);
    }
  }

  //println("frame rate = " + frameRate);

  feedbackCapture(feedbackBuffer[feedbackCount]);
  feedbackCount = ((feedbackCount + 1) % feedbackDelay.valueInt());
}

//Square Class

class Square {

  PShape shape;
  float size = 0;
  int redLocal;
  int greenLocal;
  int blueLocal;
  int xLocation;
  int yLocation;
  float speed;

  int activeFlag = 0;
  int redrawState = 0;

  Square(PShape tempShape, int tempRed, int tempGreen, int tempBlue, int tempXLocation, int tempYLocation, float tempSpeed) {

    shape = tempShape;
    redLocal = tempRed;
    greenLocal = tempGreen;
    blueLocal = tempBlue;
    xLocation = tempXLocation;
    yLocation = tempYLocation;
    speed = tempSpeed;
  }

  int activeCheck() {
    return activeFlag;
  }

  void drawSquare(int redTemp, int greenTemp, int blueTemp, float speedTemp) {

      float a = map(size, 0, 1, 255, 0) * ((feedbackLevel.value() * -1) + 1); 

      shape.setFill(color(redLocal, greenLocal, blueLocal, a));

      pushMatrix();
      translate(xLocation, yLocation);
      scale(size);
      shape(shape);
      popMatrix();

      if (size >= 1) {
        if(redrawState == 1){ 
        size = 0;
        activeFlag = 0;
        }
      } else {
        size = size + (speed / 1000);
      }
       
  }

  void changeVertex(int index, int x, int y) {
    shape.setVertex(index, x, y);
  }
  
  void setParameters(int redTemp, int greenTemp, int blueTemp, float speedTemp, int activeFlagTemp, int xLocationTemp, int yLocationTemp) {
      redLocal = redTemp;
      greenLocal = greenTemp;
      blueLocal = blueTemp;
      speed = speedTemp;
      activeFlag = 1;
      xLocation = xLocationTemp;
      yLocation = yLocationTemp;
  }

  void redrawOnOff(int redrawStateTemp){
    redrawState = redrawStateTemp;
  } 

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

//Monome Functions

//arc input
public void delta(int n, int d) {

  if (n == 0) {
    pairs[controlSelection[0]][0].change(d);
    arcDisplayValuesEnc(0, 0, 0);
  }

  if (n == 1) {
    pairs[controlSelection[0]][1].change(d);
    arcDisplayValuesEnc(1, 0, 1);
  }

  if (n == 2) {
    pairs[controlSelection[1]][0].change(d);
    arcDisplayValuesEnc(2, 1, 0);
  }

  if (n == 3) {
    pairs[controlSelection[1]][1].change(d);
    arcDisplayValuesEnc(3, 1, 1);
  }
}

//grid input
public void key(int x, int y, int n) {
  //x is horizontal y is vertical

  //columns seletion for arc control selection

  int[] columns = { 0, 1, 2, 3 };

  //arc control selection
  if (((x >= columns[0]) && (x <= columns[3])) && (n == 1)) {

    if (x == columns[0]) {
      int scaleX = 0;
      if ((scaleX + (y * 2)) < pairs.length) {
        controlSelection[0] = scaleX + (y * 2);
        
        arcDisplayValuesEnc(0, 0, 0);
        arcDisplayValuesEnc(1, 0, 1);
      }

      println("controlSelection[0] = " + controlSelection[0]);
    }

    if (x == columns[2]) {
      int scaleX = 1;
      if ((scaleX + (y * 2)) < pairs.length) {
        controlSelection[0] = scaleX + (y * 2);
        
        arcDisplayValuesEnc(0, 0, 0);
        arcDisplayValuesEnc(1, 0, 1);
      }

      //println("scaleX = " + scaleX);
      println("controlSelection[0] = " + controlSelection[0]);
    }

    if (x == columns[1]) {
      int scaleX = 0;
      if ((scaleX + (y * 2)) < pairs.length) {
        controlSelection[1] = scaleX + (y * 2);
        
        arcDisplayValuesEnc(2, 1, 0);
        arcDisplayValuesEnc(3, 1, 1);
      }

      println("controlSelection[1] = " + controlSelection[1]);
    }

    if (x == columns[3]) {
      int scaleX = 1;
      if ((scaleX + (y * 2)) < pairs.length) {
        controlSelection[1] = scaleX + (y * 2);
        
        arcDisplayValuesEnc(2, 1, 0);
        arcDisplayValuesEnc(3, 1, 1);
      }

      //println("scaleX = " + scaleX);
      println("controlSelection[1] = " + controlSelection[1]);
    }

    gridDisplayArcSelection();
  }
}

void gridDisplayArcSelection () {
  int[][] controlLeds = {{0, 0}, {0, 2}, {1, 0}, {1, 2}, {2, 0}, {2, 2}, {3, 0}, {3, 2}, {4, 0}, {4, 2}, {5, 0}, {5, 2}, {6, 0}, {6, 2}, {7, 0}, {7, 2}, };

  for (int i = 0; i < 8; i++) {
    for (int k = 0; k < 16; k++) {
      gridLed[i][k] = 0;
    }
  }

  //selection for arc control

  gridLed[controlLeds[controlSelection[0]][0]][controlLeds[controlSelection[0]][1]] = 15;
  gridLed[controlLeds[controlSelection[0]][0]][controlLeds[controlSelection[0]][1] + 1] = 15;
  gridLed[controlLeds[controlSelection[1]][0]][controlLeds[controlSelection[1]][1]] = 7;
  gridLed[controlLeds[controlSelection[1]][0]][controlLeds[controlSelection[1]][1] + 1] = 7;

  grid.refresh(gridLed);
}

void arcDisplayValuesEnc (int encoderNumber, int pairSelectionZero, int pairSelectionOne) { 
  for (int i = 0; i < arcLed[encoderNumber].length; i++) {
    arcLed[encoderNumber][i] = 0;
  }

  //arc led values
  for (int i = 0; i <= pairs[controlSelection[pairSelectionZero]][pairSelectionOne].arcLeds(); i++ ) {
    arcLed[encoderNumber][i] = 15;
  }
  arc.refresh(encoderNumber, arcLed[encoderNumber]);
}

//Parameter Class

class Parameter{

  //boundMode 0 is constrain boundMode 1 is wrap

  String name;
  float min;
  float max;
  float scale;
  int boundMode;

  float storedValue = 0;
  float defaultValue;

  int arcValue;

  Parameter (String nameTemp, float minTemp, float maxTemp, float scaleTemp, int boundModeTemp, float valueTemp) {
    name = nameTemp;
    min = minTemp;
    max = maxTemp;
    scale = scaleTemp;
    boundMode = boundModeTemp;
    storedValue = valueTemp;
    defaultValue = valueTemp;

    arcValue = int(map(storedValue, min, max, 0, 63));
  }

  float value () {

    if (boundMode == 1) {
      return boundWrap(storedValue);
    } else { 
      return storedValue;
    }
  }
  
  int valueInt () {
    
    if (boundMode == 1) {
      return int(boundWrap(storedValue));
    } else { 
      return int(storedValue);
    }
  }

  void change(float delta) {
    if (boundMode == 0) {
      storedValue = constrain((storedValue + (delta / scale)), min, max);
    } else {
      if (storedValue < 0) {
        storedValue = max;
      }
      storedValue = (storedValue + (delta / scale));
    }
    println(name + " = " + storedValue);
    
    arcValue = int(map(storedValue, min, max, 0, 63));
    
  }
  
  void setValueFloat(float value) {
   storedValue = value; 
  }
  
  float getDefault() {
    return defaultValue;
  }

  float boundWrap (float currentValue) {
    float boundValue = currentValue;

    boundValue = boundValue % max;

    return boundValue;
  }

  int arcLeds() {
    return (int(map(storedValue, min, max, 0, 63)) % 64);
  }
  
  void setMax(float value) {
    max = value;
  }
  
}
