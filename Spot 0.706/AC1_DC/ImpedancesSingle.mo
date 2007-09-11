package ImpedancesSingle "Simple mpedance and admittance two terminal"
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
<p>One-conductor models <b>without</b> choice of units and base-values, using directly the parameters</p>
<pre>
  R      resistance
  L      inductance
  G      conductance
  C      capacitance
</pre>
<p>in SI-units.</p>
</html>       "),
    Icon);

  model Resistor "Resistor, 1-phase"
    extends Partials.ImpedBase;

    parameter SI.Resistance R=1;
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
<p>Info see package AC1_DC.ImpedancesSingle.</p>
</html>"),
      Icon(
  Rectangle(extent=[-80,20; 80,-20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255}))),
      Diagram(
        Rectangle(extent=[-60,10; 60,-10], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255}))));

  equation
    R*i = v;
  end Resistor;

  model Conductor "Conductor, 1-phase"
    extends Partials.ImpedBase;

    parameter SI.Conductance G=1;
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
<p>Info see package AC1_DC.ImpedancesSingle.</p>
</html>"),
      Icon(
  Rectangle(extent=[-80,20; 80,-20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255}))),
      Diagram(
        Rectangle(extent=[-60,10; 60,-10], style(
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

    parameter SI.Resistance R=0;
    parameter SI.Inductance L=1e-3;
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
<p>Info see package AC1_DC.ImpedancesSingle.</p>
</html>"),
      Icon(
  Rectangle(extent=[-80,20; -40,-20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
  Rectangle(extent=[-40,20; 80,-20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))),
      Diagram(
        Rectangle(extent=[-60,10; -40,-10], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
    Rectangle(extent=[-40,10; 60,-10], style(
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

    parameter SI.Conductance G=0;
    parameter SI.Capacitance C=1e-6;
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
<p>Info see package AC1_DC.ImpedancesSingle.</p>
</html>"),
      Icon(
        Line(points=[-90,0; -16,0], style(color=3, rgbcolor={0,0,255})),
        Line(points=[90,0; 16,0], style(color=3, rgbcolor={0,0,255})),
        Rectangle(extent=[-10,50; 10,-50], style(
            color=30,
            rgbcolor={215,215,215},
            fillColor=30,
            rgbfillColor={215,215,215})),
        Rectangle(extent=[-18,50; -10,-50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[10,50; 18,-50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255}))),
      Diagram(
        Rectangle(extent=[-4,20; -2,0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[2,20; 4,0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
    Rectangle(extent=[-10,-6; 10,-14], style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1)),
    Line(points=[-4,10; -60,10; -60,-10; -10,-10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=69,
            rgbfillColor={0,128,255})),
    Line(points=[4,10; 60,10; 60,-10; 10,-10], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=69,
            rgbfillColor={0,128,255}))));

  equation
    C*der(v) + G*v = i;
  end Capacitor;

  model ResistorSym "Symmetrical capacitor with neutral access, 1-phase"

    parameter SI.Resistance R=1;
    Base.Interfaces.Electric_p term_p
                                 annotation (extent=[-110,-10; -90,10]);
    Base.Interfaces.Electric_n term_n
                                 annotation (extent=[90,-10; 110,10]);
    Base.Interfaces.Electric_n neutral "symmetrical point"
      annotation (extent=[-10,-110; 10,-90], rotation=
          -90);
    Resistor res1(final R=R/2)               annotation (extent=[-40,-10; -20,10]);
    Resistor res2(final R=R/2)               annotation (extent=[20,-10; 40,10]);
    annotation (defaultComponentName="resSym",
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
<p>Info see package AC1_DC.ImpedancesSingle.</p>
</html>"),
      Icon(
        Line(points=[-90,0; -70,0], style(color=3, rgbcolor={0,0,255})),
        Line(points=[90,0; 70,0], style(color=3, rgbcolor={0,0,255})),
        Line(points=[-10,0; 10,0], style(color=3, rgbcolor={0,0,255})),
        Line(points=[0,0; 0,-90], style(color=3, rgbcolor={0,0,255})),
       Text(
      extent=[-100,130; 100,90],
      string="%name",
      style(color=0)),
  Rectangle(extent=[-70,10; -10,-10],style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
  Rectangle(extent=[10,10; 70,-10],  style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255}))),
      Diagram);

  equation
    connect(term_p, res1.term_p)
      annotation (points=[-100,0; -40,0], style(color=3, rgbcolor={0,0,255}));
    connect(res1.term_n, neutral) annotation (points=[-20,0; 0,0; 0,-100], style(
          color=3, rgbcolor={0,0,255}));
    connect(neutral, res2.term_p) annotation (points=[0,-100; 0,0; 20,0], style(
          color=3, rgbcolor={0,0,255}));
    connect(res2.term_n, term_n)
      annotation (points=[40,0; 100,0], style(color=3, rgbcolor={0,0,255}));
  end ResistorSym;

  model CapacitorSym "Symmetrical capacitor with neutral access, 1-phase"

    parameter SI.Conductance G=0;
    parameter SI.Capacitance C=1e-6;
    parameter SI.Voltage Vstart=0 "start voltage";
    Base.Interfaces.Electric_p term_p
                                 annotation (extent=[-110,-10; -90,10]);
    Base.Interfaces.Electric_n term_n
                                 annotation (extent=[90,-10; 110,10]);
    Base.Interfaces.Electric_n neutral "symmetrical point"
      annotation (extent=[-10,-110; 10,-90], rotation=
          -90);
    Capacitor cap1(final G=2*G, final C=2*C, v(start=Vstart/2))
                                             annotation (extent=[-40,-10; -20,10]);
    Capacitor cap2(final G=2*G, final C=2*C, v(start=Vstart/2))
                                             annotation (extent=[20,-10; 40,10]);
    annotation (defaultComponentName="capSym",
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
<p>Info see package AC1_DC.ImpedancesSingle.</p>
</html>"),
      Icon(
        Line(points=[-90,0; -68,0], style(color=3, rgbcolor={0,0,255})),
        Line(points=[90,0; 68,0], style(color=3, rgbcolor={0,0,255})),
        Rectangle(extent=[-60,50; -40,-50],style(
            color=30,
            rgbcolor={215,215,215},
            fillColor=30,
            rgbfillColor={215,215,215})),
        Rectangle(extent=[-68,50; -60,-50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[-40,50; -32,-50],
                                          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[40,50; 60,-50],  style(
            color=30,
            rgbcolor={215,215,215},
            fillColor=30,
            rgbfillColor={215,215,215})),
        Rectangle(extent=[32,50; 40,-50],   style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Rectangle(extent=[60,50; 68,-50], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Line(points=[-32,0; 32,0], style(color=3, rgbcolor={0,0,255})),
        Line(points=[0,0; 0,-90], style(color=3, rgbcolor={0,0,255})),
       Text(
      extent=[-100,130; 100,90],
      string="%name",
      style(color=0))),
      Diagram);

  equation
    connect(term_p, cap1.term_p)
      annotation (points=[-100,0; -40,0], style(color=3, rgbcolor={0,0,255}));
    connect(cap1.term_n, neutral) annotation (points=[-20,0; 0,0; 0,-100], style(
          color=3, rgbcolor={0,0,255}));
    connect(neutral, cap2.term_p) annotation (points=[0,-100; 0,0; 20,0], style(
          color=3, rgbcolor={0,0,255}));
    connect(cap2.term_n, term_n)
      annotation (points=[40,0; 100,0], style(color=3, rgbcolor={0,0,255}));
  end CapacitorSym;

  package Partials "Partial models"
    extends Base.Icons.Partials;

    partial model ImpedBase "Impedance base, 1-phase"
      SI.Voltage v;
      SI.Current i;
      Base.Interfaces.Electric_p term_p
                                   annotation (extent=[-110,-10; -90,10]);
      Base.Interfaces.Electric_n term_n
                                   annotation (extent=[90,-10; 110,10]);
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
"),   Icon(
         Text(
        extent=[-100,-90; 100,-130],
        string="%name",
        style(color=0))),
      Diagram(
          Line(points=[-90,0; -60,0], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
          Line(points=[60,0; 90,0], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1))));

    equation
      term_p.i + term_n.i = 0;
      v = term_p.v - term_n.v;
      i = term_p.i;
    end ImpedBase;

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

end ImpedancesSingle;
