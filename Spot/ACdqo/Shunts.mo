within Spot.ACdqo;
package Shunts "Reactive and capacitive shunts"
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
height=0.44,
library=1,
autolayout=1),
    Documentation(info="<html>
<p>Info see package ACdqo.Impedances.</p>
</html>
"),
  Icon);

model ReactiveShunt "Shunt reactor with parallel conductor, 3-phase dqo"
  extends Partials.ShuntBase;

  parameter SIpu.Conductance g=0 "conductance (parallel)";
  parameter SIpu.Resistance r=0 "resistance (serial)";
  parameter SIpu.Reactance x_s=1 "self reactance";
  parameter SIpu.Reactance x_m=0 "mutual reactance, -x_s/2 < x_m < x_s";
  protected
  final parameter SI.Resistance[2] RL_base=Base.Precalculation.baseRL(units, V_nom, S_nom, 2*pi*f_nom);
  final parameter SI.Conductance G=g/RL_base[1];
  final parameter SI.Resistance R=r*RL_base[1];
  final parameter SI.Inductance L=(x_s-x_m)*RL_base[2];
  final parameter SI.Inductance L0=(x_s+2*x_m)*RL_base[2];
  SI.Current[3] i_x;
annotation (defaultComponentName = "xShunt1",
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
<p>Info see package ACabc.Impedances.</p>
</html>"),
  Icon( Rectangle(extent=[70,30; 80,-30], style(
            color=10,
            rgbcolor={135,135,135},
            thickness=2,
            fillColor=10,
            rgbfillColor={135,135,135})),
        Rectangle(extent=[-80,30; -40,-30], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-40,30; 70,-30], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2,
            fillColor=62,
            rgbfillColor={0,120,120}))),
  Diagram(
        Rectangle(extent=[-60,62; 60,52], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-60,48; 60,38], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-60,30; 60,20], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Rectangle(extent=[-60,-20; 60,-30], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175},
        fillPattern=1)),
    Rectangle(extent=[-60,-70; 60,-80],
                                      style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
        Rectangle(extent=[-60,12; 60,2], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-60,-2; 60,-12],style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Rectangle(extent=[-60,-38; 60,-48], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-60,-52; 60,-62],
                                      style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Line(points=[-60,38; -60,62], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1)),
        Line(points=[-60,-12; -60,12], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1)),
        Line(points=[-60,-62; -60,-38], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1)),
        Line(points=[60,-12; 60,12], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1)),
        Line(points=[60,38; 60,62], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1)),
        Line(points=[60,-62; 60,-38], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1))));

initial equation
  if system.steadyIni_t then
    der(i_x) = omega[1]*j_dqo(i_x);
  end if;

equation
  i_x = i - G*v;
  if system.transientSim then
    diagonal({L,L,L0})*der(i_x) + omega[2]*L*j_dqo(i_x) + R*i_x = v;
  else
    omega[2]*L*j_dqo(i_x) + R*i_x = v;
  end if;
end ReactiveShunt;

model CapacitiveShunt
    "Shunt capacitor with parallel conductor, 3-phase dqo, pp pg"
  extends Partials.ShuntBase;

  parameter SIpu.Conductance g_pg=0 "conductance ph-grd";
  parameter SIpu.Conductance g_pp=0 "conductance ph_ph";
  parameter SIpu.Susceptance b_pg=1 "susceptance ph-grd";
  parameter SIpu.Susceptance b_pp=1/3 "susceptance ph-ph";
  protected
  final parameter SI.Resistance[2] GC_base=Base.Precalculation.baseGC(units, V_nom, S_nom, 2*pi*f_nom);
  final parameter SI.Conductance G=(g_pg+3*g_pp)*GC_base[1];
  final parameter SI.Conductance G0=g_pg*GC_base[1];
  final parameter SI.Capacitance C=(b_pg+3*b_pp)*GC_base[2];
  final parameter SI.Capacitance C0=b_pg*GC_base[2];
