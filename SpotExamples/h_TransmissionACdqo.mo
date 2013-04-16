within SpotExamples;
package h_TransmissionACdqo "AC transmission, dqo"
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
<p>Transmission line models and faults.</p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"),
    Icon);

model PowerTransfer "Power transfer between two nodes"

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
    Documentation(
            info="<html>
<p>Shows the influence of phase-difference on power flow.<br>
Alternatively one can look at a variation of amplitude ratios.</p>
<p><i>See for example:</i>
<pre>
  sensor1.p[1]     active power
  sensor1.p[2]     reactive power.
</pre>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"), Diagram,
    Icon,
      experiment(StopTime=60),
      experimentSetupOutput);
  inner Spot.System system
                      annotation (extent=[-100,80; -80,100]);
  Spot.Blocks.Signals.TransientPhasor transPh(
      t_change=30,
      t_duration=60,
      ph_fin=2*pi,
      ph_ini=0)
               annotation (extent=[-80,20; -60,40]);
  Spot.ACdqo.Sources.InfBus infBus1(V_nom=130e3, scType=Spot.Base.Types.sig)
    annotation (
          extent=[-60,0; -40,20]);
  Spot.ACdqo.Lines.RXline line(par(
    V_nom=130e3,
    S_nom=100e6),
    len=100)                            annotation (extent=[20,0; 40,20]);
  Spot.ACdqo.Sensors.Psensor sensor
    annotation (
          extent=[-20,0; 0,20]);
  Spot.ACdqo.Sources.InfBus infBus2(V_nom=130e3)
    annotation (
          extent=[80,0; 60,20]);
  Spot.ACdqo.Nodes.GroundOne grd1 annotation (extent=[-60,0; -80,20]);
  Spot.ACdqo.Nodes.GroundOne grd2 annotation (extent=[80,0; 100,20]);

equation
  connect(transPh.y,infBus1. vPhasor)
                                 annotation (points=[-60,30; -44,30; -44,20],
                                                                      style(
          color=74, rgbcolor={0,0,127}));
  connect(infBus1.term, sensor.term_p)  annotation (points=[-40,10; -20,10],
        style(color=62, rgbcolor={0,110,110}));
  connect(sensor.term_n, line.term_p)
      annotation (points=[0,10; 20,10], style(color=62, rgbcolor={0,110,110}));
    connect(line.term_n, infBus2.term)
                                      annotation (points=[40,10; 60,10], style(
          color=62, rgbcolor={0,110,110}));
  connect(grd1.term,infBus1. neutral)
      annotation (points=[-60,10; -60,10], style(color=3, rgbcolor={0,0,255}));
    connect(grd2.term, infBus2.neutral)
      annotation (points=[80,10; 80,10], style(color=3, rgbcolor={0,0,255}));
end PowerTransfer;

model VoltageStability "Voltage stability"

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
    Documentation(
            info="<html>
<p>Power flow between source and infinite bus. The bus-voltage decreases from 1 to 0.
<pre>
  stable:     voltage above extremal point (maximum p[1])
  instable:   voltage below extremal point (maximum p[1])
</pre></p>
<p><i>See for example:</i>
<pre>
  meter1/2/3.v_norm and plot it against
  meter1/2/3.p[1] as independent variable.
</pre></p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"),
    Diagram,
    Icon,
      experiment(StopTime=180, NumberOfIntervals=1000),
      experimentSetupOutput);
  inner Spot.System system
                      annotation (extent=[-100,80; -80,100]);
  Spot.ACdqo.Sources.InfBus Vsource0(V_nom=400e3, alpha0=0)
    annotation (
          extent=[-80,40; -60,60]);
  Spot.ACdqo.Sources.InfBus infBus(V_nom=400e3, scType=Spot.Base.Types.sig)
    annotation (
          extent=[60,0; 40,20]);

  Spot.ACdqo.Sensors.Vmeter Vmeter(phasor=true, V_nom=400e3)
      annotation (extent=[40,40; 60,60]);
  Spot.ACdqo.Sensors.PVImeter meter0(phasor=true, S_nom=100e6)
      annotation (extent=[0,40; 20,60]);
  Spot.ACdqo.Lines.RXline line0(par(
        V_nom=400e3,
        r=2e-3,
        x=0.25e-3), len=500)            annotation (extent=[-40,40; -20,60]);
  Spot.ACdqo.Sources.InfBus Vsource1(V_nom=400e3, alpha0=5*d2r)
    annotation (
          extent=[-80,0; -60,20]);
  Spot.ACdqo.Sensors.PVImeter meter1(phasor=true, S_nom=100e6)
      annotation (extent=[0,0; 20,20]);
  Spot.ACdqo.Lines.RXline line1(par(
        V_nom=400e3,
        r=2e-3,
        x=0.25e-3), len=500)            annotation (extent=[-40,0; -20,20]);
  Spot.ACdqo.Sources.InfBus Vsource2(V_nom=400e3, alpha0=-5*d2r)
    annotation (
          extent=[-80,-40; -60,-20]);
  Spot.ACdqo.Sensors.PVImeter meter2(phasor=true, S_nom=100e6)
      annotation (extent=[0,-40; 20,-20]);
  Spot.ACdqo.Lines.RXline line2(par(
        V_nom=400e3,
        r=2e-3,
        x=0.25e-3), len=500)            annotation (extent=[-40,-40; -20,-20]);
  Spot.Blocks.Signals.TransientPhasor transPh(
      t_change=90,
      t_duration=120,
      a_ini=1,
      a_fin=0) annotation (extent=[90,20; 70,40]);
  Spot.ACdqo.Nodes.GroundOne grd1 annotation (extent=[-80,40; -100,60]);
  Spot.ACdqo.Nodes.GroundOne grd4 annotation (extent=[60,0; 80,20]);
  Spot.ACdqo.Nodes.GroundOne grd2 annotation (extent=[-80,0; -100,20]);
  Spot.ACdqo.Nodes.GroundOne grd3 annotation (extent=[-80,-40; -100,-20]);

