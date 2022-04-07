import processing.pdf.*;

//Scene-related global variables
float camera_z = 0, camera_rx = -0.0, camera_ry = 0.0;
float radius = 10.0;
boolean showFrame=true, filming=false, change=false;
pt camera_focus = P(0,0,0);  // focus point:  the camera is looking at it (moved when 'f or 'F' are pressed
pt Of=P(100,100,0); // resd point controlled by the user via mouseDrag : used for inserting vertices ...
pt Pick=P();
pt display_origin = P();
int frame = 0;

//Code-related global variables
int circle_detail = 8;

wpg WP = new wpg();
vec U_direction = V(1, 0, 0), V_direction = V(1.5*cos(2*PI/5), -1.5*sin(2*PI/5), 0);
float a = 250, edge_radius = 4.0;
boolean show_floor = true, show_colored_cells = false, show_symmetry_grid = false, show_master_cell = true;
boolean display_vertices = true, display_edges = true, show_only_master_geometry = false;
boolean showF = true;

vec translation_vector = V(0,0,0);
float rotation_angle = 0.0, scale_amount = 2.0;

void setup() {
  textureMode(NORMAL);
  size(1000, 800, P3D);
  surface.setLocation(400,0);
  sphereDetail(32);
  textSize(20);
  frameRate(30);
  WP.declare();
  WP.setRepetitions(3, 3);
  WP.wallpaper_id = 1;
  WP.setSimilarityVectors(V(a, U_direction), V(a, V_direction));
  WP.recomputeDisplayMesh();
}

void draw() {
  frame++; 
  background(255);
  
  pushMatrix();
  setCameraView();
  
  //if (show_floor) showFloorAsPlane();
  
  if (change)
  {
    WP.recomputeDisplayMesh();
  }
  
  //Show the base tiling
  WP.displayColoredCells();
  WP.displayAxes();
  
  // Draw the letter F
  if (showF)
  {
    drawSampleGeometry();
  }
  
  // Picking vertices and edges
  Pick=pick(mouseX,mouseY);
  computeProjectedVectors();
  popMatrix();
  
  if (scribeText)
  {
    fill(black);
    text("Wallpaper ID " + WP.wallpaper_id, 10, 40);
    for (int i = 0; i < WP.num_s; i++)
    {
      String extra = "";
      if (WP.S[i].type=="ROTATE") {extra = str(WP.S[i].getCount());}
      if (WP.S[i].type=="MIRROR") {extra = (n(M(WP.S[i].axis_vec, WP.U)) < 0.001) ? "AXIS" : "DIAG";}
      if (WP.S[i].type=="GLIDE") {extra = (d(WP.S[i].axis_pt, WP.O) < 0.001) ? "AXIS" : "OFF";}
      text("Symmetry" + i + " : " + WP.S[i].type + " " + extra, 10, 60 + 20*i, 0);
    }
  }
  if(scribeText) {fill(black); displayHeader();} // dispalys header on canvas, including my face
  if(scribeText && !filming) displayFooter(); // shows menu at bottom, only if not filming
  if(filming && (change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif");  // save next frame to make a movie
  change=false; // to avoid capturing frames when nothing happens (change is set uppn action)
}

void setCameraView() {
  
  // SET PERSPECTIVE
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  camera(0,0,cameraZ,0,0,0,0,1,0  );       // sets a standard perspective

  // SET VIEW
  translate(0,0,camera_z); // puts origin of model at screen center and moves forward/away by dz
  //lights();  // turns on view-dependent lighting
  rotateZ(camera_rx);
  
  blendMode(BLEND);
}

void showFloorAsPlane()
{
  fill(grey, 20);
  pushMatrix();
  translate(0,0,-1);
  box(7000,7000,1);
  popMatrix();
}

// **** Header, footer, help text on canvas
void displayHeader() { // Displays title and authors face on screen
    //scribeHeader(title,0); 
    scribeHeaderRight(name); 
    //fill(white); image(myFace, width-myFace.width/2,25,myFace.width/2,myFace.height/2); 
    }
void displayFooter() { // Displays help text at the bottom
    scribeFooter(guide,3); 
    scribeFooter(guide1,2); 
    scribeFooter(guide2,1); 
    scribeFooter(menu,0); 
    }

String title ="Warped wallpaper patterns", name ="Sarang Joshi",
       menu="?:help, !:picture, ~:(start/stop)capture, space:rotate, z/wheel:zoom, >:toggle origin/axes, #:quit",
       guide2="'f':toggle 'F' display; 'h': display grid; 'G': display fundamental region, 'g': display tiles", // user's guide
       guide1="mouse drag+'m':translate geometry; mouse drag+'r': rotate geomety", // user's guide
       guide="mouse drag+'o':translate origin; mouse drag+'u/v': translate U/V vector"; // user's guide
