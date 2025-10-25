unsigned long nextMillis = 0;

void br_lamp() {

  if (nextMillis > millis())
  {
    return;
  }

  nextMillis = millis() + random(50, 3000);
  
//  delay(random(50, 3000));

  FastLED.setBrightness(0);
  for (int n = 0; n < NUM_LEDS; n++) {
    leds[n] = CRGB::White;
  }

  for (int n = 0; n < 6; n++) {
    FastLED.setBrightness(n * 10);
    FastLED.show();
    delay(35);
  }

  delay(100);
  for (int n = 0; n < NUM_LEDS; n++) {
    leds[n] = CRGB::Black;
  }
  FastLED.show();

  delay(100);
  for (int n = 0; n < NUM_LEDS; n++) {
    leds[n] = CRGB::White;
  }
  FastLED.show();

  for (int i = 50; i > 0; i -= 5) {
    for (int n = 0; n < NUM_LEDS; n++) {
      FastLED.setBrightness(i);
    }
    delay(35);
    FastLED.show();
  }

  for (int n = 0; n < NUM_LEDS; n++) {
    leds[n] = CRGB::Black;
    FastLED.setBrightness(32);
  }


  leds[0].setRGB(255, 77, 0);
  leds[1].setRGB(255, 77, 0);
  leds[57] = CRGB::White;

  leds[60].setRGB(255, 77, 0);
  leds[61].setRGB(255, 77, 0);
  leds[117] = CRGB::White;

  leds[120].setRGB(255, 77, 0);
  leds[121].setRGB(255, 77, 0);
  leds[177] = CRGB::White;

  leds[180].setRGB(255, 77, 0);
  leds[181].setRGB(255, 77, 0);
  leds[237] = CRGB::White;

  leds[240].setRGB(255, 77, 0);
  leds[241].setRGB(255, 77, 0);
  leds[297] = CRGB::White;

  leds[300].setRGB(255, 77, 0);
  leds[301].setRGB(255, 77, 0);
  leds[357] = CRGB::White;

  for (int i = 0; i < 20; i += 3) {
    for (int n = 0; n < NUM_LEDS; n++) {
      FastLED.setBrightness(i);
    }
    delay(35);
    FastLED.show();
  }


  for (int n = 1; n < NUM_LEDS; n++) {
    leds[n] = CRGB::Black;
    FastLED.setBrightness(32);
  }

  leds[0].setRGB(255, 77, 0);
  leds[1].setRGB(255, 77, 0);
  leds[57] = CRGB::White;

  leds[60].setRGB(255, 77, 0);
  leds[61].setRGB(255, 77, 0);
  leds[117] = CRGB::White;

  leds[120].setRGB(255, 77, 0);
  leds[121].setRGB(255, 77, 0);
  leds[177] = CRGB::White;

  leds[180].setRGB(255, 77, 0);
  leds[181].setRGB(255, 77, 0);
  leds[237] = CRGB::White;

  leds[240].setRGB(255, 77, 0);
  leds[241].setRGB(255, 77, 0);
  leds[297] = CRGB::White;

  leds[300].setRGB(255, 77, 0);
  leds[301].setRGB(255, 77, 0);
  leds[357] = CRGB::White;

  for (int i = 20; i > 0; i -= 3) {
    for (int n = 0; n < NUM_LEDS; n++) {
      FastLED.setBrightness(i);
    }
    delay(40);
    FastLED.show();
  }

  delay(40);


  for (int n = 0; n < NUM_LEDS; n++) {
    leds[n] = CRGB::Black;
    FastLED.setBrightness(32);
    FastLED.show();
  }
}
