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