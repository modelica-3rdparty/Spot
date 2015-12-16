within SpotExamples;
package d_DrivesACabc "AC drives, abc"
  model ASMcharacteristic
    "AC asynchronous machine: torque - slip characteristic"


    inner Spot.System system(sim="st")
    annotation (extent=[-100,80; -80,100]);
    Spot.ACabc.Nodes.GroundOne grd
                                 annotation (extent=[-60,-20; -80,0]);
    Spot.ACabc.Sources.Voltage voltage(V_nom=400)
                                     annotation (extent=[-60,-20; -40,0]);
    Spot.DrivesACabc.ASM asm(
      rotor(J=0.3),
      motor(par=asyn400_30k))             annotation (extent=[-20,-20; 0,0]);
    Spot.Common.Thermal.BdCondV bdCond(m=2)
                                          annotation (extent=[-20,0; 0,20]);
    Spot.Mechanics.Rotation.Speed speed(
    w0=system.omega_nom/2,
    scType=Spot.Base.Types.sig,
    tcst=0.01) annotation (extent=[40,-20; 20,0]);
    Spot.Blocks.Signals.Transient speedSignal(
    t_duration=0.5,
      s_fin=2*system.omega_nom/asm.motor.pp,
      s_ini=-system.omega_nom/asm.motor.pp)
      annotation (extent=[78,-20; 58,0]);
    Data.Machines.Asynchron400V_30kVA asyn400_30k
      annotation (extent=[-60,80; -20,100]);

  equation
    connect(grd.term,voltage. neutral)
                                     annotation (points=[-60,-10; -60,-10],
        style(color=3, rgbcolor={0,0,255}));
    connect(asm.flange,speed. flange)
    annotation (points=[0,-10; 20,-10], style(color=0, rgbcolor={0,0,0}));
    connect(asm.heat,bdCond. heat)
    annotation (points=[-10,0; -10,0], style(color=42, rgbcolor={176,0,0}));
    connect(voltage.term,asm. term)
                                  annotation (points=[-40,-10; -20,-10], style(
        color=62, rgbcolor={0,120,120}));
    connect(speedSignal.y,speed. w)
    annotation (points=[58,-10; 40,-10], style(color=74, rgbcolor={0,0,127}));
    annotation (
  Documentation(
          info="<html>
<p>Steady-state simulation to produce motor characteristic 'torque vs slip'.<br>
<pre>
  asm.torque         motor mechanical torque
  asm.motor.slip     slip (negative: motor, positive: generator mode)

       slip &lt  -1    motor breake mode
  -1 &lt  slip &lt  0     motor drive mode
       slip &gt  0     generator mode
</pre></p>
<p>Plot torque vs slip:<br>
plot 'asm.torque', then right-click 'asm.motor.slip' and choose 'Independent variable': 'asm.motor.slip'.</p>
<p><a href=\"modelica://Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"));
  end ASMcharacteristic;
  extends Spot.Base.Icons.Examples;

  model ASM_Y_D "AC asynchronous machine Y-Delta switcheable"

    inner Spot.System system(ini="tr")
      annotation (extent=[-100,80; -80,100]);
    Spot.ACabc.Nodes.GroundOne grd annotation (extent=[-80,-20; -100,0]);
    Spot.ACabc.Sources.Voltage voltage(V_nom=400, v0=1)
                                        annotation (extent=[-80,-20; -60,0]);
    Spot.ACabc.Sensors.Psensor power
      annotation (extent=[-50,-20; -30,0]);
    Spot.DrivesACabc.ASM_Y_D asm_Y_D(rotor(J=0.3), motor(par=
            asyn400_30k),
      speed_ini=0.1)                        annotation (extent=[-10,-20; 10,0]);
    Spot.Common.Thermal.BdCondV bdCond(m=2) annotation (extent=[-10,0; 10,20]);
    Spot.Mechanics.Rotation.Rotor loadInertia(J=40)
      annotation (extent=[30,-20; 50,0]);
    Spot.Mechanics.Rotation.FrictionTorque frictTorq(cFrict={1,0.05})
      annotation (extent=[70,-20; 90,0]);
    Spot.Control.Relays.Y_DeltaControl relay1(t_switch={1.5})
      annotation (extent=[-50,20; -30,40]);
    SpotExamples.Data.Machines.Asynchron400V_30kVA asyn400_30k
      annotation (extent=[-60,80; -20,100]);

  equation
    connect(relay1.y, asm_Y_D.YDcontrol) annotation (points=[-30,30; -20,30;
          -20,-6; -10,-6],
               style(color=5, rgbcolor={255,0,255}));
    connect(voltage.term, power.term_p) annotation (points=[-60,-10; -50,-10],
        style(color=70, rgbcolor={0,130,175}));
    connect(power.term_n, asm_Y_D.term) annotation (points=[-30,-10; -10,-10],
        style(color=70, rgbcolor={0,130,175}));
    connect(asm_Y_D.flange, loadInertia.flange_p)
      annotation (points=[10,-10; 30,-10],
                                         style(color=0, rgbcolor={0,0,0}));
    connect(loadInertia.flange_n, frictTorq.flange)
      annotation (points=[50,-10; 70,-10],
                                         style(color=0, rgbcolor={0,0,0}));
    connect(grd.term, voltage.neutral)
      annotation (points=[-80,-10; -80,-10],
                                           style(color=3, rgbcolor={0,0,255}));
    connect(asm_Y_D.heat, bdCond.heat) annotation (points=[0,0; 0,0],   style(
        color=42,
        rgbcolor={176,0,0},
        fillColor=84,
        rgbfillColor={213,170,255},
        fillPattern=1));
    annotation (
      Documentation(
              info="<html>
<p>Asynchron machine, Y-Delta switcheable, start-up.</p>
<p><i>See for example:</i>
<pre>
  power.p
  asm_Y_D.motor.slip
  loadInertia.flange_p.tau
  frictTorq.flange.tau
  frictTorq.w
</pre>
Compare 'transient' and 'steady-state' mode.</p>
<p><a href=\"modelica://Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),
      experiment(StopTime=3));
  end ASM_Y_D;

  model ASMav
    "AC asynchronous machine, voltage controlled with average inverter"

    inner Spot.System system
      annotation (extent=[-100,80; -80,100]);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-80,-20; -100,0]);
    Spot.AC1_DC.Sources.DCvoltage voltage(pol=0, V_nom=sqrt(2/3)*6000)
      annotation (extent=[-80,-20; -60,0]);
    Spot.ACabc.Inverters.Select select
      annotation (extent=[-50,20; -30,40]);
    Spot.ACabc.Inverters.InverterAverage inverter(par=idealSC3kV_500A)
                                          annotation (extent=[-50,-20; -30,0]);
    Spot.ACabc.Sensors.Pmeter power(av=true,
      units="SI",
      tcst=0.05)
      annotation (extent=[-10,-20; 10,0]);
    Spot.DrivesACabc.ASM asm(
      rotor(J=6.4),
      motor(par=asyn3k_1p5M),
      speed_ini=1)                          annotation (extent=[30,-20; 50,0]);
    Spot.Common.Thermal.BdCondV bdCond1(m=2)
                                            annotation (extent=[30,0; 50,20]);
    Spot.Common.Thermal.BdCondV bdCond2(m=1)
      annotation (extent=[-50,0; -30,20]);
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
      annotation (extent=[70,-20; 90,0]);
    SpotExamples.Data.Machines.Asynchron3kV_1p5MVA asyn3k_1p5M
      annotation (extent=[-60,80; -20,100]);
    SpotExamples.Data.Semiconductors.IdealSC3kV_500A idealSC3kV_500A
      annotation (extent=[0,80; 40,100]);

  equation
    connect(select.theta_out, inverter.theta) annotation (points=[-46,20; -46,0],
               style(color=74, rgbcolor={0,0,127}));
    connect(select.uPhasor_out, inverter.uPhasor) annotation (points=[-34,20;
          -34,0],  style(color=74, rgbcolor={0,0,127}));
    connect(voltage.term, inverter.DC)
      annotation (points=[-60,-10; -50,-10],
                                           style(color=3, rgbcolor={0,0,255}));
    connect(inverter.AC, power.term_p) annotation (points=[-30,-10; -10,-10],
        style(color=70, rgbcolor={0,130,175}));
    connect(power.term_n, asm.term)
      annotation (points=[10,-10; 30,-10],
                                        style(color=70, rgbcolor={0,130,175}));
    connect(grd.term, voltage.neutral)
      annotation (points=[-80,-10; -80,-10],
                                           style(color=3, rgbcolor={0,0,255}));
    connect(asm.flange, tabLoad.flange_p)
      annotation (points=[50,-10; 70,-10],
                                         style(color=0, rgbcolor={0,0,0}));
    connect(asm.heat, bdCond1.heat)
                                   annotation (points=[40,0; 40,0],   style(
        color=42,
        rgbcolor={176,0,0},
        fillColor=84,
        rgbfillColor={213,170,255},
        fillPattern=1));
    connect(inverter.heat,bdCond2. heat) annotation (points=[-40,0; -40,0],
        style(
        color=42,
        rgbcolor={176,0,0},
        fillColor=84,
        rgbfillColor={213,170,255},
        fillPattern=1));
    annotation (
      Documentation(
              info="<html>
<p>Asynchron machine with load (drive along height-profile), on-load steady-state start.<br>
The model uses a time-average inverter. With the actual parameter values the 'inverter' corresponds exactly to an AC voltage source of 3kV.</p>
<p><i>See for example:</i>
<pre>
  power.p
  asm.motor.slip
  tabLoad.vVehicle
</pre>
Compare 'transient' and 'steady-state' mode.</p>
<p><a href=\"modelica://Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),
      experiment(StopTime=60));
  end ASMav;

  model ASMav_icontrol
    "AC asynchronous machine, current controlled with average inverter"

    inner Spot.System system(ref="synchron")
    annotation (extent=[-100,80; -80,100]);
    Spot.AC1_DC.Nodes.GroundOne grd
                                  annotation (extent=[-40,-40; -60,-20]);
    Spot.AC1_DC.Sources.DCvoltage voltage(pol=0, V_nom=sqrt(2/3)*6000)
    annotation (extent=[-40,-40; -20,-20]);
    Spot.DrivesACabc.ASM_ctrl asm_ctrl(
      rotor(J=0.3),
      rpm_ini=200,
      motor(par=asyn3k_1p5M),
      inverter(par=idealSC3kV_500A))
              annotation (extent=[0,-40; 20,-20]);
    Spot.Common.Thermal.BdCondV bdCond(m=3)
                                          annotation (extent=[0,-20; 20,0]);
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
    annotation (extent=[40,-40; 60,-20]);
    Spot.Blocks.Signals.Transient i_q(s_fin=0.2, s_ini=0)
      "phase of modulation signal"        annotation (extent=[-90,0; -70,20]);
    Spot.Blocks.Signals.Transient i_d(
      s_ini=0.36,
      s_fin=0.36,
      t_change=30,
      t_duration=60) "phase of modulation signal"
                                          annotation (extent=[-70,30; -50,50]);
    Modelica.Blocks.Continuous.LimPID PI_i_q(
      Td=0.1,
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      initType=Modelica.Blocks.Types.Init.SteadyState,
      Ti=0.1)
         annotation (extent=[-50,0; -30,20]);
    SpotExamples.Data.Machines.Asynchron3kV_1p5MVA asyn3k_1p5M
    annotation (extent=[-60,80; -20,100]);
    SpotExamples.Data.Semiconductors.IdealSC3kV_500A idealSC3kV_500A
    annotation (extent=[0,80; 40,100]);

  equation
    connect(grd.term, voltage.neutral)
    annotation (points=[-40,-30; -40,-30],
                                         style(color=3, rgbcolor={0,0,255}));
    connect(voltage.term, asm_ctrl.term)
    annotation (points=[-20,-30; 0,-30], style(color=3, rgbcolor={0,0,255}));
    connect(asm_ctrl.flange, tabLoad.flange_p)
    annotation (points=[20,-30; 40,-30], style(color=0, rgbcolor={0,0,0}));
    connect(i_q.y,PI_i_q. u_s)
                            annotation (points=[-70,10; -52,10], style(color=
          74, rgbcolor={0,0,127}));
    connect(i_d.y, asm_ctrl.i_act[1])     annotation (points=[-50,40; 16,40; 16,
          -19.5],  style(color=74, rgbcolor={0,0,127}));
    connect(asm_ctrl.i_meas[2], PI_i_q.u_m)
                                          annotation (points=[4,-19.5; 4,-12;
          -40,-12; -40,-2],
                 style(color=74, rgbcolor={0,0,127}));
    connect(PI_i_q.y, asm_ctrl.i_act[2])
                                       annotation (points=[-29,10; 16,10; 16,
          -20.5],
               style(color=74, rgbcolor={0,0,127}));
    connect(asm_ctrl.heat, bdCond.heat)
    annotation (points=[10,-20; 10,-20],
                                     style(color=42, rgbcolor={176,0,0}));
  annotation (
    Documentation(
            info="<html>
<p>Current (torque) controlled asynchron machine with load (drive along height-profile), steady-state start, torque-increase after start.<br>
The model uses a time-average inverter. For comparison with the previous example 'ASMav'.</p>
<p><i>See for example:</i>
<pre>
  asm.motor.tau_el
  tabLoad.vVehicle
</pre>
Compare 'transient' and 'steady-state' mode.</p>
<p><a href=\"modelica://Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"),
    experiment(
      StopTime=60,
      NumberOfIntervals=1357,
      Tolerance=1e-006));
  end ASMav_icontrol;

  model ASM "AC asynchronous machine, voltage controlled"

    inner Spot.System system(ini="tr", ref="inertial")
      annotation (extent=[-100,80; -80,100]);
    Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-80,-20; -100,0]);
    Spot.AC1_DC.Sources.DCvoltage voltage(pol=0, V_nom=sqrt(2/3)*6000)
      annotation (extent=[-80,-20; -60,0]);
    Spot.ACabc.Inverters.Select select
      annotation (extent=[-50,20; -30,40]);
    Spot.ACabc.Inverters.Inverter inverter
                                          annotation (extent=[-50,-20; -30,0]);
    Spot.ACabc.Sensors.PVImeter power(
      av=true,
      units="SI",
      tcst=0.05,
      abc=true)
      annotation (extent=[-10,-20; 10,0]);
    Spot.DrivesACabc.ASM asm(
      rotor(J=6.4),
      speed_ini=1,
      motor(par=asyn3k_1p5M))               annotation (extent=[30,-20; 50,0]);
    Spot.Common.Thermal.BdCondV bdCond1(m=2)
                                            annotation (extent=[30,0; 50,20]);
    Spot.Common.Thermal.BdCondV bdCond2(m=3)
      annotation (extent=[-50,0; -30,20]);
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
      annotation (extent=[70,-20; 90,0]);
    SpotExamples.Data.Machines.Asynchron3kV_1p5MVA asyn3k_1p5M
      annotation (extent=[-60,80; -20,100]);
    SpotExamples.Data.Semiconductors.IdealSC3kV_500A idealSC3kV_500A
      annotation (extent=[0,80; 40,100]);

  equation
    connect(select.theta_out, inverter.theta) annotation (points=[-46,20; -46,0],
               style(color=74, rgbcolor={0,0,127}));
    connect(select.uPhasor_out, inverter.uPhasor) annotation (points=[-34,20;
          -34,0],  style(color=74, rgbcolor={0,0,127}));
    connect(voltage.term, inverter.DC)
      annotation (points=[-60,-10; -50,-10],
                                           style(color=3, rgbcolor={0,0,255}));
    connect(inverter.AC, power.term_p) annotation (points=[-30,-10; -10,-10],
        style(color=70, rgbcolor={0,130,175}));
    connect(power.term_n, asm.term)
      annotation (points=[10,-10; 30,-10],
                                        style(color=70, rgbcolor={0,130,175}));
    connect(grd.term, voltage.neutral)
      annotation (points=[-80,-10; -80,-10],
                                           style(color=3, rgbcolor={0,0,255}));
    connect(asm.flange, tabLoad.flange_p)
      annotation (points=[50,-10; 70,-10],
                                         style(color=0, rgbcolor={0,0,0}));
    connect(asm.heat, bdCond1.heat)
                                   annotation (points=[40,0; 40,0],   style(
        color=42,
        rgbcolor={176,0,0},
        fillColor=84,
        rgbfillColor={213,170,255},
        fillPattern=1));
    connect(inverter.heat,bdCond2. heat) annotation (points=[-40,0; -40,0],
        style(
        color=42,
        rgbcolor={176,0,0},
        fillColor=84,
        rgbfillColor={213,170,255},
        fillPattern=1));
    annotation (
      Documentation(
              info="<html>
<p>Asynchron machine with load (drive along height-profile), on-load transient start.<br>
The machine defines the reference-system independent of the system choice (as needed for example in hardware-in-the-loop simulation). This model uses a switched inverter.</p>
<p><i>See for example:</i>
<pre>
  power.p_av        time-average power
  time_av.y         time-average pu stator currents
  asm.motor.tau_el  electric torque
</pre></p>
<p><a href=\"modelica://Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"),
      experiment(Tolerance=1e-005, Algorithm="Lsodar"),
      experimentSetupOutput(
        derivatives=false,
        auxiliaries=false,
        events=false));
  end ASM;

