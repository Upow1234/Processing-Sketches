class Parameter {

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