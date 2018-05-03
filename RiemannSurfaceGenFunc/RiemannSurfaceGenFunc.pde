import peasy.*;

PeasyCam cam;

ArrayList<Complex[]> graph = new ArrayList<Complex[]>();
ArrayList<Complex[]> unitCircleGraph = new ArrayList<Complex[]>();


// sqrt(1-z^2)
/*
float minIm = -1;
float maxIm = 1;
float minRe = -1;
float maxRe = 1;
int steps = 50;
int Nroot = 2; // N-th root
Complex[] function(Complex input){ // sqrt(1-z^2)
  return getRoots(Complex.Sub(new Complex(-1,0), Complex.Pow(input,2)), 2);
}*/
float minIm = -PI/4;
float maxIm = PI/4;
float minRe = -PI/4;
float maxRe = PI/4;
int steps = 100;
int Nroot = 2; // N-th root
Complex[] function(Complex input){ // sqrt(1-z^2)
  Complex[] r = getRoots(Complex.Sub(new Complex(-1,0), Complex.Pow(input,2)), 2);
  Complex[] outs = new Complex[r.length];
  for (int i = 0;i<outs.length;i++){
    outs[i] = Complex.Sub(Complex.tanh(r[i]), Complex.Mul(new Complex(0,2), Complex.Mul(input, Complex.Div(r[i],Complex.Sub(new Complex(1,0), Complex.Mul(new Complex(2,0), Complex.Pow(input,2)))))));
  }
  return outs;
}

boolean plotArg = false;

boolean ImageArgumentColoring = true;

boolean animateUnitCirclePath = true;
double unitCirclePathArg = 0;
float animationSpeed = 1/float(Nroot);

void setup() {
  size(500, 500, P3D);
  cam = new PeasyCam(this, 0, 0, 0, 100);
  cam.setWheelScale(0.3);
  cam.setMinimumDistance(0.00000000001);
  float fov = PI/3.0;
  perspective(fov, float(width)/float(height), 
    0.0001, 10000000);
  calcGraph();
  colorMode(HSB);
  
  frameRate(60);
}

/*Complex[] getMultiValuedFunctionVal(Complex input){
  Complex[] roots = getRoots(input, Nroot);
  Complex[] val = 
}*/
Complex[] getRoots(Complex input, int n) { // calculates all complex n-ths roots
  Complex[] roots = new Complex[n];

  double arg = input.Arg2PIBranch(); //  2*PI branch of complex log
  double r = input.Abs();
  double rr = sqrt((float)r); // real sqrt of real radius

  for (int i=0; i<n; i++) {
    double n_arg = (arg+i*2*PI)/n;
    roots[i] = Complex.Mul(new Complex(rr, 0), Complex.e_to_ix(n_arg));
  }

  return roots;
}

void calcGraph() {
  float dRe = (maxRe-minRe)/steps;
  float dIm = (maxIm-minIm)/steps;

  for (float r = minRe; r<=maxRe; r+=dRe) {
    for (float i = minIm; i<=maxIm; i+=dIm) {
      Complex z = new Complex(r, i);
      Complex[] vals = function(z);//getRoots(z, Nroot);
      for (int k=0; k<Nroot; k++) {
        Complex[] point = new Complex[]{
          z, 
          vals[k]
        };
        graph.add(point);
      }
    }
  }
}

void drawAxis() {
  float l = 7;
  //Re - red
  colorMode(RGB);
  strokeWeight(1);
  stroke(color(255, 0, 0));
  line(0, 0, 0, l, 0, 0);
  //Im - green
  stroke(color(0, 255, 0));
  line(0, 0, 0, 0, l, 0);
  //output - blue
  stroke(color(0, 0, 255));
  line(0, 0, 0, 0, 0, l);
  colorMode(HSB);
}

void draw() {
  background(0);
  pushMatrix();
  noFill();
  stroke(255);

  strokeWeight(2);
  for (Complex[] p : graph) {
    double z = plotArg ? (p[1].Arg()+PI) % (2*PI) : p[1].real;
    float d = ImageArgumentColoring ? (float)(p[1].Arg2PIBranch() /(2*PI)*255) :(float)(z+p[0].Abs())*50 % 255;
    stroke(d, 255, 255);
    point((float)p[0].real, (float)p[0].imag, (float)z);
  }
  /*if (animateUnitCirclePath){ // draws the image of the unit-circle under the n-th root
    stroke(255);
    strokeWeight(7);
    Complex z = Complex.e_to_ix(unitCirclePathArg);
    double imageArg = unitCirclePathArg/Nroot % (2*PI);
    Complex image = Complex.e_to_ix(imageArg);
    point((float)z.real, (float)z.imag, (float)(plotArg ? (image.Arg()+PI) % (2*PI) : image.real));
    //println(unitCirclePathArg,imageArg);
    unitCirclePathArg += 2*PI*animationSpeed/60.0;
    if (unitCirclePathArg<2.05*PI*Nroot){
      unitCircleGraph.add(new Complex[]{
        z,
        image
      });
    }
    beginShape();
    strokeWeight(1);
    for (int i=0;i<unitCircleGraph.size();i++){
      Complex p1 = unitCircleGraph.get(i)[0];
      Complex p2 = unitCircleGraph.get(i)[1];
      vertex((float)p1.real, (float)p1.imag, (float)(plotArg ? (p2.Arg()+PI) % (2*PI) : p2.real));
    }
    endShape();
  }*/
  popMatrix();
  drawAxis();
}