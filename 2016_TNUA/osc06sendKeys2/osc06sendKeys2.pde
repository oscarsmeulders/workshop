// Collaborative drawing for 3 people
import oscP5.*;
import netP5.*;

OscP5 oscP5;

NetAddress other1;
int other1X, other1Y, other1Pressed;

NetAddress other2;
int other2X, other2Y, other2Pressed;

// TODO: make this unique for each participant
int myself = 1; // others will probably be 2 and 3

void setup() {
  size(400, 400);
  oscP5 = new OscP5(this, 12000);

  other1 = new NetAddress("192.168.X.X", 12000);
  other2 = new NetAddress("192.168.X.Y", 12000);

  oscP5.plug(this, "otherDrag", "/drag");
  oscP5.plug(this, "otherRelease", "/release");
  oscP5.plug(this, "clearScreen", "/clear");
  oscP5.plug(this, "drawLine", "/drawLine");

  background(0);// black background
  noStroke();
  fill(255, 20); // white with 20% alpha (very transparent)
}
void draw() {  
  // Then: try to replace triangle with 3 ellipses.
  if (mousePressed == true && other1Pressed == 1 && other2Pressed == 1) {
    triangle(mouseX, mouseY, other1X, other1Y, other2X, other2Y);
  }
  
  // Also: we can send key press events to others.
  // For instance, SPACE to erase the screen, L to draw a random line.
}
void mouseDragged() {
  OscMessage msg = new OscMessage("/drag");  
  msg.add(mouseX);
  msg.add(mouseY);
  msg.add(myself);
  oscP5.send(msg, other1);
  oscP5.send(msg, other2);
}
void mouseReleased() {
  OscMessage msg = new OscMessage("/release");
  msg.add(myself);
  oscP5.send(msg, other1);
  oscP5.send(msg, other2);
}
void keyPressed() {
  if(key == ' ') {
    // do something if we pressed space
    OscMessage msg = new OscMessage("/clear");
    oscP5.send(msg, other1);
    oscP5.send(msg, other2);
    clearScreen();
  }
  if(key == 'l') {
    OscMessage msg = new OscMessage("/drawLine");
    oscP5.send(msg, other1);
    oscP5.send(msg, other2);
    drawLine();
  }
  // more key tests here if you want
}
// otherDrag runs when receiving a /drag OSC message
void otherDrag(int x, int y, int who) {
  // TODO: if I'm 1, check 2 and 3
  // if I'm 2, check 1 and 3
  // if I'm 3, check 1 and 2
  if(who == 2) {
    other1X = x;
    other1Y = y;
    other1Pressed = 1;
  }
  if(who == 3) {
    other2X = x;
    other2Y = y;
    other2Pressed = 1;
  }
}
// otherReleased runs when receiving a /release OSC message
void otherReleased(int who) {
  // TODO: if I'm 1, check 2 and 3
  // if I'm 2, check 1 and 3
  // if I'm 3, check 1 and 2
  if(who == 2) {
    other1Pressed = 0;
  }
  if(who == 3) {
    other2Pressed = 0;
  }
}
void clearScreen() {
  background(0);
}
void drawLine() {
  stroke(random(255));
  strokeWeight(5);
  // random start and end point for this line
  line(random(width), random(height), random(width), random(height));
}