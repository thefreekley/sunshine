
  
void gradientShow()
{
  
  
  
 static unsigned int paletteIndex=0;
 fill_palette(leds,LED_COUNT,paletteIndex, 255/LED_COUNT,GradientPalette,255,LINEARBLEND);
 EVERY_N_MILLISECONDS(40){
   paletteIndex++;
 }

 FastLED.show();
}
