import peasy.*;
import java.util.*;


PeasyCam cam;
OBJModel model1, model2;
PVector[] model1Vertices, model2Vertices;
float model1ScaleAmount = 10, model2ScaleAmount = 400;

Morph morph;
float morphAmount = 0, morphSpeed = 0.003;

boolean recording = false, pause = true;
float pauseSeconds = 0.5, pauseCount = pauseSeconds*60; // pause in ms


void setup() {
    size(1024, 768, OPENGL);
    smooth(8);
    //noFill();
    stroke(0);
    strokeWeight(2);

    cam = new PeasyCam(this, 0, 0, 0, 1250);
    
    model1 = new OBJModel(this, "cat.obj");
    model2 = new OBJModel(this, "dog.obj");
    model1Vertices = model1.getVertices();
    model2Vertices = model2.getVertices();
    
    setupModels();
}



void draw() {
    background(255);
    cam.lookAt(0, 0, 0);
    lights(); 
    
    rotateY(HALF_PI);
    
    if (frameCount < 1) {
        setupModels();
    } else {
      
        // Pause between morphings
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
        saveFrame("frames/cloudMorph_####.tiff");
    }

    // write the fps in the header of the window
    frame.setTitle(int(frameRate) + " fps");
}


void setupModels() {
    int vertex1Count = model1Vertices.length;
    int vertex2Count = model2Vertices.length;
    
    for (int i = 0; i < vertex1Count; i ++) {
      model1Vertices[i].mult(model1ScaleAmount);
    }
    for (int i = 0; i < vertex2Count; i ++) {
      model2Vertices[i].mult(model2ScaleAmount);
    }
  
    // Shuffle arrays
    shuffleArray(model1Vertices);
    shuffleArray(model2Vertices);

    // Create a morph object with the two arrays
    morph = new Morph(model1Vertices, model2Vertices, true);
    //morph = new Morph(model1Vertices);
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
        saveFrame("img/cloudMorph_####.png");
    } else if (key == 'r' || key == 'R') {
        recording = !recording;
    } else if (key == '0') {
        setupModels();
    }
}

