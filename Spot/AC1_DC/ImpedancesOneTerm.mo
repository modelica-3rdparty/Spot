within Spot.AC1_DC;


package ImpedancesOneTerm "Impedance and admittance one terminal"
  extends Base.Icons.Library;


  model Resistor "Resistor, 1-phase"
    extends Partials.ImpedBase(final f_nom=0);

    parameter SIpu.Resistance r=1 "resistance";
  protected
    final parameter SI.Resistance R=r*Base.Precalculation.baseR(units, V_nom, S_nom);

  equation
    R*i = v;
    annotation (defaultComponentName="res1",
      Documentation(
              info="<html>
<p>Info see package AC1_DC.Impedances.</p>
</html>"),
      Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{-80,30},{80,-30}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{-10,60},{10,-60}},
            lineColor={0,0,255},
            lineThickness=0.5,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}));
  end Resistor;

  model Conductor "Conductor, 1-phase"
    extends Partials.ImpedBase(final f_nom=0);

    parameter SIpu.Conductance g=1 "conductance";
  protected
    final parameter SI.Conductance G=g/Base.Precalculation.baseR(units, V_nom, S_nom);

  equation
    G*v = i;
    annotation (defaultComponentName="cond1",
      Documentation(
              info="<html>
<p>Info see package AC1_DC.Impedances.</p>
</html>"),
      Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{-80,30},{80,-30}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{-10,60},{10,-60}},
            lineColor={0,0,255},
            lineThickness=0.5,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}));
  end Conductor;

  model Inductor "Inductor with series resistor, 1-phase"
    extends Partials.ImpedBase;

    parameter SIpu.Resistance r=0 "resistance";
    parameter SIpu.Reactance x=1 "reactance matrix";
  protected
    final parameter Real[2] RL_base=Base.Precalculation.baseRL(units, V_nom, S_nom, 2*pi*f_nom);
    final parameter SI.Resistance R=r*RL_base[1];
    final parameter SI.Inductance L=x*RL_base[2];

  equation
    L*der(i) + R*i = v;
    annotation (defaultComponentName="ind1",
      Documentation(
              info="<html>
<p>Info see package AC1_DC.Impedances.</p>
</html>"),
      Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{-80,30},{-40,-30}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Rectangle(
            extent={{-40,30},{80,-30}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{-10,60},{10,40}},
            lineColor={0,0,255},
            lineThickness=0.5,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Rectangle(
            extent={{-10,40},{10,-60}},
            lineColor={0,0,255},
            lineThickness=0.5,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid)}));
  end Inductor;

  model Capacitor "Capacitor with parallel conductor, 1-phase"
    extends Partials.ImpedBase;

    parameter SIpu.Conductance g=0 "conductance";
    parameter SIpu.Susceptance b=1 "susceptance";
  protected
    final parameter Real[2] GC_base=Base.Precalculation.baseGC(units, V_nom, S_nom, 2*pi*f_nom);
    final parameter SI.Conductance G=g*GC_base[1];
    final parameter SI.Capacitance C=b*GC_base[2];

  equation
    C*der(v) + G*v = i;
    annotation (defaultComponentName="cap1",
      Documentation(
              info="<html>
<p>Info see package AC1_DC.Impedances.</p>
</html>"),
      Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-90,0},{-20,0}}, color={0,0,255}),
          Rectangle(
            extent={{-12,60},{12,-60}},
            lineColor={215,215,215},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-20,60},{-12,-60}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{12,60},{20,-60}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Rectangle(
            extent={{-50,16},{50,10}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-50,10},{50,-10}},
            lineColor={215,215,215},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-50,-10},{50,-16}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Line(points={{0,60},{0,16}}, color={0,0,255}),
          Line(points={{0,-60},{0,-16}}, color={0,0,255})}));
  end Capacitor;

  model Varistor "Varistor, 1-phase"
    extends Partials.ImpedBase(final f_nom=0);

    parameter SIpu.Resistance r0=100 "small voltage resistance";
    parameter SIpu.Voltage v0=1 "saturation voltage";
  protected
    final parameter Real V0=(v0*Base.Precalculation.baseV(units, V_nom));
    final parameter Real H0=(r0*Base.Precalculation.baseR(units, V_nom, S_nom)/V0);

  equation
    v = V0*tanh(H0*i);
    annotation (defaultComponentName="varistor",
      Documentation(
              info="<html>
<p> Voltage limiter with hyperbolic tangent characteristic.</p>
<p> More info see package AC1_DC.Impedances.</p>
</html>
"),   Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{-80,30},{80,-30}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Line(points={{30,25},{26,2},{-26,-2},
                {-30,-26}}, color={0,0,0})}),
      Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{-10,60},{10,-60}},
            lineColor={0,0,255},
            lineThickness=0.5,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Line(points={{10,-22},{2,-20},{-2,
                20},{-10,22}}, color={0,0,0})}));
  end Varistor;

  package Partials "Partial models"
    extends Base.Icons.Partials;

    partial model ImpedBase "One terminal impedance base, 1-phase"
      extends Ports.Port_p;
      extends Base.Units.NominalAC;

      SI.Voltage v;
      SI.Current i;


    equation
      term.pin[1].i + term.pin[2].i = 0;
      v = term.pin[1].v - term.pin[2].v;
      i = term.pin[1].i;
    annotation (
      Documentation(
            info="<html>
</html>
"),      Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Line(points={{-80,20},{-60,20},{-60,80},{0,
                  80},{0,60}}, color={0,0,255}), Line(points={{-80,-20},{-60,
                  -20},{-60,-80},{0,-80},{0,-60}}, color={0,0,255})}));
    end ImpedBase;

    partial model ImpedBaseHeat
      "One terminal impedance base with heat port, 1-phase"
      extends ImpedBase;
      extends Base.Interfaces.AddHeat;
      annotation (
    Documentation(
          info="<html>
<p>Same as ImpedBase, but contains an additional heat port.</p>
<p>Does not contain mass and specific heat. These parameters are expected to belong to the corresponding thermal model. The heat-flow at the connector is given by the total dissipated electric power.</p>
</html>
"));
    end ImpedBaseHeat;

  end Partials;

  annotation (preferredView="info",
Documentation(info="<html>
<p>Contains lumped impedance models with one terminal.</p>
<p>General relations see AC1_DC.Impedances.</p>
</html>
"));
end ImpedancesOneTerm;