model SM_ctrlAv
    "AC synchronous pm machine, current controlled with average inverter"

  inner Spot.System system
  annotation (extent=[-100,80; -80,100]);
  Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-40,-40; -60,-20]);
  Spot.AC1_DC.Sources.DCvoltage voltage(pol=0, V_nom=sqrt(2/3)*2*400)
                                    annotation (extent=[-40,-40; -20,-20]);
  Spot.DrivesACabc.SM_ctrl sm_ctrl(
      rotor(J=0.3),
      motor(par=syn3rdpm400_30k),
      inverter(par=idealSC1k_100),
      rpm_ini=0.5)
              annotation (extent=[0,-40; 20,-20]);
  Spot.Common.Thermal.BdCondV bdCond(m=3)   annotation (extent=[0,-20; 20,0]);
  Spot.Mechanics.Rotation.Rotor loadInertia(J=0.5)
  annotation (extent=[40,-40; 60,-20]);
  Spot.Mechanics.Rotation.FrictionTorque frictTorq(cFrict={0.1,0.01})
    annotation (extent=[80,-40; 100,-20]);
  Modelica.Mechanics.Rotational.TorqueStep torqueStep(
    offsetTorque=0,
      startTime=6,
      stepTorque=-100)
              annotation (extent=[100,0; 80,20]);
  Spot.Blocks.Signals.Transient i_q(
      t_change=3, s_ini=0.1) "phase of modulation signal"
                                          annotation (extent=[-100,10; -80,30]);
  Spot.Blocks.Signals.Transient i_d(
      t_change=3,
      s_ini=0,
      s_fin=0) "phase of modulation signal"
                                          annotation (extent=[-80,40; -60,60]);
  Modelica.Blocks.Continuous.LimPID PI_i_q(
      Ti=0.2,
      Td=0.1,
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      initType=Modelica.Blocks.Types.Init.SteadyState)
         annotation (extent=[-60,10; -40,30]);
  SpotExamples.Data.Machines.Synchron3rd_pm400V_30kVA syn3rdpm400_30k
      annotation (extent=[-60,80; -20,100]);
  SpotExamples.Data.Semiconductors.IdealSC1kV_100A idealSC1k_100
      annotation (extent=[0,80; 40,100]);

