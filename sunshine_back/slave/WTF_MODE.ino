 

bool gReverseDirection = false;

void Fire2012WithPalette(int count)
{
  
 
  byte cooling = map(count, 2, 255, 250, 80);
  byte sparking = map(count, 2, 255, 100, 250); 
// Array of temperature readings at each simulation cell
  static uint8_t heat[LED_COUNT];

  // Step 1.  Cool down every cell a little
    for( int i = 0; i < LED_COUNT; i++) {
      heat[i] = qsub8( heat[i],  random8(0, ((cooling * 10) / LED_COUNT) + 2));
    }
  
    // Step 2.  Heat from each cell drifts 'up' and diffuses a little
    for( int k= LED_COUNT - 1; k >= 2; k--) {
      heat[k] = (heat[k - 1] + heat[k - 2] + heat[k - 2] ) / 3;
    }
    
    // Step 3.  Randomly ignite new 'sparks' of heat near the bottom
    if( random8() < sparking ) {
      int y = random8(7);
      heat[y] = qadd8( heat[y], random8(160,255) );
    }

    // Step 4.  Map from heat cells to LED colors
    for( int j = 0; j < LED_COUNT; j++) {
      // Scale the heat value from 0-255 down to 0-240
      // for best results with color palettes.
      uint8_t colorindex = scale8( heat[j], 240);
      CRGB color = ColorFromPalette( gPal, colorindex);
      int pixelnumber;
      if( gReverseDirection ) {
        pixelnumber = (LED_COUNT-1) - j;
      } else {
        pixelnumber = j;
      }
      leds[pixelnumber] = color;
    }
    LEDS.show();
}
