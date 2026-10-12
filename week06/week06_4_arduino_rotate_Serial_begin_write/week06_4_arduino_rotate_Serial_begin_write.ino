// week06_4_arduino_rotate_Serial_begin_write
// 修改自 week06_2_arduino_button_change_mode_LED_flow

int mode = 0; // 0：從小變到大，1：從大變到小

void setup() {
  Serial.begin(9600);

  pinMode(2, INPUT_PULLUP);

  for (int i = 3; i <= 13; i++) {
    pinMode(i, OUTPUT);
  }

  tone(8, 523, 100);
  delay(100); // Do 發個聲音，提醒你程式式有在動
  tone(8, 784, 100);
  delay(100); // Mi
}

int prev = HIGH, now = 3;
// prev 是按鈕前一瞬間的狀態，now 現在要發亮的 LED

void loop() {
  if (prev == HIGH && digitalRead(2) == LOW) {
    // 按下去的瞬間

    if (mode == 0) {
      mode = 1; // 從 0 變 1

      tone(8, 784, 100);
      delay(100); // Mi

      tone(8, 523, 100);
      delay(100); // Do

    } else {
      mode = 0; // 從 1 變 0

      tone(8, 523, 100);
      delay(100); // Do

      tone(8, 784, 100);
      delay(100); // Mi
    }

    prev = LOW;

    // 你可以把前面 tone() 的 Do Mi 放這裡

    if (mode == 1) Serial.write('1');
    if (mode == 0) Serial.write('0');

  } else if (prev == LOW && digitalRead(2) == HIGH) {
    // 放開的瞬間
    prev = HIGH;

    // 你可以把前面 tone() 的 Mi Do 放這裡
  }

  if (mode == 0) {
    // 0：從小變到大
    now++;

    if (now > 13) now = 3; // 超過範圍，又變回 3

  } else {
    // 1：從大變到小
    now--;

    if (now < 3) now = 13;
  }

  // 你也可以把重覆的 digitalWrite() delay() digitalWrite() 放在外面
  digitalWrite(now, HIGH); // 亮
  delay(100);              // 等一下
  digitalWrite(now, LOW);  // 暗
}
