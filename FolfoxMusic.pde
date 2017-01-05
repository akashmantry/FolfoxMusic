import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

PFont f;
Minim minim;
AudioPlayer player;
FFT fft;
FFT fftLog;
AudioMetaData meta;

int newCounter = 0;                                                              //these are to solve the song length anomaly problem
int timeLeftSeconds = 0;
int againNewCounter = 0;
int flagSongEnded = 0;
//PVector centerLine, startLine, centerStartLine, positionLine, positionCenterLine;
int opacity1 = 200;                                          //for the arrow mark which is dragged to bring the playlist icon
int opacity2 = 0;                                            //for the arrow mark which gets displayed once the playlist icon has been dragged out
float rect1 = 20;
float rect2 = 30;
float rect3 = 15;
float maximumHeightLine = 0;
float volume, power=0;
boolean flagMouseOverCircle = false;                                                      //3 rectangles search, playlist and some other thing
boolean showRectangle = false;                                                            //for showing the rectangle
int incrementRectangles = 0, startPoint = 0, flagRectangles = 0;
boolean playSong=true;
boolean deck1Playing = false;
boolean locked=false;
boolean mouseOverBox=false;
boolean showGUIInformation=false;
boolean showGUIVolume = true;
boolean flagInfoButton = false;
boolean flagSearchButton = false;
boolean flagSpacebar = false;
boolean flagMousePressed = false;
boolean flagExitButton = false;
float power1;
float margin;
float width1;
int ctr, counterFrames=0, counterFrames1=0, callCounter=0;
int flag=0, flagForDrag=0, flagCalculateXYEllipse=1;              //flag is used to play the music only after selecting a file
int minutes, seconds, timeLeft, maximumLength=0;
double lengthOfSong; 
float counterAngleEllipse=225.0;
int counterSpaceBar = 0;
float counterAngleArc=-90.0;
float angleCalculated;
float xRedLine;                                //name is red but the line is blue
float yRedLine;
float getVolume;
//float[] xPointsEllipse;
//float[] yPointsEllipse;
PImage [] recordPlayer;
PImage volumeicon;
PImage searchicon;
PImage backgroundImage;
float deckX;
float deckY;
int rotatedeck=0;
float deckwidth, newPositionSong=0.0;
double unitMovementOfEllipse, ratioAngleSongLength;
float sound;
String userInput, timeLeftStr, author, album, genre, fileName = null;
float distanceCenter_Ellipse=0.0, distanceCenter_Mouse=0.0;
Slider sliderVolume;
  
//variables of new visualiser
//ParticleSystem ps;
int flagHeadphone = 0;
float ySineWave, timeVariable;
float incrementHeadphone = 0.0, heightEllipse;
float amplitude = 0.0, amplitude1 = 0.0;

//PlayListMenu playListMenuObject = new PlayListMenu();
boolean createPlayListMenu = false;

//Button searchButton;

void setup()
{
  size(512,512);
  minim=new Minim(this);
  f = createFont("Roboto-Thin", 13);
  textFont(f);
  
  width1=0.039*width;
  heightEllipse=0.239*height;                                                  //or radius of big ellipse
  margin=height/20;
  distanceCenter_Ellipse=heightEllipse;
  
  backgroundImage = loadImage("7.jpg");
  backgroundImage.resize(0, (2*(height/3)));
  searchicon = loadImage("ic_search_white_24dp_1x.png");
  ctr=(int)((width-margin)/(margin+width1));
  sliderVolume = new Slider("", 35, 0, 70, (int)(margin+40+30+20), (int)(height-margin-8), 80, (int)margin-10, HORIZONTAL);//textWidth was changed from 60 to 0 in GUI
}

void fileSelected(File selection){
  if(selection == null){
    println("\nWindow was closed due to an error or the user hit cancel.");
    if(player.isPlaying()){
      flag = 1;
      player.pause();
      playSong = false;
    }
  }
  else{
    userInput = selection.getAbsolutePath();
    call();
  }
}

