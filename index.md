<!doctype html>
<!--
Copyright 2017-2020 JellyWare Inc. All Rights Reserved.
-->
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="description" content="BlueJelly">
    <meta name="viewport" content="width=640, maximum-scale=1.0, user-scalable=yes">
    <title>BlueJelly-ESP32  超音波センサDEMO</title>
    <link href="https://fonts.googleapis.com/css?family=Lato:100,300,400,700,900" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="style.css">
   
    <style type="text/css">
    	/*
		#startNotifications{
			position:absolute;
			left:100;
		}
		#stopNotifications{
			position:absolute;
			left:500;
		}*/
    </style>
    
    <script type="text/javascript" src="bluejelly.js"></script>
    <script type="text/javascript" src="./smoothie.js"></script>
  </head>

<body>
<div class="container">
    <div class="title margin">
        <font color="orange"><font size="5">超音波センサDEMO</font></font>       
        <button id="startNotifications" class="button">Start Notify</button>
		<button id="stopNotifications" class="button">Stop Notify</button>
    </div>
    
	<span id="data_text">HOHO</span>
	
    <div class="contents margin">
        

        <hr>
        <div id="svg">GRAPH AREA</div>
        <hr>
        
        <span>　　</span>
        <span id="data_text2"> </span>
        <!--<div id="device_name"> </div>
        <div id="uuid_name"> </div>
        
        <div id="status"> </div>-->

    </div>
    <!--<div class="footer margin">
                For more information, see <a href="https://jellyware.jp/kurage" target="_blank">jellyware.jp</a> and <a href="https://github.com/electricbaka/bluejelly" target="_blank">GitHub</a> !
    </div>-->
</div>


<script>
//--------------------------------------------------
//Global変数
//--------------------------------------------------
//BlueJellyのインスタンス生成
const ble = new BlueJelly();

//TimeSeriesのインスタンス生成
const ble_data = new TimeSeries();


//-------------------------------------------------
//smoothie.js
//-------------------------------------------------
function createTimeline() {
    const chart = new SmoothieChart({
        millisPerPixel: 20,
        grid: {
            fillStyle: '#ff8319',
            strokeStyle: '#ffffff',
            millisPerLine: 800
        },
        maxValue: 5000,
        minValue: 0
    });
    chart.addTimeSeries(ble_data, {
        strokeStyle: 'rgba(255, 255, 255, 1)',
        fillStyle: 'rgba(255, 255, 255, 0.2)',
        lineWidth: 4
    });
    chart.streamTo(document.getElementById("chart"), 500);
}


//--------------------------------------------------
//ロード時の処理
//--------------------------------------------------
window.onload = function () {
  //UUIDの設定
  ble.setUUID("UUID1","4fafc201-1fb5-459e-8fcc-c5c9c331914b","beb5483e-36e1-4688-b7f5-ea07361b26a8");

  //smoothie.js
  //createTimeline();
}


//--------------------------------------------------
//Scan後の処理
//--------------------------------------------------
ble.onScan = function (deviceName) {
  //document.getElementById('device_name').innerHTML = deviceName;
  document.getElementById('status').innerHTML = "found device!";
}


//--------------------------------------------------
//ConnectGATT後の処理
//--------------------------------------------------
ble.onConnectGATT = function (uuid) {
  console.log('> connected GATT!');

  //document.getElementById('uuid_name').innerHTML = uuid;
  //document.getElementById('status').innerHTML = "connected GATT!";
}


//--------------------------------------------------
//Read後の処理：得られたデータの表示など行う
//--------------------------------------------------
ble.onRead = function (data, uuid){
  //フォーマットに従って値を取得
  let value = "";
  for(let i = 0; i < data.byteLength; i++){
    value = value + String.fromCharCode(data.getInt8(i));
  }

  //数値化
  value = Number(value);

  //コンソールに値を表示
  console.log(value);
  
  let value2=Math.round(value*0.5);
  str_value="";
  let str_value2="";
  
  if(String(value).length==1) str_value= "00"+value;
  if(String(value).length==2) str_value= "0"+value;
  if(String(value).length==3) str_value= value;

  if(String(value2).length==1) str_value2= "000"+value2;
  if(String(value2).length==2) str_value2= "00"+value2;
  if(String(value2).length==3) str_value2= "0"+value2;
  if(String(value2).length==4) str_value2= value2;
  
  //HTMLにデータを表示
  str_value+="cm";
  document.getElementById('data_text').innerHTML = str_value;
  //document.getElementById('data_text2').innerHTML = str_value2;
  //document.getElementById('uuid_name').innerHTML = uuid;
  //document.getElementById('status').innerHTML = "read data"

  //グラフへ反映
  //ble_data.append(new Date().getTime(), value);
  Create_grapf(value,value2);
}


