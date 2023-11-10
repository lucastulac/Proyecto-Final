#include <dht.h>
dht DHT;
#define DHT11_PIN 8

class Invernadero{  
  public:
  float inHumedad;
  float inTemperatura;           
}Objeto;

String inputString = "";
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

}

void loop() {

  DHT.read11(DHT11_PIN);
  serialIN();                         //700 es temp. ambiente aprox
  serialOUT(outputString);            //0° es 1023 en el s.temperatura DH11
  Objeto.inTemperatura = DHT.temperature;    
  Objeto.inHumedad = analogRead(A1);

  if(Objeto.inTemperatura < 30 || inputString == "eCaloventor"){ //El 100 va a ser una variable in de processing, el usuario seteara a la temp que quiere que se prenda el caloventor
    digitalWrite(rCaloventor,HIGH);
    outputString="eCaloventor";
    }else if(Objeto.inTemperatura>= 30 || inputString == "aCaloventor"){
    digitalWrite(rCaloventor,LOW);
    outputString="aCaloventor";
  }
  delay(1000);
  serialOUT(outputString);
  if(Objeto.inHumedad<200 || inputString == "eEletrovalvula"){ //lo mismo que lo del caloventor, el usuario setea la humedad a partir de la que se quiere regar
    digitalWrite(rElectrovalvula,HIGH);
    outputString="eElectrovalvula";
    }else if(Objeto.inHumedad>=200 || inputString == "aEletrovalvula"){
   digitalWrite(rElectrovalvula,LOW);
   outputString="aElectrovalvula";
  } 
  delay(1000);


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

void serialOUT(String outputString){
  Serial.println(outputString);
}
  
