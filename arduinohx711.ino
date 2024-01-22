#include <SoftwareSerial.h>
#include "HX711.h"
#include <Wire.h>
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2); // I2C address 0x27, 16 column and 2 rows


 
#define LOADCELL_DOUT_PIN  3
#define LOADCELL_SCK_PIN  2
 
HX711 scale;
SoftwareSerial hc05(4,5);
float calibration_factor = -288; //-7050 this variable to be adjusted according to ths weight sensor
 
void setup() {
  hc05.begin(9600);
  Serial.begin(9600);
  Serial.println("HX711 calibration sketch");
  Serial.println("Remove all weight from scale");
  Serial.println("After readings begin, place known weight on scale");
  Serial.println("Press + or a to increase calibration factor");
  Serial.println("Press - or z to decrease calibration factor");
 
  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);
  scale.set_scale();
  scale.tare(); //Reset the scale to 0
 
  long zero_factor = scale.read_average(); //Get a baseline reading
  Serial.print("Zero factor: "); //This can be used to remove the need to tare the scale. Useful in permanent scale projects.
  Serial.println(zero_factor);
  lcd.init(); // initialize the lcd
  lcd.backlight();
}
 
void loop() {
  scale.set_scale(calibration_factor);
  float weight = scale.get_units();
  
  Serial.print("Reading: ");
  Serial.print(weight, 1);
  hc05.print(weight, 1);
  Serial.print(" lbs");
  Serial.print(" calibration_factor: ");
  Serial.print(calibration_factor);
  Serial.println();

  // Update the LCD with the weight information
  // Update the LCD with the weight information
  lcd.clear();                 // clear display
  lcd.setCursor(0, 0);         // move cursor to   (0, 0)
  lcd.print("Weight in grams:");        // print message at (0, 0)
  lcd.setCursor(2, 1);         // move cursor to   (2, 1)
  lcd.print(weight, 1);
  if (Serial.available()) {
    char temp = Serial.read();
    if (temp == '+' || temp == 'a')
      calibration_factor += 10;
    else if (temp == '-' || temp == 'z')
      calibration_factor -= 10;
  }
  delay(1000);
}
