within Spot.Control;
package Modulation "Pulse width modulation"
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
<p>Asynchronous and synchronous PWM control of inverter-gates, three- and one-phase.</p>
</html>
"),
  Icon);

block PWMasyn "Sine PWM asynchronous mode, 3phase"
  extends Partials.PWMasynBase(final m=3);

  protected
  constant SI.Angle[3] phShift=(0:2)*2*pi/3;
  Real[3] u_abc;
  discrete SI.Time[3] sigdel_t;
  discrete SI.Time[3] t0;
  annotation (defaultComponentName = "pwm",
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
<p>Pulse width modulation for AC_DC 3-phase inverters, asynchronous mode.
<pre>
  |v_AC| = u*sqrt(3/2)*v_DC/2     AC voltage norm

  u[1] &le  1 for pure sine-modulation, but u[1] &gt  1 possible.
  u[1] = 1 corresponds to AC single-phase amplitude = v_DC/2

  gates[1:2]     phase-module a
  gates[3:4]     phase-module b
  gates[5:6]     phase-module c
</pre></p>
</html>"),
    Icon(
Line(points=[0,-60; 0,-80],   style(color=81)),
Line(points=[-20,-60; -20,-80],   style(color=81)),
Line(points=[20,-60; 20,-80],   style(color=81))),
    Diagram);

initial algorithm
  for k in 1:3 loop
    if u_abc[k] > -1 then
      gates[{pgt[k], ngt[k]}] := {true,false};
      sigdel_t[k] := del_t;
    else
      gates[{pgt[k], ngt[k]}] := {false,true};
      sigdel_t[k] := -del_t;
    end if;
    t0[k] := del_t;
  end for;

equation
  u_abc = uPhasor[1]*cos(fill(theta + uPhasor[2], 3) - phShift);
/*
  for k in 1:3 loop  // assumes |u_abc| < 1:
    when time > pre(t0[k]) + pre(sigdel_t[k])*u_abc[k] then
      gates[{pgt[k], ngt[k]}] = pre(gates[{ngt[k], pgt[k]}]);
      sigdel_t[k] = -pre(sigdel_t[k]);
      t0[k] = pre(t0[k]) + 2*del_t;
    end when;
  end for;
*/
  for k in 1:3 loop  // allows |u_abc| >= 1:
    when time > pre(t0[k]) + pre(sigdel_t[k])*u_abc[k] then
      if noEvent(time < pre(t0[k]) + delp_t) then
        gates[{pgt[k], ngt[k]}] = pre(gates[{ngt[k],pgt[k]}]);
        sigdel_t[k] = -pre(sigdel_t[k]);
        t0[k] = pre(t0[k]) + 2*del_t;
      else
        gates[{pgt[k], ngt[k]}] = pre(gates[{pgt[k],ngt[k]}]);
        sigdel_t[k] = pre(sigdel_t[k]);
        t0[k] = pre(t0[k]) + 4*del_t;
      end if;
    end when;
  end for;
end PWMasyn;

block PWMsyn "Sine PWM synchronous mode, 3phase"
  extends Partials.PWMsynBase(final m=3);

  protected
  constant SI.Angle[3] phShift=(0:2)*2*pi/3;
  final parameter SI.Angle[m2] phi0=(1:2:2*m2 - 1)*del_phi;
  Integer[3] n;
  SI.Angle[3] phi;
  Real[3] u_abc;
  discrete Real[3] sigdel_phi;
  function mod2sign = Base.Math.mod2sign;
  annotation (defaultComponentName = "pwm",
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
<p>Pulse width modulation for AC_DC 3-phase inverters, synchronous mode (phase-angle instead of time).
<pre>
  |v_AC| = u*sqrt(3/2)*v_DC/2     AC voltage norm

  u[1] &le  1 for pure sine-modulation, but u[1] &gt  1 possible.
  u[1] = 1 corresponds to AC single-phase amplitude = v_DC/2

  gates[1:2]     phase-module a
  gates[3:4]     phase-module b
  gates[5:6]     phase-module c
</pre></p>
</html>
"), Icon(
Line(points=[-20,-60; -20,-80],   style(color=81)),
Line(points=[0,-60; 0,-80],   style(color=81)),
Line(points=[20,-60; 20,-80],   style(color=81))),
    Diagram);

initial algorithm
  n := {1,1,1} + integer(phi/(2*del_phi));
  for k in 1:3 loop
    if -scalar(mod2sign({n[k]})) > 0 then
      if phi[k] <= phi0[n[k]] + del_phi*u_abc[k] then
        gates[{pgt[k], ngt[k]}] := {true,false};
        sigdel_phi[k] := del_phi;
      else
        gates[{pgt[k], ngt[k]}] := {false,true};
        sigdel_phi[k] := -del_phi;
        n[k] := if n[k] < m2 then n[k] + 1 else 1;
      end if;
    else
      if phi[k] <= phi0[n[k]] - del_phi*u_abc[k] then
        gates[{pgt[k], ngt[k]}] := {false,true};
        sigdel_phi[k] := -del_phi;
      else
        gates[{pgt[k], ngt[k]}] := {true,false};
        sigdel_phi[k] := del_phi;
        n[k] := if n[k] < m2 then n[k] + 1 else 1;
      end if;
    end if;
  end for;

equation
  phi = mod(fill(theta + uPhasor[2], 3) - phShift, 2*pi);
  u_abc = uPhasor[1]*cos(phi);
/*
  for k in 1:3 loop  // assumes |u_abc| < 1:
    when phi[k] > phi0[(pre(n[k]))] + pre(sigdel_phi[k])*u_abc[k] then
      gates[{pgt[k], ngt[k]}] = pre(gates[{ngt[k], pgt[k]}]);
      sigdel_phi[k] = -pre(sigdel_phi[k]);
      n[k] = if pre(n[k]) < m2 then pre(n[k]) + 1 else 1;
    end when;
  end for;
*/
  for k in 1:3 loop  // allows |u_abc| >= 1:
    when phi[k] > phi0[pre(n[k])] + pre(sigdel_phi[k])*u_abc[k] then
      if noEvent(phi[k] < phi0[pre(n[k])] + delp_phi) then
        gates[{pgt[k], ngt[k]}] = pre(gates[{ngt[k],pgt[k]}]);
        sigdel_phi[k] = -pre(sigdel_phi[k]);
        n[k] = if pre(n[k]) < m2 then pre(n[k]) + 1 else 1;
      else
        gates[{pgt[k], ngt[k]}] = pre(gates[{pgt[k],ngt[k]}]);
        sigdel_phi[k] = pre(sigdel_phi[k]);
        n[k] = if pre(n[k]) < m2 - 1 then pre(n[k]) + 2 else pre(n[k]) + 2 - m2;
      end if;
    end when;
  end for;
end PWMsyn;

block PWMtab "PWM tabulated, synchronous mode, 3phase"
  extends Partials.PWMsynBase(final m=3, final mult=integer((size(table.phiIgn, 2)+1)/4));

  replaceable Spot.Control.IgnitionTables.Table_2 table "table(multiplicity)"
    annotation (extent=[-20, -20; 20, 20], choices(
    choice(redeclare Spot.Control.IgnitionTables.Table_2 table
            "3 pulses/period"),
    choice(redeclare Spot.Control.IgnitionTables.Table_3 table
            "5 pulses/period"),
    choice(redeclare Spot.Control.IgnitionTables.Table_4 table
            "7 pulses/period"),
    choice(redeclare Spot.Control.IgnitionTables.Table_5 table
            "9 pulses/period")));
  protected
  constant SI.Angle[3] phShift=(0:2)*2*pi/3;
  discrete SI.Angle[m2] phiIgn1;
  discrete SI.Angle[m2] phiIgn2;
  discrete SI.Angle[m2] phiIgn3;
//  discrete SI.Angle[3,m2] phiIgn; // desired version
  Integer[3] n;
  SI.Angle[3] phi;
  function intpol = Base.Math.interpolateTable;
  annotation (defaultComponentName = "pwm",
    Coordsys(
extent=[-100, -100; 100, 100],
grid=[2, 2],
component=[40, 40]),
    Window(
x=0.45,
y=0.01,
width=0.44,
height=0.65),
    Documentation(
            info="<html>
<p>Pulse width modulation for AC_DC 3-phase inverters, tabulated synchronous mode (phase-angle instead of time).
<pre>
  |v_AC| = u*sqrt(3/2)*v_DC/2     AC voltage norm

  u[1] &le  1 for pure sine-modulation, but u[1] &gt  1 possible.
  u[1] = 1 corresponds to AC single-phase amplitude = v_DC/2

  gates[1:2]     phase-module a
  gates[3:4]     phase-module b
  gates[5:6]     phase-module c
</pre></p>
</html>
"), Icon(
Line(points=[-40,46; 40,46],   style(color=10)),
Line(points=[-20,56; -20,36],   style(color=10)),
Rectangle(extent=[-40,36; 40,56],   style(color=10)),
Line(points=[-20,-60; -20,-80],   style(color=81)),
Line(points=[0,-60; 0,-80],   style(color=81)),
Line(points=[20,-60; 20,-80],   style(color=81))),
    Diagram);

initial algorithm
  n := {1,1,1};
  phiIgn1 := intpol(uPhasor[1], table.phiIgn);
  gates[{pgt[1], ngt[1]}] := {true, false};
  while phiIgn1[n[1]] < phi[1] and phi[1] < phiIgn1[end] loop
    n[1] := n[1] + 1;
    gates[{pgt[1], ngt[1]}] := gates[{ngt[1], pgt[1]}];
  end while;
  phiIgn2 := intpol(uPhasor[1], table.phiIgn);
  gates[{pgt[2], ngt[2]}] := {true, false};
  while phiIgn2[n[2]] < phi[2] and phi[2] < phiIgn2[end] loop
    n[2] := n[2] + 1;
    gates[{pgt[2], ngt[2]}] := gates[{ngt[2], pgt[2]}];
  end while;
  phiIgn3 := intpol(uPhasor[1], table.phiIgn);
  gates[{pgt[3], ngt[3]}] := {true, false};
  while phiIgn3[n[3]] < phi[3] and phi[3] < phiIgn3[end] loop
    n[3] := n[3] + 1;
    gates[{pgt[3], ngt[3]}] := gates[{ngt[3], pgt[3]}];
  end while;

equation
  phi = mod(fill(theta + uPhasor[2], 3) - phShift, 2*pi);

  when phi[1] > pre(phiIgn1[pre(n[1])]) then
    gates[{pgt[1], ngt[1]}] = pre(gates[{ngt[1], pgt[1]}]);
    n[1] = if pre(n[1]) < m2 then pre(n[1]) + 1 else 1;
  end when;
  when phi[2] > pre(phiIgn2[pre(n[2])]) then
    gates[{pgt[2], ngt[2]}] = pre(gates[{ngt[2], pgt[2]}]);
    n[2] = if pre(n[2]) < m2 then pre(n[2]) + 1 else 1;
  end when;
  when phi[3] > pre(phiIgn3[pre(n[3])]) then
    gates[{pgt[3], ngt[3]}] = pre(gates[{ngt[3], pgt[3]}]);
    n[3] = if pre(n[3]) < m2 then pre(n[3]) + 1 else 1;
  end when;
  when n[1]==1 then
    phiIgn1 = intpol(uPhasor[1], table.phiIgn);
  end when;
  when n[2]==1 then
    phiIgn2 = intpol(uPhasor[1], table.phiIgn);
  end when;
  when n[3]==1 then
    phiIgn3 = intpol(uPhasor[1], table.phiIgn);
  end when;

/* desired version:
initial algorithm
  n := {1,1,1};
  for k in 1:3 loop
    phiIgn[k,:] := intpol(uPhasor[1], table.phiIgn);
    gates[{pgt[k], ngt[k]}] := {true, false};
    while phiIgn[k, n[k]] < phi[k] and phi[k] < phiIgn[k, end] loop
      n[k] := n[k] + 1;
      gates[{pgt[k], ngt[k]}] := gates[{ngt[k], pgt[k]}];
    end while;
  end for;
equation
  for k in 1:3 loop
    when phi[k] > pre(phiIgn[k, pre(n[k])]) then
      gates[{pgt[k], ngt[k]}] := pre(gates[{ngt[k],pgt[k]}]);
      n[k] := if pre(n[k]) < m2 then pre(n[k]) + 1 else 1;
    end when;
    when n[k]==1 then
      phiIgn[k,:] := intpol(uPhasor[1], table.phiIgn);
    end when;
  end for;*/
end PWMtab;

block SVPWMasyn "Space vector PWM asynchronous mode"
  extends Partials.SVPWMsynBase;

  protected
  Real u;
  SI.Angle phi;
  discrete SI.Angle phi_s;
  discrete SI.Angle[m2] phiIgn;
  Integer i;
  Integer k;
  Integer n;
  Integer s;
  annotation (defaultComponentName = "sv_pwm",
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
<p>Space vector modulation for AC_DC 3-phase inverters, asynchronous mode.<br>
'Asynchronous mode' NOT FINISHED, this model is a copy of 'SVPWMsyn'!
<pre>
  |v_AC| = u*sqrt(2/3)*v_DC     AC voltage norm

  u[1] &le  sqrt(3)/2 = 0.866: pure sine-pwm,
  sqrt(3)/2 &le  u[1] &le  1:  overmodulation (not implemented in this preliminary version).
  u[1] = sqrt(3)/2 corresponds to AC single-phase amplitude = v_DC/sqrt(3)

  gates[1:2]     phase-module a
  gates[3:4]     phase-module b
  gates[5:6]     phase-module c
</pre></p>
</html>
"), Icon(
Line(points=[-20,-60; -20,-80],   style(color=81)),
Line(points=[0,-60; 0,-80],   style(color=81)),
Line(points=[20,-60; 20,-80],   style(color=81)),
        Line(points=[-80,60; 80,-60], style(color=1, rgbcolor={255,0,0}))),
    Diagram);

initial algorithm
  s := integer(3*phi/pi) + 1;
  phi_s := (s - 1)*pi/3;
  phiIgn := Phi + u*Dphi;
  i := 1;
  n := 1;
  while phiIgn[n] < phi - phi_s loop
    n := n + 1;
    i := if i < imax then i + 1 else 1;
  end while;
  k := K[s, i];
  gates[{1,3,5}] := state[k,:];
  gates[{2,4,6}] := {not state[k,1], not state[k,2], not state[k,3]};

