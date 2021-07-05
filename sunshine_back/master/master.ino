
#include <SPI.h>
#include "nRF24L01.h"
#include "RF24.h"

RF24 radio(9,10); 

byte address[][6] = {"1Node","2Node","3Node","4Node","5Node","6Node"};  //возможные номера труб

byte items[6]= {0,0,0,0,0,0};

byte currentId;
boolean broadcast;

byte command;
boolean process;
byte counter=0;

void setup(){
  Serial.begin(9600); //открываем порт для связи с ПК

  radio.begin(); //активировать модуль
  radio.setAutoAck(1);         //режим подтверждения приёма, 1 вкл 0 выкл
  radio.setRetries(0,15);     //(время между попыткой достучаться, число попыток)
  radio.enableAckPayload();    //разрешить отсылку данных в ответ на входящий сигнал
  radio.setPayloadSize(1);     //размер пакета, в байтах

  radio.openWritingPipe(address[0]);   //мы - труба 0, открываем канал для передачи данных
  radio.setChannel(0x60);  //выбираем канал (в котором нет шумов!)

  radio.setPALevel (RF24_PA_MAX); //уровень мощности передатчика. На выбор RF24_PA_MIN, RF24_PA_LOW, RF24_PA_HIGH, RF24_PA_MAX
  radio.setDataRate (RF24_2MBPS); 

  radio.powerUp(); 
  radio.stopListening();  
  
}

void loop(void) {

     if (Serial.available()) {
     byte number = Serial.read();
     sendTo(number);
     }
//  static unsigned long timeLastReceive= 0;
//  if (Serial.available()) {
//     byte number = Serial.read();  
//     timeLastReceive = millis();
//     if (counter==0){ 
//        if(number>1){
//          sendTo(number);
//          counter = 0;
//          process = 0;
//          return;
//        }
//        else{
//          broadcast = (number==0) ? false : true;
//          if (number==1)counter++;
//        }
//        
//     }
//     else if (counter==1)currentId = number; 
//     else if (counter==2) command = number;
//     else if (counter==3){
//        items[0] = number;
//        if(command == 1 || command == 2 || command == 3 || command == 4 || command == 5 )process = true;
//     }
//     else if (counter==4){
//        items[1] = number;
//        if(command == 6)process = true;
//     }
//     else{
//        items[counter-3] = (byte)number;
//        if (counter==8) process = true;
//     }
//     
//     
//     if(!process)counter++;
//     else counter = 0;
//
//  }
//if(millis()-timeLastReceive>100){
//  counter = 0;
//
//}
//  
//
//  if(process){
//      
//      sendTo( broadcast ? 1:0);
//      delay(2);
//      if(!broadcast){ sendTo(currentId); delay(2); }
//      sendTo(command);
//      delay(2);
//      if(command == 1 || command == 2 || command == 3 || command == 4 || command == 5 )sendTo(items[0]);
//      else if(command == 6){
//        delay(2);
//        sendTo(items[0]);
//        delay(2);
//        sendTo(items[1]); 
//      }
//      else if(command == 7){
//        delay(2);
//        sendTo(items[0]);
//        delay(2);
//        sendTo(items[1]);
//        delay(2);
//        sendTo(items[2]);
//        delay(2);
//        sendTo(items[3]);
//        delay(2);
//        sendTo(items[4]);
//        delay(2);
//        sendTo(items[5]); 
//      }
//   process = false;
//      
//  }
  
  
        
}

void sendTo(byte number){
    radio.write(&number,1);
}
