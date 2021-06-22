
  
void gradientShow()
{
  static unsigned long gradientTime = 0;
 
    
  if(millis()-gradientTime>50){
    leds[0]=leds[LED_COUNT-1];
     for(int i = LED_COUNT-1; i>0; i--){
      leds[i]=leds[i-1];
         
    }
    gradientTime = millis();
  }
  
 FastLED.show();
}
