within SpotExamples;
package d_DrivesDC "DC drives"
  extends Spot.Base.Icons.Examples;

  model DCmotor_ser "DC motor series excited"

    inner Spot.System system(ref="inertial")
    annotation (extent=[-100,80; -80,100]);
    Spot.Blocks.Signals.Transient ramp(
      t_change=0,
      t_duration=10)
    annotation (extent=[-80,10; -60,30]);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-60,-20; -80,0]);
    Spot.AC1_DC.Sources.DCvoltage voltage(V_nom=1500, scType=Spot.Base.Types.sig)
                                      annotation (extent=[-60,-20; -40,0]);
    Spot.AC1_DC.Sensors.Psensor power      annotation (extent=[-20,-20; 0,0]);
    Spot.DrivesDC.DCMser dcm_ser(
      rotor(J=6.4),
      motor(par=DCs1500_1p5M),
      rpm_ini=1400)                       annotation (extent=[20,-20; 40,0]);
    Spot.Common.Thermal.BdCondV bdCond(m=2) annotation (extent=[20,0; 40,20]);
    Spot.Mechanics.Rotation.TabPosSlopeTorque tabLoad(
      r=0.4,
      gRatio=40/17,
      cFrict={50,15},
      mass=200e3,
      scale=true,
      D=1.5,
      slope_perc=2.5,
      tableName="height",
      fileName=TableDir + "hNormProfile.tab",
      colData=3)
    annotation (extent=[60,-20; 80,0]);
    SpotExamples.Data.Machines.DCser1500V_1p5MVA DCs1500_1p5M
      annotation (extent=[-60,80; -20,100]);

  equation
    connect(voltage.term, power.term_p)
    annotation (points=[-40,-10; -20,-10],
                                         style(color=3, rgbcolor={0,0,255}));
    connect(power.term_n,dcm_ser. term)
    annotation (points=[0,-10; 20,-10],style(color=3, rgbcolor={0,0,255}));
    connect(grd.term, voltage.neutral) annotation (points=[-60,-10; -60,-10],
        style(color=3, rgbcolor={0,0,255}));
    connect(dcm_ser.flange, tabLoad.flange_p)
      annotation (points=[40,-10; 60,-10], style(color=0, rgbcolor={0,0,0}));
    connect(dcm_ser.heat, bdCond.heat) annotation (points=[30,0; 30,0], style(
        color=42,
        rgbcolor={176,0,0},
        fillColor=84,
        rgbfillColor={213,170,255},
        fillPattern=1));
    connect(ramp.y, voltage.vDC) annotation (points=[-60,20; -44,20; -44,0],
        style(color=74, rgbcolor={0,0,127}));
  annotation (
    Documentation(
            info="<html>
<p>DC machine (series-connected) with load (drive along height-profile).</p>
<p><i>See for example:</i>
<pre>
  power.p
  tabLoad.vVehicle
</pre></p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),
    experiment(StopTime=60));
  end DCmotor_ser;

  model DCmotor_par "DC motor parallel excited"

    inner Spot.System system(ref="inertial")
    annotation (extent=[-100,80; -80,100]);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-60,-20; -80,0]);
    Spot.AC1_DC.Sources.DCvoltage armVoltage(      V_nom=1500, scType=Spot.Base.Types.
          par)                        annotation (extent=[-60,-20; -40,0]);
    Spot.AC1_DC.Sensors.Psensor power      annotation (extent=[-20,-20; 0,0]);
    Spot.AC1_DC.Sources.DCvoltage excVoltage(      V_nom=1500, scType=Spot.Base.Types.
          par)                        annotation (extent=[-60,-60; -40,-40]);
    Spot.DrivesDC.DCMpar dcm_par(
      rotor(J=6.4),
      motor(par=DCp1500_1p5M))             annotation (extent=[20,-20; 40,0]);
    Spot.Common.Thermal.BdCondV bdCond(m=2) annotation (extent=[20,0; 40,20]);
    Spot.Mechanics.Rotation.TabPosSlopeTorque tabLoad(
      r=0.4,
      gRatio=40/17,
      scale=true,
      D=1.5,
      tableName="height",
      fileName=TableDir + "hNormProfile.tab",
      colData=3,
      mass=200e3,
      slope_perc=2.5,
      cFrict={50,15})
    annotation (extent=[60,-20; 80,0]);
    SpotExamples.Data.Machines.DCpar1500V_1p5MVA DCp1500_1p5M
      annotation (extent=[-60,80; -20,100]);

  equation
    connect(armVoltage.term, power.term_p) annotation (points=[-40,-10; -20,-10],
        style(color=3, rgbcolor={0,0,255}));
    connect(power.term_n, dcm_par.term)
      annotation (points=[0,-10; 20,-10], style(color=3, rgbcolor={0,0,255}));
    connect(excVoltage.term, dcm_par.field) annotation (points=[-40,-50; 10,-50;
          10,-14; 20,-14],
                         style(color=3, rgbcolor={0,0,255}));
    connect(grd.term, armVoltage.neutral) annotation (points=[-60,-10; -60,-10],
        style(color=3, rgbcolor={0,0,255}));
    connect(excVoltage.neutral, armVoltage.neutral) annotation (points=[-60,-50;
          -60,-10], style(color=3, rgbcolor={0,0,255}));
    connect(dcm_par.flange, tabLoad.flange_p)
      annotation (points=[40,-10; 60,-10], style(color=0, rgbcolor={0,0,0}));
    connect(dcm_par.heat, bdCond.heat) annotation (points=[30,0; 30,0], style(
        color=42,
        rgbcolor={176,0,0},
        fillColor=84,
        rgbfillColor={213,170,255},
        fillPattern=1));
  annotation (
    Documentation(
            info="<html>
<p>DC machine (parallel-connected) with load (drive along height-profile).</p>
<p><i>See for example:</i>
<pre>
  power.p
  tabLoad.vVehicle
</pre></p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"),
    experiment(StopTime=60));
  end DCmotor_par;

  model DCmotor_pm "DC motor permanent magnet excited"

    inner Spot.System system(ref="inertial", ini="tr")
    annotation (extent=[-100,80; -80,100]);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-80,-20; -100,0]);
    Spot.AC1_DC.Sources.DCvoltage voltage(V_nom=100)
                                      annotation (extent=[-80,-20; -60,0]);
    Spot.AC1_DC.Sensors.Psensor power annotation (extent=[-50,-20; -30,0]);
    Spot.AC1_DC.Sensors.Efficiency efficiency(tcst=0.1, m=2)
      annotation (extent=[-20,-20; 0,0]);
    Spot.DrivesDC.DCMpm dcm_pm(rotor(J=0.02), motor(par=DCpm100_1k))
                                          annotation (extent=[10,-20; 30,0]);
    Spot.Mechanics.Rotation.Rotor loadInertia(J=0.03)
    annotation (extent=[40,-20; 60,0]);
    Spot.Mechanics.Rotation.FrictionTorque frictTorq(cFrict={0.01,0.0002})
      annotation (extent=[70,-20; 90,0]);
    Modelica.Mechanics.Rotational.TorqueStep torqueStep(
      stepTorque=-10,
      startTime=1.5)
                annotation (extent=[90,20; 70,40]);
    SpotExamples.Data.Machines.DCpm100V_1kVA DCpm100_1k
                                           annotation (extent=[-60,80; -20,100]);

  equation
    connect(grd.term, voltage.neutral) annotation (points=[-80,-10; -80,-10], style(
          color=3, rgbcolor={0,0,255}));
    connect(voltage.term, power.term_p) annotation (points=[-60,-10; -50,-10],
        style(color=3, rgbcolor={0,0,255}));
    connect(power.term_n, efficiency.term_p) annotation (points=[-30,-10; -20,
          -10], style(color=3, rgbcolor={0,0,255}));
    connect(efficiency.term_n, dcm_pm.term)
      annotation (points=[0,-10; 10,-10], style(color=3, rgbcolor={0,0,255}));
    connect(dcm_pm.flange, loadInertia.flange_p)
      annotation (points=[30,-10; 40,-10], style(color=0, rgbcolor={0,0,0}));
    connect(loadInertia.flange_n, frictTorq.flange)
      annotation (points=[60,-10; 70,-10], style(color=0, rgbcolor={0,0,0}));
    connect(loadInertia.flange_n, torqueStep.flange) annotation (points=[60,-10;
          64,-10; 64,30; 70,30], style(color=0, rgbcolor={0,0,0}));
    connect(dcm_pm.heat, efficiency.heat) annotation (points=[20,0; 20,10; -10,
          10; -10,0], style(color=42, rgbcolor={176,0,0}));
  annotation (
    Documentation(
            info="<html>
<p>DC machine (permanent magnet) start-up and step-load.</p>
<p><i>See for example:</i>
<pre>
  power.p                      dc power
  loadInertia.w                angular velocity load
  loadInertia.flange_p.tau     torque on load
  efficiency.eta               efficiency
</pre></p>
<p>See also example DCcharSpeed.</p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),
    experiment(StopTime=3));
  end DCmotor_pm;

  model BLDC "Brushless DC motor"

    inner Spot.System system(f_nom=60,
      ini="tr",
      ref="inertial")
    annotation (extent=[-100,80; -80,100]);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-80,-20; -100,0]);
    Spot.AC1_DC.Sources.DCvoltage voltage(           pol=0, V_nom=100)
                                      annotation (extent=[-80,-20; -60,0]);
    Spot.AC1_DC.Sensors.Psensor power annotation (extent=[-50,-20; -30,0]);
    Spot.AC1_DC.Sensors.Efficiency efficiency(
      av=true,
      tcst=0.1,
      m=5)      annotation (extent=[-20,-20; 0,0]);
    Spot.DrivesDC.BLDC bldcm(
      motor(par=bldc100_1k),
      rotor(J=0.02),
      redeclare Spot.ACdqo.Inverters.Inverter inverter(redeclare final
          Spot.Control.Modulation.BlockM modulator "block modulation (no PWM)",
          redeclare Spot.ACdqo.Inverters.Components.InverterSwitch inverter
          "switch, no diode, no losses") "inverter with modulator")
                             annotation (extent=[10,-20; 30,0]);
    Spot.Mechanics.Rotation.Rotor loadInertia(J=0.03)
    annotation (extent=[40,-20; 60,0]);
    Spot.Mechanics.Rotation.FrictionTorque frictTorq(cFrict={0.01,0.0002})
      annotation (extent=[70,-20; 90,0]);
    Modelica.Mechanics.Rotational.TorqueStep torqueStep(
      startTime=1.5, stepTorque=-10)
                annotation (extent=[90,20; 70,40]);
    SpotExamples.Data.Machines.BLDC100V_1kVA bldc100_1k
                                           annotation (extent=[-60,80; -20,100]);
    SpotExamples.Data.Semiconductors.IdealSC100V_10A idealSC100V_10A
      annotation (extent=[0,80; 40,100]);

  equation
    connect(grd.term, voltage.neutral) annotation (points=[-80,-10; -80,-10],
        style(color=3, rgbcolor={0,0,255}));
    connect(bldcm.heat, efficiency.heat) annotation (points=[20,0; 20,10; -10,
          10; -10,0], style(color=42, rgbcolor={176,0,0}));
    connect(voltage.term, power.term_p) annotation (points=[-60,-10; -50,-10],
        style(color=3, rgbcolor={0,0,255}));
    connect(power.term_n, efficiency.term_p) annotation (points=[-30,-10; -20,
          -10], style(color=3, rgbcolor={0,0,255}));
    connect(efficiency.term_n, bldcm.term)
      annotation (points=[0,-10; 10,-10], style(color=3, rgbcolor={0,0,255}));
    connect(bldcm.flange, loadInertia.flange_p)
      annotation (points=[30,-10; 40,-10], style(color=0, rgbcolor={0,0,0}));
    connect(loadInertia.flange_n, frictTorq.flange)
      annotation (points=[60,-10; 70,-10], style(color=0, rgbcolor={0,0,0}));
    connect(loadInertia.flange_n, torqueStep.flange) annotation (points=[60,-10;
          64,-10; 64,30; 70,30], style(color=0, rgbcolor={0,0,0}));
  annotation (
    Documentation(
            info="<html>
<p>Brushless DC machine (permanent magnet synchronous machine) start-up and step-load.</p>
<p><i>See for example:</i>
<pre>
  power.p                      dc power
  loadInertia.w                angular velocity load
  loadInertia.flange_p.tau     torque on load
  efficiency.eta               efficiency including semiconductor losses
</pre></p>
<p>See also example BLDCcharSpeed.</p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),
    experiment(
        StopTime=3,
        Tolerance=1e-005,
        Algorithm="Dassl"),
    experimentSetupOutput(events=false));
  end BLDC;

  model DCcharSpeed "DC pm: torque - speed characteristic"

    inner Spot.System system(f_nom=60, sim="st")
    annotation (extent=[-100,80; -80,100]);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-80,-20; -100,0]);
    Spot.AC1_DC.Sources.DCvoltage voltage(           pol=0, V_nom=100)
                                      annotation (extent=[-80,-20; -60,0]);
    Spot.AC1_DC.Sensors.Efficiency efficiency(
      av=true,
      tcst=0.1,
      m=2)      annotation (extent=[-40,-20; -20,0]);
    Spot.DrivesDC.DCMpm machine(rotor(J=0.02), motor(par=DCpm100_1k))
                                          annotation (extent=[0,-20; 20,0]);
    Spot.Blocks.Signals.Transient speedSignal(
      s_ini=0, s_fin=160)
      annotation (extent=[100,-20; 80,0]);
    Spot.Mechanics.Rotation.Speed speed(tcst=0.01,
      w0=100,
      scType=Spot.Base.Types.sig)
      annotation (extent=[60,-20; 40,0]);
    SpotExamples.Data.Machines.DCpm100V_1kVA DCpm100_1k
                                           annotation (extent=[-60,80; -20,100]);

  equation
    connect(grd.term, voltage.neutral) annotation (points=[-80,-10; -80,-10],
        style(color=3, rgbcolor={0,0,255}));
    connect(speedSignal.y, speed.w) annotation (points=[80,-10; 60,-10], style(
          color=74, rgbcolor={0,0,127}));
    connect(voltage.term, efficiency.term_p) annotation (points=[-60,-10; -40,
          -10], style(color=3, rgbcolor={0,0,255}));
    connect(efficiency.term_n, machine.term)
      annotation (points=[-20,-10; 0,-10], style(color=3, rgbcolor={0,0,255}));
    connect(machine.flange, speed.flange)
      annotation (points=[20,-10; 40,-10], style(color=0, rgbcolor={0,0,0}));
    connect(machine.heat, efficiency.heat) annotation (points=[10,0; 10,10; -30,
          10; -30,0], style(color=42, rgbcolor={176,0,0}));
  annotation (
    Documentation(
            info="<html>
<p>DC machine (permanent magnet) torque-speed characteristic.</p>
<p></p>
<p><i>See for example as a function of phase:</i>
<pre>
  efficiency.eta          efficiency
  machine.motor.w_el       angular velocity (el)
  machine.motor.tau_el     torque (el)
</pre>
(right click dcm_pm.motor.w_el and choose Independent variable: w_el).</p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"),
    experiment(Tolerance=1e-005, Algorithm="Dassl"),
    experimentSetupOutput(events=false));
  end DCcharSpeed;

  model BLDCcharSpeed "BLDC: torque - speed characteristic"

    inner Spot.System system(f_nom=60, sim="st")
    annotation (extent=[-100,80; -80,100]);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-80,-20; -100,0]);
    Spot.AC1_DC.Sources.DCvoltage voltage(V_nom=100, pol=0)
                                      annotation (extent=[-80,-20; -60,0]);
    Spot.AC1_DC.Sensors.Efficiency efficiency(
      tcst=0.1, m=3)
                annotation (extent=[-40,-20; -20,0]);
    Spot.DrivesDC.BLDC machine(
      rotor(J=0.02),
      motor(par=bldc100_1k),
      redeclare Spot.ACdqo.Inverters.InverterAverage inverter(final modulation=
            3, par=idealSC100V_10A) "inverter time-average")
                             annotation (extent=[0,-20; 20,0]);
    Spot.Blocks.Signals.Transient speedSignal(
      s_ini=0, s_fin=160)
      annotation (extent=[100,-20; 80,0]);
    Spot.Mechanics.Rotation.Speed speed(tcst=0.01, scType=Spot.Base.Types.sig)
      annotation (extent=[60,-20; 40,0]);
    SpotExamples.Data.Machines.BLDC100V_1kVA bldc100_1k
                                           annotation (extent=[-60,80; -20,100]);
    SpotExamples.Data.Semiconductors.IdealSC100V_10A idealSC100V_10A
      annotation (extent=[0,80; 40,100]);

  equation
    connect(grd.term, voltage.neutral) annotation (points=[-80,-10; -80,-10],
        style(color=3, rgbcolor={0,0,255}));
    connect(voltage.term, efficiency.term_p) annotation (points=[-60,-10; -40,
          -10], style(color=3, rgbcolor={0,0,255}));
    connect(machine.heat, efficiency.heat)
                                         annotation (points=[10,0; 10,10; -30,
          10; -30,0], style(color=42, rgbcolor={176,0,0}));
    connect(efficiency.term_n, machine.term)
      annotation (points=[-20,-10; 0,-10], style(color=3, rgbcolor={0,0,255}));
    connect(machine.flange, speed.flange)
      annotation (points=[20,-10; 40,-10], style(color=0, rgbcolor={0,0,0}));
    connect(speedSignal.y, speed.w) annotation (points=[80,-10; 60,-10], style(
          color=74, rgbcolor={0,0,127}));
  annotation (
    Documentation(
            info="<html>
<p>Brushless DC machine (permanent magnet synchronous machine) torque-speed characteristic.</p>
<p>This example uses rectangular modulation with constant voltage amplitude and width=2/3, corresponding to 2 phases on, 1 phase off (no additional PWM).</p>
<p><i>See for example as a function of phase:</i>
<pre>
  efficiency.eta          efficiency
  machine.motor.w_el       angular velocity (el)
  machine.motor.tau_el     torque (el)
</pre>
(right click dcm_pm.motor.w_el and choose Independent variable: w_el).</p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"),
    experiment(Tolerance=1e-005, Algorithm="Dassl"),
    experimentSetupOutput(events=false));
  end BLDCcharSpeed;

  annotation (preferredView="info",
Documentation(info="<html>
<p>DC drives (motors electrical and mechanical).</p>
<p><a href=\"Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"));
end d_DrivesDC;
