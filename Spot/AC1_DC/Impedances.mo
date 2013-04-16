package Impedances "Impedance and admittance two terminal"
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
  height=0.38,
  library=1,
  autolayout=1),
Documentation(info="<html>
<p>Contains lumped impedance models and can also be regarded as a collection of basic formulas. Shunts are part of a separate package.</p>
<p>General relations.</p>
<pre>
  r = R / R_base                  resistance
  x = 2*pi*f_nom*L/R_base         reactance
  g = G / G_base                  conductance
  b = (2*pi*f_nom*C) / G_base     susceptance
  G_base = 1/R_base
</pre>
<p>The reactance-matrix is</p>
<pre>
  x = [x_s, x_m
       x_m, x_s]
</pre>
<p>with the relations</p>
<pre>
  x1   = x_s - x_m,         stray reactance
  x0  = x_s + x_m,          zero reactance
  x_s = (x1 + x0)/2,        self reactance single conductor
  x_m = (x0 - x1)/2,        mutual reactance
</pre>
<p>Coupling.</p>
<pre>
  -x_s &lt  x_m &lt  x_s
  uncoupled limit:          x_m = 0,        x0 = x_s
  fully positive coupled:   x_m = x_s,      x0 = 2*x_s
  fully negative coupled:   x_m = -x_s,     x0 = 0
</pre>
<p>The resistance matrix is</p>
<pre>
  r = [r1, 0
       0,  r2]
</pre>
<p>The susceptance matrix is</p>
<pre>
  b = [ b_pg + b_pp, -b_pp
       -b_pp,         b_pg + b_pp]
</pre>
<p>where <tt>_pg</tt> denotes 'phase-to-ground' and <tt>_pp</tt> 'phase-to-phase' in analogy to the three-phase notation. More precisely (for a one-phase system) <tt>_pp</tt> means 'conductor-to-conductor'.</p>
<p>The corresponding conduction matrix is (in analogy to susceptance)</p>
<pre>
  g = [g_pg + g_pp, -g_pp
      -g_pp,         g_pg + g_pp]
</pre>
</html>"),
    Icon);

  model Resistor "Resistor, 1-phase"
    extends Partials.ImpedBase(final f_nom=0);

    parameter SIpu.Resistance[2] r={1,1} "resistance";
  protected
    final parameter SI.Resistance[2] R=r*Base.Precalculation.baseR(units, V_nom, S_nom);
    annotation (defaultComponentName="res1",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>Info see package AC1_DC.Impedances.</p>
</html>"),
      Icon(
  Rectangle(extent=[-80,30; 80,-30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255}))),
      Diagram(
        Rectangle(extent=[-60,30; 60,10], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-60,-10; 60,-30], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255}))));

  equation
    diagonal(R)*i = v;
  end Resistor;

  model Conductor "Conductor, 1-phase"
    extends Partials.ImpedBase(final f_nom=0);

    parameter SIpu.Conductance[2] g={1,1} "conductance";
  protected
    final parameter SI.Conductance[2] G=g/Base.Precalculation.baseR(units, V_nom, S_nom);
    annotation (defaultComponentName="cond1",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>Info see package AC1_DC.Impedances.</p>
</html>"),
      Icon(
  Rectangle(extent=[-80,30; 80,-30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255}))),
      Diagram(
        Rectangle(extent=[-60,30; 60,10], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-60,-10; 60,-30], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255}))));

  equation
    diagonal(G)*v = i;
  end Conductor;

  model Inductor "Inductor with series resistor, 1-phase"
    extends Partials.ImpedBase;

    parameter SIpu.Resistance[2] r={0,0} "resistance";
    parameter SIpu.Reactance[2,2] x=[1,0;0,1] "reactance matrix";
  protected
    final parameter Real[2] RL_base=Base.Precalculation.baseRL(units, V_nom, S_nom, 2*pi*f_nom);
    final parameter SI.Resistance[2] R=r*RL_base[1];
    final parameter SI.Inductance[2,2] L=x*RL_base[2];
    annotation (defaultComponentName="ind1",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[40, 40]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>Info see package AC1_DC.Impedances.</p>
</html>"),
      Icon(
  Rectangle(extent=[-80,30; -40,-30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
  Rectangle(extent=[-40, 30; 80, -30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))),
      Diagram(
        Rectangle(extent=[-60,30; -40,10], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,30; 60,10], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-60,-10; -40,-30], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,-10; 60,-30], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=3,
            rgbfillColor={0,0,255})),
    Rectangle(extent=[-40,5; 60,-5],  style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175}))));

  equation
    L*der(i) + diagonal(R)*i = v;
  end Inductor;

  model Capacitor "Capacitor with parallel conductor, 1-phase"
    extends Partials.ImpedBase;

    parameter SIpu.Conductance[2] g={0,0} "conductance";
    parameter SIpu.Susceptance[2] b={1,1} "susceptance";
  protected
    final parameter Real[2] GC_base=Base.Precalculation.baseGC(units, V_nom, S_nom, 2*pi*f_nom);
    final parameter SI.Conductance[2] G=g*GC_base[1];
    final parameter SI.Capacitance[2] C=b*GC_base[2];
    annotation (defaultComponentName="cap1",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>No pair capacitance.</p>
<p>Info see package AC1_DC.Impedances.</p>
</html>"),
      Icon(
        Line(points=[-90,0; -20,0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=69,
            rgbfillColor={0,128,255})),
        Line(points=[90,0; 20,0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=69,
            rgbfillColor={0,128,255})),
        Rectangle(extent=[-12,60; 12,-60], style(
            color=30,
            rgbcolor={215,215,215},
            fillColor=30,
            rgbfillColor={215,215,215})),
        Rectangle(extent=[-20,60; -12,-60], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[12,60; 20,-60], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))),
      Diagram(
        Rectangle(extent=[-4,40; -2,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[2,40; 4,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
    Rectangle(extent=[-10,14; 10,6], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[-4,30; -60,30; -60,10; -10,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[4,30; 60,30; 60,10; 10,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
        Rectangle(extent=[-4,0; -2,-20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[2,0; 4,-20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
    Rectangle(extent=[-10,-26; 10,-34], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[-4,-10; -60,-10; -60,-30; -10,-30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[4,-10; 60,-10; 60,-30; 10,-30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1))));

  equation
    diagonal(C)*der(v) + diagonal(G)*v = i;
  end Capacitor;

  model Impedance "Impedance (inductive) with series resistor, 1-phase"
    extends Partials.ImpedBase;

    parameter SIpu.Impedance z_abs=1 "impedance-value";
    parameter Real cos_phi(min=0,max=1)=0.1 "cos-phi of impedance";
    parameter Real cpl(min=-1,max=1)=0 "phase coupling, -1 < cpl < 1";
  protected
    final parameter Real[2] RL_base=Base.Precalculation.baseRL(units, V_nom, S_nom, 2*pi*f_nom);
    function acos = Modelica.Math.acos;
    final parameter SI.Resistance R=z_abs*cos_phi*RL_base[1];
    final parameter SI.Inductance[2,2] L=([1,cpl;cpl,1]/(1 - cpl))*z_abs*sin(acos(cos_phi))*RL_base[2];
    annotation (defaultComponentName="impedance1",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>This model corresponds to AC1_DC.Inductor, but uses a different determination of the coefficients.<br>
Instead of x and r the parameters z_abs and cos(phi) are used.</p>
<p>Relations:</p>
<pre>
  z = Z / R_base
  z_abs = |z|
  r = real(z) = |z|*cos(phi)          resistance
  x = imag(z) = |z|*sin(phi)          inductance pair
</pre>
<p>With</p>
<pre>  cpl = x_m/x_s, -1 &lt  cpl &lt  1         coupling coefficient</pre>
<p>we have</p>
<pre>  x0 = x*(1 + cpl)/(1 - cpl)          inductance 0-component</pre>
<p>and</p>
<pre>
  x_s = (x + x0)/2 = x/(1 - cpl)      self inductance single conductor
  x_m = (x0 - x)/2 = x*cpl/(1 - cpl)  mutual inductance
</pre>
<p>Coupling:</p>
<pre>
  cpl &gt  0:        positive coupling (example lines)
  cpl &lt  0:        negative coupling
</pre>
<p>More info see package AC1_DC.Impedances.</p>
</html>
"),   Icon(
       Rectangle(extent=[-80,30; -20,-30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),                      Polygon(points=[
              -80,-30; 80,-30; 80,30; -20,30; -80,-30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))),
      Diagram(
        Rectangle(extent=[-60,30; -40,10], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,30; 60,10], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-60,-10; -40,-30], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,-10; 60,-30], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=3,
            rgbfillColor={0,0,255})),
    Rectangle(extent=[-40,5; 60,-5],  style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175}))));

  equation
    L*der(i) + R*i = v;
  end Impedance;

  model Admittance "Admittance (capacitive) with parallel conductor, 1-phase"
    extends Partials.ImpedBase;

    parameter SIpu.Admittance y_abs=1 "abs value of admittance";
    parameter Real cos_phi(min=0,max=1)=0.1 "cos-phi of admittance";
  protected
    final parameter Real[2] GC_base=Base.Precalculation.baseGC(units, V_nom, S_nom, 2*pi*f_nom);
    function acos = Modelica.Math.acos;
    final parameter SI.Conductance G=y_abs*cos_phi*GC_base[1];
    final parameter SI.Capacitance C=y_abs*sin(acos(cos_phi))*GC_base[2];
    annotation (defaultComponentName="admittance1",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>This model corresponds to AC1_DC.Capacitor, but uses a different determination of the coefficients.<br>
Instead of b and g the parameters y_abs and cos(phi) are used.</p>
<p>Relations:</p>
<pre>
  y = Y / G_base
  y_abs = |y|
  g = real(y) = |y|*cos(phi):     conductance
  b = imag(y) = |y|*sin(phi):     admittance
</pre>
<p>No pair capacitance.</p>
<p>More info see package AC1_DC.Impedances.</p>
</html>
"),   Icon(
        Line(points=[-90,0; -20,0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Line(points=[90,0; 20,0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-12,60; 12,-60], style(
            color=30,
            rgbcolor={215,215,215},
            fillColor=30,
            rgbfillColor={215,215,215})),
       Polygon(points=[-12,60; 12,60; -12,-60; -12,60], style(
        color=7,
        rgbcolor={255,255,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
        Rectangle(extent=[-20,60; -12,-60], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[12,60; 20,-60], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))),
      Diagram(
        Rectangle(extent=[-4,40; -2,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[2,40; 4,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
    Rectangle(extent=[-10,14; 10,6], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[-4,30; -60,30; -60,10; -10,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[4,30; 60,30; 60,10; 10,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
        Rectangle(extent=[-4,0; -2,-20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[2,0; 4,-20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
    Rectangle(extent=[-10,-26; 10,-34], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[-4,-10; -60,-10; -60,-30; -10,-30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[4,-10; 60,-10; 60,-30; 10,-30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1))));

  equation
    C*der(v) + G*v = i;
  end Admittance;

  model Varistor "Varistor, 1-phase"
    extends Partials.ImpedBase(final f_nom=0);

    parameter SIpu.Resistance r0=100 "small voltage resistance";
    parameter SIpu.Voltage v0=1 "saturation voltage";
  protected
    final parameter Real V0=(v0*Base.Precalculation.baseV(units, V_nom));
    final parameter Real H0=(r0*Base.Precalculation.baseR(units, V_nom, S_nom)/V0);
    annotation (defaultComponentName="varistor",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[40, 40]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>Voltage limiter with hyperbolic tangent characteristic.</p>
<p>More info see package AC1_DC.Impedances.</p>
</html>
"),   Icon(
  Rectangle(extent=[-80, 30; 80, -30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
  Line(points=[30, 25; 26, 2; -26, -2; -30, -26], style(color=0))),
      Diagram(
        Rectangle(extent=[-60,30; 60,10], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
        Line(points=[28,30; 26,22; -26,18; -28,10], style(color=0)),
        Rectangle(extent=[-60,-10; 60,-30], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
        Line(points=[28,-10; 26,-18; -26,-22; -28,-30],
                                                    style(color=0))));

  equation
    v = V0*tanh(H0*i);
  end Varistor;

  model ResistorSym "Symmetrical capacitor with neutral access"
    extends Partials.ImpedBase0;

    parameter SI.Resistance R=1;
    Base.Interfaces.Electric_n neutral "symmetrical point"
      annotation (extent=[-10,-110; 10,-90], rotation=
          -90);
    Nodes.Electric_pn_p_n pn_p_n annotation (extent=[-80,-10; -60,10]);
    Nodes.Electric_pn_p_n p_n_pn annotation (extent=[80,-10; 60,10]);
    ImpedancesSingle.ResistorSym resSym(final R=R)
      annotation (extent=[-20,-20; 20,20],rotation=-90);
    annotation (defaultComponentName="resSym",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[40, 40]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
</html>
"),   Icon(
        Line(points=[0,10; 0,-10], style(color=3, rgbcolor={0,0,255})),
        Rectangle(extent=[-10,60; 10,10], style(color=3, rgbcolor={0,0,255})),
        Rectangle(extent=[-10,-10; 10,-60], style(color=3, rgbcolor={0,0,255})),
        Line(points=[-80,10; -40,10; -40,70; 40,70; 40,10; 80,10], style(color=3,
              rgbcolor={0,0,255})),
        Line(points=[-80,-10; -40,-10; -40,-70; 40,-70; 40,-10; 80,-10], style(
              color=3, rgbcolor={0,0,255})),
        Line(points=[0,70; 0,60],  style(color=3, rgbcolor={0,0,255})),
        Line(points=[0,-60; 0,-70],style(color=3, rgbcolor={0,0,255})),
        Line(points=[0,0; 20,0; 20,-100; 10,-100], style(color=3, rgbcolor={0,0,
                255}))),
      Diagram);

  equation
    connect(pn_p_n.term_p, resSym.term_p) annotation (points=[-64,4; -40,4; -40,
          20; -1.22465e-015,20], style(color=3, rgbcolor={0,0,255}));
    connect(resSym.term_p, p_n_pn.term_p) annotation (points=[-1.22465e-015,20;
          40,20; 40,4; 64,4], style(color=3, rgbcolor={0,0,255}));
    connect(pn_p_n.term_n, resSym.term_n) annotation (points=[-64,-4; -40,-4;
          -40,-20; 1.22465e-015,-20],
                                  style(color=3, rgbcolor={0,0,255}));
    connect(resSym.term_n, p_n_pn.term_n) annotation (points=[1.22465e-015,-20;
          40,-20; 40,-4; 64,-4], style(color=3, rgbcolor={0,0,255}));
    connect(term_p, pn_p_n.term_pn)
      annotation (points=[-100,0; -76,0], style(color=3, rgbcolor={0,0,255}));
    connect(p_n_pn.term_pn, term_n)
      annotation (points=[76,0; 100,0], style(color=3, rgbcolor={0,0,255}));
    connect(resSym.neutral, neutral) annotation (points=[-20,-1.22465e-015; -20,
          -40; 0,-40; 0,-100], style(color=3, rgbcolor={0,0,255}));
  end ResistorSym;

  model CapacitorSym "Symmetrical capacitor with neutral access"
    extends Partials.ImpedBase0;

    parameter SI.Voltage Vstart=0 "start voltage";
    parameter SI.Conductance G=1e-6;
    parameter SI.Capacitance C=1e-6;
    Base.Interfaces.Electric_n neutral "symmetrical point"
      annotation (extent=[-10,-110; 10,-90], rotation=
          -90);
    Nodes.Electric_pn_p_n pn_p_n annotation (extent=[-80,-10; -60,10]);
    Nodes.Electric_pn_p_n p_n_pn annotation (extent=[80,-10; 60,10]);
    ImpedancesSingle.CapacitorSym capSym(final G=G, final C=C, final Vstart=Vstart)
      annotation (extent=[-20,-20; 20,20],rotation=-90);
  protected
    outer System system;
    annotation (defaultComponentName="capSym",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[40, 40]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
</html>
"),   Icon(
        Rectangle(extent=[-50,40; 50,20],  style(
            color=30,
            rgbcolor={215,215,215},
            fillColor=30,
            rgbfillColor={215,215,215})),
        Rectangle(extent=[-50,48; 50,40],   style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-50,20; 50,12], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-50,-20; 50,-40],style(
            color=30,
            rgbcolor={215,215,215},
            fillColor=30,
            rgbfillColor={215,215,215})),
        Rectangle(extent=[-50,-12; 50,-20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-50,-40; 50,-48],
                                          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Line(points=[0,12; 0,-12], style(color=3, rgbcolor={0,0,255})),
        Line(points=[0,0; 20,0; 20,-6], style(color=3, rgbcolor={0,0,255})),
        Line(points=[-80,10; -70,10; -70,70; 70,70; 70,10; 80,10], style(color=3,
              rgbcolor={0,0,255})),
        Line(points=[-80,-10; -70,-10; -70,-70; 70,-70; 70,-10; 80,-10], style(
              color=3, rgbcolor={0,0,255})),
        Line(points=[20,-54; 20,-100; 10,-100], style(color=3, rgbcolor={0,0,
                255})),
        Line(points=[0,70; 0,48],  style(color=3, rgbcolor={0,0,255})),
        Line(points=[0,-48; 0,-70],style(color=3, rgbcolor={0,0,255}))),
      Diagram);

  initial equation
    capSym.cap1.v = capSym.cap2.v;
    if system.steadyIni then
      der(capSym.cap1.v) + der(capSym.cap2.v) = 0;
    end if;

  equation
    connect(pn_p_n.term_p, capSym.term_p) annotation (points=[-64,4; -40,4; -40,
          20; -1.22461e-015,20], style(color=3, rgbcolor={0,0,255}));
    connect(capSym.term_p, p_n_pn.term_p) annotation (points=[-1.22461e-015,20;
          40,20; 40,4; 64,4], style(color=3, rgbcolor={0,0,255}));
    connect(pn_p_n.term_n, capSym.term_n) annotation (points=[-64,-4; -40,-4;
          -40,-20; 1.22461e-015,-20],
                                  style(color=3, rgbcolor={0,0,255}));
    connect(capSym.term_n, p_n_pn.term_n) annotation (points=[1.22461e-015,-20;
          40,-20; 40,-4; 64,-4], style(color=3, rgbcolor={0,0,255}));
    connect(term_p, pn_p_n.term_pn)
      annotation (points=[-100,0; -76,0], style(color=3, rgbcolor={0,0,255}));
    connect(p_n_pn.term_pn, term_n)
      annotation (points=[76,0; 100,0], style(color=3, rgbcolor={0,0,255}));
    connect(capSym.neutral, neutral) annotation (points=[-20,-1.22461e-015; -20,
          -40; 0,-40; 0,-100], style(color=3, rgbcolor={0,0,255}));
  end CapacitorSym;

  model DClink "DC-link with filter circuit"
    extends Partials.ImpedBase0;

    parameter SI.Voltage Vstart=0 "start voltage";
    parameter SI.Resistance Rfilter=1e-3;
    parameter SI.Inductance Lfilter=1e-3;
    parameter SI.Capacitance Cfilter=1e-6;
    parameter SI.Capacitance Cdc=1e-6;
    ImpedancesSingle.Resistor res1(final R=Rfilter)
      annotation (extent=[-40,40; -20,60], rotation=-90);
    ImpedancesSingle.Inductor ind1(final L=Lfilter)
      annotation (extent=[-40,-10; -20,10], rotation=-90);
    ImpedancesSingle.Capacitor cap1(final C=Cfilter)
      annotation (extent=[-40,-60; -20,-40], rotation=-90);
    ImpedancesSingle.Capacitor cap(final C=Cdc, final v(start=Vstart))
      annotation (extent=[20,-10; 40,10], rotation=-90);
    Base.Interfaces.Electric_n grd "ground"
      annotation (extent=[-10,-110; 10,-90], rotation=
          -90);
    Nodes.Electric_pn_p_n pn_p_n annotation (extent=[-80,-10; -60,10]);
    Nodes.Electric_pn_p_n p_n_pn annotation (extent=[80,-10; 60,10]);
  protected
    outer System system;
    annotation (defaultComponentName="dcLink",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[40, 40]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
</html>
"),   Icon(
  Rectangle(extent=[-80,60; 80,-60],   style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})), Text(
          extent=[-80,20; 80,-20],
          style(color=3, rgbcolor={0,0,255}),
          string="DClink")),
      Diagram);

  initial equation
    if system.steadyIni then
      der(cap.v) = 0;
      der(cap1.v) = 0;
    end if;

  equation
    connect(pn_p_n.term_p, res1.term_p) annotation (points=[-64,4; -60,4; -60,
          60; -30,60], style(color=3, rgbcolor={0,0,255}));
    connect(res1.term_n, ind1.term_p)
      annotation (points=[-30,40; -30,10], style(color=3, rgbcolor={0,0,255}));
    connect(ind1.term_n, cap1.term_p) annotation (points=[-30,-10; -30,-40],
        style(color=3, rgbcolor={0,0,255}));
    connect(cap1.term_n, pn_p_n.term_n) annotation (points=[-30,-60; -60,-60;
          -60,-4; -64,-4], style(color=3, rgbcolor={0,0,255}));
    connect(p_n_pn.term_p, cap.term_p)  annotation (points=[64,4; 60,4; 60,10;
          30,10], style(color=3, rgbcolor={0,0,255}));
    connect(p_n_pn.term_n, cap.term_n)  annotation (points=[64,-4; 60,-4; 60,
          -10; 30,-10], style(color=3, rgbcolor={0,0,255}));
    connect(res1.term_p, cap.term_p)  annotation (points=[-30,60; 30,60; 30,10],
        style(color=3, rgbcolor={0,0,255}));
    connect(cap.term_n, cap1.term_n)  annotation (points=[30,-10; 30,-60; -30,
          -60], style(color=3, rgbcolor={0,0,255}));
    connect(cap.term_n, grd)  annotation (points=[30,-10; 30,-60; 0,-60; 0,-100],
        style(color=3, rgbcolor={0,0,255}));
    connect(term_p, pn_p_n.term_pn)
      annotation (points=[-100,0; -76,0], style(color=3, rgbcolor={0,0,255}));
    connect(p_n_pn.term_pn, term_n)
      annotation (points=[76,0; 100,0], style(color=3, rgbcolor={0,0,255}));
  end DClink;

  model DClinkSym "Symmetrical DC-link with filter circuit and neutral access"
    extends Partials.ImpedBase0;

    parameter SI.Voltage Vstart=0 "start voltage";
    parameter SI.Resistance Rfilter=1e-3;
    parameter SI.Inductance Lfilter=1e-3;
    parameter SI.Capacitance Cfilter=1e-6;
    parameter SI.Capacitance Cdc=1e-6;
    ImpedancesSingle.Resistor res1(final R=Rfilter)
      annotation (extent=[-40,40; -20,60], rotation=-90);
    ImpedancesSingle.Inductor ind1(final L=Lfilter)
      annotation (extent=[-40,-10; -20,10], rotation=-90);
    ImpedancesSingle.Capacitor cap1(final C=Cfilter)
      annotation (extent=[-40,-60; -20,-40], rotation=-90);
    ImpedancesSingle.CapacitorSym capSym(final C=Cdc, final Vstart=Vstart)
      annotation (extent=[20,-10; 40,10], rotation=-90);
    Base.Interfaces.Electric_n neutral "symmetrical point"
      annotation (extent=[-10,-110; 10,-90], rotation=
          -90);
    Nodes.Electric_pn_p_n pn_p_n annotation (extent=[-80,-10; -60,10]);
    Nodes.Electric_pn_p_n p_n_pn annotation (extent=[80,-10; 60,10]);
  protected
    outer System system;
    annotation (defaultComponentName="dcLink",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[40, 40]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
</html>
"),   Icon(
  Rectangle(extent=[-80,60; 80,-60],   style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})), Text(
          extent=[-80,40; 80,0],
          style(color=3, rgbcolor={0,0,255}),
          string="DClink"),               Text(
          extent=[-80,0; 80,-40],
          style(color=3, rgbcolor={0,0,255}),
          string="sym")),
      Diagram);

  initial equation
    capSym.cap1.v = capSym.cap2.v;
    if system.steadyIni then
      der(cap1.v) = 0;
    end if;

  equation
    connect(pn_p_n.term_p, res1.term_p) annotation (points=[-64,4; -60,4; -60,
          60; -30,60], style(color=3, rgbcolor={0,0,255}));
    connect(res1.term_n, ind1.term_p)
      annotation (points=[-30,40; -30,10], style(color=3, rgbcolor={0,0,255}));
    connect(ind1.term_n, cap1.term_p) annotation (points=[-30,-10; -30,-40],
        style(color=3, rgbcolor={0,0,255}));
    connect(cap1.term_n, pn_p_n.term_n) annotation (points=[-30,-60; -60,-60;
          -60,-4; -64,-4], style(color=3, rgbcolor={0,0,255}));
    connect(p_n_pn.term_p, capSym.term_p) annotation (points=[64,4; 60,4; 60,10;
          30,10], style(color=3, rgbcolor={0,0,255}));
    connect(p_n_pn.term_n, capSym.term_n) annotation (points=[64,-4; 60,-4; 60,
          -10; 30,-10], style(color=3, rgbcolor={0,0,255}));
    connect(res1.term_p, capSym.term_p) annotation (points=[-30,60; 30,60; 30,10],
               style(color=3, rgbcolor={0,0,255}));
    connect(capSym.term_n, cap1.term_n) annotation (points=[30,-10; 30,-60; -30,
          -60], style(color=3, rgbcolor={0,0,255}));
    connect(capSym.neutral, neutral) annotation (points=[20,-6.12323e-016; 10,
          -6.12323e-016; 10,0; 0,0; 0,-100], style(color=3, rgbcolor={0,0,255}));
    connect(term_p, pn_p_n.term_pn)
      annotation (points=[-100,0; -76,0], style(color=3, rgbcolor={0,0,255}));
    connect(p_n_pn.term_pn, term_n)
      annotation (points=[76,0; 100,0], style(color=3, rgbcolor={0,0,255}));
  end DClinkSym;

  package Partials "Partial models"
    partial model ImpedBase0 "Impedance base 0, 1-phase"

      Base.Interfaces.ElectricV_p term_p(final m=2) "positive terminal"
    annotation (extent=[-110, -10; -90, 10]);
      Base.Interfaces.ElectricV_n term_n(final m=2) "negative terminal"
    annotation (extent=[90, -10; 110, 10]);

    annotation (
      Coordsys(
        extent=
       [-100, -100; 100, 100],
        grid=
     [2, 2],
        component=
          [20, 20]),
      Window(
        x=0.45,
        y=0.01,
        width=
      0.44,
        height=
       0.65),
      Documentation(
            info="<html>
</html>
"),   Icon(
         Text(
        extent=[-100,130; 100,90],
        string="%name",
        style(color=0))),
      Diagram);
    end ImpedBase0;
    extends Base.Icons.Partials;

    partial model ImpedBase "Impedance base, 1-phase"
      extends Ports.Port_pn;
      extends Base.Units.NominalAC;

      SI.Voltage[2] v;
      SI.Current[2] i;

    annotation (
      Coordsys(
        extent=
       [-100, -100; 100, 100],
        grid=
     [2, 2],
        component=
          [20, 20]),
      Window(
        x=0.45,
        y=0.01,
        width=
      0.44,
        height=
       0.65),
      Documentation(
            info="<html>
</html>
"),   Icon,
      Diagram(
          Line(points=[-80,20; -60,20], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
          Line(points=[-80,-20; -60,-20], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
          Line(points=[60,20; 80,20], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
          Line(points=[60,-20; 80,-20], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1))));

    equation
      v = term_p.pin.v - term_n.pin.v;
      i = term_p.pin.i;
    end ImpedBase;

    partial model ImpedBaseHeat "Impedance base with heat port, 1-phase"
      extends ImpedBase;
      extends Base.Interfaces.AddHeat;
      annotation (
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=[
    2, 2],
      component=
        [20, 20]),
    Window(
      x=0.45,
      y=0.01,
      width=
    0.44,
      height=
     0.65),
    Documentation(
          info="<html>
<p>Same as ImpedBase, but contains an additional heat port.</p>
<p>Does not contain mass and specific heat. These parameters are expected to belong to the corresponding thermal model. The heat-flow at the connector is given by the total dissipated electric power of both conductors.</p>
</html>"),
    Icon,
    Diagram);
    end ImpedBaseHeat;

  partial model ImpedNonSymHeat
      "Impedance base non symmetric with heat port, 3-phase abc"
    extends ImpedBase;
    extends Base.Interfaces.AddHeatV(final m_heat=2);

    annotation (
      Coordsys(
      extent=[-100,-100; 100,100],
      grid=[2,2],
      component=
  [20, 20]),
      Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Documentation(
    info="<html>
<p>Same as ImpedBase, but contains an additional vector heat port.</p>
<p>Does not contain mass and specific heat. These parameters are expected to belong to the corresponding thermal model. The heat-flow at the connectors is given by the total dissipated electric power per conductor.</p>
</html>
"),   Icon,
      Diagram);

  equation
    Q_flow = v.*i;
  end ImpedNonSymHeat;

    annotation (
          Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]), Window(
  x=0.05,
  y=0.44,
  width=0.31,
  height=0.23,
  library=1,
  autolayout=1));
  end Partials;

end Impedances;
