//***** Configuracion del display *******
#include <LCD4Bit_mod.h> 
LCD4Bit_mod lcd = LCD4Bit_mod(2); 
//***** Configuracion del teclado *****
int  adc_key_val[5] ={30, 150, 360, 535, 760 };
int NUM_KEYS = 5;
int adc_key_in;
int key=-1;
int oldkey=-1;
boolean aut=false;

float sat,mag;
int imag,isat;
char strip[16];
char demo;
void setup()
{
  Serial.begin(4800);
  pinMode(13, OUTPUT);  //we'll use the debug LED to output a heartbeat
  lcd.init();
  lcd.clear();
  lcd.printIn("C.M.I. Emulator");
  lcd.cursorTo(2, 0);
  lcd.printIn("JMQ Software '10");
  delay(2000);
  lcd.cursorTo(2, 0);
  lcd.printIn("www.escainet.es    ");
  delay(3000);
  
  lcd.clear();
  lcd.cursorTo(1, 0);
  lcd.printIn("C.M.I. Emulator");
  sat=0.7;
  mag=0.3;
}

void loop()
{
  //delay(500);
  //lcd.clear();
  lcd.cursorTo(2, 0);
   int mag1 = (mag - (int)mag) * 100;
   // sprintf(ascii,"The Value is: %0d.%d", (int)temp, temp1);

 sprintf(strip, "  RA=%d RS=%d    \0",(int)mag,(int)sat);
//demo=(char)mag;

if (aut==false){
    sat=sat + 0.7;
    if (sat>360){
        sat=0.7;
    }
     mag=mag + 0.9;
    if (mag>360){
        mag=0.7;
    }
}

  lcd.printIn(strip);
  printMag(mag);
 // delay(500);
  printSat(sat);
 // delay(500);
 
 
 
 
  delay(50);
  adc_key_in = analogRead(0);    // read the value from the sensor  
    key = get_key(adc_key_in);		        // convert into key press
    if (key != oldkey)				
    {			
     // oldkey = key;
      switch (key) {
        case 0:
            sat=sat + 0.7;
            aut=true;
            if (sat>360){
              sat=0.7; 
            }
            break;
        case 1:
            sat=sat - 0.7;
            aut=true;
            if (sat<0){
              sat=359.3;
            }
            break;
        case 2:
           mag=mag + 0.9;
           aut=true;
            if (mag>360){
              mag=0.7;
            }
            break;
        case 3:
           mag=mag - 0.9;
           aut=true;
            if (mag<0){
              mag=359.2;
            }
            break;    
      }
    }
  
    printGGA();
    printGPGSV();
    printGPHDT(sat);
    
    
  
}



void printMag(float rumbo){
Serial.print("$HCHDG,");
Serial.print(rumbo);
Serial.print(",,,");
Serial.println();
delay(100);
}

void printSat(float rumbo){
  //$GPHDT,186.1801,,,*3T
Serial.print("$GPHDT,");
Serial.print(rumbo);
Serial.print(",,,*3T");
Serial.println();
delay(100);
}


void printGGA(){
    delay(100);
    Serial.println("$GPGGA,152834.34,4124.8963,N,08151.6838,W,1,05,1.5,10.5,M,-34.0,M,,*75");
  //  Serial.println("$GPGLL,4916.45,N,12311.12,W,225444,A");
  //  Serial.println("$GPRMA,A,llll.ll,N,lllll.ll,W,,,ss.s,ccc,vv.v,W*hh");
}

void printGPGSV(){
 //   delay(100);
 //   Serial.println("$GPGSV,3,1,11,03,03,111,00,04,15,270,00,06,01,010,00,13,06,292,00*74");
 //   Serial.println("$GPGSA,A,3,19,28,14,18,27,22,31,39,,,,,1.7,1.0,1.3*35");
}

void printGPHDT(float rumbo){
    delay(100);
    Serial.print("$GPHDT,");
    Serial.print(rumbo);
    Serial.println(",T" );
}



// Convert ADC value to key number
int get_key(unsigned int input)
{
	int k;
	for (k = 0; k < NUM_KEYS; k++)
	{
		if (input < adc_key_val[k])
		    {      
                      return k;
                    }
	}
    
    if (k >= NUM_KEYS)
        k = -1;     // No valid key pressed
    
    return k;
}


/*

	if (key != oldkey)				    // if keypress is detected
	{
    delay(50);		// wait for debounce time
    adc_key_in = analogRead(0);    // read the value from the sensor  
    key = get_key(adc_key_in);		        // convert into key press
    if (key != oldkey)				
    {			
      oldkey = key;
      switch (key) {
        case 0:
            lcd.clear();
            lcd.cursorTo(1, 0);
            lcd.printIn("Gateway IP:");
            lcd.cursorTo(2, 0);
            //strip=ipAddr[0]; 
            sprintf(strip, "%d.%d.%d.%d\0", gatewayAddr[0], gatewayAddr[1], gatewayAddr[2], gatewayAddr[3]);
            lcd.printIn(strip);
            break;
        case 1:
            lcd.clear();
            lcd.cursorTo(1, 0);
            lcd.printIn("DNS Primario:");
            lcd.cursorTo(2, 0);
            //strip=ipAddr[0];
            sprintf(strip, "%d.%d.%d.%d\0", dnsAddr[0], dnsAddr[1], dnsAddr[2], dnsAddr[3]);
            lcd.printIn(strip);
            break;
        case 2:
             lcd.clear();
            lcd.cursorTo(1, 0);
            lcd.printIn("Direccion IP:");
            lcd.cursorTo(2, 0);
            sprintf(strip, "%d.%d.%d.%d\0", ipAddr[0], ipAddr[1], ipAddr[2], ipAddr[3]);
            lcd.printIn(strip);
            break;
        
      }
      
    }
  }
*/
