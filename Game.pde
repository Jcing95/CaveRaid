class Game implements Runnable{

  Thread th;

  int TPS = 60;

  boolean running;


  public Game(){
    running = true;
    th = new Thread(this);
    th.start();
    println("Game started!_");
  }

  public void run(){
    int lastMillis = millis();
    while(running){
      if(millis()-lastMillis > 1000/TPS){
        lastMillis = millis();
        tick();
      }
      try{
      Thread.sleep(10);
      } catch (InterruptedException e) {

      }
    }
  }


}
