
import processing.opengl.*;
PFont label ;
float k=0;

ArrayList<ExoPlanet> planets = new ArrayList();
float o=0;
float maxax=0;
float ER = 1;          
float AU = 1500;        
float YEAR = 50000;

// Max/Min numbers
float maxTemp = 3257;
float minTemp = 3257;

float yMax = 10;
float yMin = 0;

float maxSize = 0;
float minSize = 1000000;

// Axis labels
String xLabel = "Years";
String yLabel = "Size";

// Rotation Vectors - control the main 3D space
PVector rot = new PVector();
PVector trot = new PVector();

// Master zoom
float zoom = 0;
float tzoom = 0.3;

// This is a zero-one weight that controls whether the planets are flat on the
// plane (0) or not (1)
float flatness = 0;
float tflatness = 0;

// add controls (e.g. zoom, sort selection)
Controls controls; 
int showControls;
boolean draggingZoomSlider = false;

void setup() {
  size(displayWidth, displayHeight, OPENGL);
  background(0);
  smooth();  
label= createFont("Helvetica", 92);
  textFont(label,92);

  getPlanets("KeplerData.csv");
  println(planets.size());

  //addMarkerPlanets();
  updatePlanetColors();
  
  controls = new Controls();
  showControls = 1;
  
}

void getPlanets(String url) {
  // Here, the data is loaded and a planet is made from each line.
  String[] pArray = loadStrings(url);
 
  for (int i = 1; i < pArray.length; i++) {
    ExoPlanet p;
  
      p = new ExoPlanet().fromCSV(split(pArray[i], ",")).init();

    
    planets.add(p);
    maxSize = max(p.radius, maxSize);
    minSize = min(p.radius, minSize);

    // These are two planets from the 2011 data set that I wanted to feature.
    
  }
}

void updatePlanetColors()
{
  // Calculate overall min/max temps (will include the marker planets this way)
  for (int i = 0; i < planets.size(); i++)
  {
    ExoPlanet p = planets.get(i);
    maxTemp = max(p.temp, maxTemp);
    minTemp = min(abs(p.temp), minTemp);
  }

  colorMode(HSB);
  for (int i = 0; i < planets.size(); i++)
  {
    ExoPlanet p = planets.get(i);

    if (0 < p.temp)
    {
      float h = map(sqrt(p.temp), sqrt(minTemp), sqrt(maxTemp), 200, 0);
      p.col = color(h, 255, 255);
    }
    else
    {
      // What should we do with planets that have a negative temp in kelvin?
      p.col = color(200, 255, 255);
    }
  }
  colorMode(RGB);
}




