within Spot.Common;
package Thermal "Thermal boundary and adaptors"
  extends Base.Icons.Library;

  annotation (preferedView="info", Documentation(info="<html>
<p>Auxiliary thermal boundary-conditions, boundary-elements and adptors.</p>
</html>"));

  model BdCond "Default (Neumann) boundary condition, scalar port"
    extends Partials.BdCondBase;

    Base.Interfaces.Thermal_p heat "heat port"
      annotation (extent=[-10, -110; 10, -90], rotation=90);

    annotation (defaultComponentName="bdCond",
      Icon,
      Diagram,
      Documentation(info="<html>
<p>Deault thermal boundary condition for applications where the thermal output of heat-producing components is not needed.<br>
Boundary has fixed temperature T = 0.</p>
</html>

"));

  equation
    heat.T = T_amb;
  end BdCond;

  model BdCondV "Default (Neumann) boundary condition, vector port"

    parameter Integer m(final min=1)=1 "dimension of heat port";
    extends Partials.BdCondBase;
    Base.Interfaces.ThermalV_p heat(final m=m) "vector heat port"
      annotation (extent=[-10,-110; 10,-90],   rotation=90);
    annotation (defaultComponentName="bdCond",
      Icon,
      Diagram,
      Documentation(info="<html>
<p>Deault thermal boundary condition for applications where the thermal output of heat-producing components is not needed.<br>
Boundary has fixed temperature T = 0.</p>
</html>

"));

  equation
    heat.port.T = fill(T_amb, heat.m);
  end BdCondV;

  model Boundary "Boundary model, scalar port"
    extends Partials.BoundaryBase;

    output SI.HeatFlowRate Q_flow;
    output SI.HeatFlowRate Qav_flow=q if av;
    Base.Interfaces.Thermal_p heat "heat port"
      annotation (extent=[-10,-110; 10,-90],   rotation=90);
  protected
    SI.HeatFlowRate q;
    annotation (defaultComponentName="boundary",
      Icon,
      Diagram,
      Documentation(info="<html>
<p>Ideal cooling (ideal=true):<br>
Boundary has fixed temperature T_amb.</p>
<p>Cooling by linear heat transition (ideal=false):<br>
Boundary has one common variable temperature T.<br>
T is determined by the difference between heat inflow at the heat-port and outflow=G*(T-T_amb) towards ambient, according to a given heat capacity C.</p>
<p>The time-average equation
<pre>  der(q) = (Q_flow - q)/tcst</pre>
is equivalent to the heat equation
<pre>  C*der(T) = Q_flow - G*(T - T_amb)</pre>
at constant ambient temperature. The correspondence is
<pre>
  tcst = C/G
  q = G*(T - T_amb)
</pre></p>
</html>
"));

  equation
    heat.T = T;
    Q_flow = heat.Q_flow;

    if ideal then
      T = T_amb;
    else
      C*der(T) = Q_flow - G*(T - T_amb);
    end if;

    if av then
      der(q) = (Q_flow - q)/tcst;
    else
      q = 0;
    end if;
  end Boundary;

  model BoundaryV "Boundary model, vector port"

    parameter Boolean add_up=true "add up Q_flow at equal T";
    parameter Integer m(final min=1)=1 "dimension of heat port";
    extends Partials.BoundaryBase;
    output SI.HeatFlowRate[if add_up then 1 else m] Q_flow;
    output SI.HeatFlowRate[if add_up then 1 else m] Qav_flow=q if av;
    Base.Interfaces.ThermalV_p heat(final m=m) "vector heat port"
      annotation (extent=[-10,-110; 10,-90],   rotation=90);
  protected
    SI.HeatFlowRate[if add_up then 1 else m] q;
    annotation (defaultComponentName="boundary",
      Icon,
      Diagram,
      Documentation(info="<html>
<p>Ideal cooling (ideal=true):<br>
Boundary has fixed temperature T_amb.</p>
<p>Cooling by linear heat transition (ideal=false):<br>
Boundary has one common variable temperature T.<br>
T is determined by the difference between heat inflow at the heat-port and outflow=G*(T-T_amb) towards ambient, according to a given heat capacity C.</p>
<p>The time-average equation
<pre>  der(q) = (Q_flow - q)/tcst</pre>
is equivalent to the heat equation
<pre>  C*der(T) = Q_flow - G*(T - T_amb)</pre>
at constant ambient temperature. The correspondence is
<pre>
  tcst = C/G
  q = G*(T - T_amb)
</pre></p>
</html>
"));

  equation
    heat.port.T = fill(T, heat.m);
    Q_flow = if add_up then {sum(heat.port.Q_flow)} else heat.port.Q_flow;

    if ideal then
      T = T_amb;
    else
      C*der(T) = sum(Q_flow) - G*(T - T_amb);
    end if;

    if av then
      der(q) = (Q_flow - q)/tcst;
    else
      q = zeros(if add_up then 1 else m);
    end if;
  end BoundaryV;

  model Heat_a_b_ab "Adaptor 2 x Thermal (scalar) to ThermalV (vector)"

    Base.Interfaces.Thermal_p port_a "scalar port a"
      annotation (extent=[-50,-70; -30,-50], rotation=90);
    Base.Interfaces.Thermal_p port_b "scalar port b"
      annotation (extent=[30,-70; 50,-50], rotation=90);
    Base.Interfaces.ThermalV_n port_ab(final m=2) "vector port {a,b}"
      annotation (extent=[-10,50; 10,70], rotation=90);
    annotation (defaultComponentName="heat_adapt",
      Diagram(Line(points=[-40,-40; -40,0; -5,0; -5,40], style(color=42, rgbcolor=
               {176,0,0})), Line(points=[40,-40; 40,0; 5,0; 5,40], style(color=42,
              rgbcolor={176,0,0}))),
      Icon(
          Rectangle(extent=[-60,40; 60,-40], style(
            color=7,
            rgbcolor={255,255,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Line(points=[-40,-38; -40,0; -10,0; -10,40], style(color=42, rgbcolor={
                176,0,0})),
        Line(points=[40,-40; 40,0; 10,0; 10,40], style(color=42, rgbcolor={176,0,
                0})),
        Text(
  extent=[-100,-100; 100,-140],
  string="%name",
  style(color=0)),
        Text(
          extent=[-100,-60; -60,-100],
          string="a",
          style(color=42, rgbcolor={176,0,0})),
        Text(
          extent=[60,-60; 100,-100],
          style(color=42, rgbcolor={176,0,0}),
          string="b")),
      Documentation(info="<html>
</html>"));

  equation
    {port_a.T, port_b.T} = port_ab.port.T;
    {port_a.Q_flow, port_b.Q_flow} + port_ab.port.Q_flow = zeros(2);
  end Heat_a_b_ab;

  model Heat_a_b_c_abc "Adaptor 3 x Thermal (scalar) to ThermalV (vector)"

    Base.Interfaces.Thermal_p port_a "scalar port a"
      annotation (extent=[-50,-70; -30,-50], rotation=90);
    Base.Interfaces.Thermal_p port_b "scalar port b"
      annotation (extent=[-10,-70; 10,-50],rotation=90);
    Base.Interfaces.Thermal_p port_c "scalar port c"
      annotation (extent=[30,-70; 50,-50], rotation=90);
    Base.Interfaces.ThermalV_n port_abc(final m=3) "vector port {a,b,c}"
                                                 annotation (extent=[-10,50; 10,70],
        rotation=90);
    annotation (defaultComponentName="heat_adapt",
      Diagram(
        Line(points=[-40,-40; -40,0; -5,0; -5,40], style(color=42, rgbcolor={176,
                0,0})),
        Line(points=[0,-40; 0,40], style(color=42, rgbcolor={176,0,0})),
        Line(points=[40,-40; 40,0; 5,0; 5,40], style(color=42, rgbcolor={176,0,0}))),
      Icon(
          Rectangle(extent=[-60,40; 60,-40], style(
            color=7,
            rgbcolor={255,255,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Line(points=[-40,-38; -40,0; -10,0; -10,40], style(color=42, rgbcolor={
                176,0,0})),
        Line(points=[40,-40; 40,0; 10,0; 10,40], style(color=42, rgbcolor={176,0,
                0})),
        Line(points=[0,-40; 0,40], style(color=42, rgbcolor={176,0,0})),
        Text(
  extent=[-100,-100; 100,-140],
  string="%name",
  style(color=0)),
        Text(
          extent=[-100,-60; -60,-100],
          string="a",
          style(color=42, rgbcolor={176,0,0})),
        Text(
          extent=[60,-60; 100,-100],
          style(color=42, rgbcolor={176,0,0}),
          string="c")),
      Documentation(info="<html>
</html>"));

  equation
    {port_a.T, port_b.T, port_c.T} = port_abc.port.T;
    {port_a.Q_flow, port_b.Q_flow, port_c.Q_flow} + port_abc.port.Q_flow = zeros(3);
  end Heat_a_b_c_abc;

  model HeatV_a_b_ab "Adaptor 2 x ThermalV (vector) to ThermalV (vector)"

    parameter Integer[2] m={1,1} "dimension {port_a, port_b}";
    Base.Interfaces.ThermalV_p port_a(final m=m[1]) "vector port a"
      annotation (extent=[-50,-70; -30,-50], rotation=90);
    Base.Interfaces.ThermalV_p port_b(final m=m[2]) "vector port b"
      annotation (extent=[30,-70; 50,-50], rotation=90);
    Base.Interfaces.ThermalV_n port_ab(final m=sum(m)) "vector port {a,b}"
      annotation (extent=[-10,50; 10,70], rotation=90);
    annotation (defaultComponentName="heat_adapt",
      Diagram(Line(points=[-40,-40; -40,0; -5,0; -5,40], style(color=42, rgbcolor=
               {176,0,0})), Line(points=[40,-40; 40,0; 5,0; 5,40], style(color=42,
              rgbcolor={176,0,0}))),
      Icon(
          Rectangle(extent=[-60,40; 60,-40], style(
            color=7,
            rgbcolor={255,255,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Line(points=[-40,-38; -40,0; -10,0; -10,40], style(color=42, rgbcolor={
                176,0,0})),
        Line(points=[40,-40; 40,0; 10,0; 10,40], style(color=42, rgbcolor={176,0,
                0})),
        Text(
  extent=[-100,-100; 100,-140],
  string="%name",
  style(color=0)),
        Text(
          extent=[-100,-60; -60,-100],
          string="a",
          style(color=42, rgbcolor={176,0,0})),
        Text(
          extent=[60,-60; 100,-100],
          style(color=42, rgbcolor={176,0,0}),
          string="b")),
      Documentation(info="<html>
</html>"));

  equation
    cat(1, port_a.port.T, port_b.port.T) = port_ab.port.T;
    cat(1, port_a.port.Q_flow, port_b.port.Q_flow) + port_ab.port.Q_flow = zeros(sum(m));
  end HeatV_a_b_ab;

  model HeatV_a_b_c_abc "Adaptor 3 x Thermal (scalar) to ThermalV (vector)"

    parameter Integer[3] m={1,1,1} "dimension {port_a, port_b, port_c}";
    Base.Interfaces.ThermalV_p port_a(final m=m[1]) "scalar port a"
      annotation (extent=[-50,-70; -30,-50], rotation=90);
    Base.Interfaces.ThermalV_p port_b(final m=m[2]) "scalar port b"
      annotation (extent=[-10,-70; 10,-50],rotation=90);
    Base.Interfaces.ThermalV_p port_c(final m=m[3]) "scalar port c"
      annotation (extent=[30,-70; 50,-50], rotation=90);
    Base.Interfaces.ThermalV_n port_abc(final m=sum(m)) "vector port {a,b,c}"
                                                 annotation (extent=[-10,50; 10,70],
        rotation=90);
    annotation (defaultComponentName="heat_adapt",
      Diagram(
        Line(points=[-40,-40; -40,0; -5,0; -5,40], style(color=42, rgbcolor={176,
                0,0})),
        Line(points=[0,-40; 0,40], style(color=42, rgbcolor={176,0,0})),
        Line(points=[40,-40; 40,0; 5,0; 5,40], style(color=42, rgbcolor={176,0,0}))),
      Icon(
          Rectangle(extent=[-60,40; 60,-40], style(
            color=7,
            rgbcolor={255,255,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Line(points=[-40,-38; -40,0; -10,0; -10,40], style(color=42, rgbcolor={
                176,0,0})),
        Line(points=[40,-40; 40,0; 10,0; 10,40], style(color=42, rgbcolor={176,0,
                0})),
        Line(points=[0,-40; 0,40], style(color=42, rgbcolor={176,0,0})),
        Text(
  extent=[-100,-100; 100,-140],
  string="%name",
  style(color=0)),
        Text(
          extent=[-100,-60; -60,-100],
          string="a",
          style(color=42, rgbcolor={176,0,0})),
        Text(
          extent=[60,-60; 100,-100],
          style(color=42, rgbcolor={176,0,0}),
          string="c")),
      Documentation(info="<html>
</html>"));

  equation
    cat(1, port_a.port.T, port_b.port.T, port_c.port.T) = port_abc.port.T;
    cat(1, port_a.port.Q_flow, port_b.port.Q_flow, port_c.port.Q_flow) + port_abc.port.Q_flow = zeros(sum(m));
  end HeatV_a_b_c_abc;

  model HeatV_S "Collector ThermalV (vector) to Thermal (scalar)"

    parameter Integer m(final min=1) = 1 "dimension of port_a";
    Base.Interfaces.ThermalV_p port_a(final m=m) "vector port"
      annotation (extent=[-10,-68; 10,-48],  rotation=90);
    Base.Interfaces.Thermal_n port_b "scalar port"
      annotation (extent=[-10,50; 10,70], rotation=90);
    annotation (defaultComponentName="heat_collect",
      Diagram,
      Icon(
          Rectangle(extent=[-60,40; 60,-40], style(
            color=7,
            rgbcolor={255,255,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Line(points=[-10,-40; -10,0; 0,0; 0,40],     style(color=42, rgbcolor={
                176,0,0})),
        Line(points=[10,-40; 10,0; 0,0; 0,40],   style(color=42, rgbcolor={176,0,
                0})),
        Text(
  extent=[-100,-100; 100,-140],
  string="%name",
  style(color=0))),
      Documentation(info="<html>
The temperatures of all vector-heat ports and the temperature of the scalar heat port are equal.<br>
The total of all vector-heat in-flows is equal to the scalar out-flow.
</html>"));

  equation
    port_a.port.T = fill( port_b.T, port_a.m);
    sum(port_a.port.Q_flow) + port_b.Q_flow = 0;
  end HeatV_S;

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
model BdCondBase "Default (Neumann) boundary condition base"

  parameter SI.Temperature T_amb=300 "ambient temperature";

  annotation (defaultComponentName="bdCond",
    Icon(
      Text(
extent=[-100,0; 100,-40],
string="%name",
style(color=0)),
      Rectangle(extent=[-80,-50; 80,-80],    style(
          color=0,
          fillColor=8,
          fillPattern=8)),
      Line(points=[-80,-50; 80,-50], style(color=7, rgbcolor={255,255,255}))),
    Diagram,
    Documentation(info="<html>
<p>Deault thermal boundary condition for applications where the thermal output of heat-producing components is not needed.<br>
Boundary has fixed temperature T = 0.</p>
</html>

"));

end BdCondBase;

partial model BoundaryBase "Boundary model base"

  parameter Boolean av=false "time average heat-flow"  annotation(evaluate=true,Dialog(group="Options"));
  parameter SI.Time tcst(min=1e-9)=1 "average time-constant"
                                                  annotation(Evaluate=true, Dialog(group="Options",enable=av));
  parameter Boolean ideal=true "ideal cooling";
  parameter SI.Temperature T_amb=300 "ambient temperature";
  parameter SI.HeatCapacity C=1 "heat capacity cp*m" annotation(Dialog(enable=not ideal));
  parameter SI.ThermalConductance G=1 "thermal conductance to ambient" annotation(Dialog(enable=not ideal));
  SI.Temperature T(start=300) "temperature";

    protected
  outer System system;
  annotation (defaultComponentName="boundary",
    Icon(
      Rectangle(extent=[-80,-50; 80,-80],    style(
          color=0,
          fillColor=8,
          fillPattern=8)),
      Rectangle(extent=[-80,40; 80,-50], style(
          color=7,
          rgbcolor={255,255,255},
          fillColor=7,
          rgbfillColor={255,255,255})),
      Line(points=[-50,20; -40,40; -30,20], style(color=42, fillColor=45)),
      Line(points=[-10,20; 0,40; 10,20],    style(color=42, fillColor=45)),
      Line(points=[30,20; 40,40; 50,20],    style(color=42, fillColor=45)),
      Line(points=[-40,-50; -40,-40], style(color=42, fillColor=45)),
      Line(points=[0,-50; 0,-40],     style(color=42, fillColor=45)),
      Line(points=[40,-50; 40,-40],   style(color=42, fillColor=45)),
      Line(points=[-40,0; -40,40],    style(color=42, fillColor=45)),
      Line(points=[0,0; 0,40],        style(color=42, fillColor=45)),
      Line(points=[40,0; 40,40],      style(color=42, fillColor=45)),
      Text(
extent=[-100,0; 100,-40],
string="%name",
style(color=0))),
    Diagram,
    Documentation(info="<html>
</html>
"));

initial equation
  if not ideal and system.steadyIni_t then
    der(T) = 0;
  end if;
end BoundaryBase;
end Partials;

end Thermal;
