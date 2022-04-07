// ******************************** PLANAR ISOMETRIES ************************
// TRANSLATE: this function takes as input a point P, and returns a new point 
// which is the result of translating P by vector V.
// SOLUTION PROVIDED
public pt Translate(pt P, vec V)
{
  return P(P, V);
}

// ROTATE: This function takes as input a point P, rotation center O and rotation amount a
// and returns a new point which is obtained by rotating P about O by the angle a clockwise.
// SOLUTION PROVIDED
public pt Rotate(pt P, pt O, float a)
{
  return R(P, a, V(1,0,0), V(0,1,0), O); 
}

// MIRROR: This function takes as input a point P, and a mirror axis which passes through O and which is along unit vector V
// and returns a new point which is the result of reflecting P about this axis.
// STUDENT CODE BELOW
public pt Mirror(pt P, pt reflection_axis_pt, vec reflection_axis_vec)
{
  return P;
}

// GLIDE: Recall that a glide can be thought of as a composition of a mirror followed by a translation along mirror axis.
// This function takes as input a point P, the mirror axis and translation distance (dist).
// The output should be a new point obtained as a result of glide reflection of P along given axis by the distance. 
// STUDENT CODE BELOW
public pt Glide(pt P, pt glide_axis_pt, vec glide_axis_vec, float dist)
{
  return P;
}

// *********************************************** WALLPAPER SYMMETRIES ************************************
// The code below sets the generating symmetries for each wallpaper group.
// You are expected to define the generating symmetries for each wallpaper group here.
// An example for one wallpaper group is provided to illustrate this.
// Refer to the slides for more information on generating symmetries.

// Some information on the data structure being used:
// The symmetry class stores our set of symmetries.
// We first define the symmetry type by a string: either "TRANSLATE", "ROTATE", "MIRROR", "GLIDE" or "IDENTITY" (default).
// In addition to this, depending on the type of symmetries, we need further parameters.
// Translation symmetry needs a translation vector (vec)
// Rotation symmetry needs the origin (pnt) and a rotation amount (float).
// Mirror symmetry needs an axis, defined by a point that the axis passes through (pnt) and a vector along the axis (vec)
// Glide symmetry needs an axis, defined by (pnt) and (vec) as above; plus a translation amount (float) along the axis vector.

// Some examples of each symmetry are shown below (note: these are intentionally different from the symmetries in the wallpaper groups). 
// Translation symmetry w.r.t vector (100,0) : T = new symmetry("TRANSLATE", V(100, 0));
// 5-fold rotation symmetry about origin : R = new symmetry("ROTATE", P(0,0), PI/5);
// Mirror symmetry about Y-axis: M = new symmetry("MIRROR", P(0,0,0), V(0,1,0));
// Glide reflection symmetry about X-axis with translation of 50:  G = new symmetry("GLIDE", P(0,0), V(1,0), 50));
void setWallpaperSymmetries()
{
  // Translation vectors
  vec U = WP.U;
  vec V = WP.V;
  
  // Origin
  pt O = WP.O;
  
  //STUDENT CODE BELOW.
  //Add cases for each of the 17 wallpaper groups i.e. wallpaper_id goes from 0 to 16
  // by adding their appropriate generating symmetries.
  // An example is shown below for the case wallpaper_id = 1 (two translations and a 2-fold rotation).
  switch(WP.wallpaper_id) {
    case 0:
      //Add stuff here and make new cases
      break;
    case 1:
      WP.addSymmetry(new symmetry("TRANSLATE", U));
      WP.addSymmetry(new symmetry("TRANSLATE", V));
      WP.addSymmetry(new symmetry("ROTATE", O, PI));
      break;
    case 2:
    // add the corresponding symmetries for remaining cases...
    default:
      break;
  }
}

// ******************************** CUSTOM GEOMETRY ************************

// This function creates the geometry for letter "F" inside the wallpaper pattern.
// You can use this as a reference to generate more creative geometry, and animate it with time.
// You can use the variable frameCount to help with animation.
// Feel free to replace the contents of this function to draw your thing instead, or create a new function.

