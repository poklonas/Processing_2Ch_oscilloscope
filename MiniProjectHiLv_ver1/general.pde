void serial_check(){
 if (myPort != null ){
    status_port.setText("PORT  STATUS : ON");
    // for check serial port is available it look like when port come name = 80 then if port left port = 81
    // 80 != 81 it will not reset value thus it will let pc know port is not available
    try {
      if(!(name == Serial.list()[0])){
        time_out = 0;
      }
     }catch (Exception e) {
       print(" port miss "); 
     }
     //
    if(stop_update == false){ // update chart allow ?
     if(myPort.available() > get_delay()){ // delay for store update value
      while(myPort.available() > 5){ // 5 because in worth case read command want 5 package for update
      int in_mode = myPort.read(); 
        if((in_mode) != (mode_ch+128)){ // mode input match with pc mode or not 
           send_command_set_mode(); 
           confirm_connect = 0;
           myPort.clear(); // reset input form port
        }else{ 
         // true value is value1+value2 in string mode like value 1 = 20 value 2 = 23
         // true value is ''20''+''23'' = ''2023'' mV then before send to calculate divide by 1000
         // for set in volt , 2.023 volt
         int value_first;
         int value_second;
         int value_first2;
         int value_second2;
         switch(in_mode){
          case 128: // mode 0
            break; 
            
          case 129: // mode 1
            value_first = myPort.read();
            value_second = myPort.read();
            myChart.push("ch1", calculate_output_with_scale(float((value_first*100)+(value_second))/1000, scale_y_ch1));
            break;
            
          case 130: // mode 2
            value_first = myPort.read();
            value_second = myPort.read();
            myChart2.push("ch2", calculate_output_with_scale(float((value_first*100)+(value_second))/1000, scale_y_ch2));
            break;
            
          case 131: // mode 3
            value_first = myPort.read();
            value_second = myPort.read();
            value_first2 = myPort.read();
            value_second2 = myPort.read();
            myChart.push("ch1", calculate_output_with_scale(float((value_first*100)+(value_second))/1000, scale_y_ch1));
            myChart2.push("ch2", calculate_output_with_scale(float((value_first2*100)+(value_second2))/1000, scale_y_ch2));
            break;
         }
        }
       }
      }
     }
     // ping board for let board know we are here 
      confirm_connect++;
      if(confirm_connect == 10){
          confirm_connect = 0; 
          send_command_set_mode();
      }
  }else{
     status_port.setText("PORT  STATUS : OFF");
  }
  
  // if time out that mean usb is not available it will reset port
  if(time_out >= 100){
   myPort = null;
   status_port.setText("PORT  STATUS : OFF");
   time_out = 0;
  }
  time_out++;
  
}

// calculate output for map in chart
float calculate_output_with_scale(float input, float scale){
  float output = 2/float(max_row);
  output *= (range_y_max*input)/scale;
  return output;
}

// set mode to board
void send_command_set_mode(){
  myPort.write('#');
  myPort.write(str(mode_ch));
}

// try to reconnect if port available
void check_serial_again(){
 if(Serial.list() != null){
   name = Serial.list()[0];
   myPort = new Serial(this, Serial.list()[0], 460800); 
   delay(50);
 }
}

// for delay update by highest scale(mean lowest buffer)
float get_delay(){
  float higest_time;
  if( scale_x_ch1 < scale_x_ch2){
    higest_time = scale_x_ch1;
  }else{
    higest_time = scale_x_ch2;
  }
  if(higest_time >= 0.1){
    return (0);
  }
  if(mode_ch == 3){
    return (1000); 
  }
  return (600); // size_of_data * 3 * 0.1
}