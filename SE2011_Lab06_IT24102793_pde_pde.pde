//6
int state = 0;
int lives = 3;
int startTime;
int duration = 30;

float px, py, vx, vy;
float accel = 0.6;
float friction = 0.9;
float gravity = 0.6;
float jumpForce = -12;
float pR = 20;

int n = 8;
float[] ex = new float[n];
float[] ey = new float[n];
float[] evx = new float[n];
float[] evy = new float[n];
float eR = 15;

int lastHitTime = 0;
int cooldown = 800; 

void setup() {
  size(600, 400);
  resetGame();
}

void draw() {
  background(240);
  
  if (state == 0) {
    drawScreen("DODGE & SURVIVE", "Press ENTER to Start");
  } else if (state == 1) {
    playGame();
  } else if (state == 2) {
    drawScreen("GAME OVER", "Press R to Restart");
  } else if (state == 3) {
    drawScreen("YOU WIN!", "Press R to Restart");
  }
}

void playGame() {
  int elapsed = (millis() - startTime) / 1000;
  int remaining = duration - elapsed;
  if (remaining <= 0) state = 3;

  if (keyPressed) {
    if (keyCode == LEFT)  vx -= accel;
    if (keyCode == RIGHT) vx += accel;
  }
  vx *= friction;
  vy += gravity;
  px += vx;
  py += vy;

  px = constrain(px, pR, width - pR);
  if (py > height - 50 - pR) {
    py = height - 50 - pR;
    vy = 0;
  }

  for (int i = 0; i < n; i++) {
    ex[i] += evx[i];
    ey[i] += evy[i];

    if (ex[i] < eR || ex[i] > width - eR) evx[i] *= -1;
    if (ey[i] < eR || ey[i] > height - eR) evy[i] *= -1;

    float d = dist(px, py, ex[i], ey[i]);
    if (d < pR + eR && millis() - lastHitTime > cooldown) {
      lives--;
      lastHitTime = millis();
      if (lives <= 0) state = 2;
    }

    fill(255,0,0);
    ellipse(ex[i], ey[i], eR*2, eR*2);
  }

  fill(80, 160, 255);
  if (millis() - lastHitTime < cooldown && (frameCount / 5) % 2 == 0) {
  } else {
     ellipse(px, py, pR*2, pR*2);
  }

  fill(0);
  textSize(20);
  text("Lives: " + lives, 20, 30);
  text("Time: " + remaining, width - 100, 30);
  rect(0, height-50, width, 5);
}

void resetGame() {
  px = 100; py = 200; vx = 0; vy = 0;
  lives = 3;
  for (int i = 0; i < n; i++) {
    ex[i] = random(width);
    ey[i] = random(height/2);
    evx[i] = random(-4, 4);
    evy[i] = random(-4, 4);
  }
}

void drawScreen(String title, String sub) {
  textAlign(CENTER);
  fill(0);
  textSize(40); text(title, width/2, height/2 - 20);
  textSize(20); text(sub, width/2, height/2 + 30);
  textAlign(LEFT);
}

void keyPressed() {
  if (state == 0 && keyCode == ENTER) {
    state = 1;
    startTime = millis();
  }
  if ((state == 2 || state == 3) && (key == 'r' || key == 'R')) {
    resetGame();
    state = 0;
  }
  if (state == 1 && key == ' ' && py >= height - 50 - pR - 1) {
    vy = jumpForce;
  }
}
