uint8_t connectivityLED = 3;  //Rx pin (GPIO3)

void setup() {
  pinMode(connectivityLED,OUTPUT);  //Set Rx pin as an output
  analogWrite(connectivityLED,0);
}
int x = 0;
void loop(){
  if(x<100){
    analogWrite(connectivityLED,0);
  }else if(x<200){
    analogWrite(connectivityLED,50);
  }else if(x<300){
    analogWrite(connectivityLED,1023);
  }else{
    x=0;  
  }
  x++;
  delay(20);
}
