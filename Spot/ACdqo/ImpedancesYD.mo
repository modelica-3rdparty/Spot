within Spot.ACdqo;
package ImpedancesYD
  "Impedance and admittance one terminal, Y and Delta topology"
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
<p>Contains lumped impedance models for Y and Delta topology.</p>
<p>General relations see 'Impedances'.</p>
<p>All elements allow the choice between Y- and Delta-topology.<br>
The impedance parameters are defined 'as seen from the terminals', directly relating terminal voltage and terminal current. With this definition same parameters lead to same network properties, independent of topology. The necessary scaling is performed automatically.</p>
<p>In Delta-topology the conductor voltage is sqrt(3) higher, the current sqrt(3) lower,
compared to the terminal voltage and current. Therefore the impedance relating conductor current and voltage is a factor 3 larger, the admittance a factor 1/3 smaller than the impedance and admittance as seen from the terminal.</p>
<p>If impedance parameters are known for the WINDINGS, choose:</p>
<pre>  input values impedance parameters = (winding values of impedance parameters)/3</pre>
<p>In dqo-representation the following relations hold between<br>
terminal-voltage term.v and -current term.i on the one hand<br>
and conductor-voltage v and -current i on the other:</p>
<p><b>Y-topology</b>:</p>
<pre>
  v = term.v - {0, 0, sqrt(3)*v_n}: voltage between terminal and neutral point
  term.i = i
  i_n = sqrt(3)*term.i[3]
</pre>
<p><b>Delta-topology</b>:</p>
<pre>
  v[1:2] = sqrt(3)*R30*term.v[1:2]: voltage between phase-terminals
  v[3] = 0
  term.i[1:2] = sqrt(3)*transpose(R30)*i[1:2]
  term.i[3] = 0
