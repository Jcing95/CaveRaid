
ArrayList<Jimg> mtex;
Textures tex;
final int TEXTUREWIDTH = 32;

class Textures {

  BaseTextures base;
  Liquids liquid;
  Walls wall;
  Ressources ressources;

  public Textures(){
    base = new BaseTextures();
    liquid = new Liquids();
    wall = new Walls();
    ressources = new Ressources();
    mth = new MaterialHandler();
    println("initialized textures!_");
  }
}

class BaseTextures{
  int STONE;
  int COBBLE;
  int DIRT;
  int MARBLE;
}

class Liquids{
  int LAVA;
}

class Walls{
  int COBBLE;
  int MARBLE;
}

class Ressources{
  int GRAVEL;
  int IRON;
  int COAL;
}



void initMaterial(){
  tex = new Textures();
  //
  //  #####    ##    ####  ######
  //  #    #  #  #  #      #
  //  #####  #    #  ####  #####
  //  #    # ######      # #
  //  #    # #    # #    # #
  //  #####  #    #  ####  ######
  mtex = new ArrayList<Jimg>();
  tex.base.STONE = mtex.size();
  mtex.add(new Jimg("gfx/terrain/base/stone"));
  tex.base.COBBLE = mtex.size();
  mtex.add(new Jimg("gfx/terrain/base/cobble"));
  tex.base.DIRT = mtex.size();
  mtex.add(new Jimg("gfx/terrain/base/dirt"));
  tex.base.MARBLE = mtex.size();
  mtex.add(new Jimg("gfx/terrain/base/marble"));
  //
  //  #    #   ##   #      #       ####
  //  #    #  #  #  #      #      #
  //  #    # #    # #      #       ####
  //  # ## # ###### #      #           #
  //  ##  ## #    # #      #      #    #
  //  #    # #    # ###### ######  ####
  tex.wall.COBBLE = mtex.size();
  mtex.add(new Jimg("gfx/terrain/wall/cobble"));
  tex.wall.MARBLE = mtex.size();
  mtex.add(new Jimg("gfx/terrain/wall/marble"));
  //
  //  #      #  ####  #    # # #####
  //  #      # #    # #    # # #    #
  //  #      # #    # #    # # #    #
  //  #      # #  # # #    # # #    #
  //  #      # #   #  #    # # #    #
  //  ###### #  ### #  ####  # #####
  tex.liquid.LAVA = mtex.size();
  mtex.add(new Jimg("gfx/terrain/liquid/lava",5));


  //
  //  #####  ######  ####   ####   ####  #    # #####   ####  ######  ####
  //  #    # #      #      #      #    # #    # #    # #    # #      #
  //  #    # #####   ####   ####  #    # #    # #    # #      #####   ####
  //  #####  #           #      # #    # #    # #####  #      #           #
  //  #   #  #      #    # #    # #    # #    # #   #  #    # #      #    #
  //  #    # ######  ####   ####   ####   ####  #    #  ####  ######  ####
  tex.ressources.IRON = mtex.size();
  mtex.add(new Jimg("gfx/terrain/ressources/iron"));
  tex.ressources.COAL = mtex.size();
  mtex.add(new Jimg("gfx/terrain/ressources/coal"));
  tex.ressources.GRAVEL = mtex.size();
  mtex.add(new Jimg("gfx/terrain/ressources/gravel"));
  println("initialized material!_");
}

//
//  #    #   ##   ##### ###### #####  #   ##   #      #    #   ##   #    # #####  #      ###### #####
//  ##  ##  #  #    #   #      #    # #  #  #  #      #    #  #  #  ##   # #    # #      #      #    #
//  # ## # #    #   #   #####  #    # # #    # #      ###### #    # # #  # #    # #      #####  #    #
//  #    # ######   #   #      #####  # ###### #      #    # ###### #  # # #    # #      #      #####
//  #    # #    #   #   #      #   #  # #    # #      #    # #    # #   ## #    # #      #      #   #
//  #    # #    #   #   ###### #    # # #    # ###### #    # #    # #    # #####  ###### ###### #    #

MaterialHandler mth; //TODO: better Name

class MaterialHandler implements Runnable{

