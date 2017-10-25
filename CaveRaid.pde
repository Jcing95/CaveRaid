import java.io.File;
import java.util.LinkedList;

PImage imgt;
Jimg jt;
Game game;
Cave cave;
WorldGen wg;
KeyBoard kb;

Menu menu;

Tile camTile;

float zOffset;

void settings(){
  //size(778,600,P3D);
  //size(1280,720,P3D);
  fullScreen(P3D);
}

void setup(){
  //size(1280,720,P3D);
  frameRate(60);
  ((PGraphicsOpenGL)g).textureSampling(3);
  smooth(8);
  println("starting: CaveRaid_");
  //initialisation
  colorMode(RGB);
  initgfx();
  initMaterial();
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height),
            cameraZ/10.0, cameraZ*10.0);

  kb = new KeyBoard();
  wg = new WorldGen();
  cave = new Cave();
  game = new Game();
  menu = new Menu();
}

void draw(){
    background(0);
    lights();
    pushMatrix();
    translate(width/2,height/2);
    rotateX(radians(cam.xRot));
    rotateZ(radians(cam.zRot));
    translate(-width/2,-height/2);
    camTile = cave.getTile((int)-((cam.pos.x-width/4)/PANESIZE/2.0),(int)-((cam.pos.y-height/4)/PANESIZE/2.0));
    if(camTile != null){
      camTile.tint(#ff0000);
      if(camTile.z*PANESIZE > zOffset)
        zOffset+= PANESIZE*0.02;
      if(camTile.z*PANESIZE < zOffset)
        zOffset-= PANESIZE*0.02;
    }
    translate(cam.pos.x,cam.pos.y,cam.pos.z-zOffset);
    cave.paint();
    if(camTile != null){
    translate(camTile.x*PANESIZE*2,camTile.y*PANESIZE*2,5+camTile.z*PANESIZE);
    //fill(#ff0000);
    //ellipse(PANESIZE,PANESIZE,PANESIZE/2,PANESIZE/2);
    //ellipse(-cam.pos.x+PANESIZE/4,-cam.pos.y+PANESIZE/4,PANESIZE/2,PANESIZE/2);
  }
    //shape(testShape,-cam.pos.x,-cam.pos.y);
    //image(imgt, 200,200);
    //scale(100);

    popMatrix();

    menu.paint();
    fill(#ffff00);
    text("x" + cam.pos.x/PANESIZE + " y" + cam.pos.y/PANESIZE + " z" + cam.pos.z + " rx" + cam.xRot + " rz" + cam.zRot + " FPS" + frameRate ,20,20);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  cam.zoom(event.getCount());
}

void keyPressed(){
  kb.press(keyCode);
  //key=0;
}

void keyReleased(){
  kb.release(keyCode);
  key=0;
}

int clickX, clickY;

void mousePressed(){
  clickX = mouseX;
  clickY = mouseY;
}

void mouseDragged(){
  if(mouseButton == CENTER)
    cam.rotate(mouseX-clickX, mouseY-clickY);
  clickX = mouseX;
  clickY = mouseY;
}

void tick(){
    if(kb.pressed(kb.MOVE_FORWARD)){
      cam.moveUp();
    }
    if(kb.pressed(kb.MOVE_BACK)){
      cam.moveDown();
    }
    if(kb.pressed(kb.MOVE_LEFT)){
      cam.moveLeft();
    }
    if(kb.pressed(kb.MOVE_RIGHT)){
      cam.moveRight();
    }
    //println("" + noise(-100,-100) + " " + noise(100,100));
}
