import java.io.File;
import java.util.LinkedList;

PImage imgt;
Jimg jt;
Game game;
Cave cave;
WorldGen wg;
KeyBoard kb;

Menu menu;

void settings(){
  size(1024,768,P3D);
  //size(1280,720,P3D);
  //fullScreen(P3D);
}

PShape testShape;
void setup(){
  //size(1280,720,P3D);
  frameRate(60);
  ((PGraphicsOpenGL)g).textureSampling(3);
  smooth(8);
  println("starting: CaveRaid_");
  //initialisation
  initgfx();
  initMaterial();
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height),
            cameraZ/10.0, cameraZ*10.0);

  kb = new KeyBoard();
  wg = new WorldGen();
  cave = new Cave();
  testShape = loadShape("obj/stem.obj");
  testShape.setTexture(loadImage("obj/stemnew.png"));
  testShape.scale(80);
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

    translate(cam.pos.x,cam.pos.y,cam.pos.z);
    cave.paint();
    translate(0,0,5+cave.getTile((int)-cam.pos.x/PANESIZE/2,(int)-cam.pos.y/PANESIZE/2).z*PANESIZE);
    fill(#ff0000);
    //ellipse(-cam.pos.x+PANESIZE/4,-cam.pos.y+PANESIZE/4,PANESIZE/2,PANESIZE/2);
    //shape(testShape,-cam.pos.x,-cam.pos.y);
    //image(imgt, 200,200);
    //scale(100);

    popMatrix();

    menu.paint();
    fill(#ffff00);
    text("x" + cam.pos.x/PANESIZE + " y" + cam.pos.y/PANESIZE + " z" + cam.pos.z + "  " + frameRate ,20,20);
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