equation
  connect(grd.term, voltage.neutral)
      annotation (points=[-40,-30; -40,-30],
                                           style(color=3, rgbcolor={0,0,255}));
  connect(sm_ctrl.heat, bdCond.heat)    annotation (points=[10,-20; 10,-20],
                                                                         style(
        color=42,
        rgbcolor={176,0,0},
        fillColor=84,
        rgbfillColor={213,170,255},
        fillPattern=1));
  connect(sm_ctrl.flange, loadInertia.flange_p)
      annotation (points=[20,-30; 40,-30], style(color=0, rgbcolor={0,0,0}));
  connect(loadInertia.flange_n, frictTorq.flange)
      annotation (points=[60,-30; 80,-30], style(color=0, rgbcolor={0,0,0}));
  connect(loadInertia.flange_n, torqueStep.flange) annotation (points=[60,-30;
          70,-30; 70,10; 80,10], style(color=0, rgbcolor={0,0,0}));
  connect(i_q.y, PI_i_q.u_s)
                            annotation (points=[-80,20; -62,20], style(color=
          74, rgbcolor={0,0,127}));
  connect(voltage.term, sm_ctrl.term)
      annotation (points=[-20,-30; 0,-30], style(color=3, rgbcolor={0,0,255}));
  connect(sm_ctrl.i_meas[2], PI_i_q.u_m)          annotation (points=[4,-19.5; 4,0;
          -50,0; -50,8], style(color=74, rgbcolor={0,0,127}));
  connect(PI_i_q.y, sm_ctrl.i_act[2])          annotation (points=[-39,20; 16,
          20; 16,-20.5], style(color=74, rgbcolor={0,0,127}));
  connect(i_d.y, sm_ctrl.i_act[1])          annotation (points=[-60,50; 16,50;
          16,-19.5], style(color=74, rgbcolor={0,0,127}));
