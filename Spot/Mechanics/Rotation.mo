within Spot.Mechanics;
package Rotation "Rotating parts "
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
</html>
"), Icon);

  package Ports "One- and two-flange base for rotating mechanical components."
  extends Base.Icons.Base;

    annotation (
      preferedView="info",
  Coordsys(
    extent=[-100, -100; 100, 100],
    grid=[2, 2],
    component=[20, 20]),
  Window(
    x=0.05,
    y=0.03,
    width=0.4,
    height=0.38,
    library=1,
    autolayout=1),
  Documentation(info="<html>
<p>Contains mechanical one and two-ports with rotational connectors.</p>
</html>"),
    Icon);

  partial model Flange_p "One flange, 'positive'"

    Base.Interfaces.Rotation_p flange "positive flange"
  annotation (extent=[-110,-10; -90,10]);
    annotation (
  Icon(Text(
      extent=[-100,-100; 100,-140],
      string="%name",
      style(color=0))),
  Diagram,
  Documentation(info="<html>
</html>"));
  end Flange_p;

  partial model Flange_n "One flange, 'negative'"

    Base.Interfaces.Rotation_n flange "negative flange"
  annotation (extent=[90, -10; 110, 10]);
    annotation (
  Icon(Text(
      extent=[-100,-100; 100,-140],
      string="%name",
      style(color=0))),
  Diagram,
  Documentation(info="<html>
</html>"));
  end Flange_n;

  partial model Flange_p_n "Two flange"

    Base.Interfaces.Rotation_p flange_p "positive flange"
  annotation (extent=[-110, -10; -90, 10]);
    Base.Interfaces.Rotation_n flange_n "negative flange"
  annotation (extent=[90, -10; 110, 10]);
    annotation (
  Icon(Text(
      extent=[-100,-100; 100,-140],
      string="%name",
      style(color=0))),
  Diagram,
  Documentation(info="<html>
</html>"));
  end Flange_p_n;

  partial model Rigid "Rigid two-flange"
    extends Flange_p_n;

    annotation (
  Icon,
  Diagram,
  Documentation(info="<html>
</html>"));

  equation
    flange_p.phi = flange_n.phi;
  end Rigid;

  partial model Compliant "Compliant two-flange"
    extends Flange_p_n;

    SI.Angle d_phi "difference angle (twist)";
    SI.Torque d_tau "twisting torque";
    annotation (
  Icon,
  Diagram,
  Documentation(info="<html>
</html>"));

  equation
    flange_n.phi - flange_p.phi = d_phi;
    flange_n.tau - flange_p.tau = 2*d_tau;
  end Compliant;

  end Ports;

  model Speed "Rotation with given angular velocity"
    extends Ports.Flange_n;

    parameter SI.Time tcst(min=1e-9)=0.1 "time-constant";
    parameter Base.Types.SourceType scType=Base.Types.par
      "w: parameter or signal"
     annotation(Evaluate=true);
    parameter SI.AngularVelocity w0=1 "angular velocity"
     annotation(Dialog(enable=scType==Base.Types.par));
    Modelica.Blocks.Interfaces.RealInput w(redeclare type SignalType =
          SI.AngularVelocity) "(signal ang-velocity)"
    annotation (extent=[-110, -10; -90, 10]);
  protected
    SI.Angle phi_dot(start=w0);

  annotation (defaultComponentName = "speed1",
    Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]),
    Icon(
        Ellipse(extent=[-60,60; 60,-60], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=9,
          rgbfillColor={175,175,175})),
        Ellipse(extent=[-40,40; 40,-40], style(
          color=0,
          fillColor=7)),
        Rectangle(extent=[26,20; 66,-20], style(pattern=0, fillColor=7)),
        Polygon(points=[26,20; 46,-20; 66,20; 26,20], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=9,
          rgbfillColor={175,175,175}))),
    Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
    Diagram(Text(
        extent=[-50,10; 50,-10],
        style(color=74, rgbcolor={0,0,127}),
          string="signal-angular-velocity w"),
            Text(
        extent=[-70,70; 70,50],
        style(color=74, rgbcolor={0,0,127}),
          string="parameter-angular-velocity w0"),
      Line(points=[-90,0; -60,0], style(color=74, rgbcolor={0,0,127})),
            Text(
        extent=[-20,40; 20,20],
        style(color=74, rgbcolor={0,0,127}),
        string="or")),
    Documentation(
            info="<html>
<p>'flange' moves with parameter-ang-velocity w0 or with signal angular-velocity w, depending on 'scType'.<br>
This is a \"soft\" speed, using a differential equation. It is needed for compatibility with the default initial equations used in the machine models.<br>
The start value is always given by <tt>w0</tt>.</p>
</html>"));

  equation
    der(flange.phi) = phi_dot;
    der(phi_dot) = if scType == Base.Types.par then (w0 - phi_dot)/tcst else (w - phi_dot)/tcst;
  end Speed;

  model Torque "Driving torque"
    extends Ports.Flange_n;

    parameter Base.Types.SourceType scType=Base.Types.par
      "tau: parameter or signal"
     annotation(Evaluate=true);
    parameter SI.Torque tau0=1 "torque"
     annotation(Dialog(enable=scType==Base.Types.par));
    Modelica.Blocks.Interfaces.RealInput tau(redeclare type SignalType = SI.Torque)
      "(signal torque)"
    annotation (extent=[-110, -10; -90, 10]);
  annotation (defaultComponentName = "torq1",
    Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]),
    Icon(
        Ellipse(extent=[-60,60; 60,-60], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=9,
          rgbfillColor={175,175,175})),
        Ellipse(extent=[-40,40; 40,-40], style(
          color=0,
          fillColor=7)),
        Rectangle(extent=[26,20; 66,-20], style(pattern=0, fillColor=7)),
        Polygon(points=[26,20; 46,-20; 66,20; 26,20], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=9,
          rgbfillColor={175,175,175}))),
    Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
    Diagram(Text(
        extent=[-50,10; 50,-10],
        style(color=74, rgbcolor={0,0,127}),
          string="signal-torque tau"),
            Text(
        extent=[-70,70; 70,50],
        style(color=74, rgbcolor={0,0,127}),
          string="parameter-torque tau0"),
      Line(points=[-90,0; -60,0], style(color=74, rgbcolor={0,0,127})),
            Text(
        extent=[-20,40; 20,20],
        style(color=74, rgbcolor={0,0,127}),
        string="or")),
    Documentation(
            info="<html>
<p>Torque <tt>tau</tt> acts in positive direction on the connected component if <tt>tau > 0</tt>.</p>
</html>
"));

  equation
    flange.tau = if scType == Base.Types.par then -tau0 else -tau;
  end Torque;

model TabTimeTorque "Torque using table (time... torque)"
  extends Partials.TabTorque;

  parameter SI.Time t_unit=1 "unit of 'time' in tab";
  parameter SI.Torque tau_unit=1 "unit of 'torque' in tab";
  parameter Real[2] t_bd(unit="tab-unit")={0,1} "{first, last} time in tab";
  parameter Integer drive_load=1 "driving or load"
    annotation(choices(
    choice=1 "driving torque (+1)", choice=-1 "load torque (-1)"));
  parameter Integer direction(min=-1,max=1)=1 "forward or backward in time"
    annotation(choices(
    choice=1 "t_first --> t_last", choice=-1 "t_first <-- t_last"));
  parameter Boolean scale=false "scale time and torque";
  parameter SI.Time T=1 "scale duration to T"
    annotation(Dialog(enable=scale));
  parameter SIpu.Percent tau_perc=100 "scale tab torque to tau_perc"
    annotation(Dialog(enable=scale));
  protected
  SI.Time t;
  final parameter Real t_factor=if scale then T/abs(t_bd[2]-t_bd[1]) else t_unit;
  final parameter Real tau_factor=if scale then drive_load*0.01*tau_perc*tau_unit else drive_load*tau_unit;

  annotation (defaultComponentName = "tabTorq1",
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
<p>The torque is defined in a table as a function of time.
<pre>
  Column 1 contains the time in units <tt>t_unit</tt> (<tt>t_unit</tt> in \"s\").
  Column 'colData' contains the torque in units <tt>tau_unit</tt> (<tt>tau_unit</tt> in \"N.m\").
</pre></p>
<p>Both time and torque may be linearly scaled by a factor if 'scale = true'.</p>
<p>Flange_p and flange_n are rigidly connected. The torque acts on the connected component(s) in
<pre>
positive direction, if tau_table &gt  0 and drive_load = +1 or tau_table &lt  0 and drive_load = -1
negative direction, if tau_table &gt  0 and drive_load = -1 or tau_table &lt  0 and drive_load = +1
</pre></p>
<p>Note: start integration at time = 0</p>
</html>"),
    Icon,
    Diagram);

equation
  if direction == 1 then
    t = t_factor*t_bd[1] + time;
  elseif direction == -1 then
    t = t_factor*t_bd[2] - time;
  else
    t = 0;
  end if;
  table.u = t/t_factor;
  tau = tau_factor*table.y[1];

  when t > t_factor*t_bd[2] or t < t_factor*t_bd[1] then
    terminate("BOUNDARY TIME REACHED!");
  end when;
  annotation (defaultComponentName = "tabTorq1",
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
<p>The torque load is defined in a table.
<pre>
  Column 1 contains the time in units <tt>t_unit</tt> (<tt>t_unit</tt> in \"s\").
  Column 'colTorque' contains the torque in units <tt>tau_unit</tt> (<tt>tau_unit</tt> in \"N.m\").
</pre>
</html>
"), Icon,
    Diagram);
end TabTimeTorque;

model TabPosSlopeTorque "Torque using table (position... slope)"
  extends Partials.TabTorque;

  constant SI.Force g_n=Modelica.Constants.g_n;
  parameter SI.Length s_unit=1 "unit of 'position' in tab";
  parameter Real[2] s_bd(unit="tab-unit")={0,1} "{first, last} position in tab";
  parameter Integer dirTrack(min=-1,max=1)=+1 "forward or backward track"
    annotation(choices(
    choice=1 "first-pos ---> last-pos", choice=-1 "first-pos <--- last-pos"));
  parameter Integer dirVehicle(min=-1,max=1)=+1
      "vehicle forward or backward driving"
    annotation(choices(
    choice=1 "forward", choice=-1 "backward"));
  parameter Boolean scale=false "scale position and slope";
  parameter SIpu.Length_km D=1 "scale distance to D" annotation(Dialog(enable=scale));
  parameter SIpu.Percent slope_perc=100 "scale slope to slope_perc"
                                                             annotation(Dialog(enable=scale));
  parameter SI.Mass mass=1 "mass";
  parameter Real[2] cFrict(min={0,0}, unit="{N.s/m, N.s2/m2} ")={0,0}
      "friction cst {lin, quadr} (translation)";
  parameter SI.Length r=1 "radius wheel";
  parameter Real gRatio=1 "gear-ratio";
  SI.Length s;
  SI.Velocity vVehicle "vehicle horizontal velocity";
  protected
  final parameter Real s_factor=if scale then 1e3*D/abs(s_bd[2]-s_bd[1]) else s_unit;
  final parameter Real slope_factor=if scale then 0.01*slope_perc else 1;
  final parameter Integer sig=dirTrack*dirVehicle;
  Real slope;
  Real sin_gam;
  SI.Angle phi;
  SI.Force f;
  annotation (defaultComponentName = "tabTorq1",
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
<p>This model uses a position-slope table. It is mainly intended for test-purposes.</p>
<pre>
  Column 1 contains the (horizontal) position in units <tt>s_unit</tt> (<tt>s_unit</tt> in \"m\").
  Column 'colData' contains the slope dh/ds of a height profile in dimensionless units.
</pre></p>
<p>Both position and slope may be linearly scaled by a factor if 'scale = true' (for example using a normalised height-profile).</p>
<p>The torque load <tt>tau</tt> is related to a driving force <tt>f</tt> and a parameter (wheel-) radius <tt>r</tt> by
<pre>  tau = f/r</pre>
The force as a function of position <tt>s</tt> corresponds to a mass moving along a height profile with linear and quadratic friction. Flange_p and flange_n are rigidly connected.</p>
<p>Note: If the height h is also needed, it has to be scaled with the factor (slope_perc/100)*D.<br>
Start integration at time = 0.</p>
</html>
"), Icon(
      Polygon(points=[-38,190; -38,190],
                                       style(
          color=10,
          rgbcolor={255,250,110})),
      Polygon(points=[-40,110; -60,90; 60,110; 40,123; -40,110],
                                                           style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=10,
            rgbfillColor={135,135,135})),
      Polygon(points=[-60,80; -80,60; 40,80; 60,100; -60,80],  style(
          color=10,
          rgbcolor={95,95,95},
          fillColor=10,
          rgbfillColor={95,95,95},
          fillPattern=1)),
        Polygon(points=[-60,90; -60,80; 60,100; 60,110; -60,90], style(
            color=1,
            rgbcolor={255,0,0},
            fillColor=1,
            rgbfillColor={255,0,0}))),
    Diagram);

initial equation
  s = if dirTrack == 1 then s_factor*s_bd[1] else s_factor*s_bd[2];

equation
  phi = flange_p.phi;
  gRatio*vVehicle = r*der(phi);
  r*f = gRatio*tau;
  table.u = s/s_factor;
  slope = slope_factor*table.y[1];
  sin_gam = slope/sqrt(1 + slope*slope); // = sin(atan(slope))
  der(s) = sig*vVehicle;
  mass*der(vVehicle) = -(f + sig*mass*g_n*sin_gam + (cFrict[1] + cFrict[2]*abs(vVehicle))*vVehicle);

  when s > s_factor*s_bd[2] or s < s_factor*s_bd[1] then
    terminate("BOUNDARY POSITION REACHED!");
  end when;
end TabPosSlopeTorque;

  model FrictionTorque "Friction torque"
    extends Ports.Flange_p;

     parameter Real[2] cFrict(min={0,0}, unit="{N.m.s, N.m.s2}")={0,0}
      "friction cst {lin, quadr}";
    SI.Angle phi;
    SI.AngularVelocity w;
  annotation (defaultComponentName = "frictTorq1",
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
<p>Linear and quadratic friction torque <tt>tau</tt>.</p>
<pre>
  tau = c_frict[1]*w + c_frict[2]*abs(w)*w
  w     angular velocity
</pre>
</html>"),
    Icon(
      Polygon(points=[-38,20; -38,20], style(
          color=10,
          rgbcolor={255,250,110})),
      Ellipse(extent=[-60,60; 60,-60], style(
          color=10,
          rgbcolor={135,135,135},
          fillColor=10,
          rgbfillColor={135,135,135})),
      Line(points=[-80,0; -60,0], style(
          color=10,
          rgbcolor={95,95,95},
          fillColor=10,
          rgbfillColor={95,95,95},
          fillPattern=1)),
      Ellipse(extent=[-50,50; 50,-50], style(
          color=1,
          rgbcolor={255,0,0},
          fillColor=1,
          rgbfillColor={255,0,0})),
      Ellipse(extent=[-44,44; 44,-43], style(
          color=10,
          rgbcolor={95,95,95},
          fillColor=10,
          rgbfillColor={95,95,95}))),
    Diagram);

  equation
    phi = flange.phi;
    w = der(phi);
    flange.tau = (cFrict[1] + cFrict[2]*noEvent(abs(w)))*w;
  end FrictionTorque;

model FixedAngle "Flange at fixed angular position"
  parameter SI.Angle phi0=0 "angle";

   Base.Interfaces.Rotation_p flange
                                 annotation (extent=[-10,-10; 10,10]);
  annotation (defaultComponentName = "fixAng1",
    Coordsys(
      extent=[-100, -100; 100, 100],
      grid=[2, 2],
      component=[20, 20]),
    Window(
      x=0.27,
      y=0.02,
      width=0.63,
      height=0.73),
    Icon(
      Line(points=[60,-40; -80,-40; 20,60], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=44,
          rgbfillColor={255,170,170},
          fillPattern=1)),
      Polygon(points=[-80,-40; -60,-20; -52,-40; -80,-40], style(
          color=9,
          rgbcolor={175,175,175},
          fillColor=44,
          rgbfillColor={255,170,170})),
     Text(
    extent=[-100,-100; 100,-140],
    string="%name",
    style(color=0))),
    Documentation(info="<html>
<p>Fixes the angular variable <tt>phi</tt> of a connected flange to a parameter value <tt>phi0</tt>.</p>
</html>
"), Diagram);

equation
  flange.phi = phi0;
end FixedAngle;

model Rotor "Rigid rotating mass"
  extends Partials.RigidRotorBase;

  annotation (defaultComponentName = "rotor1",
    Coordsys(
extent=[-100, -100; 100, 100],
grid=[2, 2],
component=[20, 20]),
    Window(
x=0.45,
y=0.01,
width=0.44,
height=0.65),
    Diagram,
    Icon(
Rectangle(extent=[-60,50; 60,-50],   style(
          color=0,
          rgbcolor={0,0,0},
          gradient=2,
          fillColor=9,
          rgbfillColor={175,175,175})),
      Rectangle(extent=[60,10; 100,-10], style(
          color=9,
          rgbcolor={175,175,175},
          gradient=2,
          fillColor=30,
          rgbfillColor={215,215,215})),
      Rectangle(extent=[-100,10; -60,-10], style(
          color=9,
          rgbcolor={175,175,175},
          gradient=2,
          fillColor=30,
          rgbfillColor={215,215,215}))),
    Documentation(
            info="<html>
<p>Rotating rigid mass with two flanges. </p>
</html>
"));

equation
  J*a = flange_p.tau + flange_n.tau;
end Rotor;

  model ThermalTurbineRotor "Thermal turbine rotor"
    extends Partials.RigidRotorCase;

    annotation (defaultComponentName = "turbRotor1",
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
<p>Turbine-rotor as one single rigid mass</p>
<pre>
  flange_p, flange_n:  connectors to other rotating parts
                       of the turbo-generator group
</pre>
<p><i>
No pole pair reduction of equations of motion.<br>
phi and w represent the mechanical angle and angular velocity.
</i></p>
</html>
"),   Icon(
     Polygon(points=[-100,30; 100,70; 100,-70; -100,-30; -100,30], style(
            color=0,
            rgbcolor={0,0,0},
            gradient=2,
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=8)),
        Polygon(points=[-100,70; -100,40; 60,70; -100,70],style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=42,
            rgbfillColor={176,0,0})),
        Polygon(points=[-100,-70; -100,-40; 60,-70; -100,-70], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=42,
            rgbfillColor={176,0,0})),
        Line(points=[0,-70; 0,-50], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=10,
            rgbfillColor={95,95,95},
            fillPattern=1)),
        Rectangle(extent=[-100,90; 100,70], style(
            color=9,
            rgbcolor={175,175,175},
            fillColor=9,
            rgbfillColor={175,175,175})),
        Rectangle(extent=[-100,-70; 100,-90],
                                            style(
            color=9,
            rgbcolor={175,175,175},
            fillColor=9,
            rgbfillColor={175,175,175}))),
      Diagram);

  end ThermalTurbineRotor;

  model HydroTurbineRotor "Hydro turbine rotor"
    extends Partials.RigidRotorCase;

    annotation (defaultComponentName = "turbRotor1",
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
<p>Turbine-rotor as one single rigid mass</p>
<pre>
  flange_p, flange_n:  connectors to other rotating parts
                       of the turbo-generator group
</pre>
<p><i>
No pole pair reduction of equations of motion.<br>
phi and w represent the mechanical angle and angular velocity.
</i></p>
</html>
"),   Icon(Rectangle(extent=[20,10; 40,-10],  style(
                color=0,
                rgbcolor={0,0,0},
                gradient=2,
                fillColor=30,
                rgbfillColor={215,215,215},
                fillPattern=8)),
        Rectangle(extent=[-60,-80; 100,-100],style(
             color=9,
             rgbcolor={175,175,175},
             fillColor=9,
             rgbfillColor={175,175,175})),
        Rectangle(extent=[-60,80; 60,-80], style(
            color=68,
            rgbcolor={170,213,255},
            fillColor=68,
            rgbfillColor={170,213,255},
            fillPattern=1)),
        Rectangle(extent=[-60,100; 60,80],    style(
            color=9,
            rgbcolor={175,175,175},
            fillColor=9,
            rgbfillColor={175,175,175})),
        Rectangle(extent=[-20,60; 20,-60], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=30,
            rgbfillColor={215,215,215})),
        Ellipse(
        extent=[-20,80; 20,40],  style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=10,
            rgbfillColor={135,135,135})),
        Ellipse(
        extent=[-20,-40; 20,-80],  style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=10,
            rgbfillColor={135,135,135})),
        Rectangle(extent=[20,10; 100,-10], style(
            color=0,
            rgbcolor={0,0,0},
            gradient=2,
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=8))),
      Diagram);
  end HydroTurbineRotor;

  model DieselRotor "Diesel rotor"
    extends Partials.RigidRotorCase;

    annotation (defaultComponentName = "turbRotor1",
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
<p>Turbine-rotor as one single rigid mass</p>
<pre>
  flange_p, flange_n:  connectors to other rotating parts
                       of the turbo-generator group
</pre>
<p><i>
No pole pair reduction of equations of motion.<br>
phi and w represent the mechanical angle and angular velocity.
</i></p>
</html>
"),   Icon(Rectangle(extent=[20,10; 40,-10],  style(
                color=0,
                rgbcolor={0,0,0},
                gradient=2,
                fillColor=30,
                rgbfillColor={215,215,215},
                fillPattern=8)),
        Rectangle(extent=[-60,-80; 100,-100],style(
             color=9,
             rgbcolor={175,175,175},
             fillColor=9,
             rgbfillColor={175,175,175})),
        Rectangle(extent=[-60,80; 60,-80],   style(
            color=45,
            rgbcolor={255,128,0},
            fillColor=45,
            rgbfillColor={255,128,0},
            fillPattern=1)),
        Rectangle(extent=[-40,80; 40,-80],  style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=30,
            rgbfillColor={215,215,215})),
        Rectangle(extent=[-30,100; 30,80], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=9,
            rgbfillColor={175,175,175},
            fillPattern=1)),
        Ellipse(extent=[-30,4; 30,-56],   style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=9,
            rgbfillColor={175,175,175},
            fillPattern=1))),
      Diagram);
  end DieselRotor;

  model WindTurbineRotor "Wind turbine rotor"
    extends Partials.RigidRotorCase;

  annotation (defaultComponentName = "turbRotor1",
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
<p>Turbine-rotor as one single rigid mass</p>
<pre>
  flange_p, flange_n:  connectors to other rotating parts
                       of the turbo-generator group
</pre>
<p><i>
No pole pair reduction of equations of motion.<br>
phi and w represent the mechanical angle and angular velocity.
</i></p>
</html>
"), Icon(   Rectangle(extent=[-50,90; 40,70], style(
                color=9,
                rgbcolor={175,175,175},
                fillColor=9,
                rgbfillColor={175,175,175})),
            Rectangle(extent=[-50,-70; 40,-90],
                                              style(
                color=9,
                rgbcolor={175,175,175},
                fillColor=9,
                rgbfillColor={175,175,175})),
        Rectangle(extent=[-60,100; 60,-100], style(
            color=51,
            rgbcolor={255,255,170},
            fillColor=51,
            rgbfillColor={255,255,170},
            fillPattern=1)),
        Rectangle(extent=[-40,14; 40,-14],style(
            color=9,
            rgbcolor={175,175,175},
            fillColor=9,
            rgbfillColor={175,175,175})),
           Polygon(points=[0,-120; 0,120; 8,80; 16,40; 16,20; 12,6; 0,0; -12,-6;
              -16,-20; -16,-40; -10,-80; 0,-120],                  style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
            Rectangle(extent=[40,10; 100,-10], style(
                color=0,
                rgbcolor={0,0,0},
                gradient=2,
                fillColor=30,
                rgbfillColor={215,215,215},
                fillPattern=8))),
    Diagram);
  end WindTurbineRotor;

  model ElectricRotor "Electric generator/motor rotor, mechanical"
    extends Partials.RigidRotorCase;

  annotation (defaultComponentName = "elRotor",
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
<p>Rotor as one single stiff mass.</p>
<pre>
  flange_p, flange_n:  connectors to other rotating parts
                       of the turbo-generator group
</pre>
<p><i>
No pole pair reduction of equations of motion.<br>
phi and w represent the mechanical angle and angular velocity.
</i></p>
</html>
"),   Icon(
    Rectangle(extent=[-100,50; 100,-50], style(
            color=0,
            rgbcolor={0,0,0},
            gradient=2,
            fillColor=30,
            rgbfillColor={215,215,215})), Rectangle(extent=[-100,70; 100,50], style(
            color=47,
            rgbcolor={255,170,85},
            fillColor=47,
            rgbfillColor={255,170,85})),  Rectangle(extent=[-100,-50; 100,-70], style(
            color=47,
            rgbcolor={255,170,85},
            fillColor=47,
            rgbfillColor={255,170,85})),
        Line(points=[0,-70; 0,-50], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=10,
            rgbfillColor={95,95,95},
            fillPattern=1)),
        Rectangle(extent=[-100,90; 100,70], style(
            color=9,
            rgbcolor={175,175,175},
            fillColor=9,
            rgbfillColor={175,175,175})),
        Rectangle(extent=[-100,-70; 100,-90],
                                            style(
            color=9,
            rgbcolor={175,175,175},
            fillColor=9,
            rgbfillColor={175,175,175}))),
      Diagram);
  end ElectricRotor;

