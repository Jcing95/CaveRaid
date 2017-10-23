public class Menu {

  boolean active;
  Button test;

  public Menu(){
    test = new Button(200,200,200,50,"TEST");
    //active = true;
    println("Menu created!");
  }


  public void paint(){
    if(!active)
      return;

    test.paint();


  }


}


public class Button{

  int x, y, w, h;
  String label;

  public Button(int x, int y, int w, int h, String label){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }

  public void paint(){
    pushMatrix();
    translate(x,y);
    fill(0xb0afafaf);
    rect(0,0,w,h);
    translate(w/2-textWidth(label)/2,h*0.6);
    fill(0);
    stroke(0);
    text(label,0,0);
    popMatrix();
  }


}
