within SpotExamples;
package f_TransformationACdqo "Transformation dqo"
  extends Spot.Base.Icons.Examples;

  model PhaseShifts "Phase shift primary-secondary"

    inner Spot.System system
      annotation (extent=[-100.5,80; -80.5,100]);

    Spot.ACdqo.Sources.Voltage voltage
      annotation (
            extent=[-90,-10; -70,10]);
    Spot.ACdqo.Sensors.PVImeter meter1(phasor=true)
      annotation (
            extent=[-60,-10; -40,10]);
    Spot.ACdqo.Nodes.BusBar bus      annotation (extent=[-30,-10; -10,10]);
    Spot.ACdqo.Transformers.TrafoStray trafo1(par(
      V_nom={1,10}),
      redeclare Spot.ACdqo.Ports.Topology.Y top_p "Y",
      redeclare Spot.ACdqo.Ports.Topology.Y top_n "Y")
      annotation (
            extent=[0,20; 20,40]);
    Spot.ACdqo.Sensors.PVImeter meter12( V_nom=10, phasor=true)
      annotation (
            extent=[40,20; 60,40]);
    Spot.ACdqo.ImpedancesYD.Resistor res12(V_nom=10, r=1000)
                                           annotation (extent=[80,20; 100,40]);
    Spot.ACdqo.Transformers.TrafoStray trafo2(
      redeclare Spot.ACdqo.Ports.Topology.Y top_p "Y",
      redeclare Spot.ACdqo.Ports.Topology.Delta top_n "Delta",
      par(V_nom={1,10}))                   annotation (extent=[0,-40; 20,-20]);
    Spot.ACdqo.Sensors.PVImeter meter22(phasor=true, V_nom=10)
      annotation (
            extent=[40,-40; 60,-20]);
    Spot.ACdqo.ImpedancesYD.Resistor res22(V_nom=10, r=1000)
                                           annotation (extent=[80,-40; 100,-20]);
    Spot.ACdqo.Nodes.GroundOne grd annotation (extent=[-90,-10; -110,10]);

  equation
    connect(voltage.term,meter1. term_p) annotation (points=[-70,0; -60,0],
        style(color=62, rgbcolor={0,110,110}));
    connect(meter1.term_n,bus. term)
                                    annotation (points=[-40,0; -20,0], style(
          color=62, rgbcolor={0,110,110}));
    connect(bus.term, trafo1.term_p) annotation (points=[-20,0; -10,0; -10,30;
          0,30], style(color=62, rgbcolor={0,110,110}));
    connect(trafo1.term_n, meter12.term_p) annotation (points=[20,30; 40,30],
        style(color=62, rgbcolor={0,110,110}));
    connect(meter12.term_n, res12.term) annotation (points=[60,30; 80,30],
        style(color=62, rgbcolor={0,110,110}));
    connect(bus.term, trafo2.term_p) annotation (points=[-20,0; -10,0; -10,-30;
          0,-30], style(color=62, rgbcolor={0,110,110}));
    connect(trafo2.term_n, meter22.term_p) annotation (points=[20,-30; 40,-30],
        style(color=62, rgbcolor={0,110,110}));
    connect(meter22.term_n, res22.term) annotation (points=[60,-30; 80,-30],
        style(color=62, rgbcolor={0,110,110}));
    connect(grd.term, voltage.neutral)
      annotation (points=[-90,0; -90,0], style(color=3, rgbcolor={0,0,255}));
    annotation (
      Documentation(
              info="<html>
<p>Primary and secondary signals show a topology dependent phase shift.</p>
<p>
Y-Y and Delta-Delta configuration:<br>
&nbsp; &nbsp;  no phase shift.</p>
<p>
Y-Delta configuration:<br>
&nbsp; &nbsp; shift secondary vs primary voltage is -30deg.</p>
<p>
Delta_Y configuration:<br>
&nbsp; &nbsp; shift secondary vs primary voltage is +30deg.</p>
<p>
<i>Compare:</i>
<pre>
  meter12.alpha_v     voltage phase secondary Y-Y topology
  meter22.alpha_v     voltage phase secondary Y_Delta topology
</pre></p>
<p><a href=\"modelica://Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"));
  end PhaseShifts;

  model TapChanger "Tap changing primary and secondary"

    inner Spot.System system
      annotation (extent=[-100.5,80; -80.5,100]);
    Spot.ACdqo.Sources.Voltage voltage
      annotation (
            extent=[-90,-10; -70,10]);
    Spot.ACdqo.Sensors.PVImeter meter1(phasor=true)
      annotation (
            extent=[-60,-10; -40,10]);
    Spot.ACdqo.Nodes.BusBar bus      annotation (extent=[-30,-10; -10,10]);
    Spot.ACdqo.Transformers.TrafoStray trafo1(par(
      V_nom={1,10},
      v_tc1={0.9,1.0,1.1},
      v_tc2={0.9,1.0,1.1}))
                           annotation (extent=[0,20; 20,40]);
    Spot.ACdqo.Sensors.PVImeter meter12(V_nom=10, phasor=true)
      annotation (
            extent=[40,20; 60,40]);
    Spot.ACdqo.ImpedancesYD.Resistor res12(V_nom=10, r=1000)
                                           annotation (extent=[80,20; 100,40]);
    Spot.ACdqo.Transformers.TrafoStray trafo2(par(
      V_nom={1,10},
      v_tc1={0.9,1.0,1.1},
      v_tc2={0.9,1.0,1.1}))
                           annotation (extent=[0,-20; 20,-40]);
    Spot.ACdqo.Sensors.PVImeter meter22(phasor=true, V_nom=10)
      annotation (
            extent=[40,-40; 60,-20]);
    Spot.ACdqo.ImpedancesYD.Resistor res22(V_nom=10, r=1000)
                                           annotation (extent=[80,-40; 100,-20]);
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
    Spot.ACdqo.Nodes.GroundOne grd annotation (extent=[-90,-10; -110,10]);

  equation
    connect(voltage.term, meter1.term_p) annotation (points=[-70,0; -60,0],
        style(color=62, rgbcolor={0,110,110}));
    connect(meter1.term_n, bus.term)
                                    annotation (points=[-40,0; -20,0], style(
          color=62, rgbcolor={0,110,110}));
    connect(bus.term, trafo1.term_p)
                                    annotation (points=[-20,0; -10,0; -10,30; 0,
          30], style(color=62, rgbcolor={0,110,110}));
    connect(trafo1.term_n, meter12.term_p) annotation (points=[20,30; 40,30],
        style(color=62, rgbcolor={0,110,110}));
    connect(meter12.term_n, res12.term) annotation (points=[60,30; 80,30],
        style(color=62, rgbcolor={0,110,110}));
    connect(bus.term, trafo2.term_p)
                                    annotation (points=[-20,0; -10,0; -10,-30;
          0,-30], style(color=62, rgbcolor={0,110,110}));
    connect(trafo2.term_n, meter22.term_p) annotation (points=[20,-30; 40,-30],
        style(color=62, rgbcolor={0,110,110}));
    connect(meter22.term_n, res22.term) annotation (points=[60,-30; 80,-30],
        style(color=62, rgbcolor={0,110,110}));
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
<pre>  meter 12.v_norm     voltage norm secondary</pre>
if primary side is changed at fixed source.
<pre>  meter 22.v_norm     voltage norm secondary</pre>
</pre>
if secondary side is changed at fixed source.</p>
<p><a href=\"modelica://Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),
      experiment(StopTime=4));
  end TapChanger;

  model TreeWinding "Tree winding transformer"

    inner Spot.System system
      annotation (extent=[-100.5,80; -80.5,100]);

    Spot.ACdqo.Sources.Voltage voltage
      annotation (
            extent=[-90,-10; -70,10]);
    Spot.ACdqo.Sensors.PVImeter meter1(phasor=true)
      annotation (
            extent=[-60,-10; -40,10]);
    Spot.ACdqo.Nodes.BusBar bus      annotation (extent=[-30,-10; -10,10]);
    Spot.ACdqo.Transformers.Trafo3Stray trafo3Stray
      annotation (extent=[0,-10; 20,10]);
    Spot.ACdqo.Sensors.PVImeter meter12( V_nom=10, phasor=true)
      annotation (
            extent=[40,20; 60,40]);
    Spot.ACdqo.ImpedancesYD.Resistor res12(V_nom=10, r=1000)
                                           annotation (extent=[80,20; 100,40]);
    Spot.ACdqo.Sensors.PVImeter meter22(phasor=true, V_nom=10)
      annotation (
            extent=[40,-40; 60,-20]);
    Spot.ACdqo.ImpedancesYD.Resistor res22(V_nom=10, r=1000)
                                           annotation (extent=[80,-40; 100,-20]);
    Spot.ACdqo.Nodes.GroundOne grd annotation (extent=[-90,-10; -110,10]);

  equation
    connect(voltage.term,meter1. term_p) annotation (points=[-70,0; -60,0],
        style(color=62, rgbcolor={0,110,110}));
    connect(meter1.term_n,bus. term)
                                    annotation (points=[-40,0; -20,0], style(
          color=62, rgbcolor={0,110,110}));
    connect(meter12.term_n, res12.term) annotation (points=[60,30; 80,30],
        style(color=62, rgbcolor={0,110,110}));
    connect(meter22.term_n, res22.term) annotation (points=[60,-30; 80,-30],
        style(color=62, rgbcolor={0,110,110}));
    connect(bus.term, trafo3Stray.term_p)
      annotation (points=[-20,0; 0,0], style(color=62, rgbcolor={0,120,120}));
    connect(trafo3Stray.term_na, meter12.term_p) annotation (points=[20,4; 32,4;
          32,30; 40,30], style(color=62, rgbcolor={0,120,120}));
    connect(trafo3Stray.term_nb, meter22.term_p) annotation (points=[20,-4; 30,
          -4; 30,-30; 40,-30], style(color=62, rgbcolor={0,120,120}));
    connect(grd.term, voltage.neutral)
      annotation (points=[-90,0; -90,0], style(color=3, rgbcolor={0,0,255}));
    annotation (
      Documentation(
              info="<html>
<p>Primary and secondary signals show a topology dependent phase shift.</p>
<p>
Y-Y and Delta-Delta configuration:<br>
&nbsp; &nbsp;  no phase shift.</p>
<p>
Y-Delta configuration:<br>
&nbsp; &nbsp; shift secondary vs primary voltage is -30deg.</p>
<p>
Delta_Y configuration:<br>
&nbsp; &nbsp; shift secondary vs primary voltage is +30deg.</p>
<p>
<i>Compare:</i>
<pre>
  meter12.alpha_v     voltage phase secondary Y-Y topology
  meter22.alpha_v     voltage phase secondary Y_Delta topology
</pre></p>
<p><a href=\"modelica://Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"));
  end TreeWinding;
  annotation (preferredView="info",
Documentation(info="<html>
<p>Transformers three-phase and tap changer control.</p>
<p><a href=\"modelica://Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"));
end f_TransformationACdqo;
