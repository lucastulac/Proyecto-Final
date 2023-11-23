#include <dht.h>
dht DHT;
#define DHT11_PIN 8

class Invernadero{  
  public:
  float inHumedad;
  float inTemperatura;           
}Objeto;

String inputString = "sInformacion";
String outputString = "";
bool stringComplete = false;
int rElectrovalvula = 5;
int rCaloventor = 6;
void setup() {
  inputString.reserve(200);
  outputString.reserve(200);
  Serial.begin(9600);
  pinMode(A1,INPUT);
  pinMode(rElectrovalvula,OUTPUT);
  pinMode(rCaloventor,OUTPUT);
  pinMode(13,OUTPUT);

}

void loop() {

  DHT.read11(DHT11_PIN);
  serialIN();                                    
  Objeto.inTemperatura = DHT.temperature;    
  Objeto.inHumedad = analogRead(A1);

  if(inputString=="sInformacion"){ //si en processing no se aprieta ningun boton, los reles los manejan los sensores

    if(Objeto.inTemperatura < 30){ 
    digitalWrite(rCaloventor,HIGH);
    outputString="eCaloventor";
    }
    if(Objeto.inTemperatura>= 30){
    digitalWrite(rCaloventor,LOW);
    outputString="aCaloventor";
    }

  delay(100);
  serialOUT();

    if(Objeto.inHumedad<200){ 
    digitalWrite(rElectrovalvula,HIGH);
    outputString="eElectrovalvula";
    }
    if(Objeto.inHumedad>=200){
    digitalWrite(rElectrovalvula,LOW);
    outputString="aElectrovalvula";
    }

  serialOUT();
  }
  else{ //si inputString es distinto de "sInformacion" es pq en processing se estan tocando los botones, osea, los sensores ya no manejan
        //los reles
    if(inputString == "eCaloventor"){
      digitalWrite(rCaloventor,HIGH);
      outputString="eCaloventor";
      serialOUT();
      delay(100);
    }
    if(inputString == "aCaloventor"){
      digitalWrite(rCaloventor,LOW);
      outputString="aCaloventor";
      serialOUT();
      delay(100);
    }
    if(inputString == "eElectrovalvula"){
      digitalWrite(rElectrovalvula,HIGH);
      outputString="eElectrovalvula";
      serialOUT();
      delay(100);
    }
    if(inputString == "aElectrovalvula"){
      digitalWrite(rElectrovalvula,LOW);
      outputString="aElectrovalvula";
      serialOUT();
      delay(100);
    }
  }
  //Serial.println(Objeto.inHumedad);
  //Serial.println(Objeto.inTemperatura);
  delay(200);
}

void serialIN() {
  while (Serial.available()) 
  {
   inputString = ""; 
   while(stringComplete != true){ 
    char inChar = (char)Serial.read();
     if (inChar != '\n') {
      inputString += inChar;
     }
    else if (inChar == '\n') {
      stringComplete = true;
     }
    }
    stringComplete = false;
  }
}

void serialOUT(){
  delay(400);
  Serial.println(outputString);
}
  