//--------------------------------------------------
//Start Notify後の処理
//--------------------------------------------------
ble.onStartNotify = function(uuid){
  console.log('> Start Notify!');

  //document.getElementById('uuid_name').innerHTML = uuid;
  //document.getElementById('status').innerHTML = "started Notify";
}


//--------------------------------------------------
//Stop Notify後の処理
//--------------------------------------------------
ble.onStopNotify = function(uuid){
  console.log('> Stop Notify!');

  //document.getElementById('uuid_name').innerHTML = uuid;
  //document.getElementById('status').innerHTML = "stopped Notify";
}


//-------------------------------------------------
//ボタンが押された時のイベント登録
//--------------------------------------------------
document.getElementById('startNotifications').addEventListener('click', function() {
      ble.startNotify('UUID1');
});

document.getElementById('stopNotifications').addEventListener('click', function() {
      ble.stopNotify('UUID1');
});


let str_value="";

var array1 = new Array(100);
for(let i=0;i<100;i++){
		array1[i] = new Array(2);
}



function Create_grapf(getdata,getdata1) {
	let screen_w = 600;
	let screen_h = 500;
	let Max_val = 100;
	let Min_val = 0;
	let i=0;
	let ii=0;
	var plot_color = new Array('red', 'blue', 'yellow' ,'green');
	
	
	
	
	for(ii=0;ii<2;ii++){
		for(i=0;i<=98;i++){
			array1[i][ii]=array1[(i+1)][ii];
		}
	}
	array1[99][0]=getdata;
	array1[99][1]=getdata1;
	
	
	
	let display_text="<svg xmlns='http://www.w3.org/2000/svg' version='1.1' height='" + screen_h + "' width='" + screen_w + "' viewBox='-50 -50 750 600' class='SvgFrame'>";
	display_text = display_text + "<line x1='0' y1='0' x2='" + screen_w + "' y2='0' style='stroke:black;stroke-width:1' />";
	display_text = display_text + "<line x1='0' y1='" + screen_h + "' x2='" + screen_w + "' y2='" + screen_h + "' style='stroke:black;stroke-width:1' />";
	display_text = display_text + "<line x1='0' y1='0' x2='0' y2='" + screen_h + "' style='stroke:black;stroke-width:1' />";
	display_text = display_text + "<line x1='" + screen_w + "' y1='0' x2='" + screen_w + "' y2='" + screen_h + "' style='stroke:black;stroke-width:1' />";
	
	
	
	
	display_text = display_text + "<text x='510' y='30' font-size='30' stroke='black' text-anchor='start' stroke-width='2'>"+str_value+"</text>"
	
	
	
	

	for(i=1;i<=4;i++){
		display_text = display_text + "<line x1='" + screen_w/5*i + "' y1='0' x2='" + (screen_w/5*i) + "' y2='" + screen_h + "' style='stroke:gray;stroke-width:1' />";
		display_text = display_text + "<line x1='0' y1='" + screen_h/5*i + "' x2='" +  screen_w + "' y2='" + screen_h/5*i + "' style='stroke:gray;stroke-width:1' />";
	}

	for(i=0;i<=5;i++){
        display_text = display_text + "<text x='-5' y='"+ (screen_h/5*i+10) +"' font-size='20' stroke='black' text-anchor='end' stroke-width='1'>"+(Max_val-Max_val/5*i)+"</text>"
    }
    
	
	
	for(ii=0;ii<2;ii++){
	    let x1 = 0;
	    
	    for(let i = 0;i<=98;i++){
	    	let x2=0;
	        x2 = x1 + screen_w / 100;
	        y1 = array1[i][ii]
	        y1 -= Min_val;
	        y1 *= screen_h;
	        y1 /= (Max_val - Min_val);
	        y1 = screen_h - y1;
	        
	        y2 =  array1[(i+1)][ii];
	        y2 -= Min_val;
	        y2 *= screen_h;
	        y2 /= (Max_val - Min_val);
	        y2 = screen_h - y2;
	        display_text = display_text + "<line x1='" + x1 + "' y1='" + y1 + "' x2='" + x2 + "' y2='" + y2 + "' style='stroke:"+ plot_color[ii] +";stroke-width:2' />";
	        
	        x1 += screen_w / 100
	        
	    }
    }

    
    display_text += "</svg>"
    document.getElementById("svg").innerHTML =  display_text;


}

</script>
</body>
</html>

