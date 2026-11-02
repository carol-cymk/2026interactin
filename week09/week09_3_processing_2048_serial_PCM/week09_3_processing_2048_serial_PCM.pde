// week09_3_processing_2048_serial_PCM
// Q6：剛剛的 week09_1、week09_2 都成功了。
// 接下來想用 Processing 寫一個小遊戲（2048，有方向鍵），
// 再利用 USB Serial 傳到 MakerUNO，發出對應的 3 個聲音
// （移動、消掉、跳出新的數字）。
import processing.serial.*;
// Serial 設定
// 修改 PORT_NAME 為你的 Arduino 實際連接埠
// Windows 通常是 COM4、COM5 等
// 留空 "" 可嘗試自動選擇 Arduino 連接埠
final String PORT_NAME = "COM4";
final int BAUD = 115200;
Serial arduino;
String connection = "No serial";
// 2048 遊戲設定
int[][] board = new int[4][4];
int score = 0;
boolean won = false;
boolean gameOver = false;
// Processing 初始化
void setup() {
  size(500, 600);
  textAlign(CENTER, CENTER);
  connectArduino();
  resetGame();
}
// 連接 Arduino
void connectArduino() {
  try {
    if (PORT_NAME.equals("")) {
      String[] ports = Serial.list();

      if (ports.length > 0) {
        arduino = new Serial(this, ports[ports.length - 1], BAUD);
        connection = ports[ports.length - 1];
      }
    } else {
      arduino = new Serial(this, PORT_NAME, BAUD);
      connection = PORT_NAME;
    }

    if (arduino != null) {
      arduino.clear();
      arduino.bufferUntil('\n');
    }

  } catch (Exception e) {
    println("Serial connection failed.");
    println(e);
    connection = "No serial";
    arduino = null;
  }
}

// ========================================
// 遊戲畫面
// ========================================

void draw() {
  background(250, 248, 239);

  // 遊戲標題
  fill(100, 90, 80);
  textSize(40);
  text("2048", 100, 45);

  // 分數
  textSize(18);
  text("Score: " + score, 390, 45);

  // 操作說明
  textSize(12);
  fill(120);
  text("Arrow keys = move    R = restart    P = reconnect",
       width / 2, 90);

  text("1 = Move sound    2 = Merge sound    3 = New tile",
       width / 2, 110);

  // 遊戲棋盤
  drawBoard();

  // Serial 狀態
  fill(100);
  textSize(12);
  text("Serial: " + connection + " @ " + BAUD,
       width / 2, 570);

  // 遊戲結束提示
  if (gameOver) {
    fill(0, 150);
    rect(0, 0, width, height);

    fill(255);
    textSize(32);
    text("GAME OVER", width / 2, height / 2);
    textSize(18);
    text("Press R to restart",
         width / 2, height / 2 + 45);
  }

  // 達到 2048
  if (won) {
    fill(0, 150);
    rect(0, 0, width, height);

    fill(255);
    textSize(32);
    text("YOU WIN!", width / 2, height / 2);
    textSize(18);
    text("Press R to continue",
         width / 2, height / 2 + 45);
  }
}

// ========================================
// 繪製棋盤
// ========================================

void drawBoard() {
  int cellSize = 100;
  int gap = 8;

  int startX = 42;
  int startY = 150;

  for (int r = 0; r < 4; r++) {
    for (int c = 0; c < 4; c++) {

      int x = startX + c * (cellSize + gap);
      int y = startY + r * (cellSize + gap);

      int value = board[r][c];

      // 空格顏色
      fill(205, 193, 180);

      // 數字顏色
      if (value == 2) {
        fill(238, 228, 218);
      } else if (value == 4) {
        fill(237, 224, 200);
      } else if (value == 8) {
        fill(242, 177, 121);
      } else if (value == 16) {
        fill(245, 149, 99);
      } else if (value == 32) {
        fill(246, 124, 95);
      } else if (value == 64) {
        fill(246, 94, 59);
      } else if (value >= 128) {
        fill(237, 207, 114);
      }

      rect(x, y, cellSize, cellSize, 8);

      // 顯示數字
      if (value != 0) {
        if (value <= 4) {
          fill(100, 90, 80);
        } else {
          fill(255);
        }

        textSize(32);
        text(value,
             x + cellSize / 2,
             y + cellSize / 2);
      }
    }
  }
}

// ========================================
// 初始化遊戲
// ========================================

void resetGame() {
  for (int r = 0; r < 4; r++) {
    for (int c = 0; c < 4; c++) {
      board[r][c] = 0;
    }
  }

  score = 0;
  won = false;
  gameOver = false;

  addRandomTile();
  addRandomTile();
}

// ========================================
// 隨機產生新數字
// ========================================

