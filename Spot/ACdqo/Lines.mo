package Lines "Transmission lines 3-phase"
  extends Base.Icons.Library;
  import Spot.Base.Transforms.jj_dqo;

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
<p>Contains different types of transmission line models.<br>
Faulted transmission lines contain a third terminal for connection to a fault-component.</p>
<p> The relations between line reactance (<tt>x,x0</tt>) and self- and mutual reactance (<tt>x_s,x_m</tt>) are</p>
<pre>
  x   = x_s - x_m,          reactance dq (stray reactance)
  x0  = x_s + 2*x_m,        reactance o (zero-component reactance)
  x_s =  (2*x + x0)/3       self reactance single conductor
  x_m = -(x - x0)/3         mutual reactance
</pre>
<p>Coupling:</p>
<pre>
  cpl = x_m/x_s &gt  0,        positive for lines
</pre>
<p>More info see package ACdqoImpedances.</p>
</html>"),
  Icon,
  Diagram);

  model RXline0 "RX line without length parameter, 3-phase dqo"
    extends Impedances.Partials.ImpedBase;

    parameter SIpu.Resistance r=0.01 "resistance";
    parameter SIpu.Reactance x=0.1 "reactance";
    parameter SIpu.Reactance x0=3*x "reactance zero-comp";
  protected
    final parameter SI.Resistance[2] RL_base=Base.Precalculation.baseRL(units, V_nom, S_nom, 2*pi*f_nom);
    final parameter SI.Resistance R=r*RL_base[1];
    final parameter SI.Inductance L=x*RL_base[2];
    final parameter SI.Inductance L0=x0*RL_base[2];
  annotation (
    defaultComponentName="RXline0_1",
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
<p>This component contains the same equations as 'Impedances.Inductor', but it is specified using the parameters x and x0 instead of xs and xm (see info package 'Impedances'), similar to 'RXline'. It does not contain the length parameter 'len'. Together with 'Sources.InfBus' it may be used to model a network specified by voltage and impedance values.</p>
</html>"),
      Icon(Rectangle(extent=[-80,30; -40,-30], style(
          color=62,
          rgbcolor={0,120,120},
          thickness=2,
          fillColor=7,
          rgbfillColor={255,255,255})),
        Rectangle(extent=[-40,30; 80,-30], style(
          color=62,
          rgbcolor={0,120,120},
          thickness=2,
          fillColor=62,
          rgbfillColor={0,120,120}))),
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
      der(i) = omega[1]*j_dqo(i);
    end if;

  equation
    if system.transientSim then
      diagonal({L,L,L0})*der(i) + omega[2]*L*j_dqo(i) + R*i = v;
    else
      omega[2]*L*j_dqo(i) + R*i = v;
    end if;
  end RXline0;

  model RXline "RX transmission line, 3-phase dqo"
    extends Ports.Port_pn;
    extends Partials.RXlineBase(final ne=1);

    SI.Voltage[3] v;
    SI.Current[3] i;
  protected
    SI.AngularFrequency[2] omega;
    annotation (
      defaultComponentName="RXline1",
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
<p>Transmission line modelled as concentrated RX-impedance.</p>
</html>
"),
  Icon(Rectangle(extent=[-80,30; -40,-30], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
          Rectangle(extent=[-40,30; 80,-30], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2,
            fillColor=62,
            rgbfillColor={0,120,120}))),
  Diagram(
    Line(points=[-80,35; -60,35], style(
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
    Line(points=[-80,-35; -60,-35], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Rectangle(extent=[-60,40; -40,30], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,40; 60,30],  style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-40,20; 60,16],  style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
        Rectangle(extent=[-60,6; -40,-5], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,6; 60,-5],  style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Rectangle(extent=[-60,-30; -40,-40], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,-30; 60,-40],  style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-40,-16; 60,-20],  style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Rectangle(extent=[-40,-49; 60,-53],style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Line(points=[60,35; 80,35],   style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[60,0; 80,0],   style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[60,-35; 80,-35],   style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1))));

  initial equation
    if steadyIni_t then
      der(i) = omega[1]*j_dqo(i);
    end if;

  equation
    omega = der(term_p.theta);
    v = term_p.v - term_n.v;
    i = term_p.i;

    if system.transientSim then
      diagonal({L,L,L0})*der(i) + omega[2]*L*j_dqo(i) + R*i = v;
    else
      omega[2]*L*j_dqo(i) + R*i = v;
    end if;
  end RXline;

  model PIline "PI transmission line, 3-phase dqo"
    extends Ports.Port_p_n;
    extends Partials.PIlineBase;

    SI.Voltage[3,ne] v;
    SI.Current[3,ne1] i;
  protected
    final parameter Integer ne1=ne + 1;
    SI.AngularFrequency[2] omega;
    annotation (
      defaultComponentName="PIline1",
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
<p>Transmission line modelled as discretised telegraph-equation, 'pi-elements'.</p>
<p>The line of total length <tt>len</tt> is divided into elements of length <tt>delta = len/n</tt>.
It is composed of <tt>n-1</tt> interior elements of length <tt>delta</tt> and at each end of a half-element of length <tt>delta/2</tt>. Therefore it contains <tt>n</tt> interior nodes. Each element corresponds to a series resistor-inductor with values R and L corresponding to its length. A shunt parallel capacitor-conductor is linked to each node.<br>
The minimum of n is 1.</p>
<p>This kind of discretisation is slightly more complicated than the division of the line into n identical elements, but it results in a symmetric model with respect to interchanging positive and negative terminal.
The set of equations of two series connected lines of length len1 and len2 is identical to the set of equations for one line of length len1 + len2 if delta1 = delta2. Otherwise differences occur from the different discretisation length.</p>
</html>"),
  Icon(
    Rectangle(extent=[-90,30; 90,-30], style(
        color=7,
        rgbcolor={255,255,255},
        arrow=3,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
        Rectangle(extent=[-90,25; 90,20], style(
            color=62,
            rgbcolor={0,120,120},
            fillColor=62,
            rgbfillColor={0,120,120})),
        Rectangle(extent=[-90,2.5; 90,-2.5], style(
            color=62,
            rgbcolor={0,120,120},
            fillColor=62,
            rgbfillColor={0,120,120})),
        Rectangle(extent=[-90,-20; 90,-25], style(
            color=62,
            rgbcolor={0,120,120},
            fillColor=62,
            rgbfillColor={0,120,120}))),
  Diagram(
    Line(points=[-70,18; -60,18], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Rectangle(extent=[-60,20; -50,16], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-50,20; -20,16], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-50,10; -20,8], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
        Rectangle(extent=[-60,2; -50,-2], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-50,2; -20,-2], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-50,-8; -20,-10], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Rectangle(extent=[-50,-16; -20,-20], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Rectangle(extent=[-60,-16; -50,-20], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-10,13; 0,11],style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-10,9; 0,7],style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-10,-7; 0,-9],style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-10,-11; 0,-13],style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[14,3; 24,1], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[14,-1; 24,-3], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[6,16; 10,4],  style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[6,-4; 10,-16],  style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[30,6; 34,-6], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Line(points=[-20,18; 70,18], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-70,0; -60,0], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[10,0; 60,0], style(
        color=3,
        rgbcolor={0,0,255},
        pattern=3,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-70,-18; -60,-18], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[-20,-18; 70,-18], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-5,12; -5,18],
                              style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-5,-18; -5,-12],
                                style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-5,7; -5,-7],
                             style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[19,18; 19,2], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[19,-2; 19,-18], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[32,18; 32,6], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[32,-6; 32,-18], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[60,0; 70,0], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[8,18; 8,16],   style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[8,-16; 8,-18],   style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[8,4; 8,-4],   style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-20,0; 12,0], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-50,-25; -20,-27],
                                      style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Rectangle(extent=[-16,-37; -6,-39],
                                    style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-16,-41; -6,-43],
                                      style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[-10,-60; -10,-42],
                                style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-2,-34; 2,-46],
                                    style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Line(points=[0,-46; 0,-60],  style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[0,-18; 0,-34],style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-11,-18; -11,-37],
                               style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[8,-37; 18,-39],
                                    style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[8,-41; 18,-43], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[13,-60; 13,-42],
                                style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[24,-34; 28,-46],
                                    style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Line(points=[26,-46; 26,-60],style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[41,-37; 51,-39],
                                    style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[41,-41; 51,-43],style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[46,-60; 46,-42],
                                style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[55,-34; 59,-46],
                                    style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Line(points=[57,-46; 57,-60],style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[57,18; 57,-34],
                               style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[46,18; 46,-37],
                               style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
        Line(points=[26,0; 26,-28; 26,-28; 26,-34], style(color=3, rgbcolor={0,
                0,255})),
        Line(points=[13,0; 13,-28; 13,-28; 13,-38], style(color=3, rgbcolor={0,
                0,255})),
    Rectangle(extent=[-13,-60; 60,-62], style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=10,
            rgbfillColor={135,135,135}))));

  initial equation
    if steadyIni_t then
      der(v) = omega[1]*jj_dqo(v);
      der(i) = omega[1]*jj_dqo(i);
    elseif system.steadyIni_t then
      der(v) = omega[1]*jj_dqo(v);
      der(i[:,2:ne1]) = omega[1]*jj_dqo(i[:,2:ne1]);
    end if;

  equation
    omega = der(term_p.theta);
    i[:, 1] = term_p.i;
    i[:, ne1] = -term_n.i;

    if system.transientSim then
      diagonal({C,C,C0})*der(v) + omega[2]*C*jj_dqo(v) + G*v =
       i[:,1:ne] - i[:,2:ne1];
      diagonal({L,L,L0})*der(i) + omega[2]*L*jj_dqo(i) + R*i =
       [[2*(term_p.v - v[:, 1])], v[:, 1:ne - 1] - v[:, 2:ne], [2*(v[:, ne] - term_n.v)]];
    else
      omega[2]*C*jj_dqo(v) + G*v = i[:,1:ne] - i[:,2:ne1];
      omega[2]*L*jj_dqo(i) + R*i =
       [[2*(term_p.v - v[:, 1])], v[:, 1:ne - 1] - v[:, 2:ne], [2*(v[:, ne] - term_n.v)]];
    end if;
  end PIline;

  model FaultRXline "Faulted RX transmission line, 3-phase dqo"
    extends Ports.Port_p_n_f;
    parameter Real p(min=0,max=1)=0.5 "rel fault-position (0 < p < 1)";
    extends Partials.RXlineBase(final ne=1);

    SI.Current[3] i1;
    SI.Current[3] i2;
  protected
    SI.AngularFrequency[2] omega;
    annotation (
      defaultComponentName="faultRXline",
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
<p>Transmission line modelled as concentrated RX-impedance, with third terminal for connecting line-fault component.</p>
<p>The fault is at relative length <tt>p(0&lt p&lt 1)</tt>:<br>
<pre>  p*len = distance to fault from terminal term_p</pre>
</html>
"),
  Icon( Rectangle(extent=[-40,30; 80,-30], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2,
            fillColor=62,
            rgbfillColor={0,120,120})),
        Rectangle(extent=[-80,30; -40,-30], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
        Line(points=[0,80; -20,0; 20,30; 0,-40], style(color=6,
    thickness=2))),
  Diagram(
        Text(
          extent=[-50,-80; -29,-100],
          string="p",
      style(
        color=10,
        rgbcolor={95,95,95},
        arrow=3)),
        Text(
          extent=[20,-80; 60,-100],
          string="(1-p)",
      style(
        color=10,
        rgbcolor={95,95,95},
        arrow=3)),
    Line(points=[-80,35; -60,35], style(
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
    Line(points=[-80,-35; -60,-35], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[60,35; 80,35], style(
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
    Line(points=[60,-35; 80,-35], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Rectangle(extent=[-60,40; -50,30], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-50,40; -20,30], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-50,20; -20,16], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
        Rectangle(extent=[-60,5; -50,-5], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-50,5; -20,-5], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Rectangle(extent=[-60,-30; -50,-40], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-50,-30; -20,-40], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-50,-16; -20,-20], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
        Rectangle(extent=[20,40; 30,30], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[30,40; 60,30], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[30,20; 60,16], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
        Rectangle(extent=[20,5; 30,-5], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[30,5; 60,-5], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Rectangle(extent=[20,-30; 30,-40], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[30,-30; 60,-40], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[30,-16; 60,-20], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Line(points=[-20,35; 20,35], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-20,0; 20,0], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-20,-35; 20,-35], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-10,35; -10,80], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[0,0; 0,80], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[10,-35; 10,80], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-60,-70; -20,-70], style(
        color=10,
        rgbcolor={95,95,95},
        arrow=3,
        fillColor=10,
        rgbfillColor={95,95,95},
        fillPattern=1)),
    Line(points=[20,-70; 60,-70], style(
        color=10,
        rgbcolor={95,95,95},
        arrow=3,
        fillColor=10,
        rgbfillColor={95,95,95},
        fillPattern=1)),
    Rectangle(extent=[-50,-49; -20,-53],
                                       style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Rectangle(extent=[30,-49; 60,-53],
                                     style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175}))));

  initial equation
    if steadyIni_t then
      der(i1) = omega[1]*j_dqo(i1);
      der(i2) = omega[1]*j_dqo(i2);
    elseif system.steadyIni_t then
      der(term_f.i) = omega[1]*j_dqo(term_f.i);
    end if;

  equation
    omega = der(term_p.theta);
    term_p.i + term_n.i + term_f.i = zeros(3);
    i1 = term_p.i;
    i2 = -term_n.i;

    if system.transientSim then
      p*(diagonal({L,L,L0})*der(i1) + omega[2]*L*j_dqo(i1) + R*i1) =
       term_p.v - term_f.v;
      (1 - p)*(diagonal({L,L,L0})*der(i2) + omega[2]*L*j_dqo(i2) + R*i2) =
       term_f.v - term_n.v;
    else
      p*(omega[2]*L*j_dqo(i1) + R*i1) = term_p.v - term_f.v;
      (1 - p)*(omega[2]*L*j_dqo(i2) + R*i2) = term_f.v - term_n.v;
    end if;
  end FaultRXline;

  model FaultPIline "Faulted PI transmission line, 3-phase dqo"
    extends Ports.Port_p_n_f;
    parameter Real p(min=0.5/ne,max=1-0.5/ne)=0.5
      "rel fault-pos (1/2ne <= p < 1 - 1/2ne)";
    extends Partials.PIlineBase;

    SI.Voltage[3,ne] v;
    SI.Current[3,ne1] i;
    SI.Current[3] iF;
    SI.Current[3,2] iF_p(each stateSelect=StateSelect.never);
  protected
    final parameter Integer ne1=ne + 1;
    final parameter Integer nF=integer(ne*p + 1.5);
    final parameter Real pe=min(0.9, max(0.1, ne*p + 1.5 - nF))
      "relative fault position within element nF";
    SI.AngularFrequency[2] omega;
    annotation (
      defaultComponentName="faultPIline",
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
<p>Transmission line modelled as discretised telegraph-equation, 'pi-elements'.</p>
<p>The line of total length <tt>len</tt> is divided into elements of length <tt>delta = len/n</tt>.
It is composed of <tt>n-1</tt> interior elements of length <tt>delta</tt> and at each end of a half-element of length <tt>delta/2</tt>. Therefore it contains <tt>n</tt> interior nodes. Each element corresponds to a series inductor-resistor with values R and L corresponding to its length. A shunt parallel capacitor-conductor is liked to each node.<br>
The minimum of <tt>n</tt> is <tt>1</tt>.</p>
<p>The fault is at relative length <tt>p(0&lt p&lt 1)</tt>:<br>
<pre>  p*len = distance to fault from terminal term_p</pre>
<p><tt>p</tt> is restricted in such a way that faults do not occur in the end-elements of the line. Furthermore the position within an element is restricted to a relative position between <tt>0.1</tt> and <tt>0.9</tt> for numerical reasons.</p>
</html>"),
  Icon(
    Rectangle(extent=[-90,30; 90,-30], style(
        color=7,
        rgbcolor={255,255,255},
        arrow=3,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
        Rectangle(extent=[-90,25; 90,20], style(
            color=62,
            rgbcolor={0,120,120},
            fillColor=62,
            rgbfillColor={0,120,120})),
        Rectangle(extent=[-90,2.5; 90,-2.5], style(
            color=62,
            rgbcolor={0,120,120},
            fillColor=62,
            rgbfillColor={0,120,120})),
        Rectangle(extent=[-90,-20; 90,-25], style(
            color=62,
            rgbcolor={0,120,120},
            fillColor=62,
            rgbfillColor={0,120,120})),
        Line(points=[0,80; -20,0; 20,30; 0,-40], style(color=6,
    thickness=2))),
  Diagram(
        Text(
          extent=[-50,-80; -29,-100],
          string="p",
      style(
        color=10,
        rgbcolor={95,95,95},
        arrow=3)),
        Text(
          extent=[20,-80; 60,-100],
          string="(1-p)",
      style(
        color=10,
        rgbcolor={95,95,95},
        arrow=3)),
    Line(points=[-60,-70; -20,-70], style(
        color=10,
        rgbcolor={95,95,95},
        arrow=3,
        fillColor=10,
        rgbfillColor={95,95,95},
        fillPattern=1)),
    Line(points=[20,-70; 60,-70], style(
        color=10,
        rgbcolor={95,95,95},
        arrow=3,
        fillColor=10,
        rgbfillColor={95,95,95},
        fillPattern=1)),
    Rectangle(extent=[-60,1; -20,-1], style(
        color=3,
        rgbcolor={0,0,255},
        arrow=3,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-60,12; -20,10], style(
        color=3,
        rgbcolor={0,0,255},
        arrow=3,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-60,-10; -20,-12], style(
        color=3,
        rgbcolor={0,0,255},
        arrow=3,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[20,1; 60,-1], style(
        color=3,
        rgbcolor={0,0,255},
        arrow=3,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[20,12; 60,10], style(
        color=3,
        rgbcolor={0,0,255},
        arrow=3,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[20,-10; 60,-12], style(
        color=3,
        rgbcolor={0,0,255},
        arrow=3,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[-20,11; 20,11], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[-20,0; 20,0], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[-20,-11; 20,-11], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[-10,11; -10,80], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[0,0; 0,80], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[10,-11; 10,80], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[-80,11; -60,11], style(
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
    Line(points=[-80,-11; -60,-11], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[60,11; 80,11], style(
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
    Line(points=[60,-11; 80,-11], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1))));

  initial equation
    if steadyIni_t then
      der(v) = omega[1]*jj_dqo(v);
      der(i) = omega[1]*jj_dqo(i);
      der(iF) = omega[1]*j_dqo(iF);
    elseif system.steadyIni_t then
      der(v) = omega[1]*jj_dqo(v);
      der(i[:,2:ne1]) = omega[1]*jj_dqo(i[:,2:ne1]);
      der(iF) = omega[1]*j_dqo(iF);
    end if;

  equation
    omega = der(term_p.theta);
    i[:, 1] = term_p.i;
    i[:, ne1] = -term_n.i;
    iF = -term_f.i;
    iF_p = [(1-pe)*iF, pe*iF];

    if system.transientSim then
      diagonal({C,C,C0})*der(v) + omega[2]*C*jj_dqo(v) + G*v =
       [i[:,1:nF-2]-i[:, 2:nF-1], i[:,nF-1:nF]-i[:,nF:nF+1]-iF_p, i[:,nF+1:ne]-i[:,nF+2:ne1]];
      diagonal({L,L,L0})*der(i) + omega[2]*L*jj_dqo(i) + R*i =
       [[2*(term_p.v - v[:, 1])], v[:, 1:ne - 1] - v[:, 2:ne], [2*(v[:, ne] - term_n.v)]];
      diagonal({L,L,L0})*der(iF) + omega[2]*L*j_dqo(iF) + R*iF =
       (v[:, nF-1] - term_f.v)/pe + (v[:, nF] - term_f.v)/(1-pe);
    else
      omega[2]*C*jj_dqo(v) + G*v =
       [i[:,1:nF-2]-i[:, 2:nF-1], i[:,nF-1:nF]-i[:,nF:nF+1]-iF_p, i[:,nF+1:ne]-i[:,nF+2:ne1]];
      omega[2]*L*jj_dqo(i) + R*i =
       [[2*(term_p.v - v[:, 1])], v[:, 1:ne - 1] - v[:, 2:ne], [2*(v[:, ne] - term_n.v)]];
      omega[2]*L*j_dqo(iF) + R*iF =
       (v[:, nF-1] - term_f.v)/pe + (v[:, nF] - term_f.v)/(1-pe);
    end if;
  end FaultPIline;

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

    partial model RXlineBase "RX-line base, 3-phase dqo"

      parameter Boolean stIni_en=true "enable steady-state initial equation"
                                                                           annotation(evaluate=true);
      parameter SIpu.Length_km len=100 "line length";
      parameter Integer ne(min=1)=1 "number of pi-elements";
      replaceable parameter Parameters.RXline par "line parameter"
        annotation (extent=[-80,60; -60,80]);
    protected
      outer System system;
      final parameter Boolean steadyIni_t=system.steadyIni_t and stIni_en;
      final parameter SI.Resistance[2] RL_base=Base.Precalculation.baseRL(par.units, par.V_nom, par.S_nom, 2*pi*par.f_nom);
      final parameter SIpu.Length_km delta_len=len/ne;
      final parameter SI.Resistance R=par.r*delta_len*RL_base[1];
      final parameter SI.Inductance L=par.x*delta_len*RL_base[2];
      final parameter SI.Inductance L0=par.x0*delta_len*RL_base[2];
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
<p>Precalculation of coefficient matrices.</p>
</html>
"),     Icon,
        Diagram);

    end RXlineBase;

    partial model PIlineBase "PI-line base, 3-phase dqo"
      extends RXlineBase(ne=3, redeclare replaceable parameter
          Spot.ACdqo.Lines.Parameters.PIline par)
                                            annotation (extent=[-80,60; -60,80]);

    protected
      final parameter SI.Conductance[2] GC_base=Base.Precalculation.baseGC(par.units, par.V_nom, par.S_nom, 2*pi*par.f_nom);
      final parameter SI.Conductance G=(par.b_pg + 3*par.b_pp)*delta_len*GC_base[1];
      final parameter SI.Capacitance C=(par.b_pg + 3*par.b_pp)*delta_len*GC_base[2];
      final parameter SI.Capacitance C0=par.b_pg*delta_len*GC_base[2];
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
<p>Precalculation of coefficient matrices.</p>
</html>
"),     Icon);
    end PIlineBase;
  end Partials;

 package Parameters "Parameter data for interactive use"
  extends Base.Icons.Base;

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
      Documentation(info=
                   "<html>
<p>Records containing parameters of the corresponding components.</p>
</html>"),
    Icon);

   record RXline "RX-line parameters, 3-phase"
     extends Base.Units.NominalDataAC(S_nom=100e6);
     parameter SIpu.Resistance_km r=0.1e-3 "resistance/km";
     parameter SIpu.Reactance_km x=1e-3 "reactance/km";
     parameter SIpu.Reactance_km x0=3*x "reactance/km zero-comp";

       annotation (
         defaultComponentName="data",
         Coordsys(
      extent=[-100,-100; 100,100],
      grid=[2,2],
      component=[20,20]),
         Window(
      x=0.45,
   y=0.01,
   width=0.44,
      height=0.65),
         Documentation(info=
      "<html>
<p>Relations.</p>
<pre>
  x = 2*pi*f_nom*L/R_base     reactance
  r = R / R_base              resistance
</pre>
<p>Coupling.</p>
<pre>
  positive coupled     x0 &gt  x
  uncoupled limit      x0 = x
</pre>
<p>More info see package ACabc.Impedances.</p>
</html>
"),      Icon,
         Diagram);
   end RXline;

   record PIline "PI-line parameters, 3-phase"
     extends RXline;
     parameter SIpu.Conductance g_pg=0 "shunt conductance/km ph-grd";
     parameter SIpu.Conductance g_pp=0 "shunt conductance/km ph_ph";
     parameter SIpu.Susceptance_km b_pg=0.025e-3 "susceptance/km ph-grd";
     parameter SIpu.Susceptance_km b_pp=0.025e-3 "susceptance/km ph-ph";

       annotation (
         defaultComponentName="data",
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
<p>Relations.</p>
<pre>
  g = G/G_base                  conductance
  b = (2*pi*f_nom*C)/G_base     susceptance
  G_base = 1/R_base
</pre>
<p>where <tt>_pg</tt> denotes phase-to-ground, and <tt>_pp</tt> phase-to-phase.</p>
<p>More info see package ACabc.Impedances.</p>
</html>
"),Icon);
   end PIline;
 end Parameters;
end Lines;
