within Spot.ACdqo;
package Breakers "Switches and Breakers 3-phase"
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
<p>Terminology:</p>
<p><tt><b>Forced switch</b></tt> is used for a component that breaks the current independent of a possible zero crossing.<br>
<tt><b>Switch</b></tt> is used for a component, that breaks the current during zero-crossing but does not contain any additional physical properties like arc-voltage etc.<br>
<tt><b>Breaker</b></tt> is used for a component that acts basically like a 'Switch' but contains additionally physical properties of plasma-arcs, opening duration etc.</p>
</html>
"), Icon);

  model ForcedSwitch "Forced switch, 3-phase dqo"
    extends Partials.SwitchBase(final n=1);

    parameter SI.Time t_relax=10e-3 "switch relaxation time";
    parameter Integer p_relax(min=2)=4 "power of relaxation exponent";
  protected
    outer System system;
    SI.Time t0(start=-Modelica.Constants.inf, fixed=true);
    Real[2] r(start={0,1});
    Real[3] s;
    Boolean open(start=not control[1])=not control[1];
    Boolean closed(start=control[1])=control[1];
    function relaxation=Base.Math.relaxation;
  annotation (defaultComponentName = "switch1",
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
<p>Switching by forced change of current-voltage ratio.</p>
<p>Does not allow single-phase switching. This model acts directly on the current vector in the chosen reference frame and avoids any transformation of variables. To be used, if details of the switching process are not of interest.</p>
<p>'closed' and 'open' determine the mechanical switch-position.<br>
Electrically the switch is on, if it is 'closed', whereas the currents start decreasing exponentially, when it is opened.</p>
<p>A single scalar control-input is sufficient.</p>
<p>The transition between the 'off' conductivity (epsG) and the 'on' resistivity (epsR) is continuous with an exponential relaxation function
<pre>  f = (exp(-dt^p/2) - exp(-1/2))/(1 - exp(-1/2))</pre>
with
<pre>
  dt          relative time measured from switching instant
  t_relax     relaxation time
  p           power of exponent
</pre></p></html>
"), Icon(
        Line(points=[-50,0; 50,0], style(
            color=62,
            rgbcolor={0,120,120},
            pattern=3)),
        Text(extent=[-80,-20; 80,-60], string="dqo exp",
          style(
            color=62,
            rgbcolor={0,120,120},
            pattern=3))),
    Diagram(
        Line(points=[-80,0; -50,0; 30,60], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2)),
        Line(points=[-50,0; 50,0], style(
            color=62,
            rgbcolor={0,120,120},
            pattern=3)),
        Line(points=[50,0; 80,0], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2)),
        Line(points=[0,90; 0,40], style(
            color=5,
            rgbcolor={255,0,255},
            pattern=3)),
      Text(
        extent=[-100,-40; 100,-60],
          style(
            color=62,
            rgbcolor={0,120,120},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1),
          string=" forced switch with exponential relaxation")));

  equation
    if system.transientSim then
      when edge(open) or edge(closed) then
        t0 = time;
      end when;
      r = relaxation(time - t0, t_relax, p_relax);
      {v,i} = if closed then {(r[1]+r[2]*epsR)*s,(r[1]*epsG+r[2])*s} else {(r[1]*epsR+r[2])*s,(r[1]+r[2]*epsG)*s};
    else
      t0 = 0;
      r = {1,0};
      {v,i} = if closed then {epsR*s,s} else {s,epsG*s};
    end if;
  end ForcedSwitch;

  model ForcedCommSwitch "Forced commuting switch, 3-phase dqo"
    extends Base.Units.NominalVI;

    parameter Real[2] eps(final min={0,0}, unit="pu")={1e-4,1e-4}
      "{resistance 'closed', conductance 'open'}";
    parameter SI.Time t_relax=10e-3 "switch relaxation time";
    parameter Integer p_relax(min=2)=4 "power of relaxation exponent";
    SI.Voltage[3] v_t;
    SI.Voltage[3] v_f;
    SI.Current[3] i_t;
    SI.Current[3] i_f;

    Base.Interfaces.ACdqo_p term_p "positive terminal"
      annotation (extent=[-110,-10; -90,10]);
    Base.Interfaces.ACdqo_n term_nt "negative terminal 'true'"
      annotation (extent=[90,30; 110,50]);
    Base.Interfaces.ACdqo_n term_nf "negative terminal 'false'"
      annotation (extent=[90,-50; 110,-30]);
    Modelica.Blocks.Interfaces.BooleanInput control
      "true: p - nt closed, false: p - nf closed"
      annotation(extent=[-10,90; 10,110], rotation=-90);
  protected
    outer System system;
    final parameter SI.Resistance epsR=eps[1]*V_nom/I_nom;
    final parameter SI.Conductance epsG=eps[2]*I_nom/V_nom;
    SI.Time t0(start=-Modelica.Constants.inf, fixed=true);
    Real[2] r(start={0,1});
    Real[3] s_t;
    Real[3] s_f;
    Boolean open_t(start=not control)=not control;
    Boolean closed_t(start=control)=control;
    function relaxation=Base.Math.relaxation;
  annotation (defaultComponentName = "switch1",
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
<p>Switching by forced change of current-voltage ratio.</p>
<p>Does not allow single-phase switching. This model acts directly on the current vector in the chosen reference frame and avoids any transformation of variables. To be used, if details of the switching process are not of interest.</p>
<p>'closed' and 'open' determine the mechanical switch-position.<br>
Electrically the switch is on, if it is 'closed', whereas the currents start decreasing exponentially, when it is opened.</p>
<p>A single scalar control-input is sufficient.</p>
<p>The transition between the 'off' conductivity (epsG) and the 'on' resistivity (epsR) is continuous with an exponential relaxation function
<pre>  f = (exp(-dt^p/2) - exp(-1/2))/(1 - exp(-1/2))</pre>
with
<pre>
  dt          relative time measured from switching instant
  t_relax     relaxation time
  p           power of exponent
</pre></p></html>
"), Icon(
       Text(
      extent=[-100,-80; 100,-120],
      string="%name",
      style(color=0)),
        Rectangle(extent=[-80,60; 80,-80], style(
            color=7,
            rgbcolor={255,255,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
  Line(points=[-80,0; -50,0; 50,40], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2)),
  Line(points=[40,40; 80,40],
                            style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2)),
  Line(points=[40,-40; 80,-40],
                            style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2)),
        Line(points=[-48,0; 50,-40],
                                   style(
            color=62,
            rgbcolor={0,120,120},
            pattern=3)),
        Text(extent=[-80,-50; 80,-80], string="dqo exp",
          style(
            color=62,
            rgbcolor={0,120,120},
            pattern=3)),
        Line(points=[0,90; 0,22], style(
            color=5,
            rgbcolor={255,0,255},
            pattern=3))),
    Diagram(
        Line(points=[-80,0; -50,0; 50,40], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2)),
        Line(points=[-50,0; 50,-40],
                                   style(
            color=62,
            rgbcolor={0,120,120},
            pattern=3)),
        Line(points=[40,-40; 80,-40],
                                  style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2)),
        Line(points=[0,90; 0,20], style(
            color=5,
            rgbcolor={255,0,255},
            pattern=3)),
      Text(
        extent=[-100,-60; 100,-80],
          style(
            color=62,
            rgbcolor={0,120,120},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1),
          string=" forced commuting switch with exponential relaxation"),
        Line(points=[40,40; 80,40],
                                  style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2)),
        Text(
          extent=[10,50; 50,40],
          string="true",
          style(color=5, rgbcolor={255,0,255})),
        Text(
          extent=[10,-40; 50,-50],
          string="false",
          style(color=5, rgbcolor={255,0,255}))));

  equation
    Connections.branch(term_p.theta, term_nt.theta);
    Connections.branch(term_p.theta, term_nf.theta);
    term_nt.theta = term_p.theta;
    term_nf.theta = term_p.theta;

    v_t = term_p.v - term_nt.v;
    v_f = term_p.v - term_nf.v;
    term_nt.i = -i_t;
    term_nf.i = -i_f;
    term_p.i + term_nt.i + term_nf.i = zeros(3);

    if system.transientSim then
      when edge(open_t) or edge(closed_t) then
        t0 = time;
      end when;
      r = relaxation(time - t0, t_relax, p_relax);
      {v_t,i_t} = if closed_t then {(r[1]+r[2]*epsR)*s_t,(r[1]*epsG+r[2])*s_t} else {(r[1]*epsR+r[2])*s_t,(r[1]+r[2]*epsG)*s_t};
      {v_f,i_f} = if open_t then {(r[1]+r[2]*epsR)*s_f,(r[1]*epsG+r[2])*s_f} else {(r[1]*epsR+r[2])*s_f,(r[1]+r[2]*epsG)*s_f};
    else
      t0 = 0;
      r = {1,0};
      {v_t,i_t} = if control then {epsR*s_t,s_t} else {s_t,epsG*s_t};
      {v_f,i_f} = if not control then {epsR*s_f,s_f} else {s_f,epsG*s_f};
    end if;
  end ForcedCommSwitch;

  model Switch "Ideal switch, 3-phase dqo"
    extends Partials.SwitchTrsfBase;

  protected
    Common.Switching.Switch switch_a(
      epsR=epsR,
      epsG=epsG,
      v=v_abc[1],
      i=i_abc[1])                 annotation (extent=[-70,30; 10,90]);
    Common.Switching.Switch switch_b(
      epsR=epsR,
      epsG=epsG,
      v=v_abc[2],
      i=i_abc[2])                 annotation (extent=[-40,-30; 40,30]);
    Common.Switching.Switch switch_c(
      epsR=epsR,
      epsG=epsG,
      v=v_abc[3],
      i=i_abc[3])                 annotation (extent=[-10,-90; 70,-30]);
    annotation (defaultComponentName = "switch1",
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
<p>Allows single-phase switching.</p>
<p>'closed' and 'open' determine the mechanical switch-position.<br>
Electrically the switch is on if it is 'closed', whereas it is switched off, if it is mechanically 'open' and the corresponding phase-current crosses zero.</p>
<p>Contains no plasma-arc, in contrast to Breaker.</p>
<p>Note: currently not suitable for steady-state simulation. In this case use ForcedSwitch.</p>
</html>
"),   Icon(
  Line(points=[-50,0; 50,0], style(
            color=62,
            rgbcolor={0,100,100},
            pattern=3))),
      Diagram);

  equation
    connect(control[1], switch_a.closed)  annotation (points=[0,93.3333; 0,90;
          -30,90],         style(color=5, rgbcolor={255,0,255}));
    connect(control[2], switch_b.closed)  annotation (points=[0,100; 0,30],
        style(color=5, rgbcolor={255,0,255}));
    connect(control[3], switch_c.closed)  annotation (points=[0,106.667; 0,90;
          30,90; 30,-30], style(color=5, rgbcolor={255,0,255}));
  end Switch;

  model Breaker "Breaker, 3-phase dqo"
    extends Partials.SwitchTrsfBase;

    replaceable Parameters.BreakerArc par "breaker parameter"
                                             annotation (extent=[60,70; 80,90]);
  protected
    replaceable Common.Switching.Breaker breaker_a(
      D=par.D,
      t_opening=par.t_opening,
      Earc=par.Earc,
      R0=par.R0,
      epsR=epsR,
      epsG=epsG,
      v=v_abc[1],
      i=i_abc[1])                 annotation (extent=[-70,30; 10,90]);
    replaceable Common.Switching.Breaker breaker_b(
      D=par.D,
      t_opening=par.t_opening,
      Earc=par.Earc,
      R0=par.R0,
      epsR=epsR,
      epsG=epsG,
      v=v_abc[2],
      i=i_abc[2])                 annotation (extent=[-40,-30; 40,30]);
    replaceable Common.Switching.Breaker breaker_c(
      D=par.D,
      t_opening=par.t_opening,
      Earc=par.Earc,
      R0=par.R0,
      epsR=epsR,
      epsG=epsG,
      v=v_abc[3],
      i=i_abc[3])                 annotation (extent=[-10,-90; 70,-30]);
    annotation (defaultComponentName = "breaker1",
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
<p>Allows single-phase switching.</p>
<p>'closed' and 'open' determine the mechanical switch-position.<br>
Electrically the switch is on if it is 'closed', whereas it is switched off, if it is mechanically fully 'open' (after a given opening duration) and the corresponding phase-current crosses zero.</p>
<p>Contains replaceable single-line breakers with replaceable tanh arc-voltage, i.e. a constant electric field strength E for large currents and a small-signal Ohmic resistance R.</p>
<p>Note: currently not suitable for steady-state simulation. In this case use ForcedSwitch.</p>
</html>
"),   Icon(
     Line(points=[-50,0; -34,-4; -24,0; -14,-2; -4,4; 2,0; 12,-4; 22,2; 30,-2;
              38,-4; 42,2; 50,0],
                               style(
            color=49,
            rgbcolor={255,255,0},
            thickness=2))),
      Diagram);

  equation
    connect(control[1], breaker_a.closed)  annotation (points=[0,93.3333; 0,90;
          -30,90],         style(color=5, rgbcolor={255,0,255}));
    connect(control[2], breaker_b.closed)
      annotation (points=[0,100; 0,30], style(color=5, rgbcolor={255,0,255}));
    connect(control[3], breaker_c.closed)  annotation (points=[0,106.667; 0,90;
          30,90; 30,-30], style(color=5, rgbcolor={255,0,255}));
  end Breaker;

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

    partial model SwitchBase "Switch base, 3-phase dqo"
      extends Ports.Port_pn;
      extends Base.Units.NominalVI;

      parameter Integer n=3 "number of independent switches";
      parameter Real[2] eps(final min={0,0}, unit="pu")={1e-4,1e-4}
        "{resistance 'closed', conductance 'open'}";
      SI.Voltage[3] v;
      SI.Current[3] i;
      Modelica.Blocks.Interfaces.BooleanInput[n] control
        "true:closed, false:open"
      annotation (
            extent=[-10,90; 10,110],   rotation=-90);
    protected
      final parameter SI.Resistance epsR=eps[1]*V_nom/I_nom;
      final parameter SI.Conductance epsG=eps[2]*I_nom/V_nom;
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
"),     Icon(
          Rectangle(extent=[-80,60; 80,-60], style(
              color=7,
              rgbcolor={255,255,255},
              fillColor=7,
              rgbfillColor={255,255,255},
              fillPattern=1)),
    Line(points=[-80,0; -50,0; 30,60], style(
              color=62,
              rgbcolor={0,120,120},
              thickness=2)),
    Line(points=[50,0; 80,0], style(
              color=62,
              rgbcolor={0,120,120},
              thickness=2)),
          Line(points=[0,90; 0,40], style(
              color=5,
              rgbcolor={255,0,255},
              pattern=3))),
        Diagram);

    equation
      v = term_p.v - term_n.v;
      term_p.i = i;
    end SwitchBase;

    partial model SwitchTrsfBase
      "Switch base, additional abc-variables, 3-phase dqo"
      extends SwitchBase(final n=3);

      SI.Voltage[3] v_abc(each stateSelect=StateSelect.never)
        "voltage switch a, b, c";
      SI.Current[3] i_abc(each stateSelect=StateSelect.never)
        "current switch a, b, c";
    protected
      Real[3,3] Park = Base.Transforms.park(term_p.theta[2]);
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
"),     Icon,
        Diagram(
          Line(points=[-80,-60; 0,-60],   style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
          Line(points=[60,-60; 80,-60], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
          Line(points=[-80,0; -30,0], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
          Line(points=[30,0; 80,0], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
          Line(points=[-80,60; -60,60], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
          Line(points=[0,60; 80,60],  style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1))));

    equation
      v = Park*v_abc;
      i_abc = transpose(Park)*i;
    /*
  Loop not solvable for this version:
  static = not (switch_a.arc or switch_b.arc or switch_c.arc); //Switch
  static = not (breaker_a.arc or breaker_b.arc or breaker_c.arc); //Breaker
  if static then
    v_abc = {0,0,0} "v_abc not needed";
    i_abc = {0,0,0} "i_abc not needed)";
  else
    v = Park*v_abc;
    i_abc = transpose(Park)*i;
  end if;
*/
    /*
  Initial equation needed, if the equation
  der(i_abc) = transpose(Park)*(der(i) + omega[2]*j_dqo(i));
  is used:
  initial equation
  i_abc = transpose(Park)*i;
*/
    end SwitchTrsfBase;
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
Documentation(info="<html>
<p>Records containing parameters of the corresponding components.</p>
</html>"),
    Icon);

record BreakerArc "Breaker parameters, 3-phase"
  extends Base.Icons.Record;
  parameter SI.Distance D=50e-3 "contact distance open";
  parameter SI.Time t_opening=30e-3 "opening duration";
  parameter SI.ElectricFieldStrength Earc=50e3 "electric field arc";
  parameter Real R0=1 "small signal resistance arc";

  annotation (defaultComponentName = "data",
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
</html>
"), Icon,
    Diagram);
end BreakerArc;
end Parameters;
end Breakers;