annotation (defaultComponentName = "cShunt1",
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
<p>Info see package ACdqo.Impedances.</p>
</html>
"),
  Icon( Rectangle(extent=[-12,60; 12,-60], style(
            color=30,
            rgbcolor={215,215,215},
            fillColor=30,
            rgbfillColor={215,215,215})),
        Line(points=[-90,0; -20,0], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2)),
        Rectangle(extent=[-20,60; -12,-60], style(
            color=62,
            rgbcolor={0,120,120},
            fillColor=62,
            rgbfillColor={0,120,120})),
        Rectangle(extent=[12,60; 20,-60], style(
          color=10,
          rgbcolor={135,135,135},
          fillColor=10,
          rgbfillColor={135,135,135}))),
  Diagram(
        Rectangle(extent=[36,70; 38,50], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[42,70; 44,50], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[36,20; 38,0], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[42,20; 44,0], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[36,-30; 38,-50], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[42,-30; 44,-50], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
    Rectangle(extent=[30,44; 50,36], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[30,-6; 50,-14], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[30,-56; 50,-64], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[36,60; 20,60; 20,40; 30,40], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[36,10; 20,10; 20,-10; 30,-10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[36,-40; 20,-40; 20,-60; 30,-60], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[44,60; 60,60; 60,40; 50,40], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[44,10; 60,10; 60,-10; 50,-10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[44,-40; 60,-40; 60,-60; 50,-60], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-70,28; -50,26], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-70,22; -50,20], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-44,34; -36,14], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-60,28; -60,40; -40,40; -40,34], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-60,20; -60,8; -40,8; -40,14], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-70,-22; -50,-24], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-70,-28; -50,-30], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-44,-16; -36,-36], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-60,-22; -60,-10; -40,-10; -40,-16], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-60,-30; -60,-42; -40,-42; -40,-36], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-30,4; -10,2], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-30,-2; -10,-4], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-4,10; 4,-10], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-20,4; -20,16; 0,16; 0,10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-20,-4; -20,-16; 0,-16; 0,-10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-60,50; 20,50], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-60,0; 20,0], style(
        color=3,
        rgbcolor={0,0,255},
        pattern=3,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-60,-50; 20,-50], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-50,50; -50,40], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-50,-50; -50,-42], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-50,8; -50,-10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-10,50; -10,16], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-10,-50; -10,-16], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
        Text(
          extent=[-80,-60; 0,-70],
          style(color=3, rgbcolor={0,0,255}),
          string="b_pp, g_pp"),
        Text(
          extent=[0,-80; 80,-90],
          style(color=3, rgbcolor={0,0,255}),
          string="g_pg"),
        Text(
          extent=[0,-70; 80,-80],
          style(color=3, rgbcolor={0,0,255}),
          string="b_pg")));

initial equation
  if system.steadyIni_t then
    der(v) = omega[1]*j_dqo(v);
  end if;

equation
  if system.transientSim then
    diagonal({C,C,C0})*der(v) + omega[2]*C*j_dqo(v) + diagonal({G,G,G0})*v = i;
  else
    omega[2]*C*j_dqo(v) + diagonal({G,G,G0})*v = i;
  end if;
end CapacitiveShunt;

model ReactiveShuntNonSym
    "Shunt reactor with parallel conductor non symmetric, 3-phase dqo"
  extends Partials.ShuntBaseNonSym;

  parameter SIpu.Conductance[3] g={0,0,0} "conductance abc (parallel)";
  parameter SIpu.Resistance[3] r={0,0,0} "resistance abc (serial)";
  parameter SIpu.Reactance[3, 3] x=[1, 0, 0; 0, 1, 0; 0, 0, 1] "reactance abc";
  SI.MagneticFlux[3] psi_x(each stateSelect=StateSelect.prefer) "magnetic flux";
  protected
  final parameter SI.Resistance[2] RL_base=Base.Precalculation.baseRL(units, V_nom, S_nom, 2*pi*f_nom);
  final parameter SI.Conductance[3] G_abc=g/RL_base[1];
  final parameter SI.Reactance[3] R_abc=r*RL_base[1];
  final parameter SI.Inductance[3, 3] L_abc=x*RL_base[2];
  SI.Conductance[3, 3] G;
  SI.Conductance[3, 3] R;
  SI.Inductance[3, 3] L;
  SI.Current[3] i_x;
