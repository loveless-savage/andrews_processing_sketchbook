//how many pixels to draw in each frame? 10 is a good slow speed
int drawSpeed = 10;


//store the growth of the dragon in a class
class dragonClass {

	//return the number of points to external methods
	public int size(){ return pts.length; }
	//store all generated points in an array
	PVector pts[]=new PVector[0];

	// what iteration is the fractal drawing now?
	int pivot_id=1;
	// return pivot_id to external methods
	public int pivot_id(){ return pivot_id; }
	// for each iteration, a pivot point is selected around which to reflect all other points
	PVector pivot=new PVector();

	//mirror_pt stores the current target point so it can be reflected
	PVector mirror_pt=new PVector();
	//mirror_pt_id stores the id of which point to rotate
	int mirror_pt_id;

	// constructor
	dragonClass(int dx, int dy){
		// begin with a single line, a pair of points
		pts=(PVector[])append(pts, new PVector(0,0) );
		pts=(PVector[])append(pts, new PVector(dx,dy) );

		println("You're getting sleepy... and you're about to be getting satisfied because this fills all white space");

		// second point in fractal is chosen as the first pivot point
		pivot=pts[pivot_id];
	}

	//grow adds each new point
	public void grow(){

		//mirror_pt_id stores the id of which point to rotate
		mirror_pt_id = pivot_id*2 - pts.length;

		//first, the world coordinates are translated so pivot is at origin
		mirror_pt=pts[mirror_pt_id].copy();
		mirror_pt.sub(pivot);
		//then, the x- and y-values are swapped
		//to rotate point clockwise 90º, y-value must be negated after inversion
		mirror_pt.set( mirror_pt.y, -mirror_pt.x );
		//then the now rotated point is translated back by adding the pivot point
		mirror_pt.add(pivot);

		//the final point value is added to the array
		pts=(PVector[])append(pts, mirror_pt );
	};

	//when an iteration is complete, a new pivot point is needed
	public void newiteration(){
		pivot_id=pts.length-1;
		pivot = pts[pivot_id];
	}

	// draw the most recent line
	public void drawlastline(){
		pushMatrix();
		// center on the source of the pixel
		translate(300,300);
		point(pts[pts.length-1].x,pts[pts.length-1].y);
		popMatrix();
	}
}

// the dragon itself!
dragonClass dragon1, dragon2, dragon3, dragon4;

// these functions make for a nice color spectrum
int skew(float depth){
    return 255+int(255.0*cos(PI*sin(depth)));
};
void convertToColor(float depth){
    int myred = skew(depth);
    int mygreen = skew(depth-PI/3);
    int myblue = skew(depth+PI/3);
    stroke(myred,mygreen,myblue);
};



void setup() {
	//the backdrop is black, like my soul
	background(0);

	// the dragon itself!
	dragon1=new dragonClass(1,0);
	dragon2=new dragonClass(0,1);
	dragon3=new dragonClass(-1,0);
	dragon4=new dragonClass(0,-1);
}

void settings(){
	size(600,600);
}

void draw() {
    //to change speed change number "10" below
	for(int i=0; i<drawSpeed; i++){

		//add another point to the fractal!
		dragon1.grow();
		//draw the new line
		convertToColor(sqrt(float( dragon1.size() ))/75.0);
		dragon1.drawlastline();

		//when all the points in an iteration have been calculated, a new pivot point is needed
		if(dragon1.pivot_id()*2<=dragon1.size()){
			dragon1.newiteration();
		}

		//add another point to the fractal!
		dragon2.grow();
		//draw the new line
		convertToColor(sqrt(float( dragon2.size() ))/75.0+PI/4);
		dragon2.drawlastline();

		//when all the points in an iteration have been calculated, a new pivot point is needed
		if(dragon2.pivot_id()*2<=dragon2.size()){
			dragon2.newiteration();
		}

		//add another point to the fractal!
		dragon3.grow();
		//draw the new line
		convertToColor(sqrt(float( dragon3.size() ))/75.0+PI/2);
		dragon3.drawlastline();

		//when all the points in an iteration have been calculated, a new pivot point is needed
		if(dragon3.pivot_id()*2<=dragon3.size()){
			dragon3.newiteration();
		}

		//add another point to the fractal!
		dragon4.grow();
		//draw the new line
		convertToColor(sqrt(float( dragon4.size() ))/75.0-PI/4);
		dragon4.drawlastline();

		//when all the points in an iteration have been calculated, a new pivot point is needed
		if(dragon4.pivot_id()*2<=dragon4.size()){
			dragon4.newiteration();
		}
	}
};
