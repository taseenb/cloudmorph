class Morph {
  
    PVector[] shape1, shape2, p, time, v1, v2, tmpShape;
    
    int shapeCount, shape1Count, shape2Count, maxShapeCount, minShapeCount, shapeCountDiff;
    int[] shape1Size = {0,0};
    boolean morphToNoise, noiseAnimation;
    float noiseValue = 0.008;
    
    int visiblePoints;


    Morph(PVector[] shape1_) {
        morphToNoise = true;
        shape1 = shape1_;
        shapeCount = shape1.length;
        shape1Size = getShapeSize(shape1);
        //println(shape1Size);
        setupArrays();
    }


    Morph(PVector[] shape1_, PVector[] shape2_, boolean noiseAnimation_) {
        morphToNoise = false;
        noiseAnimation = noiseAnimation_;
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
        tmpShape = new PVector[shapeCount];
        for (int i = 0; i < shapeCount; i++) {
            //p[i] = new PVector(width/2 * random(0.5, 1.5), height/2 * random(0.5, 1.5), 0);
            p[i] = new PVector(0, 0, 0);
            time[i] = new PVector(random(10000), random(10000), random(10000));
        }
    }
    
    
    int[] getShapeSize(PVector[] shape) {
      float minX = 0, maxX = 0, minY = 0, maxY = 0, minZ = 0, maxZ = 0;
      int[] size = new int[3];
      int shapeCount = shape.length;
      for (int i = 0; i < shapeCount; i++) {
        minX = shape[i].x < minX ? shape[i].x : minX;
        maxX = shape[i].x > maxX ? shape[i].x : maxX;
        
        minY = shape[i].y < minY ? shape[i].y : minY;
        maxY = shape[i].y > maxY ? shape[i].y : maxY;
        
        minZ = shape[i].z < minZ ? shape[i].z : minZ;
        maxZ = shape[i].z > maxZ ? shape[i].z : maxZ;
      }
      size[0] = (int) (maxX - minX);
      size[1] = (int) (maxY - minY);
      size[2] = (int) (maxZ - minZ);
      return size;
    }


    void updateAndDisplay(float amt) {
        if (morphToNoise) {
            morphToNoise(shape1, shape1Size, shapeCount, amt);
        } else if (noiseAnimation) {
            morphToNoiseToShape(amt);
        } else {
            morphToShape(amt);
        }
    }


    void morphToNoise(PVector[] shape, int[] size, int visiblePoints, float amt) {
        for (int i = 0; i < shapeCount; i++) {

            // Get random position with Perlin noise
            p[i].x = (noise(time[i].x) * size[0]) - size[0]/2;// + (width-size[0])/2;
            p[i].y = (noise(time[i].y) * size[1]) - size[1]/2;// + (height-size[1])/2;
            p[i].z = (noise(time[i].z) * size[2]) - size[2]/2;//- size[2] / 2;
//            p[i].x = (noise(time[i].x) * size[0]) + (width-size[0])/2;
//            p[i].y = (noise(time[i].y) * size[1]) + (height-size[1])/2;
//            p[i].z = (noise(time[i].z) * size[2]) - size[2] / 2;
            time[i].add(noiseValue, noiseValue, noiseValue);

            // Interpolate random position to point in the shape
            if (i < visiblePoints) {
              p[i].lerp(shape[i], amt);
  
              // Display
              point(p[i].x, p[i].y, p[i].z);
            }
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
    
    
    void morphToNoiseToShape(float amt) {
      float noiseAmt;
      visiblePoints = 0;
      
      for (int i = 0; i < shapeCount; i++) {
          if (i < minShapeCount) {
              
              // Interpolation between the 2 shapes
              tmpShape[i] = PVector.lerp(shape1[i], shape2[i], amt);
              visiblePoints++;
              
          } else if (i - minShapeCount < amt * shapeCountDiff) {
              
              // Interpolation between the extra points and the shape with more points
              // (extra points exist because we have fill the gap of points count bewtween the 2 shapes)
              tmpShape[i] = PVector.lerp(p[i], v1[i], amt);
              visiblePoints++;
              
          } else {
            
              tmpShape[i] = new PVector();
              
          }
      }
      
      
      if (amt < 0.5) { 
        noiseAmt = map(amt, 0, 0.5, 1, 0);
      } else {
        noiseAmt = map(amt, 0.5, 1, 0, 1);
      }

      noiseAmt = easeInOutCubic(noiseAmt, 0, 1, 1);
      morphToNoise(tmpShape, getShapeSize(tmpShape), visiblePoints, noiseAmt);
      
    }
    
    
    /**
     * easeInOutCubic
     * t = current time
     * b = start value
     * c = change in value
     * d = duration
     **/
    float easeInOutCubic(float t, float b, float c, float d) {
      t /= d/2;
      if (t < 1) return c/2*t*t*t + b;
      t -= 2;
      return c/2*(t*t*t + 2) + b;
    };
    
    float easeOutCubic(float t, float b, float c, float d) {
      t /= d;
      t--;
      return c*(t*t*t + 1) + b;
    };
    
    float easeInCubic(float t, float b, float c, float d) {
      t /= d;
      return c*t*t*t + b;
    };
    
    
    
    

}