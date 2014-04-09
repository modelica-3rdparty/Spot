within Spot.AC1_DC;


package Breakers "Breakers "
  extends Base.Icons.Library;

  model ForcedSwitch "Forced switch, 1-phase"
    extends Partials.SwitchBase;

    parameter SI.Time t_relax=10e-3 "switch relaxation time";
    parameter Integer p_relax(min=2)=4 "power of relaxation exponent";
  protected
    SI.Time t0(start=-Modelica.Constants.inf, fixed=true);
    Real[2] r(start={0,1});
    Real s;
    Boolean open(start=not control)=not control;
    Boolean closed(start=control)=control;
    function relaxation=Base.Math.relaxation;

  equation
    when edge(open) or edge(closed) then
      t0 = time;
    end when;
    r = relaxation(time - t0, t_relax, p_relax);
    {v,i} = if closed then {(r[1]+r[2]*epsR)*s,(r[1]*epsG+r[2])*s} else {(r[1]*epsR+r[2])*s,(r[1]+r[2]*epsG)*s};
    annotation (defaultComponentName = "switch1",
      Documentation(
              info="<html>
<p>Allows switching of single conductor (of totally one or two).<br>
Switching by forced change of current-voltage ratio.</p>
<p>'closed' and 'open' determine the mechanical switch-position.<br>
Electrically the switch is 'on' if it is 'closed', whereas the currents start decreasing exponentially, when it is opened.</p>
<p>The transition between the 'off' conductivity (epsG) and the 'on' resistivity (epsR) is continuous with an exponential relaxation function
<pre>  f = (exp(-dt^p/2) - exp(-1/2))/(1 - exp(-1/2))</pre>
with
<pre>
  dt          relative time measured from switching instant
  t_relax     relaxation time
  p           power of exponent
</pre></p>
</html>"),
      Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Line(
            points={{-40,0},{40,0}},
            color={0,0,255},
            pattern=LinePattern.Dot), Text(
            extent={{-80,-20},{80,-60}},
            lineColor={0,0,255},
            textString =                 "exp")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(
            points={{-10,30},{12,30}},
            color={0,0,255},
            pattern=LinePattern.Dot),
          Line(
            points={{-30,30},{-12,30},{12,46}},
            color={0,0,255},
            thickness=0.5),
          Line(
            points={{12,30},{30,30}},
            color={0,0,255},
            thickness=0.5),
          Line(
            points={{0,90},{0,38}},
            color={255,0,255},
            pattern=LinePattern.Dot),
          Text(
            extent={{-100,-40},{100,-60}},
            lineColor={0,0,255},
            pattern=LinePattern.Dash,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textString=
                 " forced switch with exponential relaxation")}));
  end ForcedSwitch;

  model ForcedCommSwitch "Forced commuting switch, 1-phase"
    extends Base.Units.NominalVI;

    parameter Real[2] eps(final min={0,0}, unit="pu")={1e-4,1e-4}
      "{resistance 'closed', conductance 'open'}";
    parameter SI.Time t_relax=10e-3 "switch relaxation time";
    parameter Integer p_relax(min=2)=4 "power of relaxation exponent";
    SI.Voltage[2] v_t;
    SI.Voltage[2] v_f;
    SI.Current[2] i_t;
    SI.Current[2] i_f;

    Base.Interfaces.ElectricV_p term_p(final m=2) "positive terminal"
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
            rotation=0)));
    Base.Interfaces.ElectricV_n term_nt(final m=2) "negative terminal"
      annotation (Placement(transformation(extent={{90,30},{110,50}}, rotation=
              0)));
    Base.Interfaces.ElectricV_n term_nf(final m=2) "negative terminal"
      annotation (Placement(transformation(extent={{90,-50},{110,-30}},
            rotation=0)));
    Modelica.Blocks.Interfaces.BooleanInput control
      "true: p - nt closed, false: p - nf closed"
    annotation (Placement(transformation(
          origin={0,100},
          extent={{-10,-10},{10,10}},
          rotation=270)));
  protected
    final parameter SI.Resistance epsR=eps[1]*V_nom/I_nom;
    final parameter SI.Conductance epsG=eps[2]*I_nom/V_nom;
    SI.Time t0(start=-Modelica.Constants.inf, fixed=true);
    Real[2] r(start={0,1});
    Real[2] s_t;
    Real[2] s_f;
    Boolean open_t(start=not control)=not control;
    Boolean closed_t(start=control)=control;
    function relaxation=Base.Math.relaxation;

  equation
    v_t = term_p.pin.v - term_nt.pin.v;
    v_f = term_p.pin.v - term_nf.pin.v;
    term_nt.pin.i = - i_t;
    term_nf.pin.i = - i_f;
    term_p.pin.i + term_nt.pin.i + term_nf.pin.i = zeros(2);

    when edge(open_t) or edge(closed_t) then
      t0 = time;
    end when;
    r = relaxation(time - t0, t_relax, p_relax);
    {v_t,i_t} = if closed_t then {(r[1]+r[2]*epsR)*s_t,(r[1]*epsG+r[2])*s_t} else {(r[1]*epsR+r[2])*s_t,(r[1]+r[2]*epsG)*s_t};
    {v_f,i_f} = if open_t then {(r[1]+r[2]*epsR)*s_f,(r[1]*epsG+r[2])*s_f} else {(r[1]*epsR+r[2])*s_f,(r[1]+r[2]*epsG)*s_f};
    annotation (defaultComponentName = "switch1",
      Documentation(
              info="<html>
<p>Allows switching of single conductor (of totally one or two).<br>
Switching by forced change of current-voltage ratio.</p>
<p>'closed' and 'open' determine the mechanical switch-position.<br>
Electrically the switch is 'on' if it is 'closed', whereas the currents start decreasing exponentially, when it is opened.</p>
<p>The transition between the 'off' conductivity (epsG) and the 'on' resistivity (epsR) is continuous with an exponential relaxation function
<pre>  f = (exp(-dt^p/2) - exp(-1/2))/(1 - exp(-1/2))</pre>
with
<pre>
  dt          relative time measured from switching instant
  t_relax     relaxation time
  p           power of exponent
</pre></p></html>"),
      Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Rectangle(
            extent={{-80,60},{80,-60}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,0},{-40,0},{50,40}}, color={0,0,255}),
          Line(
            points={{-40,0},{50,-40}},
            color={0,0,255},
            pattern=LinePattern.Dot),
          Line(points={{40,40},{80,40}}, color={0,0,255}),
          Text(
            extent={{-80,-40},{80,-80}},
            lineColor={0,0,255},
            textString =                 "exp"),
          Line(points={{40,-40},{80,-40}}, color={0,0,255}),
          Line(
            points={{0,90},{0,20}},
            color={255,0,255},
            pattern=LinePattern.Dot),
          Text(
            extent={{-100,-90},{100,-130}},
            lineColor={0,0,0},
            textString=
             "%name")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(
            points={{-12,30},{12,20}},
            color={0,0,255},
            pattern=LinePattern.Dot),
          Line(
            points={{-30,30},{-12,30},{12,40}},
            color={0,0,255},
            thickness=0.5),
          Line(
            points={{12,40},{30,40}},
            color={0,0,255},
            thickness=0.5),
          Line(
            points={{0,90},{0,38}},
            color={255,0,255},
            pattern=LinePattern.Dot),
          Text(
            extent={{-100,-60},{100,-80}},
            lineColor={0,0,255},
            pattern=LinePattern.Dash,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textString=
                 " forced commuting switch with exponential relaxation"),
          Line(points={{-80,30},{-30,30}}, color={0,0,255}),
          Line(
            points={{12,20},{30,20}},
            color={0,0,255},
            thickness=0.5),
          Line(points={{30,40},{40,40},{40,46},{80,46}}, color={0,0,255}),
          Line(points={{54,20},{60,20},{60,-34},{80,-34}}, color={0,0,255}),
          Line(points={{30,-40},{50,-40},{50,-46},{80,-46}}, color={0,0,255}),
          Line(
            points={{-30,-30},{-12,-30},{12,-20}},
            color={0,0,255},
            thickness=0.5),
          Line(
            points={{12,-20},{30,-20}},
            color={0,0,255},
            thickness=0.5),
          Line(
            points={{12,-40},{30,-40}},
            color={0,0,255},
            thickness=0.5),
          Line(
            points={{-12,-30},{12,-40}},
            color={0,0,255},
            pattern=LinePattern.Dot),
          Line(points={{-80,-30},{-30,-30}}, color={0,0,255}),
          Line(points={{80,34},{50,34},{50,-20},{30,-20}}, color={0,0,255}),
          Line(points={{30,20},{46,20}}, color={0,0,255})}));
  end ForcedCommSwitch;

  model Switch "Ideal switch, 1-phase"
    extends Partials.SwitchBase;

  protected
    Common.Switching.Switch switch_1(
      epsR=epsR,
      epsG=epsG,
      v=v,
      i=i)                        annotation (Placement(transformation(extent={
              {-40,0},{40,60}}, rotation=0)));

  equation
    connect(control, switch_1.closed)
      annotation (Line(points={{0,100},{0,60}}, color={255,0,255}));
    annotation (defaultComponentName = "switch1",
      Documentation(
              info="<html>
<p>Allows switching of single conductor (of totally one or two).</p>
<p>'closed' and 'open' determine the mechanical switch-position.<br>
Electrically the switch is on if it is 'closed', whereas it is switched off, if it is mechanically 'open' and the corresponding phase-current crosses zero.</p>
<p>Contains no plasma-arc, in contrast to Breaker.</p>
</html>"),   Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Line(
            points={{-40,0},{40,0}},
            color={0,0,255},
            pattern=LinePattern.Dot)}));
  end Switch;

  model Breaker "Breaker, 1-phase"
    extends Partials.SwitchBase;

    replaceable Parameters.BreakerArc par "breaker parameter"
                                             annotation (Placement(
          transformation(extent={{60,70},{80,90}}, rotation=0)));
  protected
    replaceable Common.Switching.Breaker breaker_1(
      D=par.D,
      t_opening=par.t_opening,
      Earc=par.Earc,
      R0=par.R0,
      epsR=epsR,
      epsG=epsG,
      v=v,
      i=i) annotation (Placement(transformation(extent={{-20,10},{20,50}},
            rotation=0)));


  equation
    connect(control, breaker_1.closed)
      annotation (Line(points={{0,100},{0,50}}, color={255,0,255}));
    annotation (defaultComponentName = "breaker1",
      Documentation(
              info="<html>
<p> Allows switching of single conductor (of totally one or two).</p>
<p>'closed' and 'open' determine the mechanical switch-position.<br>
Electrically the switch is on if it is 'closed', whereas it is switched off, if it is mechanically fully 'open' (after a given opening duration) and the corresponding phase-current crosses zero.</p>
<p>Contains replaceable single-line breaker with replaceable tanh arc-voltage, i.e. a constant electric field strength E for large currents and a small-signal Ohmic resistance R.</p>
</pre>
</html>"),   Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Line(
            points={{-40,0},{-22,-6},{-10,-4},{2,4},{16,-4},{30,2},{40,0}},
            color={255,255,0},
            thickness=0.5)}));
  end Breaker;

  model ForcedDoubleSwitch "Forced double switch, 1-phase"
    extends Partials.DoubleSwitchBase;

    parameter SI.Time t_relax=10e-3 "switch relaxation time";
    parameter Integer p_relax(min=2)=4 "power of relaxation exponent";
  protected
    SI.Time[2] t0(start=-{Modelica.Constants.inf,Modelica.Constants.inf}, fixed=true);
    Real[2] r_1(start={0,1});
    Real[2] r_2(start={0,1});
    Real[2] s;
    Boolean[2] open(start={not control[1],not control[2]})={not control[1],not control[2]};
    Boolean[2] closed(start={control[1],control[2]})={control[1],control[2]};
    function relaxation=Base.Math.relaxation;

  equation
    when edge(open[1]) or edge(closed[1]) then
      t0[1] = time;
    end when;
    when edge(open[2]) or edge(closed[2]) then
      t0[2] = time;
    end when;
    r_1 = relaxation(time - t0[1], t_relax, p_relax);
    r_2 = relaxation(time - t0[2], t_relax, p_relax);
    {v[1],i[1]} = if closed[1] then {(r_1[1]+r_1[2]*epsR)*s[1],(r_1[1]*epsG+r_1[2])*s[1]} else {(r_1[1]*epsR+r_1[2])*s[1],(r_1[1]+r_1[2]*epsG)*s[1]};
    {v[2],i[2]} = if closed[2] then {(r_2[1]+r_2[2]*epsR)*s[2],(r_2[1]*epsG+r_2[2])*s[2]} else {(r_2[1]*epsR+r_2[2])*s[2],(r_2[1]+r_2[2]*epsG)*s[2]};
    annotation (defaultComponentName = "switch1",
      Documentation(
              info="<html>
<p>Allows double switching of double conductor.<br>
Switching by forced change of current-voltage ratio.</p>
<p>'closed' and 'open' determine the mechanical switch-position.<br>
Electrically the switch is on if it is 'closed', whereas
the currents start decreasing exponentially, when it is opened.</p>
<p>The transition between the 'off' conductivity (epsG) and the 'on' resistivity (epsR) is continuous with an exponential relaxation function
<pre>  f = (exp(-dt^p/2) - exp(-1/2))/(1 - exp(-1/2))</pre>
with
<pre>
  dt          relative time measured from switching instant
  t_relax     relaxation time
  p           power of exponent
</pre></p></html>"),
      Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Line(
            points={{-40,0},{40,0}},
            color={0,0,255},
            pattern=LinePattern.Dot), Text(
            extent={{-80,-20},{80,-60}},
            lineColor={0,0,255},
            textString =                 "exp")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(
            points={{-30,30},{-8,30}},
            color={0,0,255},
            pattern=LinePattern.Dot),
          Line(
            points={{-50,30},{-32,30},{-8,46}},
            color={0,0,255},
            thickness=0.5),
          Line(
            points={{-8,30},{10,30}},
            color={0,0,255},
            thickness=0.5),
          Text(
            extent={{-100,-40},{100,-60}},
            lineColor={0,0,255},
            pattern=LinePattern.Dot,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textString=
                 " forced switching with exponential relaxation"),
          Line(
            points={{10,-30},{32,-30}},
            color={0,0,255},
            pattern=LinePattern.Dot),
          Line(
            points={{-10,-30},{8,-30},{32,-14}},
            color={0,0,255},
            thickness=0.5),
          Line(
            points={{32,-30},{50,-30}},
            color={0,0,255},
            thickness=0.5),
          Line(
            points={{0,90},{0,80},{-20,80},{-20,38}},
            color={255,0,255},
            pattern=LinePattern.Dot),
          Line(
            points={{0,90},{0,80},{20,80},{20,-22}},
            color={255,0,255},
            pattern=LinePattern.Dot)}));
  end ForcedDoubleSwitch;

  model DoubleSwitch "Double switch, 1-phase"
    extends Partials.DoubleSwitchBase;

  protected
    Common.Switching.Switch switch_1(
      epsR=epsR,
      epsG=epsG,
      v=v[1],
      i=i[1])                     annotation (Placement(transformation(extent={
              {-60,0},{20,60}}, rotation=0)));
    Common.Switching.Switch switch_2(
      epsR=epsR,
      epsG=epsG,
      v=v[2],
      i=i[2])                     annotation (Placement(transformation(extent={
              {-20,-60},{60,0}}, rotation=0)));

  equation
    connect(control[1], switch_1.closed)  annotation (Line(points={{0,95},{0,80},
            {-20,80},{-20,60}}, color={255,0,255}));
    connect(control[2], switch_2.closed)  annotation (Line(points={{0,105},{0,
            80},{20,80},{20,0}}, color={255,0,255}));
    annotation (defaultComponentName = "switch1",
      Documentation(
              info="<html>
<p>Allows double switching of double conductor.</p>
<p>'closed' and 'open' determine the mechanical switch-position.<br>
Electrically the switch is on if it is 'closed', whereas it is switched off,
if it is mechanically 'open' and the corresponding phase-current crosses zero.</p>
<p>Contains no plasma-arc, in contrast to Breaker.</p>
</html>"),   Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Line(
            points={{-40,0},{40,0}},
            color={0,0,255},
            pattern=LinePattern.Dot)}));
  end DoubleSwitch;

  model DoubleBreaker "Double breaker, 1-phase"
    extends Partials.DoubleSwitchBase;

    replaceable Parameters.BreakerArc par "breaker parameter"
                                             annotation (Placement(
          transformation(extent={{60,70},{80,90}}, rotation=0)));
  protected
    replaceable Common.Switching.Breaker breaker_1(
      D=par.D,
      t_opening=par.t_opening,
      Earc=par.Earc,
      R0=par.R0,
      epsR=epsR,
      epsG=epsG,
      v=v[1],
      i=i[1])                     annotation (Placement(transformation(extent={
              {-60,0},{20,60}}, rotation=0)));
    replaceable Common.Switching.Breaker breaker_2(
      D=par.D,
      t_opening=par.t_opening,
      Earc=par.Earc,
      R0=par.R0,
      epsR=epsR,
      epsG=epsG,
      v=v[2],
      i=i[2])                     annotation (Placement(transformation(extent={
              {-20,-60},{60,0}}, rotation=0)));


  equation
    connect(control[1], breaker_1.closed)  annotation (Line(points={{0,95},{0,
            80},{-20,80},{-20,60}}, color={255,0,255}));
    connect(control[2], breaker_2.closed)  annotation (Line(points={{0,105},{0,
            80},{20,80},{20,0}}, color={255,0,255}));
    annotation (defaultComponentName = "breaker1",
      Documentation(
              info="<html>
<p>Allows double switching of double conductor.</p>
<p>'closed' and 'open' determine the mechanical switch-position.<br>
Electrically the switch is on if it is 'closed', whereas it is switched off,
if it is mechanically fully 'open' (after a given opening duration) and the corresponding phase-current crosses zero.</p>
<p>Contains replaceable single-line breakers with replaceable tanh arc-voltage, i.e. a constant electric field strength E for large currents and a small-signal Ohmic resistance R.</p>
</html>"),   Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Line(
            points={{-40,0},{-22,-6},{-10,-4},{2,4},{16,-4},{30,2},{40,0}},
            color={255,255,0},
            thickness=0.5)}));
  end DoubleBreaker;

  package Partials "Partial models"
    extends Base.Icons.Partials;

     partial model SwitchBase0 "Switch base, 1-phase"
       extends Ports.Port_pn;
       extends Base.Units.NominalVI;

       parameter Real[2] eps(final min={0,0}, unit="pu")={1e-4,1e-4}
        "{resistance 'closed', conductance 'open'}";
    protected
       final parameter SI.Resistance epsR=eps[1]*V_nom/I_nom;
       final parameter SI.Conductance epsG=eps[2]*I_nom/V_nom;
        annotation (
          Documentation(
                info="<html>
</html>"),       Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Rectangle(
              extent={{-80,60},{80,-40}},
              lineColor={255,255,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Line(points={{40,10},{80,10}}, color={0,0,255}),
            Line(points={{-80,10},{-40,10},{30,50}}, color={0,0,255}),
            Line(
              points={{0,90},{0,34}},
              color={255,0,255},
              pattern=LinePattern.Dot)}));
     end SwitchBase0;

    partial model SwitchBase "Switch base, 1-phase"
      extends SwitchBase0;

      SI.Voltage v;
      SI.Current i;
      Modelica.Blocks.Interfaces.BooleanInput control "true:closed, false:open"
      annotation (Placement(transformation(
            origin={0,100},
            extent={{-10,-10},{10,10}},
            rotation=270)));

    equation
      v = term_p.pin[1].v - term_n.pin[1].v;
      i = term_p.pin[1].i;
      term_p.pin[2].v = term_n.pin[2].v;
      annotation (
        Documentation(
              info="<html>
<p>Allows one or two conductors. The first is switched.</p>
</html>"),        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Line(points={{-80,-30},{80,-30}}, color={0,0,255}),
            Line(points={{-80,30},{-30,30}}, color={0,0,255}),
            Line(points={{30,30},{80,30}}, color={0,0,255})}));
    end SwitchBase;

    partial model DoubleSwitchBase "Double switch base, 1-phase"
      extends SwitchBase0;

      SI.Voltage[2] v;
      SI.Current[2] i;
      Modelica.Blocks.Interfaces.BooleanInput[2] control
        "true:closed, false:open"
      annotation (Placement(transformation(
            origin={0,100},
            extent={{-10,-10},{10,10}},
            rotation=270)));

    equation
      v = term_p.pin.v - term_n.pin.v;
      i = term_p.pin.i;
      annotation (
        Documentation(
              info="<html>
<p>Both of two conductors are switched.</p>
</html>"),     Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Line(points={{-80,-10},{80,-10}}, color={0,0,
                  255})}),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Line(points={{-80,-30},{-10,-30}}, color={0,0,255}),
            Line(points={{50,-30},{80,-30}}, color={0,0,255}),
            Line(points={{-80,30},{-50,30}}, color={0,0,255}),
            Line(points={{10,30},{80,30}}, color={0,0,255})}));
    end DoubleSwitchBase;
  end Partials;