model ShaftNoMass "Elastic massless shaft"
  extends Ports.Compliant;

  parameter SIpu.TorsionStiffness stiff=1e6 "torsion stiffness";

  annotation (defaultComponentName = "shaft1",
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
<p>Rotating torsion-elastic massless shaft. It is equivalent to a massless torsion spring.<br><br>
The parameter <tt>stiffness</tt> is a length-independent specification, in contrast to a spring-constant.</p>
</html>
"), Icon(
   Rectangle(extent=[-100,10; 100,-10], style(
          color=0,
          rgbcolor={0,0,0},
          gradient=2,
          fillColor=7,
          rgbfillColor={255,255,255}))),
    Diagram);

equation
  flange_p.tau + flange_n.tau = 0;
  d_tau = stiff*d_phi;
end ShaftNoMass;

model Shaft "Elastic massive shaft"
  extends Ports.Compliant;

  parameter SI.Inertia J=1 "inertia";
  parameter SIpu.TorsionStiffness stiff=1e6 "torsion stiffness";
  SI.Angle phi(stateSelect=StateSelect.prefer) "rotation angle center";
  SI.AngularVelocity w(stateSelect=StateSelect.prefer);
  SI.AngularAcceleration a;
  annotation (defaultComponentName = "shaft1",
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
<p>Rotating torsion-elastic massive shaft. It is equivalent to a massive torsion spring.<br>
(Approximation for small torsion-angles / lowest mode to avoid wave-equation)<br><br>
The parameter <tt>stiffness</tt> is a length-independent specification, in contrast to a spring-constant.</p>
</html>"),
    Icon(
   Rectangle(extent=[-100,10; 100,-10], style(
          color=0,
          rgbcolor={0,0,0},
          gradient=2,
          fillColor=9,
          rgbfillColor={175,175,175}))),
    Diagram);

