import java.io.File;
import java.util.Arrays;
import java.util.Comparator;

// CONSTANTS
//TileShape pane;
ShapeManager shm;
int PANESIZE;

//
//  # #    # # #####     ####  ###### #    #
//  # ##   # #   #      #    # #       #  #
//  # # #  # #   #      #      #####    ##
//  # #  # # #   #      #  ### #        ##
//  # #   ## #   #      #    # #       #  #
//  # #    # #   #       ####  #      #    #

void initgfx(){
  textureMode(NORMAL);
  PANESIZE = (int)sqrt((width*width)+(height*height))/10;
  shm = new ShapeManager();
  //pane = new TileShape();
  println("initialized gfx_");
}

int frame(){
  return millis()/100;
}

int frame(double fps){
  return (int)(millis()/1000.0*fps);
}

//        #
//        # # #    #  ####
//        # # ##  ## #    #
//        # # # ## # #
//  #     # # #    # #  ###
//  #     # # #    # #    #
//   #####  # #    #  ####

//Jimg is a Picture / seeded picture / animated picture
class Jimg {
  ArrayList<Jimg> imgs;
  boolean isImg;
  boolean anim;
  String label;
  double fps;
  PImage img;

  //picture if path is a file
  //seeded if path is a directory
  //animated if path has subdirectories

  public Jimg(String path){
    label = path;
    this.fps = 10;
    this.init(new File(new File(dataPath("")), path),false);
  }

  public Jimg(PImage img, String label, double fps){
    this.label = label;
    this.fps = fps;
    this.img = img;
    isImg = true;
  }

  public Jimg(String path, double fps){
    label = path;
    this.fps = fps;
    this.init(new File(new File(dataPath("")), path),false);
  }

  public Jimg(File loc, boolean isAnimation,String label, double fps){
    this.fps = fps;
    this.label = label;
    init(loc, isAnimation);
  }

  private void init(File loc, boolean isAnimation){
    if(loc.isFile()){ //is File --> load image
      println("loading File: " + label);
      isImg = true;
      img = loadImage(loc.getPath());
      return;
    }
    if(loc.isDirectory()){ //not a Picture --> multiple / animation
      isImg = false;
      imgs = new ArrayList<Jimg>();
      File[] files = loc.listFiles();
      sorti(files); //Sort files in ascending numeric order (last number in filename)
      if(isAnimation && files[0].isDirectory()){ //Directories are stacked frame by frame
        println("loading StackAnimation: " + label + " (" + files.length + " images stacked)");
        File[][] frames = new File[files.length][];
        PImage[][] layers = new PImage[files.length][];
        for(int i=0; i< files.length; i++){
          if(files[i].isDirectory()){
            frames[i] = files[i].listFiles();
            sorti(frames[i]);
            layers[i] = new PImage[frames[i].length];
            for(int j=0; j<frames[i].length; j++){
              layers[i][j] = loadImage(frames[i][j].getPath());
            }
          }else{
            frames[i] = new File[1];
            frames[i][0] = files[i];
            layers[i] = new PImage[1];
            layers[i][0] = loadImage(frames[i][0].getPath());
          }
        }
        int[] index = new int[frames.length];
        for(int i=0; i<frames.length; i++)
          index[i] = 0;
        ArrayList<PGraphics> layerImgs = new ArrayList<PGraphics>();
        do{
            PGraphics g = createGraphics(layers[0][index[0]].width,layers[0][index[0]].height);
            g.beginDraw();
            g.fill(0);
            for(int i=0; i<layers.length; i++){
              g.image(layers[i][index[i]], 0, 0);
              index[i]++;
              index[i]%=layers[i].length;
            }
            g.endDraw();
            layerImgs.add(g);
        }while(!checkIndexes(index));
        println(layerImgs.size());
        imgs = new ArrayList<Jimg>(layerImgs.size());
        for(PGraphics g: layerImgs){
          imgs.add(new Jimg(g,label,fps));
        }
        return;
      }
      println("loading Animation: " + label);
      for(File f: files) {
        if(f.isDirectory()){ //must be a animation
          anim = true;
          imgs.add(new Jimg(f,true,label, fps)); //add animation
        }else{
          imgs.add(new Jimg(f,false,label, fps)); //add Picture
        }
      }
    }
  }

