PImage logo;
PImage cursor_img;

float goalX;
float goalY;
float circleX;
float circleY;
float speedX;
float speedY;
int shots;
int high_score;
boolean is_high_score;

enum State {
  START,
  READY,
  SHOOTING,
  CONGRATS,
  SCORE,
  BUTTON,
  RESTART
}

State state;

void setup() {
  size(800, 450);
  state = State.START;
  logo = loadImage("logo.png");
  cursor_img = loadImage("cursor.png");
  cursor(cursor_img);
  high_score = 0;
}

void draw() {
  rectMode(CENTER);
  imageMode(CENTER);
  textSize(40);
  background(0, 0, 40);
  if (state == State.START) {
    image(logo, width/2, height/2 - 50);
    stroke(220);
    strokeWeight(3);
    fill(30);
    rect(width/2, height/2 + 100, 220, 70, 5);
    fill(220);
    textAlign(CENTER);
    text("Start", width/2, height/2 + 115);
    return;
  }
  fill(0, 0, 0);
  stroke(150, 0, 0);
  strokeWeight(3);
  ellipse(goalX, goalY, 32, 32);
  strokeWeight(0);
  for (int i = 31; i >= 0; i--) {
    fill(255 - sqrt(i) * 8 * sqrt(32), 0, 0);
    ellipse(goalX, goalY, i, i);
  }
  fill(5);
  stroke(150);
  strokeWeight(2);
  float dx1 = mouseX - circleX, dy1 = mouseY - circleY;
  float d1 = sqrt(dx1*dx1 + dy1*dy1);
  if (state == State.READY && d1 > 0) {
    dx1 = 24 * dx1 / d1;
    dy1 = 24 * dy1 / d1;
    line(circleX, circleY, circleX + dx1, circleY + dy1);
  }
  ellipse(circleX, circleY, 32, 32);
  textAlign(RIGHT);
  fill(120, 0, 0);
  text(nf(shots), width - 5, 40);
  circleX = circleX + speedX;
  circleY = circleY + speedY;
  if (circleX >= (width - 16)) {
    speedX = -abs(speedX);
  }
  if (circleX <= 16) {
    speedX = abs(speedX);
  }
  if (circleY >= (height - 16)) {
    speedY = -abs(speedY);
  }
  if (circleY <= 16) {
    speedY = abs(speedY);
  }
  speedX = speedX * 0.995;
  speedY = speedY * 0.995;
  if (speedX*speedX + speedY*speedY < 0.1) {
    speedX = speedY = 0; 
    float dx = circleX - goalX, dy = circleY - goalY;
    float d = sqrt(dx*dx + dy*dy);
    if (d < 32) {
      state = State.RESTART;
      image(logo, width/2, 70, logo.width/2, logo.height/2);
      textAlign(CENTER);
      fill(220, 200, 0);
      int score = int((2000 / shots) / (d + 2));
      String msg = "Congratulations!";
      if (score == 0) msg = "Seriously?!?!";
      else if (score < 10) msg = "At least you tried";
      else if (score < 100) msg = "Well done";
      else if (score == 10000) msg = "How?";
      else if (score >= 300) msg = "Impressive!";
      else if (score >= 1000) msg = "Fantastic!";
      println("score: ", score);
      println("high_score: ", high_score);
      text(msg, width/2, height/2 - 80);
      text("You scored " + nf(score), width/2, height/2 - 25);
      if (score > high_score) is_high_score = true;
      if (is_high_score) {
        String msg2 = "High score!";
        if (score < 50) {
          msg2 = "High score";
        }
        text(msg2, width/2, height/2 + 30);
        high_score = score;
      } else {
        text("High score: " + nf(high_score), width/2, height/2 + 30);
      }
      stroke(220);
      strokeWeight(3);
      fill(30);
      rect(width/2, height/2 + 100, 220, 70, 5);
      fill(220);
      text("Play again", width/2, height/2 + 115);
    } else {
      state = State.READY;
    }
  }
}

void mousePressed() {
  if (state == State.START ||
      state == State.RESTART) {
    if (mouseX >= width/2 - 110 &&
        mouseX <= width/2 + 110 &&
        mouseY >= height/2 + 65 &&
        mouseY <= height/2 + 135) {
      state = State.READY;
      goalX = random(16, width - 16);
      goalY = random(16, height - 16);
      circleX = width/2;
      circleY = height/2;
      speedX = 0;
      speedY = 0;
      shots = 0;
    }
  } else if (state == State.READY) {
    is_high_score = false;
    state = State.SHOOTING;
    shots = shots + 1;
    speedX = (mouseX - circleX) / 30;
    speedY = (mouseY - circleY) / 30;
  }
}
