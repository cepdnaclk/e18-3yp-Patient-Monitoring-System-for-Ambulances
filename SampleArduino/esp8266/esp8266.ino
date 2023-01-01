#include "FS.h"
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
//#include <OneWire.h>
//#include <DallasTemperature.h>
//#include <Wire.h>
#include <TinyGPS++.h>
#include <SoftwareSerial.h>
//#include "MAX30100_PulseOximeter.h"

/*
// Data wire of DS18B20 is plugged into digital pin 2 on the Arduino
#define ONE_WIRE_BUS 2

// Setup a oneWire instance to communicate with any OneWire device
OneWire oneWire(ONE_WIRE_BUS);

// Pass oneWire reference to DallasTemperature library
DallasTemperature ds18b20(&oneWire);
*/

/*
// Create a PulseOximeter object
PulseOximeter pox;
*/
/*

// Choose two Arduino pins to use for software serial
int RXPin = 13;   //D7
int TXPin = 15;   //D8

int GPSBaud = 9600;

// Create a TinyGPS++ object
TinyGPSPlus gps;

// Create a software serial port called "gpsSerial"
SoftwareSerial gpsSerial(RXPin, TXPin);
*/
/*
const char* ssid = "Dialog 4G 769";
const char* password = "583BbFe3";*/

char* ssid = "Dialog 4G 517";
char* password = "576E5Fc3";

/*
const char* ssid = "Eng-Student";
const char* password = "3nG5tuDt";
*/
/*
const char* ssid = "ACES_Coders";
const char* password = "Coders@2022";
*/
/*
const char* ssid = "Gimhara Wi~Fi";
const char* password = "hachcha@1122";
*/

String const deviceID = "001";
String const hospitalID = "001";
String outTopic;
String inTopic = "Device_"+deviceID;

boolean rideFLAG = false;

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP,"pool.ntp.org");

const char* AWS_endpoint = "a3rwyladencomq-ats.iot.ap-northeast-1.amazonaws.com";

void callback(char* topic, byte* payload, unsigned int length){
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  boolean found = false;
  String receivedMsg = "";
  String msgType = "";
  for(int i=0;i<length;i++){
    Serial.print((char)payload[i]);
    if(found){
      receivedMsg = receivedMsg + (char)payload[i];    
    }else if((char)payload[i]==':'){
      msgType = msgType + (char)0;
      found = true;
    }else{
      msgType = msgType + (char)payload[i];
    }
  }
  checkMsg(msgType,receivedMsg);
  Serial.println();
}

WiFiClientSecure espClient;
PubSubClient client(AWS_endpoint,8883,callback,espClient);
long lastMsg = 0;
char msg[200];
float temperature;
float heart_rate;
float spo2;
float lattitude;
float longitude;
float Altitude;

void setup_wifi(){
  delay(10);
  espClient.setBufferSizes(512,512);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid,password);

  while(WiFi.status() != WL_CONNECTED){
    delay(500);
    Serial.print(".");  
  }

  Serial.println("");
  Serial.println("Wifi connected");
  Serial.println("IP address :");
  Serial.println(WiFi.localIP());

  timeClient.begin();
  while(!timeClient.update()){
    timeClient.forceUpdate();  
  }

  espClient.setX509Time(timeClient.getEpochTime());
  
}

void checkMsg(String msgType,String MSG){
  /*This function checks the type of the received msg and proceed the corresponding task*/
  Serial.print("msgType:"+msgType);
  Serial.print("MSG:"+MSG);
  if(!strcmp(msgType.c_str(),(char*)"start")){    //If msg is to start a ride
    if(!rideFLAG){
      startRide(MSG);
    }
  }else if(!strcmp(msgType.c_str(),(char*)"stop")){    //If msg is to stop a ride
    stopRide();
  }else if(!strcmp(msgType.c_str(),(char*)"change")){    //If msg is to chnage the hospital
    changeHospital(MSG);
  }else{                                //If it is just a msg
    Serial.print("NEW MSG:"+MSG);
  }
}

void changeHospital(String hospital){
  /*This function changes the destination hospital*/
  outTopic = "/AmbulanceProject/Hospital_"+hospital+"/"+deviceID;
}

void startRide(String newHospital){
  /*This function starts a new ride*/
  changeHospital(newHospital);
  client.publish((char*)(outTopic.c_str()),"Active");
  rideFLAG = true;
}

void stopRide(){
  /*This function stops an existing ride*/
  changeHospital(hospitalID);
  rideFLAG = false;  
}

