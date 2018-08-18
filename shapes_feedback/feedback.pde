class Feedback {

  PGraphics[] feedbackBuffer;
  int feedbackCount = 1;

  int feedbackDelay = 1;
  float feedbackLevel = 0;
  float addBright = 0;

  Feedback(int feedbackBufferLength) {

    feedbackBuffer = new PGraphics[feedbackBufferLength];

    for (int i = 0; i < feedbackBuffer.length; i++) {
      feedbackBuffer[i] = createGraphics(pgWidth, pgHeight, P2D);
      //if something isn't drawn into PGraphics first, when you turn up feedbackDelay there is a terrible drop in frame rate or the computer freezes
      feedbackBuffer[i].beginDraw();
      feedbackBuffer[i].background(0);
      feedbackBuffer[i].endDraw();
    }
  }

  //Feedback Functions
  void feedbackDisplay(PGraphics outputContext) {

    outputContext.tint(255, (255 * (feedbackLevel + addBright))); 
    outputContext.image(feedbackBuffer[feedbackCount], 0, 0, pgWidth, pgHeight);
  }


  void feedbackCapture(PGraphics captureContext) {
    feedbackBuffer[feedbackCount].beginDraw();
    feedbackBuffer[feedbackCount].image(captureContext, 0, 0);
    feedbackBuffer[feedbackCount].endDraw();
  }

  void count () {
    feedbackCount = ((feedbackCount + 1) % feedbackDelay);
  }

  void parameters(Expanding_Square expandingSquareTemp) { //local parameter isn't used
    feedbackLevel = mp.feedbackLevelES.value();
    feedbackDelay = mp.feedbackDelayES.valueInt();
  }

  void parameters(Five_Circles fiveCirclesTemp) { //local parameter isn't used
    feedbackLevel = mp.feedbackLevelFC.value();
    feedbackDelay = mp.feedbackDelayFC.valueInt();
  }

  int feedbackBufferLength() {
    return feedbackBuffer.length;
  }
}
