class Morph 
{

	PVector[] shape1, shape2, p;

	int shape1count, shape2count;
	boolean morphToNoise;

	PVector time = new PVector(random(10000),random(10000),random(10000));
	float noiseValue = 0.005;

	float x, y, z;


	Morph(PVector[] shape1_) {
		morphToNoise = true;
		shape1 = shape1_;
		shape1count = shape1.length;
		p = new PVector[shape1count];
		for (int i=0; i < shape1count; i++) {
			p[i] = new PVector(0, 0, 0);
		}
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
			p[i].x = (noise(time.x) * width);
			p[i].y = (noise(time.y) * height);
			p[i].z = (noise(time.z) * height) - height/2;
			time.add(noiseValue, noiseValue, noiseValue);
		}
	}

	void lerp(float amt) {
		for (int i=0; i < shape1count; i++) {
			p[i].x = PApplet.lerp(p[i].x, shape1[i].x, amt);
			p[i].y = PApplet.lerp(p[i].y, shape1[i].y, amt);
			p[i].z = PApplet.lerp(p[i].z, shape1[i].z, amt);
		}
	}

	void display() {
		for (int i=0; i < shape1count; i++) {
			point(p[i].x, p[i].y, p[i].z);
		}
	}

}