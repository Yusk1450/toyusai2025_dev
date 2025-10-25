#include <FastLED.h>

#define DATA_PIN 16

#define NUM_LEDS 60
CRGB leds[NUM_LEDS];

void setup()
{
  Serial.begin(9600);
  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS);

  white_lamp();
}

void loop()
{
  // br_lamp();
}

void white_lamp(){
  for(int n = 0; n < NUM_LEDS; n++) {
    FastLED.setBrightness(60);
      leds[n].setRGB(180, 180, 180);
   }
   FastLED.show();
}
