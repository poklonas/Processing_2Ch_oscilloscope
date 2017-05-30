// update x scale 
void CH1_X_Scale(){
  if(scale_x_ch1 == 0.01){ 
   scale_x_ch1 = 0.025;
  }else if(scale_x_ch1 == 0.025){
   scale_x_ch1 = 0.05;
  }else if(scale_x_ch1 == 0.05){
   scale_x_ch1 = 0.1;
  }else if(scale_x_ch1 == 0.1){
   scale_x_ch1 = 0.2;
  }else if(scale_x_ch1 == 0.2){ 
   scale_x_ch1 = 0.00025;
  }else if(scale_x_ch1 == 0.00025){
   scale_x_ch1 = 0.0005;
  }else if(scale_x_ch1 == 0.0005){
   scale_x_ch1 = 0.001;
  }else if(scale_x_ch1 == 0.001){
   scale_x_ch1 = 0.01;
  }
  set_x_scale_ch1();
}

// set new buffer size when change x scale
void set_x_scale_ch1(){
  buffer_ch1 = int((scale_x_ch1 / send_time)) * max_colum;
  x1.setText((scale_x_ch1*1000)+" ms");
  if((mode_ch == 1) || (mode_ch == 3)){
    myChart.setData("ch1", new float[buffer_ch1]);
  }
}


// update y scale
void CH1_Y_Scale(){
  if(scale_y_ch1 == 0.5){
   scale_y_ch1 = 1;
  }else if(scale_y_ch1 ==1){
   scale_y_ch1 = 2;
  }else if(scale_y_ch1 ==2){
   scale_y_ch1 = 3;
  }else if(scale_y_ch1 ==3){
   scale_y_ch1 = 0.5;
  }
   y1.setText(scale_y_ch1+" Volt");
}

// update mode and read status
void ch1_toggle(){
  if(mode_ch == 0){ // set on ch1
   mode_ch = 1;
   buffer_ch1 = int((scale_x_ch1 / send_time)) * max_colum;
  }else if(mode_ch ==1){ // set off ch1
   mode_ch = 0; 
   buffer_ch1 = 1;
  }else if(mode_ch ==2){ // set on ch1
   mode_ch = 3; 
   buffer_ch1 = int((scale_x_ch1 / send_time)) * max_colum;
  }else if(mode_ch ==3){ // set off ch1
   mode_ch = 2;
   buffer_ch1 = 1;
  }
   myChart.setData("ch1", new float[buffer_ch1]);
   send_command_set_mode();
}

// update colour
void ch1_color(){
  int red_ch1 = cp5.get(ColorWheel.class,"ch1_color").r();
  int green_ch1 = cp5.get(ColorWheel.class,"ch1_color").g(); 
  int blue_ch1 = cp5.get(ColorWheel.class,"ch1_color").b(); 
  myChart.setColors("ch1", color(red_ch1,green_ch1,blue_ch1));
}