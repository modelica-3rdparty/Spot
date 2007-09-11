package Transforms "Auxiliary blocks"
  extends Base.Icons.Library;

  annotation (preferedView="info",
Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
Window(
  x=0.05,
  y=0.41,
  width=0.4,
  height=0.32,
  library=1,
  autolayout=1),
Documentation(info="<html>
</html>"),
    Icon);

  block Park "Park-transform of input signal-vector"
    extends Partials.MIMO(final nin=3, final nout=3);

    Modelica.Blocks.Interfaces.RealInput theta(redeclare type SignalType =
          SI.Angle) "transformation angle"
      annotation (extent=[-10,90; 10,110], rotation=-90);
  protected
    constant Real s13=sqrt(1/3);
    constant Real s23=sqrt(2/3);
    constant Real dph_b=2*pi/3;
    constant Real dph_c=4*pi/3;
    Real[3] c;
    Real[3] s;
    annotation (defaultComponentName = "park",
      Coordsys(
        extent=[-100, -100; 100, 100],
        grid=[2, 2],
        component=[20, 20]),
      Icon(
     Text(
    extent=[-80,40; 80,-40],
    style(color=10),
          string="park")),
      Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
      Documentation(info="<html>
<p>The block <tt>Park</tt> transforms abc variables (u) into dqo variables (y) with arbitrary angular orientation
<pre>  y = P*u</pre>
<tt>P</tt> can be factorised into a constant, angle independent orthogonal matrix <tt>P0</tt> and an angle-dependent rotation <tt>R</tt></p>
<pre>
  P(theta) = R'(theta)*P0
</pre>
<p>Using the definition</p>
<pre>
  c_k = cos(theta - k*2*pi/3),  k=0,1,2 (phases a, b, c)
  s_k = sin(theta - k*2*pi/3),  k=0,1,2 (phases a, b, c)
</pre>
<p>it takes the form
<pre>
                       [ c_0,  c_1, c_2]
  P(theta) = sqrt(2/3)*[-s_0, -s_1,-s_2]
                       [ w,    w,   w  ]
</pre>
with
<pre>
                        [ 1,      -1/2,       -1/2]
  P0 = P(0) = sqrt(2/3)*[ 0, sqrt(3)/2, -sqrt(3)/2]
                        [ w,         w,          w]
</pre>
and
<pre>
             [c_0, -s_0, 0]
  R(theta) = [s_0,  c_0, 0]
             [  0,  0,   1]
</pre></p>
</html>"),
      Diagram);

  equation
    c =  cos({theta, theta - dph_b, theta - dph_c});
    s =  sin({theta, theta - dph_b, theta - dph_c});
    y = transpose([s23*c, -s23*s, {s13, s13, s13}])*u;
  end Park;

  block Rotation_dq "Rotation of input signal-vector"
    extends Partials.MIMO(final nin=2, final nout=2);

    Modelica.Blocks.Interfaces.RealInput theta(redeclare type SignalType =
          SI.Angle) "rotation angle"
      annotation (extent=[-10,90; 10,110], rotation=-90);
  protected
    Real c;
    Real s;
    annotation (defaultComponentName = "rot_dq",
      Coordsys(
        extent=[-100, -100; 100, 100],
        grid=[2, 2],
        component=[20, 20]),
      Icon(
     Text(
    extent=[-75,40; 75,-40],
    style(color=10),
          string="rot_dq")),
      Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
      Documentation(info="<html>
<p>The block <tt>Rotation_dq</tt> rotates u by an arbitrary angle <tt>theta</tt> into y according to
<pre>  y = R_dq*u</pre>
<tt>R_dq</tt> is the restriction of <tt>R_dqo</tt> from dqo to dq.</p>
<p>The matrix <tt>R_dqo</tt> rotates dqo variables around the o-axis in dqo-space with arbitrary angle <tt>theta</tt>.
<p>It takes the form
<pre>
                 [cos(theta), -sin(theta), 0]
  R_dqo(theta) = [sin(theta),  cos(theta), 0]
                 [  0,           0,        1]
</pre>
and has the real eigenvector
<pre>  {0, 0, 1}</pre>
in the dqo reference-frame.</p>
<p>Coefficient matrices of the form (symmetrical systems)
<pre>
      [x, 0, 0 ]
  X = [0, x, 0 ]
      [0, 0, xo]
</pre>
are invariant under transformations R_dqo</p>
<p>The connection between R_dqo and R_abc is the following
<pre>  R_dqo = P0*R_abc*P0'.</pre>
with P0 the orthogonal transform 'Transforms.P0'.</p>
</html>
"),   Diagram);

  equation
    c =   cos(theta);
    s =   sin(theta);
    y = [c, -s; s, c]*u;
  end Rotation_dq;

  block Rotation_abc "Rotation of input signal-vector"
    extends Partials.MIMO(final nin=3, final nout=3);

    Modelica.Blocks.Interfaces.RealInput theta(redeclare type SignalType =
          SI.Angle) "rotation angle"
      annotation (extent=[-10,90; 10,110], rotation=-90);
  protected
    constant Real q13=1/3;
    constant Real q23=2/3;
    constant Real dph_b=2*pi/3;
    constant Real dph_c=4*pi/3;
    Real[3] g;
    annotation (defaultComponentName = "rot_abc",
      Coordsys(
        extent=[-100, -100; 100, 100],
        grid=[2, 2],
        component=[20, 20]),
      Icon(
     Text(
    extent=[-75,40; 75,-40],
    style(color=10),
          string="rot_abc")),
      Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
      Documentation(info="<html>
<p>The block <tt>Rotation_abc</tt> rotates u by an arbitrary angle <tt>theta</tt> into y according to
<pre>  y = R_abc*u</pre>
<p>The matrix <tt>R_abc</tt> rotates abc variables around the {1,1,1}-axis in abc-space with arbitrary angle <tt>theta</tt>.
<p>Using the definition
<pre>
  g_k = 1/3 + (2/3)*cos(theta - k*2*pi/3),  k=0,1,2 (phases a, b, c)
</pre>
it takes the form
<pre>
                 [g_0, g_2, g_1]
  R_abc(theta) = [g_1, g_0, g_2]
                 [g_2, g_1, g_0]
</pre>
and has the real eigenvector
<pre>  {1, 1, 1}/sqrt(3)</pre>
in the abc reference-frame.</p>
<p>Coefficient matrices of the form (symmetrical systems)
<pre>
      [x,  xm, xm]
  X = [xm,  x, xm]
      [xm, xm, x ]
</pre>
are invariant under transformations R_abc</p>
<p>The connection between R_abc and R_dqo is the following
<pre>  R_abc = P0'*R_dqo*P0.</pre>
with P0 the orthogonal transform 'Transforms.P0'.</p>
</html>"));

  equation
    g =  {q13, q13, q13} + q23*cos({theta, theta - dph_b, theta - dph_c});
    y =  [g[{1,2,3}], g[{3,1,2}], g[{2,3,1}]]*u;
  end Rotation_abc;

  block RotationPhasor "Rotation of input signal-vector"
    extends Partials.MIMO(final nin=2, final nout=2);

    Modelica.Blocks.Interfaces.RealInput theta(redeclare type SignalType =
          SI.Angle) "rotation angle"
      annotation (extent=[-10,90; 10,110], rotation=-90);
    annotation (defaultComponentName = "rot_Phasor",
      Coordsys(
        extent=[-100, -100; 100, 100],
        grid=[2, 2],
        component=[20, 20]),
      Icon(
     Text(
    extent=[-75,40; 75,-40],
    style(color=10),
          string="rot_Ph")),
      Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
      Documentation(info="<html>
<p>Rotates phasor u in polar representation by angle theta.</p>
<p>Input u:
<pre>
  u[1]     absolute value
  u[2]     argument, phase
</pre></p>
<p>Output y:
<pre>
  y[1] = u[1]            absolute value
  y[2] = u[2] + theta    argument, phase
</pre></p>
</html>"),
      Diagram);

  equation
    y = {u[1], u[2] + theta};
  end RotationPhasor;

  block PhasorToAlphaBeta "Rotation of input signal-vector"
    extends Partials.MIMO(final nin=2, final nout=2);

    Modelica.Blocks.Interfaces.RealInput theta(redeclare type SignalType =
          SI.Angle) "rotation angle"
      annotation (extent=[-10,90; 10,110], rotation=-90);
  protected
    constant Real s23=sqrt(2/3);
    annotation (defaultComponentName = "phToAlphaBeta",
      Coordsys(
        extent=[-100, -100; 100, 100],
        grid=[2, 2],
        component=[20, 20]),
      Icon(
     Text(
    extent=[-70,18; -10,-18],
    style(color=10),
          string="uPh"),
     Text(
    extent=[-10,40; 80,10],
    style(color=10),
          string="alpha"),
     Text(
    extent=[-10,-10; 80,-40],
    style(color=10),
          string="beta")),
      Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
      Documentation(info="<html>
<p>Transforms phasor u to amplitudes {alpha, beta}.<br>
i.e. rotates phasor in polar representation by angle theta and transforms to Euclidean {y[1], y[2]} coordinates.</p>
<p>Input u:
<pre>
  u[1]     absolute value
  u[2]     argument, phase
</pre></p>
<p>Output y:
<pre>
  y = sqrt(2/3)*u[1]*{cos(u[2] + theta), sin(u[2] + theta)}    amplitudes alpha, beta
</pre></p>
</html>"),
      Diagram);

  equation
    y = sqrt(2/3)*u[1]*{cos(u[2] + theta), sin(u[2] + theta)};
  end PhasorToAlphaBeta;
end Transforms;
