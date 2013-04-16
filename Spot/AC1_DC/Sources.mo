within Spot.AC1_DC;

package Sources "DC voltage sources"
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
<p>AC sources have the optional inputs:</p>
<pre>
  vPhasor:   voltage {norm, phase}
  omega:     angular frequency
</pre>
<p>DC sources have the optional input:</p>
<pre>  vDC:       DC voltage</pre>
<p>To use signal inputs, choose parameters vType=signal and/or fType=signal.</p>
</html>"),
    Icon);
  model ACvoltage "Ideal AC voltage, 1-phase"
    extends Partials.ACvoltageBase;

    parameter SIpu.Voltage veff=1 "eff voltage"   annotation(Dialog(enable=scType==Base.Types.par));
    parameter SI.Angle alpha0=0 "phase angle"   annotation(Dialog(enable=scType==Base.Types.par));
  protected
    SI.Voltage V;
    SI.Angle alpha;
    SI.Angle phi;
    annotation (defaultComponentName = "voltage1",
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
<p>AC voltage with constant amplitude and phase when 'vType' is 'parameter',<br>
with variable amplitude and phase when 'vType' is 'signal'.</p>
<p>Optional input:
<pre>
  omega           angular frequency  (choose fType == \"sig\")
  vPhasor         {eff(v), phase(v)}
   vPhasor[1]     in SI or pu, depending on choice of 'units'
   vPhasor[2]     in rad
</pre></p>
</html>
"),   Icon,
      Diagram);

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
    annotation (defaultComponentName = "voltage1",
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
      Diagram);

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
  end Vspectrum;

  model DCvoltage "Ideal DC voltage"
    extends Partials.DCvoltageBase(pol=-1);

    parameter SIpu.Voltage v0=1 "DC voltage"   annotation(Dialog(enable=scType==Base.Types.par));
  protected
    SI.Voltage v;
    annotation (defaultComponentName = "voltage1",
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
<p>DC voltage with constant amplitude when 'vType' is 'parameter',<br>
with variable amplitude when 'vType' is 'signal'.</p>
<p>Optional input:
<pre>  vDC     DC voltage in SI or pu, depending on choice of 'units' </pre></p>
</html>
"),   Icon,
      Diagram);

  equation
    if scType == Base.Types.par then
      v = v0*V_base;
    elseif scType == Base.Types.sig then
      v = vDC*V_base;
    end if;
    term.pin[1].v - term.pin[2].v = v;
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
    annotation (defaultComponentName = "battery1",
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
<p><b>Preliminary:</b> Battery is DC voltage with constant amplitude.<br>
To be completed later with charging and discharging characteristic.</p>
</html>
"),   Icon(
        Ellipse(
        extent=[-70,-70; 70,70], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Line(
     points=[-70,0; 70,0], style(
            color=42,
            rgbcolor={176,0,0},
            thickness=2)),
  Line(points=[-34,40; -34,-40],   style(color=42, rgbcolor={176,0,0})),
  Line(points=[-20,20; -20,-20],   style(color=42, rgbcolor={176,0,0})),
  Line(points=[20,40; 20,-40],   style(color=42, rgbcolor={176,0,0})),
  Line(points=[34,20; 34,-20],   style(color=42, rgbcolor={176,0,0})),
        Line(points=[-34,0; -20,0], style(
            color=7,
            rgbcolor={255,255,255},
            thickness=2)),
        Line(points=[20,0; 34,0], style(
            color=7,
            rgbcolor={255,255,255},
            thickness=2))),
      Diagram);

  equation
    v = v0*V_base;
    term.pin[2].v = 0;
    term.pin[1].v - term.pin[2].v = v;
    term.pin[1].i = -i;
  end Battery;

  package Partials "Partial models"
    extends Base.Icons.Partials;

    annotation (
          Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]), Window(
  x=0.05,
  y=0.44,
  width=0.35,
  height=0.27,
  library=1,
  autolayout=1));

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
        annotation (extent=[-110,-10; -90,10], rotation=0);
    protected
      final parameter SI.Voltage V_base=Base.Precalculation.baseV(units, V_nom);
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
<p>Allows positive, symmetrical, and negativ grounding according to the choice of parameter 'pol'.<br>
If the connector 'neutral' remains unconnected, then the source is NOT grounded. In all other cases connect 'neutral' to the desired circuit or ground.</p>
</html>"),
        Icon(
          Ellipse(
          extent=[-70,-70; 70,70], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=7,
              rgbfillColor={255,255,255})),
          Line(
       points=[-70,0; 70,0], style(
              color=42,
              rgbcolor={176,0,0},
              thickness=2))),
        Diagram);

    equation
      if pol==1 then
        term.pin[1].v = neutral.v;
      elseif pol==-1 then
        term.pin[2].v = neutral.v;
      else
        term.pin[1].v + term.pin[2].v = neutral.v;
      end if;

      sum(term.pin.i) + neutral.i = 0;
    end VoltageBase;

    partial model ACvoltageBase "AC voltage base"

      parameter Base.Types.FreqType fType=Base.Types.sys
        "f: system, parameter, signal"
        annotation(Evaluate=true);
      parameter SI.Frequency f=system.f "frequency" annotation(Dialog(enable=fType==Base.Types.par));
      extends VoltageBase;

      Modelica.Blocks.Interfaces.RealInput[2] vPhasor
        "{abs(voltage), phase(voltage)}"
        annotation(extent=[50,90; 70,110],    rotation=-90);
      Modelica.Blocks.Interfaces.RealInput omega(redeclare type SignalType =
            SI.AngularFrequency) "ang frequency"
        annotation (extent=[-70,90; -50,110],rotation=-90);
    protected
      outer System system;
      SI.Angle theta(stateSelect=StateSelect.prefer);
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
    end ACvoltageBase;

    partial model DCvoltageBase "DC voltage base"
      extends VoltageBase;

      parameter Integer pol(min=-1,max=1)=-1 "grounding scheme"
        annotation(evaluate=true,
        choices(choice=1 "positive",
        choice=0 "symmetrical",
        choice=-1 "negative"));
      Modelica.Blocks.Interfaces.RealInput vDC(redeclare type SignalType =
            SIpu.Voltage) "DC voltage"
        annotation (
              extent=[50,90; 70,110],    rotation=-90);
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
          Text(
    extent=[-50,10; 50,-60],
            style(
              color=42,
              rgbcolor={176,0,0},
              thickness=2,
              fillColor=77,
              rgbfillColor={127,0,255}),
            string="=")),
        Diagram);

    end DCvoltageBase;
  end Partials;

end Sources;
