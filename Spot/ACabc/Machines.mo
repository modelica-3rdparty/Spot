package Machines "AC machines, electric part "
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
<p> This package contains the <b>electrical part</b> (electrical equations) of AC synchronous and asynchronous machines (generators or motors).<br>
Complete drives or generators are found in package Drives or Generation.</p>
<p>The models in this package can be used both for Y- and for Delta-topology, if the impedance parameters are defined 'as seen from the terminals', directly relating terminal voltage and terminal current.</p>
<p>

.</p>
</html>"),
    Icon);

  model Asynchron "Asynchronous machine, cage-rotor, 3-phase abc"
    extends Partials.AsynchronBase;

  annotation (defaultComponentName = "asynchron",
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
<p>Equivalent circuit is on <b>diagram layer</b> of parameter record ACabc.Machines.Parameters.*</p>
<p>More information see Partials.AsynchronBase.</p>
</html>
"), Icon,
    Diagram);

  initial equation
    phi_el = phi_el_ini;
    if system.steadyIni then
      der(w_el) = 0;
    else
      w_el = w_el_ini;
    end if;

  end Asynchron;

  model AsynchronY_D "Asynchronous machine Y-Delta, cage-rotor, 3-phase abc"
    extends Partials.AsynchronBase(redeclare Spot.ACabc.Ports.Topology.Y_Delta
        top "Y-Delta");

    Modelica.Blocks.Interfaces.BooleanInput YDcontrol "true:Y, false:Delta"
                                              annotation (extent=[-110,50; -90,70],rotation=0);
  annotation (defaultComponentName = "asynchron",
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
<p>Equivalent circuit is on <b>diagram layer</b> of parameter record ACabc.Machines.Parameters.*</p>
<p>Switcheable topology Y-Delta. The impedance values are defined with respect to the WINDINGS, i.e. they refer to Y-topology. Terminal impedance in Delta-topology is a factor 3 higher.</p>
<p>More information see Partials.AsynchronBase.</p>
</html>"),
    Icon,
    Diagram);

  initial equation
    phi_el = phi_el_ini;
    if system.steadyIni then
      der(w_el) = 0;
    else
      w_el = w_el_ini;
    end if;
  equation
    connect(YDcontrol, top.control) annotation (points=[-100,60; -80,60; -80,40;
          40,40; 40,20], style(color=5, rgbcolor={255,0,255}));
  end AsynchronY_D;

  model Asynchron_ctrl
    "Asynchronous machine, cage-rotor, for field-oriented control, 3-phase abc"
    extends Partials.AsynchronBase;

    Modelica.Blocks.Interfaces.RealOutput[2] i_meas(redeclare type SignalType
        = SIpu.Current, final unit="pu") "measured current {i_d, i_q} pu"
      annotation (extent=[-70,90; -50,110],  rotation=90);
    Modelica.Blocks.Interfaces.RealInput[2] i_act(redeclare type SignalType =
          SIpu.Current, final unit="pu") "actuated current {i_d, i_q} pu"
      annotation (extent=[50,110; 70,90],    rotation=90);
    Modelica.Blocks.Interfaces.RealOutput phiRotorflux(redeclare type
        SignalType =
          SI.Angle) "rotor-flux angle"
      annotation (extent=[110,90; 90,110],   rotation=180);
    Modelica.Blocks.Interfaces.RealOutput[2] uPhasor
      "desired {abs(u), phase(u)}"
      annotation (extent=[-110,90; -90,110], rotation=180);
  protected
    constant Real eps=Modelica.Constants.eps;
    final parameter SI.Current I_nom=par.S_nom/par.V_nom;
    SI.Angle alpha_i;
    SI.Angle alpha_psi;
    SI.Voltage[2] v_dq "stator voltage demand in rotor flux-system";
    SI.Current[2] i_dq "stator current demand in rotor flux-system";
    SI.Current[n_r] i_d;
    SI.Current[n_r] i_q;
    function acos=Modelica.Math.acos;
  annotation (defaultComponentName = "asynchron",
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
<p>This model is intended for field-oriented control. The input/output current-signals 'i_meas'/'i_act' represent the pu stator current in the rotorflux-fixed reference system:
<pre>
  first component   ('field'): pu current in rotorflux d-axis
  second component ('torque'): pu current in rotorflux q-axis (q 90deg pos vs d)
</pre>
The mapping from current demand to voltage demand is based on the steady-state equations of the machine.</p>
<p>Equivalent circuit is on <b>diagram layer</b> of parameter record ACdqo.Machines.Parameters.*</p>
<p>More information see Partials.AsynchronBase.</p>
</html>
"), Icon(  Rectangle(extent=[-90,112; 90,88], style(
            color=74,
            rgbcolor={0,0,127},
            fillColor=68,
            rgbfillColor={170,213,255}))),
    Diagram);

  initial equation
    phi_el = phi_el_ini;
    phiRotorflux = 0;
    if system.steadyIni then
      der(w_el) = 0;
    else
      w_el = w_el_ini;
    end if;

  equation
    der(phiRotorflux) = w_el - (-diagonal(c.R_r)*i_rd*psi_rq + diagonal(c.R_r)*i_rq*psi_rd)/(psi_rd*psi_rd + psi_rq*psi_rq + eps);
    alpha_i = atan2(i_s[2], i_s[1]);
    alpha_psi = atan2(c.R_m*psi_rq, c.R_m*psi_rd);
    i_meas = {cos(alpha_i - alpha_psi),sin(alpha_i - alpha_psi)}*sqrt(i_s[1:2]*i_s[1:2])/I_nom;
    i_dq =  i_act*I_nom;
    (sum(omega) - w_el)*(-c.L_m*i_dq[2] - c.L_r*i_q) + diagonal(c.R_r)*i_d = zeros(n_r);
    (sum(omega) - w_el)*(c.L_m*i_dq[1] + c.L_r*i_d) + diagonal(c.R_r)*i_q = zeros(n_r);
    v_dq = sum(omega)*{-(c.L_s[2]*i_dq[2] + c.L_m*i_q), c.L_s[1]*i_dq[1] + c.L_m*i_d} + c.R_s*i_dq;
    uPhasor = {sqrt(v_dq*v_dq)/par.V_nom, atan2(v_dq[2], v_dq[1]) + atan2(sin(alpha_psi - term.theta[1]), cos(alpha_psi - term.theta[1]))};
  end Asynchron_ctrl;

  model Synchron3rd_el "Synchronous machine, 3rd order model, 3-phase abc"
    extends Partials.Synchron3rdBase(final phi_el_ini=-pi/2+system.alpha0,
      redeclare replaceable parameter
        Spot.ACabc.Machines.Parameters.Synchron3rd_el par);
    annotation (defaultComponentName = "synchron",
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
<p>Equivalent circuit is on <b>diagram layer</b> of parameter record ACabc.Machines.Parameters.*</p>
<p>Electric excitation (<tt>excite = 1</tt>).</p>
<p>More information see Partials.Synchron3rdBase.</p>
</html>"),
      Icon,
      Diagram);

    final parameter SI.Voltage Vf_nom=par.V_nom; // to be accessible from 'excitation'.
    output SI.Angle powerAngle(start=0) "power angle";
    Base.Interfaces.ElectricV_p field(m=2) "field winding"
      annotation (extent=[-90,-30; -110,-50],
                                           rotation=180);

  initial equation
    if system.steadyIni then
      w_el = sum(omega);
      der(w_el) = 0;
    else
      phi_el = phi_el_ini;
      w_el = w_el_ini;
    end if;

  equation
    if par.excite==1 then
      psi_e = (field.pin[1].v - field.pin[2].v)/c.omega_nom;
    else
      assert(false, "machine-parameter must be excite = 1 (el)");
    end if;
    powerAngle = noEvent(mod(phi_el - term.theta[2] - atan2(-v[1], v[2]) + pi, 2*pi)) - pi;
  end Synchron3rd_el;

  model Synchron_el "Synchronous machine, 3-phase abc"
    extends Partials.SynchronBase(final phi_el_ini=-pi/2+system.alpha0,
      redeclare replaceable parameter
        Spot.ACabc.Machines.Parameters.Synchron_el par);

    final parameter SI.Voltage Vf_nom=c.Vf_nom; // to be accessible from 'excitation'.
    output SI.Angle powerAngle(start=0, stateSelect=StateSelect.never)
      "power angle";
    Base.Interfaces.ElectricV_p field(m=2) "field winding"
      annotation (extent=[-90,-30; -110,-50],
                                           rotation=180);
  annotation (defaultComponentName = "synchron",
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
<p>Equivalent circuit is on <b>diagram layer</b> of parameter record ACabc.Machines.Parameters.*</p>
<p>Electric excitation (<tt>excite = 1</tt>).</p>
<p>More information see Partials.SynchronBase.</p>
</html>"),
    Icon,
    Diagram(
  Rectangle(extent=[-50,-42; -30,-46],
                                     style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-30,-42; 30,-46],style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Rectangle(extent=[-30,-50; 30,-52],
                                          style(
            color=9,
            rgbcolor={175,175,175},
            fillColor=9,
            rgbfillColor={175,175,175})),
        Line(points=[-50,-44; -80,-44], style(color=3, rgbcolor={0,0,255})),
        Line(points=[30,-44; 40,-44; 40,-36; -80,-36], style(color=3,
              rgbcolor={0,0,255})),
        Text(
          extent=[30,-39; 90,-49],
          style(color=3, rgbcolor={0,0,255}),
          string="field")));

  initial equation
    if system.steadyIni then
      w_el = sum(omega);
      der(w_el) = 0;
    else
      phi_el = phi_el_ini;
      w_el = w_el_ini;
    end if;

  equation
    if par.excite==1 then
      psi_e = 0;
      v_rd[1] = (field.pin[1].v - field.pin[2].v)*c.wf;
    else
      assert(false, "machine-parameter must be excite = 2 (el)");
    end if;
    powerAngle = noEvent(mod(phi_el - term.theta[2] - atan2(-v[1], v[2]) + pi, 2*pi)) - pi;
  end Synchron_el;

  model Synchron3rd_pm
    "Synchronous machine, torque-control, 3rd order model, 3-phase abc"
    extends Partials.Synchron3rdBase(redeclare replaceable parameter
        Spot.ACabc.Machines.Parameters.Synchron3rd_pm par);

    Modelica.Blocks.Interfaces.RealOutput phiRotor(redeclare type SignalType =
          SI.Angle) = phi_el "rotor angle el"
      annotation (extent=[110,90; 90,110],   rotation=180);

    annotation (defaultComponentName = "synchron",
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
<p>Equivalent circuit is on <b>diagram layer</b> of parameter record ACabc.Machines.Parameters.*</p>
<p>The model is valid for permanent magnet (<tt>excite = 2</tt>) or reluctance machines (<tt>excite = 3</tt>).</p>
<p>The relation between 'flux induced by permanent magnet' <tt>Psi_pm [Wb]</tt> and 'magnetisation' <tt>psi_pm [pu]</tt> is given by the following relation;
<pre>
  Psi_pm = psi_pm*V_nom/omega_nom
  psi_pm = Psi_pm*omega_nom/V_nom
</pre></p>
<p>More information see Partials.Synchron3rdBase.</p>
</html>"),
      Icon,
      Diagram(
        Rectangle(extent=[-30,-40; 30,-44], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=42,
            rgbfillColor={176,0,0},
            fillPattern=1)),
        Rectangle(extent=[-30,-29; 30,-31],
                                          style(
            color=9,
            rgbcolor={175,175,175},
            fillColor=9,
            rgbfillColor={175,175,175}))));

  initial equation
    phi_el = phi_el_ini;
    if system.steadyIni then
      der(w_el) = 0;
    else
      w_el = w_el_ini;
    end if;

  equation
    if par.excite==1 then
      assert(false, "machine-parameter must be excite = 2 (pm) or 3 (reluctance)");
    elseif par.excite==2 then
      psi_e = c.Psi_pm; // = par.psi_pm*(par.V_nom/c.omega_nom)
    elseif par.excite==3 then
      psi_e = 0;
    end if;
  end Synchron3rd_pm;

  model Synchron_pm "Synchronous machine, torque-control, 3-phase abc"
    extends Partials.SynchronBase(redeclare replaceable parameter
        Spot.ACabc.Machines.Parameters.Synchron_pm par);

    Modelica.Blocks.Interfaces.RealOutput phiRotor(redeclare type SignalType =
          SI.Angle) = phi_el "rotor angle el"
      annotation (extent=[110,90; 90,110],   rotation=180);
  annotation (defaultComponentName = "synchron",
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
<p>Equivalent circuit is on <b>diagram layer</b> of parameter record ACabc.Machines.Parameters.*</p>
<p>The model is valid for permanent magnet (<tt>excite = 2</tt>) or reluctance machines (<tt>excite = 3</tt>).</p>
<p>The relation between 'flux induced by permanent magnet' <tt>Psi_pm [Wb]</tt> and 'magnetisation' <tt>psi_pm [pu]</tt> is given by the following relation;
<pre>
  Psi_pm = psi_pm*V_nom/omega_nom
  psi_pm = Psi_pm*omega_nom/V_nom
</pre></p>
<p>More information see Partials.SynchronBase.</p>
</html>"),
    Icon,
    Diagram(
        Rectangle(extent=[-30,-29; 30,-31],
                                          style(
            color=9,
            rgbcolor={175,175,175},
            fillColor=9,
            rgbfillColor={175,175,175})),
        Rectangle(extent=[-30,-40; 30,-44], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=42,
            rgbfillColor={176,0,0},
            fillPattern=1))));

  initial equation
    phi_el = phi_el_ini;
    if system.steadyIni then
      der(w_el) = 0;
    else
      w_el = w_el_ini;
    end if;

  equation
    if par.excite==1 then
      assert(false, "machine-parameter must be excite = 2 (pm) or 3 (reluctance)");
    elseif par.excite==2 then
      psi_e = c.Psi_pm; // = par.psi_pm*(par.V_nom/c.omega_nom)
      v_rd[1] = 0;
    elseif par.excite==3 then
      psi_e = 0;
      v_rd[1] = 0;
    end if;
  end Synchron_pm;

  model Synchron3rd_ctrl
    "Synchronous machine, for field-oriented control, 3rd order model, 3-phase abc"
    extends Partials.Synchron3rdBase(redeclare replaceable parameter
        Spot.ACabc.Machines.Parameters.Synchron3rd_pm par);

    Modelica.Blocks.Interfaces.RealOutput[2] i_meas(redeclare type SignalType
        = SIpu.Current, final unit="pu") "measured current {i_d, i_q} pu"
      annotation (extent=[-70,90; -50,110],  rotation=90);
    Modelica.Blocks.Interfaces.RealInput[2] i_act(redeclare type SignalType =
          SIpu.Current, final unit="pu") "actuated current {i_d, i_q} pu"
      annotation (extent=[50,110; 70,90],    rotation=90);
    Modelica.Blocks.Interfaces.RealOutput phiRotor(redeclare type SignalType =
          SI.Angle) = phi_el "rotor angle el"
      annotation (extent=[110,90; 90,110],   rotation=180);
    Modelica.Blocks.Interfaces.RealOutput[2] uPhasor
      "desired {abs(u), phase(u)}"
      annotation (extent=[-110,90; -90,110], rotation=180);
  protected
    final parameter SI.Current I_nom=par.S_nom/par.V_nom;
    SI.Voltage[2] v_dq "voltage demand {v_d, v_q} pu";
    SI.Current[2] i_dq "current demand {i_d, i_q} pu";
    annotation (defaultComponentName = "synchron",
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
<p>This model is intended for field-oriented control. The input/output current-signals 'i_meas'/'i_act' represent the pu stator current in the rotor-fixed reference system:
<pre>
  first component    (field'): pu current in rotor d-axis
  second component ('torque'): pu current in rotor q-axis (q 90deg pos vs d)
</pre>
The mapping from current demand to voltage demand is based on the steady-state equations of the machine.</p>
<p>Equivalent circuit is on <b>diagram layer</b> of parameter record ACdqo.Machines.Parameters.*</p>
<p>The model is valid for permanent magnet (<tt>excite=2</tt>) or reluctance machines (<tt>excite=3</tt>).</p>
<p>Limit velocity for pm-excitation without field weakening (d-axis current i_s[1]=0).
<pre>  w_lim = omega_nom/psi_pm</pre></p>
<p>More information see Partials.Synchron3rdBase.</p>
</html>
"),   Icon(Rectangle(extent=[-90,112; 90,88], style(
            color=74,
            rgbcolor={0,0,127},
            fillColor=68,
            rgbfillColor={170,213,255}))),
      Diagram(
        Rectangle(extent=[-30,-40; 30,-44], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=42,
            rgbfillColor={176,0,0},
            fillPattern=1)),
        Rectangle(extent=[-30,-29; 30,-31],
                                          style(
            color=9,
            rgbcolor={175,175,175},
            fillColor=9,
            rgbfillColor={175,175,175}))));

  initial equation
    phi_el = phi_el_ini;
    if system.steadyIni then
      der(w_el) = 0;
    else
      w_el = w_el_ini;
    end if;

  equation
    if par.excite==1 then
      assert(false, "machine-parameter must be excite = 2 (pm) or 3 (reluctance)");
    elseif par.excite==2 then
      psi_e = c.Psi_pm; // = par.psi_pm*(par.V_nom/c.omega_nom)
    elseif par.excite==3 then
      psi_e = 0;
    end if;

    i_meas = i_s[1:2]/I_nom;
    i_dq = i_act*I_nom;
    v_dq = w_el*{-(c.L_s[2]*i_dq[2]), c.L_s[1]*i_dq[1] + psi_e} + c.R_s*i_dq;
    uPhasor = {sqrt(v_dq*v_dq)/par.V_nom, atan2(v_dq[2], v_dq[1])};
  end Synchron3rd_ctrl;

  model Synchron_ctrl
    "Synchronous machine, for field-oriented control, 3-phase abc"
    extends Partials.SynchronBase(redeclare replaceable parameter
        Spot.ACabc.Machines.Parameters.Synchron_pm par);

    Modelica.Blocks.Interfaces.RealOutput[2] i_meas(redeclare type SignalType
        = SIpu.Current, final unit="pu") "measured current {i_d, i_q} pu"
      annotation (extent=[-70,90; -50,110],  rotation=90);
    Modelica.Blocks.Interfaces.RealInput[2] i_act(redeclare type SignalType =
          SIpu.Current, final unit="pu") "actuated current {i_d, i_q} pu"
      annotation (extent=[50,110; 70,90],    rotation=90);
    Modelica.Blocks.Interfaces.RealOutput phiRotor(redeclare type SignalType =
          SI.Angle) = phi_el "rotor angle el"
      annotation (extent=[110,90; 90,110],   rotation=180);
    Modelica.Blocks.Interfaces.RealOutput[2] uPhasor
      "desired {abs(u), phase(u)}"
      annotation (extent=[-110,90; -90,110], rotation=180);
  protected
    final parameter SI.Current I_nom=par.S_nom/par.V_nom;
    SI.Voltage[2] v_dq "voltage demand {v_d, v_q} pu";
    SI.Current[2] i_dq "current demand {i_d, i_q} pu";
  annotation (defaultComponentName = "synchron",
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
<p>This model is intended for field-oriented control. The input/output current-signals 'i_meas'/'i_act' represent the pu stator current in the rotor-fixed reference system:
<pre>
  first component    (field'): pu current in rotor d-axis
  second component ('torque'): pu current in rotor q-axis (q 90deg pos vs d)
</pre>
The mapping from current demand to voltage demand is based on the steady-state equations of the machine.</p>
<p>Equivalent circuit is on <b>diagram layer</b> of parameter record ACdqo.Machines.Parameters.*</p>
<p>The model is valid for permanent magnet (<tt>excite=2</tt>) or reluctance machines (<tt>excite=3</tt>).</p>
<p>Limit velocity for pm-excitation without field weakening (d-axis current i_s[1]=0).
<pre>  w_lim = omega_nom/psi_pm</pre></p><p>More information see Partials.SynchronBase.</p>
</html>
"), Icon(  Rectangle(extent=[-90,112; 90,88], style(
            color=74,
            rgbcolor={0,0,127},
            fillColor=68,
            rgbfillColor={170,213,255}))),
    Diagram(
        Rectangle(extent=[-30,-29; 30,-31],
                                          style(
            color=9,
            rgbcolor={175,175,175},
            fillColor=9,
            rgbfillColor={175,175,175})),
        Rectangle(extent=[-30,-40; 30,-44], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=42,
            rgbfillColor={176,0,0},
            fillPattern=1))));

  initial equation
    phi_el = phi_el_ini;
    if system.steadyIni then
      der(w_el) = 0;
    else
      w_el = w_el_ini;
    end if;

  equation
    if par.excite==1 then
      assert(false, "machine-parameter must be excite = 2 (pm) or 3 (reluctance)");
    elseif par.excite==2 then
      psi_e = c.Psi_pm; // = par.psi_pm*(par.V_nom/c.omega_nom)
      v_rd[1] = 0;
    elseif par.excite==3 then
      psi_e = 0;
      v_rd[1] = 0;
    end if;

    i_meas = i_s[1:2]/I_nom;
    i_dq = i_act*I_nom;
    v_dq = w_el*{-c.L_s[2]*i_dq[2], c.L_s[1]*i_dq[1] + c.L_md[1]*i_rd[1] + psi_e} + c.R_s*i_dq;
    uPhasor = {sqrt(v_dq*v_dq)/par.V_nom, atan2(v_dq[2], v_dq[1])};
  end Synchron_ctrl;

  package Partials "Partial models"
    partial model ACmachine "AC machine base, 3-phase abc"
      extends Ports.YDport_p;

      parameter Integer pp=1 "pole-pair number";
      parameter Boolean stIni_en=true "enable steady-state initial equation"
                                                                           annotation(evaluate=true);
      parameter SI.Angle phi_el_ini=0 "initial rotor angle electric";
      parameter SI.AngularVelocity w_el_ini=0
        "initial rotor angular velocity el";
      SI.Angle phi_el(start=phi_el_ini, stateSelect=StateSelect.prefer)
        "rotor angle electric (syn: +pi/2)";
      SI.AngularVelocity w_el(start=w_el_ini, stateSelect=StateSelect.prefer)
        "rotor angular velocity el";
      SI.Torque tau_el "electromagnetic torque";
      Base.Interfaces.Rotation_n airgap "electro-mechanical connection"
        annotation (extent=[-10,50; 10,70], layer="icon", rotation=-90);
      Base.Interfaces.ThermalV_n heat(m=2) "heat source port {stator, rotor}"
        annotation (extent=[-10,90; 10,110], rotation=90);
    protected
      outer System system;
      final parameter Boolean steadyIni_t=system.steadyIni_t and stIni_en;
      SI.AngularFrequency[2] omega;
      function atan2 = Modelica.Math.atan2;
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
<p>Contains the pole-pair transformation</p>
<pre>
  pp*airgap.phi = phi_el;
  airgap.tau = -pp*tau_el;
