class Five_Circles { 

  PGraphics masterContext;
  int masterContextWidth;
  int masterContextHeight;

  PShape ellipse;

  float scale;
  Lfo scaleLfo; //drives the expansion and contraction

  Lfo ellipseWidthLfo;
  Lfo ellipseHeightLfo;
  Lfo xOffsetLfo;
  Lfo yOffsetLfo;

  Lfo redStrokeLfo;
  Lfo greenStrokeLfo;
  Lfo blueStrokeLfo;
  Lfo alphaStrokeLfo;

  Lfo redFillLfo;
  Lfo greenFillLfo;
  Lfo blueFillLfo;
  Lfo alphaFillLfo;

  Five_Circles(PGraphics masterContextTemp, int masterContextWidthTemp, int masterContextHeightTemp) {
    masterContext = masterContextTemp;
    masterContextWidth = masterContextWidthTemp;
    masterContextHeight = masterContextHeightTemp;

    initializeLfos();
  }

  void render() { 
    float ellipseWidth = mp.ellipseWidthFC.value();
    float ellipseHeight = mp.ellipseHeightFC.value();
    float xOffset = mp.xOffsetFC.value();
    float yOffset = mp.yOffsetFC.value();

    float redStroke = mp.redStrokeFC.value();
    float greenStroke = mp.greenStrokeFC.value();
    float blueStroke = mp.blueStrokeFC.value();
    float alphaStroke = mp.alphaStrokeFC.value();

    float redFill = mp.redFillFC.value();
    float greenFill = mp.greenFillFC.value();
    float blueFill = mp.blueFillFC.value();
    float alphaFill = mp.alphaFillFC.value();

    incrementLfos();

    ellipse = createShape(ELLIPSE, 0, 0, (masterContextWidth / 6) * (ellipseWidth * ellipseWidthLfo.value()), 
      (masterContextHeight / 6) * (ellipseHeight * ellipseHeightLfo.value())); //resolution of the squares is essentially set here "pgWidth / x"

    ellipse.setStroke(color(redStroke * redStrokeLfo.value(), greenStroke * greenStrokeLfo.value(), 
      blueStroke * blueStrokeLfo.value(), alphaStroke * alphaStrokeLfo.value()));

    ellipse.setFill(color(redFill * redFillLfo.value(), greenFill * greenFillLfo.value(), blueFill * blueFillLfo.value(), alphaFill * alphaFillLfo.value()));

    float scale = scaleLfo.incrementLfo();
    ellipse.scale(scale);

    float xOffsetAdjusted = (xOffsetLfo.value() - 1) * pgWidth;
    float yOffsetAdjusted = (yOffsetLfo.value() - 1) * pgHeight;

    masterContext.shape(ellipse, (pgWidth/2) + (xOffset + xOffsetAdjusted), (pgHeight/2) + (yOffset + yOffsetAdjusted));
    masterContext.shape(ellipse, 0 + (xOffset + xOffsetAdjusted), 0 + (yOffset + yOffsetAdjusted));
    masterContext.shape(ellipse, pgWidth + (xOffset + xOffsetAdjusted), 0 + (yOffset + yOffsetAdjusted));
    masterContext.shape(ellipse, 0 + (xOffset + xOffsetAdjusted), pgHeight + (yOffset + yOffsetAdjusted));
    masterContext.shape(ellipse, pgWidth + (xOffset + xOffsetAdjusted), pgHeight + (yOffset + yOffsetAdjusted));
  }

  void display() {
    image(masterContext, 0, 0, width, height);
  }

  void incrementLfos() {

    ellipseWidthLfo.incrementLfo();
    ellipseHeightLfo.incrementLfo();
    xOffsetLfo.incrementLfo();
    yOffsetLfo.incrementLfo();

    redStrokeLfo.incrementLfo();
    greenStrokeLfo.incrementLfo();
    blueStrokeLfo.incrementLfo();
    alphaStrokeLfo.incrementLfo();

    redFillLfo.incrementLfo();
    greenFillLfo.incrementLfo();
    blueFillLfo.incrementLfo();
    alphaFillLfo.incrementLfo();
  }

  void initializeLfos() {
    //these are hard coded to be the same as the corresponding monome_parameters, if I don't do this I can't compile
    scaleLfo = new Lfo(0, 0); //constructor is depth, speed

    ellipseWidthLfo = new Lfo(0, 0);
    ellipseHeightLfo = new Lfo(0, 0);
    xOffsetLfo = new Lfo(0, 0);
    yOffsetLfo = new Lfo(0, 0);

    redStrokeLfo = new Lfo(0, 0);
    greenStrokeLfo = new Lfo(0, 0);
    blueStrokeLfo = new Lfo(0, 0);
    alphaStrokeLfo = new Lfo(0, 0);

    redFillLfo = new Lfo(0, 0);
    greenFillLfo = new Lfo(0, 0);
    blueFillLfo = new Lfo(0, 0);
    alphaFillLfo = new Lfo(0, 0);
  }
}
