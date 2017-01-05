// Simple bouncing ball class

class Ball {                                                        //ball is the dustbin
  
  float x;
  float y;
  float speed;
  float gravity;
  float w;
  String fileName;
  float temporaryY;
  int iRotate = 0;
    int nextStep0 = 1, nextStep1 = 0, nextStep2 = 0, nextStep3 = 0;
  //float life = 255;
  
  Ball(float tempX, float tempY, float tempW, String tempName) {
    x = tempX;
    y = tempY;
    w = tempW;
    fileName = tempName;
    speed = 0;
    gravity = 0.1;
    temporaryY = y;
  }
  
    void dropBall() {                                    //this function gives the dustbin dropping action
      speed = speed - gravity;
      y = y + speed;
      //x = x + 0.15;
      if(y < temporaryY - w){
        speed = speed * (-0.9);
        gravity = -0.1;
        //rn true;
      }
    
  }

  void move(){                                          //this function animates the dustbin
    stroke(220, 0, 0);
    strokeWeight(1);
    
    if(iRotate < 90 && nextStep1 == 0 && nextStep2 == 0 && nextStep3 == 0 && nextStep0 == 1){            //iRotate was earlier roatating the dustbin but now I am using it for just counting
      iRotate = iRotate + 5;
      pushMatrix();
      translate(x,y);
      //rotate(radians(iRotate));
      line(-2,-3,-2,+3);                                  //middle line
      line(+2,-3,+2,+3);
      line(-5,-5,-5,+5);                              //left line
      line(+5,-5,+5,+5);                              //right line
      line(-5,+5,+5,+5);                              //base line
      line(-5,-5,+5,-5);                              //top
      line(-5,-7,-5,-17);
      line(-7,-10,-7,-14);
      popMatrix();
      fill(0);
      textSize(13);
      textAlign(LEFT);
      text(fileName, 2*x, y*1.05);                                          //playlist items
      if(iRotate == 90){
        nextStep1 = 1;
        nextStep0 = 0;
      }
    }
    else if(iRotate >= 90 && nextStep1 == 1 && nextStep2 == 0 && nextStep3 == 0){
      pushMatrix();
      translate(x,y);
      iRotate = iRotate + 5;
      //rotate(radians(iRotate));
      line(-2,-3,-2,+3);                                  //middle line
      line(+2,-3,+2,+3);
      line(-5,-5,-5,+5);                              //left line
      line(+5,-5,+5,+5);                              //right line
      line(-5,+5,+5,+5);
      line(-5,-5,+5,-5);
      line(-5,-7,-5,-17);
      line(-7,-10,-7,-14);
      popMatrix();
      fill(255);
      textSize(13);
      textAlign(LEFT);
      text(fileName, 2*x, y*1.05);
      if(iRotate == 180){
        nextStep1 = 0;
        nextStep2 = 1;
      }
    }
    else if(iRotate >= 180 && nextStep1 == 0 && nextStep2 == 1 && nextStep3 == 0){
      pushMatrix();
      translate(x,y);
      iRotate = iRotate + 5;
      //rotate(radians(iRotate));
      line(-2,-3,-2,+3);                                  //middle line
      line(+2,-3,+2,+3);
      line(-5,-5,-5,+5);                              //left line
      line(+5,-5,+5,+5);                              //right line
      line(-5,+5,+5,+5);                              //base line
      line(-5,-5,+5,-5);                              //top
      line(-5,-7,+5,-7);
      line(-2,-8,+2,-8);
      popMatrix();
      if(iRotate == 270){
        nextStep2 = 0;
        nextStep3 = 1;
      }
    }
    else if(nextStep3 == 1 && iRotate == 270 && nextStep1 == 0 && nextStep2 == 0){
      dropBall();
    }
  }
  

  
  boolean finished() {                                    //this function is called when the dustbin has crossed the screen
    // Balls fade out
    if (y > height + 10) {
      return true;
    } else {
      return false;
    }
  }
  
  void display() {
    // Display the circle
        stroke(237, 28, 36);
    //stroke(0,life);
//    ellipseMode(CENTER);
//    ellipse(x,y,w,w);
//    stroke(255);
//    fill(255);
    strokeWeight(1);
//    line(x-3,y,x+3,y);
      line(x-2,y-3,x-2,y+3);                                  //middle line
      line(x+2,y-3,x+2,y+3);
      line(x-5,y-5,x-5,y+5);                              //left line
      line(x+5,y-5,x+5,y+5);                              //right line
      line(x-5,y+5,x+5,y+5);                              //base line
      line(x-5,y-5,x+5,y-5);                              //top
      line(x-5,y-7,x+5,y-7);
      line(x-2,y-8,x+2,y-8);
      //line(x-3,y-6,x+3,y-6);
      fill(0);
      textSize(13);
      textAlign(LEFT);
      text(fileName, 2*x, y*1.05);                                          //playlist items
      stroke(200);
      strokeWeight(1);
      line(margin, y + margin, width - x, y + margin);          //line after each item
  }
  
  void modifyY(int index){
    y = y - 2*margin;
  }
  
  float valueX(){
    return x;
  }
 
 float valueY(){
  return y;
 } 
 
 float valueW(){
   return w;
 }
 
 String valueFileName(){
   return fileName;
 }
 
  boolean mousePressed(){
    if(mouseX >= x-w/2 && mouseX <= x+w/2 && mouseY >= y-w/2 && mouseY <= y+w/2){
      move();
      return true;
    }
    return false;
  }
  
    void displayWithoutLine() {                                                            //this method is called when removing
    // Display the circle
        stroke(237, 28, 36);
    //stroke(0,life);
//    ellipseMode(CENTER);
//    ellipse(x,y,w,w);
//    stroke(255);
//    fill(255);
    strokeWeight(1);
//    line(x-3,y,x+3,y);
      line(x-2,y-3,x-2,y+3);                                  //middle line
      line(x+2,y-3,x+2,y+3);
      line(x-5,y-5,x-5,y+5);                              //left line
      line(x+5,y-5,x+5,y+5);                              //right line
      line(x-5,y+5,x+5,y+5);                              //base line
      line(x-5,y-5,x+5,y-5);                              //top
      line(x-5,y-7,x+5,y-7);
      line(x-2,y-8,x+2,y-8);
      //line(x-3,y-6,x+3,y-6);
    }
  
}  
