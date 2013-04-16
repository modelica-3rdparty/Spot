within SpotExamples;
package b_AC1_DC "AC 1-phase and DC components"
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
<p>This package contains small models for testing single components from AC1_DC.
The replaceable component can be replaced by a user defined component of similar type.</p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"),
    Icon,
    Diagram);

  model Breaker "Breaker"

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
</html>"),
      experiment(StopTime=0.2, NumberOfIntervals=2345),
      experimentSetupOutput);
    inner Spot.System system(ref="inertial")
      annotation (extent=[-80,60; -60,80]);
    Spot.Blocks.Signals.TransientPhasor transPh
    annotation (extent=[-100,10; -80,30]);
    Spot.Control.Relays.SwitchRelay relay(
      n=1,
      ini_state=true,
      t_switch={0.1})
        annotation (extent=[40,60; 60,80], rotation=-90);
    Spot.AC1_DC.Sources.ACvoltage voltage(V_nom=10e3, scType=Spot.Base.Types.sig)
      annotation (extent=[-70,-10; -50,10]);
    Spot.AC1_DC.Impedances.Inductor ind(r={0.1,0.1},
      V_nom=10e3,
      S_nom=1e6)
      annotation (extent=[-40,-10; -20,10]);
    Spot.AC1_DC.Sensors.PVImeter meter(V_nom=10e3, S_nom=1e6)
                                           annotation (extent=[-10,-10; 10,10]);
    replaceable Spot.AC1_DC.Breakers.Breaker breaker(V_nom=10e3, I_nom=100)
                                            annotation (extent=[40,-10; 60,10]);
    Spot.AC1_DC.Nodes.Ground grd      annotation (extent=[90,-10; 110,10]);
    Spot.AC1_DC.Nodes.GroundOne grd1 annotation (extent=[-70,-10; -90,10]);

  equation
    connect(transPh.y, voltage.vPhasor)
      annotation (points=[-80,20; -54,20; -54,10],
                                         style(color=74, rgbcolor={0,0,127}));
    connect(voltage.term, ind.term_p)
      annotation (points=[-50,0; -40,0], style(color=3, rgbcolor={0,0,255}));
    connect(ind.term_n, meter.term_p)
      annotation (points=[-20,0; -10,0], style(color=3, rgbcolor={0,0,255}));
    connect(meter.term_n, breaker.term_p)
      annotation (points=[10,0; 40,0], style(color=3, rgbcolor={0,0,255}));
    connect(breaker.term_n, grd.term)
      annotation (points=[60,0; 90,0], style(color=3, rgbcolor={0,0,255}));
    connect(relay.y[1], breaker.control)
      annotation (points=[50,60; 50,10], style(color=5, rgbcolor={255,0,255}));
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
    inner Spot.System system(ref="inertial")
      annotation (extent=[-80,60; -60,80]);
    Spot.Control.Relays.SwitchRelay relay1(                       n=2, t_switch=
         {3.5,29.5}/50)
      annotation (
            extent=[-80,0; -60,20]);
    Spot.Control.Relays.SwitchRelay relay2(                       n=2, t_switch=
         {3.6,29.4}/50)
      annotation (
            extent=[80,0; 60,20]);
    Spot.AC1_DC.Sources.ACvoltage voltage1(V_nom=10e3, alpha0=10*d2r)
      annotation (extent=[-90,-40; -70,-20]);
    Spot.AC1_DC.Sources.ACvoltage voltage2(V_nom=10e3)
      annotation (extent=[90,-40; 70,-20]);
    Spot.AC1_DC.Breakers.DoubleSwitch switch1(V_nom=10e3,I_nom=100)
      annotation (extent=[-60,-40; -40,-20]);
    Spot.AC1_DC.Breakers.DoubleSwitch switch2(V_nom=10e3, I_nom=100)
                                            annotation (extent=[40,-40; 60,-20]);
    Spot.AC1_DC.Lines.FaultRXline line(par(V_nom = 10e3, S_nom=1e6))
                                           annotation (extent=[-10,-40; 10,-20]);
    Spot.AC1_DC.Sensors.PVImeter meter(V_nom=10e3, S_nom=1e6)
                                            annotation (extent=[-10,-10; 10,10],
        rotation=90);
    replaceable Spot.AC1_DC.Faults.Fault_Ab fault_Ab
                                              annotation (extent=[-10,40; 10,60]);
    Spot.AC1_DC.Nodes.GroundOne grd1 annotation (extent=[-90,-40; -110,-20]);
    Spot.AC1_DC.Nodes.GroundOne grd2 annotation (extent=[90,-40; 110,-20]);

  equation
    connect(voltage1.term, switch1.term_p)
                                          annotation (points=[-70,-30; -60,-30], style(
          color=3, rgbcolor={0,0,255}));
    connect(switch1.term_n, line.term_p) annotation (points=[-40,-30; -10,-30],
        style(color=3, rgbcolor={0,0,255}));
    connect(line.term_n, switch2.term_p)
      annotation (points=[10,-30; 40,-30], style(color=3, rgbcolor={0,0,255}));
    connect(switch2.term_n, voltage2.term)
      annotation (points=[60,-30; 70,-30], style(color=3, rgbcolor={0,0,255}));
    connect(line.term_f, meter.term_p) annotation (points=[0,-20; 0,-10;
          -6.12303e-016,-10], style(color=3, rgbcolor={0,0,255}));
    connect(meter.term_n,fault_Ab. term) annotation (points=[6.12303e-016,10; 0,
          10; 0,40], style(color=3, rgbcolor={0,0,255}));
    connect(relay1.y, switch1.control) annotation (points=[-60,10; -50,10; -50,
          -20], style(color=5, rgbcolor={255,0,255}));
    connect(relay2.y, switch2.control) annotation (points=[60,10; 50,10; 50,-20],
        style(color=5, rgbcolor={255,0,255}));
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
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Icon,
      Diagram,
      Documentation(
              info="<html>
</html>"),
      experiment(StopTime=0.2, NumberOfIntervals=731),
      experimentSetupOutput);
    inner Spot.System system(ref="inertial")
      annotation (extent=[-80,60; -60,80]);
    Spot.Blocks.Signals.TransientPhasor transPh
    annotation (extent=[-100,10; -80,30]);
    Spot.AC1_DC.Sources.ACvoltage voltage(scType=Spot.Base.Types.sig)
      annotation (extent=[-70,-10; -50,10]);
    Spot.AC1_DC.Sensors.PVImeter meter      annotation (extent=[-40,-10; -20,10]);
    replaceable Spot.AC1_DC.Impedances.Inductor ind(r={0.1,0.1})
                                            annotation (extent=[20,-10; 40,10]);
    Spot.AC1_DC.Nodes.GroundOne grd1
                                annotation (extent=[-70,-10; -90,10]);
    Spot.AC1_DC.Nodes.Ground grd2     annotation (extent=[80,-10; 100,10]);

  equation
    connect(transPh.y, voltage.vPhasor)
      annotation (points=[-80,20; -54,20; -54,10],
                                         style(color=74, rgbcolor={0,0,127}));
    connect(voltage.term, meter.term_p)
      annotation (points=[-50,0; -40,0], style(color=3, rgbcolor={0,0,255}));
    connect(meter.term_n, ind.term_p)
      annotation (points=[-20,0; 20,0], style(color=3, rgbcolor={0,0,255}));
    connect(ind.term_n, grd2.term)
      annotation (points=[40,0; 80,0], style(color=3, rgbcolor={0,0,255}));
    connect(grd1.term, voltage.neutral)
      annotation (points=[-70,0; -70,0], style(color=3, rgbcolor={0,0,255}));
  end Impedance;

  model ImpedanceOneTerm "Impedance One-terminal"

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
</html>"),
      experiment(StopTime=0.2, NumberOfIntervals=731),
      experimentSetupOutput);
    inner Spot.System system(ref="inertial")
      annotation (extent=[-80,60; -60,80]);
    Spot.Blocks.Signals.TransientPhasor transPh
    annotation (extent=[-100,10; -80,30]);
    Spot.AC1_DC.Sources.ACvoltage voltage(scType=Spot.Base.Types.sig)
      annotation (extent=[-70,-10; -50,10]);
    Spot.AC1_DC.Sensors.PVImeter meter      annotation (extent=[-40,-10; -20,10]);
    replaceable Spot.AC1_DC.ImpedancesOneTerm.Inductor ind(r=0.1)
      annotation (extent=[30,-10; 50,10]);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-70,-10; -90,10]);

  equation
    connect(transPh.y, voltage.vPhasor)
      annotation (points=[-80,20; -54,20; -54,10],
                                         style(color=74, rgbcolor={0,0,127}));
    connect(voltage.term, meter.term_p)
      annotation (points=[-50,0; -40,0], style(color=3, rgbcolor={0,0,255}));
    connect(meter.term_n, ind.term)
      annotation (points=[-20,0; 30,0], style(color=3, rgbcolor={0,0,255}));
    connect(grd.term, voltage.neutral)
      annotation (points=[-70,0; -70,0], style(color=3, rgbcolor={0,0,255}));
  end ImpedanceOneTerm;

  model Line "Line"

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
</html>"),
      experiment(StopTime=0.2, NumberOfIntervals=3456),
      experimentSetupOutput);
    inner Spot.System system(ref="inertial")
      annotation (extent=[-80,60; -60,80]);
    Spot.Blocks.Signals.TransientPhasor transPh(ph_fin=5*d2r)
    annotation (extent=[-100,10; -80,30]);
    Spot.AC1_DC.Sources.ACvoltage voltage1(
      V_nom=132e3,
      alpha0=5*d2r,
      scType=Spot.Base.Types.sig)
      annotation (extent=[-70,-10; -50,10]);
    Spot.AC1_DC.Sources.ACvoltage voltage2(V_nom=132e3)
      annotation (extent=[90,-10; 70,10]);
    Spot.AC1_DC.Sensors.PVImeter meter(V_nom=132e3, S_nom=100e6)
                                            annotation (extent=[-40,-10; -20,10]);
    replaceable Spot.AC1_DC.Lines.PIline line(redeclare replaceable parameter
        Spot.AC1_DC.Lines.Parameters.PIline par( V_nom=132e3))
                                      annotation (extent=[20,-10; 40,10]);
    Spot.AC1_DC.Nodes.GroundOne grd1 annotation (extent=[-70,-10; -90,10]);
    Spot.AC1_DC.Nodes.GroundOne grd2 annotation (extent=[90,-10; 110,10]);

  equation
    connect(transPh.y, voltage1.vPhasor)
      annotation (points=[-80,20; -54,20; -54,10],
                                         style(color=74, rgbcolor={0,0,127}));
    connect(voltage1.term, meter.term_p)
      annotation (points=[-50,0; -40,0], style(color=3, rgbcolor={0,0,255}));
    connect(meter.term_n, line.term_p)
      annotation (points=[-20,0; 20,0], style(color=3, rgbcolor={0,0,255}));
    connect(line.term_n, voltage2.term)
      annotation (points=[40,0; 70,0], style(color=3, rgbcolor={0,0,255}));
    connect(grd1.term, voltage1.neutral)
      annotation (points=[-70,0; -70,0], style(color=3, rgbcolor={0,0,255}));
    connect(voltage2.neutral, grd2.term)
      annotation (points=[90,0; 90,0], style(color=3, rgbcolor={0,0,255}));
  end Line;

  model LoadAC "AC load"

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
</html>"),
      experiment(NumberOfIntervals=3456),
      experimentSetupOutput);
    inner Spot.System system(ref="inertial")
      annotation (extent=[-80,60; -60,80]);
    Spot.Blocks.Signals.Transient[2] trsSignal(s_ini={1,2}, s_fin={2,3})
      annotation (extent=[30,50; 50,70], rotation=-90);
    Spot.Blocks.Signals.TransientPhasor transPh(a_fin=0.9)
    annotation (extent=[-100,10; -80,30]);
    Spot.AC1_DC.Sources.ACvoltage voltage(scType=Spot.Base.Types.sig)
      annotation (extent=[-70,-10; -50,10]);
    Spot.AC1_DC.Sensors.PVImeter meter      annotation (extent=[-40,-10; -20,10]);
    replaceable Spot.AC1_DC.Loads.ZloadAC zLoadAC
                                           annotation (extent=[30,-10; 50,10]);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-70,-10; -90,10]);

  equation
    connect(transPh.y, voltage.vPhasor)
      annotation (points=[-80,20; -54,20; -54,10],
                                         style(color=74, rgbcolor={0,0,127}));
    connect(voltage.term, meter.term_p)
      annotation (points=[-50,0; -40,0], style(color=3, rgbcolor={0,0,255}));
    connect(meter.term_n, zLoadAC.term)
      annotation (points=[-20,0; 30,0], style(color=3, rgbcolor={0,0,255}));
    connect(grd.term, voltage.neutral)
      annotation (points=[-70,0; -70,0], style(color=3, rgbcolor={0,0,255}));
    connect(trsSignal.y, zLoadAC.p_set)
      annotation (points=[40,50; 40,10], style(color=74, rgbcolor={0,0,127}));
  end LoadAC;

  model LoadDC "AC load"

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
</html>"),
      experiment(NumberOfIntervals=731),
      experimentSetupOutput);
    inner Spot.System system(ref="inertial")
      annotation (extent=[-80,60; -60,80]);
    Spot.Blocks.Signals.Transient trsSignalL(s_ini=0.5, s_fin=1)
      annotation (extent=[30,50; 50,70], rotation=-90);
    Spot.AC1_DC.Sources.DCvoltage voltage(scType=Spot.Base.Types.sig)
      annotation (extent=[-70,-10; -50,10]);
    Spot.AC1_DC.Sensors.PVImeter meter      annotation (extent=[-40,-10; -20,10]);
    replaceable Spot.AC1_DC.Loads.PindLoadDC pLoadDC
                                              annotation (extent=[30,-10; 50,10]);
    Spot.Blocks.Signals.Transient transV(s_fin=0.9)
                                        annotation (extent=[-100,10; -80,30]);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-70,-10; -90,10]);

  equation
    connect(voltage.term, meter.term_p)
      annotation (points=[-50,0; -40,0], style(color=3, rgbcolor={0,0,255}));
    connect(meter.term_n, pLoadDC.term)
      annotation (points=[-20,0; 30,0], style(color=3, rgbcolor={0,0,255}));
    connect(grd.term, voltage.neutral)
      annotation (points=[-70,0; -70,0], style(color=3, rgbcolor={0,0,255}));
    connect(transV.y, voltage.vDC) annotation (points=[-80,20; -54,20; -54,10],
        style(color=74, rgbcolor={0,0,127}));
    connect(trsSignalL.y, pLoadDC.p_set)
      annotation (points=[40,50; 40,10], style(color=74, rgbcolor={0,0,127}));
  end LoadDC;

  model Machines "Machines"

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
"),   experiment,
      experimentSetupOutput);
    inner Spot.System system(ref="inertial")
      annotation (extent=[-80,60; -60,80]);
    Spot.Mechanics.Rotation.Rotor rotor
      annotation (extent=[28,-10; 48,10]);
    Spot.Mechanics.Rotation.Torque torq(tau0=-1)
                                              annotation (extent=[80,-10; 60,10]);
    Spot.Blocks.Signals.Transient transTau(s_ini=0, s_fin=-1)
                                       annotation (extent=[100,-10; 80,10]);

    Spot.AC1_DC.Sources.DCvoltage voltage1(scType=Spot.Base.Types.sig, V_nom=
          100)                        annotation (extent=[-80,-10; -60,10]);
    Spot.Blocks.Signals.Transient transV(s_ini=0, s_fin=1)
    annotation (extent=[-100,10; -80,30]);
    Spot.AC1_DC.Sensors.Psensor power
                                 annotation (extent=[-50,-10; -30,10]);
    replaceable Spot.AC1_DC.Machines.DCser motor(par(V_nom=100, S_nom=1e3))
      "DC machine series"                   annotation (extent=[-10,-10; 10,10]);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-80,-10; -100,10]);
    Spot.Common.Thermal.BoundaryV boundary(m=2)
      annotation (extent=[-10,10; 10,30]);

  equation
    connect(voltage1.term, power.term_p)
      annotation (points=[-60,0; -50,0], style(color=3, rgbcolor={0,0,255}));
    connect(power.term_n, motor.term)
      annotation (points=[-30,0; -10,0], style(color=3, rgbcolor={0,0,255}));
    connect(motor.airgap, rotor.flange_p) annotation (points=[0,6; 14,6; 14,0;
          28,0], style(color=0, rgbcolor={0,0,0}));
    connect(rotor.flange_n, torq.flange)
      annotation (points=[48,0; 60,0], style(color=0, rgbcolor={0,0,0}));
    connect(grd.term, voltage1.neutral)
      annotation (points=[-80,0; -80,0], style(color=3, rgbcolor={0,0,255}));
    connect(transV.y, voltage1.vDC) annotation (points=[-80,20; -64,20; -64,10],
        style(color=74, rgbcolor={0,0,127}));
    connect(motor.heat, boundary.heat)
      annotation (points=[0,10; 0,10], style(color=42, rgbcolor={176,0,0}));
    connect(transTau.y, torq.tau)
      annotation (points=[80,0; 80,0], style(color=74, rgbcolor={0,0,127}));
  end Machines;

  model Sensor "Sensor and meter"

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
      experiment(StopTime=0.2, NumberOfIntervals=731),
      experimentSetupOutput);
    inner Spot.System system(ref="inertial")
      annotation (extent=[-80,60; -60,80]);
    Spot.Blocks.Signals.TransientPhasor transPh
    annotation (extent=[-100,10; -80,30]);
    Spot.AC1_DC.ImpedancesOneTerm.Resistor res
      annotation (extent=[80,-10; 100,10]);
    replaceable Spot.AC1_DC.Sensors.PVImeter meter
                                            annotation (extent=[0,-10; 20,10]);
    Spot.AC1_DC.Sources.Vspectrum voltage
      annotation (extent=[-70,-10; -50,10]);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-70,-10; -90,10]);

  equation
    connect(transPh.y, voltage.vPhasor)
                                    annotation (points=[-80,20; -54,20; -54,10],
                                                                       style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(voltage.term, meter.term_p) annotation (points=[-50,0; 0,0], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(meter.term_n, res.term) annotation (points=[20,0; 80,0], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(grd.term, voltage.neutral)
      annotation (points=[-70,0; -70,0], style(color=3, rgbcolor={0,0,255}));
  end Sensor;

  model Source "Source"

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
      experiment(StopTime=0.2, NumberOfIntervals=731),
      experimentSetupOutput);
    inner Spot.System system(ref="inertial")
      annotation (extent=[-80,60; -60,80]);
    replaceable Spot.AC1_DC.Sources.ACvoltage voltage
      annotation (extent=[-40,-10; -20,10]);
    Spot.AC1_DC.Sensors.PVImeter meter      annotation (extent=[40,-10; 60,10]);
    Spot.AC1_DC.ImpedancesOneTerm.Inductor ind
      annotation (extent=[70,-10; 90,10]);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-40,-10; -60,10]);

  equation
    connect(voltage.term, meter.term_p) annotation (points=[-20,0; 40,0], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(meter.term_n, ind.term) annotation (points=[60,0; 70,0], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(grd.term, voltage.neutral)
      annotation (points=[-40,0; -40,0], style(color=3, rgbcolor={0,0,255}));
  end Source;

  model Transformer "Transformer"

    annotation (
      Coordsys(
  extent=[-100, -100; 100, 100],
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
      experiment(StopTime=3, NumberOfIntervals=7531),
      experimentSetupOutput);
    inner Spot.System system(ref="inertial")
      annotation (extent=[-80,60; -60,80]);
    Spot.Blocks.Signals.TransientPhasor transPh
                    annotation (extent=[-100,10; -80,30]);
    Spot.Control.Relays.TapChangerRelay TapChanger(
      preset_1={0,1,2},
      preset_2={0,1,2},
      t_switch_1={0.9,1.9},
      t_switch_2={1.1,2.1})
      annotation(extent=[0,50; 20,70], rotation=-90);
    Spot.AC1_DC.Sources.ACvoltage voltage(scType=Spot.Base.Types.sig)
      annotation (extent=[-80,-10; -60,10]);
    Spot.AC1_DC.Sensors.PVImeter meter1
      annotation (extent=[-50,-10; -30,10]);
    Spot.AC1_DC.Sensors.PVImeter meter2(V_nom=10)
      annotation (extent=[50,-10; 70,10]);
    replaceable Spot.AC1_DC.Transformers.TrafoStray trafo(par(
      v_tc1 = {1,1.1},
      v_tc2 = {1,1.2},
      V_nom = {1,10}))
                    annotation (extent=[0,-10; 20,10]);
    Spot.AC1_DC.ImpedancesOneTerm.Resistor res(V_nom=10, r=100)
      annotation (extent=[80,-10; 100,10]);
    Spot.AC1_DC.Nodes.PolarityGround polGrd1(pol=0)
      annotation (extent=[80,-40; 100,-20]);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-80,-10; -100,10]);

  equation
    connect(transPh.y, voltage.vPhasor)
      annotation (points=[-80,20; -64,20; -64,10],
                                         style(color=74, rgbcolor={0,0,127}));
    connect(voltage.term, meter1.term_p)
      annotation (points=[-60,0; -50,0], style(color=3, rgbcolor={0,0,255}));
    connect(meter1.term_n, trafo.term_p)
      annotation (points=[-30,0; 0,0], style(color=3, rgbcolor={0,0,255}));
    connect(trafo.term_n, meter2.term_p)
      annotation (points=[20,0; 50,0], style(color=3, rgbcolor={0,0,255}));
    connect(meter2.term_n, res.term)
      annotation (points=[70,0; 80,0], style(color=3, rgbcolor={0,0,255}));
    connect(res.term, polGrd1.term)
      annotation (points=[80,0; 80,-30], style(color=3, rgbcolor={0,0,255}));
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
"),   experiment(StopTime=0.2, NumberOfIntervals=1000),
      experimentSetupOutput);
    inner Spot.System system(ref="inertial")
                        annotation (extent=[-80,60; -60,80]);
    Spot.Blocks.Signals.TransientPhasor transPh
         annotation (extent=[-100,10; -80,30]);
    Spot.AC1_DC.Sources.ACvoltage vAC(V_nom=2, scType=Spot.Base.Types.sig)
          annotation (extent=[-80,-10; -60,10]);
    Spot.AC1_DC.Impedances.Inductor ind
      annotation (
            extent=[-50,-10; -30,10]);
    Spot.AC1_DC.Sensors.PVImeter meterAC(av=true, tcst=0.1)
      annotation (
            extent=[-20,-10; 0,10]);
    replaceable Spot.AC1_DC.Inverters.Rectifier rectifier
      annotation (
            extent=[30,-10; 10,10]);
    Spot.AC1_DC.Sensors.PVImeter meterDC(av=true, tcst=0.1)
      annotation (
            extent=[40,-10; 60,10]);
    Spot.AC1_DC.Sources.DCvoltage vDC(pol=0)
      annotation (
            extent=[90,-10; 70,10]);
    Spot.AC1_DC.Nodes.GroundOne grd1 annotation (extent=[-80,-10; -100,10]);
    Spot.AC1_DC.Nodes.GroundOne grd2 annotation (extent=[90,-10; 110,10]);
    Spot.Common.Thermal.BoundaryV boundary(m=2)
      annotation (extent=[10,10; 30,30]);

  equation
    connect(transPh.y, vAC.vPhasor)
      annotation (points=[-80,20; -64,20; -64,10],
                                         style(color=74, rgbcolor={0,0,127}));
    connect(vAC.term, ind.term_p)
      annotation (points=[-60,0; -50,0], style(color=3, rgbcolor={0,0,255}));
    connect(ind.term_n, meterAC.term_p)
      annotation (points=[-30,0; -20,0], style(color=3, rgbcolor={0,0,255}));
    connect(meterAC.term_n, rectifier.AC)
      annotation (points=[0,0; 10,0], style(color=3, rgbcolor={0,0,255}));
    connect(rectifier.DC, meterDC.term_p) annotation (points=[30,0; 40,0],
                 style(color=3, rgbcolor={0,0,255}));
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
"),   experiment(StopTime=0.2, NumberOfIntervals=1000),
      experimentSetupOutput);
    inner Spot.System system(ref="inertial")
                        annotation (extent=[-80,60; -60,80]);
    Spot.Blocks.Signals.TransientPhasor transPh
         annotation (extent=[-100,10; -80,30]);
    Spot.AC1_DC.Sources.ACvoltage vAC(         scType=Spot.Base.Types.sig)
          annotation (extent=[-80,-10; -60,10]);
    Spot.AC1_DC.Impedances.Inductor ind
      annotation (
            extent=[-50,-10; -30,10]);
    Spot.AC1_DC.Sensors.PVImeter meterAC(av=true, tcst=0.1)
      annotation (
            extent=[0,-10; -20,10]);
    replaceable Spot.AC1_DC.Inverters.Inverter dc_ac
                                             annotation (extent=[30,-10; 10,10]);
    Spot.AC1_DC.Sensors.PVImeter meterDC(av=true, tcst=0.1)
      annotation (
            extent=[60,-10; 40,10]);
    Spot.AC1_DC.Sources.DCvoltage vDC(pol=0, V_nom=2)
      annotation (
            extent=[90,-10; 70,10]);
    Spot.AC1_DC.Inverters.Select select(alpha0=30*d2r)
                                   annotation (extent=[30,40; 10,60]);
    Spot.AC1_DC.Nodes.GroundOne grd1 annotation (extent=[90,-10; 110,10]);
    Spot.AC1_DC.Nodes.GroundOne grd2 annotation (extent=[-80,-10; -100,10]);
    Spot.Common.Thermal.BoundaryV boundary(m=2)
      annotation (extent=[10,10; 30,30]);

  equation
    connect(transPh.y, vAC.vPhasor) annotation (points=[-80,20; -64,20; -64,10],
        style(color=74, rgbcolor={0,0,127}));
    connect(select.theta_out,dc_ac. theta)
      annotation (points=[26,40; 26,10], style(color=74, rgbcolor={0,0,127}));
    connect(select.uPhasor_out,dc_ac. uPhasor)
      annotation (points=[14,40; 14,10], style(color=74, rgbcolor={0,0,127}));
    connect(vDC.term, meterDC.term_p)
      annotation (points=[70,0; 60,0],   style(color=3, rgbcolor={0,0,255}));
    connect(meterDC.term_n, dc_ac.DC)
      annotation (points=[40,0; 30,0],   style(color=3, rgbcolor={0,0,255}));
    connect(dc_ac.AC, meterAC.term_p)
      annotation (points=[10,0; 0,0],  style(color=3, rgbcolor={0,0,255}));
    connect(meterAC.term_n, ind.term_n)
      annotation (points=[-20,0; -30,0],
                                       style(color=3, rgbcolor={0,0,255}));
    connect(ind.term_p, vAC.term)
      annotation (points=[-50,0; -60,0],
                                       style(color=3, rgbcolor={0,0,255}));
    connect(grd1.term, vDC.neutral)
      annotation (points=[90,0; 90,0],   style(color=3, rgbcolor={0,0,255}));
    connect(grd2.term, vAC.neutral)
      annotation (points=[-80,0; -80,0],
                                       style(color=3, rgbcolor={0,0,255}));
    connect(dc_ac.heat, boundary.heat)
      annotation (points=[20,10; 20,10], style(color=42, rgbcolor={176,0,0}));
  end Inverter;

end b_AC1_DC;
