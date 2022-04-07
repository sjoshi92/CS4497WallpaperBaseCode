public class wpg
{
  int max_num_i = 100, max_num_j = 100, max_num_v = 5000, max_num_c = max_num_v, max_num_s = 4;
  
  //Origin
  pt O = P();
  
  //Translation vectors U and V
  vec U = V(1, 0, 0);
  vec V = V(0, 1, 0);
  
  //Independent symmetries inside the wallpaper group
  symmetry[] S = new symmetry[max_num_s];
  
  // Wallpaper group number
  int wallpaper_id = 0;
  
  // Vertices and edges in the fundamental region
  pt G[] = new pt[max_num_v];
  int E[][] = new int[max_num_c][2];
  
  //Properties of the SPM
  int num_v = 0;
  int num_s = 0;
  int num_c = 0;
  
  // Repetition count for translation symmetries along U and V
  int num_i = 1, num_j = 1;
  
  //Extra variables for display purposes
  int picked_v = 0, picked_c = 0;
  pts display_mesh = new pts();
  pts display_mesh_edges = new pts();
  
  public wpg()
  { 
  }
  
  public void declare()
  {
    for (int i = 0; i < max_num_v; i++)
    {
      this.G[i] = new pt();
    }
    for (int i = 0; i < max_num_v; i++)
    {
      this.E[i] = new int[2];
    }
    for (int i = 0; i < max_num_s; i++)
    {
      this.S[i] = new symmetry();
    }
    display_mesh.declare();
    display_mesh_edges.declare();
  }
  
  public void setRepetitions(int i, int j)
  {
    this.num_i = i;
    this.num_j = j;
  }
  
  public void setSimilarityVectors(vec U_vector, vec V_vector)
  {
    this.U = V(U_vector);
    this.V = V(V_vector);
  }
  
  public void setWallpaperID(int i)
  {
    this.wallpaper_id = i % 17;
  }
  
  //Resets the geometry and the symmetries
  public void reset()
  {
    this.num_v = 0;
    this.num_s = 0;
    this.num_c = 0;
    this.U = V();
    this.V = V();
    this.recomputeDisplayMesh();
  }
  
  //Resets the geometry arrays
  public void resetGeometry()
  {
    this.num_v = 0;
    this.num_c = 0;
    this.recomputeDisplayMesh();
  }
  
  //Resets symmetries
  public void resetSymmetries()
  { 
    for (int i = 0; i < this.num_s; i++)
    {
      this.S[i] = new symmetry();
    }
    this.num_s = 0;
  }
  
  //Add a new vertex to the pattern
  public int addPt(pt N)
  {
    this.G[this.num_v] = N;
    this.num_v++;
    return this.num_v-1;
  }
  
  public pt getPt(int i)
  {
    return this.G[i];
  }
  
  public pt getPt(int i, int u, int v, int s, int t)
  {
    return this.applySymmetriesToPt(this.G[i], u, v, s, t);
  }
  
  // Adds an edge between the ith and jth vertex in the array G
  // Currently I do not check whether indices i and j are valid; 
  // make sure that i and j are < this.num_v when calling this function to add edges.
  public void addEdge(int i, int j)
  {
    this.E[this.num_c][0] = i;
    this.E[this.num_c][1] = j;
    this.num_c++;
  }
  
  // Adds a new symmetry of type S to the wallpaper group
  public void addSymmetry(symmetry S)
  {
    if (num_s < max_num_s)
    {
      this.S[this.num_s] = S;
      this.num_s++;
    }
  }
  
  void getTransformationMatrix()
  {
    this.S[0].applyMatrix(this.getSymmetryStartCount(0));
    this.S[1].applyMatrix(this.getSymmetryStartCount(1));
    for (int u = this.getSymmetryStartCount(0); u < this.getSymmetryEndCount(0); u++)
    {
      this.S[0].applyMatrix();
      for (int v = this.getSymmetryStartCount(1); v < this.getSymmetryEndCount(1); v++)
      {
        this.S[1].applyMatrix();
        for (int s = this.getSymmetryStartCount(2); s < this.getSymmetryEndCount(2); s++)
        {
          for (int t = getSymmetryStartCount(3); t < getSymmetryEndCount(3); t++)
          {
          }
        }
      }
    }
    
  }
  
  
  // Computes the geometry stuff for storage and display purposes.
  public void recomputeDisplayMesh()
  {
    display_mesh.empty();
    display_mesh_edges.empty();
    this.setSymmetries();
        
    //Find all vertices in the mesh based on the number of repetitions
    for (int u = this.getSymmetryStartCount(0); u < this.getSymmetryEndCount(0); u++)
    {
      for (int v = this.getSymmetryStartCount(1); v < this.getSymmetryEndCount(1); v++)
      {
        for (int t = this.getSymmetryStartCount(2); t < this.getSymmetryEndCount(2); t++)
        {
          for (int s = this.getSymmetryStartCount(3); s < this.getSymmetryEndCount(3); s++)
          {    
            for (int i = 0; i < this.num_v; i++)
            {
              //Do stuff
              display_mesh.addPt(applySymmetriesToPt(this.G[i], u, v, s, t));
            }
          }
        }
      }
    }
    
    int count = 0;
    //Find all edges in the mesh based on the number of repetitions
    for (int u = this.getSymmetryStartCount(0); u < this.getSymmetryEndCount(0); u++)
    {
      for (int v = this.getSymmetryStartCount(1); v < this.getSymmetryEndCount(1); v++)
      {
        for (int t = this.getSymmetryStartCount(2); t < this.getSymmetryEndCount(2); t++)
        {
          for (int s = this.getSymmetryStartCount(3); s < this.getSymmetryEndCount(3); s++)
          {
            for (int i = 0; i < this.num_c; i ++)
            {
              int k = count * this.num_v + this.E[i][0];
              int l = count * this.num_v + this.E[i][1];
              
              //Edge stuff
              display_mesh_edges.addPt(P(k,l,0));
            }
            count++;
          }
        }
      }
    }
    
  }
  
  // Adds constraints to the U and V vector based on the type of "lattice" (crystallography theorem)
  public void setLatticeVectors()
  {
    String curr_lattice = this.getLatticeType();
    float nU = n(this.U), nV = n(this.V);
    
    //120-degrees
    if (curr_lattice.contains("T"))
    {
      this.V = V(nV, U(R(this.U, 2*PI/3, V(1,0,0), V(0,-1,0))));
    }
    
    //60-degrees
    if (curr_lattice.contains("H"))
    {
      this.V = V(nV, U(R(this.U, PI/3, V(1,0,0), V(0,-1,0))));
    }
    
    //Rectangular
    if (curr_lattice.contains("N"))
    {
      this.V = V(nV, M(U(R(this.U))));
    }
    
    //Rhombic
    if (curr_lattice.contains("E"))
    {
      this.U = V(sqrt(nU*nV), U(this.U));
      this.V = V(sqrt(nU*nV), U(this.V));
    }
  }
  
  // Set the symmetries for this group.
  public void setSymmetries()
  {
    this.resetSymmetries();
    this.setLatticeVectors();
    setWallpaperSymmetries();
  }
  
  // Gets the fundamental region, or "master tile": the smallest valid repeating region of space.
  // This region can be displayed by toggling the "G" key. "g" toggles the display of copies of this region.
  pts getMasterTile()
  {
    pts output = new pts();
    output.declare();
    if (wallpaper_id == 0)
    {
      output.addPt(P(this.O, this.U));
      output.addPt(P(this.O));
      output.addPt(P(this.O, this.V));
      output.addPt(P(this.O, A(this.U, this.V)));
    }
    if (wallpaper_id == 1)
    {
      output.addPt(P(this.O, this.U));
      output.addPt(P(this.O));
      output.addPt(P(this.O, V(0.5, this.V)));
      output.addPt(P(this.O, A(this.U, V(0.5, this.V))));
    }
    if (wallpaper_id == 2)
    {
      output.addPt(P(this.O, this.U));
      output.addPt(P(this.O));
      output.addPt(P(this.O, V(0.5, this.V)));
      output.addPt(P(this.O, A(this.U, V(0.5, this.V))));
    }
    if (wallpaper_id == 3)
    {
      output.addPt(P(this.O, this.U));
      output.addPt(P(this.O));
      output.addPt(P(this.O, V(0.5, this.V)));
      output.addPt(P(this.O, A(this.U, V(0.5, this.V))));
    }
    if (wallpaper_id == 4)
    {
      output.addPt(P(this.O, this.U));
      output.addPt(P(this.O));
      output.addPt(P(this.O, this.V));
    }
    if (wallpaper_id == 5)
    {
      output.addPt(P(this.O, V(0.5, this.U)));
      output.addPt(P(this.O));
      output.addPt(P(this.O, V(0.5, this.V)));
      output.addPt(P(this.O, V(this.U, this.V)));
    }
    if (wallpaper_id == 6)
    {
      output.addPt(P(this.O, 1/4., this.U));
      output.addPt(P(this.O, -1/4., this.U));
      output.addPt(P(this.O, V(-1/4., this.U, 1/2., this.V)));
      output.addPt(P(this.O, V(1/4., this.U, 1/2., this.V)));
    }
    if (wallpaper_id == 7)
    {
      output.addPt(P(this.O, this.U));
      output.addPt(P(this.O));
      output.addPt(P(this.O, V(this.U, this.V)));
    }
    if (wallpaper_id == 8)
    {
      output.addPt(P(this.O, this.U));
      output.addPt(P(this.O));
      output.addPt(P(this.O, V(this.U, this.V)));
    }
    if (wallpaper_id == 9)
    {
      output.addPt(P(this.O, V(0.5, this.U)));
      output.addPt(P(this.O));
      output.addPt(P(this.O, V(0.5, this.V)));
      output.addPt(P(this.O, V(this.U, this.V)));
    }
    if (wallpaper_id == 10)
    {
      output.addPt(P(this.O, V(0.5, this.U)));
      output.addPt(P(this.O));
      output.addPt(P(this.O, V(this.U, this.V)));
    }
    if (wallpaper_id == 11)
    {
      output.addPt(P(this.O, V(0.5, this.U)));
      output.addPt(P(this.O));
      output.addPt(P(this.O, V(0.5, this.V)));
    }
    if (wallpaper_id == 12)
    {
      output.addPt(P(this.O, V(1/3., this.U, -1/3., this.V)));
      output.addPt(this.O);
      output.addPt(P(this.O, V(2/3., this.U, 1/3., this.V)));
      output.addPt(P(this.O, this.U));
    }
    if (wallpaper_id == 13)
    {
      output.addPt(P(this.O, this.U));
      output.addPt(this.O);
      output.addPt(P(this.O, V(2/3., this.U, 1/3., this.V)));
    }
    if (wallpaper_id == 14)
    {
      output.addPt(P(this.O, V(1/3., this.U, -1/3., this.V)));
      output.addPt(this.O);
      output.addPt(P(this.O, V(2/3., this.U, 1/3., this.V)));
    }
    if (wallpaper_id == 15)
    {
      output.addPt(P(this.O, this.U));
      output.addPt(this.O);
      output.addPt(P(this.O, 2/3., V(this.U, this.V)));
    }
    if (wallpaper_id == 16)
    {
      output.addPt(P(this.O, V(V(), this.U)));
      output.addPt(this.O);
      output.addPt(P(this.O, 2/3., V(this.U, this.V)));
    }
    
    return output;
  }
  
  // Adds a new vertex at the mouse location.
  void addVertexFromPick(pt M)
  {
    pt MM = P(M.x, M.y, 0);
    this.addPt(P(MM));
  }
  
  // Gets the locations of the unit cell
  pts[] getTileLocations()
  {
    pts curr = new pts();
    curr.declare();
    pts master_tile = this.getMasterTile();
    int num = this.getTotalNumTiles();
    pts[] result = new pts[num];
    for (int i = 0; i < master_tile.nv; i++)
    {
      curr.empty();
      curr = this.getNodeLocations(master_tile.G[i]);
      for (int j = 0; j < curr.nv; j++)
      {
        if (i==0)
        {
          result[j] = new pts();
          result[j].declare();
        }
        result[j].addPt(curr.G[j]);
      }
    }
    return result;
  }
  
  public pts getNodeLocations(pt P)
  {
    pt Q = P(P);
    pts result = new pts();
    result.declare();
    for (int u = this.getSymmetryStartCount(0); u < this.getSymmetryEndCount(0); u++)
    {
      for (int v = this.getSymmetryStartCount(1); v < this.getSymmetryEndCount(1); v++)
      {
        for (int s = this.getSymmetryStartCount(2); s < this.getSymmetryEndCount(2); s++)
        {
          for (int t = this.getSymmetryStartCount(3); t < this.getSymmetryEndCount(3); t++)
          {
            result.addPt(this.applySymmetriesToPt(Q, u, v, s, t));
          }
        }
      }
    }
    return result;
  }
  
  // Applies all symmetries in the wallpaper group to a given point, to produce
  // P_uvst = T_U^u * T_V^v * R_n ^ s * M ^t * P
  public pt applySymmetriesToPt(pt Q, int u, int v, int s, int t)
  {
    return this.S[0].apply(this.S[1].apply(this.S[2].apply(this.S[3].apply(Q, t), s), v), u);
  }
  
  public void getTransformationMatrix(int u, int v, int s, int t)
  {
    this.S[0].applyMatrix(u);
    this.S[1].applyMatrix(v);
    this.S[2].applyMatrix(s);
    this.S[3].applyMatrix(t);
  }
  
  // Number of total tiles in the shape
  int getNumTilesInCell()
  {
    int result = 1;
    for (int i = 0; i < this.num_s; i++)
    {
      result *= this.S[i].getCount();
    }
    return result;
  }
  
  int getTotalNumTiles()
  {
    int result = 1;
    for (int i = 0; i < this.num_s; i++)
    {
      result *= this.getNumSymmetryInstances(i);
    }
    return result;
  }
  
  int getSymmetryStartCount(int i)
  {
    if (this.S[i].type == "TRANSLATE")
    {
      return -this.num_i + 1;
    }
    return 0;
  }
  
  int getSymmetryEndCount(int i)
  {
    return this.getSymmetryStartCount(i) + this.getNumSymmetryInstances(i);
  }
  
  int getNumSymmetryInstances(int i)
  {
    if (this.S[i].type == "TRANSLATE")
    {
      return 2*this.num_i - 1;
    }
    return this.S[i].getCount();
  }
  
  // Draws the fundamental region/master tile
  void drawPrimaryCell()
  {
    pts test = this.getMasterTile();
    fill(red, 80);
    strokeWeight(5);
    stroke(black,80);
    test.colorPolygon();
    noFill();
    noStroke();
  }
  
  // Draws tiling obtained by applying each symmetry to the master tile.
  void displayColoredCells()
  {
    pts[] test = this.getTileLocations();
    for (int i = 0; i < test.length; i++)
    {
      fill(color(colorArray[i%(this.S[2].getCount()*this.S[3].getCount())],40));
      strokeWeight(2);
      stroke(black,120);
      if (!show_symmetry_grid) noStroke();
      if (!show_colored_cells) noFill();
      test[i].colorPolygon();
    }
    
    if (show_master_cell)
    {
      WP.drawPrimaryCell();
    }
  }
  
  // Draws the geometry (vertices and edges).
  public void displayAxes()
  {
    if (showFrame)
    {
      // Display origin
      stroke(black);
      noFill();
      show(this.O, 2);
      noStroke();
      fill(black);
      show(this.O, "C");
      
      //Display the translation vectors U and V
      fill(green);
      arrow(this.O, this.U, 4);
      arrow(this.O, this.V, 4);
    }
  }
  
  public void displayGeometryOld()
  {
    //Draw vertices
    if (showF)
    {
      if (display_vertices)
      {
        this.showVertices();
      }
      if (display_edges)
      {
        this.showEdges();
      } 
    }
  }
  
  void displayGeometry()
  {
    for (int u = this.getSymmetryStartCount(0); u < this.getSymmetryEndCount(0); u++)
    {
      for (int v = this.getSymmetryStartCount(1); v < this.getSymmetryEndCount(1); v++)
      {
        for (int s = this.getSymmetryStartCount(2); s < this.getSymmetryEndCount(2); s++)
        {
          for (int t = this.getSymmetryStartCount(3); t < this.getSymmetryEndCount(3); t++)
          {
            pushMatrix();
            this.getTransformationMatrix(u, v, s, t);
            makeGeometry();
            popMatrix();
          }
        }
      }
    }
  }
  
  public void showMasterVertices()
  {
    for (int i = 0; i < this.num_v; i++) 
    {
      fill(colorArray[int(i/this.num_v)%this.getNumTilesInCell()]);
      noStroke();
      show(this.G[i], 2*edge_radius); 
    }
  }
  
  public void showVertices()
  {
    for (int i = 0; i < this.display_mesh.nv; i++) 
    {
      noStroke();
      fill(blue);
      show(this.display_mesh.G[i], edge_radius);
    }
  }
  
  void drawDart(pt A, pt B, float r) 
  {
      stub(A, P(B),r,r); 
  }
  
  void drawDart(pt A, pt B, float r1, float r2) 
  {
    stub(A, P(B),r1,r2);
  } 
  
  public void showEdges()
  {
    // stuff
    for (int i = 0; i < display_mesh_edges.nv; i++)
    {
      drawDart(display_mesh.G[int(display_mesh_edges.G[i].x)], display_mesh.G[int(display_mesh_edges.G[i].y)], edge_radius);
    }
  }
  
  public String getLatticeType()
  {
    if (this.wallpaper_id == 1)
    {
      return "";
    }
    if (this.wallpaper_id == 2)
    {
      return "N";
    }
    if (this.wallpaper_id == 3)
    {
      return "N";
    }
    if (this.wallpaper_id == 4)
    {
      return "E";
    }
    if (this.wallpaper_id == 5)
    {
      return "N";
    }
    if (this.wallpaper_id == 6)
    {
      return "N";
    }
    if (this.wallpaper_id == 7)
    {
      return "N";
    }
    if (this.wallpaper_id == 8)
    {
      return "E";
    }
    if (this.wallpaper_id == 9)
    {
      return "NE";
    }
    if (this.wallpaper_id == 10)
    {
      return "NE";
    }
    if (this.wallpaper_id == 11)
    {
      return "NE";
    }
    if (this.wallpaper_id == 12)
    {
      return "TE";
    }
    if (this.wallpaper_id == 13)
    {
      return "TE";
    }
    if (this.wallpaper_id == 14)
    {
      return "TE";
    }
    if (this.wallpaper_id == 15)
    {
      return "HE";
    }
    if (this.wallpaper_id == 16)
    {
      return "HE";
    }
    return "";
  }
  
  void setF()
  {
    setSampleGeometry();
  }
  
  void translateGeometry(vec V)
  {
    for (int i = 0; i < this.num_v; i++)
    {
      this.G[i] = P(this.G[i], V);
    }
  }
  
  void rotateGeometry(float a)
  {
    for (int i = 0; i < this.num_v; i++)
    {
      this.G[i] = R(this.G[i], a, this.O);
    }
  }
 
}
