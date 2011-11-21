//Jeremy Blum's Arduino Tutorial Series - Episode 12 - RFID Cards
//Sample Code - RFID Code Reading
//http://www.jeremyblum.com
//Some Code Adapted from http://www.cooking-hacks.com

 byte data[5];  //For holding the ID we receive
 int val = 0;
 byte jeremy[5] = {0x3E,0x00,0xFC,0xBD,0x88};
 byte david[5]  = {0x3E,0x00,0xFC,0xFF,0xA5};

 void setup()
 {
   // Start serial port 19200 bps
   Serial.begin(19200);
   
   // Setting Auto Read Mode - EM4102 Decoded Mode - No password
   // command: FF 01 09 87 01 03 02 00 10 20 30 40 37
   Serial.print(0xFF,BYTE);  //Header
   Serial.print(0x01,BYTE);  //Reserved
   Serial.print(0x09,BYTE);  //Length (Command + Data)
   Serial.print(0x87,BYTE);  //Command (0x87 sets auto mode behavior
   Serial.print(0x01,BYTE);  //Data 1: Enable Auto-Read
   Serial.print(0x03,BYTE);  //Data 2: Mode – Parity decoded – Manchester RF/64
   Serial.print(0x02,BYTE);  //Data 3: Total number of block to be read (2)
   Serial.print(0x00,BYTE);  //Data 4: No password expected
   Serial.print(0x10,BYTE);  //Data 5: Password byte 1
   Serial.print(0x20,BYTE);  //Data 6: Password byte 2
   Serial.print(0x30,BYTE);  //Data 7: Password byte 3
   Serial.print(0x40,BYTE);  //Data 8: Password byte 4
   Serial.print(0x37,BYTE);  //Checksum
   
   delay(500);
   Serial.flush();
   Serial.println();
   Serial.println("RFID module started in Auto Read Mode, Waiting for Card...");
 }

 void loop()
 {
 
   val = Serial.read();
   while (val != 0xff)
   {  //On Successful read, first byte will always be 0xFF
      val = Serial.read();
      delay(1000);
   }
   
   //we already read the header (0xff)
   Serial.read();              // reserved
   Serial.read();              // length
   Serial.read();              // command (indicates tag data)
   data[0] = Serial.read();    // we read data 1
   data[1] = Serial.read();    // we read data 2
   data[2] = Serial.read();    // we read data 3
   data[3] = Serial.read();    // we read data 4
   data[4] = Serial.read();    // we read data 5
   Serial.read();              // checksum
   
   // Indentify RFID Card
   boolean j_card = true;
   boolean d_card = true;
   Serial.print("Card found - Code: ");
   for (int i=0; i<5; i++)
   {
     if (data[i] < 16) Serial.print("0");
     Serial.print(data[i], HEX);
      
     //cross-check
     if (data[i] != jeremy[i]) j_card = false;
     if (data[i] != david[i]) d_card = false;
   }
   Serial.println();
   
   if (j_card) Serial.println("Hello Jeremy!");
   else if (d_card) Serial.println("Hello David!");
   else Serial.println("Not Recognized!  Get out of Here!");
   Serial.println();
 }
