within;
package SpotExamples "Spot examples"
  extends Spot.Base.Icons.Examples;
  import SI = Modelica.SIunits;
  import SIpu = Spot.Base.Types;
  import Modelica.Constants.pi;
  import Spot.Base.Types.d2r;
  import Spot.Base.TableDir;

annotation (preferedView="info",
Coordsys(
  extent=[-100, -100; 100, 100],
  grid=[2, 2],
  component=[20, 20]),
Window(
  x=0.05,
  y=0.03,
  width=0.4,
  height=0.38,
  library=1,
  autolayout=1),
Documentation(info="<html>
<h3><font color=\"#000080\" size=5>Modelica Power Systems Library SPOT: Examples</font></h3>
<p><a href=\"Spot.UsersGuide.Overview\">up users guide</a></p>
<p>Copyright &copy; 2004-2007, H.J. Wiesmann.</p>
<p><i>The Modelica package is <b>free</b> software; it can be redistributed and/or modified under the terms of the <b>Modelica license</b>, see the license conditions and the accompanying <b>disclaimer</b>
<a href=\"Modelica://Modelica.UsersGuide.ModelicaLicense\">here</a>.</i></p>
</html>"),
  uses(Modelica(version="2.2.1"), Spot(version="0.705")));
end SpotExamples;
