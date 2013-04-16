within Spot.Semiconductors;
package Partials "Partial models"
  extends Base.Icons.Partials;

  annotation (
        Coordsys(
extent=[-100, -100; 100, 100],
grid=[2, 2],
component=[20, 20]), Window(
x=0.05,
y=0.44,
width=0.31,
height=0.25,
library=1,
autolayout=1));

  partial model ComponentBase "Semiconductor component base"

    SI.Voltage v "voltage";
    SI.Current i "current";
    Base.Interfaces.Electric_p term_p "positive terminal"
  annotation (extent=[-110,-10; -90,10]);
    Base.Interfaces.Electric_n term_n "negative terminal"
  annotation (extent=[90,-10; 110,10]);
    Base.Interfaces.Thermal_n heat "source dissipated heat power"
      annotation (extent=[-10,90; 10,110], rotation=90);
  protected
    SI.Temperature T "component temperature";
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
</html>
"),   Diagram,
      Icon(
        Text(
  extent=[-100,-90; 100,-130],
  string="%name",
  style(color=0))));

  equation
    term_p.i + term_n.i = 0;
    v = term_p.v - term_n.v;
    i = term_p.i;

    T = heat.T;
    heat.Q_flow = -v*i;
  end ComponentBase;

  partial model AC1_DC_base "AC(scalar)-DC base"
    extends Base.Icons.Inverter;

    Base.Interfaces.Electric_n AC "AC scalar connection"
      annotation (
            extent=[90,-10; 110,10]);
    Base.Interfaces.ElectricV_p DC(final m=2) "DC connection"
      annotation (
            extent=[-110,-10; -90,10]);
    Base.Interfaces.Thermal_n heat annotation (extent=[-10,90; 10,110], rotation=
          90);
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
</html>
"),   Diagram,
      Icon(
        Text(
          extent=[-120,50; -80,10],
            style(color=3, rgbcolor={0,0,255}),
          string="="),
        Text(
          extent=[80,50; 120,10],
            style(color=3, rgbcolor={0,0,255}),
          string="~")));

  end AC1_DC_base;

end Partials;
