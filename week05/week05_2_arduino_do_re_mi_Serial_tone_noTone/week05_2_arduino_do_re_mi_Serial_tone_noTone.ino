// week05_2_arduino_do_re_mi_Serial_tone_noTone
// 修改自 week05_1_arduino_do_re_mi_Serial

void setup() {
  Serial.begin(9600); // USB Serial 開始傳輸，速度 9600 bps

  tone(8, 523, 100); delay(200); // Do
  tone(8, 587, 100); delay(200); // Re
  tone(8, 659, 100); delay(200); // Mi
  tone(8, 587, 100); delay(200); // Re
  tone(8, 523, 100); delay(200); // Do
}

void loop() {
  if (Serial.available()) { // 如果 USB Serial 有收到資料
    char c = Serial.read(); // 就讀進來

    if (c=='1') tone(8, 523, 100); // Do 0.1秒
    if (c=='2') tone(8, 587, 100); // Re 0.1秒
    if (c=='3') tone(8, 659, 100); // Mi 0.1秒
  }
}
