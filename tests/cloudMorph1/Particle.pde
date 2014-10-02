class Particle extends PVector
{
  PVector time = new PVector(random(10000),random(10000),random(10000));
  float noiseValue = 0.005;
  
  Particle(float x_, float y_, float z_) {
    super(x_, y_, z_);
  }
  
  void update() {
    x = (noise(time.x) * width);
    y = (noise(time.y) * height);
    z = (noise(time.z) * height) - height/2;
    time.add(noiseValue, noiseValue, noiseValue);
  }

  void morph(PVector shapePoint, float amt) {
    x = PApplet.lerp(x, shapePoint.x, amt);
    y = PApplet.lerp(y, shapePoint.y, amt);
    z = PApplet.lerp(z, shapePoint.z, amt);
  }

  void display() {
    point(x, y, z);
  }
  
};