annotation (defaultComponentName = "xShuntNonSym",
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
<p>Reactive shunt with general reactance matrix and parallel conductor, defined in abc inertial system.<br>
Use only if 'non symmetric' is really desired because this component needs a time dependent transform of the coefficient matrix.</p>
<p>Info see package ACdqo.Impedances.</p>
</html>
"),
  Icon( Rectangle(extent=[70,30; 80,-30], style(
            color=10,
            rgbcolor={135,135,135},
            thickness=2,
            fillColor=10,
            rgbfillColor={135,135,135})),
        Rectangle(extent=[-80,30; -40,-30], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
        Rectangle(extent=[-40,30; 70,-30], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2,
            fillColor=62,
            rgbfillColor={0,120,120})),
      Polygon(points=[-80,30; -80,0; -50,30; -80,30], style(
            pattern=0,
            fillColor=9,
            rgbfillColor={175,175,175}))),
  Diagram(
        Rectangle(extent=[-60,62; 60,52], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-60,48; 60,38], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-60,30; 60,20], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
    Rectangle(extent=[-60,-20; 60,-30], style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175},
        fillPattern=1)),
    Rectangle(extent=[-60,-70; 60,-80],
                                      style(
        color=9,
        rgbcolor={175,175,175},
        fillColor=9,
        rgbfillColor={175,175,175})),
        Rectangle(extent=[-60,12; 60,2], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-60,-2; 60,-12],style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Rectangle(extent=[-60,-38; 60,-48], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255})),
    Rectangle(extent=[-60,-52; 60,-62],
                                      style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Line(points=[-60,38; -60,62], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1)),
        Line(points=[-60,-12; -60,12], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1)),
        Line(points=[-60,-62; -60,-38], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1)),
        Line(points=[60,38; 60,62], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1)),
        Line(points=[60,-12; 60,12], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1)),
        Line(points=[60,-62; 60,-38], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1))));

initial equation
  if system.steadyIni then
    der(psi_x[1:2]) = omega[1]*j_dqo(psi_x[1:2]);
    psi_x[3] = 0;
  end if;

equation
  L = Park*L_abc*transpose(Park);
  R = Park*diagonal(R_abc)*transpose(Park);
  G = Park*diagonal(G_abc)*transpose(Park);

  i_x = i - G*v;
  psi_x = L*(i - G*v);
  der(psi_x) + omega[2]*j_dqo(psi_x) + R*i_x = v;
end ReactiveShuntNonSym;

model CapacitiveShuntNonSym
    "Shunt capacitor with parallel conductor non symmetric, 3-phase dqo, pp pg"
  extends Partials.ShuntBaseNonSym;

  parameter SIpu.Conductance[3] g_pg={0,0,0} "conductance ph-grd abc";
  parameter SIpu.Conductance[3] g_pp={0,0,0} "conductance ph_ph abc";
  parameter SIpu.Susceptance[3] b_pg={1,1,1} "susceptance ph-grd abc";
  parameter SIpu.Susceptance[3] b_pp={1,1,1}/3 "susceptance ph-ph abc";
  SI.ElectricCharge[3] q(each stateSelect=StateSelect.prefer) "electric charge";
  protected
  final parameter SI.Resistance[2] GC_base=Base.Precalculation.baseGC(units, V_nom, S_nom, 2*pi*f_nom);
  final parameter SI.Conductance[3,3] G_abc=(diagonal(g_pg)+
    [g_pp[2]+g_pp[3],-g_pp[3],-g_pp[2];-g_pp[3],g_pp[3]+g_pp[1],-g_pp[1];-g_pp[2],-g_pp[1],g_pp[1]+g_pp[2]])
    *GC_base[1];
  final parameter SI.Capacitance[3,3] C_abc=(diagonal(b_pg)+
    [b_pp[2]+b_pp[3],-b_pp[3],-b_pp[2];-b_pp[3],b_pp[3]+b_pp[1],-b_pp[1];-b_pp[2],-b_pp[1],b_pp[1]+b_pp[2]])
    *GC_base[2];
  SI.Conductance[3, 3] G;
  SI.Inductance[3, 3] C;
