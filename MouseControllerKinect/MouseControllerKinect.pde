import java.awt.AWTException;
import java.awt.MouseInfo;
import java.awt.Point;
import java.awt.Robot;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

// The kinect stuff is happening in another class
KinectTracker tracker;
Kinect kinect;

// Robot for controlling mouse functions
Robot robot;

void setup() {
  size(640, 520);
  kinect = new Kinect(this);
  tracker = new KinectTracker(kinect);
  
  try {
    robot = new Robot();
  } catch (AWTException e) {
    println("Robot class not supported by your system!");
    exit();
  }
}

void draw() {
  background(255);

  // Run the tracking analysis
  tracker.track();
  // Show the image
  tracker.display();

  // Let's draw the raw location, if there is one
  PVector v1 = tracker.getPos();
  if(v1.x >= 0 && v1.y >=0) {
    fill(50, 100, 250, 200);
    noStroke();
    ellipse(v1.x, v1.y, 20, 20);
  }

  // Let's draw the "lerped" location, if there is one
  PVector v2 = tracker.getLerpedPos();
  if(v2.x >= 0 && v2.y >=0) {
    fill(100, 250, 50, 200);
    noStroke();
    ellipse(v2.x, v2.y, 20, 20);
  }

  // Display some info
  int t = tracker.getThreshold();
  fill(0);
  text("threshold: " + t + "    " +  "framerate: " + int(frameRate) + "    " + 
    "UP increase threshold, DOWN decrease threshold", 10, 500);
  
  // Move mouse if there was an old and new location
  PVector oldPos = tracker.getOldLerpedPos();
  PVector newPos = tracker.getLerpedPos();
  if(oldPos.x >= 0 && oldPos.y >=0 && newPos.x >= 0 && newPos.y >=0) {
    moveMouse((int)(newPos.x-oldPos.x), (int)(newPos.y-oldPos.y));
  }
}

// Adjust the threshold with key presses
void keyPressed() {
  int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t+=5;
      tracker.setThreshold(t);
    } else if (keyCode == DOWN) {
      t-=5;
      tracker.setThreshold(t);
    }
  }
}

// Move the mouse by a given delta
void moveMouse(int deltaX, int deltaY) {
  Point p = MouseInfo.getPointerInfo().getLocation();
  robot.mouseMove(p.x + deltaX, p.y + deltaY);
}