/***************************************************
  名前: 稲友祭2025「IT×ホラー×脱出ゲーム」
  問2：情報
****************************************************/

#include <HTTPClient.h>
#include <ArduinoOSCWiFi.h>

#include <SPI.h>
#include <MFRC522.h>

String ssid = "hopter_wifi";
String pwd = "hopter_1450";

const IPAddress ip(192, 168, 0, 205);
const IPAddress gateway(192, 168, 0, 1);
const IPAddress subnet(255, 255, 255, 0);

// OSC送信先（アプリ）
char oscAppHost[16] = "192.168.43.201";       //15文字+1文字(\0)
extern const int oscPort = 33333;

// リーダー1のピン定義
#define SS_PIN_1 5
#define RST_PIN_1 26

// リーダー2のピン定義
#define SS_PIN_2 25
#define RST_PIN_2 27

// リーダー3のピン定義
#define SS_PIN_3 21
#define RST_PIN_3 22

// MFRC522のインスタンスを作る
MFRC522 rfid_1(SS_PIN_1, RST_PIN_1);
MFRC522 rfid_2(SS_PIN_2, RST_PIN_2);
MFRC522 rfid_3(SS_PIN_3, RST_PIN_3);

String uids[3];

void setup()
{
  Serial.begin(9600);
  SPI.begin();
  rfid_1.PCD_Init();
  rfid_2.PCD_Init();
  rfid_3.PCD_Init();

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

  OscWiFi.subscribe(oscPort, "/rfid_confirm", onOscConfirmRFID);

  Serial.println("Initializing complete");
}

void loop() {

  OscWiFi.update();

  if (rfid_1.PICC_IsNewCardPresent() && rfid_1.PICC_ReadCardSerial())
  {
    Serial.println("リーダー1でカード検出");
    showCardInfo(rfid_1, 0);
  }

  if (rfid_2.PICC_IsNewCardPresent() && rfid_2.PICC_ReadCardSerial())
  {
    Serial.println("リーダー2でカード検出");
    showCardInfo(rfid_2, 1);
  }

  if (rfid_3.PICC_IsNewCardPresent() && rfid_3.PICC_ReadCardSerial())
  {
    Serial.println("リーダー3でカード検出");
    showCardInfo(rfid_3, 2);
  }

  delay(100);
}

void showCardInfo(MFRC522 &rfid, int index) {
  Serial.print("UID: ");
  String uid = "";
  for (byte i = 0; i < rfid.uid.size; i++)
  {
    uid += String(rfid.uid.uidByte[i], HEX);    
  }
  Serial.println(uid);

  uids[index] = uid;

  rfid.PICC_HaltA();
  rfid.PCD_StopCrypto1();
}

void onOscConfirmRFID(const OscMessage& m) {

  int idx = m.arg<int>(0);
  OscWiFi.send(oscAppHost, oscPort, "/uuid", uids[idx]);

  Serial.println("onOscConfirmRFID");

}