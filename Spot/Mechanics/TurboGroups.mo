within Spot.Mechanics;
package TurboGroups "Turbines including generator-rotor"
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
<p>Contains a single mass and examples of multi-mass models of turbo groups.</p>
<li>Default torque models</li>
</html>
"), Icon);

  model FixedSpeedTG "Fixed speed turbo-generator rotor"

    parameter SI.AngularVelocity w_ini=0 "initial rotor angular velocity";
    parameter SI.AngularVelocity w_nom=1 "nom ang velocity";
    Base.Interfaces.Rotation_n airgap "to airgap electric machine"
                                           annotation (extent=[90,50; 110,70]);
    Modelica.Blocks.Interfaces.RealInput power(redeclare type SignalType =
      SIpu.Power, final unit="pu") "turbine power pu"
      annotation (
            extent=[50,90; 70,110],     rotation=-90);
    Modelica.Blocks.Interfaces.RealOutput speed(redeclare type SignalType =
      SIpu.AngularVelocity, final unit="pu") "turbine speed pu"
      annotation (
            extent=[-70,90; -50,110],     rotation=90);
  protected
    outer System system;
    SI.Angle phi(stateSelect=StateSelect.prefer);
    SI.AngularVelocity w(start=w_ini, stateSelect=StateSelect.prefer);
    annotation (defaultComponentName = "rotor1mass",
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
<p>Turbine-rotor and generator-rotor together represent one single rotating object without dynamical properties. The constant rotor velocity is determined at initialisation.</p>
<p><i>
No pole pair reduction of equations of motion is performed.<br>
Therefore phi and w represent the mechanical angle and angular velocity.
</i></p>
</html>
"),   Icon(
        Polygon(points=[-100,34; 0,70; 0,-70; -100,-34; -100,34], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=7,
            rgbfillColor={255,255,255})),
            Rectangle(extent=[-100,90; 100,70],
                                              style(
                color=9,
                rgbcolor={175,175,175},
                fillColor=9,
                rgbfillColor={175,175,175})),
           Text(
          extent=[-100,-100; 100,-140],
          string="%name",
          style(color=0)),
            Rectangle(extent=[-100,-70; 100,-90],
                                              style(
                color=9,
                rgbcolor={175,175,175},
                fillColor=9,
                rgbfillColor={175,175,175})),
            Rectangle(extent=[0,50; 100,-50], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=7,
            rgbfillColor={255,255,255})),
                       Rectangle(extent=[0,70; 100,50],  style(
            color=47,
            rgbcolor={255,170,85},
            fillColor=47,
            rgbfillColor={255,170,85})),
                       Rectangle(extent=[0,-50; 100,-70],  style(
            color=47,
            rgbcolor={255,170,85},
            fillColor=47,
            rgbfillColor={255,170,85}))),
      Diagram);

  initial equation
    if not system.steadyIni then
      w = w_ini;
    end if;

  equation
    phi = airgap.phi;
    w = der(phi);
    0 = der(w);
    speed = w/w_nom;
  end FixedSpeedTG;

  model SingleMassTG "Single mass turbo-generator rotor"

    parameter SIpu.AngularVelocity speed_thr(unit="pu")=0.5
      "threshold: torque ctrl \\ power ctrl";
    parameter SI.Time H=1 "inertia constant turbine + generator";
    parameter SI.AngularVelocity w_ini=0 "initial rotor angular velocity";
    parameter SI.AngularVelocity w_nom=1 "nom ang velocity";
    parameter SI.Power P_nom=1 "nom power turbine";
    Base.Interfaces.Rotation_n airgap "to airgap electric machine"
                                           annotation (extent=[90,50; 110,70]);
    Modelica.Blocks.Interfaces.RealInput power(redeclare type SignalType =
      SIpu.Power, final unit="pu") "turbine power pu"
      annotation (
            extent=[50,90; 70,110],     rotation=-90);
    Modelica.Blocks.Interfaces.RealOutput speed(redeclare type SignalType =
      SIpu.AngularVelocity, final unit="pu") "turbine speed pu"
      annotation (
            extent=[-70,90; -50,110],     rotation=90);
  protected
    outer System system;
    final parameter SI.Inertia J=2*H*P_nom/(w_nom*w_nom)
      "inertia turbine + generator";
    final parameter SI.Torque tau_nom=P_nom/w_nom;
    SI.Angle phi(stateSelect=StateSelect.prefer);
    SI.AngularVelocity w(start=w_ini, stateSelect=StateSelect.prefer);
    SI.AngularAcceleration a(start=0);
    SI.Torque tau_pu;
    annotation (defaultComponentName = "rotor1mass",
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
<p>This model can be regarded as a default model.<br><br>
Turbine-rotor and generator-rotor together represent one single stiff rotating mass, characterised by its mechanical time constant H. The model therefore has one single mechanical degree of freedom. This component does not need an additional torque model.</p>
<p><i>
No pole pair reduction of equations of motion is performed.<br>
Therefore phi and w represent the mechanical angle and angular velocity.
</i></p>
</html>
"),   Icon(
        Polygon(points=[-100,34; 0,70; 0,-70; -100,-34; -100,34],     style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=8)),
            Rectangle(extent=[0,50; 100,-50],  style(
                color=0,
                rgbcolor={0,0,0},
                gradient=2,
                fillColor=30,
                rgbfillColor={215,215,215})),
            Rectangle(extent=[-100,90; 100,70],
                                              style(
                color=9,
                rgbcolor={175,175,175},
                fillColor=9,
                rgbfillColor={175,175,175})),
           Text(
          extent=[-100,-100; 100,-140],
          string="%name",
          style(color=0)),
            Rectangle(extent=[-100,-70; 100,-90],
                                              style(
                color=9,
                rgbcolor={175,175,175},
                fillColor=9,
                rgbfillColor={175,175,175})),
                       Rectangle(extent=[0,70; 100,50],  style(
            color=47,
            rgbcolor={255,170,85},
            fillColor=47,
            rgbfillColor={255,170,85})),
                       Rectangle(extent=[0,-50; 100,-70],  style(
            color=47,
            rgbcolor={255,170,85},
            fillColor=47,
            rgbfillColor={255,170,85}))),
      Diagram);

  equation
    max(speed_thr, speed)*tau_pu = power;
    phi = airgap.phi;
    w = der(phi);
    a = der(w);
    J*a = tau_pu*tau_nom + airgap.tau;
    speed = w/w_nom;
  end SingleMassTG;

  model SteamTurboGroup "Steam turbo-group with generator-rotor"
    extends Partials.TurboBase1(final n=size(par.P_nom,1));

    replaceable Parameters.SteamTurboGroup par "turbo-group par"
                                 annotation (extent=[-80,80; -60,100]);
    Rotation.ElectricRotor genRotor(J=par.J_gen, w(start=w_ini), a(start=0))
      annotation (
            extent=[50,-10; 70,10]);
    SI.Angle[n] delta "difference angles";
  protected
    Rotation.Rotor aux1(J=par.J_aux[1])
      annotation (
            extent=[-100,-10; -80,10]);
    Rotation.ShaftNoMass shaft1(stiff=par.stiff[1])
      annotation (
            extent=[-80,-10; -70,10]);
    Rotation.ThermalTurbineRotor turbine1(J=par.J_turb[1])
                  annotation (extent=[-70,-10; -50,10]);
    Rotation.ShaftNoMass shaft2(stiff=par.stiff[2])
      annotation (
            extent=[-50,-10; -40,10]);
    Rotation.ThermalTurbineRotor turbine2(J=par.J_turb[2])
                  annotation (extent=[-40,-10; -20,10]);
    Rotation.ShaftNoMass shaft3(stiff=par.stiff[3])
      annotation (
            extent=[-20,-10; -10,10]);
    Rotation.ThermalTurbineRotor turbine3(J=par.J_turb[3])
                  annotation (extent=[-10,-10; 10,10]);
    Rotation.ShaftNoMass shaft4(stiff=par.stiff[4])
                                       annotation (extent=[10,-10; 20,10]);
    Rotation.ThermalTurbineRotor turbine4(J=par.J_turb[4])
                  annotation (extent=[20,-10; 40,10]);
    Rotation.ShaftNoMass shaft5(stiff=par.stiff[5])
      annotation (
            extent=[40,-10; 50,10]);
    Rotation.ShaftNoMass shaft6(stiff=par.stiff[6])
      annotation (
            extent=[70,-10; 80,10]);
    Rotation.Rotor aux2(J=par.J_aux[2])
      annotation (
            extent=[80,-10; 100,10]);
    annotation (defaultComponentName = "turboGrp",
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
<p>Example model of a large steam turbo-group with generator rotor.<br>
(Aux, HP1, HP2, MP, LP, Generator, Exciter).<br><br>
The rigid massive rotating parts are connected with massless elastic shafts. The model therefore has several mechanical degrees of freedom and allows the study of coupled electrical and mechanical resonances.<br>
An appropriate torque model has to be connected to SteamTurboGroup.blades.</p>
<p><i>
No pole pair reduction of equations of motion is performed.<br>
Therefore phi and w represent the mechanical angle and angular velocity.
</i></p>
</html>
"),   Icon(Icon(
        Polygon(points=[-100,20; -60,50; -60,-48; -100,-20; -100,20], style(
            color=0,
            rgbcolor={0,0,0},
            gradient=2,
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=8)),
        Polygon(points=[-60,28; -10,70; -10,-70; -60,-30; -60,28], style(
            color=0,
            rgbcolor={0,0,0},
            gradient=2,
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=8)),
        Rectangle(extent=[-10,10; 10,-10], style(
            color=0,
            rgbcolor={0,0,0},
            gradient=2,
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=8)),
        Rectangle(extent=[10,40; 100,-40], style(
            color=0,
            rgbcolor={0,0,0},
            gradient=2,
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=8))),
      Diagram,
        Polygon(points=[-100,40; -60,60; -60,-60; -100,-40; -100,40], style(
            color=0,
            rgbcolor={0,0,0},
            gradient=2,
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=8)),
        Polygon(points=[-60,40; -10,70; -10,-70; -60,-40; -60,40], style(
            color=0,
            rgbcolor={0,0,0},
            gradient=2,
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=8)),
        Polygon(points=[-60,70; -60,40; -10,70; -60,70], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=42,
            rgbfillColor={176,0,0})),
        Polygon(points=[-60,-70; -60,-40; -10,-70; -60,-70], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=42,
            rgbfillColor={176,0,0}))),
      Diagram(Text(
          extent=[-100,-60; 100,-80],
          string=
              "stator reaction torque- and friction-models may be added here",
          style(
            color=9,
            rgbcolor={175,175,175},
            fillColor=9,
            rgbfillColor={175,175,175},
            fillPattern=1))));

  initial equation
    aux1.w = turbine1.w;
    aux1.a = turbine1.a;
    turbine1.w = turbine2.w;
    turbine1.a = turbine2.a;
    turbine2.w = turbine3.w;
    turbine2.a = turbine3.a;
    turbine3.w = turbine4.w;
    turbine3.a = turbine4.a;
    turbine4.w = genRotor.w;
    turbine4.a = genRotor.a;
    genRotor.w = aux2.w;
    genRotor.a = aux2.a;

  equation
    delta = {turbine2.flange_p.phi-turbine1.flange_n.phi, turbine3.flange_p.phi-turbine2.flange_n.phi,
      turbine4.flange_p.phi-turbine3.flange_n.phi, genRotor.flange_p.phi-turbine4.flange_n.phi};

    connect(aux1.flange_n, shaft1.flange_p)
      annotation (points=[-80,0; -80,0],   style(color=0, rgbcolor={0,0,0}));
    connect(shaft1.flange_n,turbine1. flange_p)
      annotation (points=[-70,0; -70,0], style(color=0, rgbcolor={0,0,0}));
    connect(turbine1.flange_n, shaft2.flange_p)
      annotation (points=[-50,0; -50,0],   style(color=0, rgbcolor={0,0,0}));
    connect(shaft2.flange_n,turbine2. flange_p)
      annotation (points=[-40,0; -40,0], style(color=0, rgbcolor={0,0,0}));
    connect(turbine2.flange_n, shaft3.flange_p)
      annotation (points=[-20,0; -20,0],   style(color=0, rgbcolor={0,0,0}));
    connect(shaft3.flange_n, turbine3.flange_p)
      annotation (points=[-10,0; -10,0],   style(color=0, rgbcolor={0,0,0}));
    connect(turbine3.flange_n, shaft4.flange_p)
      annotation (points=[10,0; 10,0],   style(color=0, rgbcolor={0,0,0}));
    connect(shaft4.flange_n, turbine4.flange_p)
      annotation (points=[20,0; 20,0],   style(color=0, rgbcolor={0,0,0}));
    connect(turbine4.flange_n, shaft5.flange_p)
      annotation (points=[40,0; 40,0],   style(color=0, rgbcolor={0,0,0}));
    connect(shaft5.flange_n, genRotor.flange_p)
      annotation (points=[50,0; 50,0],   style(color=0, rgbcolor={0,0,0}));
    connect(genRotor.flange_n, shaft6.flange_p)
      annotation (points=[70,0; 70,0],   style(color=0, rgbcolor={0,0,0}));
    connect(shaft6.flange_n, aux2.flange_p)
      annotation (points=[80,0; 80,0],   style(color=0, rgbcolor={0,0,0}));
    connect(blades[1], turbine1.rotor)
                                      annotation (points=[-100,60; -60,60; -60,
          6],     style(color=0, rgbcolor={0,0,0}));
    connect(blades[2], turbine2.rotor)
                                      annotation (points=[-100,60; -30,60; -30,
          6],     style(color=0, rgbcolor={0,0,0}));
    connect(blades[3], turbine3.rotor)
                                      annotation (points=[-100,60; 0,60; 0,6],
        style(color=0, rgbcolor={0,0,0}));
    connect(blades[4], turbine4.rotor)
                                      annotation (points=[-100,60; 30,60; 30,6],
              style(color=0, rgbcolor={0,0,0}));
    connect(airgap, genRotor.rotor) annotation (points=[100,60; 60,60; 60,6],
        style(color=0, rgbcolor={0,0,0}));
  end SteamTurboGroup;

  model GasTurbineGear "Gas turbine with gear and generator-rotor"
    extends Partials.TurboBase1(final n=size(par.P_nom,1));

    replaceable Parameters.GasTurbineGear par "turbo-group par"
                                 annotation (extent=[-80,80; -60,100]);
    Rotation.ElectricRotor genRotor(J=par.J_gen, w(start=w_ini*par.ratio[end]/par.ratio[1]), a(start=0))
      annotation (
            extent=[70,-10; 90,10]);
  protected
    Rotation.ThermalTurbineRotor turbine(J=par.J_turb)
               annotation (extent=[-90,-10; -70,10]);
    Rotation.ShaftNoMass shaft1(stiff=par.stiff_sh[1])
      annotation (
            extent=[-70,-10; -60,10]);
    Rotation.ThermalTurbineRotor compressor(J=par.J_comp)
             annotation (extent=[-40,-10; -60,10]);
    Rotation.ShaftNoMass shaft2(stiff=par.stiff_sh[2])
                                      annotation (extent=[-40,-10; -30,10]);
    Rotation.Gear gear1(ratio=par.ratio[1:2], J=par.J_gear1)
      annotation (
            extent=[-30,-10; -10,10]);
    Rotation.ShaftNoMass shaft3(stiff=par.stiff_sh[3])
                                      annotation (extent=[-10,-10; 0,10]);
    Rotation.Gear gear2(ratio=par.ratio[2:3], J=par.J_gear2)
      annotation (
            extent=[0,-10; 20,10]);
    Rotation.ShaftNoMass shaft4(stiff=par.stiff_sh[4])
      annotation (
            extent=[20,-10; 30,10]);
    Rotation.Rotor accessory(J=par.J_acc)
      annotation (
            extent=[30,-10; 40,10]);
    Rotation.ShaftNoMass shaft5(stiff=par.stiff_sh[5])
      annotation (
            extent=[40,-10; 50,10]);
    Rotation.Shaft coupling(J=par.J_cpl, stiff=par.stiff_cpl)
             annotation (extent=[50,-40; 60,40]);
    Rotation.ShaftNoMass shaft6(stiff=par.stiff_sh[6])
      annotation (
            extent=[60,-10; 70,10]);
    annotation (defaultComponentName = "GTgrp",
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
<p>Example model of a small gas-turbine with gear and generator rotor.
(Turbine, compressor, gear, accessory, generator).<br>
An appropriate torque model has to be connected to GasTurbineGear.blades.</p>
<p><i>
No pole pair reduction of equations of motion is performed.<br>
Therefore phi and w represent the mechanical angle and angular velocity.
</i></p>
</html>"),
      Icon(
        Polygon(points=[-100,40; -60,60; -60,-60; -100,-40; -100,40], style(
            color=0,
            rgbcolor={0,0,0},
            gradient=2,
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=8)),
        Polygon(points=[-60,40; -10,70; -10,-70; -60,-40; -60,40], style(
            color=0,
            rgbcolor={0,0,0},
            gradient=2,
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=8)),
        Polygon(points=[-60,70; -60,40; -10,70; -60,70], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=42,
            rgbfillColor={176,0,0})),
        Polygon(points=[-60,-70; -60,-40; -10,-70; -60,-70], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=42,
            rgbfillColor={176,0,0})),
  Line(points=[-88,10; -70,10], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2)),
  Line(points=[-50,10; -20,10], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2)),
  Line(points=[-88,-10; -20,-10], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2))),
      Diagram(Text(
          extent=[-100,-60; 100,-80],
          string=
              "stator reaction torque- and friction-models may be added here",
          style(
            color=9,
            rgbcolor={175,175,175},
            fillColor=9,
            rgbfillColor={175,175,175},
            fillPattern=1))));

  initial equation
    turbine.w = compressor.w;
    turbine.a = compressor.a;
    compressor.w = (par.ratio[1]/par.ratio[2])*gear1.w;
    compressor.a = (par.ratio[1]/par.ratio[2])*gear1.a;
    gear1.w = (par.ratio[2]/par.ratio[3])*gear2.w;
    gear1.a = (par.ratio[2]/par.ratio[3])*gear2.a;
    gear2.w = accessory.w;
    gear2.a = accessory.a;
    accessory.w = coupling.w;
    accessory.a = coupling.a;
    coupling.w = genRotor.w;
    coupling.a = genRotor.a;

  equation
    connect(turbine.flange_n, shaft1.flange_p)
      annotation (points=[-70,0; -70,0], style(color=0, rgbcolor={0,0,0}));
    connect(compressor.flange_n, shaft1.flange_n)
      annotation (points=[-60,0; -60,0], style(color=0, rgbcolor={0,0,0}));
    connect(compressor.flange_p, shaft2.flange_p)
      annotation (points=[-40,0; -40,0], style(color=0, rgbcolor={0,0,0}));
    connect(shaft2.flange_n, gear1.flange_p)
      annotation (points=[-30,0; -30,0], style(color=0, rgbcolor={0,0,0}));
    connect(gear1.flange_n, shaft3.flange_p)
      annotation (points=[-10,0; -10,0], style(color=0, rgbcolor={0,0,0}));
    connect(shaft3.flange_n, gear2.flange_p)
      annotation (points=[0,0; 0,0],     style(color=0, rgbcolor={0,0,0}));
    connect(gear2.flange_n, shaft4.flange_p)
      annotation (points=[20,0; 20,0], style(color=0, rgbcolor={0,0,0}));
    connect(shaft4.flange_n, accessory.flange_p)
      annotation (points=[30,0; 30,0], style(color=0, rgbcolor={0,0,0}));
    connect(accessory.flange_n, shaft5.flange_p)
      annotation (points=[40,0; 40,0], style(color=0, rgbcolor={0,0,0}));
    connect(shaft5.flange_n, coupling.flange_p)
      annotation (points=[50,0; 50,0], style(color=0, rgbcolor={0,0,0}));
    connect(coupling.flange_n, shaft6.flange_p)
      annotation (points=[60,0; 60,0], style(color=0, rgbcolor={0,0,0}));
    connect(shaft6.flange_n, genRotor.flange_p)
      annotation (points=[70,0; 70,0], style(color=0, rgbcolor={0,0,0}));
    connect(blades[1], turbine.rotor) annotation (points=[-100,60; -80,60; -80,
          6], style(color=0, rgbcolor={0,0,0}));
    connect(blades[2], compressor.rotor) annotation (points=[-100,60; -50,60;
          -50,6], style(color=0, rgbcolor={0,0,0}));
    connect(airgap, genRotor.rotor) annotation (points=[100,60; 80,60; 80,6],
        style(color=0, rgbcolor={0,0,0}));
  end GasTurbineGear;

  model HydroTurbine "Hydro turbine with generator-rotor"
    extends Partials.TurboBase2(final n=1);                                                                           // annotation 0;

    replaceable Parameters.HydroTurbine par "hydro-turbine par"
                                     annotation (extent=[-80,80; -60,100]);
    Rotation.ElectricRotor genRotor(J=par.J_gen, w(start=w_ini), a(start=0))
      annotation (
            extent=[5,-10; 25,10]);
  protected
    Rotation.HydroTurbineRotor turbine(J=par.J_turb)
                  annotation (extent=[-25,-10; -5,10]);
    Rotation.Shaft shaft(J=par.J_shaft, stiff=par.stiff)
      annotation (
            extent=[-5,-10; 5,10]);
    annotation (defaultComponentName = "hydroGrp",
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
<p>Hydro turbine and generator rotor, coupled with a massive shaft.</p>
<p>Note that name and icon of the model are specific, although the turbine model itself is rather generic. The essential type-specific properties are related with torque generation.<br>
An appropriate torque model has to be connected to HydroTurbine.blades.</p>
<p><i>
No pole pair reduction of equations of motion is performed.<br>
Therefore phi and w represent the mechanical angle and angular velocity.
</i></p>
</html>
"),   Icon(
      Diagram,
        Rectangle(extent=[-83,50; -43,-50], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=30,
            rgbfillColor={215,215,215})),
        Ellipse(
        extent=[-83,70; -43,30], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=10,
            rgbfillColor={135,135,135})),
        Ellipse(
        extent=[-83,-30; -43,-70], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=10,
            rgbfillColor={135,135,135})),
        Rectangle(extent=[-43,10; -10,-10],style(
            color=0,
            rgbcolor={0,0,0},
            gradient=2,
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=8))),
      Diagram(Text(
          extent=[-100,-60; 100,-80],
          string=
              "stator reaction torque- and friction-models may be added here",
          style(
            color=9,
            rgbcolor={175,175,175},
            fillColor=9,
            rgbfillColor={175,175,175},
            fillPattern=1))));

  initial equation
    turbine.w = shaft.w;
    der(turbine.w) = der(shaft.w);
    shaft.w = genRotor.w;
    der(shaft.w) = der(genRotor.w);

  equation
    connect(turbine.flange_n, shaft.flange_p)
      annotation (points=[-5,0; -5,0],   style(color=0, rgbcolor={0,0,0}));
    connect(shaft.flange_n, genRotor.flange_p)
      annotation (points=[5,0; 5,0], style(color=0, rgbcolor={0,0,0}));
    connect(blades[1], turbine.rotor) annotation (points=[-100,60; -15,60; -15,
          6],
        style(color=0, rgbcolor={0,0,0}));
    connect(airgap, genRotor.rotor) annotation (points=[100,60; 15,60; 15,6],
        style(color=0, rgbcolor={0,0,0}));
  end HydroTurbine;

  model Diesel "Diesel with generator-rotor"
    extends Partials.TurboBase3(final n=1);                                                                                            // annotation 0;

    replaceable Parameters.Diesel par "Diesel par"
                                annotation (extent=[-80,80; -60,100]);
    Rotation.ElectricRotor genRotor(J=par.J_gen, w(start=w_ini), a(start=0))
      annotation (
            extent=[5,-10; 25,10]);
  protected
    Rotation.DieselRotor diesel(J=par.J_turb)
                  annotation (extent=[-25,-10; -5,10]);
    Rotation.ShaftNoMass shaft(stiff=par.stiff)
      annotation (
            extent=[-5,-10; 5,10]);
    annotation (defaultComponentName = "dieselGrp",
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
<p>Diesel with generator rotor, coupled with a massless shaft.</p>
<p>Note that name and icon of the model are specific, although the 'turbine' model itself is rather generic. The essential type-specific properties are related with torque generation.<br>
An appropriate torque model has to be connected to Diesel.blades (terminology from turbines!).<br><br>
<b>Perhaps somebody can provide a more realistic Diesel-model!</b></p>
<p><i>
No pole pair reduction of equations of motion is performed.<br>
Therefore phi and w represent the mechanical angle and angular velocity.
</i></p>
</html>
"),   Icon(
      Diagram,
        Rectangle(extent=[-90,50; -20,-70], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=30,
            rgbfillColor={215,215,215})),
        Rectangle(extent=[-80,70; -30,50], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=9,
            rgbfillColor={175,175,175},
            fillPattern=1)),
        Ellipse(extent=[-85,-6; -25,-66], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=9,
            rgbfillColor={175,175,175},
            fillPattern=1))),
      Diagram(Text(
          extent=[-100,-60; 100,-80],
          string=
              "stator reaction torque- and friction-models may be added here",
          style(
            color=9,
            rgbcolor={175,175,175},
            fillColor=9,
            rgbfillColor={175,175,175},
            fillPattern=1))));

  initial equation
    diesel.w = genRotor.w;
    der(diesel.w) = der(genRotor.w);

  equation
    connect(diesel.flange_n, shaft.flange_p)
      annotation (points=[-5,0; -5,0],     style(color=0, rgbcolor={0,0,0}));
    connect(shaft.flange_n, genRotor.flange_p)
      annotation (points=[5,0; 5,0], style(color=0, rgbcolor={0,0,0}));
    connect(blades[1], diesel.rotor) annotation (points=[-100,60; -15,60; -15,6],
        style(color=0, rgbcolor={0,0,0}));
    connect(airgap, genRotor.rotor) annotation (points=[100,60; 15,60; 15,6],
        style(color=0, rgbcolor={0,0,0}));
  end Diesel;

  model WindTurbineGear "Wind turbine with gear and generator-rotor"
    extends Partials.TurboBase4(final n=1);

    replaceable Parameters.WindTurbineGear par "turbine par"
                                         annotation (extent=[-80,80; -60,100]);
    Rotation.ElectricRotor genRotor(J=par.J_gen, w(start=w_ini*par.ratio[end]/par.ratio[1]), a(start=0))
      annotation (
            extent=[20,-10; 40,10]);
  protected
    final parameter Real[3] gr2=diagonal(par.ratio)*par.ratio/par.ratio[end]^2;
    final parameter SI.Inertia J_red=par.J_turb*gr2[1] + par.J_gear*gr2 + par.J_gen
      "gear reduced inertia";
    Rotation.WindTurbineRotor turbine(J=par.J_turb)
             annotation (extent=[-40,-10; -20,10]);
    Rotation.ShaftNoMass shaft1(stiff=par.stiff_sh[1])
                                      annotation (extent=[-20,-10; -10,10]);
    Rotation.Gear gear(J=par.J_gear, ratio=par.ratio)
      annotation (
            extent=[-10,-10; 10,10]);
    Rotation.ShaftNoMass shaft2(stiff=par.stiff_sh[2])
                                      annotation (extent=[10,-10; 20,10]);
    annotation (defaultComponentName = "windGrp",
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
<p>Wind turbine, gear and generator rotor, coupled with massless shafts.</p>
<p>Note that name and icon of the model are specific, although the turbine model itself is rather generic. The essential type-specific properties are related with torque generation.<br>
An appropriate torque model has to be connected to WindTurbineGear.blades.</p>
<p><i>
No pole pair reduction of equations of motion is performed.<br>
Therefore phi and w represent the mechanical angle and angular velocity.
</i></p>
</html>
"),   Icon(Polygon(points=[-55,-120; -55,120; -47,80; -39,40; -39,20; -43,6;
              -55,0; -67,-6; -71,-20; -71,-40; -65,-80; -55,-120], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1))),
      Diagram(Text(
          extent=[-98,-58; 102,-78],
          string=
              "stator reaction torque- and friction-models may be added here",
          style(
            color=9,
            rgbcolor={175,175,175},
            fillColor=9,
            rgbfillColor={175,175,175},
            fillPattern=1))));

  initial equation
    turbine.w = (par.ratio[1]/par.ratio[end])*gear.w;
    der(turbine.w) = (par.ratio[1]/par.ratio[end])*der(gear.w);
    gear.w = genRotor.w;
    der(gear.w) = der(genRotor.w);

  equation
    connect(turbine.flange_n,shaft1. flange_p) annotation (points=[-20,0; -20,0], style(color=0, rgbcolor={0,0,0}));
    connect(shaft1.flange_n, gear.flange_p)
      annotation (points=[-10,0; -10,0], style(color=0, rgbcolor={0,0,0}));
    connect(gear.flange_n, shaft2.flange_p)
      annotation (points=[10,0; 10,0],   style(color=0, rgbcolor={0,0,0}));
    connect(airgap, genRotor.rotor) annotation (points=[100,60; 30,60; 30,6],
        style(color=0, rgbcolor={0,0,0}));
    connect(blades[1], turbine.rotor) annotation (points=[-100,60; -30,60; -30,
          6], style(color=0, rgbcolor={0,0,0}));
    connect(shaft2.flange_n, genRotor.flange_p) annotation (points=[20,0; 20,0],
        style(
        color=0,
        rgbcolor={0,0,0},
        fillColor=61,
        rgbfillColor={0,255,128},
        fillPattern=1));
  end WindTurbineGear;

  model PcontrolTorque "Turbine torque from power control"

    parameter SIpu.AngularVelocity_rpm rpm_nom=3000 "nom r.p.m. turbine"
      annotation(Evaluate=true, Dialog(group="Nominal"));
    parameter SI.Power[:] P_nom={1} "nom power turbines"
      annotation(Evaluate=true, Dialog(group="Nominal"));

    parameter SIpu.AngularVelocity speed_thr(unit="pu")=0.5
      "threshold torque ctrl \\ power ctrl";
    SI.Angle phi;
    SIpu.Torque tau_pu(unit="pu");
    Modelica.Blocks.Interfaces.RealInput power(
                    final unit="pu", redeclare type SignalType = SIpu.Power)
      "power pu"
      annotation (
            extent=[50,90; 70,110],   rotation=-90);
    Modelica.Blocks.Interfaces.RealOutput speed(redeclare type SignalType =
        SIpu.AngularVelocity, final unit="pu") "angular velocity pu"
      annotation (
            extent=[-70,90; -50,110],   rotation=90);
    Base.Interfaces.Rotation_n[n] blades "to turbine model"
      annotation (extent=[110,70; 90,50],    rotation=180);
  protected
    final parameter SI.AngularVelocity w_nom=rpm_nom*Base.Types.rpm2w;
    final parameter Integer n=size(P_nom,1) "number of turbines"
                                                               annotation(Evaluate=true);
    final parameter SI.Torque[n] tau_nom=P_nom/w_nom "nom torque"
    annotation(Evaluate=true);
    annotation (defaultComponentName = "turbTorq",
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
<p>This is a default model. The torque is directly determined by the pu power control-signal.
It does neither contain thermal nor hydraulic forces, but it may be replaced by appropriate physical models.</p>
<p>Power control for speed &gt  speed_thr (speed threshold)
<pre>  speed*torq = power</pre>
torque control for speed &lt  speed_thr (speed threshold)
<pre>  speed_thr*torq = power</pre></p>
</html>
"),   Icon(Text(
            extent=[-100,30; 100,10],
            string="torque",
            style(color=74, rgbcolor={0,0,127})), Text(
            extent=[-100,-10; 100,-30],
            style(color=74, rgbcolor={0,0,127}),
          string="gen"),
       Rectangle(extent=[-80,60; 80,-60], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=30,
            rgbfillColor={215,215,215})),
           Text(
            extent=[-100,40; 100,20],
          string="p control",
          style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=48,
            rgbfillColor={255,179,179})),         Text(
            extent=[-100,-20; 100,-40],
            string="torque",
          style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=42,
            rgbfillColor={176,0,0})),
       Text(
      extent=[-100,-100; 100,-140],
      string="%name",
      style(color=0)),
        Polygon(points=[-10,10; 0,-10; 10,10; -10,10], style(
            color=42,
            rgbcolor={176,0,0},
            fillColor=7,
            rgbfillColor={255,255,255}))),
      Diagram);

  equation
    max(speed_thr, speed)*tau_pu = power;
    phi=blades[end].phi;
    for k in 1:n loop
      blades[k].tau = -tau_pu*tau_nom[k];
    end for;
    speed = der(phi)/w_nom;
  end PcontrolTorque;

  model WindTabTorque "Turbine torque, table {speed, torque pu}"

    parameter SIpu.AngularVelocity_rpm rpm_nom=3000 "nom r.p.m. turbine"
      annotation(Evaluate=true, Dialog(group="Nominal"));
    parameter SI.Power P_nom=1 "nom power turbine"
      annotation(Evaluate=true, Dialog(group="Nominal"));

    parameter String tableName="torque" "table name in file";
    parameter String fileName=TableDir+"WindTorque.tab"
      "name of file containing table";

    Modelica.Blocks.Tables.CombiTable1Ds table(table=[0,0,1; 0,1,1],
      final tableName=tableName,
      final fileName=fileName,
      columns={2},
      final tableOnFile=true) "{wind speed m/s, torque pu}"
      annotation (extent=[-20,-20; 20,20]);
    Base.Interfaces.Rotation_n blades "to turbine model"
      annotation (extent=[110,70; 90,50],    rotation=180);
    Modelica.Blocks.Interfaces.RealInput windSpeed(redeclare type SignalType =
          SI.Velocity) "wind speed"
      annotation (extent=[-110,-10; -90,10],rotation=0);
  protected
    final parameter SI.AngularVelocity w_nom=rpm_nom*Base.Types.rpm2w;
    final parameter SI.Torque tau_nom=P_nom/w_nom "nom torque"
    annotation(Evaluate=true);
    annotation (defaultComponentName = "turbTorq",
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
<p>This is a default model. The torque is directly determined by the pu torque-signal. It does not contain aerodynamic forces, but it may be replaced by appropriate physical models.</p>
</html>
"),   Icon(Text(
            extent=[-100,30; 100,10],
            string="torque",
            style(color=74, rgbcolor={0,0,127})), Text(
            extent=[-100,-10; 100,-30],
            style(color=74, rgbcolor={0,0,127}),
          string="gen"),
       Rectangle(extent=[-80,60; 80,-60], style(
            color=74,
            rgbcolor={0,0,127},
            fillColor=51,
            rgbfillColor={255,255,170})),
           Text(
            extent=[-100,40; 100,20],
          style(color=74, rgbcolor={0,0,127}),
          string="wind tab"),                     Text(
            extent=[-100,-20; 100,-40],
          style(color=74, rgbcolor={0,0,127}),
          string="torque"),
       Text(
      extent=[-100,-100; 100,-140],
      string="%name",
      style(color=0)),
        Polygon(points=[-10,10; 0,-10; 10,10; -10,10], style(
            color=74,
            rgbcolor={0,0,127},
            fillColor=7,
            rgbfillColor={255,255,255}))),
      Diagram);

  equation
    blades.tau = -table.y[1]*tau_nom;

    connect(windSpeed, table.u)
      annotation (points=[-100,0; -24,0], style(color=74, rgbcolor={0,0,127}));
  end WindTabTorque;

