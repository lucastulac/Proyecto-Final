import processing.serial.*;
import java.util.Date;
import java.text.SimpleDateFormat;

PImage logo;
char inChar;
int nivel;
String inputString = "";        
String outputString = "";   
boolean stringComplete = false;
String lines[];
int tiempoEntreRegistros = 5000; // Pausa de 5 segundos entre registros
int tiempoUltimoRegistro;
Serial myPort;

void setup(){
  
  
  
  size(900, 500);
  PFont myFont = createFont(PFont.list()[3], 35);
  textFont(myFont);
  lines = new String[0];
  logo = loadImage("logo-utn.png");
  logo.resize(200, 50);
  myPort = new Serial(this, "COM4", 9600);
  tiempoUltimoRegistro = millis();

}

void draw(){
  background(245, 245, 220);
  
  textSize(35);
  fill(0, 0, 0);
  text("INVERNADERO", 300, 50);
  text("CALEFACCION",70,140);        //dibujo de los textos
  text("RIEGO",650,140); 
  
  fill(0, 0, 0);
  textSize(20);
  text("ENCENDIDO",160,320);
  text("APAGADO",160,350);        //dibujo de textos
  text("ENCENDIDO",670,320);
  text("APAGADO",670,350);
  
  fill(0,255,0);               //botones de encendido y apagado
  rect(140,305,15,15);         //encendido del caloventor
  rect(650,305,15,15);         //encendido de la e valvula
  fill(255,0,0);
  rect(140,335,15,15);        //apagado del caloventor
  rect(650,335,15,15);        //apagado de la valvula
  
  image(logo, 750, 450);
  serialIn();
  cargaArchivo(inputString);
  
  if(inputString == "eCaloventor"){
  fill(0, 255, 0);
  ellipse(200, 190, 70, 70);
  text("Prueba",450,250);
  }
  else if(inputString == "aCaloventor"){
  fill(255, 0, 0);
  ellipse(200, 190, 70, 70);
  }
  
  serialIn();
  cargaArchivo(inputString);
  
  if(inputString == "eElectrovalvula"){
  fill(255, 0, 0);
  ellipse(710, 190, 70, 70);
  }
  else if(inputString == "aElectrovalvula"){
  fill(0, 255, 0);
  ellipse(710, 190, 70, 70);
  }
   
  nivel=cuatrobotones();
  switch(nivel){

  case 1:
    outputString = "eCaloventor";
    break;
  case 2:
   outputString = "aCaloventor";
   break;
  case 3:
   outputString = "eElectrovalvula";
   break;
  case 4:
   outputString = "aElectrovalvula";
   break;
  case 5:
   outputString = "sInformacion";
   break;
  }
  
  serialOut(); 
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
  return 5;      
}
 
 void serialIn(){  
 delay(50);
 while (myPort.available()>0){
   inputString = "";
   while(stringComplete != true){ 
    char inChar = (char)myPort.read();
     if (inChar != '\n') {
      inputString += inChar;
     }
    else if (inChar == '\n') {
      stringComplete = true;
     }
    }
    stringComplete = false;
  }
  printpuertos();
 }
 
 void serialOut(){
  delay(50);
  myPort.write(outputString);
  myPort.write(ENTER);
  printpuertos();
 }
 
 void printpuertos(){
 fill(0,0,0);
 text("Output: "+outputString,30,465); 
 text("Input: "+inputString,30,440);
 }
 
 void cargaArchivo(String evento) {
  
  if (millis() - tiempoUltimoRegistro >= tiempoEntreRegistros) { 
    Date hora = new Date();  // Obtener la fecha y la hora actual

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  // Formatear la fecha y hora en un formato legible
    String horaformateada = dateFormat.format(hora);
    String registro = horaformateada + " - " + evento;    // Construir la línea a escribir en el archivo
  
    lines = append(lines, registro);    // Escribir la línea en el arreglo de strings 
    saveStrings("registro-invernadero.txt", lines);  //Guardar el arreglo en el archivo
    tiempoUltimoRegistro = millis();
  }
}   
