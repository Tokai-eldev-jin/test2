#include <M5Stack.h>
#include "BluetoothSerial.h"
BluetoothSerial SerialBT;

String MACadd = "AA:BB:CC:11:22:33";
uint8_t address[6]  = {0xAA, 0xBB, 0xCC, 0x11, 0x22, 0x33};
//uint8_t address[6]  = {0x00, 0x1D, 0xA5, 0x02, 0xC3, 0x22};
String name = "ESP32test";
char *pin = "1234"; //<- standard pin would be provided by default
bool connected;



void setup() {
  M5.begin(false, true, true, true);
  M5.Lcd.fillScreen(BLUE);
  M5.Lcd.setTextColor(YELLOW);
  //Serial.begin(115200);
  
  SerialBT.begin("ESP32test2", true); 
  Serial.println("The device started in master mode, make sure remote BT device is on!");

  connected = SerialBT.connect(name);


  if(connected) {
    Serial.println("Connected Succesfully!");
  } else {
    while(!SerialBT.connected(10000)) {
      Serial.println("Failed to connect. Make sure remote device is available and in range, then restart app."); 
    }
  }
  // disconnect() may take upto 10 secs max
  if (SerialBT.disconnect()) {
    Serial.println("Disconnected Succesfully!");
  }
  // this would reconnect to the name(will use address, if resolved) or address used with connect(name/address).
  SerialBT.connect();

  Serial.println("start");
  delay(100);
  
}


int getdata=0;
int getdata1=0;
int getdata2=0;
int X1=0;
int X2=0;

void loop() {
  M5.update();
  

  if (SerialBT.available()) {
    while(SerialBT.available()<4){
      delay(1);
    }
    
    getdata=SerialBT.read();
    getdata1=SerialBT.read();
    getdata2 = getdata1<<8;
    getdata2 |= getdata;
    X1=getdata2;

    getdata=SerialBT.read();
    getdata1=SerialBT.read();
    getdata2 = getdata1<<8;
    getdata2 |= getdata;  
    X2=getdata2;
  }

  if(Serial.available() > 0) { // 受信したデータが存在する
    String input = Serial.readStringUntil(';');
    Serial.print(X1);
    Serial.print(',');
    Serial.println(X2);
  }
    
  delay(30);
}
