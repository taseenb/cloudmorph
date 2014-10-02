import peasy.*;

PeasyCam cam;

Particle[] p, shape;
int particlesCount;

TypoManager typo;

boolean recording = false;

float morphAmount;


void setup() {
  size(1024,768, OPENGL);
  smooth();
  noFill();
  stroke(0);
  strokeWeight(4);
  
  cam = new PeasyCam(this, 0,0,0, 1250);
  typo = new TypoManager(this,"Arial.ttf","Aiaiai!",10);

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
    for (int i=0; i < particlesCount; i++) {
      p[i].update();
      p[i].morph(shape[i], morphAmount);
      p[i].display();
    }
  }
  
  // Record frame
  if (recording) {
    saveFrame("frames/electricTypo_####.tiff");
  }
  
  // write the fps in the header of the window
  frame.setTitle(int(frameRate) + " fps");
}


void go() {
  // get particules from typo
  particlesCount = typo.listePoints.length;
  p = new Particle[particlesCount];
  shape = new Particle[particlesCount];
  PVector v;
  // create particles
  for (int i=0; i < particlesCount; i++) {
    v = typo.listePoints[i];
    p[i] = new Particle(v.x, v.y, v.z);
    shape[i] = new Particle(v.x, v.y, v.z);
  } 
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

