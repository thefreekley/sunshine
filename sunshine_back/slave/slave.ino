#define ID 1

#include <SPI.h>
#include "nRF24L01.h"
#include "RF24.h"
#include <EEPROM.h>        


#define LED_COUNT 120
#define LED_DT 8

#include "FastLED.h" 


// ---------------СЛУЖЕБНЫЕ ПЕРЕМЕННЫЕ-----------------

          
int BOTTOM_INDEX = 0;        // светодиод начала отсчёта
int TOP_INDEX = int(LED_COUNT / 2);
int EVENODD = LED_COUNT % 2;
struct CRGB leds[LED_COUNT];
int ledsX[LED_COUNT][3];     //-ARRAY FOR COPYING WHATS IN THE LED LEDS CURRENTLY (FOR CELL-AUTOMATA, MARCH, ETC)

int thisdelay = 20;          //-FX LOOPS DELAY VAR
int thisstep = 10;           //-FX LOOPS DELAY VAR
int thishue = 0;             //-FX LOOPS DELAY VAR
int thissat = 255;           //-FX LOOPS DELAY VAR

int thisindex = 0;
int thisRED = 0;
int thisGRN = 0;
int thisBLU = 0;

int idex = 0;                //-LED INDEX (0 to LED_COUNT-1
int ihue = 0;                //-HUE (0-255)
int ibright = 0;             //-BRIGHTNESS (0-255)
int isat = 0;                //-SATURATION (0-255)
int bouncedirection = 0;     //-SWITCH FOR COLOR BOUNCE (0-1)
float tcount = 0.0;          //-INC VAR FOR SIN LOOPS
int lcount = 0;              //-ANOTHER COUNTING VAR
CRGBPalette16 firePalette;


////////////////////////////////////////////////////////////////////


RF24 radio(9,10); // "создать" модуль на пинах 9 и 10 Для Уно
//RF24 radio(9,53); // для Меги
byte new_bright = 255;
byte items[6]= {0,0,0,0,0,0};

byte currentId;
boolean broadcast;

byte command;
boolean process;
int countTimes;

byte address[][6] = {"1Node","2Node","3Node","4Node","5Node","6Node"};  //возможные номера труб

volatile boolean changeFlag;
byte musicTheme = 0;
byte lightTheme = 5;
boolean paintTheme = false;
boolean screenTheme = false;
byte bright = 255;
byte gradientColors[12] = {0,255,0,40,128,0,0,60,255,255,0,40};
byte screenColor[6]= {0,0,0,0,0,0};

byte amplitude = 0;

byte minuteToSleep = 0;
byte hourToSleep = 0;


boolean sleep_mode = false;

byte current_minute = 0;
byte current_second = 0;
byte current_hour = 0;

byte time_off_minute = 0;
byte time_off_hour = 0;

byte time_on_minute = 0;
byte time_on_hour = 0;

byte listLightModeMinute[10] = {0,0,0,0,0,0,0,0,0,0};
byte listLightModeHour[10] = {0,0,0,0,0,0,0,0,0,0};
byte listLightModeCount = 0;

byte listSleepModeMinute[10] = {0,0,0,0,0,0,0,0,0,0};
byte listSleepModeHour[10] = {0,0,0,0,0,0,0,0,0,0}; 
byte listSleepModeCount = 0;


//struct color {
//  int r;
//  int g;
//  int b;
//};
//
//typedef struct color Color;



CRGBPalette16 GradientPalette;

CRGBPalette16 gPal;