</pre>
<p>between the 'electrical' variables phi_el and tau_el and the 'mechanical' variables airgap.phi and airgap.tau.<br>
The connector 'airgap' transfers the electromagnetic rotor-torque to the mechanical system.</p>
<p>The electric reference frame can specified by the machine rotor. Use this choice ONLY if really necessary and care about restrictions. Choosing
<pre>  isRef = true</pre> induces
<pre>  term.theta = {-phi_el_ini, phi_el}</pre>
and therefore
<pre>  omega = {0, w_el}</pre>
not allowing steady-state initialisation for asynchronous machines. Note that
<pre>  phi_el = pole_pair_number*phi_mechanical</pre>
More info see at 'Machines.Asynchron' and 'Machines.Synchron'.</p>
</html>
"),     Icon(
          Ellipse(
          extent=[90,90; -90,-90], style(
              color=9,
              rgbcolor={175,175,175},
              fillColor=9,
              rgbfillColor={175,175,175})),
          Ellipse(
          extent=[70,70; -70,-70], style(
              color=47,
              rgbcolor={255,170,85},
              fillColor=47,
              rgbfillColor={255,170,85})),
          Ellipse(
          extent=[50,50; -50,-50], style(
              color=9,
              rgbcolor={175,175,175},
              gradient=3,
              fillColor=30,
              rgbfillColor={215,215,215})),
          Polygon(points=[-64,-10; -59,10; -54,-10; -64,-10], style(
              color=7,
              rgbcolor={255,255,255},
              fillColor=7,
              rgbfillColor={255,255,255})),
          Polygon(points=[55,10; 59,-10; 65,10; 55,10], style(
              color=7,
              rgbcolor={255,255,255},
              fillColor=7,
              rgbfillColor={255,255,255}))),
        Diagram(
    Rectangle(extent=[70,20; 76,-20],   style(
        color=10,
        fillColor=10,
        fillPattern=1)),
    Rectangle(extent=[-50,18; -30,14], style(
              color=3,
              rgbcolor={0,0,255},
              thickness=2,
              fillColor=7,
              rgbfillColor={255,255,255})),
          Rectangle(extent=[-30,18; 30,14],  style(
              color=3,
              rgbcolor={0,0,255},
              thickness=2,
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
          Rectangle(extent=[-30,9; 30,7],   style(
              color=9,
              rgbcolor={175,175,175},
              fillColor=9,
              rgbfillColor={175,175,175})),
          Rectangle(extent=[-30,2; 30,-2],  style(
              color=3,
              rgbcolor={0,0,255},
              thickness=2,
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
          Rectangle(extent=[-30,-7; 30,-9],   style(
              color=9,
              rgbcolor={175,175,175},
              fillColor=9,
              rgbfillColor={175,175,175})),
          Rectangle(extent=[-30,-14; 30,-18],  style(
              color=3,
              rgbcolor={0,0,255},
              thickness=2,
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
          Rectangle(extent=[-30,25; 30,23], style(
              color=9,
              rgbcolor={175,175,175},
              fillColor=9,
              rgbfillColor={175,175,175})),
    Rectangle(extent=[-50,2; -30,-2],  style(
              color=3,
              rgbcolor={0,0,255},
              thickness=2,
              fillColor=7,
              rgbfillColor={255,255,255})),
    Rectangle(extent=[-50,-14; -30,-18],
                                       style(
              color=3,
              rgbcolor={0,0,255},
              thickness=2,
              fillColor=7,
              rgbfillColor={255,255,255})),
          Line(points=[-80,-16; -50,-16], style(color=3, rgbcolor={0,0,255})),
          Line(points=[-80,0; -50,0], style(color=3, rgbcolor={0,0,255})),
          Line(points=[-80,16; -50,16], style(color=3, rgbcolor={0,0,255})),
          Text(
            extent=[-40,40; 40,30],
            style(color=3, rgbcolor={0,0,255}),
            string="stator"),
          Text(
            extent=[-40,-90; 40,-100],
            style(color=3, rgbcolor={0,0,255}),
            string="rotor")));

    equation
      omega = der(term.theta);
      pp*airgap.phi = phi_el;
      airgap.tau = -pp*tau_el;
      w_el = der(phi_el);
    end ACmachine;

    partial model AsynTransform "Park transform"
      extends ACmachine;

      SI.Voltage[3] v_s "stator voltage dqo in synchronous system";
      SI.Current[3] i_s(each stateSelect=StateSelect.prefer)
        "stator current dqo in synchronous system";
    protected
      Real[3,3] Park0 = Base.Transforms.Park0
        "Transformation reference-abc to reference-dqo system";
      annotation (
    defaultComponentName="asynchron",
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
<p>Contains the transformation of stator voltage and current from the abc-frame to the dqo-frame with the same reference angle.
<pre>
  v_s, i_s:    stator-voltage and -current dqo in the rotor frame of the machine.
</pre></p>
<p>This transform could be removed, if the equations are written directly in the variables v and i.</p>
</html>"),
      Icon,
      Diagram);

    equation
      v_s = Park0*v;
      i = transpose(Park0)*i_s;
    end AsynTransform;
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

    partial model AsynchronBase "Asynchronous machine base, 3-phase abc"
      extends AsynTransform(final pp=par.pp,
        v(start={cos(system.alpha0),cos(system.alpha0-2*pi/3),cos(system.alpha0-4*pi/3)}*par.V_nom));

      output Real slip "<0:motor, >0:generator";
      replaceable parameter Parameters.Asynchron par(f_nom=system.f_nom)
        "machine parameter"
        annotation (extent=[-60,60; -40,80]);
    protected
      final parameter Integer n_r=if par.transDat then size(par.tc,1) else size(par.xsig_r,1)
        "number of rotor circuits d- and q-axis";
      final parameter Coefficients.Asynchron c = Base.Precalculation.machineAsyn(par,n_r);
      SI.Voltage[n_r] v_rd=zeros(n_r) "rotor voltage d_axis, cage-rotor = 0";
      SI.Voltage[n_r] v_rq=zeros(n_r) "rotor voltage q_axis, cage-rotor = 0";
      SI.Current[n_r] i_rd(each stateSelect=StateSelect.prefer)
        "rotor current d_axis";
      SI.Current[n_r] i_rq(each stateSelect=StateSelect.prefer)
        "rotor current q_axis";
      SI.MagneticFlux[2] psi_s "magnetic flux stator dq";
      SI.MagneticFlux[n_r] psi_rd "magnetic flux rotor d";
      SI.MagneticFlux[n_r] psi_rq "magnetic fluxrotor q";
      annotation (
    defaultComponentName="asynchron",
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
<p>The stator contains one winding each in d-axis, q-axis, o-axis.<br>
The rotor contains n_r windings each in d-axis and q-axis (at least one).<br>
See also equivalent circuit on 'Diagram layer' of
<a href=\"Parameters.Asynchron\">Parameters.Asynchron</a> !</p>
<pre>
  v, i:                  stator-voltage and -current abc
  v_s, i_s:              stator-voltage and -current dqo
  v_rd[n_r], i_rd[n_r]:  rotor-voltage and -current d-axis
  v_rq[n_r], i_rq[n_r]:  rotor-voltage and -current q-axis
</pre>
<p>The equations are valid for <i>all</i> dqo reference systems with arbitrary angular orientation.<br>
Special choices are</p>
<pre>
  omega[2] = omega  defines 'stator' system, rotating with stator frequency
  omega[2] = w_el   defines 'rotor' system, rotating with rotor speed el (el = mec*pp)
  omega[2] = 0      defines the inertial system, not rotating.
  with
  omega[2] = der(term.theta[2])
</pre></p>
</html>"),
      Icon(
     Text(
    extent=[-100,10; 100,-10],
            style(color=7, rgbcolor={255,255,255}),
            string="asyn")),
      Diagram(
      Rectangle(extent=[-50,-58; -30,-62],
                                 style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-30,-58; 30,-62],
                                      style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
      Rectangle(extent=[-50,-74; -30,-78],
                                 style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-30,-74; 30,-78],  style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-30,-67; 30,-69], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
      Rectangle(extent=[-50,-42; -30,-46],
                                 style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-30,-42; 30,-46],style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-30,-29; 30,-31],
                                      style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Rectangle(extent=[-30,-51; 30,-53],
                                      style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Rectangle(extent=[-30,-83; 30,-85], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Line(points=[-50,-86; -60,-86; -60,-40; -50,-40; -50,-42], style(color=
            3, rgbcolor={0,0,255})),
    Line(points=[30,-86; 40,-86; 40,-40; 30,-40; 30,-42], style(color=3,
          rgbcolor={0,0,255})),
    Line(points=[30,-42; 30,-86], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2)),
    Line(points=[-50,-42; -50,-86], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2))));

    initial equation
      if steadyIni_t then
        der(psi_s) = omega[1]*{-psi_s[2], psi_s[1]};
        der(i_s[3]) = 0;
        der(psi_rd) = omega[1]*(-psi_rq);
        der(psi_rq) = omega[1]*psi_rd;
      elseif system.steadyIni_t then
        der(psi_rd) = omega[1]*(-psi_rq);
        der(psi_rq) = omega[1]*psi_rd;
      end if;

    equation
      psi_s = diagonal(c.L_s[1:2])*i_s[1:2] + {c.L_m*i_rd, c.L_m*i_rq};
      psi_rd = c.L_m*i_s[1] + c.L_r*i_rd;
      psi_rq = c.L_m*i_s[2] + c.L_r*i_rq;

      if system.transientSim then
        der(psi_s) + omega[2]*{-psi_s[2], psi_s[1]} + c.R_s*i_s[1:2] = v_s[1:2];
        c.L_s[3]*der(i_s[3]) + c.R_s*i_s[3] = v_s[3];
        der(psi_rd) + (omega[2] - w_el)*(-psi_rq) + diagonal(c.R_r)*i_rd = v_rd;
        der(psi_rq) + (omega[2] - w_el)*psi_rd + diagonal(c.R_r)*i_rq = v_rq;
      else
        omega[2]*{-psi_s[2], psi_s[1]} + c.R_s*i_s[1:2] = v_s[1:2];
        c.R_s*i_s[3] = v_s[3];
        (omega[2] - w_el)*(-psi_rq) + diagonal(c.R_r)*i_rd = v_rd;
        (omega[2] - w_el)*psi_rd + diagonal(c.R_r)*i_rq = v_rq;
      end if;

      if par.neu_iso then
        i_n = zeros(top.n_n);
      else
        v_n = c.R_n*i_n "equation neutral to ground (relevant if Y-topology)";
      end if;

      slip = (w_el/sum(omega) - 1);
      tau_el = i_s[1:2]*{-psi_s[2], psi_s[1]};
      heat.port.Q_flow = -{c.R_s*i_s*i_s, diagonal(c.R_r)*i_rd*i_rd + diagonal(c.R_r)*i_rq*i_rq};
    end AsynchronBase;

    partial model SynTransform "Synchronous machine base0, 3-phase abc"
      extends ACmachine;

    protected
      SI.MagneticFlux psi_e "excitation flux";
      SI.Voltage[3] v_s "stator voltage dqo in rotor-system";
      SI.Current[3] i_s(each stateSelect=StateSelect.prefer)
        "stator current dqo in rotor-system";
      Real[3,3] Park=Base.Transforms.park(phi_el - term.theta[2])
        "Transformation refrerence_abc to rotor_dqo system";
      annotation (Documentation(info="<html>
<p>Contains the transformation of stator voltage and current from the abc reference-frame to the dqo rotor-frame.<br>
The transformation angle is the (electric) rotor-angle relative to the reference frame.</p>
<p>If 'rotorSys = true', the reference frame is specified by the rotor. This allows to avoid the transformation. In this case, the system choice ('synchronous', 'inertial') has no influence. Note that this choice is not generally possible (for example several machines coupled to one common source).
<pre>
  v_s, i_s:    stator-voltage and -current dqo in the rotor frame of the machine.
</pre></p>
</html>"), Diagram(
          Text(
            extent=[10,40; 70,30],
            style(color=3, rgbcolor={0,0,255}),
            string="(armature)")),
        Icon);

    equation
      v_s = Park*v;
      i = transpose(Park)*i_s;
    end SynTransform;

    partial model Synchron3rdBase "Synchronous machine 3rd base, 3-phase abc"
      extends SynTransform(final pp=par.pp,
        v(start={cos(system.alpha0),cos(system.alpha0-2*pi/3),cos(system.alpha0-4*pi/3)}*par.V_nom));

      replaceable parameter Parameters.Synchron3rd par(f_nom=system.f_nom)
        "machine parameter"
        annotation (extent=[-60,60; -40,80]);
    protected
      final parameter Coefficients.Synchron3rd c = Base.Precalculation.machineSyn3rd(par);
      SI.MagneticFlux[2] psi_s "magnetic flux stator dq";
      annotation (Documentation(info="<html>
<p>'Voltage behind synchronous reactance', simplified model of synchronous machine.<br>
One winding in d-axis, q-axis, o-axis.<br>
See also equivalent circuit on 'Diagram layer' of
<a href=\"Parameters.Synchron3rd\">Parameters.Synchron3rd</a> !</p>
<pre>
  v, i:          stator-voltage and -current dqo reference-system
  v_s, i_s:      stator-voltage and -current dqo rotor-system<br>
</pre>
<p>The model is valid for reference systems with arbitrary angular orientation theta[2].</p>
<p>Voltage of field-winding:</p>
<p>Machine- and excitation model must use the same value for the (unscaled) field voltage <tt>Vf_nom</tt>,<br>
as the machine model is stator-scaled with
<pre>  Vf_nom = V_nom</pre>
i.e. choose for both values <tt>V_nom</tt>.</p>
<p>The magnetic flux Psi_pm of the permanent magnet (if present) is defined by
<pre>
  Psi_pm = psi_pm*Psi_nom
  Psi_nom = V_nom/omega_nom = V_nom/(pp*w_nom)
</pre>
where <tt>psi_pm</tt> relates to the induced armature voltage <tt>v_op</tt> at open-terminal and <tt>omega_nom</tt> as
<pre>  psi_pm = v_op/V_nom</pre></p>
<p>The power angle is calculated if so desired. Note that for an inverter driven machine the power angle signal is oscillating with the source voltage.
<pre>
  powerAngle:   difference (angle of rotor) - (angle of terminal_voltage)
                (&gt 0: generator, &lt 0: motor)
</pre></p>
</html>"), Icon(
     Text(
    extent=[-100,10; 100,-10],
            style(color=7, rgbcolor={255,255,255}),
            string="syn3")));

    initial equation
      if steadyIni_t then
        der(psi_s) = zeros(2);
        der(c.L_s[3]*i_s[3]) = 0;
      end if;

    equation
      psi_s = {c.L_s[1]*i_s[1] + psi_e, c.L_s[2]*i_s[2]};

      if system.transientSim then
        der(psi_s) + w_el*{-psi_s[2], psi_s[1]} + c.R_s*i_s[1:2] = v_s[1:2];
        c.L_s[3]*der(i_s[3]) + c.R_s*i_s[3] = v_s[3];
      else
        w_el*{-psi_s[2], psi_s[1]} + c.R_s*i_s[1:2] = v_s[1:2];
        c.R_s*i_s[3] = v_s[3];
      end if;

      if par.neu_iso then
        i_n = zeros(top.n_n);
      else
        v_n = c.R_n*i_n "equation neutral to ground (relevant if Y-topology)";
      end if;

      tau_el = i_s[1:2]*{-psi_s[2], psi_s[1]};
      heat.port.Q_flow = -{c.R_s*i_s*i_s, 0};
    end Synchron3rdBase;

    partial model SynchronBase "Synchronous machine base, 3-phase abc"
      extends SynTransform(final pp=par.pp,
        v(start={cos(system.alpha0),cos(system.alpha0-2*pi/3),cos(system.alpha0-4*pi/3)}*par.V_nom));

      replaceable parameter Parameters.Synchron par(f_nom=system.f_nom)
        "machine parameter"
        annotation (extent=[-60,60; -40,80]);
    protected
      final parameter Integer n_d=if par.transDat then size(par.tc_d,1) else size(par.xsig_rd,1)
        "number of rotor circuits d-axis";
      final parameter Integer n_q=if par.transDat then size(par.tc_q,1) else size(par.xsig_rq,1)
        "number of rotor circuits q-axis";
      final parameter Coefficients.Synchron c = Base.Precalculation.machineSyn(par,n_d,n_q);
      SI.Voltage[n_d] v_rd "rotor voltage d-axis in rotor-system";
      SI.Voltage[n_q] v_rq "rotor voltage q-axis in rotor-system";
      SI.Current[n_d] i_rd(each stateSelect=StateSelect.prefer)
        "rotor current d-axis in rotor-system";
      SI.Current[n_q] i_rq(each stateSelect=StateSelect.prefer)
        "rotor current q-axis in rotor-system";
      SI.MagneticFlux[2] psi_s "magnetic flux stator dq";
      SI.MagneticFlux[n_d] psi_rd "magnetic flux rotor d";
      SI.MagneticFlux[n_q] psi_rq "magnetic fluxrotor q";
      SI.Voltage v_f "field voltage (not scaled to stator units)";
      SI.Current i_f "field current (not scaled to stator units)";
      annotation (
        Diagram(
    Rectangle(extent=[-50,-58; -30,-62],
                                       style(
              color=3,
              rgbcolor={0,0,255},
              thickness=2,
              fillColor=7,
              rgbfillColor={255,255,255})),
          Rectangle(extent=[-30,-58; 30,-62],
                                            style(
              color=3,
              rgbcolor={0,0,255},
              thickness=2,
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
    Rectangle(extent=[-50,-74; -30,-78],
                                       style(
              color=3,
              rgbcolor={0,0,255},
              thickness=2,
              fillColor=7,
              rgbfillColor={255,255,255})),
          Rectangle(extent=[-30,-74; 30,-78],  style(
              color=3,
              rgbcolor={0,0,255},
              thickness=2,
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
          Rectangle(extent=[-30,-66; 30,-68], style(
              color=9,
              rgbcolor={175,175,175},
              fillColor=9,
              rgbfillColor={175,175,175})),
          Rectangle(extent=[-30,-29; 30,-31],
                                            style(
              color=9,
              rgbcolor={175,175,175},
              fillColor=9,
              rgbfillColor={175,175,175})),
          Line(points=[-50,-60; -60,-60; -60,-54; 40,-54; 40,-60; 30,-60], style(
                color=3, rgbcolor={0,0,255})),
          Line(points=[-50,-76; -60,-76; -60,-70; 40,-70; 40,-76; 30,-76], style(
                color=3, rgbcolor={0,0,255})),
          Rectangle(extent=[-30,-82; 30,-84],
                                            style(
              color=9,
              rgbcolor={175,175,175},
              fillColor=9,
              rgbfillColor={175,175,175}))),
        Documentation(info="<html>
<p>General model of synchronous machine.<br>
Stator: one winding each in d-axis, q-axis, o-axis.<br>
Rotor: n_d windings in d-axis (field f, (n_d-1) damper D1, ..), n_q windings in q-axis (damper Q1, ..).<br>
See also equivalent circuit on 'Diagram layer' of
<a href=\"Parameters.Synchron\">Parameters.Synchron</a> !</p>
<pre>
  v, i:          stator-voltage and -current abc reference-system
  v_s, i_s:      stator-voltage and -current dqo rotor-system
  v_rd, i_rd:    rotor-voltage and -current d-axis rotor-system
  v_rq, i_rq:    rotor-voltage and -current q-axis rotor-system
</pre>
<p>The model is valid for reference systems with arbitrary angular orientation theta[2].</p>
<p>Voltage of field-winding:</p>
<p>Machine- and excitation model should use the same value for the (unscaled) field voltage <tt>Vf_nom</tt>.<br>
This value is calculated from <tt>If_nom</tt>, defined through <tt>V=V_nom</tt> at open terminal.</p>
<p>As the machine model is stator-scaled, the default values
<pre>
  If_nom = I_nom = S_nom/V_nom
  Vf_nom = V_nom
</pre>
are sufficient when unscaled values for the field-winding are not of interest.</p>
<p>The magnetic flux Psi_pm of the permanent magnet (if present) is defined by
<pre>
  Psi_pm = psi_pm*Psi_nom
  Psi_nom = V_nom/omega_nom = V_nom/(pp*w_nom)
</pre>
where <tt>psi_pm</tt> relates to the induced armature voltage <tt>v_op</tt> at open-terminal and <tt>omega_nom</tt> as
<pre>  psi_pm = v_op/V_nom</pre></p>
<p>The power angle is calculated if so desired. Note that for an inverter driven machine the power angle signal is oscillating with the source voltage.
<pre>
  powerAngle:   difference (angle of rotor) - (angle of terminal_voltage)
                (&gt 0: generator, &lt 0: motor)
</pre></p>
</html>"),
        Icon(
     Text(
    extent=[-100,10; 100,-10],
            style(color=7, rgbcolor={255,255,255}),
            string="syn")));

    initial equation
      if steadyIni_t then
        der(psi_s) = zeros(2);
        der(c.L_s[3]*i_s[3]) = 0;
        der(psi_rd) = zeros(n_d);
        der(psi_rq) = zeros(n_q);
      elseif system.steadyIni_t then
        der(psi_rd) = zeros(n_d);
        der(psi_rq) = zeros(n_q);
      end if;

    equation
      v_rd[2:end] = zeros(n_d - 1);
      v_rq = zeros(n_q);
      psi_s = diagonal(c.L_s[1:2])*i_s[1:2] + {c.L_md*i_rd + psi_e, c.L_mq*i_rq};
      psi_rd = c.L_md*i_s[1] + c.L_rd*i_rd;
      psi_rq = c.L_mq*i_s[2] + c.L_rq*i_rq;
      v_f = v_rd[1]/c.wf;
      i_f = i_rd[1]*c.wf;

      if system.transientSim then
        der(psi_s) + w_el*{-psi_s[2], psi_s[1]} + c.R_s*i_s[1:2] = v_s[1:2];
        c.L_s[3]*der(i_s[3]) + c.R_s*i_s[3] = v_s[3];
        der(psi_rd) + diagonal(c.R_rd)*i_rd = v_rd;
        der(psi_rq) + diagonal(c.R_rq)*i_rq = v_rq;
      else
        w_el*{-psi_s[2], psi_s[1]} + c.R_s*i_s[1:2] = v_s[1:2];
        c.R_s*i_s[3] = v_s[3];
        diagonal(c.R_rd)*i_rd = v_rd;
        diagonal(c.R_rq)*i_rq = v_rq;
      end if;

      if par.neu_iso then
        i_n = zeros(top.n_n);
      else
        v_n = c.R_n*i_n "equation neutral to ground (relevant if Y-topology)";
      end if;

      tau_el = i_s[1:2]*{-psi_s[2], psi_s[1]};
      heat.port.Q_flow = -{c.R_s*i_s*i_s, diagonal(c.R_rd)*i_rd*i_rd + diagonal(c.R_rq)*i_rq*i_rq};
    end SynchronBase;

  end Partials;

  package Control

    annotation (Documentation(info="<html>
txt
</html>"));

  model Excitation "Excitation (electric part)"
    extends Ports.Port_p;

    parameter SI.Voltage V_nom=1 "nom voltage armature"
      annotation(Evaluate=true, Dialog(group="Nominal"));
    parameter SI.Voltage Vf_nom=1 "nom voltage field-winding"
      annotation(Evaluate=true, Dialog(group="Nominal"));

    Modelica.Blocks.Interfaces.RealOutput[3] termVoltage(redeclare type
          SignalType=SIpu.Voltage, final unit="pu")
        "terminal voltage pu to exciter control"
      annotation (extent=[-70,90; -50,110], rotation=90);
    Modelica.Blocks.Interfaces.RealInput fieldVoltage(redeclare type SignalType
          =
          SIpu.Voltage, final unit="pu")
        "field voltage pu from exciter control"
      annotation (extent=[50,90; 70,110], rotation=-90);
    Base.Interfaces.ElectricV_n field(final m=2) "to generator field-winding"
      annotation (extent=[-90,-50; -110,-30],
                                            rotation=0);

  annotation (defaultComponentName = "excitation",
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
<p>This is a default model. The excitation-voltage is directly determined by the pu field-voltage control-signal.<br>
It does not contain any electronic component.</p>
</html>
"), Icon(Text(
          extent=[-100,30; 100,10],
          string="torque",
          style(color=74, rgbcolor={0,0,127})), Text(
          extent=[-100,-10; 100,-30],
          style(color=74, rgbcolor={0,0,127}),
        string="gen"),
     Rectangle(extent=[-80,60; 80,-60], style(
            color=70,
            rgbcolor={0,130,175},
            fillColor=30,
            rgbfillColor={215,215,215})),
         Text(
          extent=[-100,30; 100,10],
          style(color=3, rgbcolor={0,0,255}),
          string="field"),                      Text(
          extent=[-100,-10; 100,-30],
          style(color=3, rgbcolor={0,0,255}),
          string="voltage"),
        Line(points=[-80,-40; 40,-40],style(color=3, rgbcolor={0,0,255}))),
    Diagram);

  equation
    term.i = zeros(3);
    termVoltage = term.v/V_nom;
    field.pin.v = {fieldVoltage*Vf_nom, 0};
  end Excitation;

  model PowerAngle "Direct determination of generator power angle"
    extends Ports.Port_p;
    outer System system;

    parameter Integer pp=1 "pole-pair number";
    parameter SI.Angle delta=0 "power angle";
    parameter SI.AngularFrequency gamma=1 "inverse time constant";
    SI.Angle phi_el(start=delta-pi/2+system.alpha0) "rotor angle";
    Base.Interfaces.Rotation_n airgap(phi(start=(delta-pi/2+system.alpha0)/pp))
        "to airgap of generator"
  annotation (
        extent=[90,50; 110,70]);
    protected
    SI.Voltage v_dq[2];
    Real[3,3] Park = Base.Transforms.park(term.theta[1])
        "Transformation inertial_abc- to rotor_dqo-system";
    function atan2 = Modelica.Math.atan2;
    annotation (
      defaultComponentName="powerAngle",
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
<p>
Auxiliary control device for test purposes.<br>
Generator rotates at given power angle delta. Replaces turbine and generator-rotor (mechanical part).</p>
<p>Connector 'airgap' to be connected to 'generator.airgap'.<br>
Connector 'term' to be connected to 'generator.term'.</p>
</html>
"),
  Icon(
   Rectangle(extent=[-80,60; 80,-60],   style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255})),                   Polygon(
  points=[-20,0; 12,0; 8,14; -20,0],     style(
        color=44,
        rgbcolor={255,170,170},
        pattern=0,
        fillColor=44,
        rgbfillColor={255,170,170})),
        Line(points=[80,0; -20,0; 60,40], style(color=10, rgbcolor={95,95,95}))),
  Diagram);

  equation
    term.i = zeros(3);
    pp*airgap.phi = phi_el;
    v_dq = Park[1:2,:]*term.v;

    phi_el = delta + atan2(-v_dq[1], v_dq[2]) + term.theta[2]; // steady state!
  //  der(phi_el) = gamma*(delta + atan2(-v_dq[1], v_dq[2]) + term.theta[2] - phi_el);
  end PowerAngle;
  end Control;

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
Documentation(info="<html>
<p>Records containing parameters of the corresponding components.</p>
</html>"),
    Icon);

record Asynchron3rd "Asynchronous machine 3rd order parameters"
  extends Base.Units.NominalDataAC;

  parameter Boolean neu_iso=false "isolated neutral if Y";
  parameter Integer pp=1 "pole-pair number";

  parameter SIpu.Reactance x=4 "total reactance d- and q-axis";
  parameter SIpu.Reactance x_o=0.1 "reactance o-axis";
  parameter SIpu.Resistance r_s=0.04 "resistance stator";
  parameter SIpu.Resistance r_n=1 "resistance neutral to grd (if Y)" annotation(Dialog(enable=not neu_iso));

  annotation (defaultComponentName="asyn3rdPar",
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
<p>Equivalent circuit on <b>diagram layer</b>!</p>
</html>"),
    Icon,
    Diagram(
        Line(points=[-40,80; -40,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[-40,-20; -40,-90], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Text(
          extent=[-66,90; -52,84],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_s"),
        Text(
          extent=[-96,90; -82,84],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_s"),
        Text(
          extent=[-96,-10; -82,-16],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_s"),
        Text(
          extent=[-100,40; -60,20],
          string="d-axis",
          style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
        Text(
          extent=[-100,-60; -60,-80],
          string="q-axis",
          style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
        Text(
          extent=[-86,-54; -46,-60],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
            string="xm = x - xsig_s"),
        Text(
          extent=[-86,46; -46,40],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
            string="xm = x - xsig_s"),
        Rectangle(extent=[-42,60; -38,30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-100,-18; -80,-22], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-42,-40; -38,-70], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Line(points=[-80,-20; -40,-20], style(color=3, rgbcolor={0,0,255})),
        Line(points=[-100,10; -40,10],   style(color=3, rgbcolor={0,0,255})),
        Text(
          extent=[-66,-10; -52,-16],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_s"),
        Rectangle(extent=[-70,-18; -50,-22], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Line(points=[-100,-90; -40,-90], style(color=3, rgbcolor={0,0,255})),
        Line(points=[-100,80; -40,80],   style(color=3, rgbcolor={0,0,255})),
        Rectangle(extent=[-100,82; -80,78], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-70,82; -50,78], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))));
end Asynchron3rd;

record Asynchron "Asynchronous machine parameters"
  extends Asynchron3rd;

  parameter Boolean transDat=true "use transient data"  annotation(choices(
    choice=true "transient data",
    choice=false "equivalent circuit data"));
  parameter Boolean use_xtr=true "use x_transient and t_closed"
    annotation(Dialog(enable=transDat), choices(
    choice=true "x_tr and t_closed",
    choice=false "t_closed and t_open"));
  parameter SIpu.Reactance[:] xtr={0.4844}
        "transient reactance {xtr', xtr'', ..}"
    annotation(Dialog(enable=transDat and use_xtr));
  parameter SI.Time[:] tc={0.03212} "time constant closed-loop {tc', tc'', ..}"
    annotation(Dialog(enable=transDat));

  parameter SI.Time[:] to={0.2653} "time constant open-loop {to', to'', ..}"
    annotation(Dialog(enable=transDat and not use_xtr));

  parameter SIpu.Reactance xsig_s=0.25 "leakage reactance stator";
  parameter SIpu.Reactance[:] xsig_r={0.25} "leakage reactance rotor"
    annotation(Dialog(enable=not transDat));
  parameter SIpu.Resistance[size(xsig_r,1)] r_r={0.04} "resistance rotor"
    annotation(Dialog(enable=not transDat));

  annotation (defaultComponentName="asynPar",
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
<p>Equivalent circuit on <b>diagram layer</b>!</p>
<p>Specifying standard transient data, an example:</p>
<p>&nbsp; - for first order per axis write</p>
<pre>
  xtr = {0.4}  for  xtr' = 0.4,  no xtr'', ..
  tc  = {1.3}  for   tc' = 1.3,   no tc'', ..
</pre>
<p>&nbsp; - for second order per axis write</p>
<pre>
  xtr = {0.4, 0.24}  for  xtr' = 0.4,  xtr'' = 0.24
  tc  = {1.3, 0.04}  for   tc' = 1.3,   tc'' = 0.04
</pre>
<p>and analogous for higher order.</p>
<p>Specifying equivalent circuit data:</p>
<p>&nbsp; &nbsp; <tt>xsig_r, r_r</tt> correspond to a stator-based equivalent circuit.<br>
&nbsp; &nbsp; The number of components of <tt>xsig_r, r_r</tt> depends on the order of the model.<br>
&nbsp; &nbsp; For pu-input refer to stator base value <tt>R_base</tt>.</p>
</html>"),
    Icon,
    Diagram(
        Line(points=[10,80; 10,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[50,80; 50,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[90,50; 90,40], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[50,-20; 50,-90], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[10,-20; 10,-90], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[90,-50; 90,-60], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Text(
          extent=[-14,66; 6,60],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_r3"),
        Text(
          extent=[-12,32; 6,26],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_r3"),
        Rectangle(extent=[88,70; 92,50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[88,40; 92,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[48,70; 52,50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[48,40; 52,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[8,70; 12,50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[8,40; 12,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[88,-30; 92,-50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[88,-60; 92,-80], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[48,-30; 52,-50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[48,-60; 52,-80], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[8,-30; 12,-50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[8,-60; 12,-80], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Text(
          extent=[26,66; 46,60],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_r2"),
        Text(
          extent=[66,66; 86,60],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_r1"),
        Text(
          extent=[28,32; 46,26],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_r2"),
        Text(
          extent=[68,32; 86,26],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_r1"),
        Text(
          extent=[-12,-68; 6,-74],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_r3"),
        Text(
          extent=[28,-68; 46,-74],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_r2"),
        Text(
          extent=[68,-68; 86,-74],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_r1"),
        Text(
          extent=[-14,-34; 6,-40],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_r3"),
        Text(
          extent=[26,-34; 46,-40],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_r2"),
        Text(
          extent=[66,-34; 86,-40],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_r1"),
          Line(points=[-40,80; 90,80; 90,70], style(color=3, rgbcolor={0,0,255})),
          Line(points=[-40,10; 90,10; 90,20], style(color=3, rgbcolor={0,0,255})),
          Line(points=[-40,-20; 90,-20; 90,-30], style(color=3, rgbcolor={0,0,
                  255})),
          Line(points=[-40,-90; 90,-90; 90,-80], style(color=3, rgbcolor={0,0,
                  255}))));

end Asynchron;

record Synchron3rd "Synchronous machine 3rd order parameters"
  extends Base.Units.NominalDataAC;

  parameter Boolean neu_iso=false "isolated neutral if Y";
  parameter Integer pp=1 "pole-pair number";
  parameter Integer excite(min=0,max=3)=1
        "excitation (1:el, 2:pm, 3:reluctance)"
    annotation(Evaluate=true, choices(
    choice=1 "electric excitation",
    choice=2 "permanent magnet",
    choice=3 "reluctance machine"));
  parameter SIpu.MagneticFlux psi_pm(unit="pu")=1.2
        "magnetisation (V/V_nom at open term at omega_nom)"
    annotation(Dialog(enable=excite==2));

  parameter SIpu.Reactance x_d=1.9 "syn reactance d-axis";
  parameter SIpu.Reactance x_q=1.77 "syn reactance q-axis";
  parameter SIpu.Reactance x_o=0.1 "reactance o-axis";
  parameter SIpu.Resistance r_s=0.005 "resistance armature";
  parameter SIpu.Resistance r_n=1 "resistance neutral to grd (if Y)" annotation(Dialog(enable=not neu_iso));

  annotation (defaultComponentName="syn3rdPar",
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
<p>Equivalent circuit on <b>diagram layer</b>!</p>
<p>This simplified model uses only main but no transient reactances.</p>
</html>"),
    Diagram(
        Line(points=[-40,80; -40,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[-40,-20; -40,-90], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Text(
          extent=[-66,90; -52,84],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_s"),
        Text(
          extent=[-96,90; -82,84],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_s"),
        Text(
          extent=[-96,-10; -82,-16],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_s"),
        Text(
          extent=[-100,40; -60,20],
          string="d-axis",
          style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
        Text(
          extent=[-100,-60; -60,-80],
          string="q-axis",
          style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
        Text(
          extent=[-86,-54; -46,-60],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xm_q = x_q - xsig_s"),
        Text(
          extent=[-86,46; -46,40],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xm_d = x_d - xsig_s"),
        Rectangle(extent=[-42,60; -38,30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-100,-18; -80,-22], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-42,-40; -38,-70], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Line(points=[-80,-20; -40,-20], style(color=3, rgbcolor={0,0,255})),
        Line(points=[-100,10; -40,10],   style(color=3, rgbcolor={0,0,255})),
        Text(
          extent=[-66,-10; -52,-16],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_s"),
        Rectangle(extent=[-70,-18; -50,-22], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Line(points=[-100,-90; -40,-90], style(color=3, rgbcolor={0,0,255})),
        Line(points=[-100,80; -40,80],   style(color=3, rgbcolor={0,0,255})),
        Rectangle(extent=[-100,82; -80,78], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-70,82; -50,78], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))),
    DymolaStoredErrors);
end Synchron3rd;

record Synchron "Synchronous machine parameters"
  extends Synchron3rd;

  parameter Boolean transDat=true "use transient data?" annotation(choices(
    choice=true "transient data",
    choice=false "equivalent circuit data"));
  parameter Boolean use_xtr=true "use x_transient and t_closed?"
    annotation(Dialog(enable=transDat), choices(
    choice=true "x_tr and t_closed",
    choice=false "t_closed and t_open"));

  parameter SIpu.Reactance[:] xtr_d={0.33, 0.25}
        "trans reactance d-axis {xtr_d', xtr_d'', ..}"
    annotation(Dialog(enable=transDat and use_xtr));
  parameter SIpu.Reactance[:] xtr_q={0.44, 0.27}
        "trans reactance q-axis {xtr_q', xtr_q'', ..}"
    annotation(Dialog(enable=transDat and use_xtr));
  parameter SI.Time[:] tc_d={0.86, 0.025}
        "time constant closed-loop d-axis {tc_d', tc_d'', ..}"
    annotation(Dialog(enable=transDat));
  parameter SI.Time[:] tc_q={0.25, 0.04}
        "time constant closed-loop q-axis {tc_q', tc_q'', ..}"
    annotation(Dialog(enable=transDat));
  parameter SI.Time[:] to_d={4.9898, 0.032747}
        "time constant open-loop d-axis {to_d', to_d'', ..}"
    annotation(Dialog(enable=transDat and not use_xtr));
  parameter SI.Time[:] to_q={1.0867, 0.060327}
        "time constant open-loop q-axis {to_q', to_q'', ..}"
    annotation(Dialog(enable=transDat and not use_xtr));
  parameter Boolean use_if0=true "induced field current and phase available?"
    annotation(Dialog(enable=transDat and size(tc_d,1)>1 and not pm_exc), choices(
    choice=true "d-axis with xm_d",
    choice=false "d-axis omitting xm_d"));
  parameter SIpu.Current if0=0.85 "induced field current at v_s=Vnom/0deg"
   annotation(Dialog(enable=transDat and size(tc_d,1)>1 and use_if0 and not pm_exc));
  parameter SIpu.Angle_deg if0_deg=-100
        "angle(if0) at v_s=Vnom/0deg (sign: i_f behind v_s)"
    annotation(Dialog(enable=transDat and size(tc_d,1)>1 and use_if0 and not pm_exc));
  parameter Real tol=1e-6 "tolerance precalculation"
    annotation(Dialog(enable=transDat and size(tc_d,1)>1 and use_if0 and not pm_exc));

  parameter SIpu.Reactance xsig_s=0.17 "leakage reactance armature";
  parameter SIpu.Reactance[:] xsig_rd={0.135194, 0.0365214}
        "leakage reactance rotor d-axis {f, D, ..}"
    annotation(Dialog(enable=not transDat));
  parameter SIpu.Reactance[:] xsig_rq={0.407386, 0.144502}
        "leakage reactance rotor q-axis {Q1, ..}"
    annotation(Dialog(enable=not transDat));
  parameter SIpu.Reactance[size(xsig_rd,1)-1] xm_d={0.0555125}
        "coupling-reactance d-axis {xm1, ..}"
    annotation(Dialog(enable=not transDat));
  parameter SIpu.Resistance[size(xsig_rd,1)] r_rd={1.32139e-3, 14.376e-3}
        "resistance rotor d-axis {f, D, ..}"
    annotation(Dialog(enable=not transDat));
  parameter SIpu.Resistance[size(xsig_rq,1)] r_rq={7.38411e-3, 19.7148e-3}
        "resistance rotor q-axis {Q1, ..}"
    annotation(Dialog(enable=not transDat));

  parameter SI.Current If_nom=1 "nom field current (V=V_nom at open term)"
    annotation(Dialog(group="Nominal", enable=not pm_exc));
//  example: V_nom=20e3, S_nom=500e6, If_nom=1500.

  annotation (defaultComponentName="synPar",
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
<p>Equivalent circuit on <b>diagram layer</b>!</p>
<p>Specifying standard transient data both for _d and _q axis:</p>
<p>&nbsp; - for first order write</p>
<pre>
  xtr = {0.4}   for  xtr'  = 0.4,  no xtr''
  tc  = {1.3}   for   tc'  = 1.3,   no tc''
  and
  xtr = {0.26}  for  xtr'' = 0.26,  no xtr'
  tc  = {0.06}  for   tc'' = 0.06,   no tc'
</pre>
<p>&nbsp; - for second order write</p>
<pre>
  xtr = {0.4, 0.24}  for  xtr' = 0.4, xtr'' = 0.24
  tc  = {1.3, 0.04}  for   tc' = 1.3,  tc'' = 0.04
</pre>
<p>and analogous for higher order.</p>
<p>Sign of field current i_f:<br>
Mathematical conventions (Z-matrix) are used for formulas in package 'Precalculation'.<br>
Experimental conventions (if0_deg) choose the inverse sign for the field-current.<br>
Therefore we have to use the following definition for the phase-angle of i_f:
<pre>  alpha_if0 = (if0_deg + 180)*pi/180</pre></p>
<p>If the induced field-current values are not available and for pm-excitation the d-axis is treated according to the q-axis scheme (without xm_d).</p>
<p>Specifying equivalent circuit data:</p>
<p>&nbsp; &nbsp; <tt>xsig_f, r_f, xsig_Q, r_Q</tt> correspond to a stator-based equivalent circuit.<br>
&nbsp; &nbsp; The number of components of <tt>xsig_r, r_r</tt> depends on the order of the model.<br>
&nbsp; &nbsp; For pu-input refer to stator base value <tt>R_base</tt>.</p>
<p>Relation rotor resistance of field winding to stator-based equivalent circuit data:</p>
<pre>
  If_base = (x_d - xsig_s)*If_nom, (x_d, xsig_s in pu)
  Rf_base = P_nom/If_base^2
  rf =  Rf/Rf_base                (in pu, stator-based).
  rf = (Rf/Rf_base)*R_base        (in SI, stator-based).
  Rf = resistance field winding   (in Ohm, true value, not scaled)
</pre>
</html>"),
    Diagram(
        Line(points=[10,80; 10,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[50,80; 50,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[90,50; 90,40], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[50,-20; 50,-90], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[10,-20; 10,-90], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[90,-50; 90,-60], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Text(
          extent=[-14,66; 6,60],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_rd3"),
        Text(
          extent=[-12,32; 6,26],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_rd3"),
        Text(
          extent=[-16,90; -2,84],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xm_d3"),
        Text(
          extent=[24,90; 38,84],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xm_d2"),
        Ellipse(extent=[64,16; 76,4], style(color=3, rgbcolor={0,0,255})),
        Text(
          extent=[78,6; 92,0],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="v_f"),
        Rectangle(extent=[88,70; 92,50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[88,40; 92,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[20,82; 40,78], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[48,70; 52,50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[48,40; 52,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-20,82; 0,78], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[8,70; 12,50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[8,40; 12,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[88,-30; 92,-50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[88,-60; 92,-80], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[48,-30; 52,-50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[48,-60; 52,-80], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[8,-30; 12,-50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[8,-60; 12,-80], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Text(
          extent=[26,66; 46,60],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_rd2"),
        Text(
          extent=[66,66; 86,60],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_rd1"),
        Text(
          extent=[28,32; 46,26],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_rd2"),
        Text(
          extent=[68,32; 86,26],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_rd1"),
        Text(
          extent=[-12,-68; 6,-74],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_rq3"),
        Text(
          extent=[28,-68; 46,-74],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_rq2"),
        Text(
          extent=[68,-68; 86,-74],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_rq1"),
        Text(
          extent=[-14,-34; 6,-40],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_rq3"),
        Text(
          extent=[26,-34; 46,-40],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_rq2"),
        Text(
          extent=[66,-34; 86,-40],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_rq1"),
          Line(points=[-40,80; 90,80; 90,70], style(color=3, rgbcolor={0,0,255})),
          Line(points=[-40,10; 90,10; 90,20], style(color=3, rgbcolor={0,0,255})),
          Line(points=[-40,-20; 90,-20; 90,-30], style(color=3, rgbcolor={0,0,
                  255})),
          Line(points=[-40,-90; 90,-90; 90,-80], style(color=3, rgbcolor={0,0,
                  255}))),
    DymolaStoredErrors);

end Synchron;

record Synchron3rd_el "Synchronous machine 3rd order parameters"
  extends Base.Units.NominalDataAC;

  parameter Boolean neu_iso=false "isolated neutral if Y";
  parameter Integer pp=1 "pole-pair number";
  final parameter Integer excite=1 "excitation (1:el)"
    annotation(Evaluate=true);
  final parameter SIpu.MagneticFlux psi_pm(unit="pu")=0
        "magnetisation (V/V_nom at open term at omega_nom)"
    annotation(Dialog(enable=excite==2));

  parameter SIpu.Reactance x_d=1.9 "syn reactance d-axis";
  parameter SIpu.Reactance x_q=1.77 "syn reactance q-axis";
  parameter SIpu.Reactance x_o=0.1 "reactance o-axis";
  parameter SIpu.Resistance r_s=0.005 "resistance armature";
  parameter SIpu.Resistance r_n=1 "resistance neutral to grd (if Y)" annotation(Dialog(enable=not neu_iso));

  annotation (defaultComponentName="syn3rd_elPar",
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
<p>Equivalent circuit on <b>diagram layer</b>!</p>
<p>This simplified model uses only main but no transient reactances.</p>
</html>"),
    Diagram(
        Line(points=[-40,80; -40,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[-40,-20; -40,-90], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Text(
          extent=[-66,90; -52,84],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_s"),
        Text(
          extent=[-96,90; -82,84],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_s"),
        Text(
          extent=[-96,-10; -82,-16],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_s"),
        Text(
          extent=[-100,40; -60,20],
          string="d-axis",
          style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
        Text(
          extent=[-100,-60; -60,-80],
          string="q-axis",
          style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
        Text(
          extent=[-86,-54; -46,-60],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xm_q = x_q - xsig_s"),
        Text(
          extent=[-86,46; -46,40],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xm_d = x_d - xsig_s"),
        Rectangle(extent=[-42,60; -38,30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-100,-18; -80,-22], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-42,-40; -38,-70], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Line(points=[-80,-20; -40,-20], style(color=3, rgbcolor={0,0,255})),
        Line(points=[-100,10; -40,10],   style(color=3, rgbcolor={0,0,255})),
        Text(
          extent=[-66,-10; -52,-16],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_s"),
        Rectangle(extent=[-70,-18; -50,-22], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Line(points=[-100,-90; -40,-90], style(color=3, rgbcolor={0,0,255})),
        Line(points=[-100,80; -40,80],   style(color=3, rgbcolor={0,0,255})),
        Rectangle(extent=[-100,82; -80,78], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-70,82; -50,78], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))),
    DymolaStoredErrors);
end Synchron3rd_el;

record Synchron_el "Synchronous machine parameters"
  extends Synchron3rd_el;

  parameter Boolean transDat=true "use transient data?" annotation(choices(
    choice=true "transient data",
    choice=false "equivalent circuit data"));
  parameter Boolean use_xtr=true "use x_transient and t_closed?"
    annotation(Dialog(enable=transDat), choices(
    choice=true "x_tr and t_closed",
    choice=false "t_closed and t_open"));

  parameter SIpu.Reactance[:] xtr_d={0.33, 0.25}
        "trans reactance d-axis {xtr_d', xtr_d'', ..}"
    annotation(Dialog(enable=transDat and use_xtr));
  parameter SIpu.Reactance[:] xtr_q={0.44, 0.27}
        "trans reactance q-axis {xtr_q', xtr_q'', ..}"
    annotation(Dialog(enable=transDat and use_xtr));
  parameter SI.Time[:] tc_d={0.86, 0.025}
        "time constant closed-loop d-axis {tc_d', tc_d'', ..}"
    annotation(Dialog(enable=transDat));
  parameter SI.Time[:] tc_q={0.25, 0.04}
        "time constant closed-loop q-axis {tc_q', tc_q'', ..}"
    annotation(Dialog(enable=transDat));
  parameter SI.Time[:] to_d={4.9898, 0.032747}
        "time constant open-loop d-axis {to_d', to_d'', ..}"
    annotation(Dialog(enable=transDat and not use_xtr));
  parameter SI.Time[:] to_q={1.0867, 0.060327}
        "time constant open-loop q-axis {to_q', to_q'', ..}"
    annotation(Dialog(enable=transDat and not use_xtr));
  parameter Boolean use_if0=true "induced field current and phase available?"
    annotation(Dialog(enable=transDat and size(tc_d,1)>1 and not pm_exc), choices(
    choice=true "d-axis with xm_d",
    choice=false "d-axis omitting xm_d"));
  parameter SIpu.Current if0=0.85 "induced field current at v_s=Vnom/0deg"
   annotation(Dialog(enable=transDat and size(tc_d,1)>1 and use_if0 and not pm_exc));
  parameter SIpu.Angle_deg if0_deg=-100
        "angle(if0) at v_s=Vnom/0deg (sign: i_f behind v_s)"
    annotation(Dialog(enable=transDat and size(tc_d,1)>1 and use_if0 and not pm_exc));
  parameter Real tol=1e-6 "tolerance precalculation"
    annotation(Dialog(enable=transDat and size(tc_d,1)>1 and use_if0 and not pm_exc));

  parameter SIpu.Reactance xsig_s=0.17 "leakage reactance armature";
  parameter SIpu.Reactance[:] xsig_rd={0.135194, 0.0365214}
        "leakage reactance rotor d-axis {f, D, ..}"
    annotation(Dialog(enable=not transDat));
  parameter SIpu.Reactance[:] xsig_rq={0.407386, 0.144502}
        "leakage reactance rotor q-axis {Q1, ..}"
    annotation(Dialog(enable=not transDat));
  parameter SIpu.Reactance[size(xsig_rd,1)-1] xm_d={0.0555125}
        "coupling-reactance d-axis {xm1, ..}"
    annotation(Dialog(enable=not transDat));
  parameter SIpu.Resistance[size(xsig_rd,1)] r_rd={1.32139e-3, 14.376e-3}
        "resistance rotor d-axis {f, D, ..}"
    annotation(Dialog(enable=not transDat));
  parameter SIpu.Resistance[size(xsig_rq,1)] r_rq={7.38411e-3, 19.7148e-3}
        "resistance rotor q-axis {Q1, ..}"
    annotation(Dialog(enable=not transDat));

  parameter SI.Current If_nom=1 "nom field current (V=V_nom at open term)"
    annotation(Dialog(group="Nominal", enable=not pm_exc));
//  example: V_nom=20e3, S_nom=500e6, If_nom=1500.

  annotation (defaultComponentName="syn_elPar",
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
<p>Equivalent circuit on <b>diagram layer</b>!</p>
<p>Specifying standard transient data both for _d and _q axis:</p>
<p>&nbsp; - for first order write</p>
<pre>
  xtr = {0.4}   for  xtr'  = 0.4,  no xtr''
  tc  = {1.3}   for   tc'  = 1.3,   no tc''
  and
  xtr = {0.26}  for  xtr'' = 0.26,  no xtr'
  tc  = {0.06}  for   tc'' = 0.06,   no tc'
</pre>
<p>&nbsp; - for second order write</p>
<pre>
  xtr = {0.4, 0.24}  for  xtr' = 0.4, xtr'' = 0.24
  tc  = {1.3, 0.04}  for   tc' = 1.3,  tc'' = 0.04
</pre>
<p>and analogous for higher order.</p>
<p>Sign of field current i_f:<br>
Mathematical conventions (Z-matrix) are used for formulas in package 'Precalculation'.<br>
Experimental conventions (if0_deg) choose the inverse sign for the field-current.<br>
Therefore we have to use the following definition for the phase-angle of i_f:
<pre>  alpha_if0 = (if0_deg + 180)*pi/180</pre></p>
<p>If the induced field-current values are not available and for pm-excitation the d-axis is treated according to the q-axis scheme (without xm_d).</p>
<p>Specifying equivalent circuit data:</p>
<p>&nbsp; &nbsp; <tt>xsig_f, r_f, xsig_Q, r_Q</tt> correspond to a stator-based equivalent circuit.<br>
&nbsp; &nbsp; The number of components of <tt>xsig_r, r_r</tt> depends on the order of the model.<br>
&nbsp; &nbsp; For pu-input refer to stator base value <tt>R_base</tt>.</p>
<p>Relation rotor resistance of field winding to stator-based equivalent circuit data:</p>
<pre>
  If_base = (x_d - xsig_s)*If_nom, (x_d, xsig_s in pu)
  Rf_base = P_nom/If_base^2
  rf =  Rf/Rf_base                (in pu, stator-based).
  rf = (Rf/Rf_base)*R_base        (in SI, stator-based).
  Rf = resistance field winding   (in Ohm, true value, not scaled)
</pre>
</html>"),
    Diagram(
        Line(points=[10,80; 10,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[50,80; 50,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[90,50; 90,40], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[50,-20; 50,-90], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[10,-20; 10,-90], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[90,-50; 90,-60], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Text(
          extent=[-14,66; 6,60],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_rd3"),
        Text(
          extent=[-12,32; 6,26],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_rd3"),
        Text(
          extent=[-16,90; -2,84],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xm_d3"),
        Text(
          extent=[24,90; 38,84],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xm_d2"),
        Ellipse(extent=[64,16; 76,4], style(color=3, rgbcolor={0,0,255})),
        Text(
          extent=[78,6; 92,0],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="v_f"),
        Rectangle(extent=[88,70; 92,50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[88,40; 92,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[20,82; 40,78], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[48,70; 52,50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[48,40; 52,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-20,82; 0,78], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[8,70; 12,50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[8,40; 12,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[88,-30; 92,-50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[88,-60; 92,-80], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[48,-30; 52,-50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[48,-60; 52,-80], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[8,-30; 12,-50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[8,-60; 12,-80], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Text(
          extent=[26,66; 46,60],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_rd2"),
        Text(
          extent=[66,66; 86,60],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_rd1"),
        Text(
          extent=[28,32; 46,26],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_rd2"),
        Text(
          extent=[68,32; 86,26],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_rd1"),
        Text(
          extent=[-12,-68; 6,-74],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_rq3"),
        Text(
          extent=[28,-68; 46,-74],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_rq2"),
        Text(
          extent=[68,-68; 86,-74],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_rq1"),
        Text(
          extent=[-14,-34; 6,-40],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_rq3"),
        Text(
          extent=[26,-34; 46,-40],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_rq2"),
        Text(
          extent=[66,-34; 86,-40],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_rq1"),
          Line(points=[-40,80; 90,80; 90,70], style(color=3, rgbcolor={0,0,255})),
          Line(points=[-40,10; 90,10; 90,20], style(color=3, rgbcolor={0,0,255})),
          Line(points=[-40,-20; 90,-20; 90,-30], style(color=3, rgbcolor={0,0,
                  255})),
          Line(points=[-40,-90; 90,-90; 90,-80], style(color=3, rgbcolor={0,0,
                  255}))),
    DymolaStoredErrors);

end Synchron_el;

record Synchron3rd_pm "Synchronous machine pm 3rd order parameters"
  extends Base.Units.NominalDataAC;

  parameter Boolean neu_iso=false "isolated neutral if Y";
  parameter Integer pp=2 "pole-pair number";
  final parameter Integer excite=2 "excitation (2:pm)"
    annotation(Evaluate=true);
  parameter SIpu.MagneticFlux psi_pm(unit="pu")=1.2
        "magnetisation (V/V_nom at open term at omega_nom)"
    annotation(Dialog(enable=excite==2));
  parameter SIpu.Reactance x_d=0.4 "syn reactance d-axis";
  parameter SIpu.Reactance x_q=0.4 "syn reactance q-axis";
  parameter SIpu.Reactance x_o=0.1 "reactance 0-axis";
  parameter SIpu.Resistance r_s=0.05 "resistance armature";
  parameter SIpu.Resistance r_n=1 "resistance neutral to grd (if Y)" annotation(Dialog(enable=not neu_iso));

  annotation (defaultComponentName="syn3rd_pmPar",
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
<p>Equivalent circuit on <b>diagram layer</b>!</p>
<p>The relation between 'flux induced by permanent magnet' <tt>Psi_pm [Wb]</tt> and 'magnetisation' <tt>psi_pm [pu]</tt> is given by the following relation;
<pre>
  Psi_pm = psi_pm*V_nom/omega_nom
  psi_pm = Psi_pm*omega_nom/V_nom
</pre></p>
</html>
"), Icon,
    Diagram(
        Line(points=[-40,80; -40,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[-40,-20; -40,-90], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Text(
          extent=[-66,90; -52,84],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_s"),
        Text(
          extent=[-96,90; -82,84],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_s"),
        Text(
          extent=[-96,-10; -82,-16],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_s"),
        Text(
          extent=[-100,40; -60,20],
          string="d-axis",
          style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
        Text(
          extent=[-100,-60; -60,-80],
          string="q-axis",
          style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
        Text(
          extent=[-86,-54; -46,-60],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xm_q = x_q - xsig_s"),
        Text(
          extent=[-86,46; -46,40],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xm_d = x_d - xsig_s"),
        Rectangle(extent=[-42,60; -38,30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-100,-18; -80,-22], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-42,-40; -38,-70], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Line(points=[-80,-20; -40,-20], style(color=3, rgbcolor={0,0,255})),
        Line(points=[-100,10; -40,10],   style(color=3, rgbcolor={0,0,255})),
        Text(
          extent=[-66,-10; -52,-16],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_s"),
        Rectangle(extent=[-70,-18; -50,-22], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Line(points=[-100,-90; -40,-90], style(color=3, rgbcolor={0,0,255})),
        Line(points=[-100,80; -40,80],   style(color=3, rgbcolor={0,0,255})),
        Rectangle(extent=[-100,82; -80,78], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-70,82; -50,78], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))));
end Synchron3rd_pm;

record Synchron_pm "Synchronous machine pm parameters"
  extends Synchron3rd_pm;

  parameter Boolean transDat=true "use transient data";
  parameter Boolean use_xtr=true "use x_transient and t_closed?";
  parameter SIpu.Reactance[:] xtr_d={0.142857}
        "trans reactance d-axis {xtr_d', xtr_d'', ..}";
  parameter SIpu.Reactance[:] xtr_q={0.142857}
        "trans reactance q-axis {xtr_q', xtr_q'', ..}";
  parameter SI.Time[:] tc_d={0.00994718}
        "time constant closed-loop d-axis {tc_d', tc_d'', ..}";
  parameter SI.Time[:] tc_q={0.00994718}
        "time constant closed-loop q-axis {tc_q', tc_q'', ..}";
  parameter SI.Time[:] to_d={0.0278521}
        "time constant open-loop d-axis {to_d', to_d'', ..}";
  parameter SI.Time[:] to_q={0.0278521}
        "time constant open-loop q-axis {to_q', to_q'', ..}";
  parameter Boolean use_if0=false "induced field current and phase available?";
  parameter SIpu.Current if0=0 "induced field current at v_s=Vnom/0deg";
  parameter SIpu.Angle_deg if0_deg=0
        "angle(if0) at v_s=Vnom/0deg (sign: i_f behind v_s)";
  parameter Real tol=1e-6 "tolerance precalculation";

// the corresponding equivalent circuit data are:
  parameter SIpu.Reactance xsig_s=0.1 "leakage reactance armature";
  parameter SIpu.Reactance[:] xsig_rd={0.05}
        "leakage reactance rotor d-axis {f, D, ..}";
  parameter SIpu.Reactance[:] xsig_rq={0.05}
        "leakage reactance rotor q-axis {Q1, ..}";
  parameter SIpu.Reactance[size(xsig_rd,1)-1] xm_d=fill(0, 0)
        "coupling-reactance d-axis {xm1, ..}";
  parameter SIpu.Resistance[size(xsig_rd,1)] r_rd={0.04}
        "resistance rotor d-axis {f, D, ..}";
  parameter SIpu.Resistance[size(xsig_rq,1)] r_rq={0.04}
        "resistance rotor q-axis {Q1, ..}";

  final parameter SI.Current If_nom=0
        "nom field current (V=V_nom at open term)";

  annotation (defaultComponentName="syn_pmPar",
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
<p>Equivalent circuit on <b>diagram layer</b>!</p>
<p>Specifying standard transient data both for _d and _q axis:</p>
<p>&nbsp; - for first order write</p>
<pre>
  xtr = {0.4}   for  xtr'  = 0.4,  no xtr''
  tc  = {1.3}   for   tc'  = 1.3,   no tc''
  and
  xtr = {0.26}  for  xtr'' = 0.26,  no xtr'
  tc  = {0.06}  for   tc'' = 0.06,   no tc'
</pre>
<p>&nbsp; - for second order write</p>
<pre>
  xtr = {0.4, 0.24}  for  xtr' = 0.4, xtr'' = 0.24
  tc  = {1.3, 0.04}  for   tc' = 1.3,  tc'' = 0.04
</pre>
<p>and analogous for higher order.</p>
<p>Sign of field current i_f:<br>
Mathematical conventions (Z-matrix) are used for formulas in package 'Precalculation'.<br>
Experimental conventions (if0_deg) choose the inverse sign for the field-current.<br>
Therefore we have to use the following definition for the phase-angle of i_f:
<pre>  alpha_if0 = (if0_deg + 180)*pi/180</pre></p>
<p>If the induced field-current values are not available and for pm-excitation the d-axis is treated according to the q-axis scheme (without xm_d).</p>
<p>Specifying equivalent circuit data:</p>
<p>&nbsp; &nbsp; <tt>xsig_f, r_f, xsig_Q, r_Q</tt> correspond to a stator-based equivalent circuit.<br>
&nbsp; &nbsp; The number of components of <tt>xsig_r, r_r</tt> depends on the order of the model.<br>
&nbsp; &nbsp; For pu-input refer to stator base value <tt>R_base</tt>.</p>
<p>The relation between 'flux induced by permanent magnet' <tt>Psi_pm [Wb]</tt> and 'magnetisation' <tt>psi_pm [pu]</tt> is given by the following relation;
<pre>
  Psi_pm = psi_pm*V_nom/omega_nom
  psi_pm = Psi_pm*omega_nom/V_nom
</pre></p>
</html>"),
    Diagram(
        Line(points=[10,80; 10,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[50,80; 50,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[90,50; 90,40], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[50,-20; 50,-90], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[10,-20; 10,-90], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[90,-50; 90,-60], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Text(
          extent=[-14,66; 6,60],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_rd3"),
        Text(
          extent=[-12,32; 6,26],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_rd3"),
        Text(
          extent=[-16,90; -2,84],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xm_d3"),
        Text(
          extent=[24,90; 38,84],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xm_d2"),
        Ellipse(extent=[64,16; 76,4], style(color=3, rgbcolor={0,0,255})),
        Text(
          extent=[78,6; 92,0],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="pm"),
        Rectangle(extent=[88,70; 92,50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[88,40; 92,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[20,82; 40,78], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[48,70; 52,50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[48,40; 52,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-20,82; 0,78], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[8,70; 12,50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[8,40; 12,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[88,-30; 92,-50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[88,-60; 92,-80], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[48,-30; 52,-50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[48,-60; 52,-80], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[8,-30; 12,-50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[8,-60; 12,-80], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Text(
          extent=[26,66; 46,60],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_rd2"),
        Text(
          extent=[66,66; 86,60],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_rd1"),
        Text(
          extent=[28,32; 46,26],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_rd2"),
        Text(
          extent=[68,32; 86,26],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_rd1"),
        Text(
          extent=[-12,-68; 6,-74],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_rq3"),
        Text(
          extent=[28,-68; 46,-74],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_rq2"),
        Text(
          extent=[68,-68; 86,-74],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_rq1"),
        Text(
          extent=[-14,-34; 6,-40],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_rq3"),
        Text(
          extent=[26,-34; 46,-40],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_rq2"),
        Text(
          extent=[66,-34; 86,-40],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_rq1"),
          Line(points=[-40,80; 90,80; 90,70], style(color=3, rgbcolor={0,0,255})),
          Line(points=[-40,10; 90,10; 90,20], style(color=3, rgbcolor={0,0,255})),
          Line(points=[-40,-20; 90,-20; 90,-30], style(color=3, rgbcolor={0,0,
                  255})),
          Line(points=[-40,-90; 90,-90; 90,-80], style(color=3, rgbcolor={0,0,
                  255}))),
    DymolaStoredErrors);

end Synchron_pm;

record Synchron3rd_reluctance "Synchronous machine pm 3rd order parameters"
  extends Base.Units.NominalDataAC;

  parameter Boolean neu_iso=false "isolated neutral if Y";
  parameter Integer pp=2 "pole-pair number";
  final parameter Integer excite=3 "excitation (3:reluctance)"
    annotation(Evaluate=true);
  final parameter SIpu.MagneticFlux psi_pm(unit="pu")=0
        "magnetisation (V/V_nom at open term at omega_nom)"
    annotation(Dialog(enable=excite==2));
  parameter SIpu.Reactance x_d=2.0 "syn reactance d-axis";
  parameter SIpu.Reactance x_q=0.6 "syn reactance q-axis";
  parameter SIpu.Reactance x_o=0.1 "reactance 0-axis";
  parameter SIpu.Resistance r_s=0.05 "resistance armature";
  parameter SIpu.Resistance r_n=1 "resistance neutral to grd (if Y)" annotation(Dialog(enable=not neu_iso));

  annotation (defaultComponentName="syn_reluctPar",
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
<p>Equivalent circuit on <b>diagram layer</b>!</p>
</html>
"), Icon,
    Diagram(
        Line(points=[-40,80; -40,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[-40,-20; -40,-90], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Text(
          extent=[-66,90; -52,84],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_s"),
        Text(
          extent=[-96,90; -82,84],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_s"),
        Text(
          extent=[-96,-10; -82,-16],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="r_s"),
        Text(
          extent=[-100,40; -60,20],
          string="d-axis",
          style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
        Text(
          extent=[-100,-60; -60,-80],
          string="q-axis",
          style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
        Text(
          extent=[-86,-54; -46,-60],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xm_q = x_q - xsig_s"),
        Text(
          extent=[-86,46; -46,40],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xm_d = x_d - xsig_s"),
        Rectangle(extent=[-42,60; -38,30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-100,-18; -80,-22], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-42,-40; -38,-70], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Line(points=[-80,-20; -40,-20], style(color=3, rgbcolor={0,0,255})),
        Line(points=[-100,10; -40,10],   style(color=3, rgbcolor={0,0,255})),
        Text(
          extent=[-66,-10; -52,-16],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="xsig_s"),
        Rectangle(extent=[-70,-18; -50,-22], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Line(points=[-100,-90; -40,-90], style(color=3, rgbcolor={0,0,255})),
        Line(points=[-100,80; -40,80],   style(color=3, rgbcolor={0,0,255})),
        Rectangle(extent=[-100,82; -80,78], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-70,82; -50,78], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))));
end Synchron3rd_reluctance;
end Parameters;

package Coefficients "Coefficient matrices of machine equations"
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
Documentation(info="<html>
<p>Records containing the result of precalculation, and used in the dynamical equations of the corresponding components.</p>
</html>
"), Icon);

record Asynchron "Coefficient matrices of asynchronous machine"
  extends Base.Icons.Record;

  parameter Integer n_r "number of rotor circuits";
  final parameter SI.Inductance[3] L_s "L matrix stator dqo, d=q";
  final parameter SI.Inductance[n_r, n_r] L_r "L matrix rotor";
  final parameter SI.Inductance[n_r] L_m "L matrix mutual";
  final parameter SI.Resistance R_s "R matrix stator";
  final parameter SI.Resistance[n_r] R_r "R matrix rotor";
  final parameter SI.Resistance R_n "resistance neutral to grd (if Y)";
  final parameter SI.Resistance[n_r] R_m "= diagonal(R_r)*inv(L_r)*L_m";

annotation(Diagram,          Documentation(info="<html>
</html>"));
end Asynchron;

record Synchron3rd "Coefficient matrices of synchronous machine, 3rd order"
  extends Base.Icons.Record;

  final parameter SI.Inductance[3] L_s "L matrix stator dqo";
  final parameter SI.Resistance R_s "R stator (armature)";
  final parameter SI.Resistance R_n "resistance neutral to grd (if Y)";
  final parameter SI.MagneticFlux Psi_pm "flux permanent magnet";
  final parameter SI.AngularFrequency omega_nom;

annotation(Diagram,           Documentation(info="<html>
</html>"));
end Synchron3rd;

record Synchron "Coefficient matrices of synchronous machine"
  extends Base.Icons.Record;

  parameter Integer n_d "number of rotor circuits d-axis";
  parameter Integer n_q "number of rotor circuits q-axis";
  final parameter SI.Inductance[3] L_s "L matrix stator dqo";
  final parameter SI.Inductance[n_d, n_d] L_rd "L matrix rotor";
  final parameter SI.Inductance[n_q, n_q] L_rq "L matrix rotor";
  final parameter SI.Inductance[n_d] L_md "L matrix mutual d-axis";
  final parameter SI.Inductance[n_q] L_mq "L matrix mutual q-axis";
  final parameter SI.Resistance R_s "R stator (armature)";
  final parameter SI.Resistance[n_d] R_rd "R matrix rotor";
  final parameter SI.Resistance[n_q] R_rq "R matrix rotor";
  final parameter SI.Resistance R_n "resistance neutral to grd (if Y)";
  final parameter SI.MagneticFlux Psi_pm "flux permanent magnet";
  final parameter Real wf "ratio field winding";
  final parameter SI.Voltage Vf_nom "nom voltage field winding";
  final parameter SI.AngularFrequency omega_nom;

annotation(Diagram,           Documentation(info="<html>
</html>"));
end Synchron;
end Coefficients;
end Machines;
