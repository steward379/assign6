class GameState
{
  static final int START = 0;
  static final int PLAYING = 1;
  static final int END = 2;
}
class Direction
{
  static final int LEFT = 0;
  static final int RIGHT = 1;
  static final int UP = 2;
  static final int DOWN = 3;
}
class EnemysShowingType
{
  static final int STRAIGHT = 0;
  static final int SLOPE = 1;
  static final int DIAMOND = 2;
  static final int STRONGLINE = 3;
}
class FlightType
{
  static final int FIGHTER = 0;
  static final int ENEMY = 1;
  static final int ENEMYSTRONG = 2;
}

int state = GameState.START;
int currentType = EnemysShowingType.STRAIGHT;
int enemyCount = 8;
int bulletCount = 5;
Enemy[] enemys = new Enemy[enemyCount];
Bullet [] bullets = new Bullet[bulletCount];
Boss[] boss = new Boss[bulletCount];

Fighter fighter;
Background bg;
FlameMgr flameMgr;
Treasure treasure;
HPDisplay hpDisplay;

boolean isMovingUp;
boolean isMovingDown;
boolean isMovingLeft;
boolean isMovingRight;

int time;
int wait = 4000;
int limit = 0;
boolean isBoss = false;
int counter = 0;

void setup () {
  size(640, 480);
  frameRate(60);
  flameMgr = new FlameMgr();
  bg = new Background();
  treasure = new Treasure();
  hpDisplay = new HPDisplay();
  fighter = new Fighter(20);

  for (int i = 0; i < bulletCount; i++) {
    bullets[i] = null;
  }
  for (int i = 0; i < bulletCount; i++) {
    boss[i] = null;
  }
}

void draw() {

  if (state == GameState.START) {
    bg.draw();
  } else if (state == GameState.PLAYING) {
    bg.draw();
    treasure.draw();
    flameMgr.draw();
    fighter.draw();

    //enemys
    if (millis() - time >= wait) {
      addEnemy(currentType++);
      currentType = currentType % 4;
    }		

    for (int i = 0; i < enemyCount; ++i) {
      if (enemys[i] != null) {
        enemys[i].move();
        enemys[i].draw();
        if (enemys[i].isCollideWithFighter()) {
          if ( currentType == EnemysShowingType.STRONGLINE) {
            fighter.hpValueChange(-50);
          } else {
            fighter.hpValueChange(-20);
          }
          flameMgr.addFlame(enemys[i].x, enemys[i].y);
          enemys[i]=null;
        } else if (enemys[i].isOutOfBorder()) {
          enemys[i]=null;
        }
      }
    }
    // 這地方應該加入Fighter 血量顯示UI
    hpDisplay.updateWithFighterHP(fighter.hp);

    for (int i = 0; i < enemyCount; ++i) {
      for (int j = 0; j < bulletCount; ++j) {
        if (bullets[j]!= null) {
          bullets[j].draw();
          bullets[j].move();
          if (bullets[j].isCollideWithEnemy(i)) {
            if (enemys[i]!= null) {
              if (currentType == EnemysShowingType.STRONGLINE) {
                counter += 1;
                if (counter == 5) {
                  flameMgr.addFlame(enemys[i].x, enemys[i].y);
                  enemys[i] = null;
                  bullets[j] = null;
                  counter = 0;
                }
              } else {
                flameMgr.addFlame(enemys[i].x, enemys[i].y);
                enemys[i] = null;
                bullets[j] = null;
              }
            }
          } else if (bullets[j].isOutOfBorder()) {
            bullets[j] = null;
          }
        }
      }
    }
  } else if (state == GameState.END) {
    bg.draw();
  }
}
boolean isHit(int ax, int ay, int aw, int ah, int bx, int by, int bw, int bh)
{
  // Collision x-axis?
  boolean collisionX = (ax + aw >= bx) && (bx + bw >= ax);
  // Collision y-axis?
  boolean collisionY = (ay + ah >= by) && (by + bh >= ay);
  return collisionX && collisionY;
}

void keyPressed() {
  switch(keyCode) {
  case UP : 
    isMovingUp = true ;
    break ;
  case DOWN : 
    isMovingDown = true ; 
    break ;
  case LEFT : 
    isMovingLeft = true ; 
    break ;
  case RIGHT : 
    isMovingRight = true ; 
    break ;
  default :
    break ;
  }
}

void keyReleased() {
  switch(keyCode) {
  case UP : 
    isMovingUp = false ;
    break ;
  case DOWN : 
    isMovingDown = false ; 
    break ;
  case LEFT : 
    isMovingLeft = false ; 
    break ;
  case RIGHT : 
    isMovingRight = false ; 
    break ;
  default :
    break ;
  }
  if (key == ' ') {
    if (state == GameState.PLAYING) {
      fighter.shoot();
    }
  }


  if (key == ENTER) {
    switch(state) {
    case GameState.START:
    case GameState.END:
      state = GameState.PLAYING;
      enemys = new Enemy[enemyCount];
      flameMgr = new FlameMgr();
      treasure = new Treasure();
      fighter = new Fighter(20);
    default : 
      break ;
    }
  }
}