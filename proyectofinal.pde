import processing.serial.*;
import java.util.Date;
import java.text.SimpleDateFormat;

PImage logo,medidor,agua; //declarar la variable de una imagen
char inChar;
int nivel;
String temperatura = "";
String humedad = "";
String inputString = "";   
String inString = "";
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
  medidor = loadImage("medidor2.png");
  medidor.resize(200,200);
  agua = loadImage("valvula.png");
  agua.resize(200,200);
  myPort = new Serial(this, "COM4", 9600);
  tiempoUltimoRegistro = millis();

}

void draw(){
  background(245, 245, 220);
  
  manometro();
  valvula();
  
  textSize(35);
  fill(0, 0, 0);
  text("INVERNADERO", 350, 50); 
  text("CALEFACCION",100,90);  //dibujo de los textos
  text("RIEGO",650,90); 
  
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
  cargaArchivo(inputString); 
  serialIn();
  cargaArchivo(inputString);

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
  //printpuertos();
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
          inputString = " ";
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

void manometro(){
  
  image(medidor,80,100);
  
  fill(0,0,0); //datos del medidor temperatura
  ellipse(180,200,50,50);
  textSize(12);
  text("0°C",146,245);
  text("10°C",130,210);
  text("20°C",138,182);
  text("30°C",168,170);
  text("40°C",198,182);
  text("50°C",205,210);
  
  temperatura = temperatura.trim();
  int Ntemperatura = int(temperatura);
  String panel = temperatura;
  textSize(19);
  text(panel+="°C",265,133);

  intervalo(132,246,0,0,Ntemperatura);
  intervalo(114,203,1,15,Ntemperatura);
  intervalo(133,153,15,22,Ntemperatura);
  intervalo(155,139,22,28,Ntemperatura);      
  intervalo(180,135,28,32,Ntemperatura);
  intervalo(206,139,32,38,Ntemperatura);
  intervalo(227,154,38,200,Ntemperatura);

  //println(mouseX,mouseY);
}

void intervalo(int X,int Y,int min,int max,int Ntemperatura){
  if(Ntemperatura>min && Ntemperatura<=max && caloventor.equals("ON")){
  fill(0,255,0);
  ellipse(X,Y,13,13);
  }else if(Ntemperatura>min && Ntemperatura<=max && caloventor.equals("OFF")){
  fill(255,0,0);
  ellipse(X,Y,13,13);
  }
}

void valvula(){
  image(agua,590,100);
  fill(0,100,255); //medidor de agua
  rect(601,221,10,60);
  if(electrovalvula.equals("ON")){
    rect(768,221,10,60);  //cuando se enciende el riego se "descomenta"
    fill(0,255,0);    //riego encendido
    rect(655,176,69,10);
  }else if(electrovalvula.equals("OFF"))
    {fill(255,0,0);    //riego apagado
    rect(655,176,69,10);
  } 
}