  private boolean checkIndexes(int[] index){
    boolean zero = true;
    for(int i: index)
      if(i != 0)
        return false;
    return true;
  }

  private void sorti(File[] files){
    Arrays.sort(files, new Comparator<File>(){
        public int compare(File o1, File o2){
          String name1 = o1.getName();
          String name2 = o2.getName();
            if(name1 != null && !name1.isEmpty()){
              String num = "";
              boolean found = false;
              boolean newd = false;;
              for(char c : name1.toCharArray()){
                  if(Character.isDigit(c)){
                      if(newd)
                        num = "";
                      num += c;
                      found = true;
                  } else if(found){
                      newd = true;
                  }
              }
              name1 = num;
            }
            if(name2 != null && !name2.isEmpty()){
              String num = "";
              boolean found = false;
              boolean newd = false;
              for(char c : name2.toCharArray()){
                  if(Character.isDigit(c)){
                      if(newd)
                        num = "";
                      num += c;
                      found = true;
                  } else if(found){
                      newd = true;
                  }
              }
              name2 = num;
            }
          if(Integer.parseInt(name1) > Integer.parseInt(name2)){
            return 1;
          }
          return -1;
        }

        public boolean equals(Object o){
          return false;
        }
      });
  }

  public int getID(int seed){
    return seed % imgs.size();
  }

  public int frames(int id){
    if(!anim)
      return 1;
    id %= imgs.size();
    return imgs.get(id).imgs.size();
  }

  public PImage get(int id){
    if(isImg)
      return img;
    id %= imgs.size();
    return imgs.get(id).get(frame());
  }

  public PImage get(int id, int frame){
    if(isImg)
      return img;
    id %= imgs.size();
    return imgs.get(id).get(frame);
  }

}



final int TILE_FLOOR=0;
final int TILE_WALL=1;
final int TILE_SLOPE=2;

final int TILE_INNER_CORNER_WALL=3;
final int TILE_OUTER_CORNER_WALL=4;
final int TILE_INNER_CORNER_SLOPE=5;
final int TILE_OUTER_CORNER_SLOPE=6;

final int TILE_CONNECT_SLOPE_WALL=7;
final int TILE_CONNECT_WALL_SLOPE=8;

final int TILE_CONNECTOR_SLOPE_UP=9;
final int TILE_CONNECTOR_SLOPE_DOWN=10;

 int TILE_CONNECT_INNER_CORNER_WALL_SLOPE=11;
 int TILE_CONNECT_OUTER_CORNER_WALL_SLOPE=12;
 int TILE_CONNECT_INNER_CORNER_SLOPE_WALL=13;
int TILE_CONNECT_OUTER_CORNER_SLOPE_WALL=14;

final int TILE_SHAPENUM=15;

/*
void pane(int x, int y, int z, int type, int orientation, Material mat){
  pane.paint(x,y,z,type,orientation,mat);
}*/

//                                ##    ##
//  #####    ##   #    # ######  #        #
//  #    #  #  #  ##   # #      #          #
//  #    # #    # # #  # #####  #          #
//  #####  ###### #  # # #      #          #
//  #      #    # #   ## #       #        #
//  #      #    # #    # ######   ##    ##

int camDistance(int x, int y){
  return (int)sqrt((x+cam.pos.x)*(x+cam.pos.x)+(y+cam.pos.y)*(y+cam.pos.y));
}

int VIEWDISTANCE = 75;

void pane(int x, int y, int z, int type, int orientation, Material mat, int col){
  if(!mat.initialized || camDistance(x*PANESIZE,y*PANESIZE) > (height/2.0) / tan(PI/3.0/2.0) * 10.0){
    return;
  }
  pushMatrix();
  translate(x*PANESIZE, y*PANESIZE);
  translate(PANESIZE/2,PANESIZE/2);
  rotateZ(radians(orientation*90));
  translate(-PANESIZE/2,-PANESIZE/2);
  translate(0,0,z*PANESIZE);
  fill(255);
  shm.get(mat,type).setTint(col);
  shape(shm.get(mat,type),0,0);
  popMatrix();

}


//
//   ####  #    #   ##   #####  ######  ####  ###### #    #
//  #      #    #  #  #  #    # #      #    # #      ##   #
//   ####  ###### #    # #    # #####  #      #####  # #  #
//       # #    # ###### #####  #      #  ### #      #  # #
//  #    # #    # #    # #      #      #    # #      #   ##
//   ####  #    # #    # #      ######  ####  ###### #    #

