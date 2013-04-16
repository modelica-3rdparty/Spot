within Spot.ACabc;
package Sources "Voltage and Power Sources"
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
<p>The sources have optional inputs:</p>
<pre>
  vPhasor:   voltage {norm, phase} vType = signal
  omega:     angular frequency     fType=signal
  pv:        {active power, abs(voltage)}  (only PVsource)
  p:         {active power, rective power} (only PQsource)
</pre>
<p>To use signal inputs, choose parameters vType=signal and/or fType=signal.</p>
<p>General relations between voltage-norms, effective- and peak-values is shown in the table, both
relative to each other (pu, norm = 1) and as example (SI, 400 V).</p>
<table border=1 cellspacing=0 cellpadding=4>
<tr> <th></th> <th></th> <th><b>pu</b></th> <th><b>V</b></th> </tr>
<tr><td>Three-phase norm</td><td>|v_abc|</td><td><b>1</b></td><td><b>400</b></td></tr>
<tr><td>Single-phase amplitude</td><td>ampl (v_a), ..</td><td>sqrt(2/3)</td> <td>326</td> </tr>
<tr><td>Single-phase effective</td><td>eff (v_a), ..</td><td><b>1/sqrt(3)</b></td><td><b>230</b></td></tr>
<tr><td>Phase to phase amplitude</td><td>ampl (v_b - v_c), ..</td><td>sqrt(2)</td><td>565</td></tr>
<tr><td>Phase to phase effective</td><td>eff (v_b - v_c), ..</td><td><b>1</b></td><td><b>400</b></td></tr>
<tr><td>Three-phase norm</td><td>|v_dqo|</td><td><b>1</b></td><td><b>400</b></td> </tr>
<tr><td>Phase to phase dq-norm</td><td>|vpp_dq|</td><td>sqrt(2)</td><td>565</td></tr>
</table>
</html>"),
    Icon);
  model Voltage "Ideal voltage, 3-phase abc"
    extends Partials.VoltageBase;

    parameter SIpu.Voltage v0=1 "voltage"   annotation(Dialog(enable=scType==Base.Types.par));
    parameter SI.Angle alpha0=0 "phase angle"
                      annotation(Dialog(enable=scType==Base.Types.par));
  protected
    SI.Voltage V;
    SI.Angle alpha;
    SI.Angle phi;
    annotation (defaultComponentName = "voltage1",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2,2],
  component=[40,40]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>Voltage with constant amplitude and phase when 'vType' is 'parameter',<br>
