void setup(){
}

void draw(){
}


class 4DPos {
	float x,y,z,w;
	4DPos(float ix, float iy, float iz, float iw){
		x=ix;
		y=iy;
		z=iz;
		w=iw;
	}

	void rotate(4DPos angs){
		PVector temp = new PVector(x,z);

		temp.set(x,z);
		temp.rotate(angs.x);
		x=temp.x;
		z=temp.y;

		temp.set(y,w);
		temp.rotate(angs.w);
		y=temp.x;
		w=temp.y;

		temp.set(y,z);
		temp.rotate(angs.y);
		y=temp.x;
		z=temp.y;

		temp.set(x,w);
		temp.rotate(angs.z);
		x=temp.x;
		w=temp.y;
	}

	
};
