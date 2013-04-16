package Translation "Translating parts "
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

  package Ports
    "One- and two-flange base for translating mechanical components."
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
<p>Contains mechanical one and two-ports with translational connectors.</p>
</html>"),
    Icon);

  partial model Flange_p "One coupling, 'positive'"

    Base.Interfaces.Translation_p flange "positive flange"
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

  partial model Flange_n "One coupling, 'negative'"

    Base.Interfaces.Translation_n flange "negative flange"
                                     annotation (extent=[90,-10; 110,10]);
    annotation (
  Icon(Text(
      extent=[-100,-100; 100,-140],
      string="%name",
      style(color=0))),
  Diagram,
  Documentation(info="<html>
</html>"));
  end Flange_n;

  partial model Flange_p_n "Two coupling"

    Base.Interfaces.Translation_p flange_p "positive flange"
  annotation (extent=[-110,-10; -90,10]);
    Base.Interfaces.Translation_n flange_n "negative flange"
  annotation (extent=[90,-10; 110,10]);
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

    parameter SI.Length d=0 "signed distance (flange_n.s - flange_p.s)";
    annotation (
  Icon,
  Diagram,
  Documentation(info="<html>
</html>"));

  equation
    flange_n.s - flange_p.s = d;
  end Rigid;

  partial model Compliant "Compliant two-flange"
    extends Flange_p_n;

    parameter SI.Length d=1 "signed distance (coupl_n.s - coupl_p.s)";
    SI.Distance d_s "difference length (elongation)";
    SI.Force d_f "elongation force";
    annotation (
  Icon,
  Diagram,
  Documentation(info="<html>
</html>"));

  equation
    flange_n.s - flange_p.s = d + d_s;
    flange_n.f - flange_p.f = 2*d_f;
  end Compliant;

  end Ports;

  model Speed "Translation with given velocity"
    extends Ports.Flange_n;

    parameter SI.Time tcst(min=1e-9)=0.1 "time-constant";
    parameter Base.Types.SourceType scType=Base.Types.par
      "v: parameter or signal"
     annotation(Evaluate=true);
    parameter SI.Velocity v0=1 "velocity"
     annotation(Dialog(enable=scType==Base.Types.par));
    Modelica.Blocks.Interfaces.RealInput v(redeclare type SignalType =
          SI.Velocity) "(signal velocity)"
    annotation (extent=[-110,-10; -90,10]);
  protected
    SI.Angle s_dot(start=v0);
    annotation (defaultComponentName = "speed1",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Icon(
     Polygon(points=[-90,10; 20,10; 20,41; 90,0; 20,-41; 20,-10; -90,-10; -90,
              10],    style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=9,
          rgbfillColor={175,175,175}))),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>'flange' moves with parameter-velocity v0 or with signal-velocity v, depending on 'scType'.<br>
This is a \"soft\" speed, using a differential equation.<br>
The start value is always given by <tt>v0</tt>.</p>
</html>
"), Diagram(Text(
        extent=[-50,10; 50,-10],
        style(color=74, rgbcolor={0,0,127}),
          string="signal-speed v"),
            Text(
        extent=[-70,70; 70,50],
        style(color=74, rgbcolor={0,0,127}),
          string="parameter-speed v0"),
      Line(points=[-90,0; -60,0],     style(color=74, rgbcolor={0,0,127})),
            Text(
        extent=[-20,40; 20,20],
        style(color=74, rgbcolor={0,0,127}),
        string="or")));

  equation
    der(flange.s) = s_dot;
    der(s_dot) = if scType == Base.Types.par then (v0 - s_dot)/tcst else (v - s_dot)/tcst;
  end Speed;

  model Force "Driving force"
    extends Ports.Flange_n;

    parameter Base.Types.SourceType scType=Base.Types.par
      "f: parameter or signal"
     annotation(Evaluate=true);
    parameter SI.Force f0=1 "force"
     annotation(Dialog(enable=scType==Base.Types.par));
    Modelica.Blocks.Interfaces.RealInput f(redeclare type SignalType = SI.Force)
      "(signal force)"
    annotation (extent=[-110,-10; -90,10]);
    annotation (defaultComponentName = "force1",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Icon(
     Polygon(points=[-90,10; 20,10; 20,41; 90,0; 20,-41; 20,-10; -90,-10; -90,
              10],    style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=9,
          rgbfillColor={175,175,175}))),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>Force <tt>f</tt> acts in positive direction on the connected component if <tt>f > 0</tt>.</p>
</html>
"), Diagram(Text(
        extent=[-50,10; 50,-10],
        style(color=74, rgbcolor={0,0,127}),
        string="signal force f"),
            Text(
        extent=[-70,70; 70,50],
        style(color=74, rgbcolor={0,0,127}),
        string="parameter force f0"),
      Line(points=[-90,0; -60,0],     style(color=74, rgbcolor={0,0,127})),
            Text(
        extent=[-20,40; 20,20],
        style(color=74, rgbcolor={0,0,127}),
        string="or")));

  equation
    flange.f = if scType == Base.Types.par then -f0 else -f;
  end Force;

