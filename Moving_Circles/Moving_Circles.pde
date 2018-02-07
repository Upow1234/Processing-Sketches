/* the only issue with this sketch as is: arc leds do not initialze to correct levels
this initialization is quickly done by re-selecting the rows on the grid */

import org.monome.Monome;
import oscP5.*;

Monome arc;
Monome grid;

Circle[] circle = new Circle[50];
int numberCircles = 50;

//variables for monome grid
int[][] gridLed; //array for grid leds ROW THEN COLUMN (8 x 16)
int row[] = { 0, 1 }; //selected row for arc encoders left (0 and 1) and right (2 and 3) 
int col[] = { 0, 1 }; //selected column for arc encoders left (0 and 1) and right (2 and 3)
int[] ledIntensity = { 15, 7 }; //intensity for left and right columns

//array for arc leds
int[][] arcLed;

//index of selected parameter group
int selectionLeft = 0;
int selectionRight = 1;

float[] selectionMax = { width/4, 2, 2, 2, 255, 255, 1, 1}; //max for size, red, green, blue, alpha, stroke, stroke alpha, speed
float[] selectionMin = { 0, 0, 0, 0, 0, 0, 0, 0}; //min for size, red, green, blue. alpha, stroke, stroke alpha, speed(speed min is just a placeholder)


void setup() {

  size(300, 300);
  //fullScreen();

  arc = new Monome(this, "m1100144");
  grid = new Monome(this, "m1000370");

  //creates circles based on number of circles variable
  for (int i = 0; i < numberCircles; i++) { 
    circle[i] = new Circle();
  }
}



void draw() {

  clear();

  gridLed = new int[8][16]; //creates new arrays every draw
  arcLed = new int[4][64];  //to clear last led state

  //updates grid leds based on selected row and column
  gridLed[ row[0] ] [col[0]] = ledIntensity[0];
  gridLed[ row[1] ] [col[1]] = ledIntensity[1];
  grid.refresh(gridLed);

  //executes three functions for every Circle object
  for (int i = 0; i < numberCircles; i++) { 
    circle[i].change();
    circle[i].move();
    circle[i].create();
  }
}

//creates Circles
class Circle {

  float [] location = { width/2, height/2 };
  float [] direction = { (int(random(1, 20) - -10)), (int(random(1, 20) - -10)) };

  float [] classSelection = { 20, 0, 0, 0, 255, 255, 0 }; // size, red, green, blue, alpha, stroke, stroke alpha
  float [] selectionDirection = { 1, 1, 1, 1, 1, 1, 1 }; //size direction, red direction etc...


  Circle() {
    //nothing here!
  }

  //moves circles x and y locations
  void move() {

    int[] maximum  = { width, height };

    for (int i = 0; i <= 1; i = i + 1) {
      location[i] = location[i] + (direction[i] * selectionMax[7]);

      if (location[i] >= (maximum[i] - ( classSelection[0] / 2 )) ) {
        direction[i] = (random(1, 10) * -1);
      }

      if (location[i] <= ( classSelection[0] / 2 )) {
        direction[i] = random(1, 10);
      }
    }
  }


  //changes size, red, green, blue, alpha, stroke, stroke alpha
  void change() {

    for (int i = 0; i <= 6; i = i + 1) {

      classSelection[i] = classSelection[i] + (selectionDirection[i] * selectionMax[7]);

      if (classSelection[i] <= selectionMin[i]) {
        selectionDirection[i] = random(1, 10);
      }
      if (classSelection[i] >= selectionMax[i]) {
        selectionDirection[i] = ((random(1, 10)) * -1);
      }
    }
  }


  //draws based on current values of parameters
  void create() {

    fill(classSelection[1], classSelection[2], classSelection[3], classSelection[4]);
    stroke(classSelection[5], classSelection[6]);
    ellipse(location[0], location[1], classSelection[0], classSelection[0]);
  }
}


