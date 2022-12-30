#include "FS.h"
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <TinyGPS++.h>
#include <SoftwareSerial.h>
#include <Wire.h>
#include "MAX30100_PulseOximeter.h"
#include <OneWire.h>
#include <DallasTemperature.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

int buzzer = D3;  //buzzer

uint8_t connectivityLED = 3;  //Rx pin (GPIO3)(green wire)
uint8_t rideLED = 1;          //Tx pin (GPIO1)(blue wire)

Adafruit_SSD1306 TV = Adafruit_SSD1306(128,64,&Wire);

// Data wire is plugged into digital pin 2 on the Arduino
#define ONE_WIRE_BUS 2  //D4

// Setup a oneWire instance to communicate with any OneWire device
OneWire oneWire(ONE_WIRE_BUS);  

// Pass oneWire reference to DallasTemperature library
DallasTemperature sensors(&oneWire);


// Choose two Arduino pins to use for software serial
int RXPin = 13;   //D7 ()
int TXPin = 15;   //D8 (purple)

int GPSBaud = 9600;

// Create a TinyGPS++ object
TinyGPSPlus gps;

// Create a software serial port called "gpsSerial"
SoftwareSerial gpsSerial(RXPin, TXPin);


// Create a PulseOximeter object
PulseOximeter pox;

//parameters;
float temperature=0;
float heart_rate=0;
float spo2=0;
float lattitude=0;
float longitude=0;
float Altitude=0;
int canShow = 2;

//Variables used to calculate average values
float hrConcat = 0;
int hrCount = 0;
float oxConcat = 0;
int oxCount = 0;
int beatCount = 0;

void onBeatDetected() { //Here it is checked whether reading is valid or not
    ++beatCount;
    Serial.println("Beat!");
    float hrTemp = pox.getHeartRate();
    float oxTemp = pox.getSpO2();
    
    hrConcat += hrTemp;
    if(hrTemp!=0.0){
      ++hrCount;  
    }
    oxConcat += oxTemp;
    if(oxTemp!=0.0){
      ++oxCount;  
    }
    pox.update();
}

void calcMAX30100(){  //Calculated the average values
    if(beatCount!=0){
      if(hrCount==0){
        heart_rate = 0.0;  
      }else{
        heart_rate = hrConcat/hrCount;  
      }
      if(oxCount==0){
        spo2 = 0.0;  
      }else{
        spo2 = oxConcat/oxCount;  
      }
    }
    hrConcat = 0;
    hrCount = 0;
    oxConcat = 0;
    oxCount = 0;
    beatCount=0;
}

/*
const char* ssid = "Dialog 4G 769";
const char* password = "583BbFe3";*/

const char* ssid = "Dialog 4G 517";
const char* password = "576E5Fc3";

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
char msg[300];

void setup_wifi(){
  delay(10);
  espClient.setBufferSizes(512,512);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid,password);

  while(WiFi.status() != WL_CONNECTED){
    analogWrite(connectivityLED,0);
    delay(500);
    Serial.print(".");  
  }

  Serial.println("");
  Serial.println("Wifi connected");
  Serial.println("IP address :");
  Serial.println(WiFi.localIP());
  analogWrite(connectivityLED,50);

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
    showMessage(MSG+"");
    tone(buzzer,1000,200);
    canShow = 2;
  }
}

void changeHospital(String hospital){
  /*This function changes the destination hospital*/
  outTopic = "/AmbulanceProject/Hospital_"+hospital+"/"+deviceID;
  showNewHospital("Kalutara General Hospital");
  canShow = 2;
  tone(buzzer,1000,200);
  if (!pox.begin()) {
    Serial.println("FAILED");
    for(;;);
  }else{
    Serial.println("SUCCESS");
  }
}

