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

  Tile[][] tiles;

  public Chunk(Point p){
    x = (int)p.x*CHUNKSIZE;
    y = (int)p.y*CHUNKSIZE;

    tiles = new Tile[CHUNKSIZE][CHUNKSIZE];
    for(int i=0; i<CHUNKSIZE; i++){
      for(int j =0; j<CHUNKSIZE; j++){
        tiles[i][j] = new Tile(x+i,y+j);
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

  boolean running;

  PVector loaded;

  HashMap<Point,Chunk> loadedChunks;

  public CaveLoader(){
    loaded = new PVector(0,0);
    loadedChunks = new HashMap<Point,Chunk>();
    load();
    running = true;
    Thread th = new Thread(this);
    th.start();
    println("Caveloader started!_");
  }


  void update(){
    println("cam: "+ cam.tile().x + "|" + cam.tile().y + "   " + loaded + "  floored: x" + floor(cam.tile().x/CHUNKSIZE) + " y" + floor(cam.tile().y/CHUNKSIZE));
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
    //println(loadedChunks.keySet());
    for(Object p: loadedChunks.keySet()){
      Chunk c = loadedChunks.get((Point)p);
      if(c != null)
        loadedChunks.get((Point)p).paint();
    }
  }

  public void run(){

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
    return new Tile(0,0);
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

  public Tile (int x, int y) {

    this.x = x;
    this.y = y;
    this.z = wg.getZ(x,y);
    orientation = NORTH;
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

  //
  //  ##### # #      ######         #####    ##   # #    # #####
  //    #   # #      #              #    #  #  #  # ##   #   #
  //    #   # #      #####          #    # #    # # # #  #   #
  //    #   # #      #              #####  ###### # #  # #   #
  //    #   # #      #              #      #    # # #   ##   #
  //    #   # ###### ###### ####### #      #    # # #    #   #
  public void paint(){
    pane(x*2,y*2,z,TILE_FLOOR,NORTH,mat[0]);
    if(down[0])
      pane((x*2)+1,(y*2),z-1,types[0],WEST,mat[1]);
      else if (types[0] == TILE_FLOOR)
        pane((x*2)+1,(y*2),z,types[0],NORTH,mat[1]);
      else
        pane((x*2)+1,(y*2),z,types[0],EAST,mat[1]);
    if(down[1])
      pane((x*2),(y*2)+1,z-1,types[1],NORTH,mat[2]);
      else if(types[1] == TILE_FLOOR)
        pane((x*2),(y*2)+1,z,types[1],NORTH,mat[2]);
      else
        pane((x*2),(y*2)+1,z,types[1],SOUTH,mat[2]);
    if(down[2])
      pane((x*2)+1,(y*2)+1,z-1,types[2],orientation,mat[3]);
      else
      pane((x*2)+1,(y*2)+1,z,types[2],orientation,mat[3]);
  }

}