void reconnect(){
  while(!client.connected()){
    Serial.print("Attempting to MQTT connection");
    if(client.connect("ESPthing")){
      Serial.println("Connected");
//      client.publish("outTopic","Hello World");
      client.subscribe((char*)(inTopic.c_str()));
    }else{
      Serial.print("failed,rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");


      char buf[256];
      espClient.getLastSSLError(buf,256);
      Serial.print("WiFiClientSecure SSL error: ");
      Serial.println(buf);
      delay(5000);
    }
  }  
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.setDebugOutput(true);

  /*
  // Start the software serial port at the GPS's default baud
  gpsSerial.begin(GPSBaud);
  */
  pinMode(LED_BUILTIN,OUTPUT);
  setup_wifi();
  delay(1000);
  if(!SPIFFS.begin()){
    Serial.println("Failed to mount file system");
    return;  
  }  

  Serial.print("Heap: ");

  Serial.println(ESP.getFreeHeap());

  File cert = SPIFFS.open("/cert.der","r");         /*Load cert*/
  
  if(!cert){
    Serial.println("failed to open cert file");
  }else{
    Serial.println("Success to open cert file");  
  }

  delay(1000);


  if(espClient.loadCertificate(cert)){
    Serial.println("Cert loaded");  
  }else{
    Serial.println("Cert not loaded");
  }

  File private_key = SPIFFS.open("/private.der","r");   /*Load private*/

  if(!private_key){
    Serial.println("Failed to open CERt file");  
  }else{
    Serial.println("Success to open CERt file");
  }

  delay(1000);


  if(espClient.loadPrivateKey(private_key)){
    Serial.println("Private key loaded");  
  }else{
    Serial.println("Private Key not loaded");
  }

  File ca = SPIFFS.open("/ca.der","r");               /*Load ca*/

  if(!ca){
    Serial.println("Failed to open ca file");  
  }else{
    Serial.println("Success to open ca file");
  }

  delay(1000);


  if(espClient.loadCACert(ca)){
    Serial.println("ca loaded");  
  }else{
    Serial.println("ca not loaded");
  }
  Serial.print("Heap: ");
  Serial.println(ESP.getFreeHeap());
  /*
  //max30100
  //Initialize max30100 sensor
  if (!pox.begin()) {
    Serial.println("FAILED");
      for(;;);
  }else{
    Serial.println("SUCCESS");
  }

  // Configure sensor to use 7.6mA for LED drive
  pox.setIRLedCurrent(MAX30100_LED_CURR_7_6MA);
  */
}
float value1 = 42;
float value2 = 61;
float value3 = 58;
float value4 = 83;

void loop() {
  // put your main code here, to run repeatedly:
  if(!client.connected()){
    reconnect();  
    
  }
  client.loop();

  if(rideFLAG){
    long now = millis();
    //pox.update();
    if(now-lastMsg>2000){
      lastMsg = now;
  
      /*//Read from the ds18b20 sensor
      ds18b20.requestTemperatures();
      temperature = ds18b20.getTempCByIndex(0);*/ 
      /*
      // Read from the max30100 sensor
      heart_rate = pox.getHeartRate();
      spo2 = pox.getSpO2();
      Serial.print(heart_rate);
      Serial.print(spo2);*/
      /*// Read from the max30100 sensor
      gpsSerial.read();
      lattitude = gps.location.lat();
      longitude = gps.location.lng();
      Altitude = gps.location.meters();*/
      password = "d";
      //snprintf(msg,200,"{\"Temperature\": %ld, \"Heart rate\": %ld, \"Oxygen sat. level\": %ld, \"Lattitude\": %ld, \"Longitude\": %ld, \"Altitude\": %ld}",temperature,heart_rate,spo2,lattitude,longitude,Altitude);
      //snprintf(msg,200,"{\"Heart rate\": %ld, \"Oxygen sat. level\": %ld}",heart_rate,spo2);
      snprintf(msg,200,"{\"temperature\": %f, \"heart rate\": %f, \"pulse rate\": %f, \"oxygen saturation\": %f}",value1,value2,value3,value4);
      value1=value1+0.243;
      value2=value2+0.3578;
      value3=value3+0.1259;
      value4=value4+0.5346;
      
      Serial.print("Publish message: ");
      Serial.print(outTopic);
      Serial.println(msg);
      client.publish((char*)(outTopic.c_str()),msg);
      Serial.print("Heap: ");
      Serial.println(ESP.getFreeHeap());
    }
  }
  digitalWrite(LED_BUILTIN,HIGH);
  delay(100);
  digitalWrite(LED_BUILTIN,LOW);
  delay(100);
} 