annotation (
  Documentation(
          info="<html>
<p>Field oriented control of pm synchronous machine with time-average inverter. The first component of i_dq controls 'field', the second controls 'torque' at constant 'field'.<br>
For pm machine (psi_pm &gt  0, x_d = x_q) i_d can be set to zero. For reluctance machines (psi_pm = 0, x_d &gt  x_q) i_d must have a positive value.</p>
On-load steady-state start with torque-increase at 3 s and load-step 6 s.</p>
<p><i>See for example:</i>
<pre>
  sm_ctrl.motor.tau_el
  loadInertia.flange_p.tau
  sm_ctrl.motor.w_el
  loadInertia.w
</pre></p>
<p><a href=\"modelica://Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"),
  experiment(StopTime=10));
end SM_ctrlAv;

model SM_ctrl "AC synchronous pm machine, current controlled"

  inner Spot.System system(ini="tr")
  annotation (extent=[-100,80; -80,100]);
  Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-40,-40; -60,-20]);
  Spot.AC1_DC.Sources.DCvoltage voltage(pol=0, V_nom=sqrt(2/3)*2*400)
                                    annotation (extent=[-40,-40; -20,-20]);
  Spot.DrivesACabc.SM_ctrl sm_ctrl(
      rotor(J=0.3),
      motor(par=syn3rdpm400_30k),
      redeclare Spot.ACabc.Inverters.Inverter inverter(redeclare
          Spot.ACabc.Inverters.Components.InverterEquation inverter(par=
              idealSC1k_100) "equation, with losses") "inverter with modulator")
              annotation (extent=[0,-40; 20,-20]);
  Spot.Common.Thermal.BdCondV bdCond(m=5)   annotation (extent=[0,-20; 20,0]);
  Spot.Mechanics.Rotation.Rotor loadInertia(J=0.5)
  annotation (extent=[40,-40; 60,-20]);
  Spot.Mechanics.Rotation.FrictionTorque frictTorq(cFrict={0.1,0.01})
    annotation (extent=[80,-40; 100,-20]);
  Modelica.Mechanics.Rotational.TorqueStep torqueStep(
    offsetTorque=0,
      stepTorque=-100,
    startTime=2)
              annotation (extent=[100,0; 80,20]);
  Spot.Blocks.Signals.Transient i_q(s_ini=0.1) "phase of modulation signal"
                                          annotation (extent=[-100,10; -80,30]);
  Spot.Blocks.Signals.Transient i_d(
      s_ini=0,
      s_fin=0) "phase of modulation signal"
                                          annotation (extent=[-80,40; -60,60]);
  Modelica.Blocks.Continuous.LimPID PI_i_q(
      Ti=0.2,
      Td=0.1,
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      initType=Modelica.Blocks.Types.Init.InitialState,
      xi_start=0.1)
         annotation (extent=[-60,10; -40,30]);
  SpotExamples.Data.Machines.Synchron3rd_pm400V_30kVA syn3rdpm400_30k(r_n=0)
      annotation (extent=[-60,80; -20,100]);
  SpotExamples.Data.Semiconductors.IdealSC1kV_100A idealSC1k_100
      annotation (extent=[0,80; 40,100]);