model TabTimeForce "Force using table (time... force)"
  extends Partials.TabForce;

  parameter SI.Time t_unit=1 "unit of 'time' in tab";
  parameter SI.Force f_unit=1 "unit of 'force' in tab";
  parameter Real[2] t_bd(unit="tab-unit")={0,1} "{first, last} time in tab";
  parameter Integer drive_load=1 "driving or load"
    annotation(choices(
    choice=1 "driving force (+1)", choice=-1 "load force (-1)"));
  parameter Integer direction(min=-1,max=1)=1 "forward or backward in time"
    annotation(choices(
    choice=1 "t_first --> t_last", choice=-1 "t_first <-- t_last"));
  parameter Boolean scale=false "scale time and force";
  parameter SI.Time T=1 "scale duration to T"        annotation(Dialog(enable=scale));
  parameter SIpu.Percent f_perc=100 "scale tab force to f_perc"
                                                             annotation(Dialog(enable=scale));
  protected
  SI.Time t;
  final parameter Real t_factor=if scale then T/abs(t_bd[2]-t_bd[1]) else t_unit;
  final parameter Real f_factor=if scale then drive_load*0.01*f_perc*f_unit else drive_load*f_unit;

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
<p>The force is defined in a table as a function of time.
<pre>
  Column 1 contains the time in units <tt>t_unit</tt> (<tt>t_unit</tt> in \"s\").
  Column 'colData' contains the force in units <tt>f_unit</tt> (<tt>f_unit</tt> in \"N\").
</pre></p>
<p>Both time and force may be linearly scaled by a factor if 'scale = true'.</p>
<p>Flange_p and flange_n are rigidly connected. The force acts on the connected component(s) in
<pre>
positive direction, if f_table &gt  0 and drive_load = +1 or f_table &lt  0 and drive_load = -1
negative direction, if f_table &gt  0 and drive_load = -1 or f_table &lt  0 and drive_load = +1
</pre></p>
<p>Note: start integration at time = 0</p>
</html>
"), Icon,
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
  f = f_factor*table.y[1];

  when t > t_factor*t_bd[2] or t < t_factor*t_bd[1] then
    terminate("BOUNDARY TIME REACHED!");
  end when;
end TabTimeForce;

model TabPosSlopeForce "Force using table (position... slope)"
  extends Partials.TabForce;

  constant SI.Force g_n=Modelica.Constants.g_n;
  parameter SI.Length s_unit=1 "unit of 'position' in tab";
  parameter Real[2] s_bd(unit="tab-unit")={0,1} "{first, last} position in tab";
  parameter Integer dirTrack(min=-1,max=1)=+1 "forward or backward track"
    annotation(choices(
    choice=1 "first-pos ---> last-pos", choice=-1 "first-pos <--- last-pos"));
  parameter Integer dirVeh(min=-1,max=1)=+1
      "vehicle forward or backward driving"
    annotation(choices(
    choice=1 "forward", choice=-1 "backward"));
  parameter Boolean scale=false "scale position and slope";
  parameter SIpu.Length_km D=1 "scale distance to D" annotation(Dialog(enable=scale));
  parameter SIpu.Percent slope_perc=100 "scale slope to slope_perc"
    annotation(Dialog(enable=scale));
  parameter SI.Mass mass=1 "mass";
  parameter Real[2] cFrict(min={0,0}, unit="{N.s/m, N.s2/m2}")={0,0}
      "friction cst {lin, quadr}";
  SI.Length s;
  SI.Velocity vVeh "vehicle horizontal velocity";
  protected
  final parameter Real s_factor=if scale then 1e3*D/abs(s_bd[2]-s_bd[1]) else s_unit;
  final parameter Real slope_factor=if scale then 0.01*slope_perc else 1;
  final parameter Integer sig=dirTrack*dirVeh;
  Real slope;
  Real sin_gam;
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
<p>This model uses a position-slope table. It is mainly intended for test-purposes.</p>
<pre>
  Column 1 contains the (horizontal) position in units <tt>s_unit</tt> (<tt>s_unit</tt> in \"m\").
  Column 'colData' contains the slope dh/ds of a height profile in dimensionless units.
</pre></p>
<p>Both position and slope may be linearly scaled by a factor if 'scale = true' (for example using a normalised height-profile).</p>
The force load as a function of position <tt>s</tt> corresponds to a mass moving along a height profile with linear and quadratic friction. Flange_p and flange_n are rigidly connected.</p>
<p>Note: If the height h is also needed, it has to be scaled with the factor (slope_perc/100)*D.<br>
Start integration at time = 0.</p>
</html>
"), Icon(
      Polygon(points=[-38,-10; -38,-10],
                                       style(
          color=10,
          rgbcolor={255,250,110})),
      Polygon(points=[-40,90; -60,70; 60,90; 40,103; -40,90],
                                                           style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=10,
            rgbfillColor={135,135,135})),
      Polygon(points=[-60,60; -80,40; 40,60; 60,80; -60,60],   style(
          color=10,
          rgbcolor={95,95,95},
          fillColor=10,
          rgbfillColor={95,95,95},
          fillPattern=1)),
        Polygon(points=[-60,70; -60,60; 60,80; 60,90; -60,70],   style(
            color=1,
            rgbcolor={255,0,0},
            fillColor=1,
            rgbfillColor={255,0,0}))),
    Diagram);

