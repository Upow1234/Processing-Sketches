class Expanding_Square {
  
  PGraphics masterContext;
  int masterContextWidth;
  int masterContextHeight;

  PShape square;

  float size; //size just expands always
  float rotation;

  Lfo squareWidthLfo;
  Lfo squareHeightLfo;

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

  Expanding_Square(PGraphics masterContextTemp, int masterContextWidthTemp, int masterContextHeightTemp) {
    masterContext = masterContextTemp;
    masterContextWidth = masterContextWidthTemp;
    masterContextHeight = masterContextHeightTemp;
    
    rectMode(CENTER);

    initializeLfos();
  }

  void render() {

    float sizeSpeed = mp.sizeSpeedES.value();
    float rotationSpeed = mp.rotationSpeedES.value();

    float squareWidth = mp.squareWidthES.value();
    float squareHeight = mp.squareHeightES.value();
    float xOffset = mp.xOffsetES.value();
    float yOffset = mp.yOffsetES.value();

    float redStroke = mp.redStrokeES.value();
    float greenStroke = mp.greenStrokeES.value();
    float blueStroke = mp.blueStrokeES.value();
    float alphaStroke = mp.alphaStrokeES.value();

    float redFill = mp.redFillES.value();
    float greenFill = mp.greenFillES.value();
    float blueFill = mp.blueFillES.value();
    float alphaFill = mp.alphaFillES.value();
    incrementLfos();

    int resolution = 8;

    square = createShape(RECT, 0, 0, (masterContextWidth / resolution) * (squareWidth * squareWidthLfo.value()), 
    (masterContextHeight / resolution) * (squareHeight * squareHeightLfo.value()));

    square.setStroke(color(redStroke * redStrokeLfo.value(), greenStroke * greenStrokeLfo.value(), 
      blueStroke * blueStrokeLfo.value(), alphaStroke * alphaStrokeLfo.value()));
    square.setFill(color(redFill * redFillLfo.value(), greenFill * greenFillLfo.value(), 
      blueFill * blueFillLfo.value(), alphaFill * alphaFillLfo.value()));

    square.rotate(radians(rotation));
    square.scale(size);

    //these will always run anyways
    size = (size + sizeSpeed) % resolution;
    rotation = (rotation + rotationSpeed) % 360;

    float xOffsetAdjusted = (xOffsetLfo.value() - 1) * pgWidth;
    float yOffsetAdjusted = (yOffsetLfo.value() - 1) * pgHeight;

    masterContext.shape(square, (pgWidth / 2) + (xOffset + xOffsetAdjusted), (pgHeight / 2) + (yOffset + yOffsetAdjusted));
  }

  void display() {
    image(masterContext, 0, 0, width, height);
  }

  void incrementLfos() {

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
    squareWidthLfo = new Lfo(0, 0);
    squareHeightLfo = new Lfo(0, 0);

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
