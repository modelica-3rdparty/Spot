within Spot.ACabc;
package Inverters "Rectifiers and Inverters"
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
<p>The package contains passive rectifiers and switched/modulated inverters. Different implementations use:
<ul>
<li>Phase-modules (pairs of diodes or pairs of IGBT's with antiparallel diodes).</li>
<li>The switch-equation for ideal components.</li>
<li>The time-averaged switch-equation. As models based on single-switching are generally slow in simulation, alternative 'averaged' models are useful in cases, where details of current and voltage signals can be ignored.</li>
</ul>
<p>Thermal losses are proportional to the forward voltage drop V, which may depend on temperature.<br>
The temperature dependence is given by
<pre>  V(T) = Vf*(1 + cT[1]*(T - T0) + cT[2]*(T - T0)^2 + ...)</pre>
where <tt>Vf</tt> denotes the parameter value. With input <tt>cT</tt> empty, no temperature dependence of losses is calculated.</p>
<p>The switching losses are approximated by
<pre>
  h = Hsw_nom*v*i/(V_nom*I_nom)
  use:
  S_nom = V_nom*I_nom
</pre>
where <tt>Hsw_nom</tt> denotes the dissipated heat per switching operation at nominal voltage and current, averaged over 'on' and 'off'. The same temperature dependence is assumed as for Vf. A generalisation to powers of i and v is straightforward.</p>
<p>NOTE: actually the switching losses are only implemented for time-averaged components!</p>
</html>"),
    Icon);

block Select "Select frequency and voltage-phasor type"

  extends Base.Icons.Block;

  parameter Base.Types.FreqType fType=Base.Types.sys
      "f: system, parameter, signal"
    annotation(Evaluate=true);
  parameter SI.Frequency f=system.f "frequency"
    annotation(Dialog(enable=fType==Base.Types.par));
  parameter Base.Types.SourceType uType=Base.Types.par
      "uPhasor: parameter or signal"
   annotation(Evaluate=true);
  parameter Real u0=1 "voltage ampl pu vDC/2"
                                         annotation(Dialog(enable=uType==Base.Types.par));
  parameter SI.Angle alpha0=0 "phase angle" annotation(Dialog(enable=uType==Base.Types.par));

  Modelica.Blocks.Interfaces.RealInput[2] uPhasor "{abs(u), phase(u)}"
    annotation(extent=[50,90; 70,110],    rotation=-90);
  Modelica.Blocks.Interfaces.RealInput omega(redeclare type SignalType =
        SI.AngularFrequency) "ang frequency"
    annotation (extent=[-70,90; -50,110],rotation=-90);

  Modelica.Blocks.Interfaces.RealOutput[2] uPhasor_out
      "{abs(u), phase(u)} to inverter"
    annotation(extent=[50,-110; 70,-90],  rotation=-90);
  Modelica.Blocks.Interfaces.RealOutput theta_out(redeclare type SignalType =
        SI.Angle) "abs angle to inverter, der(theta)=omega"
    annotation(extent=[-70,-110; -50,-90],rotation=-90);
  outer System system;
  protected
  SI.Angle theta;

