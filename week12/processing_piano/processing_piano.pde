import processing.serial.*;
import processing.sound.*;

Serial myPort;
SoundFile[] notes = new SoundFile[7];

// 音階名稱
String[] noteNames = {"Do", "Re", "Mi", "Fa", "Sol", "La", "Ti"};

// 對應數字 1～7
String[] noteNumbers = {"1", "2", "3", "4", "5", "6", "7"};

int activeKey = -1;  // 目前按下的琴鍵索引

void setup() {
  size(700, 320);
  textAlign(CENTER, CENTER);
  textSize(24);

  // 1. 列出可用序列埠並連接 Arduino
  printArray(Serial.list());

  // 請依照實際 Arduino 序列埠調整
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);

  // 2. 載入 7 個音階音效檔
  for (int i = 0; i < 7; i++) {
    String fileName = (i + 1) + ".mp3";

    if (dataFile(fileName).exists()) {
      notes[i] = new SoundFile(this, fileName);
    } else {
      println("提醒：找不到音檔 " + fileName);
    }
  }
}


// 繪製鋼琴畫面
void draw() {
  background(30);

  float keyWidth = width / 7.0;

  for (int i = 0; i < 7; i++) {

    // 按下時琴鍵變色，未按下時為白色
    if (i == activeKey) {
      fill(20, 184, 166);
    } else {
      fill(255);
    }

    stroke(40);
    strokeWeight(2);

    // 繪製琴鍵
    rect(i * keyWidth, 0, keyWidth, height, 0, 0, 8, 8);

    // 顯示音階名稱
    fill(i == activeKey ? 255 : 30);
    text(noteNames[i],
         i * keyWidth + keyWidth / 2,
         height - 70);

    // 顯示對應數字 1～7
    textSize(16);
    text(noteNumbers[i],
         i * keyWidth + keyWidth / 2,
         height - 35);

    textSize(24);
  }
}


// 觸發指定琴鍵
void triggerNote(int keyIndex) {

  if (keyIndex >= 0 && keyIndex < 7 && activeKey != keyIndex) {

    activeKey = keyIndex;

    // 播放對應音效
    if (notes[keyIndex] != null) {
      notes[keyIndex].play();
    }

    // 傳送數字 1～7 給 Arduino
    char serialChar = char('1' + keyIndex);
    myPort.write(serialChar);

    println("播放音階：" + noteNames[keyIndex]);
    println("傳送指令：" + serialChar);
  }
}


// 停止發聲與恢復琴鍵
void stopNote() {

  activeKey = -1;

  // 傳送 0 給 Arduino，停止蜂鳴器
  myPort.write('0');
}


// 滑鼠按下
void mousePressed() {

  int keyIndex = int(mouseX / (width / 7.0));

  triggerNote(keyIndex);
}


// 滑鼠放開
void mouseReleased() {

  stopNote();
}


// 鍵盤按下 1～7
void keyPressed() {

  if (key >= '1' && key <= '7') {

    int keyIndex = key - '1';

    triggerNote(keyIndex);
  }
}


// 鍵盤放開
void keyReleased() {

  if (key >= '1' && key <= '7') {

    stopNote();
  }
}