equation
  u = min(uPhasor[1], 0.85); // preliminary (no overmodulation)
  phi = mod(theta + uPhasor[2], 2*pi);

  when phi > pre(phi_s) + pre(phiIgn[pre(n)]) then
    if pre(n) < m2 then
      i = if pre(i) < imax then pre(i) + 1 else 1;
      n = pre(n) + 1;
      s = pre(s);
      phi_s = pre(phi_s);
      phiIgn = pre(phiIgn);
    else
      i = 1;
      n = 1;
      if pre(s) < 6 then
        s = pre(s) + 1;
        phi_s = pre(phi_s) + pi/3;
        phiIgn = pre(phiIgn);
      else
        s = 1;
        phi_s = 0;
        phiIgn =  Phi + u*Dphi;
      end if;
    end if;
    k = K[s, i];
    gates[{1,3,5}] = state[k,:];
    gates[{2,4,6}] = {not state[k,1], not state[k,2], not state[k,3]};
  end when;
end SVPWMasyn;

block SVPWMsyn "Space vector PWM synchronous mode"
  extends Partials.SVPWMsynBase;

  protected
  Real u;
  SI.Angle phi;
  discrete SI.Angle phi_s;
  discrete SI.Angle[m2] phiIgn;
  Integer i;
  Integer k;
  Integer n;
  Integer s;
  annotation (defaultComponentName = "sv_pwm",
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
<p>Space vector modulation for AC_DC 3-phase inverters, synchronous mode (phase-angle instead of time).
<pre>
  |v_AC| = u*sqrt(2/3)*v_DC     AC voltage norm

  u[1] &le  sqrt(3)/2 = 0.866: pure sine-pwm,
  sqrt(3)/2 &le  u[1] &le  1:  overmodulation (not implemented in this preliminary version).
  u[1] = sqrt(3)/2 corresponds to AC single-phase amplitude = v_DC/sqrt(3)

  gates[1:2]     phase-module a
  gates[3:4]     phase-module b
  gates[5:6]     phase-module c
</pre></p>
</html>
"), Icon(
Line(points=[-20,-60; -20,-80],   style(color=81)),
Line(points=[0,-60; 0,-80],   style(color=81)),
Line(points=[20,-60; 20,-80],   style(color=81))),
    Diagram);

initial algorithm
  s := integer(3*phi/pi) + 1;
  phi_s := (s - 1)*pi/3;
  phiIgn := Phi + u*Dphi;
  i := 1;
  n := 1;
  while phiIgn[n] < phi - phi_s loop
    n := n + 1;
    i := if i < imax then i + 1 else 1;
  end while;
  k := K[s, i];
  gates[{1,3,5}] := state[k,:];
  gates[{2,4,6}] := {not state[k,1], not state[k,2], not state[k,3]};

equation
  u = min(uPhasor[1], 0.85); // preliminary (no overmodulation)
  phi = mod(theta + uPhasor[2], 2*pi);

  when phi > pre(phi_s) + pre(phiIgn[pre(n)]) then
    if pre(n) < m2 then
      i = if pre(i) < imax then pre(i) + 1 else 1;
      n = pre(n) + 1;
      s = pre(s);
      phi_s = pre(phi_s);
      phiIgn = pre(phiIgn);
    else
      i = 1;
      n = 1;
      if pre(s) < 6 then
        s = pre(s) + 1;
        phi_s = pre(phi_s) + pi/3;
        phiIgn = pre(phiIgn);
      else
        s = 1;
        phi_s = 0;
        phiIgn =  Phi + u*Dphi;
      end if;
    end if;
    k = K[s, i];
    gates[{1,3,5}] = state[k,:];
    gates[{2,4,6}] = {not state[k,1], not state[k,2], not state[k,3]};
  end when;
end SVPWMsyn;

block SVPWM "Space vector PWM"
  extends Partials.SVPWMbase;

  annotation (defaultComponentName = "sv_pwm",
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
<p>This version uses models from the library 'MotorControl', author Martin Kuhn, DLR Munich.</p>
<p>Space vector modulation for AC_DC 3-phase inverters, asynchronous mode.
<pre>
  |v_AC| = u*sqrt(2/3)*v_DC     AC voltage norm

  u[1] &le  sqrt(3)/2 = 0.866: pure sine-pwm,
  sqrt(3)/2 &le  u[1] &le  1:  overmodulation (not implemented in this preliminary version).
  u[1] = sqrt(3)/2 corresponds to AC single-phase amplitude = v_DC/sqrt(3)

  gates[1:2]     phase-module a
  gates[3:4]     phase-module b
  gates[5:6]     phase-module c
</pre></p>
</html>
"), Icon(
Line(points=[-20,-60; -20,-80],   style(color=81)),
Line(points=[0,-60; 0,-80],   style(color=81)),
Line(points=[20,-60; 20,-80],   style(color=81))),
    Diagram(
        Rectangle(extent=[-40,65; 0,55], style(color=77, rgbcolor={128,0,255})),
        Text(
          extent=[-40,65; 0,55],
          style(color=77, rgbcolor={128,0,255}),
          string="d_phi"),
        Line(points=[-40,60; -54,60; -54,50], style(color=77, rgbcolor={128,0,
                255}))));

  parameter SI.Frequency f_carr=1e3 "carrier frequency";
  Blocks.Transforms.PhasorToAlphaBeta phToAlphaBeta
        annotation (extent=[-70,-10; -50,10]);
  SpaceVector.SVMlogic logic(T_pwm=1/f_carr)
                     annotation (extent=[-40,-20; 0,20]);
  SpaceVector.SVMpwm pwm(T_pwm=1/f_carr)
                                annotation (extent=[20,-20; 60,20]);
      annotation (extent=[-74,68; -54,48]);
  Modelica.Blocks.Math.Add phaseCorr
        annotation (extent=[-70,40; -50,20],   rotation=90);
equation
  phaseCorr.u2 = der(theta)/(2*f_carr); //d_phi = pi*f/f_carr.

  connect(uPhasor, phToAlphaBeta.u) annotation (points=[60,100; 60,80; -80,80;
          -80,0; -70,0],
                     style(color=74, rgbcolor={0,0,127}));
  connect(phToAlphaBeta.y, logic.u_alpha_beta)     annotation (points=[-50,0;
          -41.3333,0],    style(color=74, rgbcolor={0,0,127}));
  connect(logic.trigger, pwm.trigger)           annotation (points=[1.33333,8;
          18,8],    style(color=5, rgbcolor={255,0,255}));
  connect(pwm.switch, gates)      annotation (points=[62,0; 80,0; 80,-40; -60,
          -40; -60,-100], style(color=5, rgbcolor={255,0,255}));
  connect(logic.dutyRatio, pwm.dutyRatio) annotation (points=[1.33333,-8; 18,-8],
        style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1));
    connect(theta, phaseCorr.u1) annotation (points=[-60,100; -60,60; -66,60;
          -66,42], style(color=74, rgbcolor={0,0,127}));
    connect(phaseCorr.y, phToAlphaBeta.theta) annotation (points=[-60,19; -60,
          10], style(color=74, rgbcolor={0,0,127}));
end SVPWM;

block BlockM "Block modulation, 3phase"
  extends Partials.BlockBase(final m=3);

  protected
  constant SI.Angle[3] phShift=(0:2)*2*pi/3;
  SI.Angle alpha;
  Real a;
  Real[3] u_abc;
  annotation (defaultComponentName = "blockMod",
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
<p>Block (rectangular) modulation for DC_AC 3-phase inverters.
<pre>
  ampl(v_AC_abc) = v_DC/2     AC phase-voltage amplitude

  gates[1:2]     phase-module a
  gates[3:4]     phase-module b
  gates[5:6]     phase-module c
</pre></p>
<p>The default-value <pre>  width = 2/3</pre> corresponds to '2 phases on, one phase off'.<br><br>
The input uPhasor[1] has no influence on this model. It is only needed, if additional PWM is desired.</p>
</html>"),
    Icon(
Line(points=[0,-60; 0,-80],   style(color=81)),
Line(points=[-20,-60; -20,-80],   style(color=81)),
Line(points=[20,-60; 20,-80],   style(color=81))),
    Diagram);

equation
  alpha = max(min((1 - width)*pi/2, pi/2 - dphimin), 0);
  a = sin(alpha);
  u_abc = cos(fill(theta + uPhasor[2], 3) - phShift);

  for k in 1:3 loop
    gates[{pgt[k], ngt[k]}] = {u_abc[k] > a, u_abc[k] < -a};
  end for;
end BlockM;

 block PWMasyn1ph "Sine PWM asynchronous mode, 1-phase"
   extends Partials.PWMasynBase(final m=2);

  protected
   Real u;
   discrete SI.Time sigdel_t;
   discrete SI.Time t0;
  annotation (defaultComponentName = "pwm",
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
<p>Pulse width modulation for AC_DC 1-phase inverters, asynchronous mode.
<pre>
  v_AC_eff = u*v_DC/sqrt(2)     AC effective voltage

  u[1] &le  1 for pure sine-modulation, but u[1] &gt  1 possible.
  u[1] = 1 corresponds to:  AC amplitude = v_DC

  gates[1:2]     phase-module 1
  gates[3:4]     phase-module 2
</pre></p>
</html>
"),
  Icon(
 Line(points=[0,-60; 0,-80],   style(color=81))),
  Diagram);

 initial algorithm
   if u > -1 then
     gates[{pgt[1], ngt[1]}] := {true,false};
     gates[{pgt[2], ngt[2]}] := {false,true};
     sigdel_t := del_t;
   else
     gates[{pgt[1], ngt[1]}] := {false,true};
     gates[{pgt[2], ngt[2]}] := {true,false};
     sigdel_t := -del_t;
   end if;
   t0 := del_t;

 equation
   u = uPhasor[1]*cos(theta + uPhasor[2]);
 /*
//assumes |u| < 1:
  when time > pre(t0) + pre(sigdel_t)*u then
    gates[{pgt[1], ngt[1]}] = pre(gates[{ngt[1], pgt[1]}]);
    gates[{pgt[2], ngt[2]}] = pre(gates[{ngt[2], pgt[2]}]);
    sigdel_t = -pre(sigdel_t);
    t0 = pre(t0) + 2*del_t;
  end when;
*/
 //allows |u| >= 1:
   when time > pre(t0) + pre(sigdel_t)*u then
     if noEvent(time < pre(t0) + delp_t) then
       gates[{pgt[1], ngt[1]}] = pre(gates[{ngt[1], pgt[1]}]);
       gates[{pgt[2], ngt[2]}] = pre(gates[{ngt[2], pgt[2]}]);
       sigdel_t = -pre(sigdel_t);
       t0 = pre(t0) + 2*del_t;
     else
       gates = pre(gates);
       sigdel_t = pre(sigdel_t);
       t0 = pre(t0) + 4*del_t;
     end if;
   end when;
 end PWMasyn1ph;

block PWMsyn1ph "Sine PWM synchronous mode, 1-phase"
  extends Partials.PWMsynBase(final m=2);

  protected
  final parameter SI.Angle[m2] phi0=(1:2:2*m2 - 1)*del_phi;
  SI.Angle phi;
  Real u;
  Integer n;
  Integer sigma;
  discrete Real sigdel_phi;
  function mod2sign = Base.Math.mod2sign;
annotation (defaultComponentName = "pwm",
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
<p>Pulse width modulation for AC_DC 1-phase inverters, synchronous mode (phase-angle instead of time).
<pre>
  v_AC_eff = u*v_DC/sqrt(2)     AC effective voltage

  u[1] &le  1 for pure sine-modulation, but u[1] &gt  1 possible.
  u[1] = 1 corresponds to:  AC amplitude = v_DC

  gates[1:2]     phase-module 1
  gates[3:4]     phase-module 2
</pre></p>
</html>
"),
  Icon(
 Line(points=[0,-60; 0,-80],   style(color=81))),
  Diagram);

initial algorithm
  n := 1 + integer(phi/(2*del_phi));
  sigma := -scalar(mod2sign({n}));
  if sigma > 0 then
    if phi <= phi0[n] + del_phi*u then
      gates[{pgt[1], ngt[1]}] := {true,false};
      gates[{pgt[2], ngt[2]}] := {false,true};
      sigdel_phi := del_phi;
    else
      gates[{pgt[1], ngt[1]}] := {false,true};
      gates[{pgt[2], ngt[2]}] := {true,false};
      sigdel_phi := -del_phi;
      n := if n < m2 then n + 1 else 1;
    end if;
  else
    if phi <= phi0[n] - del_phi*u then
      gates[{pgt[1], ngt[1]}] := {false,true};
      gates[{pgt[2], ngt[2]}] := {true,false};
      sigdel_phi := -del_phi;
    else
      gates[{pgt[1], ngt[1]}] := {true,false};
      gates[{pgt[2], ngt[2]}] := {false,true};
      sigdel_phi := del_phi;
      n := if n < m2 then n + 1 else 1;
    end if;
  end if;

equation
  sigma = pre(sigma);
  phi = mod(theta + uPhasor[2], 2*pi);
  u = uPhasor[1]*cos(phi);

/*
// assumes |u_abc| < 1:
  when phi > phi0[(pre(n))] + pre(sigdel_phi)*u then
    gates[{pgt[1], ngt[1]}] = pre(gates[{ngt[1], pgt[1]}]);
    gates[{pgt[2], ngt[2]}] = pre(gates[{ngt[2], pgt[2]}]);
    sigdel_phi = -pre(sigdel_phi);
    n = if pre(n) < m2 then pre(n) + 1 else 1;
  end when;
*/
// allows |u_abc| >= 1:
  when phi > phi0[pre(n)] + pre(sigdel_phi)*u then
    if noEvent(phi < phi0[pre(n)] + delp_phi) then
      gates[{pgt[1], ngt[1]}] = pre(gates[{ngt[1], pgt[1]}]);
      gates[{pgt[2], ngt[2]}] = pre(gates[{ngt[2], pgt[2]}]);
      sigdel_phi = -pre(sigdel_phi);
      n = if pre(n) < m2 then pre(n) + 1 else 1;
    else
      gates = pre(gates);
      sigdel_phi = pre(sigdel_phi);
      n =  if pre(n) < m2 - 1 then pre(n) + 2 else pre(n) + 2 -
        m2;
    end if;
  end when;
