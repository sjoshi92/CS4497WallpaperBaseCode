public class symmetry
{
  String type = "NONE";
  pt axis_pt = P();
  vec axis_vec = V();
  float amount = 0.0;
  
  public symmetry(String tt)
  {
    if (tt == "TRANSLATE" || tt == "MIRROR" || tt == "GLIDE" || tt == "ROTATE" || tt == "IDENTITY")
    {
      this.type = tt;
    }
  }
  
  public symmetry()
  {
    this.type = "IDENTITY";
  }
  
  public symmetry(String tt, vec V)
  {
    if (tt == "TRANSLATE")
    {
      this.type = tt;
      this.axis_vec = V;
    }
  }
  
  public symmetry(String tt, pt P, float a)
  {
    if (tt == "ROTATE")
    {
      this.type = tt;
      this.axis_pt = P;
      this.amount = a;
    }
  }
  
  public symmetry(String tt, pt P, vec V)
  {
    if (tt == "MIRROR")
    {
      this.type = tt;
      this.axis_pt = P;
      this.axis_vec = V;
    }
  }
  
  public symmetry(String tt, pt P, vec V, float a)
  {
    this.type = tt;
    this.axis_pt = P;
    this.axis_vec = V;
    this.amount = a;
  }
  
  public symmetry(symmetry S)
  {
    this.type = S.type;
    this.axis_pt = S.axis_pt;
    this.axis_vec = S.axis_vec;
    this.amount = S.amount;
  }
  
  public void applyMatrix(int n)
  {
    pt O = this.axis_pt;
    pt X = P(O, V(1,0,0));
    pt Y = P(O, V(0,-1,0));
    pt O1 = this.apply(O,n);
    pt X1 = this.apply(X,n);
    pt Y1 = this.apply(Y,n);
    
    //Translation vector
    vec D = V(O, O1);
    
    //Angle
    float a = angleSigned(V(O,X), V(O1,X1));
    
    //Scaling factor for reflection
    float a1 = angleSigned(V(O,X), V(O,Y));
    float a2 = angleSigned(V(O1,X1), V(O1,Y1));
    int s = a1/a2 < 0 ? -1 : 1;
    
    translate(D.x, D.y, D.z);
    translate(O.x, O.y, O.z);
    rotate(a);
    scale(1,s);
    translate(-O.x, -O.y, -O.z);
  }
  
  public void applyMatrix()
  {
    this.applyMatrix(1);
  }
  
  public pt apply(pt P)
  {
    if (this.type == "TRANSLATE")
    {
      return Translate(P, this.axis_vec);
    }
    if (this.type == "ROTATE")
    {
      return Rotate(P, this.axis_pt, this.amount); 
    }
    else if (this.type == "MIRROR")
    {
      return Mirror(P, this.axis_pt, this.axis_vec);
    }
    else if (this.type == "GLIDE")
    {
      return Glide(P, this.axis_pt, this.axis_vec, this.amount);
    }
    else
    {
      return P;
    }
  }
  
  public pt apply(pt P, int n)
  {
    pt result = P(P);
    symmetry input = new symmetry(this);
    if (n < 0)
    {
      if (input.type == "ROTATE")
      {
        input.amount = 2*PI - input.amount;
      }
      if (input.type == "GLIDE")
      {
        input.amount = -input.amount;
      }
      if (input.type == "TRANSLATE")
      {
        input.axis_vec = M(input.axis_vec);
      }
    }
    for (int i = 0; i < abs(n); i++)
    {
      result = input.apply(result);
    }
    return result;
  }
  
  public symmetry apply(symmetry S)
  {
    pt P = S.axis_pt;
    P = this.apply(P);
    vec V = V(S.axis_vec);
    float amt = S.amount;
    if (S.type == "IDENTITY")
    {
      return this;
    }
    if (this.type == "IDENTITY")
    {
      return S;
    }
    if (this.type == "ROTATE")
    {
      V = R(V, this.amount, V(1, 0, 0), V(0, 1, 0));
      if (S.type == "ROTATE")
      {
        amt += this.amount;
      }
    }
    return new symmetry(S.type, P, V, amt);
  }
  
  public symmetry apply(symmetry S, int n)
  {
    symmetry result = S, input = new symmetry(this);
    if (n < 0)
    {
      if (input.type == "ROTATE")
      {
        input.amount = 2*PI - input.amount;
      }
      if (input.type == "GLIDE")
      {
        input.amount = -input.amount;
      }
    }
    for (int i = 0; i < abs(n); i++)
    {
      result = input.apply(result);
    }
    return result;
  }
  
  public int getCount()
  {
    if (this.type == "MIRROR" || this.type == "GLIDE")
    {
      return 2;
    }
    else if (this.type == "ROTATE")
    {
      return int(2*PI/this.amount);
    }
    return 1;
  }
  
  public void print()
  {
    println("Symmetry " + this.type + " has Pt: ( " + this.axis_pt.x + " , " + this.axis_pt.y + " ); Vec: ( " + this.axis_vec.x  + " , " + this.axis_vec.y + " ) Amount: " + this.amount);
  }
}
