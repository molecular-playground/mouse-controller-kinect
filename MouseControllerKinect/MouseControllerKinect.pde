import java.awt.AWTException;
import java.awt.MouseInfo;
import java.awt.Point;
import java.awt.Robot;
import java.awt.event.InputEvent;
import java.awt.event.MouseEvent;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

// The kinect stuff is happening in another class
KinectTracker tracker;
Kinect kinect;
float deg;

// Robot for controlling mouse functions
Robot robot;

// Boolean determining if mouse will be pressed
boolean isMousePressEnabled;
boolean isMousePressed;

void setup() {
  size(640, 520);
  kinect = new Kinect(this);
  tracker = new KinectTracker(kinect);
  deg = kinect.getTilt();
  isMousePressEnabled = false;
  isMousePressed = false;
  
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
  drawPosition(v1, 50, 100, 250, 200);

  // Let's draw the "lerped" location, if there is one
  PVector v2 = tracker.getLerpedPos();
  drawPosition(v2, 100, 250, 50, 200);

  // Display some info
  int t = tracker.getThreshold();
  fill(0);
  text("threshold: " + t + "    " +  "framerate: " + int(frameRate) + "    " + 
    "RIGHT increase threshold, LEFT decrease threshold", 10, 500);
    
  handleMouse();
}

void drawPosition(PVector pos, int v1, int v2, int v3, int alpha) {
  if(pos.x >= 0 && pos.y >=0) {
    fill(v1, v2, v3, alpha);
    noStroke();
    ellipse(pos.x, pos.y, 20, 20);
  }
}

// Adjust the threshold with key presses
void keyPressed() {
  int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == RIGHT) {
      t+=5;
      tracker.setThreshold(t);
    } else if (keyCode == LEFT) {
      t-=5;
      tracker.setThreshold(t);
    } else if (keyCode == UP) {
      deg++;
      deg = constrain(deg, 0, 30);
      kinect.setTilt(deg);
    } else if (keyCode == DOWN) {
      deg--;
      deg = constrain(deg, 0, 30);
      kinect.setTilt(deg);
    }
  } else if (key == 'm') {
    isMousePressEnabled = !isMousePressEnabled;
  }
}

// Move the mouse by a given delta
void moveMouse(int deltaX, int deltaY) {
  Point p = MouseInfo.getPointerInfo().getLocation();
  robot.mouseMove(p.x + deltaX, p.y + deltaY);
}

void handleMouse() {
  PVector oldPos = tracker.getOldLerpedPos();
  PVector newPos = tracker.getLerpedPos();
  
  // Only enable mouse if in range
  if(newPos.x >= 0 && newPos.y >=0) {
    
    // Press/unpress the mouse if that setting is turned on/off
    if(isMousePressEnabled && !isMousePressed) {
     robot.mousePress(InputEvent.getMaskForButton(MouseEvent.BUTTON1));
     isMousePressed = true;
    } else if(!isMousePressEnabled && isMousePressed) {
     robot.mouseRelease(InputEvent.getMaskForButton(MouseEvent.BUTTON1));
     isMousePressed = false;
    }
    
    // Move mouse if there was an old location
    if(oldPos.x >= 0 && oldPos.y >=0) {
      moveMouse((int)(newPos.x-oldPos.x), (int)(newPos.y-oldPos.y));
    }
    
  // When mouse is out of range, unpress it
  } else if(isMousePressed) {
    robot.mouseRelease(InputEvent.getMaskForButton(MouseEvent.BUTTON1));
    isMousePressed = false;
  }
}