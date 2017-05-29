import controlP5.*;
import processing.serial.*;

// main control p5
ControlP5 cp5;

// object of p5
Chart myChart, myChart2;
Textlabel status_port, x1, x2, y1, y2, gx, gy;
Toggle ch1_toggle, ch2_toggle, stop_toggle;
Button x_ch1, y_ch1, x_ch2, y_ch2, global_x, global_y, reconnect;
ColorWheel ch1_color, ch2_color;

// serial
Serial myPort;
String name; // store port name (last connect) for check port is available

// other var
int confirm_connect = 0; // for ping board
boolean stop_update = false; // for control update chart and read serial
int status_reset = 0; 
int x_app = 0;  // base value for draw gui
int y_app = 0; // base value for draw gui
int mode_ch = 0; //0 1 2 3
int max_row = 10; // number of row
int max_colum = 22; // number of colum
int multiple_of_row = 45; // distance between block in y axis
int multiple_of_colum = 50; // distance between block in x axis
int range_y_max = 6; // set max value for scale axis y 
int buffer_ch1 = 1100;  // number of buffer ch1
int buffer_ch2 = 1100; // number of buffer ch2
float scale_y_ch1 = 1; // voltage per block
float scale_y_ch2 = 1; // voltage per block
float scale_x_ch1 = 0.1; // time per block
float scale_x_ch2 = 0.1; // time per block
float send_time = 0.00016; // time of data  0.00016 for 6000 package 0.005 for 200 package
int time_out = 0; // for check port still available

// main colour 1 2 3 4 5 darker
color shade1 = color(255, 230, 250);
color background_moniter = color(255,10);
color shade2 = color(196, 215, 237);
color shade3 = color(171, 200, 226);
color shade4 = color(55, 93, 129);
color shade5 = color(24, 49, 82);

