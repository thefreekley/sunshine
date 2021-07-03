
int glitterPosition[10]= {LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1};

void gradientMusicMode(int count,byte modeOfMusic){
  static double aceleration = 0;
  static byte gradient_index = 0;
  static byte alarm_for_change = 0;
  static int current_count = 0;
  static int go_to_count = 0;
  static byte num_of_glitter = 0;
  boolean add_glitter = false;
  static byte raibow_index = 0;

  static byte alarm_acceletation = 0;
  
  count = map(count, 2, 255, 0, LED_COUNT);
   if(count - go_to_count>3) add_glitter=true; 
  if(go_to_count!=count && go_to_count==current_count) go_to_count =  count;
//  if(go_to_count==count && go_to_count==current_count && count!=0) go_to_count = random( 0, go_to_count);
  if(go_to_count<count)go_to_count=count;
  
 
    

  alarm_for_change+=1;
  alarm_for_change%=6;

  
  gradient_index++;
  gradient_index%=240;

  if(alarm_for_change==1)raibow_index++;
  raibow_index%=255;


  
  
  if(go_to_count<current_count){
      aceleration=(cos((current_count)/LED_COUNT))*1.57;
      current_count -= aceleration;
      if(current_count<0)current_count = 0;
  }
  else if(go_to_count>current_count){
    aceleration=(cos((current_count)/LED_COUNT))*1.57;
    current_count+= aceleration;
    if(current_count>go_to_count)current_count = go_to_count;
  }

      
   if(add_glitter){
    glitterPosition[num_of_glitter] = current_count;
    num_of_glitter++;
    num_of_glitter%=10; 
  }
      
  for(int i=0;i<10;i++){
    if (glitterPosition[i]<LED_COUNT)glitterPosition[i]= glitterPosition[i]+1;
  }
  
  
  

     
   if(modeOfMusic==1){

     for (int i = 0 ; i < LED_COUNT; i++ ) {
    if (i < current_count) leds[i]= ColorFromPalette( GradientPalette, (gradient_index + i)%240 );
    else leds[i].setRGB(0,0,0);
    }
      for(int i=0;i<10;i++){
      leds[glitterPosition[i]-1] = ColorFromPalette( GradientPalette, (gradient_index + i*4)%240);
      leds[glitterPosition[i]-2].setRGB(0,0,0);
    }
    leds[LED_COUNT-1].setRGB(0,0,0);
    
    }
   else if(modeOfMusic==2){
    
    for (int i = 0 ; i < LED_COUNT; i++ ) {
      if (i > LED_COUNT - current_count) leds[i]= ColorFromPalette( GradientPalette, (gradient_index + i)%240 );
      else leds[i].setRGB(0,0,0);
      }
     
     for(int i=0;i<10;i++){
      leds[LED_COUNT - glitterPosition[i]] = ColorFromPalette( GradientPalette, (gradient_index + i*4)%240 );
      leds[ (LED_COUNT - glitterPosition[i]+1)%LED_COUNT].setRGB(0,0,0);
    }
    leds[0].setRGB(0,0,0);
    
  }
  else if(modeOfMusic==3){
    for (int i = LED_COUNT/2; i < LED_COUNT; i++ ) {
    if(i< LED_COUNT/2 + current_count/2) leds[i] = ColorFromPalette( GradientPalette, (gradient_index + i*6)%240 );
    else leds[i].setRGB(0,0,0);
    }
    for(int i=0;i<10;i++){
      leds[LED_COUNT/2 + glitterPosition[i]/2-1] = ColorFromPalette( GradientPalette, (gradient_index + i*4)%240 );
      leds[LED_COUNT/2 + glitterPosition[i]/2 -2].setRGB(0,0,0);
    }
    leds[LED_COUNT-1].setRGB(0,0,0);
    for(int i=0; i<LED_COUNT/2; i++){
      leds[i] = leds[LED_COUNT-i] ;
    }
    leds[0].setRGB(0,0,0);
   
  }
  else if(modeOfMusic==4){
    
  for (int i = LED_COUNT/2; i < LED_COUNT; i++ ) {
    if(i> LED_COUNT - current_count/2) leds[i] = ColorFromPalette( GradientPalette, (gradient_index + i*2)%240 );
    else leds[i].setRGB(0,0,0);
    }

   for(int i=0;i<10;i++){
      leds[LED_COUNT - glitterPosition[i]/2-1] = ColorFromPalette( GradientPalette, (gradient_index + i*4)%240 );
      leds[LED_COUNT - glitterPosition[i]/2-2].setRGB(0,0,0);
    }

    for(int i=0; i<LED_COUNT/2; i++){
      leds[i] = leds[LED_COUNT-i] ;
    }
    
   leds[LED_COUNT/2].setRGB(0,0,0);
    
  }

   
    
   LEDS.show();
    
}
