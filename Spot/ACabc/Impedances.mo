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
height=0.44,
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
<p>A) <b>Symmetric systems</b>.</p>
<p>The reactance-matrix in abc-representation is</p>
<pre>
          [x_s, x_m, x_m
  x_abc =  x_m, x_s, x_m
           x_m, x_m, x_s]
</pre>
<p>and corresponds to the following diagonal matrix in dqo-representation</p>
<pre>
          [x, 0, 0
  x_dqo =  0, x, 0
           0, 0, x0]
</pre>
<p>with the relations</p>
<pre>
  x   = x_s - x_m           stray reactance (dq-components)
  x0  = x_s + 2*x_m         zero-reactance (o-component)
  x_s =  (2*x + x0)/3       self reactance single conductor
  x_m = -(x - x0)/3         mutual reactance
</pre>
<p>Coupling.</p>
<pre>
  -x_s/2 &lt  x_m &lt  x_s
  uncoupled limit:          x_m = 0,               x0 = x
  fully positive coupled:   x_m = x_s,             x0 = 3*x_s
  fully negative coupled:   x_m = -x_s/2,          x0 = 0
  'practical' value:        x_m = -x_s*(2/13),     x0 = (3/5)*x
</pre>
<p>The corresponding resistance matrix is</p>
<pre>
                  [r, 0, 0
  r_abc = r_dqo =  0, r, 0
                   0, 0, r]
</pre>
<p>The susceptance matrices in abc- and in dqo-representation are</p>
<pre>
          [ b_pg + 2b_pp, -b_pp,         -b_pp
  b_abc =  -b_pp,          b_pg + 2b_pp, -b_pp
           -b_pp,         -b_pp,          b_pg + 2b_pp]
          [ b_pg + 3*b_pp, 0,             0
  b_dqo =   0,             b_pg + 3*b_pp, 0
            0,             0,             b_pg]
</pre>
<p>where <tt>_pg</tt> denotes 'phase-to-ground' and <tt>_pp</tt> 'phase-to-phase'.</p>
<p>The corresponding conduction matrices are (in analogy to susceptance)</p>
<pre>
          [ g_pg + 2g_pp, -g_pp,         -g_pp
  g_abc =  -g_pp,          g_pg + 2g_pp, -g_pp
           -g_pp,         -g_pp,          g_pg + 2g_pp]
          [ g_pg + 3*g_pp, 0,             0
  g_dqo =   0,             g_pg + 3*g_pp, 0
            0,             0,             g_pg]
</pre>
<p>B) <b>Non symmetric systems</b>.</p>
<p><tt>&nbsp; x_abc</tt> is an arbitrary symmetric matrix with positive diagonal elements</p>
<p><tt>&nbsp; r_abc</tt> is an arbitrary diagonal matrix with positive elements</p>
<p><tt>&nbsp; b_abc</tt> (phase-to-ground) is an arbitrary diagonal matrix with positive elements</p>
<p><tt>&nbsp; b_abc</tt> (phase-to-phase) is of the form</p>
<pre>
          [b_pp[2] + b_pp[3], -b_pp[3],           -b_pp[2]
  b_abc = -b_pp[3],            b_pp[3] + b_pp[1], -b_pp[1]
          -b_pp[2],           -b_pp[1],            b_pp[1] + b_pp[2]]
</pre>
<p><tt>&nbsp; g_abc(phase-to-ground)</tt> is an arbitrary diagonal matrix with positive elements</p>
<p><tt>&nbsp; g_abc(phase-to-phase)</tt> is of the form</p>
<pre>
          [g_pp[2] + g_pp[3], -g_pp[3],           -g_pp[2]
  g_abc = -g_pp[3],            g_pp[3] + g_pp[1], -g_pp[1]
          -g_pp[2],           -g_pp[1],            g_pp[1] + g_pp[2]]
</pre>
<p>where</p>
<pre>
  index 1 denotes pair 2-3
  index 2 denotes pair 3-1
  index 3 denotes pair 1-2