equation
  flange_p.phi + flange_n.phi = 2*phi;
  w = der(phi);
  a = der(w);
  J*a = flange_p.tau + flange_n.tau;
  d_tau = stiff*d_phi;
end Shaft;

model GearNoMass "Massless gear"
  extends Ports.Flange_p_n;

  parameter Real[:] ratio={1,1}
      "gear-ratio {p, .., n}, (speeds in arbitrary units)";
  protected
  final parameter Real ratio_pn=ratio[1]/ratio[end];
  annotation (defaultComponentName = "gear",
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
<p>Ideal massless gear. Rigid coupling with gear-ratio</p>
<pre>  ratio[1]/ratio[end]</pre>
<p>Input identical with massive gear 'Gear'.<br>
Gear ratios are defined by <b>relative</b> speed. The following specifications are equivalent
<pre>
  ratio = {6, 2, 1}
  ratio = {9000, 3000, 1500}
</pre></p>
<p>For memorising
<pre>  ratio[1]/ratio[end] > 1 if flange_a faster flange_b.</pre></p>
</html>
"), Icon(
Rectangle(extent=[30,40; 50,-40], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=7,
          rgbfillColor={255,255,255})),
Rectangle(extent=[30,80; 50,40], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=7,
          rgbfillColor={255,255,255})),
      Rectangle(extent=[50,10; 100,-10], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=7,
          rgbfillColor={255,255,255})),
      Rectangle(extent=[-30,70; 30,50], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=7,
          rgbfillColor={255,255,255})),
