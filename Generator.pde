


class WorldGen {

  Noise heights;
  Noise[] matNoises;
  Noise[] terrNoises;

  public WorldGen(){
    heights = new Noise(123456,16,0.65,30,4);
    matNoises = new Noise[5];
    matNoises[0] = new Noise(123,8,0.5,5,2); //
    matNoises[1] = new Noise(124,8,0.5,5,2);
    matNoises[2] = new Noise(125,8,0.5,5,2);
    matNoises[3] = new Noise(126,8,0.5,5,2);
    matNoises[4] = new Noise(127,8,0.5,5,2);
    terrNoises = new Noise[3];
    terrNoises[0] = new Noise(222,6,0.5,60,2);
    terrNoises[1] = new Noise(223,6,0.5,60,2);
    terrNoises[2] = new Noise(224,6,0.5,60,2);
  }

  Material getMat(float x, float y){
    if(getZ(x,y) == 0 && getZ(floor(x),floor(y)) == 0)
      return mth.tile(tex.liquid.LAVA);
    double[] val = new double[matNoises.length];
    for(int i=0; i<val.length; i++){
      val[i] = matNoises[i].noise(x,y);
    }
    double[] terr = new double[terrNoises.length];
    for(int i=0; i<terr.length; i++){
      terr[i] = terrNoises[i].noise(x,y);
    }
    LinkedList<Integer> mats = new LinkedList<Integer>();
    if(terr[0] > 1.8 && terr[1] > 1.4)
      mats.add(tex.base.MARBLE);
    else
      mats.add(tex.base.COBBLE);
    if(val[2] < 1.5 && val[3] > 1 && val[4] > 1 && val[0] < 1.5 && val[1] > 0.5)
      mats.add(tex.ressources.GRAVEL);
    if(val[0] > 1 && val[1] < 1 && val[2] < 1 && val[3] > 1){
      mats.add(tex.ressources.IRON);
      return mth.tile(mats);
    }
    if(val[0] < 1 && val[1] < 1 && val[2] > 0.5){
      mats.add(tex.ressources.COAL);
      return mth.tile(mats);
    }
    return mth.tile(mats);
  }

  Material getWall(float x, float y){
    //if(getZ(x,y) == 0 && getZ(floor(x),floor(y)) == 0)
    //  return mth.tile(tex.liquid.LAVA);
    double[] val = new double[matNoises.length];
    for(int i=0; i<val.length; i++){
      val[i] = matNoises[i].noise(x,y);
    }
    double[] terr = new double[terrNoises.length];
    for(int i=0; i<terr.length; i++){
      terr[i] = terrNoises[i].noise(x,y);
    }
    LinkedList<Integer> mats = new LinkedList<Integer>();
    if(terr[0] > 1.8 && terr[1] > 1.4)
      mats.add(tex.wall.MARBLE);
    else
      mats.add(tex.wall.COBBLE);
    /*if(val[2] < 1.5 && val[3] > 1 && val[4] > 1 && val[0] < 1.5 && val[1] > 0.5)
      mats.add(tex.ressources.GRAVEL);
    if(val[0] > 1 && val[1] < 1 && val[2] < 1 && val[3] > 1){
      mats.add(tex.ressources.IRON);
      return mth.tile(mats);
    }
    if(val[0] < 1 && val[1] < 1 && val[2] > 0.5){
      mats.add(tex.ressources.COAL);
      return mth.tile(mats);
    }*/
    return mth.tile(mats);
  }

  int getZ(float x, float y){
    return (int)abs(heights.noise(x,y)-1);
  }


}

double abs(double i){
  if(i< 0)
    return i*-1;
  return i;
}

class Noise {

  OpenSimplexNoise noise;
  int seed, octaves;
  float falloff;
  float interpolation;
  float range;

  public Noise(int seed, int octaves, float falloff, float interpolation, float range) {
    this.seed = seed;
    this.octaves = octaves;
    this.falloff = falloff;
    this.interpolation = interpolation;
    this.range = range;
    noise = new OpenSimplexNoise(seed);

  }

  public double noise(float x, float y){
    float fall=1;
    double val = 0;//(1+(noise.eval(x/interpolation,y/interpolation)/2.0))*range;
    for(int i=1;i<=octaves;i++){
      val += (fall*0.5*range/(i)*(1+noise.eval(x/(interpolation/i)*i,y/(interpolation/i)*i)));
      //println(i + ":  " + (fall*0.5*(noise.eval(x/(interpolation*fall)*i,y/(interpolation*fall)*i))));
      fall *= falloff;
    }
    //println(val*range);
    return val;
  }

  private float pow(float base, int exp){
    for(int i=0; i<exp; i++)
     base *= base;
    return base;
  }

  public float noise(float x, float y, float z){
    float val=0, fall=1;
    for(int i=0;i<octaves;i++){
      val+=range*(fall*noise(x/interpolation,y/interpolation,z/interpolation));
      fall *= falloff;
    }
    return val/octaves;
  }

}