equation
  connect(transPh.y, infBus.vPhasor)
      annotation (points=[70,30; 44,30; 44,20],
                                         style(color=74, rgbcolor={0,0,127}));
  connect(Vsource0.term, line0.term_p)   annotation (points=[-60,50; -40,50], style(
          color=62, rgbcolor={0,110,110}));
  connect(line0.term_n, meter0.term_p)   annotation (points=[-20,50; 0,50],
        style(color=62, rgbcolor={0,110,110}));
  connect(meter0.term_n, infBus.term)   annotation (points=[20,50; 30,50; 30,10;
          40,10], style(color=62, rgbcolor={0,110,110}));
  connect(Vsource1.term, line1.term_p)   annotation (points=[-60,10; -40,10],
        style(color=62, rgbcolor={0,110,110}));
  connect(line1.term_n, meter1.term_p)   annotation (points=[-20,10; 0,10],
        style(color=62, rgbcolor={0,110,110}));
  connect(meter1.term_n, infBus.term)   annotation (points=[20,10; 40,10],
        style(color=62, rgbcolor={0,110,110}));
  connect(Vsource2.term, line2.term_p)   annotation (points=[-60,-30; -40,-30],
        style(color=62, rgbcolor={0,110,110}));
  connect(line2.term_n, meter2.term_p)   annotation (points=[-20,-30; 0,-30],
        style(color=62, rgbcolor={0,110,110}));
  connect(meter2.term_n, infBus.term)   annotation (points=[20,-30; 30,-30; 30,
          10; 40,10], style(color=62, rgbcolor={0,110,110}));
  connect(infBus.term, Vmeter.term)   annotation (points=[40,10; 40,50], style(
          color=62, rgbcolor={0,110,110}));
  connect(grd1.term, Vsource0.neutral)
      annotation (points=[-80,50; -80,50], style(color=3, rgbcolor={0,0,255}));
  connect(grd2.term, Vsource1.neutral)
      annotation (points=[-80,10; -80,10], style(color=3, rgbcolor={0,0,255}));
  connect(grd3.term, Vsource2.neutral) annotation (points=[-80,-30; -80,-30],
        style(color=3, rgbcolor={0,0,255}));
  connect(infBus.neutral, grd4.term)
      annotation (points=[60,10; 60,10], style(color=3, rgbcolor={0,0,255}));
