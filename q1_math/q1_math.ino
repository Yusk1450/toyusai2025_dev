/***************************************************
  問1：数学
****************************************************/

#include <M5StickCPlus.h>

#include <HTTPClient.h>
#include <ArduinoOSCWiFi.h>

// 部屋番号（0 or 1）
#define ROOM_NUM 0

String ssid = "hopter_wifi";
String pwd = "hopter_1450";

const IPAddress ip(192, 168, 0, 205);
const IPAddress gateway(192, 168, 0, 1);
const IPAddress subnet(255, 255, 255, 0);

// OSC送信先（アプリ）
char oscAppHost[16] = "192.168.43.201";       //15文字+1文字(\0)
extern const int oscPort = 33333;

void setup()
{
  M5.begin();
  Serial.begin(9600);

  if (M5.Imu.Init() != 0)
  {
    Serial.println("IMU initialization failed!");
    while (1);
  }

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

  Serial.println("Initializing complete");
}

void loop() {
  OscWiFi.update();

  float accX, accY, accZ;
  M5.Imu.getAccelData(&accX, &accY, &accZ);

  float accMag = sqrt(accX * accX + accY * accY + accZ * accZ);
  Serial.printf("Magnitude: %.2f g\n", accMag);

  if (accMag > 0)
  {
    OscWiFi.send(oscAppHost, oscPort, "/accMag", ROOM_NUM);
  }

  delay(100);
}