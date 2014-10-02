import peasy.*;

PeasyCam cam;

PVector[] shape1, shape2;
int shape1Count, shape2Count;

Morph morph;

TypoManager typo1, typo2;

boolean recording = false;

float morphAmount;


void setup() {
  size(1024,768, OPENGL);
  smooth();
  noFill();
  stroke(0);
  strokeWeight(4);
  
  cam = new PeasyCam(this, 0,0,0, 1250);
  typo1 = new TypoManager(this,"Arial.ttf","Aiaiai!",10);
  typo2 = new TypoManager(this,"Arial.ttf","Nooo!",10);

  go();
}


void draw() {
  background(255);
  cam.lookAt(0,0,0);
  
  // Draw particles
  translate(-(width/2), -(height/2), 0);
  if (frameCount < 1) {
    go();
  } else {
    morphAmount = (float)mouseY/height; // float 0 to 1
    morph.updateAndDisplay(morphAmount);
  }
  
  // Record frame
  if (recording) {
    saveFrame("frames/electricTypo_####.tiff");
  }
  
  // write the fps in the header of the window
  frame.setTitle(int(frameRate) + " fps");
}


void go() {
  shape1Count = typo1.listePoints.length;
  shape2Count = typo2.listePoints.length;
  shape1 = new PVector[shape1Count];
  shape2 = new PVector[shape2Count];
  PVector v;
  for (int i=0; i < shape1Count; i++) {
    v = typo1.listePoints[i];
    shape1[i] = new PVector(v.x, v.y, v.z);
  }
  for (int i=0; i < shape2Count; i++) {
    v = typo2.listePoints[i];
    shape2[i] = new PVector(v.x, v.y, v.z);
  } 
  
  morph = new Morph(shape1, shape2);
}







void keyReleased() {
  if (key == 's' || key == 'S') {
    saveFrame("img/electricTypo_####.png");
  } else if (key == 'r' || key == 'R') {
    recording = !recording;
  } else if (key == '0') {
    go();
  }
}

