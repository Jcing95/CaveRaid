class EntityManager{

  HashMap<Chunk, LinkedList<Entity>> entities;

  public EntityManager(){
    entities = new HashMap<Chunk, LinkedList<Entity>>();
  }

  void addEntity(Chunk c, Entity e){
    if(!entities.keySet().contains(c))
      entities.put(c, new LinkedList<Entity>());
    entities.get(c).add(e);
  }

  void moveEntity(Chunk from, Chunk to, Entity e){
    entities.get(from).remove(e);
    if(entities.get(from).isEmpty())
      entities.remove(from);
    if(!entities.keySet().contains(to))
      entities.put(to, new LinkedList<Entity>());
    entities.get(to).add(e);
  }

  public void showEntities(){
    Set<Chunk> chunks = entities.keySet();
    for(Chunk c: chunks)
      if(c.active)
        for(Entity e: entities.get(c))
          e.paint();
  }


  public void tick(){
    Set<Chunk> chunks = entities.keySet();
    for(Chunk c: chunks)
      for(Entity e: entities.get(c))
        e.tick();
  }

}


abstract class Entity{

  int tileX, tileY;
  Chunk containinChunk;

  public Entity(Chunk c){

  }

  public abstract void paint();

  public abstract void tick();

}
