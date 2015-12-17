class Boss extends Enemy {

  Boss(int x, int y, int type) {
    super (x, y, type); 
    super.life = 5;
    super.damage = 50;
    super.speed = 2;
    super.enemyImg = loadImage("img/enemy2.png");
  }
}
