//dig a maze out of a grid of preexisting barriers

import java.util.ArrayList.*;//sh is an IntList

//size of maze square
final int msize=8;

//barrier type
class Bar {
	boolean p;//is the barrier opened?
	boolean s;//can I select it?
	boolean d;//which direction did I come at it?

	int[] pos = new int[3];//where is it?
	Bar (int v,int i,int j){
		pos=new int[]{v,i,j};
		p=false;
		s=false;
		d=false;
	}

	int shpos;//where is it in sh?

	int comppos(){//compressed position coordinate
		return pos[0]*msize*msize + pos[1]*msize + pos[2];
	}
};



//digger function- all the action is here
class Digger {
	//array of barriers
	//3D: bars [isVertical] [horizontal coord] [vertical coord]
	Bar[][][] bars=new Bar[2][][];//either horizontal or vertical

	void Digger(){
		bars[0]=new Bar[msize][msize-1];//horizontal barriers array has one less vertical coordinate
		bars[1]=new Bar[msize-1][msize];//vertical barriers array has one less horizontal coordinate

		//fill the arrays with barriers
		for(int i=0;i<msize;i++){//longer coordinates
		for(int j=0;j<msize-1;j++){//shorter coordinates

			bars[0][i][j] = new Bar(0,i,j);//horizontal barriers have longer horizontal coordinates

			bars[1][j][i] = new Bar(1,j,i);//vertical barriers have longer vertical coordinates
		}}
	};

	IntList sh=new IntList();//hold all the 2D coordinates of both directions of selectable barriers
	//holds them compressed into a single number each

	int[] b=new int[3];//hold currently selected barrier coordinates
	int[] t=new int[3];//hold barrier coordinates for labelling neighboring barriers as selectable

	void addtosh(){//add newly selectable barriers to sh

		//we use t[] instead of b[], since this is not the last-opened barrier, but the neightboring one
		bars[t[0]][t[1]][t[2]].shpos=sh.size();//bars.shpos holds the position of its coordinate in sh...
		//and since its coordinate is added to the end, we just measure the size of sh

		sh.append(bars[t[0]][t[1]][t[2]].comppos());//add the compressed barrier coordinate to the end of sh

	}

	void takefromsh(){
		sh.remove(bars[t[0]][t[1]][t[2]].shpos);//remove the compressed barrier coordinate from wherever it is in sh
	}

	void readfromsh(int idx){
		/*barrier coordinates are compressed in sh[] like this:
		  b[0]*msize^2 + b[1]*msize +b[2]
		 *thus every combination of coordinates in the domain has a unique compressed value
		 *to decompress it, we need to shave off the other parts for each coordinate
		 *when b[0] is 0, sh[idx] is always less than msize^2, and vice versa
		 *for b[1], we divide by msize and round down to shave off b[2], then we take the
		 modulus % with msize as divisor which returns the remainder
		 *for b[2], we find the remainder of sh[idx]/msize using the modulo operation
		 */

		b[0]=(sh.get(idx)>=msize*msize)?1:0;//is it less than msize^2?
		b[1]=floor(sh.get(idx)/msize) %msize;//find the 'tens' place
		b[2]=sh.get(idx) %msize;//find the 'ones' place
	};

