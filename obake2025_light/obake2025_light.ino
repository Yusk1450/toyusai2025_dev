/***************************************************
  名前: 稲友祭2025「IT×お化け屋敷」照明
****************************************************/
#include <ArduinoJson.h>

#include <HTTPClient.h>
#include <ArduinoOSCWiFi.h>

#define LIGHT_1_PIN 26
#define LIGHT_2_PIN 27

String ssid = "hopter_wifi";
String pwd = "hopter_1450";

const IPAddress ip(192, 168, 0, 205);
const IPAddress gateway(192, 168, 0, 1);
const IPAddress subnet(255, 255, 255, 0);

extern const int oscPort = 33333;

void setup()
{
  Serial.begin(9600);

  pinMode(LIGHT_1_PIN, OUTPUT);
  pinMode(LIGHT_2_PIN, OUTPUT);

  #ifdef ESP_PLATFORM
    WiFi.disconnect(true, true);  // disable wifi, erase ap info
    delay(1000);
    WiFi.mode(WIFI_STA);
  #endif
    WiFi.begin(ssid.c_str(), pwd.c_str());
    WiFi.config(ip, gateway, subnet);

    Serial.println("Wifi Connecting");
    while (WiFi.status() != WL_CONNECTED) {
      delay(150);
      Serial.println(".");
    }

    OscWiFi.subscribe(oscPort, "/light_on", onOscLightOn);
    OscWiFi.subscribe(oscPort, "/light_off", onOscLightOff);

    Serial.println("Initializing complete");
}

void loop()
{
  OscWiFi.update();
}

void onOscLightOn(const OscMessage& m) {
  digitalWrite(LIGHT_1_PIN, HIGH);
  digitalWrite(LIGHT_2_PIN, HIGH);
}

void onOscLightOff(const OscMessage& m) {
  digitalWrite(LIGHT_1_PIN, LOW);
  digitalWrite(LIGHT_2_PIN, LOW);
}