void call(){
  if(callCounter != 0)
    player.pause();
    
  counterAngleEllipse = 225.0;
  counterAngleArc = -90;
  player = minim.loadFile(userInput);
  meta = player.getMetaData();
  fileName = meta.title();
  player.cue(0);
                
  fft = new FFT(player.bufferSize(), player.sampleRate());
  
  lengthOfSong = (double)(player.length()/1000);
  //println(lengthOfSong);
  minutes = (int)(lengthOfSong / 60);
  seconds = (int)(lengthOfSong % 60);
  unitMovementOfEllipse = (double)(360.0/lengthOfSong/60.0);
  //println(unitMovementOfEllipse);
  ratioAngleSongLength = (double)((lengthOfSong*1000.0)/360.0);
  flag = 1;
  callCounter++;
  //println(player.getControls());
}

void draw()
{
 background(255);
 noStroke();
 imageMode(CENTER);
 
 
 if(fileName != null){
   textSize(18);                                                                                //displays file name
   fill(0,0,0);
   text(fileName,margin+40+30,height-4*margin);
 }
 
 image(backgroundImage, (int)(width/2), (int)(height/3));
 noStroke();
 fill(0, 125, 255);
 ellipse(2.65*margin, (int)(2*(height/3)), 50,50);                                            //draws the blue ellipse of information                                                                               //displays the information button
 textFont(f);
 fill(255);                                                                                   //draws the new 'i'
 stroke(255);
 line(2.7*margin, (2*(height/3)-8), 2.7*margin, (2*(height/3)+8));
 line(2.65*margin, (2*(height/3)-8), 2.5*margin, (2*(height/3)-8));
 ellipse(2.65*margin, (2*(height/3)-14), 2, 2);
 

 noStroke();                                                                                      //the old search icon and ellipse
 fill(0, 125, 255);
 ellipseMode(CENTER);
 ellipse(width-(2*margin), (height-(2*margin)), 50,50);
 image(searchicon, (int)(width - (margin+25)), (int)(height-2*margin));                              //NEW search icon with image
 stroke(0, 125, 255);                                                                                  //the new volume icon
 noFill();
 strokeWeight(2);
 rectMode(CENTER);
 rect(margin+40+30, height-margin, 0.4*margin, 0.5*margin);
 line(margin+40+30+0.4*margin+2, height-0.5*margin, margin+40+30+0.4*margin+2, height-1.5*margin);
 line(margin+40+30+6, height-0.5*margin, margin+40+30+12, height-0.3*margin);
 line(margin+40+30+6, height-1.5*margin, margin+40+30+12, height-1.7*margin);
 line(margin+40+30+12, height-0.3*margin, margin+40+30+12, height-1.7*margin);
 getVolume = sliderVolume.get();
 volume = map(getVolume, 0, 70, -55, -6.0206);
 
 
  ellipseMode(CENTER);
  rectMode(CENTER);
  noStroke();                                                            //for drawing the 3 rectangles, search, playlist...
  fill(0, 125, 255);
  fill(0,100);
  stroke(0, 125, 255, opacity2);
  strokeWeight(3);
  
  noStroke();
  fill(0, 125, 255);
  ellipse(width-incrementRectangles+60+4, height/2, 50,50);            

  stroke(255);                                                                                                            //playlist icon in the middle rectangle
  strokeWeight(3);
  noFill();
  triangle(width-incrementRectangles+60, height/2, width-incrementRectangles+45, height/2-8, width-incrementRectangles+45, height/2+8);
  line(width-incrementRectangles+60+5,height/2-8, width-incrementRectangles+60+2+18, height/2-8);
  line(width-incrementRectangles+60+5, height/2, width-incrementRectangles+60+2+18, height/2);
  line(width-incrementRectangles+60+5, height/2+8, width-incrementRectangles+60+2+18, height/2+8);
  
 if(flagRectangles == 1 && startPoint == 0){
    incrementRectangles = incrementRectangles + 2;
    pushMatrix();
    translate(-incrementRectangles,0);
    popMatrix();
    if(incrementRectangles >= 100){
      incrementRectangles = 100;
      startPoint = incrementRectangles;
      flagRectangles = 0;
    }
  }
  
  if(flagRectangles == 0 && startPoint == 100){
    opacity1 = opacity1 - 40;
    opacity2 = opacity2 + 40;
    pushMatrix();
    translate(-startPoint,0);
    popMatrix();
    if(opacity1 <= 0)
      opacity1 = 0;
    if(opacity2 >= 200)
      opacity2 = 200;
  }
  
  if(flagRectangles == 1 && startPoint == 100){
    incrementRectangles = incrementRectangles - 2;
    pushMatrix();
    translate(-incrementRectangles,0);
    popMatrix();
    if(incrementRectangles <= 0){
      incrementRectangles = 0;
      startPoint = incrementRectangles;
      flagRectangles = 0;
      opacity1 = 200;
      opacity2 = 0;
    }
  }                                                                        //drawing of the 3 rectangles ends here
  
 if(playSong)                                                              //when track is not playing
 {
   fill(0,125,255);
   stroke(0,125,255);
   triangle(width/2-4,(height/2)+4,width/2+4,(height/2),width/2-4,(height/2)-4);    //play button
   
   incrementHeadphone = incrementHeadphone - 3;                                                                        //new visualiser
    if(incrementHeadphone <= 0){
      incrementHeadphone = 0;
    }
 }
 else
 {
   stroke(0,125,255);
   strokeWeight(3);
   line(width/2-5,(height/2),width/2-5,(height/2)+5);                                      //pause button
   line(width/2+5,(height/2),width/2+5,(height/2)+5);
   line(width/2-5,(height/2),width/2-5,(height/2)-5);
   line(width/2+5,(height/2),width/2+5,(height/2)-5);
 }
 
 noFill();                                                                               //grey circle
 strokeWeight(2);
 stroke(200);
 ellipseMode(CENTER);
 //ellipse(width/2,2*(height/3),heightEllipse,heightEllipse);
 ellipse(width/2,(height/2),heightEllipse,heightEllipse);
 
 if(playSong == false)                                                        //frame count and ellipse angle change happens here
 {
   //counterAngleEllipse += unitMovementOfEllipse;
   //counterAngleArc += unitMovementOfEllipse;
  //player.setVolume(volume);                                                         //for sound we have to use a different library
   player.setGain(volume);
   
  counterAngleEllipse = (map(player.position(), 0, player.length(), 225 , 585)); 
  counterAngleArc = (map(player.position(), 0, player.length(), -90 , 270));
  counterFrames1++;
  if(counterFrames1 % 180 == 0){
    counterFrames1 = 0;
  }
 }

 fill(0,125,255);                                                                             //drawing of the small red rotating ellipse
 strokeWeight(3);
 stroke(0,125,255);                                                                                              
 ellipseMode(CENTER);
 pushMatrix();
 translate(width/2, (height/2));
 rotate(radians(counterAngleEllipse));
 ellipse(42.8,42.8,5,5);                                                                      //calculate this
 popMatrix();
 
 noStroke();
 fill(0,125,255);                                                                              //small circle that rotates, opacity has been removed
 ellipseMode(CENTER);
 pushMatrix();
 translate(width/2, (height/2));
 rotate(radians(counterAngleEllipse));
 ellipse(42.8,42.8,18,18);                                                                      //calculate this
 popMatrix();
 
 pushMatrix();
 translate(width/2, (height/2)); 
 if(dist(width/2, (height/2), mouseX, mouseY)<63 && dist(width/2, (height/2), mouseX, mouseY)>50){
   angleCalculated=calculateAngle();
   if(angleCalculated<=counterAngleEllipse+15.0 && angleCalculated>=counterAngleEllipse-15.0){
     mouseOverBox=true;
   }
   else
     mouseOverBox=false;
 } 
 popMatrix();
 
 noFill();
 //stroke(0,120,255,150);
 stroke(0,125,255); 
 pushMatrix();
 translate(width/2, (height/2));
 //rotate(radians(counterAngleEllipse));
 //line(42.8,42.8,5,5);                                                                      //calculate this
 arc(xRedLine, yRedLine, heightEllipse, heightEllipse, radians(-90), radians(counterAngleArc), OPEN);         //drawing of line following the ellipse
 popMatrix();
 
 fill(0);
 stroke(0);
 ellipseMode(CENTER);
 ellipse(width-margin,margin,3,3);
 
 noFill();
 stroke(0);
 ellipseMode(CENTER);
 ellipse(width-margin,margin,15,15);
 
 if(flagSearchButton && flag == 0){                                      //this is called when I press the search button from keyboard for the first time 
    flag = 0;
    playSong = true;
    selectInput("Select a file to process: ", "fileSelected");
    flagSearchButton = false;
  }
  
  
 
 if(flag==1){
   if(flagSearchButton && flag == 1){                                     //this is called when a song is being played and I press the search button from keyboard
    flag = 0;
    if(counterAngleEllipse == 225.0)
      playSong = true;                                                    //see if my angle is 225, this means my song has finished, and I don't want to start it again after I press
    else                                                                  //the spacebar..so I did this
      playSong = false;
    selectInput("Select a file to process: ", "fileSelected");
    flagSearchButton = false;
  }
  
 if( flagSpacebar == true ){                                                  //this is required to set the status of playsong after pressing the spacebar button
   playSong = !playSong;
   flagSpacebar = false;
 }
 
 if(!playSong){
    player.play();
 }
 else
    player.pause();

   
 if(!playSong && ((-(timeLeft/1000/60)) != 0 || (-(timeLeft/1000%60)) != 0))//player.length() <= player.position()  )                  //NEED LOGIC FOR THIS(STILL)
 {   
   player.play();
   fft.forward(player.mix);
  stroke(255, 120, 0);
  fill(255,120,0);
  rectMode(CORNER);
  float power1 = random(-2,2);
  float power2 = random(-2,2);
  float power3 = random(-2,2);
  rect1 = rect1 + (int)power1;
  rect2 = rect2 + (int)power2;
  rect3 = rect3 + (int)power3;
  if(rect1 >= 50 || rect1 <= 0)
    rect1 = 20;
  if(rect2 >= 50 || rect2 <= 0)
    rect2 = 30;
  if(rect3 >= 50 || rect3 <= 0)
    rect3 = 15;  
  rect(margin+(0*(15)), height-(3*margin), 10, -rect1);
  rect(margin+(1*(15)), height-(3*margin), 10, -rect2);
  rect(margin+(2*(15)), height-(3*margin), 10, -rect3);
 
  amplitude = fft.getBand(0);
  if(incrementHeadphone < 180){
    incrementHeadphone = incrementHeadphone + 3;
  }
  else{
    incrementHeadphone = 180;
  }
  if(incrementHeadphone == 180){
    for(int i=6; i< 276; i=i+6){
      amplitude = map(fft.getBand(i), 0, fft.getBand(i)+15, 165, 0);
      amplitude1 = map(fft.getBand(i), 0, fft.getBand(i)+15, 0, 165);
      amplitude1 = amplitude1/3;  
      stroke(255, 120, 0);
      
      line(117+i,165,117+i, amplitude);                                        //for normal lines
      stroke(255, 120, 0, 150);
      line(117+i,170,117+i, 170+amplitude1);
    }
  }
  
//  for(int i=0; i< fft.specSize(); i++){                                                            //line visualizer
//    amplitude = map(fft.getBand(i), 0, 26, 0, 20);                  //height/3 is replaced by 20 and float MappedBand by amplitude
//    amplitude = map(amplitude, 0, 100, 20, 0);
////    for(timeVariable = 117; timeVariable <= 395; timeVariable = timeVariable + 0.0167){
////       ySineWave = amplitude * sin(0.1 * timeVariable);
////       strokeWeight(1);
////       stroke(0, 15, 255);
////       point(timeVariable, 165+ySineWave);
////    }
//   }
 }
 else
   player.pause();
 
   
 timeLeft = player.position() - player.length();
 timeLeftStr = String.format("%02d:%02d s", -(timeLeft/1000/60), -(timeLeft/1000%60));
 newCounter++;
 if(newCounter == 60){
   if(-(timeLeft/1000/60) == 0 && -(timeLeft/1000%60) <= 10){
     timeLeftSeconds = timeLeft/1000%60;
     againNewCounter++; 
   }
   if(againNewCounter > 10)
     flagSongEnded = 1;
   newCounter = 0;
 }
 
 textSize(18);
 fill(225, 120, 0);
 text(timeLeftStr, margin+40+30,height-3*margin);
 
 
 if(showGUIInformation){
   author = "Author: " + meta.author();
   album = "Album: " + meta.album();
   genre = "Genre: " + meta.genre();
   textSize(12);                                                                                //displays file information
   fill(255);
   text("Length: "+minutes+":"+seconds+"s", margin, 2*(height/3)-margin-36-5);
   text(author, margin, 2*(height/3)-margin-24-5);
   text(album, margin, 2*(height/3)-margin-12-5);
   text(genre, margin, 2*(height/3)-margin-3);
   
   if(textWidth(album) >= textWidth(author) && textWidth(album) >= textWidth(genre))          //for comparing who has maximum length and depending on that the box will have its length
     maximumLength = (int)textWidth(album);
   else if(textWidth(author) > textWidth(album) && textWidth(author) > textWidth(genre))
     maximumLength = (int)textWidth(author);
   else
     maximumLength = (int)textWidth(genre);
     
   noStroke();
   fill(0,0,0,50);
   rect(margin-5, 2*(height/3)-margin-48-2, maximumLength+10, 48+5);                //box has its length depending on the maximum length
     
 }
  
 if(flagInfoButton == true){
    if(showGUIInformation == true){
      showGUIInformation = false;
      flagInfoButton = false;
    }
    else{
     showGUIInformation = true;
     flagInfoButton = false;
    }
  } 
  if(!playSong)
    sliderVolume.display();  
 

 if(counterAngleEllipse == 585  || (-(timeLeft/1000/60)) == 0 && (-(timeLeft/1000%60)) == 0 || flagSongEnded == 1) //&& counterAngleEllipse >                       //ending is not good..improve this(earlier)
 {
   counterAngleEllipse=225.0;
   counterAngleArc=-90.0;
   againNewCounter = 0;
   flagSongEnded = 0;
   player.pause();
   player.cue(0);
   playSong=!playSong;
 }
 
 }
}

