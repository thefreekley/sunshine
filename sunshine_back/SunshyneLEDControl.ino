#include <SoftwareSerial.h>
#include <string.h>
#include <FastLED.h>

/**
 * define the bluetooth rx and tx pins
 */
SoftwareSerial BT(10, 11); // RX | TX

/**
 * NEED SWITCHES 2,3,5,6 AND THEN DONE
 */

/**
 * define constants in code 
 */
#define data 3  //use whichever digital pin you want
#define num_leds 300  //change for your led strip
#define led_type WS2812   //the code I have written is for WS2812 idk if how itll work on other types
#define color_order GRB //change to approriate color order
#define strobeRate 100  //only used if you want a strobe effects

float audio;
float calc;

uint8_t gHue = 0;
uint8_t hue = 0;

int curRed;
int curGreen;
int curBlue;

boolean isActive = false; //not currently used

CRGB leds[num_leds];  //define your array of leds

String holdInput = "";
String hold = "";

void setup(){

  pinMode(data, OUTPUT);  //setup data pin

  FastLED.addLeds<led_type, data, color_order>(leds, num_leds).setCorrection(TypicalSMD5050); //define the lights

  /**
   * initially set all of the lights to be turned off
   */
  for(int i = 0; i < num_leds; i++){

    leds[i] = CRGB(0,0,0);
  }
  /**
   * open serial port and bluetooth port
   * change the bluetooth value depending on the baud rate of your bluetooth module
   * I used the HC-05 whihc has a default of 9600 
   */
  Serial.begin(38400);
  //Serial.println("Enter AT commands!");
  BT.begin(38400); //Baud Rate for command Mode. 
}

/**
 * reads the data from the bluetooth and processes it based on characters defined in the app
 */
void readInputData(){

  if(BT.available()){

    char inputData = BT.read();
    holdInput.concat(inputData);

    String identifier = "";

    //Serial.println(holdInput);

    if(inputData == '\n'){

      identifier = holdInput.substring(0, 1);

      if(identifier == "x"){

        readColorData(holdInput);
      }
      if(identifier == "y"){
        
        readEffectsData(holdInput);
      }
      if(identifier == "z"){

        readColorPatternData(holdInput);
      }
      
      holdInput = "";
    }
  }
}

/**
 * processes the solid light color data 
 * from the app (tabs 1 and 3).
 * sets the strand of lights to one solid color
 * If your power supply does not meet the 
 * current requirements for your led strip the solid
 * color lights may have a gradient effect
 */
void readColorData(String colorData){

  String red = "";
  String green = "";
  String blue= "";

  int R_Index;
  int G_Index;
  int B_Index;
  int end_Index;

  int r_val = 0;
  int g_val = 0;
  int b_val = 0;

  for(int i = 0; i < colorData.length() + 1; i++){
      
    R_Index = colorData.indexOf("R");
    G_Index = colorData.indexOf("G");
    B_Index = colorData.indexOf("B");
    end_Index = colorData.indexOf('\n');
  }
         
  red = colorData.substring(R_Index, G_Index);
  green = colorData.substring(G_Index, B_Index);
  blue = colorData.substring(B_Index, end_Index);
      
  red.remove(0,1);
  blue.remove(0,1);
  green.remove(0,1);

  r_val = red.toInt();
  g_val = green.toInt();
  b_val = blue.toInt();
          
  //Serial.println(r_val);
  //Serial.println(g_val);
  //Serial.println(b_val);

  setColorLight(r_val, g_val, b_val);

  curRed = r_val;
  curGreen = g_val;
  curBlue = b_val;

  colorData = "";
}

/**
 * this function determines which switch has been pressed in the "effects" tab
 * in the app and then begins the function for the desired effect
 */

void setColorLight(int red, int green, int blue){

  fill_solid(leds, num_leds, CRGB(red, green, blue));
  FastLED.setBrightness(255);
  FastLED.show();   
}
/**
 * this sets a single specific light to a specific color
 */
void setColorPattern(int red, int green, int blue, int num){

  leds[num - 1] = CRGB(red, green, blue);
  FastLED.setBrightness(255);
  FastLED.show();
}

/**
 * reads an aux input and sets the brightness of the 
 * led strip based on the analog reading of the aux input. 
 * 
 * due to the current method used to loop the function and read the bluetooth input,
 * when you turn the switch off in the app the arduino may not respond immediately 
 * and must be pressed multiple times. I am working to fix this issue.
 */

void loop(){

  //bpm();
  //FastLED.show();
  //juggle();
  //FastLED.show();
  //strobeMusic();
  //changeColor();
  //musicColor();
  EVERY_N_MILLISECONDS(20){gHue += 5;}
  //bpm();
  readInputData();
}
