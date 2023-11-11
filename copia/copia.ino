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
  serialIN();                         //700 es temp. ambiente aprox            
  Objeto.inTemperatura = DHT.temperature;    
  Objeto.inHumedad = analogRead(A1);

  if(inputString=="sInformacion"){
  if(Objeto.inTemperatura < 30){ 
    digitalWrite(rCaloventor,HIGH);
    outputString="eCaloventor";
    }
  if(Objeto.inTemperatura>= 30){
    digitalWrite(rCaloventor,LOW);
    outputString="aCaloventor";
    }
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
  
  else{
    if(inputString == "eCaloventor"){
      digitalWrite(rCaloventor,HIGH);
      outputString="eCaloventor";
      serialOUT();
    }
    else if(inputString == "aCaloventor"){
      digitalWrite(rCaloventor,LOW);
      outputString="aCaloventor";
      serialOUT();
    }
    else if(inputString == "eElectrovalvula"){
      digitalWrite(rElectrovalvula,HIGH);
      outputString="eEletrovalvula";
      serialOUT();
    }
    else if(inputString == "aElectrovalvula"){
      digitalWrite(rElectrovalvula,LOW);
      outputString="aEletrovalvula";
      serialOUT();
    }
  }
  delay(1000);
}

void serialIN() {
  while (Serial.available()) 
  {
   digitalWrite(13,HIGH);
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
  digitalWrite(13,LOW);
}

void serialOUT(){
  Serial.println(outputString);
}
  