//arc encoders change minimums and maximums of oscillating value ranges
public void delta(int n, int d) {

  float[] maximum = { width/2, 255, 255, 255, 255, 255, 255, 4 }; //maximum values of parameters so we know when to turn around
  float[] scale = { 10.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 1000.0 }; //scales arc delta value for finer resolution

  int[] lastLed = { 0, 0, 0, 0 }; //stores last led level so ring is only updated when a new integer value is reached

  //work for each encoder
  if (row[0] == selectionLeft && col[0] == 0) {
    if (n == 0) {
      selectionMax[selectionLeft] = selectionMax[selectionLeft] + (d / scale[selectionLeft]);
      println("selectionMax[" + selectionLeft + "] = " + selectionMax[selectionLeft]);

      if (lastLed[0] != int(map(selectionMax[selectionLeft], 0, maximum[selectionLeft], 0, 63))) {
        ledMaxRefresh(0, selectionLeft);
      }

      lastLed[0] = int(map(selectionMax[selectionLeft], 0, maximum[selectionLeft], 0, 63));
    }

    if (n == 1 && col[0] == 0) {
      selectionMin[selectionLeft] = selectionMin[selectionLeft] + (d / scale[selectionLeft]);
      println("selectionMin[" + selectionLeft + "] = " + selectionMin[selectionLeft]);

      if (lastLed[1] != int(map(selectionMin[selectionLeft], 0, maximum[selectionLeft], 0, 63))) {
        ledMinRefresh(1, selectionLeft);
      }

      lastLed[1] = int(map(selectionMin[selectionLeft], 0, maximum[selectionLeft], 0, 63));
    }
  }

  if (row[1] == selectionRight && col[1] == 1) {
    if (n == 2) {
      selectionMax[selectionRight] = selectionMax[selectionRight] + (d / scale[selectionRight]);
      println("selectionMax[" + selectionRight + "] = " + selectionMax[selectionRight]);

      if (lastLed[2] != int(map(selectionMax[selectionRight], 0, maximum[selectionRight], 0, 63))) {
        ledMaxRefresh(2, selectionRight);
      }

      lastLed[2] = int(map(selectionMax[selectionRight], 0, maximum[selectionRight], 0, 63));
    }

    if (n == 3 && col[1] == 1) {
      selectionMin[selectionRight] = selectionMin[selectionRight] + (d / scale[selectionRight]);
      println("selectionMin[" + selectionRight + "] = " + selectionMin[selectionRight]);

      if (lastLed[3] != int(map(selectionMin[selectionRight], 0, maximum[selectionRight], 0, 63))) {
        ledMinRefresh(3, selectionRight);
      }

      lastLed[3] = int(map(selectionMin[selectionRight], 0, maximum[selectionRight], 0, 63));
    }

    selectionMax[selectionLeft] = constrain(selectionMax[selectionLeft], 0, maximum[selectionLeft]);
    selectionMin[selectionLeft] = constrain(selectionMin[selectionLeft], 0, maximum[selectionLeft]);
    selectionMax[selectionRight] = constrain(selectionMax[selectionRight], 0, maximum[selectionRight]);
    selectionMin[selectionRight] = constrain(selectionMin[selectionRight], 0, maximum[selectionRight]);
  }
}


//grid keys input, changes selection values and updates arc rings accordingly
public void key(int x, int y, int s) {

  if (s == 1 && x == 0) {
    row[0] = y;
    col[0] = 0;

    selectionLeft = y;

    arcLedRefresh(0, 1, selectionLeft);
  }

  if (s == 1 && x == 1) {
    row[1] = y;
    col[1] = 1;

    selectionRight = y;

    arcLedRefresh(2, 3, selectionRight);
  }

  //to add more parameters must add to selection variables then uncomment this area
  /* if (s == 1 && x == 2) {
   row[0] = y;
   col[0] = 2;
   
   selectionLeft = y + 8;
   }
   
   if (s == 1 && x == 3) {
   row[1] = y;
   col[1] = 3;
   
   selectionRight = y + 8;
   }*/
}

//arc led refresh functions
void arcLedRefresh(int enc, int enc2, int selection) {

  float[] maximum = { width/2, 255, 255, 255, 255, 255, 255, 4 };

  for (int j = 0; j <= constrain(int(map(selectionMax[selection], 0, maximum[selection], 0, 63)), 0, 63); j = j + 1) {
    arcLed[enc][j] = 15;
  }

  arc.refresh(enc, arcLed[enc]);


  for (int j = 0; j <= constrain(int(map(selectionMin[selection], 0, maximum[selection], 0, 63)), 0, 63); j = j + 1) {
    arcLed[enc2][j] = 15;
  }

  arc.refresh(enc2, arcLed[enc2]);
}



void ledMaxRefresh(int enc, int selection) {

  float[] maximum = { width/2, 255, 255, 255, 255, 255, 255, 4 };

  for (int j = 0; j <= constrain(int(map(selectionMax[selection], 0, maximum[selection], 0, 63)), 0, 63); j = j + 1) {
    arcLed[enc][j] = 15;
  }

  arc.refresh(enc, arcLed[enc]);
}

void ledMinRefresh(int enc, int selection) {

  float[] maximum = { width/2, 255, 255, 255, 255, 255, 255, 4 };

  for (int j = 0; j <= constrain(int(map(selectionMin[selection], 0, maximum[selection], 0, 63)), 0, 63); j = j + 1) {
    arcLed[enc][j] = 15;
  }

  arc.refresh(enc, arcLed[enc]);
}