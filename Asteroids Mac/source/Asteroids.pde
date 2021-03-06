//NOTE: TO ACTIVATE SHOOTING WHILE HACKED,
//MAKE SURE TO TAKE OUT PART WHERE IT DOESN'T CHECK IF ITS HACKED, 
//THE PART WHERE IT DEALTH WITH THE PROJECTILES
//AND THE PART IF IT CHECKS IF A PROJECTILE HITS AN ASTEROIDS
int livesAlloted;

class Motion{
  
  float angle;
  
  
  float xVel;
  float yVel;
  float angleVel;
  
  float combinedVel; 
  
  float xAccel;
  float yAccel;
  float angleAccel;
  
  float ratio;
  
  boolean spaceship;
  
  float terminalVelocity;
  
  Motion(float a, float xV, float yV, float aV, float xA, float yA, float aA, float tV, boolean s){
    angle=a;
    xVel=xV;
    yVel=yV;
    angleVel=aV;
    xAccel=xA;
    yAccel=yA;
    angleAccel=aA;
    ratio=xVel/yVel;
    float powyX=pow(xVel, 2);
    float powyY=pow(yVel, 2);
    combinedVel=pow(powyX+powyY, 0.5);
    terminalVelocity=tV;
    spaceship=s;
  }
  
  void update(){
    angle+=angleVel;
    
    
    angleVel+=angleAccel;
    if(xVel>=0) xVel+=xAccel;
    else if(xVel<0) xVel-=xAccel;
    if(yVel>=0) yVel+=yAccel;
    else if(yVel<0) yVel-=yAccel;
    float powyX=pow(xVel, 2);
    float powyY=pow(yVel, 2);
    combinedVel=pow(powyX+powyY, 0.5);  // pythagorean theorem to find magnitude of total
    if(combinedVel>terminalVelocity){
      yAccel=0;
      xAccel=0;
    }  
    
    
   
   if(angle>radians(360)) angle%=radians(360);
   else if(angle<-radians(360)) angle%=radians(-360);
   /*
   if(angle>0 && angle<radians(180)) angle=angle;
   
   else if(angle>radians(180)){
        angle%=radians(180);
        angle=-angle;
        angle=PI+angle;
      
    }
    
    else if(angle<0 && angle>radians(-180)){
      angle=angle;
    }
    
    else if(angle<radians(-180)){
      angle%=radians(-180);
      angle=-angle;
      angle=PI-angle;
    }
    */
}
  
  void getAngleWithRat(){
    angle=atan(-xVel/yVel);
  }
  
  void getRatWithAngle(){
    ratio=tan(angle);
  }
  
  void getVels(){
    if(spaceship){
        if(!stoppingForward && !stoppingBackward){
          xVel=sin(angle)*combinedVel;
          yVel=-cos(angle)*combinedVel; 
        }
        else{
          xVel=sin(angleAtStop)*combinedVel;
          yVel=-cos(angleAtStop)*combinedVel; 
        }
    }
    else{
      xVel=sin(angle)*combinedVel;
      yVel=-cos(angle)*combinedVel;
    }
  }
  
}


class Projectile{
  int radius;
  color col;
  float totalMoved;
  boolean appear;
  
  float xPos;
  float yPos;
  
  float angleOfDir;
  
  float totalSpeed;
  
  boolean bounceAtEdge;
  
  Projectile(int r, int c1, int c2, int c3, boolean BAE, float tS, float aOD, float xP, float yP, boolean a){
    radius=r;
    col=color(c1, c2, c3);
    bounceAtEdge=BAE;
    totalSpeed=tS;
    angleOfDir=aOD;
    xPos=xP;
    yPos=yP;
    appear=a;
    totalMoved=0;
  }
  
  void moveProjectile(Motion moveSpecs){
    xPos+=moveSpecs.xVel;
    yPos+=moveSpecs.yVel;
    float powyX=pow(moveSpecs.xVel, 2);
    float powyY=pow(moveSpecs.yVel, 2);
    totalMoved+=pow(powyX+powyY, 0.5);
    
    if(totalMoved>=20){
      appear=true;
    }
    
    if(bounceAtEdge){
      if(xPos>width){
        xPos=0;
      }
      
      else if(xPos<0){
        xPos=width;
      }
      
      if(yPos<0){
        yPos=height;
      }
      
      else if(yPos>height){
        yPos=0;
      }
      
    }
    
  }
  
  void render(){
    int alpha;
    if(appear){
      alpha=255;
    }
    
    else{
      alpha=0;
    }
    
    fill(col, alpha);
    noStroke();
    pushMatrix();
    translate(xPos, yPos);
    rotate(angleOfDir);
    ellipse(0, 0, radius, radius);
    popMatrix();
  }
  
}

class Spaceship{
  float xTop;
  float yTop;
  float xBotLeft;
  float yBotLeft;
  float xMidPoint;
  float yMidPoint;
  float xBotRight;
  float yBotRight;
  
  color col;
  
  int lives; 
  
  boolean bounceAtEdge;
  boolean flameOn;
  
  float flameTopLeft;
  float flameTopRight;
  float flameBot;
  