void addRandomTile() {
  ArrayList<int[]> emptyCells = new ArrayList<int[]>();

  for (int r = 0; r < 4; r++) {
    for (int c = 0; c < 4; c++) {
      if (board[r][c] == 0) {
        emptyCells.add(new int[]{r, c});
      }
    }
  }

  if (emptyCells.size() > 0) {
    int index = int(random(emptyCells.size()));

    int[] cell = emptyCells.get(index);

    int value = random(1) < 0.9 ? 2 : 4;

    board[cell[0]][cell[1]] = value;

    // 播放新數字音效
    sendSound(3);
  }
}

// ========================================
// 鍵盤控制
// ========================================

void keyPressed() {

  if (key == 'r' || key == 'R') {
    resetGame();
    return;
  }

  if (key == 'p' || key == 'P') {
    connectArduino();
    return;
  }

  if (gameOver || won) {
    return;
  }

  boolean moved = false;
  boolean merged = false;

  if (keyCode == LEFT) {
    moved = moveLeft();
  } else if (keyCode == RIGHT) {
    moved = moveRight();
  } else if (keyCode == UP) {
    moved = moveUp();
  } else if (keyCode == DOWN) {
    moved = moveDown();
  }

  if (moved) {

    if (merged) {
      sendSound(2);
    } else {
      sendSound(1);
    }

    addRandomTile();

    checkGameStatus();
  }
}

// ========================================
// 向左移動
// ========================================

boolean moveLeft() {
  boolean moved = false;

  for (int r = 0; r < 4; r++) {

    int[] oldRow = board[r].clone();

    int[] newRow = new int[4];

    ArrayList<Integer> values = new ArrayList<Integer>();

    for (int c = 0; c < 4; c++) {
      if (board[r][c] != 0) {
        values.add(board[r][c]);
      }
    }

    int index = 0;

    for (int i = 0; i < values.size(); i++) {

      int value = values.get(i);

      if (i < values.size() - 1 &&
          value == values.get(i + 1)) {

        value *= 2;
        score += value;
        i++;
      }

      newRow[index] = value;
      index++;
    }

    board[r] = newRow;

    if (!equalArray(oldRow, newRow)) {
      moved = true;
    }
  }

  return moved;
}

// ========================================
// 向右移動
// ========================================

boolean moveRight() {
  reverseBoard();

  boolean moved = moveLeft();

  reverseBoard();

  return moved;
}

// ========================================
// 向上移動
// ========================================

boolean moveUp() {
  transposeBoard();

  boolean moved = moveLeft();

  transposeBoard();

  return moved;
}

// ========================================
// 向下移動
// ========================================

boolean moveDown() {
  transposeBoard();

  boolean moved = moveRight();

  transposeBoard();

  return moved;
}

// ========================================
// 反轉棋盤
// ========================================

void reverseBoard() {
  for (int r = 0; r < 4; r++) {
    for (int c = 0; c < 2; c++) {

      int temp = board[r][c];

      board[r][c] = board[r][3 - c];

      board[r][3 - c] = temp;
    }
  }
}

// ========================================
// 轉置棋盤
// ========================================

void transposeBoard() {
  for (int r = 0; r < 4; r++) {
    for (int c = r + 1; c < 4; c++) {

      int temp = board[r][c];

      board[r][c] = board[c][r];

      board[c][r] = temp;
    }
  }
}

// ========================================
// 比較陣列
// ========================================

boolean equalArray(int[] a, int[] b) {
  for (int i = 0; i < 4; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }

  return true;
}

// ========================================
// 遊戲狀態判斷
// ========================================

void checkGameStatus() {

  // 判斷是否達到 2048
  for (int r = 0; r < 4; r++) {
    for (int c = 0; c < 4; c++) {

      if (board[r][c] >= 2048) {
        won = true;
        return;
      }
    }
  }

  // 判斷是否還有空格
  for (int r = 0; r < 4; r++) {
    for (int c = 0; c < 4; c++) {

      if (board[r][c] == 0) {
        return;
      }
    }
  }

  // 判斷是否還能合併
  for (int r = 0; r < 4; r++) {
    for (int c = 0; c < 4; c++) {

      if (c < 3 &&
          board[r][c] == board[r][c + 1]) {
        return;
      }

      if (r < 3 &&
          board[r][c] == board[r + 1][c]) {
        return;
      }
    }
  }

  gameOver = true;
}

// ========================================
// 傳送音效至 Arduino
// ========================================

// 1 = 移動
// 2 = 合併消除
// 3 = 新數字出現

void sendSound(int soundType) {

  if (arduino != null) {

    arduino.write(soundType);

    println("Sound event: " + soundType);

  } else {

    println("Arduino not connected.");
  }
}

// ========================================
// Serial 接收 Arduino 回傳資料
// ========================================

void serialEvent(Serial port) {

  String message = port.readStringUntil('\n');

  if (message != null) {

    message = trim(message);

    println("Arduino: " + message);
  }
}
