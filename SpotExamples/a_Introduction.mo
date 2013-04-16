within SpotExamples;
package a_Introduction "Introductory examples"
  extends Spot.Base.Icons.Examples;

  model Units "SI and pu units"

  annotation (
    Coordsys(
          extent=[-100,-100; 100,100],
          grid=[2,2],
          component=[20,20]),
    Window(
          x=0.45,
          y=0.01,
          width=0.44,
          height=0.65),
    Diagram,
    Documentation(
            info="<html>
<p>This example shows, how input-parameters can be defined in SI- or in pu-units (V, A or 'per unit').<br>
'SI | pu' means 'SI' or 'pu', depending on the choice of 'units'.
<pre>
  SI:     base-values = 1
  pu:     base-values = nominal-values (by definition)
</pre></p>
<p>
Upper part:<br>
input for 'voltage_SI', 'meter_SI' and 'load_SI' in V, VA, and Ohm.
<pre>
  V_base = 1,     V_nom = 400 V
  S_base = 1,     S_nom = 10 kVA
  R_base = 1
</pre>
Lower part:<br>
input for 'voltage_pu', 'meter_pu' and 'load_pu' in pu.
<pre>
  V_base = V_nom = 400 V
  S_base = S_nom = 10 kVA
  R_base = V_base^2/S_base = 16 Ohm
</pre>
The corresponding values are
<pre>
  408 V   and  1.02 pu
  20 Ohm  and  1.25 pu
</pre>
Quantities in 'meter_SI' are displayed in SI.<br>
Quantities in 'meter_pu' are displayed in pu.</p>
<p>
<i>See for example:</i>
<pre>
  meter_SI.p[1] = 8323.2 W   (active power in SI)
  meter_pu.p[1] = 0.83232 pu (active power in pu)
</pre>
and other meter-signals.</p>
<p><a href=\"Spot.UsersGuide.Introduction.Examples\">up users guide</a></p>
</html>"),
    experiment(StopTime=0.1),
    experimentSetupOutput);
    inner Spot.System system(ref="inertial")
                      annotation (extent=[-100,80; -80,100]);
    Spot.ACabc.Sources.Voltage voltage_SI(
      V_nom=400,
      v0=408,
      units=Spot.Base.Types.SI)
           annotation (extent=[-60,20; -40,40]);
    Spot.ACabc.Nodes.GroundOne grdV1
                                annotation (extent=[-70,20; -90,40]);
    Spot.ACabc.Sources.Voltage voltage_pu(
      V_nom=400,
      v0=1.02,
      units=Spot.Base.Types.pu)
           annotation (extent=[-60,-40; -40,-20]);
    Spot.ACabc.Nodes.GroundOne grdV2
                                annotation (extent=[-70,-40; -90,-20]);
    Spot.ACabc.Sensors.PVImeter meter_SI(
      V_nom=400,
      S_nom=10e3,
      units=Spot.Base.Types.SI)
    annotation (
          extent=[-20,20; 0,40]);
    Spot.ACabc.Sensors.PVImeter meter_pu(
      V_nom=400,
      S_nom=10e3,
      units=Spot.Base.Types.pu)
    annotation (
          extent=[-20,-40; 0,-20]);
    Spot.ACabc.Impedances.Resistor load_SI(
      V_nom=400,
      S_nom=10e3,
      r=20,
      units=Spot.Base.Types.SI)
      annotation (extent=[20,20; 40,40]);
    Spot.ACabc.Impedances.Resistor load_pu(
      V_nom=400,
      S_nom=10e3,
      r=1.25,
      units=Spot.Base.Types.pu)
     annotation (extent=[20,-40; 40,-20]);
    Spot.ACabc.Nodes.Ground grd1           annotation (extent=[50,20; 70,40]);
    Spot.ACabc.Nodes.Ground grd2           annotation (extent=[50,-40; 70,-20]);

  equation
    connect(voltage_SI.term, meter_SI.term_p) annotation (points=[-40,30; -20,30],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(meter_SI.term_n, load_SI.term_p) annotation (points=[0,30; 20,30],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(load_SI.term_n, grd1.term) annotation (points=[40,30; 50,30], style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(voltage_pu.term, meter_pu.term_p) annotation (points=[-40,-30; -20,
          -30], style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(meter_pu.term_n, load_pu.term_p) annotation (points=[0,-30; 20,-30],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(load_pu.term_n, grd2.term) annotation (points=[40,-30; 50,-30],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(grdV1.term, voltage_SI.neutral)
      annotation (points=[-70,30; -60,30], style(color=3, rgbcolor={0,0,255}));
    connect(grdV2.term, voltage_pu.neutral) annotation (points=[-70,-30; -60,
          -30], style(color=3, rgbcolor={0,0,255}));
  end Units;

  model Frequency "System and autonomous frequency"

  annotation (
    Coordsys(
          extent=[-100,-100; 100,100],
          grid=[2,2],
          component=[20,20]),
    Window(
          x=0.45,
          y=0.01,
          width=0.44,
          height=0.65),
    Diagram,
    Documentation(
            info="<html>
<p>Example of two frequency-independent parts, one with system- and one with autonomous frequency.</p>
<p>The input 'omega_inp' of voltage2 is connected to a signal source and the parameter <tt>fType</tt> is set to <tt>\"sig\"</tt>. The source delivers an angular frequency <tt>omega</tt> which is independent of the actual system frequency.</p>
<p>Note: the 'Mode'-parameters 'ini' and 'sim' in 'system' are ignored by one-phase and DC components.</p>
<p>
<i>See for example:</i>
<pre>
  meter1     v and i-signal, system frequency (60 Hz)
  meter2     v and i-signal, variable frequency (10 to 50 Hz)
</pre></p>
<p><a href=\"Spot.UsersGuide.Introduction.Examples\">up users guide</a></p>
</html>"),
    experiment(NumberOfIntervals=1000),
    experimentSetupOutput);
    inner Spot.System system(f_nom=60, ref="inertial")
                      annotation (extent=[-100,80; -80,100]);
    Spot.Blocks.Signals.TransientFreq theta_dqo(f_fin=50, f_ini=10)
      annotation (extent=[-80,-20; -60,0]);
    Spot.AC1_DC.Sources.ACvoltage voltage1(veff=230, units=Spot.Base.
      Types.SI)
      annotation (extent=[-40,20; -20,40]);
    Spot.AC1_DC.Nodes.GroundOne grdV1
                                 annotation (extent=[-50,20; -70,40]);
    Spot.AC1_DC.Sources.ACvoltage voltage2(
      veff=230,
      fType="sig",
      units=Spot.Base.Types.SI)
                   annotation (extent=[-40,-40; -20,-20]);
    Spot.AC1_DC.Nodes.GroundOne grdV2
                                 annotation (extent=[-50,-40; -70,-20]);
    Spot.AC1_DC.ImpedancesOneTerm.Inductor ind1(
      x=0.2,
      r=0.5,
      units=Spot.Base.Types.SI,
      f_nom=700)
             annotation (extent=[40,20; 60,40]);
    Spot.AC1_DC.ImpedancesOneTerm.Inductor ind2(
      x=0.2,
      r=0.5,
      units=Spot.Base.Types.SI)
             annotation (extent=[40,-40; 60,-20]);
    Spot.AC1_DC.Sensors.PVImeter meter1(units=Spot.Base.Types.SI)
      annotation (extent=[0,20; 20,40]);
    Spot.AC1_DC.Sensors.PVImeter meter2(units=Spot.Base.Types.SI)
      annotation (extent=[0,-40; 20,-20]);

  equation
    connect(voltage1.term, meter1.term_p)
      annotation (points=[-20,30; 0,30],  style(color=3, rgbcolor={0,0,255}));
    connect(meter1.term_n, ind1.term)
      annotation (points=[20,30; 40,30], style(color=3, rgbcolor={0,0,255}));
    connect(voltage2.term, meter2.term_p)
      annotation (points=[-20,-30; 0,-30], style(color=3, rgbcolor={0,0,255}));
    connect(meter2.term_n, ind2.term)
      annotation (points=[20,-30; 40,-30], style(color=3, rgbcolor={0,0,255}));
    connect(grdV1.term, voltage1.neutral)
      annotation (points=[-50,30; -40,30], style(color=3, rgbcolor={0,0,255}));
    connect(grdV2.term, voltage2.neutral) annotation (points=[-50,-30; -40,-30],
        style(color=3, rgbcolor={0,0,255}));
    connect(theta_dqo.y, voltage2.omega) annotation (points=[-60,-10; -36,-10;
          -36,-20], style(color=74, rgbcolor={0,0,127}));
  end Frequency;

  model ReferenceInertial "Inertial reference system (non rotating)"

  annotation (
    Coordsys(
          extent=[-100,-100; 100,100],
          grid=[2,2],
          component=[20,20]),
    Window(
          x=0.45,
          y=0.01,
          width=0.44,
          height=0.65),
    Diagram,
    Documentation(
            info="<html>
<p>This example shows two physically identical systems, the upper one in abc-, the lower one in dqo-representation.</p>
<p>In the inertial, non rotating reference frame (<tt>SynRef=false</tt>), signals oscillate with the source frequency.</p>
<p>
<i>See for example:</i>
<pre>
  meter_abc.i     standard notation: 'abc'-system
  meter_dqo.i     standard notation: 'alpha beta gamma'-system
</pre>
and other meter-signals.<br>
Compare with the signals of the identical system in the example below.</p>
<p><a href=\"Spot.UsersGuide.Introduction.Examples\">up users guide</a></p>
</html>"),
    experiment(StopTime=0.1, NumberOfIntervals=1000),
    experimentSetupOutput);
    inner Spot.System system(ini="tr", ref="inertial")
                      annotation (extent=[-100,80; -80,100]);
    Spot.ACabc.Sources.Voltage voltage_abc(
      V_nom=400,
      v0=1.02,
      units=Spot.Base.Types.pu)
           annotation (extent=[-60,20; -40,40]);
    Spot.ACabc.Nodes.GroundOne grdV_abc
                                annotation (extent=[-70,20; -90,40]);
    Spot.ACdqo.Sources.Voltage voltage_dqo(
      V_nom=400,
      v0=1.02,
      units=Spot.Base.Types.pu)
           annotation (extent=[-60,-40; -40,-20]);
    Spot.ACdqo.Nodes.GroundOne grdV_dqo
                                annotation (extent=[-70,-40; -90,-20]);
    Spot.ACabc.Sensors.PVImeter meter_abc(
      V_nom=400,
      S_nom=10e3,
      units=Spot.Base.Types.pu)
    annotation (
          extent=[-20,20; 0,40]);
    Spot.ACdqo.Sensors.PVImeter meter_dqo(
      V_nom=400,
      S_nom=10e3,
      units=Spot.Base.Types.pu)
    annotation (
          extent=[-20,-40; 0,-20]);
    Spot.ACabc.Impedances.Inductor load_abc(
      V_nom=400,
      S_nom=10e3,
      r=0.1,
      units=Spot.Base.Types.pu)
      annotation (extent=[20,20; 40,40]);
    Spot.ACdqo.Impedances.Inductor load_dqo(
      V_nom=400,
      S_nom=10e3,
      r=0.1,
      units=Spot.Base.Types.pu)
     annotation (extent=[20,-40; 40,-20]);
    Spot.ACabc.Nodes.Ground grd_abc        annotation (extent=[50,20; 70,40]);
    Spot.ACdqo.Nodes.Ground grd_dqo        annotation (extent=[50,-40; 70,-20]);

  equation
    connect(voltage_abc.term, meter_abc.term_p) annotation (points=[-40,30; -20,30],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(meter_abc.term_n, load_abc.term_p) annotation (points=[0,30; 20,30],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(load_abc.term_n, grd_abc.term) annotation (points=[40,30; 50,30],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(voltage_dqo.term, meter_dqo.term_p) annotation (points=[-40,-30;
          -20,-30], style(
        color=62,
        rgbcolor={0,120,120},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(meter_dqo.term_n, load_dqo.term_p) annotation (points=[0,-30; 20,
          -30], style(
        color=62,
        rgbcolor={0,120,120},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(load_dqo.term_n, grd_dqo.term) annotation (points=[40,-30; 50,-30],
        style(
        color=62,
        rgbcolor={0,120,120},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(grdV_abc.term, voltage_abc.neutral)
      annotation (points=[-70,30; -60,30], style(color=3, rgbcolor={0,0,255}));
    connect(grdV_dqo.term, voltage_dqo.neutral) annotation (points=[-70,-30;
          -60,-30], style(color=3, rgbcolor={0,0,255}));
  end ReferenceInertial;

  annotation (preferedView="info",
Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
Window(
  x=0.05,
  y=0.41,
  width=0.4,
  height=0.42,
  library=1,
  autolayout=1),
Documentation(info="<html>
<p>Each of the introductory examples points out one specific aspect of specifying and simulating a model.
The examples are based on most elementary configurations. A meter is added for convenience, displaying signals both in abc- and dqo-representation. </p>
<p>The component Spot.System is needed in all models, except in Introduction.Tables.</p>
<p><a href=\"Spot.UsersGuide.Introduction.Examples\">up users guide</a></p>
</html>
"), Icon);

  model ReferenceSynchron "Synchronous reference system (rotating)"

  annotation (
    Coordsys(
          extent=[-100,-100; 100,100],
          grid=[2,2],
          component=[20,20]),
    Window(
          x=0.45,
          y=0.01,
          width=0.44,
          height=0.65),
    Diagram,
    Documentation(
            info="<html>
<p>This example shows two physically identical systems, the upper one in abc-, the lower one in dqo-representation.</p>
<p>In the synchronous, rotating reference frame (<tt>SynRef=true</tt>), steady-state signals are constant (after an initial oscillation).</p>
<p>
<i>See for example:</i>
<pre>
  meter_abc.i
  meter_dqo.i     standard notation: 'dqo'-system
</pre>
and other meter-signals.<br>
Compare with the signals of the identical system in the example above.</p>
<p><a href=\"Spot.UsersGuide.Introduction.Examples\">up users guide</a></p>
</html>"),
    experiment(StopTime=0.1, NumberOfIntervals=1000),
    experimentSetupOutput);
    inner Spot.System system(ini="tr")
                      annotation (extent=[-100,80; -80,100]);
    Spot.ACabc.Sources.Voltage voltage_abc(
      V_nom=400,
      v0=1.02,
      units=Spot.Base.Types.pu)
           annotation (extent=[-60,20; -40,40]);
    Spot.ACabc.Nodes.GroundOne grdV_abc
                                annotation (extent=[-70,20; -90,40]);
    Spot.ACdqo.Sources.Voltage voltage_dqo(
      V_nom=400,
      v0=1.02,
      units=Spot.Base.Types.pu)
           annotation (extent=[-60,-40; -40,-20]);
    Spot.ACdqo.Nodes.GroundOne grdV_dqo
                                annotation (extent=[-70,-40; -90,-20]);
    Spot.ACabc.Sensors.PVImeter meter_abc(
      V_nom=400,
      S_nom=10e3,
      units=Spot.Base.Types.pu)
    annotation (
          extent=[-20,20; 0,40]);
    Spot.ACdqo.Sensors.PVImeter meter_dqo(
      V_nom=400,
      S_nom=10e3,
      abc=true,
      units=Spot.Base.Types.pu)
    annotation (
          extent=[-20,-40; 0,-20]);
    Spot.ACabc.Impedances.Inductor load_abc(
      V_nom=400,
      S_nom=10e3,
      r=0.1,
      units=Spot.Base.Types.pu)
      annotation (extent=[20,20; 40,40]);
    Spot.ACdqo.Impedances.Inductor load_dqo(
      V_nom=400,
      S_nom=10e3,
      r=0.1,
      units=Spot.Base.Types.pu)
     annotation (extent=[20,-40; 40,-20]);
    Spot.ACabc.Nodes.Ground grd_abc        annotation (extent=[50,20; 70,40]);
    Spot.ACdqo.Nodes.Ground grd_dqo        annotation (extent=[50,-40; 70,-20]);

  equation
    connect(voltage_abc.term, meter_abc.term_p) annotation (points=[-40,30; -20,30],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(meter_abc.term_n, load_abc.term_p) annotation (points=[0,30; 20,30],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(load_abc.term_n, grd_abc.term) annotation (points=[40,30; 50,30],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(voltage_dqo.term, meter_dqo.term_p) annotation (points=[-40,-30;
          -20,-30], style(
        color=62,
        rgbcolor={0,120,120},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(meter_dqo.term_n, load_dqo.term_p) annotation (points=[0,-30; 20,
          -30], style(
        color=62,
        rgbcolor={0,120,120},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(load_dqo.term_n, grd_dqo.term) annotation (points=[40,-30; 50,-30],
        style(
        color=62,
        rgbcolor={0,120,120},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(grdV_abc.term, voltage_abc.neutral)
      annotation (points=[-70,30; -60,30], style(color=3, rgbcolor={0,0,255}));
    connect(grdV_dqo.term, voltage_dqo.neutral) annotation (points=[-70,-30;
          -60,-30], style(color=3, rgbcolor={0,0,255}));
  end ReferenceSynchron;

  model InitialSteadyState "Steady-state initialisation"

  annotation (
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
<p>With 'system.ini = steady' (using the steady-state initial conditions) no inrush is observed as in the previous two examples. The solution is steady-state from the beginning.</p>
<p>The example illustrates the choice <tt>SynRef=false</tt> (inertial system), but is valid for other choices too.</p>
<p>
<i>See for example:</i>
<pre>
  meter_abc.i_abc
  meter_dqo.i_abc
</pre>
<p><a href=\"Spot.UsersGuide.Introduction.Examples\">up users guide</a></p>
</html>"),
    Diagram,
    experiment(StopTime=0.1, NumberOfIntervals=1000),
    experimentSetupOutput);
    inner Spot.System system(ref="inertial")
                      annotation (extent=[-100,80; -80,100]);
    Spot.ACabc.Sources.Voltage voltage_abc(
      V_nom=400,
      v0=1.02,
      units=Spot.Base.Types.pu)
           annotation (extent=[-60,20; -40,40]);
    Spot.ACabc.Nodes.GroundOne grdV_abc
                                annotation (extent=[-70,20; -90,40]);
    Spot.ACdqo.Sources.Voltage voltage_dqo(
      V_nom=400,
      v0=1.02,
      units=Spot.Base.Types.pu)
           annotation (extent=[-60,-40; -40,-20]);
    Spot.ACdqo.Nodes.GroundOne grdV_dqo
                                annotation (extent=[-70,-40; -90,-20]);
    Spot.ACabc.Sensors.PVImeter meter_abc(
      V_nom=400,
      S_nom=10e3,
      units=Spot.Base.Types.pu,
      abc=true)
    annotation (
          extent=[-20,20; 0,40]);
    Spot.ACdqo.Sensors.PVImeter meter_dqo(
      V_nom=400,
      S_nom=10e3,
      abc=true,
      units=Spot.Base.Types.pu)
    annotation (
          extent=[-20,-40; 0,-20]);
    Spot.ACabc.Impedances.Inductor load_abc(
      V_nom=400,
      S_nom=10e3,
      r=0.1,
      units=Spot.Base.Types.pu)
      annotation (extent=[20,20; 40,40]);
    Spot.ACdqo.Impedances.Inductor load_dqo(
      V_nom=400,
      S_nom=10e3,
      r=0.1,
      units=Spot.Base.Types.pu)
     annotation (extent=[20,-40; 40,-20]);
    Spot.ACabc.Nodes.Ground grd_abc        annotation (extent=[50,20; 70,40]);
    Spot.ACdqo.Nodes.Ground grd_dqo        annotation (extent=[50,-40; 70,-20]);

  equation
    connect(voltage_abc.term, meter_abc.term_p) annotation (points=[-40,30; -20,30],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(meter_abc.term_n, load_abc.term_p) annotation (points=[0,30; 20,30],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(load_abc.term_n, grd_abc.term) annotation (points=[40,30; 50,30],
        style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(voltage_dqo.term, meter_dqo.term_p) annotation (points=[-40,-30;
          -20,-30], style(
        color=62,
        rgbcolor={0,120,120},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(meter_dqo.term_n, load_dqo.term_p) annotation (points=[0,-30; 20,
          -30], style(
        color=62,
        rgbcolor={0,120,120},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(load_dqo.term_n, grd_dqo.term) annotation (points=[40,-30; 50,-30],
        style(
        color=62,
        rgbcolor={0,120,120},
        fillColor=70,
        rgbfillColor={0,130,175},
        fillPattern=1));
    connect(grdV_abc.term, voltage_abc.neutral)
      annotation (points=[-70,30; -60,30], style(color=3, rgbcolor={0,0,255}));
    connect(grdV_dqo.term, voltage_dqo.neutral) annotation (points=[-70,-30;
          -60,-30], style(color=3, rgbcolor={0,0,255}));
  end InitialSteadyState;

  model SimulationTransient "Transient simulation"

  annotation (
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
<p>With 'system.sim = transient' fast dynamics after switching are resolved.</p>
<p>The example uses the dqo-representation, but is valid for abc too.</p>
<p>
<i>See for example:</i>
<pre>
  meter.p[1]  active power in pu, changing from 0.5 (1000 MW) to 0.25 (500 MW)
  meter.p[2]  reactive power in pu, from 0.25 (500 MW) to 0.125 (250 MW)
</pre>
and other meter-signals.</p>
<p><a href=\"Spot.UsersGuide.Introduction.Examples\">up users guide</a></p>
</html>
"), Diagram,
    experiment(NumberOfIntervals=1000),
    experimentSetupOutput);
    inner Spot.System system
                      annotation (extent=[-100,80; -80,100]);
    Spot.Blocks.Signals.TransientPhasor transPh(
      a_ini=1.14,
      ph_ini=18.4*d2r,
      a_fin=1.0865,
      ph_fin=9.55*d2r,
      t_duration=0.8)
    annotation (extent=[-100,40; -80,60]);
    Spot.ACdqo.Sources.Voltage voltageL(V_nom=400e3, scType=Spot.Base.Types.sig)
           annotation (extent=[-70,20; -50,40]);
    Spot.ACdqo.Nodes.GroundOne grdL
                                annotation (extent=[-80,20; -100,40]);
    Spot.ACdqo.Sensors.PVImeter meter(V_nom=400e3, S_nom=2000e6,
      units=Spot.Base.Types.SI)
    annotation (
          extent=[-40,20; -20,40]);
    Spot.ACdqo.Lines.RXline lineR(par(
        V_nom=400e3,
        r=0.02e-3,
        x=0.25e-3))
     annotation (extent=[30,20; 50,40]);
    Spot.ACdqo.Lines.RXline lineL(par(
        V_nom=400e3,
        r=0.02e-3,
        x=0.25e-3))
     annotation (extent=[-10,20; 10,40]);
    Spot.ACdqo.Sources.Voltage voltageR(V_nom=400e3)
    annotation (
          extent=[80,20; 60,40]);
    Spot.ACdqo.Nodes.GroundOne grdR
                                annotation (extent=[90,20; 110,40]);
    Spot.ACdqo.Breakers.ForcedSwitch switch(V_nom=400e3, I_nom=5e3)
    annotation (extent=[30,-20; 10,0], rotation=-90);
    Spot.Control.Relays.SwitchRelay relayNet(n=1,
      ini_state=true,
      t_switch={0.4,0.6})
      annotation (extent=[-30,-20; -10,0]);
    Spot.ACdqo.Lines.RXline lineB(par(
        V_nom=400e3,
        r=0.02e-3,
        x=0.25e-3), stIni_en=false)
     annotation (extent=[30,-50; 10,-30], rotation=-90);
    Spot.ACdqo.Sources.Voltage voltageB(V_nom=400e3)
    annotation (
          extent=[10,-81; 30,-61], rotation=90);
    Spot.ACdqo.Nodes.GroundOne grdB
                                annotation (extent=[30,-110; 10,-90], rotation=
          -90);

  equation
    connect(relayNet.y, switch.control) annotation (points=[-10,-10; 10,-10],
                                                                            style(
          color=5, rgbcolor={255,0,255}));
    connect(voltageL.term, meter.term_p) annotation (points=[-50,30; -40,30],
        style(color=62, rgbcolor={0,110,110}));
    connect(meter.term_n, lineL.term_p) annotation (points=[-20,30; -10,30],
        style(color=62, rgbcolor={0,110,110}));
    connect(lineL.term_n, switch.term_p) annotation (points=[10,30; 20,30; 20,0],
        style(color=62, rgbcolor={0,110,110}));
    connect(switch.term_p, lineR.term_p) annotation (points=[20,0; 20,30; 30,30],
        style(color=62, rgbcolor={0,110,110}));
    connect(lineR.term_n, voltageR.term) annotation (points=[50,30; 60,30],
        style(color=62, rgbcolor={0,110,110}));
    connect(switch.term_n, lineB.term_p) annotation (points=[20,-20; 20,-30],
        style(color=62, rgbcolor={0,110,110}));
    connect(lineB.term_n, voltageB.term) annotation (points=[20,-50; 20,-61],
        style(color=62, rgbcolor={0,110,110}));
    connect(transPh.y, voltageL.vPhasor)
                                        annotation (points=[-80,50; -54,50; -54,
          40],
        style(color=74, rgbcolor={0,0,127}));
    connect(grdL.term, voltageL.neutral)
      annotation (points=[-80,30; -70,30], style(color=3, rgbcolor={0,0,255}));
    connect(voltageR.neutral, grdR.term)
      annotation (points=[80,30; 90,30], style(color=3, rgbcolor={0,0,255}));
    connect(grdB.term, voltageB.neutral)
      annotation (points=[20,-90; 20,-81], style(color=3, rgbcolor={0,0,255}));
  end SimulationTransient;

  model SimulationSteadyState "Steady-state simulation"

  annotation (
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
<p>With 'system.sim = steady' transients are suppressed and only slow dynamics, imposed by the source-voltage is resolved.<br>
This approximation corresponds to an infinitely fast response of the system.</p>
<p>The example uses the dqo-representation, but is valid for abc too.</p>
<p>
<i>See for example:</i>
<pre>
  meter.p[1]  active power in pu, changing from 0.5 (1000 MW) to 0.25 (500 MW)
  meter.p[2]  reactive power in pu, from 0.25 (500 MW) to 0.125 (250 MW)
</pre>
and other meter-signals.</p>
<p><a href=\"Spot.UsersGuide.Introduction.Examples\">up users guide</a></p>
</html>
"), Diagram,
    experiment(NumberOfIntervals=1000),
    experimentSetupOutput);
    inner Spot.System system(sim="st")
                      annotation (extent=[-100,80; -80,100]);
    Spot.Blocks.Signals.TransientPhasor transPh(
      a_ini=1.14,
      ph_ini=18.4*d2r,
      a_fin=1.0865,
      t_duration=0.8,
      ph_fin=9.55*d2r)
    annotation (extent=[-100,40; -80,60]);
    Spot.ACdqo.Sources.Voltage voltageL(V_nom=400e3, scType=Spot.Base.Types.sig)
           annotation (extent=[-70,20; -50,40]);
    Spot.ACdqo.Nodes.GroundOne grdL
                                annotation (extent=[-80,20; -100,40]);
    Spot.ACdqo.Sensors.PVImeter meter(V_nom=400e3, S_nom=2000e6)
    annotation (
          extent=[-40,20; -20,40]);
    Spot.ACdqo.Lines.RXline lineR(par(
        V_nom=400e3,
        r=0.02e-3,
        x=0.25e-3))
     annotation (extent=[30,20; 50,40]);
    Spot.ACdqo.Lines.RXline lineL(par(
        V_nom=400e3,
        r=0.02e-3,
        x=0.25e-3))
     annotation (extent=[-10,20; 10,40]);
    Spot.ACdqo.Sources.Voltage voltageR(V_nom=400e3)
    annotation (
          extent=[80,20; 60,40]);
    Spot.ACdqo.Nodes.GroundOne grdR
                                annotation (extent=[90,20; 110,40]);
    Spot.ACdqo.Breakers.ForcedSwitch switch(V_nom=400e3, I_nom=5e3)
    annotation (extent=[30,-20; 10,0], rotation=-90);
    Spot.Control.Relays.SwitchRelay relayNet(n=1,
      ini_state=true,
      t_switch={0.4,0.6})
      annotation (extent=[-30,-20; -10,0]);
    Spot.ACdqo.Lines.RXline lineB(par(
        V_nom=400e3,
        r=0.02e-3,
        x=0.25e-3), stIni_en=false)
     annotation (extent=[30,-50; 10,-30], rotation=-90);
    Spot.ACdqo.Sources.Voltage voltageB(V_nom=400e3)
    annotation (
          extent=[10,-81; 30,-61], rotation=90);
    Spot.ACdqo.Nodes.GroundOne grdB
                                annotation (extent=[30,-110; 10,-90], rotation=
          -90);

  equation
    connect(transPh.y, voltageL.vPhasor)
                                       annotation (points=[-80,50; -54,50; -54,
          40],
        style(color=74, rgbcolor={0,0,127}));
    connect(relayNet.y, switch.control) annotation (points=[-10,-10; 10,-10],
                                                                            style(
          color=5, rgbcolor={255,0,255}));
    connect(voltageL.term, meter.term_p) annotation (points=[-50,30; -40,30],
        style(color=62, rgbcolor={0,110,110}));
    connect(meter.term_n, lineL.term_p) annotation (points=[-20,30; -10,30],
        style(color=62, rgbcolor={0,110,110}));
    connect(lineL.term_n, switch.term_p) annotation (points=[10,30; 20,30; 20,0],
        style(color=62, rgbcolor={0,110,110}));
    connect(switch.term_p, lineR.term_p) annotation (points=[20,0; 20,30; 30,30],
        style(color=62, rgbcolor={0,110,110}));
    connect(lineR.term_n, voltageR.term) annotation (points=[50,30; 60,30],
        style(color=62, rgbcolor={0,110,110}));
    connect(switch.term_n, lineB.term_p) annotation (points=[20,-20; 20,-30],
        style(color=62, rgbcolor={0,110,110}));
    connect(lineB.term_n, voltageB.term) annotation (points=[20,-50; 20,-61],
                style(color=62, rgbcolor={0,110,110}));
    connect(grdL.term, voltageL.neutral)
      annotation (points=[-80,30; -70,30], style(color=3, rgbcolor={0,0,255}));
    connect(voltageR.neutral, grdR.term)
      annotation (points=[80,30; 90,30], style(color=3, rgbcolor={0,0,255}));
    connect(voltageB.neutral, grdB.term)
      annotation (points=[20,-81; 20,-90], style(color=3, rgbcolor={0,0,255}));
  end SimulationSteadyState;

  model Display "Display of phasors and power"

  annotation (
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
<p>The example shows the use of a display element for voltage and current 'phasors' with additional power bars.</p>
<p>The phase of 'voltageL' moves in positive sense with increasing amplitude.<br>
Inductive current (blue) is behind, capacitive ahead of voltage (red).</p>
<p>
The left bar (green) displays the active power,<br>
the right bar (violet) displays the reactive power.<br>
An additional arrow indicates the direction of active power flow.</p>
<p>The example uses the dqo-representation, but is valid for abc too.</p>
<p>
Select Experiment Setup/Compiler/'MS Visual C++ with DDE'<br>
Check Experiment Setup/Realtime/'Synchronize with realtime'<br>
Select Experiment Setup/Realtime/'Load result interval' = 0.1 s<br>
Select 'Diagram' in the Simulation layer</p>
<p><a href=\"Spot.UsersGuide.Introduction.Examples\">up users guide</a></p>
</html>"),
    Diagram,
    experiment(StopTime=30, NumberOfIntervals=1500),
    experimentSetupOutput);
    inner Spot.System system(f=50)
                      annotation (extent=[-100,80; -80,100]);
    Spot.Blocks.Signals.TransientPhasor transPh(
      a_fin=1.2,
      ph_ini=-pi,
      ph_fin=pi,
      a_ini=0.7,
      t_change=15,
      t_duration=30)
    annotation (extent=[-100,10; -80,30]);
    Spot.ACdqo.Sources.Voltage voltageL(
      V_nom=400, alpha0=5.75*d2r,
      scType=Spot.Base.Types.sig)
           annotation (extent=[-70,-10; -50,10]);
    Spot.ACdqo.Nodes.GroundOne grdV1
                                annotation (extent=[-80,-10; -100,10]);
    Spot.ACdqo.Sensors.Phasor phasor_ind(V_nom=400, S_nom=10e3)
      annotation (extent=[-30,20; 10,60]);
    Spot.ACdqo.Impedances.Inductor ind(
      V_nom=400,
      S_nom=10e3,
      x_m=0.5,
      x_s=2,
      r=1)
      annotation (extent=[20,30; 40,50]);
    Spot.ACdqo.Sources.Voltage voltageR(V_nom=400)            annotation (extent=[80,
          30; 60,50]);
    Spot.ACdqo.Nodes.GroundOne grdV2
                                annotation (extent=[90,30; 110,50]);
    Spot.ACdqo.Sensors.Phasor phasor_cap(V_nom=400, S_nom=10e3)
      annotation (extent=[-30,-60; 10,-20]);
    Spot.ACdqo.Impedances.Capacitor cap(
      V_nom=400,
      S_nom=10e3,
      g=0.1,
      b=1)
      annotation (extent=[50,-50; 70,-30]);
    Spot.ACdqo.Nodes.Ground grd            annotation (extent=[80,-50; 100,-30]);
    Spot.ACdqo.Impedances.Resistor res(V_nom=400, S_nom=10e3,
      r=0.5)
           annotation (extent=[20,-50; 40,-30]);

  equation
    connect(transPh.y, voltageL.vPhasor)
                                     annotation (points=[-80,20; -54,20; -54,10],
      style(color=74, rgbcolor={0,0,127}));
    connect(voltageL.term, phasor_ind.term_p) annotation (points=[-50,0; -40,0;
          -40,40; -30,40], style(color=62, rgbcolor={0,120,120}));
    connect(phasor_ind.term_n, ind.term_p) annotation (points=[10,40; 20,40],
        style(color=62, rgbcolor={0,120,120}));
    connect(ind.term_n, voltageR.term) annotation (points=[40,40; 60,40], style(
          color=62, rgbcolor={0,120,120}));
    connect(voltageL.term, phasor_cap.term_p) annotation (points=[-50,0; -40,0;
          -40,-40; -30,-40], style(color=62, rgbcolor={0,120,120}));
    connect(phasor_cap.term_n, res.term_p) annotation (points=[10,-40; 20,-40],
        style(color=62, rgbcolor={0,120,120}));
    connect(res.term_n, cap.term_p) annotation (points=[40,-40; 50,-40], style(
          color=62, rgbcolor={0,120,120}));
    connect(cap.term_n, grd.term) annotation (points=[70,-40; 80,-40], style(
          color=62, rgbcolor={0,120,120}));
    connect(grdV1.term, voltageL.neutral)
      annotation (points=[-80,0; -70,0], style(color=3, rgbcolor={0,0,255}));
    connect(voltageR.neutral, grdV2.term)
      annotation (points=[80,40; 90,40], style(color=3, rgbcolor={0,0,255}));
  end Display;

  model Tables "Using tables"

  annotation (
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
<p>The example shows the use of a table.<br>
Interpolates table-values.</p>
<pre>
  u     argument
  y     values(argument)
</pre>
<p>
<i>plot:</i>
<pre>
  y[1] against u     linear curve
  y[2] against u     quadratic curve
</pre>
(choose  u as 'independent variable', right mouse)</p>
<p><a href=\"Spot.UsersGuide.Introduction.Examples\">up users guide</a></p>
</html>"),
    Diagram,
    experiment,
    experimentSetupOutput);
    parameter Integer icol[:]={2,3} "{2nd column, 3rd column}";
    Real u "1st column";
    Real y[size(icol, 1)] "values of chosen columns";
    Modelica.Blocks.Tables.CombiTable1Ds table(
      table=fill(0.0, 0, 0),
      columns=icol,
      tableOnFile=true,
      tableName="values",
      fileName=TableDir + "TableExample.tab")
                             annotation (extent=[-20,-20; 20,20]);

  equation
    u = 10*time "for plotting, time = {0, 1}";

    table.u = u;
    y = table.y;
  end Tables;

end a_Introduction;