  Spaceship(float xMP, float yMP, float xT, float yT, float xBL, float yBL, float xBR, float yBR, boolean BAE, int c1, int c2, int c3){
    flameOn=false;
    xMidPoint=xMP;
    yMidPoint=yMP;
    xTop=xT;
    yTop=yT;
    xBotLeft=xBL;
    yBotLeft=yBL; 
    xBotRight=xBR;
    yBotRight=yBR;
    col=color(c1, c2, c3);
    bounceAtEdge=BAE;
    lives=livesAlloted; 
  }
  
  void updateFlame(){
    if(flameOn){
      stroke(255, 0, 0);
      line(lerp(0, -15, 0.5), lerp(0, 20, 0.5), 0, 25);
      line(0, 25, lerp(0, 15, 0.5), lerp(0, 20, 0.5));
    }
  }
  
  void move(Motion moveSpecs){
    if(upPressed || stoppingForward){
      xTop+=moveSpecs.xVel;
      yTop+=moveSpecs.yVel;
      xBotLeft+=moveSpecs.xVel;
      yBotLeft+=moveSpecs.yVel;
      xMidPoint+=moveSpecs.xVel;
      yMidPoint+=moveSpecs.yVel;
      xBotRight+=moveSpecs.xVel;
    }
    if(backPressed || stoppingBackward){
      xTop-=moveSpecs.xVel;
      yTop-=moveSpecs.yVel;
      xBotLeft-=moveSpecs.xVel;
      yBotLeft-=moveSpecs.yVel;
      xMidPoint-=moveSpecs.xVel;
      yMidPoint-=moveSpecs.yVel;
      xBotRight-=moveSpecs.xVel;
      yBotRight-=moveSpecs.yVel;
    }
    
    if(bounceAtEdge){
      if(xMidPoint>width){
        xMidPoint=0;
      }
      else if(xMidPoint<0){
        xMidPoint=width;
      }
      
      if(yMidPoint>height){
        yMidPoint=0;
      }
      
      else if(yMidPoint<0){
        yMidPoint=height;
      }
      
    }
    
  }
  
  void render(){
    noFill();
    pushMatrix();
    translate((int)mySpaceship.xMidPoint,  (int)mySpaceship.yMidPoint);
    rotate(spaceshipMotion.angle);
    
    spaceshipMotion.update();
    spaceshipMotion.getVels();
    if(stoppingForward){
      if((stoppedGoingDir && spaceshipMotion.yVel>=0) || (!stoppedGoingDir && spaceshipMotion.yVel<=0)){
        stoppingForward=false;
      }
    }
    if(stoppingBackward){
      if((!stoppedGoingDir && spaceshipMotion.yVel<=0.1) || (stoppedGoingDir && spaceshipMotion.yVel>=-0.1)){
        stoppingBackward=false;
      }
    }
    mySpaceship.move(spaceshipMotion);
    if(upPressed) flameOn=true;
    else  flameOn=false;
    if(countingDown) flameOn=false;
    updateFlame();
    
    stroke(mySpaceship.col);
    if(showStuff) stroke(mySpaceship.col, 75);
    quad(0, -20, -15, 20, 0, 0, 15, 20);
    if(showStuff){
      fill(255);
      ellipse(0, -20, 3, 3);
      noFill();
      stroke(255);
      ellipse(0, 0, 20, 20);
      stroke(255, 0, 0, 150);
      if(shotPressed) line(0, -20, 0, -100000);
    }
    
    popMatrix();
  }
  
  void hit(){
    if(lives==0) gameOver=true;
    background(0);
    asteroids.clear();
    asteroidMotion.clear();
    projectNumCount=0;
    xMidPoint=500;
    yMidPoint=350;
    xTop=500;
    yTop=330;
    xBotLeft=485;
    yBotLeft=370;
    xBotRight=515;
    yBotRight=370;
    spaceshipMotion.xVel=0;
    spaceshipMotion.yVel=0;
    spaceshipMotion.angle=0;
    spaceshipMotion.xAccel=0;
    spaceshipMotion.yAccel=0;
    spaceshipMotion.angleVel=0;
    spaceshipMotion.angleAccel=0;
  }
  
}

class Asteroid{
  float centerX;
  float centerY;
  
  int size; 
  
  int numOfPoints;
  
  float xPs[]=new float[100];
  float yPs[]=new float[100];
  
  boolean grazed;
  
  float radius;
  
  color col;
  
  Asteroid(float cX, float cY, int s, int c1, int c2, int c3, int n){
    centerX=cX;
    centerY=cY;
    size=s;
    radius=pow(2, size+3);
    numOfPoints=n; 
    genPoints();
    col=color(c1, c2, c3);
    grazed=false;
  }
  
