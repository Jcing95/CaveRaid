import java.util.HashMap;
import java.util.Set;

int CHUNKSIZE = 64;

//
//   ####  #    # #    # #    # #    #
//  #    # #    # #    # ##   # #   #
//  #      ###### #    # # #  # ####
//  #      #    # #    # #  # # #  #
//  #    # #    # #    # #   ## #   #
//   ####  #    #  ####  #    # #    #
class Chunk {

  int x,y;
  boolean active;
  Tile[][] tiles;

  @Override
  public int hashCode(){
    return (""+x+"C"+y).hashCode();
  }

  public Chunk(Point p){
    x = (int)p.x*CHUNKSIZE;
    y = (int)p.y*CHUNKSIZE;
    active = true;
    tiles = new Tile[CHUNKSIZE][CHUNKSIZE];
    for(int i=0; i<CHUNKSIZE; i++){
      for(int j =0; j<CHUNKSIZE; j++){
        tiles[i][j] = new Tile(x+i,y+j,p);
      }
    }
  }

  Tile getTile(int x, int y){
    if(x < 0)
    x+=CHUNKSIZE;
    if(y<0)
    y+=CHUNKSIZE;
    //println("  x" +x +"  y"+y);
    return tiles[x][y];
  }

  void paint(){
    for(int i=0; i<CHUNKSIZE; i++){
      for(int j =0; j<CHUNKSIZE; j++){
        tiles[i][j].paint();
      }
    }
  }

}


//
//   ####    ##   #    # ###### #       ####    ##   #####  ###### #####
//  #    #  #  #  #    # #      #      #    #  #  #  #    # #      #    #
//  #      #    # #    # #####  #      #    # #    # #    # #####  #    #
//  #      ###### #    # #      #      #    # ###### #    # #      #####
//  #    # #    #  #  #  #      #      #    # #    # #    # #      #   #
//   ####  #    #   ##   ###### ######  ####  #    # #####  ###### #    #
class CaveLoader implements Runnable{

  float UPS = 1;

  boolean running, initialized;

  PVector loaded;

  HashMap<Point,Chunk> loadedChunks;

  public CaveLoader(){
    initialized = false;
    loaded = new PVector(0,0);
    loadedChunks = new HashMap<Point,Chunk>();
    //load();
    running = true;
    Thread th = new Thread(this);
    th.start();
    println("Caveloader started!_");
  }


  void update(){
    //println("cam: "+ cam.tile().x + "|" + cam.tile().y + "   " + loaded + "  floored: x" + floor(cam.tile().x/CHUNKSIZE) + " y" + floor(cam.tile().y/CHUNKSIZE));
    if(floor(cam.tile().x/CHUNKSIZE) != loaded.x || floor(cam.tile().y/CHUNKSIZE) != loaded.y) {
      //&&  floor(cam.tile().x)/CHUNKSIZE <= loaded.x+1 && floor(cam.tile().y)/CHUNKSIZE <= loaded.y+1 )){
      loaded = new PVector(floor(cam.tile().x/CHUNKSIZE),floor(cam.tile().y/CHUNKSIZE));
      load();
    }
  }

  void load(){
    HashMap lc = new HashMap<Point,Chunk>();
    Set k = loadedChunks.keySet();

    Point p = new Point(loaded.x,loaded.y);

    if(k.contains(p)){
      lc.put(p, loadedChunks.get(p));
    }else{
      lc.put(p, new Chunk(p));
    }

    p = new Point(loaded.x+1, loaded.y);
    if(k.contains(p)){
      lc.put(p, loadedChunks.get(p));
    }else{
      lc.put(p, new Chunk(p));
    }

    p = new Point(loaded.x, loaded.y+1);
    if(k.contains(p)){
      lc.put(p, loadedChunks.get(p));
    }else{
      lc.put(p, new Chunk(p));
    }

    p = new Point(loaded.x-1, loaded.y);
    if(k.contains(p)){
      lc.put(p, loadedChunks.get(p));
    }else{
      lc.put(p, new Chunk(p));
    }

    p = new Point(loaded.x, loaded.y-1);
    if(k.contains(p)){
      lc.put(p, loadedChunks.get(p));
    }else{
      lc.put(p, new Chunk(p));
    }

    p = new Point(loaded.x+1, loaded.y+1);
    if(k.contains(p)){
      lc.put(p, loadedChunks.get(p));
    }else{
      lc.put(p, new Chunk(p));
    }

    p = new Point(loaded.x-1, loaded.y+1);
    if(k.contains(p)){
      lc.put(p, loadedChunks.get(p));
    }else{
      lc.put(p, new Chunk(p));
    }

    p = new Point(loaded.x+1, loaded.y-1);
    if(k.contains(p)){
      lc.put(p, loadedChunks.get(p));
    }else{
      lc.put(p, new Chunk(p));
    }

    p = new Point(loaded.x-1, loaded.y-1);
    if(k.contains(p)){
      lc.put(p, loadedChunks.get(p));
    }else{
      lc.put(p, new Chunk(p));
    }

    loadedChunks = lc;
    println("reload tiles @ " + loaded);
  }

