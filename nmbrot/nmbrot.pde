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
 
 *the computer can't really do the equation an infinite number of times, so we have a shortcut that makes it easier and even makes it more beautiful.
  *the program simply does the calculation about 20 times per point.  Most of the failing points are eliminated after 20 iterations, anyway.
  *but after each iteration, we see if the point's z-value has already exceeded some boundary.
    matheatically speaking, if the absolute value of z exceeds 2, z will shoot off from there.  That will tell us it diverges to infinity.
  *if a point fails the test, we will color it in.  The color depends on how many iterations before it passed the boundary.
  *this gives us an awesome rainbow effect, radiating around the passing points.
  *all the points that don't fail after 20 iterations are left blank.
  
 *It's called the Mandelbrot Set after Benoit Mandelbrot...
  ...who did tons of research on it.
  *called "set" because it's the set of complex numbers that passes the test.
 *First drawn by Robert W. Brooks and Peter Matelski in 1978
 (source: Wikipedia)
 
 *It's a fractal because no matter how much you zoom, it gets more detailed.
 *Actually, its border is by definition the most fractal-like it is possible to be.
  *the border's Hausdorff dimension is 2, one more than its intuitive dimension.
  *so, mathematically, the one-dimensional border acts two-dimensional!
  
 *Technically, the Mandelbrot set is a slice of a four-dimensional fractal.
 *Nobody has bothered to try drawing the four-dimensional fractal.
 *of course, that's because you can't really draw things in the fourth dimension... also, it would take huge computing power to calculate its shape in full.
 *other slices of this "Mother Fractal" are called Julia sets.
  *There are many Julia Sets, each one having a universally set "c" value for every point.
  *Each point's coordinates are plugged into z's intitial value instead of into c.
*/








//each colored border contains the points that failed after some number of iterations- 20 is the max!
final int resol=16;

//different window sizes: how much of the coordinate plane to show
final float windowSize=3.0;

class Pt {
	PVector z,c;
	Pt(float A,float B,float C,float D){
		//z is the dynamic value; changes as iterations progress
		z=new PVector(A,B);
		//c is the constant value; reference for z=z^2+c
		c=new PVector(C,D);
	}

	//one iteration
	void it(){
		//first square the complex value z
		z.set( sq(z.x)-sq(z.y), 2*z.x*z.y );
		//then add c
		z.add(c);
	}

	//is the test passing?
	boolean pass=true;
};

//to begin, each point on the screen is tested in this template point
//if it does not exceed the limits, the point is left blank
Pt temp;

//sliceName is the name for each TIFF file saved for each slice
String sliceName="";

//set size of the window; we need the settings() function to make the compiler shut up
void settings(){
	size(ceil(200*windowSize),ceil(200*windowSize));
}


//all the action
void setup(){
	translate(100*windowSize,100*windowSize);
	stroke(255);

	//#(windowSize) slices
	for(float sliceNum=-windowSize;sliceNum<windowSize;sliceNum+=0.01){
		background(0);

		//#(windowSize) lines
		for(float lineNum=-windowSize;lineNum<windowSize;lineNum+=0.01){
			//a single line
			for(float alongLine=-windowSize;alongLine<windowSize;alongLine+=0.01){

				//put new point into temp
				temp=new Pt( 0.0,sliceNum, alongLine,lineNum );
				//this new point always starts out not failing!
				temp.pass=true;

				//iterate point by resol # of times
				for(byte iter=0;iter<resol;iter++){
					//if the point fails
					if(temp.z.mag()>=2){
						//didn't pass
						temp.pass=false;
						break;
					}
					temp.it();//do the next iteration
				}
				//color the point in only if it passed!
				if(temp.pass){
					point( (int)(temp.c.x*100),(int)(temp.c.y*100) );//scale is 100px:1unit
				}
			}
		}

		//new file name, using whichever slice has been just drawn
		//use nf to convert the current slice number to an index value
		//add windowSize so negative values wouldn't mess up alphabetical order
		sliceName=nf( (int)( (sliceNum+windowSize)*100 ) ,3);//3 digits

		//so we know how far along the program is going
		println(sliceName);

		//add file syntax stuff on either side of new file name
		sliceName="m_"+sliceName+".tiff";

		save(sliceName);
		delay(1);

	}

	exit();
}

void draw(){}