  void genPoints(){
    float r2=pow(radius, 2);
    
    float xtoThe2;
    float ytoThe2;
    
    float randvals[]=new float[numOfPoints];
    
    int chanceHappen;
    
    for(int i=0; i<numOfPoints; i++){
      
      int quotient=(int)radius*2/numOfPoints;
      float product=(radius*2)/numOfPoints;
      product*=i;
      int randy=(int)random(product, product+quotient);
      randvals[i]=randy-radius;
    }
    /*
    for(int i=0; i<5; i+=2){
      xPs[i]=randvals[i];
      chanceHappen=(int)random(2);
    
      xtoThe2=pow(xPs[i], 2);
      yPs[i]=pow(r2-xtoThe2, 0.5);
      if(chanceHappen==0) yPs[i]=-yPs[i];
    }

    for(int i=1; i<5; i+=2){
      yPs[i]=randvals[i];
      chanceHappen=(int)random(2);
    
      ytoThe2=pow(yPs[i], 2);
      xPs[i]=pow(r2-ytoThe2, 0.5);
      if(chanceHappen==0) xPs[i]=-xPs[i];
    }
    */
    
    for(int i=0; i<numOfPoints; i++){
      xPs[i]=randvals[i];
    
      xtoThe2=pow(xPs[i], 2);
      yPs[i]=pow(r2-xtoThe2, 0.5);
      if(i%2==1) yPs[i]=-yPs[i];
    }

    
  }
  
  void render(Motion moveSpecs){
    centerX+=moveSpecs.xVel;
    centerY+=moveSpecs.yVel;
    pushMatrix();
    translate((int)centerX, (int)centerY);
    rotate(moveSpecs.angle); 
    fill(255);
    stroke(255);
    /*
    line(x1, y1, x2, y2);
    line(x2, y2, x3, y4);
    line(x3, y3, x4, y4);
    line(x4, y4, x5, y5);
    line(x5, y5, x6, y6);
    */
    
    /*
    for(int i=1; i<numOfPoints-1; i++){
      //point(xPsSorted[i], yPsSorted[i]);
      line(xPsSorted[i], yPsSorted[i], xPsSorted[i+1], yPsSorted[i+1]);
      line(xPs[i], yPs[i], xPs[i+1], yPs[i+1]);
    }*/
    
    for(int i=1; i<numOfPoints-2; i+=2){
      line(xPs[i], yPs[i], xPs[i+2], yPs[i+2]);
    }
    
     for(int i=0; i<numOfPoints-2; i+=2){
      line(xPs[i], yPs[i], xPs[i+2], yPs[i+2]);
    }
    
    line(xPs[0], yPs[0], xPs[1], yPs[1]);
    line(xPs[numOfPoints-1], yPs[numOfPoints-1], xPs[numOfPoints-2], yPs[numOfPoints-2]); 
    
    
    if(showStuff){
      noFill();
      ellipse(0, 0, (int)radius*2, (int)radius*2);
    }
    popMatrix();
  }
  
}


Spaceship mySpaceship=new Spaceship(500, 350, 500, 330, 485, 370, 515, 370, true, 255, 255, 255);
Motion spaceshipMotion=new Motion(0, 0, 0, 0, 0, 0, 0, 7, true);

ArrayList<Asteroid> asteroids;
ArrayList<Motion> asteroidMotion;



boolean upPressed=false;
boolean rightPressed=false;
boolean leftPressed=false;
boolean backPressed=false;
boolean stoppingForward=false;
boolean stoppingBackward=false;

boolean allowBackward=false; 

boolean countDown=false;
boolean showRules=true;

boolean stoppedGoingDir=false; //true is up

boolean shotPressed=false;

float angleAtStop;
int ammoCount=40;
int ammoLeft=ammoCount;

int timesGrazed=0;


Projectile myProjectiles[]=new Projectile[200];
Motion projectileMotion[]=new Motion[200];

int deathCounter=0;

PFont myFont;
PFont myBigFont;
PFont mySmallFont;

float goSpeed=2.5;
boolean showStuff=false;
float rotSpeed=4;

int projectNumCount=0;
int projectileDelay=15;
int delayCount=0;

int asteroidSpawnChance=40;

int score=0; 

float speedRange=5;

boolean countingDown=false;
int countDownCounter=0;
int countDownLeft=3;

boolean counting=false;

boolean gameOver=false;

boolean paused=true;

boolean mousyPressed=false;

String texty="";

float levelTimeTotal=30;
float levelTimeLeft=levelTimeTotal;
float levelTimeCounter=0;
int levelOn=1;

int astyPlus=100;

int shotsFired=0;
int shotsHit=0;

public void setup(){
  
  frameRate(60);
  size(1000, 700);
  background(0);
  rectMode(CENTER);
  smooth();
  myFont=loadFont("Serif-20.vlw");
  myBigFont=loadFont("Serif-48.vlw");
  mySmallFont=loadFont("Serif-10.vlw");
  
  asteroids=new ArrayList<Asteroid>();
  asteroidMotion=new ArrayList<Motion>();
  
  
  if(showRules){ 
      int spaceBetween=40;
      textFont(myFont);
      textAlign(CENTER);
      text("Press 'p' to toggle pause", 500, 100);
      text("Press W, A, D or up, left, right arrow keys to move forward, rotate left, rotate right", 500, 120+spaceBetween);
      text("Press SPACE, 'z', or click to shoot", 500, 100+2*spaceBetween);
      text("You have a certain amount of lives determined by your difficulty and 40 ammo to start off with", 500, 100+3*spaceBetween);
      text("Everytime you hit an asteroid you get +1 ammo", 500, 100+4*spaceBetween);
      text("Every level lasts 30 seconds", 500, 100+5*spaceBetween);
      text("Every time a level ends you get replenished ammo and replenished lives,\nbut you get less ammo every level and the asteroids come faster and harder", 500, 120+6*spaceBetween); 
      textFont(myBigFont);
      text("Press:\n '1' for easy, '2' for normal,\n '3' for hard, '4' for insanity", 500, 100+9*spaceBetween); 
      textFont(myFont);
      textAlign(RIGHT);
      textMode(MODEL);
      text(texty, 990, 690);
    }
  
}




