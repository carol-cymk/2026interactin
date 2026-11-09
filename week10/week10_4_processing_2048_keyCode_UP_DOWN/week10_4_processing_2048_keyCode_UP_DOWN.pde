// week10_4_processing_2048_keyCode_UP_DOWN
// 修改自 week10_3_processing_2048_keyCode_LEFT_UP_DOWN
// 使用鍵盤上下左右方向鍵控制方塊移動

void setup() {
  size(550, 550);
  genNewBlock();
}

// 建立4x4的二維陣列，初始值都是0
int[][] a = new int[4][4];

// 產生新的數字方塊
void genNewBlock() {
  int zeros = 0;

  // 計算目前空白格子的數量
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (a[i][j] == 0) zeros++;
    }
  }

  // 如果沒有空格，就不再產生新方塊
  if (zeros == 0) return;

  // 隨機選擇一個空白位置
  int choose = int(random(zeros));

  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (a[i][j] == 0) {
        if (choose == 0) a[i][j] = 2;
        choose--;
      }
    }
  }
}

// 鍵盤控制功能
void keyPressed() {

  if (keyCode == RIGHT) { // 右鍵往右
    for (int i = 0; i < 4; i++) {
      int j2 = 3; // 最右邊的格子

      for (int j = 3; j >= 0; j--) {
        if (a[i][j] > 0) {
          int temp = a[i][j2];
          a[i][j2] = a[i][j];
          a[i][j] = temp;
          j2--;
        }
      }
    }
  }

  else if (keyCode == LEFT) { // 左鍵往左
    for (int i = 0; i < 4; i++) {
      int j2 = 0; // 最左邊的格子

      for (int j = 0; j < 4; j++) {
        if (a[i][j] > 0) {
          int temp = a[i][j2];
          a[i][j2] = a[i][j];
          a[i][j] = temp;
          j2++;
        }
      }
    }
  }

  else if (keyCode == UP) { // 上鍵往上
    for (int j = 0; j < 4; j++) { // 先選擇每一欄
      int i2 = 0; // 最上面的格子

      for (int i = 0; i < 4; i++) {
        if (a[i][j] > 0) {
          int temp = a[i2][j];
          a[i2][j] = a[i][j];
          a[i][j] = temp;
          i2++;
        }
      }
    }
  }

  else if (keyCode == DOWN) { // 下鍵往下
    for (int j = 0; j < 4; j++) { // 先選擇每一欄
      int i2 = 3; // 最下面的格子

      for (int i = 3; i >= 0; i--) { // 反過來的迴圈
        if (a[i][j] > 0) {
          int temp = a[i2][j];
          a[i2][j] = a[i][j];
          a[i][j] = temp;
          i2--;
        }
      }
    }
  }

  // 移動完成後產生新的方塊
  genNewBlock();
}

// 繪製遊戲畫面
void draw() {
  background(250, 248, 239); // 淡淡的背景色
  noStroke(); // 不要黑線
  fill(187, 173, 160); // 大格子的色彩
  rect(40, 40, 450, 450, 9); // 大格子

  // 使用迴圈繪製4x4格子
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      int x = 50 + j * (100 + 10);
      int y = 50 + i * (100 + 10);

      fill(tileColor(a[i][j]));
      rect(x, y, 100, 100, 6);
    }
  }
}

// 根據數字設定方塊顏色
int tileColor(int n) {
  switch(n) {
    case 0: return color(205, 193, 180);
    case 2: return color(238, 228, 218);
    case 4: return color(237, 224, 200);
    case 8: return color(242, 177, 121);
    case 16: return color(245, 149, 99);
    case 32: return color(246, 124, 95);
    case 64: return color(246, 94, 59);
    case 128: return color(237, 207, 114);
    case 256: return color(237, 204, 97);
    case 512: return color(237, 200, 80);
    case 1024: return color(237, 197, 63);
    default: return color(237, 194, 46);
  }
}