end VoltageStability;

  model RXline "Single lumped line"
    import Spot;

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
      Documentation(
              info="<html>
<p>Short-time line switched off.<br>
Compare with PIline.</p>
<p><i>See for example:</i>
<pre>  meter.p[1:2]     active and reactive power</pre></p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),   Diagram,
      Icon,
      experiment,
      experimentSetupOutput);
    inner Spot.System system
                        annotation (extent=[-100,80; -80,100]);
    Spot.ACdqo.Sources.InfBus infBus1(V_nom=400e3,
      v0=1.04,
      alpha0=30*d2r)
      annotation (
            extent=[-80,-20; -60,0]);
    Spot.ACdqo.Breakers.Switch switch1(V_nom=400e3, I_nom=2500)
      annotation (
            extent=[-20,-20; 0,0]);
    Spot.ACdqo.Lines.RXline line(par(
        V_nom=400e3,
        x=0.25e-3,
        r=0.02e-3), len=400)
      annotation(extent=[10,-20; 30,0]);
    Spot.ACdqo.Breakers.Switch switch2(V_nom=400e3, I_nom=2500)
      annotation (
            extent=[40,-20; 60,0]);
    Spot.ACdqo.Sources.InfBus infBus2(V_nom=400e3)
      annotation (
            extent=[90,-20; 70,0]);
    Spot.Control.Relays.SwitchRelay relay1(
      t_switch={0.2,0.65})
        annotation (extent=[-40,20; -20,40]);
    Spot.Control.Relays.SwitchRelay relay2(
      t_switch={0.3,0.7})
        annotation (extent=[80,20; 60,40]);
    Spot.ACdqo.Sensors.PVImeter meter(V_nom=400e3, S_nom=1000e6)
      annotation (
            extent=[-50,-20; -30,0]);
    Spot.ACdqo.Nodes.GroundOne grd1 annotation (extent=[-80,-20; -100,0]);
    Spot.ACdqo.Nodes.GroundOne grd2 annotation (extent=[90,-20; 110,0]);

  equation
    connect(relay1.y, switch1.control) annotation (points=[-20,30; -10,30; -10,0],
        style(color=5, rgbcolor={255,0,255}));
    connect(relay2.y, switch2.control) annotation (points=[60,30; 50,30; 50,0],
        style(color=5, rgbcolor={255,0,255}));
    connect(infBus1.term, meter.term_p) annotation (points=[-60,-10; -50,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(meter.term_n, switch1.term_p) annotation (points=[-30,-10; -20,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(switch1.term_n, line.term_p) annotation (points=[0,-10; 10,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(line.term_n, switch2.term_p) annotation (points=[30,-10; 40,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(switch2.term_n, infBus2.term)
                                         annotation (points=[60,-10; 70,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(grd1.term,infBus1. neutral) annotation (points=[-80,-10; -80,-10],
        style(color=3, rgbcolor={0,0,255}));
    connect(infBus2.neutral, grd2.term)
      annotation (points=[90,-10; 90,-10], style(color=3, rgbcolor={0,0,255}));
  end RXline;

  model PIline "Single PI-line"

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
      Diagram,
      Documentation(
              info="<html>
<p>Short-time line switched off.<br>
Compare with RXline.</p>
<p><i>See for example:</i>
<pre>
  meter.p[1:2]     active and reactive power
  line.v           line voltage, oscillations due to switching
</pre></p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),   Icon,
      experiment(NumberOfIntervals=34567),
      experimentSetupOutput);
    inner Spot.System system
                        annotation (extent=[-100,80; -80,100]);
    Spot.ACdqo.Sources.InfBus infBus1(V_nom=400e3,
      v0=1.04,
      alpha0=30*d2r)
      annotation (
            extent=[-80,-20; -60,0]);
    Spot.ACdqo.Breakers.Breaker breaker1(V_nom=400e3, I_nom=2500)
      annotation (
            extent=[-20,-20; 0,0]);
    Spot.ACdqo.Lines.PIline line(len=400, par(
        V_nom=400e3,
        x=0.25e-3,
        r=0.02e-3))
      annotation (
            extent=[10,-20; 30,0]);
    Spot.ACdqo.Breakers.Breaker breaker2(V_nom=400e3, I_nom=2500)
      annotation (
            extent=[40,-20; 60,0]);
    Spot.ACdqo.Sources.InfBus infBus2(V_nom=400e3)
      annotation (
            extent=[90,-20; 70,0]);
    Spot.Control.Relays.SwitchRelay relay1(
      t_switch={0.2,0.65})
        annotation (extent=[-40,20; -20,40]);
    Spot.Control.Relays.SwitchRelay relay2(
      t_switch={0.3,0.7})
        annotation (extent=[80,20; 60,40]);
    Spot.ACdqo.Sensors.PVImeter meter(V_nom=400e3, S_nom=1000e6)
      annotation (
            extent=[-50,-20; -30,0]);
    Spot.ACdqo.Nodes.GroundOne grd1 annotation (extent=[-80,-20; -100,0]);
    Spot.ACdqo.Nodes.GroundOne grd2 annotation (extent=[90,-20; 110,0]);

  equation
    connect(relay1.y, breaker1.control) annotation (points=[-20,30; -10,30; -10,0],
        style(color=5, rgbcolor={255,0,255}));
    connect(relay2.y, breaker2.control) annotation (points=[60,30; 50,30; 50,0],
        style(color=5, rgbcolor={255,0,255}));
    connect(infBus1.term, meter.term_p) annotation (points=[-60,-10; -50,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(meter.term_n, breaker1.term_p) annotation (points=[-30,-10; -20,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(breaker1.term_n, line.term_p) annotation (points=[0,-10; 10,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(line.term_n, breaker2.term_p) annotation (points=[30,-10; 40,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(breaker2.term_n, infBus2.term)
                                          annotation (points=[60,-10; 70,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(grd1.term,infBus1. neutral) annotation (points=[-80,-10; -80,-10],
        style(color=3, rgbcolor={0,0,255}));
    connect(infBus2.neutral, grd2.term)
      annotation (points=[90,-10; 90,-10], style(color=3, rgbcolor={0,0,255}));
  end PIline;

  model FaultRXline "Faulted lumped line"
    import Spot;

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
      Documentation(
              info="<html>
<p>Fault clearance by short-time line switched off.<br>
Compare with FaultPIline.</p>
<p><i>See for example:</i>
<pre>
  meter.p[1:2]     active and reactive power
  abc.i_abc        fault currents
</pre></p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),   Diagram,
      Icon,
      experiment,
      experimentSetupOutput);
    inner Spot.System system
                        annotation (extent=[-100,80; -80,100]);
    Spot.ACdqo.Sources.InfBus infBus1(V_nom=400e3,
      v0=1.04,
      alpha0=30*d2r)
      annotation (
            extent=[-80,-20; -60,0]);
    Spot.ACdqo.Breakers.Switch switch1(V_nom=400e3, I_nom=2500)
      annotation (
            extent=[-20,-20; 0,0]);
    Spot.ACdqo.Lines.FaultRXline line(par(
        V_nom=400e3,
        x=0.25e-3,
        r=0.02e-3), len=400)
      annotation(extent=[10,-20; 30,0]);
    Spot.ACdqo.Breakers.Switch switch2(V_nom=400e3, I_nom=2500)
      annotation (
            extent=[40,-20; 60,0]);
    Spot.ACdqo.Sources.InfBus infBus2(V_nom=400e3)
      annotation (
            extent=[90,-20; 70,0]);
    Spot.Control.Relays.SwitchRelay relay1(
      t_switch={0.2,0.65})
        annotation (extent=[-40,20; -20,40]);
    Spot.Control.Relays.SwitchRelay relay2(
      t_switch={0.3,0.7})
        annotation (extent=[80,20; 60,40]);
    Spot.ACdqo.Sensors.PVImeter meter(V_nom=400e3, S_nom=1000e6)
      annotation (
            extent=[-50,-20; -30,0]);
    Spot.ACdqo.Faults.Fault_abc abc
         annotation (extent=[10,20; 30,40]);
    Spot.ACdqo.Nodes.GroundOne grd1 annotation (extent=[-80,-20; -100,0]);
    Spot.ACdqo.Nodes.GroundOne grd2 annotation (extent=[90,-20; 110,0]);

  equation
    connect(relay1.y, switch1.control) annotation (points=[-20,30; -10,30; -10,0],
        style(color=5, rgbcolor={255,0,255}));
    connect(relay2.y, switch2.control) annotation (points=[60,30; 50,30; 50,0],
        style(color=5, rgbcolor={255,0,255}));
    connect(infBus1.term, meter.term_p) annotation (points=[-60,-10; -50,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(meter.term_n, switch1.term_p) annotation (points=[-30,-10; -20,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(switch1.term_n, line.term_p) annotation (points=[0,-10; 10,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(line.term_n, switch2.term_p) annotation (points=[30,-10; 40,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(switch2.term_n, infBus2.term)
                                         annotation (points=[60,-10; 70,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(line.term_f, abc.term)
      annotation (points=[20,0; 20,20], style(color=62, rgbcolor={0,120,120}));
    connect(grd1.term,infBus1. neutral) annotation (points=[-80,-10; -80,-10],
        style(color=3, rgbcolor={0,0,255}));
    connect(infBus2.neutral, grd2.term)
      annotation (points=[90,-10; 90,-10], style(color=3, rgbcolor={0,0,255}));
  end FaultRXline;

  model FaultPIline "Faulted PI-line"

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
      Diagram,
      Documentation(
              info="<html>
<p>Fault clearance by short-time line switched off.<br>
Compare with FaultRXline.</p>
<p><i>See for example:</i>
<pre>
  meter.p[1:2]     active and reactive power
  line.v           line voltage, oscillations due to switching
  abc.i_abc        fault currents
</pre></p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),   Icon,
      experiment(NumberOfIntervals=34567),
      experimentSetupOutput);
    inner Spot.System system
                        annotation (extent=[-100,80; -80,100]);
    Spot.ACdqo.Sources.InfBus infBus1(V_nom=400e3,
      v0=1.04,
      alpha0=30*d2r)
      annotation (
            extent=[-80,-20; -60,0]);
    Spot.ACdqo.Breakers.Breaker breaker1(V_nom=400e3, I_nom=2500)
      annotation (
            extent=[-20,-20; 0,0]);
    Spot.ACdqo.Lines.FaultPIline line(len=400, par(
        V_nom=400e3,
        x=0.25e-3,
        r=0.02e-3))
      annotation (
            extent=[10,-20; 30,0]);
    Spot.ACdqo.Breakers.Breaker breaker2(V_nom=400e3, I_nom=2500)
      annotation (
            extent=[40,-20; 60,0]);
    Spot.ACdqo.Sources.InfBus infBus2(V_nom=400e3)
      annotation (
            extent=[90,-20; 70,0]);
    Spot.Control.Relays.SwitchRelay relay1(
      t_switch={0.2,0.65})
        annotation (extent=[-40,20; -20,40]);
    Spot.Control.Relays.SwitchRelay relay2(
      t_switch={0.3,0.7})
        annotation (extent=[80,20; 60,40]);
    Spot.ACdqo.Sensors.PVImeter meter(V_nom=400e3, S_nom=1000e6)
      annotation (
            extent=[-50,-20; -30,0]);
    Spot.ACdqo.Faults.Fault_abc abc
         annotation (extent=[10,20; 30,40]);
    Spot.ACdqo.Nodes.GroundOne grd1 annotation (extent=[-80,-20; -100,0]);
    Spot.ACdqo.Nodes.GroundOne grd2 annotation (extent=[90,-20; 110,0]);

  equation
    connect(relay1.y, breaker1.control) annotation (points=[-20,30; -10,30; -10,0],
        style(color=5, rgbcolor={255,0,255}));
    connect(relay2.y, breaker2.control) annotation (points=[60,30; 50,30; 50,0],
        style(color=5, rgbcolor={255,0,255}));
    connect(infBus1.term, meter.term_p) annotation (points=[-60,-10; -50,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(meter.term_n, breaker1.term_p) annotation (points=[-30,-10; -20,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(breaker1.term_n, line.term_p) annotation (points=[0,-10; 10,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(line.term_n, breaker2.term_p) annotation (points=[30,-10; 40,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(breaker2.term_n, infBus2.term)
                                          annotation (points=[60,-10; 70,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(line.term_f, abc.term)
      annotation (points=[20,0; 20,20], style(color=62, rgbcolor={0,120,120}));
    connect(grd1.term,infBus1. neutral) annotation (points=[-80,-10; -80,-10],
        style(color=3, rgbcolor={0,0,255}));
    connect(infBus2.neutral, grd2.term)
      annotation (points=[90,-10; 90,-10], style(color=3, rgbcolor={0,0,255}));
  end FaultPIline;

  model DoubleRXline "Parallel lumped lines, one faulted"

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
      Documentation(
              info="<html>
<p>Fault clearance by short-time line switched off.<br>
Compare with DoublePIline.</p>
<p><i>See for example:</i>
<pre>
  meter.p[1:2]     active and reactive power
  abc.i_abc        fault currents
</pre></p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),   Diagram,
      Icon,
      experiment(StopTime=0.5, NumberOfIntervals=20000),
      experimentSetupOutput);
    inner Spot.System system
                        annotation (extent=[-100,80; -80,100]);
    Spot.ACdqo.Sources.InfBus infBus1(V_nom=20e3, alpha0=30*d2r)
      annotation (extent=[-90,-20; -70,0]);
    Spot.ACdqo.Transformers.TrafoStray trafo(
      par=trafo20k_400k_YD,
      redeclare Spot.ACdqo.Ports.Topology.Delta top_p "Delta",
      redeclare Spot.ACdqo.Ports.Topology.Y top_n "Y")
              annotation (extent=[-60,-20; -40,0]);
    Spot.ACdqo.Lines.RXline line(
      len=480, par=OH400kV)
      annotation (
            extent=[20,-40; 40,-20]);
    Spot.ACdqo.Breakers.Switch switch1(V_nom=400e3, I_nom=2500)
      annotation (
            extent=[-40,0; -20,20]);
    Spot.ACdqo.Lines.FaultRXline lineF(
      len=430, par=OH400kV,
      stIni_en=false)
         annotation (extent=[20,0; 40,20]);
    Spot.ACdqo.Breakers.Switch switch2(V_nom=400e3, I_nom=2500)
      annotation (
            extent=[50,0; 70,20]);
    Spot.ACdqo.Faults.Fault_abc abc
         annotation (extent=[20,40; 40,60]);
    Spot.ACdqo.Sources.InfBus InfBus2(V_nom=400e3, alpha0=30*d2r)
      annotation (
            extent=[90,-20; 70,0]);
    Spot.Control.Relays.SwitchRelay relay1(t_switch={0.15,0.2})
      annotation (
            extent=[-60,40; -40,60]);
    Spot.Control.Relays.SwitchRelay relay2(t_switch={0.153,0.21})
             annotation (extent=[90,40; 70,60]);
    Spot.ACdqo.Sensors.PVImeter meterL(S_nom=1000e6, V_nom=400e3)
      annotation (
            extent=[-10,-40; 10,-20]);
    Spot.ACdqo.Sensors.PVImeter meterF(S_nom=1000e6, V_nom=400e3)
      annotation (
            extent=[-10,0; 10,20]);
    Spot.ACdqo.Nodes.GroundOne grd1 annotation (extent=[-90,-20; -110,0]);
    Spot.ACdqo.Nodes.GroundOne grd2 annotation (extent=[90,-20; 110,0]);
    Data.Lines.OHline400kV OH400kV annotation (extent=[0,80; 40,100]);
    Data.Transformers.TrafoStray trafo20k_400k_YD
      annotation (extent=[-60,80; -20,100]);

  equation
    connect(relay1.y, switch1.control) annotation (points=[-40,50; -30,50; -30,
          20], style(color=5, rgbcolor={255,0,255}));
    connect(relay2.y, switch2.control) annotation (points=[70,50; 60,50; 60,20],
        style(color=5, rgbcolor={255,0,255}));
    connect(trafo.term_n, meterL.term_p) annotation (points=[-40,-10; -40,-30;
          -10,-30], style(color=62, rgbcolor={0,110,110}));
    connect(meterL.term_n, line.term_p) annotation (points=[10,-30; 20,-30],
        style(color=62, rgbcolor={0,110,110}));
    connect(line.term_n, InfBus2.term)
                                      annotation (points=[40,-30; 70,-30; 70,
          -10],         style(color=62, rgbcolor={0,110,110}));
    connect(trafo.term_n, switch1.term_p) annotation (points=[-40,-10; -40,10],
        style(color=62, rgbcolor={0,110,110}));
    connect(switch1.term_n, meterF.term_p) annotation (points=[-20,10; -10,10],
        style(color=62, rgbcolor={0,110,110}));
    connect(meterF.term_n, lineF.term_p) annotation (points=[10,10; 20,10],
        style(color=62, rgbcolor={0,110,110}));
    connect(lineF.term_n, switch2.term_p) annotation (points=[40,10; 50,10],
        style(color=62, rgbcolor={0,110,110}));
    connect(switch2.term_n, InfBus2.term)
                                         annotation (points=[70,10; 70,-10],
                style(color=62, rgbcolor={0,110,110}));
    connect(lineF.term_f, abc.term) annotation (points=[30,20; 30,40], style(
          color=62, rgbcolor={0,120,120}));
    connect(infBus1.term, trafo.term_p)  annotation (points=[-70,-10; -60,-10],
        style(color=62, rgbcolor={0,120,120}));
    connect(grd1.term,infBus1. neutral)  annotation (points=[-90,-10; -90,-10],
        style(color=3, rgbcolor={0,0,255}));
    connect(InfBus2.neutral, grd2.term)
      annotation (points=[90,-10; 90,-10], style(color=3, rgbcolor={0,0,255}));
  end DoubleRXline;

  model DoublePIline "Parallel PI-lines, one faulted"

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
      Documentation(
              info="<html>
<p>Fault clearance by short-time line switched off.<br>
Compare with DoublePIline.</p>
<p><i>See for example:</i>
<pre>
  meter.p[1:2]     active and reactive power
  line.v           line voltage, oscillations due to switching
  lineF.v          fault line voltage
  abc.i_abc        fault currents
</pre></p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"),
      Diagram,
      Icon,
      experiment(StopTime=0.5, NumberOfIntervals=20000),
      experimentSetupOutput);
    inner Spot.System system
                        annotation (extent=[-100,80; -80,100]);
    Spot.ACdqo.Sources.InfBus infBus1(V_nom=20e3, alpha0=30*d2r)
      annotation (extent=[-90,-20; -70,0]);
    Spot.ACdqo.Transformers.TrafoStray trafo(
      par=trafo20k_400k_YD,
      redeclare Spot.ACdqo.Ports.Topology.Delta top_p "Delta",
      redeclare Spot.ACdqo.Ports.Topology.Y top_n "Y")
              annotation (extent=[-60,-20; -40,0]);
    Spot.ACdqo.Lines.PIline line(
      len=480, par=OH_400kV)
      annotation (
            extent=[20,-40; 40,-20]);
    Spot.ACdqo.Breakers.Switch switch1(V_nom=400e3, I_nom=2500)
      annotation (
            extent=[-40,0; -20,20]);
    Spot.ACdqo.Lines.FaultPIline lineF(
      len=430, par=OH_400kV,
      stIni_en=false)
         annotation (extent=[20,0; 40,20]);
    Spot.ACdqo.Breakers.Switch switch2(V_nom=400e3, I_nom=2500)
      annotation (
            extent=[50,0; 70,20]);
    Spot.ACdqo.Faults.Fault_abc abc
         annotation (extent=[20,40; 40,60]);
    Spot.ACdqo.Sources.InfBus InfBus2(V_nom=400e3, alpha0=30*d2r)
      annotation (
            extent=[90,-20; 70,0]);
    Spot.Control.Relays.SwitchRelay relay1(t_switch={0.15,0.2})
      annotation (
            extent=[-60,40; -40,60]);
    Spot.Control.Relays.SwitchRelay relay2(t_switch={0.153,0.21})
             annotation (extent=[90,40; 70,60]);
    Spot.ACdqo.Sensors.PVImeter meterL(S_nom=1000e6, V_nom=400e3)
      annotation (
            extent=[-10,-40; 10,-20]);
    Spot.ACdqo.Sensors.PVImeter meterF(S_nom=1000e6, V_nom=400e3)
      annotation (
            extent=[-10,0; 10,20]);
    Data.Lines.OHline_400kV OH_400kV annotation (extent=[0,80; 40,100]);
    Spot.ACdqo.Nodes.GroundOne grd1 annotation (extent=[-90,-20; -110,0]);
    Spot.ACdqo.Nodes.GroundOne grd2 annotation (extent=[90,-20; 110,0]);
    Data.Transformers.TrafoStray trafo20k_400k_YD
      annotation (extent=[-60,80; -20,100]);

  equation
    connect(relay1.y, switch1.control) annotation (points=[-40,50; -30,50; -30,
          20], style(color=5, rgbcolor={255,0,255}));
    connect(relay2.y, switch2.control) annotation (points=[70,50; 60,50; 60,20],
        style(color=5, rgbcolor={255,0,255}));
    connect(trafo.term_n, meterL.term_p) annotation (points=[-40,-10; -40,-30;
          -10,-30], style(color=62, rgbcolor={0,110,110}));
    connect(meterL.term_n, line.term_p) annotation (points=[10,-30; 20,-30],
        style(color=62, rgbcolor={0,110,110}));
    connect(line.term_n, InfBus2.term)
                                      annotation (points=[40,-30; 70,-30; 70,
          -10],         style(color=62, rgbcolor={0,110,110}));
    connect(trafo.term_n, switch1.term_p) annotation (points=[-40,-10; -40,10],
        style(color=62, rgbcolor={0,110,110}));
    connect(switch1.term_n, meterF.term_p) annotation (points=[-20,10; -10,10],
        style(color=62, rgbcolor={0,110,110}));
    connect(meterF.term_n, lineF.term_p) annotation (points=[10,10; 20,10],
        style(color=62, rgbcolor={0,110,110}));
    connect(lineF.term_n, switch2.term_p) annotation (points=[40,10; 50,10],
        style(color=62, rgbcolor={0,110,110}));
    connect(switch2.term_n, InfBus2.term)
                                         annotation (points=[70,10; 70,-10],
                style(color=62, rgbcolor={0,110,110}));
    connect(lineF.term_f, abc.term) annotation (points=[30,20; 30,40], style(
          color=62, rgbcolor={0,110,110}));
    connect(infBus1.term, trafo.term_p)  annotation (points=[-70,-10; -60,-10],
        style(color=62, rgbcolor={0,120,120}));
    connect(grd1.term, infBus1.neutral)  annotation (points=[-90,-10; -90,-10],
        style(color=3, rgbcolor={0,0,255}));
    connect(grd2.term, InfBus2.neutral)
      annotation (points=[90,-10; 90,-10], style(color=3, rgbcolor={0,0,255}));
  end DoublePIline;

  model DoubleRXlineTG
    "Parallel lumped lines with turbo generator, one line faulted"

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
      Documentation(
              info="<html>
<p>Fault clearance by short-time line switched off.<br>
Compare with DoublePIline.</p>
<p><i>See for example:</i>
<pre>
  meter.p[1:2]     active and reactive power
  abc.i_abc        fault currents
</pre></p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),   Diagram,
      Icon,
      experiment(StopTime=0.5),
      experimentSetupOutput);
    inner Spot.System system
                        annotation (extent=[-100,80; -80,100]);
    Spot.GenerationACdqo.TurboGenerator turbGen(
      alpha_ini=30*d2r,
      p_ini=0.762922,
      iniType=Spot.Base.Types.p_q,
      redeclare Spot.ACdqo.Machines.Synchron_el generator(par(
          V_nom=20e3,
          S_nom=1000e6,
          If_nom=2000), stIni_en=false) "nth order")
      annotation (extent=[-90,-20; -70,0]);
    Spot.ACdqo.Transformers.TrafoStray trafo(
      par=trafo20k_400k_YD,
      redeclare Spot.ACdqo.Ports.Topology.Delta top_p "Delta",
      redeclare Spot.ACdqo.Ports.Topology.Y top_n "Y")
              annotation (extent=[-60,-20; -40,0]);
    Spot.ACdqo.Lines.RXline line(
      len=480, par=OH400kV)
      annotation (
            extent=[20,-40; 40,-20]);
    Spot.ACdqo.Breakers.Switch switch1(V_nom=400e3, I_nom=2500)
      annotation (
            extent=[-40,0; -20,20]);
    Spot.ACdqo.Lines.FaultRXline lineF(
      len=430, par=OH400kV,
      stIni_en=false)
         annotation (extent=[20,0; 40,20]);
    Spot.ACdqo.Breakers.Switch switch2(V_nom=400e3, I_nom=2500)
      annotation (
            extent=[50,0; 70,20]);
    Spot.ACdqo.Faults.Fault_abc abc(epsG=1e-5)
         annotation (extent=[20,40; 40,60]);
    Spot.ACdqo.Sources.InfBus InfBus(V_nom=400e3, alpha0=30*d2r)
      annotation (
            extent=[90,-20; 70,0]);
    Spot.Control.Relays.SwitchRelay relay1(t_switch={0.15,0.2})
      annotation (
            extent=[-60,40; -40,60]);
    Spot.Control.Relays.SwitchRelay relay2(t_switch={0.153,0.21})
             annotation (extent=[90,40; 70,60]);
    Spot.ACdqo.Sensors.PVImeter meterL(S_nom=1000e6, V_nom=400e3)
      annotation (
            extent=[-10,-40; 10,-20]);
    Spot.ACdqo.Sensors.PVImeter meterF(S_nom=1000e6, V_nom=400e3)
      annotation (
            extent=[-10,0; 10,20]);
    Spot.Control.Setpoints.Set_w_p_v cst_set
                                       annotation (extent=[-110,-20; -90,0]);
    Spot.ACdqo.Nodes.GroundOne grd2 annotation (extent=[90,-20; 110,0]);
    Data.Lines.OHline400kV OH400kV annotation (extent=[0,80; 40,100]);
    Data.Transformers.TrafoStray trafo20k_400k_YD
      annotation (extent=[-60,80; -20,100]);

    Spot.Common.Thermal.BoundaryV boundary(m=2)
      annotation (extent=[-90,0; -70,20]);
  equation
    connect(relay1.y, switch1.control) annotation (points=[-40,50; -30,50; -30,
          20], style(color=5, rgbcolor={255,0,255}));
    connect(relay2.y, switch2.control) annotation (points=[70,50; 60,50; 60,20],
        style(color=5, rgbcolor={255,0,255}));
    connect(cst_set.setpts, turbGen.setpts) annotation (points=[-90,-10; -90,
          -10], style(color=74, rgbcolor={0,0,127}));
    connect(turbGen.term, trafo.term_p) annotation (points=[-70,-10; -60,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(trafo.term_n, meterL.term_p) annotation (points=[-40,-10; -40,-30;
          -10,-30], style(color=62, rgbcolor={0,110,110}));
    connect(meterL.term_n, line.term_p) annotation (points=[10,-30; 20,-30],
        style(color=62, rgbcolor={0,110,110}));
    connect(line.term_n, InfBus.term) annotation (points=[40,-30; 70,-30; 70,
          -10],         style(color=62, rgbcolor={0,110,110}));
    connect(trafo.term_n, switch1.term_p) annotation (points=[-40,-10; -40,10],
        style(color=62, rgbcolor={0,110,110}));
    connect(switch1.term_n, meterF.term_p) annotation (points=[-20,10; -10,10],
        style(color=62, rgbcolor={0,110,110}));
    connect(meterF.term_n, lineF.term_p) annotation (points=[10,10; 20,10],
        style(color=62, rgbcolor={0,110,110}));
    connect(lineF.term_n, switch2.term_p) annotation (points=[40,10; 50,10],
        style(color=62, rgbcolor={0,110,110}));
    connect(switch2.term_n, InfBus.term) annotation (points=[70,10; 70,-10],
                style(color=62, rgbcolor={0,110,110}));
    connect(lineF.term_f, abc.term) annotation (points=[30,20; 30,40], style(
          color=62, rgbcolor={0,110,110}));
    connect(InfBus.neutral, grd2.term)
      annotation (points=[90,-10; 90,-10], style(color=3, rgbcolor={0,0,255}));
    connect(turbGen.heat, boundary.heat)
      annotation (points=[-80,0; -80,0], style(color=42, rgbcolor={176,0,0}));
  end DoubleRXlineTG;

  model DoublePIlineTG
    "Parallel PI-lines with turbo generator, one line faulted"

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
      Documentation(
              info="<html>
<p>Fault clearance by short-time line switched off.<br>
Compare with DoublePIline.</p>
<p><i>See for example:</i>
<pre>
  meter.p[1:2]     active and reactive power
  line.v           line voltage, oscillations due to switching
  lineF.v          fault line voltage
  abc.i_abc        fault currents
</pre></p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"),
      Diagram,
      Icon,
      experiment(StopTime=0.5, NumberOfIntervals=3400),
      experimentSetupOutput);
    inner Spot.System system
                        annotation (extent=[-100,80; -80,100]);
    Spot.GenerationACdqo.TurboGenerator turbGen(
      p_ini=0.761825,
      alpha_ini=30*d2r,
      redeclare Spot.ACdqo.Machines.Synchron_el generator(par(
          V_nom=20e3,
          S_nom=1000e6,
          If_nom=2000), stIni_en=false) "nth order")
      annotation (extent=[-90,-20; -70,0]);
    Spot.ACdqo.Transformers.TrafoStray trafo(
      par=trafo20k_400k_YD,
      redeclare Spot.ACdqo.Ports.Topology.Delta top_p "Delta",
      redeclare Spot.ACdqo.Ports.Topology.Y top_n "Y")
              annotation (extent=[-60,-20; -40,0]);
    Spot.ACdqo.Lines.PIline line(
      len=480, par=OH_400kV)
      annotation (
            extent=[20,-40; 40,-20]);
    Spot.ACdqo.Breakers.Switch switch1(V_nom=400e3, I_nom=2500)
      annotation (
            extent=[-40,0; -20,20]);
    Spot.ACdqo.Lines.FaultPIline lineF(
      len=430, par=OH_400kV,
      stIni_en=false)
         annotation (extent=[20,0; 40,20]);
    Spot.ACdqo.Breakers.Switch switch2(V_nom=400e3, I_nom=2500)
      annotation (
            extent=[50,0; 70,20]);
    Spot.ACdqo.Faults.Fault_abc abc(epsG=1e-5)
         annotation (extent=[20,40; 40,60]);
    Spot.ACdqo.Sources.InfBus InfBus(V_nom=400e3, alpha0=30*d2r)
      annotation (
            extent=[90,-20; 70,0]);
    Spot.Control.Relays.SwitchRelay relay1(t_switch={0.15,0.2})
      annotation (
            extent=[-60,40; -40,60]);
    Spot.Control.Relays.SwitchRelay relay2(t_switch={0.153,0.21})
             annotation (extent=[90,40; 70,60]);
    Spot.ACdqo.Sensors.PVImeter meterL(S_nom=1000e6, V_nom=400e3)
      annotation (
            extent=[-10,-40; 10,-20]);
    Spot.ACdqo.Sensors.PVImeter meterF(S_nom=1000e6, V_nom=400e3)
      annotation (
            extent=[-10,0; 10,20]);
    Spot.Control.Setpoints.Set_w_p_v cst_set
                                       annotation (extent=[-110,-20; -90,0]);
    Spot.ACdqo.Nodes.GroundOne grd2 annotation (extent=[90,-20; 110,0]);
    Data.Lines.OHline_400kV OH_400kV annotation (extent=[0,80; 40,100]);
    Data.Transformers.TrafoStray trafo20k_400k_YD
      annotation (extent=[-60,80; -20,100]);

    Spot.Common.Thermal.BoundaryV boundary(m=2)
      annotation (extent=[-90,0; -70,20]);
  equation
    connect(relay1.y, switch1.control) annotation (points=[-40,50; -30,50; -30,
          20], style(color=5, rgbcolor={255,0,255}));
    connect(relay2.y, switch2.control) annotation (points=[70,50; 60,50; 60,20],
        style(color=5, rgbcolor={255,0,255}));
    connect(cst_set.setpts, turbGen.setpts) annotation (points=[-90,-10; -90,
          -10], style(color=74, rgbcolor={0,0,127}));
    connect(turbGen.term, trafo.term_p) annotation (points=[-70,-10; -60,-10],
        style(color=62, rgbcolor={0,110,110}));
    connect(trafo.term_n, meterL.term_p) annotation (points=[-40,-10; -40,-30;
          -10,-30], style(color=62, rgbcolor={0,110,110}));
    connect(meterL.term_n, line.term_p) annotation (points=[10,-30; 20,-30],
        style(color=62, rgbcolor={0,110,110}));
    connect(line.term_n, InfBus.term) annotation (points=[40,-30; 70,-30; 70,
          -10],         style(color=62, rgbcolor={0,110,110}));
    connect(trafo.term_n, switch1.term_p) annotation (points=[-40,-10; -40,10],
        style(color=62, rgbcolor={0,110,110}));
    connect(switch1.term_n, meterF.term_p) annotation (points=[-20,10; -10,10],
        style(color=62, rgbcolor={0,110,110}));
    connect(meterF.term_n, lineF.term_p) annotation (points=[10,10; 20,10],
        style(color=62, rgbcolor={0,110,110}));
    connect(lineF.term_n, switch2.term_p) annotation (points=[40,10; 50,10],
        style(color=62, rgbcolor={0,110,110}));
    connect(switch2.term_n, InfBus.term) annotation (points=[70,10; 70,-10],
                style(color=62, rgbcolor={0,110,110}));
    connect(lineF.term_f, abc.term) annotation (points=[30,20; 30,40], style(
          color=62, rgbcolor={0,110,110}));
    connect(InfBus.neutral, grd2.term)
      annotation (points=[90,-10; 90,-10], style(color=3, rgbcolor={0,0,255}));
    connect(turbGen.heat, boundary.heat)
      annotation (points=[-80,0; -80,0], style(color=42, rgbcolor={176,0,0}));
  end DoublePIlineTG;
end h_TransmissionACdqo;