  HashMap<Integer, Material> tmats;
  HashMap<Integer, Material> wmats;

  boolean randomTextures = true;
  int waitTime = 20;
  LinkedList<Material> jobs;
  boolean running;
  Thread th;

  public MaterialHandler(){
    tmats = new HashMap<Integer,Material>();
    wmats = new HashMap<Integer,Material>();

    running = true;
    jobs = new LinkedList<Material>();
    th = new Thread(this);
    th.start();
  }

  public void run(){
    int last = millis();
    while(running){
      while(jobs.isEmpty()){
        try{
          Thread.sleep(waitTime);
        } catch(InterruptedException e){

        }
      }
      while(!jobs.isEmpty()){
        jobs.getFirst().create();
        jobs.removeFirst();
      }
    }
  }

  public Material wall(int type){
    Material m = new Material(type, (int)random(123456));
    if(wmats.keySet().contains(m.hashCode()))
      return wmats.get(m.hashCode());
    jobs.add(m);
    wmats.put(m.hashCode(),m);
    return m;
  }

  public Material tile(int type){
    Material m;
    if(randomTextures)
      m = new Material(type, (int)random(132456));
    else
      m = new Material(type, 0);
    if(tmats.keySet().contains(m.hashCode()))
      return tmats.get(m.hashCode());
    jobs.add(m);
    tmats.put(m.hashCode(),m);
    return m;
  }

  public Material tile(LinkedList<Integer> type){
    Material m;
    if(randomTextures)
      m = new Material(type, (int)random(132456));
    else
      m = new Material(type, 0);
    if(tmats.keySet().contains(m.hashCode()))
      return tmats.get(m.hashCode());
    jobs.add(m);
    tmats.put(m.hashCode(),m);
    return m;
  }


}


//
//  #    #   ##   ##### ###### #####  #   ##   #
//  ##  ##  #  #    #   #      #    # #  #  #  #
//  # ## # #    #   #   #####  #    # # #    # #
//  #    # ######   #   #      #####  # ###### #
//  #    # #    #   #   #      #   #  # #    # #
//  #    # #    #   #   ###### #    # # #    # ######
class Material {

  LinkedList<Integer> tx;
  PImage[] tex;
  int hash;
  int[] r;
  boolean animated;
  double FPS;

  boolean initialized;

  public Material(int base, int seed){
    initialized = false;
    tx = new LinkedList<Integer>();
    tx.add(base);
    randomSeed(seed);
    generate();
  }

  public Material(LinkedList<Integer> textures, int seed){
    initialized = false;
    tx = textures;
    randomSeed(seed);
    generate();
  }

  @Override
  public int hashCode(){
    return hash;
  }

  /*public void addTex(int tex){
    tx.add(tex);
  }*/

  public PImage[] tex(){
  //  println("" + tex.length + " - " + (frame()%tex.length));
    return tex;
  }


  private void generate(){
    r = new int[tx.size()];
    for(int i = 0; i<r.length; i++){
      r[i] = (int)random(123456);
    }
    String hs = "";
    int hid = 0;
    for(int id : tx){
      hs += id;
      hs += "T";
      hs += mtex.get(id).getID(r[hid]);
      hs += "H";
    }
    hash = hs.hashCode();
  }

  public void create(){
    if(r == null)
      return;
    Jimg base = mtex.get(tx.getFirst());
    FPS = base.fps;
    tex = new PImage[base.frames(r[0])];
    println("creating " + base.label + " w/hash: " + hash + " - (" + tex.length + " frames)");
    if(tex.length>1)
      animated = true;
    for(int i = 0; i<tex.length; i++){
      PGraphics g = createGraphics(mtex.get(tx.getFirst()).get(r[0]).width, mtex.get(tx.getFirst()).get(r[0]).height);
      g.beginDraw();
      g.fill(0);
      g.noStroke();
      int j = 0;
      for(int id : tx){
        int f = 0;
        if(id == tx.getFirst())
          f = i;
        g.image(mtex.get(id).get(r[j],f),0,0);
        j++;
      }
      g.endDraw();
      tex[i] = g;
    }
    r = null;
    initialized = true;
  }



}
