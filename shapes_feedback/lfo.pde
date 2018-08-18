class Lfo { 
  //lfo that oscillates with 1 as a center point, unless depth goes above 1
  //depth goes from 0 to 1 (or higher)
  
  float depth;
  float speed;
  float increment;

  float value;


  Lfo(float tempDepth, float tempSpeed) {
    depth = tempDepth;
    speed = tempSpeed;
    value = 1;

    increment = 1;
  }

  float incrementLfo() {
    if (depth <= 1) {
      depthFunction(1);
    } else if (depth > 1) {
      depthFunction(depth);
    } 
    
    if (depth == 0) {
      //no incrementing occurs
    } else {
      value = value + (increment * speed);
    }
    return value;
  }

  void depthFunction(float input) {
    if (value >= (input + depth)) {
      increment = -1;
    } else if (value <= (input - depth)) {
      increment = 1;
    }
  }

  float value() {
    return value;
  }

  void changeSpeed(float speedTemp) {
    speed = speedTemp;
    //println("LFO Speed = " + speed);
  }

  void changeDepth(float depthTemp) {
    depth = depthTemp;
    //println("LFO Depth = " + depth);
  }
}
