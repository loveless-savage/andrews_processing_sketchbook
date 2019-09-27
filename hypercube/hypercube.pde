int stageNum=0;
int order=0;

void settings(){
	size(1536,150);
}

void setup(){
	order=floor(log(width/3)/log(2));
	println(order);

	noStroke();
	fill(0);

	background(0,0,50);
	rect(0,height-order*3,width,order*3);
	rect(0,0,width,order*3);

	fill(0,255,0);
	rect(pow(2,order-1)*3-1,height/2-1,2,2);
}

void draw(){
	int bitSum=0;
	for(int bit=0;bit<order;bit++){
		bitSum += (stageNum>>bit)&1;
	}

	fill(stageNum*255*3/width);
	if(bitSum*2>order && stageNum*2<=pow(2,order)) fill(350-stageNum*255*3/width,0,0);
	rect(stageNum*3,height-bitSum*6,3,bitSum*6);

	if(bitSum*2>order && stageNum*2>pow(2,order)){
		rect(pow(2,order)*3-stageNum*3-3,height-bitSum*6,3,bitSum*6);
	}
	//rect(width-stageNum*3-3,0,3,bitSum*6);

	stageNum++;
	if(stageNum>=width) noLoop();
}
