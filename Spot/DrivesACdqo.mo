within Spot;
package DrivesACdqo "AC-drives dqo"
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
<p>Contains both electrical and mechanical parts of AC-drives, dqo-representation.</p>
<p>Heat ports must be connected. In cases where they are not needed, use 'Common.Thermal.BdCond(V)'.</p><p><a <p><a href=\"Spot.UsersGuide.Overview\">up users guide</a></p>
</html>
"), Icon,
    uses(Spot(version="0.702"), Modelica(version="2.2.1")));

  model ASM "Asynchronous machine with cage rotor"

    parameter Spot.Base.Types.AngularVelocity speed_ini(unit="pu")=0
      "initial speed (start-value if ini='st')"
      annotation(Dialog(enable=not system.steadyIni));
    extends Partials.DriveBase(rotor(
                               w(      start=speed_ini*2*pi*motor.par.f_nom/2)));
    replaceable Spot.ACdqo.Machines.Asynchron motor(final w_el_ini=speed_ini*2*pi*motor.par.f_nom)
      "asyn motor"
      annotation (extent=[-40,-10; -20,10]);
    annotation (defaultComponentName = "asm",
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
<p>Complete ASM drive.</p>
<p>Note: for machines with gear <tt>w_ini</tt> denotes the initial angular velocity at the generator-side!</p>
</html>"),
      Icon(
  Text(
    extent=[-60,20; 80,-20],
    style(color=10),
          string="asyn")),
      Diagram);

  equation
    connect(motor.heat, heat) annotation (points=[-30,10; -30,40; 0,40; 0,100],
        style(color=42, rgbcolor={176,0,0}));
    connect(motor.airgap, rotor.rotor)
      annotation (points=[-30,6; 10,6], style(color=0, rgbcolor={0,0,0}));
    connect(term, motor.term) annotation (points=[-100,0; -40,0], style(color=
            62, rgbcolor={0,120,120}));
  end ASM;

  model ASM_Y_D "Asynchronous machine with cage rotor, Y-Delta switcheable"

    parameter Spot.Base.Types.AngularVelocity speed_ini(unit="pu")=0
      "initial speed (start-value if ini='st')"
      annotation(Dialog(enable=not system.steadyIni));
    extends Partials.DriveBase;
    replaceable Spot.ACdqo.Machines.AsynchronY_D motor(final w_el_ini=speed_ini*2*pi*motor.par.f_nom)
      "asyn motor Y-Delta switcheable"
      annotation (extent=[-40,-10; -20,10]);
    input Modelica.Blocks.Interfaces.BooleanInput YDcontrol
      "true:Y, false:Delta"
      annotation (extent=[-110,30; -90,50],rotation=0);
    annotation (defaultComponentName = "asm_Y_D",
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
<p>Complete ASM drive with switcheable Y-Delta topology.</p>
<p>Note: for machines with gear <tt>w_ini</tt> denotes the initial angular velocity at the generator-side!</p>
</html>"),
      Icon(
  Text(
    extent=[-60,20; 80,-20],
    style(color=10),
          string="asynY-D")),
      Diagram(Text(
          extent=[-100,90; -10,80],
          style(color=5, rgbcolor={255,0,255}),
          string="switcheable Y - Delta topology"),
              Text(
          extent=[-90,68; -30,60],
          style(color=5, rgbcolor={255,0,255}),
          string="true: Y     false: Delta")));

  equation
    connect(YDcontrol, motor.YDcontrol) annotation (points=[-100,40; -60,40;
          -60,6; -40,6],   style(color=5, rgbcolor={255,0,255}));
    connect(motor.heat, heat) annotation (points=[-30,10; -30,40; 0,40; 0,100],
                  style(color=42, rgbcolor={176,0,0}));
    connect(motor.airgap, rotor.rotor)
      annotation (points=[-30,6; 10,6], style(color=0, rgbcolor={0,0,0}));
    connect(term, motor.term) annotation (points=[-100,0; -40,0], style(color=
            62, rgbcolor={0,120,120}));
  end ASM_Y_D;

  model ASM_ctrl "Asynchronous machine, current-control"

    parameter SIpu.AngularVelocity_rpm rpm_ini=0
      "initial rpm (start-value if ini='st')"
      annotation(Dialog(enable=not system.steadyIni));
    extends Partials.DriveBase_ctrl(heat_adapt(final m={2,inverter.heat.m}));
    replaceable ACdqo.Inverters.InverterAverage inverter
      extends ACdqo.Inverters.Partials.AC_DC_base
      "inverter (average or modulated)"           annotation (extent=[-80,-10; -60,10], choices(
      choice(redeclare Spot.ACdqo.Inverters.InverterAverage inverter(final
              autosyn=false) "inverter time-average"),
      choice(redeclare Spot.ACdqo.Inverters.Inverter inverter(final autosyn=false)
            "inverter with modulator")));
    replaceable ACdqo.Machines.Asynchron_ctrl motor(
      final w_el_ini=rpm_ini*Base.Types.rpm2w*motor.par.pp)
      "asyn motor, current controlled"
      annotation (extent=[-40,-10; -20,10],choices(
      choice(redeclare Spot.ACdqo.Machines.Synchron3rd_ctrl motor
            "synchron 3rd order"),
      choice(redeclare Spot.ACdqo.Machines.Synchron_ctrl motor
            "synchron general")));

      annotation (
      defaultComponentName="sm_ctrlAv",
      Diagram,
      Icon(
  Text(
    extent=[-60,20; 80,-20],
    style(color=10),
          string="asyn")),
      Documentation(info="<html>
<p>Complete ASM drive with inverter and motor for field oriented current control.</p>
<p>Note: for machines with gear <tt>w_ini</tt> denotes the initial angular velocity at the generator-side!</p>
</html>"));

  equation
    connect(motor.airgap, rotor.rotor)
      annotation (points=[-30,6; 10,6], style(color=0, rgbcolor={0,0,0}));
    connect(term, inverter.DC)
      annotation (points=[-100,0; -80,0], style(color=3, rgbcolor={0,0,255}));
    connect(inverter.AC, motor.term)
      annotation (points=[-60,0; -40,0], style(color=62, rgbcolor={0,120,120}));
    connect(motor.heat, heat_adapt.port_a) annotation (points=[-30,10; -30,54;
          4,54; 4,64],
               style(color=42, rgbcolor={176,0,0}));
    connect(inverter.heat, heat_adapt.port_b) annotation (points=[-70,10; -70,
          64; -4,64],  style(color=42, rgbcolor={176,0,0}));
    connect(motor.uPhasor, inverter.uPhasor)
      annotation (points=[-40,10; -64,10], style(color=74, rgbcolor={0,0,127}));
    connect(motor.i_meas, i_meas)       annotation (points=[-36,10; -36,40; -60,40;
          -60,100], style(color=74, rgbcolor={0,0,127}));
    connect(i_act, motor.i_act)       annotation (points=[60,100; 60,40; -24,40;
          -24,10], style(color=74, rgbcolor={0,0,127}));
    connect(motor.phiRotorflux, inverter.theta) annotation (points=[-20,10; -16,
          10; -16,20; -84,20; -84,10; -76,10], style(color=74, rgbcolor={0,0,
            127}));
  end ASM_ctrl;

  model SM_el "Synchronous machine, electric excitation"

    parameter Spot.Base.Types.AngularVelocity speed_ini(unit="pu")=0
      "initial speed (start-value if ini='st')"
      annotation(Dialog(enable=not system.steadyIni));
    extends Partials.DriveBase;
    replaceable Spot.ACdqo.Machines.Control.Excitation excitation
      "excitation model"                annotation (extent=[-70,20; -50,40]);
    replaceable Spot.ACdqo.Machines.Synchron3rd_el motor(final w_el_ini=speed_ini*2*pi*motor.par.f_nom)
      "syn motor"
      annotation (extent=[-40,-10; -20,10],choices(
      choice(redeclare Spot.ACdqo.Machines.Synchron3rd_el motor
            "synchron 3rd order"),
      choice(redeclare Spot.ACdqo.Machines.Synchron_el motor "synchron general")));
    Modelica.Blocks.Interfaces.RealInput fieldVoltage(redeclare type SignalType
        = SIpu.Voltage, final unit="pu")
      "field voltage pu from exciter control"
      annotation (extent=[50,90; 70,110], rotation=-90);
    Modelica.Blocks.Interfaces.RealOutput[3] termVoltage(redeclare type
        SignalType = SIpu.Voltage, final unit="pu")
      "terminal voltage pu to exciter control"
      annotation (extent=[-70,90; -50,110], rotation=90);
    annotation (defaultComponentName = "sm_el",
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
<p>Complete SM drive with electrically excited motor.</p>
<p>Note: for machines with gear <tt>w_ini</tt> denotes the initial angular velocity at the generator-side!</p>
</html>"),
      Icon(
      Line(points=[-90,-10; -60,-10], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=67,
          rgbfillColor={85,255,255},
          fillPattern=1)),
      Line(points=[-90,10; -60,10], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=67,
          rgbfillColor={85,255,255},
          fillPattern=1)),
  Text(
    extent=[-60,20; 80,-20],
    style(color=10),
          string="syn")),
      Diagram);

  equation
    connect(fieldVoltage, excitation.fieldVoltage)
                                                  annotation (points=[60,100;
          60,60; -54,60; -54,40],
                               style(color=74, rgbcolor={0,0,127}));
    connect(excitation.term, motor.term) annotation (points=[-70,30; -80,30;
          -80,0; -40,0],
                     style(color=62, rgbcolor={0,120,120}));
    connect(excitation.field, motor.field) annotation (points=[-70,26; -70,-4;
          -40,-4],         style(color=3, rgbcolor={0,0,255}));
    connect(term, motor.term)
      annotation (points=[-100,0; -40,0], style(color=62, rgbcolor={0,120,120}));
    connect(motor.airgap, rotor.rotor)
      annotation (points=[-30,6; 10,6], style(color=0, rgbcolor={0,0,0}));
    connect(motor.heat, heat) annotation (points=[-30,10; -30,40; 0,40; 0,100],
        style(color=42, rgbcolor={176,0,0}));
    connect(excitation.termVoltage, termVoltage) annotation (points=[-66,40;
          -66,60; -60,60; -60,100], style(color=74, rgbcolor={0,0,127}));
  end SM_el;

  model SM_ctrl "Synchronous machine, current-control"

    parameter SIpu.AngularVelocity_rpm rpm_ini=0
      "initial rpm (start-value if ini='st')"
      annotation(Dialog(enable=not system.steadyIni));
    extends Partials.DriveBase_ctrl(heat_adapt(final m={2,inverter.heat.m}));
    replaceable ACdqo.Inverters.InverterAverage inverter
      extends ACdqo.Inverters.Partials.AC_DC_base
      "inverter (average or modulated)" annotation (extent=[-80,-10; -60,10], choices(
      choice(redeclare Spot.ACdqo.Inverters.InverterAverage inverter
            "inverter time-average"),
      choice(redeclare Spot.ACdqo.Inverters.Inverter inverter
            "inverter with modulator")));
    replaceable ACdqo.Machines.Synchron3rd_ctrl motor(
      final w_el_ini=rpm_ini*Base.Types.rpm2w*motor.par.pp)
      "syn motor, current controlled"
      annotation (extent=[-40,-10; -20,10],choices(
      choice(redeclare Spot.ACdqo.Machines.Synchron3rd_ctrl motor
            "synchron 3rd order"),
      choice(redeclare Spot.ACdqo.Machines.Synchron_ctrl motor
            "synchron general")));

      annotation (
      defaultComponentName="sm_ctrl",
      Diagram,
      Icon(
  Text(
    extent=[-60,20; 80,-20],
    style(color=10),
          string="syn"),
      Rectangle(extent=[-60,-26; 80,-30], style(
          color=42,
          rgbcolor={176,0,0},
          fillColor=42,
          rgbfillColor={176,0,0},
          fillPattern=1)),
      Rectangle(extent=[-60,30; 80,26],   style(
          color=42,
          rgbcolor={176,0,0},
          fillColor=42,
          rgbfillColor={176,0,0},
          fillPattern=1))),
      Documentation(info="<html>
<p>Complete SM drive with inverter and motor for field oriented current control.</p>
<p>Note: for machines with gear <tt>w_ini</tt> denotes the initial angular velocity at the generator-side!</p>
</html>"));

  equation
    connect(motor.airgap, rotor.rotor)
      annotation (points=[-30,6; 10,6], style(color=0, rgbcolor={0,0,0}));
    connect(term, inverter.DC)
      annotation (points=[-100,0; -80,0], style(color=3, rgbcolor={0,0,255}));
    connect(inverter.AC, motor.term)
      annotation (points=[-60,0; -40,0], style(color=62, rgbcolor={0,120,120}));
    connect(motor.heat, heat_adapt.port_a) annotation (points=[-30,10; -30,54; 4,
          54; 4,64],
               style(color=42, rgbcolor={176,0,0}));
    connect(inverter.heat, heat_adapt.port_b) annotation (points=[-70,10; -70,64;
          -4,64],      style(color=42, rgbcolor={176,0,0}));
    connect(motor.phiRotor, inverter.theta)   annotation (points=[-20,10; -16,10;
          -16,20; -84,20; -84,10; -76,10], style(color=74, rgbcolor={0,0,127}));
    connect(motor.uPhasor, inverter.uPhasor)
      annotation (points=[-40,10; -64,10], style(color=74, rgbcolor={0,0,127}));
    connect(motor.i_meas, i_meas)       annotation (points=[-36,10; -36,40; -60,
          40; -60,100], style(color=74, rgbcolor={0,0,127}));
    connect(i_act, motor.i_act)       annotation (points=[60,100; 60,40; -24,40;
          -24,10], style(color=74, rgbcolor={0,0,127}));
  end SM_ctrl;

  package Partials "Partial models"
  partial model DriveBase0 "AC drives base mechanical"

    Spot.Base.Interfaces.Rotation_n flange "mechanical flange"
      annotation (extent=[90, -10; 110, 10]);
    replaceable Spot.Mechanics.Rotation.ElectricRotor rotor "machine rotor"
      annotation (extent=[0,-10; 20,10]);
    replaceable Spot.Mechanics.Rotation.NoGear gear "type of gear"
      annotation (extent=[40,-10; 60,10],                                                                                    choices(
        choice(redeclare Spot.Mechanics.Rotation.Joint gear "no gear"),
        choice(redeclare Spot.Mechanics.Rotation.GearNoMass gear
              "massless gear"),
        choice(redeclare Spot.Mechanics.Rotation.Gear gear "massive gear")));
    Spot.Base.Interfaces.ThermalV_n heat(m=2)
        "heat source port {stator, rotor}"
      annotation (extent=[-10,90; 10,110], rotation=90);
    protected
    outer Spot.System system;
    annotation (
  Coordsys(
    extent=
   [-100, -100; 100, 100],
    grid=[2,2],
    component=[40,40]),
  Icon(
    Rectangle(extent=[-90,80; 90,-80], style(
        color=10,
        rgbcolor={95,95,95},
        fillColor=56,
        rgbfillColor={184,189,116})),
    Rectangle(
      extent=[80,10; 100,-10],style(
        color=0,
        rgbcolor={0,0,0},
        gradient=2,
        fillColor=30,
        rgbfillColor={235,235,235})),
    Rectangle(extent=[-60,60; 80,40], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
        Rectangle(extent=[-60,30; 80,-30], style(
        color=0,
        rgbcolor={0,0,0},
        gradient=2,
        fillColor=30,
        rgbfillColor={215,215,215})),
    Rectangle(extent=[-60,-40; 80,-60], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
       Text(
      extent=[-100,-90; 100,-130],
      style(color=0),
            string="%name"),          Rectangle(extent=[-60,40; 80,30], style(
          color=47,
          rgbcolor={255,170,85},
          fillColor=47,
          rgbfillColor={255,170,85})),Rectangle(extent=[-60,-30; 80,-40],
          style(
          color=47,
          rgbcolor={255,170,85},
          fillColor=47,
          rgbfillColor={255,170,85}))),
  Window(
    x=0.41,
        y=0.01,
        width=
  0.6,
    height=
   0.6),
  Diagram(Text(
      extent=[-100,-60; 100,-80],
      string=
          "stator reaction torque- and friction-models may be added here",
      style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175},
        fillPattern=1))),
  Documentation(info="<html>
</html>"));

  equation
    connect(rotor.flange_n, gear.flange_p)
      annotation (points=[20,0; 40,0], style(color=0, rgbcolor={0,0,0}));
    connect(gear.flange_n, flange)
      annotation (points=[60,0; 100,0], style(color=0, rgbcolor={0,0,0}));
  end DriveBase0;
    extends Base.Icons.Partials;

    annotation (
          Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]), Window(
  x=0.05,
  y=0.44,
  width=0.31,
  height=0.23,
  library=1,
  autolayout=1));

  partial model DriveBase "AC drives base"
    extends DriveBase0;

    Spot.Base.Interfaces.ACdqo_p term "electric terminal"
                            annotation (extent=[-110,-10; -90,10]);

    annotation (
  Coordsys(
    extent=
   [-100, -100; 100, 100],
    grid=[2,2],
    component=[40,40]),
  Icon(
    Rectangle(extent=[-90,80; 90,-80], style(
        color=10,
        rgbcolor={95,95,95},
        fillColor=56,
        rgbfillColor={184,189,116})),
    Rectangle(
      extent=[80,10; 100,-10],style(
        color=0,
        rgbcolor={0,0,0},
        gradient=2,
        fillColor=30,
        rgbfillColor={235,235,235})),
    Rectangle(extent=[-60,60; 80,40], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
        Rectangle(extent=[-60,30; 80,-30], style(
        color=0,
        rgbcolor={0,0,0},
        gradient=2,
        fillColor=30,
        rgbfillColor={215,215,215})),
    Rectangle(extent=[-60,-40; 80,-60], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
       Text(
      extent=[-100,-90; 100,-130],
      style(color=0),
            string="%name"),          Rectangle(extent=[-60,40; 80,30], style(
          color=47,
          rgbcolor={255,170,85},
          fillColor=47,
          rgbfillColor={255,170,85})),Rectangle(extent=[-60,-30; 80,-40],
          style(
          color=47,
          rgbcolor={255,170,85},
          fillColor=47,
          rgbfillColor={255,170,85}))),
  Window(
    x=0.41,
        y=0.01,
        width=
  0.6,
    height=
   0.6),
  Diagram(Text(
      extent=[-100,-60; 100,-80],
      string=
          "stator reaction torque- and friction-models may be added here",
      style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175},
        fillPattern=1))),
  Documentation(info="<html>
</html>"));
  end DriveBase;

  partial model DriveBase_ctrl "AC drives base control"
    extends DriveBase0(heat(final m=sum(heat_adapt.m)),
      rotor(w(start=rpm_ini*Base.Types.rpm2w)));

    parameter SIpu.AngularVelocity_rpm rpm_ini=0
        "initial rpm (start-value if ini='st')"
      annotation(Dialog(enable=not system.steadyIni));
    Spot.Base.Interfaces.ElectricV_p term(final m=2) "electric terminal DC"
                            annotation (extent=[-110, -10; -90, 10]);
    Modelica.Blocks.Interfaces.RealOutput[2] i_meas(redeclare type SignalType
          =
          SIpu.Current, final unit="pu") "measured current {i_d, i_q} pu"
      annotation (extent=[-70,90; -50,110],  rotation=90);
    Modelica.Blocks.Interfaces.RealInput[2] i_act(redeclare type SignalType =
          SIpu.Current, final unit="pu") "actuated current {i_d, i_q} pu"
      annotation (extent=[50,110; 70,90],    rotation=90);
    protected
    Common.Thermal.HeatV_a_b_ab heat_adapt annotation (extent=[10,60; -10,80]);

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
</html>"),
    Icon(
        Rectangle(extent=[-90,112; 90,88], style(
            color=74,
            rgbcolor={0,0,127},
            fillColor=68,
            rgbfillColor={170,213,255}))),
    Diagram);
  equation
    connect(heat_adapt.port_ab, heat)
      annotation (points=[0,76; 0,100], style(color=42, rgbcolor={176,0,0}));
  end DriveBase_ctrl;

  end Partials;

end DrivesACdqo;