class ShapeManager {
  ArrayList<HashMap<Material,PShape[]>> shapes;


  public ShapeManager(){
    shapes = new ArrayList<HashMap<Material, PShape[]>>(TILE_SHAPENUM);
    for(int i=0; i<TILE_SHAPENUM; i++){
      shapes.add(new HashMap<Material, PShape[]>());
    }
  }

  public PShape get(Material mat, int shape){
    if(!shapes.get(shape).keySet().contains(mat)){
      PShape[] shapeFrames = new PShape[mat.tex().length];
      for(int i =0; i< mat.tex().length; i++)
        shapeFrames[i] = makeShape(shape,mat.tex()[i]);
      shapes.get(shape).put(mat,shapeFrames);
    }
    return shapes.get(shape).get(mat)[frame(mat.FPS)%shapes.get(shape).get(mat).length];
  }

  PShape makeShape(int shapeid, PImage tex){
    PShape shape = createShape();
    PShape child;
    switch(shapeid){
      case TILE_FLOOR:
        shape.beginShape();
        shape.noStroke();
        shape.vertex(0,0,0,0,0);
        shape.vertex(PANESIZE,0,0,1,0);
        shape.vertex(PANESIZE,PANESIZE,0,1,1);
        shape.vertex(0,PANESIZE,0,0,1);
        shape.endShape();
        break;
      case TILE_SLOPE:
        shape.beginShape();
        shape.noStroke();
        shape.vertex(0,0,PANESIZE/2,0,0);
        shape.vertex(PANESIZE,0,PANESIZE/2,1,0);
        shape.vertex(PANESIZE,PANESIZE,0,1,1);
        shape.vertex(0,PANESIZE,0,0,1);
        shape.endShape();
        break;
      case TILE_WALL:
        shape = createShape();
        shape.beginShape();
        shape.noStroke();
        shape.vertex(0,0,PANESIZE,0,0);
        shape.vertex(PANESIZE,0,PANESIZE,1,0);
        shape.vertex(PANESIZE,PANESIZE,0,1,1);
        shape.vertex(0,PANESIZE,0,0,1);
        shape.endShape();
      break;
      case TILE_CONNECT_SLOPE_WALL:
        shape = createShape();
        shape.beginShape();
        shape.noStroke();
        shape.vertex(0,0,PANESIZE/2,0,0);
        shape.vertex(PANESIZE,0,PANESIZE,1,0);
        shape.vertex(PANESIZE,PANESIZE,0,1,1);
        shape.vertex(0,PANESIZE,0,0,1);
        shape.endShape();
      break;
      case TILE_CONNECT_WALL_SLOPE:
        shape = createShape();
        shape.beginShape();
        shape.noStroke();
        shape.vertex(0,0,PANESIZE,0,0);
        shape.vertex(PANESIZE,0,PANESIZE/2,1,0);
        shape.vertex(PANESIZE,PANESIZE,0,1,1);
        shape.vertex(0,PANESIZE,0,0,1);
        shape.endShape();
      break;
      case TILE_INNER_CORNER_SLOPE:
        shape = createShape(GROUP);
        child = createShape();
        child.beginShape();
        child.noStroke();
        child.vertex(0,0,PANESIZE/2,0,0);
        child.vertex(PANESIZE,0,PANESIZE/2,1,0);
        child.vertex(0,PANESIZE,PANESIZE/2,0,1);
        child.endShape();
        shape.addChild(child);
        child = createShape();
        child.beginShape();
        child.noStroke();
        child.vertex(PANESIZE,0,PANESIZE/2,1,0);
        child.vertex(PANESIZE,PANESIZE,0,1,1);
        child.vertex(0,PANESIZE,PANESIZE/2,0,1);
        child.endShape();
        shape.addChild(child);
        break;
      case TILE_OUTER_CORNER_SLOPE:
        shape = createShape(GROUP);
        child = createShape();
        child.beginShape();
        child.noStroke();
        child.vertex(0,0,PANESIZE/2,0,0);
        child.vertex(0,PANESIZE,0,0,1);
        child.vertex(PANESIZE,0,0,1,0);
        child.endShape();
        shape.addChild(child);
        child = createShape();
        child.beginShape();
        child.noStroke();
        child.vertex(0,PANESIZE,0,0,1);
        child.vertex(PANESIZE,0,0,1,0);
        child.vertex(PANESIZE,PANESIZE,0,1,1);
        child.endShape();
        shape.addChild(child);
      break;
      case TILE_INNER_CORNER_WALL:
        shape = createShape(GROUP);
        child = createShape();
        child.beginShape();
        child.noStroke();
        child.vertex(0,0,PANESIZE,0,0);
        child.vertex(PANESIZE,0,PANESIZE,1,0);
        child.vertex(0,PANESIZE,PANESIZE,0,1);
        child.endShape();
        shape.addChild(child);
        child = createShape();
        child.beginShape();
        child.noStroke();
        child.vertex(PANESIZE,0,PANESIZE,1,0);
        child.vertex(PANESIZE,PANESIZE,0,1,1);
        child.vertex(0,PANESIZE,PANESIZE,0,1);
        child.endShape();
        shape.addChild(child);
      break;
      case TILE_OUTER_CORNER_WALL:
        shape = createShape(GROUP);
        child = createShape();
        child.beginShape();
        child.noStroke();
        child.vertex(0,0,PANESIZE,0,0);
        child.vertex(0,PANESIZE,0,0,1);
        child.vertex(PANESIZE,0,0,1,0);
        child.endShape();
        shape.addChild(child);
        child = createShape();
        child.beginShape();
        child.noStroke();
        child.vertex(0,PANESIZE,0,0,1);
        child.vertex(PANESIZE,0,0,1,0);
        child.vertex(PANESIZE,PANESIZE,0,1,1);
        child.endShape();
        shape.addChild(child);
      break;
    }
    shape.setTexture(tex);
    return shape;
  }
}