//Motion projectileMotion
public void draw(){
  
  if(!paused){
    showRules=false;
    background(0); 
    if(countingDown) mySpaceship.flameOn=false;
    mySpaceship.render();
    fill(255);
    stroke(255);
    textFont(myFont);
    textAlign(LEFT);
    text("Ammo Left: ", 10, 20);
    text(ammoLeft, 120, 20);
    textAlign(RIGHT);
    text("Lives left: "+mySpaceship.lives, 990, 20);
    text("Times grazed: "+timesGrazed, 990, 40);
    textAlign(CENTER);
    text("Score: "+score, 500, 20);
    if(levelTimeLeft>10){
      fill(255);
      stroke(255);
      text("Level: "+levelOn+"       Level time left: "+String.format("%.0f", levelTimeLeft), 500, 40);
    }
    
    
    
    else{
      textAlign(CENTER);
      fill(255);
      stroke(255);
      text("Level: "+levelOn+"       Level time left: ", 500, 40);
      textFont(myBigFont);
      textAlign(LEFT);
      fill(255, 0, 0);
      stroke(255, 0, 0);
      text(String.format("%.1f", levelTimeLeft), 620, 50);
    }
    
  }
  
  if(!countingDown && !paused && !gameOver){
    int spawnHappen=(int)random(asteroidSpawnChance); 
    if(spawnHappen==0) spawnAsteroid(speedRange, false, -300, -300, 3);
    if(mousyPressed){
      mouseMove();
    }
    if(shotPressed && delayCount==0 && ammoLeft>0){
      shot();
    }
    dealWithProjectiles();
    dealWithAsteroids();
    countLevel();
  }
    
    
  
  else if((paused || showRules)&& !countingDown){
    
    
    if(!showRules){
      
      textFont(myBigFont);
      textAlign(CENTER);
      text("PAUSED", 500, 100);
      textFont(myFont);
      text("Press 'r' to restart", 500, 140);
      text("Press 'p' to toggle pause", 500, 160);
    }  
    
    String newLine="\n";
    
    if(showRules){ 
      background(0);
      
      int spaceBetween=40;
      textFont(myFont);
      textAlign(CENTER);
      text("Press 'p' to toggle pause", 500, 100);
      text("Press W, A, D or up, left, right arrow keys to move forward, rotate left, rotate right", 500, 120+spaceBetween);
      text("Press SPACE, 'z', or click to shoot", 500, 100+2*spaceBetween);
      text("You have a certain amount of lives determined by your difficulty and 40 ammo to start off with", 500, 100+3*spaceBetween);
      text("Everytime you hit an asteroid you get +1 ammo", 500, 100+4*spaceBetween);
      text("Every level lasts 30 seconds", 500, 100+5*spaceBetween);
      text("Every time a level ends you get replenished ammo and replenished lives,\nbut you get less ammo every level and the asteroids come faster and harder", 500, 120+6*spaceBetween); 
      textFont(myBigFont);
      text("Press:\n '1' for easy, '2' for normal,\n '3' for hard, '4' for insanity", 500, 100+9*spaceBetween); 
      textFont(mySmallFont);
      textAlign(RIGHT);
      textMode(MODEL);
    }
     
  }
  
  else if(countingDown){
    countdown();
    mySpaceship.flameOn=false;
    fill(0);
    rectMode(CENTER);
    noStroke();
    if(paused || showRules){
      rect(676, 87, 55, 47);
      fill(255);
      stroke(255);
      textFont(myBigFont);
      textAlign(CENTER);
      text(countDownLeft, 660, 97);
    }
    
    
    else{
      rect(500, 250, 55, 50);
      fill(255);
      stroke(255);
      textFont(myBigFont);
      textAlign(CENTER);
      text(countDownLeft,500, 260);
    }
  }
  
  if(gameOver){
    float shotsyHit=shotsHit;
    float shotsyFired=shotsFired;
    float accur;
    if(shotsyHit==0 || shotsyFired==0){
      accur=0.0;
    } 
    else{
      accur=(shotsyHit/shotsyFired)*100;
    }
    background(0);
    fill(167, 17, 17);
    stroke(167, 17, 17);
    textFont(myBigFont);
    textAlign(CENTER);
    text("GAME OVER", 500, 350); 
    fill(255);
    textFont(myFont);
    text("Your score was: "+score, 500, 400);
    text("Your level was: "+levelOn, 500, 450);
    text("You died "+deathCounter+" times", 500, 500);
    text("You had "+accur+"% accuracy", 500, 550);
    text("You were grazed "+timesGrazed+" times", 500, 600);
    text("Press '1' for easy, '2' for normal, '3' for hard, '4' for insanity", 500, 650);
  }
  fill(255);
  stroke(255);
  textFont(mySmallFont);
  textAlign(RIGHT);
  textMode(MODEL);
  text(texty, 990, 690);
  
}

