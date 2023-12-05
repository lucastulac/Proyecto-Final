import processing.serial.*;
import java.util.Date;
import java.text.SimpleDateFormat;

PImage logo;
char inChar;
int nivel;
String temperatura = "";
String humedad = "";
String inputString = "";        
String outputString = "";   
boolean stringComplete = false;
String electrovalvula = "";
String caloventor = "";
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
  
  line(100,285,800,285);
  
  textSize(25);
  text("CONTROL MANUAL",310,335);
  
  fill(0, 0, 0);
  textSize(20);
  text("ENCENDIDO",160,380);
  text("APAGADO",160,410);        //dibujo de textos
  text("ENCENDIDO",670,380);
  text("APAGADO",670,410);
  
  fill(0,255,0);               //botones de encendido y apagado
  rect(140,365,15,15);         //encendido del caloventor
  rect(650,365,15,15);         //encendido de la e valvula
  fill(255,0,0);
  rect(140,395,15,15);        //apagado del caloventor
  rect(650,395,15,15);        //apagado de la valvula
  
  image(logo, 750, 450);
  
  serialIn();
  //printpuertos();
  cargaArchivo(inputString);
     
  if(caloventor.equals("ON")){
  fill(0, 255, 0);
  ellipse(200, 210, 70, 70);
  }
  if(caloventor.equals("OFF")){
  fill(255, 0, 0);
  ellipse(200, 210, 70, 70);
  }
  
  serialIn();
  //printpuertos();
  cargaArchivo(inputString);
  
  if(electrovalvula.equals("ON")){
  fill(0, 255, 0);
  ellipse(710, 210, 70, 70);
  }
  if(electrovalvula.equals("OFF")){
  fill(255, 0, 0);
  ellipse(710, 210, 70, 70);
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
  printpuertos();
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
  if (enRect (140,365,15,15) && mousePressed ){    //encendido del caloventor
  return 1;
}else if (enRect (140,395,15,15) && mousePressed ){   //apagado del caloventor
  return 2;
}else if (enRect (650,365,15,15) && mousePressed ){   //encendido de la e valvula
  return 3;
}else if (enRect (650,395,15,15) && mousePressed ){   //apagado de la valvula
  return 4;
}
  return 5;      
}
 
 void evento(){
  String cleanString = inputString.trim().toLowerCase(); //trim elimina espacios en blanco, toLowerCase convierte todo a min
 if(cleanString.equals("ecaloventor") || cleanString.equals("acaloventor")){
     if(cleanString.equals("ecaloventor")){
       caloventor = "ON";
     }else if(cleanString.equals("acaloventor")){
       caloventor = "OFF";
     }
   }else if(cleanString.equals("eelectrovalvula") || cleanString.equals("aelectrovalvula")){
        if(cleanString.equals("eelectrovalvula")){
         electrovalvula = "ON";
     }else if(cleanString.equals("aelectrovalvula")){
         electrovalvula = "OFF";
     }
   }
 }
 
 void serialIn(){  
 delay(150);
 inChar = ' ';
 while (myPort.available()>0){
   char inChar = (char)myPort.read();       
       if(inChar=='X'){ 
          inputString = "";
          while(stringComplete != true){
            if(inChar!='\n'){ 
              inChar = (char)myPort.read();
               inputString += inChar;
            }else if(inChar == '\n'){
              evento();
              stringComplete = true;
            }
          }
       }
       else if(inChar=='H'){ //humedad 
          humedad = "";
          while(stringComplete != true){
            if(inChar!='\n'){ 
              inChar = (char)myPort.read();
               humedad += inChar;
            }else if(inChar == '\n'){
              stringComplete = true;
            }
          }
       }
       else if(inChar=='T'){
         temperatura = "";
          while(stringComplete != true){
            if(inChar!='\n'){ 
              inChar = (char)myPort.read();
              temperatura += inChar;
            }else if(inChar == '\n'){
              stringComplete = true;
            }
          }
       }
 }
    stringComplete = false;
   //println(inputString);
   //println(temperatura);
   //println(humedad);
   }
 
 void serialOut(){
  delay(00);
  myPort.write(outputString);
  myPort.write(ENTER);
 }
 
 void printpuertos(){
 fill(0,0,0);
 text("Output: "+outputString,30,465); 
 text("Input: "+inputString,30,440);
 text("Humedad: "+humedad,250,440);
 text("Temperatura: "+temperatura,250,465);
 }
 
 void cargaArchivo(String evento) {
  
  if (millis() - tiempoUltimoRegistro >= tiempoEntreRegistros) { 
    Date hora = new Date();  // obtener la fecha y la hora actual

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  // formatear la fecha y hora en un formato legible
    String horaformateada = dateFormat.format(hora);
    String registro = horaformateada + " - " + evento;    // construir la línea a escribir en el archivo
  
    lines = append(lines, registro);    // escribir la línea en el arreglo de strings 
    saveStrings("registro-invernadero.txt", lines);  //guardar el arreglo en el archivo
    tiempoUltimoRegistro = millis(); //reactualiza el tiempo del ultimo registro
  }
}   
