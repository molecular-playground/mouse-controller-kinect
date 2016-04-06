# mouse-controller-kinect
A "driver" for the Kinect v1 to control your mouse movements.

## Supported features
- "TOUCH" (default) and "DRAG" modes to control mouse movement
  - "TOUCH" moves the mouse to the position of your hand as if you were using a touchscreen
  - "DRAG" drags the mouse across the screen based on its current position
  - The default is "TOUCH"
- "PRESS" mode presses in the mouse whenever a hand is visible
  - "PRESS" is off by default
- The Kinect can be tilted up and down
- The depth threshold for capture can be changed
  - As of right now, everything closer to the Kinect than the specified threshold will also be captured

## Setup
Each release of mouse-controller-kinect will have downloadable executables in the "releases" tab on GitHub. Due to the library we are using to interact with the Kinect you may also need to install other software:

#### Mac OS X
Nothing, just run the application and you should be all set!

#### Windows
CAUTION: Untested! Based off of [here](https://github.com/shiffman/OpenKinect-for-Processing#linux).

- Java 8
- libusbK
  - Download [Zadig](http://zadig.akeo.ie/) to install the libusbK driver for the Kinect v1

#### Linux
CAUTION: Untested! Based off of [here](https://github.com/shiffman/OpenKinect-for-Processing#windows).
- Java 8
- libusb-1.0-0
- libusb-1.0-0-dev

It is also possible to build your own executables using Processing and the source code. Simply open this project in processing, then click ```File -> Export Application```. **Please note that with [Processing 3.0.2](https://processing.org/download/?processing) and [OpenKinect-for-Processing 1.0](https://github.com/shiffman/OpenKinect-for-Processing/releases/tag/1.0) the necessary jna.jar does not get included with any of the exported executables. You must manually add that jar in yourself.**

## Future development
- The ability to specify a plane in 3D space for capture
- Improved user interface (currently does not mention many of the supported features)
