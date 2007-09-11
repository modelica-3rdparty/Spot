package ImpedancesOneTerm "Impedance and admittance one terminal"
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
  height=0.38,
  library=1,
  autolayout=1),
Documentation(info="<html>
<p>Contains lumped impedance models with one terminal.</p>
<p>General relations see AC1_DC.Impedances.</p>
</html>
"), Icon);

  model Resistor "Resistor, 1-phase"
    extends Partials.ImpedBase(final f_nom=0);

    parameter SIpu.Resistance r=1 "resistance";
  protected
    final parameter SI.Resistance R=r*Base.Precalculation.baseR(units, V_nom, S_nom);
    annotation (defaultComponentName="res1",
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
<p>Info see package AC1_DC.Impedances.</p>
</html>"),
      Icon(
  Rectangle(extent=[-80, 30; 80, -30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255}))),
      Diagram(
        Rectangle(extent=[-10,60; 10,-60], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255}))));

  equation
    R*i = v;
  end Resistor;

  model Conductor "Conductor, 1-phase"
    extends Partials.ImpedBase(final f_nom=0);

    parameter SIpu.Conductance g=1 "conductance";
  protected
    final parameter SI.Conductance G=g/Base.Precalculation.baseR(units, V_nom, S_nom);
    annotation (defaultComponentName="cond1",
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
<p>Info see package AC1_DC.Impedances.</p>
</html>"),
      Icon(
  Rectangle(extent=[-80,30; 80,-30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255}))),
      Diagram(
        Rectangle(extent=[-10,60; 10,-60], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255}))));

  equation
    G*v = i;
  end Conductor;

  model Inductor "Inductor with series resistor, 1-phase"
    extends Partials.ImpedBase;

    parameter SIpu.Resistance r=0 "resistance";
    parameter SIpu.Reactance x=1 "reactance matrix";
  protected
    final parameter Real[2] RL_base=Base.Precalculation.baseRL(units, V_nom, S_nom, 2*pi*f_nom);
    final parameter SI.Resistance R=r*RL_base[1];
    final parameter SI.Inductance L=x*RL_base[2];
    annotation (defaultComponentName="ind1",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[40, 40]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p>Info see package AC1_DC.Impedances.</p>
</html>"),
      Icon(
  Rectangle(extent=[-80,30; -40,-30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
  Rectangle(extent=[-40, 30; 80, -30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))),
      Diagram(
          Rectangle(extent=[-10,60; 10,40], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
                                      Rectangle(extent=[-10,40; 10,-60], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=3,
            rgbfillColor={0,0,255}))));

  equation
    L*der(i) + R*i = v;
  end Inductor;

  model Capacitor "Capacitor with parallel conductor, 1-phase"
    extends Partials.ImpedBase;

    parameter SIpu.Conductance g=0 "conductance";
    parameter SIpu.Susceptance b=1 "susceptance";
  protected
    final parameter Real[2] GC_base=Base.Precalculation.baseGC(units, V_nom, S_nom, 2*pi*f_nom);
    final parameter SI.Conductance G=g*GC_base[1];
    final parameter SI.Capacitance C=b*GC_base[2];
    annotation (defaultComponentName="cap1",
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
<p>Info see package AC1_DC.Impedances.</p>
</html>"),
      Icon(
        Line(points=[-90,0; -20,0], style(color=3, rgbcolor={0,0,255})),
        Rectangle(extent=[-12,60; 12,-60], style(
            color=30,
            rgbcolor={215,215,215},
            fillColor=30,
            rgbfillColor={215,215,215})),
        Rectangle(extent=[-20,60; -12,-60], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[12,60; 20,-60], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))),
      Diagram(
        Rectangle(extent=[-50,16; 50,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-50,10; 50,-10], style(
            color=30,
            rgbcolor={215,215,215},
            fillColor=30,
            rgbfillColor={215,215,215})),
        Rectangle(extent=[-50,-10; 50,-16], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Line(points=[0,60; 0,16], style(color=3, rgbcolor={0,0,255})),
        Line(points=[0,-60; 0,-16], style(color=3, rgbcolor={0,0,255}))));

  equation
    C*der(v) + G*v = i;
  end Capacitor;

  model Varistor "Varistor, 1-phase"
    extends Partials.ImpedBase(final f_nom=0);

    parameter SIpu.Resistance r0=100 "small voltage resistance";
    parameter SIpu.Voltage v0=1 "saturation voltage";
  protected
    final parameter Real V0=(v0*Base.Precalculation.baseV(units, V_nom));
    final parameter Real H0=(r0*Base.Precalculation.baseR(units, V_nom, S_nom)/V0);
    annotation (defaultComponentName="varistor",
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[40, 40]),
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
              info="<html>
<p> Voltage limiter with hyperbolic tangent characteristic.</p>
<p> More info see package AC1_DC.Impedances.</p>
</html>
"),   Icon(
  Rectangle(extent=[-80, 30; 80, -30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
  Line(points=[30, 25; 26, 2; -26, -2; -30, -26], style(color=0))),
      Diagram(
        Rectangle(extent=[-10,60; 10,-60], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
                                      Line(points=[10,-22; 2,-20; -2,20; -10,22],
            style(color=0))));

  equation
    v = V0*tanh(H0*i);
  end Varistor;

  package Partials "Partial models"
    extends Base.Icons.Partials;

    partial model ImpedBase "One terminal impedance base, 1-phase"
      extends Ports.Port_p;
      extends Base.Units.NominalAC;

      SI.Voltage v;
      SI.Current i;

    annotation (
      Coordsys(
        extent=
       [-100, -100; 100, 100],
        grid=
     [2, 2],
        component=
          [20, 20]),
      Window(
        x=0.45,
        y=0.01,
        width=
      0.44,
        height=
       0.65),
      Documentation(
            info="<html>
</html>
"),   Icon,
      Diagram(Line(points=[-80,20; -60,20; -60,80; 0,80; 0,60], style(color=3,
                rgbcolor={0,0,255})), Line(points=[-80,-20; -60,-20; -60,-80; 0,
                -80; 0,-60], style(color=3, rgbcolor={0,0,255}))));

    equation
      term.pin[1].i + term.pin[2].i = 0;
      v = term.pin[1].v - term.pin[2].v;
      i = term.pin[1].i;
    end ImpedBase;

    partial model ImpedBaseHeat
      "One terminal impedance base with heat port, 1-phase"
      extends ImpedBase;
      extends Base.Interfaces.AddHeat;
      annotation (
    Coordsys(
      extent=
     [-100, -100; 100, 100],
      grid=[
    2, 2],
      component=
        [20, 20]),
    Window(
      x=0.45,
      y=0.01,
      width=
    0.44,
      height=
     0.65),
    Documentation(
          info="<html>
<p>Same as ImpedBase, but contains an additional heat port.</p>
<p>Does not contain mass and specific heat. These parameters are expected to belong to the corresponding thermal model. The heat-flow at the connector is given by the total dissipated electric power.</p>
</html>
"), Icon,
    Diagram);
    end ImpedBaseHeat;

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
  end Partials;

end ImpedancesOneTerm;