void startRide(String newHospital){
  /*This function starts a new ride*/
  showStart();
  delay(1500);
  changeHospital(newHospital);
  client.publish((char*)(outTopic.c_str()),"Active");
  if (!pox.begin()) {
    Serial.println("FAILED");
    for(;;);
  }else{
    Serial.println("SUCCESS");
  }
  pox.update();
  rideFLAG = true;
  analogWrite(rideLED,1023);
}

void stopRide(){
  /*This function stops an existing ride*/
  changeHospital(hospitalID);
  rideFLAG = false;
  analogWrite(rideLED,0);  
  showStop();
  delay(2000);
  showWaiting();
}

void reconnect(){
//  if(WiFi.status() != WL_CONNECTED){
//    setup_wifi();
//  }
  while(!client.connected()){
    analogWrite(connectivityLED,50);
//    if(rideFLAG){   //If there is an ongoing ride and connectivity has been lost
//      analogWrite(rideLED,50);
//    }
    Serial.print("Attempting to MQTT connection");
    if(client.connect("ESPthing")){
      Serial.println("Connected");
//      if(rideFLAG){         //If there is an ongoing ride and connected
//        analogWrite(rideLED,1023);  
//      } 
//      analogWrite(connectivityLED,1023);
      client.subscribe((char*)(inTopic.c_str()));
      showWaiting();
    }else{
      tone(buzzer,1000,200);
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
  sensors.begin();  // Start up the library
  //Begin the display
  TV.begin(SSD1306_SWITCHCAPVCC,0x3C);
  showWelcome();
  
  pinMode(connectivityLED,OUTPUT);  //Set Rx pin as an output
  pinMode(rideLED,OUTPUT);          //Set Tx pin as an output
  analogWrite(connectivityLED,0);
  analogWrite(rideLED,0);
  pinMode(buzzer,OUTPUT);  //Set D3 as output for buzzer

  // put your setup code here, to run once:
  Serial.begin(9600);
  Serial.setDebugOutput(true);

  
  // Start the software serial port at the GPS's default baud
  gpsSerial.begin(GPSBaud);
  
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

  reconnect();

  //max30100
  //Initialize max30100 sensor
  if (!pox.begin()) {
    Serial.println("FAILED");
      for(;;);
  }else{
    Serial.println("SUCCESS");
  }

  // Configure sensor to use 7.6mA for LED drive
  pox.setIRLedCurrent(MAX30100_LED_CURR_37MA);

  //Set the callback function on a beat
  pox.setOnBeatDetectedCallback(onBeatDetected);
}

void showParameters(float temp, float hrate, float spO2){
  TV.clearDisplay();
  TV.setTextColor(WHITE);

  TV.setTextSize(1);
  TV.setCursor(0,4);
  TV.print("TEMP");
  
  TV.setTextSize(2);
  TV.setCursor(33,0);
  TV.printf("%.2f",temp);

  TV.setTextSize(1);
  TV.setCursor(115,4);
  TV.printf("%cC",248);
  
  TV.setTextSize(1);
  TV.setCursor(0,29);
  TV.print("H.R.");
  
  TV.setTextSize(2);
  TV.setCursor(33,25);
  TV.printf("%.2f",hrate);

  TV.setTextSize(1);
  TV.setCursor(110,29);
  TV.print("BPM");
  
  TV.setTextSize(1);
  TV.setCursor(0,54);
  TV.print("O.S.");

  TV.setTextSize(2);
  TV.setCursor(33,50);
  TV.printf("%.2f",spO2);

  TV.setTextSize(1);
  TV.setCursor(115,54);
  TV.print("%");
  
  TV.display();   
}

void showNewHospital(String new_hospital){
  
  TV.clearDisplay();
  TV.setTextColor(WHITE);

  TV.setTextSize(2);
  TV.setCursor(20,0);
  TV.print("NEW");

  TV.setTextSize(1);
  TV.setCursor(62,6);
  TV.print("HOSPITAL");
  
  TV.setTextSize(1);
  TV.setCursor(0,30);
  TV.print(new_hospital);

  TV.display();   
}

void showStart(){
  
  TV.clearDisplay();
  TV.setTextColor(WHITE);

  TV.setTextSize(3);
  TV.setCursor(38,5);
  TV.print("NEW");
  
  TV.setTextSize(3);
  TV.setCursor(2,40);
  TV.print("PATIENT");

  TV.display();   
}

void showStop(){
  
  TV.clearDisplay();
  TV.setTextColor(WHITE);

  TV.setTextSize(3);
  TV.setCursor(40,5);
  TV.print("END");
  
  TV.setTextSize(3);
  TV.setCursor(30,40);
  TV.print("RIDE");

  TV.display();   
}


void showWelcome(){
  
  TV.clearDisplay();
  TV.setTextColor(WHITE);

  TV.setTextSize(2);
  TV.setCursor(24,27);
  TV.print("WELCOME");
  
  TV.display();   
}


void showEnd(){
  
  TV.clearDisplay();
  TV.setTextColor(WHITE);

  TV.setTextSize(2);
  TV.setCursor(17,27);
  TV.print("GOOD BYE");
  
  TV.display();   
}


void showWaiting(){
  
  TV.clearDisplay();
  TV.setTextColor(WHITE);

  TV.setTextSize(3);
  TV.setCursor(2,0);
  TV.print("WAITING");

  TV.setTextSize(2);
  TV.setCursor(8,30);
  TV.print("for a new");

  TV.setTextSize(2);
  TV.setCursor(20,47);
  TV.print("patient");

  TV.display();   
}

void showMessage(String message){
  
  TV.clearDisplay();
  TV.setTextColor(WHITE);

  TV.setTextSize(2);
  TV.setCursor(20,0);
  TV.print("NEW MSG");

  TV.setTextSize(1);
  TV.setCursor(0,30);
  TV.print(message);

  TV.display();   
}

void disconnectAWS(){
    client.disconnect();
}

void rideButton(){
  if(rideFLAG){
    stopRide();
  }else{
    startRide("Colombo General Hospital");
  }
}

void connectButton(){
  if(client.connected()){
    disconnectAWS();
  }else{
    reconnect();
  }
}

float value3 = 58;

void loop() {
  // put your main code here, to run repeatedly:
  pox.update(); 
  if(!client.connected()){
      reconnect();  
  }

  if(rideFLAG){
    pox.update();
    
    
    client.loop();
    long now = millis();
    //location updating
    if(gpsSerial.available() > 0){
      if(gps.encode(gpsSerial.read())){
        if(gps.location.isValid()){
          lattitude = gps.location.lat();
          longitude = gps.location.lng();
          Altitude = gps.altitude.meters();
        }
      }
    }
   
    pox.update();
    if(now-lastMsg>2000){
      pox.update();
      lastMsg = now;
      sensors.setWaitForConversion(false);
      sensors.requestTemperatures();
      temperature = sensors.getTempCByIndex(0);
      sensors.setWaitForConversion(true);
      Serial.print("Latitude: ");
      Serial.println(gps.location.lat(), 6);
      Serial.print("Longitude: ");
      Serial.println(gps.location.lng(), 6);
      Serial.print("Altitude: ");
      Serial.println(gps.altitude.meters());
      calcMAX30100();
      snprintf(msg,300,"{\"temperature\": %f, \"heart rate\": %f, \"pulse rate\": %f, \"oxygen saturation\": %f, \"lattitude\": %f, \"longitude\": %f, \"altitude\": %f}",temperature,heart_rate,value3,spo2,lattitude,longitude,Altitude);
      if(canShow==0){
        showParameters(temperature,heart_rate,spo2); 
        tone(buzzer,10000,150); 
      }else{
        tone(buzzer,1000,200);
        --canShow;  
      }
      
      Serial.print("Publish message: ");
      Serial.print(outTopic);
      Serial.println(msg);
      client.publish((char*)(outTopic.c_str()),msg);
      pox.begin();
      Serial.print("Heap: ");
      Serial.println(ESP.getFreeHeap());
    }
  }
} 
