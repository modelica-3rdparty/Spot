package Custom "Custom models"
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
<p>Intended for custom semiconductor models, replacing ideal components.<br>
</html>
"),
  Icon);

record SCparameter "Custom semiconductor parameters"
  extends Base.Units.NominalDataVI;

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
</html>"),
    Diagram,
    Icon);
end SCparameter;

model Diode "Diode"
  extends Partials.ComponentBase;

  parameter SCparameter par "parameters" annotation (extent=[-80,-80; -60,-60]);

  annotation (defaultComponentName = "diode1",
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
</html>
"), Icon(
Polygon(points=[40,0; -40,40; -40,-40; 40,0],     style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
Line(points=[-90,0; -40,0],   style(color=3, rgbcolor={0,0,255})),
Line(points=[40,0; 90,0], style(color=3, rgbcolor={0,0,255})),
Line(points=[40,40; 40,-40],   style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
          Line(points=[-100,-100; 100,100], style(color=1, rgbcolor={255,0,0}))),
    Diagram);

equation
  i = v; // replace!
end Diode;

model SCswitch "IGBT"
  extends Partials.ComponentBase;

  parameter SCparameter par "parameters" annotation (extent=[-80,-80; -60,-60]);
  Modelica.Blocks.Interfaces.BooleanInput gate "true:on, false: off"
    annotation (
          extent=[50,90; 70,110],   rotation=-90);

  annotation (defaultComponentName = "IGBT1",
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
</html>"),
    Icon(
Polygon(points=[80,0; 30,40; 16,10; 80,0],        style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
Line(points=[0,40; 24,26],  style(color=3, rgbcolor={0,0,255})),
Line(points=[90,0; 80,0],      style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
Line(points=[60,60; 60,90],   style(color=5, rgbcolor={255,0,255})),
        Line(points=[-70,40; 70,40], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[-70,60; 70,60], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
        Line(points=[-90,0; -80,0; -20,40], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255},
            fillPattern=1)),
          Line(points=[-100,-100; 100,100], style(color=1, rgbcolor={255,0,0}))),
      Diagram);

equation
  i = v; // replace!
end SCswitch;

model Thyristor "Thyristor"
  extends Partials.ComponentBase;

  parameter SCparameter par "parameters" annotation (extent=[-80,-80; -60,-60]);
  Modelica.Blocks.Interfaces.BooleanInput gate "true:on, false: off"
    annotation (
          extent=[50,90; 70,110],   rotation=-90);
  annotation (defaultComponentName = "thyristor1",
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
</html>
"), Icon(
Polygon(points=[20, 0; -60, 40; -60, -40; 20, 0], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
Line(points=[-90, 0; -60, 0], style(color=3, rgbcolor={0,0,255})),
Line(points=[20, 0; 90, 0], style(color=3, rgbcolor={0,0,255})),
Line(points=[20, 40; 20, -40], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=3,
            rgbfillColor={0,0,255})),
        Line(points=[20,0; 60,40; 60,90], style(
              color=5,
              rgbcolor={255,0,255},
              pattern=3)),
          Line(points=[-100,-100; 100,100], style(color=1, rgbcolor={255,0,0}))),
      Diagram);

equation
  i = v; // replace!
end Thyristor;

end Custom;
