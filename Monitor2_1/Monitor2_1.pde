import processing.serial.*;
import java.io.FileWriter;
import controlP5.*;
import processing.awt.PSurfaceAWT; //ライブラリの宣言


Serial port;
PrintWriter output;///File操作宣言


//########## 計測設定 ##########
String COM="COM29";
long endcyc=600000;//終了する時間（秒）
int delaytime=1;//delayタイム（ms）
int Max_val = 5000;//最大値設定
int Min_val = 0;//最小値設定
String savefile = "data/save.csv";
int Plot_num=350;//グラフのプロット数
//########## 計測設定 ##########



int[] graph_color = new int[21];
//int graph_color[] = {#FF0000,#FF8000,#FFFF00,#80FF00,#00FF00,#00FFFF,#00FF80,#0000FF,#7F00FF,#FF00FF};//こっちでもいい

int[] data_table1 = new int[Plot_num];//生データグラフ用
int[] data_table2 = new int[Plot_num];//加工データグラフ用


int screen_w = 700;  //グラフの表示サイズ　横
int screen_h = 400;  //グラフの表示サイズ　縦
int sc_offx=150;        //グラフの画面上のオフセット
int sc_offy=80;        //グラフの画面上のオフセット

PFont myFont;
PFont myFont2;
PFont myFont3;
PFont myFont4;
PFont myFont5;

PImage tokairika;
PImage yaris;
int yaris_pos=0;


void setup() {
  
  frameRate(100);
  
  yaris = loadImage("yarisu.png");
  tokairika=loadImage("tokaiRika.jpg"); //<>//
  
  int i=0;
  
  //外枠
  //size(displayWidth, displayHeight,JAVA2D);//ソフトの表示サイズ　　　リテラルのみ
  size(960,600,JAVA2D);//ソフトの表示サイズ　　　リテラルのみ
  //fullScreen();
  
 
  //########## Graphカラーの設定 ##########
  graph_color[0]=#FF0000;//red
  graph_color[1]=#FF8000;//orange
  graph_color[2]=#FFFF00;//yellow
  graph_color[3]=#80FF00;//light green
  graph_color[4]=#00FF00;//green
  graph_color[5]=#00FFFF;//light blue
  graph_color[6]=#00008B;//dark blue
  graph_color[7]=#0000FF;//blue
  graph_color[8]=#7F00FF;//purple
  graph_color[9]=#FF00FF;//pink
  graph_color[10]=#000080;//navy
  graph_color[11]=#008080;//teal
  graph_color[12]=#00FF00;//lime
  graph_color[13]=#00FFFF;//aqua
  graph_color[14]=#FF00FF;//fuchsia
  graph_color[15]=#808000;//olive
  graph_color[16]=#800000;//maroon
  graph_color[17]=#808080;//gray
  graph_color[18]=#C0C0C0;//silver
  graph_color[19]=#FFFFFF;//while
  graph_color[20]=#000000;//black 
  //########## Graphカラーの設定 ##########
  
  
  //########## フォント設定 ##########
  myFont = createFont("Dialog.bold", 40);
  myFont2 = createFont("Dialog.bold", 20);
  myFont3 = createFont("Dialog.bold", 12);
  myFont4 = createFont("Dialog.bold", 30);
  myFont5 = createFont("Dialog.bold", 16);
  //########## フォント設定 ##########
  
  
  port = new Serial(this, COM, 115200);//シリアル通信設定
  background(200, 255, 255);//light blue　　背景色
  
  
  //########### グラフプロットデータの初期化 ###########
  for(i=0;i<Plot_num;i++){
    data_table1[i] = 0;
  }
  //########### グラフプロットデータの初期化 ###########
  
  //########## シリアルポートのクリア　##########
  while(port.available()>0){
    int R=port.read();
  }
  //########## シリアルポートのクリア　##########
  
  textSize(20);
  fill(0);//black
  textAlign(CENTER);
  delay(2500);          //Arduinoが立ち上がるまで待つ（これがないと通信に失敗する）
  
}









