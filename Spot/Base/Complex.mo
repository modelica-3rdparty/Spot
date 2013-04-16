package Complex "Complex functions (preliminary package)"
  extends Icons.Base;

  annotation (preferedView="info",
Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
Window(
  x=0.05,
  y=0.41,
  width=0.4,
  height=0.38,
  library=1,
  autolayout=1),
Documentation(info="<html>
<p>Auxiliary package, to be used until Complex type is available in Modelica.</p>
</html>
"), Icon);

function conjC "Conjugate value of complex number"
  extends Icons.Function;

  input Types.Complex z "complex argument";
  output Types.Complex conj_z "conjugate value of z";

annotation (Documentation(info="<html>
</html>"));

algorithm
  conj_z := transpose(z);
end conjC;

function absC "Absolute value of complex number"
  extends Icons.Function;

  input Types.Complex z "complex argument";
  output Real abs_z "absolute value of z";

annotation (Documentation(info="<html>
</html>"));

algorithm
  abs_z := sqrt(detC(z));
end absC;

function detC "Determinant of complex number matrix"
  extends Icons.Function;

  input Types.Complex z "complex argument";
  output Real det_z "determinant of z";

annotation (Documentation(info="<html>
</html>"));

algorithm
  det_z := z[1,1]*z[2,2] - z[1,2]*z[2,1];
end detC;

function invC "Inverse of complex number"
  extends Icons.Function;

  input Types.Complex z "complex argument";
  output Types.Complex inv_z "inverse of z";

annotation (Documentation(info="<html>
</html>"));

algorithm
  inv_z := transpose(z)/detC(z);
end invC;

function sumC "Sum of complex numbers"
  extends Icons.Function;

  input Types.Complex[:] z "complex vector";
  output Types.Complex s "sum of components of z";

annotation (Documentation(info="<html>
</html>"));

algorithm
  s := z[1, :, :];
  for k in 2:size(z,1) loop
    s := s + z[k,:,:];
  end for;
end sumC;

function prodC "Product of complex numbers"
  extends Icons.Function;

  input Types.Complex[:] z "complex vector";
  output Types.Complex p "product of components of z";

annotation (Documentation(info="<html>
</html>"));

algorithm
  p := z[1, :, :];
  for k in 2:size(z,1) loop
    p := p*z[k,:,:];
  end for;
end prodC;

function expI "Exponential of imaginary number"
  extends Icons.Function;

  input Real phi "real argument";
  output Types.Complex exp_jphi "exponential of j*phi";
  protected
  Real c;
  Real s;
annotation (Documentation(info="<html>
</html>"));

algorithm
  c := cos(phi);
  s := sin(phi);
  exp_jphi := [c, -s; s, c];
end expI;

function expC "Exponential of complex number"
  extends Icons.Function;

  input Types.Complex z "complex argument";
  output Types.Complex exp_z "exponential of z";

annotation (Documentation(info="<html>
</html>"));

algorithm
  exp_z := exp(z[1,1])*expI(z[2,1]);
end expC;

function powerC "Power of complex number"
  extends Icons.Function;

  input Types.Complex z "complex argument";
  input Real alpha "exponent";
  output Types.Complex pow_z "power of z";
  protected
  function atan2=Modelica.Math.atan2;
annotation (Documentation(info="<html>
</html>"));

algorithm
  pow_z := detC(z)^(0.5*alpha)*expI(alpha*atan2(z[2,1], z[1,1]));
end powerC;

function sqrtC "Square-root of complex number"
  extends Icons.Function;

  input Types.Complex z "complex argument";
  output Types.Complex sqrt_z "square-root of z";
  protected
  Real a;
  function atan2=Modelica.Math.atan2;

annotation (Documentation(info="<html>
</html>"));

algorithm
  a := absC(z);
  sqrt_z := sqrt(a)*expI(0.5*atan2(z[2,1], z[1,1]));
end sqrtC;

function logC "Logarithm of complex number"
  extends Icons.Function;

  input Types.Complex z "complex argument";
  output Types.Complex log_z "logarithm of z";
  protected
  Real re;
  Real im;
  function atan2=Modelica.Math.atan2;
  function log=Modelica.Math.log;
annotation (Documentation(info="<html>
</html>"));

algorithm
  re := 0.5*log(detC(z));
  im := atan2(z[2,1], z[1,1]);
  log_z := [re, -im; im, re];
end logC;

function cosC "Cosine of complex number"
  extends Icons.Function;

  input Types.Complex z "complex argument";
  output Types.Complex cos_z "cosine of z";
  protected
  Real re;
  Real im;

annotation (Documentation(info="<html>
</html>"));

algorithm
  re := cos(z[1,1])*cosh(z[2,1]);
  im := -sin(z[1,1])*sinh(z[2,1]);
  cos_z := [re, -im; im, re];
end cosC;

function sinC "Sine of complex number"
  extends Icons.Function;

  input Types.Complex z "complex argument";
  output Types.Complex sin_z "sine of z";
  protected
  Real re;
  Real im;

annotation (Documentation(info="<html>
</html>"));

algorithm
  re := sin(z[1,1])*cosh(z[2,1]);
  im := cos(z[1,1])*sinh(z[2,1]);
  sin_z := [re, -im; im, re];
end sinC;

function tanC "Tangens of complex number"
  extends Icons.Function;

  input Types.Complex z "complex argument";
  output Types.Complex tan_z "tangens of z";

annotation (Documentation(info="<html>
</html>"));

algorithm
  tan_z := sinC(z)*invC(cosC(z));
end tanC;

function atanC "Arc-tangens of complex number"
  extends Icons.Function;

  input Types.Complex z "complex argument";
  output Types.Complex atan_z "arc-tangens of z";
  protected
  Real a;
annotation (Documentation(info="<html>
</html>"));

algorithm
  a := 0.5*(1 - detC(z));
  atan_z := 0.5*logC([a, -z[1,1]; z[1,1], a]/(1 - a + z[2,1]));
  atan_z := [atan_z[2,1], atan_z[2,2]; -atan_z[1,1], -atan_z[1,2]];
end atanC;

function coshC "Hyperbolic cosine of complex number"
  extends Icons.Function;

  input Types.Complex z "complex argument";
  output Types.Complex cosh_z "hyp cosine of z";
  protected
  Real re;
  Real im;

annotation (Documentation(info="<html>
</html>"));

algorithm
  re := cosh(z[1,1])*cos(z[2,1]);
  im := sinh(z[1,1])*sin(z[2,1]);
  cosh_z := [re, -im; im, re];
end coshC;

function sinhC "Hyperbolic sine of complex number"
  extends Icons.Function;

  input Types.Complex z "complex argument";
  output Types.Complex sinh_z "hyp sine of z";
  protected
  Real re;
  Real im;

annotation (Documentation(info="<html>
</html>"));

algorithm
  re := sinh(z[1,1])*cos(z[2,1]);
  im := cosh(z[1,1])*sin(z[2,1]);
  sinh_z := [re, -im; im, re];
end sinhC;

function tanhC "Hyperbolic tangens of complex number"
  extends Icons.Function;

  input Types.Complex z "complex argument";
  output Types.Complex tanh_z "hyp tangens of z";

annotation (Documentation(info="<html>
</html>"));

algorithm
  tanh_z := sinhC(z)*invC(coshC(z));
end tanhC;

function atanhC "Area-tangens-hyp of complex number"
  extends Icons.Function;

  input Types.Complex z "complex argument";
  output Types.Complex atan_z "area-tangens-hyp of z";
  protected
  Real a;
annotation (Documentation(info="<html>
</html>"));

algorithm
  a := 0.5*(1 - detC(z));
  atan_z := 0.5*logC([a, -z[2,1]; z[2,1], a]/(1 - a - z[1,1]));
end atanhC;
end Complex;