</pre>
<p>The corresponding dqo-matrices are all obtained by Park-transformation P</p>
<pre>
  x_dqo = P*x_abc*transpose(P)
  r_dqo = P*r_abc*transpose(P)
  b_dqo = P*b_abc*transpose(P)
  g_dqo = P*g_abc*transpose(P)
</pre>
</html>"),
  Icon);

  model Resistor "Resistor, 3-phase abc"
    extends Partials.ImpedBase(final f_nom=0, final stIni_en=false);

    parameter SIpu.Resistance r=1 "resistance";
  protected
    final parameter SI.Resistance R=r*Base.Precalculation.baseR(units, V_nom, S_nom);
    annotation (
      defaultComponentName="res1",
  Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]),
  Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
  Documentation(
          info="<html>
<p>Info see package ACabc.Impedances.</p>
</html>"),
  Icon(Rectangle(extent=[-80,30; 80,-30], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255}))),
  Diagram(
        Rectangle(extent=[-60,10; 60,-10], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
        Rectangle(extent=[-60,60; 60,40], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
        Rectangle(extent=[-60,-40; 60,-60], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255}))));

  equation
    R*i = v;
  end Resistor;

  model Conductor "Conductor, 3-phase abc"
    extends Partials.ImpedBase(final f_nom=0, final stIni_en=false);

    parameter SIpu.Conductance g=1 "conductance";
  protected
    final parameter SI.Conductance G=g/Base.Precalculation.baseR(units, V_nom, S_nom);
    annotation (
      defaultComponentName="cond1",
  Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]),
  Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
  Documentation(
          info="<html>
<p>Info see package ACabc.Impedances.</p>
</html>"),
  Icon(Rectangle(extent=[-80,30; 80,-30], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255}))),
  Diagram(
        Rectangle(extent=[-60,10; 60,-10], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
        Rectangle(extent=[-60,60; 60,40], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
        Rectangle(extent=[-60,-40; 60,-60], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255}))));

  equation
    G*v = i;
  end Conductor;

  model Inductor "Inductor with series resistor, 3-phase abc"
    extends Partials.ImpedBase;

    parameter SIpu.Resistance r=0 "resistance";
    parameter SIpu.Reactance x_s=1 "self reactance";
    parameter SIpu.Reactance x_m=0 "mutual reactance, -x_s/2 < x_m < x_s";
  protected
    final parameter SI.Resistance[2] RL_base=Base.Precalculation.baseRL(units, V_nom, S_nom, 2*pi*f_nom);
    final parameter SI.Resistance R=r*RL_base[1];
    final parameter SI.Inductance[3,3] L=[x_s,x_m,x_m;x_m,x_s,x_m;x_m,x_m,x_s]*RL_base[2];
    annotation (
      defaultComponentName="ind1",
  Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]),
  Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
  Documentation(
          info="<html>
<p>Info see package ACabc.Impedances.</p>
</html>"),
  Icon(Rectangle(extent=[-80,30; -40,-30], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
          Rectangle(extent=[-40,30; 80,-30], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2,
            fillColor=70,
            rgbfillColor={0,130,175}))),
  Diagram(
        Rectangle(extent=[-60,60; -40,40], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,60; 60,40], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Rectangle(extent=[-60,10; -40,-10], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,10; 60,-10], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Rectangle(extent=[-60,-40; -40,-60], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,-40; 60,-60], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-40,30; 60,20], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Rectangle(extent=[-40,-20; 60,-30], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175},
        fillPattern=1)),
    Rectangle(extent=[-40,-70; 60,-80],
                                      style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175}))));

  initial equation
    if steadyIni_t then
      der(i) = omega[1]*j_abc(i);
    end if;

  equation
    if system.transientSim then
      L*der(i) + omega[2]*L*j_abc(i) + R*i = v;
    else
      omega[2]*L*j_abc(i) + R*i = v;
    end if;
  end Inductor;

  model Capacitor "Capacitor with parallel conductor, 3-phase abc"
    extends Partials.ImpedBase;

    parameter SIpu.Conductance g=0 "conductance";
    parameter SIpu.Susceptance b=1 "susceptance";
  protected
    final parameter SI.Resistance[2] GC_base=Base.Precalculation.baseGC(units, V_nom, S_nom, 2*pi*f_nom);
    final parameter SI.Conductance G=g*GC_base[1];
    final parameter SI.Capacitance C=b*GC_base[2];
    annotation (
      defaultComponentName="cap1",
  Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]),
  Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
  Documentation(
          info="<html>
<p>No phase to phase capacitance.</p>
<p>Info see package ACabc.Impedances.</p>
</html>"),
  Icon( Line(points=[-90,0; -20,0], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2)),
        Line(points=[90,0; 20,0], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2)),
        Rectangle(extent=[-12,60; 12,-60], style(
            color=30,
            rgbcolor={215,215,215},
            fillColor=30,
            rgbfillColor={215,215,215})),
        Rectangle(extent=[-20,60; -12,-60], style(
            color=70,
            rgbcolor={0,130,175},
            fillColor=70,
            rgbfillColor={0,130,175})),
        Rectangle(extent=[12,60; 20,-60], style(
            color=70,
            rgbcolor={0,130,175},
            fillColor=70,
            rgbfillColor={0,130,175}))),
  Diagram(
        Rectangle(extent=[-4,70; -2,50], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[2,70; 4,50], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[-4,20; -2,0], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[2,20; 4,0], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[-4,-30; -2,-50], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[2,-30; 4,-50], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
    Rectangle(extent=[-10,44; 10,36], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-10,-6; 10,-14], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-10,-56; 10,-64], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-4,60; -60,60; -60,40; -10,40], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-4,10; -60,10; -60,-10; -10,-10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-4,-40; -60,-40; -60,-60; -10,-60], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[4,60; 60,60; 60,40; 10,40], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[4,10; 60,10; 60,-10; 10,-10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[4,-40; 60,-40; 60,-60; 10,-60], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1))));

  initial equation
    if steadyIni_t then
      der(v) = omega[1]*j_abc(v);
    end if;

  equation
    if system.transientSim then
      C*der(v) + omega[2]*C*j_abc(v) + G*v = i;
    else
      omega[2]*C*j_abc(v) + G*v = i;
    end if;
  end Capacitor;

  model Impedance "Impedance (inductive) with series resistor, 3-phase abc"
    extends Partials.ImpedBase;

    parameter SIpu.Impedance z_abs=1 "abs value of impedance";
    parameter Real cos_phi(min=0,max=1)=0.1 "cos-phi of impedance";
    parameter Real cpl(min=-0.5,max=1)=0
      "phase coupling x_m/x_s, -1/2 < cpl < 1";
  protected
    final parameter SI.Resistance[2] RL_base=Base.Precalculation.baseRL(units, V_nom, S_nom, 2*pi*f_nom);
    function acos = Modelica.Math.acos;
    final parameter SI.Resistance R=z_abs*cos_phi*RL_base[1];
    final parameter SI.Inductance[3,3] L=[1,cpl,cpl;cpl,1,cpl;cpl,cpl,1]*z_abs*sin(acos(cos_phi))*RL_base[2]/(1-cpl);
    annotation (
      defaultComponentName="impedance1",
  Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]),
  Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
  Documentation(
          info="<html>
<p>This model corresponds to ACabc.Inductor, but uses a different determination of the coefficients.<br>
Instead of x_s, x_m, and r the parameters z_abs, cos(phi), and x_o are used.</p>
<p>Relations:</p>
<pre>
  z = Z / R_base
  z_abs = |z|
  r = real(z) = |z|*cos(phi)           resistance
  x = imag(z) = |z|*sin(phi)           inductance dq-components
</pre>
<p>With</p>
<pre>  cpl = x_m/x_s, -1/2 &lt;  cpl &lt;  1      coupling coefficient</pre>
<p>we have</p>
<pre>  x0 = x*(1 + 2*cpl)/(1 - cpl)         inductance o-component</pre>
<p>and</p>
<pre>
  x_s = (2*x + x0)/3 = x/(1 - cpl)     self inductance
  x_m = -(x - x0)/3 = x*cpl/(1 - cpl)  mutual inductance
</pre>
<p>Coupling:</p>
<pre>
  cpl = x_m/x_s     coupling coefficient, -1/2 &lt;  cpl &lt;  1
  cpl &gt;  0        positive coupling (example lines)
  cpl &lt;  0        negative coupling (example machine windings)
  cpl = (x0/x - 1)/(x0/x + 2)
</pre>
<p>More info see package ACabc.Impedances.</p>
</html>
"),
  Icon(Rectangle(extent=[-80,30; -20,-30], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),                      Polygon(points=[
              -80,-30; 80,-30; 80,30; -20,30; -80,-30], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2,
            fillColor=70,
            rgbfillColor={0,130,175}))),
  Diagram(
        Rectangle(extent=[-60,60; -40,40], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,60; 60,40], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Rectangle(extent=[-60,10; -40,-10], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,10; 60,-10], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Rectangle(extent=[-60,-40; -40,-60], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,-40; 60,-60], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-40,30; 60,20], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Rectangle(extent=[-40,-20; 60,-30], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175},
        fillPattern=1)),
    Rectangle(extent=[-40,-70; 60,-80],
                                      style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175}))));

  initial equation
    if steadyIni_t then
      der(i) = omega[1]*j_abc(i);
    end if;

  equation
    if system.transientSim then
      L*der(i) + omega[2]*L*j_abc(i) + R*i = v;
    else
      omega[2]*L*j_abc(i) + R*i = v;
    end if;
  end Impedance;

  model Admittance
    "Admittance (capacitive) with parallel conductor, 3-phase abc"
    extends Partials.ImpedBase;

    parameter SIpu.Admittance y_abs=1 "abs value of admittance";
    parameter Real cos_phi(min=0,max=1)=0.1 "cos-phi of admittance";
  protected
    final parameter SI.Resistance[2] GC_base=Base.Precalculation.baseGC(units, V_nom, S_nom, 2*pi*f_nom);
    function acos = Modelica.Math.acos;
    final parameter SI.Conductance G=y_abs*cos_phi*GC_base[1];
    final parameter SI.Capacitance C=y_abs*sin(acos(cos_phi))*GC_base[2];
    annotation (
      defaultComponentName="admittance1",
  Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]),
  Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
  Documentation(
          info="<html>
<p>This model corresponds to ACabc.Capacitor, but uses a different determination of the coefficients.<br>
Instead of b and g the parameters y_abs and cos(phi) are used.</p>
<p>Relations:</p>
<pre>
  y = Y / G_base
  y_abs = |y|
  g = real(y) = |y|*cos(phi)     conductance
  b = imag(y) = |y|*sin(phi)     admittance dqo-components
</pre>
<p>No phase to phase capacitance.</p>
<p>More info see package ACabc.Impedances.</p>
</html>
"),
  Icon( Line(points=[-90,0; -20,0], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2)),
        Line(points=[90,0; 20,0], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2)),
        Rectangle(extent=[-12,60; 12,-60], style(
            color=30,
            rgbcolor={215,215,215},
            fillColor=30,
            rgbfillColor={215,215,215})),
       Polygon(points=[-12,60; 12,60; -12,-60; -12,60], style(
            pattern=0,
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
        Rectangle(extent=[-20,60; -12,-60], style(
            color=70,
            rgbcolor={0,130,175},
            fillColor=70,
            rgbfillColor={0,130,175})),
        Rectangle(extent=[12,60; 20,-60], style(
            color=70,
            rgbcolor={0,130,175},
            fillColor=70,
            rgbfillColor={0,130,175}))),
  Diagram(
        Rectangle(extent=[-4,70; -2,50], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[2,70; 4,50],   style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[-4,20; -2,0], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[2,20; 4,0],   style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[-4,-30; -2,-50], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[2,-30; 4,-50],   style(
  color=3,
  fillColor=3,
  fillPattern=1)),
    Rectangle(extent=[-10,44; 10,36],style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-10,-6; 10,-14],style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-10,-56; 10,-64],style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-4,60; -60,60; -60,40; -10,40],
                                              style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-4,10; -60,10; -60,-10; -10,-10],
                                                style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-4,-40; -60,-40; -60,-60; -10,-60],
                                                  style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[4,60; 60,60; 60,40; 10,40],  style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[4,10; 60,10; 60,-10; 10,-10],  style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[4,-40; 60,-40; 60,-60; 10,-60],  style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1))));

  initial equation
    if steadyIni_t then
      der(v) = omega[1]*j_abc(v);
    end if;

  equation

    if system.transientSim then
      C*der(v) + omega[2]*C*j_abc(v) + G*v = i;
    else
      omega[2]*C*j_abc(v) + G*v = i;
    end if;
  end Admittance;

  model ResistorNonSym "Resistor non symmetric, 3-phase abc"
    extends Partials.ImpedNonSymBase(final f_nom=0, final stIni_en=false);

    parameter SIpu.Resistance[3] r={1,1,1} "resistance[3] abc";
  protected
    final parameter SI.Resistance[3] R_abc=r*Base.Precalculation.baseR(units, V_nom, S_nom);
    SI.Resistance[3, 3] R;
    annotation (
      defaultComponentName="resNonSym",
  Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]),
  Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
  Documentation(
          info="<html>
<p>Resistor with general resistance matrix, defined in abc inertial system.<br>
Use only if 'non symmetric' is really desired because this component needs a time dependent transform of the coefficient matrix.</p>
<p>More info see package ACabc.Impedances.</p>
</html>"),
  Icon(Rectangle(extent=[-80,30; 80,-30], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),                               Polygon(
        points=[-80,30; -80,0; -50,30; -80,30], style(
            pattern=0,
            fillColor=9,
            rgbfillColor={175,175,175}))),
  Diagram(
        Rectangle(extent=[-60,10; 60,-10], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
        Rectangle(extent=[-60,60; 60,40], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
        Rectangle(extent=[-60,-40; 60,-60], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255}))));

  equation
    R = transpose(Rot)*diagonal(R_abc)*Rot;
    R*i = v;
  end ResistorNonSym;

  model InductorNonSym
    "Inductor with series resistor non symmetric, 3-phase abc"
    extends Partials.ImpedNonSymBase;

    parameter SIpu.Resistance[3] r={0,0,0} "resistance[3] abc";
    parameter SIpu.Reactance[3, 3] x=[1, 0, 0; 0, 1, 0; 0, 0, 1]
      "reactance[3,3] abc";
    SI.MagneticFlux[3] psi(each stateSelect=StateSelect.prefer) "magnetic flux";
  protected
    final parameter SI.Resistance[2] RL_base=Base.Precalculation.baseRL(units, V_nom, S_nom, 2*pi*f_nom);
    final parameter SI.Resistance[3] R_abc=r*RL_base[1];
    final parameter SI.Inductance[3, 3] L_abc=x*RL_base[2];
    SI.Resistance[3, 3] R;
    SI.Inductance[3, 3] L;
    annotation (
      defaultComponentName="indNonSym",
  Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]),
  Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
  Documentation(
          info="<html>
<p>Inductor with general reactance matrix, defined in abc inertial system.<br>
Use only if 'non symmetric' is really desired because this component needs a time dependent transform of the coefficient matrix.</p>
<p>More info see package ACabc.Impedances.</p>
</html>"),
  Icon( Rectangle(extent=[-80,30; -40,-30], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-40,30; 80,-30], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2,
            fillColor=70,
            rgbfillColor={0,130,175})),
    Polygon(points=[-80,30; -80,0; -50,30; -80,30], style(
            pattern=0,
            fillColor=9,
            rgbfillColor={175,175,175}))),
  Diagram(
        Rectangle(extent=[-60,60; -40,40], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,60; 60,40], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Rectangle(extent=[-60,10; -40,-10], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,10; 60,-10], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Rectangle(extent=[-60,-40; -40,-60], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,-40; 60,-60], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-40,30; 60,20], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Rectangle(extent=[-40,-20; 60,-30], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175},
        fillPattern=1)),
    Rectangle(extent=[-40,-70; 60,-80], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175},
        fillPattern=1))));

  initial equation
    if steadyIni_t then
      der(psi) = omega[1]*j_abc(psi);
    end if;

  equation
    L = transpose(Rot)*L_abc*Rot;
    R = transpose(Rot)*diagonal(R_abc)*Rot;

    psi = L*i;
    der(psi) + omega[2]*j_abc(psi) + R*i = v;
  end InductorNonSym;

  model CapacitorNonSym
    "Capacitor with parallel conductor non symmetric, 3-phase abc"
    extends Partials.ImpedNonSymBase;

    parameter SIpu.Conductance[3] g={0,0,0} "conductance[3] abc";
    parameter SIpu.Susceptance[3] b={1,1,1} "susceptance[3] abc";
    SI.ElectricCharge[3] q(each stateSelect=StateSelect.prefer)
      "electric charge";
  protected
    final parameter SI.Resistance[2] GC_base=Base.Precalculation.baseGC(units, V_nom, S_nom, 2*pi*f_nom);
    final parameter SI.Conductance[3] G_abc=g*GC_base[1];
    final parameter SI.Capacitance[3] C_abc=b*GC_base[2];
    SI.Conductance[3, 3] G;
    SI.Inductance[3, 3] C;
    annotation (
      defaultComponentName="capNonSym",
  Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]),
  Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
  Documentation(
          info="<html>
<p>Capacitor with general susceptance matrix, defined in abc inertial system.<br>
Use only if 'non symmetric' is really desired because this component needs a time dependent transform of the coefficient matrix.</p>
<p>No phase to phase capacitance.</p>
</p>More info see package ACabc.Impedances.</p>
</html>"),
  Icon( Line(points=[-90,0; -20,0], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2)),
        Line(points=[90,0; 20,0], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2)),
        Rectangle(extent=[-12,60; 12,-60], style(
            color=30,
            rgbcolor={215,215,215},
            fillColor=30,
            rgbfillColor={215,215,215})),
    Polygon(points=[-12,60; -12,30; 12,60; -12,60], style(
            pattern=0,
            fillColor=9,
            rgbfillColor={175,175,175})),
        Rectangle(extent=[-20,60; -12,-60], style(
            color=70,
            rgbcolor={0,130,175},
            fillColor=70,
            rgbfillColor={0,130,175})),
        Rectangle(extent=[12,60; 20,-60], style(
            color=70,
            rgbcolor={0,130,175},
            fillColor=70,
            rgbfillColor={0,130,175}))),
  Diagram(
        Rectangle(extent=[-4,70; -2,50], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[2,70; 4,50], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[-4,20; -2,0], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[2,20; 4,0], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[-4,-30; -2,-50], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[2,-30; 4,-50], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
    Rectangle(extent=[-10,44; 10,36], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-10,-6; 10,-14], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-10,-56; 10,-64], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-4,60; -60,60; -60,40; -10,40], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-4,10; -60,10; -60,-10; -10,-10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-4,-40; -60,-40; -60,-60; -10,-60], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[4,60; 60,60; 60,40; 10,40], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[4,10; 60,10; 60,-10; 10,-10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[4,-40; 60,-40; 60,-60; 10,-60], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1))));

  initial equation
    if steadyIni_t then
      der(q) = omega[1]*j_abc(q);
    end if;

  equation
    C = transpose(Rot)*diagonal(C_abc)*Rot;
    G = transpose(Rot)*diagonal(G_abc)*Rot;
    q = C*v;
    der(q) + omega[2]*j_abc(q) + G*v = i;
  end CapacitorNonSym;

  model Varistor "Varistor, 3-phase abc"
    extends Partials.ImpedBase(final f_nom=0, final stIni_en=false);

    parameter SIpu.Resistance r0=100 "small voltage resistance";
    parameter SIpu.Voltage v0=1 "saturation voltage";
  protected
    final parameter Real V0=(v0*Base.Precalculation.baseV(units, V_nom));
    final parameter Real H0=(r0*Base.Precalculation.baseR(units, V_nom, S_nom)/V0);
    annotation (
      defaultComponentName="varistor",
  Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[40,40]),
  Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
  Documentation(
          info="<html>
<p>Voltage limiter with hyperbolic tangent characteristic.</p>
<p>More info see package ACabc.Impedances.</p>
</html>
"),
  Icon(Rectangle(extent=[-80,30; 80,-30], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),                      Line(points=[30,
              25; 26,2; -26,-2; -30,-26], style(color=0))),
  Diagram(
        Rectangle(extent=[-60,10; 60,-10], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
        Rectangle(extent=[-60,60; 60,40], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
        Rectangle(extent=[-60,-40; 60,-60], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
        Line(points=[28,10; 26,2; -26,-2; -28,-10], style(color=0)),
        Line(points=[28,60; 26,52; -26,48; -28,40], style(color=0)),
        Line(points=[28,-40; 26,-48; -26,-52; -28,-60], style(color=0))));

  equation
    v = V0*tanh(H0*i);
  end Varistor;

  package Partials "Partial models"
    extends Base.Icons.Partials;
    annotation (
      Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]), Window(
        x=0.05,
        y=0.44,
        width=0.31,
        height=0.23,
        library=1,
        autolayout=1));

    partial model ImpedBase "Impedance base, 3-phase abc"
      extends Ports.Port_pn;
      extends Base.Units.NominalAC;

      parameter Boolean stIni_en=true "enable steady-state initial equation"
                                                                           annotation(evaluate=true);
      SI.Voltage[3] v;
      SI.Current[3] i;
    protected
      final parameter Boolean steadyIni_t=system.steadyIni_t and stIni_en;
      SI.AngularFrequency[2] omega;
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
</html>
"),     Icon,
        Diagram(
    Line(points=[-80,50; -60,50], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[-80,0; -60,0], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[-80,-50; -60,-50], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[60,50; 80,50], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[60,0; 80,0], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[60,-50; 80,-50], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1))));

    equation
      omega = der(term_p.theta);
      v = term_p.v - term_n.v;
      i = term_p.i;
    end ImpedBase;

    partial model ImpedNonSymBase "Impedance base non symmetric, 3-phase abc"
      extends ImpedBase;

    protected
      Real[3,3] Rot = Base.Transforms.rotation_abc(term_p.theta[2]);

      annotation (
        Coordsys(
          extent=[-100,-100; 100,100],
          grid=[2,2],
          component=[20,20]),
        Window(
          x=0.45,
          y=0.01,
          width=0.44,
          height=0.65),
        Documentation(
    info="<html>
<p>Same as ImpedBase, but contains additionally a rotation-transform which is needed for
transformation of general impedance matrices from abc rest- to rotating abc-system.</p>
</html>"),
        Icon,
        Diagram);
    end ImpedNonSymBase;

    partial model ImpedHeat "Impedance base with heat port, 3-phase abc"
      extends ImpedBase;
      extends Base.Interfaces.AddHeat;
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
<p>Same as ImpedBase, but contains an additional heat port.</p>
<p>Does not contain mass and specific heat. These parameters are expected to belong to the corresponding thermal model. The heat-flow at the connector is given by the total dissipated electric energy of all conductors.</p>
</html>
"),     Icon,
        Diagram);

    equation
      Q_flow = v*i;
    end ImpedHeat;

    partial model ImpedNonSymHeat
      "Impedance base non symmetric with heat port, 3-phase abc"
      extends ImpedNonSymBase;
      extends Base.Interfaces.AddHeatV(final m_heat=3);

      SI.Voltage[3] v_abc=transpose(Rot)*v;
      SI.Current[3] i_abc=transpose(Rot)*i;

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
<p>Same as ImpedNonSymBase, but contains an additional vector heat port.</p>
<p>Does not contain mass and specific heat. These parameters are expected to belong to the corresponding thermal model. The heat-flow at the connectors is given by the dissipated electric power per conductor.</p>
</html>
"),     Icon,
        Diagram);

    equation
      Q_flow = v_abc.*i_abc;
    end ImpedNonSymHeat;
  end Partials;

end Impedances;
