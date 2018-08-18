class Parameter {

  //boundMode 0 is constrain boundMode 1 is wrap

  String name;
  float min;
  float max;
  float scale;
  int boundMode;

  float storedValue = 0;
  float defaultValue;

  Lfo lfoName;
  int speedOrDepth; //0 is no lfo parameters, 1 is lfoSpeed, 2 is lfoDepth

  int arcValue;

  Parameter (String nameTemp, float minTemp, float maxTemp, float scaleTemp, int boundModeTemp, float valueTemp) {
    name = nameTemp;
    min = minTemp;
    max = maxTemp;
    scale = scaleTemp;
    boundMode = boundModeTemp;
    storedValue = valueTemp;
    defaultValue = valueTemp;

    speedOrDepth = 0;

    arcValue = int(map(storedValue, min, max, 0, 63));
  }

  Parameter (String nameTemp, float minTemp, float maxTemp, float scaleTemp, int boundModeTemp, float valueTemp, Lfo lfoNameTemp, int speedOrDepthTemp) {
    name = nameTemp;
    min = minTemp;
    max = maxTemp;
    scale = scaleTemp;
    boundMode = boundModeTemp;
    storedValue = valueTemp;
    defaultValue = valueTemp;
    this.lfoName = lfoNameTemp; 

    speedOrDepth = speedOrDepthTemp;

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
    
    if (speedOrDepth == 1) {
      lfoName.changeSpeed(storedValue);
    } else if (speedOrDepth == 2) {
      lfoName.changeDepth(storedValue);
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

  int arcLedsCoarse() {
    int coarseLedValue = (int(map(storedValue, min, max, 0, 64)) % 65);
    return coarseLedValue;
  }

  int arcLedsFine() {
    float ledValue = map(storedValue, min, max, 0, 64);
    float extractDecimal = ledValue - floor(ledValue);
    int fineLedValue = floor(map(extractDecimal, 0, 1, 0, 15));

    return fineLedValue;
  }

  void setMax(float value) {
    max = value;
  }

  String name() {
    return name;
  }
}
