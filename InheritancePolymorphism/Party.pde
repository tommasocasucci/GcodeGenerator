class Party {              //parent (or super )class        
                          
//fields and methods of the parent class are inherited dy sub classes 
 
 
  // GLOBAL VARIABLES
  float x = 0; // X coordinate of the ball
  float y = 0; // Y coordinate of the ball
  float speedX = random(-2,2);
  float speedY = random(-2,2);


//CONSTRUCTOR
  Party(float x, float y) {

    this.x = x; //Within an instance method or a constructor, this is a reference to the current object
    this.y = y;
  }

  //FUNCTIONS
  void run() {
    display();
    move();
    bounce();
    gravity();
  }

  void gravity(){
    speedY += 0.2;  //set increment of the speed in Y
  }


//define the behaviour of the ball when it reach the side of the screen
  void bounce() {
    if(x > width) {
      speedX = speedX * -1;
    }
    if(x < 0) {
      speedX = speedX * -1;
    }
    if(y > height) {
      speedY = speedY * -1;
    }
    if(y < 0) {
      speedY = speedY * -1;
    }
  }

//update the position of the Ball
  void move() {
    x += speedX;
    y += speedY;
  }

//draw the ball
  void display() {
    pushMatrix();
    noStroke();
    ellipse(x,y,5,5);
    popMatrix();
  }
}