void mousePressed()
{
  if(flag==1){
    if(mouseOverBox==true)
      locked=true;
 
    if((mouseX>=(width/2-4) && mouseX<=(width/2+4) && mouseY>=((height/2)-4) && mouseY<=((height/2)+4)))
    {
      playSong=!playSong;
    }
    if(!playSong)
    {
      player.play();
    }
    else{
      player.pause();
    }
  }
  if(flag==1 && mouseX >= 2.65*margin-25 && mouseX <= 2.65*margin+25 && mouseY >= (2*height/3)-25 && mouseY <= (2*height/3)+25){
    if(showGUIInformation)
      showGUIInformation = false;
    else
      showGUIInformation = true;
  }
  else
    showGUIInformation = false; 
      
  if(dist(width/2, (height/2), mouseX, mouseY)<63 && dist(width/2, (height/2), mouseX, mouseY)>50 && !playSong)          //50 and 63 are the range for clicking..calculate the values
    //player.pause();
    flagMousePressed = true;
  else
    flagMousePressed = false;      
}

float calculateAngle(){
    float angleHere = 0.0;                              //fastest algorithm I could make, works fine
    float newAngle = 0.0;
    pushMatrix();
    translate(width/2, (height)/2);
    float perpendicular=mouseY-((height/2));
    float base=mouseX-width/2;
    angleHere = atan2(perpendicular, base);
    if(base < 0 && perpendicular < 0){
      newAngle = degrees(angleHere) + 90.0 + 360.0 + 225.0;
      //println(degrees(angleHere) + 90 + 360);
    }
    else{
      newAngle = degrees(angleHere) + 90.0 + 225.0;
      //println(degrees(angleHere) + 90);
    }
    popMatrix();      
    return newAngle;
}

