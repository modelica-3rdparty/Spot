within ;
package SpotExamples "Spot examples"
  extends Spot.Base.Icons.Examples;
  import SI = Modelica.SIunits;
  import SIpu = Spot.Base.Types;
  import Modelica.Constants.pi;
  import Spot.Base.Types.d2r;
  import Spot.Base.TableDir;


annotation (preferredView="info",
Documentation(info="<html>
<h3><font color=\"#000080\" size=5>Modelica Power Systems Library SPOT: Examples</font></h3>
<p><a href=\"Spot.UsersGuide.Overview\">up users guide</a></p>
<p>Copyright &copy; 2004-2007, H.J. Wiesmann.</p>
<p><i>The Modelica package is <b>free</b> software; it can be redistributed and/or modified under the terms of the <b>Modelica license</b>, see the license conditions and the accompanying <b>disclaimer</b>
<a href=\"Modelica://Modelica.UsersGuide.ModelicaLicense\">here</a>.</i></p>
</html>"),
  uses(Modelica(version="3.2.1"), Spot(version="0.706.1")),
  version="0.706.1");
end SpotExamples;