Rectangle(extent=[-50,100; -30,20], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=7,
          rgbfillColor={255,255,255})),
Rectangle(extent=[-50,20; -30,-20], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=7,
          rgbfillColor={255,255,255})),
      Rectangle(extent=[-100,10; -50,-10], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=7,
          rgbfillColor={255,255,255})),
      Rectangle(extent=[-30,50; 30,-20], style(
          color=7,
          rgbcolor={255,255,255},
          fillColor=7,
          rgbfillColor={255,255,255}))),
    Diagram(
      Rectangle(extent=[-80,10; -50,-10], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=7,
          rgbfillColor={255,255,255})),
Rectangle(extent=[-50,20; -30,-20], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=7,
          rgbfillColor={255,255,255})),
Rectangle(extent=[-50,100; -30,20], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=7,
          rgbfillColor={255,255,255})),
      Rectangle(extent=[-30,70; 30,50], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=7,
          rgbfillColor={255,255,255})),
Rectangle(extent=[30,80; 50,40], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=7,
          rgbfillColor={255,255,255})),
Rectangle(extent=[30,40; 50,-40], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=7,
          rgbfillColor={255,255,255})),
      Rectangle(extent=[50,10; 80,-10], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=7,
          rgbfillColor={255,255,255})),
      Text(
        extent=[-100,-80; 100,-100],
        style(
          color=1,
          rgbcolor={255,0,0},
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
          string="ratio = {4, 2, 1}  or  {6000, 3000, 1500}"),
      Text(
        extent=[-70,-30; -10,-50],
        style(color=0, rgbcolor={0,0,0}),
        string="J[1] = 0"),
      Text(
        extent=[-30,100; 30,80],
        style(color=0, rgbcolor={0,0,0}),
        string="J[2] = 0"),
      Text(
        extent=[10,-50; 70,-70],
        style(color=0, rgbcolor={0,0,0}),
        string="J[3] = 0")));

