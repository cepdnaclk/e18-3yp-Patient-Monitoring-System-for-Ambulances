#include "FS.h"
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include <Wire.h>
#include <TinyGPS++.h>
#include <SoftwareSerial.h>
#include "MAX30100_PulseOximeter.h"

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

const char* ssid = "Dialog 4G 769";
const char* password = "583BbFe3";

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP,"pool.ntp.org");

const char* AWS_endpoint = "a3rwyladencomq-ats.iot.ap-northeast-1.amazonaws.com";

void callback(char* topic, byte* payload, unsigned int length){
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for(int i=0;i<length;i++){
    Serial.print((char)payload[i]);  
  }
  Serial.println();
}

WiFiClientSecure espClient;
PubSubClient client(AWS_endpoint,8883,callback,espClient);
long lastMsg = 0;
char msg[100];
float temperature;
float heart_rate;
float spo2;
float value4 = 45.6;

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

void reconnect(){
  while(!client.connected()){
    Serial.print("Attempting to MQTT connection");
    if(client.connect("ESPthing")){
      Serial.println("Connected");
      client.publish("outTopic","Hello World");
      client.subscribe("inTopic");
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
/* max30100
  // Initialize max30100 sensor
  if (!pox.begin()) {
    Serial.println("FAILED");
      for(;;);
  }else{
    Serial.println("SUCCESS");
  }

  // Configure sensor to use 7.6mA for LED drive
  pox.setIRLedCurrent(MAX30100_LED_CURR_7_6MA);*/
}
int a = 0;
void loop() {
  // put your main code here, to run repeatedly:
  if(!client.connected()){
    reconnect();  
    
  }
  client.loop();
  
  long now = millis();
  if(now-lastMsg>2000){
    lastMsg = now;

    /*//Read from the ds18b20 sensor
    ds18b20.requestTemperatures();
    temperature = ds18b20.getTempCByIndex(0);*/ 
    
    /*// Read from the max30100 sensor
    pox.update();
    heart_rate = pox.getHeartRate();
    spo2 = pox.getSpO2();*/
    
    value4 = value4 + 0.1;
    snprintf(msg,100,"{\"Temperature\": %ld, \"Heart rate\": %ld, \"Oxygen sat. level\": %ld, \"Pulse rate\": %ld}",temperature,heart_rate,spo2,value4);
    Serial.print("Publish message: ");
    Serial.println(msg);
    if(a==0){
      client.publish("outTopic1",msg);
      a=1; 
    }else{
      client.publish("outTopic2",msg);
      a=0;
    }
    Serial.print("Heap: ");
    Serial.println(ESP.getFreeHeap());
  }
  
  digitalWrite(LED_BUILTIN,HIGH);
  delay(100);
  digitalWrite(LED_BUILTIN,LOW);
  delay(100);
} 