  void paintCave(){
    //println(loadedChunks.keySet().size());
    for(Object p: loadedChunks.keySet()){
      Chunk c = loadedChunks.get((Point)p);
      if(c != null)
        loadedChunks.get((Point)p).paint();
    }
  }

  public void run(){
    load();
    initialized = true;
    int last = millis();
    while (running){
      if(millis()-last>1000/UPS){
        last=millis();
        update();
      }

    }
  }




}

//
//   ####    ##   #    # ######
//  #    #  #  #  #    # #
//  #      #    # #    # #####
//  #      ###### #    # #
//  #    # #    #  #  #  #
//   ####  #    #   ##   ######
class Cave {

  //HashMap<Point,Chunk> world;
  CaveLoader loader;

  public Cave(){
    loader = new CaveLoader();
    println("initialized Cave!_");
  }

  int chunkAt(float x){
    return floor(x);
  }

  public Tile getTile(float x, float y){
  //  println("x" + chunkAt(x/CHUNKSIZE) + " y" + chunkAt(y/CHUNKSIZE) + "   " + world.get(new Point(x/CHUNKSIZE,y/CHUNKSIZE)));
    if(loader.loadedChunks.get(new Point(chunkAt(x/CHUNKSIZE),chunkAt(y/CHUNKSIZE))) != null)
      return loader.loadedChunks.get(new Point(chunkAt(x/CHUNKSIZE),chunkAt(y/CHUNKSIZE))).getTile((int)x%CHUNKSIZE,(int)y%CHUNKSIZE);
    return null;
  }

  void paint(){
    loader.paintCave();
  }
}

final int NORTH = 0;
final int EAST = 1;
final int SOUTH = 2;
final int WEST = 3;

//
//  ##### # #      ######
//    #   # #      #
//    #   # #      #####
//    #   # #      #
//    #   # #      #
//    #   # ###### ######
class Tile {
  PImage imgt;

  int x,y,z;
  final int DELTA_Z = (int)(0.25*sqrt(2)*PANESIZE);
  Material[] mat;
  int[] types;
  boolean[] down;
  int orientation;
  Point chunk;

  color tint;

  ArrayList<Entity> entitiesTL;
  ArrayList<Entity> entitiesTR;
  ArrayList<Entity> entitiesBL;
  ArrayList<Entity> entitiesBR;

  public Tile (int x, int y, Point chunk) {
    this.x = x;
    this.y = y;
    this.z = wg.getZ(x,y);
    this.chunk = chunk;
    orientation = NORTH;

    tint = 0xFFFFFFFF;

    entitiesTL = new ArrayList<Entity>(2);
    entitiesTR = new ArrayList<Entity>(2);
    entitiesBL = new ArrayList<Entity>(2);
    entitiesBR = new ArrayList<Entity>(2);

    mat = new Material[4];
    mat[0] = wg.getMat(x,y);
    mat[1] = wg.getMat(x+0.5,y);
    mat[2] = wg.getMat(x,y+0.5);
    mat[3] = wg.getMat(x+0.5,y+0.5);


    types = new int[3];
    down = new boolean[3];
    if(wg.getZ(x+1,y) > z){
      types[0] = TILE_WALL;
      down[0] = false;
      mat[1] = wg.getWall(x+0.5,y);
    }
    if(wg.getZ(x+1,y) < z){
      types[0] = TILE_WALL;
      down[0] = true;
      mat[1] = wg.getWall(x+0.5,y);
    }
    if(wg.getZ(x,y+1) > z){
      types[1] = TILE_WALL;
      down[1] = false;
      mat[2] = wg.getWall(x,y+0.5);
    }
    if(wg.getZ(x,y+1) < z){
      types[1] = TILE_WALL;
      down[1] = true;
      mat[2] = wg.getWall(x,y+0.5);
    }

    if(wg.getZ(x+1,y+1) != z && types[0] == TILE_WALL && types[1] ==TILE_WALL ){
      types[2] = TILE_INNER_CORNER_WALL;
      orientation = SOUTH;
      mat[3] = wg.getWall(x+0.5,y+0.5);
      if(wg.getZ(x+1,y+1) < z){
        types[2] = TILE_OUTER_CORNER_WALL;
        down[2] = true;
        orientation = NORTH;
      }
      return;
    }

    if(wg.getZ(x+1,y+1) != z && types[0] == types[1]){
      types[2] = TILE_OUTER_CORNER_WALL;
      orientation = SOUTH;
      mat[3] = wg.getWall(x+0.5,y+0.5);
      if(wg.getZ(x+1,y+1) < z){
        types[2] = TILE_INNER_CORNER_WALL;
        down[2] = true;
        orientation = NORTH;
      }
      return;
    }

    if(wg.getZ(x+1,y) != wg.getZ(x,y+1) ){
      types[2] = TILE_WALL;
      mat[3] = wg.getWall(x+0.5,y+0.5);
      if(wg.getZ(x,y+1) != z){
        orientation = SOUTH;
        if(wg.getZ(x+1,y+1) == z){
          orientation = WEST;
          types[2] = TILE_OUTER_CORNER_WALL;
          if(wg.getZ(x,y+1) < z){
            types[2] = TILE_INNER_CORNER_WALL;
            down[2] = true;
            orientation = EAST;
          }
          return;
        }
        if(wg.getZ(x,y+1) < z){
          down[2] = true;
          orientation = NORTH;
        }
      }
      if(wg.getZ(x+1,y) != z){
        orientation = EAST;
        if(wg.getZ(x+1,y+1) == z){
          orientation = EAST;
          types[2] = TILE_OUTER_CORNER_WALL;
          if(wg.getZ(x+1,y) < z){
            types[2] = TILE_INNER_CORNER_WALL;
            down[2] = true;
            orientation = WEST;
          }
          return;
        }
        if(wg.getZ(x+1,y) < z){
          down[2] = true;
          orientation = WEST;
        }
      }
      return;
    }
  }