void turnCountDownOn(){
  countingDown=true;
  countDownLeft=3;
}

void countLevel(){
  levelTimeCounter++;
  if(levelTimeLeft>10){
    if(levelTimeCounter==60){
      levelTimeLeft--;
      levelTimeCounter=0;
    }
  }
  else{
    if(levelTimeCounter==6){
      levelTimeLeft-=0.1;
      levelTimeCounter=0;
    }
  }
  if(levelTimeLeft<=0){
    turnCountDownOn();
    if(ammoCount-((2*levelOn)-1)>=3) ammoLeft=ammoCount-((2*levelOn)-1);
    if(asteroidSpawnChance>10) asteroidSpawnChance-=3;
    speedRange+=1.5;
    levelOn++;
    levelTimeLeft=levelTimeTotal;
    levelTimeCounter=0;
    mySpaceship.hit();
    gameOver=false;
    astyPlus+=50;
    score+=3000+((levelOn-2)*1000);
    mySpaceship.lives=livesAlloted;
  }
}

void dealWithProjectiles(){
  if(!showStuff){
    if(projectNumCount==200){
        projectNumCount=1;
      }
      for(int i=0; i<projectNumCount; i++){
        projectileMotion[i].getVels();
        myProjectiles[i].moveProjectile(projectileMotion[i]);
        myProjectiles[i].render();
      }
      if(delayCount==projectileDelay){
        delayCount=0;
        counting=false;
      }
      else if(counting) delayCount++;
  }
}

void dealWithAsteroids(){
  for(int i=asteroids.size()-1; i>=1; i--){
      if(asteroids.get(i).centerX>width+2000 || asteroids.get(i).centerX<-2000 || asteroids.get(i).centerY>height+2000 || asteroids.get(i).centerY<-2000){
        asteroids.remove(i);
        asteroidMotion.remove(i);
        return;
      }
        asteroidMotion.get(i).update();
        asteroids.get(i).render(asteroidMotion.get(i));
        if(showStuff){
          
          float xPosy=sin(spaceshipMotion.angle)*20;
          float yPosy=-cos(spaceshipMotion.angle)*20;
          for(int j=0; j<10000; j++){
            if(asteroids.size()==i) return;
            if(dist(lerp(mySpaceship.xMidPoint, mySpaceship.xMidPoint+xPosy, (j/20)+1), lerp(mySpaceship.yMidPoint, mySpaceship.yMidPoint+yPosy, (j/20)+1), asteroids.get(i).centerX, asteroids.get(i).centerY)<=asteroids.get(i).radius){
              pushMatrix();
              fill(255, 0, 0);
              stroke(255, 0, 0);
              ellipse(asteroids.get(i).centerX, asteroids.get(i).centerY, asteroids.get(i).radius*2, asteroids.get(i).radius*2);
              popMatrix();
              if(shotPressed){
                asteroidHit(i, true, 0);
              }
              
              
              break;
            }
          }
        }
        checkAsteroidHit(i);
        if(checkSpaceshipHit(i)) return;
  }
}

void asteroidHit(int i, boolean easter, int j){
  if(easter==false){
    ammoLeft++;
    shotsHit++;
    if(asteroids.get(i).size==1){
      asteroids.remove(i);
      asteroidMotion.remove(i);
    }
    else{
      for(int k=-1; k<2; k+=2){
        float distBetween=asteroids.get(i).radius/2;
        float angly=projectileMotion[j].angle;
        
        angly+=radians(90); //perpendicular
        
        float xVely=sin(angly)*distBetween;
        float yVely=-cos(angly)*distBetween;
        
        xVely*=k;
        yVely*=k;
        
        float xPosy=asteroids.get(i).centerX+xVely;
        float yPosy=asteroids.get(i).centerY+yVely;
        spawnAsteroid(speedRange, true, xPosy, yPosy, asteroids.get(i).size-1);
      }
      asteroids.remove(i);
      asteroidMotion.remove(i);
    }
    score+=astyPlus;
    if(projectileMotion[j].xVel<0) myProjectiles[j].xPos=-10000;
    else if(projectileMotion[j].xVel>=0) myProjectiles[j].xPos=10000;
    
    
    if(projectileMotion[j].yVel<0) myProjectiles[j].yPos=-10000;
    else if(projectileMotion[j].yVel>=0) myProjectiles[j].yPos=10000;
  }
  
  
  else{
    ammoLeft++;
    shotsHit++;
    if(asteroids.get(i).size==1){
      asteroids.remove(i);
      asteroidMotion.remove(i);
    }
    else{
      for(int k=-1; k<2; k+=2){
        float distBetween=asteroids.get(i).radius/2;
        float angly=spaceshipMotion.angle;
        
        angly+=radians(90); //perpendicular
        
        float xVely=sin(angly)*distBetween;
        float yVely=-cos(angly)*distBetween;
        
        xVely*=k;
        yVely*=k;
        
        float xPosy=asteroids.get(i).centerX+xVely;
        float yPosy=asteroids.get(i).centerY+yVely;
        spawnAsteroid(speedRange, true, xPosy, yPosy, asteroids.get(i).size-1);
      }
      asteroids.remove(i);
      asteroidMotion.remove(i);
    }
    score+=100;

  }
  
  
}

