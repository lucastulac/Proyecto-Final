import processing.serial.*;

PImage logo;
int contA=0; //variable para pruebas
int contB=0; //variable para pruebas
char inChar;
int nivel;
String inputString = "";        
String outputString = "";         
boolean stringComplete = false;

void setup(){
  
  Serial myPort;
  
  size(900, 500);
  PFont myFont = createFont(PFont.list()[3], 35);
  textFont(myFont);
  logo = loadImage("logo-utn.png");
  logo.resize(200, 50);
  myPort = new Serial(this, "COM4", 9600);

}

void draw(){
  background(245, 245, 220);
  
  /*if(contA==0){
     contA++;
     inputString = "eElectrovalvula";        //pruebaaaa
  }else{
     contA=0;
     inputString = "aElectrovalvula";
  }*/
  
  textSize(35);
  fill(0, 0, 0);
  text("INVERNADERO", 300, 50);
  text("CALEFACCION",70,140);
  text("RIEGO",650,140);
  
  text(inputString,300,300);
  
  fill(0, 0, 0);
  textSize(20);
  text("ENCENDIDO",160,320);
  text("APAGADO",160,350);
  text("ENCENDIDO",670,320);
  text("APAGADO",670,350);
  
  fill(0,255,0);               //botones de encendido y apagado
  rect(140,305,15,15);         //encendido del caloventor
  rect(650,305,15,15);         //encendido de la e valvula
  fill(255,0,0);
  rect(140,335,15,15);        //apagado del caloventor
  rect(650,335,15,15);        //apagado de la valvula
  
  image(logo, 750, 450);
  
  /*if(myPort.available()>0){
  inputString = "";
     while(myPort.read()!='\n'){          //manejo del p.serie
        inChar = (char)myPort.read();
        inputString += inChar;
     }
  }*/
  
  delay(1000);
  
  if(inputString == "eElectrovalvula"){
  fill(255, 0, 0);
  ellipse(710, 190, 70, 70);
  }else if(inputString == "aElectrovalvula"){
  fill(0, 255, 0);
  ellipse(710, 190, 70, 70);
  }
  
  /*if(myPort.available()>0){
  inputString = "";
     while(myPort.read()!='\n'){            //manejo del p.serie
        inChar = (char)myPort.read();
        inputString += inChar;
     }
  }*/
  
  /*if(contB==0){
     contB++;
     inputString = "eCaloventor";
  }else{                                  //pruebaa
     contB=0;
     inputString = "aCaloventor";
  }*/
  
  delay(1000);
  
  if(inputString == "eCaloventor"){
  fill(0, 255, 0);
  ellipse(200, 190, 70, 70);
  }else if(inputString == "aCaloventor"){
  fill(255, 0, 0);
  ellipse(200, 190, 70, 70);
  }
  
  nivel=cuatrobotones();
  switch(nivel){
  case 1:
    outputString = "eCaloventor";
  case 2:
   outputString = "aCaloventor";
  case 3:
   outputString = "eElectrovalvula";
  case 4:
   outputString = "aElectrovalvula";
  }
}

boolean enRect(int x, int y, int ancho, int alto)  {
  if (mouseX >= x && mouseX <= x+ancho && 
      mouseY >= y && mouseY <= y+alto) {
    return true;
  } else {
    return false;
  }
}

int cuatrobotones () {
  if (enRect (140,305,15,15) && mousePressed ){    //encendido del caloventor
  return 1;
}else if (enRect (140,335,15,15) && mousePressed ){   //apagado del caloventor
  return 2;
}else if (enRect (650,305,15,15) && mousePressed ){   //encendido de la e valvula
  return 3;
}else if (enRect (650,335,15,15) && mousePressed ){   //apagado de la valvula
  return 4;
}
  return 0;      
}

void serialEvent(Serial myPort) {
    
   if(myPort.available()>0){
     inputString = "";
      while(myPort.read()!='\n'){
         inChar = (char)myPort.read();
         inputString += inChar;
      }
   }
 }
    
