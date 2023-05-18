#include <Arduino.h>
#include "DHT.h"      // DHT sensor library
#include "EmonLib.h"  // Include Emon Library
#include <WiFi.h>
#include <WiFiClient.h>
#include <WiFiManager.h>
#include "time.h"
#include <FirebaseESP32.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"
#include "ESP32_MailClient.h"

#define emailSenderAccount "severmonitoring@gmail.com"
#define emailSenderPassword "robtdfpacszpdtqa"
#define smtpServer "smtp.gmail.com"
#define smtpServerPort 465
#define emailSubject "[ALERT] Server Monitoring System"

#define API_KEY "AIzaSyAIfXgnvxRkAu8DyBoDNlFGBaFBhiQAY8M"
#define USER_EMAIL "testsms2@gmail.com"
#define USER_PASSWORD "testsms2@2023"
#define DATABASE_URL "sever-monitoring-system-default-rtdb.asia-southeast1.firebasedatabase.app"

// Default Recipient Email Address
String inputMessage = "10749896@students.plymouth.ac.uk";

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

String uid;

String voltPath = "/voltage";
String tempPath = "/temperature";
String humPath = "/humidity";
String smokePath = "/smoke";
String firePath = "/fire";
String vibPath = "/vibration";
String alarmPath = "/alarm";
String timePath = "/timeStamp";

int timestamp;

int timeout = 120;
int timeout_counter;
bool forceConfig = false;

FirebaseJson json;

#define CONNECTION_TIMEOUT 60

const char* ntpServer = "in.pool.ntp.org";
const long gmtOffset_sec = 19800;
const int daylightOffset_sec = 0;

EnergyMonitor emon;    // Create an instance
#define DHTPIN 13      // Digital pin connected to the DHT sensor
#define DHTTYPE DHT22  // DHT 22  (AM2302), AM2321
DHT dht(DHTPIN, DHTTYPE);
#define MQ2pin 33       //Digital pin connected to the smoke sensor
#define vs 27           // vibration sensor pin
#define fs 26           // Fire sensor pin
#define bz 25           // Buzzer pin
#define rst 18          // reset pin
float sensorValue;      //variable to store MQ2sensor value
bool smoke;
bool Alarm = false;     // varialble for buzzer
bool AlarmPre = false;
float Voltage;

float smoke_get;
float hum_get;
float tem_get;
float volH_get;
float volL_get;

const byte heartBeatLED = 2;
const byte warningLED = 4;

unsigned long sendDataPrevMillis = 0;
unsigned long timerDelay = 1000;

// Function that gets current epoch time
unsigned long getTime() {
  time_t now;
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) {
    //Serial.println("Failed to obtain time");
    return (0);
  }
  time(&now);
  return now;
}

void configModeCallback(WiFiManager* myWiFiManager)
// Called when config mode launched
{
  Serial.println("Entered Configuration Mode");

  Serial.print("Config SSID: ");
  Serial.println(myWiFiManager->getConfigPortalSSID());

  Serial.print("Config IP Address: ");
  Serial.println(WiFi.softAPIP());
}

SMTPData smtpData;

void setup() {
  Serial.begin(115200);

  WiFiManager wm;

  Serial.print("setup() running on core ");
  Serial.println(xPortGetCoreID());

  // WiFi.mode(WIFI_STA);  //Optional
  // wm.setConfigPortalBlocking(false);
  wm.setConfigPortalTimeout(60);

  bool res;

  res = wm.autoConnect("Server monitoring system");  // anonymous ap

  if (!res) {
    Serial.println("Failed to connect");
    // ESP.restart();
  } else {
    //if you get here you have connected to the WiFi
    Serial.println("connected...yeey :)");
    Serial.print("ESP32 IP: ");
    Serial.println(WiFi.localIP());
    delay(1000);
  }

  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(200);
    timeout_counter++;
    if (timeout_counter >= CONNECTION_TIMEOUT * 5) {
      ESP.restart();
    }
  }

  Serial.println("\nConnected to the WiFi network");
  Serial.print("Local ESP32 IP: ");
  Serial.println(WiFi.localIP());


  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);
  //printLocalTime();

  config.api_key = API_KEY;

  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  config.database_url = DATABASE_URL;

  Firebase.reconnectWiFi(true);
  fbdo.setResponseSize(4096);

  config.token_status_callback = tokenStatusCallback;

  config.max_token_generation_retry = 5;

  Firebase.begin(&config, &auth);

  // Serial.println("Getting User UID");
  // while ((auth.token.uid) == "") {
  //   Serial.print('.');
  //   delay(1000);
  // }

  uid = auth.token.uid.c_str();
  Serial.print("User UID: ");
  Serial.println(uid);


  pinMode(vs, INPUT);
  pinMode(fs, INPUT);
  pinMode(bz, OUTPUT);
  pinMode(heartBeatLED, OUTPUT);
  pinMode(warningLED, OUTPUT);
  pinMode(rst, INPUT_PULLDOWN);
  dht.begin();
  emon.voltage(35, 1000, 1.7);  // Voltage: input pin, calibration, phase_shift
  Serial.println("MQ2 warming up!");
  bool alarm = false;
  delay(20000);  // allow the MQ2 to warm up
}