equation
  connect(grd.term, voltage.neutral)
      annotation (points=[-40,-30; -40,-30],
                                           style(color=3, rgbcolor={0,0,255}));
  connect(sm_ctrl.heat, bdCond.heat)    annotation (points=[10,-20; 10,-20],
                                                                         style(
        color=42,
        rgbcolor={176,0,0},
        fillColor=84,
        rgbfillColor={213,170,255},
        fillPattern=1));
  connect(sm_ctrl.flange, loadInertia.flange_p)
      annotation (points=[20,-30; 40,-30], style(color=0, rgbcolor={0,0,0}));
  connect(loadInertia.flange_n, frictTorq.flange)
      annotation (points=[60,-30; 80,-30], style(color=0, rgbcolor={0,0,0}));
  connect(loadInertia.flange_n, torqueStep.flange) annotation (points=[60,-30;
          70,-30; 70,10; 80,10], style(color=0, rgbcolor={0,0,0}));
  connect(i_q.y, PI_i_q.u_s)
                            annotation (points=[-80,20; -62,20], style(color=
          74, rgbcolor={0,0,127}));
  connect(voltage.term, sm_ctrl.term)
      annotation (points=[-20,-30; 0,-30], style(color=3, rgbcolor={0,0,255}));
  connect(sm_ctrl.i_meas[2], PI_i_q.u_m)          annotation (points=[4,-19.5; 4,0;
          -50,0; -50,8], style(color=74, rgbcolor={0,0,127}));
  connect(PI_i_q.y, sm_ctrl.i_act[2])          annotation (points=[-39,20; 16,
          20; 16,-20.5], style(color=74, rgbcolor={0,0,127}));
  connect(i_d.y, sm_ctrl.i_act[1])          annotation (points=[-60,50; 16,50;
          16,-19.5], style(color=74, rgbcolor={0,0,127}));