end PWMsyn1ph;

block PWMtab1ph "PWM tabulated, synchronous mode, 1-phase"
  extends Partials.PWMsynBase(final m=2, final mult=integer((size(table.phiIgn, 2)+1)/4));

  replaceable Spot.Control.IgnitionTables.Table_2 table "table(multiplicity)"
    annotation (extent=[-20, -20; 20, 20], choices(
    choice(redeclare Spot.Control.IgnitionTables.Table_2 table
            "3 pulses/period"),
    choice(redeclare Spot.Control.IgnitionTables.Table_3 table
            "5 pulses/period"),
    choice(redeclare Spot.Control.IgnitionTables.Table_4 table
            "7 pulses/period"),
    choice(redeclare Spot.Control.IgnitionTables.Table_5 table
            "9 pulses/period")));
  protected
  discrete SI.Angle[m2] phiIgn;
  SI.Angle phi;
  Integer n;
  function intpol = Base.Math.interpolateTable;
annotation (defaultComponentName = "pwm",
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
<p>Pulse width modulation for AC_DC 1-phase inverters, tabulated synchronous mode (phase-angle instead of time).
<pre>
  v_AC_eff = u*v_DC/sqrt(2)     AC effective voltage

  u[1] &le  1 for pure sine-modulation, but u[1] &gt  1 possible.
  u[1] = 1 corresponds to:  AC amplitude = v_DC

  gates[1:2]     phase-module 1
  gates[3:4]     phase-module 2
</pre></p>
</html>
"),
  Icon(
      Line(points=[-20,56; -20,36], style(color=10)),
      Line(points=[-40,46; 40,46], style(color=10)),
      Rectangle(extent=[-40,36; 40,56], style(color=10)),
      Line(points=[0,-60; 0,-80], style(color=81))));

initial algorithm
  n := 1;
  phiIgn := intpol(uPhasor[1], table.phiIgn);
  gates[{pgt[1], ngt[1]}] := {true, false};
  gates[{pgt[2], ngt[2]}] := {false, true};
  while phiIgn[n] < phi and phi < phiIgn[end] loop
    n := n + 1;
    gates[{pgt[1], ngt[1]}] := gates[{ngt[1], pgt[1]}];
    gates[{pgt[2], ngt[2]}] := gates[{ngt[2], pgt[2]}];
  end while;

equation
  phi = mod(theta + uPhasor[2], 2*pi);

  when phi > pre(phiIgn[pre(n)]) then
    gates[{pgt[1], ngt[1]}] = pre(gates[{ngt[1], pgt[1]}]);
    gates[{pgt[2], ngt[2]}] = pre(gates[{ngt[2], pgt[2]}]);
    n = if pre(n) < m2 then pre(n) + 1 else 1;
  end when;
  when n==1 then
    phiIgn = intpol(uPhasor[1], table.phiIgn);
  end when;
end PWMtab1ph;

block BlockM1ph "Block modulation, 1phase"
  extends Partials.BlockBase(final m=2);

  protected
  SI.Angle alpha;
  Real a;
  Real u;
  annotation (defaultComponentName = "blockMod",
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
<p>Block (rectangular) modulation for DC_AC 1-phase inverters.
<pre>
  ampl(v_AC) = v_DC     AC voltage amplitude

  gates[1:2]     phase-module 1
  gates[3:4]     phase-module 2
</pre></p>
The input uPhasor[1] has no influence on this model. It is only needed, if additional PWM is desired.</p>
</html>
"), Icon(
Line(points=[0,-60; 0,-80],   style(color=81))),
    Diagram);

equation
  alpha = max(min((1 - width)*pi/2, pi/2 - dphimin), 0);
  a = sin(alpha);
  u = cos(theta + uPhasor[2]);

  gates[{pgt[1], ngt[1]}] = {u > a, u < -a};
  gates[{pgt[2], ngt[2]}] = {u < -a, u > a};
end BlockM1ph;

block ChopperPWM "Chopper PWM (voltage)"
  extends Base.Icons.BlockS;

  parameter SI.Frequency f_carr=500 "carrier frequency";
  Modelica.Blocks.Interfaces.RealInput uDC
      "desired average voltage, pu v_DC_in"
  annotation (
        extent=[50,90; 70,110],  rotation=-90);
  Modelica.Blocks.Interfaces.BooleanOutput gate "gate"
  annotation (
        extent=[-70,-110; -50,-90],  rotation=-90);
  protected
  final parameter SI.Time del_t=1/f_carr;
  discrete SI.Time t0;
  discrete SI.Time t1;
annotation (defaultComponentName = "chopperMod",
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
<p>Pulse width modulation for chopper, voltage controlled.
<pre>
  u[1] = 1 corresponds to:  v_DC_out = v_DC_in
  u[1] &le  1 for pwm, but u[1] &gt  1 possible.
</pre></p>
</html>"),
  Icon(Line(points=[-68,10; 70,-4], style(color=62, rgbcolor={0,120,120})),
 Line(points=[-60,-30; -60,30; -30,30; -30,-30; -10,-30; -10,30; 15,30; 15,-30;
            40,-30; 40,30; 60,30; 60,-30], style(color=6, rgbcolor={255,255,0})),
     Text(
    extent=[-100,100; 100,60],
    string="%name",
    style(color=0))),
      Diagram);

equation
  when sample(0, del_t) then
    t0 = time;
    t1 = time + uDC*del_t;
  end when;

  gate = t0 <= time and time < t1;
end ChopperPWM;

block ChopperPWM_I "Chopper PWM (current)"
  extends Base.Icons.BlockS;

  parameter SI.Current iRipple=1 "max ripple current";
  Modelica.Blocks.Interfaces.BooleanOutput gate "gate"
  annotation (
        extent=[-70,-110; -50,-90],  rotation=-90);
  Modelica.Blocks.Interfaces.RealInput iSet(redeclare type SignalType =
        SI.Current) "desired current"
  annotation (
        extent=[-110, -10; -90, 10]);
  Modelica.Blocks.Interfaces.RealInput iMeas(redeclare type SignalType =
        SI.Current) "measured current"
  annotation (
        extent=[110, -10; 90, 10]);
  protected
  SI.Current di;

annotation (defaultComponentName = "chopperMod",
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
<p>Pulse width modulation for chopper, current controlled.</p>
</html>
"),
  Icon(
 Line(points=[-60, -20; -30, 20; -6, -20; 20, 20; 42, -20; 60, 20], style(color=
               62, rgbcolor={0,127,127})),
     Text(
    extent=[-100,100; 100,60],
    string="%name",
    style(color=0))),
      Diagram);

equation
  di = (iMeas - iSet);

  if di > iRipple then
    gate = false;
  elseif di < -iRipple then
    gate = true;
  else
    gate = pre(gate);
  end if;
end ChopperPWM_I;

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
height=0.25,
library=1,
autolayout=1));

  partial block ModulatorBase "Modulator base"
    extends Base.Icons.BlockS;

    parameter Integer m(min=2,max=3)=3 "3 for 3-phase, 2 for 1-phase";
    Modelica.Blocks.Interfaces.RealInput theta(redeclare type SignalType = SI.Angle)
        "reference angle"
      annotation (
          extent=[-70,90; -50,110], rotation=-90);
    Modelica.Blocks.Interfaces.RealInput[2] uPhasor
        "voltage demand pu {norm(v), phase(v)} (see info)"
                            annotation (extent=[50,90; 70,110], rotation=-90);
    Modelica.Blocks.Interfaces.BooleanOutput[2*m] gates "gates"
      annotation (
            extent=[-70,-110; -50,-90],  rotation=-90);
    protected
    final parameter Integer[m] pgt=1:2:(2*m-1) "positive gates" annotation(Evaluate=true);
    final parameter Integer[m] ngt=2:2:(2*m) "negative gates" annotation(Evaluate=true);
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
      Icon(
        Rectangle(extent=[-80,120; -40,80], style(
              color=84,
              rgbcolor={213,170,255},
              fillColor=84,
              rgbfillColor={213,170,255})),
       Text(
      extent=[-100,100; 100,60],
      string="%name",
      style(color=0))),
      Documentation(
            info="<html>
</html>"),
        Diagram);
  end ModulatorBase;

  partial block SVPWMbase "Space vector PWM base"
    extends ModulatorBase(final m=3);

    parameter Boolean sym=true "'symmetric' or 'antisymmetric'"
                                                           annotation(Evaluate=true, choices(
      choice=true " true: symmetric",
      choice=false "false: antisymmetric"));
    protected
    Boolean[8,3] state=
      [true,false,false;
       true,true,false;
       false,true,false;
       false,true,true;
       false,false,true;
       true,false,true;
       false,false,false;
       true,true,true];
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
      Icon(
          Polygon(points=[-30,-52; 30,-52; 60,0; 30,52; -30,52; -60,0; -30,-52],
              style(color=6, rgbcolor={255,255,0})),
          Line(points=[0,0; 60,0], style(color=6, rgbcolor={255,255,0})),
          Line(points=[0,0; 30,52], style(color=6, rgbcolor={255,255,0})),
          Line(points=[0,0; -30,52], style(color=6, rgbcolor={255,255,0})),
          Line(points=[0,0; -60,0], style(color=6, rgbcolor={255,255,0})),
          Line(points=[0,0; -30,-52], style(color=6, rgbcolor={255,255,0})),
          Line(points=[0,0; 30,-52], style(color=6, rgbcolor={255,255,0})),
          Line(points=[0,0; 32,26], style(
              color=62,
              rgbcolor={0,127,127},
              thickness=2))),
      Documentation(
            info="<html>
</html>"),
        Diagram);
  end SVPWMbase;

  partial block SVPWMasynBase "Space vector PWM asynchronous base"
    extends SVPWMbase;
  /* asynchronous:
  parameter SI.Frequency f_carr=1e3 "carrier frequency" annotation 0;
protected
  final parameter SI.Time del_t=1/(2*f_carr) annotation 1;
  constant Integer mult=10 "number of stored phase-values";
  constant SI.Angle del_phi=pi/(3*mult);
//constant SI.Angle[1+mult] dt=(del_t/sqrt(3))*sin((0:mult)*del_phi);
  constant SI.Angle[1+mult] dt_sum=(del_t/sqrt(3))*(sin((mult:-1:0)*del_phi)+sin((0:mult)*del_phi));
  constant SI.Angle[1+mult] dt_dif=(del_t/sqrt(3))*(sin((mult:-1:0)*del_phi)-sin((0:mult)*del_phi));
  SI.Angle Phi;
  SI.Angle[3] Dt;
  Integer[6,:] K=if sym then
    [7,1,2,8,2,1;
     7,3,2,8,2,3;
     7,3,4,8,4,3;
     7,5,4,8,4,5;
     7,5,6,8,6,5;
     7,1,6,8,6,1] else
    [7,1,2,8;
     7,3,2,8;
     7,3,4,8;
     7,5,4,8;
     7,5,6,8;
     7,1,6,8];
  Integer imax = size(K,2);
*/
    parameter Integer mult(min=1)=1 "multiplicity (6m-1 pulses/period)"
                                                                annotation(Evaluate=true);
    protected
    final parameter Integer m1=if sym then 2*mult else mult           annotation(Evaluate=true);
    final parameter Integer m2=if sym then 3*m1-1 else 4*m1-1        annotation(Evaluate=true);
    final parameter SI.Angle del_phi=pi/(3*m1) annotation(Evaluate=true);
    final parameter SI.Angle[m1] dphi=(del_phi/sqrt(3))*sin((1:m1)*del_phi) annotation(Evaluate=true);
    SI.Angle[m2] Phi;
    SI.Angle[m2] Dphi;
    Integer[6,:] K=if sym then
      [1,7,1,2,8,2;
       2,8,2,3,7,3;
       3,7,3,4,8,4;
       4,8,4,5,7,5;
       5,7,5,6,8,6;
       6,8,6,1,7,1] else
      [1,7,8,2;
       2,8,7,3;
       3,7,8,4;
       4,8,7,5;
       5,7,8,6;
       6,8,7,1];
    Integer imax = size(K,2);
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
      Documentation(
            info="<html>
</html>"),
        Diagram);
  equation
    if sym then
      Phi[1] = 0;
      Dphi[1] = dphi[m1];
      for m in 1:m1-1 loop
        Phi[3*m-1:3*m+1] = fill(m*del_phi, 3);
        Dphi[3*m-1:3*m+1] = {-dphi[m]-dphi[m1-m], (-1)^m*(dphi[m]-dphi[m1-m]), dphi[m]+dphi[m1-m]};
      end for;
      Phi[m2] = pi/3;
      Dphi[m2] = -dphi[m1];
    else
      Phi[1:2] = {0, del_phi/2};
      Dphi[1:2] = {dphi[m1], 0};
      for m in 1:m1-1 loop
        Phi[4*m-1:4*m+1] = fill(m*del_phi, 3);
        Dphi[4*m-1:4*m+1] = {-dphi[m]-dphi[m1-m], (dphi[m]-dphi[m1-m]), dphi[m]+dphi[m1-m]};
        Phi[4*m+2] = (0.5 + m)*del_phi;
        Dphi[4*m+2] = 0;
      end for;
      Phi[m2] = pi/3;
      Dphi[m2] = -dphi[m1];
    end if;
  end SVPWMasynBase;

  partial block SVPWMsynBase "Space vector PWM synchronous base"
    extends SVPWMbase;

    parameter Integer mult(min=1)=1 "multiplicity (6*mult-1 pulses/period)"
                                                                annotation(Evaluate=true);
    protected
    final parameter Integer m1=if sym then 2*mult else mult           annotation(Evaluate=true);
    final parameter Integer m2=if sym then 3*m1-1 else 4*m1-1        annotation(Evaluate=true);
    final parameter SI.Angle del_phi=pi/(3*m1) annotation(Evaluate=true);
    final parameter SI.Angle[m1] dphi=(del_phi/sqrt(3))*sin((1:m1)*del_phi) annotation(Evaluate=true);
    SI.Angle[m2] Phi;
    SI.Angle[m2] Dphi;
    Integer[6,:] K=if sym then
      [1,7,1,2,8,2;
       2,8,2,3,7,3;
       3,7,3,4,8,4;
       4,8,4,5,7,5;
       5,7,5,6,8,6;
       6,8,6,1,7,1] else
      [1,7,8,2;
       2,8,7,3;
       3,7,8,4;
       4,8,7,5;
       5,7,8,6;
       6,8,7,1];
    Integer imax = size(K,2);

  equation
    if sym then
      Phi[1] = 0;
      Dphi[1] = dphi[m1];
      for m in 1:m1-1 loop
        Phi[3*m-1:3*m+1] = fill(m*del_phi, 3);
        Dphi[3*m-1:3*m+1] = {-dphi[m]-dphi[m1-m], (-1)^m*(dphi[m]-dphi[m1-m]), dphi[m]+dphi[m1-m]};
      end for;
      Phi[m2] = pi/3;
      Dphi[m2] = -dphi[m1];
    else
      Phi[1:2] = {0, del_phi/2};
      Dphi[1:2] = {dphi[m1], 0};
      for m in 1:m1-1 loop
        Phi[4*m-1:4*m+1] = fill(m*del_phi, 3);
        Dphi[4*m-1:4*m+1] = {-dphi[m]-dphi[m1-m], (dphi[m]-dphi[m1-m]), dphi[m]+dphi[m1-m]};
        Phi[4*m+2] = (0.5 + m)*del_phi;
        Dphi[4*m+2] = 0;
      end for;
      Phi[m2] = pi/3;
      Dphi[m2] = -dphi[m1];
    end if;
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
      Documentation(
            info="<html>
</html>"),
        Diagram);
  end SVPWMsynBase;

  partial block PWMasynBase "Sine PWM asynchronous base"
    extends ModulatorBase;

    parameter SI.Frequency f_carr=1e3 "carrier frequency"
      annotation(Evaluate=true);
    parameter SI.Frequency dtmin(min=Modelica.Constants.eps,max=0.1*del_t)=1e-6
        "minimal time between on/off"
                                    annotation(Evaluate=true);
    protected
    final parameter SI.Time del_t=1/(4*f_carr)
                                              annotation(Evaluate=true);
    final parameter SI.Time delp_t=del_t - dtmin/2 annotation(Evaluate=true);
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
      Icon(
   Line(points=[-60,-30; -40,30; -20,-30; 0,30; 20,-30; 40,30; 60,-30], style(
                color=6, rgbcolor={255,255,0})),
                                 Line(points=[-60,-8; -50,0; -40,6; -30,10; -20,
                12; -6,14; 6,14; 20,12; 30,10; 40,6; 50,0; 60,-8], style(color=
                  62, rgbcolor={0,127,127}))),
      Documentation(
            info="<html>
</html>"),
        Diagram);

  end PWMasynBase;

  partial block PWMsynBase "Sine PWM synchronous base"
    extends ModulatorBase;

    parameter Integer mult(min=1)=3 "multiplicity (2*mult-1 pulses/period)"
                                                  annotation(Evaluate=true);
    parameter SI.Frequency dphimin(min=Modelica.Constants.eps,max=0.1*del_phi)=1e-6
        "minimal time between on/off"                            annotation(Evaluate=true);
    protected
    final parameter Integer m2=2*(2*mult-1)
                                         annotation(Evaluate=true);
    final parameter SI.Angle del_phi=pi/m2    annotation(Evaluate=true);
    final parameter SI.Angle delp_phi=del_phi-dphimin/2
                                                      annotation(Evaluate=true);
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
      Icon(
   Line(points=[-60,-30; -40,30; -20,-30; 0,30; 20,-30; 40,30; 60,-30], style(
                color=6, rgbcolor={255,255,0})),
                                 Line(points=[-60,-8; -50,0; -40,6; -30,10; -20,
                12; -6,14; 6,14; 20,12; 30,10; 40,6; 50,0; 60,-8], style(color=
                  62, rgbcolor={0,127,127}))),
      Documentation(
            info="<html>
</html>"),
        Diagram);

  end PWMsynBase;

  partial block BlockBase "Block modulator base"
    extends Base.Icons.BlockS;

    parameter Integer m(min=2,max=3)=3 "3 for 3-phase, 2 for 1-phase";
    parameter SI.Angle width=2/3 "relative width (0 - 1)";
    parameter SI.Frequency dphimin(min=Modelica.Constants.eps, max=pi)=1e-3
        "minimal phase angle on"
                               annotation(Evaluate=true);
    Modelica.Blocks.Interfaces.RealInput theta(redeclare type SignalType = SI.Angle)
        "reference angle"
      annotation (
          extent=[-70,90; -50,110], rotation=-90);
    Modelica.Blocks.Interfaces.RealInput[2] uPhasor
        "voltage demand pu {norm(v), phase(v)} (see info)"
                            annotation (extent=[50,90; 70,110], rotation=-90);
    Modelica.Blocks.Interfaces.BooleanOutput[2*m] gates "gates"
      annotation (
            extent=[-70,-110; -50,-90],  rotation=-90);
    protected
    final parameter Integer[m] pgt=1:2:(2*m-1) "positive gates" annotation(Evaluate=true);
    final parameter Integer[m] ngt=2:2:(2*m) "negative gates" annotation(Evaluate=true);

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
      Icon(
   Line(points=[-70,-30; -60,-30; -60,30; -30,30; -30,-30; 0,-30; 0,30; 30,30;
                30,-30; 60,-30; 60,30; 70,30], style(color=62, rgbcolor={0,120,
                  120})), Line(points=[-80,0; 80,0], style(color=0, rgbcolor={0,
                  0,0})),
        Rectangle(extent=[-80,120; -40,80], style(
              color=84,
              rgbcolor={213,170,255},
              fillColor=84,
              rgbfillColor={213,170,255})),
       Text(
      extent=[-100,100; 100,60],
      string="%name",
      style(color=0))),
      Documentation(
            info="<html>
</html>"),
        Diagram);

  end BlockBase;

