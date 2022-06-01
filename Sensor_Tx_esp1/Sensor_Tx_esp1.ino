
#include "BluetoothSerial.h"

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

BluetoothSerial SerialBT;


void setup() {
  
  Serial.begin(115200);
  SerialBT.begin("ESP32test"); //Bluetooth device name
  Serial.println("The device started, now you can pair it with bluetooth!");
}




int Xval=0;
int Yval=0;
int Xval2=0;
int Yval2=0;


void loop() {

  int X1=analogRead(33);
  int X2=analogRead(32);
  int Y1=analogRead(35);
  int Y2=analogRead(34);

  X1 -= 1775;
  X2 -= 1775;
  Y1 -= 1775;
  Y2 -= 1775;

  float AngX=0;
  float AngY=0;
     
  AngX=atan2(X1,X2);
  AngX *= 180;
  AngX /= 3.14159265359;
  AngX += 180;
  AngX /= 2;
  
  AngY=atan2(Y2,Y1);
  AngY *= 180;
  AngY /= 3.14159265359;
  AngY += 180;
  AngY /= 2;
  
  Xval=AngX;
  Yval=AngY;
  
  int Xoffset=0;
  int Yoffset=0;

  Xval -= Xoffset;
  Yval -= Yoffset;

  byte xmax=180;
  byte xmin=0;
  byte ymax=180;
  byte ymin=0;
  int Xrange=300;
  int Yrange=300;

    
  Xval2 = map(Xval,xmin,xmax,0,Xrange);
  Yval2 = map(Yval,ymax,ymin,0,Yrange);

  SerialBT.write(lowByte(Xval2));
  SerialBT.write(highByte(Xval2));
  SerialBT.write(lowByte(Yval2));
  SerialBT.write(highByte(Yval2));
    
  Serial.print(Xval2);
  Serial.print(',');
  Serial.println(Yval2);

  delay(40);
    
}
