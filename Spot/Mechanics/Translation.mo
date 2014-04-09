within Spot.Mechanics;
package Translation "Translating parts "
  extends Base.Icons.Library;


  package Ports
    "One- and two-flange base for translating mechanical components."
  extends Base.Icons.Base;


  partial model Flange_p "One coupling, 'positive'"

    Base.Interfaces.Translation_p flange "positive flange"
                                     annotation (Placement(transformation(
              extent={{-110,-10},{-90,10}}, rotation=0)));
    annotation (
  Icon(graphics={Text(
              extent={{-100,-100},{100,-140}},
              lineColor={0,0,0},
              textString=
             "%name")}),
  Documentation(info="<html>
</html>"));
  end Flange_p;

  partial model Flange_n "One coupling, 'negative'"

    Base.Interfaces.Translation_n flange "negative flange"
                                     annotation (Placement(transformation(
              extent={{90,-10},{110,10}}, rotation=0)));
    annotation (
  Icon(graphics={Text(
              extent={{-100,-100},{100,-140}},
              lineColor={0,0,0},
              textString=
             "%name")}),
  Documentation(info="<html>
</html>"));
  end Flange_n;

  partial model Flange_p_n "Two coupling"

    Base.Interfaces.Translation_p flange_p "positive flange"
  annotation (Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
    Base.Interfaces.Translation_n flange_n "negative flange"
  annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
    annotation (
  Icon(graphics={Text(
              extent={{-100,-100},{100,-140}},
              lineColor={0,0,0},
              textString=
             "%name")}),
  Documentation(info="<html>
</html>"));
  end Flange_p_n;

  partial model Rigid "Rigid two-flange"
    extends Flange_p_n;

    parameter SI.Length d=0 "signed distance (flange_n.s - flange_p.s)";

  equation
    flange_n.s - flange_p.s = d;
    annotation (
  Documentation(info="<html>
</html>"));
  end Rigid;

  partial model Compliant "Compliant two-flange"
    extends Flange_p_n;

    parameter SI.Length d=1 "signed distance (coupl_n.s - coupl_p.s)";
    SI.Distance d_s "difference length (elongation)";
    SI.Force d_f "elongation force";

  equation
    flange_n.s - flange_p.s = d + d_s;
    flange_n.f - flange_p.f = 2*d_f;
    annotation (
  Documentation(info="<html>
</html>"));
  end Compliant;

    annotation (
      preferredView="info",
  Documentation(info="<html>
<p>Contains mechanical one and two-ports with translational connectors.</p>
</html>"));
  end Ports;

  model Speed "Translation with given velocity"
    extends Ports.Flange_n;

    parameter SI.Time tcst(min=1e-9)=0.1 "time-constant";
    parameter Base.Types.SourceType scType=Base.Types.par
      "v: parameter or signal"
     annotation(Evaluate=true);
    parameter SI.Velocity v0=1 "velocity"
     annotation(Dialog(enable=scType==Base.Types.par));
    Modelica.Blocks.Interfaces.RealInput v "(signal velocity)" annotation (
        Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  protected
    SI.Angle s_dot(start=v0);

  equation
    der(flange.s) = s_dot;
    der(s_dot) = if scType == Base.Types.par then (v0 - s_dot)/tcst else (v - s_dot)/tcst;
    annotation (defaultComponentName = "speed1",
      Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Polygon(
            points={{-90,10},{20,10},{20,41},{90,0},{20,-41},{20,-10},{-90,-10},
                {-90,10}},
            lineColor={0,0,0},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid)}),
      Documentation(
              info="<html>
<p>'flange' moves with parameter-velocity v0 or with signal-velocity v, depending on 'scType'.<br>
This is a \"soft\" speed, using a differential equation.<br>
The start value is always given by <tt>v0</tt>.</p>
</html>
"), Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Text(
            extent={{-50,10},{50,-10}},
            lineColor={0,0,127},
            textString=
                 "signal-speed v"),
          Text(
            extent={{-70,70},{70,50}},
            lineColor={0,0,127},
            textString=
                 "parameter-speed v0"),
          Line(points={{-90,0},{-60,0}}, color={0,0,127}),
          Text(
            extent={{-20,40},{20,20}},
            lineColor={0,0,127},
            textString=
               "or")}));
  end Speed;

  model Force "Driving force"
    extends Ports.Flange_n;

    parameter Base.Types.SourceType scType=Base.Types.par
      "f: parameter or signal"
     annotation(Evaluate=true);
    parameter SI.Force f0=1 "force"
     annotation(Dialog(enable=scType==Base.Types.par));
    Modelica.Blocks.Interfaces.RealInput f "(signal force)" annotation (
        Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=0)));

  equation
    flange.f = if scType == Base.Types.par then -f0 else -f;
    annotation (defaultComponentName = "force1",
      Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Polygon(
            points={{-90,10},{20,10},{20,41},{90,0},{20,-41},{20,-10},{-90,-10},
                {-90,10}},
            lineColor={0,0,0},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid)}),
      Documentation(
              info="<html>
<p>Force <tt>f</tt> acts in positive direction on the connected component if <tt>f > 0</tt>.</p>
</html>
"), Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Text(
            extent={{-50,10},{50,-10}},
            lineColor={0,0,127},
            textString=
               "signal force f"),
          Text(
            extent={{-70,70},{70,50}},
            lineColor={0,0,127},
            textString=
               "parameter force f0"),
          Line(points={{-90,0},{-60,0}}, color={0,0,127}),
          Text(
            extent={{-20,40},{20,20}},
            lineColor={0,0,127},
            textString=
               "or")}));
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
  annotation (defaultComponentName = "tabForce1",
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
"));
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
  annotation (defaultComponentName = "tabForce1",
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
"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Polygon(points={{-38,-10},{-38,-10}}, lineColor={255,250,110}),
          Polygon(
            points={{-40,90},{-60,70},{60,90},{40,103},{-40,90}},
            lineColor={95,95,95},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-60,60},{-80,40},{40,60},{60,80},{-60,60}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-60,70},{-60,60},{60,80},{60,90},{-60,70}},
            lineColor={255,0,0},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid)}));
