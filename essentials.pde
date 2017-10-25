import java.awt.event.KeyEvent;

//
//  #####   ####  # #    # #####
//  #    # #    # # ##   #   #
//  #    # #    # # # #  #   #
//  #####  #    # # #  # #   #
//  #      #    # # #   ##   #
//  #       ####  # #    #   #
class Point {
  int x, y;

  public Point(float x, float y){
    this.x = floor(x);
    this.y = floor(y);
  }

  @Override
  public boolean equals(Object obj){
    if( obj == null) return false;
    if( ((Point)obj).x == x && ((Point)obj).y == y){
      return true;
    }
    return false;
  }

  @Override
  public int hashCode(){
    return (""+x+"x"+y).hashCode();
  }

}

//
//   ####    ##   #    # ###### #####    ##
//  #    #  #  #  ##  ## #      #    #  #  #
//  #      #    # # ## # #####  #    # #    #
//  #      ###### #    # #      #####  ######
//  #    # #    # #    # #      #   #  #    #
//   ####  #    # #    # ###### #    # #    #

Camera cam = new Camera(0,0,-200);

class Camera {

  PVector pos;
  PVector forward, right;

  int minDistance, maxDistance;
  int speed = 25;
  float boost = 5;
  float maxDist = 1000;
  float minDist = 10;

  float xRot, zRot;

  public Camera(int x, int y, int z){
    pos = new PVector(x,y,z);
    forward = new PVector(0,speed);
    right = new PVector(speed,0);
    xRot = 20;
    zRot = 45;
    forward.rotate(radians(-zRot));
    right.rotate(radians(-zRot));

  }

  public void rotate(int x, int y){
    zRot -= x;
    xRot += y;
    if(xRot > 75)
      xRot = 75;
    if(xRot < 0)
      xRot = 0;
    forward.rotate(radians(x));
    right.rotate(radians(x));
  }

  public void moveUp(){
    pos.y += forward.y;
    pos.x += forward.x;
    if(kb.pressed(kb.BOOST)){
      pos.y += forward.y*boost;
      pos.x += forward.x*boost;
    }
  }

  public void moveDown(){
    pos.y-= forward.y;
    pos.x-= forward.x;
    if(kb.pressed(kb.BOOST)){
      pos.y -= forward.y*boost;
      pos.x -= forward.x*boost;
    }
  }
  public void moveLeft(){
    pos.x+= right.x;
    pos.y+= right.y;
    if(kb.pressed(kb.BOOST)){
      pos.y += right.y*boost;
      pos.x += right.x*boost;
    }
  }
  public void moveRight(){
    pos.x-= right.x;
    pos.y-= right.y;
    if(kb.pressed(kb.BOOST)){
      pos.y -= right.y*boost;
      pos.x -= right.x*boost;
    }
  }

  public PVector tile(){
    return new PVector((int)-cam.pos.x/PANESIZE/2,(int)-cam.pos.y/PANESIZE/2);
  }

  public void zoom(float val){
    pos.z += val*pos.z/10;
    if(pos.z<-maxDist)
      pos.z=-maxDist;
    if(pos.z > -minDist){
      pos.z=-minDist;
    }
  }

}

//
//  #    # ###### #   # #####   ####    ##   #####  #####
//  #   #  #       # #  #    # #    #  #  #  #    # #    #
//  ####   #####    #   #####  #    # #    # #    # #    #
//  #  #   #        #   #    # #    # ###### #####  #    #
//  #   #  #        #   #    # #    # #    # #   #  #    #
//  #    # ######   #   #####   ####  #    # #    # #####
class KeyBoard {

  int MOVE_FORWARD = 0;
  int MOVE_LEFT = 1;
  int MOVE_RIGHT = 2;
  int MOVE_BACK = 3;
  int BOOST = 4;

  int LASTKEY = 5;

  boolean[] keys;
  int[] chars;


  public KeyBoard(){
    keys = new boolean[LASTKEY];
    chars = new int[LASTKEY];
    //TODO: parse controls;
    chars[MOVE_FORWARD] = KeyEvent.VK_W;
    chars[MOVE_LEFT] = KeyEvent.VK_A;
    chars[MOVE_RIGHT] = KeyEvent.VK_D;
    chars[MOVE_BACK] = KeyEvent.VK_S;
    chars[BOOST] = KeyEvent.VK_SHIFT;
    println("Keyboard set up!_");
  }

  public void press(int k){
    for(int i=0; i<chars.length; i++){
      if(k == chars[i]){
        keys[i] = true;
        return;
      }
    }
  }

  public void release(int k){
    for(int i=0; i<chars.length; i++){
      if(k == chars[i]){
        keys[i] = false;
        return;
      }
    }
  }

  public boolean pressed(int k){
    return keys[k];
  }



}
