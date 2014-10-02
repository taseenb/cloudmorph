import saito.objloader.*;

import peasy.*;
import java.util.*;

PeasyCam cam;

OBJModel model1, model2;
// BoundingBox is a class within OBJModel. Check docs for all it can do.
BoundingBox bbox;

PVector[] shape1, shape2;
int shape1Count, shape2Count;

Morph morph;

TypoManager typo1, typo2;

boolean recording = false, pause = true;
int pauseSeconds = 1, pauseCount = pauseSeconds*60; // pause in ms

float morphAmount = 0, morphSpeed = 0.005;


void setup() {
    size(1024, 768, OPENGL);
    smooth(8);
    //noFill();
    stroke(0);
    strokeWeight(3);

    cam = new PeasyCam(this, 0, 0, 0, 1250);
    typo1 = new TypoManager(this, "Arial.ttf", "What!?!?", 10);
    typo2 = new TypoManager(this, "Arial.ttf", "Wooow!", 10);
    
    //model1 = new OBJModel(this, "bird.obj", "relative", QUADS);
    //model1 = new OBJModel(this, "christmas_cane.obj", "relative", QUADS);

    go();
}


void draw() {
    background(255);
    cam.lookAt(0, 0, 0);
    lights();

    //model1.draw();

    // Draw particles
    translate(-(width / 2), -(height / 2), 500);
    
    
    //rect(0,0, width, height);
    if (frameCount < 1) {
        go();
    } else {
        //morphAmount = (float) mouseY / height; // float 0 to 1
        
        if (!pause) {
          morphAmount += morphSpeed;
          morphAmount = constrain(morphAmount, 0, 1);
          if (morphAmount >=1 || morphAmount <=0) {
            pause = true;
            morphSpeed = -1 * morphSpeed;
          }
        } else if (pause) {
          pauseCount--;
          if (pauseCount <= 0) {
            pauseCount = pauseSeconds*60;
            pause = false;
          }
        }
        
        morph.updateAndDisplay(morphAmount);
        
    }

    // Record frame
    if (recording) {
        saveFrame("frames/electricTypo_####.tiff");
    }
    
    //saveFrame("frames/electricTypo_####.tiff");

    // write the fps in the header of the window
    frame.setTitle(int(frameRate) + " fps");
}


void go() {

    // Create two arrays of PVectors from typography
    shape1Count = typo1.listePoints.length;
    shape2Count = typo2.listePoints.length;
    shape1 = new PVector[shape1Count];
    shape2 = new PVector[shape2Count];
    PVector v;
    for (int i = 0; i < shape1Count; i++) {
        v = typo1.listePoints[i];
        shape1[i] = new PVector(v.x, v.y, v.z);
    }
    for (int i = 0; i < shape2Count; i++) {
        v = typo2.listePoints[i];
        shape2[i] = new PVector(v.x, v.y, v.z);
    }

    // Shuffle arrays
    shuffleArray(shape1);
    shuffleArray(shape2);

    // Create a morph object with the two arrays
    morph = new Morph(shape1, shape2, true);
    //morph = new Morph(shape1);
}


// Implementing Fisher–Yates shuffle
void shuffleArray(PVector[] ar) {
    Random rnd = new Random();
    for (int i = ar.length - 1; i > 0; i--) {
        int index = rnd.nextInt(i + 1);
        // Simple swap
        PVector a = ar[index];
        ar[index] = ar[i];
        ar[i] = a;
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