void setup(){
  GradientPalette.loadDynamicGradientPalette(gradientColors);
   firePalette = CRGBPalette16(
                  getFireColor(0 * 16),
                  getFireColor(1 * 16),
                  getFireColor(2 * 16),
                  getFireColor(3 * 16),
                  getFireColor(4 * 16),
                  getFireColor(5 * 16),
                  getFireColor(6 * 16),
                  getFireColor(7 * 16),
                  getFireColor(8 * 16),
                  getFireColor(9 * 16),
                  getFireColor(10 * 16),
                  getFireColor(11 * 16),
                  getFireColor(12 * 16),
                  getFireColor(13 * 16),
                  getFireColor(14 * 16),
                  getFireColor(15 * 16)
                );

  LEDS.setBrightness(bright);
  randomSeed(analogRead(0));
  LEDS.addLeds<WS2811, LED_DT, GRB>(leds, LED_COUNT);  // настрйоки для нашей ленты (ленты на WS2811, WS2812, WS2812B)
  
  one_color_all(0, 0, 0);          
  LEDS.show();                     
  randomSeed(analogRead(0));
  
  
  Serial.begin(9600); //открываем порт для связи с ПК
  radio.begin(); //активировать модуль
  radio.setAutoAck(0);         //режим подтверждения приёма, 1 вкл 0 выкл
  radio.setRetries(0,15);     //(время между попыткой достучаться, число попыток)
  radio.enableAckPayload();    //разрешить отсылку данных в ответ на входящий сигнал
  radio.setPayloadSize(1);     //размер пакета, в байтах

  radio.openReadingPipe(1,address[0]);      //хотим слушать трубу 0
  radio.setChannel(0x60);  //выбираем канал (в котором нет шумов!)

  radio.setPALevel (RF24_PA_MAX); //уровень мощности передатчика. На выбор RF24_PA_MIN, RF24_PA_LOW, RF24_PA_HIGH, RF24_PA_MAX
  radio.setDataRate (RF24_2MBPS); //скорость обмена. На выбор RF24_2MBPS, RF24_1MBPS, RF24_250KBPS
  //должна быть одинакова на приёмнике и передатчике!
  //при самой низкой скорости имеем самую высокую чувствительность и дальность!!
  // ВНИМАНИЕ!!! enableAckPayload НЕ РАБОТАЕТ НА СКОРОСТИ 250 kbps!
  
  radio.powerUp(); //начать работу
  radio.startListening();  //начинаем слушать эфир, мы приёмный модуль
  change_mode(lightTheme);
  gPal = HeatColors_p;
}

void loop(void) {
  stay_ease();

  if(listLightModeCount!=0 || listSleepModeCount!=0){
    time_to_sleep();
  }
   static unsigned long timeLastReceive= 0;
  byte pipeNo, gotByte;                          
    while( radio.available(&pipeNo)){    // слушаем эфир со всех труб
      radio.read( &gotByte, 1 );         // чиатем входящий сигнал
      byte number = gotByte;
      timeLastReceive = millis();
      
     if (countTimes==0){ 
        if(number>1){
          
          amplitude = number;
         
          countTimes = 0;
          process = 0;
          goto pass_check;
        }
        else{
          broadcast = (number==0) ? false : true;
          if (number==1)countTimes++;
        }
        
     }
     else if (countTimes==1)currentId = number; 
     else if (countTimes==2) command = number;
     else if (countTimes==3){
        items[0] = number;
        if(command == 1 || command == 2 || command == 3 || command == 4 )process = true;
     }
     else if (countTimes==4){
        items[1] = number;
     }
     else{
        items[countTimes-3] = (byte)number;
        if (countTimes==8 && command == 7 ) process = true;
        if (countTimes==8 && command == 6 ) process = true;
        if (countTimes==5 && command == 5 ) process = true;
     }
     
     
     if(!process)countTimes++;
     else countTimes = 0;
     
   }
   pass_check:

   if(millis()-timeLastReceive>150){
  countTimes = 0;
  process = 0; 
}



    if(process){
      
      
      if( (!broadcast && currentId == ID) || broadcast){
      switch(command){
        case 1:
        musicTheme = items[0];
        lightTheme = 0;
        one_color_all(0, 0, 0);
        clearGlitterArr();
        break;

        case 2:
        lightTheme = items[0];
        change_mode(lightTheme);
        musicTheme = 0;      
        break;
        
        case 4:
        new_bright = items[0];
        break;

        case 5:
         
          screenColor[0] =  screenColor[3];
          screenColor[1] =  screenColor[4];
          screenColor[2] =  screenColor[5];

          screenColor[3] = items[0];
          screenColor[4] = items[1];
          screenColor[5] = items[2];
       
            
          
          lightTheme = 6;
          musicTheme = 0;
         
        break;
        
        case 6:
        
          current_minute = items[1];
          current_second = 0;
          current_hour = items[0];
          if( items[2] == 66 && items[3] == 66){
              listSleepModeMinute[listSleepModeCount] = items[5];
              listSleepModeHour[listSleepModeCount] = items[4];
              listSleepModeCount+=1;
              listSleepModeCount= listSleepModeCount%10;
          }
          else if( items[4] == 66 && items[5] == 66){
              listLightModeMinute[listLightModeCount] = items[3];
              listLightModeHour[listLightModeCount] = items[2];
              listLightModeCount+=1;
              listLightModeCount= listLightModeCount%10;
              
          }
          else if(items[2] == 66 && items[3] == 66 && items[4] == 66 && items[5] == 66){
              listSleepModeCount = 0;
              listLightModeCount = 0;
          }
          else{
            listLightModeMinute[listLightModeCount] = items[5];
            listLightModeHour[listLightModeCount] = items[4];
            listLightModeCount+=1;
            listLightModeCount= listLightModeCount%10;

            listSleepModeMinute[listSleepModeCount] = items[3];
            listSleepModeHour[listSleepModeCount] = items[2];
            listSleepModeCount+=1;
            listSleepModeCount = listSleepModeCount%10;
          }
          
        break;  
        case 7:
          
          gradientColors[1]=items[0];
          gradientColors[2]=items[1];
          gradientColors[3]=items[2];
          gradientColors[5]=items[3];
          gradientColors[6]=items[4];
          gradientColors[7]=items[5];
          gradientColors[9]=items[0];
          gradientColors[10]=items[1];
          gradientColors[11]=items[2];
          


         
          
          GradientPalette.loadDynamicGradientPalette(gradientColors);
          if(lightTheme == 5) fill_palette(leds,LED_COUNT,0, 255/LED_COUNT,GradientPalette,255,LINEARBLEND); LEDS.show();
          
        break;      
      }
     
  }
  process = false;
    }
  


    if (lightTheme == 1) fireLine();
    else if (lightTheme == 2) fireLineNoise();
    else if (lightTheme == 3) rainbow_loop();
    else if (lightTheme == 4) new_rainbow_loop();
    else if (lightTheme == 5) gradientShow();
    else if (lightTheme == 6) screenMode();
    

    if( musicTheme == 1) gradientMusicMode(amplitude,1);
    else if( musicTheme == 2) gradientMusicMode(amplitude,2);
    else if( musicTheme == 3) gradientMusicMode(amplitude,3);
    else if( musicTheme == 4) gradientMusicMode(amplitude,4);
    else if( musicTheme == 5)Fire2012WithPalette(amplitude); 
    else if( musicTheme == 6)frequencySplit(amplitude); 
    else if( musicTheme == 7) slideGrlitters(amplitude); 
    else if( musicTheme == 8) colorTape(amplitude); 
   
}

