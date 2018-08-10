float offset=0;
void setup(){
	size(400,400);
	colorMode(HSB);
	frameRate(60);
}
void draw(){
	background(255);
	pushMatrix();
	translate(200,200);
	for(int i=-300;i<300;i++){
		rotate(offset);
		stroke( (abs(i)+offset) % 330 , 255, 255);
		line(i,-300,i,300);
	}
	popMatrix();
	offset+=0.001;
};