equation
  flange_p.phi = ratio_pn*flange_n.phi;
  ratio_pn*flange_p.tau + flange_n.tau = 0;
end GearNoMass;

model Gear "Massive gear"
  extends Ports.Flange_p_n;

  parameter Real[:] ratio={1,1}
      "gear-ratio {p, .., n}, (speeds in arbitrary units)";
  parameter SI.Inertia[:] J={1,1} "inertias {p, .., n}, (not reduced)";
  SI.Angle phi(stateSelect=StateSelect.prefer);
  SI.AngularVelocity w(stateSelect=StateSelect.prefer);
  SI.AngularAcceleration a;
  protected
  final parameter Real ratio_pn=ratio[1]/ratio[end];
  final parameter Real[size(ratio,1)] ratio2=diagonal(ratio)*ratio/(ratio[end]*ratio[end]);
  annotation (defaultComponentName = "gear",
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
<p>Ideal massive gear. N rigidly coupled inertias with gear-ratio
<pre>  ratio[1]/ratio[2], .., ratio[end-1]/ratio[end]</pre></p>
<p>Input identical with massless gear 'GearNoMass'.</p>
<p>Gear ratios are defined by <b>relative</b> speed. The following specifications are equivalent
<pre>
  ratio = {6, 2, 1}
  ratio = {9000, 3000, 1500}
</pre></p>
<p>For memorising
<pre>  ratio[1]/ratio[end] > 1 if flange_a faster flange_b.</pre></p>
</html>
"), Icon(
Rectangle(extent=[30,40; 50,-40], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=9,
          rgbfillColor={175,175,175})),
