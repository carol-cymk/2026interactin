// week07_2_processing_audio_two_SoundFile
// 修改自 week07_1_processing_audio_SoundFile_play

import processing.sound.*;

SoundFile sound;
SoundFile sound2;

void setup() {
  size(300, 300);
  sound = new SoundFile(this, "music.mp3");
  sound2 = new SoundFile(this, "mi.wav");
  sound.play(); // 先播放其中一個音樂
}

void draw() {
}

void mousePressed() {
  sound2.play();
}