	void spotMore(){
		//three bounding barriers surrounding newly opened scoop
		//*new scoop will always be surrounded by closed barriers, except for the one last opened
		for(int k=0;k<3;k++){
			t=b;//start at the opened barrier first, then transforn

			switch(k){
				//barrier across the scoop from the opened barrier
				case 0:
					//add 1 to the horizontal coordinate if the opened barrier is horizontal...
					//...and to the vertical coordinate if the opened barrier is vertical- that's the b[0] conditional in the 1st line of the statement
					//also, subtract if the the new scoop faces up or left- that's the bars[][][].d conditional in the 2nd line
					t[ b[0]==0/*horizontal or vertical*/ ? 1:2 ] +=
						bars[b[0]][b[1]][b[2]].d/*facing down/right or up/left */ ? 1:-1;

					break;

					//barrier adjacent to the opened barrier at top or left
				case 1:
					//flip from horizontal to vertical, or vice versa
					t[0]= 1-t[0];//this corresponds to a 0 becoming a 1, and a 1 becoming a 0

					//take 1 from the horizontal coordinate if the opened barrier is horizontal...
					//...and to the vertical coordinate if the opened barrier is vertical- that's the b[0] conditional in the 1st line of the statement
					//also, subtract if the the new scoop faces up or left- that's the bars[][][].d conditional in the 2nd line
					t[ b[0]==0/*horizontal or vertical*/ ? 1:2 ] +=
						bars[b[0]][b[1]][b[2]].d/*facing down/right or up/left */ ? -1:1;

					//if the scoop faces down or right, add 1 to...
					//...the horizontal axis if the opened barrier is vertical...
					//...or the vertical axis if the opened barrier is horizontal
					if(bars[b[0]][b[1]][b[2]].d){
						t[ b[0]==1/*horizontal or vertical*/ ? 1:2 ] ++;
					}

					break;

					//barrier adjacent to the opened barrier at bottom or right
				case 2:
					//flip from horizontal to vertical, or vice versa
					t[0]= 1-t[0];//this corresponds to a 0 becoming a 1, and a 1 becoming a 0

					//if the scoop faces down or right, add 1 to...
					//...the horizontal axis if the opened barrier is vertical...
					//...or the vertical axis if the opened barrier is horizontal
					if(bars[b[0]][b[1]][b[2]].d){
						t[ b[0]==1/*horizontal or vertical*/ ? 1:2 ] ++;
					}

					break;
			}

			//if the current bounding barrier is over the edge of the maze
			if(t[1]<0 || t[1]>=bars[t[0]].length){//left or right edge
				continue;//skip to the next of the three barriers
			}else if(t[2]<0 || t[2]>=bars[t[0]][t[1]].length){//top or bottom edge
				continue;//skip to the next of the three barriers
			}

			//turn selectability on or off in the spotted barrier
			if(bars[t[0]][t[1]][t[2]].s){//if the spotted barrier has already been spotted, turn it's selectability off
				bars[t[0]][t[1]][t[2]].s=false;
				takefromsh();
			}else{//if the spotted barrier has not yet been spotted, make it selectable
				bars[t[0]][t[1]][t[2]].s=true;
				addtosh();
			}
		}
	};

	void scoop(){
		//randomly select one of the selectable barriers
		readfromsh(floor( random(0,sh.size()) ));
		//b now contains the coordinates for the selected barrier

		//open the barrier!
		bars[b[0]][b[1]][b[2]].p=true;

		//add newly uncovered barriers to the register
		//also remove from the barrier those that are freestanding
		spotMore();
	}

	void drawThem(){
		//draw the barriers!
		for(int i=0;i<msize;i++){  for(int j=0;j<msize;j++){  //2D arrays, 2 indicies

			//horizontal barriers
			if(j!=msize-1 && !bars[0][i][j].p){//j!==msize-1 removes the last row of barriers

				stroke(bars[0][i][j].s?color(255,0,0):0);//color it red if it's selectable

				line(50+i*300/msize,//horizontal
						50+(j+1)*300/msize,
						50+(i+1)*300/msize,
						50+(j+1)*300/msize);
			}

			//vertical barriers
			if(i!=msize-1 && !bars[1][i][j].p){//!bars[1][i][j].p checks if the barrier is open

				stroke(bars[1][i][j].s?color(255,0,0):0);//color it red if it's selectable

				line(50+(i+1)*300/msize,//vertical
						50+j*300/msize,
						50+(i+1)*300/msize,
						50+(j+1)*300/msize);
			}
		}}
	};
};

//void setup(){

	Digger digger=new Digger();

	frameRate(2);//go real slow, so we can see what's going on

	digger.spotMore();
//}


//void draw() {
	size(400,400);
	background(200);
	fill(255);
	rect(50,50,300,300);
	fill(0);

	//take another scoop out of the maze
	digger.scoop();//still does nothing

	digger.drawThem();//draw all the barriers

//};

