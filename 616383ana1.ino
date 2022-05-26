
//#include <Arduino.h>
//#include <FastLED.h>

//#define Button 39  //Mstampのボタン



//########### FastLED ##########
//#define NUM_LEDS 1  //FastLEDのLEDの連結数
//#define DATA_PIN 27  //FastLEDのデータピン
//CRGB leds[NUM_LEDS];
//########### FastLED ##########















void setup() {
  Serial.begin(115200);
  
//  pinMode(Button,INPUT);///////M5stampのボタン
//  //########### FastLED ##########
//  FastLED.addLeds<SK6812, DATA_PIN, RGB>(leds, NUM_LEDS);  // GRB ordering is typical
//  FastLED.setBrightness(1);//0-255
//  leds[0] = 0x00FFFF;
//  FastLED.setBrightness(1);//2-255
//  FastLED.show();
//  //########### FastLED ##########

  Serial.println("start");
  delay(100);
  
}


float pre_Angle=0;
int cyc=0;
byte A_flag=0;

void loop() {
//  if (digitalRead(Button)==LOW) {
//    
//  }


  //##########　616404（SAS）の出力を得る　##########
  int A1s = analogRead(32);
  int A2c = analogRead(33);

  float A1s2=0;
  float A2c2=0;

  A1s2 = A1s;
//  A1s2 /= 4095;
//  A1s2 *= 3.3;
//  A1s2 *=1000;

  A2c2 = A2c;
//  A2c2 /= 4095;
//  A2c2 *= 3.3;
//  A2c2 *= 1000;
  
//  Serial.print(A1s);
//  Serial.print(',');
//  Serial.println(A2c);
  //##########　616404（SAS）の出力を得る　##########


  //##########　角度演算する　##########
  A1s -= 2048;
  A2c -= 2048;
  A2c*=-1;
  
  float Angle=0;
  float Angle2=0;
  
  
  Angle=atan2(A2c,A1s);
  Angle *= 180;
  Angle /= 3.14159265359;
  Angle /= 2;
  Angle += 90;

  //##########　角度演算する　##########


  //##########　角度飛びしないように補正する　##########
  if(cyc>0){
    if((Angle-pre_Angle)<-100 && pre_Angle>90){
      A_flag=1; 
    }else if((Angle-pre_Angle)>100 && Angle>90){
      A_flag=0; 
    }else if((Angle-pre_Angle)>100 && pre_Angle<90){
      A_flag=2; 
    }if((Angle-pre_Angle)<-100 && Angle<90){
      A_flag=0; 
    }
  }
  
  Angle2 = Angle;
  if(A_flag==1){
    Angle2 += 180;
  }
  if(A_flag==2){
    Angle2 -= 180;
  }
  //##########　角度飛びしないように補正する　##########
  
  
  Angle2 -= 0;//offset

  
  //##########　角度がマイナスの場合、プラスに変更する　##########
  if(Angle2<-5) Angle2 += 180;
  //##########　角度がマイナスの場合、プラスに変更する　##########

    
  pre_Angle=Angle;


  int data1=0;
  int data2=0;

  data1=(int)Angle;
  data2=(int)Angle2;

  
  
  if(Serial.available() > 0) { // 受信したデータが存在する
    String input = Serial.readStringUntil(';');
    Serial.print(A1s2,3);
    Serial.print(',');
    Serial.print(A2c2,3);
    Serial.print(',');
    Serial.print(Angle);
    Serial.print(',');
    Serial.println(Angle2);
  }
  
//  Serial.print(Angle);
//  Serial.print(',');
//  Serial.println(Angle2);
  
  cyc=10;


}
