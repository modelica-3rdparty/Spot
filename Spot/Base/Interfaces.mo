within Spot.Base;
package Interfaces "Interfaces "
  extends Icons.Base;


  connector Electric_p "Electric terminal ('positive')"
    extends Connectors.Electric;
    annotation (defaultComponentName = "term_p",
  Documentation(info="<html>
</html>
"),
  Window(
    x=0.45,
    y=0.01,
    width=0.44,
    height=0.65),
  Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{0,50},{100,-50}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-120,120},{100,60}},
            lineColor={0,0,255},
            textString=
             "%name")}));
  end Electric_p;

  connector Electric_n "Electric terminal ('negative')"
    extends Connectors.Electric;
    annotation (defaultComponentName = "term_n",
  Documentation(info="<html>
</html>"),
  Window(
    x=0.45,
    y=0.01,
    width=0.44,
    height=0.65),
  Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{-100,50},{0,-50}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-100,120},{120,60}},
            lineColor={0,0,255},
            textString=
             "%name")}));
  end Electric_n;

  connector ElectricV_p "Electric vector terminal ('positive')"
    parameter Integer m(final min=1)=2 "number of single contacts";
    Connectors.Electric[m] pin "vector of single contacts";
  annotation (defaultComponentName = "term_p",
    Documentation(info="<html>
<p>Electric connector with a vector of 'pin's, positive.</p>
</html>
"), Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Polygon(
            points={{-120,0},{0,-120},{120,0},{0,120},{-120,0}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-60,60},{60,-60}},
            lineColor={255,255,255},
            pattern=LinePattern.None,
            textString=
                 "%m")}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Text(
            extent={{-120,120},{100,60}},
            lineColor={0,0,255},
            textString=
               "%name"),
          Polygon(
            points={{-20,0},{40,-60},{100,0},{40,60},{-20,0}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-10,50},{90,-50}},
            lineColor={255,255,255},
            pattern=LinePattern.None,
            textString=
                 "%m")}));
  end ElectricV_p;

  connector ElectricV_n "Electric vector terminal ('negative')"
    parameter Integer m(final min=1)=2 "number of single contacts";
    Connectors.Electric[m] pin "vector of single contacts";
  annotation (defaultComponentName = "term_n",
    Documentation(info="<html>
<p>Electric connector with a vector of 'pin's, negative.</p>
</html>"),
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Polygon(
            points={{-120,0},{0,-120},{120,0},{0,120},{-120,0}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-60,60},{60,-60}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            lineThickness=0.5,
            textString=
                 "%m")}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Text(
            extent={{-100,120},{120,60}},
            lineColor={0,0,255},
            textString=
               "%name"),
          Polygon(
            points={{-100,0},{-40,-60},{20,0},{-40,60},{-100,0}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-90,50},{10,-50}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            lineThickness=0.5,
            textString=
                 "%m")}));
  end ElectricV_n;

  connector ACabc_p "AC terminal, 3-phase abc ('positive')"
    extends Connectors.AC3ph;
  annotation (defaultComponentName = "term_p",
    Documentation(info="<html>
<p>AC connector with vector variables in abc-representation, positive.</p>
</html>"),
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Ellipse(
            extent={{-100,100},{100,-100}},
            lineColor={0,130,175},
            fillColor={0,130,175},
            fillPattern=FillPattern.Solid), Text(
            extent={{-60,60},{60,-60}},
            lineColor={255,255,255},
            textString=
                 "abc")}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Text(
            extent={{-120,120},{100,60}},
            lineColor={0,130,175},
            textString=
               "%name"),
          Ellipse(
            extent={{0,50},{100,-50}},
            lineColor={0,130,175},
            fillColor={0,130,175},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{12,40},{90,-40}},
            lineColor={255,255,255},
            pattern=LinePattern.None,
            textString=
                 "abc")}));
  end ACabc_p;

  connector ACabc_n "AC terminal, 3-phase abc ('negative')"
    extends Connectors.AC3ph;
  annotation (defaultComponentName = "term_n",
    Documentation(info="<html>
<p>AC connector with vector variables in abc-representation, negative.</p>
</html>"),
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Ellipse(
            extent={{-100,100},{100,-100}},
            lineColor={0,130,175},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-60,60},{60,-60}},
            lineColor={0,130,175},
            textString=
                 "abc")}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Text(
            extent={{-100,120},{120,60}},
            lineColor={0,130,175},
            textString=
             "%name"),
          Ellipse(
            extent={{-100,50},{0,-50}},
            lineColor={0,130,175},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-90,40},{-10,-40}},
            lineColor={0,130,175},
            textString=
                 "abc")}));
  end ACabc_n;

  connector ACdqo_p "AC terminal, 3-phase dqo ('positive')"
    extends Connectors.AC3ph;
  annotation (defaultComponentName = "term_p",
    Documentation(info="<html>
<p>AC connector with vector variables in dqo-representation, positive.</p>
</html>"),
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Ellipse(
            extent={{-100,100},{100,-100}},
            lineColor={0,120,120},
            fillColor={0,120,120},
            fillPattern=FillPattern.Solid), Text(
            extent={{-60,60},{60,-60}},
            lineColor={255,255,255},
            textString=
                 "dqo")}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Ellipse(
            extent={{0,50},{100,-50}},
            lineColor={0,120,120},
            fillColor={0,120,120},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{12,40},{90,-40}},
            lineColor={255,255,255},
            pattern=LinePattern.None,
            textString=
                 "dqo"),
          Text(
            extent={{-120,120},{100,60}},
            lineColor={0,120,120},
            textString=
                 "%name")}));
  end ACdqo_p;

  connector ACdqo_n "AC terminal, 3-phase dqo ('negative')"
    extends Connectors.AC3ph;
  annotation (defaultComponentName = "term_n",
    Documentation(info="<html>
<p>AC connector with vector variables in dqo-representation, negative.</p>
</html>"),
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Ellipse(
            extent={{-100,100},{100,-100}},
            lineColor={0,120,120},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-60,60},{60,-60}},
            lineColor={0,120,120},
            textString=
                 "dqo")}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Ellipse(
            extent={{-100,50},{0,-50}},
            lineColor={0,120,120},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-90,40},{-10,-40}},
            lineColor={0,120,120},
            textString=
                 "dqo"),
          Text(
            extent={{-100,120},{120,60}},
            lineColor={0,120,120},
            fillColor={0,100,100},
            fillPattern=FillPattern.Solid,
            textString=
             "%name")}));
  end ACdqo_n;

  connector Rotation_p "Rotational flange ('positive') "
    extends Connectors.Rotation;
  annotation (defaultComponentName = "flange_p",
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Documentation(info="<html>
<p>Mechanical rotational connector (also electro-mechanical), positive.</p>
</html>
"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Ellipse(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Ellipse(
            extent={{0,50},{100,-50}},
            lineColor={0,0,0},
            fillColor={128,128,128},
            fillPattern=FillPattern.Solid), Text(
            extent={{-120,120},{100,60}},
            lineColor={95,95,95},
            textString=
               "%name")}));
  end Rotation_p;

  connector Rotation_n "Rotational flange ('negative') "
    extends Connectors.Rotation;
  annotation (defaultComponentName = "flange_n",
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Documentation(info="<html>
<p>Mechanical rotational connector (also electro-mechanical), negative.</p>
</html>
"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Ellipse(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Ellipse(
            extent={{-100,50},{0,-50}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-100,120},{120,60}},
            lineColor={95,95,95},
            textString=
               "%name")}));
  end Rotation_n;

  connector Translation_p "Translational flange ('positive') "
    extends Connectors.Translation;
  annotation (defaultComponentName = "flange_p",
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Documentation(info="<html>
<p>Mechanical translational connector (also electro-mechanical), positive.</p>
</html>"),
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{0,50},{100,-50}},
            lineColor={0,0,0},
            fillColor={128,128,128},
            fillPattern=FillPattern.Solid), Text(
            extent={{-120,120},{100,60}},
            lineColor={95,95,95},
            textString=
               "%name")}));
  end Translation_p;

  connector Translation_n "Translational flange ('negative')"
    extends Connectors.Translation;
  annotation (defaultComponentName = "flange_n",
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Documentation(info="<html>
<p>Mechanical translational connector (also electro-mechanical), negative.</p>
</html>"),
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{-100,50},{0,-50}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-100,120},{120,60}},
            lineColor={95,95,95},
            textString=
               "%name")}));
  end Translation_n;

  connector Thermal_p "Thermal heat port ('positive')"
    extends Connectors.Thermal;

  annotation (defaultComponentName = "heat_p",
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}}), graphics={Rectangle(
            extent={{0,50},{100,-50}},
            lineColor={176,0,0},
            fillColor={176,0,0},
            fillPattern=FillPattern.Solid), Text(
            extent={{-120,120},{100,60}},
            lineColor={176,0,0},
            textString=
                 "%name")}),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}}), graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={176,0,0},
            fillColor={176,0,0},
            fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