annotation (defaultComponentName="select1",
  Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]),
  Window(
        x=0,
        y=0.01,
        width=0.44,
        height=0.65),
  Documentation(
          info="<html>
<p>This is an optional component. If combined with an inverter, a structure is obtained that is equivalent to a voltage source.<br>
The component is not needed, if specific control components are available.</p>
</html>"),
  Icon(Text(
          extent=[-100,20; 100,-20],
          style(
            color=74,
            rgbcolor={0,0,127},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
        string="%name"),
      Rectangle(extent=[-80,-80; -40,-120], style(
            color=84,
            rgbcolor={213,170,255},
            fillColor=84,
            rgbfillColor={213,170,255}))),
  Diagram);

initial equation
  if fType == Base.Types.sig then
    theta = 0;
  end if;

equation
  if fType == Base.Types.sys then
    theta = system.theta;
  elseif fType == Base.Types.par then
    theta = 2*pi*f*(time - system.initime);
  elseif fType == Base.Types.sig then
    der(theta) = omega;
  end if;
  theta_out = theta;

  if uType == Base.Types.par then
    uPhasor_out[1] = u0;
    uPhasor_out[2] = alpha0;
  elseif uType == Base.Types.sig then
    uPhasor_out[1] = uPhasor[1];
    uPhasor_out[2] = uPhasor[2];
  end if;
end Select;

model Rectifier "Rectifier, 3-phase abc"
  extends Partials.AC_DC_base(heat(final m=3));

  replaceable Components.RectifierEquation rectifier "rectifier model"
                                                annotation (extent=[-10,-10; 10,10], choices(
    choice(redeclare Spot.ACabc.Inverters.Components.RectifierEquation
            rectifier "equation, with losses"),
    choice(redeclare Spot.ACabc.Inverters.Components.RectifierModular rectifier
            "modular, with losses")));

annotation (defaultComponentName="rectifier",
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
<p>Passive rectifier, allows choosing between equation-based and modular version.</p>
</html>
"),
  Icon,
  Diagram);

equation
  connect(AC, rectifier.AC)    annotation (points=[100,0; 10,0],   style(color=
            62, rgbcolor={0,120,120}));
  connect(rectifier.DC, DC)
      annotation (points=[-10,0; -100,0],
                                        style(color=3, rgbcolor={0,0,255}));
  connect(rectifier.heat, heat)
      annotation (points=[0,10; 0,100], style(color=42, rgbcolor={176,0,0}));
end Rectifier;

model RectifierAverage "Rectifier time-average, 3-phase abc"
  extends Partials.SwitchEquation(heat(final m=1));

  replaceable parameter Semiconductors.Ideal.SCparameter par(final Hsw_nom=0)
      "SC parameters"
    annotation (extent=[-80,-80;-60,-60]);
  parameter Real sigma=1 "power correction" annotation(choices(
    choice=1.0966227 "Sigma",
    choice=1.0 "1"));
  protected
  final parameter Real S_abs=sigma*(2*sqrt(6)/pi);
  final parameter SI.Resistance R_nom=par.V_nom/par.I_nom;
  Real cT;
  Real iAC2;
  annotation (defaultComponentName="rectifier",
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
    Icon(
        Text(
          extent=[-100,-70; 100,-90],
          style(color=42, rgbcolor={176,0,0}),
          string="average")),
    Diagram(
        Text(
          extent=[-40,-60; 40,-80],
          style(color=42, rgbcolor={176,0,0}),
          string="time average equation"),
      Polygon(
      points=[-10,-38; 0,-18; 10,-38; -10,-38], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Polygon(
      points=[-10,18; 0,38; 10,18; -10,18], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Line(
   points=[0,-18; 0,18],   style(color=3, rgbcolor={0,0,255})),
      Line(
   points=[-10,-18; 10,-18],   style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Line(
   points=[-10,38; 10,38],   style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Line(
   points=[0,0; 60,0],    style(color=3, rgbcolor={0,0,255})),
        Line(points=[-70,10; -60,10; -60,52; 0,52; 0,40], style(color=3,
              rgbcolor={0,0,255})),
        Line(points=[-70,-10; -60,-10; -60,-50; 0,-50; 0,-38], style(color=3,
              rgbcolor={0,0,255}))),
      Documentation(info="<html>
<p>Time-averaged passive rectifier, with power-correction.<br>
AC_power = DC_power.</p>
<p>sigma-correction (comparison of AC and DC voltage):
<pre>
   sigma=1.0966227

+) increase S_dqo:  better approximation at vAC smaller
   S_abs=(2*sqrt(6)/pi)*sigma

0) no correction:
   S_abs=(2*sqrt(6)/pi)

-) decrease S_dqo: better approximation at vAC larger
   S_abs=(2*sqrt(6)/pi)/sigma
</pre></p>
<p><i>This is not yet a solution with sufficient precision.</i></p>
</html>"));

equation
  cT = if size(par.cT_loss,1)==0 then 1 else loss(T[1]-par.T0_loss, par.cT_loss);
  iAC2 = AC.i*AC.i;

  switch_abc = S_abs*AC.i/(sqrt(iAC2) + 1e-5);
  v_abc = (vDC1 + cT*par.Vf)*switch_abc;

  Q_flow = {par.eps[1]*R_nom*iAC2 + (2*sqrt(6)/pi)*par.Vf*sqrt(iAC2)};
end RectifierAverage;

model Inverter "Complete modulator with inverter, 3-phase abc"
  extends Partials.AC_DC_base(heat(final m=3));

  Modelica.Blocks.Interfaces.RealInput theta(redeclare type SignalType =
    SI.Angle) "abs angle, der(theta)=omega"
    annotation (extent=[-70,90; -50,110],rotation=-90);
  Modelica.Blocks.Interfaces.RealInput[2] uPhasor "desired {abs(u), phase(u)}"
    annotation(extent=[50,90; 70,110],    rotation=-90);
  replaceable Control.Modulation.PWMasyn modulator
    extends Control.Modulation.Partials.ModulatorBase "modulator type"
    annotation (extent=[-10,40; 10,60], choices(
    choice(redeclare Spot.Control.Modulation.PWMasyn modulator "sine PWM asyn"),
    choice(redeclare Spot.Control.Modulation.PWMsyn modulator "sine PWM syn"),
    choice(redeclare Spot.Control.Modulation.PWMtab modulator
            "sine PWM syn tabulated"),
    choice(redeclare Spot.Control.Modulation.SVPWMasyn modulator "SV PWM asyn"),
    choice(redeclare Spot.Control.Modulation.SVPWMsyn modulator "SV PWM syn"),
    choice(redeclare Spot.Control.Modulation.SVPWM modulator
            "SV PWM (using control blocks)"),
    choice(redeclare Spot.Control.Modulation.BlockM modulator
            "block modulation (no PWM)")));
  replaceable Components.InverterSwitch inverter "inverter model"
    annotation (extent=[-10,-10; 10,10], choices(
    choice(redeclare Spot.ACabc.Inverters.Components.InverterSwitch inverter
            "switch, no diode, no losses"),
    choice(redeclare Spot.ACabc.Inverters.Components.InverterEquation inverter
            "equation, with losses"),
    choice(redeclare Spot.ACabc.Inverters.Components.InverterModular inverter
            "modular, with losses")));
  protected
  outer System system;

annotation (defaultComponentName="inverter",
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
<p>Four quadrant switched inverter with modulator. Fulfills the power balance:
<pre>  vAC*iAC = vDC*iDC</pre></p>
<p>The structure of this component is related that of a voltage source, with two minor differences:</p>
<p>1) <tt>theta</tt> is used instead of <tt>omega</tt> as input.</p>
<p>2) <tt>u_phasor</tt> is used instead of <tt>v_phasor</tt> defining the AC-voltage in terms of the DC voltage <tt>v_DC</tt> according to the following relations.</p>
<p>For sine modulation:
<pre>
  |v_AC| = u*sqrt(3/2)*v_DC/2     AC voltage norm

  u[1] &le  1 for pure sine-modulation, but u[1] &gt  1 possible.
  u[1] = 1 corresponds to AC single-phase amplitude = v_DC/2
</pre>
For space-vector modulation:
<pre>
  |v_AC| = u*sqrt(2/3)*v_DC       AC voltage norm

  u[1] &le  sqrt(3)/2 = 0.866: pure sine-pwm,
  sqrt(3)/2 &le  u[1] &le  1:  overmodulation (not implemented in this preliminary version).
  u[1] = sqrt(3)/2 corresponds to AC single-phase amplitude = v_DC/sqrt(3)
</pre>
For block modulation:
<pre>
  ampl(v_abc) = v_DC/2
  w     relative width (0 - 1)
  w = 2/3 corresponds to 'two phases on, one phase off'
  the relation between AC and DC voltage is independent of width
</pre></p>
</html>
"),
  Icon(                                   Rectangle(extent=[-80,120; -40,80], style(
            color=84,
            rgbcolor={213,170,255},
            fillColor=84,
            rgbfillColor={213,170,255}))),
  Diagram);

equation
  Connections.potentialRoot(AC.theta);
  if Connections.isRoot(AC.theta) then
    AC.theta = if system.synRef then {0, theta} else {theta, 0};
  end if;

  connect(AC, inverter.AC)     annotation (points=[100,0; 10,0],   style(color=
            62, rgbcolor={0,120,120}));
  connect(inverter.DC, DC)
      annotation (points=[-10,0; -100,0],
                                        style(color=3, rgbcolor={0,0,255}));
  connect(theta, modulator.theta)   annotation (points=[-60,100; -60,70; -6,70;
        -6,60],                                                                   style(
          color=74, rgbcolor={0,0,127}));
  connect(uPhasor, modulator.uPhasor)   annotation (points=[60,100; 60,70; 6,70;
        6,60],             style(color=74, rgbcolor={0,0,127}));
  connect(modulator.gates, inverter.gates)
      annotation (points=[-6,40; -6,10], style(color=5, rgbcolor={255,0,255}));
  connect(inverter.heat, heat)   annotation (points=[0,10; 0,20; 20,20; 20,80; 0,80;
          0,100], style(color=42, rgbcolor={176,0,0}));
end Inverter;

model InverterAverage "Inverter time-average, 3-phase abc"
  extends Partials.SwitchEquation(heat(final m=1));

  replaceable parameter Semiconductors.Ideal.SCparameter par "SC parameters"
    annotation (extent=[-80,-80;-60,-60]);
  parameter Integer modulation=1 "equivalent modulation :"
    annotation(Evaluate=true, choices(
    choice=1 "1: sine PWM, equivalent: v_DC(sine) = 4/3*v_DC(SV)",
    choice=2 "2: SV PWM,   equivalent: v_DC(SV) = 3/4*v_DC(sine)",
    choice=3 "3: block M"));
  parameter Boolean syn=false "synchronous, asynchronous"
    annotation(Evaluate=true, Dialog(enable=modulation<3), choices(
    choice=true "synchronous",
    choice=false "asynchronous"));
  parameter Integer m_carr(min=1)=1 "f_carr/f, pulses/period"
    annotation(Evaluate=true, Dialog(enable=syn and modulation<3));
  parameter SI.Frequency f_carr=1e3 "carrier frequency"
    annotation(Evaluate=true, Dialog(enable=not syn and modulation<3));
  parameter Real width0=2/3 "relative width, (0 - 1)"
    annotation(Dialog(enable=modulation==3));

  Modelica.Blocks.Interfaces.RealInput theta(redeclare type SignalType =
    SI.Angle) "abs angle, der(theta)=omega"
    annotation (extent=[-70,90; -50,110],rotation=-90);
  Modelica.Blocks.Interfaces.RealInput[2] uPhasor "desired {abs(u), phase(u)}"
    annotation(extent=[50,90; 70,110],    rotation=-90);
  protected
  outer System system;
  constant SI.Angle[3] phShift=(0:2)*2*pi/3 "phase shift";
  final parameter SI.Resistance R_nom=par.V_nom/par.I_nom;
  final parameter Real factor=
    if modulation==1 then 1 else
    if modulation==2 then (4/3) else
    if modulation==3 then (4/pi)*sin(width0*pi/2) else 0       annotation(Evaluate=true);
  SI.Angle phi;
  SI.Voltage Vloss;
  Real iAC2;
  Real cT;
  SI.Time hsw_nom;
  annotation (defaultComponentName="inverter",
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
    Icon(
        Text(
          extent=[-100,-70; 100,-90],
          style(color=42, rgbcolor={176,0,0}),
          string="average"),              Rectangle(extent=[-80,120; -40,80], style(
            color=84,
            rgbcolor={213,170,255},
            fillColor=84,
            rgbfillColor={213,170,255}))),
    Diagram(
        Text(
          extent=[-40,-60; 40,-80],
          style(color=42, rgbcolor={176,0,0}),
          string="time average equation"),
      Line(
   points=[30,-46; 30,46], style(color=3, rgbcolor={0,0,255})),
      Line(
   points=[20,-14; 40,-14], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Line(
   points=[20,34; 40,34], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
Line(points=[-30,0; 60,0], style(color=3, rgbcolor={0,0,255})),
      Polygon(
      points=[20,14; 30,34; 40,14; 20,14], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Polygon(
      points=[20,-34; 30,-14; 40,-34; 20,-34], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Line(
   points=[-30,-46; -30,46],
                           style(color=3, rgbcolor={0,0,255})),
      Polygon(
      points=[-40,34; -30,14; -20,34; -40,34], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Line(
   points=[-40,14; -20,14], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Line(
   points=[-30,14; -42,2], style(color=42, rgbcolor={176,0,0})),
      Polygon(
      points=[-40,-14; -30,-34; -20,-14; -40,-14], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Line(
   points=[-40,-34; -20,-34], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Line(
   points=[-30,-34; -42,-46], style(color=42, rgbcolor={176,0,0})),
        Line(points=[-70,10; -60,10; -60,46; 30,46], style(color=3, rgbcolor={0,
                0,255})),
        Line(points=[-70,-10; -60,-10; -60,-46; 30,-46], style(color=3,
              rgbcolor={0,0,255}))),
      Documentation(info="<html>
<p>Four quadrant time-averaged inverter with modulator. Fulfills the power balance:
<pre>  vAC*iAC = vDC*iDC</pre></p>
<p>The structure of this component is related that of a voltage source, with two minor differences:</p>
<p>1) <tt>theta</tt> is used instead of <tt>omega</tt> as input.</p>
<p>2) <tt>u_phasor</tt> is used instead of <tt>v_phasor</tt> defining the AC-voltage in terms of the DC voltage <tt>v_DC</tt> according to the following relations.</p>
<p>If equivalent to sine modulation:
<pre>
  |v_AC| = u*sqrt(3/2)*v_DC/2     AC voltage norm

  u[1] &le  1 for pure sine-modulation, but u[1] &gt  1 possible.
  u[1] = 1 corresponds to AC single-phase amplitude = v_DC/2
</pre></p>
<p>If equivalent to space-vector modulation:
<pre>
  |v_AC| = u*sqrt(2/3)*v_DC       AC voltage norm

  u[1] &le  sqrt(3)/2 = 0.866: pure sine-pwm,
  sqrt(3)/2 &le  u[1] &le  1:  overmodulation (not implemented in this preliminary version).
  u[1] = sqrt(3)/2 corresponds to AC single-phase amplitude = v_DC/sqrt(3)
</pre></p>
<p>If equivalent to block (rectangular) modulation:<br>
Note that this component works with the fundamental of the rectangular voltage.<br>
The method must be improved in this third case (in particular in context with inductive devices).
<pre>
  |v_AC| = u*(4/pi)*sin(width*pi/2)*sqrt(3/2)*v_DC/2    AC voltage norm of fundamental

  u[1] = 1 for block modulation without pwm, 0 &lt  width &lt  1
  u[1] &le  1 for block modulation with pwm.
  u[1] = 1 corresponds to AC single-phase amplitude = (4/pi)*sin(width*pi/2)*v_DC/2
</pre></p>
</html>"));

equation
  Connections.potentialRoot(AC.theta);
  if Connections.isRoot(AC.theta) then
    AC.theta = if system.synRef then {0, theta} else {theta, 0};
  end if;

  Vloss = if par.Vf<1e-3 then 0 else tanh(10*iDC1/par.I_nom)*2*par.Vf;
  iAC2 = AC.i*AC.i;
  cT = if size(par.cT_loss,1)==0 then 1 else loss(T[1]-par.T0_loss, par.cT_loss);
  hsw_nom = if syn then (2*par.Hsw_nom*m_carr/(pi*par.V_nom*par.I_nom))*der(theta) else
                        4*par.Hsw_nom*f_carr/(par.V_nom*par.I_nom);

  phi = AC.theta[1] + uPhasor[2] + system.alpha0;
  switch_abc = factor*uPhasor[1]*cos(fill(phi, 3) - phShift);
  v_abc = (vDC1 - cT*Vloss)*switch_abc;
// passive mode?

  Q_flow = {par.eps[1]*iAC2*R_nom +
                     (2*sqrt(6)/pi)*cT*(par.Vf + hsw_nom*abs(vDC1))*sqrt(iAC2)};
end InverterAverage;

package Components "Equation-based and modular components"
model RectifierEquation "Rectifier equation, 3-phase abc"
  extends Partials.SwitchEquation(heat(final m=3));

  replaceable parameter Semiconductors.Ideal.SCparameter par(final Hsw_nom=0)
        "SC parameters"
    annotation (extent=[-80,-80;-60,-60]);
    protected
  SI.Voltage[3] V;
  SI.Voltage[3] v "voltage in inertial abc representation";
  SI.Voltage[3] i_sc "current scaled to voltage in inertial abc representation";
  Real[3] s "arc-length on characteristic";
  Real[3] switch "switch function in inertial abc representation";
  Real[3,3] Rot = Spot.Base.Transforms.rotation_abc(AC.theta[2]);

  annotation (defaultComponentName="rectifier",
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
    Icon(
        Text(
          extent=[-60,-70; 60,-90],
          style(color=42, rgbcolor={176,0,0}),
        string="eq")),
    Diagram(
        Text(
          extent=[-40,-60; 40,-80],
          style(color=42, rgbcolor={176,0,0}),
          string="time resolved equation"),
      Polygon(
      points=[-10,-38; 0,-18; 10,-38; -10,-38], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Polygon(
      points=[-10,18; 0,38; 10,18; -10,18], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Line(
   points=[0,-18; 0,18],   style(color=3, rgbcolor={0,0,255})),
      Line(
   points=[-10,-18; 10,-18],   style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Line(
   points=[-10,38; 10,38],   style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Line(
   points=[0,0; 60,0],    style(color=3, rgbcolor={0,0,255})),
          Line(points=[-70,10; -60,10; -60,52; 0,52; 0,40], style(color=3,
                rgbcolor={0,0,255})),
          Line(points=[-70,-10; -60,-10; -60,-50; 0,-50; 0,-38], style(color=3,
                rgbcolor={0,0,255}))),
      Documentation(info="<html>
<p>Passive rectifier, based on switch-equation.<br>
Blocking losses are neglected in the expression of dissipated heat <tt>Q_flow</tt>.</p>
</html>"));

equation
  i_sc = Rot*AC.i*par.V_nom/par.I_nom;

  for k in 1:3 loop
    V[k] = if size(par.cT_loss,1)==0 then  vDC1 + par.Vf else vDC1 + par.Vf*loss(T[k]-par.T0_loss, par.cT_loss);
    if s[k] > V[k] then // vDC+ < vAC
      {v[k],i_sc[k]} = {par.eps[1]*s[k] + (1 - par.eps[1])*V[k], s[k] - (1 - par.eps[2])*V[k]};
    elseif s[k] < -V[k] then  // vAC < vDC-
      {v[k],i_sc[k]} = {par.eps[1]*s[k] - (1 - par.eps[1])*V[k], s[k] + (1 - par.eps[2])*V[k]};
    else // vDC- < vAC < vDC+
      {v[k],i_sc[k]} = {s[k],par.eps[2]*s[k]};
    end if;
    switch[k] = noEvent(sign(s[k]));
  end for;

  v_abc = transpose(Rot)*v;
  switch_abc = transpose(Rot)*switch;
  Q_flow = (v - switch*vDC1).*i_sc*par.I_nom/par.V_nom;
end RectifierEquation;

model RectifierModular "Rectifier modular, 3-phase"
  extends Partials.AC_DC_base(heat(final m=3));

  package SCpackage=Semiconductors.Ideal "SC package";
  replaceable parameter SCpackage.SCparameter par(final Hsw_nom=0)
        "SC parameters"
  annotation (extent=[-80,-80;-60,-60]);
  Nodes.ACabc_a_b_c acabc_a_b_c annotation (extent=[80,-10; 60,10]);
  Common.Thermal.Heat_a_b_c_abc heat_adapt annotation (extent=[-10,70; 10,90]);
  Semiconductors.PhaseModules.DiodeModule diodeMod_a(par=par)
        "diode module AC_a"
      annotation (extent=[-10,30; 10,50]);
  Semiconductors.PhaseModules.DiodeModule diodeMod_b(par=par)
        "diode module AC_b"
      annotation (extent=[-10,-10; 10,10]);
  Semiconductors.PhaseModules.DiodeModule diodeMod_c(par=par)
        "diode module AC_c"
      annotation (extent=[-10,-50; 10,-30]);

annotation (defaultComponentName="rectifier",
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
<p>Passive rectifier, using diode-modules.</p>
</html>
"),
  Icon( Text(
          extent=[-100,-70; 100,-90],
          style(color=42, rgbcolor={176,0,0}),
        string="modular")),
  Diagram);

equation
  connect(AC, acabc_a_b_c.term) annotation (points=[100,0; 80,0],   style(color=
           62, rgbcolor={0,120,120}));
  connect(acabc_a_b_c.term_a, diodeMod_a.AC) annotation (points=[60,4; 40,4; 40,
            40; 10,40],    style(color=3, rgbcolor={0,0,255}));
  connect(acabc_a_b_c.term_b, diodeMod_b.AC)
      annotation (points=[60,0; 10,0],   style(color=3, rgbcolor={0,0,255}));
  connect(acabc_a_b_c.term_c, diodeMod_c.AC) annotation (points=[60,-4; 40,-4;
            40,-40; 10,-40], style(color=3, rgbcolor={0,0,255}));
  connect(diodeMod_a.DC, DC) annotation (points=[-10,40; -40,40; -40,0; -100,0],
        style(color=3, rgbcolor={0,0,255}));
  connect(diodeMod_b.DC, DC)
      annotation (points=[-10,0; -100,0],
                                        style(color=3, rgbcolor={0,0,255}));
  connect(diodeMod_c.DC, DC) annotation (points=[-10,-40; -40,-40; -40,0; -100,
            0],
        style(color=3, rgbcolor={0,0,255}));
  connect(diodeMod_a.heat, heat_adapt.port_a) annotation (points=[0,50; 0,60;
            -4,60; -4,74], style(color=42, rgbcolor={176,0,0}));
  connect(diodeMod_b.heat, heat_adapt.port_b) annotation (points=[0,10; 0,20;
            20,20; 20,64; 0,64; 0,74], style(color=42, rgbcolor={176,0,0}));
  connect(diodeMod_c.heat, heat_adapt.port_c) annotation (points=[0,-30; 0,-20;
            30,-20; 30,74; 4,74], style(color=42, rgbcolor={176,0,0}));
  connect(heat_adapt.port_abc, heat)
        annotation (points=[0,86; 0,100], style(color=42, rgbcolor={176,0,0}));
end RectifierModular;
  extends Base.Icons.Library;
  annotation (preferedView="info",
        Coordsys(
extent=[-100, -100; 100, 100],
grid=[2, 2],
component=[20, 20]), Window(
x=0.05,
y=0.44,
width=0.31,
height=0.26,
library=1,
autolayout=1),
    Documentation(info="<html>
<p>Contains alternative components:
<ul>
<li>Equation-based: faster code, restricted to ideal V-I characteristic, but including forward threshold voltage, needed for calculation of thermal losses.</li>
<li>Modular: composed from semiconductor-switches and diodes. These components with ideal V-I characteristic can be replaced by custom-specified semiconductor models.</li>
</ul>
</html>"));

model InverterSwitch "Inverter switch, 3-phase abc"
  extends Partials.SwitchEquation(heat(final m=3));

  Modelica.Blocks.Interfaces.BooleanInput[6] gates
        "gates pairs {a_p, a_n, b_p, b_n, c_p, c_n}"
  annotation (
        extent=[-70,90; -50,110],  rotation=-90);
    protected
  constant Integer[3] pgt={1,3,5} "positive gates";
  constant Integer[3] ngt={2,4,6} "negative gates";
  SI.Voltage[3] v "voltage in inertial abc representation";
  Real[3] switch "switch function in inertial abc representation";
  Real[3,3] Rot = Spot.Base.Transforms.rotation_abc(AC.theta[2]);

  annotation (defaultComponentName="inverter",
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
    Icon(
        Text(
          extent=[-60,-70; 60,-90],
          style(color=42, rgbcolor={176,0,0}),
        string="switch")),
    Diagram(
        Text(
          extent=[-40,-60; 40,-80],
          style(color=42, rgbcolor={176,0,0}),
        string="switch, no diode"),
Line(points=[0,0; 60,0],   style(color=3, rgbcolor={0,0,255})),
      Line(
   points=[0,-46; 0,46],   style(color=3, rgbcolor={0,0,255})),
      Polygon(
      points=[-10,34; 0,14; 10,34; -10,34],    style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Line(
   points=[-10,14; 10,14],  style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Line(
   points=[0,14; -12,2],   style(color=42, rgbcolor={176,0,0})),
      Polygon(
      points=[-10,-14; 0,-34; 10,-14; -10,-14],    style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Line(
   points=[-10,-34; 10,-34],  style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Line(
   points=[0,-34; -12,-46],   style(color=42, rgbcolor={176,0,0})),
        Line(points=[-70,10; -60,10; -60,46; 0,46], style(color=3, rgbcolor={
                0,0,255})),
        Line(points=[-70,-10; -60,-10; -60,-46; 0,-46], style(color=3,
              rgbcolor={0,0,255}))),
      Documentation(info="<html>
<p>Four quadrant switched inverter, based on switch without antiparallel diode (no passive mode). Fulfills the power balance:
<pre>  vAC*iAC = vDC*iDC</pre></p>
<p>Gates:
<pre>  true=on, false=off.</pre></p>
<p>Contains no forward drop voltage Vf. Heat losses are set to zero.</p>
</html>"));

equation
  for k in 1:3 loop
    if gates[pgt[k]] then // switched mode DC+ to AC
      switch[k] = 1;
      v[k] = vDC1;
    elseif gates[ngt[k]] then // switched mode DC- to AC
      switch[k] = -1;
      v[k] = -vDC1;
    else
      switch[k] = 0;
      v[k] = 0;
    end if;
  end for;

  v_abc = transpose(Rot)*v;
  switch_abc = transpose(Rot)*switch;
  Q_flow = zeros(heat.m);
end InverterSwitch;

model InverterEquation "Inverter equation, 3-phase abc"
  extends Partials.SwitchEquation(heat(final m=3));

  replaceable parameter Semiconductors.Ideal.SCparameter par "SC parameters"
    annotation (extent=[-80,-80;-60,-60]);
  Modelica.Blocks.Interfaces.BooleanInput[6] gates
        "gates pairs {a_p, a_n, b_p, b_n, c_p, c_n}"
  annotation (
        extent=[-70,90; -50,110],  rotation=-90);
    protected
  constant Integer[3] pgt={1,3,5} "positive gates";
  constant Integer[3] ngt={2,4,6} "negative gates";
  SI.Voltage[3] V_s;
  SI.Voltage[3] V_d;
  SI.Voltage[3] v "voltage in inertial abc representation";
  SI.Voltage[3] i_sc "current scaled to voltage in inertial abc representation";
  Real[3] s "arc-length on characteristic";
  Real[3] switch "switch function in inertial abc representation";
  Real[3,3] Rot = Spot.Base.Transforms.rotation_abc(AC.theta[2]);
  annotation (defaultComponentName="inverter",
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
    Icon(
        Text(
          extent=[-60,-70; 60,-90],
          style(color=42, rgbcolor={176,0,0}),
        string="eq")),
    Diagram(
        Text(
          extent=[-40,-60; 40,-80],
          style(color=42, rgbcolor={176,0,0}),
          string="time resolved equation"),
      Line(
   points=[30,-46; 30,46], style(color=3, rgbcolor={0,0,255})),
      Line(
   points=[20,-14; 40,-14], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Line(
   points=[20,34; 40,34], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
Line(points=[-30,0; 60,0], style(color=3, rgbcolor={0,0,255})),
      Polygon(
      points=[20,14; 30,34; 40,14; 20,14], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Polygon(
      points=[20,-34; 30,-14; 40,-34; 20,-34], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Line(
   points=[-30,-46; -30,46],
                           style(color=3, rgbcolor={0,0,255})),
      Polygon(
      points=[-40,34; -30,14; -20,34; -40,34], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Line(
   points=[-40,14; -20,14], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Line(
   points=[-30,14; -42,2], style(color=42, rgbcolor={176,0,0})),
      Polygon(
      points=[-40,-14; -30,-34; -20,-14; -40,-14], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Line(
   points=[-40,-34; -20,-34], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Line(
   points=[-30,-34; -42,-46], style(color=42, rgbcolor={176,0,0})),
          Line(points=[-70,10; -60,10; -60,46; 30,46], style(color=3, rgbcolor=
                  {0,0,255})),
          Line(points=[-70,-10; -60,-10; -60,-46; 30,-46], style(color=3,
                rgbcolor={0,0,255}))),
      Documentation(info="<html>
<p>Four quadrant switched inverter, based on switch equation. Fulfills the power balance:
<pre>  vAC*iAC = vDC*iDC</pre></p>
<p>Gates:
<pre>  true=on, false=off.</pre></p>
<p>The Boolean parameter Vf_zero chooses faster code if both Vf_s and Vf_d are zero.<br>
Blocking losses are neglected in the expression of dissipated heat <tt>Q_flow</tt>.</p>
</html>"));

equation
  i_sc = Rot*AC.i*par.V_nom/par.I_nom;

  if par.Vf<1e-3 then // faster code if forward voltage drop Vf not used (Vf=0).
    for k in 1:3 loop
      V_s[k] = 0;
      V_d[k] = vDC1;
      if gates[pgt[k]] then // switched mode DC+ to AC
        switch[k] = 1;
        {v[k],i_sc[k]} = {par.eps[1]*s[k] + (1 - par.eps[1])*V_d[k],s[k] - (1 - par.eps[2])*V_d[k]};
      elseif gates[ngt[k]] then // switched mode DC- to AC
        switch[k] = -1;
        {v[k],i_sc[k]} = {par.eps[1]*s[k] - (1 - par.eps[1])*V_d[k],s[k] + (1 - par.eps[2])*V_d[k]};
      else // rectifier mode
       if s[k] > V_d[k] then // vDC+ < vAC
          {v[k],i_sc[k]} = {par.eps[1]*s[k] + (1 - par.eps[1])*V_d[k], s[k] - (1 - par.eps[2])*V_d[k]};
        elseif s[k] < -V_d[k] then  // vAC < vDC-
          {v[k],i_sc[k]} = {par.eps[1]*s[k] - (1 - par.eps[1])*V_d[k], s[k] + (1 - par.eps[2])*V_d[k]};
        else // vDC- < vAC < vDC+
          {v[k],i_sc[k]} = {s[k],par.eps[2]*s[k]};
        end if;
        switch[k] = noEvent(sign(s[k]));
      end if;
    end for;
    Q_flow = zeros(heat.m);
  else // slower code if voltage drop used (Vf_s>0 or Vf_d>0).
    for k in 1:3 loop
      {V_s[k], V_d[k]} = if size(par.cT_loss,1)==0 then {vDC1-par.Vf, vDC1+par.Vf} else {vDC1, vDC1} + {-par.Vf, par.Vf}*loss(T[k]-par.T0_loss, par.cT_loss);
      if gates[pgt[k]] then // switched mode DC+ to AC
        switch[k] = 1;
        if s[k] > V_d[k] then
          {v[k],i_sc[k]} = {par.eps[1]*s[k] + (1 - par.eps[1])*V_d[k],s[k] - (1 - par.eps[2])*V_d[k]};
        elseif s[k] < V_s[k] then
          {v[k],i_sc[k]} = {par.eps[1]*s[k] + (1 - par.eps[1])*V_s[k],s[k] - (1 - par.eps[2])*V_s[k]};
        else
          {v[k],i_sc[k]} = {s[k],par.eps[2]*s[k]};
        end if;
      elseif gates[ngt[k]] then // switched mode DC- to AC
        switch[k] = -1;
        if s[k] < -V_d[k] then
          {v[k],i_sc[k]} = {par.eps[1]*s[k] - (1 - par.eps[1])*V_d[k],s[k] + (1 - par.eps[2])*V_d[k]};
        elseif s[k] > -V_s[k] then
          {v[k],i_sc[k]} = {par.eps[1]*s[k] -(1 - par.eps[1])*V_s[k],s[k] + (1 - par.eps[2])*V_s[k]};
        else
          {v[k],i_sc[k]} = {s[k],par.eps[2]*s[k]};
        end if;
      else // rectifier mode
        if s[k] > V_d[k] then // vDC+ < vAC
          {v[k],i_sc[k]} = {par.eps[1]*s[k] + (1 - par.eps[1])*V_d[k], s[k] - (1 - par.eps[2])*V_d[k]};
        elseif s[k] < -V_d[k] then  // vAC < vDC-
          {v[k],i_sc[k]} = {par.eps[1]*s[k] - (1 - par.eps[1])*V_d[k], s[k] + (1 - par.eps[2])*V_d[k]};
        else // vDC- < vAC < vDC+
          {v[k],i_sc[k]} = {s[k],par.eps[2]*s[k]};
        end if;
        switch[k] = noEvent(sign(s[k]));
      end if;
    end for;
    Q_flow = (v - switch*vDC1).*i_sc*par.I_nom/par.V_nom;
  end if;

  v_abc = transpose(Rot)*v;
  switch_abc = transpose(Rot)*switch;
end InverterEquation;

model InverterModular "Inverter modular, 3-phase"
  extends Partials.AC_DC_base(heat(final m=3));

  package SCpackage=Semiconductors.Ideal "SC package";
  replaceable parameter SCpackage.SCparameter par "SC parameters"
  annotation (extent=[-80,-80;-60,-60]);
  Modelica.Blocks.Interfaces.BooleanInput[6] gates
        "gates pairs {a_p, a_n, b_p, b_n, c_p, c_n}"
  annotation (
        extent=[-70,90; -50,110],  rotation=-90);
  Nodes.ACabc_a_b_c acabc_a_b_c annotation (extent=[80,-10; 60,10]);
  Common.Thermal.Heat_a_b_c_abc heat_adapt annotation (extent=[-10,70; 10,90]);
  Blocks.Multiplex.Gate3demux gate3demux1(final n=2)
    annotation (extent=[-50,60; -30,80]);
  Semiconductors.PhaseModules.SwitchModule switchMod_a(par=par)
        "switch + reverse diode module AC_a"
      annotation (extent=[-10,30; 10,50]);
  Semiconductors.PhaseModules.SwitchModule switchMod_b(par=par)
        "switch + reverse diode module AC_b"
      annotation (extent=[-10,-10; 10,10]);
  Semiconductors.PhaseModules.SwitchModule switchMod_c(par=par)
        "switch + reverse diode module AC_c"
      annotation (extent=[-10,-50; 10,-30]);

annotation (defaultComponentName="inverter",
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
<p>Four quadrant switched inverter,  using switch-modules. Fulfills the power balance:
<pre>  vAC*iAC = vDC*iDC</pre></p>
<p>Gates:
<pre>  true=on, false=off.</pre></p>
</html>
"),
  Icon( Text(
          extent=[-100,-70; 100,-90],
          style(color=42, rgbcolor={176,0,0}),
        string="modular")),
  Diagram);

equation
  connect(gates, gate3demux1.gates)   annotation (points=[-60,100; -60,80; -40,
            80],                                                          style(
          color=5, rgbcolor={255,0,255}));
  connect(AC, acabc_a_b_c.term) annotation (points=[100,0; 80,0],   style(color=
           62, rgbcolor={0,120,120}));
  connect(gate3demux1.gates_a, switchMod_a.gates) annotation (points=[-46,60;
            -46,56; -6,56; -6,50],
                               style(color=5, rgbcolor={255,0,255}));
  connect(gate3demux1.gates_b, switchMod_b.gates) annotation (points=[-40,60;
            -40,20; -6,20; -6,10],
                               style(color=5, rgbcolor={255,0,255}));
  connect(gate3demux1.gates_c, switchMod_c.gates) annotation (points=[-34,60;
            -34,-20; -6,-20; -6,-30],
                                  style(color=5, rgbcolor={255,0,255}));
  connect(acabc_a_b_c.term_a, switchMod_a.AC) annotation (points=[60,4; 40,4;
            40,40; 10,40],
                         style(color=3, rgbcolor={0,0,255}));
  connect(switchMod_a.DC, DC) annotation (points=[-10,40; -60,40; -60,0; -100,0],
      style(color=3, rgbcolor={0,0,255}));
  connect(acabc_a_b_c.term_b, switchMod_b.AC)
    annotation (points=[60,0; 10,0],   style(color=3, rgbcolor={0,0,255}));
  connect(switchMod_b.DC, DC)
    annotation (points=[-10,0; -100,0],
                                      style(color=3, rgbcolor={0,0,255}));
  connect(acabc_a_b_c.term_c, switchMod_c.AC) annotation (points=[60,-4; 40,-4;
            40,-40; 10,-40],   style(color=3, rgbcolor={0,0,255}));
  connect(switchMod_c.DC, DC) annotation (points=[-10,-40; -60,-40; -60,0; -100,
            0],
      style(color=3, rgbcolor={0,0,255}));
  connect(switchMod_a.heat, heat_adapt.port_a) annotation (points=[0,50; 0,60;
            -4,60; -4,74], style(color=42, rgbcolor={176,0,0}));
  connect(switchMod_b.heat, heat_adapt.port_b) annotation (points=[0,10; 0,20;
            20,20; 20,64; 0,64; 0,74], style(color=42, rgbcolor={176,0,0}));
  connect(switchMod_c.heat, heat_adapt.port_c) annotation (points=[0,-30; 0,-20;
            30,-20; 30,74; 4,74], style(color=42, rgbcolor={176,0,0}));
  connect(heat_adapt.port_abc, heat)
        annotation (points=[0,86; 0,100], style(color=42, rgbcolor={176,0,0}));
end InverterModular;

end Components;

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
height=0.26,
library=1,
autolayout=1));

partial model AC_DC_base "AC-DC base, 3-phase abc"
  extends Base.Icons.Inverter_abc;

  Base.Interfaces.ACabc_n AC "AC 3-phase connection"
    annotation (
        extent=[90,-10; 110,10]);
  Base.Interfaces.ElectricV_p DC(final m=2) "DC connection"
    annotation (
        extent=[-110,-10; -90,10]);
  Base.Interfaces.ThermalV_n heat(m=3) "vector heat port"
    annotation (extent=[-10,90; 10,110], rotation=90);
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
    Icon,
    Diagram,
      Documentation(info="<html>
</html>
"));

end AC_DC_base;

partial model SwitchEquation "Switch equation, 3-phase abc"
  extends AC_DC_base;

    protected
  SI.Voltage vDC1=0.5*(DC.pin[1].v - DC.pin[2].v);
  SI.Voltage vDC0=0.5*(DC.pin[1].v + DC.pin[2].v);
  SI.Current iDC1=(DC.pin[1].i - DC.pin[2].i);
  SI.Current iDC0=(DC.pin[1].i + DC.pin[2].i);
  Real[3] v_abc "switching function voltage in abc representation";
  Real[3] switch_abc "switching function in abc representation";

  SI.Temperature[heat.m] T "component temperature";
  SI.HeatFlowRate[heat.m] Q_flow "component loss-heat flow";
  function loss = Spot.Base.Math.taylor "spec loss function of temperature";
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
    Icon,
    Diagram(
      Ellipse(extent=[68,18; 72,22],   style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Ellipse(extent=[68,-2; 72,2],   style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Ellipse(extent=[68,-22; 72,-18],   style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Text(
        extent=[76,24; 84,16],
        style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1),
        string="a"),
      Text(
        extent=[76,4; 84,-4],
        style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1),
        string="b"),
      Text(
        extent=[76,-16; 84,-24],
        style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1),
        string="c"),
      Ellipse(extent=[-72,12; -68,8],
                                    style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Ellipse(extent=[-72,-8; -68,-12],
                                      style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
        Text(
          extent=[-86,16; -74,4],
          style(color=3, rgbcolor={0,0,255}),
          string="+"),
        Text(
          extent=[-86,-4; -74,-16],
          style(color=3, rgbcolor={0,0,255}),
          string="-")),
      Documentation(info="<html>
</html>
"));

equation
  AC.v = v_abc + {vDC0,vDC0,vDC0};
  iDC1 + switch_abc*AC.i = 0;
  iDC0 + sum(AC.i) = 0;

  T = heat.port.T;
  heat.port.Q_flow = -Q_flow;
end SwitchEquation;

end Partials;
end Inverters;