Rectangle(extent=[30,80; 50,40], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=9,
          rgbfillColor={175,175,175})),
      Rectangle(extent=[50,10; 100,-10], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=30,
          rgbfillColor={215,215,215})),
      Rectangle(extent=[-30,70; 30,50], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=30,
          rgbfillColor={215,215,215})),
Rectangle(extent=[-50,100; -30,20], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=9,
          rgbfillColor={175,175,175})),
Rectangle(extent=[-50,20; -30,-20], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=9,
          rgbfillColor={175,175,175})),
      Rectangle(extent=[-100,10; -50,-10], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=30,
          rgbfillColor={215,215,215})),
      Rectangle(extent=[-30,50; 30,-20], style(
          color=7,
          rgbcolor={255,255,255},
          fillColor=7,
          rgbfillColor={255,255,255}))),
    Diagram(
      Text(
        extent=[-70,-30; -10,-50],
        string="J[1]",
        style(color=0, rgbcolor={0,0,0})),
      Text(
        extent=[10,-50; 70,-70],
        style(color=0, rgbcolor={0,0,0}),
        string="J[3]"),
Rectangle(extent=[30,40; 50,-40], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=9,
          rgbfillColor={175,175,175})),
Rectangle(extent=[30,80; 50,40], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=9,
          rgbfillColor={175,175,175})),
      Rectangle(extent=[50,10; 80,-10], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=30,
          rgbfillColor={215,215,215})),
      Rectangle(extent=[-30,70; 30,50], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=30,
          rgbfillColor={215,215,215})),