with variable amplitude and phase when 'vType' is 'signal'.</p>
<p>Optional input:
<pre>
  omega           angular frequency (choose fType == \"sig\")
  vPhasor         {norm(v), phase(v)}, amplitude(v_abc)=sqrt(2/3)*vPhasor[1]
   vPhasor[1]     in SI or pu, depending on choice of 'units'
   vPhasor[2]     in rad
</pre></p>
</html>
"),   Icon,
      Diagram);

  equation
    if scType == Base.Types.par then
      V = v0*sqrt(2/3)*V_base;
      alpha = alpha0;
    elseif scType == Base.Types.sig then
      V = vPhasor[1]*sqrt(2/3)*V_base;
      alpha = vPhasor[2];
    end if;
    phi = term.theta[1] + alpha + system.alpha0;
    term.v = V*cos(fill(phi,3) - phShift) + fill(neutral.v, 3);
  end Voltage;

  model Vspectrum "Ideal voltage spectrum, 3-phase abc"
    extends Partials.VoltageBase;

    parameter Integer[:] h={1,3,5} "{1, ...}, which harmonics?";
    parameter SIpu.Voltage[N] v0={1,0.3,0.1} "voltages";
    parameter SI.Angle[N] alpha0=zeros(N) "phase angles";
  protected
    final parameter Integer N=size(h, 1) "nb of harmonics";
    SI.Voltage V;
    SI.Angle alpha;
    SI.Angle phi;
    Integer[N] h_mod3;
    Real[3, N] H;
    annotation (defaultComponentName = "Vspec1",
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
<p>Voltage spectrum with constant amplitude and phase when 'vType' is 'parameter',<br>
with variable amplitude and phase when 'vType' is 'signal'.</p>
<p>In inertial abc-system the voltage-spectrum is given by the expression
<pre>
  v_spec_ABC = sqrt(2/3)*sum_n(v0[n]*cos(h[n]*(theta + alpha_tot - k*2*pi/3)))
with
  k=0,1,2 for phase a,b,c
and
  alpha_tot = alpha + system.alpha0 + alpha0[n]
where
  alpha = vPhasor[2] (common phase) for signal input, else 0
</pre></p>
<p>Optional input:
<pre>
  omega            angular frequency (if fType == \"sig\")
  vPhasor          {modulation(v), common phase(v)}
   vPhasor[1] = 1  delivers the values for constant amplitudes v0
   vPhasor[1]      in SI or pu, depending on choice of 'units'
   vPhasor[2]      in rad
</pre></p>
</html>"),
      Icon(
        Text(
  extent=[-40,60; 40,-20],
          style(
            color=42,
            rgbcolor={176,0,0},
            thickness=2,
            fillColor=77,
            rgbfillColor={127,0,255}),
          string="~~~")),
      Diagram,
      DymolaStoredErrors);

  equation
    if scType == Base.Types.par then
      V = sqrt(2/3)*V_base;
      alpha = 0;
    elseif scType == Base.Types.sig then
      V = vPhasor[1]*(sqrt(2/3)*V_base);
      alpha = vPhasor[2];
    end if;

  algorithm
    h_mod3 := mod(h, 3);
    for n in 1:N loop
      if h_mod3[n] == 1 then
        phi := h[n]*(theta + alpha + system.alpha0 + alpha0[n]) - term.theta[2];
        H[:, n] := {cos(phi - phShift[1]), cos(phi - phShift[2]), cos(phi - phShift[3])};
      elseif h_mod3[n] == 2 then
        phi := h[n]*(theta + alpha + system.alpha0 + alpha0[n]) + term.theta[2];
        H[:, n] := {cos(phi + phShift[1]), cos(phi + phShift[2]), cos(phi + phShift[3])};
      else
        phi := h[n]*(theta + alpha + system.alpha0 + alpha0[n]);
        H[:, n] := {cos(phi), cos(phi), cos(phi)};
      end if;
    end for;
    term.v := V*(H*v0);
  end Vspectrum;

  model InfBus "Infinite slack bus, 3-phase abc"
    extends Partials.PowerBase(final S_nom=1);

    parameter Base.Types.SourceType scType=Base.Types.par
      "v :parameter or signal"
     annotation(Evaluate=true);
    parameter SIpu.Voltage v0=1 "voltage"   annotation(Dialog(enable=scType==Base.Types.par));
    parameter SI.Angle alpha0=0 "phase angle"   annotation(Dialog(enable=scType==Base.Types.par));
    Modelica.Blocks.Interfaces.RealInput[2] vPhasor "({abs(voltage), phase})"
      annotation(extent=[50,90; 70,110],    rotation=-90);
  protected
    SI.Voltage V;
    SI.Angle alpha;
    SI.Angle phi;
    annotation(defaultComponentName = "infBus",
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
<p>Ideal voltage source with constant amplitude and phase when 'vPhasor' unconnected,<br>
with variable amplitude and phase when 'vPhasor' connected to a signal-input.</p>
<p>Optional input:
<pre>
  omega_inp       angular frequency (choose fType == \"sig\")
  vPhasor         {norm(v_abc), phase(v)}
   vPhasor[1]     in SI or pu, depending on choice of 'units'
   vPhasor[2]     in rad
</pre></p>
<p>Frequency: the source has always <i>system</i>-frequency.</p>
</html>"),
      Icon(
     Text(
    extent=[-60,54; 60,14],
          string="V",
          style(
            color=30,
            rgbcolor={215,215,215},
            fillColor=77,
            rgbfillColor={127,0,255})),
     Text(
    extent=[-60,54; 60,14],
          string="slack",
          style(
            color=10,
            rgbcolor={128,128,128},
            thickness=2,
            fillColor=77,
            rgbfillColor={127,0,255}))),
      Diagram);

  equation
    if scType == Base.Types.par then
      V = v0*sqrt(2/3)*V_base;
      alpha = alpha0;
    elseif scType == Base.Types.sig then
      V = vPhasor[1]*sqrt(2/3)*V_base;
      alpha = vPhasor[2];
    end if;
    phi = term.theta[1] + alpha + system.alpha0;
    term.v = V*cos(fill(phi,3) - phShift) + fill(neutral.v, 3);
  end InfBus;

  model VsourceRX "Voltage behind reactance source, 3-phase abc"
    extends Partials.PowerBase;

    parameter Boolean stIni_en=true "enable steady-state initial equation";
    parameter Base.Types.IniType iniType=Base.Types.v_alpha
      "initialisation type";
    parameter SIpu.Voltage v_ini=1 "initial terminal voltage" annotation(Dialog(enable=iniType==Base.Types.v_alpha or iniType==Base.Types.v_p or iniType==Base.Types.v_q));
    parameter SI.Angle alpha_ini=0 "initial terminal phase angle"             annotation(Dialog(enable=iniType==Base.Types.v_alpha));
    parameter SIpu.ApparentPower p_ini=1 "initial terminal active power"
                                                        annotation(Dialog(enable=iniType==Base.Types.v_p));
    parameter SIpu.ApparentPower q_ini=1 "initial terminal reactive power"
      annotation(Dialog(enable=iniType==Base.Types.v_q));
    parameter SIpu.ApparentPower pq_ini[2]={1,0}
      "initial terminal {active, reactive} power"           annotation(Dialog(enable=iniType==Base.Types.p_q));
    parameter SIpu.Resistance r=0 "resistance";
    parameter SIpu.Reactance x=1 "reactance d- and q-axis";
    parameter SIpu.Reactance x_o=0.1 "reactance 0-axis";
  protected
    outer System system;
    final parameter Boolean steadyIni_t=system.steadyIni_t and stIni_en;
    final parameter SIpu.Voltage v0(final fixed=false, start=1)
      "voltage behind reactance";
    final parameter SI.Angle alpha0(final fixed=false, start=0)
      "phase angle of voltage b r";
    final parameter SI.Voltage V=v0*sqrt(2/3)*V_base;
    final parameter SI.Resistance[2] RL_base=Base.Precalculation.baseRL(units, V_nom, S_nom, 2*pi*system.f_nom);
    final parameter SI.Resistance R=r*RL_base[1];
    final parameter SIpu.Reactance x_s=(2*x+x_o)/3 "self reactance";
    final parameter SIpu.Reactance x_m=-(x-x_o)/3 "mutual reactance";
    final parameter SI.Inductance[3,3] L=[x_s,x_m,x_m;x_m,x_s,x_m;x_m,x_m,x_s]*RL_base[2];
    SI.Voltage[3] v(start={cos(system.alpha0),cos(system.alpha0-2*pi/3),cos(system.alpha0-4*pi/3)}*V_base);
    SI.Current[3] i(start={0,0,0});
    SI.AngularFrequency[2] omega;
    SI.Angle phi(start=alpha0+system.alpha0);
    function atan2 = Modelica.Math.atan2;
    annotation (defaultComponentName = "Vsource1",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2,2],
  component=[40,40]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>Ideal voltage source with constant amplitude and phase, and with resistive-inductive inner impedance.</p>
<p>There are 3 different initialisation choices.
<pre>
  1)  v_ini, alpha_ini  initial terminal voltage and phase angle,
  2)  v_ini, p_ini      initial terminal voltage and active power,
  3)  pq_ini            initial terminal {active power, reactive power},
