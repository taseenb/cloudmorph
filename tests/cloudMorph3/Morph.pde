class Morph 
{

	PVector[] shape1, shape2, p, time;

	int shape1count, shape2count;
	boolean morphToNoise;
	float noiseValue = 0.005;


	Morph(PVector[] shape1_) {
		morphToNoise = true;
		shape1 = shape1_;
		shape1count = shape1.length;
		setup();
	}

	Morph(PVector[] shape1_, PVector[] shape2_) {
		morphToNoise = false;
		shape1 = shape1_;
		shape2 = shape2_;
		shape1count = shape1.length;
		shape2count = shape2.length;
		setup();
	}

	void setup() {
		// Create the shape to be actually drawn
		p = new PVector[shape1count];
		time = new PVector[shape1count];
		for (int i=0; i < shape1count; i++) {
			p[i] = new PVector();
			time[i] = new PVector(random(10000),random(10000),random(10000));
		}
	}

	void updateAndDisplay(float amt) {
		for (int i=0; i < shape1count; i++) {

			// Get positions with Perlin noise
			p[i].x = (noise(time[i].x) * width);
			p[i].y = (noise(time[i].y) * height);
			p[i].z = (noise(time[i].z) * height) - height/2;
			time[i].add(noiseValue, noiseValue, noiseValue);

			// Lerp
			p[i].lerp(shape1[i], amt);

			// Display
			point(p[i].x, p[i].y, p[i].z);
		}
	}


}