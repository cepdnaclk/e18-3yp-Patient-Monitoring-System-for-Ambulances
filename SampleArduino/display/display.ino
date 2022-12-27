#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

Adafruit_SSD1306 TV = Adafruit_SSD1306(128,64,&Wire);

void setup(){
  
  TV.begin(SSD1306_SWITCHCAPVCC,0x3C);
    
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

int x=0;
void loop(){
//  showParameters();
  if(x<5){
    showWelcome();  
  }else if(x<10){
    showWaiting();
  }else if(x<15){
    showStart();
  }else if(x<20){
    showParameters(x*1.53,x*1.18,x*1.15);
  }else if(x<25){
    showNewHospital("Kalutara General Hospital");
  }else if(x<30){
    showParameters(x*1.53,x*1.18,x*1.15);
  }else if(x<35){
    showMessage("Send the patient name plz");
  }else if(x<40){
    showParameters(x*1.53,x*1.18,x*1.15);
  }else if(x<45){
    showStop();
  }else if(x<50){
    showWaiting();
  }else if(x<55){
    showEnd();
  }else{
    x=0;  
  }
  ++x;
  delay(1000);
}