void playMusicMouseClickOrDrag(){
    float angleHere=0.0;
    pushMatrix();
    translate(width/2, (height)/2);
    float perpendicular=mouseY-((height/2));
    float base=mouseX-width/2;
    angleHere = atan2(perpendicular, base);
    if(base < 0 && perpendicular < 0){
      counterAngleEllipse = degrees(angleHere) + 90.0 + 360.0 + 225.0;
      //println(degrees(angleHere) + 90 + 360);
    }
    else{
      counterAngleEllipse = degrees(angleHere) + 90.0 + 225.0;
      //println(degrees(angleHere) + 90);
    }
    popMatrix();
    
    int position;
    position=(int)((counterAngleEllipse - 225)*ratioAngleSongLength);
    player.play(position);
}

void stop(){
    if(playSong == false)
      player.close();
    minim.stop();
    super.stop();
}

void mouseDragged(){        
  if((mouseX >= width-25 && mouseY >= height/2-25 && mouseY <= height/2+25 && flagRectangles == 0 && startPoint != 100) || (mouseX>=width-125 && mouseX<=width-100 && mouseY >= height/2-25 && mouseY <= height/2+25 && flagRectangles == 0 && startPoint == 100)){            //this release method is for the 3 rectangles 
    //println(width);
    flagRectangles = 1;
    startPoint = incrementRectangles;                                    //startPoint tells us whether the rectangles are inside or outside,value ranges between 0 and 100
  }
  
  sliderVolume.mouseDragged();  
 if(locked == true){
  float previousAngle = counterAngleEllipse;
  float presentAngle = calculateAngle();
  if(presentAngle >= previousAngle)                                        //if you are dragging it forward, this method is called, otherwise the method in mousereleased is called
                                                                           //dont ask why! this works perfectly...its fast..
    playMusicMouseClickOrDrag();
   
  }}

