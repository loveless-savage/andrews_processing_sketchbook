/* WELCOME TO THE BRAIN PLASTICITY GAME
 * use keys as listed at the top to move
 * click inside the canvas to respawn
*/

// randomly select keys for control?
var randomKeys=true;

// adjust this value to change starting x coordinate
// 300 = start
// 3000 = ladder
// 4300 = pillars
// 5700 = herring bone
// 6200 = thumbtacks
var off=300;

// change to 1 to reverse left/right arrow keys
var reversed=0;

// array of barrier coordinates
var bar_coords=[
0,500,1000,50, // bottom
0,50,35,450, // back wall
565,50,35,400, // low pass wall
900,420,200,50, // ascending steps
1100,340,200,50,
1300,260,150,50,
1450,180,100,50, // lily pads
1650,180,100,50,
1850,180,100,50,
2100,180,100,50, // stairs
2150,230,100,50,
2200,280,100,50,
2250,330,100,50,
2300,380,100,50,
2350,430,100,50,
2400,480,100,50,
2450,530,100,50,
2650,500,530,50, // stair landing
2800,0,35,450, // low pass wall
3200,420,50,50, // ladder
3050,320,50,50,
3200,220,50,50,
3050,120,50,50,
3250,90,150,50, // ladder top
3500,170,25,25, // buttons
3600,240,25,25,
3700,310,25,25,
3900,380,25,25,
4080,440,25,25,
4250,550,100,50, // landing
4400,450,50,150, // pillars
4500,340,50,260,
4600,230,50,370,
4700,165,50,435,
4700,115,450,50, // pillar top
5100,165,50,150, // left hook
5050,265,50,165,
5100,380,50,50,
5250,-10,50,210, // middle key
5300,160,50,160,
5250,270,50,220,
5300,390,60,70,
5254,550,246,50, // right key
5450,475,55,125,
5505,150,50,375,
5455,273,50,100,
5505,100,350,50, // right key platform
5950,-25,50,150, // herring bone spine
5970,125,15,65,
5975,215,15,60,
5980,300,15,60,
5985,385,15,60,
5955,190,50,25, // herring bone spurs
5960,275,50,25,
5965,360,50,25,
5970,445,50,25,
5975,530,70,50, // below the herring bone
6150,100,250,50, // platform
6500,200,10,10, // thumbtacks
6600,300,10,10,
6700,400,10,10,
6900,500,10,10,
7080,470,10,10,
7275,550,10,10,
7430,500,3,50, // knife walk
7590,450,3,50,
7750,400,3,50,
7850,300,3,50,
8025,280,3,50,
8150,200,3,50,
8300,150,300,50, // runway
];