package Parameters "Parameter data for interactive use"
  extends Base.Icons.Base;


record BreakerArc "Breaker parameters, 3-phase"
  extends Base.Icons.Record;
  parameter SI.Distance D=50e-3 "contact distance open";
  parameter SI.Time t_opening=30e-3 "opening duration";
  parameter SI.ElectricFieldStrength Earc=50e3 "electric field arc";
  parameter Real R0=1 "small signal resistance arc";

  annotation (defaultComponentName = "data",
    Documentation(
            info="<html>
</html>"));
end BreakerArc;
  annotation (preferredView="info",
Documentation(info="<html>
<p>Records containing parameters of the corresponding components.</p>
</html>"));
end Parameters;
  annotation (preferredView="info",
Documentation(info="<html>
<p>Contains switches acting on one conductor only and double-switches acting on both conductors.</p>
<p>Terminology:</p>
<p><tt><b>Forced switch</b></tt> is used for a component that breaks the current independent of a possible zero crossing.<br>
<tt><b>Switch</b></tt> is used for a component, that breaks the current during zero-crossing but does not contain any additional physical properties like arc-voltage etc.<br>
<tt><b>Breaker</b></tt> is used for a component that acts basically like a 'Switch' but contains additionally physical properties of plasma-arcs, opening duration etc.</p>
</html>"));
end Breakers;
