class Morph {
    PVector[] shape1, shape2, p, time, v1, v2;

    int shapeCount, shape1Count, shape2Count, maxShapeCount, minShapeCount, shapeCountDiff;
    boolean morphToNoise;
    float noiseValue = 0.005;


    Morph(PVector[] shape1_) {
        morphToNoise = true;
        shape1 = shape1_;
        shapeCount = shape1.length;
        
        setupArrays();
    }


    Morph(PVector[] shape1_, PVector[] shape2_) {
        morphToNoise = false;
        shape1 = shape1_;
        shape2 = shape2_;
        shape1Count = shape1.length;
        shape2Count = shape2.length;
        maxShapeCount = shape1Count >= shape2Count ? shape1Count : shape2Count;
        minShapeCount = shape1Count <= shape2Count ? shape1Count : shape2Count;
        shapeCount = maxShapeCount;
        shapeCountDiff = maxShapeCount - minShapeCount;
        v1 = shape1Count >= shape2Count ? shape1 : shape2; // shape with more points
        v2 = shape1Count <= shape2Count ? shape1 : shape2; // shape with less points

        setupArrays();
    }


    void setupArrays() {
        // Create the shape to be actually drawn
        p = new PVector[shapeCount];
        time = new PVector[shapeCount];
        for (int i = 0; i < shapeCount; i++) {
            p[i] = new PVector(width/2 * random(0.5, 1.5), height/2 * random(0.5, 1.5), 0);
            time[i] = new PVector(random(10000), random(10000), random(10000));
        }
    }


    void updateAndDisplay(float amt) {
        if (morphToNoise) {
            morphToNoise(amt);
        } else {
            morphToShape(amt);
        }
    }


    void morphToNoise(float amt) {
        for (int i = 0; i < shapeCount; i++) {

            // Get positions with Perlin noise
            p[i].x = (noise(time[i].x) * width);
            p[i].y = (noise(time[i].y) * height);
            p[i].z = (noise(time[i].z) * height) - height / 2;
            time[i].add(noiseValue, noiseValue, noiseValue);

            // Interpolation
            p[i].lerp(shape1[i], amt);

            // Display
            point(p[i].x, p[i].y, p[i].z);
        }
    }


    void morphToShape(float amt) {
        PVector v;
        for (int i = 0; i < shapeCount; i++) {
            if (i < minShapeCount) {
                
                // Interpolation between the 2 shapes
                p[i] = PVector.lerp(v2[i], v1[i], amt);

                // Display
                point(p[i].x, p[i].y, p[i].z);
                
            } else if (amt > 0.025 && i - minShapeCount < amt * shapeCountDiff) {
                
                // Interpolation between the extra points and the shape with more points
                // (extra points are added because we have fill the gap of points count bewtween the 2 shapes)
                v = PVector.lerp(p[i], v1[i], amt);
                
                // Display
                point(v.x, v.y, v.z);
                
            }
        }
    }

}