Rectangle(extent=[-50,100; -30,20], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=9,
          rgbfillColor={175,175,175})),
Rectangle(extent=[-50,20; -30,-20], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=9,
          rgbfillColor={175,175,175})),
      Rectangle(extent=[-80,10; -50,-10], style(
          color=10,
          rgbcolor={95,95,95},
          gradient=2,
          fillColor=30,
          rgbfillColor={215,215,215})),
      Text(
        extent=[-30,100; 30,80],
        style(color=0, rgbcolor={0,0,0}),
        string="J[2]"),
      Text(
        extent=[-100,-80; 100,-100],
        style(
          color=1,
          rgbcolor={255,0,0},
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
          string="ratio = {4, 2, 1}  or  {6000, 3000, 1500}")));

equation
  flange_p.phi = ratio_pn*flange_n.phi;
  phi = flange_n.phi;
  w = der(phi);
  a = der(w);
  (ratio2*J)*a = ratio_pn*flange_p.tau + flange_n.tau;
end Gear;

model NoGear "Placeholder for gear"
  extends Ports.Flange_p_n;

  annotation (defaultComponentName = "joint",
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
<p>Joining two rotational flanges directly, in place of gear.</p>
</html>
"), Icon(Rectangle(extent=[-80,80; 80,-80], style(
          color=0,
          rgbcolor={0,0,0},
          pattern=3,
          fillColor=7,
          rgbfillColor={255,255,255})), Line(points=[-90,0; 90,0], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1))),
    Diagram);

equation
  flange_p.phi = flange_n.phi;
  flange_p.tau + flange_n.tau = 0;
end NoGear;

model AngleSensor "Angle and angular velocity sensor (mechanical)"
  extends Ports.Flange_p;

  Modelica.Blocks.Interfaces.RealOutput phi(redeclare type SignalType =
    SI.Angle) "angle"
    annotation (
          extent=[-50,90; -30,110],  rotation=90);
  Modelica.Blocks.Interfaces.RealOutput w(redeclare type SignalType =
        SI.AngularVelocity) "angular velocity"
    annotation (
          extent=[30,90; 50,110],    rotation=90);
  annotation (defaultComponentName = "angleSens1",
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
</html>
"), Icon(
Ellipse(extent=[-70, 70; 70, -70], style(color=10, fillColor=7)),
Line(points=[0, 70; 0, 40], style(color=10)),
Line(points=[22.9, 32.8; 40.2, 57.3], style(color=10)),
Line(points=[-22.9, 32.8; -40.2, 57.3], style(color=10)),
Line(points=[37.6, 13.7; 65.8, 23.9], style(color=10)),
Line(points=[-37.6, 13.7; -65.8, 23.9], style(color=10)),
Line(points=[0, 0; 9.02, 28.6], style(color=10, rgbcolor={95,95,95})),
Polygon(points=[-0.48, 31.6; 18, 26; 18, 57.2; -0.48, 31.6], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=10,
            rgbfillColor={128,128,128},
            fillPattern=1)),
Ellipse(extent=[-5, 5; 5, -5], style(
            color=10,
            rgbcolor={95,95,95},
            gradient=0,
            fillColor=10,
            rgbfillColor={128,128,128},
            fillPattern=1)),
Line(points=[-90,0; 0,0],  style(color=10, rgbcolor={135,135,135})),
Text(
  extent=[-100,-100; 100,-140],
  string="%name",
  style(color=0))),
    Diagram);

