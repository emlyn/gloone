PImage logo;

float goalX;
float goalY;
float circleX;
float circleY;
float speedX;
float speedY;
int shots;

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
}

void draw() {
  rectMode(CENTER);
  imageMode(CENTER);
  textSize(40);
  background(0, 80, 10);
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
  fill(150, 0, 0);
  stroke(0, 40, 5);
  strokeWeight(8);
  ellipse(goalX, goalY, 32, 32);
  fill(5);
  stroke(128);
  strokeWeight(1);
  ellipse(circleX, circleY, 32, 32);
  textAlign(RIGHT);
  fill(0, 0, 200);
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
      textAlign(CENTER);
      fill(220, 200, 0);
      text("Congratulations!", width/2, height/2 - 100);
      int score = int((2000 / shots) / (d + 2));
      text("You scored " + nf(score) + "!", width/2, height/2);
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
    state = State.SHOOTING;
    shots = shots + 1;
    speedX = (mouseX - circleX) / 30;
    speedY = (mouseY - circleY) / 30;
  }
}
