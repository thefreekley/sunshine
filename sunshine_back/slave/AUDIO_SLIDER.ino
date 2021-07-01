
int glitterPosition[10]= {LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1,LED_COUNT-1};

void gradientMusicMode(int count,byte modeOfMusic){
  static int aceleration_up = 1;
  static int aceleration_down = 1;
  static byte gradient_index = 0;
  static byte alarm_for_change = 0;
  static int current_count = 0;
  static int go_to_count = 0;
  static byte num_of_glitter = 0;
  boolean add_glitter = false;
  

  static byte alarm_acceletation = 0;
  
  count = map(count, 2, 255, 0, LED_COUNT);
   if(count - go_to_count>1) add_glitter=true; 
  if(go_to_count!=count && go_to_count==current_count) go_to_count =  count;
  if(go_to_count==count && go_to_count==current_count && count!=0) go_to_count = random( (go_to_count - go_to_count/6) >0 ? (go_to_count - go_to_count/6): 0, (go_to_count + go_to_count/6) < LED_COUNT ? (go_to_count + go_to_count/6): LED_COUNT-1 );
  if(go_to_count<count)go_to_count=count;
  
 
    
  

  alarm_for_change+=1;
  alarm_for_change%=6;

  
  gradient_index++;
  gradient_index%=240;


  
  
  if(go_to_count<current_count){
     if(alarm_for_change==5) aceleration_down+=aceleration_down;
      aceleration_up = 1;
      
      current_count -= aceleration_down/10;
      if(current_count<0)current_count = 0;
    
  }
  else if(go_to_count>current_count){
    if(alarm_for_change==5)aceleration_up+=aceleration_up;
    aceleration_down = 1;
    current_count+= aceleration_up/10;
    if(current_count>go_to_count)current_count = go_to_count;
  }

      
   if(add_glitter){
    glitterArr[num_of_glitter].speed = map(go_to_count - current_count,1,LED_COUNT,1,5);
    glitterArr[num_of_glitter].color = gradient_index;
    glitterArr[num_of_glitter].position = current_count;

    num_of_glitter++;
    num_of_glitter%=30; 

    
     
      
  }
      
  
  

     
   if(modeOfMusic==1){

     for (int i = 0 ; i < LED_COUNT; i++ ) {
    if (i < current_count) leds[i]= ColorFromPalette( GradientPalette, (gradient_index + i)%240 );
    else leds[i].setRGB(0,0,0);
    }
      for(int i=0;i<30;i++){

       glitterArr[i].delay+=glitterArr[i].speed;
      if(glitterArr[i].delay>5)glitterArr[i].delay = 0;
      
      if(glitterArr[i].delay == 0){
        leds[glitterArr[i].position-1].setRGB(0,0,0);
        if(glitterArr[i].position<LED_COUNT) glitterArr[i].position+= ((LED_COUNT/2)*(LED_COUNT/2) - glitterArr[i].position*glitterArr[i].position)/4000 + 1;
        if (glitterArr[i].position>LED_COUNT-1)glitterArr[i].position = 0;
        leds[glitterArr[i].position-1]= ColorFromPalette( GradientPalette, glitterArr[i].color*4);
      }
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
