within Spot.Common;
package Switching "Common switching components"
  extends Base.Icons.Library;

  annotation (preferedView="info", uses(Modelica(version="2.2"), Spot(version="0.506")),
    Documentation(info="<html>
<p>Structurally incomplete kernel models.</p>
</html>"));

model Switch "Switch kernel, no terminals"
  extends Partials.SwitchBase;

  annotation (structurallyIncomplete, defaultComponentName = "switch_",
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [40, 40]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Documentation(
          info="<html>
<p><b>Structurally incomplete model</b>. Use only as component within complete Switch model.<br>
Cleared at first current-zero after opening.</p>
<p>When opening at current <> 0: <tt>arc</tt> becomes true (<tt>open</tt> changes from false to true).<br>
When open and <tt>i</tt> crosses zero: <tt>arc</tt> becomes false (<tt>open</tt> does not change).<br>
When closing: <tt>arc</tt> becomes false (<tt>open</tt> changes from true to false).</p>
</html>
"), Icon(
Line(points=[-40,0; 40,0], style(
              color=10,
              rgbcolor={95,95,95},
              pattern=3))),
    Diagram(
      Line(points=[-28,0; 32,0], style(
              color=10,
              rgbcolor={95,95,95},
              pattern=3,
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1))));

equation
  when {open and i < 0, open and i > 0, closed} then
    arc = edge(open);
  end when;
  {v,i} = if closed or arc then {epsR*s,s} else {s,epsG*s};
end Switch;

model Breaker "Breaker kernel, no terminals"
  extends Partials.SwitchBase;

  parameter SI.Distance D=50e-3 "contact distance open";
  parameter SI.Time t_opening=20e-3 "opening duration";
  parameter SI.ElectricFieldStrength Earc=50e3 "electric field arc";
  parameter SI.Resistance R0=1 "small signal resistance arc";
  replaceable Plasma.ArcBreaker arcBreaker(E=Earc, r=R0/(D*Earc), d=d, v=v_arc, i=i_arc)
    annotation (extent=[-30,-20; 30,20]);
  protected
  SI.Voltage v_arc;
  SI.Current i_arc;
  SI.Time t0(start=Modelica.Constants.inf, fixed=true) "start opening";
  SI.Distance d "contact distance";
  Boolean opening(start=false, fixed=true);

  annotation (structurallyIncomplete, defaultComponentName = "breaker_",
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [40, 40]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Documentation(
          info="<html>
<p><b>Structurally incomplete model</b>. Use only as component within complete Breaker model.<br>
Cleared at first current-zero after end of opening-interval.<br>
Contains replaceable model of plasma-arc.</p>
<p>When opening at current <> 0: <tt>arc</tt> becomes true (<tt>open</tt> changes from false to true).<br>
When fully open and <tt>i</tt> crosses zero: <tt>arc</tt> becomes false (<tt>open</tt> does not change).<br>
When closing: <tt>arc</tt> becomes false (<tt>open</tt> changes from true to false).</p>
</html>"),
    Icon(
   Line(points=[-40,0; -30,-4; -24,0; -14,-2; -4,4; 2,0; 10,-2; 18,2; 26,-2; 30,
                -2; 34,2; 40,0], style(
              color=6,
              rgbcolor={255,255,0},
              thickness=2))),
    Diagram);

equation
  when {open and i < 0, open and i > 0, closed} then
    arc = edge(open) or opening;
  end when;
  when pre(arc) then
    t0 = time;
  end when;
  opening = t0 < time and time < t0 + t_opening;
  d = if opening then ((time - t0)/t_opening)^2*D else D
      "d not needed if closed (d=0)";
  i_arc = if arc then s else 0;
  {v,i} = if closed then {epsR*s,s} else if arc then {v_arc,i_arc} else {s,epsG*s};
end Breaker;

model Short "Short kernel optionally with exponential relaxation, no terminals"
  extends Partials.FaultBase;

  parameter Boolean relax=false "use relaxation fct" annotation(evaluate=true);
  parameter SI.Time t_c=10e-3 "relaxation time constant" annotation(Dialog(enable=relax));
  parameter Real beta(min=2)=4 "power of exponent" annotation(Dialog(enable=relax));
  SI.Time t0(start=-Modelica.Constants.inf, fixed=true);
  Real[2] r;
  function relaxation=Base.Math.relaxation;
      annotation (
        structurallyIncomplete,
        defaultComponentName="fault_",
Coordsys(
  extent=
 [-100, -100; 100, 100],
  grid=[2,2],
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
<p><b>Structurally incomplete model</b>. Use only as component within complete Short model.</p>
<p>The parameter 'relax' allows choosing a continuous transition between the 'off' conductivity (epsG) and the 'on' resistivity (epsR), using an exponential relaxation function
<pre>  f = (exp(-dt^p/2) - exp(-1/2))/(1 - exp(-1/2))</pre>
with
<pre>
  dt          relative time measured from onset of short
  t_relax     relaxation time
  p           power of exponent
</pre></p>
</html>"),
Diagram,
Icon(
  Line(points=[18,78; -18,-12; 18,12; -18,-78], style(
            color=6,
            rgbcolor={255,255,0},
            pattern=2,
            thickness=2)),
 Text(
extent=[-100,140; 100,100],
string="%name",
style(color=0))));

equation
  when edge(on) then
    t0 = time;
  end when;
  if relax then
    r = relaxation(time - t0, t_c, beta);
    {v,i} = if on then {(r[1] + r[2]*epsR)*s,s} else {s,(r[1]*epsG + r[2])*s};
  else
    r = {0,0};
    {v,i} = if on then {epsR*s,s} else {s,epsG*s};
  end if;
end Short;

model Fault "Line fault kernel, no terminals"
  extends Partials.FaultBase;

  parameter SI.Voltage Varc=100 "arc voltage";
  parameter SI.Resistance R0=1 "small-signal resistance";
  parameter SI.Current Iclear=10 "self clearing current";
  parameter SI.Time t_c=1e-3 "cooling time constant";
  Boolean arc(start=false, fixed=true);
  protected
  final parameter Real r=(R0/Varc);
  final parameter Real Qclear=Iclear*Varc*t_c;
  final parameter Real Qini=100*Qclear;
  SI.Voltage v_arc;
  SI.Current i_arc;
  Real Q(start=0, fixed=true);
  Boolean cleared(start=true, fixed=true);
  replaceable Plasma.ArcFault arcFault(
    V=Varc,
    r=R0/Varc,
    v=v_arc,
    i=i_arc)
     annotation (extent=[-20,-20; 20,20]);

annotation (structurallyIncomplete, defaultComponentName = "fault_",
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
<p><b>Structurally incomplete model</b>. Use only as component within complete Fault model.<br>
Clearing criterion: balance heating-cooling.</p>
<p>Contains replaceable model of plasma-arc.</p>
</html>"),
  Diagram,
  Icon(
    Line(
 points=[18,78; -18,-12; 18,12; -18,-78],style(color=6, thickness=
   2)),
   Text(
  extent=[-100,140; 100,100],
  string="%name",
  style(color=0))));

equation
  when edge(on) then
    reinit(Q, Qini);
  end when;
  when {on, cleared} then
    arc = edge(on);
  end when;
  if arc then
    i_arc = s;
    {v,i} = {v_arc,i_arc};
    der(Q) = v_arc*i_arc - Q/t_c;
  else
    i_arc = 0;
    {v,i} = {s,epsG*s};
    der(Q) = 0;
  end if;
  cleared = Q < Qclear;
end Fault;

package Partials "Partial models"
  extends Base.Icons.Partials;

  annotation (
    Coordsys(
extent=[-100, -100; 100, 100],
grid=[2, 2],
component=[20, 20]),
    Icon,
    Window(
x=0.05,
y=0.44,
width=0.31,
height=0.26,
library=1,
autolayout=1),
    Documentation(
            info="<html>
</html>
"));

partial model SwitchBase "Switch base kernel, no terminals"

  parameter SI.Resistance epsR=1e-5 "resistance 'closed'";
  parameter SI.Conductance epsG=1e-5 "conductance 'open'";
  SI.Voltage v;
  SI.Current i;
  Boolean arc(start=false, fixed=true) "arc on";
  Boolean open(start=true)=not closed;
  Modelica.Blocks.Interfaces.BooleanInput closed(start=false)
        "true:closed, false:open"
    annotation (preferedView="info",
        extent=[-10,90; 10,110],   rotation=-90);
    protected
  Real s;

  annotation (
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=
   [2, 2],
      component=
        [40, 40]),
    Window(
      x=
0.45, y=
0.01, width=
    0.44,
      height=
     0.65),
    Documentation(
          info="<html>
</html>
"), Icon(
      Rectangle(extent=[-80,60; 80,-40], style(
          color=7,
          rgbcolor={255,255,255},
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
Line(points=[40,0; 80,0], style(
              color=10,
              rgbcolor={95,95,95},
              thickness=2)),
     Text(
    extent=[-100,-40; 100,-80],
    string="%name",
    style(color=0)),
      Line(
   points=[-80,0; -40,0; 30,40], style(
              color=10,
              rgbcolor={95,95,95},
              thickness=2)),
          Line(points=[0,90; 0,22], style(
              color=5,
              rgbcolor={255,0,255},
              pattern=3))),
    Diagram(
      Line(points=[-80,0; -60,0], style(
              color=10,
              rgbcolor={95,95,95},
              fillColor=69,
              rgbfillColor={0,128,255},
              fillPattern=1)),
Line(points=[-60,0; -30,0; 30,20], style(
              color=10,
              rgbcolor={95,95,95},
              thickness=2,
              fillColor=69,
              rgbfillColor={0,128,255})),
Line(points=[30,0; 80,0], style(
              color=10,
              rgbcolor={95,95,95},
              fillColor=69,
              rgbfillColor={0,128,255})),
      Line(points=[0,90; 0,10], style(
              color=5,
              rgbcolor={255,0,255},
              pattern=3,
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1))));

end SwitchBase;

partial model FaultBase "Fault kernel base"

  parameter SI.Resistance epsR=1e-5 "resistance 'short'";
  parameter SI.Conductance epsG=1e-5 "conductance 'open'";
  SI.Voltage v;
  SI.Current i;
  Boolean on(start=false, fixed=true);
    protected
  Real s;
      annotation (
        structurallyIncomplete,
        defaultComponentName="fault_",
Coordsys(
  extent=
 [-100, -100; 100, 100],
  grid=[2,2],
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
</html>"),
Diagram,
Icon(
  Rectangle(
    extent=[-40,80; 40,-80], style(
      color=10,
      rgbcolor={95,95,95},
      gradient=0,
      fillColor=9,
      rgbfillColor={175,175,175},
      fillPattern=1)),
 Text(
extent=[-100,140; 100,100],
string="%name",
style(color=0))));

end FaultBase;
end Partials;
end Switching;
