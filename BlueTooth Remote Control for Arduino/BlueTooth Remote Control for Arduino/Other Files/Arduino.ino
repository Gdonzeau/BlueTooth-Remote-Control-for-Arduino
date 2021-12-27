/*
 * 
 */

#include <Wire.h>
#include <SoftwareSerial.h>
SoftwareSerial BT(10, 9); //TX Pin,RX Pin
// Connect Tx to pin 10 and RX to pin 9

// Buffer for BlueTooth
char incomingByte;
String readBuffer = "";
bool recu = 0;

// Setting diodes
int pinDiode = 13;
int pinDiodeRed = 2;

// Setinng Servo
int periode = 20000;
int pinServo = 3;

// Setting time
long temps = 0;
long tempspasse = 100; // Every 0,1 seconds

// Datas
int light;
int data2 = 200; // If you need to send another data
int servoAngle = 90;

void setup() {
  pinMode(pinServo, OUTPUT); // on prépare le pin en mode OUTPUT
  digitalWrite(pinServo, LOW); // on l'initialise à l'état bas
  
  BT.begin(9600);
  
  pinMode(pinDiode, OUTPUT);
  pinMode(pinDiodeRed, OUTPUT);
  
  blinkRed();
}

void loop() {
  light = analogRead(A0); //Let's measure the light
  
  while (BT.available()) {            // If Bluetooth has data
    recu = 1;
    incomingByte = BT.read();          // Store each icoming byte from Bluetooth Module
    delay(5);
    readBuffer += char(incomingByte);    // Add each byte to ReadBuffer string variable
  }

  if (recu == 1) {
    analyseSignal();
    readBuffer = "";
    recu = 0;
  }

  if (millis() - temps >= tempspasse) {
    temps = millis();
    
    String messageToSent = String(light) + ":" + String(servoAngle);
    // The message has to be : "data01 : data02"
    
    sendMessage(messageToSent);
  }

}

void analyseSignal() {
  
// succession of if / else if to analyse message received (switch doesn't work with String)

  if (readBuffer == "LED_ON") {
    sendMessage("LED ON:");
    digitalWrite(pinDiodeRed, HIGH);
    
  } else if (readBuffer ==  "LED_OFF") {
    sendMessage("LED OFF: ");
    digitalWrite(pinDiodeRed, LOW);
    
  } else if (readBuffer == "Servo+") {
    servoAngle = servoAngle + 5;
    if (servoAngle > 179) {
      servoAngle = 179;
    }
    setAngle(servoAngle);
    
  } else if (readBuffer == "Servo-") {
    servoAngle = servoAngle - 5;
    if (servoAngle < 0) {
      servoAngle = 0;
    }
    setAngle(servoAngle);
    
  } else if (readBuffer == "0") {
    servoAngle = 0;
    setAngle(servoAngle);
    
  } else if (readBuffer == "90") {
    servoAngle = 90;
    setAngle(servoAngle);
    
  } else if (readBuffer == "179") {
    servoAngle = 179;
    setAngle(servoAngle);
    
  } else {
    sendMessage("Pas compris : ");
  }
  
}

void blinkRed() {
  for (int i = 0; i < 5 ; i++) {
    digitalWrite(pinDiodeRed, HIGH);
    delay(100);
    digitalWrite(pinDiodeRed, LOW);
    delay(100);
  }
}

void sendMessage(String message) {
  BT.println(message);
  //blink();
}

void setAngle(int a) {
  
  int duree = map(a, 0, 179, 500, 2500); // on transforme l'angle en microsecondes et on stocke dans la variable duree
  digitalWrite(pinServo, LOW); //on met le pin à l'état bas

  for (int t = 0; t < 80; t++) {
    digitalWrite(pinServo, HIGH); // on envoie l'impulsion
    delayMicroseconds(duree); // pendant la bonne durée
    digitalWrite(pinServo, LOW); // on stoppe l'impulsion
    delayMicroseconds(periode - duree); // on attend le temps restant pour atteindre la période
  }
}
