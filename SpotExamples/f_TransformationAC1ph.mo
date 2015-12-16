within SpotExamples;
package f_TransformationAC1ph "Transformation 1 phase"
  extends Spot.Base.Icons.Examples;

  model OnePhase "One phase transformer"

    inner Spot.System system(ref="inertial")
      annotation (extent=[-100.5,80; -80.5,100]);
    Spot.AC1_DC.Sources.ACvoltage voltage(pol=-1)
      annotation (extent=[-90,-10; -70,10]);
    Spot.AC1_DC.Sensors.PVImeter meter1
      annotation (extent=[-60,-10; -40,10]);
    Spot.AC1_DC.Nodes.BusBar bus   annotation (extent=[-30,-10; -10,10]);
    Spot.AC1_DC.Transformers.TrafoStray trafo(par(V_nom={1,10}))
      annotation (extent=[0,-10; 20,10]);
    Spot.AC1_DC.Sensors.PVImeter meter2(V_nom=10)
      annotation (extent=[40,-10; 60,10]);
    Spot.AC1_DC.ImpedancesOneTerm.Resistor res(V_nom=10, r=1000)
      annotation (extent=[80,-10; 100,10]);
    Spot.AC1_DC.Nodes.PolarityGround polGrd(pol=0)
      annotation (extent=[80,-40; 100,-20]);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-90,-10; -110,10]);

  equation
    connect(voltage.term, meter1.term_p)
      annotation (points=[-70,0; -60,0], style(color=3, rgbcolor={0,0,255}));
    connect(meter1.term_n, bus.term)
      annotation (points=[-40,0; -20,0], style(color=3, rgbcolor={0,0,255}));
    connect(bus.term, trafo.term_p)
      annotation (points=[-20,0; 0,0],  style(color=3, rgbcolor={0,0,255}));
    connect(trafo.term_n, meter2.term_p)
      annotation (points=[20,0; 40,0], style(color=3, rgbcolor={0,0,255}));
    connect(meter2.term_n, res.term)
      annotation (points=[60,0; 80,0], style(color=3, rgbcolor={0,0,255}));
    connect(res.term, polGrd.term)
      annotation (points=[80,0; 80,-30], style(color=3, rgbcolor={0,0,255}));
    connect(grd.term, voltage.neutral)
      annotation (points=[-90,0; -90,0], style(color=3, rgbcolor={0,0,255}));
    annotation (
      Documentation(
              info="<html>
<p>The one-phase transformer has fluctuating potential primary and secondary side.<br>
Both sides have to choose a grounding scheme. In this example grounding is performed<br>
- for primary side: integrated in the voltage source<br>
- for secondary side: explicitly using the component 'PolarityGround'.</p>
<p>
<i>Compare:</i>
<pre>
  meter1.v     voltage phase secondary Y-Y topology
  meter2.v     voltage phase secondary Y_Delta topology
</pre></p>
<p><a href=\"modelica://Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),
      experiment(NumberOfIntervals=1234));
  end OnePhase;

  model TapChanger "One phase tap changing primary and secondary"

    inner Spot.System system(ref="inertial")
      annotation (extent=[-100.5,80; -80.5,100]);
    Spot.Control.Relays.TapChangerRelay TapRelay2(
      preset_1={0,0},
      preset_2={0,1,2,3},
      t_switch_2={1,2,3})
      annotation(extent=[0,-60; 20,-80],
                                       rotation=-90);
    Spot.Control.Relays.TapChangerRelay TapRelay1(
      preset_1={0,1,2,3},
      preset_2={0,0},
      t_switch_1={1,2,3})
      annotation(extent=[0,60; 20,80], rotation=-90);
    Spot.AC1_DC.Sources.ACvoltage voltage(pol=-1)
      annotation (extent=[-90,-10; -70,10]);
    Spot.AC1_DC.Sensors.PVImeter meter1
      annotation (extent=[-60,-10; -40,10]);
    Spot.AC1_DC.Nodes.BusBar bus   annotation (extent=[-30,-10; -10,10]);
    Spot.AC1_DC.Transformers.TrafoStray trafo1(par(
      v_tc1={0.9,1.0,1.1},
      v_tc2={0.9,1.0,1.1},
      V_nom={1,10}))
                    annotation (extent=[0,20; 20,40]);
    Spot.AC1_DC.Sensors.PVImeter meter12(V_nom=10)
      annotation (extent=[40,20; 60,40]);
    Spot.AC1_DC.ImpedancesOneTerm.Resistor res12(V_nom=10, r=1000)
      annotation (extent=[80,20; 100,40]);
    Spot.AC1_DC.Transformers.TrafoStray trafo2(par(
      v_tc1={0.9,1.0,1.1},
      v_tc2={0.9,1.0,1.1},
      V_nom={1,10}))
                    annotation (extent=[0,-20; 20,-40]);
    Spot.AC1_DC.Sensors.PVImeter meter22(V_nom=10)
      annotation (extent=[40,-40; 60,-20]);
    Spot.AC1_DC.ImpedancesOneTerm.Resistor res22(V_nom=10, r=1000)
      annotation (extent=[80,-40; 100,-20]);
    Spot.AC1_DC.Nodes.PolarityGround polGrd1(pol=0)
      annotation (extent=[80,0; 100,20]);
    Spot.AC1_DC.Nodes.PolarityGround polGrd2(pol=0)
      annotation (extent=[80,-60; 100,-40]);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-90,-10; -110,10]);

  equation
    connect(voltage.term, meter1.term_p)
      annotation (points=[-70,0; -60,0], style(color=3, rgbcolor={0,0,255}));
    connect(meter1.term_n, bus.term)
      annotation (points=[-40,0; -20,0], style(color=3, rgbcolor={0,0,255}));
    connect(bus.term, trafo1.term_p) annotation (points=[-20,0; -10,0; -10,30;
          0,30], style(color=3, rgbcolor={0,0,255}));
    connect(trafo1.term_n, meter12.term_p)
      annotation (points=[20,30; 40,30], style(color=3, rgbcolor={0,0,255}));
    connect(meter12.term_n, res12.term)
      annotation (points=[60,30; 80,30], style(color=3, rgbcolor={0,0,255}));
    connect(bus.term, trafo2.term_p) annotation (points=[-20,0; -10,0; -10,-30;
          0,-30], style(color=3, rgbcolor={0,0,255}));
    connect(trafo2.term_n, meter22.term_p)
      annotation (points=[20,-30; 40,-30], style(color=3, rgbcolor={0,0,255}));
    connect(meter22.term_n, res22.term)
      annotation (points=[60,-30; 80,-30], style(color=3, rgbcolor={0,0,255}));
    connect(res12.term, polGrd1.term)
      annotation (points=[80,30; 80,10], style(color=3, rgbcolor={0,0,255}));
    connect(res22.term, polGrd2.term)
      annotation (points=[80,-30; 80,-50], style(color=3, rgbcolor={0,0,255}));
    connect(grd.term, voltage.neutral)
      annotation (points=[-90,0; -90,0], style(color=3, rgbcolor={0,0,255}));
    connect(TapRelay1.tap_p, trafo1.tap_p)
      annotation (points=[6,60; 6,40], style(color=45, rgbcolor={255,127,0}));
    connect(TapRelay1.tap_n, trafo1.tap_n) annotation (points=[14,60; 14,40], style(
          color=45, rgbcolor={255,127,0}));
    connect(TapRelay2.tap_p, trafo2.tap_p) annotation (points=[6,-60; 6,-40],
        style(color=45, rgbcolor={255,127,0}));
    connect(TapRelay2.tap_n, trafo2.tap_n) annotation (points=[14,-60; 14,-40],
        style(color=45, rgbcolor={255,127,0}));
    annotation (
      Documentation(
              info="<html>
<p>The transformers change either primary or secondary voltage level at times (1,2,3).
<pre>
  trafo1   primary voltage levels (1, 0.9, 1, 1.1)*V_nom_prim
  trafo2 secondary voltage levels (1, 0.9, 1, 1.1)*V_nom_prim
</pre>
Note that the primary voltage source is fixed.</p>
<p>
<i>See for example:</i>
<pre>
  meter 12.v     voltage secondary, if primary is changed at fixed source.
  meter 22.v     voltage secondary, if secondary is changed at fixed source.
</pre></p>
<p><a href=\"modelica://Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),
      experiment(StopTime=4, NumberOfIntervals=4567));
  end TapChanger;
  annotation (preferredView="info",
Documentation(info="<html>
<p>Transformers one-phase and tap changer control.</p>
<p><a href=\"modelica://Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"));
end f_TransformationAC1ph;
