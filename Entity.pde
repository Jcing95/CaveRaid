class EntityManager{

  HashMap<Point, LinkedList<Entity>> entities;
  LinkedList<Entity> todraw;

  public EntityManager(){
    entities = new HashMap<Point, LinkedList<Entity>>();
    todraw = new LinkedList<Entity>();
  }

  void addEntity(Point c, Entity e){
    if(!entities.keySet().contains(c))
      entities.put(c, new LinkedList<Entity>());
    entities.get(c).add(e);
  }

  void moveEntity(Point from, Point to, Entity e){
    entities.get(from).remove(e);
    if(entities.get(from).isEmpty())
      entities.remove(from);
    if(!entities.keySet().contains(to))
      entities.put(to, new LinkedList<Entity>());
    entities.get(to).add(e);
  }

  public void toDraw(Entity e){
    todraw.add(e);
  }

  public void finishDrawing(){
    Set<Point> chunks = entities.keySet();
    for(Entity e: todraw)
      e.painted();
    todraw.clear();
  }

  public void tick(){
    Set<Point> chunks = entities.keySet();
    for(Point c: chunks)
      for(Entity e: entities.get(c))
        e.tick();
  }

}


abstract class Entity{

  Point containingChunk;
  Tile occupied;
  Point subPos;
  Point offset;
  boolean painted;

  public Entity(Tile t, Point subPos){
    this.subPos = subPos;
    occupied = t;
    offset = new Point(0,0);
    containingChunk = t.getChunk();
    entities.addEntity(t.getChunk(),this);
    t.occupy(this,subPos);
  }

  public Point getSubPos(){
    return subPos;
  }

  public void addOffset(int x, int y){
    offset.x += x;
    offset.y += y;
    int subPosChangeX = offset.x / PANESIZE;
    int subPosChangeY = offset.y / PANESIZE;
    offset.x %= PANESIZE;
    offset.y %= PANESIZE;
    //println("OFFSET: " + offset.x + "/" + PANESIZE + " (+" + x + ") sub: +" + subPosChangeX);
    addSubPos(subPosChangeX, subPosChangeY);
  }

  public void addSubPos(int x, int y){
    subPos.x += x;
    subPos.y += y;
    int tileChangeX = subPos.x / 2;
    int tileChangeY = subPos.y / 2;
    subPos.x %= 2;
    subPos.y %= 2;
    //println("SUBPOS: " + subPos.x + " (+" + x + ") tile: +" + tileChangeX);
    moveToTile(occupied.x + tileChangeX, occupied.y + tileChangeY);
  }

  public void moveToTile(int x, int y){
    occupied.removeEntity(this);
    occupied = cave.getTile(x,y);
    occupied.occupy(this,subPos);
  }

  public void moveTile(int x, int y){

  }

  public void show(){
    entities.toDraw(this);
  }

  public void painted(){
    pushMatrix();
    translate(occupied.x*2*PANESIZE+subPos.x*PANESIZE+offset.x,occupied.y*2*PANESIZE+subPos.y*PANESIZE+offset.y, occupied.z*PANESIZE);
    this.paint();
    popMatrix();
  }

  public abstract void paint();

  public abstract void tick();

}
