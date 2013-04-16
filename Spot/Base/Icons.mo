within Spot.Base;
package Icons "Icons"
  extends Icons.Base;

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
</html>
"));

  partial block Block "Block icon"

    annotation (
  Coordsys(
    extent=[-100, -100; 100, 100],
    grid=[2, 2],
    component=[20, 20]),
  Window(
    x=0.45,
    y=0.01,
    width=0.44,
    height=0.65),
  Documentation(info="
"),
  Icon(Rectangle(extent=[-80, 60; 80, -60], style(
            color=74,
            rgbcolor={0,0,127},
            fillColor=7,
            rgbfillColor={255,255,255}))));
  end Block;

  partial block Block0 "Block icon 0"
    extends Block;
    annotation (
  Coordsys(
    extent=[-100, -100; 100, 100],
    grid=[2, 2],
    component=[20, 20]),
  Window(
    x=0.45,
    y=0.01,
    width=0.44,
    height=0.65),
  Documentation(info="
"),
  Icon(Text(
      extent=[-100,-80; 100,-120],
      string="%name",
      style(color=0))));
  end Block0;

  partial block Block1 "Block icon 1"
    extends Block;
    annotation (
  Coordsys(
    extent=[-100, -100; 100, 100],
    grid=[2, 2],
    component=[20, 20]),
  Window(
    x=0.45,
    y=0.01,
    width=0.44,
    height=0.65),
  Documentation(info="
"),
  Icon(Text(
      extent=[-100,120; 100,80],
      string="%name",
      style(color=0))));
  end Block1;

  partial block BlockS "Block icon shadowed"

    annotation (
  Coordsys(
    extent=[-100, -100; 100, 100],
    grid=[2, 2],
    component=[20, 20]),
  Window(
    x=0.45,
    y=0.01,
    width=0.44,
    height=0.65),
  Documentation(info="
"),
  Icon(Rectangle(extent=[-80, 60; 80, -60], style(
            color=74,
            rgbcolor={0,0,127},
            fillColor=8,
            rgbfillColor={192,192,192}))));
  end BlockS;

  partial block BlockS0 "Block icon shadowed 0"
    extends BlockS;
    annotation (
  Coordsys(
    extent=[-100, -100; 100, 100],
    grid=[2, 2],
    component=[20, 20]),
  Window(
    x=0.45,
    y=0.01,
    width=0.44,
    height=0.65),
  Documentation(info="
"),
  Icon(Text(
      extent=[-100,-80; 100,-120],
      string="%name",
      style(color=0))));
  end BlockS0;

  partial block BlockS1 "Block icon shadowed 1"
    extends BlockS;
    annotation (
  Coordsys(
    extent=[-100, -100; 100, 100],
    grid=[2, 2],
    component=[20, 20]),
  Window(
    x=0.45,
    y=0.01,
    width=0.44,
    height=0.65),
  Documentation(info="
"),
  Icon(Text(
      extent=[-100,120; 100,80],
      string="%name",
      style(color=0))));
  end BlockS1;

partial model Adaptor_abc "Adaptor icon abc"

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
    Icon(
        Rectangle(extent=[-80,60; 80,-60], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
Text(extent=[0,58; 60,18],   string="~",
        style(color=3, rgbcolor={0,0,255})),
Text(extent=[0,18; 60,-22],   string="~",
        style(color=3, rgbcolor={0,0,255})),
Text(extent=[0,-22; 60,-62],   string="~",
        style(color=3, rgbcolor={0,0,255})),
      Text(
        extent=[50,50; 70,30],
        style(color=3, rgbcolor={0,0,255}),
          string="a"),
      Text(
        extent=[50,10; 70,-10],
        style(color=3, rgbcolor={0,0,255}),
          string="b"),
      Text(
        extent=[50,-30; 70,-50],
        style(color=3, rgbcolor={0,0,255}),
          string="c"),
      Text(
        extent=[-70,50; -50,30],
        string="a",
          style(color=70, rgbcolor={0,130,175})),
      Text(
        extent=[-70,10; -50,-10],
        string="b",
          style(color=70, rgbcolor={0,130,175})),
      Text(
        extent=[-70,-30; -50,-50],
        string="c",
          style(color=70, rgbcolor={0,130,175})),
Text(extent=[-60,62; 0,22],  string="~",
          style(color=70, rgbcolor={0,130,175})),
Line(points=[-46,30; -14,30], style(color=70, rgbcolor={0,130,175})),
Text(extent=[-60,22; 0,-18],  string="~",
          style(color=70, rgbcolor={0,130,175})),
Line(points=[-46,-10; -14,-10], style(color=70, rgbcolor={0,130,175})),
Line(points=[-46,-50; -14,-50], style(color=70, rgbcolor={0,130,175})),
Text(extent=[-60,-18; 0,-58], string="~",
          style(color=70, rgbcolor={0,130,175})),
     Text(
    extent=[-100,-90; 100,-130],
    string="%name",
    style(color=0))),
    Diagram,
      Documentation(info=""));

end Adaptor_abc;

partial model Adaptor_dqo "Adaptor icon dqo"

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
    Icon(
        Rectangle(extent=[-80,60; 80,-60], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
Text(extent=[0,58; 60,18],   string="~",
        style(color=3, rgbcolor={0,0,255})),
Text(extent=[0,18; 60,-22],   string="~",
        style(color=3, rgbcolor={0,0,255})),
Text(extent=[0,-22; 60,-62],   string="~",
        style(color=3, rgbcolor={0,0,255})),
      Text(
        extent=[50,50; 70,30],
        style(color=3, rgbcolor={0,0,255}),
          string="a"),
      Text(
        extent=[50,10; 70,-10],
        style(color=3, rgbcolor={0,0,255}),
          string="b"),
      Text(
        extent=[50,-30; 70,-50],
        style(color=3, rgbcolor={0,0,255}),
          string="c"),
      Text(
        extent=[-70,50; -50,30],
        string="d",
          style(color=62, rgbcolor={0,120,120})),
      Text(
        extent=[-70,10; -50,-10],
        string="q",
          style(color=62, rgbcolor={0,120,120})),
      Text(
        extent=[-70,-30; -50,-50],
        string="o",
          style(color=62, rgbcolor={0,120,120})),
Text(extent=[-60,62; 0,22],  string="~",
          style(color=62, rgbcolor={0,120,120})),
Line(points=[-46,30; -14,30], style(color=62, rgbcolor={0,120,120})),
Text(extent=[-60,22; 0,-18],  string="~",
          style(color=62, rgbcolor={0,120,120})),
Line(points=[-46,-10; -14,-10], style(color=62, rgbcolor={0,120,120})),
Line(points=[-46,-40; -14,-40], style(color=62, rgbcolor={0,120,120})),
     Text(
    extent=[-100,-90; 100,-130],
    string="%name",
    style(color=0))),
    Diagram,
      Documentation(info=""));

end Adaptor_dqo;

partial model Inverter "Inverter icon"

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
    Icon(
      Rectangle(
        extent=[-80,60; 80,-60], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Rectangle(
        extent=[-80,60; 80,-60], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
     Text(
    extent=[-100,-90; 100,-130],
    string="%name",
    style(color=0))),
    Diagram,
      Documentation(info=""));

end Inverter;

partial model Inverter_abc "Inverter icon"

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
    Icon(
      Rectangle(
        extent=[-80,60; 80,-60], style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
      Line(
   points=[-80,-60; 80,60], style(color=70, rgbcolor={0,130,175})),
Line(points=[24,-40; 56,-40], style(color=70, rgbcolor={0,130,175})),
Line(points=[24,-20; 56,-20],   style(color=70, rgbcolor={0,130,175})),
     Text(
    extent=[-100,-90; 100,-130],
    string="%name",
    style(color=0)),
Text(extent=[10,20; 70,-10],  string="~",
          style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2)),
Line(points=[24,0; 56,0],     style(color=70, rgbcolor={0,130,175})),
Text(extent=[10,0; 70,-30],  string="~",
          style(
            color=70,
            rgbcolor={0,130,175},
            thickness=2)),
Text(extent=[10,-20; 70,-50],string="~",
          style(color=70, rgbcolor={0,130,175})),
      Text(
   extent=[-80,40; 0,0],   string="=")),
    Diagram,
      Documentation(info=""));

end Inverter_abc;

partial model Inverter_dqo "Inverter icon"

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
    Icon(
      Rectangle(
        extent=[-80,60; 80,-60], style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2,
            fillColor=7,
            rgbfillColor={255,255,255})),
      Line(
   points=[-80,-60; 80,60], style(color=62, rgbcolor={0,120,120})),
Text(extent=[10,20; 70,-10],  string="~",
          style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2)),
Text(extent=[10,0; 70,-30],  string="~",
          style(
            color=62,
            rgbcolor={0,120,120},
            thickness=2)),
Line(points=[24,0; 56,0],     style(color=62, rgbcolor={0,120,120})),
Line(points=[24,-20; 56,-20], style(color=62, rgbcolor={0,120,120})),
Line(points=[24,-40; 56,-40],   style(color=62, rgbcolor={0,120,120})),
     Text(
    extent=[-100,-90; 100,-130],
    string="%name",
    style(color=0)),
      Text(
   extent=[-80,40; 0,0],   string="=")),
    Diagram,
      Documentation(info=""));

end Inverter_dqo;

partial record Record "Record icon"

  annotation (Icon(
Rectangle(extent=[-80,80; 80,-40], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=51,
            rgbfillColor={255,255,170})),
Line(points=[-80,40; 80,40], style(color=10, rgbcolor={95,95,95})),
Line(points=[0,80; 0,-40], style(color=10, rgbcolor={95,95,95})),
Text(
  extent=[-100,-80; 100,-120],
  string="%name",
  style(color=0)),
Line(points=[-80,0; 80,0],     style(color=10, rgbcolor={95,95,95}))),
        Documentation(info=""));
end Record;

partial function Function "Function icon"

  annotation (
    Coordsys(
extent=[-100, -100; 100, 100],
grid=[2, 2],
component=[20, 20]),
    Icon(
      Ellipse(extent=[-100,60; 100,-60], style(
            color=43,
            rgbcolor={255,85,85},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Text(
        extent=[-100,30; 100,-50],
          style(color=43, rgbcolor={255,85,85}),
          string="f"),
      Text(extent=[-100,120; 100,80],   string="%name",
          style(color=0, rgbcolor={0,0,0}))),
    Documentation(
            info="
"), Window(
x=0.45,
y=0.01,
width=0.44,
height=0.65),
    Diagram);
end Function;

partial class Enumeration "Enumeration icon"

  annotation (Icon(
      Text(extent=[-100,120; 100,80],   string="%name",
          style(color=0, rgbcolor={0,0,0})),
      Ellipse(extent=[-100,60; 100,-60], style(
            color=75,
            rgbcolor={85,85,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
      Text(
        extent=[-100,40; 100,-40],
          style(
            color=75,
            rgbcolor={85,85,255},
            fillColor=88,
            rgbfillColor={223,159,191}),
          string="e")), Documentation(info=""));
end Enumeration;

  partial class Library "Package icon 'Library'"

    annotation (Coordsys(
        extent=[-100, -100; 100, 100],
        grid=[2,2],
        component=[20,20]),  Icon(
        Rectangle(extent=[-100, -100; 80, 50], style(fillColor=30,
              fillPattern=
                1)),
        Polygon(points=[-100, 50; -80, 70; 100, 70; 80, 50; -100, 50], style(
              fillColor=30, fillPattern=1)),
        Polygon(points=[100, 70; 100, -80; 80, -100; 80, 50; 100, 70], style(
              fillColor=30, fillPattern=1)),
        Text(
          extent=[-120,125; 120,70],
          string="%name",
          style(color=1)),
    Text(
      extent=[-80,40; 70,-80],
          string="Library",
          style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=51,
            rgbfillColor={255,255,170}))),
      Documentation(info=""),
      Diagram);
  end Library;

  partial class SpecialLibrary "Package icon 'Special Library'"

    annotation (
  Coordsys(
    extent=[-100, -100; 100, 100],
    grid=[2, 2],
    component=[20, 20]),
  Icon(
    Rectangle(extent=[-100, -100; 80, 50], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=30,
            rgbfillColor={212,231,211})),
    Polygon(points=[-100, 50; -80, 70; 100, 70; 80, 50; -100, 50], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=30,
            rgbfillColor={212,231,211})),
    Polygon(points=[100, 70; 100, -80; 80, -100; 80, 50; 100, 70], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=30,
            rgbfillColor={212,231,211})),
    Text(
      extent=[-80,40; 70,-80],
          string="Library",
          style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=51,
            rgbfillColor={255,255,170})),
        Text(
          extent=[-120,125; 120,70],
          string="%name",
          style(color=1))),
  Window(
    x=0.05,
    y=0.44,
    width=0.29,
    height=0.24,
    library=1,
    autolayout=1),
  Documentation(info=""),
      Diagram);
  end SpecialLibrary;

  partial class Base "Package icon 'Base'"

    annotation (
  Coordsys(
    extent=[-100, -100; 100, 100],
    grid=[2, 2],
    component=[20, 20]),
  Icon(
    Rectangle(extent=[-100, -100; 80, 50], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=30,
            rgbfillColor={253,255,202})),
    Polygon(points=[-100, 50; -80, 70; 100, 70; 80, 50; -100, 50], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=30,
            rgbfillColor={253,255,202})),
    Polygon(points=[100, 70; 100, -80; 80, -100; 80, 50; 100, 70], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=30,
            rgbfillColor={253,255,202})),
    Text(
      extent=[-80,40; 70,-80],
          style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=51,
            rgbfillColor={255,255,170}),
          string="Base")),
  Window(
    x=0.05,
    y=0.44,
    width=0.29,
    height=0.24,
    library=1,
    autolayout=1),
  Documentation(info=""),
      Diagram);
  end Base;

  partial class Partials "Package icon 'Partials'"

    annotation (
  Coordsys(
    extent=[-100, -100; 100, 100],
    grid=[2, 2],
    component=[20, 20]),
  Icon(
    Rectangle(extent=[-100,-100; 80,50], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=30,
            rgbfillColor={236,236,236})),
    Polygon(points=[-100,50; -80,70; 100,70; 80,50; -100,50], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=30,
            rgbfillColor={236,236,236})),
    Polygon(points=[100,70; 100,-80; 80,-100; 80,50; 100,70], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=30,
            rgbfillColor={236,236,236})),
    Text(
      extent=[-80,40; 70,-80],
          style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=51,
            rgbfillColor={255,255,170}),
          string="Partials")),
  Window(
    x=0.05,
    y=0.44,
    width=0.29,
    height=0.24,
    library=1,
    autolayout=1),
  Documentation(info=""),
      Diagram);
  end Partials;

  partial class Examples "Package icon 'Examples'"

    annotation (
  Coordsys(
    extent=[-100, -100; 100, 100],
    grid=[2, 2],
    component=[20, 20]),
  Icon(
    Rectangle(extent=[-100,-100; 80,50], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=44,
            rgbfillColor={255,170,170})),
    Polygon(points=[-100,50; -80,70; 100,70; 80,50; -100,50], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=44,
            rgbfillColor={255,170,170})),
    Polygon(points=[100,70; 100,-80; 80,-100; 80,50; 100,70], style(
            color=10,
            rgbcolor={95,95,95},
            fillColor=44,
            rgbfillColor={255,170,170})),
    Text(
      extent=[-85,41; 65,-79],
          style(color=10, rgbcolor={95,95,95}),
          string="Examples")),
  Window(
    x=0.05,
    y=0.44,
    width=0.29,
    height=0.24,
    library=1,
    autolayout=1),
  Documentation(info=""),
      Diagram);
  end Examples;
end Icons;
