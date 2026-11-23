//arduino 期中鋼琴
// 整合 7 個音符 Arduino 控制程式
// 音階 LED 腳位對應：Pin 7 (Do) ~ Pin 13 (Ti)
const int buzzerPin = 8; // 蜂鳴器接在 Pin 6，避免與 Pin 8 的 LED 衝突

// C5 算起 7 個標準音符頻率 (Hz)
int frequencies[] = {
  523, // 1: Do  (C5)
  587, // 2: Re  (D5)
  659, // 3: Mi  (E5)
  698, // 4: Fa  (F5)
  784, // 5: Sol (G5)
  880, // 6: La  (A5)
  988  // 7: Ti  (B5)
};

char lastChar = '0'; // 記錄上一次收到的指令，避免重複觸發閃爍

void setup() {
  pinMode(buzzerPin, OUTPUT);

  // 初始化 Pin 7 ~ Pin 13 作為 LED 腳位 (對應音符 1 ~ 7)
  for (int i = 7; i <= 13; i++) {
    pinMode(i, OUTPUT);
  }

  Serial.begin(9600); // USB Serial 傳輸，速率 9600 bps

  // 開機開場音 (Do Re Mi Fa Sol La Ti)
  for (int i = 0; i < 7; i++) {
    tone(buzzerPin, frequencies[i], 80);
    delay(120);
  }
}
void loop() {
  if (Serial.available() > 0) {
    char c = Serial.read();

    // 只有當收到的字元與上一次不同時才更新狀態
    if (c != lastChar) {
      lastChar = c;

      // 先熄滅所有 LED
      for (int i = 9; i <= 13; i++) {
        //digitalWrite(i, LOW);
      }

      if (c >= '1' && c <= '6') {
        int index = c - '1';                 // 轉為 0 ~ 6 陣列索引
        tone(buzzerPin, frequencies[index]); // 持續發出該音階聲音
        //digitalWrite(9 + index, HIGH);       // 點亮對應 LED
      } else {
        noTone(buzzerPin);                   // 收到 '0' 或其他字元時靜音
      }
    }
  }
}
