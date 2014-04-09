within Spot;
package GenerationACdqo "Turbo generator groups dqo"
  extends Base.Icons.Library;
  import Spot.Base.Transforms.j_dqo;


  model TurboGenerator "Turbo generator single mass"
    extends Partials.GenBase_el;

    replaceable Spot.Mechanics.TurboGroups.SingleMassTG rotor(
      final w_ini=w_ini,
      final H=H,
      final P_nom=generator.par.S_nom,
      final w_nom=w_nom) "single-mass rotor (turbine-rotor + generator-rotor)"
     annotation (Placement(transformation(extent={{-60,-10},{-40,10}}, rotation
            =0)));


  equation
    connect(rotor.airgap, generator.airgap)
    annotation (Line(points={{-40,6},{50,6}}, color={0,0,0}));
    connect(rotor.speed, governor.speed)
                                       annotation (Line(points={{-56,10},{-56,
            50}}, color={0,0,127}));
    connect(governor.power, rotor.power)
                                       annotation (Line(points={{-44,50},{-44,
            10}}, color={0,0,127}));
  annotation (defaultComponentName = "turboGen1",
    Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
    Documentation(
            info="<html>
<p>Turbo generator model with governor and exciter.<br>
One-mass model, turbine- and generator-rotor represent one single rigid mass.<br>
The machine inertia is determined by the inertia time constant H.</p>
<p>Steady-state initialisation:<br>
If combined with 'Control.Setpoints.Set_w_p_v' or similar, the setpoint values <tt>p_set</tt> and <tt>v_set</tt> are determined at initialisation from initial active power and voltage. The corresponding value for the speed <tt>w_set</tt> is determined by the system frequency <tt>system.f0</tt>.</p>
</html>"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Polygon(
            points={{-20,70},{-94,30},{-94,-30},{-20,-70},{-20,70}},
            lineColor={95,95,95},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics));
  end TurboGenerator;

  model TurboGrpGenerator "Example turbogroup generator"
    extends Partials.GenBase_el(final H=h);

    replaceable Spot.Mechanics.TurboGroups.PcontrolTorque turbTorq(final
        rpm_nom=
        turboGroup.par.rpm_nom, final P_nom=turboGroup.par.P_nom)
      "torque-model"                 annotation (Placement(transformation(
            extent={{-60,-10},{-40,10}}, rotation=0)));
    replaceable Spot.Mechanics.TurboGroups.SteamTurboGroup turboGroup(final
        w_ini=
          w_ini) "steam turbo-goup with generator-rotor"
                                            annotation (Placement(
          transformation(extent={{-10,-10},{10,10}}, rotation=0)));
  protected
    final parameter Modelica.SIunits.Time h=(sum(turboGroup.par.J_turb) +
        turboGroup.par.J_gen + sum(turboGroup.par.J_aux))*w_nom^2/(2
        *generator.par.S_nom) "inertia cst turb + gen";


  equation
    connect(turbTorq.blades, turboGroup.blades)
    annotation (Line(points={{-40,6},{-10,6}}, color={0,0,0}));
    connect(turboGroup.airgap, generator.airgap)
    annotation (Line(points={{10,6},{50,6}}, color={0,0,0}));
    connect(turbTorq.speed, governor.speed)
                                          annotation (Line(points={{-56,10},{
            -56,50}}, color={0,0,127}));
    connect(governor.power, turbTorq.power)
                                          annotation (Line(points={{-44,50},{
            -44,10}}, color={0,0,127}));
  annotation (defaultComponentName = "turboGrpGen1",
    Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
    Documentation(
            info="<html>
<p>Turbo generator model with governor and exciter.<br>
Turbo-group, with turbines and generator-rotor elastically coupled.</p>
<p>Steady-state initialisation:<br>
If combined with 'Control.Setpoints.Set_w_p_v' or similar, the setpoint values <tt>p_set</tt> and <tt>v_set</tt> are determined at initialisation from initial active power and voltage. The corresponding value for the speed <tt>w_set</tt> is determined by the system frequency <tt>system.f0</tt>.</p>
</html>"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Polygon(
            points={{-20,70},{-94,30},{-94,-30},{-20,-70},{-20,70}},
            lineColor={95,95,95},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid), Polygon(
            points={{-61,48},{-61,-48},{-57,-50},{-57,50},{-61,48}},
            lineColor={135,135,135},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics));
  end TurboGrpGenerator;

  model GTGenerator "Example gas turbine generator"
    extends Partials.GenBase_el(final H=h);

    replaceable Spot.Mechanics.TurboGroups.PcontrolTorque turbTorq(final
        rpm_nom=
          GT.par.rpm_nom, final P_nom=GT.par.P_nom) "torque-model"
                                     annotation (Placement(transformation(
            extent={{-60,-10},{-40,10}}, rotation=0)));
    replaceable Spot.Mechanics.TurboGroups.GasTurbineGear GT(final w_ini=w_ini)
      "gas turbine with gear and generator-rotor"
                                                annotation (Placement(
          transformation(extent={{-10,-10},{10,10}}, rotation=0)));
  protected
    final parameter Real[3] gr2=diagonal(GT.par.ratio)*GT.par.ratio/GT.par.ratio[end]^2;
    final parameter Modelica.SIunits.Inertia J_red=(GT.par.J_turb + GT.par.J_comp)
        *gr2[1] + GT.par.J_gear1*gr2[1:2] + GT.par.J_gear2*gr2[2:3] + (GT.par.J_acc
         + GT.par.J_cpl + GT.par.J_gen) "gear reduced inertia";
    final parameter Modelica.SIunits.Time h=J_red*w_nom^2/(2*generator.par.S_nom);


  equation
    assert(abs(2*pi*generator.par.f_nom/(generator.par.pp*
      GT.par.rpm_nom*Base.Types.rpm2w) - 1) < 1e-3,
      "nominal rpm, frequency and pole-pair number seems to be incompatible");
    connect(turbTorq.blades, GT.blades)
    annotation (Line(points={{-40,6},{-10,6}}, color={0,0,0}));
    connect(GT.airgap, generator.airgap)
    annotation (Line(points={{10,6},{50,6}}, color={0,0,0}));
    connect(turbTorq.speed, governor.speed)
                                          annotation (Line(points={{-56,10},{
            -56,50}}, color={0,0,127}));
    connect(governor.power, turbTorq.power)
                                          annotation (Line(points={{-44,50},{
            -44,10}}, color={0,0,127}));
  annotation (defaultComponentName = "turboGen1",
    Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
    Documentation(
            info="<html>
<p>Turbo generator model with governor and exciter.<br>
Gas turbine with gear and generator-rotor, elastically coupled.</p>
<p>Steady-state initialisation:<br>
If combined with 'Control.Setpoints.Set_w_p_v' or similar, the setpoint values <tt>p_set</tt> and <tt>v_set</tt> are determined at initialisation from initial active power and voltage. The corresponding value for the speed <tt>w_set</tt> is determined by the system frequency <tt>system.f0</tt>.</p>
<p>Note: for turbines with gear <tt>w_ini</tt> denotes the initial angular velocity at the generator-side!</p>
</html>"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Polygon(
            points={{-20,70},{-94,30},{-94,-30},{-20,-70},{-20,70}},
            lineColor={95,95,95},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-61,48},{-61,-48},{-57,-50},{-57,50},{-61,48}},
            lineColor={135,135,135},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-86,-10},{-26,-10}},
            color={0,0,0},
            thickness=0.5),
          Line(
            points={{-86,10},{-68,10}},
            color={0,0,0},
            thickness=0.5),
          Line(
            points={{-48,10},{-26,10}},
            color={0,0,0},
            thickness=0.5)}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics));
  end GTGenerator;

  model HydroGenerator "Hydro generator"
    extends Partials.GenBase_el(final H=h);

    replaceable Spot.Mechanics.TurboGroups.PcontrolTorque turbTorq(final
        rpm_nom=
          hydro.par.rpm_nom, final P_nom={hydro.par.P_nom}) "torque-model"
                                     annotation (Placement(transformation(
            extent={{-60,-10},{-40,10}}, rotation=0)));
    replaceable Spot.Mechanics.TurboGroups.HydroTurbine hydro(final w_ini=w_ini)
      "hydro turbine with generator-rotor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0)));
  protected
    final parameter Modelica.SIunits.Time h=(hydro.par.J_turb + hydro.par.J_gen)
        *w_nom^2/(2*generator.par.S_nom);


  equation
    assert(abs(2*pi*generator.par.f_nom/(generator.par.pp*
      hydro.par.rpm_nom*Base.Types.rpm2w) - 1) < 1e-3,
      "nominal rpm, frequency and pole-pair number seems to be incompatible");
    connect(turbTorq.blades, hydro.blades)
    annotation (Line(points={{-40,6},{-10,6}}, color={0,0,0}));
    connect(hydro.airgap, generator.airgap)
    annotation (Line(points={{10,6},{50,6}}, color={0,0,0}));
    connect(turbTorq.speed, governor.speed)
                                          annotation (Line(points={{-56,10},{
            -56,50}}, color={0,0,127}));
    connect(governor.power, turbTorq.power)
                                          annotation (Line(points={{-44,50},{
            -44,10}}, color={0,0,127}));
  annotation (defaultComponentName = "hydroGen1",
    Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
    Documentation(
            info="<html>
<p>Hydro generator model with governor and exciter.<br>
Hydro turbine and generator-rotor, elastically coupled.</p>
<p>Steady-state initialisation:<br>
If combined with 'Control.Setpoints.Set_w_p_v' or similar, the setpoint values <tt>p_set</tt> and <tt>v_set</tt> are determined at initialisation from initial active power and voltage. The corresponding value for the speed <tt>w_set</tt> is determined by the system frequency <tt>system.f0</tt>.</p>
</html>"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Rectangle(
            extent={{-70,50},{-30,-52}},
            lineColor={95,95,95},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-70,70},{-30,30}},
            lineColor={95,95,95},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-70,-30},{-30,-70}},
            lineColor={95,95,95},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics));
  end HydroGenerator;

  model DieselGenerator "Diesel generator"
    extends Partials.GenBase_el(final H=h);

    replaceable Spot.Mechanics.TurboGroups.PcontrolTorque turbTorq(final
        rpm_nom=
      diesel.par.rpm_nom, final P_nom={diesel.par.P_nom}) "torque-model"
                                     annotation (Placement(transformation(
            extent={{-60,-10},{-40,10}}, rotation=0)));
    replaceable Spot.Mechanics.TurboGroups.Diesel diesel(final w_ini=w_ini)
      "Diesel engine with generator-rotor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0)));
  protected
    final parameter Modelica.SIunits.Time h=(diesel.par.J_turb + diesel.par.J_gen)
        *w_nom^2/(2*generator.par.S_nom);


  equation
    assert(abs(2*pi*generator.par.f_nom/(generator.par.pp*
      diesel.par.rpm_nom*Base.Types.rpm2w) - 1) < 1e-3,
      "nominal rpm, frequency and pole-pair number seems to be incompatible");
    connect(turbTorq.blades, diesel.blades)
    annotation (Line(points={{-40,6},{-10,6}}, color={0,0,0}));
    connect(diesel.airgap, generator.airgap)
    annotation (Line(points={{10,6},{50,6}}, color={0,0,0}));
    connect(turbTorq.speed, governor.speed)
                                          annotation (Line(points={{-56,10},{
            -56,50}}, color={0,0,127}));
    connect(governor.power, turbTorq.power)
                                          annotation (Line(points={{-44,50},{
            -44,10}}, color={0,0,127}));
  annotation (defaultComponentName = "dieselGen1",
    Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
    Documentation(
            info="<html>
<p>Diesel generator model with Diesel-controller and exciter.<br>
Diesel-engine and generator-rotor, elastically coupled.</p>
<p>Steady-state initialisation:<br>
If combined with 'Control.Setpoints.Set_w_p_v' or similar, the setpoint values <tt>p_set</tt> and <tt>v_set</tt> are determined at initialisation from initial active power and voltage. The corresponding value for the speed <tt>w_set</tt> is determined by the system frequency <tt>system.f0</tt>.</p>
</html>"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Rectangle(
            extent={{-90,50},{-20,-70}},
            lineColor={95,95,95},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-85,-6},{-25,-66}},
            lineColor={95,95,95},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-80,70},{-30,50}},
            lineColor={95,95,95},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics));
  end DieselGenerator;

  model TurboPMgenerator "Turbo generator single mass, permanent magnet"
    extends Partials.GenBase;

    Base.Interfaces.ACdqo_n term "negative terminal"
      annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation
            =0)));
    Modelica.Blocks.Interfaces.RealInput[2] setpts
      "setpoints {speed, power} pu"
    annotation (Placement(transformation(extent={{-110,10},{-90,-10}}, rotation
            =0)));
    Modelica.Blocks.Interfaces.RealOutput phiRotor "rotor angle el" annotation
      (Placement(transformation(
          origin={100,100},
          extent={{10,-10},{-10,10}},
          rotation=180)));
    replaceable Spot.ACdqo.Machines.Synchron3rd_pm generator(
      final w_el_ini=w_ini*generator.par.pp) "synchron pm generator"
      annotation (                       choices(
      choice(redeclare Spot.ACdqo.Machines.Synchron3rd_pm generator "3rd order"),
      choice(redeclare Spot.ACdqo.Machines.Synchron_pm generator "nth order")),
        Placement(transformation(extent={{60,-10},{40,10}}, rotation=0)));
    replaceable Spot.Control.Governors.GovernorConst governor
      "governor (control)"
    annotation (                         choices(
    choice(redeclare Spot.Control.Governors.GovernorConst governor "constant"),
    choice(redeclare Spot.Control.Governors.Governor1st governor "1st order")),
        Placement(transformation(extent={{-60,30},{-40,50}}, rotation=0)));
    parameter Modelica.SIunits.Time H=10 "inertia cst turb + gen";
    replaceable Spot.Mechanics.TurboGroups.SingleMassTG rotor(
      final w_ini=w_ini,
      final H=H,
      final P_nom=generator.par.S_nom,
      final w_nom=w_nom) "single-mass rotor (turbine-rotor + generator-rotor)"
     annotation (Placement(transformation(extent={{-60,-10},{-40,10}}, rotation
            =0)));
  protected
    final parameter SI.AngularVelocity w_nom=2*pi*generator.par.f_nom/generator.par.pp
      "nominal angular velocity";
    final parameter SI.AngularVelocity w_ini=speed_ini*w_nom
      "initial angular velocity";

  equation
    connect(setpts[1], governor.setptSpeed)
                                          annotation (Line(points={{-100,5},{
            -90,5},{-90,44},{-60,44}}, color={0,0,127}));
    connect(setpts[2], governor.setptPower)
                                          annotation (Line(points={{-100,-5},{
            -80,-5},{-80,36},{-60,36}}, color={0,0,127}));
    connect(rotor.speed, governor.speed)
                                       annotation (Line(points={{-56,10},{-56,
            30}}, color={0,0,127}));
    connect(governor.power, rotor.power)
                                       annotation (Line(points={{-44,30},{-44,
            10}}, color={0,0,127}));
    connect(rotor.airgap, generator.airgap)
    annotation (Line(points={{-40,6},{50,6}}, color={0,0,0}));
    connect(generator.heat, heat) annotation (Line(points={{50,10},{50,40},{0,
            40},{0,100}}, color={176,0,0}));
    connect(generator.term, term)
      annotation (Line(points={{60,0},{100,0}}, color={0,120,120}));
    connect(generator.phiRotor, phiRotor)     annotation (Line(points={{40,10},
            {30,10},{30,100},{100,100}}, color={0,0,127}));
  annotation (defaultComponentName = "turboPMgen",
    Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
    Documentation(
            info="<html>
<p>Turbo generator model with governor and pm machine.<br>
One-mass model, turbine- and generator-rotor represent one single rigid mass.<br>
The machine inertia is determined by the inertia time constant H.</p>
</html>"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Polygon(
            points={{-90,10},{-20,30},{-20,-32},{-90,-10},{-90,10}},
            lineColor={95,95,95},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics));
  end TurboPMgenerator;

  model PMgenerator "Generator inverter time-average"
    extends Partials.GenBase_ctrl(heat_adapt(final m={2,inverter.heat.m}));

    replaceable ACdqo.Machines.Synchron3rd_ctrl generator(final w_el_ini=rpm_ini*
          Base.Types.rpm2w*generator.par.pp) "synchron pm generator"
      annotation (                       choices(
      choice(redeclare Spot.ACdqo.Machines.Synchron3rd_ctrl generator
            "3rd order"),
      choice(redeclare Spot.ACdqo.Machines.Synchron_ctrl generator "nth order")),
        Placement(transformation(extent={{40,-10},{20,10}}, rotation=0)));
    replaceable ACdqo.Inverters.InverterAverage inverter
      constrainedby ACdqo.Inverters.Partials.AC_DC_base
      "inverter (average or modulated)"
      annotation (                        choices(
      choice(redeclare Spot.ACdqo.Inverters.InverterAverage inverter
            "inverter time-average"),
      choice(redeclare Spot.ACdqo.Inverters.Inverter inverter
            "inverter with modulator")), Placement(transformation(extent={{80,
              -10},{60,10}}, rotation=0)));


  equation
    connect(rotor.flange_n, generator.airgap) annotation (Line(points={{0,0},{
            10,0},{10,6},{30,6}}, color={0,0,0}));
    connect(generator.term, inverter.AC)
      annotation (Line(points={{40,0},{60,0}}, color={0,120,120}));
    connect(inverter.DC, term)
      annotation (Line(points={{80,0},{100,0}}, color={0,0,255}));
    connect(generator.heat, heat_adapt.port_a) annotation (Line(points={{30,10},
            {30,54},{-4,54},{-4,64}}, color={176,0,0}));
    connect(inverter.heat, heat_adapt.port_b) annotation (Line(points={{70,10},
            {70,64},{4,64}}, color={176,0,0}));
    connect(generator.phiRotor, inverter.theta)   annotation (Line(points={{20,
            10},{14,10},{14,20},{86,20},{86,10},{76,10}}, color={0,0,127}));
    connect(generator.uPhasor, inverter.uPhasor)
      annotation (Line(points={{40,10},{64,10}}, color={0,0,127}));
    connect(generator.i_meas, i_meas)       annotation (Line(points={{36,10},{
            36,40},{60,40},{60,100}}, color={0,0,127}));
    connect(i_act, generator.i_act)       annotation (Line(points={{-60,100},{
            -60,40},{24,40},{24,10}}, color={0,0,127}));
    annotation (
      defaultComponentName="pmGen_ctrl",
      Diagram(graphics),
      Documentation(info="<html>
<p>Generator with pm excitation and inverter for current-control. To be coupled to a mechanical engine. May contain a gear.</p>
<p>Note: for machines with gear <tt>w_ini</tt> denotes the initial angular velocity at the generator-side!</p>
</html>"), Icon(graphics={
          Rectangle(
            extent={{-50,14},{-40,-14}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={175,175,175}),
          Rectangle(
            extent={{-50,46},{-40,14}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={175,175,175}),
          Rectangle(
            extent={{-40,3},{-20,-3}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={215,215,215}),
          Rectangle(
            extent={{-70,33},{-50,27}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={215,215,215}),
          Rectangle(
            extent={{-80,40},{-70,20}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={175,175,175}),
          Rectangle(
            extent={{-80,20},{-70,-20}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={175,175,175}),
          Rectangle(
            extent={{-100,10},{-80,-10}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={215,215,215})}));
  end PMgenerator;

  model WindGenerator "Wind generator"
    extends Partials.GenBase;

    Base.Interfaces.ACdqo_n term "negative terminal"
      annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation
            =0)));
    replaceable Spot.ACdqo.Machines.Asynchron generator(w_el_ini=w_ini*generator.par.pp)
      "asynchron generator"             annotation (Placement(transformation(
            extent={{60,-10},{40,10}}, rotation=0)));
    replaceable Spot.Mechanics.TurboGroups.WindTabTorque turbTorq(final rpm_nom=
         WT.par.rpm_nom, final P_nom=WT.par.P_nom) "table: wind speed, torque"
                       annotation (Placement(transformation(extent={{-60,-10},{
              -40,10}}, rotation=0)));
    replaceable Spot.Mechanics.TurboGroups.WindTurbineGear WT(final w_ini=
          w_ini) "wind turbine with generator-rotor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0)));
    Modelica.Blocks.Interfaces.RealInput windSpeed "wind speed m/s" annotation
      (Placement(transformation(extent={{-110,10},{-90,-10}}, rotation=0)));
  protected
    final parameter SI.AngularVelocity w_ini=speed_ini*2*pi*generator.par.f_nom/generator.par.pp
      "initial angular velocity";

  equation
    connect(windSpeed, turbTorq.windSpeed)
    annotation (Line(points={{-100,0},{-60,0}}, color={0,0,127}));
    connect(turbTorq.blades, WT.blades[1])
    annotation (Line(points={{-40,6},{-10,6}}, color={0,0,0}));
    connect(WT.airgap, generator.airgap)
    annotation (Line(points={{10,6},{50,6}}, color={0,0,0}));
    connect(generator.term, term)
    annotation (Line(points={{60,0},{100,0}}, color={0,120,120}));
    connect(generator.heat, heat) annotation (Line(points={{50,10},{50,40},{0,
            40},{0,100}}, color={176,0,0}));
  annotation (defaultComponentName = "windGen1",
    Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
    Documentation(
            info="<html>
<p>Wind generator.<br>
Turbine with gear and generator-rotor, elastically coupled, asynchronous generator.</p>
<p>Note: for turbines with gear <tt>w_ini</tt> denotes the initial angular velocity at the generator-side!</p>
</html>"),
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Polygon(
            points={{-55,-120},{-55,120},{-47,80},{-39,40},{-39,20},{-43,6},{
                -55,0},{-67,-6},{-71,-20},{-71,-40},{-65,-80},{-55,-120}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics));
  end WindGenerator;

  package Partials "Partial models"
    partial model GenBase0 "Generation base"

      Base.Interfaces.ThermalV_n heat(m=2) "heat source port {stator, rotor}"
        annotation (Placement(transformation(
            origin={0,100},
            extent={{-10,-10},{10,10}},
            rotation=90)));
    protected
      outer Spot.System system;

    annotation (
        Window(
    x=0.45,
        y=0.01,
        width=0.44,
    height=0.65),
        Documentation(
        info="<html>
</html>"),
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Rectangle(
              extent={{-100,80},{90,-80}},
              lineColor={95,95,95},
              fillColor={184,189,116},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{88,54},{-20,-54}},
              lineColor={95,95,95},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-20,0},{88,0}},
              color={176,0,0},
              thickness=0.5),
            Text(
              extent={{-16,30},{84,-70}},
              lineColor={176,0,0},
              lineThickness=0.5,
              fillColor={127,0,255},
              fillPattern=FillPattern.Solid,
              textString=
                 "~"),
            Text(
              extent={{-100,-90},{100,-130}},
              lineColor={0,0,0},
              textString=
                     "%name")}),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics));
    end GenBase0;
    extends Base.Icons.Partials;


    partial model GenBase "Generation base"
      extends GenBase0;

      parameter Spot.Base.Types.AngularVelocity speed_ini(unit="pu")=1
        "initial speed (start-value if ini='st')"
      annotation(Dialog(enable=not system.steadyIni));
      Base.Interfaces.ACdqo_n term "negative terminal"
        annotation (Placement(transformation(extent={{90,-10},{110,10}},
              rotation=0)));
    annotation (
        Window(
    x=0.45,
        y=0.01,
        width=0.44,
    height=0.65),
        Documentation(
        info="<html>
</html>"),
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics));
    end GenBase;

    partial model GenBase_el "Generation base el, synchron machines"
      extends GenBase;

      parameter Spot.Base.Types.IniType iniType=Spot.Base.Types.v_alpha
        "initialisation type (if system.ini='st')";
      parameter Spot.Base.Types.Voltage v_ini(unit="pu")=1
        "initial terminal voltage"
        annotation(Dialog(enable=system.steadyIni and (iniType==Base.Types.v_alpha or iniType==Base.Types.v_p or iniType==Base.Types.v_q)));
      parameter Modelica.SIunits.Angle alpha_ini=system.alpha0
        "initial voltage phase angle"
        annotation(Dialog(enable=system.steadyIni and iniType==Base.Types.v_alpha));
      parameter Spot.Base.Types.Power p_ini(unit="pu")=1
        "initial terminal active power"
        annotation(Dialog(enable=system.steadyIni and (iniType==Base.Types.v_p or iniType==Base.Types.p_q)));
      parameter Spot.Base.Types.Power q_ini(unit="pu")=1
        "initial terminal reactive power"
        annotation(Dialog(enable=system.steadyIni and (iniType==Base.Types.v_q or iniType==Base.Types.p_q)));
      parameter Boolean dispPA=false "display power angle"
        annotation(Evaluate=true);
      Base.Interfaces.ACdqo_n term "negative terminal"
        annotation (Placement(transformation(extent={{90,-10},{110,10}},
              rotation=0)));
      Modelica.Blocks.Interfaces.RealInput[3] setpts
        "setpoints {speed, power, voltage} pu"
        annotation (Placement(transformation(extent={{-110,10},{-90,-10}},
              rotation=0)));
      replaceable Spot.ACdqo.Machines.Synchron3rd_el generator(final w_el_ini=w_ini*generator.par.pp)
        "synchron generator"
        annotation (                       choices(
        choice(redeclare Spot.ACdqo.Machines.Synchron3rd_el generator
              "3rd order"),
        choice(redeclare Spot.ACdqo.Machines.Synchron_el generator "nth order")),
          Placement(transformation(extent={{60,-10},{40,10}}, rotation=0)));
      replaceable Spot.Control.Exciters.ExciterConst exciter
        "exciter (control)"
        annotation (                       choices(
        choice(redeclare Spot.Control.Exciters.ExciterConst exciter "constant"),
        choice(redeclare Spot.Control.Exciters.Exciter1st exciter "1st order")),
          Placement(transformation(extent={{60,50},{40,70}}, rotation=0)));
      replaceable Spot.ACdqo.Machines.Control.Excitation excitation(V_nom=generator.par.V_nom,
          Vf_nom=generator.Vf_nom) "exciter (electric)"
                                                     annotation (Placement(
            transformation(extent={{60,20},{40,40}}, rotation=0)));
      replaceable Spot.Control.Governors.GovernorConst governor
        "governor (control)"
        annotation (                         choices(
        choice(redeclare Spot.Control.Governors.GovernorConst governor
              "constant"),
        choice(redeclare Spot.Control.Governors.Governor1st governor
              "1st order")), Placement(transformation(extent={{-60,50},{-40,70}},
              rotation=0)));
      parameter Modelica.SIunits.Time H=10 "inertia cst turb + gen";
    protected
      final parameter SI.AngularVelocity w_nom=2*pi*generator.par.f_nom/generator.par.pp
        "nominal angular velocity";
      final parameter SI.AngularVelocity w_ini=speed_ini*w_nom
        "initial angular velocity";
      Spot.Base.Interfaces.SenderFreq sender "sends weighted frequency"
        annotation (Placement(transformation(extent={{40,90},{60,110}},
              rotation=0)));
      function atan2 = Modelica.Math.atan2;

    initial equation
      if iniType == Spot.Base.Types.v_alpha then
        sqrt(term.v[1:2]*term.v[1:2]) = v_ini*generator.par.V_nom;
        atan2(term.v[2], term.v[1]) = alpha_ini;
      elseif iniType == Spot.Base.Types.v_p then
        sqrt(term.v[1:2]*term.v[1:2]) = v_ini*generator.par.V_nom;
        -term.v[1:2]*term.i[1:2] = p_ini*generator.par.S_nom;
      elseif iniType == Spot.Base.Types.v_q then
        sqrt(term.v[1:2]*term.v[1:2]) = v_ini*generator.par.V_nom;
        -{term.v[2],-term.v[1]}*term.i[1:2] = q_ini*generator.par.S_nom;
      elseif iniType == Spot.Base.Types.p_q then
        -term.v[1:2]*term.i[1:2] = p_ini*generator.par.S_nom;
        -{term.v[2],-term.v[1]}*term.i[1:2] = q_ini*generator.par.S_nom;
      end if;

    equation
      if iniType == Spot.Base.Types.v_alpha then
        Connections.potentialRoot(term.theta);
      end if;
      if Connections.isRoot(term.theta) then
        term.theta = if system.synRef then {0, system.theta} else {system.theta, 0};
      end if;

      sender.sendFreq.H_w = -H*generator.w_el;
      sender.sendFreq.H = -H;

      connect(term, generator.term)
        annotation (Line(points={{100,0},{80,0},{80,0},{60,0}}, color={0,130,
              175}));
      connect(sender.sendFreq, system.receiveFreq);
      connect(exciter.fieldVoltage,excitation.fieldVoltage) annotation (Line(
            points={{44,50},{44,40}}, color={0,0,127}));
      connect(excitation.termVoltage, exciter.termVoltage)
                                                          annotation (Line(
            points={{56,40},{56,50}}, color={0,0,127}));
      connect(setpts[1], governor.setptSpeed) annotation (Line(points={{-100,
              6.66667},{-88,6.66667},{-88,64},{-60,64}}, color={0,0,127}));
      connect(setpts[2], governor.setptPower) annotation (Line(points={{-100,
              -4.44089e-16},{-80,-4.44089e-16},{-80,56},{-60,56}}, color={0,0,
              127}));
      connect(setpts[3], exciter.setptVoltage) annotation (Line(points={{-100,
              -6.66667},{-70,-6.66667},{-70,80},{70,80},{70,60},{60,60}}, color
            ={0,0,127}));
      connect(generator.term, excitation.term) annotation (Line(points={{60,0},
              {80,0},{80,30},{60,30}}, color={0,120,120}));
      connect(excitation.field, generator.field)
        annotation (Line(points={{60,26},{76,26},{76,-4},{60,-4}}, color={0,0,
              255}));
      connect(generator.heat, heat) annotation (Line(points={{50,10},{50,16},{0,
              16},{0,100}}, color={176,0,0}));
      annotation (
        Window(
          x=
    0.45, y=
    0.01, width=
        0.44,
          height=
         0.65),
        Documentation(
              info="<html>
<p>
Setpoint values for turbine-speed, -power and terminal-voltage are determined through the input-connector 'setpts' (see also 'governor' and 'exciter').
<pre>
  setpts[1]:     turbine speed pu
  setpts[2]:     turbine power pu
  setpts[3]:     terminal voltage-norm pu
</pre>
<p>
Constant setpoint values can be obtained at (steady-state) initialisation when using Control.CstSetpointsGen.</p>
</html>"),
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics));
    end GenBase_el;

    partial model GenBase_ctrl "Generation base pm, synchronous machines"
      extends GenBase0(heat(final m=sum(heat_adapt.m)));

      parameter SIpu.AngularVelocity_rpm rpm_ini=0
        "initial rpm (start-value if ini='st')"
        annotation(Dialog(enable=not system.steadyIni));
      Base.Interfaces.Rotation_p flange
                                      annotation (Placement(transformation(
              extent={{-110,-10},{-90,10}}, rotation=0)));
      Base.Interfaces.ElectricV_n term(final m=2) "negative terminal"
        annotation (Placement(transformation(extent={{90,-10},{110,10}},
              rotation=0)));
      Common.Thermal.HeatV_a_b_ab heat_adapt annotation (Placement(
            transformation(extent={{-10,60},{10,80}}, rotation=0)));
      replaceable Mechanics.Rotation.NoGear gear "type of gear"
      annotation (                          choices(
      choice(redeclare Spot.Mechanics.Rotation.Joint gear "no gear"),
      choice(redeclare Spot.Mechanics.Rotation.GearNoMass gear "massless gear"),
      choice(redeclare Spot.Mechanics.Rotation.Gear gear "massive gear")),
          Placement(transformation(extent={{-60,-10},{-40,10}}, rotation=0)));
      replaceable Mechanics.Rotation.Rotor rotor(w(start=rpm_ini*Base.Types.rpm2w))
        "rotor generator"          annotation (Placement(transformation(extent=
                {{-20,-10},{0,10}}, rotation=0)));
      Modelica.Blocks.Interfaces.RealOutput[2] i_meas(final unit="pu")
        "measured current {i_d, i_q} pu" annotation (Placement(transformation(
            origin={60,100},
            extent={{-10,-10},{10,10}},
            rotation=90)));
      Modelica.Blocks.Interfaces.RealInput[2] i_act(final unit="pu")
        "actuated current {i_d, i_q} pu" annotation (Placement(transformation(
            origin={-60,100},
            extent={{10,-10},{-10,10}},
            rotation=90)));

    equation
      connect(heat_adapt.port_ab, heat)
        annotation (Line(points={{0,76},{0,100}}, color={176,0,0}));
      connect(flange, gear.flange_p)
        annotation (Line(points={{-100,0},{-60,0}}, color={0,0,0}));
      connect(gear.flange_n, rotor.flange_p)
        annotation (Line(points={{-40,0},{-20,0}}, color={0,0,0}));
      annotation (
        Window(
          x=
    0.45, y=
    0.01, width=
        0.44,
          height=
         0.65),
        Documentation(
              info="<html>
</html>"),
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Rectangle(
              extent={{-90,112},{90,88}},
              lineColor={0,0,127},
              fillColor={170,213,255},
              fillPattern=FillPattern.Solid)}),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics));
    end GenBase_ctrl;

    annotation (       Window(
  x=0.05,
  y=0.44,
  width=0.31,
  height=0.23,
  library=1,
  autolayout=1));
  end Partials;
  annotation (preferedView="info",
Window(
  x=0.05,
  y=0.41,
  width=0.4,
  height=0.32,
  library=1,
  autolayout=1),
Documentation(info="<html>
<p>Combined turbine-generator systems with governor and exciter, both electrical and mechanical model.</p>
<p>Heat ports must be connected. In cases where they are not needed, use 'Common.Thermal.BdCond(V)'.</p><p><a <p><a href=\"Spot.UsersGuide.Overview\">up users guide</a></p>
</html>"));
end GenerationACdqo;