void draw() {
  // Ease rotation vectors, zoom
  zoom += (tzoom - zoom) * 0.01;     
  if (zoom < 0)  {
     zoom = 0;
  } else if (zoom > 3.0) {
     zoom = 3.0;
  }
  controls.updateZoomSlider(zoom);  
  rot.x += (trot.x - rot.x) * 0.1;
  rot.y += (trot.y - rot.y) * 0.1;
  rot.z += (trot.z - rot.z) * 0.1;

  // Ease the flatness weight
  flatness += (tflatness - flatness) * 0.1;

  // MousePress - Controls Handling 
  if (mousePressed) {
     if((showControls == 1) && controls.isZoomSliderEvent(mouseX, mouseY)) {
        draggingZoomSlider = true;
        zoom = controls.getZoomValue(mouseY);        
        tzoom = zoom;
     } 
     
     // MousePress - Rotation Adjustment
     else if (!draggingZoomSlider) {
       trot.x += (pmouseY - mouseY) * 0.01;
       trot.z += (pmouseX - mouseX) * 0.01;
     }
  }



  background(10);
  
  // show controls
  if (showControls == 1) {
     controls.render(); 
  }
    
  // We want the center to be in the middle and slightly down when flat, and to the left and down when raised
  translate(width/2 - (width * flatness * 0.4), height/2 + (160 * rot.x));
  rotateX(rot.x);
  rotateZ(rot.z);
  scale(zoom);

  // Draw the sun
  fill(255 - (255 * flatness));
  noStroke();
  ellipse(0, 0, 10, 10);

  // Draw Rings:
  strokeWeight(2);
  noFill();

  // Draw a 2 AU ring
  stroke(255, 100 - (90 * flatness));
  ellipse(0, 0, AU * 2, AU * 2);

  // Draw a 1 AU ring
  stroke(255, 50 - (40 * flatness));
  ellipse(0, 0, AU, AU);

  // Draw a 10 AU ring
  ellipse(0, 0, AU * 10, AU * 10);

  // Draw the Y Axis
  stroke(255, 100);
  pushMatrix();
  rotateY(-PI/2);
  line(0, 0, 1000 * flatness, 0);

  // Draw Y Axis max/min
  pushMatrix();
  fill(255, 100 * flatness);
  rotateZ(PI/2);
  textFont(label);
  textSize(40);

  text(200, 20, -155+20);
   text(400, 20, -310+20);
    text(600, 20, -465+20);
     text(800, 20, -620+20);
      text(1000, 20, -776+20);
  popMatrix();

  // Draw Y Axis Label
  fill(255, flatness * 255);
  text(yLabel, 250 * flatness, -10);

  popMatrix();

  // Draw the X Axis if we are not flat
  pushMatrix();
  rotateZ(PI/2);
  line(0, 0, 1550 * flatness, 0);

  if (flatness > 0.5) {
    pushMatrix();
    rotateX(PI/2);
    line(AU * 1.06, -10, AU * 1.064, 10); 
    line(AU * 1.064, -10, AU * 1.068, 10);   
    popMatrix();
  }

  // Draw X Axis Label
  fill(255, flatness * 255);
  rotateX(-PI/2);
  text(xLabel, 500 * flatness, 100);

  // Draw X Axis min/max
  fill(255, 100 * flatness);
  text("1910",-.02*AU, 60);
  text("1920",.06*AU, 60);  
    text("1930",.14*AU, 60);
    text("1940",.22*AU, 60);
  text("1950",.30*AU, 60);
    text("1960",.4*AU, 60);
    text("1970",.5*AU, 60);
    text("1980",.65*AU, 60);
    text("1990",.82*AU, 60);
    text("2000",.93*AU, 60);
    text("2010",AU, 60);
  popMatrix();

  // Render the planets
  for (int i = 0; i < planets.size(); i++) {
    ExoPlanet p = planets.get(i);

      p.update();
      p.render();
    
  }    
  

  

  
}

void sortBySize() {
  // Raise the planets off of the plane according to their size
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = map(planets.get(i).radius, 0, maxSize, 0, 500);
  }
}

void sortByTemp() {
  // Raise the planets off of the plane according to their temperature
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = map(planets.get(i).temp, minTemp, maxTemp, 0, 500);
  }
}

void unSort() {
  // Put all of the planets back onto the plane
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = 0;
  }
}

void keyPressed() {
  String timeStamp = hour() + "_"  + minute() + "_" + second();
  if (key == 's') {
    save("out/Kepler" + timeStamp + ".png");
  } else if (key == 'c'){
     showControls = -1 * showControls;
  }

  if (keyCode == UP) {
    tzoom += 0.025;
  } 
  else if (keyCode == DOWN) {
    tzoom -= 0.025;
  }

  if (key == '1') {
    sortBySize(); 
    toggleFlatness(1);
    yLabel = "Total Deaths";
    yMax = maxSize;
    yMin = 0;
  } 
  else if (key == '2') {
    sortByTemp(); 
    trot.x = PI/2;
    yLabel = "Aboard";
    //toggleFlatness(1);
    yMax = 644;
    yMin = 0;
  } 
  else if (key == '`') {
    unSort(); 
    toggleFlatness(0);
  }
  else if (key == '3') {
    trot.x = 1.5;
  }
  else if (key == '4') {
    tzoom = 1;
  }

  if (key == 'f') {
    tflatness = (tflatness == 1) ? (0):(1);
    toggleFlatness(tflatness);
  }
}

// MouseWheel - zoom controller (auto-triggered on event: mousewheel)
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  float tempzoom = zoom;
  if (tempzoom >= controls.minZoomValue && tempzoom <= controls.maxZoomValue) {
    if (tempzoom >0.15) {
      tempzoom += (e*(0.05*tempzoom));
    } else { //tempzoom >= 0.15
      tempzoom += (e*0.0075);
    }
  }
  if (tempzoom < controls.maxZoomValue && tempzoom > controls.minZoomValue) { 
    tzoom = tempzoom + (e * (0.112*tempzoom)); 
    zoom = tempzoom;
  }
}

void toggleFlatness(float f) {
  tflatness = f;
  if (tflatness == 1) {
    trot.x = PI/2;
    trot.z = -PI/2;
  }
  else {
    trot.x = 0;
  }
}

void mouseReleased() {
   draggingZoomSlider = false;
}