void draw() {
  
  
    
  int i=0;

  background(150, 255, 255);//light blue　　背景色
  //background(#00FF80);
  image(tokairika,765,0);
  
  
  //########### グラフプロット枠 ###########
  fill(255,255,255);//white
  //fill(255,255,230);//white
  strokeWeight(3);//線の太さ
  stroke(0, 0, 0);//線の色　white
  rect(sc_offx,sc_offy,screen_w,screen_h);//グラフ枠を作成
  
  stroke(160,160,160);//線色　gray
  strokeWeight(1);//線太さ
  
  //横の目盛り線
  for(i=1;i<=9;i++){
    line(sc_offx,screen_h/10*i+sc_offy,screen_w+sc_offx,screen_h/10*i+sc_offy);
  }
  
  //縦の目盛り線
  for(i=1;i<=9;i++){
    line(screen_w/10*i+sc_offx,0+sc_offy,screen_w/10*i+sc_offx,screen_h+sc_offy);
  }
  
  //横の目盛り
  textSize(20);
  fill(0);//black
  textAlign(CENTER);
  for(i=1;i<=10;i++){
    text(20*i,screen_w/10*i+sc_offx,screen_h+sc_offy+20);
  }
  
  //縦の目盛り
  textSize(20);
  fill(0);//black
  textAlign(RIGHT); 
  for(i=0;i<=10;i++){
    text(Max_val/10*i,sc_offx-10,screen_h/10*(10-i)+sc_offy+5);
  }

  
  //##########　タイトルの表示　##########
  fill(#ff0000);//red
  textAlign(LEFT);
  textSize(30);
  text("MR Sensor DEMO", 50, 35);
  //##########　タイトルの表示　##########
  
  //##########　X軸のタイトル表示　##########
  fill(0);//black
  textAlign(CENTER);
  textSize(20);
  text("Time(ms)", screen_w/10*5+sc_offx,screen_h+sc_offy+50);
  //##########　X軸のタイトル表示　##########
  
  
  
  //##########　Y軸のタイトル表示　##########
  translate(60,250);//相対移動
  float rad=radians(-90);
  rotate(rad);
  fill(0);
  textAlign(CENTER);
  textFont(myFont2);
  text("Output V (mV) ",0,0);
  rad=radians(90);
  rotate(rad);
  translate(-60,-250);//相対移動
  //##########　Y軸のタイトル表示　##########
  
  
  
  
  
  
  port.write(1);
  
  delay(100);
  
  //##########マイコンから計測完了を受け取る ##########
  if(port.available()==Plot_num*4){
    for(i=0;i<Plot_num;i++){ //<>//
      int highread = port.read();//データを取り込む
      int lowread = port.read();//データを取り込む
      data_table1[i]=highread<<8;
      data_table1[i]|=lowread;
    }
    
    for(i=0;i<Plot_num;i++){
      int highread = port.read();//データを取り込む
      int lowread = port.read();//データを取り込む
      data_table2[i]=highread<<8;
      data_table2[i]|=lowread;
    }
  }
  //##########マイコンから計測完了を受け取る ##########
 
  int MR1=0;
  int pre_MR1=0;
  int MR2=0;
  int pre_MR2=0;
  byte Tkazu=0;
  byte Tkazu1=0;
  byte Tkazu2=0;
  float rpm=0;
  int rpm2=0;
  long time2=200000;
  
  
  for(i=0;i<Plot_num-1;i++){
    print(i);
    print(",");
    print(data_table1[i]);
    print(",");
    println(data_table2[i]);
    
    MR1=data_table1[i+1];
    pre_MR1=data_table1[i];
    MR2=data_table2[i+1];
    pre_MR2=data_table2[i];
    
    if(MR1>=512 && pre_MR1<512){
       Tkazu1++;
    }
    
    if(MR1<=512 && pre_MR1>512){
       Tkazu1++;
    }
        
    if(MR2>=512 && pre_MR2<512){
       Tkazu2++;
    }
    
    if(MR2<=512 && pre_MR2>512){
       Tkazu2++;
    }
  }
  
  if(Tkazu1==0 || Tkazu2==0){
    rpm2=0;
  }else{
    Tkazu=Tkazu1;
    Tkazu+=Tkazu2;
    rpm=Tkazu;
    rpm/=10;
    rpm/=time2;
    rpm*=1000000;
    rpm*=60;
    rpm2=int(rpm);
  }
  
  print(Tkazu);
  print(",");
  println(rpm);
  
  //##########　回転数の表示　##########
  fill(#0000ff);//red
  textAlign(LEFT);
  textSize(60);
  
  text(rpm2, 430, 50);
  text("rpm", 610, 50);
  //##########　回転数の表示　##########
  
  //rpm2=400;
  if(rpm2<100){
    yaris_pos=0;
  }else if(rpm2<600){
    yaris_pos+=5;
  }else if(rpm2<1100){
    yaris_pos+=25;
  }else if(rpm2<1500){
    yaris_pos+=50;
  }else{
    yaris_pos+=50;
  }
  
  if(yaris_pos>800){
    yaris_pos=0;
  }
  image(yaris, yaris_pos, 540);
  
  

  float x1=0;
  float x2=0;
  float y1=0;
  float y2=0;
  
  //########### 生データのグラフ表示 ##########
  x1=0;
  x2=0;
  y1=0;
  y2=0;
  
  stroke(graph_color[7]);
  strokeWeight(1);
  
  for(i=0;i<(Plot_num-1);i++){
    x2 = int(x1 + screen_w / Plot_num);
    y1 = data_table1[i];
    y1 = y1 - Min_val;
    y1 = y1 * screen_h;
    y1 = y1 / (Max_val - Min_val);
    y1 = y1 * Max_val / 1023;
    y1 = screen_h - y1;
    y1=int(y1);
    
    if(y1>(screen_h)) y1= screen_h;
    if(y1<0) y1=0;
    
    y2 = data_table1[i + 1];
    y2 = y2 - Min_val;
    y2 = y2 * screen_h;
    y2 = y2 / (Max_val - Min_val);
    y2 = y2 * Max_val / 1023;
    y2 = screen_h - y2;
    y2 = int(y2);
    
    if(y2>(screen_h)) y2= screen_h;
    if(y2<0) y2=0;
    
    line(x1+sc_offx,y1+sc_offy,x2+sc_offx,y2+sc_offy);
    x1 = x1 + int(screen_w / Plot_num);
  }
  
  
  
  
  
  x1=0;
  x2=0;
  y1=0;
  y2=0;
  
  stroke(graph_color[0]);
  strokeWeight(1);
  
  for(i=0;i<(Plot_num-1);i++){
    x2 = x1 + screen_w / Plot_num;
    y1 = data_table2[i];
    y1 = y1 - Min_val;
    y1 = y1 * screen_h;
    y1 = y1 / (Max_val - Min_val);
    y1 = y1 * Max_val / 1023;
    y1 = screen_h - y1;
    
    if(y1>(screen_h)) y1= screen_h;
    if(y1<0) y1=0;
    
    y2 = data_table2[i + 1];
    y2 = y2 - Min_val;
    y2 = y2 * screen_h;
    y2 = y2 / (Max_val - Min_val);
    y2 = y2 * Max_val / 1023;
    y2 = screen_h - y2;
    
    if(y2>(screen_h)) y2= screen_h;
    if(y2<0) y2=0;
    
    line(x1+sc_offx,y1+sc_offy,x2+sc_offx,y2+sc_offy);
    x1 = x1 + screen_w / Plot_num;
  }
  
  //########### 生データのグラフ表示 ##########
  

  delay(delaytime);//休む
}






boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) { 
      return true;
  } else {
    return false;
  }
}