void setup() {
  size(1250, 850);
  
  cp5 = new ControlP5(this);
  ControlFont Arial = new ControlFont(createFont("Arial",15));
  cp5.setFont(Arial);
  
  // chart ch1
  myChart = cp5.addChart("myChart")
               .setPosition(x_app+80, y_app+80)
               .setSize(1100, 450)
               .setRange(-range_y_max, range_y_max)
               .setView(Chart.LINE)
               .setColorCaptionLabel(shade5)
               .setColorBackground(background_moniter)
               .addDataSet("ch1")
               .setData("ch1", new float[buffer_ch1])
               .setColors("ch1", color(0, 255 ,255))
               ;
  //chart ch2
  myChart2 = cp5.addChart("myChart2")
               .setPosition(x_app+80, y_app+80)
               .setSize(1100, 450)
               .setRange(-range_y_max, range_y_max)
               .setView(Chart.LINE)
               .setColorCaptionLabel(shade5)
               .setColorBackground(background_moniter)
               .addDataSet("ch2")
               .setData("ch2", new float[buffer_ch2])
               .setColors("ch2", color(255, 0 ,0))
               ;
  
  myChart.setStrokeWeight(2); // size of point in chart ch1
  myChart2.setStrokeWeight(2); // size of point in chart ch2
  
  // draw status port on or off
  status_port = cp5.addTextlabel("port")
                    .setText("PORT  STATUS : OFF")
                    .setPosition(x_app+1000, y_app+50)
                    .setColorValue(0xffffff00)
                    .setFont(createFont("Arial",20))
                    ;
                    
  // show scale x for ch1
  x1 = cp5.addTextlabel("x1")
                    .setText(scale_x_ch1+" Sec")
                    .setPosition(x_app+185, y_app+660)
                    .setColorValue(0xffffff00)
                    .setFont(createFont("Arial",20))
                    ;
                    
  // show scale x for ch2                    
  x2 = cp5.addTextlabel("x2")
                    .setText(scale_x_ch2+" Sec")
                    .setPosition(x_app+865, y_app+660)
                    .setColorValue(0xffffff00)
                    .setFont(createFont("Arial",20))
                    ;
                    
  // show scale y for ch1                 
  y1 = cp5.addTextlabel("y1")
                    .setText(scale_y_ch1+" Volt")
                    .setPosition(x_app+185, y_app+730)
                    .setColorValue(0xffffff00)
                    .setFont(createFont("Arial",20))
                    ;
                    
  // show scale y for ch2
  y2 = cp5.addTextlabel("y2")
                    .setText(scale_y_ch2+" Volt")
                    .setPosition(x_app+865, y_app+730)
                    .setColorValue(0xffffff00)
                    .setFont(createFont("Arial",20))
                    ;
                    
  // show number of colums
  gx = cp5.addTextlabel("gx")
                    .setText("22 Box")
                    .setPosition(x_app+600, y_app+630)
                    .setColorValue(0xffffff00)
                    .setFont(createFont("Arial",20))
                    ;
                    
  // show number of rows
  gy = cp5.addTextlabel("gy")
                    .setText("10 Box")
                    .setPosition(x_app+600, y_app+740)
                    .setColorValue(0xffffff00)
                    .setFont(createFont("Arial",20))
                    ;

  // toggle for on / off ch1
  ch1_toggle =   cp5.addToggle("ch1_toggle")
                    .setPosition(x_app+70, y_app+570)
                    .setSize(100,40)
                    .setValue(false)
                    .setMode(ControlP5.SWITCH)
     ;
     
  // toggle for on / off ch2
  ch2_toggle =   cp5.addToggle("ch2_toggle")
                    .setPosition(x_app+750, y_app+570)
                    .setSize(100,40)
                    .setValue(false)
                    .setMode(ControlP5.SWITCH)
     ;
     
  // toggle for on / off update chart
  stop_toggle =   cp5.addToggle("stop_toggle")
                    .setBroadcast(false)
                    .setPosition(x_app+100, y_app+10)
                    .setSize(100,40)
                    .setValue(true)
                    .setMode(ControlP5.SWITCH)
                    .setBroadcast(true)
     ;
     
  // button for change number of colum
  global_x = cp5.addButton("global_x")
     .setBroadcast(false)
     .setPosition(x_app+580, y_app+570)
     .setSize(100,50)
     .setValue(0)
     .setBroadcast(true)
     ;
     
  // button for change number of row
  global_y = cp5.addButton("global_y")
     .setBroadcast(false)
     .setPosition(x_app+580, y_app+680)
     .setSize(100,50)
     .setValue(0)
     .setBroadcast(true)
     ;
     
  // button for change x scale ch1
  x_ch1 = cp5.addButton("CH1_X_Scale")
     .setBroadcast(false)
     .setPosition(x_app+70, y_app+650)
     .setSize(100,50)
     .setValue(0)
     .setBroadcast(true)
     ;
     
  // button for change x scale ch2
  x_ch2 = cp5.addButton("CH2_X_Scale")
     .setBroadcast(false)
     .setPosition(x_app+750, y_app+650)
     .setSize(100,50)
     .setValue(0)
     .setBroadcast(true)
     ;
     
  // button for change y scale ch1
  y_ch1 = cp5.addButton("CH1_Y_Scale")
     .setBroadcast(false)
     .setPosition(x_app+70, y_app+720)
     .setSize(100,50)
     .setValue(0)
     .setBroadcast(true)
     ;
     
  // button for change y scale ch2
  y_ch2 = cp5.addButton("CH2_Y_Scale")
     .setBroadcast(false)
     .setPosition(x_app+750, y_app+720)
     .setSize(100,50)
     .setValue(0)
     .setBroadcast(true)
     ; 
     
  // button for reconnect
  reconnect = cp5.addButton("reconnect")
     .setBroadcast(false)
     .setPosition(x_app+300, y_app+10)
     .setSize(100,50)
     .setValue(0)
     .setBroadcast(true)
     ; 
     
 // for set colour chart of ch1 , ch2
 ch1_color = cp5.addColorWheel("ch1_color" , x_app+300 , y_app+560 , 200 ).setRGB(color(255,0,0));
 ch2_color = cp5.addColorWheel("ch2_color" , x_app+980 , y_app+560 , 200 ).setRGB(color(0,255,0));
 
}

void draw() {
  background(shade5);
  drawBox();
  serial_check();
  drawGrid();
}