// update x scale 
void CH2_X_Scale(){
  if(scale_x_ch2 == 0.01){ 
   scale_x_ch2 = 0.025;
  }else if(scale_x_ch2 == 0.025){
   scale_x_ch2 = 0.05;
  }else if(scale_x_ch2 == 0.05){
   scale_x_ch2 = 0.1;
  }else if(scale_x_ch2 == 0.1){
   scale_x_ch2 = 0.2;
  }else if(scale_x_ch2 == 0.2){ 
   scale_x_ch2 = 0.00025;
  }else if(scale_x_ch2 == 0.00025){
   scale_x_ch2 = 0.0005;
  }else if(scale_x_ch2 == 0.0005){
   scale_x_ch2 = 0.001;
  }else if(scale_x_ch2 == 0.001){
   scale_x_ch2 = 0.01;
  }
  set_x_scale_ch2();
}

// set new buffer size when change x scale
void set_x_scale_ch2(){
  buffer_ch2 = int((scale_x_ch2 / send_time)) * max_colum;
  myChart2.setData("ch2", new float[buffer_ch2]);
  x2.setText(scale_x_ch2+" sec");
}

// update y scale
void CH2_Y_Scale(){
  if(scale_y_ch2 == 0.5){
   scale_y_ch2 = 1;
  }else if(scale_y_ch2 ==1){
   scale_y_ch2 = 2;
  }else if(scale_y_ch2 ==2){ 
   scale_y_ch2 = 3;
  }else if(scale_y_ch2 ==3){
   scale_y_ch2 = 0.5;
  }
   y2.setText(scale_y_ch2+" Volt");
}

// update mode and read status
void ch2_toggle(){
  if(mode_ch == 0){ // on ch2
   mode_ch = 2; 
   buffer_ch2 = int((scale_x_ch2 / send_time)) * max_colum;
  }else if(mode_ch ==1){ // on ch2
   buffer_ch2 = int((scale_x_ch2 /send_time)) * max_colum;
   mode_ch = 3; 
  }else if(mode_ch == 2){ // off ch2
   mode_ch = 0; 
   buffer_ch2 = 1;
  }else if(mode_ch == 3){ // off ch2
   mode_ch = 1; 
   buffer_ch2 = 1;
  }
   myChart2.setData("ch2", new float[buffer_ch2]);
   send_command_set_mode();
}

// update colour
void ch2_color(){
  int red_ch2 = cp5.get(ColorWheel.class,"ch2_color").r();
  int green_ch2 = cp5.get(ColorWheel.class,"ch2_color").g(); 
  int blue_ch2 = cp5.get(ColorWheel.class,"ch2_color").b();
  myChart2.setColors("ch2", color(red_ch2,green_ch2,blue_ch2));
}