end TabPosSlopeForce;

  model FrictionForce "Friction force"
    extends Ports.Flange_p;

    parameter Real[2] cFrict(min={0,0}, unit="{N.s/m, N.s2/m2}")={0,0}
      "friction cst {lin, quadr}";
    SI.Angle s;
    SI.Velocity v;

  equation
    s = flange.s;
    v = der(s);
    flange.f = (cFrict[1] + cFrict[2]*abs(v))*v;
  annotation (defaultComponentName = "frictForce1",
    Documentation(
            info="<html>
<p>Linear and quadratic friction force <tt>f</tt>.</p>
<pre>
  f = c_frict[1]*v + c_frict[2]*abs(v)*v
  v   velocity
</pre>
</html>"),
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Polygon(points={{-38,20},{-38,20}}, lineColor={255,250,110}),
          Polygon(
            points={{-30,25},{-50,5},{70,5},{90,25},{-30,25}},
            lineColor={95,95,95},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-50,5},{60,-5}},
            lineColor={255,0,0},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-60,-5},{-80,-25},{40,-25},{60,-5},{-60,-5}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,0},{-60,0},{-60,14},{-40,14}}, color={95,95,95})}));
  end FrictionForce;

model FixedPosition "Flange at fixed linear position"

  parameter SI.Angle s0=0 "position";
  Base.Interfaces.Translation_p flange
                                    annotation (Placement(transformation(extent
            ={{-10,-10},{10,10}}, rotation=0)));