void checkAsteroidHit(int i){
  if(!showStuff){
    i=i;
    for(int j=0; j<projectNumCount; j++){
        if(i==asteroids.size()){
          break;
        }
        if(dist(asteroids.get(i).centerX, asteroids.get(i).centerY, myProjectiles[j].xPos, myProjectiles[j].yPos)<=asteroids.get(i).radius){
          asteroidHit(i, false, j);
        } 
      }
  }
}

boolean checkSpaceshipHit(int i){
  i=i;
  if(i==asteroids.size()){
        return false;
  }
  if(dist(asteroids.get(i).centerX, asteroids.get(i).centerY, mySpaceship.xMidPoint, mySpaceship.yMidPoint)<=asteroids.get(i).radius+10){
    mySpaceship.lives--;
    mySpaceship.hit();
    turnCountDownOn();
    deathCounter++;
    timesGrazed--;
    return true;
  }
  
  else if((dist(asteroids.get(i).centerX, asteroids.get(i).centerY, mySpaceship.xMidPoint, mySpaceship.yMidPoint)<=asteroids.get(i).radius+37) && !asteroids.get(i).grazed){
    timesGrazed++;
    asteroids.get(i).grazed=true;
    return false;
  }
  
  else return false;
}

void spawnAsteroid(float s, boolean pref, float xPosChoice, float yPosChoice, int si){
    float xVelR=random(-s, s);
    float yVelR=random(-s, s);
    float spin=random(-6, 6); 
    
    int xPos;
    int yPos;
    
    int vertices=(int)random(5, 8);
    int size=(int)random(2, 4);
    if(!pref){
      xPos=-300; 
      yPos=-300; 
      if(xVelR<0) xPos=(int)random(width+100, width+500);
      else if(xVelR>=0) xPos=(int)random(-500, -100);
      
      if(yVelR<0) yPos=(int)random(height+100, height+500);
      else if(yVelR>=0) yPos=(int)random(-500, -100); 
    }
    else{
      xPos=(int)xPosChoice;
      yPos=(int)yPosChoice;
      size=si;
    }
    asteroids.add(new Asteroid(xPos, yPos, size, 255, 255, 255, vertices));
    asteroidMotion.add(new Motion(0, xVelR, yVelR, radians(spin), 0, 0, 0, 0, false));
}


void countdown(){
  mousyPressed=false;
  shotPressed=false;
  spaceshipMotion.angle=0;
  countDownCounter++;
  if(countDownCounter==60){
    countDownCounter=0;
    countDownLeft--;
  }
  if(countDownLeft<=0){
    countingDown=false;
    paused=false;
    mySpaceship.flameOn=false;
    upPressed=false;
    backPressed=false;
    rightPressed=false;
    leftPressed=false;
    shotPressed=false;
  }
}


void shot(){
  counting=true;
  float xPosy=sin(spaceshipMotion.angle)*20;
  float yPosy=-cos(spaceshipMotion.angle)*20;
  if(!showStuff){
    myProjectiles[projectNumCount]=new Projectile(5, 255, 255, 255, false, 10, spaceshipMotion.angle, xPosy+mySpaceship.xMidPoint, yPosy+mySpaceship.yMidPoint, false);
    projectileMotion[projectNumCount]=new Motion(spaceshipMotion.angle, 10, 0, 0, 0, 0, 0, 15, false);
  }
  /*if(showStuff){
    myProjectiles[projectNumCount]=new Projectile(5, 255, 255, 255, false, 10, spaceshipMotion.angle, xPosy+mySpaceship.xMidPoint, yPosy+mySpaceship.yMidPoint, false);
    projectileMotion[projectNumCount]=new Motion(spaceshipMotion.angle, 15, 0, 0, 0, 0, 0, 15, false);
    
  */
  projectNumCount++;
  ammoLeft--;
  shotsFired++;
}

float condenseAngle(float ay){
  float a=ay;
  if(a>radians(360)) a%=radians(360);
  else if(a<-radians(360)) a%=-radians(360);
  
   if(a>0 && a<radians(180)){
     a=a;
     return a;
   }
   else if(a>radians(180)){
        a%=radians(180);
        a=-a;
        a=PI+a;
        return -a;
    }
    
    else if(a<0 && a>radians(-180)){
      a=a;
      return a;
    }

    else if(a<radians(-180)){
      a%=radians(-180);
      a=-a;
      a=PI-a;
      return a;
    }
    
    return 0;
}

