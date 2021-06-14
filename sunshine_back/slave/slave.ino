#define ID 14

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
byte new_bright;
byte items[6]= {0,0,0,0,0,0};

byte currentId;
boolean broadcast;

byte command;
boolean process;
byte counter;

byte address[][6] = {"1Node","2Node","3Node","4Node","5Node","6Node"};  //возможные номера труб

volatile boolean changeFlag;
byte musicTheme = 0;
byte lightTheme = 0;
boolean paintTheme = false;
boolean screenTheme = false;
byte bright = 0;
byte gradientColors[6] = {0,0,0,0,0,0};
byte amplitude = 0;
byte minuteToSleep = 0;
byte hourToSleep = 0;


void setup(){
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
  radio.setAutoAck(1);         //режим подтверждения приёма, 1 вкл 0 выкл
  radio.setRetries(0,15);     //(время между попыткой достучаться, число попыток)
  radio.enableAckPayload();    //разрешить отсылку данных в ответ на входящий сигнал
  radio.setPayloadSize(32);     //размер пакета, в байтах

  radio.openReadingPipe(1,address[0]);      //хотим слушать трубу 0
  radio.setChannel(0x60);  //выбираем канал (в котором нет шумов!)

  radio.setPALevel (RF24_PA_MAX); //уровень мощности передатчика. На выбор RF24_PA_MIN, RF24_PA_LOW, RF24_PA_HIGH, RF24_PA_MAX
  radio.setDataRate (RF24_1MBPS); //скорость обмена. На выбор RF24_2MBPS, RF24_1MBPS, RF24_250KBPS
  //должна быть одинакова на приёмнике и передатчике!
  //при самой низкой скорости имеем самую высокую чувствительность и дальность!!
  // ВНИМАНИЕ!!! enableAckPayload НЕ РАБОТАЕТ НА СКОРОСТИ 250 kbps!
  
  radio.powerUp(); //начать работу
  radio.startListening();  //начинаем слушать эфир, мы приёмный модуль
}

void loop(void) {

    byte pipeNo, gotByte;                          
    while( radio.available(&pipeNo)){    // слушаем эфир со всех труб
      radio.read( &gotByte, 1 );         // чиатем входящий сигнал
      byte number = gotByte;
     if (counter==0){ 
        if(number>1){
          amplitude = number;
          counter = 0;
        }
        else{
          broadcast = (number==0) ? false : true;
          if (number==1)counter++;
        }
        
     }
     else if (counter==1)currentId = number; 
     else if (counter==2) command = number;
     else if (counter==3){
        items[0] = number;
        if(command == 1 || command == 2 || command == 3 || command == 4 || command == 5 )process = true;
     }
     else if (counter==4){
        items[1] = number;
        if(command == 6)process = true;
     }
     else{
        items[counter-3] = (byte)number;
        if (counter==8) process = true;
     }
     
     
     if(!process)counter++;
     else counter = 0;
     
   }

    if(process){
      
      
      if(!broadcast && currentId == ID){
      switch(command){
        case 1:
        musicTheme = items[0];
        lightTheme = 0;
        screenTheme = false;
        paintTheme = false;
        break;

        case 2:
        lightTheme = items[0];
        musicTheme = 0;
        screenTheme = false;
        paintTheme = false;
        break;
        
        case 4:
        new_bright = items[0];
        break;

        case 5:
          lightTheme = 0;
          musicTheme = 0;
          screenTheme = true;
          paintTheme = false;
        break;
        
        case 6:
          minuteToSleep = items[0];
          hourToSleep = items[1];
        break;  
        case 7:
          gradientColors[0]=items[0];
          gradientColors[1]=items[1];
          gradientColors[2]=items[2];
          gradientColors[3]=items[3];
          gradientColors[4]=items[4];
          gradientColors[5]=items[5];
        break;      
      }
     
  }
  process = false;
    }


    if (lightTheme == 1) fireLine();
    else if (lightTheme == 2) fireLineNoise();
    else if (lightTheme == 3) rainbow_loop();
    else if (lightTheme == 4) new_rainbow_loop();
    else if (lightTheme == 5) {
      one_color_all(gradientColors[0],gradientColors[1], gradientColors[2]);
      LEDS.show();
    }

    if( musicTheme = 1) one_color_symmetric_top(gradientColors[0],gradientColors[1], gradientColors[2],amplitude);
    if( musicTheme = 2) one_color_symmetric_bottom(gradientColors[0],gradientColors[1], gradientColors[2],amplitude);
    if( musicTheme = 3) one_color_symmetric_top_beta(amplitude);
    
    
   
}

void change_mode(int newmode) {
  thissat = 255;
  switch (newmode) {
   case 4: thisdelay = 15; break;                      //---NEW RAINBOW LOOP
    //case 2: thishue = 160; thissat = 50; break;         //--- FLICKER
    case 3: thisdelay = 20; thisstep = 10; break;       //---RAINBOW LOOP

    case 5: one_color_all(gradientColors[0],gradientColors[1], gradientColors[2]); LEDS.show(); break; //---ALL RED
    }
  bouncedirection = 0;
  one_color_all(0, 0, 0);
   changeFlag = true;
}


void stay_ease(){
  static unsigned long time_ease_bright;
  if(millis()-time_ease_bright>2){
  //Serial.println(String(bright) + "-n  " + String(new_bright));
  if(new_bright!=bright){
  if(new_bright<bright)bright-=5;
  else bright+=5;
  }
  //Serial.println(bright);
  time_ease_bright=millis();
  LEDS.setBrightness(bright); 
  }
 
}