</pre></p>
<p>Note: v0, alpha0 denote the exciting voltage ('behind reactance'), NOT the terminal voltage. v0 and alpha0 are kept constant during simulation. The values are determined at initialisation by the respective initial values above.</p>
<p>Frequency: the source has always <i>system</i>-frequency.</p>
</html>
"),   Icon(
     Text(
    extent=[-70,54; 30,14],
    style(color=10, fillColor=77),
          string="V"),
     Text(
    extent=[-30,42; 70,18],
    style(color=10, fillColor=77),
          string="RX")),
      Diagram);

  initial equation
    if iniType==Base.Types.v_alpha then
      sqrt(v*v) = v_ini*V_base;
      atan2(Base.Transforms.Park0[2,:]*v, Base.Transforms.Park0[1,:]*v) = alpha_ini + system.alpha0;
    elseif iniType==Base.Types.v_p then
      sqrt(v*v) = v_ini*V_base;
      v*i = p_ini*S_base;
    elseif iniType==Base.Types.v_q then
      sqrt(v*v) = v_ini*V_base;
      -j_abc(v)*i = q_ini*S_base;
    elseif iniType==Base.Types.p_q then
      {v*i, -j_abc(v)*i} = pq_ini*S_base;
    end if;
  //  sum(v) = 0;
    if steadyIni_t then
      der(i) = omega[1]*j_abc(i);
    end if;

  equation
    omega = der(term.theta);
    v = term.v;
    i = -term.i;
    phi = term.theta[1] + alpha0 + system.alpha0;

    if system.transientSim then
      L*der(i) + omega[2]*L*j_abc(i) + R*i = V*cos(fill(phi,3) - phShift) + fill(neutral.v, 3) - v;
    else
      omega[2]*L*j_abc(i) + R*i = V*cos(fill(phi,3) - phShift) + fill(neutral.v, 3) - v;
    end if;
  end VsourceRX;

  model PVsource "Power-voltage source, 3-phase abc"
    extends Partials.PowerBase;

    Modelica.Blocks.Interfaces.RealInput[2] pv "{active power, abs(voltage)}"
      annotation(extent=[50,90; 70,110],    rotation=-90);
    parameter Base.Types.SourceType scType=Base.Types.par
      "pv: parameter or signal"
     annotation(Evaluate=true);
    parameter SIpu.ApparentPower p0=1 "active power"
                                               annotation(Dialog(enable=scType==Base.Types.par));
    parameter SIpu.Voltage v0=1 "voltage"   annotation(Dialog(enable=scType==Base.Types.par));
    parameter SI.Voltage V_start=V_nom "start value terminal voltage";
  protected
    SI.Power P;
    SI.Voltage V;
    SI.Voltage[3] v(start={cos(system.alpha0),cos(system.alpha0-2*pi/3),cos(system.alpha0-4*pi/3)}*V_start);
    SI.Current[3] i(start={0,0,0});
  annotation (defaultComponentName = "PVsource1",
    Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]),
    Documentation(
            info="<html>
<p>Ideal source with constant power and voltage when 'pv' unconnected,<br>
with variable power and voltage when 'pv' connected to a signal-input.</p>
<p>Optional input:
<pre>
  pv                {p_active, norm(v)}
   pv[1], pv[2]     in SI or pu, depending on choice of 'units'
</pre></p>
<p>Frequency: the source has always <i>system</i>-frequency.</p>
<p>Use only if prescibed values for p and v are compatible with the properties of the connected system.</p>
</html>"),
    Icon(
   Text(
  extent=[-60, 54; 60, 14],
  style(color=10, fillColor=77),
  string="PV")),
    Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
    Diagram);

  equation
    i = -term.i;
    if scType == Base.Types.par then
      P = p0*S_base;
      V = v0*V_base;
    elseif scType == Base.Types.sig then
      P = pv[1]*S_base;
      V = pv[2]*V_base;
    end if;
    sum(v) = 0;
    v*v = V*V;
    v*i = P;
    term.v = v + fill(neutral.v, 3);
  end PVsource;

  model PQsource "Power source, 3-phase abc"
    extends Partials.PowerBase;

    Modelica.Blocks.Interfaces.RealInput[2] pq(redeclare type SignalType = SIpu.Power,
     final unit= "pu") "{active, reactive} power"
      annotation(extent=[50,90; 70,110],    rotation=-90);
    parameter Base.Types.SourceType scType=Base.Types.par
      "pq: parameter or signal"
     annotation(Evaluate=true);
    parameter SIpu.ApparentPower pq0[2]={1,0} "{active, reactive} power"
                                                                  annotation(Dialog(enable=scType==Base.Types.par));
    parameter SI.Voltage V_start=V_nom "start value terminal voltage";
  protected
    SI.Power[2] P;
    SI.Voltage[3] v(start={cos(system.alpha0),cos(system.alpha0-2*pi/3),cos(system.alpha0-4*pi/3)}*V_start);
    SI.Current[3] i(start={0,0,0});
  annotation (defaultComponentName = "PQsource1",
    Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]),
    Documentation(
            info="<html>
<p>Ideal source with constant (active, reactive) power when 'pq' unconnected,<br>
with variable (active, reactive) power when 'pq' connected to a signal-input.</p>
<p>Optional input:
<pre>
  pq                {p_active, p_reactive}
   pq[1], pq[2]     in SI or pu, depending on choice of 'units'
</pre></p>
<p>Frequency: the source has always <i>system</i>-frequency.</p>
<p>Use only if prescibed values for pq are compatible with the properties of the connected system.</p>
</html>
"), Icon(
   Text(
  extent=[-60, 54; 60, 14],
  string="PQ",
  style(color=10, fillColor=77))),
    Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
      Diagram);

  equation
    i = -term.i;
    if scType == Base.Types.par then
      P = pq0*S_base;
    elseif scType == Base.Types.sig then
      P = pq*S_base;
    end if;
    sum(v) = 0;
    {v*i, -j_abc(v)*i} = P;
    term.v = v + fill(neutral.v, 3);
  end PQsource;

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

    partial model SourceBase "Power source base, 3-phase abc"
      extends Ports.Port_n;
      extends Base.Units.Nominal;

      Base.Interfaces.Electric_p neutral "(use for grounding)"
        annotation (extent=[-110,-10; -90,10], rotation=0);
    protected
      outer System system;
      constant SI.Angle[3] phShift=(0:2)*2*pi/3 "phase shift";
      final parameter SI.Voltage V_base=Base.Precalculation.baseV(units, V_nom);
      SI.Angle theta(stateSelect=StateSelect.prefer) "absolute angle";
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
<p>If the connector 'neutral' remains unconnected, then the source has an isolated neutral point. In all other cases connect 'neutral' to the desired circuit or ground.</p>
</html>"),
        Icon,
        Diagram);

    equation
      Connections.potentialRoot(term.theta);
      if Connections.isRoot(term.theta) then
        term.theta = if system.synRef then {0, theta} else {theta, 0};
      end if;

      sum(term.i) + neutral.i = 0;
    end SourceBase;

    partial model VoltageBase "Voltage base, 3-phase abc"
      extends SourceBase(final S_nom=1);

      parameter Base.Types.FreqType fType=Base.Types.sys
        "f: system, parameter, signal"
        annotation(Evaluate=true);
      parameter SI.Frequency f=system.f "frequency"
        annotation(Dialog(enable=fType==Base.Types.par));
      parameter Base.Types.SourceType scType=Base.Types.par
        "v: parameter or signal"
        annotation(Evaluate=true);
      Modelica.Blocks.Interfaces.RealInput[2] vPhasor
        "{abs(voltage), phase(voltage)}"
        annotation (
              extent=[50,90; 70,110],    rotation=-90);
      Modelica.Blocks.Interfaces.RealInput omega(redeclare type SignalType =
            SI.AngularFrequency) "ang frequency"
    annotation (extent=[-70,90; -50,110],rotation=-90);
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
        Icon(
          Ellipse(
          extent=[-70, -70; 70, 70], style(
              color=70,
              rgbcolor={0,130,175},
              thickness=2,
              fillColor=7,
              rgbfillColor={255,255,255})),
          Line(
       points=[-70,0; 70,0], style(
              color=42,
              rgbcolor={176,0,0},
              thickness=2)),
          Text(
    extent=[-50,30; 50,-70],
    string="~",
            style(
              color=42,
              rgbcolor={176,0,0},
              thickness=2,
              fillColor=77,
              rgbfillColor={127,0,255}))),
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
    end VoltageBase;

    partial model PowerBase "Power source base, 3-phase abc"
      extends SourceBase(theta=system.theta);

    protected
      final parameter SI.ApparentPower S_base=Base.Precalculation.baseS(units, S_nom);
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
        Icon(
          Ellipse(
          extent=[-70,-70; 70,70], style(
              color=70,
              rgbcolor={0,130,175},
              thickness=2,
              fillColor=30,
              rgbfillColor={215,215,215})),
          Line(
       points=[-70,0; 70,0], style(
              color=42,
              rgbcolor={176,0,0},
              thickness=2)),
          Text(
    extent=[-50,30; 50,-70],
    string="~",
            style(
              color=42,
              rgbcolor={176,0,0},
              thickness=2,
              fillColor=77,
              rgbfillColor={127,0,255}))),
        Diagram);

    end PowerBase;
  end Partials;
end Sources;