void mouseReleased(){      
    sliderVolume.mouseReleased();
    
  if(mouseX >= 441 && mouseX <= 472 && mouseY >= 241 && mouseY <= 270 && flagRectangles == 0 && startPoint == 100){
    flag = 0;
    selectInput("Select a file to process: ", "fileSelected");
  }
    
  if(mouseX >= width-(2*margin)-25 && mouseX <= width-(2*margin)+25 && mouseY >= (height-(2*margin)-25) && mouseY <= (height-(2*margin)+25)){
    selectInput("Select a file to process: ", "fileSelected");                                              //pressing the new search icon near the bottom
    //selectFile();                                                                                            //for javascript
    println("select file clicked");
  }
    
  if(dist(width/2, (height/2), mouseX, mouseY)<63 && dist(width/2, (height/2), mouseX, mouseY)>50 && !playSong){
    float previousAngle = counterAngleEllipse;
    float presentAngle = calculateAngle();
    //println(presentAngle);
    if(presentAngle <= previousAngle){
      int position;
      position=(int)((presentAngle - 225)*ratioAngleSongLength);
      //position = (int)(map(counterAngleEllipse, 295, 585, 0, player.length()));  
      //player.rewind();
      player.play(position);
    }
    locked=false;
  }
  
  if(flagMousePressed == true){
    int position;
    position=(int)((calculateAngle() - 225)*ratioAngleSongLength);
    player.play(position);
  }
} 

