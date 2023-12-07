#include <dht.h>
#define DHT11_PIN 8
dht DHT;

class Invernadero{  
  public:
  int Humedad;
  int Temperatura;
  void setTemperatura();
  void setHumedad(); 
  void ConvertStrings();         
}Objeto;

String inputString = "sInformacion";
String outputString = "";
String temperatura = "";
String humedad = "";
bool stringComplete = false;
int rElectrovalvula = 5;
int rCaloventor = 6;

void setup() {
  inputString.reserve(200);
  outputString.reserve(200);
  temperatura.reserve(200);
  humedad.reserve(200);
  Serial.begin(9600);
  pinMode(A1,INPUT);
  pinMode(rElectrovalvula,OUTPUT);
  pinMode(rCaloventor,OUTPUT);
  pinMode(13,OUTPUT);

}

void loop() {

  Objeto.setTemperatura();
  Objeto.setHumedad();
  Objeto.ConvertStrings();
  serialIN();                                    

  if(inputString=="sInformacion"){ //si en processing no se aprieta ningun boton, los reles los manejan los sensores

    if(Objeto.Temperatura < 30){ 
    digitalWrite(rCaloventor,HIGH);     //control del sensado de la temperatura
    outputString="eCaloventor";
    }
    if(Objeto.Temperatura>= 30){
    digitalWrite(rCaloventor,LOW);
    outputString="aCaloventor";
    }

  delay(100);
  serialOUT();

    if(Objeto.Humedad<200){ 
    digitalWrite(rElectrovalvula,HIGH);   //control del sensado de riego
    outputString="eElectrovalvula";
    }
    if(Objeto.Humedad>=200){
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
  delay(150); //era 400 antes
  Serial.println(temperatura);
  delay(150);
  Serial.print('X');
  Serial.println(outputString);
  delay(150);
  Serial.println(humedad);
}

void Invernadero::setHumedad(){  
  Objeto.Humedad = analogRead(A1);
}

void Invernadero::setTemperatura(){
  DHT.read11(DHT11_PIN);
  Objeto.Temperatura = DHT.temperature;  
}

void Invernadero::ConvertStrings(){
  temperatura = "T";
  humedad = "H";
  temperatura += Objeto.Temperatura;
  humedad += Objeto.Humedad;
}



