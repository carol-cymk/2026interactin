// week09_2_arduino_ai_PCM_D8_laser_powerUp_siren
// 想要發出更特別的聲音，有滑音

// Q5：剛剛的 week09_1_ai_makerUNO_PCM_D8 修改自我的 MakerUNO_PCM_D8.zip 成功了
// 現在想做 week09_2，想要有比較精彩、好聽、有變化的聲音，而且希望聲音比剛剛大一些。
// 請給我建議
// week09_2: Maker UNO built-in D8 piezo PCM sound-effects demo.
// week09_2：Maker UNO 內建 D8 蜂鳴器 PCM 音效示範。
// Board: Arduino Uno / ATmega328P, 16 MHz. BUZZER switch: ON.
// 開發板：Arduino Uno / ATmega328P，16 MHz。蜂鳴器開關：ON。
// Keep PCM.cpp, PCM.h, sounddata.h in this same sketch folder.
// 請將 PCM.cpp、PCM.h、sounddata.h 放在同一個程式資料夾。
#include "PCM.h"
#include "sounddata.h"
// 播放 PCM 音效
void playClip(const unsigned char* data, int sampleCount) {
  startPlayback(data, sampleCount);
  // 8 kHz PCM；此版本使用 Timer1，因此 delay() 仍然可以執行
  delay((unsigned long)sampleCount / 8 + 25);
  stopPlayback();
}
void setup() {
  pinMode(8, OUTPUT);       // 設定 pin 8 為輸出
  digitalWrite(8, LOW);     // 初始設定為低電位
}
void loop() {
  playClip(laser_data, laser_length);
  // falling laser swoosh：雷射下降滑音
  delay(220);

  playClip(powerup_data, powerup_length);
  // four rising arcade notes：四個逐漸升高的遊戲音符
  delay(220);

  playClip(siren_data, siren_length);
  // warbling sci-fi siren：科幻警報器的波動音
  delay(1500);

}
