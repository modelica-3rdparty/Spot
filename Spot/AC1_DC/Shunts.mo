within Spot.AC1_DC;

package Shunts
  extends Base.Icons.Library;

  annotation (preferedView="info", Documentation(info="<html>
<p>Info see package AC1_DC.Impedances.</p>
</html>
"));
model ReactiveShunt "Shunt reactor with parallel conductor, 1-phase"
  extends Partials.ShuntBase;

  parameter SIpu.Conductance g=0 "conductance (parallel)";
  parameter SIpu.Resistance r=0 "resistance (serial)";
  parameter SIpu.Reactance x_s=1 "self reactance";
  parameter SIpu.Reactance x_m=0 "mutual reactance, -x_s < x_m < x_s";
  protected
  final parameter SI.Resistance[2] RL_base=Base.Precalculation.baseRL(units, V_nom, S_nom, 2*pi*f_nom);
  final parameter SI.Conductance G=g/RL_base[1];
  final parameter SI.Resistance R=r*RL_base[1];
  final parameter SI.Inductance[2,2] L=[x_s,x_m;x_m,x_s]*RL_base[2];
  SI.Current[2] i_x;

annotation (defaultComponentName = "xShunt",
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
<p>Info see package AC1_DC.Impedances.</p>
</html>"),
  Icon( Rectangle(extent=[72,20; 80,-20], style(
        color=10,
        rgbcolor={135,135,135},
        fillColor=10,
        rgbfillColor={135,135,135})),
        Rectangle(extent=[-80,20; -40,-20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-40,20; 72,-20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))),
  Diagram(
        Rectangle(extent=[-60,32; 60,22], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
    Rectangle(extent=[-60,18; 60,8],  style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=3,
            rgbfillColor={0,0,255})),
    Rectangle(extent=[-60,4; 60,-4],  style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
        Rectangle(extent=[-60,-8; 60,-18],  style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
    Rectangle(extent=[-60,-22; 60,-32], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=3,
            rgbfillColor={0,0,255})),
        Line(points=[-60,8; -60,32], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1)),
        Line(points=[-60,-32; -60,-8], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1)),
        Line(points=[60,8; 60,32], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1)),
        Line(points=[60,-32; 60,-8], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1))));

equation
  i_x = i - G*v;
  L*der(i_x) + R*i_x = v;
end ReactiveShunt;

model CapacitiveShunt "Shunt capacitor with parallel conductor, 1-phase, pp pg"
  extends Partials.ShuntBase;

  parameter SIpu.Conductance g_pg=0 "conductance ph-grd";
  parameter SIpu.Conductance g_pp=0 "conductance ph_ph";
  parameter SIpu.Susceptance b_pg=0.5 "susceptance ph-grd";
  parameter SIpu.Susceptance b_pp=0.5 "susceptance ph-ph";
  protected
  final parameter SI.Resistance[2] GC_base=Base.Precalculation.baseGC(units, V_nom, S_nom, 2*pi*f_nom);
  final parameter SI.Conductance[2,2] G=[g_pg+g_pp,-g_pp;-g_pp,g_pg+g_pp]*GC_base[1];
  final parameter SI.Capacitance[2,2] C=[b_pg+b_pp,-b_pp;-b_pp,b_pg+b_pp]*GC_base[2];

annotation (defaultComponentName = "cShunt",
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
<p>Terminology.<br>
&nbsp;  _pg denotes phase-to-ground<br>
&nbsp;  _pp denotes phase-to-phase</p>
<p>Info see package AC1_DC.Impedances.</p>
</html>"),
  Icon( Rectangle(extent=[-12,60; 12,-60], style(
            color=30,
            rgbcolor={215,215,215},
            fillColor=30,
            rgbfillColor={215,215,215})),
        Line(points=[-90,0; -20,0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=69,
            rgbfillColor={0,128,255})),
        Rectangle(extent=[-20,60; -12,-60], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[12,60; 20,-60], style(
          color=10,
          rgbcolor={135,135,135},
          fillColor=10,
          rgbfillColor={135,135,135}))),
  Diagram(
        Rectangle(extent=[36,40; 38,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[42,40; 44,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[36,0; 38,-20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[42,0; 44,-20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
    Rectangle(extent=[30,14; 50,6], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Rectangle(extent=[30,-26; 50,-34], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[36,30; 20,30; 20,10; 30,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[36,-10; 20,-10; 20,-30; 30,-30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[44,30; 60,30; 60,10; 50,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[44,-10; 60,-10; 60,-30; 50,-30], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Rectangle(extent=[-60,4; -40,2], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
    Rectangle(extent=[-60,-2; -40,-4], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
    Rectangle(extent=[-34,10; -26,-10], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[-50,4; -50,16; -30,16; -30,10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[-50,-4; -50,-16; -30,-16; -30,-10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[-60,20; 20,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[-60,-20; 20,-20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[-40,20; -40,16], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[-40,-20; -40,-16], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
        Text(
          extent=[0,-40; 80,-50],
          string="b_pg",
          style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2)),
        Text(
          extent=[0,-50; 80,-60],
          string="g_pg",
          style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2)),
        Text(
          extent=[-80,-30; 0,-40],
          string="b_pp, g_pp",
          style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2))));

equation
  C*der(v) + G*v = i;
end CapacitiveShunt;

package Partials "Partial models"
  extends Base.Icons.Partials;

  annotation (
    Coordsys(
      extent=[-100,-100; 100,100],
      grid=[2,2],
      component=[20,20]), Window(
      x=0.05,
      y=0.44,
      width=0.31,
      height=0.23,
      library=1,
      autolayout=1));

  partial model ShuntBase "Load base, 1-phase"
    extends Ports.Port_p;
    extends Base.Units.NominalAC;

    SI.Voltage[2] v "voltage";
    SI.Current[2] i "current";

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
</html>
"), Diagram(
      Line(points=[60,20; 80,20], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
          Rectangle(extent=[80,30; 84,10], style(
    color=10,
    fillColor=10,
    fillPattern=1)),
      Line(points=[60,-20; 80,-20], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
          Rectangle(extent=[80,-10; 84,-30], style(
    color=10,
    fillColor=10,
    fillPattern=1)),
      Line(points=[-80,20; -60,20], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
      Line(points=[-80,-20; -60,-20], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1))),
    Icon,
      DymolaStoredErrors);

  equation
    v = term.pin.v;
    i = term.pin.i;
  end ShuntBase;
end Partials;
end Shunts;
