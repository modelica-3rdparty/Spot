within Spot.AC1_DC;


package Sources "DC voltage sources"
  extends Base.Icons.Library;

  model ACvoltage "Ideal AC voltage, 1-phase"
    extends Partials.ACvoltageBase;

    parameter SIpu.Voltage veff=1 "eff voltage"   annotation(Dialog(enable=scType==Base.Types.par));
    parameter SI.Angle alpha0=0 "phase angle"   annotation(Dialog(enable=scType==Base.Types.par));
  protected
    SI.Voltage V;
    SI.Angle alpha;
    SI.Angle phi;

  equation
    if scType == Base.Types.par then
      V = veff*sqrt(2)*V_base;
      alpha = alpha0;
    elseif scType == Base.Types.sig then
      V = vPhasor[1]*sqrt(2)*V_base;
      alpha = vPhasor[2];
    end if;

    phi = theta + alpha + system.alpha0;
    term.pin[1].v - term.pin[2].v = V*cos(phi);
    annotation (defaultComponentName = "voltage1",
      Documentation(
              info="<html>
<p>AC voltage with constant amplitude and phase when 'vType' is 'parameter',<br>
with variable amplitude and phase when 'vType' is 'signal'.</p>
<p>Optional input:
<pre>
  omega           angular frequency  (choose fType == \"sig\")
  vPhasor         {eff(v), phase(v)}
   vPhasor[1]     in SI or pu, depending on choice of 'units'
   vPhasor[2]     in rad
</pre></p>
</html>"));
  end ACvoltage;

  model Vspectrum "Ideal voltage spectrum, 1-phase"
    extends Partials.ACvoltageBase;

    parameter Integer[:] h={1,3,5} "[1,.. ], which harmonics?";
    parameter SIpu.Voltage[N] veff={1,0.3,0.1} "eff voltages";
    parameter SI.Angle[N] alpha0=zeros(N) "phase angles";
  protected
    final parameter Integer N=size(h, 1) "nb of harmonics";
    SI.Voltage V;
    SI.Angle alpha;
    SI.Angle[N] phi;

  equation
    if scType == Base.Types.par then
      V = sqrt(2)*V_base;
      alpha = 0;
    elseif scType == Base.Types.sig then
      V = vPhasor[1]*sqrt(2)*V_base;
      alpha = vPhasor[2];
    end if;

    phi = h*(theta + alpha + system.alpha0) + h.*alpha0;
    term.pin[1].v - term.pin[2].v = V*veff*cos(phi);
    annotation (defaultComponentName = "voltage1",
      Documentation(
              info="<html>
<p>AC voltage spectrum with constant amplitude and phase when 'vType' is 'parameter',<br>
with variable amplitude and phase when 'vType' is 'signal'.</p>
<p>The voltage-spectrum is given by the expression
<pre>
  v_spec = sqrt(2)*veff*sum_n(cos(h[n]*(theta + alpha_tot[n])))
with
  alpha_tot[n] = alpha + system.alpha0 + alpha0[n]
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
      Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Text(
            extent={{-40,60},{40,-20}},
            lineColor={176,0,0},
            lineThickness=0.5,
            fillColor={127,0,255},
            fillPattern=FillPattern.Solid,
            textString=
                 "~~~")}));
  end Vspectrum;

  model DCvoltage "Ideal DC voltage"
    extends Partials.DCvoltageBase(pol=-1);

    parameter SIpu.Voltage v0=1 "DC voltage"   annotation(Dialog(enable=scType==Base.Types.par));
  protected
    SI.Voltage v;

  equation
    if scType == Base.Types.par then
      v = v0*V_base;
    elseif scType == Base.Types.sig then
      v = vDC*V_base;
    end if;
    term.pin[1].v - term.pin[2].v = v;
    annotation (defaultComponentName = "voltage1",
      Documentation(
              info="<html>
<p>DC voltage with constant amplitude when 'vType' is 'parameter',<br>
with variable amplitude when 'vType' is 'signal'.</p>
<p>Optional input:
<pre>  vDC     DC voltage in SI or pu, depending on choice of 'units' </pre></p>
</html>"));
  end DCvoltage;

  model Battery "Battery"
    extends Ports.Port_n;
    extends Base.Units.Nominal;

    parameter Integer pol(min=-1,max=1)=-1 "grounding scheme"
      annotation(evaluate=true,
      choices(choice=1 "plus",
      choice=0 "symmetrical",
      choice=-1 "negative"));
    parameter SIpu.Voltage v0=1 "battery voltage";
    parameter SIpu.Charge_Ah Q_nom=1 "nominal Capacity";
  protected
    final parameter SI.Voltage V_base=Base.Precalculation.baseV(units, V_nom);
    SI.Voltage v;
    SI.Current i;

  equation
    v = v0*V_base;
    term.pin[2].v = 0;
    term.pin[1].v - term.pin[2].v = v;
    term.pin[1].i = -i;
    annotation (defaultComponentName = "battery1",
      Documentation(
              info="<html>
<p><b>Preliminary:</b> Battery is DC voltage with constant amplitude.<br>
To be completed later with charging and discharging characteristic.</p>
</html>"),   Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Ellipse(
            extent={{-70,-70},{70,70}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-70,0},{70,0}},
            color={176,0,0},
            thickness=0.5),
          Line(points={{-34,40},{-34,-40}}, color={176,0,0}),
          Line(points={{-20,20},{-20,-20}}, color={176,0,0}),
          Line(points={{20,40},{20,-40}}, color={176,0,0}),
          Line(points={{34,20},{34,-20}}, color={176,0,0}),
          Line(
            points={{-34,0},{-20,0}},
            color={255,255,255},
            thickness=0.5),
          Line(
            points={{20,0},{34,0}},
            color={255,255,255},
            thickness=0.5)}));
  end Battery;

  package Partials "Partial models"
    extends Base.Icons.Partials;


    partial model VoltageBase "Voltage base"
      extends Ports.Port_n;
      extends Base.Units.Nominal(final S_nom=1);

      parameter Integer pol(min=-1,max=1)=-1 "grounding scheme"
        annotation(evaluate=true,
        choices(choice=1 "positive",
        choice=0 "symmetrical",
        choice=-1 "negative"));
      parameter Base.Types.SourceType scType=Base.Types.par
        "v: parameter or signal"
       annotation(Evaluate=true);
                                   Base.Interfaces.Electric_p neutral
        "(use for grounding)"
        annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
              rotation=0)));
    protected
      final parameter SI.Voltage V_base=Base.Precalculation.baseV(units, V_nom);

    equation
      if pol==1 then
        term.pin[1].v = neutral.v;
      elseif pol==-1 then
        term.pin[2].v = neutral.v;
      else
        term.pin[1].v + term.pin[2].v = neutral.v;
      end if;

      sum(term.pin.i) + neutral.i = 0;
      annotation (
        Documentation(
              info="<html>
<p>Allows positive, symmetrical, and negativ grounding according to the choice of parameter 'pol'.<br>
If the connector 'neutral' remains unconnected, then the source is NOT grounded. In all other cases connect 'neutral' to the desired circuit or ground.</p>
</html>"),
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Ellipse(
              extent={{-70,-70},{70,70}},
              lineColor={0,0,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid), Line(
              points={{-70,0},{70,0}},
              color={176,0,0},
              thickness=0.5)}));
    end VoltageBase;

    partial model ACvoltageBase "AC voltage base"

      parameter Base.Types.FreqType fType=Base.Types.sys
        "f: system, parameter, signal"
        annotation(Evaluate=true);
      parameter SI.Frequency f=system.f "frequency" annotation(Dialog(enable=fType==Base.Types.par));
      extends VoltageBase;

      Modelica.Blocks.Interfaces.RealInput[2] vPhasor
        "{abs(voltage), phase(voltage)}"
        annotation (Placement(transformation(
            origin={60,100},
            extent={{-10,-10},{10,10}},
            rotation=270)));
      Modelica.Blocks.Interfaces.RealInput omega "ang frequency" annotation (
          Placement(transformation(
            origin={-60,100},
            extent={{-10,-10},{10,10}},
            rotation=270)));
    protected
      outer System system;
      SI.Angle theta(stateSelect=StateSelect.prefer);

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
      annotation (
        Documentation(
              info="<html>
</html>"),
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Text(
              extent={{-50,30},{50,-70}},
              lineColor={176,0,0},
              lineThickness=0.5,
              fillColor={127,0,255},
              fillPattern=FillPattern.Solid,
              textString=
           "~")}));
    end ACvoltageBase;

    partial model DCvoltageBase "DC voltage base"
      extends VoltageBase;

      parameter Integer pol(min=-1,max=1)=-1 "grounding scheme"
        annotation(evaluate=true,
        choices(choice=1 "positive",
        choice=0 "symmetrical",
        choice=-1 "negative"));
      Modelica.Blocks.Interfaces.RealInput vDC "DC voltage" annotation (
          Placement(transformation(
            origin={60,100},
            extent={{-10,-10},{10,10}},
            rotation=270)));
      annotation (
        Documentation(
              info="<html>
</html>"),
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Text(
              extent={{-50,10},{50,-60}},
              lineColor={176,0,0},
              lineThickness=0.5,
              fillColor={127,0,255},
              fillPattern=FillPattern.Solid,
              textString=
                   "=")}));

    end DCvoltageBase;
  end Partials;

  annotation (preferredView="info",
Documentation(info="<html>
<p>AC sources have the optional inputs:</p>
<pre>
  vPhasor:   voltage {norm, phase}
  omega:     angular frequency
</pre>
<p>DC sources have the optional input:</p>
<pre>  vDC:       DC voltage</pre>
<p>To use signal inputs, choose parameters vType=signal and/or fType=signal.</p>
</html>"));
end Sources;
