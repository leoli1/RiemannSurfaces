static class Complex{
  public static final Complex i = new Complex(0,1);
  public static final Complex zero = new Complex(0,0);
  static final double e = 2.7182818;
  public double real = 0;
  public double imag = 0;
  
  public Complex(double _real, double _imaginary){
    real = _real;
    imag = _imaginary;
  }
  
  public double Abs(){
    return (double)Math.pow(real*real+imag*imag, 0.5);
  }
  public Complex Negative(){
    return Complex.Mul(this,-1);
  }
  
  public Complex Conjugate(){
    return new Complex(this.real,-this.imag);
  }
  
  public static Complex Add(Complex c1, Complex c2){
    return new Complex(c1.real+c2.real, c1.imag+c2.imag);
  }
  public static Complex Sub(Complex c1, Complex c2){
    return Complex.Add(c1,c2.Negative());
  }
  
  
  public static Complex Mul(Complex c1, Complex c2){
    return new Complex(c1.real*c2.real-c1.imag*c2.imag, c1.real*c2.imag+c1.imag*c2.real);
  }
  public static Complex Mul(Complex c1, double z){
    return Complex.Mul(c1,new Complex(z,0));
  }
  public static Complex Div(Complex c1, Complex c2){
    return Complex.Mul(Complex.Mul(c1,c2.Conjugate()),1/(c2.real*c2.real+c2.imag*c2.imag));
  }
  static Complex e_to_ix(double x){
    return new Complex(Math.cos(x),Math.sin(x));
  }
  static Complex e_to_iz(Complex z){
    return Complex.Mul(e_to_ix(z.real),Math.pow(e,-z.imag));
  }
  public static Complex Pow(Complex c, Complex z){
    if (Math.abs(c.real) < 0.00000000000001 && Math.abs(c.imag) < 0.00000000000001) return new Complex(0,0);
    double arg = c.Arg();
    double r = Math.sqrt(c.real*c.real+c.imag*c.imag);
    
    double ra = Math.pow(r,z.real);
    Complex e_ib_logr = e_to_ix(z.imag*Math.log(r));
    Complex e_argai = e_to_ix(arg*z.real);
    //Complex e_iza = new Complex(cos(z*arg),sin(z*arg));
    double e_negargb = Math.pow(e, -arg*z.imag);
    Complex c1 = Complex.Mul(new Complex(ra,0),e_ib_logr);
    Complex c2 = Complex.Mul(e_argai,new Complex(e_negargb,0));
    return Complex.Mul(c1,c2);
  }
  public double Arg(){
    return Math.atan2(this.imag, this.real);
  }
  public static Complex Pow(Complex c, double z){
    return Complex.Pow(c, new Complex(z,0));
  }
  public String toString(){
    return real+"+"+imag+"i";
  }
  
  public static Complex csin(Complex z){
    return Complex.Mul(new Complex(0,-0.5), Complex.Add(e_to_iz(z),e_to_iz(z.Negative()).Negative()));
  }
  public static Complex ccos(Complex z){
    return Complex.Mul(Complex.Add(e_to_iz(z),e_to_iz(z.Negative())),0.5);
  }
  public static Complex ctan(Complex z){
    return Complex.Div(csin(z),ccos(z));
  }
}