void mouseMove(){
  
  float xDif=mouseX-mySpaceship.xMidPoint;
  float yDif=mouseY-mySpaceship.yMidPoint;
  
  
  float predictAngle=atan(xDif/-yDif);  
  if(yDif>0) predictAngle-=PI;
  
  
  predictAngle=condenseAngle(predictAngle);
  
  
  //println(degrees(predictAngle));
  float angly=spaceshipMotion.angle;
  
  angly=condenseAngle(angly);
  boolean goRight=false;
  boolean goLeft=false;
  
  
  if(angly==0){
    if(predictAngle>0){
      goRight=true;
    }
    else if(predictAngle<0) goLeft=true;
    
  }
  if(!showStuff){
    if(angly>0){
      if(predictAngle>0){
        float plusy=radians(1);
        float rotFact=radians(rotSpeed)+plusy;
        if(abs(predictAngle-angly)<=rotFact){
          spaceshipMotion.angleVel=0;
          return;
        }
        
        if(predictAngle>angly){
          goRight=true;
        }
        else if(angly>predictAngle){
          goLeft=true;
        }
      }
      
      if(predictAngle<0){
        float distForRight=0;
        float distForLeft=0;
        
        distForRight=radians(180)-angly;
        distForRight+=radians(180)-(abs(predictAngle));
        //println("\nDist for right: "+distForRight);
        
        distForLeft=angly;
        distForLeft+=abs(predictAngle);
        // println("Dist for left: "+distForLeft+"\n");
        if(distForLeft<distForRight){
          //println("\nDist for left: "+distForLeft);
          //println("DIst for right: "+distForRight+"\n");
          goLeft=true;
          goRight=false;
          spaceshipMotion.angleVel=-radians(rotSpeed);
          return;
        }
        if(distForRight<distForLeft){
          goRight=true;
          goLeft=false;
          spaceshipMotion.angleVel=radians(rotSpeed);
          return;
        }
      }
      
    }
    
   if(angly<0){
     
      if(predictAngle<0){
        float plusy=radians(1);
    
        float rotFact=radians(rotSpeed)+plusy;
        if(abs(predictAngle-angly)<=rotFact){

          spaceshipMotion.angleVel=0;
          return;
        }
        
        if(predictAngle>angly){
          goRight=true;
        }
        else if(angly>predictAngle){
          goLeft=true;
        }
      }
      
      if(predictAngle>0){
        float distForRight=0;
        float distForLeft=0;
        
        distForRight=radians(180)-abs(angly);
        distForRight+=radians(180)-predictAngle;
        
        distForLeft=abs(angly);
        distForLeft+=predictAngle;
        
        if(distForRight>distForLeft){
          //println("\nDist for left: "+distForLeft);
          //println("DIst for right: "+distForRight+"\n");
          goLeft=true;
          goRight=false;
          spaceshipMotion.angleVel=radians(rotSpeed);
          return;
        }
        if(distForRight<distForLeft){
          goRight=true;
          goLeft=false;
          spaceshipMotion.angleVel=-radians(rotSpeed);
          return;
        }
      }
      
    }
    if(goRight) spaceshipMotion.angleVel=radians(rotSpeed);
    if(goLeft) spaceshipMotion.angleVel=radians(-rotSpeed);
  }
  
  if(showStuff){
    spaceshipMotion.angle=predictAngle;
  }
  /*
  if(predictAngle>angly){
    spaceshipMotion.angleVel=radians(rotSpeed);
    return;
  }
  
  else if(predictAngle<angly){
    spaceshipMotion.angleVel=-radians(rotSpeed);
  }
  */
  
  //spaceshipMotion.angle=predictAngle;
}



void keyPressed(){ // 38 is forward arrow, 37 is left arrow, 40 is back arrow, 39 is right arrow
  if(!countingDown){
    if(!paused){
      if(keyCode==38 || key=='w' || key=='W'){
        upPressed=true;
        mySpaceship.flameOn=true;
        stoppingForward=false;
        stoppingBackward=false;
        spaceshipMotion.yVel=-goSpeed;
        spaceshipMotion.yAccel=0.02;
        spaceshipMotion.xAccel=0.02;
      } 
      
      if(keyCode==37 || key=='a' || key=='A') { 
        leftPressed=true;
        spaceshipMotion.angleVel=radians(-rotSpeed);
      }
      
      if((keyCode==40|| key=='s' || key=='S') && allowBackward){ 
        backPressed=true;
        /*
        if(!stoppingForward){
          spaceshipMotion.yVel=goSpeed-1.5; 
        }
        if(stoppingForward){
          spaceshipMotion.yVel=goSpeed-3;
        }*/
        
        stoppingForward=false;
        stoppingBackward=false;
        spaceshipMotion.yVel=goSpeed-1.5; 
        
        spaceshipMotion.yAccel=0.01;
        spaceshipMotion.xAccel=0.01;
        
      }
      
      if(keyCode==39 || key=='d' || key=='D'){ 
        rightPressed=true;
        spaceshipMotion.angleVel=radians(rotSpeed);
      }
     
      if((key=='z' || key=='Z' || keyCode==32)&& !gameOver){
        shotPressed=true;
      }
    }
  }

}

