import peasy.*;

PeasyCam cam;

ArrayList<Complex[]> graph = new ArrayList<Complex[]>();

float minIm = -5;
float maxIm = 5;
float minRe = -5;
float maxRe = 5;
int steps = 50;
int Nroot = 3;

boolean plotArg = false;

void setup() {
  size(500, 500, P3D);
  cam = new PeasyCam(this, 0, 0, 0, 100);
  cam.setWheelScale(0.5);
  cam.setMinimumDistance(0.00000000001);
  float fov = PI/3.0;
  perspective(fov, float(width)/float(height), 
    0.0001, 10000000);
  calcGraph();
  colorMode(HSB);
}

Complex[] getRoots(Complex input, int n) {
  Complex[] roots = new Complex[n];

  double arg = input.Arg()+PI; //  2*PI branch of complex log
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
  float l = 10;
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

  //beginShape();
  strokeWeight(2);
  for (Complex[] p : graph) {
    double z = plotArg ? (p[1].Arg()+PI) % (2*PI) : p[1].real;
    float d = (float)(z+p[0].Abs())*50 % 255;
    stroke(d, 255, 255);
    point((float)p[0].real, (float)p[0].imag, (float)z);
  }
  //endShape();

  popMatrix();
  drawAxis();
}