equation
  flange.tau = 0;
  phi = flange.phi;
  w = der(flange.phi);
end AngleSensor;

model PowerSensor "Power and torque sensor (mechanical)"
  extends Ports.Rigid;

  Modelica.Blocks.Interfaces.RealOutput p(redeclare type SignalType =
    SI.Power) "power, flange_p to flange_n"
    annotation (
          extent=[-50,90; -30,110],  rotation=90);
  Modelica.Blocks.Interfaces.RealOutput tau(redeclare type SignalType =
        SI.Torque) "torque, flange_p to flange_n"
    annotation (
          extent=[30,90; 50,110],    rotation=90);
  annotation (defaultComponentName = "powerSens1",
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
</html>
"), Icon(
Ellipse(extent=[-70, 70; 70, -70], style(color=10, fillColor=7)),
Text(
  extent=[-100,-100; 100,-140],
  string="%name",
  style(color=0)),
    Line(
 points=[-90,0; -20,0], style(color=10, rgbcolor={95,95,95})),
    Line(
 points=[0,0; 90,0], style(color=10, rgbcolor={95,95,95})),
    Line(
 points=[30,20; 70,0; 30,-20], style(color=10, rgbcolor={95,95,95})),
   Ellipse(extent=[-20,20; 20,-20],   style(color=10, rgbcolor={135,135,135})),
      Line(points=[-66,24; -48,18], style(color=10, rgbcolor={95,95,95})),
      Line(points=[-40,57; -30,43], style(color=10, rgbcolor={95,95,95})),
      Line(points=[0,70; 0,52], style(color=10, rgbcolor={95,95,95})),
      Line(points=[40,57; 30,42], style(color=10, rgbcolor={95,95,95})),
      Line(points=[66,24; 48,18], style(color=10, rgbcolor={95,95,95}))),
    Diagram);

equation
  flange_p.tau + flange_n.tau = 0;
  tau = flange_p.tau;
  p = der(flange_p.phi)*flange_p.tau;
end PowerSensor;

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

    partial model TabTorque "Table data to torque"
      extends Ports.Flange_p_n;

      parameter String tableName="" "table name in file";
      parameter String fileName=TableDir + "" "name of file containing table";
      parameter Integer colData=2 "column # used data";
      SI.Force tau;

    Modelica.Blocks.Tables.CombiTable1Ds table(
      final tableName=tableName,
      final fileName=fileName,
      final columns={colData},
      tableOnFile=true) "{time t .. force f ..}"
        annotation (extent=[-20,-20; 20,20]);
      annotation (defaultComponentName = "tabForce1",
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
</html>
"),     Icon(
    Rectangle(extent=[-40,-90; 40,-70], style(color=10)),
    Line(points=[-40,-80; 40,-80], style(color=10)),
    Line(points=[-20,-70; -20,-90], style(color=10)),
          Ellipse(extent=[-60,60; 60,-60], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=9,
            rgbfillColor={175,175,175})),
          Ellipse(extent=[-40,40; 40,-40], style(
            color=0,
            fillColor=7)),
          Rectangle(extent=[26,20; 66,-20], style(pattern=0, fillColor=7)),
          Polygon(points=[26,20; 46,-20; 66,20; 26,20], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=9,
            rgbfillColor={175,175,175}))),
        Diagram);

    equation
      flange_p.phi = flange_n.phi;
      flange_p.tau + flange_n.tau + tau = 0;
    end TabTorque;

    partial model RigidRotorBase "Rigid rotor base"
      extends Ports.Rigid;

      parameter SI.Inertia J=1 "inertia";
      SI.Angle phi "rotation angle absolute";
      SI.AngularVelocity w;
      SI.AngularAcceleration a;
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
</html>"),
        Icon,
        Diagram);

    equation
      phi = flange_p.phi;
      w = der(phi);
      a = der(w);
    end RigidRotorBase;

    partial model RigidRotorCase "Rigid rotor with case"
      extends RigidRotorBase;

      Base.Interfaces.Rotation_p rotor
        "connector to turbine (mech) or airgap (el) torque"
        annotation(extent=[10,70; -10,50], rotation=270);
      Base.Interfaces.Rotation_p stator "access for stator reaction moment"
        annotation (
              extent=[90,-70; 110,-90], rotation=-180);
      Base.Interfaces.Rotation_n friction "access for friction model"
    annotation (extent=[-10,-90; 10,-70], rotation=90);
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
<p>Rigid rotor base with an additional access for torque on rotor, stator (case) reaction torque, and a collective access for friction.</p>
</html>
"),     Icon,
        Diagram(Line(points=[0,-80; 0,-60], style(
              color=0,
              rgbcolor={0,0,0},
              fillColor=10,
              rgbfillColor={95,95,95},
              fillPattern=1)),
          Line(points=[-80,-60; 80,-60], style(
              color=0,
              rgbcolor={0,0,0},
              thickness=2,
              fillColor=30,
              rgbfillColor={215,215,215},
              fillPattern=8))));

    equation
      if cardinality(stator) == 0 then
        stator.phi = 0;
      else
        rotor.tau + stator.tau + friction.tau = 0;
      end if;
      rotor.phi = phi - stator.phi;
      friction.phi = rotor.phi;
      J*a = rotor.tau + flange_p.tau + flange_n.tau + friction.tau;
    end RigidRotorCase;

  end Partials;

end Rotation;
