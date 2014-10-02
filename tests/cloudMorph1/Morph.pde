class Morph 
{

	PVector[] shape1, shape2;
	int shape1count, shape2count;
	boolean morphToNoise;

	PVector time = new PVector(random(10000),random(10000),random(10000));
  	float noiseValue = 0.005;

  	float x, y, z;


	Morph(PVector[] shape1_) {
		morphToNoise = true;
		shape1 = shape1_;
		shape1count = shape1.length;
	}


	Morph(PVector[] shape1_, PVector[] shape2_) {
		morphToNoise = false;
		shape1 = shape1_;
		shape2 = shape2_;
		shape1count = shape1.length;
		shape2count = shape2.length;
	}

	void update() {
		for (int i=0; i < shape1count; i++) {
			x = (noise(time.x) * width);
			y = (noise(time.y) * height);
			z = (noise(time.z) * height) - height/2;
			time.add(noiseValue, noiseValue, noiseValue);
		}
	}

	void lerp(float amt) {
		if (morphToNoise) {
			for (int i=0; i < shape1count; i++) {
				x = PApplet.lerp(x, shape1[i].x, amt);
				y = PApplet.lerp(y, shape1[i].y, amt);
				z = PApplet.lerp(z, shape1[i].z, amt);
			}
		}
	}

	void display() {
		point(x, y, z);
	}

}