annotation (
  Documentation(
          info="<html>
<p>Field oriented control of pm synchronous machine with modulated inverter. The first component of i_dq controls 'field', the second controls 'torque' at constant 'field'.<br>
For pm machine (psi_pm &gt  0, x_d = x_q) i_d can be set to zero. For reluctance machines (psi_pm = 0, x_d &gt  x_q) i_d must have a positive value.</p>
Transient start with torque-increase at 0.5 s and load-step 2 s.</p>
<p><i>See for example:</i>
<pre>
  sm_ctrl.motor.tau_el
  loadInertia.flange_p.tau
  sm_ctrl.motor.w_el
  loadInertia.w
</pre></p>
<p><a href=\"modelica://Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"),
  experiment(
        StopTime=3,
        Tolerance=1e-005,
        Algorithm="Lsodar"),
  experimentSetupOutput(
        derivatives=false,
        inputs=false,
        events=false));
end SM_ctrl;

model ASM_ctrlAv
    "AC asynchronous machine, current controlled with average inverter"

  inner Spot.System system
  annotation (extent=[-100,80; -80,100]);
  Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-40,-40; -60,-20]);
  Spot.AC1_DC.Sources.DCvoltage voltage(pol=0, V_nom=sqrt(2/3)*2*400)
                                    annotation (extent=[-40,-40; -20,-20]);
  Spot.DrivesACabc.ASM_ctrl asm_ctrl(
    rotor(J=0.3),
    inverter(par=idealSC1k_100),
    motor(par=asyn400_30k),
    rpm_ini=200)
              annotation (extent=[0,-40; 20,-20]);
  Spot.Common.Thermal.BdCondV bdCond(m=3) annotation (extent=[0,-20; 20,0]);
  Spot.Mechanics.Rotation.Rotor loadInertia(J=0.5)
  annotation (extent=[40,-40; 60,-20]);
  Spot.Mechanics.Rotation.FrictionTorque frictTorq(cFrict={5,0.5})
    annotation (extent=[80,-40; 100,-20]);
  Modelica.Mechanics.Rotational.TorqueStep torqueStep(
    offsetTorque=0,
    startTime=6,
    stepTorque=-200)
              annotation (extent=[100,0; 80,20]);
  Spot.Blocks.Signals.Transient i_q(t_change=3,
    s_fin=0.7,
    s_ini=0.6) "phase of modulation signal"
                                          annotation (extent=[-100,10; -80,30]);
  Spot.Blocks.Signals.Transient i_d(
    t_change=8,
    s_fin=0.45,
    s_ini=0.35) "phase of modulation signal"
                                          annotation (extent=[-80,40; -60,60]);
  Modelica.Blocks.Continuous.LimPID PI_i_q(
    Td=0.1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    Ti=0.1)
         annotation (extent=[-60,10; -40,30]);
  SpotExamples.Data.Machines.Asynchron400V_30kVA asyn400_30k
    annotation (extent=[-60,80; -20,100]);
  SpotExamples.Data.Semiconductors.IdealSC1kV_100A idealSC1k_100
    annotation (extent=[0,80; 40,100]);

