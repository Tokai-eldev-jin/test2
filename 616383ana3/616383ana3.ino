

void setup() {
  Serial.begin(115200);
  Serial.println("start");
  delay(100);

  while(true){
    if(Serial.available() > 0) { // 受信したデータが存在する
      String input = Serial.readStringUntil('\n');
      break;
    }
    delay(1);
  }
  
  Serial.print(1);
  Serial.print(',');
  Serial.print(1);
  Serial.print(',');
  Serial.print(1);
  Serial.print(',');
  Serial.println(1);
}





float pre_Angle=0;
int cyc=0;
byte A_flag=0;

int A1s_offset=202;
int A2c_offset=195;







void loop() {

  while(true){
    if(Serial.available() > 0) { // 受信したデータが存在する
      String input = Serial.readStringUntil('\n');
      break;
    }
    delay(1);
  }

  //##########　616404（SAS）の出力を得る　##########
  int A1s = analogRead(32);
  int A2c = analogRead(33);

  float A1s2=0;
  float A2c2=0;

  A1s2 = A1s;
  A2c2 = A2c;
  //##########　616404（SAS）の出力を得る　##########


  //##########　角度演算する　##########
  A1s+=A1s_offset;//offset
  A2c+=A2c_offset;//offset
  
  A1s -= 2029;
  A2c -= 2029;
  
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
    if(A_flag==0 && (Angle-pre_Angle)<-80){
      A_flag=1;
    }else if(A_flag==0 && (Angle-pre_Angle)>80){
      A_flag=2;
    }else if(A_flag==1 && (Angle-pre_Angle)>80){
      A_flag=0;
    }else if(A_flag==1 && (Angle-pre_Angle)<-80){
      A_flag=0;
    }else if(A_flag==2 && (Angle-pre_Angle)<-80){
      A_flag=0;
    }else if(A_flag==2 && (Angle-pre_Angle)>80){
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
  //if(Angle2<-5) Angle2 += 180;
  //##########　角度がマイナスの場合、プラスに変更する　##########

  pre_Angle=Angle;
  

  Serial.print(A1s2);
  Serial.print(',');
  Serial.print(A2c2);
  Serial.print(',');
  Serial.print(Angle);
  Serial.print(',');
  Serial.println(Angle2);
  
  cyc=10;
}
