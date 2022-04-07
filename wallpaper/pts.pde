int pp=1; // index of picked vertex

class pts { // class for manipulaitng and sisplaying polyloops
 int pv =0, // picked vertex index,\
     nv = 0;  // number of vertices currently used in P
     
 int maxnv = 16000;                 //  max number of vertices
 pt[] G = new pt [maxnv];           // geometry table (vertices)
 
  pts() {}
  
  //declare
  pts declare() 
  {
    for (int i=0; i<maxnv; i++) 
    {
      G[i]=P();
    }
    return this;
  }
  
  // resets P so that we can start adding points
  pts empty() 
  {
    nv=0; 
    pv=0; 
    return this;
  }
  
  pts addPt(pt P) 
  { 
    G[nv].setTo(P); 
    pv=nv; nv++;
    return this;
  } // adds a point at the end
  
  pt centroid()
  {
    if (this.nv > 0)
    {
      pt C = P(0,0,0);
      for (int i = 0; i < this.nv; i++)
      {
        C = A(C, this.G[i]);
      }
      return C.mul(1./this.nv);
    }
    else
      return P(0,0,0);
  }
  
  pts copy() 
  {
    pts result = new pts();
    result.declare();
    result.nv = this.nv;
    for (int i=0; i<this.nv; i++) 
    {
      result.G[i]=P(this.G[i]);
    } 
    return result;
  }

  pts drawBalls(float r) {for (int v=0; v<nv; v++) show(G[v],r); return this;}
  pts showPicked(float r) {show(G[pv],r); return this;}
  pts drawClosedCurve(float r) {for (int v=0; v<nv-1; v++) stub(G[v],V(G[v],G[v+1]),r,r);  stub(G[nv-1],V(G[nv-1],G[0]),r,r); return this;}
  pts drawOpenCurve(float r) {for (int v=0; v<nv-1; v++) stub(G[v],V(G[v],G[v+1]),r,r);  return this;}
  
  pts moveAll(vec V) {for (int i=0; i<nv; i++) G[i].add(V); return this;};   
  pts translate(vec V) {pts res = new pts(); res.declare(); for (int i=0; i<nv; i++) res.addPt(P(this.G[i], V)); return res;}
  
  void loadPts(String fn) 
  {
    println("loading: "+fn); 
    String [] ss = loadStrings(fn);
    int s=0; 
    nv = int(ss[s++]); print("nv="+nv);
    for(int k=0; k<nv; k++) 
    {
      int i=k+s;
      String [] SS = split(ss[i],","); 
      G[k].setTo(float(SS[0]),float(SS[1]),float(SS[2]));
    }
    pv=0;
  }
   
  public boolean pointInPolygon(pt P)
  {
    int num_intersections = 0;
    pt O = this.centroid();
    vec V = V(10000, U(random(-1,1), random(-1,1), 0));
    for (int i = 0; i < this.nv; i++)
    {
      //Find number of intersections between OP and polygon
      //if (doesIntersect(P, P(P, 10000, V(P,O)), this.G[i], this.G[(i+1)%this.nv]))
      if (doesIntersect(P, P(P, V), this.G[i], this.G[(i+1)%this.nv]))
      {
        num_intersections++;
      }
    }
    return (num_intersections%2 == 1) ? true : false;
  }
  
  void colorPolygon()
  {
    beginShape();
    for (int i = 0; i < this.nv; i++)
    {
      vertex(this.G[i].x, this.G[i].y, 0);
    }
    endShape(CLOSE);
  }
  
} // end of pts class

boolean lineCrosses(pt P, pt Q, pt A, pt B)
{
  return (det2(V(P,A), V(A,B)) * det2(V(Q,A), V(A,B)) <= 0);
}

boolean doesIntersect(pt P, pt Q, pt A, pt B)
{
  return (lineCrosses(P, Q, A, B) && lineCrosses(A, B, P, Q));
}

pt Modulo(pt Pt, vec U, vec V)
{
  int diff_u = round((Pt.x * V.y - Pt.y * V.x)/(U.x * V.y - V.x * U.y));
  int diff_v = round((Pt.y * U.x - Pt.x * U.y)/(U.x * V.y - V.x * U.y));
  pt result = P(P(Pt, -diff_u, U), -diff_v, V);
  return result;
}
