void feedbackDisplay(PImage output) {
 
  tint(255, (255 * (feedbackLevel.value() + addBright.value())));  //THIS IS BAD OOP!!!
  image(output, 0, 0);
  
}


void feedbackCapture(PImage output) {
  loadPixels();
  output.loadPixels();

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {

      int location = x + (y * width);

      output.pixels[location] = pixels[location];
    }
  }
  
  output.updatePixels();
  updatePixels();
}