class Raider extends Entity {

  public Raider(Tile t, Point subPos){
    super(t,subPos);
  }

  void tick(){

  }

  void paint(){
    translate(0,0,+5);
    fill(#00FF00);
    ellipse(0,0,100,100);
    translate(0,0,-5);
  }

}
