class EntityManager{

  HashMap<Point, LinkedList<Entity>> entities;

  public EntityManager(){
    entities = new HashMap<Point, LinkedList<Entity>>();
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

  public void finishDrawing(){
    Set<Point> chunks = entities.keySet();
    for(Point c: chunks)
      for(Entity e: entities.get(c))
        e.painted();
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
  boolean painted;

  public Entity(Tile t, Point subPos){
    occupied = t;
    this.subPos = t.occupy(this,subPos);
    containingChunk = t.getChunk();

  }

  public Point getSubPos(){
    return subPos;
  }

  public void show(){
    if(!painted){
      paint();
      painted = true;
    }
  }

  public void painted(){
    painted = false;
  }

  public abstract void paint();

  public abstract void tick();

}