  Point getChunk(){
    return chunk;
  }

  void tint(color col){
    tint = col;
  }

  Point occupy(Entity e, Point subPos){
    int x = subPos.x %= 2;
    int y = subPos.y %= 2;
    if(x == 0 && y == 0)
      entitiesTL.add(e);
    if(x == 0 && y == 1)
      entitiesTR.add(e);
    if(x == 1 && y == 0)
      entitiesBL.add(e);
    if(x == 1 && y == 1)
      entitiesBR.add(e);
      println("entitiy added " + x + " " + y + " " + entitiesTL.size());
    return new Point(x,y);
  }

  void removeEntity(Entity e){
    Point subPos = e.getSubPos();
    int x = subPos.x %= 1;
    int y = subPos.y %= 1;
    if(x == 0 && y == 0)
      entitiesTL.remove(e);
    if(x == 0 && y == 1)
      entitiesTR.remove(e);
    if(x == 1 && y == 0)
      entitiesBL.remove(e);
    if(x == 1 && y == 1)
      entitiesBR.remove(e);
  }

  boolean isOnScreen(int x, int y, int z){
    return screenX(x*2*PANESIZE, y*2*PANESIZE, z*PANESIZE) > 0 &&
    screenX(x*2*PANESIZE, y*2*PANESIZE, z*PANESIZE) < width &&
    screenY(x*2*PANESIZE, y*2*PANESIZE, z*PANESIZE) > 0 &&
    screenY(x*2*PANESIZE, y*2*PANESIZE, z*PANESIZE) < height;
  }

  //
  //  ##### # #      ######         #####    ##   # #    # #####
  //    #   # #      #              #    #  #  #  # ##   #   #
  //    #   # #      #####          #    # #    # # # #  #   #
  //    #   # #      #              #####  ###### # #  # #   #
  //    #   # #      #              #      #    # # #   ##   #
  //    #   # ###### ###### ####### #      #    # # #    #   #
  public void paint(){
    if(!(isOnScreen(x,y,z) || isOnScreen(x+2,y,z) || isOnScreen(x,y+2,z) || isOnScreen(x-2,y,z)
          || isOnScreen(x,y-2,z) || isOnScreen(x+2,y+2,z) || isOnScreen(x-2,y+2,z) || isOnScreen(x-2,y-2,z)
          || isOnScreen(x+2,y-2,z)))
        return;
    pane(x*2,y*2,z,TILE_FLOOR,NORTH,mat[0],tint);
    if(down[0])
      pane((x*2)+1,(y*2),z-1,types[0],WEST,mat[1],tint);
      else if (types[0] == TILE_FLOOR)
        pane((x*2)+1,(y*2),z,types[0],NORTH,mat[1],tint);
      else
        pane((x*2)+1,(y*2),z,types[0],EAST,mat[1],tint);
    if(down[1])
      pane((x*2),(y*2)+1,z-1,types[1],NORTH,mat[2],tint);
      else if(types[1] == TILE_FLOOR)
        pane((x*2),(y*2)+1,z,types[1],NORTH,mat[2],tint);
      else
        pane((x*2),(y*2)+1,z,types[1],SOUTH,mat[2],tint);
    if(down[2])
      pane((x*2)+1,(y*2)+1,z-1,types[2],orientation,mat[3],tint);
      else
      pane((x*2)+1,(y*2)+1,z,types[2],orientation,mat[3],tint);
    tint = 0xFFFFFFFF;
    for(Entity e: entitiesTL)
      e.show();
    for(Entity e: entitiesTR)
      e.show();
    for(Entity e: entitiesBL)
      e.show();
    for(Entity e: entitiesBR)
      e.show();
  }

}