float calcXRedLine(double counterAngleEllipse){
   float xRedLine;
   xRedLine=cos(radians((float)counterAngleEllipse))*heightEllipse;
   return xRedLine;
}
 
float calcYRedLine(double counterAngleEllipse){
   float yRedLine;
   yRedLine=sin(radians((float)counterAngleEllipse))*heightEllipse;
   return yRedLine;
}
 
void keyPressed(){
//   println(1);
   if((key == 'I' || key == 'i') && flag == 1){
     //println("i");
     flagInfoButton = true;
   }
   if(key == 'S' || key == 's'){
     println("s");
     flagSearchButton = true;
   }
   if(key == ' ' && flag == 1)
   {
     flagSpacebar = true;
//     println("spacebar");
     counterSpaceBar++;
   }
   if(key == 'E' || key == 'e')
   {
     println("e");
     flagExitButton = true;
   }
   if(key == '+')
   {
     float presentVolume = sliderVolume.get();
     presentVolume = presentVolume + 5; 
     sliderVolume.set(presentVolume);
     showGUIVolume = true;
   }
   if(key == '-')
   {
     float presentVolume = sliderVolume.get();
     presentVolume = presentVolume - 5; 
     sliderVolume.set(presentVolume);
     showGUIVolume = true;
   }
 }
  