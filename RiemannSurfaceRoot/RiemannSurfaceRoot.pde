import peasy.*;

PeasyCam cam;

ArrayList<Complex[]> graph = new ArrayList<Complex[]>();
ArrayList<Complex[]> unitCircleGraph = new ArrayList<Complex[]>();

float minIm = -5;
float maxIm = 5;
float minRe = -5;
float maxRe = 5;
int steps = 50;
int Nroot = 2; // N-th root

boolean plotArg = false;

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

Complex[] getRoots(Complex input, int n) { // calculates all complex n-ths roots
  Complex[] roots = new Complex[n];

  double targ = input.Arg();
  double arg = targ>=0 ? targ : targ+2*PI; //  2*PI branch of complex log
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
      Complex[] roots = getRoots(z, Nroot);
      for (int k=0; k<Nroot; k++) {
        Complex[] point = new Complex[]{
          z, 
          roots[k]
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
    float d = (float)(z+p[0].Abs())*50 % 255;
    stroke(d, 255, 255);
    point((float)p[0].real, (float)p[0].imag, (float)z);
  }
  if (animateUnitCirclePath){ // draws the image of the unit-circle under the n-th root
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
  }
  popMatrix();
  drawAxis();
}