int intpin = D5;

void abc(){
  Serial.println("abc");  
}

void setup() {
  Serial.begin(9600);
  pinMode(intpin,INPUT);  //Set Rx pin as an output
  attachInterrupt(intpin,abc,CHANGE);
}


void loop(){

}