package Parameters "Parameter data for interactive use"
  extends Base.Icons.Base;

  annotation (preferedView="info",
Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
Window(
  x=0.05,
  y=0.41,
  width=0.4,
  height=0.38,
  library=1,
  autolayout=1),
Documentation(info="<html>
<p>Records containing parameters of the corresponding components.</p>
</html>"),
    Icon);

record SteamTurboGroup "Steam turbo-group parameters"
  extends Base.Icons.Record;

  parameter SIpu.AngularVelocity_rpm rpm_nom=3000 "nom r.p.m. turbines"
    annotation(Evaluate=true, Dialog(group="Nominal"));
  parameter SI.Power[:] P_nom={500e6,250e6,250e6,250e6} "nom power turbines"
    annotation(Evaluate=true, Dialog(group="Nominal"));
  parameter SI.Inertia[size(P_nom,1)] J_turb={20000,200000,200000,200000}
        "inertia turbines";
  parameter SI.Inertia J_gen=70000 "inertia generator";
  parameter SI.Inertia[:] J_aux={500,1000} "inertia auxiliaries";
  parameter SIpu.Stiffness[size(J_turb,1)+size(J_aux,1)] stiff={250,350,750,750,750,250}*1e6
        "stiffness shafts";

  annotation (defaultComponentName="data",
    Coordsys(
extent=[-100,-100; 100,100],
grid=[2,2],
component=
  [20, 20]),
    Window(
x=0.45,
      y=0.01,
      width=0.44,
height=0.65),
    Documentation(
    info="<html>
</html>"),
    Icon,
    Diagram);
end SteamTurboGroup;

record GasTurbineGear "Turbo-group parameters"
  extends Base.Icons.Record;

  parameter SIpu.AngularVelocity_rpm rpm_nom=15057 "nom r.p.m. turbine"
    annotation(Evaluate=true, Dialog(group="Nominal"));
  parameter SI.Power[:] P_nom={12, -2}*1e6 "nom power {turbine, compressor}"
    annotation(Evaluate=true, Dialog(group="Nominal"));
  parameter SI.Inertia J_turb=40 "inertia turbine";
  parameter SI.Inertia J_comp=50 "inertia compressor";
  parameter SI.Inertia[2] J_gear1={0.6,12} "inertias gear1";
  parameter SI.Inertia[2] J_gear2={5,200} "inertias gear2";
  parameter SI.Inertia J_acc=6 "inertia accessory";
  parameter SI.Inertia J_cpl=40 "inertia coupling";
  parameter SI.Inertia J_gen=2500 "inertia generator";
  parameter Real[3] ratio={15057,5067,1500} "gear ratio";
  parameter SIpu.Stiffness[6] stiff_sh={3,5.5,100,2500,250,200}*1e6
        "stiffness shafts";
  parameter SIpu.Stiffness stiff_cpl=130*1e6 "stiffness coupling";

  annotation (defaultComponentName="data",
    Coordsys(
extent=[-100,-100; 100,100],
grid=[2,2],
component=
  [20, 20]),
    Window(
x=0.45,
      y=0.01,
      width=0.44,
height=0.65),
    Documentation(
    info="<html>
</html>"),
    Icon,
    Diagram,
    DymolaStoredErrors);
end GasTurbineGear;

record HydroTurbine "Turbo-group parameters"
  extends Base.Icons.Record;

  parameter SIpu.AngularVelocity_rpm rpm_nom=3000 "nom r.p.m. turbine"
    annotation(Evaluate=true, Dialog(group="Nominal"));
  parameter SI.Power P_nom=20e6 "nom power turbine"
    annotation(Evaluate=true, Dialog(group="Nominal"));
  parameter SI.Inertia J_turb=1000 "inertia turbines";
  parameter SI.Inertia J_shaft=5 "inertia shaft";
  parameter SI.Inertia J_gen=500 "inertia generator";
  parameter SIpu.Stiffness stiff=300e6 "stiffness shaft";

  annotation (defaultComponentName="data",
    Coordsys(
extent=[-100,-100; 100,100],
grid=[2,2],
component=
  [20, 20]),
    Window(
x=0.45,
      y=0.01,
      width=0.44,
height=0.65),
    Documentation(
    info="<html>
</html>"),
    Icon,
    Diagram,
    DymolaStoredErrors);
end HydroTurbine;

record Diesel "Turbo-group parameters"
  extends Base.Icons.Record;

  parameter SIpu.AngularVelocity_rpm rpm_nom=1500 "nom r.p.m. Diesel"
    annotation(Evaluate=true, Dialog(group="Nominal"));
  parameter SI.Power P_nom=100e3 "nom power diesel"
    annotation(Evaluate=true, Dialog(group="Nominal"));
  parameter SI.Inertia J_turb=20 "inertia diesel";
  parameter SI.Inertia J_gen=20 "inertia generator";
  parameter SIpu.Stiffness stiff=1e6 "stiffness shaft";

  annotation (defaultComponentName="data",
    Coordsys(
extent=[-100,-100; 100,100],
grid=[2,2],
component=
  [20, 20]),
    Window(
x=0.45,
      y=0.01,
      width=0.44,
height=0.65),
    Documentation(
    info="<html>
</html>"),
    Icon,
    Diagram,
    DymolaStoredErrors);
end Diesel;

record WindTurbineGear "Turbo-group parameters"
  extends Base.Icons.Record;

  parameter SIpu.AngularVelocity_rpm rpm_nom=10 "nom r.p.m. turbine"
    annotation(Evaluate=true, Dialog(group="Nominal"));
  parameter SI.Power P_nom=1e6 "nom power turbine"
    annotation(Evaluate=true, Dialog(group="Nominal"));
  parameter SI.Inertia J_turb=30 "inertia turbine";
  parameter SI.Inertia[3] J_gear={30,2,0.1} "inertias gear";
  parameter SI.Inertia J_gen=450 "inertia generator";
  parameter Real ratio[3]={10,100,1000} "gear ratio";
  parameter SIpu.Stiffness[2] stiff_sh={16,1}*1e6 "stiffness shafts";

  annotation (defaultComponentName="data",
    Coordsys(
extent=[-100,-100; 100,100],
grid=[2,2],
component=
  [20, 20]),
    Window(
x=0.45,
      y=0.01,
      width=0.44,
height=0.65),
    Documentation(
    info="<html>
</html>"),
    Icon,
    Diagram,
    DymolaStoredErrors);
end WindTurbineGear;
end Parameters;

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

    partial model TurboBase "Turbine-generator rotor base "

      parameter SI.AngularVelocity w_ini=0 "initial rotor angular velocity";
      parameter Integer n=1 "number of turbines";
      Base.Interfaces.Rotation_p[n] blades "to turbine torque model"
                                                annotation (extent=[-110,50; -90,70]);
      Base.Interfaces.Rotation_n airgap "to airgap electric machine"
                                             annotation (extent=[90,50; 110,70]);
    protected
      outer System system;
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
            Documentation(
                  info="<html>
</html>
"),         Icon(
              Rectangle(extent=[-10,10; 10,-10], style(
                  color=0,
                  rgbcolor={0,0,0},
                  gradient=2,
                  fillColor=30,
                  rgbfillColor={215,215,215},
                  fillPattern=8)),
              Rectangle(extent=[10,50; 100,-50], style(
                  color=0,
                  rgbcolor={0,0,0},
                  gradient=2,
                  fillColor=30,
                  rgbfillColor={215,215,215})),
              Rectangle(extent=[10,90; 100,70], style(
                  color=9,
                  rgbcolor={175,175,175},
                  fillColor=9,
                  rgbfillColor={175,175,175})),
             Text(
            extent=[-100,-100; 100,-140],
            string="%name",
            style(color=0)),
                         Rectangle(extent=[10,-50; 100,-70], style(
              color=47,
              rgbcolor={255,170,85},
              fillColor=47,
              rgbfillColor={255,170,85})),
              Rectangle(extent=[10,-70; 100,-90],
                                                style(
                  color=9,
                  rgbcolor={175,175,175},
                  fillColor=9,
                  rgbfillColor={175,175,175})),
              Rectangle(extent=[-100,90; -10,70],
                                                style(
                  color=9,
                  rgbcolor={175,175,175},
                  fillColor=9,
                  rgbfillColor={175,175,175})),
              Rectangle(extent=[-100,-70; -10,-90],
                                                style(
                  color=9,
                  rgbcolor={175,175,175},
                  fillColor=9,
                  rgbfillColor={175,175,175})),
                         Rectangle(extent=[10,70; 100,50], style(
              color=47,
              rgbcolor={255,170,85},
              fillColor=47,
              rgbfillColor={255,170,85}))),
            Diagram);
    end TurboBase;

    partial model TurboBase1 "Turbine-generator rotor base "
      extends Partials.TurboBase;
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
        Documentation(
              info="<html>
</html>
"),     Icon(
         Text(
        extent=[-100,-100; 100,-140],
        string="%name",
        style(color=0)),
          Polygon(points=[-100,70; -100,40; -20,70; -100,70], style(
              color=42,
              rgbcolor={176,0,0},
              fillColor=42,
              rgbfillColor={176,0,0})),
          Polygon(points=[-100,-70; -100,-40; -20,-70; -100,-70], style(
              color=42,
              rgbcolor={176,0,0},
              fillColor=42,
              rgbfillColor={176,0,0}))),
        Diagram);
    end TurboBase1;

    partial model TurboBase2 "Turbine-generator rotor base "
      extends Partials.TurboBase;
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
        Documentation(
              info="<html>
</html>
"),     Icon(
          Rectangle(extent=[-100,70; -10,-70], style(
              color=68,
              rgbcolor={170,213,255},
              fillColor=68,
              rgbfillColor={170,213,255},
              fillPattern=1))),
        Diagram);
    end TurboBase2;

    partial model TurboBase3 "Turbine-generator rotor base "
      extends Partials.TurboBase;
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
        Documentation(
              info="<html>
</html>
"),     Icon(
          Rectangle(extent=[-100,70; -10,-70], style(
              color=45,
              rgbcolor={255,128,0},
              fillColor=45,
              rgbfillColor={255,128,0},
              fillPattern=1))),
        Diagram);
    end TurboBase3;

    partial model TurboBase4 "Turbine-generator rotor base "
      extends Partials.TurboBase;
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
        Documentation(
              info="<html>
</html>
"),     Icon(
          Rectangle(extent=[-100,90; -10,-90], style(
              color=51,
              rgbcolor={255,255,170},
              fillColor=51,
              rgbfillColor={255,255,170},
              fillPattern=1)),
          Rectangle(extent=[-100,14; -10,-14],
                                            style(
              color=9,
              rgbcolor={175,175,175},
              fillColor=9,
              rgbfillColor={175,175,175}))),
        Diagram);
    end TurboBase4;
  end Partials;

end TurboGroups;
