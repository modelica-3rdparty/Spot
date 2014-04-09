within Spot.AC1_DC;

package Lines "Transmission lines 1-phase"
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
<p>Different types of transmission line models.<br>
Faulted transmission lines contain a third terminal for connection to a fault-component.</p>
<p>The relations between line reactance (<tt>x,x0</tt>) and self- and mutual reactance (<tt>x_s,x_m</tt>) are</p>
<pre>
  x   = x_s - x_m,          reactance dq (stray reactance)
  x0  = x_s + x_m,          reactance o (zero-component reactance)
  x_s = (x + x0)/2,         self reactance single conductor
  x_m = (x0 - x)/2,         mutual reactance
</pre>
<p>Coupling:</p>
<pre>  cpl = x_m/x_s &gt  0,        positive for lines</pre>
<p>More info see package AC1_DC.Impedances.</p>
</html>"), Icon);
  model RXline "RX transmission line, 1-phase"
    extends Ports.Port_pn;
    extends Partials.RXlineBase(final ne=1);

    SI.Voltage[2] v;
    SI.Current[2] i;
    annotation (
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
<p>Transmission line modelled as concentrated RX-impedance.</p>
</html>"),   Icon(
       Rectangle(extent=[-80,30; -40,-30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
          Rectangle(extent=[-40,30; 80,-30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))),
      Diagram(
        Line(points=[-80,20; -60,20],
                                    style(
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
        Line(points=[60,20; 80,20],
                                  style(
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
            fillPattern=1)),
        Rectangle(extent=[-60,25; -40,15], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,25; 60,15], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Rectangle(extent=[-60,-15; -40,-25],style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,-15; 60,-25],style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-40,5; 60,-5],  style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175}))));
  equation
    v = term_p.pin.v - term_n.pin.v;
    i = term_p.pin.i;

    L*der(i) + diagonal(R)*i = v;
  end RXline;

  model PIline "PI transmission line, 1-phase"
    extends Ports.Port_p_n;
    extends Partials.PIlineBase;

    SIpu.Voltage v[2,ne];
    SIpu.Current i[2,ne1];
  protected
    final parameter Integer ne1=ne + 1;
    annotation (
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
<p>Transmission line modelled as discretised telegraph-equation, 'pi-elements'.</p>
<p>The line of total length <tt>len</tt> is divided into elements of length <tt>delta = len/n</tt>.
It is composed of <tt>n-1</tt> interior elements of length delta and at each end of a half-element of length <tt>delta/2</tt>.
Therefore it contains <tt>n</tt> interior nodes. Each element corresponds to a series resistor-inductor with values R and L corresponding to its length. A shunt parallel capacitor-conductor is linked to each node.<br>
The minimum of <tt>n</tt> is <tt>1</tt>.</p>
<p>This kind of discretisation is slightly more complicated than the division of the line into n identical elements, but it results in a symmetric model with respect to interchanging positive and negative terminal.
The set of equations of two series connected lines of length len1 and len2 is identical to the set of equations for one line of length len1 + len2 if delta1 = delta2. Otherwise differences occur from the different discretisation length.</p>
</html>"),   Icon(
    Rectangle(extent=[-80,30; 80,-32], style(
        color=7,
        rgbcolor={255,255,255},
        arrow=3,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
        Rectangle(extent=[-90,16; 90,11], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-90,-11; 90,-16], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))),
      Diagram(
    Line(points=[-60,10; -50,10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Rectangle(extent=[-50,12; -40,8],  style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,12; -10,8],  style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-40,1; -10,-1], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Rectangle(extent=[-40,-8; -10,-12],  style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Rectangle(extent=[-50,-8; -40,-12],  style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[15,3; 25,1], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[15,-1; 25,-3], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[32,6; 36,-6], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Line(points=[-10,10; 60,10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-60,-10; -50,-10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[-10,-10; 60,-10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[20,10; 20,3], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[20,-3; 20,-10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[34,10; 34,6], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[34,-6; 34,-10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-1,-28; 9,-30],
                                    style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-1,-32; 9,-34], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[4,-48; 4,-34], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[13,-25; 17,-37],
                                    style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Line(points=[15,-37; 15,-48],style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[15,-10; 15,-25],
                               style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[4,-10; 4,-28],style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[35,-28; 45,-30],
                                    style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[35,-32; 45,-34],style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[40,-48; 40,-33],
                                style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[49,-25; 53,-37],
                                    style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Line(points=[51,-37; 51,-48],style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[51,10; 51,-25],
                               style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[40,10; 40,-28],
                               style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[0,-48; 54,-50], style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=10,
            rgbfillColor={135,135,135}))));

  initial equation
    if system.steadyIni_t then
      der(v) = zeros(2,ne);
      der(i[:,2:ne1]) = zeros(2,ne);
    end if;

  equation
    i[:, 1] = term_p.pin.i;
    i[:, ne1] = -term_n.pin.i;

    C*der(v) + G*v = i[:, 1:ne] - i[:, 2:ne1];
    L*der(i) + diagonal(R)*i = [[2*(term_p.pin.v - v[:, 1])], v[:, 1:ne - 1] - v[:, 2:ne], [2*(v[:, ne] - term_n.pin.v)]];
  end PIline;

model FaultRXline "Faulted RX transmission line, 1-phase"
  extends Ports.Port_p_n_f;
  parameter Real p(min=0,max=1)=0.5 "rel fault-position (0 < p < 1)";
  extends Partials.RXlineBase(final ne=1);

  SI.Current[2] i1;
  SI.Current[2] i2;
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
</html>"),
Icon( Rectangle(extent=[-40,30; 80,-30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
      Rectangle(extent=[-80,30; -40,-30], style(
            color=3,
            rgbcolor={0,0,255},
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
  Line(points=[60,-20; 80,-20], style(
      color=3,
      rgbcolor={0,0,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1)),
      Rectangle(extent=[-60,25; -50,15], style(
      color=3,
      rgbcolor={0,0,255},
      thickness=2,
      fillColor=7,
      rgbfillColor={255,255,255})),
  Rectangle(extent=[-50,25; -20,15], style(
      color=3,
      rgbcolor={0,0,255},
      thickness=2,
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1)),
  Rectangle(extent=[-50,2; -20,-2],  style(
      color=9,
      rgbcolor={175,175,175},
      fillColor=9,
      rgbfillColor={175,175,175})),
      Rectangle(extent=[-60,-15; -50,-25], style(
      color=3,
      rgbcolor={0,0,255},
      thickness=2,
      fillColor=7,
      rgbfillColor={255,255,255})),
  Rectangle(extent=[-50,-15; -20,-25], style(
      color=3,
      rgbcolor={0,0,255},
      thickness=2,
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1)),
      Rectangle(extent=[20,25; 30,15], style(
      color=3,
      rgbcolor={0,0,255},
      thickness=2,
      fillColor=7,
      rgbfillColor={255,255,255})),
  Rectangle(extent=[30,25; 60,15], style(
      color=3,
      rgbcolor={0,0,255},
      thickness=2,
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1)),
  Rectangle(extent=[30,2; 60,-2],  style(
      color=9,
      rgbcolor={175,175,175},
      fillColor=9,
      rgbfillColor={175,175,175})),
      Rectangle(extent=[20,-15; 30,-25], style(
      color=3,
      rgbcolor={0,0,255},
      thickness=2,
      fillColor=7,
      rgbfillColor={255,255,255})),
  Rectangle(extent=[30,-15; 60,-25], style(
      color=3,
      rgbcolor={0,0,255},
      thickness=2,
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1)),
  Line(points=[-20,20; 20,20], style(
      color=3,
      rgbcolor={0,0,255},
      fillColor=7,
      rgbfillColor={255,255,255},
      fillPattern=1)),
  Line(points=[-20,-20; 20,-20], style(
      color=3,
      rgbcolor={0,0,255},
      fillColor=7,
      rgbfillColor={255,255,255},
      fillPattern=1)),
  Line(points=[-10,20; -10,80], style(
      color=3,
      rgbcolor={0,0,255},
      fillColor=7,
      rgbfillColor={255,255,255},
      fillPattern=1)),
  Line(points=[10,-20; 10,80], style(
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
      fillPattern=1))));

equation
  term_p.pin.i + term_n.pin.i + term_f.pin.i = {0,0};
  i1 = term_p.pin.i;
  i2 = -term_n.pin.i;

  p*(L*der(i1) + diagonal(R)*i1) = term_p.pin.v - term_f.pin.v;
  (1 - p)*(L*der(i2) + diagonal(R)*i2) = term_f.pin.v - term_n.pin.v;
end FaultRXline;

model FaultPIline "Faulted PI transmission line, 1-phase"
  extends Ports.Port_p_n_f;
  parameter Real p(min=0.5/ne,max=1-0.5/ne)=0.5
      "rel fault-pos (1/2ne <= p < 1 - 1/2ne)";
  extends Partials.PIlineBase;

  SI.Voltage[2,ne] v;
  SI.Current[2,ne1] i;
  SI.Current[2] iF;
  SI.Current[2,2] iF_p(each stateSelect=StateSelect.never);
  protected
  final parameter Integer ne1=ne + 1;
  final parameter Integer nF=integer(ne*p + 1.5);
  final parameter Real pe=min(0.9, max(0.1, ne*p + 1.5 - nF))
      "relative fault position within element nF";
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
It is composed of <tt>n-1</tt> interior elements of length delta and at each end of a half-element of length <tt>delta/2</tt>.
Therefore it contains <tt>n</tt> interior nodes. Each element corresponds to a series inductor-resistor with values R and L corresponding to its length. A shunt parallel capacitor-conductor is liked to each node.<br>
The minimum of <tt>n</tt> is <tt>1</tt>.</p>
<p>The fault is at relative length <tt>p(0&lt p&lt 1)</tt>:<br>
<pre>  p*len = distance to fault from terminal term_p</pre>
<p><tt>p</tt> is restricted in such a way that faults do not occur in the end-elements of the line. Furthermore the position within an element is restricted to a relative position between <tt>0.1</tt> and <tt>0.9</tt> for numerical reasons.</p>
</html>"),
Icon(
  Rectangle(extent=[-80,30; 80,-30], style(
      color=7,
      rgbcolor={255,255,255},
      arrow=3,
      fillColor=7,
      rgbfillColor={255,255,255},
      fillPattern=1)),
      Rectangle(extent=[-90,16; 90,11], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
      Rectangle(extent=[-90,-11; 90,-16], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
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
  Rectangle(extent=[-60,11; -20,9],  style(
      color=3,
      rgbcolor={0,0,255},
      arrow=3,
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1)),
  Rectangle(extent=[-60,-9; -20,-11],  style(
      color=3,
      rgbcolor={0,0,255},
      arrow=3,
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1)),
  Rectangle(extent=[20,11; 60,9],  style(
      color=3,
      rgbcolor={0,0,255},
      arrow=3,
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1)),
  Rectangle(extent=[20,-9; 60,-11],  style(
      color=3,
      rgbcolor={0,0,255},
      arrow=3,
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1)),
  Line(points=[-20,10; 20,10], style(
      color=3,
      rgbcolor={0,0,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1)),
  Line(points=[-20,-10; 20,-10], style(
      color=3,
      rgbcolor={0,0,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1)),
  Line(points=[-10,10; -10,80], style(
      color=3,
      rgbcolor={0,0,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1)),
  Line(points=[10,-10; 10,80], style(
      color=3,
      rgbcolor={0,0,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1)),
  Line(points=[-80,10; -60,10], style(
      color=3,
      rgbcolor={0,0,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1)),
  Line(points=[-80,-10; -60,-10], style(
      color=3,
      rgbcolor={0,0,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1)),
  Line(points=[60,10; 80,10], style(
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
  if system.steadyIni_t then
    der(v) = zeros(2,ne);
    der(i[:,2:ne1]) = zeros(2,ne);
  end if;

equation
  i[:, 1] = term_p.pin.i;
  i[:, ne1] = -term_n.pin.i;
  iF = -term_f.pin.i;
  iF_p = [(1-pe)*iF, pe*iF];

  C*der(v) + G*v = [i[:,1:nF-2]-i[:, 2:nF-1], i[:,nF-1:nF]-i[:,nF:nF+1]-iF_p, i[:,nF+1:ne]-i[:,nF+2:ne1]];
  L*der(i) + diagonal(R)*i = [[2*(term_p.pin.v - v[:, 1])], v[:, 1:ne - 1] - v[:, 2:ne], [2*(v[:, ne] - term_n.pin.v)]];
  L*der(iF) + diagonal(R)*iF = (v[:, nF-1] - term_f.pin.v)/pe + (v[:, nF] - term_f.pin.v)/(1-pe);
end FaultPIline;

  package Partials "Partial models"
    extends Base.Icons.Partials;

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

    partial model RXlineBase "RX-line base, 1-phase"

      parameter SIpu.Length_km len=100 "line length";
      parameter Integer ne(min=1)=1 "number of pi-elements";
      replaceable parameter Parameters.RXline par "line parameter"
                                           annotation (extent=[-80,60; -60,80]);
    protected
      outer System system;
      final parameter Real[2] RL_base=Base.Precalculation.baseRL(par.units, par.V_nom, par.S_nom, 2*pi*par.f_nom);
      final parameter SIpu.Length_km delta_len=len/ne;
      final parameter SI.Resistance[2] R=par.r*delta_len*RL_base[1];
      final parameter SI.Inductance[2,2] L=([(par.x + par.x0),(par.x0 - par.x);(par.x0 - par.x),(par.x + par.x0)]/2)*delta_len*RL_base[2];
      annotation (
        Coordsys(
          extent=
         [-100, -100; 100, 100],
          grid=
       [2, 2],
          component=
            [20, 20]),
        Window(
          x=
    0.45, y=
    0.01, width=
        0.44,
          height=
         0.65),
        Documentation(
              info="<html>
<p>Precalculation of coefficient matrices.</p>
</html>"),     Icon,
        Diagram);
    end RXlineBase;

    partial model PIlineBase "PI-line base, 1-phase"
      extends RXlineBase(ne=3, redeclare replaceable parameter
          Spot.AC1_DC.Lines.Parameters.PIline par)
        annotation (extent=[-80,60; -60,80]);
        annotation (extent=[-80,60; -60,80]);

    protected
      final parameter Real[2] GC_base=Base.Precalculation.baseGC(par.units, par.V_nom, par.S_nom, 2*pi*par.f_nom);
      final parameter SI.Conductance[2,2] G=[par.g_pg+par.g_pp,-par.g_pp;-par.g_pp,par.g_pg+par.g_pp]*delta_len*GC_base[1];
      final parameter SI.Capacitance[2,2] C=[par.b_pg+par.b_pp,-par.b_pp;-par.b_pp,par.b_pg+par.b_pp]*delta_len*GC_base[2];
      annotation (
        Coordsys(
          extent=
         [-100, -100; 100, 100],
          grid=
       [2, 2],
          component=
            [20, 20]),
        Window(
          x=
    0.45, y=
    0.01, width=
        0.44,
          height=
         0.65),
        Documentation(
              info="<html>
<p>Precalculation of coefficient matrices.</p>
</html>"),     Icon,
        Diagram);
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

  record RXline "RX-line parameters, 1-phase"
    extends Base.Units.NominalDataAC(S_nom=100e6);
    parameter SIpu.Resistance[2] r={0.1,0.1}*1e-3 "resistance/km";
    parameter SIpu.Reactance_km x=1e-3 "reactance/km";
    parameter SIpu.Reactance_km x0(min=x)=3*x "reactance/km zero-comp";

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
  positive coupled:     x0 &gt  x
  uncoupled limit:      x0 = x
</pre>
<p>More info see package AC1_DC.Impedances.</p>
</html>"),
        Icon,
        Diagram);
  end RXline;

  record PIline "PI-line parameters, 1-phase"
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
<p>More info see package AC1_DC.Impedances.</p>
</html>"),
  Icon);
  end PIline;
end Parameters;
end Lines;