equation
  connect(asm_ctrl.heat, bdCond.heat) annotation (points=[10,-20; 10,-20],
                                                                       style(
      color=42,
      rgbcolor={176,0,0},
      fillColor=84,
      rgbfillColor={213,170,255},
      fillPattern=1));
  connect(grd.term, voltage.neutral) annotation (points=[-40,-30; -40,-30],
      style(color=3, rgbcolor={0,0,255}));
  connect(i_q.y, PI_i_q.u_s)
                            annotation (points=[-80,20; -62,20], style(color=
          74, rgbcolor={0,0,127}));
  connect(asm_ctrl.flange, loadInertia.flange_p)
    annotation (points=[20,-30; 40,-30], style(color=0, rgbcolor={0,0,0}));
  connect(loadInertia.flange_n, frictTorq.flange)
    annotation (points=[60,-30; 80,-30], style(color=0, rgbcolor={0,0,0}));
  connect(loadInertia.flange_n, torqueStep.flange) annotation (points=[60,-30;
        70,-30; 70,10; 80,10], style(color=0, rgbcolor={0,0,0}));
  connect(voltage.term, asm_ctrl.term)
    annotation (points=[-20,-30; 0,-30], style(color=3, rgbcolor={0,0,255}));
  connect(asm_ctrl.i_meas[2], PI_i_q.u_m)       annotation (points=[4,-19.5; 4,0;
        -50,0; -50,8], style(color=74, rgbcolor={0,0,127}));
  connect(PI_i_q.y, asm_ctrl.i_act[2])       annotation (points=[-39,20; 16,
        20; 16,-20.5], style(color=74, rgbcolor={0,0,127}));
  connect(i_d.y, asm_ctrl.i_act[1])       annotation (points=[-60,50; 16,50;
        16,-19.5], style(color=74, rgbcolor={0,0,127}));
annotation (
  Documentation(
          info="<html>
<p>Field oriented control of asynchronous machine with time-average inverter. The first component of i_dq controls 'field', the second controls 'torque' at constant 'field'.</p>
On-load steady-state start with torque-increase at 3 s, load-step 6 s and field-increase at 8 s.</p>
<p><i>See for example:</i>
<pre>
  asm_ctrl.motor.tau_el
  asm_ctrl.motor.w_el
  asm_ctrl.motor.uPhasor
  asm_ctrl.motor.slip
</pre></p>
Check uPhasor[1] &lt  1.<br>The time-average inverter produces a desired voltage proportional to uPhasor[1] even if uPhasor[1] &gt  1. For a time-resolved converter this corresponds to overmodulation.
<p><a href=\"modelica://Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"),
  experiment(
      StopTime=10,
      fixedstepsize=0.001,
      Algorithm="Dassl"));
end ASM_ctrlAv;

