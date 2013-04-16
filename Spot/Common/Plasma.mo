within Spot.Common;
package Plasma "Plasma arcs"
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
<p>Properties of plasma arcs for breakers and faults.</p>
</html>
"), Icon);

  model ArcBreaker "Arc voltage for breakers"
    extends Partials.ArcBase;

    parameter SI.ElectricFieldStrength E "av electric field arc";
    parameter Real r(unit="1/A") "= R0/(d*Earc), R0 small signal resistance";
    SI.Distance d "contact distance";
    annotation (structurallyIncomplete, defaultComponentName = "arcBreaker1",
    Documentation(info="<html>
<p>
<b>Structurally incomplete model</b>. Use only as component within Breaker kernel.<br><br>
The 'arc voltage vs current' characteristic is a hyperbolic tangent.
</p>
</html>
"),   Icon(
        Line(
     points=[-100,0; -76,-4; -58,2; -44,10; -34,6; -22,-2; -16,-4; -8,-4; -2,0;
              -2,0; 2,4; 10,6; 10,6; 16,2; 22,6; 30,4; 40,-2; 56,2; 76,-4; 100,
              0],                    style(color=6, thickness=4))),
      Diagram);

  equation
    v = d*E*tanh(r*i);
  end ArcBreaker;

  model ArcFault "Arc voltage for faults"
    extends Partials.ArcBase;

    parameter SI.Voltage V "arc voltage";
    parameter Real r(unit="1/A") "= R0/V, R0 small signal resistance";
    annotation (structurallyIncomplete, defaultComponentName = "arcFault1",
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
<p>
<b>Structurally incomplete model</b>. Use only as component within complete Fault model.<br><br>
The 'arc voltage vs current' characteristic is a hyperbolic tangent.
</p>
</html>
"),   Icon(
        Rectangle(extent=[-100,60; 100,-60], style(
            color=7,
            rgbcolor={255,255,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Line(
     points=[-100,60; 100,60],
                            style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2)),
        Line(
     points=[-100,20; 100,20],
                          style(
            color=3,
            rgbcolor={0,0,255},
            thickness=2)),
        Line(points=[-100,-60; 100,-60], style(
            color=46,
            rgbcolor={127,127,0},
            thickness=2)),
        Line(points=[-44,60; -42,56; -48,52; -50,46; -46,42; -48,36; -46,28;
              -48,20], style(
            color=6,
            rgbcolor={255,255,0},
            thickness=2)),
        Line(points=[16,20; 26,10; 26,-2; 38,-10; 36,-30; 48,-38; 50,-60],
            style(
            color=6,
            rgbcolor={255,255,0},
            thickness=2))));

  equation
    v = V*tanh(r*i);
  end ArcFault;

  package Partials "Partial models"
    extends Base.Icons.Partials;

    annotation (
      Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
      Icon,
      Window(
  x=0.05,
  y=0.44,
  width=0.31,
  height=0.26,
  library=1,
  autolayout=1),
      Documentation(
              info="<html>
</html>
"));

    partial model ArcBase "Arc voltage base"

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
        Icon(
         Text(
        extent=[-100,-100; 100,-140],
        string="%name",
        style(color=0))),
        Window(
          x=
    0.55, y=
    0.01, width=
        0.44,
          height=
         0.65),
        Documentation(
              info="<html>
</html>
"),     Diagram);
    end ArcBase;
  end Partials;

end Plasma;