//
//  ##### # #      ######  ####  #    #   ##   #####  ######
//    #   # #      #      #      #    #  #  #  #    # #
//    #   # #      #####   ####  ###### #    # #    # #####
//    #   # #      #           # #    # ###### #####  #
//    #   # #      #      #    # #    # #    # #      #
//    #   # ###### ######  ####  #    # #    # #      ######
/*class TileShape {

  PShape tile, wall, slope;
  PShape innerCornerWall, innerCornerSlope;
  PShape outerCornerWall, outerCornerSlope;
  ArrayList<PShape> shapes;

  public TileShape(){
    shapes = new ArrayList<PShape>();
    PShape shape, child;

    //TILE_FLOOR = shapes.size();
    shape = createShape();
    shape.beginShape();
    shape.noStroke();
    shape.vertex(0,0,0,0,0);
    shape.vertex(PANESIZE,0,0,1,0);
    shape.vertex(PANESIZE,PANESIZE,0,1,1);
    shape.vertex(0,PANESIZE,0,0,1);
    shape.endShape();
    shapes.add(shape);

    //TILE_WALL = shapes.size();
    shape = createShape();
    shape.beginShape();
    shape.noStroke();
    shape.vertex(0,0,PANESIZE,0,0);
    shape.vertex(PANESIZE,0,PANESIZE,1,0);
    shape.vertex(PANESIZE,PANESIZE,0,1,1);
    shape.vertex(0,PANESIZE,0,0,1);
    shape.endShape();
    shapes.add(shape);

    //TILE_SLOPE = shapes.size();
    shape = createShape();
    shape.beginShape();
    shape.noStroke();
    shape.vertex(0,0,PANESIZE/2,0,0);
    shape.vertex(PANESIZE,0,PANESIZE/2,1,0);
    shape.vertex(PANESIZE,PANESIZE,0,1,1);
    shape.vertex(0,PANESIZE,0,0,1);
    shape.endShape();
    shapes.add(shape);

    //TILE_INNER_CORNER_WALL = shapes.size();
    shape = createShape(GROUP);
    child = createShape();
    child.beginShape();
    child.noStroke();
    child.vertex(0,0,PANESIZE,0,0);
    child.vertex(PANESIZE,0,PANESIZE,1,0);
    child.vertex(0,PANESIZE,PANESIZE,0,1);
    child.endShape();
    shape.addChild(child);
    child = createShape();
    child.beginShape();
    child.noStroke();
    child.vertex(PANESIZE,0,PANESIZE,1,0);
    child.vertex(PANESIZE,PANESIZE,0,1,1);
    child.vertex(0,PANESIZE,PANESIZE,0,1);
    child.endShape();
    shape.addChild(child);
    shapes.add(shape);

    //TILE_OUTER_CORNER_WALL = shapes.size();
    shape = createShape(GROUP);
    child = createShape();
    child.beginShape();
    child.noStroke();
    child.vertex(0,0,PANESIZE,0,0);
    child.vertex(0,PANESIZE,0,0,1);
    child.vertex(PANESIZE,0,0,1,0);
    child.endShape();
    shape.addChild(child);
    child = createShape();
    child.beginShape();
    child.noStroke();
    child.vertex(0,PANESIZE,0,0,1);
    child.vertex(PANESIZE,0,0,1,0);
    child.vertex(PANESIZE,PANESIZE,0,1,1);
    child.endShape();
    shape.addChild(child);
    shapes.add(shape);

    //TILE_INNER_CORNER_SLOPE = shapes.size();
    shape = createShape(GROUP);
    child = createShape();
    child.beginShape();
    child.noStroke();
    child.vertex(0,0,PANESIZE/2,0,0);
    child.vertex(PANESIZE,0,PANESIZE/2,1,0);
    child.vertex(0,PANESIZE,PANESIZE/2,0,1);
    child.endShape();
    shape.addChild(child);
    child = createShape();
    child.beginShape();
    child.noStroke();
    child.vertex(PANESIZE,0,PANESIZE/2,1,0);
    child.vertex(PANESIZE,PANESIZE,0,1,1);
    child.vertex(0,PANESIZE,PANESIZE/2,0,1);
    child.endShape();
    shape.addChild(child);
    shapes.add(shape);

    //TILE_OUTER_CORNER_SLOPE = shapes.size();
    shape = createShape(GROUP);
    child = createShape();
    child.beginShape();
    child.noStroke();
    child.vertex(0,0,PANESIZE/2,0,0);
    child.vertex(0,PANESIZE,0,0,1);
    child.vertex(PANESIZE,0,0,1,0);
    child.endShape();
    shape.addChild(child);
    child = createShape();
    child.beginShape();
    child.noStroke();
    child.vertex(0,PANESIZE,0,0,1);
    child.vertex(PANESIZE,0,0,1,0);
    child.vertex(PANESIZE,PANESIZE,0,1,1);
    child.endShape();
    shape.addChild(child);
    shapes.add(shape);

    //TILE_CONNECT_SLOPE_WALL = shapes.size();
    shape = createShape();
    shape.beginShape();
    shape.noStroke();
    shape.vertex(0,0,PANESIZE/2,0,0);
    shape.vertex(PANESIZE,0,PANESIZE,1,0);
    shape.vertex(PANESIZE,PANESIZE,0,1,1);
    shape.vertex(0,PANESIZE,0,0,1);
    shape.endShape();
    shapes.add(shape);

    //TILE_CONNECT_WALL_SLOPE = shapes.size();
    shape = createShape();
    shape.beginShape();
    shape.noStroke();
    shape.vertex(0,0,PANESIZE,0,0);
    shape.vertex(PANESIZE,0,PANESIZE/2,1,0);
    shape.vertex(PANESIZE,PANESIZE,0,1,1);
    shape.vertex(0,PANESIZE,0,0,1);
    shape.endShape();
    shapes.add(shape);

    //TILE_SHAPENUM = shapes.size();
  }

  public void paint(int x, int y, int z, int type, int orientation, Material mat){
    if(screenX((x+1)*PANESIZE,(y)*PANESIZE,(z)*PANESIZE) < 0 || screenX((x-1)*PANESIZE,(y)*PANESIZE,(z)*PANESIZE) > width ||
        screenY((x)*PANESIZE,(y+2)*PANESIZE,(z)*PANESIZE) < 0 || screenY((x)*PANESIZE,(y-1)*PANESIZE,(z)*PANESIZE) > height){
      return;
    }
    pushMatrix();
    PShape shape = shapes.get(type);
    translate(x*PANESIZE, y*PANESIZE);
    translate(PANESIZE/2,PANESIZE/2);
    rotateZ(radians(orientation*90));
    translate(-PANESIZE/2,-PANESIZE/2);
    translate(0,0,z*PANESIZE);

    shape.setTexture(mat.tex());
    shape(shape,0,0);
    popMatrix();
  }
}*/
