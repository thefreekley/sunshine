
  
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



void screenMode(){
  CRGB bgColor( screenColor[3], screenColor[4],screenColor[5]); // pine green ?
  fadeTowardColor( leds, LED_COUNT, bgColor, 5);
  FastLED.show();
}


// Helper function that blends one uint8_t toward another by a given amount
void nblendU8TowardU8( uint8_t& cur, const uint8_t target, uint8_t amount)
{
  if( cur == target) return;
 
  if( cur < target ) {
    uint8_t delta = target - cur;
    delta = scale8_video( delta, amount);
    cur += delta;
  } else {
    uint8_t delta = cur - target;
    delta = scale8_video( delta, amount);
    cur -= delta;
  }
}

// Blend one CRGB color toward another CRGB color by a given amount.
// Blending is linear, and done in the RGB color space.
// This function modifies 'cur' in place.
CRGB fadeTowardColor( CRGB& cur, const CRGB& target, uint8_t amount)
{
  nblendU8TowardU8( cur.red,   target.red,   amount);
  nblendU8TowardU8( cur.green, target.green, amount);
  nblendU8TowardU8( cur.blue,  target.blue,  amount);
  return cur;
}

// Fade an entire array of CRGBs toward a given background color by a given amount
// This function modifies the pixel array in place.
void fadeTowardColor( CRGB* L, uint16_t N, const CRGB& bgColor, uint8_t fadeAmount)
{
  for( uint16_t i = 0; i < N; i++) {
    fadeTowardColor( L[i], bgColor, fadeAmount);
  }
}
