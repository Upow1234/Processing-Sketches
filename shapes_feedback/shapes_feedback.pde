//to change "sketch"
//change parameter passed to Monome_Parameters
//uncomment sketch to be changed to, comment out old sketch

//set better defaults...not just red stroke 255
import org.monome.Monome;
import oscP5.*;

Monome grid;
Monome arc;

Monome_Parameters mp;

PGraphics pg;
int pgWidth = 1280;
int pgHeight = 1024;

Five_Circles fiveCircles;
//Expanding_Square exsqua;
Feedback feedback;

void setup() { // is the order of class initialization still important? or am I using the parameters correctly now?
  fullScreen(P2D, 2);
  //size(320, 240, P2D);
  pg = createGraphics(pgWidth, pgHeight, P2D);

  feedback = new Feedback(200);

  arc = new Monome(this, "m1100144");
  grid = new Monome(this, "m1000370");

  fiveCircles = new Five_Circles(pg, pgWidth, pgHeight);
  //exsqua = new Expanding_Square(pg, pgWidth, pgHeight);

  mp = new Monome_Parameters(grid, arc, fiveCircles);
  //mp = new Monome_Parameters(grid, arc, exsqua);
}

void draw() {
  pg.beginDraw();
  pg.background(0);

  feedback.feedbackDisplay(pg);
  feedback.parameters(fiveCircles);
  //feedback.parameters(exsqua);

  fiveCircles.render();
  //exsqua.render();

  //println("frame rate = " + frameRate);

  pg.endDraw();
  fiveCircles.display();
  //exsqua.display();

  feedback.feedbackCapture(pg);
  feedback.count();
}