initial equation
  s = if dirTrack == 1 then s_factor*s_bd[1] else s_factor*s_bd[2];

equation
  s = flange_p.s;
  vVeh = sig*der(s);
  table.u = s/s_factor;
  slope = slope_factor*table.y[1];
  sin_gam = slope/sqrt(1 + slope*slope); // = sin(atan(slope))
  mass*der(vVeh) = -(f + sig*mass*g_n*sin_gam + (cFrict[1] + cFrict[2]*abs(vVeh))*vVeh);

  when s > s_factor*s_bd[2] or s < s_factor*s_bd[1] then
    terminate("BOUNDARY POSITION REACHED!");
  end when;
end TabPosSlopeForce;

  model FrictionForce "Friction force"
    extends Ports.Flange_p;

    parameter Real[2] cFrict(min={0,0}, unit="{N.s/m, N.s2/m2}")={0,0}
      "friction cst {lin, quadr}";
    SI.Angle s;
    SI.Velocity v;
  annotation (defaultComponentName = "frictForce1",
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
<p>Linear and quadratic friction force <tt>f</tt>.</p>
<pre>
  f = c_frict[1]*v + c_frict[2]*abs(v)*v
  v   velocity
</pre>
</html>"),
    Icon(
      Polygon(points=[-38,20; -38,20], style(
          color=10,
          rgbcolor={255,250,110})),
      Polygon(points=[-30,25; -50,5; 70,5; 90,25; -30,25],  style(
          color=10,
          rgbcolor={95,95,95},
          fillColor=10,
          rgbfillColor={135,135,135})),
      Rectangle(extent=[-50,5; 60,-5], style(
          color=1,
          rgbcolor={255,0,0},
          fillColor=1,
          rgbfillColor={255,0,0},
          fillPattern=1)),
      Polygon(points=[-60,-5; -80,-25; 40,-25; 60,-5; -60,-5], style(
          color=10,
          rgbcolor={95,95,95},
          fillColor=10,
          rgbfillColor={95,95,95},
          fillPattern=1)),
      Line(points=[-80,0; -60,0; -60,14; -40,14],     style(color=10,
            rgbcolor={95,95,95}))),
    Diagram);

  equation
    s = flange.s;
    v = der(s);
    flange.f = (cFrict[1] + cFrict[2]*abs(v))*v;
  end FrictionForce;

