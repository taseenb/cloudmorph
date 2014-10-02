import peasy.*;
import java.util.*;

PeasyCam cam;

PVector[] shape1, shape2;
int shape1Count, shape2Count;

Morph morph;

TypoManager typo1, typo2;

boolean recording = false;

float morphAmount;


void setup() {
    size(1024, 768, OPENGL);
    smooth();
    noFill();
    stroke(0);
    strokeWeight(4);

    cam = new PeasyCam(this, 0, 0, 0, 1250);
    typo1 = new TypoManager(this, "Arial.ttf", "Ssssssst!", 10);
    typo2 = new TypoManager(this, "Arial.ttf", "s", 10);

    go();
}


void draw() {
    background(255);
    cam.lookAt(0, 0, 0);

    // Draw particles
    translate(-(width / 2), -(height / 2), 500);
    rect(0,0, width, height);
    if (frameCount < 1) {
        go();
    } else {
        morphAmount = (float) mouseY / height; // float 0 to 1
        //morphAmount = map(mouseY, 50, height-50, 0, 1);
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
    morph = new Morph(shape1, shape2);
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