// set up barrier class
{
// barrier constructor
var bar = function(xi,yi,xli,yli) {
    // position of top left corner
    this.x=xi;
    this.y=yi;
    // width and height
    this.xl=xli;
    this.yl=yli;
    // temporary variables for corner resolution
    this.bx=0;
    this.by=0;
    this.px=0;
    this.py=0;
};//bar constructor

// corner collision utility
var hitsSide = function(px,py,dp,bx,by){
    // calculate vector from player's corner to barrier corner
    var bp = new PVector(bx,by); // given barrier corndernates
    bp.sub(px,py); // ... and player corndernates
    // corner + coordinates = corndernates XD
    
    // if player-barrier vector is steeper than dp...
    if(abs(bp.y/bp.x) > abs(dp.y/dp.x)){
        // ... hit a side of the barrier
        return false;
    } // otherwise hit the top or bottom
    return true;
};

// is the player colliding with this barrier?
bar.prototype.collide = function(player) {
// is the player even going to hit this barrier?
    // if any side of the player falls outside...
    if( this.x+this.xl  <= player.p.x+player.dp.x-25 ||
        this.x          >= player.p.x+player.dp.x+25 ||
        this.y+this.yl  <= player.p.y+player.dp.y-50 ||
        this.y          >= player.p.y+player.dp.y
    ){
        return;
    }// ... we know the player does not touch this block
    
    // don't worry about last frame
    this.norms=0;

// which edges are being crossed in this frame?
    // hit right side of bar
    if(this.x+this.xl > player.p.x+player.dp.x-25 &&
       this.x+this.xl <= player.p.x-25){
            this.norms |= 1<<0;
    }// right
    // hit left side of bar
    if(this.x < player.p.x+player.dp.x+25 &&
       this.x >= player.p.x+25){
            this.norms |= 1<<1;
    }// left
    // hit bottom of bar
    if(this.y+this.yl > player.p.y+player.dp.y-50 &&
       this.y+this.yl <= player.p.y-50){
            this.norms |= 1<<2;
    }// bottom
    // hit top of bar
    if(this.y < player.p.y+player.dp.y &&
       this.y >= player.p.y){
            this.norms |= 1<<3;
    }// top
    
// reduce corner collisions to a single edge
    // check to see if two adjacent edges even are being crossed now
    if((this.norms>>2) && (this.norms&3)){
        // identify which edges are being crossed
        if(this.norms&3 === 1){ // right
            this.bx = this.x+this.xl;
            this.px = player.p.x-25;
        }else{ // left
            this.bx = this.x;
            this.px = player.p.x+25;
        }
        if(this.norms>>2 === 1){ // bottom
            this.by = this.y+this.yl;
            this.py = player.p.y-50;
        }else{ // top
            this.by = this.y;
            this.py = player.p.y;
        }
        //
        // calculate which of the two edges is hit first
        if(hitsSide(this.px,this.py,player.dp,this.bx,this.by)){
            // neutralize all but side coordinate
            this.norms &= 3;
        }else{
            // neutralize all but top/bottom coordinates
            this.norms &= 3<<2;
        }
        //this.norms &=3<<2;
    } // corndernates
    
// send edge coordinate to player class
    switch(this.norms){
    case 1<<0: // right
        if((this.x+this.xl <= player.ncoords[0]) === false){
            player.ncoords[0] = this.x+this.xl;
        }// right
        break;
    case 1<<1: // left
        if((this.x >= player.ncoords[1]) === false){
            player.ncoords[1] = this.x;
        }// left
        break;
    case 1<<2: // bottom
        if((this.y+this.yl <= player.ncoords[2]) === false){
            player.ncoords[2] = this.y+this.yl;
        }// bottom
        break;
    case 1<<3: // top
        if((this.y >= player.ncoords[3]) === false){
            player.ncoords[3] = this.y;
        }// top
        break;
    default: // no collision
    }
    
    return this.norms;

};//bar.prototype.collide

// draw rectangle where the barrier is located
bar.prototype.draw = function() {
    pushMatrix();
    translate(this.x,this.y);
    fill(255, 0, 0);
    rect(0,0,this.xl,this.yl);
    popMatrix();
};//bar.prototype.draw
}

// array of bars
var barray = [];
// add all coordinates from array we made at top
for(var i=0;i<bar_coords.length;i+=4){
    barray.push(new bar(bar_coords[i],bar_coords[i+1],bar_coords[i+2],bar_coords[i+3]));
}


// events are good for arrows and freefall
var event = function(id){
    this.id = id;
    this.isDown = false;
    this.when = 0;
};

// handle control keys- arrows or letters
if(randomKeys){
    var arrows=[];
    // autogenerate random letter keys in place of arrow keys
    for(var i=0;i<3;i++){
        arrows.push(new event( floor(random(65,91)) ));
        // eliminate duplicates
        for(var j=0;j<i;j++){
            while( arrows[i].id === arrows[j].id ){
                arrows[i].id = floor(random(65,91));
            }
        }
    }
}else{
    // arrow keys as they always are
    var arrows=[
        new event(RIGHT),
        new event(LEFT),
        new event(UP)
    ];
}



