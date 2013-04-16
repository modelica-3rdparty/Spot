package DrivesDC "DC-drives"
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
<p>Contains both electrical and mechanical parts of DC-drives.</p>
<p>Heat ports must be connected. In cases where they are not needed, use 'Common.Thermal.BdCond(V)'.</p><p><a <p><a href=\"Spot.UsersGuide.Overview\">up users guide</a></p>
</html>
"), Icon,
    uses(Spot(version="0.702"), Modelica(version="2.2.1")));

  model DCMser "DC machine, series connected"
    extends Partials.DriveBase(heat(final m=2));

    replaceable Spot.AC1_DC.Machines.DCser motor(w_el_ini=rpm_ini*Base.Types.rpm2w*motor.par.pp)
      "DC motor series"                   annotation (extent=[-40,-10; -20,10]);
  annotation (defaultComponentName = "dcm_ser",
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
<p>Complete DC drive series connected.</p>
<p>Note: for machines with gear <tt>w_ini</tt> denotes the initial angular velocity at the generator-side!</p>
</html>"),
    Icon(
        Text(
  extent=[-60,20; 80,-20],
  style(color=10),
        string="DC ser"),
      Line(points=[-90,-10; -60,-10], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=67,
          rgbfillColor={85,255,255},
          fillPattern=1)),
      Line(points=[-90,10; -80,10; -80,50; -60,50], style(color=3, rgbcolor={
              0,0,255})),
        Line(points=[-60,10; -70,10; -70,-6], style(color=3, rgbcolor={0,0,255})),
        Line(points=[-70,-14; -70,-50; -60,-50], style(color=3, rgbcolor={0,0,
                255}))),
    Diagram);

  equation
    connect(motor.heat, heat) annotation (points=[-30,10; -30,40; 0,40; 0,100],
        style(color=42, rgbcolor={176,0,0}));
    connect(motor.airgap, rotor.rotor)
      annotation (points=[-30,6; 10,6], style(color=0, rgbcolor={0,0,0}));
    connect(term, motor.term)
      annotation (points=[-100,0; -40,0], style(color=3, rgbcolor={0,0,255}));
  end DCMser;

  model DCMpar "DC machine, parallel connected"
    extends Partials.DriveBase(heat(final m=2));

    replaceable Spot.AC1_DC.Machines.DCpar motor(w_el_ini=rpm_ini*Base.Types.rpm2w*motor.par.pp)
      "DC motor parallel"                 annotation (extent=[-40,-10; -20,10]);
    Spot.Base.Interfaces.ElectricV_p field(final m=2)
      annotation (extent=[-110,-50; -90,-30],
                                            rotation=0);
  annotation (defaultComponentName = "dcm_par",
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
<p>Complete DC drive parallel connected.</p>
<p>Note: for machines with gear <tt>w_ini</tt> denotes the initial angular velocity at the generator-side!</p>
</html>"),
    Icon(
      Line(points=[-90,10; -60,10], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=67,
          rgbfillColor={85,255,255},
          fillPattern=1)),
      Line(points=[-90,-10; -60,-10], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=67,
          rgbfillColor={85,255,255},
          fillPattern=1)),
        Text(
  extent=[-60,20; 80,-20],
  style(color=10),
        string="DC par"),
        Line(points=[-90,-50; -60,-50], style(color=3, rgbcolor={0,0,255})),
        Line(points=[-60,50; -68,50; -68,14], style(color=3, rgbcolor={0,0,255})),
        Line(points=[-68,-14; -68,-30; -90,-30], style(color=3, rgbcolor={0,0,
                255}))),
    Diagram);

  equation
    connect(motor.heat, heat) annotation (points=[-30,10; -30,40; 0,40; 0,100],
        style(color=42, rgbcolor={176,0,0}));
    connect(motor.airgap, rotor.rotor)
      annotation (points=[-30,6; 10,6], style(color=0, rgbcolor={0,0,0}));
    connect(term, motor.term)
      annotation (points=[-100,0; -40,0], style(color=3, rgbcolor={0,0,255}));
    connect(field, motor.field) annotation (points=[-100,-40; -60,-40; -60,-4;
          -40,-4], style(color=3, rgbcolor={0,0,255}));
  end DCMpar;

  model DCMpm "DC machine, permanent magnet"
    extends Partials.DriveBase(heat(final m=2));

    replaceable Spot.AC1_DC.Machines.DCpm motor(w_el_ini=rpm_ini*Base.Types.rpm2w*motor.par.pp)
      "DC motor magnet"               annotation (extent=[-40,-10; -20,10]);
  annotation (defaultComponentName = "dcm_pm",
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
<p>Complete DC drive permanent magnet excited.</p>
<p>Note: for machines with gear <tt>w_ini</tt> denotes the initial angular velocity at the generator-side!</p>
</html>"),
    Icon(
        Text(
  extent=[-60,20; 80,-20],
  style(color=10),
        string="DC pm"),
      Line(points=[-90,10; -60,10], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=67,
          rgbfillColor={85,255,255},
          fillPattern=1)),
      Line(points=[-90,-10; -60,-10], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=67,
          rgbfillColor={85,255,255},
          fillPattern=1)),
      Rectangle(extent=[-60,44; 80,40],   style(
          color=42,
          rgbcolor={176,0,0},
          fillColor=42,
          rgbfillColor={176,0,0},
          fillPattern=1)),
      Rectangle(extent=[-60,-40; 80,-44], style(
          color=42,
          rgbcolor={176,0,0},
          fillColor=42,
          rgbfillColor={176,0,0},
          fillPattern=1))),
    Diagram);

  equation
    connect(motor.heat, heat) annotation (points=[-30,10; -30,40; 0,40; 0,100],
        style(color=42, rgbcolor={176,0,0}));
    connect(motor.airgap, rotor.rotor)
      annotation (points=[-30,6; 10,6], style(color=0, rgbcolor={0,0,0}));
    connect(term, motor.term)
      annotation (points=[-100,0; -40,0], style(color=3, rgbcolor={0,0,255}));
  end DCMpm;

  model BLDC "BLDC machine"
    extends Partials.DriveBase(heat(final m=sum(heat_adapt.m)));

    replaceable ACdqo.Inverters.InverterAverage inverter(modulation=3)
      extends ACdqo.Inverters.Partials.AC_DC_base
      "inverter (average or modulated)"           annotation (extent=[-80,-10; -60,10], choices(
      choice(redeclare Spot.ACdqo.Inverters.InverterAverage inverter(final
              modulation=3) "inverter time-average"),
      choice(redeclare Spot.ACdqo.Inverters.Inverter inverter(redeclare final
              Spot.Control.Modulation.BlockM modulator
              "block modulation (no PWM)") "inverter with modulator")));
    replaceable Partials.Synchron3rd_bldc motor(
      w_el_ini=rpm_ini*Base.Types.rpm2w*motor.par.pp)
      "BLDC motor (syn pm machine)"
      annotation (extent=[-40,-10; -20,10],choices(
      choice(redeclare Spot.ACdqo.Machines.Synchron3rd_bldc motor
            "synchron 3rd order")));
    Common.Thermal.HeatV_a_b_ab heat_adapt(final m={2,inverter.heat.m})
      annotation (extent=[10,60; -10,80]);

  annotation (defaultComponentName = "bldcm",
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
<p>Complete brushless DC drive with inverter.</p>
<p>For block (rectangular) non-pulsed modulation the input to uPhasor[1] is arbitrary and has no influence.</p>
<p>For pulsed rectangles uPhasor[1] can be used<br>
a) to simulate time-average voltage amplitudes.<br>
b) to determine the ratio of on- to off-time when using a pulsed modulator.<br>
where 0 &lt  uPhasor[1] &lt  1.</p>
<p>The rectangle width is a parameter with default value 2/3, corresponding to '2 phases on, 1 phase off' at a time.</p>
<p>Note: for machines with gear <tt>w_ini</tt> denotes the initial angular velocity at the generator-side!</p>
</html>"),
    Icon(
      Rectangle(extent=[-60,30; 80,26],   style(
          color=42,
          rgbcolor={176,0,0},
          fillColor=42,
          rgbfillColor={176,0,0},
          fillPattern=1)),
      Rectangle(extent=[-60,-26; 80,-30], style(
          color=42,
          rgbcolor={176,0,0},
          fillColor=42,
          rgbfillColor={176,0,0},
          fillPattern=1)),
        Text(
  extent=[-60,20; 80,-20],
  style(color=10),
          string="BLDC")),
    Diagram);

  equation
    connect(motor.heat, heat_adapt.port_a) annotation (points=[-30,10; -30,54;
          4,54; 4,64],
                  style(color=42, rgbcolor={176,0,0}));
    connect(inverter.heat, heat_adapt.port_b) annotation (points=[-70,10; -70,
          64; -4,64],      style(color=42, rgbcolor={176,0,0}));
    connect(heat_adapt.port_ab, heat)
      annotation (points=[0,76; 0,100], style(color=42, rgbcolor={176,0,0}));
    connect(motor.airgap, rotor.rotor)
      annotation (points=[-30,6; 10,6], style(color=0, rgbcolor={0,0,0}));
    connect(term, inverter.DC)
      annotation (points=[-100,0; -80,0], style(color=3, rgbcolor={0,0,255}));
    connect(inverter.AC, motor.term) annotation (points=[-60,0; -40,0], style(
          color=62, rgbcolor={0,120,120}));
    connect(motor.rotorAngle, inverter.theta) annotation (points=[-20,10; -16,
          10; -16,20; -84,20; -84,10; -76,10], style(color=74, rgbcolor={0,0,
            127}));
    connect(motor.uPhasor, inverter.uPhasor) annotation (points=[-40,10; -64,10],
        style(color=74, rgbcolor={0,0,127}));
  end BLDC;

  package Partials "Partial models"
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

  partial model DriveBase "DC drives base"

    parameter SIpu.AngularVelocity_rpm rpm_ini=0
        "initial rpm (start-value if ini='st')"
      annotation(Dialog(enable=not system.steadyIni));
    Spot.Base.Interfaces.ElectricV_p term(final m=2) "electric terminal"
  annotation (extent=[-110, -10; -90, 10]);
    Spot.Base.Interfaces.Rotation_n flange "mechanical flange"
      annotation (extent=[90, -10; 110, 10]);
    replaceable Spot.Mechanics.Rotation.ElectricRotor rotor(w(start=rpm_ini*Base.Types.rpm2w))
        "machine rotor"
                      annotation (extent=[0,-10; 20,10]);
    replaceable Spot.Mechanics.Rotation.NoGear gear "type of gear"
      annotation (extent=[40,-10; 60,10],                                                                                    choices(
        choice(redeclare Spot.Mechanics.Rotation.Joint gear "no gear"),
        choice(redeclare Spot.Mechanics.Rotation.GearNoMass gear
              "massless gear"),
        choice(redeclare Spot.Mechanics.Rotation.Gear gear "massive gear")));
    Base.Interfaces.ThermalV_n heat(m=2) "heat source port {stator, rotor}"
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
  end DriveBase;

  model Synchron3rd_bldc
      "Synchronous machine, torque-control, 3rd order model, 3-phase dqo"
    extends ACdqo.Machines.Synchron3rd_pm(i_s(start={0,1,0}));

    Modelica.Blocks.Interfaces.RealOutput rotorAngle(redeclare type SignalType
          =
          SI.Angle) = phi_el "rotor angle el"
      annotation (extent=[110,90; 90,110],   rotation=180);
    Modelica.Blocks.Interfaces.RealOutput[2] uPhasor
        "desired {abs(u), phase(u)}"
      annotation (extent=[-110,90; -90,110], rotation=180);
    annotation (
  Documentation(info="<html>
<p>The model is valid for permanent magnet (<tt>excite=2</tt>) machines.</p>
<p>For rectangular voltage without additional PWM the only degree of freedom is the voltage phase. It is chosen such that the d-axis current (magnetising current) is zero <tt> i_s[1] = 0</tt>.<br>
Under theese assumptions the torque-speed characteristic is different from that of a DC-machine. In order to obtain a 'true' DC-characteristic with linear dependence of torque and i_s[2] from w_el, a second degree of freedom is needed.</p>
Example using 'average' inverter (approximation of rectangle by its fundamental)
<p><pre>
  v_sd = -w_el*c.L_s[2]*i_s[2]/((4/pi)*sin(width*pi/2)*par.V_nom);
  v_sq = 1;
  uPhasor[1] = sqrt(v_sd*v_sd + v_sq*v_sq);
  uPhasor[2] = atan2(v_sq, v_sd);
</pre></p>
<p>For reluctance (<tt>excite=3</tt>) machines psi_e is replaced by a desired magnetising current in d-axis <tt>i_sd</tt>.
<pre>
  uPhasor[2] = atan2(c.R_s*i_s[2] + w_el*c.L_s[1]*i_sd, c.R_s*i_sd - w_el*c.L_s[2]*i_s[2]);
</pre>
Using a pu-current <tt>i_sd_pu</tt> we obtain
<pre>
  uPhasor[2] = atan2(c.R_s*i_s[2] + w_el*c.L_s[1]*i_sd, (par.V_nom/(c.omega_nom*c.L_s[1]))*i_sd_pu - w_el*c.L_s[2]*i_s[2]);
</pre></p>
<p>More information see Partials.Synchron3rdBase.</p>
</html>"), Icon(
           Rectangle(extent=[-90,112; 90,88], style(
            color=74,
            rgbcolor={0,0,127},
            fillColor=68,
            rgbfillColor={170,213,255}))));

  equation
    uPhasor[1] = 1; //not used if no PWM
    uPhasor[2] = atan2(c.R_s*i_s[2] + w_el*psi_e, -w_el*c.L_s[2]*i_s[2]);
  end Synchron3rd_bldc;

  end Partials;

end DrivesDC;
