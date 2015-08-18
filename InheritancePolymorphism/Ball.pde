class Ball extends Party {  //Ball is a child class (or subclass) of Party
  
  //the keyword extends is used to indicate a parent class for the class being defined
  //a subclass can be expanded to include additional functions and properties beyond what is contained in the superclass
  
  //a child class can introduce new variables not included in the parent
  float r;
  float t=0;
  
  color col;
  
  Ball(float _x, float _y, float _r){
   super(_x,_y);     // super() calls the Constructor in the parent class
    r=_r;            //other code can be written into the constructor in addition to super();
    
  }
  
  void run(){
    super.run(); //extend method run of the superClass Party
    
    pulse();
    
  }
  
  
  void pulse(){
    
    t += 0.025;
    r += sin(t);   
    
  }
  
  void display(){   // override the method display of the superclass Party
    pushStyle();
    colorMode(HSB);
    col= color(random(0,255),255,255);
    fill(col);
    ellipse(x,y,r,r);
    popStyle();
    
  }
  
    
}
