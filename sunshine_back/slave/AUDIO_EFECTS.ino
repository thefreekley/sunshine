
byte LIGHT_COLOR = 0;             // начальный цвет подсветки
byte LIGHT_SAT = 255;             // начальная насыщенность подсветки
byte COLOR_SPEED = 100;
int RAINBOW_PERIOD = 1;
float RAINBOW_STEP_2 = 0.5;

DEFINE_GRADIENT_PALETTE( SmoothColor1 ) {
  0,     255,  255,  255,   
128,   255,  0,  255,  
255,   255,  255,  255  }; 


DEFINE_GRADIENT_PALETTE( SmoothColor2 ) {
  0,     255,  255,  255, 
128,   255,  0,  0,  
255,   255,  255,  255 }; 

DEFINE_GRADIENT_PALETTE( SmoothColor3 ) {
  0,    255,  255,  255,    
128,   0,  0,  255,  
255,   255,  255,  255   }; 

DEFINE_GRADIENT_PALETTE( SmoothColor4 ) {
  0,     255,  0,  0,    
128,   255,  255,  255,  
255,    255,  0,  0,   }; 

DEFINE_GRADIENT_PALETTE( SmoothColor5 ) {
  0,     255,  255,  255,   
128,   0,  255,  255,  
255,   255,  255,  255  }; 

CRGBPalette16 MyPaletteSmooth1 = SmoothColor1;
CRGBPalette16 MyPaletteSmooth2 = SmoothColor2;
CRGBPalette16 MyPaletteSmooth3 = SmoothColor3;
CRGBPalette16 MyPaletteSmooth4 = SmoothColor4;
CRGBPalette16 MyPaletteSmooth5 = SmoothColor5;


void three_color_symmetric_top_beta(int count) {       //-SET ALL LEDS TO ONE COLOR

   count = map(count, 3, 255, 0, LED_COUNT);
   count = constrain(amplitude, 0, LED_COUNT-1) -3;
  
  static byte cobination =0;
  static int old_count = 0;
   if(count - old_count > 10){
  if(cobination >3)cobination=0;
  else cobination++;
  }
  old_count = count;
  for (int i = 0 ; i < LED_COUNT; i++ ) {
    if(i< LED_COUNT/2 + count && i> LED_COUNT/2 - count){
         switch(cobination){
    case 0:leds[i] = ColorFromPalette( MyPaletteSmooth1, i*2 ); break;
    case 1:leds[i] = ColorFromPalette( MyPaletteSmooth2, i*2 ); break;
    case 2: leds[i] = ColorFromPalette( MyPaletteSmooth3, i*2 ); break;
    case 3:leds[i] = ColorFromPalette( MyPaletteSmooth4, i*2 ); break;
    case 4:leds[i] = ColorFromPalette( MyPaletteSmooth5, i*2 ); break;
  }
    }
    else leds[i].setRGB(0,0,0);
  }
  LEDS.show();      
}



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


void slideGrlitters(int count){
   static byte index_glitter = 0;
   static byte index_gradient = 0;
   static int last_value = 0;
   static unsigned long time_alarm = 0;
   count = map(count, 2, 255, 0, LED_COUNT);
    
   index_glitter++;
   index_glitter%=30;

   index_gradient++;
   index_gradient%=60;
    
   if(count>last_value){
      glitterArr[index_glitter].speed = map(count - last_value,1,LED_COUNT,1,5);
      glitterArr[index_glitter].color = ((count - last_value)*10)%240;
      glitterArr[index_glitter].position = 0;
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

void audioFlicker(int count){
  static int last_count = 0;
  byte mode_part;
  
  if(last_count<count){
    mode_part = random(0,2);
    if(mode_part == 0){
        for(int i = 0 ; i < LED_COUNT; i++){
           if(i> LED_COUNT/3 && i < LED_COUNT - LED_COUNT/3) leds[i].setRGB(255,255,255);
           else leds[i].setRGB(0,0,0);
        }
    }

    else if(mode_part == 1){
        for(int i = 0 ; i < LED_COUNT; i++){
           if(i< LED_COUNT/3 || i > LED_COUNT/2) leds[i].setRGB(255,255,255);
           else leds[i].setRGB(0,0,0);
        }
    }
    
    
  }

   for(int i = 0 ; i < LED_COUNT; i++){
           if(leds[i][0]!=0)leds[i][0]--;
           if(leds[i][1]!=0)leds[i][1]--;
           if(leds[i][2]!=0)leds[i][2]--;
        }
    LEDS.show();
  last_count = count;
}
