// week06_1_arduino_pin_2_button_INPUT_PULLUP

void setup() {
  pinMode(2, INPUT_PULLUP); // 預設 pin 2 是 Button
  pinMode(8, OUTPUT); // 預設 pin 8 是 Buzzer 喇叭
}

void loop() {
  if (digitalRead(2) == LOW) {
    tone(8, 523, 100); // 0.1 秒
    delay(100); // 等一下（讓聲音夠長）
  }
}
