class KinectTracker {

  // Depth threshold
  int threshold = 745;

  // Raw location
  PVector loc;

  // Intelocation
  PVector lerpedLoc;
  
  // Old Interpolated location
  PVector oldLerpedLoc;

  // Depth data
  int[] depth;
  
  // What we'll show the user
  PImage display;
   
  KinectTracker() {
    // This is an awkard use of a global variable here
    // But doing it this way for simplicity
    kinect.initDepth();
    kinect.enableMirror(true);
    // Make a blank image
    display = createImage(kinect.width, kinect.height, RGB);
    // Set up the vectors
    loc = new PVector(0, 0);
    lerpedLoc = new PVector(0, 0);
    oldLerpedLoc = new PVector(0, 0);
  }

  void track() {
    // Get the raw depth as array of integers
    depth = kinect.getRawDepth();

    // Being overly cautious here
    if (depth == null) return;

    float sumX = 0;
    float sumY = 0;
    float count = 0;

    for (int x = 0; x < kinect.width; x++) {
      for (int y = 0; y < kinect.height; y++) {
        
        int offset =  x + y*kinect.width;
        // Grabbing the raw depth
        int rawDepth = depth[offset];

        // Testing against threshold
        if (rawDepth < threshold) {
          sumX += x;
          sumY += y;
          count++;
        }
      }
    }
    
    // Update last lerped location
    oldLerpedLoc.x = lerpedLoc.x;
    oldLerpedLoc.y = lerpedLoc.y;
    
    // As long as we found something
    if (count != 0) {
      loc.set(sumX/count, sumY/count);
      
      // Interpolating the location, doing it arbitrarily for now
      if(oldLerpedLoc.x >= 0 && oldLerpedLoc.y >=0) {
        lerpedLoc.x = PApplet.lerp(oldLerpedLoc.x, loc.x, 0.3f);
        lerpedLoc.y = PApplet.lerp(oldLerpedLoc.y, loc.y, 0.3f);
      } else {
        lerpedLoc.set(sumX/count, sumY/count);
      }
    } else {
      loc.set(-1, -1);
      lerpedLoc.set(-1, -1);
    }
  }

  PVector getLerpedPos() {
    return lerpedLoc;
  }
  
  PVector getOldLerpedPos() {
    return oldLerpedLoc;
  }

  PVector getPos() {
    return loc;
  }

  void display() {
    PImage img = kinect.getDepthImage();

    // Being overly cautious here
    if (depth == null || img == null) return;

    // Going to rewrite the depth image to show which pixels are in threshold
    // A lot of this is redundant, but this is just for demonstration purposes
    display.loadPixels();
    for (int x = 0; x < kinect.width; x++) {
      for (int y = 0; y < kinect.height; y++) {

        int offset = x + y * kinect.width;
        // Raw depth
        int rawDepth = depth[offset];
        int pix = x + y * display.width;
        if (rawDepth < threshold) {
          // A red color instead
          display.pixels[pix] = color(150, 50, 50);
        } else {
          display.pixels[pix] = img.pixels[offset];
        }
      }
    }
    display.updatePixels();

    // Draw the image
    image(display, 0, 0);
  }

  int getThreshold() {
    return threshold;
  }

  void setThreshold(int t) {
    threshold =  t;
  }
}