equation
  flange.s = s0;
  annotation (defaultComponentName = "fixPos1",
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-60,-60},{60,-60}}, color={0,0,0}),
          Polygon(
            points={{-10,-40},{0,-60},{10,-40},{-10,-40}},
            lineColor={95,95,95},
            fillColor={255,170,170},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,-100},{100,-140}},
            lineColor={0,0,0},
            textString=
           "%name")}),
    Documentation(info="<html>
<p>Fixes the position variable <tt>s</tt> of a connected flange to a parameter value <tt>s0</tt>.</p>
</html>
"));
end FixedPosition;

model Body "Rigid body, translating mass"
  extends Partials.RigidBodyBase;

  Base.Interfaces.Translation_n friction "access for friction model"
annotation (Placement(transformation(
          origin={0,-60},
          extent={{10,-10},{-10,10}},
          rotation=270)));

equation
  friction.s = s;
  m*a = flange_p.f + flange_n.f + friction.f;
  annotation (defaultComponentName = "body",
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Line(
            points={{-80,-60},{80,-60}},
            color={0,0,0},
            thickness=0.5)}),
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Polygon(
            points={{-100,-20},{-80,70},{80,70},{100,-20},{-100,-20}},
            lineColor={0,0,0},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid)}),
    Documentation(
            info="<html>
<p>Translating rigid mass with access for friction-force on body.</p>
</html>
"));
end Body;

  model TractionWheel "Traction wheel"

    parameter SI.Inertia J=1 "inertia wheel";
    parameter SI.Radius r=1 "radius wheel";
    SI.Angle phi "rotation angle wheel";
    SI.AngularVelocity w;
    SI.AngularAcceleration a;
    Base.Interfaces.Rotation_p wheel "to torque source, (driving axle)"
                                annotation (Placement(transformation(extent={{
              -110,-10},{-90,10}}, rotation=0)));
    Base.Interfaces.Translation_n frame "to loc-body (delivers tractive force)"
      annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation
            =0)));
    Base.Interfaces.Translation_p rail "to rail-wheel friction model"
      annotation (Placement(transformation(
          origin={20,-70},
          extent={{-10,-10},{10,10}},
          rotation=180)));

  equation
    rail.f - frame.f = 0;
    rail.s = r*wheel.phi - frame.s;
    phi = wheel.phi;
    w = der(phi);
    a = der(w);
    J*a = wheel.tau + r*rail.f;
    annotation (defaultComponentName = "wheel",
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
"),   Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Rectangle(
            extent={{-90,75},{-84,-75}},
            lineColor={0,0,0},
            fillPattern=FillPattern.VerticalCylinder,
            fillColor={175,175,175}),
          Polygon(
            points={{-84,60},{-60,56},{-60,-56},{-84,-60},{-84,60}},
            lineColor={0,0,0},
            fillPattern=FillPattern.VerticalCylinder,
            fillColor={175,175,175}),
          Ellipse(
            extent={{-54,74},{96,-74}},
            lineColor={215,215,215},
            pattern=LinePattern.None,
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-40,60},{82,-60}},
            lineColor={0,0,0},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{0,10},{90,-10}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-96,-104},{96,-140}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,-100},{100,-140}},
            lineColor={0,0,0},
            textString=
             "%name")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{15,-80},{15,-90}}, color={0,0,0}),
          Polygon(
            points={{15,-110},{5,-90},{25,-90},{15,-110}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={255,0,0}),
          Polygon(
            points={{95,90},{85,70},{105,70},{95,90}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={0,127,0}),
          Polygon(
            points={{-90,0},{-70,-10},{-70,10},{-90,0}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={85,170,255}),
          Line(points={{-70,0},{-40,0}}, color={0,0,0}),
          Line(points={{95,10},{95,70}}, color={0,0,0}),
          Text(
            extent={{-100,30},{-40,20}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={85,170,255},
            textString=
                 "'axle'.flange"),
          Text(
            extent={{-100,90},{-40,80}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={85,170,255},
            textString=
                 "connect to:"),
          Rectangle(
            extent={{-30,5},{50,-5}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={175,175,175}),
          Rectangle(
            extent={{-6,80},{0,-80}},
            lineColor={0,0,0},
            fillPattern=FillPattern.VerticalCylinder,
            fillColor={175,175,175}),
          Polygon(
            points={{0,64},{34,61},{34,-60},{0,-64},{0,64}},
            lineColor={0,0,0},
            fillPattern=FillPattern.VerticalCylinder,
            fillColor={175,175,175}),
          Text(
            extent={{35,60},{95,50}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={0,127,0},
            textString=
                 "'locBbody'.flange"),
          Text(
            extent={{39,-90},{99,-100}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={255,0,0},
            textString=
                 "'friction'.rail")}));
  end TractionWheel;

model RodNoMass "Elastic massless rod"
  extends Ports.Compliant;

  parameter SIpu.Stiffness stiff=1e6 "stiffness";

equation
  flange_p.f + flange_n.f = 0;
  d_f = stiff*d_s/d;
  annotation (defaultComponentName = "rod",
    Documentation(
            info="<html>
<p>Translating elastic massless rod. It is equivalent to a massless spring.<br><br>
The parameter <tt>stiffness</tt> is a length-independent specification, in contrast to a spring-constant.</p>
</html>
"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{-90,10},{90,-10}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={255,255,255})}));
end RodNoMass;

model Rod "Elastic massive rod"
  extends Ports.Compliant;

  parameter SI.Mass m=1 "mass";
  parameter SIpu.Stiffness stiff=1e6 "stiffness";
  SI.Position s "position center";
  SI.Velocity v;
  SI.Acceleration a;

equation
  flange_p.s + flange_n.s = 2*s;
  v = der(s);
  a = der(v);
  m*a = flange_p.f + flange_n.f;
  d_f = stiff*d_s/d;
  annotation (defaultComponentName = "rod",
    Documentation(
            info="<html>
<p>Translating elastic massive rod. It is equivalent to a massive spring.<br>
(Approximation for small strain / lowest mode to avoid wave-equation)<br><br>
The parameter <tt>stiffness</tt> is a length-independent specification, in contrast to a spring-constant.</p>
</html>"),
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{-90,10},{90,-10}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={175,175,175})}));
end Rod;

  model PositionSensor "Position and velocity sensor (mechanical)"
    extends Ports.Flange_p;

    Modelica.Blocks.Interfaces.RealOutput s "position" annotation (Placement(
          transformation(
          origin={-40,100},
          extent={{-10,-10},{10,10}},
          rotation=90)));
    Modelica.Blocks.Interfaces.RealOutput v "velocity" annotation (Placement(
          transformation(
          origin={40,100},
          extent={{-10,-10},{10,10}},
          rotation=90)));

  equation
    flange.f = 0;
    s = flange.s;
    v = der(flange.s);
  annotation (defaultComponentName = "positionSens1",
    Documentation(
            info="<html>
</html>
"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Text(
            extent={{-100,-100},{100,-140}},
            lineColor={0,0,0},
            textString=
         "%name"),
          Rectangle(
            extent={{-80,-60},{80,60}},
            lineColor={135,135,135},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(points={{0,60},{0,30}}, color={128,128,128}),
          Line(points={{-60,60},{-60,30}}, color={128,128,128}),
          Line(points={{60,60},{60,30}}, color={128,128,128}),
          Line(points={{30,60},{30,30}}, color={128,128,128}),
          Line(points={{-30,60},{-30,30}}, color={128,128,128}),
          Polygon(
            points={{5,20},{25,20},{15,48},{5,20}},
            lineColor={128,128,128},
            fillColor={128,128,128},
            fillPattern=FillPattern.Solid),
          Line(points={{-90,0},{80,0}}, color={135,135,135}),
          Line(points={{15,0},{15,20}}, color={95,95,95}),
          Rectangle(
            extent={{10,5},{20,-5}},
            lineColor={95,95,95},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid)}));
  end PositionSensor;

  model PowerSensor "Power and torque sensor (mechanical)"
    extends Ports.Rigid(final d=0);

    Modelica.Blocks.Interfaces.RealOutput p "power, flange_p to flange_n"
      annotation (Placement(transformation(
          origin={-40,100},
          extent={{-10,-10},{10,10}},
          rotation=90)));
    Modelica.Blocks.Interfaces.RealOutput f "force, flange_p to flange_n"
      annotation (Placement(transformation(
          origin={40,100},
          extent={{-10,-10},{10,10}},
          rotation=90)));

  equation
    flange_p.f + flange_n.f = 0;
    f = flange_p.f;
    p = der(flange_p.s)*flange_p.f;
  annotation (defaultComponentName = "powerSens1",
    Documentation(
            info="<html>
</html>
"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Text(
            extent={{-100,-100},{100,-140}},
            lineColor={0,0,0},
            textString=
         "%name"),
          Rectangle(
            extent={{-80,-60},{80,60}},
            lineColor={135,135,135},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(points={{0,60},{0,40}}, color={128,128,128}),
          Line(points={{-60,60},{-60,40}}, color={128,128,128}),
          Line(points={{60,60},{60,40}}, color={128,128,128}),
          Line(points={{30,60},{30,40}}, color={128,128,128}),
          Line(points={{-30,60},{-30,40}}, color={128,128,128}),
          Rectangle(extent={{-20,16},{20,-16}}, lineColor={95,95,95}),
          Line(points={{-90,0},{-20,0}}, color={95,95,95}),
          Line(points={{0,0},{90,0}}, color={95,95,95}),
          Line(points={{30,20},{70,0},{30,-20}}, color={95,95,95})}));
  end PowerSensor;

  package Partials "Partial models"
    extends Base.Icons.Partials;


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
        annotation (Placement(transformation(extent={{-20,-20},{20,20}},
              rotation=0)));

    equation
      flange_p.s = flange_n.s;
      flange_p.f + flange_n.f + f = 0;
      annotation (defaultComponentName = "tabForce1",
        Documentation(
                info="<html>
</html>
"),     Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Polygon(
              points={{-90,10},{20,10},{20,41},{90,0},{20,-41},{20,-10},{-90,
                  -10},{-90,10}},
              lineColor={0,0,0},
              fillColor={175,175,175},
              fillPattern=FillPattern.Solid),
            Rectangle(extent={{-40,-80},{40,-60}}, lineColor={128,128,128}),
            Line(points={{-40,-70},{40,-70}}, color={128,128,128}),
            Line(points={{-20,-60},{-20,-80}}, color={128,128,128})}));
    end TabForce;

    partial model RigidBodyBase "Rigid body base"
      extends Ports.Rigid;

      parameter SI.Mass m=1 "mass";
      SI.Position s "position center";
      SI.Velocity v;
      SI.Acceleration a;

    equation
      flange_p.s + flange_n.s = 2*s;
      v = der(s);
      a = der(v);
      annotation (
        Documentation(
              info="<html>
</html>
"));
    end RigidBodyBase;
  end Partials;

  annotation (preferredView="info",
Documentation(info="<html>
</html>
"));
end Translation;
