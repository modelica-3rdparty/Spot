package Nodes "Nodes and adaptors"
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
</html>"),
  Icon);

  model Ground "AC Ground, 3-phase abc"
    extends Ports.Port_p;

    annotation (
      defaultComponentName="grd1",
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
<p>Zero voltage on all phases of terminal.</p>
</html>
"),
  Icon( Rectangle(extent=[-4,60; 4,-60], style(
  color=10,
  fillColor=9,
  fillPattern=1)),
        Line(points=[-90,0; -4,0], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2))),
  Diagram(Line(points=[-60,0; -80,0],
                                    style(
        color=3,
        rgbcolor={0,0,255},
        thickness=2)), Rectangle(extent=[-60,20; -54,-20],
                                                         style(
  color=10,
  fillColor=9,
  fillPattern=1))));

  equation
    term.v = zeros(3);
  end Ground;

  model GroundOne "Ground, one conductor"

    Base.Interfaces.Electric_p term "positive scalar terminal"
                               annotation (extent=[-110,-10; -90,10]);
    annotation (
      defaultComponentName="grd1",
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
<p>Zero voltage on terminal.</p>
</html>
"),
  Icon(
   Text(
  extent=[-100,-90; 100,-130],
  string="%name",
  style(color=0)),
        Rectangle(extent=[-4,50; 4,-50], style(
  color=10,
  fillColor=9,
  fillPattern=1)),
        Line(points=[-90,0; -4,0],  style(color=3, rgbcolor={0,0,255}))),
  Diagram(Line(points=[-60,0; -80,0], style(color=3, rgbcolor={0,0,255})),
                       Rectangle(extent=[-60,20; -54,-20],
                                                         style(
  color=10,
  fillColor=9,
  fillPattern=1))));

  equation
    term.v = 0;
  end GroundOne;

  model BusBar "Busbar, 3-phase abc"

    output SI.Voltage v_norm(stateSelect=StateSelect.never);
    output SI.Angle alpha_v(stateSelect=StateSelect.never);

    Base.Interfaces.ACabc_p term "bus bar"
  annotation (
      extent=[-8,-66; 8,66],   rotation=0,
      style(
        color=70,
        rgbcolor={0,130,175},
        fillColor=70,
        rgbfillColor={0,130,175}));
  protected
    Real[3,3] P = Base.Transforms.park(term.theta[1]);
    function atan2 = Modelica.Math.atan2;
    annotation (
      defaultComponentName="bus1",
  Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]),
  Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
  Icon(
   Text(
  extent=[-100,-90; 100,-130],
  string="%name",
  style(color=0)),
                 Rectangle(extent=[-10,80; 10,-80], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2,
            fillColor=70,
            rgbfillColor={0,130,175}))),
      Rectangle(extent=[-10,80; 10,-80], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255})),
  Diagram,
  Documentation(
          info="<html>
<p>Calculates norm and phase-angle of voltage.</p>
</html>"));

  equation
    term.i = zeros(3);
    v_norm = sqrt(term.v*term.v);
    alpha_v = atan2(P[2,:]*term.v, P[1,:]*term.v);
  end BusBar;

  model Ynode "Y-node with neutral-access, 3-phase abc"
    extends Ports.Port_p;

    Base.Interfaces.Electric_n neutral "neutral Y"
  annotation (
        extent=[90,-10; 110,10]);
    annotation (
      defaultComponentName="Ynode",
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
<p>Can be used for grounding neutral of AC abc 3phase components.</p>
</html>
"),
  Icon(
    Rectangle(extent=[-80,80; 80,-80], style(
        color=7,
        rgbcolor={255,255,255},
        pattern=0,
        fillColor=7,
        rgbfillColor={255,255,255})),
        Line(points=[-80,60; -40,60; 20,0; -40,-60; -80,-60], style(color=70,
              rgbcolor={0,130,175})),
        Line(points=[-80,0; 20,0], style(color=70, rgbcolor={0,130,175})),
        Line(points=[20,0; 90,0]),
        Ellipse(extent=[14,6; 26,-6], style(
            color=70,
            rgbcolor={0,130,175},
            fillColor=70,
            rgbfillColor={0,130,175}))),
  Diagram(
        Line(points=[-80,0; 90,0], style(color=3, rgbcolor={0,0,255})),
        Line(points=[-80,60; -40,60; 20,0; -40,-60; -80,-60], style(color=3,
              rgbcolor={0,0,255})),
        Ellipse(extent=[14,6; 26,-6], style(color=73, fillColor=73)),
    Text(
      extent=[10,-10; 50,-30],
      style(color=3, rgbcolor={0,0,255}),
      string="neutral point")));

  equation
    term.v = fill(neutral.v,3);
    neutral.i + sum(term.i) = 0;
  end Ynode;

  model Y_Delta "Y_Delta switch, 3-phase abc"

    Base.Interfaces.ACabc_p term_p "connect to non source side of windings"
  annotation (extent=[110,-70; 90,-50]);
    Base.Interfaces.ACabc_n term_n "connect to source side of windings"
  annotation (extent=[-90,-70; -110,-50]);
  annotation (
    defaultComponentName="Y_Delta",
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
<p>Can be used for detailed investigation of Y-Delta switching.</p>
</html>
"),   Icon(
  Rectangle(extent=[-80,60; 80,-60], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
       Text(
      extent=[-100,-90; 100,-130],
      string="%name",
      style(color=0)),
        Line(points=[58,30; 88,40], style(color=3, rgbcolor={0,0,255})),
        Line(points=[58,-10; 88,0],
                                  style(color=3, rgbcolor={0,0,255})),
        Text(
          extent=[-80,10; 80,-30],
          style(color=3, rgbcolor={0,0,255}),
          string="Delta"),
        Text(
          extent=[-80,50; 80,10],
          style(color=3, rgbcolor={0,0,255}),
          string="Y")),
      Diagram(
        Text(
          extent=[46,6; 86,-6],
          style(color=3, rgbcolor={0,0,255}),
          string="Delta >"),
        Text(
          extent=[54,46; 94,34],
          style(color=3, rgbcolor={0,0,255}),
          string="Y >"),
        Text(
          extent=[-96,26; 4,14],
          style(color=3, rgbcolor={0,0,255}),
          string="< commute Y - D"),
        Text(
          extent=[-91,-54; -31,-66],
          string="< winding",
          style(color=1, rgbcolor={255,0,0})),
        Text(
          extent=[31,-54; 92,-66],
          style(color=3, rgbcolor={0,0,255}),
          string="winding >"),
        Text(
          extent=[-40,-74; 40,-86],
          style(color=3, rgbcolor={0,0,255}),
          string="neutral (Y)"),
        Line(points=[-100,20; -110,20; -110,60; -26,60], style(
            color=0,
            rgbcolor={0,0,0},
            pattern=3)),
        Line(points=[99,40; 110,40; 110,60; 29,60], style(
            color=0,
            rgbcolor={0,0,0},
            pattern=3)),
        Line(points=[99,0; 120,0; 120,80; 29,80], style(
            color=0,
            rgbcolor={0,0,0},
            pattern=3)),
        Text(
          extent=[-60,100; 60,90],
          style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1),
          string="Use with a commuting switch"),
        Ellipse(extent=[23,83; 29,77], style(color=0, rgbcolor={0,0,0})),
        Ellipse(extent=[23,63; 29,57], style(color=0, rgbcolor={0,0,0})),
        Ellipse(extent=[-29,63; -23,57], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=0,
            rgbfillColor={0,0,0})),
        Ellipse(extent=[-9,61; -7,59], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=0,
            rgbfillColor={0,0,0})),
        Line(points=[-26,60; -8,60; 12,80; 24,80], style(color=0, rgbcolor={0,0,
                0})),
        Line(points=[12,60; 24,60], style(color=0, rgbcolor={0,0,0})),
        Text(
          extent=[-85,-64; -25,-76],
          string="source-side",
          style(color=1, rgbcolor={255,0,0}))));
    Base.Interfaces.ElectricV_n switchY_D(final m=3)
      "connect to switch 'commute' position"
                                        annotation (extent=[-90,10; -110,30]);
    Base.Interfaces.ElectricV_p switchD(final m=3)
      "connect to switch 'Delta' position"
                                        annotation (extent=[110,-10; 90,10]);
    Base.Interfaces.ElectricV_p switchY(final m=3)
      "connect to switch 'Y' position"  annotation (extent=[110,30; 90,50]);
    Base.Interfaces.Electric_n neutral "neutral Y"
                                  annotation (extent=[-10,-70; 10,-50],  rotation=
         90);
  protected
    Real[3,3] Rot = Base.Transforms.rotation_abc(term_p.theta[2]);

  equation
    switchY_D.pin.v = Rot*term_p.v;
    term_p.i + transpose(Rot)*switchY_D.pin.i = zeros(3);
    switchY.pin.v = fill(neutral.v, 3);
    sum(switchY.pin.i) + neutral.i = 0;
    switchD.pin[{3,1,2}].v = Rot*term_n.v;
    term_n.i + transpose(Rot)*switchD.pin[{3,1,2}].i = zeros(3);
  end Y_Delta;

  model ResistiveGround "Y-node with neutral-access, 3-phase abc"
    extends Ports.Yport_p;
    extends Base.Units.Nominal;

    parameter SIpu.Resistance r_n=0 "resistance neutral to grd";
  protected
    final parameter SI.Resistance R_base=Base.Precalculation.baseR(units, V_nom, S_nom);
    final parameter SI.Resistance R_n=r_n*R_base;
    annotation (
      defaultComponentName="resGrd",
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
<p>Can be used for grounding neutral of AC abc 3phase components.</p>
</html>
"),
  Icon( Rectangle(extent=[94,30; 100,-30], style(
  color=10,
  fillColor=10,
  fillPattern=1)),
        Line(points=[-80,0; -40,0], style(color=70, rgbcolor={0,130,175})),
        Rectangle(extent=[-20,30; 94,-30], style(
            color=3,
            rgbcolor={0,0,255},
            gradient=0,
            fillColor=7,
            rgbfillColor={255,255,255})),
        Line(points=[-80,60; -60,60; -40,0; -60,-60; -80,-60], style(color=70,
              rgbcolor={0,130,175})),
        Line(points=[-40,0; -20,0]),
        Ellipse(extent=[-46,6; -34,-6], style(
            color=70,
            rgbcolor={0,130,175},
            fillColor=70,
            rgbfillColor={0,130,175}))),
  Diagram(
        Rectangle(extent=[96,4; 100,-4],  style(
        color=10,
        rgbcolor={128,128,128},
        thickness=2,
        fillColor=10,
        rgbfillColor={128,128,128},
        fillPattern=1)),
    Rectangle(extent=[70,4; 96,-4],    style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
  Text(
    extent=[40,-20; 80,-40],
    string="neutral point",
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Ellipse(extent=[59,2; 63,-2], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))));

  equation
    v = zeros(3);
    R_n*i_n = v_n "equation neutral to ground";
  end ResistiveGround;

  model InductiveGround "Y-node with neutral-access, 3-phase abc"
    extends Ports.Yport_p;
    extends Base.Units.NominalAC;

    parameter SIpu.Reactance x_n=1 "reactance neutral to grd";
    parameter SIpu.Resistance r_n=0 "resistance neutral to grd";
  protected
    final parameter SI.Resistance R_base=Base.Precalculation.baseR(units, V_nom, S_nom);
    final parameter SI.Inductance L_n=x_n*R_base/(2*pi*f_nom);
    final parameter SI.Resistance R_n=r_n*R_base;
    annotation (
      defaultComponentName="indGrd",
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
<p>Can be used for grounding neutral of AC abc 3phase components.</p>
</html>
"),
  Icon( Line(points=[-80,0; -40,0], style(color=70, rgbcolor={0,130,175})),
        Line(points=[-80,60; -60,60; -40,0; -60,-60; -80,-60], style(color=70,
              rgbcolor={0,130,175})),
        Rectangle(extent=[94,30; 100,-30], style(
  color=10,
  fillColor=10,
  fillPattern=1)),
        Rectangle(extent=[-20,30; 10,-30], style(gradient=0, fillColor=7)),
    Rectangle(extent=[10,30; 94,-30], style(
        color=3,
        rgbcolor={0,0,255},
        fillColor=3,
        rgbfillColor={0,0,255},
        fillPattern=1)),
        Line(points=[-38,0; -20,0]),
        Ellipse(extent=[-46,6; -34,-6], style(
            color=70,
            rgbcolor={0,130,175},
            fillColor=70,
            rgbfillColor={0,130,175}))),
  Diagram(
    Rectangle(extent=[70,4; 76,-4],   style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
    Rectangle(extent=[76,4; 96,-4], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[96,4; 100,-4],  style(
        color=10,
        rgbcolor={128,128,128},
        thickness=2,
        fillColor=10,
        rgbfillColor={128,128,128},
        fillPattern=1)),
        Ellipse(extent=[59,2; 63,-2], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
  Text(
    extent=[40,-20; 80,-40],
    string="neutral point",
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))));

  initial equation
    if system.steadyIni then
      der(i_n) = 0;
    end if;

  equation
    v = zeros(3);
    L_n*der(i_n) + R_n*i_n = v_n;
  end InductiveGround;

  model CapacitiveGround "Y-node with neutral-access, 3-phase abc"
    extends Ports.Yport_p;
    extends Base.Units.NominalAC;

    parameter SIpu.Susceptance b_n=1 "susceptance neutral to grd";
    parameter SIpu.Conductance g_n=0 "conductance neutral to grd";
  protected
    final parameter SI.Resistance R_base=Base.Precalculation.baseR(units, V_nom, S_nom);
    final parameter SI.Capacitance C_n=b_n/(R_base*2*pi*f_nom);
    final parameter SI.Conductance G_n=g_n/R_base;
    annotation (
      defaultComponentName="capGrd",
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
<p>Can be used for grounding neutral of AC abc 3phase components.</p>
</html>
"),
  Icon( Line(points=[-80,0; -40,0], style(color=70, rgbcolor={0,130,175})),
        Line(points=[-80,60; -60,60; -40,0; -60,-60; -80,-60], style(color=70,
              rgbcolor={0,130,175})),
        Rectangle(extent=[8,60; 32,-60], style(
            color=30,
            rgbcolor={215,215,215},
            fillColor=30,
            rgbfillColor={215,215,215})),
        Rectangle(extent=[0,60; 8,-60], style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[32,60; 40,-60], style(
            color=10,
            rgbcolor={135,135,135},
            fillColor=10,
            rgbfillColor={135,135,135})),
        Line(points=[-40,0; 0,0]),
        Ellipse(extent=[-46,6; -34,-6], style(
            color=70,
            rgbcolor={0,130,175},
            fillColor=70,
            rgbfillColor={0,130,175}))),
  Diagram(
        Rectangle(extent=[92,16; 96,-16],style(
            color=30,
            rgbcolor={215,215,215},
            pattern=0,
            fillColor=30,
            rgbfillColor={215,215,215})),
        Rectangle(extent=[88,16; 92,-16],
                                        style(
  color=3,
  fillColor=3,
  fillPattern=1)),
        Rectangle(extent=[96,16; 100,-16],style(
        color=10,
        rgbcolor={128,128,128},
        thickness=2,
        fillColor=10,
        rgbfillColor={128,128,128},
        fillPattern=1)),
        Line(points=[70,0; 88,0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Ellipse(extent=[59,2; 63,-2], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
  Text(
    extent=[40,-20; 80,-40],
    string="neutral point",
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))));

  initial equation
    if system.steadyIni then
      der(v_n) = 0;
    end if;

  equation
    v = zeros(3);
    C_n*der(v_n) + G_n*v_n = i_n;
  end CapacitiveGround;

  model Y_OnePhase "Terminator, ACabc to an, bn, cn"
    extends Ports.Port_p;
    extends Base.Icons.Adaptor_abc;

    Base.Interfaces.Electric_p neutral "neutral Y"
      annotation (extent=[-10,-90; 10,-70],
        rotation=90);
    Base.Interfaces.ElectricV_n plug_a(final m=2) "phase a and neutral"
      annotation (extent=[90,30;
          110,50]);
    Base.Interfaces.ElectricV_n plug_b(final m=2) "phase b and neutral"
      annotation (extent=[90,-10;
          110,10]);
    Base.Interfaces.ElectricV_n plug_c(final m=2) "phase c and neutral"
      annotation (extent=[90,-50;110,-30]);
  protected
    Real[3,3] Rot = Base.Transforms.rotation_abc(term.theta[2]);
  annotation (defaultComponentName = "Y_abcn",
        Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
        Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
        Icon(
        Text(
          extent=[-100,100; 100,80],
            string="> 1-phase",
            style(color=3, rgbcolor={0,0,255}))),
        Documentation(info="<html>
</html>"),
        Diagram);

  equation
    plug_a.pin.v = cat(1, Rot[1:1, :]*term.v, {neutral.v});
    plug_b.pin.v = cat(1, Rot[2:2, :]*term.v, {neutral.v});
    plug_c.pin.v = cat(1, Rot[3:3, :]*term.v, {neutral.v});
    term.i + transpose(Rot)*{plug_a.pin[1].i, plug_b.pin[1].i, plug_c.pin[1].i} = zeros(3);
  end Y_OnePhase;

  model ACabc_a_b_c "Adaptor ACabc to pins a, b, c"
    extends Ports.Port_p;
    extends Base.Icons.Adaptor_abc;

    Base.Interfaces.Electric_n term_a "phase a"
        annotation (extent=[90,30; 110,50]);
    Base.Interfaces.Electric_n term_b "phase b"
        annotation (extent=[90,-10; 110,10]);
    Base.Interfaces.Electric_n term_c "phase c"
        annotation (extent=[90,-50; 110,-30]);
    Real[3,3] Rot = Base.Transforms.rotation_abc(term.theta[2]);
      annotation (defaultComponentName = "acabc_a_b_c",
          Coordsys(
    extent=[-100, -100; 100, 100],
    grid=[2, 2],
    component=[20, 20]),
          Window(
    x=0.45,
    y=0.01,
    width=0.44,
    height=0.65),
          Icon,
          Documentation(info="<html>
</html>
"),       Diagram);

  equation
    {term_a.v,term_b.v,term_c.v} = Rot*term.v;
    term.i + transpose(Rot)*{term_a.i,term_b.i,term_c.i} = zeros(3);
  end ACabc_a_b_c;

  model ACabc_abc "Adaptor ACabc to 3-vector abc"
    extends Ports.Port_p;
    extends Base.Icons.Adaptor_abc;

    Base.Interfaces.ElectricV_n term_abc(final m=3) "phase abc vector-pin"
      annotation (extent=[90,-10; 110,10]);
  protected
    Real[3,3] Rot = Base.Transforms.rotation_abc(term.theta[2]);
  annotation (defaultComponentName = "acabc_abc",
      Coordsys(
        extent=[-100,-100; 100,100],
        grid=[2,2],
        component=[20,20]),
      Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
      Icon,
      Documentation(info="<html>
</html>
"),   Diagram);

  equation
    term_abc.pin.v = Rot*term.v;
    term.i + transpose(Rot)*term_abc.pin.i = zeros(3);
  end ACabc_abc;

  model DefReference "Defines reference system, 3phase dqo"
    outer System system;

    Base.Interfaces.ACabc_p term "bus bar"
  annotation (
      extent=[-10,-10; 10,10], rotation=0,
      style(
        color=62,
        rgbcolor={0,110,110},
        fillColor=62,
        rgbfillColor={0,110,110}));
    Modelica.Blocks.Interfaces.RealInput theta(redeclare type SignalType =
      SI.Angle) "absolute angle"
      annotation (extent=[-10,90; 10,110], rotation=-90);
    annotation (defaultComponentName="reference",
      Coordsys(
        extent=[-100, -100; 100, 100],
        grid=[2, 2],
        component=[20, 20]),
      Icon(Text(
          extent=[-100,-90; 100,-130],
          string="%name",
          style(color=0)), Rectangle(extent=[-10,80; 10,-80], style(
            color=43,
            rgbcolor={255,85,85},
            gradient=2,
            fillColor=43,
            rgbfillColor={255,85,85})),
        Rectangle(extent=[-20,120; 20,80], style(
            color=84,
            rgbcolor={213,170,255},
            fillColor=84,
            rgbfillColor={213,170,255}))),
      Documentation(info="<html>
<p>Explicit definition of relative-angle term.theta[1] and reference-angle term.theta[2]<br>
(only for advanced use needed).</p>
</html>"),
      Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
      Diagram);

  equation
    term.i = zeros(3);
    Connections.potentialRoot(term.theta);
    if Connections.isRoot(term.theta) then
      term.theta = if system.synRef then {0, theta} else {theta, 0};
    end if;
  end DefReference;

  model Break "Breaks transmission of theta, 3phase abc"

    annotation (defaultComponentName="break1",
      Coordsys(
        extent=[-100, -100; 100, 100],
        grid=[2, 2],
        component=[20, 20]),
      Icon(Text(
          extent=[-100,-90; 100,-130],
          string="%name",
          style(color=0)), Rectangle(extent=[-10,80; 10,-80],   style(
            color=10,
            gradient=2,
            fillColor=49))),
      Documentation(info="<html>
<p>Breaks explicitly transfer of angle theta from term_p to term_n.</p>
<p>The electric connections remain the same as in Base.PortsACdqo.Port_pn, whereas the equation</p>
<pre>  term_n.theta = term_p.theta</pre>
<p>is omitted together with the function 'Connections.branch'<br>
(only for advanced use needed).</p>
</html>"),
      Window(
        x=0.45,
        y=0.01,
        width=0.44,
        height=0.65),
      Diagram(
        Line(points=[0,20; 0,-20], style(color=0, rgbcolor={0,0,0})),
        Line(points=[-25,0; -10,0], style(
            color=0,
            rgbcolor={0,0,0},
            arrow=1)),
        Line(points=[25,0; 10,0], style(
            color=0,
            rgbcolor={0,0,0},
            arrow=1)),
              Text(
          extent=[-50,60; 50,40],
          style(color=0, rgbcolor={0,0,0}),
          string="theta not transmitted")));
    Base.Interfaces.ACabc_p term_p "positive terminal"
  annotation (extent=[-40,-10; -20,10]);
    Base.Interfaces.ACabc_n term_n "negative terminal"
  annotation (extent=[20,-10; 40,10]);

  equation
    term_p.v = term_n.v;
    term_p.i + term_n.i = zeros(3);
  end Break;

end Nodes;
