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
  Tile[] occupied;
  Point subPos;
  boolean painted;

  public Entity(Tile t, Point subPos){
    occupied = new Tile[1];
    occupied[0] = t;
    this.subPos = t.occupy(this,subPos);
    containingChunk = t.getChunk();
    entities.addEntity(t.getChunk(),this);
  }

  public Point getSubPos(){
    return subPos;
  }

  public void moveTile(int x, int y){
    
  }

  public void show(){
    entities.toDraw(this);
  }

  public void painted(){
    pushMatrix();
    translate(occupied[0].x*2*PANESIZE+subPos.x,occupied[0].y*2*PANESIZE+subPos.y, occupied[0].z*PANESIZE);
    this.paint();
    popMatrix();
  }

  public abstract void paint();

  public abstract void tick();

}