void loop() {

  Serial.print("loop() running on core ");
  Serial.println(xPortGetCoreID());

  forceConfig = digitalRead(rst);

  if (forceConfig) {
    WiFiManager wm;

    //reset settings - for testing
    //wm.resetSettings();

    // set configportal timeout
    // wm.setConfigPortalTimeout(timeout);
    // wm.setAPCallback(configModeCallback);

    if (!wm.startConfigPortal("Server monitoring system")) {
      Serial.println("failed to connect and hit timeout");
      delay(3000);
      //reset and try again, or maybe put it to deep sleep
      ESP.restart();
      delay(5000);
    }

    //if you get here you have connected to the WiFi
    Serial.println("connected...yeey :)");
    //wifi_ap = false;
  }

  if (Firebase.ready() && (millis() - sendDataPrevMillis > timerDelay || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();

    if (Firebase.RTDB.getInt(&fbdo, "/get/mail")) {

      inputMessage = fbdo.stringData();
    } else {
      Serial.println(fbdo.errorReason());
    }
    if (Firebase.RTDB.getInt(&fbdo, "/get/smoke")) {

      smoke_get = fbdo.floatData();
    } else {
      Serial.println(fbdo.errorReason());
    }

    if (Firebase.RTDB.getInt(&fbdo, "/get/hum")) {

      hum_get = fbdo.floatData();

    } else {
      Serial.println(fbdo.errorReason());
    }

    if (Firebase.RTDB.getInt(&fbdo, "/get/tem")) {

      tem_get = fbdo.floatData();

    } else {
      Serial.println(fbdo.errorReason());
    }

    if (Firebase.RTDB.getInt(&fbdo, "/get/volH")) {

      volH_get = fbdo.floatData();

    } else {
      Serial.println(fbdo.errorReason());
    }

    if (Firebase.RTDB.getInt(&fbdo, "/get/volL")) {

      volL_get = fbdo.floatData();

    } else {
      Serial.println(fbdo.errorReason());
    }

    //printLocalTime();
    timestamp = getTime();
    Serial.print("time: ");
    Serial.println(timestamp);
    Serial.print("email: ");
    Serial.println(inputMessage);


    if (Alarm == true) {
      digitalWrite(heartBeatLED, 1);
      digitalWrite(warningLED, !digitalRead(warningLED));
    } else {
      digitalWrite(warningLED, 1);
      digitalWrite(heartBeatLED, !digitalRead(heartBeatLED));
    }
    int measurementV = vibration();
    bool measurementF = fire();
    emon.calcVI(20, 2000);               // Calculate all. No.of half wavelengths (crossings), time-out
    sensorValue = analogRead(MQ2pin);  // read analog input pin 14
    Voltage = (emon.Vrms);
    Serial.print("Vrms: ");
    Serial.print(Voltage);
    Serial.print("V");
    Serial.print(F("%  , "));
    Serial.println(volL_get);
    Serial.print(F("%  , "));
    Serial.println(volH_get);

    // Read Humidity
    float h = dht.readHumidity();
    // Read temperature as Celsius (the default)
    float t = dht.readTemperature();
    // Read temperature as Fahrenheit (isFahrenheit = true)
    float f = dht.readTemperature(true);

    // Check if any reads failed and exit early (to try again).
    if (isnan(h) || isnan(t) || isnan(f)) {
      Serial.println(F("Failed to read from DHT sensor!"));
      return;
    }

    // Compute heat index in Fahrenheit (the default)
    float hif = dht.computeHeatIndex(f, h);
    // Compute heat index in Celsius (isFahreheit = false)
    float hic = dht.computeHeatIndex(t, h, false);

    Serial.print(F("Humidity: "));
    Serial.print(h);
    Serial.print(F("%  , "));
    Serial.println(hum_get);
    Serial.print(F("%  Temperature: "));
    Serial.print(t);
    Serial.print(F("°C "));
    Serial.print(F("%  , "));
    Serial.println(tem_get);

    Serial.print("MQ2 Sensor Value: ");
    Serial.print(sensorValue);
    Serial.print(F("%  , "));
    Serial.println(smoke_get);

    if (sensorValue > smoke_get) {
      Serial.print(" | Smoke detected!");
      smoke = true;
    } else {
      Serial.print(" | No Smoke detected!");
      smoke = false;
    }


    Serial.println("");
    Serial.print("Vibration Sensor Value: ");
    Serial.println(measurementV);
    Serial.print("Fire Sensor Value: ");
    Serial.println(measurementF);
    Serial.print("Alarm Value: ");
    Serial.println(Alarm);

    if (Voltage < volL_get || Voltage > volH_get || h > hum_get || t > tem_get || sensorValue > smoke_get || measurementV == 1 || measurementF == 1) {
      Alarm = true;
    } else {
      Alarm = false;
    }

    if (Alarm == true) {
      digitalWrite(bz, 1);
    } else {
      digitalWrite(bz, 0);
    }

    if (Alarm == true && AlarmPre == false) {
      String emailMessage = String("<div style=\"color:#2f4468;\"><h1>Server Monitoring System Alert !</h1>");
      if (Voltage < volL_get) {
        emailMessage = emailMessage + String("<p>Low Voltage - ") + String(Voltage) + String("V") + String("</p>");
      
      }
      if (Voltage > volH_get) {
         emailMessage =  emailMessage + String("<p>High Voltage - ") + String(Voltage) + String("V") + String("</p>");
        
      }
      if (h > hum_get) {
         emailMessage = emailMessage + String("<p>High Humidity - ") + String(h) + String("%") + String("</p>");
        
      }
      if (t > tem_get) {
         emailMessage = emailMessage + String("<p>High Temperature - ") + String(t) + String("c") + String("</p>");
        
      }
      if (sensorValue > smoke_get) {
         emailMessage = emailMessage + String("<p>Smoke Detected - ") + String(sensorValue) + String("ppm") + String("</p>");
        
      }
      if (measurementV == 1) {
         emailMessage = emailMessage + String("<p>Vibration Detected - ") + String(measurementV) + String("</p>");
        
      }
      if (measurementF == 1) {
         emailMessage = emailMessage + String("<p>Fire Detected - ") + String(measurementF) + String("</p>");
        
      }
      emailMessage = emailMessage + String("</div>");
      if (sendEmailNotification(emailMessage)) {
          Serial.println("Email Alert have sent");
        } else {
          Serial.println("Email failed to send");
        }
        delay(500);
    }

    json.set(voltPath, Voltage);
    json.set(tempPath, t);
    json.set(humPath, h);
    json.set(smokePath, smoke);
    json.set(firePath, measurementF);
    json.set(vibPath, measurementV);
    json.set(alarmPath, Alarm);
    json.set(timePath, timestamp);
    Serial.printf("push json... %s\n", Firebase.pushJSON(fbdo, "/sensor_1_data", json) ? "ok" : fbdo.errorReason().c_str());
    Serial.printf("Set json... %s\n", Firebase.setJSON(fbdo, "/set", json) ? fbdo.to<FirebaseJson>().raw() : fbdo.errorReason().c_str());

  }
  AlarmPre = Alarm;
}

int vibration() {
  int measurementV = digitalRead(vs);
  return measurementV;
}
bool fire() {
  bool measurementF = (!digitalRead(fs));
  return measurementF;
}

bool sendEmailNotification(String emailMessage) {
  // Set the SMTP Server Email host, port, account and password
  smtpData.setLogin(smtpServer, smtpServerPort, emailSenderAccount, emailSenderPassword);

  // For library version 1.2.0 and later which STARTTLS protocol was supported,the STARTTLS will be
  // enabled automatically when port 587 was used, or enable it manually using setSTARTTLS function.
  //smtpData.setSTARTTLS(true);

  // Set the sender name and Email
  smtpData.setSender("Server Monitoring System", emailSenderAccount);

  // Set Email priority or importance High, Normal, Low or 1 to 5 (1 is highest)
  smtpData.setPriority("High");

  // Set the subject
  smtpData.setSubject(emailSubject);

  // Set the message with HTML format
  smtpData.setMessage(emailMessage, true);

  // Add recipients
  smtpData.addRecipient(inputMessage);

  smtpData.setSendCallback(sendCallback);

  // Start sending Email, can be set callback function to track the status
  if (!MailClient.sendMail(smtpData)) {
    Serial.println("Error sending Email, " + MailClient.smtpErrorReason());
    return false;
  }
  // Clear all data from Email object to free memory
  smtpData.empty();
  return true;
}

// Callback function to get the Email sending status
void sendCallback(SendStatus msg) {
  // Print the current status
  Serial.println(msg.info());

  // Do something when complete
  if (msg.success()) {
    Serial.println("----------------");
  }
}
