class Boss extends Enemy {

  Boss(int x, int y) {
    super (x, y, EnemysShowingType.STRONGLINE); 
    super.enemyImg = loadImage("img/enemy2.png");
  }

  void move() {
    this.x += 2;
  }


}