//REPLACE this function with your animated GIF
void makeGeometry()
{
  //Translation and rotation using mouse drag
  translate(translation_vector.x, translation_vector.y, translation_vector.z);
  rotateZ(rotation_angle);
  scale(scale_amount);
  
  //Draw F using three simple ellipses
  stroke(red); strokeWeight(1); fill(blue);
  int max_frames = 90; if(frame>max_frames) frame = 0; float t = sq(cos(TWO_PI*frame/max_frames));
  
  ellipse(2.*a/5, -a/24, t*a/4, a/30);
  ellipse(a/3.6, -a/8, a/30, a/7);
  ellipse(2.*a/5, -a/8, a/30, a/10);
}

//Students DO NOT need to edit this function, unless they want to go back to the 
//older version of the base code by uncommenting the second line. If so, read comment.
void drawSampleGeometry()
{
  //This function displays the geometry you construct using the makeGeometry() function
  WP.displayGeometry();
  
  //OLD VERSION. Students don't need to use or edit this; but you can uncomment the below function call
  //if you want to display the stuff passed to the WP object using the function setSampleGeometry()
  //This function displays the geometry that's added to the wallpaper object WP. By default, this is letter "F".
  //Edit the code in setSampleGeometry() to pass other stuff to WP instead of "F" and display that instead.

  //WP.displayGeometryOld();
}

//OLD VERSION. Students DO NOT need to use or edit this; but you CAN if you want to go back to the old version 
//of the base code or are interested in using the WP class.
//This function shows an example of adding a shape to the WP class.
//We first construct each vertex of the letter "F" as a point object. 
//Each vertex is then added to the WP class and then edges between the
//appropriate vertices are defined.
void setSampleGeometry()
{
  // Clear any existing geometry in the wallpaper pattern
  WP.resetGeometry();
  
  // Variables used for orienting "F" correctly
  pts P = WP.getMasterTile();
  pt B = P(P.G[0], P.G[1]);
  vec X = V(2*a, U(V(P.G[1], P.G[0])));
  vec Y = M(R(X));
  
  //Construct vertices corresponding to endpoints for drawing the letter "F"
  pt F1 = P(B, V(0.02, Y, -0.03, X));
  pt F2 = P(F1, 0.05, X);
  pt F3 = P(F1, 0.03, Y);
  pt F4 = P(F2, 0.06, Y);
  pt F5 = P(F1, -0.08, X);
  
  //Add these five vertices to the vertex list of the wallpaper pattern
  int v1 = WP.addPt(F1);
  int v2 = WP.addPt(F2);
  int v3 = WP.addPt(F3);
  int v4 = WP.addPt(F4);
  int v5 = WP.addPt(F5);
  
  //Add edges between the appropriate vertices to the wallpaper pattern
  WP.addEdge(v1, v2);
  WP.addEdge(v1, v3);
  WP.addEdge(v1, v5);
  WP.addEdge(v2, v4);
}

// ******************************** WARP USING COTS MAP ************************

//You may use extra helper functions, or modify code inside of any of the other files as needed. 
//Below are two possible approaches, you may do it any way you like using one or both or neither of these.

//Approach 1: Pressing the "~" button turns on "filming" which saves every frame drawn on the canvas as as an image.
//This is saved in the folder ./FRAMES as a .tif file.
//You can then sequentially import these images in the COTS base code provided and then apply the COTS mapping to them to show an animation

//OR

//Approach 2: Implement the math for the COTS mapping here, from the other base code.
//You can then write a function which takes in the four corners of the COTS map (A,B,C,D) and two parameters (u,v) and otuput the new location corresponding to (u,v)
//The parameters (u,v) correspond to the points of interest of your shape. There may be artifacts when doing this for circles, unless you approximate a circle as a polygon.
//If using my WP class, you can also figure out (u,v) coordinates of every point in WP, then pass those in, and display the output points.
//For a reference on how to display vertices and edges, see the function WP.displayGeometry().

//Use if needed (for Approach 2)
pt cots(pt A, pt B, pt C, pt D, float u, float v)
{
  //WP.getPt(i) returns the coordinates of the i-th point in the WP class
  //WP.getPt(i, u, v, s, t) returns the location of the i-th point after ...
  //...applying the first symmetry u times, second symmetry v times, third symmetry s times and fourth symmetry t times
  //WP.num_v is the number of vertices
 
 return P(u,v,0.0);
}