void change_mode(int newmode) {
  thissat = 255;
  one_color_all(0, 0, 0);
  switch (newmode) {
   case 4: thisdelay = 15; break;                      //---NEW RAINBOW LOOP
    //case 2: thishue = 160; thissat = 50; break;         //--- FLICKER
    case 3: thisdelay = 20; thisstep = 10; break;       //---RAINBOW LOOP

    case 5: fill_palette(leds,LED_COUNT,0, 255/LED_COUNT,GradientPalette,255,LINEARBLEND); LEDS.show(); break; //---ALL RED
    }
  bouncedirection = 0;

   changeFlag = true;
}


void stay_ease(){
  if(new_bright!=bright){
  static unsigned long time_ease_bright;
  if(millis()-time_ease_bright>2){
  //Serial.println(String(bright) + "-n  " + String(new_bright));
  
  if(new_bright<bright)bright-=5;
  else bright+=5;
  }
  //Serial.println(bright);
  time_ease_bright=millis();
  LEDS.setBrightness(bright); 
  }
 
}

void time_to_sleep(){
  static unsigned long time_update_seconds = 0;
  static byte last_bright = 0;

  if(millis()-time_update_seconds>1000){
  if(current_second<60)current_second++;
  else{
    current_second = 0;
    if(current_minute<60) {
      current_minute+=1;
      
      
    }
    else{
      current_minute = 0;
      if(current_hour<24)current_hour+=1;
      else current_hour = 0;
      
    }
    
  }
  if(new_bright==0 && current_second<2) {   
    for(int i=0; i<listLightModeCount;i++){
      if(current_minute == listLightModeMinute[i] && current_hour == listLightModeHour[i]){
        new_bright = last_bright;
      }
    }
  }

  if(new_bright!=0 && current_second<2) {
    for(int i=0; i<listSleepModeCount;i++){
      if(current_minute == listSleepModeMinute[i] && current_hour == listSleepModeHour[i]){
        last_bright = new_bright; 
        new_bright = 0;
      }
    }
  }

  
  time_update_seconds = millis();
  }
 
}