// player avatar, with all associated functions
var player = {
    // hold the position
    p: new PVector(off,0),
    // change in position
    dp: new PVector(0,0),
    
    // pulsing?
    takingDamage:false,
    
    
    // jumping event, with jumping power as argument
    jump: new event(0),
    // jump strength & gravity strength
    jump_strength:15,
    gravity_strength:1,
    vel_terminal:50,
    // gravity
    gravity:function(){
        // if first frame of jump
        if(this.jump.isDown && arrows[2].isDown){
            // add a bunch to negative vertical
            this.dp.y = -this.jump_strength;
            // remember we are now jumping
            //this.jump.isDown = false;
        
        // if in the midst of jumping and terminal velocity unreached
        }else if(this.dp.y < this.vel_terminal){
            this.dp.y += this.gravity_strength;
        }
    },
    
    // how fast do the arrow keys move?
    arrowSideSpeed: 5,
    
    // left and right arrows move it side to side
    sideways:function(arrows){
        // if right pressed only, or right pressed later than left
        if(arrows[0].isDown*arrows[0].when >
           arrows[1].isDown*arrows[1].when){
            // move right
            this.dp.x = this.arrowSideSpeed;
            
        // if right not pressed, and left is pressed
        }else if(arrows[1].isDown){
            this.dp.x =-this.arrowSideSpeed;
            
        }else{
            // if neither, do nothing
            this.dp.x = 0;
        }
        
        // switch directions
        if(reversed){
            this.dp.x*=-1;
        }
    },
    
    
    // collisions
    norms:0,
    // collision coordinates
    ncoords:[0,0,0,0],
    
/**/
    // collide with all barriers in the master array
    collide:function(barray){
        // last frame doesn't apply here
        this.norms=0;
        // we want any barrier value to feel assertive at first
        this.ncoords=['n','n','n','n'];
        
        for(var i=0;i<barray.length;i++){
            // collide with each bar
            this.norms |= barray[i].collide(this);
        }
        
        // figure out what to do with the results
        // we will only get one edge from each barrier
        // so resolve normals from all barriers
        if(this.norms & 1<<0){ // right
            this.dp.x = (this.ncoords[0]) -(this.p.x-25);
        }
        if(this.norms & 1<<1){ // left
            this.dp.x = (this.ncoords[1]) -(this.p.x+25);
        }
        if(this.norms & 1<<2){ // bottom
            this.dp.y = (this.ncoords[2]) -(this.p.y-50);
        }
        if(this.norms & 1<<3){ // top
            this.dp.y = (this.ncoords[3]) -(this.p.y);
            // remember when player fell onto the barrier
            if(!this.jump.isDown){
                this.jump.when = frameCount;
            }
            // stop falling
            this.jump.isDown = true;
        }else{ // if not falling on top of something, we are in freefall
            this.jump.isDown=false;
        }
        
    },
    
    
    // respawn
    respawn:function(){
        this.p.x = off;
        this.p.y = 0;
    },
    
    // update position, accounting for all factors
    update:function(){
        // arrow keys side to side
        this.sideways(arrows);
        
        // jumping and gravity
        this.gravity();
        
        // barrier normals
        this.collide(barray);
        
        // actually update the position
        this.p.add(this.dp);
        
        // if fallen too far down
        if(this.p.y > 1000){
            this.respawn();
        }
    },


    // draw to the screen
    draw:function(){
        pushMatrix();
        // rectangle is relative to player's position
        translate(this.p.x,this.p.y);
        
        // toggle color
        if(this.takingDamage && frameCount%12<6){
            fill(0,127,0);
        }else{
            fill(0, 255, 0);
        }
        
        // draw rectangle sitting on position point
        if(this.jump.isDown && this.jump.when>frameCount-5){
            rect(-28,-45,56,45); // squash on landing
        }else if(arrows[2].isDown){
            rect(-22,-55,44,57); // stretch when leaping
        }else if(this.dp.x>0){
            quad(-22,-50,-28,0,22,0,28,-50); // lean side to side
        }else if(this.dp.x<0){
            quad(-28,-50,-22,0,28,0,22,-50);
        }else{
            rect(-25,-50,50,50); // sitting still
        }
        popMatrix();
    }
};



// primary loop
var draw = function() {
    background(0);
    noStroke();
    pushMatrix();
    translate(width/2-player.p.x,0);
    // figure out player motion
    player.update();
    // draw player
    player.draw();
    // draw barriers
    for(var i=0;i<barray.length;i++){
        barray[i].draw();
    }
    
    // end text
    {
    // red herring message
    fill(255, 145, 0);
    textAlign(LEFT,TOP);
    textSize(30);
    text("almost there- leap of faith!",8450,200);
    // gotcha
    fill(127,255,0);
    textFont(createFont("monospace")); // for ascii art
    textSize(10);
    text("    \\\n\\    \\__\n |    _ \\\n |   ( \\_|\n | \\  ~~ \\\n | \\`~;~\"\n \\ \"-_>\n  `\"",9000,300);
    // go back to non-ascii art font
    textFont(createFont("sans-serif"));
    }
    popMatrix();
    
    fill(255);
    // top text only if we are randomly selecting which keys to use
    if(randomKeys){
        textSize(30);
        textAlign(LEFT,TOP);
        text("left = "+String.fromCharCode(arrows[1].id),5,5);
        textAlign(CENTER,TOP);
        text("jump = "+String.fromCharCode(arrows[2].id),300,5);
        textAlign(RIGHT,TOP);
        text("right = "+String.fromCharCode(arrows[0].id),595,5);
    }
};


// respawn on click
var mouseClicked = function(){
    player.p.x=mouseX+off-300;
    player.p.y=0;
};


// handle control key events
{
var keyPressed = function(){
    // only test arrow object that matches key just pressed
    for(var i=0;i<arrows.length;i++){   if(keyCode === arrows[i].id){
        // only record press-down time if it was off before
        if(arrows[i].isDown === false){
            arrows[i].when = frameCount;
        }
        arrows[i].isDown = true;
    }}
};
var keyReleased = function(){
    // only test arrow object that matches key just released
    for(var i=0;i<arrows.length;i++){    if(keyCode === arrows[i].id){
        arrows[i].isDown = false;
    }}
};
}

