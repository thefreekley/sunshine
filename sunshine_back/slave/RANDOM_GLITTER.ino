 void colorTape(int count){
  byte num_tapes=0;
  byte count_tape = 10;
  static int last_count = 0;
  static unsigned long alarm_change = 0;
  

  
  if(last_count!=count)num_tapes = map(count,0,255,0,25);
  
  for(byte i = 0;i<num_tapes;i++){
    if(glitterArr[i].delay==0){
      glitterArr[i].speed= random(0,2);
      
      if(glitterArr[i].speed==0) glitterArr[i].position = random(count_tape,LED_COUNT-1); //юзаю той самий масив шо і в глітер пуші
      else glitterArr[i].position = random(0,LED_COUNT-count_tape);
      
      glitterArr[i].delay = random(4,count_tape);
      glitterArr[i].color = random(0,241);
      
    }
  }

  if(millis()-alarm_change>50){
  for(byte i=0;i<25;i++){
    if(glitterArr[i].delay>0)glitterArr[i].delay--;
    if(glitterArr[i].color>0)glitterArr[i].color-=  255/count_tape;
    
     for(int k = 0; k<glitterArr[i].delay;k++){
        if(glitterArr[i].speed == 1)  leds[glitterArr[i].position + k] = ColorFromPalette( GradientPalette,glitterArr[i].color);
        else leds[glitterArr[i].position - k] =  ColorFromPalette( GradientPalette,glitterArr[i].color);
      }
     if(glitterArr[i].speed == 1) leds[glitterArr[i].position + glitterArr[i].delay].setRGB(0,0,0);  
     else leds[glitterArr[i].position - glitterArr[i].delay].setRGB(0,0,0);  
     alarm_change = millis();      
  }
  }

   LEDS.show();
   last_count = count;
 }
