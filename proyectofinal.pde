import processing.serial.*;
import java.util.Date;
import java.text.SimpleDateFormat;

PImage logo,alerta,agua; //declarar la variable de una imagen
char inChar;
int nivel;
String temperatura = "";
int Ntemperatura;
String humedad = "";
String inputString = "";   
String inString = "";
String outputString = "";  
float x;
float y;
boolean stringComplete = false;
String temperaturaClean = "";
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
  alerta = loadImage("alerta.png");
  alerta.resize(24,24);
  agua = loadImage("valvula.png");
  agua.resize(200,200);
  myPort = new Serial(this, "COM3", 9600);
  tiempoUltimoRegistro = millis();

}

void draw(){
  background(245, 245, 220);
  
  termometroanalogico();
  valvula();
  
  textSize(35);
  fill(0, 0, 0);
  text("INVERNADERO", 350, 50); 
  text("CALEFACCION",100,90);  //dibujo de los textos
  text("RIEGO",650,90); 
  
  line(100,305,800,305);
  
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
 // printpuertos();
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
       if(inChar=='T'){      //inChar primero se filtra entre T(temperatura),X(estado del rele) o H(int humedad)
         temperatura = " ";  //eso decide en que cadena se guarda lo leido del puerto serie
          while(stringComplete != true){    //La T,X,H no se guardan dentro de la cadena, al igual que el \n
            if(inChar!='\n'){ 
              inChar = (char)myPort.read();
              temperatura += inChar;
              
            }else if(inChar == '\n'){
              stringComplete = true;
              
            }
          }
          if(!temperatura.trim().isEmpty()){   //Debugueado, la variable temperatura se guardaba vacia
          temperaturaClean = temperatura;      //la misma cadena temperatura leida del puerto serie se filtra de
          }          //espacios blancos con trim, y isEmpty se usa como condicional de si esta vacia o no
       }            //para guardarse dentro de "temperaturaClean" que se usa luego para el draw
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
       if(inChar=='H'){ //humedad 
          humedad = " ";
          while(stringComplete != true){
            if(inChar!='\n'){ 
              inChar = (char)myPort.read();
               humedad += inChar;
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
 temperaturaClean = temperaturaClean.trim();
 text("Temperatura: "+temperaturaClean,250,465);
 println(mouseX,mouseY);
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

void termometroanalogico(){
  
  //image(medidor,80,100);
 
  circunferencia();
  fill(0,0,0); //datos del medidor temperatura
  //ellipse(180,200,50,50);
  textSize(12);
  strokeWeight(2);
  text("0°",140,197);
  text("12°",157,156);
  text("25°",210,127);
  text("37°",265,156);
  text("50°",284,197);
  
  temperaturaClean = temperaturaClean.trim(); //segunda validacion
  Ntemperatura = int(temperaturaClean);
  String panel = temperaturaClean;
  textSize(19);
  text(panel+="°C",285,133);
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
  
  if(Ntemperatura>=40){
    image(alerta,332,114);
  }
  
}

void circunferencia(){
  
  int radio = 45;
  int centerX = 220;
  int centerY = 198;
  float theta;
  float puntoSize = 10;
  noFill();
  strokeWeight(3);
  ellipse(centerX,centerY,70*2+30,70*2+30);
  ellipse(centerX,centerY,radio*2,radio*2);
  strokeWeight(1);
  theta = map(Ntemperatura, 0, 50, PI, 2*PI);
  // Obtener las coordenadas del borde del círculo y dibujar puntos
    strokeWeight(3);
    line(centerX,centerY,x,y);
    if(Ntemperatura>=30 || caloventor.equals("OFF")){
    fill(255,0,0);
    x = centerX + radio * cos(theta);
    y = centerY + radio * sin(theta);
    ellipse(x,y,puntoSize,puntoSize);
    }else if(Ntemperatura<30 || caloventor.equals("ON")){
    fill(0,255,0);
    x = centerX + radio * cos(theta);
    y = centerY + radio * sin(theta);
    ellipse(x,y,puntoSize,puntoSize);
    }
    
 
  
}