end Partials;

package SpaceVector "Space vector logic and control"
  extends Base.Icons.SpecialLibrary;

  annotation (preferedView="info",
        Coordsys(
extent=[-100, -100; 100, 100],
grid=[2, 2],
component=[20, 20]), Window(
x=0.05,
y=0.44,
width=0.31,
height=0.25,
library=1,
autolayout=1),
      Documentation(info="<html>
<p>This package contains models from the library 'MotorControl', author Martin Kuhn, DLR Munich.<br>
Modifications needed for adaptation to Spot are mentioned in info-layer of the corresponding models.</p>
</html>
"));

  model SVMlogic "Logical part for SVM"

  annotation (
    Icon(
      Rectangle(extent=[-300,300; 300,-300], style(
        color=0,
        rgbcolor={0,0,0},
        fillColor=7,
        rgbfillColor={255,255,255})),
      Polygon(points=[-120,220; -260,0; 0,0; -120,220], style(
          pattern=0,
          fillColor=30,
          rgbfillColor={251,255,213})),
      Line(points=[72,0; 280,0], style(color=3, rgbcolor={0,0,255})),
      Line(points=[0,0; 120,220], style(color=30, rgbcolor={215,215,215})),
      Line(points=[0,0; 0,280], style(color=3, rgbcolor={0,0,255})),
      Line(points=[0,0; 72,0], style(color=3, rgbcolor={0,0,255})),
      Line(points=[0,0; 120,-220], style(color=30, rgbcolor={215,215,215})),
      Line(points=[0,0; -120,220], style(color=30, rgbcolor={215,215,215})),
      Line(points=[0,0; -120,-220], style(color=30, rgbcolor={215,215,215})),
      Line(points=[0,0; -72,0], style(color=30, rgbcolor={215,215,215})),
      Line(points=[0,-220; -120,-220; -260,0; -120,220; 120,220; 260,0; 120,
            -220; 0,-220], style(color=3, rgbcolor={0,0,255})),
      Line(points=[0,0; -258,0], style(color=30, rgbcolor={215,215,215})),
      Text(
        extent=[-244,26; -194,-4],
        style(
          color=30,
          rgbcolor={215,215,215},
          pattern=0,
          thickness=2,
          arrow=1,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="011"),
      Polygon(points=[0,290; -8,270; 10,270; 0,290], style(
          pattern=0,
          arrow=1,
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1)),
      Polygon(points=[290,0; 270,12; 270,-12; 290,0], style(
          pattern=0,
          arrow=1,
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1)),
      Text(
        extent=[-148,-222; -98,-252],
        style(
          color=30,
          rgbcolor={215,215,215},
          pattern=0,
          thickness=2,
          arrow=1,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="001"),
      Text(
        extent=[100,-222; 150,-252],
        style(
          color=30,
          rgbcolor={215,215,215},
          pattern=0,
          thickness=2,
          arrow=1,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="101"),
      Text(
        extent=[196,-2; 246,-32],
        style(
          color=30,
          rgbcolor={215,215,215},
          pattern=0,
          thickness=2,
          arrow=1,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="100"),
      Text(
        extent=[14,30; 64,0],
        style(
          color=30,
          rgbcolor={215,215,215},
          pattern=0,
          thickness=2,
          arrow=1,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="000"),
      Text(
        extent=[14,-4; 64,-34],
        style(
          color=30,
          rgbcolor={215,215,215},
          pattern=0,
          thickness=2,
          arrow=1,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="111"),
      Text(
        extent=[96,250; 146,220],
        style(
          color=30,
          rgbcolor={215,215,215},
          pattern=0,
          thickness=2,
          arrow=1,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="110"),
      Text(
        extent=[-144,250; -94,220],
        style(
          color=30,
          rgbcolor={215,215,215},
          pattern=0,
          thickness=2,
          arrow=1,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="010"),
      Text(
        extent=[108,90; 158,60],
        style(
          color=30,
          rgbcolor={215,215,215},
          pattern=0,
          thickness=2,
          arrow=1,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="S1"),
      Text(
        extent=[-4,152; 46,122],
        style(
          color=30,
          rgbcolor={215,215,215},
          pattern=0,
          thickness=2,
          arrow=1,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="S2"),
      Text(
        extent=[-154,96; -104,66],
        style(
          color=30,
          rgbcolor={215,215,215},
          pattern=0,
          thickness=2,
          arrow=1,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="S3"),
      Text(
        extent=[-154,-46; -104,-76],
        style(
          color=30,
          rgbcolor={215,215,215},
          pattern=0,
          thickness=2,
          arrow=1,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="S4"),
      Text(
        extent=[-28,-122; 22,-152],
        style(
          color=30,
          rgbcolor={215,215,215},
          pattern=0,
          thickness=2,
          arrow=1,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="S5"),
      Text(
        extent=[108,-42; 158,-72],
        style(
          color=30,
          rgbcolor={215,215,215},
          pattern=0,
          thickness=2,
          arrow=1,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="S6"),
      Text(
        extent=[220,96; 286,46],
        style(
          color=30,
          rgbcolor={215,215,215},
          fillPattern=1),
        string="U"),
      Text(
        extent=[12,280; 72,234],
        style(
          color=30,
          rgbcolor={215,215,215},
          fillPattern=1),
        string="U"),
      Text(
        extent=[50,258; 94,218],
        style(
          color=30,
          rgbcolor={215,215,215},
          fillPattern=1),
        string="beta"),
      Text(
        extent=[250,64; 300,36],
        style(
          color=30,
          rgbcolor={215,215,215},
          fillPattern=1),
        string="alpha"),     Text(extent=[-300,540; 300,300],   string=
              "%name")),
  Documentation(info="<html>
<p>Spot modification:<br>
<pre>
  V_s (dc voltage supply) omitted
  U_ab[2] (non normalised alpha-beta components) remamed to
  u_alpha_beta[2] (normalised alpha-beta components)
  abs(u_alpha_beta) = 1 corresponds to modulation index u = 1
</pre></p>
<h1>Space Vector Modulation</h1><br>
This part calculates the duty ratios of the space vector modulation.
A flowchart of the logic can be seen in the figure.<br>
<img src=\"../pics/flowchart_svm.png\"><br>
<br>
source: <a
href=\"http://mech2006.vtk.be/downloads_2eIr/Actuatoren/ACPWM_2pp.pdf?PHPSESSID=f9ae6311fa3cf286ff261e796a907f35\">Mech2006</a>
<br>
</p><br>
</html>"),
  Coordsys(extent=[-300,-300; 300,300]),
  Diagram(Text(
        extent=[-112,246; -42,220],
        style(color=30, rgbcolor={215,215,215}),
        string="u_beta>=0"), Text(
        extent=[-114,92; -44,66],
        style(color=30, rgbcolor={215,215,215}),
        string="u_beta<0")));

    parameter Modelica.SIunits.Time T_pwm "cycle time pwm";
    inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (extent=[-240,260; -200,280]);
    Modelica.StateGraph.Alternative Alternative1
    annotation (extent=[-238,-40; 284,280]);
    Modelica.Blocks.Interfaces.RealInput u_alpha_beta[2]
    annotation (extent=[-340,-20; -300,20]);
    Modelica.Blocks.Math.Product norm1
    annotation (extent=[-224,-124; -204,-104]);
    Modelica.Blocks.Sources.Constant n1(k=sqrt(3/2))
    annotation (extent=[-250,-80; -230,-60],
                                           rotation=270);
    Modelica.StateGraph.StepWithSignal sector2
    annotation (extent=[118,170; 138,190]);
    Modelica.StateGraph.TransitionWithSignal t1
    annotation (extent=[-124,190; -104,210]);
    Modelica.Blocks.Logical.GreaterEqual GreaterEqual1
    annotation (extent=[-148,-160; -128,-140]);
    Modelica.Blocks.Math.Gain Gain1(k=1/sqrt(3))
    annotation (extent=[-190,-168; -170,-148]);
    Modelica.Blocks.Logical.GreaterEqualThreshold GreaterEqualThreshold1
    annotation (extent=[-180,-80; -160,-60]);
    Modelica.Blocks.Logical.Not Not1
    annotation (extent=[-150,-100; -130,-80], rotation=0);
    Modelica.Blocks.Math.Product norm2
    annotation (extent=[-226,-204; -206,-184]);
    Modelica.Blocks.Logical.GreaterEqual GreaterEqual2
    annotation (extent=[-148,-240; -128,-220]);
    Modelica.Blocks.Math.Gain Gain3(k=-1/sqrt(3))
    annotation (extent=[-192,-248; -172,-228]);
    Modelica.StateGraph.TransitionWithSignal t2
    annotation (extent=[-124,30; -104,50]);
    Modelica.StateGraph.Alternative Alternative2
    annotation (extent=[-58,124; 218,276]);
    Modelica.StateGraph.Step Step1
                                 annotation (extent=[-94,190; -74,210]);
    Modelica.StateGraph.Step Step2
                                 annotation (extent=[-94,30; -74,50]);
    Modelica.StateGraph.Alternative Alternative3
    annotation (extent=[-58,-36; 218,116]);
    Modelica.StateGraph.Alternative Alternative5
    annotation (extent=[58,126; 184,198]);
    Modelica.StateGraph.Alternative Alternative7
    annotation (extent=[58,42; 184,114]);
    Modelica.StateGraph.TransitionWithSignal t3
    annotation (extent=[-4,228; 16,248]);
    Modelica.StateGraph.TransitionWithSignal t4
    annotation (extent=[-2,152; 18,172]);
    Modelica.StateGraph.Step Step3
                                 annotation (extent=[28,152; 48,172]);
    Modelica.StateGraph.Step Step4
                                 annotation (extent=[26,68; 46,88]);
    Modelica.StateGraph.TransitionWithSignal t5
                                              annotation (extent=[0,68; 20,88]);
    Modelica.StateGraph.TransitionWithSignal t6
                                              annotation (extent=[0,-8; 20,12]);
    Modelica.Blocks.Logical.Not Not2
    annotation (extent=[-100,-180; -80,-160],  rotation=0);
    Modelica.Blocks.Logical.Not Not3
    annotation (extent=[-100,-260; -80,-240],  rotation=0);
    Modelica.StateGraph.TransitionWithSignal t7
    annotation (extent=[88,170; 108,190]);
    Modelica.StateGraph.TransitionWithSignal t8
    annotation (extent=[88,134; 108,154]);
    Modelica.StateGraph.TransitionWithSignal t9
    annotation (extent=[88,86; 108,106]);
    Modelica.StateGraph.TransitionWithSignal t10
    annotation (extent=[88,50; 108,70]);
    Modelica.StateGraph.StepWithSignal sector3
    annotation (extent=[118,134; 138,154]);
    Modelica.StateGraph.StepWithSignal sector1
    annotation (extent=[118,228; 138,248]);
    Modelica.StateGraph.StepWithSignal sector6
    annotation (extent=[118,-8; 138,12]);
    Modelica.StateGraph.StepWithSignal sector5
    annotation (extent=[118,50; 138,70]);
    Modelica.StateGraph.StepWithSignal sector4
    annotation (extent=[118,86; 138,106]);
    Modelica.StateGraph.Transition t11(enableTimer=true, waitTime=T_pwm)
    annotation (extent=[148,228; 168,248]);
    Modelica.StateGraph.Transition t12(enableTimer=true, waitTime=T_pwm)
    annotation (extent=[148,170; 168,190]);
    Modelica.StateGraph.Transition t13(enableTimer=true, waitTime=T_pwm)
    annotation (extent=[148,134; 168,154]);
    Modelica.StateGraph.Transition t16(enableTimer=true, waitTime=T_pwm)
    annotation (extent=[148,-8; 168,12]);
    Modelica.StateGraph.Transition t15(enableTimer=true, waitTime=T_pwm)
    annotation (extent=[148,50; 168,70]);
    Modelica.StateGraph.Transition t14(enableTimer=true, waitTime=T_pwm)
    annotation (extent=[148,86; 168,106]);
    Modelica.Blocks.Logical.Or s1_4
                                  annotation (extent=[120,-120; 140,-100]);
    Modelica.Blocks.Logical.Or s2_5
                                  annotation (extent=[120,-180; 140,-160]);
    Modelica.Blocks.Logical.Or s3_6
                                  annotation (extent=[120,-250; 140,-230]);
    Modelica.Blocks.Sources.Constant zero[3](each k=0)
    annotation (extent=[180,-280; 200,-260]);
    SVMsector1p4 sector1p4      annotation (extent=[160,-100; 200,-60]);
    SVMsector2p5 sector2p5      annotation (extent=[160,-160; 200,-120]);
    SVMsector3p6 sector3p6      annotation (extent=[160,-220; 200,-180]);
    Modelica.Blocks.Nonlinear.Limiter Limiter[3]
  annotation (extent=[260,-120; 280,-100]);
    Modelica.Blocks.Logical.Switch Switch1[3]
  annotation (extent=[230,-120; 250,-100]);
    Modelica.Blocks.Logical.Switch Switch2[3]
  annotation (extent=[230,-180; 250,-160]);
    Modelica.Blocks.Logical.Switch Switch3[3]
  annotation (extent=[230,-250; 250,-230]);
    Modelica.Blocks.Interfaces.RealOutput dutyRatio[3]
  annotation (extent=[300,-140; 340,-100]);
    Modelica.Blocks.Routing.DeMultiplex2 alpha_beta
  annotation (extent=[-280,-160; -260,-140]);
    Modelica.Blocks.Interfaces.BooleanOutput trigger
    annotation (extent=[300,100; 340,140]);
    Modelica.StateGraph.InitialStep InitialStep1
    annotation (extent=[-280,110; -260,130]);
    Modelica.Blocks.Logical.Or Or1
                                 annotation (extent=[222,-72; 242,-52]);
    Modelica.Blocks.Logical.Or Or2
                                 annotation (extent=[260,-80; 280,-60]);
    TriggeredPulse TriggeredPulse1(T_pulse=1/10*T_pwm)
    annotation (extent=[280,-20; 300,0], rotation=90);

  equation
    connect(Gain1.y, GreaterEqual1.u2)
                                     annotation (points=[-169,-158; -150,-158],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(norm2.y, GreaterEqualThreshold1.u)  annotation (points=[-205,-194;
        -200,-194; -200,-70; -182,-70], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(Gain3.y, GreaterEqual2.u2)
                                     annotation (points=[-171,-238; -150,-238],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(norm1.y, GreaterEqual1.u1)  annotation (points=[-203,-114; -162,
        -114; -162,-150; -150,-150], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(GreaterEqual2.u1, norm1.y)  annotation (points=[-150,-230; -162,
        -230; -162,-114; -203,-114], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(norm2.y, Gain3.u)  annotation (points=[-205,-194; -200,-194; -200,
        -238; -194,-238], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(GreaterEqualThreshold1.y, Not1.u)
                                            annotation (points=[-159,-70;
      -156,-70; -156,-90; -152,-90],
                                  style(
      color=5,
      rgbcolor={255,0,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(GreaterEqualThreshold1.y, t1.condition)
                                                  annotation (points=[-159,-70;
        -122,-70; -122,178; -114,178; -114,188], style(
      color=5,
      rgbcolor={255,0,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(t1.outPort, Step1.inPort[1])
                                       annotation (points=[-112.5,200; -95,200],
      style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(Step1.outPort[1], Alternative2.inPort)
                                                 annotation (points=[-73.5,200;
            -62.14,200],
                     style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(t2.outPort, Step2.inPort[1])
                                       annotation (points=[-112.5,40; -95,40],
      style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(Step2.outPort[1], Alternative3.inPort)
                                                 annotation (points=[-73.5,40;
            -62.14,40],
                    style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(Step3.outPort[1], Alternative5.inPort)
                                                 annotation (points=[48.5,162;
        56.11,162], style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(t4.outPort,Step3. inPort[1])
                                       annotation (points=[9.5,162; 27,162],
      style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(t5.outPort,Step4. inPort[1])
                                       annotation (points=[11.5,78; 25,78],
                                                                          style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(Step4.outPort[1], Alternative7.inPort)
                                                 annotation (points=[46.5,78;
        56.11,78],style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(GreaterEqual1.y, t3.condition)
                                         annotation (points=[-127,-150; -10,
        -150; -10,220; 6,220; 6,226], style(
      color=5,
      rgbcolor={255,0,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(Not1.y, t2.condition)
                                annotation (points=[-129,-90; -120,-90;
      -120,20; -114,20; -114,28],
                           style(
      color=5,
      rgbcolor={255,0,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(GreaterEqual1.y, Not2.u)
                                   annotation (points=[-127,-150; -120,-150;
        -120,-170; -102,-170], style(
      color=5,
      rgbcolor={255,0,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(GreaterEqual2.y, Not3.u)
                                   annotation (points=[-127,-230; -120,-230;
        -120,-250; -102,-250], style(
      color=79,
      rgbcolor={170,85,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(Not2.y, t4.condition)
                                annotation (points=[-79,-170; -8,-170; -8,140;
        8,140; 8,150], style(
      color=5,
      rgbcolor={255,0,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(GreaterEqual2.y, t6.condition)
                                         annotation (points=[-127,-230; 2,-230;
        2,-18; 10,-18; 10,-10],
                              style(
      color=79,
      rgbcolor={170,85,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(Not3.y,t5. condition)
                                annotation (points=[-79,-250; 0,-250; 0,60; 10,
        60; 10,66],      style(
      color=79,
      rgbcolor={170,85,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(GreaterEqual2.y, t7.condition)
                                         annotation (points=[-127,-230; 78,-230;
        78,162; 98,162; 98,168], style(
      color=79,
      rgbcolor={170,85,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(Not3.y, t8.condition)
                                annotation (points=[-79,-250; 80,-250; 80,120;
        98,120; 98,132], style(
      color=79,
      rgbcolor={170,85,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(GreaterEqual1.y, t10.condition)
                                         annotation (points=[-127,-150; 88,-150;
        88,44; 98,44; 98,48],
                           style(
      color=5,
      rgbcolor={255,0,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(Not2.y, t9.condition)
                                 annotation (points=[-79,-170; 86,-170; 86,78;
        98,78; 98,84],   style(
      color=5,
      rgbcolor={255,0,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(t2.inPort, Alternative1.split[2])
                                            annotation (points=[-118,40;
        -183.19,40], style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(t1.inPort, Alternative1.split[1])
                                            annotation (points=[-118,200;
        -183.19,200], style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(t3.inPort, Alternative2.split[1])
                                            annotation (points=[2,238; -29.02,
            238],
              style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(t4.inPort, Alternative2.split[2])
                                            annotation (points=[4,162; -29.02,
            162],
              style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(t7.inPort, Alternative5.split[1])
                                            annotation (points=[94,180; 71.23,
            180],
              style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(t8.inPort, Alternative5.split[2])
                                            annotation (points=[94,144; 71.23,
            144],
              style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(t7.outPort, sector2.inPort[1])
                                         annotation (points=[99.5,180; 117,180],
      style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(sector4.inPort[1], t9.outPort)
                                          annotation (points=[117,96; 99.5,96],
      style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(sector5.inPort[1], t10.outPort)
                                         annotation (points=[117,60; 99.5,60],
      style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(t3.outPort, sector1.inPort[1])
                                         annotation (points=[7.5,238; 117,238],
      style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(t6.outPort, sector6.inPort[1])
                                         annotation (points=[11.5,2; 117,2],
      style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(t8.outPort, sector3.inPort[1])
                                         annotation (points=[99.5,144; 117,144],
      style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(Alternative5.outPort, Alternative2.join[2])
                                                      annotation (points=[185.26,
            162; 189.02,162],    style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(Alternative3.outPort, Alternative1.join[2])
                                                      annotation (points=[220.76,
        40; 229.19,40],        style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(Alternative2.outPort, Alternative1.join[1])
                                                      annotation (points=[220.76,
        200; 229.19,200],        style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(sector1.outPort[1], t11.inPort)
                                          annotation (points=[138.5,238; 154,
        238], style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(sector5.outPort[1], t15.inPort)
                                          annotation (points=[138.5,60; 154,60],
      style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(sector4.outPort[1],t14. inPort)
                                          annotation (points=[138.5,96; 154,96],
              style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(sector6.outPort[1], t16.inPort)
                                          annotation (points=[138.5,2; 154,2],
      style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(sector3.outPort[1], t13.inPort)
                                          annotation (points=[138.5,144; 154,
        144], style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(sector2.outPort[1], t12.inPort)
                                          annotation (points=[138.5,180; 154,
        180], style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(t12.outPort, Alternative5.join[1])
                                             annotation (points=[159.5,180;
            170.77,180],
                     style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(t13.outPort, Alternative5.join[2])
                                             annotation (points=[159.5,144;
            170.77,144],
                     style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(t11.outPort, Alternative2.join[1])
                                             annotation (points=[159.5,238;
            189.02,238],
                     style(
      color=0,
      rgbcolor={0,0,0},
      fillPattern=1));
    connect(sector1.active, s1_4.u1)
                                   annotation (points=[128,227; 128,220; 112,
        220; 112,-110; 118,-110], style(
      color=5,
      rgbcolor={255,0,255},
      fillPattern=1));
    connect(sector2.active, s2_5.u1)
                                   annotation (points=[128,169; 128,164;
      112,164; 112,-170; 118,-170],
                                  style(
      color=5,
      rgbcolor={255,0,255},
      fillPattern=1));
    connect(sector3.active, s3_6.u1)
                                   annotation (points=[128,133; 128,120; 112,
        120; 112,-240; 118,-240], style(
      color=5,
      rgbcolor={255,0,255},
      fillPattern=1));
      connect(sector1p4.u_alpha, sector2p5.u_alpha)         annotation (
    points=[158,-74; 148,-74; 148,-134; 158,-134], style(
    color=74,
    rgbcolor={0,0,127},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
      connect(sector2p5.u_alpha, sector3p6.u_alpha)         annotation (
    points=[158,-134; 148,-134; 148,-194; 158,-194], style(
    color=74,
    rgbcolor={0,0,127},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
      connect(sector3p6.u_beta, sector2p5.u_beta)         annotation (
    points=[158,-206; 152,-206; 152,-146; 158,-146], style(
    color=74,
    rgbcolor={0,0,127},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
      connect(sector2p5.u_beta, sector1p4.u_beta)         annotation (
    points=[158,-146; 152,-146; 152,-86; 158,-86], style(
    color=74,
    rgbcolor={0,0,127},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
    connect(Switch3.y, Switch2.u3)
                                 annotation (points=[251,-240; 260,-240;
      260,-200; 220,-200; 220,-178; 228,-178], style(
    color=74,
    rgbcolor={0,0,127},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
    connect(Switch2.y, Switch1.u3)
                                 annotation (points=[251,-170; 260,-170;
      260,-140; 220,-140; 220,-118; 228,-118], style(
    color=74,
    rgbcolor={0,0,127},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
    connect(Switch1.y, Limiter.u) annotation (points=[251,-110; 258,-110],
    style(
    color=74,
    rgbcolor={0,0,127},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
    connect(Limiter.y, dutyRatio)
                         annotation (points=[281,-110; 290,-110; 290,-120; 320,
        -120],   style(
    color=74,
    rgbcolor={0,0,127},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
    connect(s1_4.y, Switch1[1].u2) annotation (points=[141,-110; 228,-110],
    style(
    color=5,
    rgbcolor={255,0,255},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
    connect(s1_4.y, Switch1[2].u2) annotation (points=[141,-110; 228,-110],
                       style(
    color=5,
    rgbcolor={255,0,255},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
    connect(s1_4.y, Switch1[3].u2) annotation (points=[141,-110; 228,-110],
    style(
    color=5,
    rgbcolor={255,0,255},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
    connect(s2_5.y, Switch2[1].u2) annotation (points=[141,-170; 228,-170],
    style(
    color=5,
    rgbcolor={255,0,255},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
    connect(s2_5.y, Switch2[2].u2) annotation (points=[141,-170; 228,-170],
    style(
    color=5,
    rgbcolor={255,0,255},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
    connect(s2_5.y, Switch2[3].u2) annotation (points=[141,-170; 228,-170],
    style(
    color=5,
    rgbcolor={255,0,255},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
    connect(s3_6.y, Switch3[1].u2) annotation (points=[141,-240; 228,-240],
                       style(
    color=5,
    rgbcolor={255,0,255},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
    connect(s3_6.y, Switch3[2].u2) annotation (points=[141,-240; 228,-240],
    style(
    color=5,
    rgbcolor={255,0,255},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
    connect(s3_6.y, Switch3[3].u2) annotation (points=[141,-240; 228,-240],
    style(
    color=5,
    rgbcolor={255,0,255},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
    connect(zero.y, Switch3.u3) annotation (points=[201,-270; 210,-270; 210,
      -248; 228,-248], style(
    color=74,
    rgbcolor={0,0,127},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
    connect(alpha_beta.y1[1], norm1.u2)
                                       annotation (points=[-259,-144; -250,-144;
        -250,-120; -226,-120],              style(color=74, rgbcolor={0,0,
        127}));
      connect(alpha_beta.u, u_alpha_beta)
                                       annotation (points=[-282,-150; -290,-150;
            -290,0;
        -320,0],
    style(color=74, rgbcolor={0,0,127}));
    connect(alpha_beta.y2[1], norm2.u2)
                                       annotation (points=[-259,-156; -250,-156;
        -250,-200; -228,-200],     style(color=74, rgbcolor={0,0,127}));
    connect(norm2.y, Gain1.u)
                             annotation (points=[-205,-194; -200,-194; -200,
        -158; -192,-158],
                        style(color=74, rgbcolor={0,0,127}));
    connect(InitialStep1.outPort[1], Alternative1.inPort)
                                                        annotation (points=[-259.5,
            120; -245.83,120],    style(color=0, rgbcolor={0,0,0}));
    connect(InitialStep1.inPort[1], Alternative1.outPort)
                                                        annotation (points=[-281,120;
            -292,120; -292,290; 288,290; 288,120; 289.22,120],
              style(color=0, rgbcolor={0,0,0}));
    connect(s1_4.y, Or1.u1)
                          annotation (points=[141,-110; 214,-110; 214,-62; 220,
        -62],                   style(color=5, rgbcolor={255,0,255}));
    connect(s2_5.y, Or1.u2)
                          annotation (points=[141,-170; 216,-170; 216,-70; 220,
        -70],                   style(color=5, rgbcolor={255,0,255}));
    connect(Or1.y, Or2.u1)
                         annotation (points=[243,-62; 250,-62; 250,-70; 258,-70],
                           style(color=5, rgbcolor={255,0,255}));
    connect(s3_6.y, Or2.u2)
                          annotation (points=[141,-240; 218,-240; 218,-78; 258,
        -78], style(color=5, rgbcolor={255,0,255}));
      connect(norm1.y, sector1p4.u_alpha)      annotation (points=[-203,-114;
        -40,-114; -40,-74; 158,-74], style(color=74, rgbcolor={0,0,127}));
      connect(norm2.y, sector1p4.u_beta)      annotation (points=[-205,-194;
        -200,-194; -200,-122; -32,-122; -32,-86; 158,-86], style(color=74,
        rgbcolor={0,0,127}));
    connect(Alternative3.split[2], t6.inPort)
    annotation (points=[-29.02,2; 6,2], style(color=0, rgbcolor={0,0,0}));
    connect(Alternative3.split[1], t5.inPort)
    annotation (points=[-29.02,78; 6,78], style(color=0, rgbcolor={0,0,0}));
    connect(Alternative7.split[1], t9.inPort)
    annotation (points=[71.23,96; 94,96], style(color=0, rgbcolor={0,0,0}));
    connect(Alternative7.split[2], t10.inPort)
    annotation (points=[71.23,60; 94,60], style(color=0, rgbcolor={0,0,0}));
    connect(t14.outPort, Alternative7.join[1])
                                             annotation (points=[159.5,96;
            170.77,96],
                    style(color=0, rgbcolor={0,0,0}));
    connect(t15.outPort, Alternative7.join[2])
                                             annotation (points=[159.5,60;
            170.77,60],
                    style(color=0, rgbcolor={0,0,0}));
    connect(t16.outPort, Alternative3.join[2])
    annotation (points=[159.5,2; 189.02,2], style(color=0, rgbcolor={0,0,0}));
    connect(Alternative7.outPort, Alternative3.join[1])
                                                      annotation (points=[185.26,
            78; 189.02,78],    style(color=0, rgbcolor={0,0,0}));
    connect(sector4.active, s1_4.u2)
                                   annotation (points=[128,85; 128,78; 112,78;
        112,-118; 118,-118], style(color=5, rgbcolor={255,0,255}));
    connect(sector5.active, s2_5.u2)
                                   annotation (points=[128,49; 128,44; 112,44;
        112,-178; 118,-178], style(color=5, rgbcolor={255,0,255}));
    connect(sector6.active, s3_6.u2)
                                   annotation (points=[128,-9; 128,-14; 112,-14;
        112,-248; 118,-248], style(color=5, rgbcolor={255,0,255}));
      connect(sector3p6.abc, Switch3.u1) annotation (points=[202,-200; 212,-200;
        212,-232; 228,-232], style(color=74, rgbcolor={0,0,127}));
      connect(sector2p5.abc, Switch2.u1) annotation (points=[202,-140; 212,-140;
        212,-162; 228,-162], style(color=74, rgbcolor={0,0,127}));
      connect(sector1p4.abc, Switch1.u1) annotation (points=[202,-80; 210,-80;
        210,-102; 228,-102], style(color=74, rgbcolor={0,0,127}));
    connect(Or2.y, TriggeredPulse1.u)
                                    annotation (points=[281,-70; 290,-70; 290,
        -21], style(color=5, rgbcolor={255,0,255}));
    connect(trigger, TriggeredPulse1.y)
                                      annotation (points=[320,120; 296,
      120; 296,52; 290,52; 290,1],
                            style(color=5, rgbcolor={255,0,255}));
    connect(n1.y, norm1.u1) annotation (points=[-240,-81; -240,-108; -226,-108],
          style(color=74, rgbcolor={0,0,127}));
    connect(n1.y, norm2.u1) annotation (points=[-240,-81; -240,-188; -228,-188],
          style(color=74, rgbcolor={0,0,127}));
  end SVMlogic;

model SVMpwm "Block generating the pwm pulses for SVM"

  annotation (
    Icon(
      Rectangle(extent=[-200,200; 200,-200], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=7,
          rgbfillColor={255,255,255})),
      Line(points=[-130,140; -130,-78], style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2)),
      Text(
        extent=[-190,170; -110,140],
        string="000",
        style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Text(
        extent=[-150,150; -70,120],
        string="100",
        style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Text(
        extent=[-98,150; -18,120],
        string="110",
        style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Text(
        extent=[-50,170; 30,140],
        string="111",
        style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Text(
        extent=[-10,150; 70,120],
        string="110",
        style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Text(
        extent=[42,150; 122,120],
        string="100",
        style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Text(
        extent=[102,170; 162,140],
        string="000",
        style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Line(points=[-40,-120; -158,-120], style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Line(points=[138,-120; 0,-120], style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Text(
        extent=[-34,-108; -12,-132],
        string="T",
        style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Text(
        extent=[-20,-124; 4,-134],
        string="PWM",
        style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Polygon(points=[-170,-120; -158,-112; -158,-126; -170,-120], style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=30,
          rgbfillColor={215,215,215},
          fillPattern=1)),
      Polygon(points=[150,-120; 138,-114; 138,-128; 150,-120], style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=30,
          rgbfillColor={215,215,215},
          fillPattern=1)),
      Text(
        extent=[142,122; 182,82],
        string="u",
        style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Text(
        extent=[170,100; 190,80],
        string="a0",
        style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Line(points=[150,120; 150,-140], style(color=3, rgbcolor={0,0,255})),
      Line(points=[-30,140; -30,-80], style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2)),
      Line(points=[10,140; 10,-82], style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2)),
      Line(points=[110,140; 110,-80], style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2)),
      Line(points=[-90,140; -90,-80], style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2)),
      Line(points=[50,140; 50,-80], style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2)),
      Text(
        extent=[142,42; 182,2],
        string="u",
        style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Text(
        extent=[170,20; 190,0],
        style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="b0"),
      Text(
        extent=[142,-38; 182,-78],
        string="u",
        style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Text(
        extent=[170,-60; 190,-80],
        style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="c0"),
      Line(points=[-190,80; -130,80; -130,120; 110,120; 110,80; 170,80], style(
            color=3, rgbcolor={0,0,255})),
      Line(points=[-190,0; -90,0; -90,40; 50,40; 50,0; 170,0], style(color=3,
            rgbcolor={0,0,255})),
      Line(points=[-190,-80; -30,-80; -30,-40; 10,-40; 10,-80; 168,-80], style(
            color=3, rgbcolor={0,0,255})),
      Line(points=[-170,140; -170,-140], style(color=3, rgbcolor={0,0,255})),
                           Text(extent=[-202,360; 200,200],   string=
            "%name")),
    Diagram,
    Coordsys(extent=[-200,-200; 200,200]),
    Documentation(info="<html>
<p>Spot modification:
<pre>
  Dimension of 'Switch' changed from 3 to 6
  signals for n-gates added.
</pre></p>
<p>PWM generation for space vector modulation, as done e.g. by TI's TMSM320P14 DSP.<br>
A duty ratio a=1 indicates a continuously closed upper switch of the first inverter leg. At a duty ratio a=0, the turn-on time during each PWM period is equally distributed to the lower and upper switch and the resulting mean value of the phase voltage u_a0 is zero. At a duty ratio a=-1, the lower switch is continuously closed, etc.</p>
</html>"));
  parameter Modelica.SIunits.Time T_pwm;
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (extent=[-180,160; -140,180]);
  Modelica.Blocks.Interfaces.BooleanInput trigger
    annotation (extent=[-240,60; -200,100]);
  Modelica.Blocks.Interfaces.RealInput dutyRatio[3]
    annotation (extent=[-240,-100; -200,-60]);
  Modelica.Blocks.Interfaces.BooleanOutput switch[6]
    annotation (extent=[200,-20; 240,20]);
  Modelica.Blocks.Routing.DeMultiplex3 DeMultiplex3_1
    annotation (extent=[-160,-160; -140,-140]);
  Modelica.Blocks.Sources.Constant one annotation (extent=[-150,-100; -130,-80]);
  Modelica.Blocks.Math.Feedback t1     annotation (extent=[-110,-100; -90,-80]);
  Modelica.Blocks.Math.Gain start_100(k=1/2)
    annotation (extent=[-80,-100; -60,-80]);
  Modelica.Blocks.Logical.GreaterEqual GreaterEqual1
    annotation (extent=[0,160; 20,180],  rotation=0);
  Modelica.Blocks.Math.Gain start_010(k=1/2)
    annotation (extent=[-80,-140; -60,-120]);
  Modelica.Blocks.Math.Feedback t2     annotation (extent=[-110,-140; -90,-120]);
  Modelica.Blocks.Math.Gain start_001(k=1/2)
    annotation (extent=[-80,-180; -60,-160]);
  Modelica.Blocks.Math.Feedback t3   annotation (extent=[-110,-180; -90,-160]);
  Modelica.Blocks.Logical.GreaterEqual GreaterEqual2
    annotation (extent=[0,80; 20,100],  rotation=0);
  Modelica.Blocks.Logical.GreaterEqual GreaterEqual3
    annotation (extent=[0,0; 20,20], rotation=0);
  Modelica.Blocks.Math.Add stop_100    annotation (extent=[20,-106; 40,-86]);
  Modelica.Blocks.Math.Add stop_010    annotation (extent=[20,-146; 40,-126]);
  Modelica.Blocks.Math.Add stop_001    annotation (extent=[20,-186; 40,-166]);
  Modelica.Blocks.Logical.GreaterEqual GreaterEqual4
    annotation (extent=[80,140; 100,160],
                                        rotation=0);
  Modelica.Blocks.Logical.GreaterEqual GreaterEqual5
    annotation (extent=[80,60; 100,80], rotation=0);
  Modelica.Blocks.Logical.GreaterEqual GreaterEqual6
    annotation (extent=[80,-20; 100,0],
                                      rotation=0);
  Modelica.Blocks.Discrete.TriggeredSampler load_data[3]
    annotation (extent=[-200,-100; -180,-120], rotation=90);
  Modelica.Blocks.Logical.Timer Timer annotation (extent=[-160,-50; -140,-30]);
  Modelica.Blocks.Math.Gain time_scaling(k=1/T_pwm)
    annotation (extent=[-100,-50; -80,-30]);
  Modelica.Blocks.Logical.Edge Edge annotation (extent=[-180,40; -160,60],
      rotation=270);
  Modelica.Blocks.Logical.Not Not annotation (extent=[-180,0; -160,20],
      rotation=270);
  DutyRatioToCycle dutyRtoC
                         annotation (extent=[-190,-160; -170,-140]);
  Modelica.Blocks.Logical.And And1 annotation (extent=[160,160; 180,180]);
  Modelica.Blocks.Logical.Not Not1 annotation (extent=[120,140; 140,160]);
  Modelica.Blocks.Logical.Not Not2 annotation (extent=[120,60; 140,80]);
  Modelica.Blocks.Logical.And And2 annotation (extent=[160,80; 180,100]);
  Modelica.Blocks.Logical.Not Not3 annotation (extent=[120,-20; 140,0]);
  Modelica.Blocks.Logical.And And3 annotation (extent=[160,0; 180,20]);
  Modelica.Blocks.Logical.Not Not4 annotation (extent=[160,120; 180,140]);
  Modelica.Blocks.Logical.Not Not5 annotation (extent=[160,40; 180,60]);
  Modelica.Blocks.Logical.Not Not6 annotation (extent=[160,-40; 180,-20]);

equation
  connect(one.y, t1.u1)     annotation (points=[-129,-90; -108,-90], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(t1.y, start_100.u)       annotation (points=[-91,-90; -82,-90], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(start_100.y, GreaterEqual1.u2)   annotation (points=[-59,-90; -50,-90;
        -50,162; -2,162],          style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(t2.y, start_010.u)       annotation (points=[-91,-130; -82,-130],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(t3.y, start_001.u)   annotation (points=[-91,-170; -82,-170], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(one.y, t2.u1)     annotation (points=[-129,-90; -120,-90; -120,-130;
        -108,-130], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(one.y, t3.u1)   annotation (points=[-129,-90; -120,-90; -120,-170;
        -108,-170], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(DeMultiplex3_1.y2[1], t2.u2)     annotation (points=[-139,-150; -100,
        -150; -100,-138], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(DeMultiplex3_1.y3[1], t3.u2)   annotation (points=[-139,-157; -130,
        -157; -130,-190; -100,-190; -100,-178], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(start_010.y, GreaterEqual2.u2)   annotation (points=[-59,-130; -40,
            -130; -40,82; -2,82],
                       style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(start_001.y, GreaterEqual3.u2) annotation (points=[-59,-170; -30,-170;
            -30,2; -2,2],
                style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(DeMultiplex3_1.y1[1], t1.u2)     annotation (points=[-139,-143; -130,
        -143; -130,-110; -100,-110; -100,-98], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(start_100.y, stop_100.u1)      annotation (points=[-59,-90; 18,-90],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(start_010.y, stop_010.u1)      annotation (points=[-59,-130; 18,-130],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(stop_010.u2, DeMultiplex3_1.y2[1])    annotation (points=[18,-142; 10,
        -142; 10,-150; -139,-150], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(start_001.y, stop_001.u1)    annotation (points=[-59,-170; 18,-170],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(stop_001.u2, DeMultiplex3_1.y3[1])    annotation (points=[18,-182; 10,
        -182; 10,-190; -130,-190; -130,-157; -139,-157], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(stop_010.y, GreaterEqual5.u2)    annotation (points=[41,-136; 60,-136;
            60,62; 78,62],
                       style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(dutyRatio, load_data.u)
                             annotation (points=[-220,-80; -190,-80; -190,-98],
      style(color=74, rgbcolor={0,0,127}));
  connect(stop_001.y, GreaterEqual6.u2)    annotation (points=[41,-176; 70,-176;
            70,-18; 78,-18],
                style(color=74, rgbcolor={0,0,127}));
  connect(stop_100.y, GreaterEqual4.u2)    annotation (points=[41,-96; 50,-96;
        50,142; 78,142],
                 style(color=74, rgbcolor={0,0,127}));
  connect(Timer.y, time_scaling.u)    annotation (points=[-139,-40; -102,-40],
      style(color=74, rgbcolor={0,0,127}));
  connect(Not.y, Timer.u) annotation (points=[-170,-1; -170,-40; -162,-40],
                                                                   style(color=
          5, rgbcolor={255,0,255}));
  connect(trigger, load_data[1].trigger) annotation (points=[-220,80; -188,80;
        -188,-60; -170,-60; -170,-110; -178.2,-110], style(color=5, rgbcolor={
          255,0,255}));
  connect(trigger, load_data[2].trigger) annotation (points=[-220,80; -188,80;
        -188,-60; -170,-60; -170,-110; -178.2,-110], style(color=5, rgbcolor={
          255,0,255}));
  connect(trigger, load_data[3].trigger) annotation (points=[-220,80; -188,80;
        -188,-60; -170,-60; -170,-110; -178.2,-110], style(color=5, rgbcolor={
          255,0,255}));
  connect(GreaterEqual1.u1, GreaterEqual2.u1) annotation (points=[-2,170; -60,
            170; -60,90; -2,90],
                             style(color=74, rgbcolor={0,0,127}));
  connect(GreaterEqual2.u1, GreaterEqual3.u1) annotation (points=[-2,90; -60,90;
            -60,10; -2,10],                      style(color=74, rgbcolor={0,0,
          127}));
  connect(GreaterEqual3.u1, GreaterEqual6.u1) annotation (points=[-2,10; -60,10;
            -60,-40; 40,-40; 40,-10; 78,-10],style(color=74, rgbcolor={0,0,127}));
  connect(GreaterEqual6.u1, GreaterEqual5.u1) annotation (points=[78,-10; 40,
            -10; 40,70; 78,70],
                       style(color=74, rgbcolor={0,0,127}));
  connect(GreaterEqual5.u1, GreaterEqual4.u1) annotation (points=[78,70; 40,70;
            40,150; 78,150],
                         style(color=74, rgbcolor={0,0,127}));
  connect(Edge.y, Not.u) annotation (points=[-170,39; -170,22], style(
      color=5,
      rgbcolor={255,0,255},
      pattern=0,
      fillColor=30,
      rgbfillColor={215,215,215},
      fillPattern=1));
  connect(stop_100.u2, DeMultiplex3_1.y1[1]) annotation (points=[18,-102; 10,
        -102; 10,-110; -130,-110; -130,-143; -139,-143], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=7,
      rgbfillColor={255,255,255},
      fillPattern=1));
  connect(Edge.u, trigger) annotation (points=[-170,62; -170,80; -220,80],
      style(color=5, rgbcolor={255,0,255}));
  connect(time_scaling.y, GreaterEqual1.u1) annotation (points=[-79,-40; -60,
        -40; -60,170; -2,170], style(color=74, rgbcolor={0,0,127}));
  connect(GreaterEqual4.y, Not1.u) annotation (points=[101,150; 118,150], style(
        color=5, rgbcolor={255,0,255}));
  connect(GreaterEqual1.y, And1.u1) annotation (points=[21,170; 158,170], style(
        color=5, rgbcolor={255,0,255}));
  connect(Not1.y, And1.u2) annotation (points=[141,150; 150,150; 150,162; 158,
        162], style(color=5, rgbcolor={255,0,255}));
  connect(Not2.y, And2.u2) annotation (points=[141,70; 150,70; 150,82; 158,82],
      style(color=5, rgbcolor={255,0,255}));
  connect(Not3.y, And3.u2) annotation (points=[141,-10; 150,-10; 150,2; 158,2],
      style(color=5, rgbcolor={255,0,255}));
  connect(GreaterEqual6.y, Not3.u)
    annotation (points=[101,-10; 118,-10],
                                         style(color=5, rgbcolor={255,0,255}));
  connect(GreaterEqual3.y, And3.u1)
    annotation (points=[21,10; 158,10], style(color=5, rgbcolor={255,0,255}));
  connect(GreaterEqual2.y, And2.u1) annotation (points=[21,90; 158,90],   style(
        color=5, rgbcolor={255,0,255}));
  connect(GreaterEqual5.y, Not2.u)
    annotation (points=[101,70; 118,70], style(color=5, rgbcolor={255,0,255}));
  connect(And1.y, Not4.u) annotation (points=[181,170; 184,170; 184,150; 158,
            150; 158,130], style(color=5, rgbcolor={255,0,255}));
  connect(And2.y, Not5.u) annotation (points=[181,90; 184,90; 184,68; 158,68;
            158,50], style(color=5, rgbcolor={255,0,255}));
  connect(And3.y, Not6.u) annotation (points=[181,10; 184,10; 184,-10; 158,-10;
            158,-30], style(color=5, rgbcolor={255,0,255}));
  connect(And1.y, switch[1]) annotation (points=[181,170; 200,170; 200,22; 220,
            22; 220,-16.6667], style(color=5, rgbcolor={255,0,255}));
  connect(Not4.y, switch[2]) annotation (points=[181,130; 200,130; 200,-10; 220,
            -10], style(color=5, rgbcolor={255,0,255}));
  connect(And2.y, switch[3]) annotation (points=[181,90; 200,90; 200,-3.33333;
            220,-3.33333], style(color=5, rgbcolor={255,0,255}));
  connect(Not5.y, switch[4]) annotation (points=[181,50; 200,50; 200,3.33333;
            220,3.33333], style(color=5, rgbcolor={255,0,255}));
  connect(And3.y, switch[5]) annotation (points=[181,10; 190.5,10; 190.5,10;
            220,10], style(color=5, rgbcolor={255,0,255}));
  connect(Not6.y, switch[6]) annotation (points=[181,-30; 200,-30; 200,16.6667;
            220,16.6667], style(color=5, rgbcolor={255,0,255}));
  connect(load_data.y, dutyRtoC.dutyRatio) annotation (points=[-190,-121; -190,
            -130; -200,-130; -200,-150; -192,-150], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1));
  connect(dutyRtoC.dutyCycle, DeMultiplex3_1.u) annotation (points=[-168,-150;
            -162,-150], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1));
end SVMpwm;

model SVMsector1p4 "Sector 1-4"

annotation (Diagram, Icon(
    Rectangle(extent=[-100,100; 100,-100], style(
        color=0,
        rgbcolor={0,0,0},
        fillColor=6,
        rgbfillColor={255,255,0})),
    Text(
      extent=[-80,70; 80,30],
      style(
        color=30,
        rgbcolor={215,215,215},
        fillColor=6,
        rgbfillColor={255,255,0},
        fillPattern=1),
            string="b = -ua + 3/sqrt(3) ub"),
    Text(
      extent=[-72,40; -16,0],
      style(
        color=30,
        rgbcolor={215,215,215},
        fillColor=6,
        rgbfillColor={255,255,0},
        fillPattern=1),
            string="c = -a "),
    Text(
      extent=[-80,100; 80,60],
      style(
        color=30,
        rgbcolor={215,215,215},
        fillColor=6,
        rgbfillColor={255,255,0},
        fillPattern=1),
            string="a =  ua + 1/sqrt(3) ub"),
    Text(
      extent=[-100,-10; 100,-90],
      style(color=0, rgbcolor={0,0,0}),
            string="S1&4"),Text(extent=[-150,150; 150,110],   string=
            "%name")));
  Modelica.Blocks.Interfaces.RealInput u_alpha
  annotation (extent=[-120,20; -100,40]);
  Modelica.Blocks.Interfaces.RealInput u_beta
  annotation (extent=[-120,-40; -100,-20]);
  Modelica.Blocks.Interfaces.RealOutput abc[3]
  annotation (extent=[100,-10; 120,10]);
  Modelica.Blocks.Math.Add Add1
                              annotation (extent=[0,50; 20,70]);
  Modelica.Blocks.Math.Gain Gain1(k=1/(sqrt(3)))
  annotation (extent=[-60,40; -40,60]);
  Modelica.Blocks.Math.Gain Gain2(k=-1)
                                      annotation (extent=[60,-70; 80,-50]);
  Modelica.Blocks.Math.Gain Gain3(k=-1)
                                      annotation (extent=[-40,0; -20,20]);
  Modelica.Blocks.Math.Add Add2
                              annotation (extent=[0,-10; 20,10]);
  Modelica.Blocks.Math.Gain Gain4(k=3/(sqrt(3)))
  annotation (extent=[-40,-40; -20,-20]);

equation
  connect(u_alpha, Add1.u1)
                          annotation (points=[-110,30; -80,30; -80,66; -2,
      66], style(color=74, rgbcolor={0,0,127}));
  connect(u_beta, Gain1.u)
                         annotation (points=[-110,-30; -70,-30; -70,50; -62,
      50], style(color=74, rgbcolor={0,0,127}));
  connect(Gain1.y, Add1.u2)
                          annotation (points=[-39,50; -20,50; -20,54; -2,54],
    style(color=74, rgbcolor={0,0,127}));
  connect(Add1.y, Gain2.u)
                         annotation (points=[21,60; 40,60; 40,-60; 58,-60],
    style(color=74, rgbcolor={0,0,127}));
  connect(u_alpha, Gain3.u)
                          annotation (points=[-110,30; -80,30; -80,10; -42,
      10], style(color=74, rgbcolor={0,0,127}));
  connect(Gain3.y, Add2.u1)
                          annotation (points=[-19,10; -10,10; -10,6; -2,6],
    style(color=74, rgbcolor={0,0,127}));
  connect(u_beta, Gain4.u)
                         annotation (points=[-110,-30; -42,-30], style(
      color=74, rgbcolor={0,0,127}));
  connect(Gain4.y, Add2.u2)
                          annotation (points=[-19,-30; -10,-30; -10,-6; -2,
      -6], style(color=74, rgbcolor={0,0,127}));
  connect(Add1.y, abc[1]) annotation (points=[21,60; 40,60; 40,0; 110,0; 110,
            -6.66667],
                   style(color=74, rgbcolor={0,0,127}));
  connect(Add2.y, abc[2]) annotation (points=[21,0; 65.5,0; 65.5,4.44089e-016;
            110,4.44089e-016],
                           style(color=74, rgbcolor={0,0,127}));
  connect(Gain2.y, abc[3]) annotation (points=[81,-60; 90,-60; 90,0; 110,0; 110,
            6.66667],
                  style(color=74, rgbcolor={0,0,127}));
end SVMsector1p4;

model SVMsector2p5 "Sector 2-5"

annotation (Diagram, Icon(
    Rectangle(extent=[-100,100; 100,-100], style(
        color=0,
        rgbcolor={0,0,0},
        fillColor=6,
        rgbfillColor={255,255,0})),
    Text(
      extent=[-100,-20; 100,-100],
      string="S2&5",
      style(color=0, rgbcolor={0,0,0})),
    Text(
      extent=[-74,40; -14,0],
      style(
        color=30,
        rgbcolor={215,215,215},
        fillColor=6,
        rgbfillColor={255,255,0},
        fillPattern=1),
            string="c = -b"),
    Text(
      extent=[-80,70; 80,30],
      style(
        color=30,
        rgbcolor={215,215,215},
        fillColor=6,
        rgbfillColor={255,255,0},
        fillPattern=1),
            string="b = 2 sqrt(3) ub"),
    Text(
      extent=[-74,100; 6,60],
      style(
        color=30,
        rgbcolor={215,215,215},
        fillColor=6,
        rgbfillColor={255,255,0},
        fillPattern=1),
            string="a = 2 ua"),
                           Text(extent=[-150,150; 150,110],   string=
            "%name")));
  Modelica.Blocks.Interfaces.RealInput u_alpha
    annotation (extent=[-120,20; -100,40]);
  Modelica.Blocks.Interfaces.RealInput u_beta
    annotation (extent=[-120,-40; -100,-20]);
  Modelica.Blocks.Interfaces.RealOutput abc[3]
  annotation (extent=[100,-10; 120,10]);
  Modelica.Blocks.Math.Gain Gain1(k=2)
                                     annotation (extent=[-40,50; -20,70]);
  Modelica.Blocks.Math.Gain Gain2(k=-1)
                                      annotation (extent=[60,-70; 80,-50]);
  Modelica.Blocks.Math.Gain Gain4(k=2/(sqrt(3)))
  annotation (extent=[-40,-40; -20,-20]);

equation
  connect(u_beta, Gain4.u)
                         annotation (points=[-110,-30; -42,-30], style(
      color=74, rgbcolor={0,0,127}));
  connect(u_alpha, Gain1.u)
                          annotation (points=[-110,30; -76,30; -76,60; -42,
      60], style(
    color=74,
    rgbcolor={0,0,127},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
  connect(Gain4.y, Gain2.u)
                          annotation (points=[-19,-30; 40,-30; 40,-60; 58,
      -60], style(
    color=74,
    rgbcolor={0,0,127},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
  connect(Gain1.y, abc[1]) annotation (points=[-19,60; 40,60; 40,0; 110,0; 110,
            -6.66667],
                   style(color=74, rgbcolor={0,0,127}));
  connect(Gain4.y, abc[2]) annotation (points=[-19,-30; 40,-30; 40,4.44089e-016;
            110,4.44089e-016],
                           style(color=74, rgbcolor={0,0,127}));
  connect(Gain2.y, abc[3]) annotation (points=[81,-60; 90,-60; 90,0; 110,0; 110,
            6.66667],
                  style(color=74, rgbcolor={0,0,127}));
end SVMsector2p5;

model SVMsector3p6 "Sector 3-6"

annotation (Diagram, Icon(
    Rectangle(extent=[-100,100; 100,-100], style(
        color=0,
        rgbcolor={0,0,0},
        fillColor=6,
        rgbfillColor={255,255,0})),
    Text(
      extent=[-100,-20; 100,-100],
      string="S3&6",
      style(color=0, rgbcolor={0,0,0})),
    Text(
      extent=[-90,40; 90,0],
      style(
        color=30,
        rgbcolor={215,215,215},
        fillColor=6,
        rgbfillColor={255,255,0},
        fillPattern=1),
            string="c = -ua - 3/sqrt(3) ub"),
    Text(
      extent=[-84,70; -30,30],
      style(
        color=30,
        rgbcolor={215,215,215},
        fillColor=6,
        rgbfillColor={255,255,0},
        fillPattern=1),
            string="b = -a"),
    Text(
      extent=[-90,100; 90,60],
      style(
        color=30,
        rgbcolor={215,215,215},
        fillColor=6,
        rgbfillColor={255,255,0},
        fillPattern=1),
            string="a = ua + 1/sqrt(3) ub"),
                           Text(extent=[-150,150; 150,110],   string=
            "%name")));
  Modelica.Blocks.Interfaces.RealInput u_alpha
    annotation (extent=[-120,20; -100,40]);
  Modelica.Blocks.Interfaces.RealInput u_beta
    annotation (extent=[-120,-40; -100,-20]);
  Modelica.Blocks.Interfaces.RealOutput abc[3]
  annotation (extent=[100,-10; 120,10]);
  Modelica.Blocks.Math.Add Add1
                              annotation (extent=[0,50; 20,70]);
  Modelica.Blocks.Math.Gain Gain1(k=-1/(sqrt(3)))
  annotation (extent=[-60,40; -40,60]);
  Modelica.Blocks.Math.Gain Gain2(k=-1)
                                      annotation (extent=[60,-10; 80,10]);
  Modelica.Blocks.Math.Gain Gain3(k=-1)
                                      annotation (extent=[-40,-40; -20,-20]);
  Modelica.Blocks.Math.Add Add2
                              annotation (extent=[0,-70; 20,-50]);
  Modelica.Blocks.Math.Gain Gain4(k=-3/(sqrt(3)))
  annotation (extent=[-40,-80; -20,-60]);

equation
  connect(u_alpha, Add1.u1)
                          annotation (points=[-110,30; -80,30; -80,66; -2,
      66], style(color=74, rgbcolor={0,0,127}));
  connect(u_beta, Gain1.u)
                         annotation (points=[-110,-30; -86,-30; -86,50; -62,50],
           style(color=74, rgbcolor={0,0,127}));
  connect(Gain1.y, Add1.u2)
                          annotation (points=[-39,50; -20,50; -20,54; -2,54],
    style(color=74, rgbcolor={0,0,127}));
  connect(u_alpha, Gain3.u)
                          annotation (points=[-110,30; -80,30; -80,-30; -42,
      -30], style(color=74, rgbcolor={0,0,127}));
  connect(Gain3.y, Add2.u1)
                          annotation (points=[-19,-30; -10,-30; -10,-54; -2,
      -54], style(color=74, rgbcolor={0,0,127}));
  connect(u_beta, Gain4.u)
                         annotation (points=[-110,-30; -86,-30; -86,-70; -42,
        -70],   style(color=74, rgbcolor={0,0,127}));
  connect(Gain4.y, Add2.u2)
                          annotation (points=[-19,-70; -10,-70; -10,-66; -2,
      -66], style(color=74, rgbcolor={0,0,127}));
  connect(Add1.y, Gain2.u)
                         annotation (points=[21,60; 40,60; 40,0; 58,0],
    style(
    color=74,
    rgbcolor={0,0,127},
    fillColor=6,
    rgbfillColor={255,255,0},
    fillPattern=1));
  connect(Add1.y, abc[1]) annotation (points=[21,60; 90,60; 90,0; 110,0; 110,
            -6.66667],
                   style(color=74, rgbcolor={0,0,127}));
  connect(Gain2.y, abc[2]) annotation (points=[81,0; 95.5,0; 95.5,4.44089e-016;
            110,4.44089e-016],
                           style(color=74, rgbcolor={0,0,127}));
  connect(Add2.y, abc[3]) annotation (points=[21,-60; 90,-60; 90,0; 110,0; 110,
            6.66667],
                  style(color=74, rgbcolor={0,0,127}));
end SVMsector3p6;

model TriggeredPulse "Edge triggered pulse"

  annotation (Diagram, Icon(
      Rectangle(extent=[-100,100; 100,-100], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=30,
          rgbfillColor={215,215,215},
          fillPattern=1)),
      Line(points=[-60,-90; -46,-90], style(
          color=10,
          rgbcolor={135,135,135},
          fillColor=30,
          rgbfillColor={215,215,215},
          fillPattern=1)),
      Line(points=[6,-90; 20,-90], style(
          color=10,
          rgbcolor={135,135,135},
          fillColor=30,
          rgbfillColor={215,215,215},
          fillPattern=1)),
      Polygon(points=[-46,-88; -46,-92; -40,-90; -46,-88], style(color=10,
            rgbcolor={135,135,135})),
      Polygon(points=[0,-90; 6,-88; 6,-92; 0,-90], style(color=10, rgbcolor={
              135,135,135})),
      Text(
        extent=[-44,-80; 0,-102],
        string="T",
        style(
          color=10,
          rgbcolor={135,135,135},
          thickness=2,
          fillColor=30,
          rgbfillColor={215,215,215},
          fillPattern=1)),
      Text(
        extent=[-26,-92; 4,-100],
        string="pulse",
        style(
          color=10,
          rgbcolor={135,135,135},
          thickness=2,
          fillColor=30,
          rgbfillColor={215,215,215},
          fillPattern=1)),
      Polygon(points=[80,-80; 72,-76; 72,-84; 80,-80], style(
          color=30,
          rgbcolor={215,215,215},
          thickness=2,
          fillColor=30,
          rgbfillColor={215,215,215})),
      Text(
        extent=[-80,-38; -46,-48],
        style(color=0, rgbcolor={0,0,0}),
        string="y"),
      Text(
        extent=[-80,50; -46,40],
        style(color=0, rgbcolor={0,0,0}),
        string="u"),
      Text(
        extent=[48,-90; 84,-98],
        string="time",
        style(color=0, rgbcolor={0,0,0})),
      Line(points=[-80,-64; -40,-64; -40,-4; 0,-4; 0,-64; 60,-64],
                                                                 style(color=5,
            rgbcolor={255,0,255})),
      Line(points=[-80,20; -40,20; -40,80; -40,80; 60,80; 60,80], style(color=5,
            rgbcolor={255,0,255})),
      Polygon(points=[-80,80; -88,58; -72,58; -80,80],     style(color=0,
            fillColor=7)),
      Line(points=[-80,58; -80,-90],   style(color=0)),
      Line(points=[-90,-80; 82,-80],   style(color=0)),
      Polygon(points=[90,-80; 68,-72; 68,-88; 90,-80],     style(color=0,
            fillColor=7)),
      Text(
        extent=[-80,142; 78,110],
        string="%name",
        style(
          color=3,
          rgbcolor={0,0,255},
          fillPattern=1))));
  parameter Modelica.SIunits.Time T_pulse=1e-3 "width of triggered pulse";
  Modelica.Blocks.Logical.Timer Timer1(y(start=0))
    annotation (extent=[-10,-40; 10,-20]);
  Modelica.Blocks.Logical.Edge Edge1 annotation (extent=[-80,-10; -60,10]);
  Modelica.Blocks.Logical.Or Or1 annotation (extent=[-40,-10; -20,10]);
  Modelica.Blocks.Logical.And And1 annotation (extent=[60,-40; 80,-20]);
  Modelica.Blocks.Interfaces.BooleanInput u
    annotation (extent=[-120,-10; -100,10]);
  Modelica.Blocks.Interfaces.BooleanOutput y
    annotation (extent=[100,-10; 120,10]);
  Modelica.Blocks.Logical.LessThreshold LessThreshold1(threshold=T_pulse)
    annotation (extent=[20,-40; 40,-20]);
  Modelica.Blocks.Logical.Pre Pre1
    annotation (extent=[-60,-60; -40,-40], rotation=90);

equation
  connect(u, Edge1.u) annotation (points=[-110,0; -82,0],               style(
        color=5, rgbcolor={255,0,255}));
  connect(Timer1.y, LessThreshold1.u)
    annotation (points=[11,-30; 18,-30], style(color=74, rgbcolor={0,0,127}));
  connect(Edge1.y, Or1.u1)
    annotation (points=[-59,0; -42,0], style(color=5, rgbcolor={255,0,255}));
  connect(Or1.y, Timer1.u) annotation (points=[-19,0; -16,0; -16,-30; -12,-30],
      style(color=5, rgbcolor={255,0,255}));
  connect(LessThreshold1.y, And1.u1)
    annotation (points=[41,-30; 58,-30], style(color=5, rgbcolor={255,0,255}));
  connect(Or1.y, y) annotation (points=[-19,0; 25.5,0; 25.5,0; 110,0], style(
        color=5, rgbcolor={255,0,255}));
  connect(Or1.u2, Pre1.y) annotation (points=[-42,-8; -50,-8; -50,-39], style(
        color=5, rgbcolor={255,0,255}));
  connect(Pre1.u, And1.y) annotation (points=[-50,-62; -50,-80; 92,-80; 92,-30;
        81,-30], style(color=5, rgbcolor={255,0,255}));
  connect(Or1.y, And1.u2) annotation (points=[-19,0; -16,0; -16,-60; 50,-60; 50,
        -38; 58,-38], style(color=5, rgbcolor={255,0,255}));
end TriggeredPulse;

model DutyRatioToCycle "Duty ratio to duty cycle transform"

annotation (Diagram, Icon(
    Rectangle(extent=[-100,100; 100,-100], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255})),
    Text(
      extent=[-100,30; 100,-30],
      style(color=3, rgbcolor={0,0,255}),
            string="r to c"),
                           Text(extent=[-150,150; 150,110],   string=
            "%name")));
  Modelica.Blocks.Interfaces.RealInput dutyRatio[3]
    annotation (extent=[-140,-20; -100,20]);
  Modelica.Blocks.Interfaces.RealOutput dutyCycle[3]
  annotation (extent=[100,-20; 140,20]);
  Modelica.Blocks.Math.Add Add[3]
                                annotation (extent=[-20,-10; 0,10]);
  Modelica.Blocks.Sources.Constant One[3](each k=1)
  annotation (extent=[-60,0; -40,20]);
  Modelica.Blocks.Math.Gain Gain[3](each k=1/2)
  annotation (extent=[20,-10; 40,10]);
  Modelica.Blocks.Math.Gain per_cent[3](each k=1)
  annotation (extent=[60,-10; 80,10]);

equation
      connect(dutyRatio, Add.u2)
                            annotation (points=[-120,0; -80,0; -80,-6; -22,-6],
               style(color=74, rgbcolor={0,0,127}));
  connect(One.y, Add.u1)
                       annotation (points=[-39,10; -30,10; -30,6; -22,6],
    style(color=74, rgbcolor={0,0,127}));
      connect(per_cent.y, dutyCycle)
                                annotation (points=[81,0; 120,0], style(
      color=74, rgbcolor={0,0,127}));
  connect(Gain.y, per_cent.u)
                            annotation (points=[41,0; 58,0], style(
      color=74, rgbcolor={0,0,127}));
  connect(Add.y, Gain.u)
  annotation (points=[1,0; 18,0], style(color=74, rgbcolor={0,0,127}));
end DutyRatioToCycle;
end SpaceVector;
end Modulation;
