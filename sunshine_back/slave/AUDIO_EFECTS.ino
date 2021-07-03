
byte LIGHT_COLOR = 0;             // начальный цвет подсветки
byte LIGHT_SAT = 255;             // начальная насыщенность подсветки
byte COLOR_SPEED = 100;
int RAINBOW_PERIOD = 1;
float RAINBOW_STEP_2 = 0.5;



byte stateSplitPart[7][3] = {{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0}};
byte speedOfFrequancy = 3;
void frequencySplit(byte count){
    
    static unsigned long longTimeForUpdateState = 0;
    static unsigned long shortTimeForUpdateState = 0;
   
    
    if(millis() - longTimeForUpdateState > 20) {
    count = count-3;
    
    
    for(byte i=0; i<7; i++){
      if(bitRead(count,i)){
        if(random(0, 2)){
        stateSplitPart[6-i][0]=gradientColors[1] - gradientColors[1]%speedOfFrequancy;
        stateSplitPart[6-i][1]=gradientColors[2] - gradientColors[2]%speedOfFrequancy;
        stateSplitPart[6-i][2]=gradientColors[3] - gradientColors[3]%speedOfFrequancy;
        }
        else{
        stateSplitPart[6-i][0]=gradientColors[5] - gradientColors[5]%speedOfFrequancy;
        stateSplitPart[6-i][1]=gradientColors[6] - gradientColors[6]%speedOfFrequancy;
        stateSplitPart[6-i][2]=gradientColors[7] - gradientColors[7]%speedOfFrequancy;
        }
      }
      
    }
    
    longTimeForUpdateState = millis();
  }
  


     
    for(byte i=0; i<7; i++){
      if(stateSplitPart[i][0]>0)stateSplitPart[i][0]-=speedOfFrequancy;
      if(stateSplitPart[i][1]>0)stateSplitPart[i][1]-=speedOfFrequancy;
      if(stateSplitPart[i][2]>0)stateSplitPart[i][2]-=speedOfFrequancy;
      
    }
      
    for(int i =0; i<7;i+=1){
        
      for(int k = 0; k< LED_COUNT/14; k++){
          leds[i*(LED_COUNT/14) + k ].setRGB( stateSplitPart[i][0],stateSplitPart[i][1] ,stateSplitPart[i][2] ); 
      }
      
      for(int k = 0; k< LED_COUNT/14; k++){
          leds[LED_COUNT/2 + (i*(LED_COUNT/14) + k) ].setRGB( stateSplitPart[6-i][0], stateSplitPart[6-i][1], stateSplitPart[6-i][2]); 
      }
      
   
    }
     LEDS.show();
    
}

struct Glitter{
  byte position;
  byte speed;
  byte color;
  byte delay;
};

Glitter glitterArr[30];

void clearGlitterArr(){
  for(int i =0; i<30;i++){
     glitterArr[i].position=0;
     glitterArr[i].speed=0;
     glitterArr[i].color=0;
     glitterArr[i].delay=0;
  }
}


void slideGrlitters(int count){
   static byte index_glitter = 0;
   static byte index_gradient = 0;
   static int last_value = 0;
   static unsigned long time_alarm = 0;
   count = map(count, 2, 255, 0, LED_COUNT);
    
   

   index_gradient++;
   index_gradient%=60;
    
   if(count>last_value){
      glitterArr[index_glitter].speed = map(count - last_value,1,LED_COUNT,1,5);
      glitterArr[index_glitter].color = ((count - last_value)*10)%240;
      glitterArr[index_glitter].position = 0;
      index_glitter++;
      index_glitter%=30;
   }

  
   for(int i=0;i<30;i++){
     
      glitterArr[i].delay+=glitterArr[i].speed;
      if(glitterArr[i].delay>5)glitterArr[i].delay = 0;
      
     
      if(glitterArr[i].delay == 0){
        
      leds[LED_COUNT/2 + glitterArr[i].position-1].setRGB(0,0,0);

      if(glitterArr[i].position<LED_COUNT/2) glitterArr[i].position+= ((LED_COUNT/2)*(LED_COUNT/2) - glitterArr[i].position*glitterArr[i].position)/4000 + 1;
      
      if (glitterArr[i].position>LED_COUNT/2)glitterArr[i].position = 0;
      
      leds[LED_COUNT/2 + glitterArr[i].position-1]= ColorFromPalette( GradientPalette, glitterArr[i].color*4, 255*(LED_COUNT/2)/glitterArr[i].position );
      }  
   }
   leds[LED_COUNT-1].setRGB(0,0,0);

   for(int i =0;i<LED_COUNT/2;i++){
    leds[i] = leds[LED_COUNT - i -1]; 
   }

 
 
   
   
   LEDS.show();
   
   last_value = count;
}
