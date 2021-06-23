
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


int glitterPosition[10]= {LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1};

void gradientMusicMode(int count , byte modeOfMusic) {       //-SET ALL LEDS TO ONE COLOR // 1 up line 2 down line 3 from center 4 to center 
  static int last_count;
  static int last_delta_count;
  static int new_count = 0;
  static unsigned  long millis_ocst = 0;
  static unsigned int gradientIndex=0;

  static byte num_of_glitter = 0;
  
  count = map(count, 3, 255, 0, LED_COUNT);
  if(count>1)count = count - count%2; 

   gradientIndex = rangeGrandient(gradientIndex, 1);
 
  if(last_count!=count){
    last_delta_count = last_count;
    new_count = last_delta_count;
    
  }
  
  
  
      if(last_count==count) {
      if(last_delta_count > count){
        if(new_count>count){
          if(new_count<2)new_count = 0;
          else new_count-=2; 
        }
      }
      else if(last_delta_count < count){
         if(new_count<count){
          if(new_count>254)new_count = 255; //animation arrow 
          else new_count+=2;
            
         }
      }
      if(new_count == count && count!=0 ){
         if(last_delta_count < count)new_count = random(last_delta_count/2,count);
         else if(last_delta_count > count)new_count = random(count/2 ,last_delta_count); // when count not enough change
      }
      
      }

   if(count>last_count){
    glitterPosition[num_of_glitter] = new_count;
    num_of_glitter++;
    num_of_glitter%=10; 
  }
      
  for(int i=0;i<10;i++){
    if (glitterPosition[i]<LED_COUNT)glitterPosition[i]= glitterPosition[i]+1;
  }

  
    
   
   if(modeOfMusic==1){
      for (int i = 0 ; i < LED_COUNT; i++ ) {
      if (i > LED_COUNT - new_count && modeOfMusic==2) leds[i]= ColorFromPalette( GradientPalette, rangeGrandient(gradientIndex,i)*2 );
      else leds[i].setRGB(0,0,0);
      }
    }
   else if(modeOfMusic==2){
    for (int i = 0 ; i < LED_COUNT; i++ ) {
    if (i < new_count) leds[i]= ColorFromPalette( GradientPalette, rangeGrandient(gradientIndex,i)*2 );
    else leds[i].setRGB(0,0,0);
    }
  }
  else if(modeOfMusic==3){
    for (int i = 0 ; i < LED_COUNT; i++ ) {
    if(i< LED_COUNT/2 + new_count/2 && i> LED_COUNT/2 - new_count/2) leds[i] = ColorFromPalette( GradientPalette, rangeGrandient(gradientIndex,i% (LED_COUNT/2))*2 );
    else leds[i].setRGB(0,0,0);
    }
    for(int i=0;i<10;i++){
      leds[LED_COUNT/2 + glitterPosition[i]/2-1] = ColorFromPalette( GradientPalette, rangeGrandient(gradientIndex,1)*2 );
      leds[LED_COUNT/2 + glitterPosition[i]/2 -2].setRGB(0,0,0);

      leds[LED_COUNT/2 - glitterPosition[i]/2] = ColorFromPalette( GradientPalette, rangeGrandient(gradientIndex,1)*2 );
      leds[LED_COUNT/2 - glitterPosition[i]/2 +1].setRGB(0,0,0);

    }
    leds[LED_COUNT-1].setRGB(0,0,0);
    leds[0].setRGB(0,0,0);
  }
  else if(modeOfMusic==4){
    for (int i = 0 ; i < LED_COUNT; i++ ) {
    if (i< new_count/2 || i> LED_COUNT - new_count/2) leds[i]= ColorFromPalette( GradientPalette, rangeGrandient(gradientIndex,i)*2 );
    else leds[i].setRGB(0,0,0);
  }
  }
  
    
   LEDS.show();
   last_count = count;     
  
}

int rangeGrandient(int index,int addPart){
  static int riseTroggle = false;
  if(riseTroggle){
    if(index <120)return index+addPart;
    else{ return 0; riseTroggle=false; }
  }
  else{
    if(index >0)return index-addPart;
    else{ return 120; riseTroggle=true; }
  }
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
        stateSplitPart[i][0]=gradientColors[1] - gradientColors[1]%speedOfFrequancy;
        stateSplitPart[i][1]=gradientColors[2] - gradientColors[2]%speedOfFrequancy;
        stateSplitPart[i][2]=gradientColors[3] - gradientColors[3]%speedOfFrequancy;
        }
        else{
        stateSplitPart[i][0]=gradientColors[5] - gradientColors[5]%speedOfFrequancy;
        stateSplitPart[i][1]=gradientColors[6] - gradientColors[6]%speedOfFrequancy;
        stateSplitPart[i][2]=gradientColors[7] - gradientColors[7]%speedOfFrequancy;
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

void slideGrlitters(int count){
   static unsigned long longTimeForUpdateState = 0;
   static unsigned long shortTimeForUpdateState = 0;
   static int lastValue = 3;
   static int indexGradientColor = 0;
  
 
  if(millis() - longTimeForUpdateState > 2) {
    if(count>lastValue){
      indexGradientColor+=20;
      indexGradientColor%=240;
//      Serial.println((count*count*100)/lastValue*lastValue);
      leds[LED_COUNT/2-1] = ColorFromPalette( GradientPalette, indexGradientColor );
      leds[LED_COUNT/2+1] = ColorFromPalette( GradientPalette, indexGradientColor );
    }
//    Serial.println(String(count) + " " + String(lastValue) + " " + String((count*100)/lastValue) );
    longTimeForUpdateState = millis();
    
    lastValue = count;
  }

  if(millis() - shortTimeForUpdateState > 5) {
     
     for(int i = LED_COUNT-1; i>LED_COUNT/2; i--){
      leds[i]=leds[i-1];
          
    }
    
     for(int i = 0; i<LED_COUNT/2+1; i++){
      leds[i]=leds[i+1];    
    }


    
     LEDS.show();
    shortTimeForUpdateState = millis();
  }
  
}

void audioFlicker(int count){
   for(int i = 0; i<LED_COUNT; i++){
      leds[i].setRGB(count,count,count);
}
LEDS.show();
}