</html>
"));
  end Thermal_p;

  connector Thermal_n "Thermal heat port ('negative')"
    extends Connectors.Thermal;

  annotation (defaultComponentName = "heat_n",
    Documentation(info="<html>
</html>
"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}}), graphics={Rectangle(
            extent={{-100,50},{0,-50}},
            lineColor={176,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-100,120},{120,60}},
            lineColor={176,0,0},
            textString=
                 "%name")}),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}}), graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={176,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}));
  end Thermal_n;

  connector ThermalV_p "Thermal vector heat port ('positive')"
    parameter Integer m(final min=1) = 1 "number of single heat-ports";
    Connectors.Thermal[m] port "vector of single heat ports";

  annotation (defaultComponentName = "heat_p",
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}}), graphics={
          Text(
            extent={{-120,120},{100,60}},
            lineColor={176,0,0},
            textString=
                 "%name"),
          Polygon(
            points={{-20,0},{40,-60},{100,0},{40,60},{-20,0}},
            lineColor={176,0,0},
            fillColor={176,0,0},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-10,50},{90,-50}},
            lineColor={235,235,235},
            pattern=LinePattern.None,
            textString=
                 "%m")}),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}}), graphics={Polygon(
            points={{-120,0},{0,-120},{120,0},{0,120},{-120,0}},
            lineColor={176,0,0},
            fillColor={176,0,0},
            fillPattern=FillPattern.Solid), Text(
            extent={{-60,60},{60,-60}},
            lineColor={255,255,255},
            pattern=LinePattern.None,
            textString=
                 "%m")}),
    Documentation(info="<html>
<p>Thermal connector with a vector of 'port's, positive.</p>
</html>
"));
  end ThermalV_p;

  connector ThermalV_n "Thermal vector heat port ('negative')"
    parameter Integer m(final min=1) = 1 "number of single heat-ports";
    Connectors.Thermal[m] port "vector of single heat ports";

  annotation (defaultComponentName = "heat_n",
    Documentation(info="<html>
<p>Thermal connector with a vector of 'port's, negative.</p>
</html>
"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}}), graphics={
          Text(
            extent={{-100,120},{120,60}},
            lineColor={176,0,0},
            textString=
                 "%name"),
          Polygon(
            points={{-100,0},{-40,-60},{20,0},{-40,60},{-100,0}},
            lineColor={176,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-90,50},{10,-50}},
            lineColor={176,0,0},
            textString=
                 "%m")}),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}}), graphics={Polygon(
            points={{-120,0},{0,-120},{120,0},{0,120},{-120,0}},
            lineColor={176,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-60,60},{60,-60}},
            lineColor={176,0,0},
            textString=
                 "%m")}));
  end ThermalV_n;

  partial model AddHeat "Additional heat port"

    Modelica.SIunits.Conversions.NonSIunits.Temperature_degC T
      "Temperature of conductor";
    SI.HeatFlowRate Q_flow "Dissipated heat of conductor";
    Base.Interfaces.Thermal_n heat "heat port"
    annotation (                                       Documentation(info="<html>
  <pre>
  Adds a scalar heat port to the component.
  The port collects the total heat dissipated by the component.
  </pre>
  </html>"),
           Diagram(graphics),
      Placement(transformation(
          origin={0,100},
          extent={{-10,-10},{10,10}},
          rotation=90)));

  equation
      T = heat.T;
      Q_flow = -heat.Q_flow;

      annotation (Diagram(graphics),
                           Documentation(info="<html>
<p>Adds a heat-port to an electrical component.</p>
<p>Copper data at 20degC.</p>
<pre>
  rho_m = 8960 kg/m^3:     density
  c_p = 382.3 J/(kg.K):    specific heat
  rho = 1.673e-8 Ohm.m:    specific resistance
</pre>
</html>"));
  end AddHeat;

  partial model AddHeatV "Additional vector heat port"

    parameter Integer m_heat(final min=1) = 1 "number of heat conductors";
    Modelica.SIunits.Conversions.NonSIunits.Temperature_degC[m_heat] T
      "Temperature of heat conductors";
    SI.HeatFlowRate[m_heat] Q_flow "Dissipated heat of conductors";
    Base.Interfaces.ThermalV_n heat(final m=m_heat) "vector heat port"
    annotation (                                       Documentation(info="<html>
  <pre>
  Adds a vector heat port to the component.
  Each port-component collects the heat dissipated by one conductor of the device.
  </pre>
  </html>"),
           Diagram(graphics),
      Placement(transformation(
          origin={0,100},
          extent={{-10,-10},{10,10}},
          rotation=90)));

  equation
      T = heat.port.T;
      Q_flow = -heat.port.Q_flow;

      annotation (Diagram(graphics),
                           Documentation(info="<html>
<p>Adds a vector heat-port to an electrical component.</p>
<p>Copper data at 20degC.</p>
<pre>
  rho_m = 8960 kg/m^3:     density
  c_p = 382.3 J/(kg.K):    specific heat
  rho = 1.673e-8 Ohm.m:    specific resistance
</pre>
</html>"));
  end AddHeatV;

  connector Position "Position reference"
    SI.Position s;

  annotation (defaultComponentName = "position",
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Polygon(
            points={{-100,0},{-40,40},{40,40},{100,0},{40,-40},{-40,-40},{-100,
                0}},
            lineColor={120,0,120},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-60,30},{60,-30}},
            lineColor={120,0,120},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString=
                 "pos")}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Polygon(
            points={{-60,0},{-20,20},{20,20},{60,0},{20,-20},{-20,-20},{-60,0}},

            lineColor={120,0,120},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-110,120},{110,60}},
            lineColor={120,0,120},
            textString=
               "%name")}),
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Documentation(info="<html>
<p>System position reference.<br>
Used in extended 'System' for sending/receiving position.</p>
<pre>
  s:        position
</pre>
</html>            "));
  end Position;

  model SenderPos "Sender of position"

    Position sendPos            annotation (Placement(transformation(extent={{
              -60,-100},{60,20}}, rotation=0)));
  annotation (defaultComponentName = "position",
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Polygon(
            points={{-100,-100},{0,100},{100,-100},{100,-100},{-100,-100}},
            lineColor={120,0,120},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-100,-100},{100,-140}},
            lineColor={120,0,120},
            textString=
                   "%name")}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics),
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Documentation(info="<html>
<p>Contains system position reference.<br>
Needed within certain models to establish the connection to extended 'system' for sending/receiving position-data.</p>
<p>Used for example in rail vehicles.</p>
</html>
 "));
  end SenderPos;

  connector Frequency "Weighted frequency"
    flow SI.Time H;
    flow Real H_w;

  annotation (defaultComponentName = "frequency",
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Ellipse(
            extent={{-80,80},{80,-80}},
            lineColor={120,0,120},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-60,30},{60,-30}},
            lineColor={120,0,120},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString=
                 "freq")}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Text(
            extent={{-110,120},{110,60}},
            lineColor={120,0,120},
            textString=
               "%name"), Ellipse(
            extent={{-40,40},{40,-40}},
            lineColor={120,0,120},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}),
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Documentation(info="<html>
<p>System frequency reference.<br>
Used in 'System' for sending/receiving weighted frequency-data.</p>
<pre>
  H:        weight, i.e. inertia constant of machine (dimension time)
  H_omega:  weighted angular frequency H*omega
</pre>
</html>"));
  end Frequency;

  model SenderFreq "Sender of weighted frequency"

    Frequency sendFreq          annotation (Placement(transformation(extent={{
              -60,-92},{60,28}}, rotation=0)));
    annotation (defaultComponentName = "sendFreq",
      Window(
        x=
  0.45, y=
  0.01, width=
      0.44,
        height=
       0.65),
      Documentation(
            info="<html>
<p>Contains system frequency reference.<br>
Needed within certain models to establish the connection to 'system' for sending/receiving weighted frequency-data.</p>
<p>Used in generator models.</p>
</html>
"),   Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Text(
            extent={{-100,-100},{100,-140}},
            lineColor={120,0,120},
            textString=
                   "%name"), Polygon(
            points={{-100,-100},{0,100},{100,-100},{100,-100},{-100,-100}},
            lineColor={120,0,120},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics));
  end SenderFreq;

  package Connectors "Naked connectors"
  extends Base.Icons.Partials;

  connector Electric "Electric terminal"
    SI.Voltage v "connector voltage";
    flow SI.Current i "current directed into the component";

  annotation (Documentation(info="<html>
<p>Electric  connector with scalar variables.</p>
<pre>
  v:        voltage
  i:        current
</pre>
</html>
"), Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Icon(graphics),
    Diagram(graphics));
  end Electric;

  connector AC3ph "AC terminal, 3-phase"
    Types.ReferenceAngle[2] theta "{relative angle, reference angle}";
    SI.Voltage[3] v "connector voltage";
    flow SI.Current[3] i "current directed into the component";

  annotation (Documentation(info="<html>
<p>AC 3-phase connector with vector variables of dimension 3.</p>
<pre>
  theta[2]:  {relative angle, reference angle}
  v[3]:      voltage vector
  i[3]:      current vector
</pre>
<p>The following relations hold between absolute and relative angle\\frequency:</p>
<pre>
  theta[1]\\der(theta[1]):  angle\\angular_frequency in frame rotating with reference angle theta[2]
  theta[2]\\der(theta[2]):  angle\\angular_frequency of rotating reference frame
</pre>
<p>Therefore the absolute quantities are given by:</p>
<pre>
  theta_abs = theta[1] + theta[2]:  absolute angle
  der(theta_abs) = omega_abs:       absolute angular frequency
</pre>
</html>"),
    Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Icon(graphics),
    Diagram(graphics));
  end AC3ph;

  connector Rotation "Rotational flange"
    SI.Angle phi "connector rotation angle";
    flow SI.Torque tau "cut torque directed into the component";

  annotation (Documentation(info="<html>
<p>Mechanical rotational connector (also electro-mechanical).</p>
<pre>
  phi:      angle
  tau:      torque
</pre>
</html>"),
    Icon(graphics),
    Diagram(graphics));
  end Rotation;

  connector Translation "Translational flange"
    SI.Position s "connector position";
    flow SI.Force f "cut force directed into the component";

  annotation (Documentation(info="<html>
<p>Mechanical translational connector (also electro-mechanical).</p>
<pre>
  s:        position
  f:        force
</pre>
</html>"),
    Icon(graphics),
    Diagram(graphics));
  end Translation;

  connector Thermal "Thermal heat-port"
    SI.Temperature T "port temperature";
    flow SI.HeatFlowRate Q_flow "heat flow rate directed into the component";

  annotation (Documentation(info="<html>
<p>Thermal connector with scalar variables.</p>
<pre>
  T:        temperature
  Q_flow:   heat flow rate
</pre>
</html>
"), Window(
      x=0.45,
      y=0.01,
      width=0.44,
      height=0.65),
    Icon(graphics),
    Diagram(graphics));
  end Thermal;
  //  annotation 11;
    annotation (preferedView="info",
  Documentation(info="<html>
</html>"));
  end Connectors;

    annotation (preferedView="info",
      Window(
        x=0,
        y=0.55,
        width=0.15,
        height=0.41,
        library=1,
        autolayout=1),
      Documentation(info="<html>
<p><a href=\"Spot.UsersGuide.Introduction.Interfaces\">up users guide</a></p>
</html>
"));
end Interfaces;
