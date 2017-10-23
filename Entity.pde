class EntityManager{

  HashMap<Chunk, LinkedList<Entity>> entities;

  public EntityManager(){
    entities = new HashMap<Chunk, LinkedList<Entity>>();
  }



}


abstract class Entity{

  int tileX, tileY;
  Chunk containinChunk;

  public abstract void paint();

}
