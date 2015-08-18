
//DECLARE

//Polymorphism allows us to simplify the code by just making one ArrayList 
//of Particle objects that contains both standard Party objects as well as Ball

ArrayList<Party> Collection;


void setup() {
  
  size(600, 400);
  background(200);
  smooth();
  noStroke();

//INITIALIZE
  Collection = new ArrayList<Party>();

  for (int i = 0; i < 15; i++) {
    
    Ball myBall = new Ball(random(0, width), random(0, 300),random(3,20));
    
    //becouse Ball is a subclass of Party we can write
    //Party myBall = new Ball(random(0, width), random(0, 300),random(3,20));   
    
    Collection.add(myBall);
  }
  
  
    for (int i = 0; i < 15; i++) {
    Party part = new Party(random(0, width), random(0, 300));
    Collection.add(part);
  }
}

void draw() {
  background(200);
  
 //CALL FUNCTIONALITY
  
 // Polymorphism allows us to treat everything as a Particle
 // whether it is a Party or a Ball
  
  for (int i = 0; i< Collection.size(); i++) {
    Party P = (Party) Collection.get(i);
    P.run();    //call run() method 
  }
}