model FixedPosition "Flange at fixed linear position"

  parameter SI.Angle s0=0 "position";
  Base.Interfaces.Translation_p flange
                                    annotation (extent=[-10,-10; 10,10]);
  annotation (defaultComponentName = "fixPos1",
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
      Line(points=[-60,-60; 60,-60], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Polygon(points=[-10,-40; 0,-60; 10,-40; -10,-40], style(
          color=10,
          rgbcolor={95,95,95},
          fillColor=44,
          rgbfillColor={255,170,170},
          fillPattern=1)),
     Text(
    extent=[-100,-100; 100,-140],
    string="%name",
    style(color=0))),
    Documentation(info="<html>
<p>Fixes the position variable <tt>s</tt> of a connected flange to a parameter value <tt>s0</tt>.</p>
</html>
"), Diagram);

equation
  flange.s = s0;
end FixedPosition;

model Body "Rigid body, translating mass"
  extends Partials.RigidBodyBase;

  Base.Interfaces.Translation_n friction "access for friction model"
annotation (extent=[-10,-50; 10,-70], rotation=-90);
  annotation (defaultComponentName = "body",
    Coordsys(
extent=[-100, -100; 100, 100],
grid=[2, 2],
component=[20, 20]),
    Window(
x=0.45,
y=0.01,
width=0.44,
height=0.65),
    Diagram(
      Line(points=[-80,-60; 80,-60], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2,
          fillColor=30,
          rgbfillColor={215,215,215},
          fillPattern=8))),
    Icon(Polygon(points=[-100,-20; -80,70; 80,70; 100,-20; -100,-20], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=10,
            rgbfillColor={135,135,135},
            fillPattern=1))),
    Documentation(
            info="<html>
<p>Translating rigid mass with access for friction-force on body.</p>
</html>
"));

equation
  friction.s = s;
  m*a = flange_p.f + flange_n.f + friction.f;
end Body;

  model TractionWheel "Traction wheel"

    parameter SI.Inertia J=1 "inertia wheel";
    parameter SI.Radius r=1 "radius wheel";
    SI.Angle phi "rotation angle wheel";
    SI.AngularVelocity w;
    SI.AngularAcceleration a;
    Base.Interfaces.Rotation_p wheel "to torque source, (driving axle)"
                                annotation (extent=[-110,-10; -90,10]);
    Base.Interfaces.Translation_n frame "to loc-body (delivers tractive force)"
      annotation (extent=[90,-10; 110,10], rotation=0);
    Base.Interfaces.Translation_p rail "to rail-wheel friction model"
      annotation (extent=[10,-80; 30,-60], rotation=180);
    annotation (defaultComponentName = "wheel",
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
<p>The model relates traction force and torque on wheel, using a rail-wheel friction model.<br>
Connectors have to be connected as indicated below.</p>
<p>The connector variable <tt>rail.s</tt> fulfills
<pre>  der(rail.s) = v_slip = v_rotation - v_translation</pre>
with
<pre>
  v_rotation = r*der(phi),  phi   rotation angle of wheel
  v_translation = der(s),   s     position of wheel
</pre>
This choice avoids the introduction of a special connector with a velocity variable.</p>
</html>
"),   Icon(
        Rectangle(extent=[-90,75; -84,-75], style(
            color=10,
            rgbcolor={95,95,95},
            gradient=1,
            fillColor=9,
            rgbfillColor={175,175,175})),
        Polygon(points=[-84,60; -60,56; -60,-56; -84,-60; -84,60],
                                                                 style(
            color=10,
            rgbcolor={95,95,95},
            gradient=1,
            fillColor=9,
            rgbfillColor={175,175,175})),
        Ellipse(extent=[-54,74; 96,-74], style(
            color=30,
            rgbcolor={215,215,215},
            pattern=0,
            fillColor=9,
            rgbfillColor={175,175,175})),
        Ellipse(extent=[-40,60; 82,-60], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=10,
            rgbfillColor={135,135,135})),
        Rectangle(extent=[0,10; 90,-10], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=10,
            rgbfillColor={95,95,95})),
        Rectangle(extent=[-96,-104; 96,-140],
                                           style(
            color=7,
            rgbcolor={255,255,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
       Text(
      extent=[-100,-100; 100,-140],
      string="%name",
      style(color=0))),
      Diagram(
        Line(points=[15,-80; 15,-90], style(
            color=1,
            rgbcolor={255,0,0},
            gradient=2,
            fillColor=1,
            rgbfillColor={255,0,0})),
        Polygon(points=[15,-110; 5,-90; 25,-90; 15,-110], style(
            color=1,
            rgbcolor={255,0,0},
            gradient=2,
            fillColor=1,
            rgbfillColor={255,0,0})),
        Polygon(points=[95,90; 85,70; 105,70; 95,90], style(
            color=58,
            rgbcolor={0,127,0},
            gradient=2,
            fillColor=58,
            rgbfillColor={0,127,0})),
        Polygon(points=[-90,0; -70,-10; -70,10; -90,0], style(
            color=71,
            rgbcolor={85,170,255},
            gradient=2,
            fillColor=71,
            rgbfillColor={85,170,255})),
        Line(points=[-70,0; -40,0], style(
            color=71,
            rgbcolor={85,170,255},
            gradient=2,
            fillColor=71,
            rgbfillColor={85,170,255})),
        Line(points=[95,10; 95,70], style(
            color=58,
            rgbcolor={0,127,0},
            gradient=2,
            fillColor=58,
            rgbfillColor={0,127,0})),
        Text(
          extent=[-100,30; -40,20],
          string="'axle'.flange",
          style(
            color=71,
            rgbcolor={85,170,255},
            gradient=2,
            fillColor=71,
            rgbfillColor={85,170,255})),
        Text(
          extent=[-100,90; -40,80],
          string="connect to:",
          style(
            color=0,
            rgbcolor={0,0,0},
            gradient=2,
            fillColor=71,
            rgbfillColor={85,170,255})),
        Rectangle(extent=[-30,5; 50,-5],   style(
            color=10,
            rgbcolor={95,95,95},
            gradient=2,
            fillColor=9,
            rgbfillColor={175,175,175})),
        Rectangle(extent=[-6,80; 0,-80],    style(
            color=10,
            rgbcolor={95,95,95},
            gradient=1,
            fillColor=9,
            rgbfillColor={175,175,175})),
        Polygon(points=[0,64; 34,61; 34,-60; 0,-64; 0,64],       style(
            color=10,
            rgbcolor={95,95,95},
            gradient=1,
            fillColor=9,
            rgbfillColor={175,175,175})),
        Text(
          extent=[35,60; 95,50],
          string="'locBbody'.flange",
          style(
            color=58,
            rgbcolor={0,127,0},
            gradient=2,
            fillColor=58,
            rgbfillColor={0,127,0})),
        Text(
          extent=[39,-90; 99,-100],
          string="'friction'.rail",
          style(
            color=1,
            rgbcolor={255,0,0},
            gradient=2,
            fillColor=1,
            rgbfillColor={255,0,0}))));

  equation
    rail.f - frame.f = 0;
    rail.s = r*wheel.phi - frame.s;
    phi = wheel.phi;
    w = der(phi);
    a = der(w);
    J*a = wheel.tau + r*rail.f;
  end TractionWheel;

model RodNoMass "Elastic massless rod"
  extends Ports.Compliant;

  parameter SIpu.Stiffness stiff=1e6 "stiffness";
  annotation (defaultComponentName = "rod",
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
<p>Translating elastic massless rod. It is equivalent to a massless spring.<br><br>
The parameter <tt>stiffness</tt> is a length-independent specification, in contrast to a spring-constant.</p>
</html>
"), Icon(
   Rectangle(extent=[-90,10; 90,-10],   style(
          color=0,
          rgbcolor={0,0,0},
          gradient=2,
          fillColor=7,
          rgbfillColor={255,255,255}))),
    Diagram);

equation
  flange_p.f + flange_n.f = 0;
  d_f = stiff*d_s/d;
end RodNoMass;

model Rod "Elastic massive rod"
  extends Ports.Compliant;

  parameter SI.Mass m=1 "mass";
  parameter SIpu.Stiffness stiff=1e6 "stiffness";
  SI.Position s "position center";
  SI.Velocity v;
  SI.Acceleration a;
  annotation (defaultComponentName = "rod",
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
<p>Translating elastic massive rod. It is equivalent to a massive spring.<br>
(Approximation for small strain / lowest mode to avoid wave-equation)<br><br>
The parameter <tt>stiffness</tt> is a length-independent specification, in contrast to a spring-constant.</p>
</html>"),
    Icon(
   Rectangle(extent=[-90,10; 90,-10],   style(
          color=0,
          rgbcolor={0,0,0},
          gradient=2,
          fillColor=9,
          rgbfillColor={175,175,175}))),
    Diagram);

equation
  flange_p.s + flange_n.s = 2*s;
  v = der(s);
  a = der(v);
  m*a = flange_p.f + flange_n.f;
  d_f = stiff*d_s/d;
end Rod;

  model PositionSensor "Position and velocity sensor (mechanical)"
    extends Ports.Flange_p;

    Modelica.Blocks.Interfaces.RealOutput s(redeclare type SignalType =
      SI.Position) "position"
    annotation (
          extent=[-50,90; -30,110],  rotation=90);
    Modelica.Blocks.Interfaces.RealOutput v(redeclare type SignalType =
          SI.Velocity) "velocity"
    annotation (
          extent=[30,90; 50,110],    rotation=90);
  annotation (defaultComponentName = "positionSens1",
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
</html>
"), Icon(
        Text(
  extent=[-100,-100; 100,-140],
  string="%name",
  style(color=0)),
        Rectangle(extent=[-80,-60; 80,60], style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Line(points=[0,60; 0,30], style(color=10)),
        Line(points=[-60,60; -60,30], style(color=10)),
        Line(points=[60,60; 60,30], style(color=10)),
        Line(points=[30,60; 30,30], style(color=10)),
        Line(points=[-30,60; -30,30], style(color=10)),
        Polygon(points=[5,20; 25,20; 15,48; 5,20], style(
    color=10,
    fillColor=10,
    fillPattern=1)),
        Line(points=[-90,0; 80,0], style(color=10, rgbcolor={135,135,135})),
        Line(points=[15,0; 15,20], style(color=10, rgbcolor={95,95,95})),
        Rectangle(extent=[10,5; 20,-5], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=10,
            rgbfillColor={135,135,135}))),
    Diagram);

  equation
    flange.f = 0;
    s = flange.s;
    v = der(flange.s);
  end PositionSensor;

  model PowerSensor "Power and torque sensor (mechanical)"
    extends Ports.Rigid(final d=0);

    Modelica.Blocks.Interfaces.RealOutput p(redeclare type SignalType =
      SI.Power) "power, flange_p to flange_n"
    annotation (
          extent=[-50,90; -30,110],  rotation=90);
    Modelica.Blocks.Interfaces.RealOutput f(redeclare type SignalType =
          SI.Force) "force, flange_p to flange_n"
    annotation (
          extent=[30,90; 50,110],    rotation=90);
  annotation (defaultComponentName = "powerSens1",
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
</html>
"), Icon(
        Text(
  extent=[-100,-100; 100,-140],
  string="%name",
  style(color=0)),
        Rectangle(extent=[-80,-60; 80,60], style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Line(points=[0,60; 0,40], style(color=10)),
        Line(points=[-60,60; -60,40], style(color=10)),
        Line(points=[60,60; 60,40], style(color=10)),
        Line(points=[30,60; 30,40], style(color=10)),
        Line(points=[-30,60; -30,40], style(color=10)),
        Rectangle(extent=[-20,16; 20,-16], style(color=10, rgbcolor={95,95,95})),
      Line(
   points=[-90,0; -20,0], style(color=10, rgbcolor={95,95,95})),
      Line(
   points=[0,0; 90,0], style(color=10, rgbcolor={95,95,95})),
      Line(
   points=[30,20; 70,0; 30,-20], style(color=10, rgbcolor={95,95,95}))),
    Diagram);

  equation
    flange_p.f + flange_n.f = 0;
    f = flange_p.f;
    p = der(flange_p.s)*flange_p.f;
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

    partial model TabForce "Table data to force"
      extends Ports.Flange_p_n;

      parameter String tableName="" "table name in file";
      parameter String fileName=TableDir "name of file containing table";
      parameter Integer colData=2 "column # used data";
      SI.Force f;

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
       Polygon(points=[-90,10; 20,10; 20,41; 90,0; 20,-41; 20,-10; -90,-10; -90,10],
                        style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=9,
            rgbfillColor={175,175,175})),
    Rectangle(extent=[-40,-80; 40,-60], style(color=10)),
    Line(points=[-40,-70; 40,-70], style(color=10)),
    Line(points=[-20,-60; -20,-80], style(color=10))),
        Diagram);

    equation
      flange_p.s = flange_n.s;
      flange_p.f + flange_n.f + f = 0;
    end TabForce;

    partial model RigidBodyBase "Rigid body base"
      extends Ports.Rigid;

      parameter SI.Mass m=1 "mass";
      SI.Position s "position center";
      SI.Velocity v;
      SI.Acceleration a;
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
</html>
"),     Icon,
        Diagram);

    equation
      flange_p.s + flange_n.s = 2*s;
      v = der(s);
      a = der(v);
    end RigidBodyBase;
  end Partials;

end Translation;
