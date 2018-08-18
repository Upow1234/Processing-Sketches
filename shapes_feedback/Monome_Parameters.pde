class Monome_Parameters {

  //parameters for expanding_square
  Parameter squareWidthES, squareHeightES, xOffsetES, yOffsetES, 
    sizeSpeedES, rotationSpeedES, feedbackLevelES, feedbackDelayES, 
    squareWidthLfoSpeedES, squareWidthLfoDepthES, squareHeightLfoSpeedES, squareHeightLfoDepthES, 
    xOffsetLfoSpeedES, xOffsetLfoDepthES, yOffsetLfoSpeedES, yOffsetLfoDepthES, 

    redStrokeES, greenStrokeES, blueStrokeES, alphaStrokeES, 
    redFillES, greenFillES, blueFillES, alphaFillES, 
    redStrokeLfoSpeedES, redStrokeLfoDepthES, greenStrokeLfoSpeedES, greenStrokeLfoDepthES, 
    blueStrokeLfoSpeedES, blueStrokeLfoDepthES, alphaStrokeLfoSpeedES, alphaStrokeLfoDepthES, 
    redFillLfoSpeedES, redFillLfoDepthES, greenFillLfoSpeedES, greenFillLfoDepthES, 
    blueFillLfoSpeedES, blueFillLfoDepthES, alphaFillLfoSpeedES, alphaFillLfoDepthES;

  //parameters for five_circles
  Parameter ellipseWidthFC, ellipseHeightFC, xOffsetFC, yOffsetFC, 
    scaleLfoSpeedFC, scaleLfoDepthFC, feedbackLevelFC, feedbackDelayFC, 
    ellipseWidthLfoSpeedFC, ellipseWidthLfoDepthFC, ellipseHeightLfoSpeedFC, ellipseHeightLfoDepthFC, 
    xOffsetLfoSpeedFC, xOffsetLfoDepthFC, yOffsetLfoSpeedFC, yOffsetLfoDepthFC, 
    //column two on grid
    redStrokeFC, greenStrokeFC, blueStrokeFC, alphaStrokeFC, 
    redFillFC, greenFillFC, blueFillFC, alphaFillFC, 
    redStrokeLfoSpeedFC, redStrokeLfoDepthFC, greenStrokeLfoSpeedFC, greenStrokeLfoDepthFC, 
    blueStrokeLfoSpeedFC, blueStrokeLfoDepthFC, alphaStrokeLfoSpeedFC, alphaStrokeLfoDepthFC, 
    redFillLfoSpeedFC, redFillLfoDepthFC, greenFillLfoSpeedFC, greenFillLfoDepthFC, 
    blueFillLfoSpeedFC, blueFillLfoDepthFC, alphaFillLfoSpeedFC, alphaFillLfoDepthFC;

  Parameter[][] pairs;

  int[] controlSelection = {0, 1}; //0 controls arc encoders 0 and 1, 1 controls encoders 2 and 3

  int [][] controlLeds;
  int [][] markerLeds = new int[8][16]; //monome grid size

  int columnOneDepth;
  int columnTwoDepth;

  int[][] gridLed;
  int[][] arcLed;

  Monome_Parameters(Monome gridTemp, Monome arcTemp, Expanding_Square expandingSquareTemp) { 
    initializeExpanding_Square(expandingSquareTemp, feedback.feedbackBufferLength());
    controlLeds = new int[(columnOneDepth + columnTwoDepth) * 2][2];

    initializeControlLeds(columnOneDepth, columnTwoDepth);
    initializeMarkerLeds(expandingSquareTemp);
    initializeMonome(gridTemp, arcTemp);
  }

  Monome_Parameters(Monome gridTemp, Monome arcTemp, Five_Circles fiveCirclesTemp) {

    initializeFive_Cirlces(fiveCirclesTemp, feedback.feedbackBufferLength());
    controlLeds = new int[(columnOneDepth + columnTwoDepth) * 2][2];

    initializeControlLeds(columnOneDepth, columnTwoDepth);
    initializeMarkerLeds(fiveCirclesTemp);
    initializeMonome(gridTemp, arcTemp);
  }

  void initializeExpanding_Square(Expanding_Square expandingSquareTemp, int feedbackBufferLength) {

    squareWidthES = new Parameter("Square Width", 0, 1, 1000, 0, 1);
    squareHeightES = new Parameter("Square Height", 0, 1, 1000, 0, 1);
    xOffsetES = new Parameter("X Offset", (pgWidth / 2) * -1, (pgWidth / 2), 5, 0, 1);
    yOffsetES = new Parameter("Y Offset", (pgHeight / 2) * -1, (pgHeight / 2), 5, 0, 1);

    sizeSpeedES = new Parameter("Size Speed", 0, 0.5, 5000, 0, 0.01); 
    rotationSpeedES = new Parameter("Rotation Speed", 0, 8, 100, 0, 0.001); 
    feedbackLevelES = new Parameter("Feedback Level", 0, 1, 1000, 0, 0);
    feedbackDelayES = new Parameter("Feedback Delay", 1, feedbackBufferLength, 10, 0, 1);

    squareWidthLfoSpeedES = new Parameter("Square Width Lfo Speed", 0, 0.1, 20000, 0, 0, expandingSquareTemp.squareWidthLfo, 1);
    squareWidthLfoDepthES = new Parameter("Square Width Lfo Depth", 0, 1, 2500, 0, 0, expandingSquareTemp.squareWidthLfo, 2);
    squareHeightLfoSpeedES = new Parameter("Square Height Lfo Speed", 0, 0.1, 20000, 0, 0, expandingSquareTemp.squareHeightLfo, 1);
    squareHeightLfoDepthES = new Parameter("Square Height Lfo Depth", 0, 1, 2500, 0, 0, expandingSquareTemp.squareHeightLfo, 2);

    xOffsetLfoSpeedES = new Parameter("X Offset Lfo Speed", 0, 0.1, 20000, 0, 0, expandingSquareTemp.xOffsetLfo, 1);
    xOffsetLfoDepthES = new Parameter("X Offset Lfo Depth", 0, 1, 2500, 0, 0, expandingSquareTemp.xOffsetLfo, 2);
    yOffsetLfoSpeedES = new Parameter("Y Offset Lfo Speed", 0, 0.1, 20000, 0, 0, expandingSquareTemp.yOffsetLfo, 1);
    yOffsetLfoDepthES = new Parameter("Y Offset Lfo Depth", 0, 1, 2500, 0, 0, expandingSquareTemp.yOffsetLfo, 2);

    columnOneDepth = 4; //counting from 1

    redStrokeES = new Parameter("Red Stroke", 0, 255, 2, 0, 255);
    greenStrokeES = new Parameter("Green Stroke", 0, 255, 2, 0, 0);
    blueStrokeES = new Parameter("Blue Stroke", 0, 255, 2, 0, 0);
    alphaStrokeES = new Parameter("Alpha Stroke", 0, 255, 2, 0, 255);

    redFillES = new Parameter("Red Fill", 0, 255, 2, 0, 0);
    greenFillES = new Parameter("Green Fill", 0, 255, 2, 0, 0);
    blueFillES = new Parameter("Blue Fill", 0, 255, 2, 0, 0);
    alphaFillES = new Parameter("Alpha Fill", 0, 255, 2, 0, 0);

    redStrokeLfoSpeedES = new Parameter("Red Stroke Lfo Speed", 0, 0.5, 5000, 0, 0, expandingSquareTemp.redStrokeLfo, 1);
    redStrokeLfoDepthES = new Parameter("Red Stroke Lfo Depth", 0, 1, 2500, 0, 0, expandingSquareTemp.redStrokeLfo, 2);
    greenStrokeLfoSpeedES = new Parameter("Green Stroke Lfo Speed", 0, 0.5, 5000, 0, 0, expandingSquareTemp.greenStrokeLfo, 1);
    greenStrokeLfoDepthES = new Parameter("Green Stroke Lfo Depth", 0, 1, 2500, 0, 0, expandingSquareTemp.greenStrokeLfo, 2);

    blueStrokeLfoSpeedES = new Parameter("Blue Stroke Lfo Speed", 0, 0.5, 5000, 0, 0, expandingSquareTemp.blueStrokeLfo, 1);
    blueStrokeLfoDepthES = new Parameter("Blue Stroke Lfo Depth", 0, 1, 2500, 0, 0, expandingSquareTemp.blueStrokeLfo, 2);
    alphaStrokeLfoSpeedES = new Parameter("Alpha Stroke Lfo Speed", 0, 0.5, 5000, 0, 0, expandingSquareTemp.alphaStrokeLfo, 1);
    alphaStrokeLfoDepthES = new Parameter("Alpha Stroke Lfo Depth", 0, 1, 2500, 0, 0, expandingSquareTemp.alphaStrokeLfo, 2);

    redFillLfoSpeedES = new Parameter("Red Fill Lfo Speed", 0, 0.5, 5000, 0, 0, expandingSquareTemp.redFillLfo, 1);
    redFillLfoDepthES = new Parameter("Red Fill Lfo Depth", 0, 1, 2500, 0, 0, expandingSquareTemp.redFillLfo, 2);
    greenFillLfoSpeedES = new Parameter("Green Fill Lfo Speed", 0, 0.5, 5000, 0, 0, expandingSquareTemp.greenFillLfo, 1);
    greenFillLfoDepthES = new Parameter("Green Fill Lfo Depth", 0, 1, 2500, 0, 0, expandingSquareTemp.greenFillLfo, 2);

    blueFillLfoSpeedES = new Parameter("Blue Fill Lfo Speed", 0, 0.5, 5000, 0, 0, expandingSquareTemp.blueFillLfo, 1);
    blueFillLfoDepthES = new Parameter("Blue Fill Lfo Depth", 0, 1, 2500, 0, 0, expandingSquareTemp.blueFillLfo, 2);
    alphaFillLfoSpeedES = new Parameter("Alpha Fill Lfo Speed", 0, 0.5, 5000, 0, 0, expandingSquareTemp.alphaFillLfo, 1);
    alphaFillLfoDepthES = new Parameter("Alpha Fill Lfo Depth", 0, 1, 2500, 0, 0, expandingSquareTemp.alphaFillLfo, 2);

    columnTwoDepth = 6; //counting from 1

    pairs = new Parameter[][] {
      {squareWidthES, squareHeightES}, {xOffsetES, yOffsetES}, 
      {sizeSpeedES, rotationSpeedES}, {feedbackLevelES, feedbackDelayES}, 
      {squareWidthLfoSpeedES, squareWidthLfoDepthES}, {squareHeightLfoSpeedES, squareHeightLfoDepthES}, 
      {xOffsetLfoSpeedES, xOffsetLfoDepthES}, {yOffsetLfoSpeedES, yOffsetLfoDepthES}, 

      {redStrokeES, greenStrokeES}, {blueStrokeES, alphaStrokeES}, 
      {redFillES, greenFillES}, {blueFillES, alphaFillES}, 
      {redStrokeLfoSpeedES, redStrokeLfoDepthES}, {greenStrokeLfoSpeedES, greenStrokeLfoDepthES}, 
      {blueStrokeLfoSpeedES, blueStrokeLfoDepthES}, {alphaStrokeLfoSpeedES, alphaStrokeLfoDepthES}, 
      {redFillLfoSpeedES, redFillLfoDepthES}, {greenFillLfoSpeedES, greenFillLfoDepthES}, 
      {blueFillLfoSpeedES, blueFillLfoDepthES}, {alphaFillLfoSpeedES, alphaFillLfoDepthES}
    };
  }

  void initializeFive_Cirlces(Five_Circles fiveCirclesTemp, int feedbackBufferLength) {

    ellipseWidthFC = new Parameter("Ellipse Width", 0, 1, 1000, 0, 1);
    ellipseHeightFC = new Parameter("Ellipse Height", 0, 1, 1000, 0, 1);
    xOffsetFC = new Parameter("X Offset", (pgWidth / 2) * -1, (pgWidth / 2), 5, 0, 1);
    yOffsetFC = new Parameter("Y Offset", (pgHeight / 2) * -1, (pgHeight / 2), 5, 0, 1);

    scaleLfoSpeedFC = new Parameter("Scale LFO Speed", 0, 0.5, 5000, 0, 0, fiveCirclesTemp.scaleLfo, 1); //can I pass the parameter type into the constructor some other way?
    scaleLfoDepthFC = new Parameter("Scale LFO Depth", 0, 8, 100, 0, 0, fiveCirclesTemp.scaleLfo, 2); //this depth is a little different because it's not multiplying a variable in the five_circles class
    feedbackLevelFC = new Parameter("Feedback Level", 0, 1, 1000, 0, 0);
    feedbackDelayFC = new Parameter("Feedback Delay", 1, feedbackBufferLength, 10, 0, 1);

    ellipseWidthLfoSpeedFC = new Parameter("Ellipse Width Lfo Speed", 0, 0.1, 20000, 0, 0, fiveCirclesTemp.ellipseWidthLfo, 1);
    ellipseWidthLfoDepthFC = new Parameter("Ellipse Width Lfo Depth", 0, 1, 2500, 0, 0, fiveCirclesTemp.ellipseWidthLfo, 2);
    ellipseHeightLfoSpeedFC = new Parameter("Ellipse Height Lfo Speed", 0, 0.1, 20000, 0, 0, fiveCirclesTemp.ellipseHeightLfo, 1);
    ellipseHeightLfoDepthFC = new Parameter("Ellipse Height Lfo Depth", 0, 1, 2500, 0, 0, fiveCirclesTemp.ellipseHeightLfo, 2);

    xOffsetLfoSpeedFC = new Parameter("X Offset Lfo Speed", 0, 0.1, 20000, 0, 0, fiveCirclesTemp.xOffsetLfo, 1);
    xOffsetLfoDepthFC = new Parameter("X Offset Lfo Depth", 0, 1, 2500, 0, 0, fiveCirclesTemp.xOffsetLfo, 2);
    yOffsetLfoSpeedFC = new Parameter("Y Offset Lfo Speed", 0, 0.1, 20000, 0, 0, fiveCirclesTemp.yOffsetLfo, 1);
    yOffsetLfoDepthFC = new Parameter("Y Offset Lfo Depth", 0, 1, 2500, 0, 0, fiveCirclesTemp.yOffsetLfo, 2);

    columnOneDepth = 4; //counting from 1

    redStrokeFC = new Parameter("Red Stroke", 0, 255, 2, 0, 255);
    greenStrokeFC = new Parameter("Green Stroke", 0, 255, 2, 0, 0);
    blueStrokeFC = new Parameter("Blue Stroke", 0, 255, 2, 0, 0);
    alphaStrokeFC = new Parameter("Alpha Stroke", 0, 255, 2, 0, 255);

    redFillFC = new Parameter("Red Fill", 0, 255, 2, 0, 0);
    greenFillFC = new Parameter("Green Fill", 0, 255, 2, 0, 0);
    blueFillFC = new Parameter("Blue Fill", 0, 255, 2, 0, 0);
    alphaFillFC = new Parameter("Alpha Fill", 0, 255, 2, 0, 0);

    redStrokeLfoSpeedFC = new Parameter("Red Stroke Lfo Speed", 0, 0.5, 5000, 0, 0, fiveCirclesTemp.redStrokeLfo, 1);
    redStrokeLfoDepthFC = new Parameter("Red Stroke Lfo Depth", 0, 1, 2500, 0, 0, fiveCirclesTemp.redStrokeLfo, 2);
    greenStrokeLfoSpeedFC = new Parameter("Green Stroke Lfo Speed", 0, 0.5, 5000, 0, 0, fiveCirclesTemp.greenStrokeLfo, 1);
    greenStrokeLfoDepthFC = new Parameter("Green Stroke Lfo Depth", 0, 1, 2500, 0, 0, fiveCirclesTemp.greenStrokeLfo, 2);

    blueStrokeLfoSpeedFC = new Parameter("Blue Stroke Lfo Speed", 0, 0.5, 5000, 0, 0, fiveCirclesTemp.blueStrokeLfo, 1);
    blueStrokeLfoDepthFC = new Parameter("Blue Stroke Lfo Depth", 0, 1, 2500, 0, 0, fiveCirclesTemp.blueStrokeLfo, 2);
    alphaStrokeLfoSpeedFC = new Parameter("Alpha Stroke Lfo Speed", 0, 0.5, 5000, 0, 0, fiveCirclesTemp.alphaStrokeLfo, 1);
    alphaStrokeLfoDepthFC = new Parameter("Alpha Stroke Lfo Depth", 0, 1, 2500, 0, 0, fiveCirclesTemp.alphaStrokeLfo, 2);

    redFillLfoSpeedFC = new Parameter("Red Fill Lfo Speed", 0, 0.5, 5000, 0, 0, fiveCirclesTemp.redFillLfo, 1);
    redFillLfoDepthFC = new Parameter("Red Fill Lfo Depth", 0, 1, 2500, 0, 0, fiveCirclesTemp.redFillLfo, 2);
    greenFillLfoSpeedFC = new Parameter("Green Fill Lfo Speed", 0, 0.5, 5000, 0, 0, fiveCirclesTemp.greenFillLfo, 1);
    greenFillLfoDepthFC = new Parameter("Green Fill Lfo Depth", 0, 1, 2500, 0, 0, fiveCirclesTemp.greenFillLfo, 2);

    blueFillLfoSpeedFC = new Parameter("Blue Fill Lfo Speed", 0, 0.5, 5000, 0, 0, fiveCirclesTemp.blueFillLfo, 1);
    blueFillLfoDepthFC = new Parameter("Blue Fill Lfo Depth", 0, 1, 2500, 0, 0, fiveCirclesTemp.blueFillLfo, 2);
    alphaFillLfoSpeedFC = new Parameter("Alpha Fill Lfo Speed", 0, 0.5, 5000, 0, 0, fiveCirclesTemp.alphaFillLfo, 1);
    alphaFillLfoDepthFC = new Parameter("Alpha Fill Lfo Depth", 0, 1, 2500, 0, 0, fiveCirclesTemp.alphaFillLfo, 2);

    columnTwoDepth = 6; //counting from 1

    pairs = new Parameter[][] {
      {ellipseWidthFC, ellipseHeightFC}, {xOffsetFC, yOffsetFC}, 
      {scaleLfoSpeedFC, scaleLfoDepthFC}, {feedbackLevelFC, feedbackDelayFC}, 
      {ellipseWidthLfoSpeedFC, ellipseWidthLfoDepthFC}, {ellipseHeightLfoSpeedFC, ellipseHeightLfoDepthFC}, 
      {xOffsetLfoSpeedFC, xOffsetLfoDepthFC}, {yOffsetLfoSpeedFC, yOffsetLfoDepthFC}, 

      {redStrokeFC, greenStrokeFC}, {blueStrokeFC, alphaStrokeFC}, 
      {redFillFC, greenFillFC}, {blueFillFC, alphaFillFC}, 
      {redStrokeLfoSpeedFC, redStrokeLfoDepthFC}, {greenStrokeLfoSpeedFC, greenStrokeLfoDepthFC}, 
      {blueStrokeLfoSpeedFC, blueStrokeLfoDepthFC}, {alphaStrokeLfoSpeedFC, alphaStrokeLfoDepthFC}, 
      {redFillLfoSpeedFC, redFillLfoDepthFC}, {greenFillLfoSpeedFC, greenFillLfoDepthFC}, 
      {blueFillLfoSpeedFC, blueFillLfoDepthFC}, {alphaFillLfoSpeedFC, alphaFillLfoDepthFC}
    };
  }

  void initializeMonome(Monome gridTemp, Monome arcTemp) {
    arcLed = new int[4][64];
    gridLed = new int[8][16];

    delay(1500); //allows time for arc and grid to initialize before initializing leds
    arcDisplayValuesEnc(arcTemp, 0, 0, 0);
    arcDisplayValuesEnc(arcTemp, 1, 0, 1);
    arcDisplayValuesEnc(arcTemp, 2, 1, 0);
    arcDisplayValuesEnc(arcTemp, 3, 1, 1);

    gridDisplayArcSelection(gridTemp);
  }

  void initializeControlLeds(int columnOneDepthTemp, int columnTwoDepthTemp) {
    int columnOneDepthLocal = columnOneDepthTemp * 2;
    int columnTwoDepthLocal = columnTwoDepthTemp * 2;

    for (int y = 0, i = 0; y < columnOneDepthLocal; y++) {
      if ((y % 2) == 1) {
        controlLeds[y][0] = i;
        controlLeds[y][1] = 2;
        i++;
      } else {
        controlLeds[y][0] = i;
        controlLeds[y][1] = 0;
      }
    }

    for (int y = columnOneDepthLocal, i = 0; y < columnOneDepthLocal + columnTwoDepthLocal; y++) {
      if ((y % 2) == 1) {
        controlLeds[y][0] = i;
        controlLeds[y][1] = 6;
        i++;
      } else {
        controlLeds[y][0] = i;
        controlLeds[y][1] = 4;
      }
    }
  }

  void initializeMarkerLeds(Expanding_Square sketchType) { //local parameter doesn't get used
    int[][] markerLedLocations = 
      {{1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
      {1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0}, 
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
      {0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0}, 
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}};

    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 16; x++) {
        if (markerLedLocations[y][x] == 1) {
          markerLeds[y][x] = 2;
        } else {
          markerLeds[y][x] = 0;
        }
      }
    }
  }

  void initializeMarkerLeds(Five_Circles sketchType) { //local parameter doesn't get used
    int[][] markerLedLocations = 
      {{1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
      {1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0}, 
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
      {0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0}, 
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}};

    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 16; x++) {
        if (markerLedLocations[y][x] == 1) {
          markerLeds[y][x] = 2;
        } else {
          markerLeds[y][x] = 0;
        }
      }
    }
  }

  //arc input
  public void mArc(Monome arcTemp, int n, int d) {

    if (n == 0) {
      pairs[controlSelection[0]][0].change(d);
      arcDisplayValuesEnc(arcTemp, 0, 0, 0);
    }

    if (n == 1) {
      pairs[controlSelection[0]][1].change(d);
      arcDisplayValuesEnc(arcTemp, 1, 0, 1);
    }

    if (n == 2) {
      pairs[controlSelection[1]][0].change(d);
      arcDisplayValuesEnc(arcTemp, 2, 1, 0);
    }

    if (n == 3) {
      pairs[controlSelection[1]][1].change(d);
      arcDisplayValuesEnc(arcTemp, 3, 1, 1);
    }
  }

  //grid input
  public void mGrid(Monome gridTemp, Monome arcTemp, int x, int y, int n) {
    //x is horizontal y is vertical

    //columns seletion for arc control selection
    int[] columns = { 0, 1, 2, 3, 4, 5, 6, 7 };

    //arc control selection
    if (((x >= columns[0]) && (x <= columns[3])) && (n == 1)) {
      if (y < columnOneDepth) {
        mGridFunction(gridTemp, arcTemp, x, y, n, columns[0], columns[1], columns[2], columns[3]);
      }
    } else if (((x >= columns[4]) && (x <= columns[7])) && (n == 1)) {
      if (y < columnTwoDepth) {
        mGridFunction(gridTemp, arcTemp, x, y + columnOneDepth, n, columns[4], columns[5], columns[6], columns[7]);
      }
    }
  }

  //could there be a more descriptive name for this function?
  void mGridFunction(Monome gridTemp, Monome arcTemp, int x, int y, int n, 
    int firstColumn, int secondColumn, int thirdColumn, int fourthColumn) {

    if (x == firstColumn) {
      int scaleX = 0;
      if ((scaleX + (y * 2)) < pairs.length) {
        controlSelection[0] = scaleX + (y * 2);

        arcDisplayValuesEnc(arcTemp, 0, 0, 0);
        arcDisplayValuesEnc(arcTemp, 1, 0, 1);
      }
      println();
      println(pairs[controlSelection[0]][0].name() + "   " + pairs[controlSelection[0]][1].name());
    }

    if (x == thirdColumn) {
      int scaleX = 1;
      if ((scaleX + (y * 2)) < pairs.length) {
        controlSelection[0] = scaleX + (y * 2);

        arcDisplayValuesEnc(arcTemp, 0, 0, 0);
        arcDisplayValuesEnc(arcTemp, 1, 0, 1);
      }
      println();
      println(pairs[controlSelection[0]][0].name() + "   " + pairs[controlSelection[0]][1].name());
    }

    if (x == secondColumn) {
      int scaleX = 0;
      if ((scaleX + (y * 2)) < pairs.length) {
        controlSelection[1] = scaleX + (y * 2);

        arcDisplayValuesEnc(arcTemp, 2, 1, 0);
        arcDisplayValuesEnc(arcTemp, 3, 1, 1);
      }
      println();
      println(pairs[controlSelection[1]][0].name() + "   " + pairs[controlSelection[1]][1].name());
    }

    if (x == fourthColumn) {
      int scaleX = 1;
      if ((scaleX + (y * 2)) < pairs.length) {
        controlSelection[1] = scaleX + (y * 2);

        arcDisplayValuesEnc(arcTemp, 2, 1, 0);
        arcDisplayValuesEnc(arcTemp, 3, 1, 1);
      }

      println();
      println(pairs[controlSelection[1]][0].name() + "   " + pairs[controlSelection[1]][1].name());
    }
    gridDisplayArcSelection(gridTemp);
  }

  void gridDisplayArcSelection (Monome gridTemp) {

    //instead of clearing grid leds, sets them to marker leds
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 16; x++) {
        gridLed[y][x] = markerLeds[y][x];
      }
    }

    //selection for arc control
    gridLed[controlLeds[controlSelection[0]][0]][controlLeds[controlSelection[0]][1]] = 15;
    gridLed[controlLeds[controlSelection[0]][0]][controlLeds[controlSelection[0]][1] + 1] = 15;
    gridLed[controlLeds[controlSelection[1]][0]][controlLeds[controlSelection[1]][1]] = 7;
    gridLed[controlLeds[controlSelection[1]][0]][controlLeds[controlSelection[1]][1] + 1] = 7;

    gridTemp.refresh(gridLed);
  }

  void arcDisplayValuesEnc (Monome arcTemp, int encoderNumber, int pairSelectionZero, int pairSelectionOne) { 
    //clear arc leds on given encoder
    for (int i = 0; i < arcLed[encoderNumber].length; i++) {
      arcLed[encoderNumber][i] = 0;
    }

    //arc led values
    int ledCoarseValue = pairs[controlSelection[pairSelectionZero]][pairSelectionOne].arcLedsCoarse();
    for (int i = 0; i < ledCoarseValue; i++ ) {
      arcLed[encoderNumber][i] = 15;
    }
    //arc fine led value...this is still not perfect, technically the highest led only gets to a brightness of 14, not 15.
    if (ledCoarseValue < 64) {
      arcLed[encoderNumber][ledCoarseValue] = pairs[controlSelection[pairSelectionZero]][pairSelectionOne].arcLedsFine();
    }

    arcTemp.refresh(encoderNumber, arcLed[encoderNumber]);
  }
}
