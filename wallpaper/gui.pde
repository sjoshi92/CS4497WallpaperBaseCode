void keyPressed() 
{
  if(key=='!') snapPicture();
  if(key=='@') {scribeText = !scribeText;}
  if(key=='~') filming=!filming;
  if(key=='+') 
  {
    WP.num_i += 1;
    WP.num_j += 1;
  }
  if(key=='-') 
  {
    WP.num_i = max(WP.num_i - 1, 1);
    WP.num_j = max(WP.num_j - 1, 1);
  }
  if(key=='0') 
  {
    WP.wallpaper_id = (WP.wallpaper_id+1)%17;
    WP.resetGeometry();
    WP.resetSymmetries();
    WP.U = V(a, U_direction);
    WP.V = V(a, V_direction);
  }
  if(key=='a') {WP.addVertexFromPick(Pick);}  
  if(key=='A') 
  {
  }
  if(key=='c') {WP.resetGeometry();}
  if(key=='f') {showF = !showF;}
  if(key=='g') {show_colored_cells = !show_colored_cells;}
  if(key=='h') {show_symmetry_grid = !show_symmetry_grid;}
  if(key=='G') {show_master_cell = !show_master_cell;}
  if(key=='i') {display_vertices = !display_vertices;}
  if(key=='I') {display_edges = !display_edges;}
  if(key=='k') {show_only_master_geometry = !show_only_master_geometry;}

  if(key=='s') {edge_radius *= 1.1;}
  if(key=='S') {edge_radius /= 1.1;}

  if(key=='>') showFrame=!showFrame;
  if(key=='#') exit();
  change = true;
}

void mouseWheel(MouseEvent event) 
{
  //Zoom in/out
  camera_z -= 5*event.getCount(); 
  change = true;
}

void mouseReleased() 
{ 
  change = true; 
}

void mouseClicked() 
{
  change = true;
}
  
void mouseMoved() 
{
  change = true;
  
  //Rotate the view
  if (keyPressed && key==' ') {
    camera_rx-=PI*(mouseY-pmouseY)/height; 
    camera_ry+=PI*(mouseX-pmouseX)/width;
  }
  
  //Zoom in/out of the view
  if (keyPressed && key=='z') 
  {
    camera_z+=(float)(mouseY-pmouseY); 
    change=true;
  }
}
  
void mouseDragged() 
{
  change = true;
  
  if (keyPressed && key=='u') {
    WP.U = A(WP.U, V((mouseX-pmouseX), (mouseY-pmouseY), 0.));
    WP.setLatticeVectors();
  }
  if (keyPressed && key=='v') {
    WP.V = A(WP.V, V((mouseX-pmouseX), (mouseY-pmouseY), 0.));
    WP.setLatticeVectors();
  }
  if (keyPressed && key=='o') {
    WP.O = P(WP.O, V((mouseX-pmouseX), (mouseY-pmouseY), 0.));
  }
  if (keyPressed && key=='m') {
    translation_vector = A(translation_vector, V((mouseX-pmouseX), (mouseY-pmouseY), 0.));
  }
  if (keyPressed && key=='r') {
    rotation_angle += 0.001*(mouseX-pmouseX);
  }
  if (keyPressed && key=='s') {
    scale_amount += 0.001*(mouseX-pmouseX);
  }
  
}
