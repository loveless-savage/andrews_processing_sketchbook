/*the Mandelbrot Set is graphed onto the complex plane.  That means that the point at (-1,2) is given the "c" value -1+2i, where i is the imaginary solution to √-1.
 *every point is given its "c" value and is put through a test:
   *set the universal variable "z" to zero.
        -"c" is different for each point but stays constant throughout the test
        -"z" is what changes throughout the test.
   *set z = z^2 + c. that means squaring zero at first, of course.
   *do it again: z = z^2 + c.
   *and again:   z = z^2 + c.
   *do that an infinite number of times. z will either shoot off to infinity or cycle around near zero forever.
   *if the c-value doesn't make z shoot off to infinity, color the point white.
   *all the rest of the points are left dark.
 
 *the computer can't really do the equation an infinite number of times, so we have a shortcut that makes it easier and even makes it colorful.
  *the program simply does the calculation about 20 times per point.  Most of the failing points are eliminated after 20 iterations, anyway.
  *but after each iteration, we see if the point's z-value has already exceeded some boundary.
    mathematically speaking, if the absolute value of z exceeds 2, z will shoot off from there.  That will tell us it diverges to infinity.
  *if a point fails the test, we will color it in.  The color depends on how many iterations before it passed the boundary.
  *this gives us an awesome rainbow effect, radiating around the passing points.
  *all the points that don't fail after 20 iterations are left blank.
  
 *It's called the Mandelbrot Set after Benoit Mandelbrot, who did tons of research on it.
  *called "set" because it's the set of complex numbers that passes the test.
 *It was first drawn by Robert W. Brooks and Peter Matelski in 1978 as an ASCII illustration with only a few hundred asterisk points.
 (source: Wikipedia)
 
 *It's a fractal because no matter how much you zoom into it, it always gets more detailed.
 *Actually, the Mandelbrot Set's border is by definition the most fractal-like it is possible to be.
  *the border's Hausdorff dimension is 2, one more than its intuitive dimension.
  *so, mathematically, the one-dimensional border acts two-dimensional!
  
 *Technically, the Mandelbrot set is a slice of a four-dimensional fractal.
 *Nobody has bothered to try drawing the four-dimensional fractal.
 *of course, that's because you can't really draw things in the fourth dimension... also, it would take vastly parallelized computing power to calculate its shape in full.
 *other slices of this "Mother Fractal" are called Julia sets.
  *There are many Julia Sets, each one having a universally set "c" value for every point.
  *Each point's coordinates are plugged into z's intitial value instead of into c.
*/








// each colored border contains the points that failed after some number of iterations- 20 is the max!
int resol=16;

// different window sizes: how much of the coordinate plane to show
final float windowSize=2.0;

// class that describes one point
class Pt {
	// coordinates
	PVector c,z;

	// initialize
	Pt(float a,float b){
		// c is the point coordinate; reference for z=z^2+c
		c=new PVector(a,b);
		// z is the dynamic value; changes as iterations progress
		z=new PVector(a,b);
	}

	// perform one iteration
	void it(){
		// first square the complex value z
		z.set( sq(z.x)-sq(z.y), 2*z.x*z.y );
		// then add c
		z.add(c);
	}
};

// coloring the points given a number of iterations
void colp(byte inputtedIndex){
	byte idx=inputtedIndex;
	idx*=2;
	if(idx<255){
		stroke(idx, 255, 255);
	}else{
		stroke(0, 255, 510-idx);
	}
};

// to begin, each point on the screen is tested using this template point
// if it does not exceed the limits, the point is left blank
Pt temp;

// put the size() function inside the settings command, so we can use the variable windowSize
void settings(){
	size(int(200*windowSize),int(200*windowSize));
}

void setup(){
	translate(125*windowSize,100*windowSize);
	background(255);
	colorMode(HSB,255);

// now let's draw it! We do it in setup()  because we don't want to do it in a loop forever
	// 400 lines
	for(float lineNum=-2.0;lineNum<2.0;lineNum+=0.01){
		// a single line
		for(float alongLine=-2.5;alongLine<1.5;alongLine+=0.01){
			// put new point into temp
			temp=new Pt(alongLine,lineNum);
			// iterate point by resol # of times
			for(byte iter=0;iter<resol;iter++){
				// if the point fails
				if(temp.z.mag()>=2){
					// points that fall outside the boundaries are colored in...
					colp(iter);//select the right color
					point( (int)(temp.c.x*100),(int)(temp.c.y*100) );//scale is 100px:1unit
					// ...and then the program moves on to the next point
					break;
				}
				temp.it();// do the next iteration
			}
		}
	}

	fill(0);
	delay(100);
}

void draw(){}