model ASM_ctrl "AC asynchronous machine, current controlled"

  inner Spot.System system(ini="tr", ref="inertial")
  annotation (extent=[-100,80; -80,100]);
  Spot.AC1_DC.Nodes.GroundOne grd annotation (extent=[-40,-40; -60,-20]);
  Spot.AC1_DC.Sources.DCvoltage voltage(pol=0, V_nom=sqrt(2/3)*2*400)
                                    annotation (extent=[-40,-40; -20,-20]);
  Spot.DrivesACabc.ASM_ctrl asm_ctrl(
    rotor(J=0.3),
    motor(par=asyn400_30k),
    rpm_ini=200,
    redeclare Spot.ACabc.Inverters.Inverter inverter(redeclare
          Spot.ACabc.Inverters.Components.InverterSwitch inverter
          "switch, no diode, no losses") "inverter with modulator")
              annotation (extent=[0,-40; 20,-20]);
  Spot.Common.Thermal.BdCondV bdCond(m=5) annotation (extent=[0,-20; 20,0]);
  Spot.Mechanics.Rotation.Rotor loadInertia(J=0.5)
  annotation (extent=[40,-40; 60,-20]);
  Spot.Mechanics.Rotation.FrictionTorque frictTorq(cFrict={5,0.5})
    annotation (extent=[80,-40; 100,-20]);
  Modelica.Mechanics.Rotational.TorqueStep torqueStep(
    offsetTorque=0,
    startTime=2,
    stepTorque=-200)
              annotation (extent=[100,0; 80,20]);
  Spot.Blocks.Signals.Transient i_q(s_ini=0.6, s_fin=0.7)
      "phase of modulation signal"        annotation (extent=[-100,10; -80,30]);
  Modelica.Blocks.Continuous.LimPID PI_i_q(
    Td=0.05,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=0.1)
         annotation (extent=[-60,10; -40,30]);
  Spot.Blocks.Signals.Transient i_d(
    s_fin=0.45,
    t_change=2.5,
    t_duration=0.5,
    s_ini=0.35) "phase of modulation signal"
                                          annotation (extent=[-80,40; -60,60]);
  SpotExamples.Data.Machines.Asynchron400V_30kVA asyn400_30k(r_n=0)
    annotation (extent=[-60,80; -20,100]);
  SpotExamples.Data.Semiconductors.IdealSC1kV_100A idealSC1k_100
    annotation (extent=[0,80; 40,100]);

equation
  connect(asm_ctrl.heat, bdCond.heat) annotation (points=[10,-20; 10,-20],
                                                                       style(
      color=42,
      rgbcolor={176,0,0},
      fillColor=84,
      rgbfillColor={213,170,255},
      fillPattern=1));
  connect(grd.term, voltage.neutral) annotation (points=[-40,-30; -40,-30],
      style(color=3, rgbcolor={0,0,255}));
  connect(i_q.y, PI_i_q.u_s)
                          annotation (points=[-80,20; -62,20], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=68,
      rgbfillColor={170,213,255},
      fillPattern=1));
  connect(asm_ctrl.flange, loadInertia.flange_p)
    annotation (points=[20,-30; 40,-30], style(color=0, rgbcolor={0,0,0}));
  connect(loadInertia.flange_n, frictTorq.flange)
    annotation (points=[60,-30; 80,-30], style(color=0, rgbcolor={0,0,0}));
  connect(loadInertia.flange_n, torqueStep.flange) annotation (points=[60,-30;
        70,-30; 70,10; 80,10], style(color=0, rgbcolor={0,0,0}));
  connect(voltage.term, asm_ctrl.term)
    annotation (points=[-20,-30; 0,-30], style(color=3, rgbcolor={0,0,255}));
  connect(asm_ctrl.i_meas[2], PI_i_q.u_m)       annotation (points=[4,-19.5; 4,0;
        -50,0; -50,8], style(color=74, rgbcolor={0,0,127}));
  connect(PI_i_q.y, asm_ctrl.i_act[2])       annotation (points=[-39,20; 16,
        20; 16,-20.5], style(color=74, rgbcolor={0,0,127}));
  connect(i_d.y, asm_ctrl.i_act[1])       annotation (points=[-60,50; 16,50;
        16,-19.5], style(color=74, rgbcolor={0,0,127}));
annotation (
  Documentation(
          info="<html>
<p>Field oriented control of asynchronous machine with modulated inverter. The first component of i_dq controls 'field', the second controls 'torque' at constant 'field'.</p>
Transient start with torque-increase at 0.5 s, load-step 2 s and field-increase at 2.5 s.</p>
<p><i>See for example:</i>
<pre>
  asm_ctrl.motor.tau_el
  asm_ctrl.motor.w_el
  asm_ctrl.motor.uPhasor
  asm_ctrl.motor.slip
</pre></p>
<p><a href=\"modelica://Spot.UsersGuide.Examples\">up users guide</a></p>
</html>"),
  experiment(
      StopTime=3,
      Tolerance=1e-005,
      Algorithm="Lsodar"),
  experimentSetupOutput(
      derivatives=false,
      inputs=false,
      events=false));
end ASM_ctrl;
  annotation (preferredView="info",
Documentation(info="<html>
<p>AC drives (motors electrical and mechanical). Electric motor terminal in abc-representation.</p>
<p><a href=\"modelica://Spot.UsersGuide.Examples\">up users guide</a></p>
</html>
"));
end d_DrivesACabc;