annotation (defaultComponentName = "cShuntNonSym",
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
<p>Capacitive shunt with general susceptance matrix and parallel conductor, defined in abc inertial system.<br>
Use only if 'non symmetric' is really desired because this component needs a time dependent transform of the coefficient matrix.</p>
<p>Terminology.<br>
&nbsp;  _pg denotes phase-to-ground<br>
&nbsp;  _pp denotes phase-to-phase</p>
<p>Info see package ACdqo.Impedances.</p>
</html>
"),
  Icon( Rectangle(extent=[-12,60; 12,-60], style(
            color=30,
            rgbcolor={215,215,215},
            fillColor=30,
            rgbfillColor={215,215,215})),
        Line(points=[-90,0; -20,0], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2)),
    Polygon(points=[-12,60; -12,30; 12,60; -12,60], style(
            pattern=0,
            fillColor=9,
            rgbfillColor={175,175,175})),
        Rectangle(extent=[-20,60; -12,-60], style(
            color=62,
            rgbcolor={0,120,120},
            fillColor=62,
            rgbfillColor={0,120,120})),
        Rectangle(extent=[12,60; 20,-60], style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=10,
            rgbfillColor={135,135,135}))),
  Diagram(
        Rectangle(extent=[36,70; 38,50], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[42,70; 44,50], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[36,20; 38,0], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[42,20; 44,0], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[36,-30; 38,-50], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[42,-30; 44,-50], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
    Rectangle(extent=[30,44; 50,36], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[30,-6; 50,-14], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[30,-56; 50,-64], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[36,60; 20,60; 20,40; 30,40], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[36,10; 20,10; 20,-10; 30,-10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[36,-40; 20,-40; 20,-60; 30,-60], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[44,60; 60,60; 60,40; 50,40], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[44,10; 60,10; 60,-10; 50,-10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[44,-40; 60,-40; 60,-60; 50,-60], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-70,28; -50,26], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-70,22; -50,20], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-44,34; -36,14], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-60,28; -60,40; -40,40; -40,34], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-60,20; -60,8; -40,8; -40,14], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-70,-22; -50,-24], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-70,-28; -50,-30], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-44,-16; -36,-36], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-60,-22; -60,-10; -40,-10; -40,-16], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-60,-30; -60,-42; -40,-42; -40,-36], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Rectangle(extent=[-30,4; -10,2], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-30,-2; -10,-4], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Rectangle(extent=[-4,10; 4,-10], style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-20,4; -20,16; 0,16; 0,10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-20,-4; -20,-16; 0,-16; 0,-10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-60,50; 20,50], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-60,0; 20,0], style(
        color=3,
        rgbcolor={0,0,255},
        pattern=3,
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-60,-50; 20,-50], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-50,50; -50,40], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-50,-50; -50,-42], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-50,8; -50,-10], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-10,50; -10,16], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
    Line(points=[-10,-50; -10,-16], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1)),
        Text(
          extent=[-80,-60; 0,-70],
          style(color=3, rgbcolor={0,0,255}),
          string="b_pp, g_pp"),
        Text(
          extent=[0,-70; 80,-80],
          style(color=3, rgbcolor={0,0,255}),
          string="b_pg"),
        Text(
          extent=[0,-80; 80,-90],
          style(color=3, rgbcolor={0,0,255}),
          string="g_pg")));

initial equation
  if system.steadyIni then
    der(q[1:2]) = omega[1]*j_dqo(q[1:2]);
    q[3] = 0;
  end if;

equation
  C = Park*C_abc*transpose(Park);
  G = Park*G_abc*transpose(Park);

  q = C*v;
  der(q) + omega[2]*j_dqo(q) + G*v = i;
end CapacitiveShuntNonSym;

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

    partial model ShuntBase "Shunt base, 3-phase dqo"
      extends Ports.Port_p;
      extends Base.Units.NominalAC;

      SI.Voltage[3] v;
      SI.Current[3] i;
    protected
      SI.AngularFrequency[2] omega;
      annotation (
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
</html>
"),     Diagram(
    Line(points=[60,50; 80,50], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[60,0; 80,0], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[60,-50; 80,-50], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
          Rectangle(extent=[80,10; 84,-10], style(
              color=10,
              fillColor=10,
              fillPattern=1)),
          Rectangle(extent=[80,60; 84,40], style(
              color=10,
              fillColor=10,
              fillPattern=1)),
          Rectangle(extent=[80,-40; 84,-60], style(
              color=10,
              fillColor=10,
              fillPattern=1)),
    Line(points=[-80,50; -60,50],
                                style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[-80,0; -60,0],
                              style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
    Line(points=[-80,-50; -60,-50],
                                  style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1))),
        Icon);

    equation
      omega = der(term.theta);
      v = term.v;
      i = term.i;
    end ShuntBase;

    partial model ShuntBaseNonSym "Shunt base non symmetric, 3-phase dqo"
      extends ShuntBase;

    protected
      Real[3,3] Park = Base.Transforms.park(term.theta[2]);
      annotation (
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
<p>Same as ShuntBase, but contains additionally a Park-transform which is needed for
transformation of general impedance matrices from abc rest- to general dqo-system.
(for example when coefficients of non symmetric systems are defined in abc representation.)
</pre>
</html>"),
        Diagram,
        Icon);
    end ShuntBaseNonSym;
  end Partials;

end Shunts;
