class Raider extends Entity {
int x;

  public Raider(Tile t, Point subPos){
    super(t,subPos);
    x = t.x;
  }

  void tick(){
    occupied[0].removeEntity(this);
    occupied[0] = cave.getTile((occupied[0].x+1)%(x+10), occupied[0].y);
    subPos.x++;
    this.subPos = occupied[0].occupy(this,subPos);
  }

  void paint(){
    translate(0,0,+5);
    fill(#00FF00);
    ellipse(0,0,100,100);
    translate(0,0,-5);
  }

}