void keyReleased(){
  if(!countingDown){
    if(!paused){
      if(keyCode==38 || key=='w' || key=='W'){ 
        upPressed=false;
        mySpaceship.flameOn=false;;
        angleAtStop=spaceshipMotion.angle;
        stoppingForward=true;
        if(spaceshipMotion.yVel>0){
          stoppedGoingDir=false;
        }
        else if(spaceshipMotion.yVel<0){
          stoppedGoingDir=true;
        }
        spaceshipMotion.yAccel=-0.08;
        spaceshipMotion.xAccel=-0.08;
      }
      
      if(keyCode==37 || key=='a' || key=='A'){ 
        leftPressed=false;
        spaceshipMotion.angleVel=0;
      }
      
      if((keyCode==40 || key=='s' || key=='S') && allowBackward){ 
        backPressed=false;
        upPressed=false;
        angleAtStop=spaceshipMotion.angle;
        stoppingBackward=true;
        if(spaceshipMotion.yVel>0){
          stoppedGoingDir=false;
        }
        else if(spaceshipMotion.yVel<0){
          stoppedGoingDir=true;
        }
        spaceshipMotion.yAccel=-0.08;
        spaceshipMotion.xAccel=-0.08;
      }
      
      if(keyCode==39 || key=='d' || key=='D'){ 
        rightPressed=false;
        spaceshipMotion.angleVel=0;
      }
    }
    
    if(key=='z' || key=='Z' || keyCode==32){
        shotPressed=false;
      }
    
  }
  if (keyCode==8){
    int textLength=texty.length();
    if(textLength>1){
      texty=texty.substring(0, texty.length()-2);
    }
  }
}

void keyTyped(){
  
  if(!countingDown){
    if((key=='p' || key=='P') && !countingDown && !showRules){
      if(paused && !showRules){
        countingDown=true;
        countDownLeft=3;
      }
      else paused=!paused;
    }
    
    
    
    if((key=='r' || key=='R') && paused){
      mySpaceship.lives=0;
      mySpaceship.hit();
      gameOver=true;
      paused=false;
    }
    
    
    
  }
  
  if((key=='1' || key=='2' || key=='3' || key=='4') && showRules){
    if(!showStuff){
      if(key=='1'){
          livesAlloted=6;
          ammoCount=80;
          projectileDelay=10;
          ammoLeft=ammoCount;
        }
        else if(key=='2'){
          livesAlloted=4;
          ammoCount=40;
          projectileDelay=15;
          ammoLeft=ammoCount;
        }
        else if(key=='3'){
          livesAlloted=3; 
          ammoCount=35;
          projectileDelay=15;
          ammoLeft=ammoCount;
        }
        else if(key=='4'){
          ammoCount=10;
          projectileDelay=30;
          ammoLeft=ammoCount;
          livesAlloted=2;
        }
     }
      
      mySpaceship.lives=livesAlloted;
      
      paused=false;
      showRules=false;
      countingDown=true;
  }
  
  if((key=='1' || key=='2' || key=='3' || key=='4') && gameOver){
      if(key=='1'){
        livesAlloted=6;
      }
      else if(key=='2'){
        livesAlloted=4;
      }
      else if(key=='3'){
        livesAlloted=3; 
      }
      else if(key=='4'){
        livesAlloted=2;
      }
      gameOver=false;
      mySpaceship.lives=livesAlloted;
      ammoLeft=ammoCount;
      levelOn=1;
      levelTimeLeft=30;
      levelTimeTotal=30;
      levelTimeCounter=0;
      speedRange=5;
      asteroidSpawnChance=40;
      score=0;
      //countDown=true;
      deathCounter=0;
      mySpaceship.xMidPoint=500;
      mySpaceship.yMidPoint=350;
      showRules=false;
      paused=false;
      countingDown=true;
      countDownLeft=3;
      shotsFired=0;
      shotsHit=0;
      showStuff=false;
      ammoCount=40;
      projectileDelay=10;
      timesGrazed=0;
    }
    if(key=='\n'){   
       if(texty.equals("alexisawesome")){
          showStuff=true;
          livesAlloted=1000000;
          ammoCount=100000000;
          ammoLeft=ammoCount;
          projectileDelay=0;
          mySpaceship.lives=livesAlloted;
       }
       else if(texty.equals("alexisntawesome") || texty.equals("alexisn'tawesome") || texty.equals("alexisnotawesome") || texty.equals("alexisadumbass") || texty.equals("dumbass") || texty.equals("alexsucks") || texty.equals("alexsuckz") || texty.equals("alexsuck")){
         exit();
       }
       texty="";
       
    }
    else if(key!=' ' && key!='1' && key!='2' && key!='3' && key!='4'){
     texty+=key;
   }  

}

void mousePressed(){
  if(!countingDown && !paused){
    if(!gameOver){
        mousyPressed=true;
        if(mouseButton==RIGHT) shotPressed=true;
        
      }
  }
}

void mouseReleased(){
  mousyPressed=false;
  if(mouseButton==RIGHT) shotPressed=false;
  spaceshipMotion.angleVel=0;
}
