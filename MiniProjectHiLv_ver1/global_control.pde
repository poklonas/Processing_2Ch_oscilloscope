// re to base value
void resetChart(){
   if(mode_ch ==1){ // set off ch2
    buffer_ch1 = 100;
    set_x_scale_ch1();
   }else if(mode_ch ==2){ // set off ch 1
    buffer_ch2 = 100;
    set_x_scale_ch2();
   }else if(mode_ch ==3){ // set on all
    buffer_ch1 = 100;
    buffer_ch2 = 100;
    set_x_scale_ch1();
    set_x_scale_ch2();
   }
}

//set number colum
void global_x(){
  if(max_colum < 44){
    max_colum *= 2;  
  }else{
    max_colum = 11; 
  }
  multiple_of_colum = 1100/max_colum;
  gx.setText(max_colum+" Box");
  set_x_scale_ch1();
  set_x_scale_ch2();
}

// set number row
void global_y(){
  if(max_row == 10){
    max_row = 14;  
  }else if(max_row == 14){
    max_row = 6; 
  }else{
    max_row = 10; 
  }
  multiple_of_row = 450/max_row;
  gy.setText(max_row+" Box");
}

// stop update or re update
void stop_toggle(){
 if(stop_update){
  stop_update = false; 
  resetChart();
 }else{
  stop_update = true; 
 }
}

// call reconnect function
void reconnect(){
  check_serial_again();
}