</pre>
<p>with <tt>R30 = rotation_30deg</tt><br>
(Alternative solutions corresponding to permuted phases are <tt>R-90</tt> and <tt>R150</tt> instead of <tt>R30</tt>).</p>
</html>"),
  Icon);
  model Resistor "Resistor, 3-phase dqo"
    extends Partials.ImpedYDBase(final f_nom=0, final stIni_en=false);

    parameter SIpu.Resistance r=1 "resistance";
  protected
    final parameter SI.Resistance R=r*Base.Precalculation.baseR(units, V_nom, S_nom, top.scale);
    annotation (
      defaultComponentName="resYD1",
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
<p>Info see package ACdqo.ImpedancesYD.</p>
</html>
"),
  Icon(Rectangle(extent=[-80,30; 70,-30], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2,
            gradient=0,
            fillColor=7,
            rgbfillColor={255,255,255}))),
  Diagram(
        Rectangle(extent=[-70,20; 30,13], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-70,3; 30,-4], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-70,-13; 30,-20], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255}))));

  equation
    R*i = v;
  end Resistor;

  model Conductor "Conductor, 3-phase dqo"
    extends Partials.ImpedYDBase(final f_nom=0, final stIni_en=false);

    parameter SIpu.Conductance g=1 "conductance";
  protected
    final parameter SI.Conductance G=g/Base.Precalculation.baseR(units, V_nom, S_nom, top.scale);
    annotation (
      defaultComponentName="resYD1",
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
<p>Info see package ACdqo.ImpedancesYD.</p>
</html>"),
  Icon(Rectangle(extent=[-80,30; 70,-30], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2,
            gradient=0,
            fillColor=7,
            rgbfillColor={255,255,255}))),
  Diagram(
        Rectangle(extent=[-70,20; 30,13], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-70,3; 30,-4], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-70,-13; 30,-20], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255}))));

  equation
    G*v = i;
  end Conductor;

  model Inductor "Inductor with series resistor, 3-phase dqo"
    extends Partials.ImpedYDBase;

    parameter SIpu.Resistance r=0 "resistance";
    parameter SIpu.Reactance x_s=1 "self reactance";
    parameter SIpu.Reactance x_m=0 "mutual reactance, -x_s/2 < x_m < x_s";
  protected
    final parameter SI.Resistance[2] RL_base=Base.Precalculation.baseRL(units, V_nom, S_nom, 2*pi*f_nom, top.scale);
    final parameter SI.Resistance R=r*RL_base[1];
    final parameter SI.Inductance L=(x_s-x_m)*RL_base[2];
    final parameter SI.Inductance L0=(x_s+2*x_m)*RL_base[2];
    annotation (
      defaultComponentName="indYD1",
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
<p>Info see package ACdqo.ImpedancesYD.</p>
</html>"),
  Icon(Rectangle(extent=[-80,30; -40,-30], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
          Rectangle(extent=[-40,30; 70,-30], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2,
            fillColor=62,
            rgbfillColor={0,120,120}))),
  Diagram(
        Rectangle(extent=[-50,3; 30,-4], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-70,3; -50,-4],  style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
        Rectangle(extent=[-50,20; 30,13], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-70,20; -50,13], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
        Rectangle(extent=[-50,-13; 30,-20], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-70,-13; -50,-20],
                                           style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-50,9; 30,7],   style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Rectangle(extent=[-50,-8; 30,-10],style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Rectangle(extent=[-50,-23; 30,-25],
                                      style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175}))));

  initial equation
    if steadyIni_t then
      der(i) = omega[1]*j_dqo(i);
    end if;

  equation
    if system.transientSim then
      diagonal({L,L,L0})*der(i) + omega[2]*L*j_dqo(i) + R*i = v;
    else
      omega[2]*L*j_dqo(i) + R*i = v;
    end if;
  end Inductor;

  model Capacitor "Capacitor with parallel conductor, 3-phase dqo"
    extends Partials.ImpedYDBase;

    parameter SIpu.Conductance g=0 "conductance";
    parameter SIpu.Susceptance b=1 "susceptance";
  protected
    final parameter SI.Resistance[2] GC_base=Base.Precalculation.baseGC(units, V_nom, S_nom, 2*pi*f_nom, top.scale);
    final parameter SI.Conductance G=g*GC_base[1];
    final parameter SI.Capacitance C=b*GC_base[2];
    annotation (
      defaultComponentName="capYD1",
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
<p>Info see package ACdqo.ImpedancesYD.</p>
</html>"),
  Icon( Line(points=[-90,0; -20,0], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2)),
        Rectangle(extent=[-12,60; 12,-60], style(
            color=30,
            rgbcolor={215,215,215},
            fillColor=30,
            rgbfillColor={215,215,215})),
        Rectangle(extent=[-20,60; -12,-60], style(
            color=62,
            rgbcolor={0,120,120},
            fillColor=62,
            rgbfillColor={0,120,120})),
        Rectangle(extent=[12,60; 20,-60], style(
            color=62,
            rgbcolor={0,120,120},
            fillColor=62,
            rgbfillColor={0,120,120}))),
  Diagram(
        Line(points=[-70,0; -4,0]),
        Rectangle(extent=[-4,21; -2,11], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[2,21; 4,11], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[-4,5; -2,-5],  style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[2,5; 4,-5],  style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[-4,-11; -2,-21],
                                         style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[2,-11; 4,-21],
                                       style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Line(points=[-70,16; -4,16]),
        Line(points=[-70,-16; -4,-16]),
        Line(points=[4,16; 30,16]),
        Line(points=[4,0; 30,0]),
        Line(points=[4,-16; 30,-16]),
    Rectangle(extent=[-20,10; -10,6], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-20,-6; -10,-10],
                                      style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-20,-22; -10,-26],
                                      style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
        Line(points=[-30,16; -30,8; -20,8], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[-30,0; -30,-8; -20,-8], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[-30,-16; -30,-24; -20,-24], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[-10,8; 20,8; 20,16], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[-10,-8; 20,-8; 20,0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[-10,-24; 20,-24; 20,-16], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1))));

  initial equation
    if steadyIni_t then
      der(v) = omega[1]*j_dqo(v);
    end if;

  equation
    if system.transientSim then
      C*der(v) + omega[2]*C*j_dqo(v) + G*v = i;
    else
      omega[2]*C*j_dqo(v) + G*v = i;
    end if;
  end Capacitor;

  model ResistorNonSym "Resistor non symmetric, 3-phase dqo"
    extends Partials.ImpedYDNonSymBase(final f_nom=0, final stIni_en=false);

    parameter SIpu.Resistance[3] r={1,1,1} "resistance[3] abc";
  protected
    final parameter SI.Resistance[3] R_abc=r*Base.Precalculation.baseR(units, V_nom, S_nom, top.scale);
    SI.Resistance[3, 3] R;
    annotation (
      defaultComponentName="resYDnonSym",
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
<p>More info see package ACdqo.ImpedancesYD.</p>
</html>"),
  Icon(Rectangle(extent=[-80,30; 70,-30], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2,
            gradient=0,
            fillColor=7,
            rgbfillColor={255,255,255})),
          Polygon(
        points=[-80,30; -80,0; -50,30; -80,30], style(
            pattern=0,
            fillColor=9,
            rgbfillColor={175,175,175}))),
  Diagram(
        Rectangle(extent=[-70,20; 30,13], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-70,3; 30,-4], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-70,-13; 30,-20], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255}))));

  equation
    R = Park*diagonal(R_abc)*transpose(Park);
    R*i = v;
  end ResistorNonSym;

  model InductorNonSym
    "Inductor with series resistor non symmetric, 3-phase dqo"
    extends Partials.ImpedYDNonSymBase;

    parameter SIpu.Resistance[3] r={0,0,0} "resistance[3] abc";
    parameter SIpu.Reactance[3, 3] x=[1, 0, 0; 0, 1, 0; 0, 0, 1]
      "reactance[3,3] abc";
    SI.MagneticFlux[3] psi(each stateSelect=StateSelect.prefer) "magnetic flux";
  protected
    final parameter SI.Resistance[2] RL_base=Base.Precalculation.baseRL(units, V_nom, S_nom, 2*pi*f_nom, top.scale);
    final parameter SI.Resistance[3] R_abc=r*RL_base[1];
    final parameter SI.Inductance[3, 3] L_abc=x*RL_base[2];
    SI.Resistance[3, 3] R;
    SI.Inductance[3, 3] L;
    annotation (
      defaultComponentName="indYDnonSym",
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
<p>More info see package ACdqo.ImpedancesYD.</p>
</html>"),
  Icon( Rectangle(extent=[-80,30; -40,-30], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-40,30; 70,-30], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2,
            fillColor=62,
            rgbfillColor={0,120,120})),
    Polygon(points=[-80,30; -80,0; -50,30; -80,30], style(
            pattern=0,
            fillColor=9,
            rgbfillColor={175,175,175}))),
  Diagram(
        Rectangle(extent=[-50,3; 30,-4], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-70,3; -50,-4],  style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
        Rectangle(extent=[-50,20; 30,13], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-70,20; -50,13], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
        Rectangle(extent=[-50,-13; 30,-20], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-70,-13; -50,-20],
                                           style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-50,9; 30,7],   style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Rectangle(extent=[-50,-8; 30,-10],style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Rectangle(extent=[-50,-23; 30,-25],
                                      style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175}))));

  initial equation
    if steadyIni_t then
      der(psi[1:2]) = omega[1]*j_dqo(psi[1:2]);
      psi[3] = 0;
    end if;

  equation
    L = Park*L_abc*transpose(Park);
    R = Park*diagonal(R_abc)*transpose(Park);

    psi = L*i;
    der(psi) + omega[2]*j_dqo(psi) + R*i = v;
  end InductorNonSym;

  model CapacitorNonSym
    "Capacitor with parallel conductor non symmetric, 3-phase dqo"
    extends Partials.ImpedYDNonSymBase;

    parameter SIpu.Conductance[3] g={0,0,0} "conductance[3] abc";
    parameter SIpu.Susceptance[3] b={1,1,1} "susceptance[3] abc";
    SI.ElectricCharge[3] q(each stateSelect=StateSelect.prefer)
      "electric charge";
  protected
    final parameter SI.Resistance[2] GC_base=Base.Precalculation.baseGC(units, V_nom, S_nom, 2*pi*f_nom, top.scale);
    final parameter SI.Conductance[3] G_abc=g*GC_base[1];
    final parameter SI.Capacitance[3] C_abc=b*GC_base[2];
    SI.Conductance[3, 3] G;
    SI.Inductance[3, 3] C;
    annotation (
      defaultComponentName="capYDnonSym",
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
<p> More info see package ACdqo.ImpedancesYD.</p>
</html>
"),
  Icon( Line(points=[-90,0; -20,0], style(
            color=62,
            rgbcolor={0,120,120},
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
            color=62,
            rgbcolor={0,120,120},
            fillColor=62,
            rgbfillColor={0,120,120})),
        Rectangle(extent=[12,60; 20,-60], style(
            color=62,
            rgbcolor={0,120,120},
            fillColor=62,
            rgbfillColor={0,120,120}))),
  Diagram(
        Line(points=[-70,0; -4,0]),
        Rectangle(extent=[-4,21; -2,11], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[2,21; 4,11], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[-4,5; -2,-5],  style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[2,5; 4,-5],  style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[-4,-11; -2,-21],
                                         style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[2,-11; 4,-21],
                                       style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Line(points=[-70,16; -4,16]),
        Line(points=[-70,-16; -4,-16]),
        Line(points=[4,16; 30,16]),
        Line(points=[4,0; 30,0]),
        Line(points=[4,-16; 30,-16]),
    Rectangle(extent=[-20,10; -10,6], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-20,-6; -10,-10],
                                      style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-20,-22; -10,-26],
                                      style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
        Line(points=[-30,16; -30,8; -20,8], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[-30,0; -30,-8; -20,-8], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[-30,-16; -30,-24; -20,-24], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[-10,8; 20,8; 20,16], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[-10,-8; 20,-8; 20,0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[-10,-24; 20,-24; 20,-16], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1))));

  initial equation
    if steadyIni_t then
      der(q[1:2]) = omega[1]*j_dqo(q[1:2]);
      q[3] = 0;
    end if;

  equation
    C = Park*diagonal(C_abc)*transpose(Park);
    G = Park*diagonal(G_abc)*transpose(Park);

    q = C*v;
    der(q) + omega[2]*j_dqo(q) + G*v = i;
  end CapacitorNonSym;

  model Varistor "Varistor, 3-phase dqo"
    extends Partials.ImpedYDNonSymBase(final f_nom=0, final stIni_en=false);

    parameter SIpu.Resistance r0=100 "small voltage resistance";
    parameter SIpu.Voltage v0=1 "saturation voltage";
    SI.Voltage[3] v_abc;
    SI.Current[3] i_abc(start=zeros(3));
  protected
    final parameter Real V0=(v0*Base.Precalculation.baseV(units, V_nom));
    final parameter Real H0=(r0*Base.Precalculation.baseR(units, V_nom, S_nom)/V0);
    annotation (
      defaultComponentName="varistorYD",
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
<p>More info see package ACdqo.ImpedancesYD.</p>
</html>
"),
  Icon(Rectangle(extent=[-80,30; 70,-30], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),                      Line(points=[30,
              25; 26,2; -26,-2; -30,-26], style(color=0))),
  Diagram(
        Rectangle(extent=[-70,20; 30,13],  style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
        Rectangle(extent=[-70,3; 30,-4],   style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
        Rectangle(extent=[-70,-13; 30,-20],style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})), Line(points=[8,22; 6,18; -46,16; -48,12],
            style(color=0)),          Line(points=[8,5; 6,1; -46,-1; -48,-5],
            style(color=0)),          Line(points=[8,-11; 6,-15; -46,-17; -48,
              -21],
            style(color=0))));

  equation
    i_abc = transpose(Park)*i;
    v_abc = V0*tanh(H0*i_abc);
    v = Park*v_abc;
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

    partial model ImpedYDBase "One terminal impedance base, 3-phase dqo"
      extends Ports.YDport_p;
      extends Base.Units.NominalAC;

      parameter Boolean stIni_en=true "enable steady-state initial equation"
                                                                           annotation(evaluate=true);
      parameter SIpu.Resistance r_n=1 "resistance neutral to grd"
        annotation(Dialog(enable));
    protected
      final parameter Boolean steadyIni_t=system.steadyIni_t and stIni_en;
      final parameter SI.Resistance R_n=r_n*Base.Precalculation.baseR(units, V_nom, S_nom);
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
<p>Y-topology: contains an equation for neutral to ground</p>
<p>Delta-topology: <tt>i[3] = 0</tt></p>
</html>"),
        Diagram(Rectangle(extent=[70,20; 76,-20], style(
              color=10,
              fillColor=10,
              fillPattern=1))),
        Icon(Rectangle(extent=[70,30; 80,-30], style(
              color=10,
              rgbcolor={135,135,135},
              thickness=2,
              fillColor=10,
              rgbfillColor={135,135,135}))));

    equation
      omega = der(term.theta);
      v_n = R_n*i_n "equation neutral to ground (if Y-topology)";
    end ImpedYDBase;

    partial model ImpedYDNonSymBase
      "One terminal impedance base non symmetric, 3-phase dqo"
      extends ImpedYDBase;

    protected
      Real[3,3] Park = Base.Transforms.park(term.theta[2]);
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
<p>Same as ImpedYDBase, but contains additionally a Park-transform which is needed for
transformation of general impedance matrices from abc rest to general dqo-system.
(for example when coefficients of non symmetric systems are defined in abc representation.)</p>
</html>"),
        Diagram,
        Icon);

    end ImpedYDNonSymBase;

    partial model ImpedYDHeat
      "One terminal impedance base with heat port, 3-phase dqo"
      extends ImpedYDBase;
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
<p>Same as ImpedYDBase, but contains an additional heat port.</p>
<p>Does not contain mass and specific heat. These parameters are expected to belong to the corresponding thermal model. The heat-flow at the connector is given by the total dissipated electric energy of all conductors (not included neutral-to-ground!).</p>
</html>
"),     Diagram,
        Icon);

    equation
      Q_flow = v*i;
    end ImpedYDHeat;

    partial model ImpedYDNonSymHeat
      "One terminal impedance base non symmetric with heat port, 3-phase dqo"
      extends ImpedYDNonSymBase;
      extends Base.Interfaces.AddHeatV(final m_heat=3);

      SI.Voltage[3] v_abc=Park*top.v_cond;
      SI.Current[3] i_abc=Park*top.i_cond;
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
<p>Same as ImpedYDNonSymBase, but contains an additional vector heat port.</p>
<p>Does not contain mass and specific heat. These parameters are expected to belong to the corresponding thermal model. The heat-flow at the connectors is given by the dissipated electric power per conductor (not included neutral-to-ground!).</p>
</html>"),
        Diagram,
        Icon);

    equation
      Q_flow = v_abc.*i_abc;
    end ImpedYDNonSymHeat;
  end Partials;

end ImpedancesYD;
