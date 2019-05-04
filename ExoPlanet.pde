



class ExoPlanet {
 


  float period;
  float radius;
  float temp;
  float axis;
  int vFlag = 1;
  

  float theta = 0;
  float thetaSpeed = 0;
  float pixelRadius = 0;
  float pixelAxis;

  float z = 0;
  float tz = 0;

  color col;

  boolean feature = false;
  String label = "";

  
  ExoPlanet() {};
  
 
  ExoPlanet fromCSV(String[] sa) {
   
   ++k;
    period = 25;
    radius = float(sa[22])/10;   
    axis =k/5268;
    temp = 254+20*(float(sa[22])); //aboard
if(temp>=13134)
{
feature=true;
label="1972";
init();
}
if(o<float(sa[22]))
{
o=float(sa[22]);
maxax=axis;
}

println(o +" " + maxax);
    return(this);
  }

  
  ExoPlanet init() {
    pixelRadius = radius * ER;
    pixelAxis = axis * AU;

    float periodInYears = period/365;
    float periodInFrames = periodInYears * YEAR;
    theta = random(2 * PI);
    thetaSpeed = (2 * PI) / periodInFrames;

    return(this);
  }

 
  void update() {
    theta += thetaSpeed;
    z += (tz - z) * 0.1;
  }


  void render() {
    float apixelAxis = pixelAxis;
    if (axis > 1.06 && feature) {
      apixelAxis = ((1.06 + ((axis - 1.06) * ( 1 - flatness))) * AU) + axis * 10;
    }
    float x = sin(theta * (1 - flatness)) * apixelAxis;
    float y = cos(theta * (1 - flatness)) * apixelAxis;
    pushMatrix();
    translate(x, y, z);

    rotateZ(-rot.z);
    rotateX(-rot.x);
    noStroke();
 if (feature) {
      translate(0, 0, 1);
      stroke(255, 255);
      strokeWeight(2);
      noFill();
      ellipse(0, 0, pixelRadius + 10, pixelRadius + 10); 
      strokeWeight(1);
      pushMatrix();
     
      rotate((1 - flatness) * PI/2);
      stroke(255, 100);
      float r = max(50, 100 + ((1 - axis) * 200));
      r *= sqrt(1/zoom);
      if (zoom > 0.5 || label.charAt(0) != '3') {
        line(0, 0, 0, -r);
        translate(0, -r - 5);
        rotate(-PI/2);
        scale(1/zoom);
        fill(255, 200);
        textSize(20);
        text(label, 0, 4);
        textSize(40);
      }
      popMatrix();
    }
    fill(col);
    noStroke();
    ellipse(0, 0, pixelRadius, pixelRadius);
    popMatrix();
  }
}