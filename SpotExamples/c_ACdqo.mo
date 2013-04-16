within SpotExamples;
package c_ACdqo "AC 3-phase components dqo"
  extends Spot.Base.Icons.Examples;
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
<p>This package contains small models for testing single components from ACdqo.
The replaceable component can be replaced by a user defined component of similar type.</p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"),
    Icon);

  model Breaker "Breaker"

    annotation (Icon, Diagram,
      experiment(StopTime=0.2, NumberOfIntervals=2345),
      experimentSetupOutput);
    inner Spot.System system
      annotation (extent=[-80,60; -60,80]);
    Spot.ACdqo.Nodes.Ground grd2     annotation (extent=[90,-10; 110,10]);
    Spot.Blocks.Signals.TransientPhasor transPh
    annotation (extent=[-100,10; -80,30]);
    Spot.ACdqo.Sources.Voltage voltage(V_nom=10e3, scType=Spot.Base.Types.sig)
           annotation (extent=[-70,-10; -50,10]);
    Spot.ACdqo.Impedances.Inductor ind(
      r=0.1,
      V_nom=10e3,
      S_nom=1e6)
         annotation (extent=[-40,-10; -20,10]);
    Spot.ACdqo.Sensors.PVImeter meter(V_nom=10e3, S_nom=1e6)
                                        annotation (extent=[-10,-10; 10,10]);
    replaceable Spot.ACdqo.Breakers.Breaker breaker(V_nom=10e3, I_nom=100)
      annotation (
            extent=[40,-10; 60,10]);
    Spot.Control.Relays.SwitchRelay relay(t_switch={0.1})
        annotation (extent=[40,60; 60,80], rotation=-90);
    Spot.ACdqo.Nodes.GroundOne grd1 annotation (extent=[-70,-10; -90,10]);

  equation
    connect(transPh.y, voltage.vPhasor)
      annotation (points=[-80,20; -54,20; -54,10],
                                         style(color=74, rgbcolor={0,0,127}));
    connect(relay.y, breaker.control)
      annotation (points=[50,60; 50,10], style(color=5, rgbcolor={255,0,255}));
    connect(voltage.term, ind.term_p) annotation (points=[-50,0; -40,0],
        style(color=62, rgbcolor={0,110,110}));
    connect(ind.term_n, meter.term_p) annotation (points=[-20,0; -10,0], style(
          color=62, rgbcolor={0,110,110}));
    connect(meter.term_n, breaker.term_p)
      annotation (points=[10,0; 40,0], style(color=62, rgbcolor={0,110,110}));
    connect(breaker.term_n, grd2.term)
      annotation (points=[60,0; 90,0], style(color=62, rgbcolor={0,110,110}));
    connect(grd1.term, voltage.neutral)
      annotation (points=[-70,0; -70,0], style(color=3, rgbcolor={0,0,255}));
  end Breaker;

  model Fault "Fault"

    annotation (
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Icon,
      Diagram,
      Documentation(
              info="<html>
</html>
"),   experiment(StopTime=0.2, NumberOfIntervals=2345),
      experimentSetupOutput);
    inner Spot.System system
      annotation (extent=[-80,60; -60,80]);
    Spot.ACdqo.Sources.Voltage voltage1(
      V_nom=10e3, alpha0=10*d2r)
             annotation (extent=[-90,-40; -70,-20]);
    Spot.ACdqo.Breakers.Switch switch1(V_nom=10e3, I_nom=100)
                            annotation (extent=[-60,-40; -40,-20]);
    Spot.ACdqo.Lines.FaultRXline line(par(V_nom=10e3, S_nom=1e6))
      annotation (
            extent=[-10,-40; 10,-20]);
    Spot.ACdqo.Breakers.Switch switch2(V_nom=10e3, I_nom=100)
                            annotation (extent=[40,-40; 60,-20]);
    Spot.ACdqo.Sources.Voltage voltage2(V_nom=10e3)
             annotation (extent=[90,-40; 70,-20]);
    Spot.Control.Relays.SwitchRelay relay1(t_switch={0.15})
      annotation (
            extent=[-80,0; -60,20]);
    Spot.Control.Relays.SwitchRelay relay2(t_switch={0.153})
      annotation (
            extent=[80,0; 60,20]);
    Spot.ACdqo.Sensors.PVImeter meter(V_nom=10e3, S_nom=1e6)
      annotation (
            extent=[-10,-10; 10,10], rotation=90);
    replaceable Spot.ACdqo.Faults.Fault_ab fault_ab
                         annotation (extent=[-10,40; 10,60]);
    Spot.ACdqo.Nodes.GroundOne grd1 annotation (extent=[-90,-40; -110,-20]);
    Spot.ACdqo.Nodes.GroundOne grd2 annotation (extent=[90,-40; 110,-20]);

  equation
    connect(relay1.y, switch1.control) annotation (points=[-60,10; -50,10; -50,
          -20], style(color=5, rgbcolor={255,0,255}));
    connect(relay2.y, switch2.control) annotation (points=[60,10; 50,10; 50,-20],
        style(color=5, rgbcolor={255,0,255}));
    connect(voltage1.term, switch1.term_p) annotation (points=[-70,-30; -60,-30],
        style(color=62, rgbcolor={0,110,110}));
    connect(switch1.term_n, line.term_p) annotation (points=[-40,-30; -10,-30],
        style(color=62, rgbcolor={0,110,110}));
    connect(line.term_n, switch2.term_p) annotation (points=[10,-30; 40,-30],
        style(color=62, rgbcolor={0,110,110}));
    connect(switch2.term_n, voltage2.term) annotation (points=[60,-30; 70,-30],
        style(color=62, rgbcolor={0,110,110}));
    connect(line.term_f, meter.term_p) annotation (points=[0,-20; 0,-10;
          -6.12303e-016,-10], style(color=62, rgbcolor={0,110,110}));
    connect(meter.term_n, fault_ab.term)  annotation (points=[6.12303e-016,10;
          0,10; 0,40], style(color=62, rgbcolor={0,110,110}));
    connect(grd1.term, voltage1.neutral) annotation (points=[-90,-30; -90,-30],
        style(color=3, rgbcolor={0,0,255}));
    connect(voltage2.neutral, grd2.term)
      annotation (points=[90,-30; 90,-30], style(color=3, rgbcolor={0,0,255}));
  end Fault;

  model Impedance "Impedance"

    annotation (
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Diagram,
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
</html>
"),   Icon,
      experiment(StopTime=0.2),
      experimentSetupOutput);
    inner Spot.System system
      annotation (extent=[-80,60; -60,80]);
    Spot.Blocks.Signals.TransientPhasor transPh
    annotation (extent=[-100,10; -80,30]);
    Spot.ACdqo.Sources.Voltage voltage(scType=Spot.Base.Types.sig)
           annotation (extent=[-70,-10; -50,10]);
    Spot.ACdqo.Sensors.PVImeter meter      annotation (extent=[-40,-10; -20,10]);
    replaceable Spot.ACdqo.Impedances.Inductor ind(r=0.1)
                                            annotation (extent=[20,-10; 40,10]);
    Spot.ACdqo.Nodes.Ground grd2     annotation (extent=[80,-10; 100,10]);
    Spot.ACdqo.Nodes.GroundOne grd1 annotation (extent=[-70,-10; -90,10]);

  equation
    connect(transPh.y, voltage.vPhasor)
      annotation (points=[-80,20; -54,20; -54,10],
                                         style(color=74, rgbcolor={0,0,127}));
    connect(voltage.term, meter.term_p) annotation (points=[-50,0; -40,0], style(
          color=62, rgbcolor={0,110,110}));
    connect(meter.term_n, ind.term_p)
      annotation (points=[-20,0; 20,0], style(color=62, rgbcolor={0,110,110}));
    connect(ind.term_n, grd2.term)
      annotation (points=[40,0; 80,0], style(color=62, rgbcolor={0,110,110}));
    connect(grd1.term, voltage.neutral)
      annotation (points=[-70,0; -70,0], style(color=3, rgbcolor={0,0,255}));
  end Impedance;

  model ImpedanceYD "Impedance Y-Delta"

    annotation (
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Diagram,
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
</html>
"),   Icon,
      experiment(StopTime=0.2),
      experimentSetupOutput);
    inner Spot.System system
      annotation (extent=[-80,60; -60,80]);
    Spot.Blocks.Signals.TransientPhasor transPh
    annotation (extent=[-100,10; -80,30]);
    Spot.ACdqo.Sources.Voltage voltage(scType=Spot.Base.Types.sig)
           annotation (extent=[-70,-10; -50,10]);
    Spot.ACdqo.Sensors.PVImeter meter      annotation (extent=[-40,-10; -20,10]);
    replaceable Spot.ACdqo.ImpedancesYD.Inductor indYD(r=0.1)
                                                annotation (extent=[30,-10; 50,10]);
    Spot.ACdqo.Nodes.GroundOne grd annotation (extent=[-70,-10; -90,10]);

  equation
    connect(transPh.y, voltage.vPhasor)
      annotation (points=[-80,20; -54,20; -54,10],
                                         style(color=74, rgbcolor={0,0,127}));
    connect(voltage.term, meter.term_p) annotation (points=[-50,0; -40,0], style(
          color=62, rgbcolor={0,110,110}));
    connect(meter.term_n, indYD.term)
      annotation (points=[-20,0; 30,0], style(color=62, rgbcolor={0,110,110}));
    connect(grd.term, voltage.neutral)
      annotation (points=[-70,0; -70,0], style(color=3, rgbcolor={0,0,255}));
  end ImpedanceYD;

  model Line "Line"

    annotation (
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Diagram,
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
</html>
"),   Icon,
      experiment,
      experimentSetupOutput);
    inner Spot.System system
      annotation (extent=[-80,60; -60,80]);
    Spot.Blocks.Signals.TransientPhasor transPh(              ph_fin=5*d2r)
    annotation (extent=[-100,10; -80,30]);
    Spot.ACdqo.Sources.Voltage voltage1(
      V_nom=132e3,
      alpha0=5*d2r,
      scType=Spot.Base.Types.sig)
           annotation (extent=[-70,-10; -50,10]);
    Spot.ACdqo.Sensors.PVImeter meter(V_nom=132e3, S_nom=100e6)
                                           annotation (extent=[-40,-10; -20,10]);
    Spot.ACdqo.Sources.Voltage voltage2(V_nom=132e3)
           annotation (extent=[90,-10; 70,10]);
    replaceable Spot.ACdqo.Lines.PIline line(redeclare replaceable parameter
        Spot.ACdqo.Lines.Parameters.PIline par(V_nom=132e3))
                                   annotation (extent=[20,-10; 40,10]);
    Spot.ACdqo.Nodes.GroundOne grd1 annotation (extent=[-70,-10; -90,10]);
    Spot.ACdqo.Nodes.GroundOne grd2 annotation (extent=[90,-10; 110,10]);

  equation
    connect(transPh.y, voltage1.vPhasor)
      annotation (points=[-80,20; -54,20; -54,10],
                                         style(color=74, rgbcolor={0,0,127}));
    connect(voltage1.term, meter.term_p) annotation (points=[-50,0; -40,0], style(
          color=62, rgbcolor={0,110,110}));
    connect(meter.term_n, line.term_p)
      annotation (points=[-20,0; 20,0], style(color=62, rgbcolor={0,110,110}));
    connect(line.term_n, voltage2.term)
      annotation (points=[40,0; 70,0], style(color=62, rgbcolor={0,110,110}));
    connect(grd1.term, voltage1.neutral)
      annotation (points=[-70,0; -70,0], style(color=3, rgbcolor={0,0,255}));
    connect(voltage2.neutral, grd2.term)
      annotation (points=[90,0; 90,0], style(color=3, rgbcolor={0,0,255}));
  end Line;

  model Load "Load"

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
    Diagram,
    Documentation(
            info="<html>
</html>"),
    experiment,
    experimentSetupOutput);
    inner Spot.System system
      annotation (extent=[-80,60; -60,80]);
    Spot.Blocks.Signals.TransientPhasor transPh
    annotation (extent=[-100,10; -80,30]);
    Spot.ACdqo.Sources.Voltage voltage(scType=Spot.Base.Types.sig)
           annotation (extent=[-70,-10; -50,10]);
    Spot.ACdqo.Sensors.PVImeter meter      annotation (extent=[-40,-10; -20,10]);
    replaceable Spot.ACdqo.Loads.PQindLoad load(tcst=0.01)
                                              annotation (extent=[30,-10; 50,10]);
    Spot.Blocks.Signals.Transient[2] trsSignal(s_ini={sqrt(3)/2,1/2}, s_fin={1,0.2})
      annotation (extent=[30,50; 50,70], rotation=-90);
    Spot.ACdqo.Nodes.GroundOne grd annotation (extent=[-70,-10; -90,10]);

  equation
    connect(transPh.y, voltage.vPhasor)
      annotation (points=[-80,20; -54,20; -54,10],
                                         style(color=74, rgbcolor={0,0,127}));
    connect(trsSignal.y, load.p_set)
      annotation (points=[40,50; 40,10], style(color=74, rgbcolor={0,0,127}));
    connect(voltage.term, meter.term_p) annotation (points=[-50,0; -40,0], style(
          color=62, rgbcolor={0,110,110}));
    connect(meter.term_n, load.term)
      annotation (points=[-20,0; 30,0], style(color=62, rgbcolor={0,110,110}));
    connect(grd.term, voltage.neutral)
      annotation (points=[-70,0; -70,0], style(color=3, rgbcolor={0,0,255}));
  end Load;

  model Machines "Machines"

    annotation(Icon,                                                    Diagram);
    inner Spot.System system(ref="synchron")
      annotation (extent=[-80,60; -60,80]);
    Spot.Blocks.Signals.TransientPhasor transPh
    annotation (extent=[-100,10; -80,30]);
    Spot.ACdqo.Sources.Voltage voltage(
      v0=1,
      scType=Spot.Base.Types.sig,
  V_nom=400)                            annotation (extent=[-80,-10; -60,10]);
    Spot.ACdqo.Sensors.Psensor power
      annotation (extent=[-50,-10; -30,10]);
    replaceable Spot.ACdqo.Machines.Asynchron asynchron(par(V_nom=400, S_nom=
        1e3))                                    annotation (extent=[-10,-10; 10,
          10]);
    Spot.Mechanics.Rotation.Rotor rotor
      annotation (extent=[28,-10; 48,10]);
    Spot.Mechanics.Rotation.Torque torq       annotation (extent=[80,-10; 60,10]);
    Spot.Blocks.Signals.Transient trsSignal
                                       annotation (extent=[100,-10; 80,10]);
    Spot.ACdqo.Nodes.GroundOne grd annotation (extent=[-80,-10; -100,10]);
    Spot.Common.Thermal.BoundaryV boundary(m=2)
      annotation (extent=[-10,10; 10,30]);

  equation
    connect(transPh.y, voltage.vPhasor)
                                    annotation (points=[-80,20; -64,20; -64,10],
                                                                         style(
          color=74, rgbcolor={0,0,127}));
    connect(voltage.term, power.term_p) annotation (points=[-60,0; -50,0], style(
          color=62, rgbcolor={0,110,110}));
    connect(power.term_n, asynchron.term) annotation (points=[-30,0; -10,0],
        style(color=62, rgbcolor={0,110,110}));
    connect(asynchron.airgap, rotor.flange_p) annotation (points=[0,6; 14,6; 14,
          0; 28,0], style(color=0, rgbcolor={0,0,0}));
    connect(rotor.flange_n, torq.flange)
      annotation (points=[48,0; 60,0], style(color=0, rgbcolor={0,0,0}));
    connect(grd.term, voltage.neutral)
      annotation (points=[-80,0; -80,0], style(color=3, rgbcolor={0,0,255}));
    connect(asynchron.heat, boundary.heat)
      annotation (points=[0,10; 0,10], style(color=42, rgbcolor={176,0,0}));
    connect(trsSignal.y, torq.tau)
      annotation (points=[80,0; 80,0], style(color=74, rgbcolor={0,0,127}));
  end Machines;

  model Sensor "Sensor and meter"

    annotation(Icon,                                                    Diagram);
    inner Spot.System system
      annotation (extent=[-80,60; -60,80]);
    Spot.ACdqo.Sources.Vspectrum voltage
      annotation (extent=[-70,-10; -50,10]);
    Spot.ACdqo.ImpedancesYD.Resistor res      annotation (extent=[80,-10; 100,10]);
    Spot.Blocks.Signals.TransientPhasor transPh
    annotation (extent=[-100,10; -80,30]);
    replaceable Spot.ACdqo.Sensors.PVImeter meter(abc=true)
                                           annotation (extent=[0,-10; 20,10]);
    Spot.ACdqo.Nodes.GroundOne grd annotation (extent=[-70,-10; -90,10]);

  equation
    connect(transPh.y, voltage.vPhasor)
      annotation (points=[-80,20; -54,20; -54,10],
                                         style(color=74, rgbcolor={0,0,127}));
    connect(voltage.term, meter.term_p)
      annotation (points=[-50,0; 0,0], style(color=62, rgbcolor={0,110,110}));
    connect(meter.term_n, res.term)
      annotation (points=[20,0; 80,0], style(color=62, rgbcolor={0,110,110}));
    connect(grd.term, voltage.neutral)
      annotation (points=[-70,0; -70,0], style(color=3, rgbcolor={0,0,255}));
  end Sensor;

  model Source "Source"

    annotation(Icon, Diagram);
    inner Spot.System system
      annotation (extent=[-80,60; -60,80]);
    Spot.ACdqo.ImpedancesYD.Inductor ind(r=0.1)
                                              annotation (extent=[70,-10; 90,10]);
    Spot.ACdqo.Sensors.PVImeter meter(abc=true, phasor=true)
                                        annotation (extent=[40,-10; 60,10]);
    replaceable Spot.ACdqo.Sources.Voltage voltage
           annotation (extent=[-40,-10; -20,10]);
    Spot.ACdqo.Nodes.GroundOne grd annotation (extent=[-40,-10; -60,10]);

  equation
    connect(voltage.term, meter.term_p)
      annotation (points=[-20,0; 40,0], style(color=62, rgbcolor={0,110,110}));
    connect(meter.term_n, ind.term)
      annotation (points=[60,0; 70,0], style(color=62, rgbcolor={0,110,110}));
    connect(grd.term, voltage.neutral)
      annotation (points=[-40,0; -40,0], style(color=3, rgbcolor={0,0,255}));
  end Source;

  model Transformer "Transformer"

    annotation (
      Coordsys(
  extent=[-100,-100; 100,100],
  grid=[2, 2],
  component=[20, 20]),
      Documentation(
              info="<html>
</html>
"),   Diagram,
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Icon,
      experiment(StopTime=3),
      experimentSetupOutput);
    inner Spot.System system
      annotation (extent=[-80,60; -60,80]);
    Spot.Blocks.Signals.TransientPhasor transPh
                    annotation (extent=[-100,10; -80,30]);
    Spot.ACdqo.Sources.Voltage voltage(scType=Spot.Base.Types.sig)
      annotation (
            extent=[-80,-10; -60,10]);
    Spot.ACdqo.Sensors.PVImeter meter1
      annotation (
            extent=[-50,-10; -30,10]);
    replaceable Spot.ACdqo.Transformers.TrafoStray trafo(par(
      v_tc1={1,1.1},
      v_tc2={1,1.2},
      V_nom={1,10}),
      redeclare Spot.ACdqo.Ports.Topology.Y top_p "Y",
      redeclare Spot.ACdqo.Ports.Topology.Delta top_n "Delta")
                           annotation (extent=[0,-10; 20,10]);
    Spot.ACdqo.Sensors.PVImeter meter2(V_nom=10)
      annotation (
            extent=[50,-10; 70,10]);
    Spot.ACdqo.ImpedancesYD.Resistor res(V_nom=10, r=100)
                                           annotation (extent=[80,-10; 100,10]);
    Spot.Control.Relays.TapChangerRelay TapChanger(
      preset_1={0,1,2},
      preset_2={0,1,2},
      t_switch_1={0.9,1.9},
      t_switch_2={1.1,2.1})
      annotation(extent=[0,50; 20,70], rotation=-90);
    Spot.ACdqo.Nodes.GroundOne grd annotation (extent=[-80,-10; -100,10]);

  equation
    connect(transPh.y, voltage.vPhasor)
                                    annotation (points=[-80,20; -64,20; -64,10],
        style(color=74, rgbcolor={0,0,127}));
    connect(voltage.term, meter1.term_p) annotation (points=[-60,0; -50,0], style(
          color=62, rgbcolor={0,110,110}));
    connect(meter1.term_n, trafo.term_p)
      annotation (points=[-30,0; 0,0], style(color=62, rgbcolor={0,110,110}));
    connect(trafo.term_n, meter2.term_p)
      annotation (points=[20,0; 50,0], style(color=62, rgbcolor={0,110,110}));
    connect(meter2.term_n, res.term)
      annotation (points=[70,0; 80,0], style(color=62, rgbcolor={0,110,110}));
    connect(grd.term, voltage.neutral)
      annotation (points=[-80,0; -80,0], style(color=3, rgbcolor={0,0,255}));
    connect(TapChanger.tap_p, trafo.tap_p)
      annotation (points=[6,50; 6,10], style(color=45, rgbcolor={255,127,0}));
    connect(TapChanger.tap_n, trafo.tap_n) annotation (points=[14,50; 14,10], style(
          color=45, rgbcolor={255,127,0}));
  end Transformer;

  model Rectifier "Rectifier"

    annotation (
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Icon,
      Diagram,
      Documentation(
              info="<html>
</html>
"),   experiment(NumberOfIntervals=5000),
      experimentSetupOutput);
    inner Spot.System system(ref="inertial")
                        annotation (extent=[-80,60; -60,80]);
    Spot.Blocks.Signals.TransientPhasor transPh
         annotation (extent=[-100,10; -80,30]);
    Spot.ACdqo.Sources.Voltage vAC(V_nom=2, scType=Spot.Base.Types.sig)
          annotation (extent=[-80,-10; -60,10]);
    Spot.ACdqo.Impedances.Inductor ind(r=0.05)
      annotation (
            extent=[-50,-10; -30,10]);
    Spot.ACdqo.Sensors.PVImeter meterAC(av=true, tcst=0.1)
      annotation (
            extent=[-20,-10; 0,10]);
    replaceable Spot.ACdqo.Inverters.Rectifier rectifier
      annotation (
            extent=[30,-10; 10,10]);
    Spot.AC1_DC.Sensors.PVImeter meterDC(av=true, tcst=0.1)
      annotation (
            extent=[40,-10; 60,10]);
    Spot.AC1_DC.Sources.DCvoltage vDC(pol=0)
      annotation (
            extent=[90,-10; 70,10]);
    Spot.ACdqo.Nodes.GroundOne grd1 annotation (extent=[-80,-10; -100,10]);
    Spot.ACdqo.Nodes.GroundOne grd2 annotation (extent=[90,-10; 110,10]);
    Spot.Common.Thermal.BoundaryV boundary(m=3)
                                           annotation (extent=[10,10; 30,30]);

  equation
    connect(transPh.y, vAC.vPhasor)
      annotation (points=[-80,20; -64,20; -64,10],
                                         style(color=74, rgbcolor={0,0,127}));
    connect(vAC.term, ind.term_p) annotation (points=[-60,0; -50,0], style(color=62,
          rgbcolor={0,110,110}));
    connect(ind.term_n, meterAC.term_p) annotation (points=[-30,0; -20,0],
        style(color=62, rgbcolor={0,110,110}));
    connect(meterAC.term_n, rectifier.AC)
      annotation (points=[0,0; 10,0], style(color=62, rgbcolor={0,110,110}));
    connect(rectifier.DC, meterDC.term_p)
      annotation (points=[30,0; 40,0], style(color=3, rgbcolor={0,0,255}));
    connect(meterDC.term_n, vDC.term)
      annotation (points=[60,0; 70,0], style(color=3, rgbcolor={0,0,255}));
    connect(grd1.term, vAC.neutral)
      annotation (points=[-80,0; -80,0], style(color=3, rgbcolor={0,0,255}));
    connect(vDC.neutral, grd2.term)
      annotation (points=[90,0; 90,0], style(color=3, rgbcolor={0,0,255}));
    connect(rectifier.heat, boundary.heat)
      annotation (points=[20,10; 20,10], style(color=42, rgbcolor={176,0,0}));
  end Rectifier;

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
<pre>
Models for testing components from Spot.Electronics.
</pre>
</html>
"), Icon);

  model Inverter "Inverter, controlled rectifier"

    annotation (
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Icon,
      Diagram,
      Documentation(
              info="<html>
</html>
"),   experiment(NumberOfIntervals=5000, Algorithm="Lsodar"),
      experimentSetupOutput);
    inner Spot.System system(ref="inertial")
                        annotation (extent=[-80,60; -60,80]);
    Spot.Blocks.Signals.TransientPhasor transPh
         annotation (extent=[-100,10; -80,30]);
    Spot.ACdqo.Sources.Voltage vAC(V_nom=2, scType=Spot.Base.Types.sig)
          annotation (extent=[-80,-10; -60,10]);
    Spot.ACdqo.Impedances.Inductor ind(r=0.05)
      annotation (
            extent=[-50,-10; -30,10]);
    Spot.ACdqo.Sensors.PVImeter meterAC(av=true, tcst=0.1)
      annotation (
            extent=[-20,-10; 0,10]);
    replaceable Spot.ACdqo.Inverters.Inverter ac_dc
                                             annotation (extent=[30,-10; 10,10]);
    Spot.AC1_DC.Sensors.PVImeter meterDC(av=true, tcst=0.1)
      annotation (
            extent=[40,-10; 60,10]);
    Spot.AC1_DC.Sources.DCvoltage vDC(pol=0)
      annotation (
            extent=[90,-10; 70,10]);
    Spot.ACdqo.Inverters.Select select
                                  annotation (extent=[30,40; 10,60]);
    Spot.ACdqo.Nodes.GroundOne grd1 annotation (extent=[-80,-10; -100,10]);
    Spot.ACdqo.Nodes.GroundOne grd2 annotation (extent=[90,-10; 110,10]);
    Spot.Common.Thermal.BoundaryV boundary(m=3)
                                           annotation (extent=[10,10; 30,30]);

  equation
    connect(transPh.y, vAC.vPhasor)
      annotation (points=[-80,20; -64,20; -64,10],
                                         style(color=74, rgbcolor={0,0,127}));
    connect(vAC.term, ind.term_p) annotation (points=[-60,0; -50,0], style(color=62,
          rgbcolor={0,110,110}));
    connect(ind.term_n, meterAC.term_p) annotation (points=[-30,0; -20,0],
        style(color=62, rgbcolor={0,110,110}));
    connect(meterAC.term_n, ac_dc.AC)
      annotation (points=[0,0; 10,0], style(color=62, rgbcolor={0,110,110}));
    connect(ac_dc.DC, meterDC.term_p)
      annotation (points=[30,0; 40,0], style(color=3, rgbcolor={0,0,255}));
    connect(meterDC.term_n, vDC.term)
      annotation (points=[60,0; 70,0], style(color=3, rgbcolor={0,0,255}));
    connect(select.theta_out, ac_dc.theta)
      annotation (points=[26,40; 26,10; 26,10],
                                         style(color=74, rgbcolor={0,0,127}));
    connect(select.uPhasor_out, ac_dc.uPhasor) annotation (points=[14,40; 14,10;
          14,10], style(color=74, rgbcolor={0,0,127}));
    connect(grd1.term, vAC.neutral)
      annotation (points=[-80,0; -80,0], style(color=3, rgbcolor={0,0,255}));
    connect(vDC.neutral, grd2.term)
      annotation (points=[90,0; 90,0], style(color=3, rgbcolor={0,0,255}));
    connect(ac_dc.heat, boundary.heat)
      annotation (points=[20,10; 20,10], style(color=42, rgbcolor={176,0,0}));
  end Inverter;

end c_ACdqo;
